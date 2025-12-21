namespace ThemePacksApiService {
    void RequestThemePacks() {
        RequestThemePacksWithParams("", 20);
    }

    void RequestThemePacksWithParams(const string &in start = "", int limit = 20) {
        if (limit <= 0) limit = 20;
        State::ResetThemePacksRequest();
        
        string effectiveStart = start.Length > 0 ? start : API::GenerateUUIDv4();
        string url = "https://api.trackmedia.io/theme-packs?start=" + effectiveStart + "&limit=" + limit;
        
        try {
            auto json = API::GetAsync(url);
            State::SetThemePacksSuccess();
            State::ClearThemePacks();
            
            for (uint i = 0; i < json.Length; i++) {
                try {
                    ThemePack@ themePack = ThemePack(json[i]);
                    State::themePacks.InsertLast(themePack);
                    startnew(ThumbnailService::RequestThumbnailForThemePack, themePack);
                } catch {
                    Logging::Error("Failed to parse theme pack " + i + ": " + getExceptionInfo());
                }
            }
            
            State::hasRequestedThemePacks = true;
        } catch {
            State::SetThemePacksError("Error");
            Logging::Error("Exception in RequestThemePacks: " + getExceptionInfo());
        }
        
        State::isRequestingThemePacks = false;
    }

    void RequestThemePackById(ThemePack@ themePack) {
        if (themePack is null) return;
        
        string url = "https://api.trackmedia.io/theme-packs/id/" + themePack.themePackId;
        try {
            auto json = API::GetAsync(url);
            themePack.UpdateWithFullData(json);
        } catch {
            Logging::Error("Exception in RequestThemePackById: " + getExceptionInfo());
        }
    }
    
    void RequestThemePackByIdWithRef(ref@ data) {
        ThemePack@ themePack = cast<ThemePack>(data);
        RequestThemePackById(themePack);
    }
}
