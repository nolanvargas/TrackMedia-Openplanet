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
    
    void RenderTabBar(
        array<Tab@>@ tabs,
        int&out activeTabIndex,
        bool&out forceTabSelection,
        const string &in tabBarId,
        const string &in pageTabLabel,
        bool&out pinnedTabsLoaded,
        bool isCollection
    ) {
        if (tabs.Length == 0 || cast<PageTab>(tabs[0]) is null) {
            tabs.InsertAt(0, PageTab(pageTabLabel));
            activeTabIndex++;
        }
        
        if (!pinnedTabsLoaded) {
            array<Tab@>@ restoredTabs = PinnedTabsStorage::RestorePinnedTabs(isCollection);
            for (uint i = 0; i < restoredTabs.Length; i++) {
                Tab@ tab = restoredTabs[i];
                if (tab !is null) tabs.InsertLast(tab);
            }
            pinnedTabsLoaded = true;
        }
        
        int previousActiveTabIndex = activeTabIndex;
        TabManager::RenderTabBar(tabs, activeTabIndex, forceTabSelection, tabBarId, activeTabIndex, forceTabSelection);
        
        // If a non-page tab (index > 0) was selected, ensure we're on the correct page and request data
        if (activeTabIndex > 0 && activeTabIndex != previousActiveTabIndex && activeTabIndex < int(tabs.Length)) {
            Tab@ selectedTab = tabs[activeTabIndex];
            if (selectedTab !is null) {
                string targetPage = isCollection ? "Collections" : "Theme Packs";
                UIWindow::SetActivePage(targetPage);
                
                // Request data for the tab if it's a collection or theme pack tab
                if (isCollection) {
                    CollectionTab@ collectionTab = cast<CollectionTab>(selectedTab);
                    if (collectionTab !is null) {
                        collectionTab.EnsureDataRequested();
                    }
                } else {
                    ThemePackTab@ themePackTab = cast<ThemePackTab>(selectedTab);
                    if (themePackTab !is null) {
                        themePackTab.EnsureDataRequested();
                    }
                }
            }
        }
    }
    
    void CloseTab(array<Tab@>@ tabs, int&out activeTabIndex, int index) {
        TabManager::CloseTab(tabs, activeTabIndex, index, activeTabIndex);
    }
}
