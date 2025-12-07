namespace ThemePacksPageTabManager {
    void RenderTabBar() {
        PageHelpers::RenderTabBar(State::themePacksTabs, State::themePacksActiveTabIndex, State::themePacksForceTabSelection, "ThemePackTabs", "Theme Packs", State::themePacksPinnedTabsLoaded, false);
    }

    void OpenThemePackTab(ThemePack@ pack) {
        if (pack is null) return;
        ThemePackTab@ newTab = ThemePackTab(pack);
        if (TabManager::OpenTab(State::themePacksTabs, State::themePacksActiveTabIndex, State::themePacksForceTabSelection, pack.themePackId, newTab, 5, State::themePacksActiveTabIndex, State::themePacksForceTabSelection)) {
            startnew(ThemePacksApiService::RequestThemePackById, pack.themePackId);
        }
    }

    void CloseTab(int index) {
        PageHelpers::CloseTab(State::themePacksTabs, State::themePacksActiveTabIndex, index);
    }
}
