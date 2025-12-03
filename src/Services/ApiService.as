namespace ApiService {
    void RequestThumbs() {
        State::isRequestingThumbs = true;
        State::thumbsRequestStatus = "Requesting...";
        State::thumbsResponse = "";
        State::thumbsStatusCode = 0;
        try {
            auto json = API::GetAsync("https://api.trackmedia.io/media/latest");
            if (json.GetType() == Json::Type::Array) {
                State::thumbsRequestStatus = "Success";
                State::thumbsStatusCode = 200;
                State::mediaItems.RemoveRange(0, State::mediaItems.Length);
                for (uint i = 0; i < json.Length; i++) {
                    MediaItem@ item = MediaItem(json[i]);
                    State::mediaItems.InsertLast(item);
                    startnew(ThumbnailService::RequestThumbnailForMediaItem, item);
                }
                State::hasRequestedThumbs = true;
            } else {
                State::thumbsRequestStatus = "Failed (Invalid JSON)";
                State::thumbsResponse = "Expected JSON Array";
                State::hasRequestedThumbs = true;
            }
        } catch {
            State::thumbsRequestStatus = "Error";
            State::thumbsResponse = "Exception: " + getExceptionInfo();
            State::hasRequestedThumbs = true;
        }
        State::isRequestingThumbs = false;
    }

    void RequestCollections() {
        RequestCollectionsWithParams("", 20);
    }

    void RequestCollectionsWithParams(const string &in start = "", int limit = 20) {
        State::isRequestingCollections = true;
        State::collectionsRequestStatus = "Requesting...";
        string effectiveStart = start.Length > 0 ? start : API::GenerateUUIDv4();
        string url = "https://api.trackmedia.io/collections?start=" + effectiveStart + "&limit=" + limit;
        try {
            auto req = API::Get(url);
            while (!req.Finished()) {
                yield();
            }
            int responseCode = req.ResponseCode();
            if (responseCode == 200) {
                try {
                    auto json = req.Json();
                    if (json.GetType() == Json::Type::Array) {
                        State::collectionsRequestStatus = "Success";
                        State::collections.RemoveRange(0, State::collections.Length);
                        for (uint i = 0; i < json.Length; i++) {
                            try {
                                Collection@ collection = Collection(json[i]);
                                State::collections.InsertLast(collection);
                                startnew(ThumbnailService::RequestThumbnailForCollection, collection);
                            } catch {
                                Logging::Error("RequestCollections: Failed to create collection " + i + ": " + getExceptionInfo());
                            }
                        }
                        State::hasRequestedCollections = true;
                    } else {
                        State::collectionsRequestStatus = "Failed (Invalid JSON)";
                        Logging::Error("Collections API: Expected JSON Array, got type: " + json.GetType());
                    }
                } catch {
                    State::collectionsRequestStatus = "Error";
                    Logging::Error("Failed to parse collections JSON: " + getExceptionInfo());
                }
            } else {
                State::collectionsRequestStatus = "Failed (HTTP " + responseCode + ")";
                Logging::Error("Collections API request failed with code: " + responseCode);
            }
        } catch {
            State::collectionsRequestStatus = "Error";
            Logging::Error("Exception in RequestCollections: " + getExceptionInfo());
        }
        State::isRequestingCollections = false;
    }

    void RequestCollectionById(const string &in collectionId) {
        string url = "https://api.trackmedia.io/collections/id/" + collectionId;
        try {
            auto req = API::Get(url);
            while (!req.Finished()) {
                yield();
            }
            if (req.ResponseCode() == 200) {
                try {
                    auto json = req.Json();
                    Collection@ foundCollection = null;
                    for (uint i = 0; i < State::collections.Length; i++) {
                        if (State::collections[i].collectionId == collectionId) {
                            @foundCollection = State::collections[i];
                            break;
                        }
                    }
                    if (foundCollection is null) {
                        for (uint i = 0; i < State::openTabs.Length; i++) {
                            CollectionTab@ tab = cast<CollectionTab>(State::openTabs[i]);
                            if (tab !is null && tab.GetCollectionId() == collectionId) {
                                @foundCollection = tab.GetCollection();
                                break;
                            }
                        }
                    }
                    if (foundCollection !is null) {
                        foundCollection.UpdateWithFullData(json);
                    } else {
                        Logging::Warn("Collection not found in state for ID: " + collectionId);
                    }
                } catch {
                    Logging::Error("Failed to parse collection JSON: " + getExceptionInfo());
                }
            } else {
                Logging::Error("Collection by ID API request failed with code: " + req.ResponseCode());
            }
        } catch {
            Logging::Error("Exception in RequestCollectionById: " + getExceptionInfo());
        }
    }

    // Fetch theme packs with pagination (wrapper for startnew)
    void RequestThemePacks() {
        RequestThemePacksWithParams("", 20);
    }

    // Fetch theme packs with pagination
    void RequestThemePacksWithParams(const string &in start = "", int limit = 20) {
        Logging::Info("RequestThemePacks: Starting request");
        State::isRequestingThemePacks = true;
        State::themePacksRequestStatus = "Requesting...";
        
        // Use provided start parameter or generate a new UUID v4
        string startParam = start != "" ? start : API::GenerateUUIDv4();
        string url = "https://api.trackmedia.io/theme-packs?start=" + startParam + "&limit=" + limit;
        
        Logging::Info("RequestThemePacks: URL = " + url);
        
        try {
            auto req = API::Get(url);
            Logging::Info("RequestThemePacks: Request started, waiting for response...");
            while (!req.Finished()) {
                yield();
            }
            
            int responseCode = req.ResponseCode();
            Logging::Info("RequestThemePacks: Response code = " + responseCode);
            
            if (responseCode == 200) {
                try {
                    string responseBody = req.String();
                    
                    // Print the JSON response to console
                    print("=== Theme Packs API Response ===");
                    print(responseBody);
                    print("=== End Theme Packs Response ===");
                    
                    auto json = req.Json();
                    Logging::Info("RequestThemePacks: JSON type = " + json.GetType());
                    
                    if (json.GetType() == Json::Type::Array) {
                        uint arrayLength = json.Length;
                        Logging::Info("RequestThemePacks: JSON array length = " + arrayLength);
                        
                        State::themePacksRequestStatus = "Success";
                        
                        State::themePacks.RemoveRange(0, State::themePacks.Length);
                        Logging::Info("RequestThemePacks: Cleared existing theme packs");
                        
                        // Create theme pack objects and request cover images
                        for (uint i = 0; i < arrayLength; i++) {
                            try {
                                ThemePack@ themePack = ThemePack(json[i]);
                                Logging::Info("RequestThemePacks: Created theme pack " + i + ": " + themePack.packName + " (ID: " + themePack.themePackId + ")");
                                State::themePacks.InsertLast(themePack);
                                
                                // Request the cover image for this theme pack
                                if (themePack.coverId.Length > 0) {
                                    Logging::Info("RequestThemePacks: Requesting cover for theme pack " + i + ", coverId = " + themePack.coverId);
                                    startnew(ThumbnailService::RequestThumbnailForThemePack, themePack);
                                }
                            } catch {
                                Logging::Error("RequestThemePacks: Failed to create theme pack " + i + ": " + getExceptionInfo());
                            }
                        }
                        
                        Logging::Info("RequestThemePacks: Total theme packs in state = " + State::themePacks.Length);
                        State::hasRequestedThemePacks = true;
                    } else {
                        State::themePacksRequestStatus = "Failed (Invalid JSON)";
                        Logging::Error("Theme Packs API: Expected JSON Array, got type: " + json.GetType());
                    }
                } catch {
                    State::themePacksRequestStatus = "Error";
                    Logging::Error("Failed to parse theme packs JSON: " + getExceptionInfo());
                }
            } else {
                Logging::Error("Theme Packs API request failed with code: " + responseCode);
                Logging::Error("Response body: " + req.String());
                State::themePacksRequestStatus = "Failed (HTTP " + responseCode + ")";
            }
        } catch {
            State::themePacksRequestStatus = "Error";
            Logging::Error("Exception in RequestThemePacks: " + getExceptionInfo());
        }
        
        Logging::Info("RequestThemePacks: Finished, isRequestingThemePacks = false");
        State::isRequestingThemePacks = false;
    }

    void RequestThemePackById(const string &in themePackId) {
        string url = "https://api.trackmedia.io/theme-packs/id/" + themePackId;
        try {
            auto req = API::Get(url);
            while (!req.Finished()) {
                yield();
            }
            if (req.ResponseCode() == 200) {
                try {
                    auto json = req.Json();
                    ThemePack@ foundThemePack = null;
                    for (uint i = 0; i < State::themePacks.Length; i++) {
                        if (State::themePacks[i].themePackId == themePackId) {
                            @foundThemePack = State::themePacks[i];
                            break;
                        }
                    }
                    if (foundThemePack is null) {
                        for (uint i = 0; i < State::openTabs.Length; i++) {
                            ThemePackTab@ tab = cast<ThemePackTab>(State::openTabs[i]);
                            if (tab !is null && tab.GetThemePackId() == themePackId) {
                                @foundThemePack = tab.GetThemePack();
                                break;
                            }
                        }
                    }
                    if (foundThemePack !is null) {
                        foundThemePack.UpdateWithFullData(json);
                    } else {
                        Logging::Warn("Theme pack not found in state for ID: " + themePackId);
                    }
                } catch {
                    Logging::Error("Failed to parse theme pack JSON: " + getExceptionInfo());
                }
            } else {
                Logging::Error("Theme pack by ID API request failed with code: " + req.ResponseCode());
            }
        } catch {
            Logging::Error("Exception in RequestThemePackById: " + getExceptionInfo());
        }
    }
}
