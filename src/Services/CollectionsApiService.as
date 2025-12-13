namespace CollectionsApiService {
    void RequestCollections() {
        RequestCollectionsWithParams("", 20);
    }

    void RequestCollectionsWithParams(const string &in start = "", int limit = 20) {
        if (limit <= 0) limit = 20;
        
        State::ResetCollectionsRequest();
        
        // API takes a uuidv4 as the start parameter for an arbitrary set
        string effectiveStart = start.Length > 0 ? start : API::GenerateUUIDv4();
        string url = "https://api.trackmedia.io/collections?start=" + effectiveStart + "&limit=" + limit;
        
        try {
            auto json = API::GetAsync(url);
            try {
                State::SetCollectionsSuccess();
                State::ClearCollections();
                
                for (uint i = 0; i < json.Length; i++) {
                    try {
                        Collection@ collection = Collection(json[i]);
                        State::collections.InsertLast(collection);
                        startnew(ThumbnailService::RequestThumbnailForCollection, collection);
                    } catch {
                        Logging::Error("Failed to parse collection " + i + ": " + getExceptionInfo());
                    }
                }
                
                State::hasRequestedCollections = true;
            } catch {
                State::SetCollectionsError("Error");
                Logging::Error("Failed to parse collections JSON: " + getExceptionInfo());
            }
        } catch {
            State::SetCollectionsError("Error");
            Logging::Error("Exception in RequestCollections: " + getExceptionInfo());
        }
        
        State::isRequestingCollections = false;
    }

    void RequestCollectionById(const string &in collectionId) {
        if (collectionId.Length == 0) { throw("RequestCollectionById called with empty ID"); }
        
        Collection@ foundCollection = FindCollectionInState(collectionId);
        if (foundCollection is null) {
            Logging::Warn("Collection not found in state for ID: " + collectionId);
            return;
        }
        
        RequestCollectionById(collectionId, foundCollection);
    }
    
    void RequestCollectionById(const string &in collectionId, Collection@ collection) {
        if (collectionId.Length == 0 || collection is null) {
            Logging::Warn("RequestCollectionById called with empty ID or null collection");
            return;
        }
        
        string url = "https://api.trackmedia.io/collections/id/" + collectionId;
        
        try {
            auto json = API::GetAsync(url);
            try {
                collection.UpdateWithFullData(json);
            } catch {
                Logging::Error("Failed to parse collection JSON: " + getExceptionInfo());
            }
        } catch {
            Logging::Error("Exception in RequestCollectionById: " + getExceptionInfo());
        }
    }
    
    // Wrapper for startnew that takes a Collection@ via ref
    void RequestCollectionByIdWithRef(ref@ data) {
        Collection@ collection = cast<Collection>(data);
        if (collection is null || collection.collectionId.Length == 0) {
            Logging::Warn("RequestCollectionByIdWithRef called with null collection or empty ID");
            return;
        }
        RequestCollectionById(collection.collectionId, collection);
    }
    
    Collection@ FindCollectionInState(const string &in collectionId) {
        for (uint i = 0; i < State::collections.Length; i++) {
            if (State::collections[i].collectionId == collectionId) {
                return State::collections[i];
            }
        }
        
        // Not a fan of this
        for (uint i = 0; i < State::collectionsTabs.Length; i++) {
            CollectionTab@ tab = cast<CollectionTab>(State::collectionsTabs[i]);
            if (tab !is null && tab.GetTabId() == collectionId) {
                return tab.GetCollection();
            }
        }
        return null;
    }
}
