namespace State {
    // Theme packs state
    bool hasRequestedThemePacks = false;
    bool isRequestingThemePacks = false;
    string themePacksRequestStatus = "Not requested";
    string themePacksResponse = "";
    array<ThemePack@> themePacks;
}
