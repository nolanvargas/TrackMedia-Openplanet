namespace CollectionsApiService {
    void RequestCollections() {
        RequestCollectionsWithParams("", 20);
    }

    void RequestCollectionsWithParams(const string &in start = "", int limit = 20) {        
        State::ResetCollectionsRequest();
        
        string effectiveStart = start.Length > 0 ? start : API::GenerateUUIDv4();
        string url = "https://api.trackmedia.io/collections?start=" + effectiveStart + "&limit=" + limit;
        
        try {
            auto json = API::GetAsync(url);
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
            Logging::Error("Exception in RequestCollections: " + getExceptionInfo());
        }
        
        State::isRequestingCollections = false;
    }
    
    void RequestCollectionById(Collection@ collection) {
        string url = "https://api.trackmedia.io/collections/id/" + collection.collectionId;
        try {
            auto json = API::GetAsync(url);
            collection.UpdateWithFullData(json);
        } catch {
            Logging::Error("Exception in RequestCollectionById: " + getExceptionInfo());
        }
    }
    
    void RequestCollectionByIdWithRef(ref@ data) {
        Collection@ collection = cast<Collection>(data);
        RequestCollectionById(collection);
    }
}
