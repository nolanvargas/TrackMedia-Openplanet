namespace CollectionsApiService {
    void RequestCollections() {
        RequestCollectionsWithParams("", 20);
    }

    void RequestCollectionsWithParams(const string &in start = "", int limit = 20) {
        if (limit <= 0) limit = 20;
        
        State::isRequestingCollections = true;
        State::collectionsRequestStatus = "Requesting...";
        
        string effectiveStart = start.Length > 0 ? start : API::GenerateUUIDv4();
        string url = "https://api.trackmedia.io/collections?start=" + effectiveStart + "&limit=" + limit;
        
        try {
            auto req = API::Get(url);
            if (req is null) {
                State::collectionsRequestStatus = "Error";
                State::isRequestingCollections = false;
                return;
            }
            
            while (!req.Finished()) {
                yield();
            }
            
            int responseCode = req.ResponseCode();
            if (responseCode != 200) {
                State::collectionsRequestStatus = "Failed (HTTP " + responseCode + ")";
                Logging::Error("Collections API request failed with code: " + responseCode);
                State::isRequestingCollections = false;
                return;
            }
            
            try {
                auto json = req.Json();
                if (json.GetType() != Json::Type::Array) {
                    State::collectionsRequestStatus = "Failed (Invalid JSON)";
                    Logging::Error("Collections API: Expected JSON Array, got type: " + json.GetType());
                    State::isRequestingCollections = false;
                    return;
                }
                
                State::collectionsRequestStatus = "Success";
                State::collections.RemoveRange(0, State::collections.Length);
                
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
                State::collectionsRequestStatus = "Error";
                Logging::Error("Failed to parse collections JSON: " + getExceptionInfo());
            }
        } catch {
            State::collectionsRequestStatus = "Error";
            Logging::Error("Exception in RequestCollections: " + getExceptionInfo());
        }
        
        State::isRequestingCollections = false;
    }

    void RequestCollectionById(const string &in collectionId) {
        if (collectionId.Length == 0) {
            Logging::Warn("RequestCollectionById called with empty ID");
            return;
        }
        
        string url = "https://api.trackmedia.io/collections/id/" + collectionId;
        
        try {
            auto req = API::Get(url);
            if (req is null) {
                Logging::Error("Failed to create request for collection: " + collectionId);
                return;
            }
            
            while (!req.Finished()) {
                yield();
            }
            
            if (req.ResponseCode() != 200) {
                Logging::Error("Collection by ID request failed: " + collectionId + " (code: " + req.ResponseCode() + ")");
                return;
            }
            
            try {
                auto json = req.Json();
                Collection@ foundCollection = FindCollectionInState(collectionId);
                
                if (foundCollection !is null) {
                    foundCollection.UpdateWithFullData(json);
                } else {
                    Logging::Warn("Collection not found in state for ID: " + collectionId);
                }
            } catch {
                Logging::Error("Failed to parse collection JSON: " + getExceptionInfo());
            }
        } catch {
            Logging::Error("Exception in RequestCollectionById: " + getExceptionInfo());
        }
    }
    
    Collection@ FindCollectionInState(const string &in collectionId) {
        for (uint i = 0; i < State::collections.Length; i++) {
            if (State::collections[i].collectionId == collectionId) {
                return State::collections[i];
            }
        }
        
        for (uint i = 0; i < State::collectionsTabs.Length; i++) {
            CollectionTab@ tab = cast<CollectionTab>(State::collectionsTabs[i]);
            if (tab !is null && tab.GetTabId() == collectionId) {
                return tab.GetCollection();
            }
        }
        
        return null;
    }

    void DebugRequestCollections() {
        Logging::Debug("DebugRequestCollections: Starting");
        State::isRequestingCollections = true;
        State::collectionsRequestStatus = "Requesting...";
        
        string effectiveStart = API::GenerateUUIDv4();
        string url = "https://api.trackmedia.io/collections?start=" + effectiveStart + "&limit=20";
        Logging::Debug("URL: " + url);
        
        try {
            auto req = API::Get(url);
            if (req is null) {
                State::collectionsRequestStatus = "Error";
                State::isRequestingCollections = false;
                return;
            }
            
            while (!req.Finished()) {
                yield();
            }
            
            int responseCode = req.ResponseCode();
            string responseBody = req.String();
            
            Logging::Debug("Response Code: " + responseCode);
            Logging::Debug("Response Body Length: " + responseBody.Length);
            
            if (responseCode == 200) {
                try {
                    auto json = req.Json();
                    if (json.GetType() == Json::Type::Array) {
                        State::collectionsRequestStatus = "Success";
                        Logging::Debug("Parsed " + json.Length + " collections");
                        
                        State::collections.RemoveRange(0, State::collections.Length);
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
                    } else {
                        State::collectionsRequestStatus = "Failed (Invalid JSON)";
                        Logging::Error("Invalid JSON type: " + json.GetType());
                    }
                } catch {
                    State::collectionsRequestStatus = "Error";
                    Logging::Error("JSON parse exception: " + getExceptionInfo());
                }
            } else {
                State::collectionsRequestStatus = "Failed (HTTP " + responseCode + ")";
                Logging::Error("HTTP error: " + responseCode);
            }
        } catch {
            State::collectionsRequestStatus = "Error";
            Logging::Error("Request exception: " + getExceptionInfo());
        }
        
        State::isRequestingCollections = false;
        Logging::Debug("DebugRequestCollections: Complete");
    }

    void DebugRequestCollectionById(const string &in collectionId) {
        if (collectionId.Length == 0) {
            Logging::Warn("DebugRequestCollectionById called with empty ID");
            return;
        }
        
        Logging::Debug("DebugRequestCollectionById: " + collectionId);
        string url = "https://api.trackmedia.io/collections/id/" + collectionId;
        
        try {
            auto req = API::Get(url);
            if (req is null) {
                Logging::Error("Failed to create request");
                return;
            }
            
            while (!req.Finished()) {
                yield();
            }
            
            int responseCode = req.ResponseCode();
            string responseBody = req.String();
            
            Logging::Debug("Response Code: " + responseCode);
            Logging::Debug("Response Body Length: " + responseBody.Length);
            
            if (responseCode == 200) {
                try {
                    auto json = req.Json();
                    Collection@ foundCollection = FindCollectionInState(collectionId);
                    
                    if (foundCollection !is null) {
                        foundCollection.UpdateWithFullData(json);
                        Logging::Debug("Updated collection in state");
                    } else {
                        Logging::Warn("Collection not found in state: " + collectionId);
                    }
                } catch {
                    Logging::Error("JSON parse exception: " + getExceptionInfo());
                }
            } else {
                Logging::Error("HTTP error: " + responseCode);
            }
        } catch {
            Logging::Error("Request exception: " + getExceptionInfo());
        }
    }
}
