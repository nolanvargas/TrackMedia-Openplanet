namespace ThemePacksApiService {
    void RequestThemePacks() {
        RequestThemePacksWithParams("", 20);
    }

    void RequestThemePacksWithParams(const string &in start = "", int limit = 20) {        
        State::isRequestingThemePacks = true;
        State::themePacksRequestStatus = "Requesting...";
        
        // API takes a uuidv4 as the start parameter for an arbitrary set
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
        
        for (uint i = 0; i < State::themePacksTabs.Length; i++) {
            ThemePackTab@ tab = cast<ThemePackTab>(State::themePacksTabs[i]);
            if (tab !is null && tab.GetTabId() == themePackId) {
                return tab.GetThemePack();
            }
        }
        
        return null;
    }
}
