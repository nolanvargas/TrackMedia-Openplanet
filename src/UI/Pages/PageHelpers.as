namespace PageHelpers {
    bool RenderGrid(uint itemCount, bool isRequesting, string requestStatus, string loadingText = "Loading...", string emptyText = "No items found.") {
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
        string tabBarId,
        string pageTabLabel,
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
        
        TabManager::RenderTabBar(tabs, activeTabIndex, forceTabSelection, tabBarId, activeTabIndex, forceTabSelection);
    }
    
    void CloseTab(array<Tab@>@ tabs, int&out activeTabIndex, int index) {
        TabManager::CloseTab(tabs, activeTabIndex, index, activeTabIndex);
    }
}
