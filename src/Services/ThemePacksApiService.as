namespace ThemePacksApiService {
    void RequestThemePacks() {
        RequestThemePacksWithParams("", 20);
    }

    void RequestThemePacksWithParams(const string &in start = "", int limit = 20) {     
        if (limit <= 0) limit = 20;
        State::ResetThemePacksRequest();
        
        // API takes a uuidv4 as the start parameter for an arbitrary set
        string startParam = start.Length > 0 ? start : API::GenerateUUIDv4();
        string url = "https://api.trackmedia.io/theme-packs?start=" + startParam + "&limit=" + limit;
        
        try {
            auto json = API::GetAsync(url);
            
            try {
                State::SetThemePacksSuccess();
                State::ClearThemePacks();
                
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
                State::SetThemePacksError("Error");
                Logging::Error("Failed to parse theme packs JSON: " + getExceptionInfo());
            }
        } catch {
            State::SetThemePacksError("Error");
            Logging::Error("Exception in RequestThemePacks: " + getExceptionInfo());
        }
        
        State::isRequestingThemePacks = false;
    }

    void RequestThemePackById(const string &in themePackId) {
        if (themePackId.Length == 0) { throw("RequestThemePackById called with empty ID"); }
        
        ThemePack@ foundThemePack = FindThemePackInState(themePackId);
        if (foundThemePack is null) {
            Logging::Warn("Theme pack not found in state for ID: " + themePackId);
            return;
        }
        
        RequestThemePackById(themePackId, foundThemePack);
    }
    
    void RequestThemePackById(const string &in themePackId, ThemePack@ themePack) {
        if (themePackId.Length == 0 || themePack is null) {
            Logging::Warn("RequestThemePackById called with empty ID or null theme pack");
            return;
        }
        
        string url = "https://api.trackmedia.io/theme-packs/id/" + themePackId;
        
        try {
            auto json = API::GetAsync(url);
            try {
                themePack.UpdateWithFullData(json);
            } catch {
                Logging::Error("Failed to parse theme pack JSON: " + getExceptionInfo());
            }
        } catch {
            Logging::Error("Exception in RequestThemePackById: " + getExceptionInfo());
        }
    }
    
    // Wrapper for startnew that takes a ThemePack@ via ref
    void RequestThemePackByIdWithRef(ref@ data) {
        ThemePack@ themePack = cast<ThemePack>(data);
        if (themePack is null || themePack.themePackId.Length == 0) {
            Logging::Warn("RequestThemePackByIdWithRef called with null theme pack or empty ID");
            return;
        }
        RequestThemePackById(themePack.themePackId, themePack);
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
