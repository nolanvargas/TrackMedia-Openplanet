namespace ThemePacksApiService {
    const int LIMIT = 20;

    void RequestThemePacks() {
        State::themePacks.Reset();

        auto json = API::GetAsync(API::API_BASE_URL + "/theme-packs?limit=" + LIMIT);
        if (!ApiHelpers::IsArrayResponse(json)) {
            State::themePacks.SetError("Bad response from server");
            return;
        }

        State::ClearThemePacks();
        for (uint i = 0; i < json.Length; i++) {
            auto p = ThemePack(json[i]);
            State::allThemePacks.InsertLast(p);
            startnew(ThumbnailService::RequestThumbnailForThemePack, p);
        }

        State::themePacks.Complete();
    }

    void RequestThemePackById(ThemePack@ p) {
        if (p is null) return;
        auto json = API::GetAsync(API::API_BASE_URL + "/theme-packs/" + p.themePackId);
        if (ApiHelpers::IsObjectResponse(json)) p.UpdateWithFullData(json);
    }

    void RequestThemePackByIdWithRef(ref@ data) {
        RequestThemePackById(cast<ThemePack>(data));
    }
}
