namespace ApiService {
    void RequestThumbs() {
        State::isRequestingThumbs = true;
        State::thumbsRequestStatus = "Requesting...";
        State::thumbsResponse = "";
        State::thumbsStatusCode = 0;
        
        try {
            auto json = API::GetAsync("https://api.trackmedia.io/media/latest");
            Json::Value itemsArray;
            
            // Handle both array response and object with "items" property
            if (json.GetType() == Json::Type::Array) {
                itemsArray = json;
            } else if (json.GetType() == Json::Type::Object && json.HasKey("items")) {
                itemsArray = json["items"];
            } else {
                State::thumbsRequestStatus = "Failed (Invalid JSON)";
                State::thumbsResponse = "Expected JSON Array or Object with 'items' property";
                State::hasRequestedThumbs = true;
                State::isRequestingThumbs = false;
                return;
            }
            
            if (itemsArray.GetType() != Json::Type::Array) {
                State::thumbsRequestStatus = "Failed (Invalid JSON)";
                State::thumbsResponse = "Expected JSON Array";
                State::hasRequestedThumbs = true;
                State::isRequestingThumbs = false;
                return;
            }
            
            State::thumbsRequestStatus = "Success";
            State::thumbsStatusCode = 200;
            State::mediaItems.RemoveRange(0, State::mediaItems.Length);
            
            for (uint i = 0; i < itemsArray.Length; i++) {
                try {
                    MediaItem@ item = MediaItem(itemsArray[i]);
                    State::mediaItems.InsertLast(item);
                    startnew(ThumbnailService::RequestThumbnailForMediaItem, item);
                } catch {
                    Logging::Error("Failed to parse media item " + i + ": " + getExceptionInfo());
                }
            }
            
            State::hasRequestedThumbs = true;
        } catch {
            State::thumbsRequestStatus = "Error";
            State::thumbsResponse = "Exception: " + getExceptionInfo();
            Logging::Error("RequestThumbs exception: " + getExceptionInfo());
            State::hasRequestedThumbs = true;
        }
        
        State::isRequestingThumbs = false;
    }

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
        
        for (uint i = 0; i < State::openTabs.Length; i++) {
            CollectionTab@ tab = cast<CollectionTab>(State::openTabs[i]);
            if (tab !is null && tab.GetCollectionId() == collectionId) {
                return tab.GetCollection();
            }
        }
        
