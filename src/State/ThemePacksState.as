namespace State {
    // Theme packs state
    bool hasRequestedThemePacks = false;
    bool isRequestingThemePacks = false;
    string themePacksRequestStatus = "Not requested";
    array<ThemePack@> themePacks;
    
    void ResetThemePacksRequest() {
        isRequestingThemePacks = true;
        themePacksRequestStatus = "Requesting...";
    }
    
    void SetThemePacksError(const string &in status) {
        themePacksRequestStatus = status;
        isRequestingThemePacks = false;
    }
    
    void SetThemePacksSuccess() {
        themePacksRequestStatus = "Success";
    }
    
    void SetThemePacksRequestComplete() {
        hasRequestedThemePacks = true;
        isRequestingThemePacks = false;
    }

    void ClearThemePacks() {
        themePacks.RemoveRange(0, themePacks.Length);
    }
}
