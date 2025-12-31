namespace ThemePacksApiService {
    void RequestThemePacks() {
        RequestThemePacksWithParams("", 20);
    }

    void RequestThemePacksWithParams(const string &in after = "", int limit = 20) {
        if (limit <= 0) limit = 20;
        State::ResetThemePacksRequest();
        
        string url = API::API_BASE_URL + "/theme-packs?limit=" + limit;
        if (after.Length > 0) {
            url += "&after=" + after;
        }
        
        auto json = API::GetAsync(url);
        if (json.GetType() == Json::Type::Null) {
            State::SetThemePacksError("Error");
            State::isRequestingThemePacks = false;
            return;
        }
        
        State::SetThemePacksSuccess();
        State::ClearThemePacks();
        
        for (uint i = 0; i < json.Length; i++) {
            ThemePack@ themePack = ThemePack(json[i]);
            State::themePacks.InsertLast(themePack);
            startnew(ThumbnailService::RequestThumbnailForThemePack, themePack);
        }
        
        State::hasRequestedThemePacks = true;
        
        State::isRequestingThemePacks = false;
    }

    void RequestThemePackById(ThemePack@ themePack) {
        if (themePack is null) return;
        
        string url = API::API_BASE_URL + "/theme-packs/" + themePack.themePackId;
        auto json = API::GetAsync(url);
        if (json.GetType() != Json::Type::Null) {
            themePack.UpdateWithFullData(json);
        }
    }
    
    void RequestThemePackByIdWithRef(ref@ data) {
        ThemePack@ themePack = cast<ThemePack>(data);
        RequestThemePackById(themePack);
    }
}