        return null;
    }

    void RequestThemePacks() {
        RequestThemePacksWithParams("", 20);
    }

    void RequestThemePacksWithParams(const string &in start = "", int limit = 20) {
        if (limit <= 0) limit = 20;
        
        State::isRequestingThemePacks = true;
        State::themePacksRequestStatus = "Requesting...";
        
        string startParam = start.Length > 0 ? start : API::GenerateUUIDv4();
        string url = "https://api.trackmedia.io/theme-packs?start=" + startParam + "&limit=" + limit;
        
        try {
            auto req = API::Get(url);
            if (req is null) {
                State::themePacksRequestStatus = "Error";
                State::isRequestingThemePacks = false;
                return;
            }
            
            while (!req.Finished()) {
                yield();
            }
            
            int responseCode = req.ResponseCode();
            if (responseCode != 200) {
                State::themePacksRequestStatus = "Failed (HTTP " + responseCode + ")";
                Logging::Error("Theme packs API request failed with code: " + responseCode);
                State::isRequestingThemePacks = false;
                return;
            }
            
            try {
                auto json = req.Json();
                if (json.GetType() != Json::Type::Array) {
                    State::themePacksRequestStatus = "Failed (Invalid JSON)";
                    Logging::Error("Theme packs API: Expected JSON Array, got type: " + json.GetType());
                    State::isRequestingThemePacks = false;
                    return;
                }
                
                State::themePacksRequestStatus = "Success";
                State::themePacks.RemoveRange(0, State::themePacks.Length);
                
                for (uint i = 0; i < json.Length; i++) {
                    try {
                        ThemePack@ themePack = ThemePack(json[i]);
                        State::themePacks.InsertLast(themePack);
                        
                        if (themePack.coverId.Length > 0) {
                            startnew(ThumbnailService::RequestThumbnailForThemePack, themePack);
                        }
                    } catch {
                        Logging::Error("Failed to parse theme pack " + i + ": " + getExceptionInfo());
                    }
                }
                
                State::hasRequestedThemePacks = true;
            } catch {
                State::themePacksRequestStatus = "Error";
                Logging::Error("Failed to parse theme packs JSON: " + getExceptionInfo());
            }
        } catch {
            State::themePacksRequestStatus = "Error";
            Logging::Error("Exception in RequestThemePacks: " + getExceptionInfo());
        }
        
        State::isRequestingThemePacks = false;
    }

    void RequestThemePackById(const string &in themePackId) {
        if (themePackId.Length == 0) {
            Logging::Warn("RequestThemePackById called with empty ID");
            return;
        }
        
        string url = "https://api.trackmedia.io/theme-packs/id/" + themePackId;
        
        try {
            auto req = API::Get(url);
            if (req is null) {
                Logging::Error("Failed to create request for theme pack: " + themePackId);
                return;
            }
            
            while (!req.Finished()) {
                yield();
            }
            
            if (req.ResponseCode() != 200) {
                Logging::Error("Theme pack by ID request failed: " + themePackId + " (code: " + req.ResponseCode() + ")");
                return;
            }
            
            try {
                auto json = req.Json();
                ThemePack@ foundThemePack = FindThemePackInState(themePackId);
                
                if (foundThemePack !is null) {
                    foundThemePack.UpdateWithFullData(json);
                } else {
                    Logging::Warn("Theme pack not found in state for ID: " + themePackId);
                }
            } catch {
                Logging::Error("Failed to parse theme pack JSON: " + getExceptionInfo());
            }
        } catch {
            Logging::Error("Exception in RequestThemePackById: " + getExceptionInfo());
        }
    }
    
    ThemePack@ FindThemePackInState(const string &in themePackId) {
        for (uint i = 0; i < State::themePacks.Length; i++) {
            if (State::themePacks[i].themePackId == themePackId) {
                return State::themePacks[i];
            }
        }
        
        for (uint i = 0; i < State::openTabs.Length; i++) {
            ThemePackTab@ tab = cast<ThemePackTab>(State::openTabs[i]);
            if (tab !is null && tab.GetThemePackId() == themePackId) {
                return tab.GetThemePack();
            }
        }
        
        return null;
    }

    // Debug functions with verbose logging
    void DebugRequestThumbs() {
        Logging::Debug("DebugRequestThumbs: Starting");
        State::isRequestingThumbs = true;
        State::thumbsRequestStatus = "Requesting...";
        State::thumbsResponse = "";
        State::thumbsStatusCode = 0;
        
        try {
            auto req = API::Get("https://api.trackmedia.io/media/latest");
            if (req is null) {
                State::thumbsRequestStatus = "Error";
                State::isRequestingThumbs = false;
                return;
            }
            
            while (!req.Finished()) {
                yield();
            }
            
            int responseCode = req.ResponseCode();
            State::thumbsStatusCode = responseCode;
            string responseBody = req.String();
            
            Logging::Debug("Response Code: " + responseCode);
            Logging::Debug("Response Body Length: " + responseBody.Length);
            
            if (responseCode == 200) {
                try {
                    auto json = req.Json();
                    Json::Value itemsArray;
                    
                    if (json.GetType() == Json::Type::Array) {
                        itemsArray = json;
                        Logging::Debug("Response is direct array");
                    } else if (json.GetType() == Json::Type::Object && json.HasKey("items")) {
                        itemsArray = json["items"];
                        Logging::Debug("Response is object with 'items' property");
                    } else {
                        State::thumbsRequestStatus = "Failed (Invalid JSON)";
                        State::thumbsResponse = "Expected JSON Array or Object with 'items' property, got type: " + json.GetType();
                        Logging::Error("Invalid JSON type: " + json.GetType());
                        State::isRequestingThumbs = false;
                        return;
                    }
                    
                    if (itemsArray.GetType() == Json::Type::Array) {
                        State::thumbsRequestStatus = "Success";
                        State::thumbsResponse = "Array with " + itemsArray.Length + " items";
                        Logging::Debug("Parsed " + itemsArray.Length + " items");
                        
                        State::mediaItems.RemoveRange(0, State::mediaItems.Length);
                        for (uint i = 0; i < itemsArray.Length; i++) {
                            try {
                                MediaItem@ item = MediaItem(itemsArray[i]);
                                State::mediaItems.InsertLast(item);
                                startnew(ThumbnailService::RequestThumbnailForMediaItem, item);
                            } catch {
                                Logging::Error("Failed to parse item " + i + ": " + getExceptionInfo());
                            }
                        }
                        State::hasRequestedThumbs = true;
                    } else {
                        State::thumbsRequestStatus = "Failed (Invalid JSON)";
                        State::thumbsResponse = "Expected JSON Array in items, got type: " + itemsArray.GetType();
                        Logging::Error("Invalid items array type: " + itemsArray.GetType());
                    }
                } catch {
                    State::thumbsRequestStatus = "Error";
                    State::thumbsResponse = "Exception parsing JSON: " + getExceptionInfo();
                    Logging::Error("JSON parse exception: " + getExceptionInfo());
                }
            } else {
                State::thumbsRequestStatus = "Failed (HTTP " + responseCode + ")";
                State::thumbsResponse = responseBody.Length > 200 ? responseBody.SubStr(0, 200) + "..." : responseBody;
                Logging::Error("HTTP error: " + responseCode);
            }
        } catch {
            State::thumbsRequestStatus = "Error";
            State::thumbsResponse = "Exception: " + getExceptionInfo();
            Logging::Error("Request exception: " + getExceptionInfo());
        }
        
        State::isRequestingThumbs = false;
        Logging::Debug("DebugRequestThumbs: Complete");
    }

    void DebugRequestThemePacks() {
        Logging::Debug("DebugRequestThemePacks: Starting");
        State::isRequestingThemePacks = true;
        State::themePacksRequestStatus = "Requesting...";
        
        string startParam = API::GenerateUUIDv4();
        string url = "https://api.trackmedia.io/theme-packs?start=" + startParam + "&limit=20";
        Logging::Debug("URL: " + url);
        
        try {
            auto req = API::Get(url);
            if (req is null) {
                State::themePacksRequestStatus = "Error";
                State::isRequestingThemePacks = false;
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
                        State::themePacksRequestStatus = "Success";
                        State::themePacksResponse = "Array with " + json.Length + " items";
                        Logging::Debug("Parsed " + json.Length + " theme packs");
                        
                        State::themePacks.RemoveRange(0, State::themePacks.Length);
                        for (uint i = 0; i < json.Length; i++) {
                            try {
                                ThemePack@ themePack = ThemePack(json[i]);
                                State::themePacks.InsertLast(themePack);
                                if (themePack.coverId.Length > 0) {
                                    startnew(ThumbnailService::RequestThumbnailForThemePack, themePack);
                                }
                            } catch {
                                Logging::Error("Failed to parse theme pack " + i + ": " + getExceptionInfo());
                            }
                        }
                        State::hasRequestedThemePacks = true;
                    } else {
                        State::themePacksRequestStatus = "Failed (Invalid JSON)";
                        State::themePacksResponse = "Expected JSON Array, got type: " + json.GetType();
                        Logging::Error("Invalid JSON type: " + json.GetType());
                    }
                } catch {
                    State::themePacksRequestStatus = "Error";
                    State::themePacksResponse = "Exception parsing JSON: " + getExceptionInfo();
                    Logging::Error("JSON parse exception: " + getExceptionInfo());
                }
            } else {
                State::themePacksRequestStatus = "Failed (HTTP " + responseCode + ")";
                State::themePacksResponse = responseBody.Length > 200 ? responseBody.SubStr(0, 200) + "..." : responseBody;
                Logging::Error("HTTP error: " + responseCode);
            }
        } catch {
            State::themePacksRequestStatus = "Error";
            State::themePacksResponse = "Exception: " + getExceptionInfo();
            Logging::Error("Request exception: " + getExceptionInfo());
        }
        
        State::isRequestingThemePacks = false;
        Logging::Debug("DebugRequestThemePacks: Complete");
    }

    void DebugRequestThemePackById(const string &in themePackId) {
        if (themePackId.Length == 0) {
            Logging::Warn("DebugRequestThemePackById called with empty ID");
            return;
        }
        
        Logging::Debug("DebugRequestThemePackById: " + themePackId);
        string url = "https://api.trackmedia.io/theme-packs/id/" + themePackId;
        
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
                    ThemePack@ foundThemePack = FindThemePackInState(themePackId);
                    
                    if (foundThemePack !is null) {
                        foundThemePack.UpdateWithFullData(json);
                        Logging::Debug("Updated theme pack in state");
                    } else {
                        Logging::Warn("Theme pack not found in state: " + themePackId);
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
