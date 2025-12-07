namespace MediaItemsApiService {
    void RequestMediaItems() {
        State::isRequestingMediaItems = true;
        State::mediaItemsRequestStatus = "Requesting...";
        State::mediaItemsResponse = "";
        State::mediaItemsStatusCode = 0;
        
        try {
            auto json = API::GetAsync("https://api.trackmedia.io/media/latest");
            Json::Value itemsArray;
            
            // Handle both array response and object with "items" property
            if (json.GetType() == Json::Type::Array) {
                itemsArray = json;
            } else if (json.GetType() == Json::Type::Object && json.HasKey("items")) {
                itemsArray = json["items"];
            } else {
                State::mediaItemsRequestStatus = "Failed (Invalid JSON)";
                State::mediaItemsResponse = "Expected JSON Array or Object with 'items' property";
                State::hasRequestedMediaItems = true;
                State::isRequestingMediaItems = false;
                return;
            }
            
            if (itemsArray.GetType() != Json::Type::Array) {
                State::mediaItemsRequestStatus = "Failed (Invalid JSON)";
                State::mediaItemsResponse = "Expected JSON Array";
                State::hasRequestedMediaItems = true;
                State::isRequestingMediaItems = false;
                return;
            }
            
            State::mediaItemsRequestStatus = "Success";
            State::mediaItemsStatusCode = 200;
            State::mediaItems.RemoveRange(0, State::mediaItems.Length);
            
            for (uint i = 0; i < itemsArray.Length; i++) {
                try {
                    MediaItem@ item = MediaItem(itemsArray[i]);
                    State::mediaItems.InsertLast(item);
                    // Don't request thumbnails automatically - let gallery cells request them lazily
                } catch {
                    Logging::Error("Failed to parse media item " + i + ": " + getExceptionInfo());
                }
            }
            
            State::hasRequestedMediaItems = true;
        } catch {
            State::mediaItemsRequestStatus = "Error";
            State::mediaItemsResponse = "Exception: " + getExceptionInfo();
            Logging::Error("RequestMediaItems exception: " + getExceptionInfo());
            State::hasRequestedMediaItems = true;
        }
        
        State::isRequestingMediaItems = false;
    }

    // Debug function with verbose logging
    void DebugRequestMediaItems() {
        Logging::Debug("DebugRequestMediaItems: Starting");
        State::isRequestingMediaItems = true;
        State::mediaItemsRequestStatus = "Requesting...";
        State::mediaItemsResponse = "";
        State::mediaItemsStatusCode = 0;
        
        try {
            auto req = API::Get("https://api.trackmedia.io/media/latest");
            if (req is null) {
                State::mediaItemsRequestStatus = "Error";
                State::isRequestingMediaItems = false;
                return;
            }
            
            while (!req.Finished()) {
                yield();
            }
            
            int responseCode = req.ResponseCode();
            State::mediaItemsStatusCode = responseCode;
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
                        State::mediaItemsRequestStatus = "Failed (Invalid JSON)";
                        State::mediaItemsResponse = "Expected JSON Array or Object with 'items' property, got type: " + json.GetType();
                        Logging::Error("Invalid JSON type: " + json.GetType());
                        State::isRequestingMediaItems = false;
                        return;
                    }
                    
                    if (itemsArray.GetType() == Json::Type::Array) {
                        State::mediaItemsRequestStatus = "Success";
                        State::mediaItemsResponse = "Array with " + itemsArray.Length + " items";
                        Logging::Debug("Parsed " + itemsArray.Length + " items");
                        
                        State::mediaItems.RemoveRange(0, State::mediaItems.Length);
                        for (uint i = 0; i < itemsArray.Length; i++) {
                            try {
                                MediaItem@ item = MediaItem(itemsArray[i]);
                                State::mediaItems.InsertLast(item);
                                // Don't request thumbnails automatically - let gallery cells request them lazily
                            } catch {
                                Logging::Error("Failed to parse item " + i + ": " + getExceptionInfo());
                            }
                        }
                        State::hasRequestedMediaItems = true;
                    } else {
                        State::mediaItemsRequestStatus = "Failed (Invalid JSON)";
                        State::mediaItemsResponse = "Expected JSON Array in items, got type: " + itemsArray.GetType();
                        Logging::Error("Invalid items array type: " + itemsArray.GetType());
                    }
                } catch {
                    State::mediaItemsRequestStatus = "Error";
                    State::mediaItemsResponse = "Exception parsing JSON: " + getExceptionInfo();
                    Logging::Error("JSON parse exception: " + getExceptionInfo());
                }
            } else {
                State::mediaItemsRequestStatus = "Failed (HTTP " + responseCode + ")";
                State::mediaItemsResponse = responseBody.Length > 200 ? responseBody.SubStr(0, 200) + "..." : responseBody;
                Logging::Error("HTTP error: " + responseCode);
            }
        } catch {
            State::mediaItemsRequestStatus = "Error";
            State::mediaItemsResponse = "Exception: " + getExceptionInfo();
            Logging::Error("Request exception: " + getExceptionInfo());
        }
        
        State::isRequestingMediaItems = false;
        Logging::Debug("DebugRequestMediaItems: Complete");
    }
}
