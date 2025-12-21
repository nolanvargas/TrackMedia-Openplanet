namespace PageHelpers {
    bool RenderGrid(uint itemCount, bool isRequesting, const string &in requestStatus, const string &in loadingText = "Loading...", const string &in emptyText = "No items found.") {
        if (itemCount == 0) {
            if (isRequesting) {
                UI::Text(loadingText);
            } else {
                UI::Text(emptyText);
                UI::Text("Status: " + requestStatus);
            }
            return false;
        }
        return true;
    }
    
    void RenderTabContent(TabSystem@ tabSystem) {
        Tab@ activeTab = tabSystem.GetActiveTab();
        if (activeTab !is null) {
            if (tabSystem.IsPageTabActive()) {
                return; // Caller should render grid
            } else {
                activeTab.PushTabStyle(tabSystem.activeIndex);
                activeTab.Render();
                activeTab.PopTabStyleWithText();
            }
        } else {
            return; // Caller should render grid
        }
    }
    
    void OpenCollectionTab(Collection@ collection) {
        if (collection is null) return;
        CollectionTab@ newTab = CollectionTab(collection);
        if (State::collectionsTabSystem.OpenTab(newTab, collection.collectionId, 5)) {
            UIWindow::SetActivePage("Collections");
            startnew(CollectionsApiService::RequestCollectionByIdWithRef, collection);
        }
    }
    
    void OpenThemePackTab(ThemePack@ pack) {
        if (pack is null) return;
        ThemePackTab@ newTab = ThemePackTab(pack);
        if (State::themePacksTabSystem.OpenTab(newTab, pack.themePackId, 5)) {
            UIWindow::SetActivePage("Theme Packs");
            startnew(ThemePacksApiService::RequestThemePackByIdWithRef, pack);
        }
    }
}
