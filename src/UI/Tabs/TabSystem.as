class TabSystem {
    array<Tab@> tabs;
    int activeIndex = -1;
    bool pinnedTabsLoaded = false;
    bool isCollection = false;
    bool forceSelection = false;
    
    TabSystem(bool isCollection) {
        this.isCollection = isCollection;
    }
    
    void RenderTabBar(const string &in tabBarId, const string &in pageTabLabel) {
        // Ensure page tab exists at index 0
        if (tabs.Length == 0 || cast<PageTab>(tabs[0]) is null) {
            tabs.InsertAt(0, PageTab(pageTabLabel));
            activeIndex = 0;
        }
        
        // Load pinned tabs if not already loaded
        if (!pinnedTabsLoaded) {
            array<Tab@>@ restoredTabs = PinnedTabsStorage::RestorePinnedTabs(isCollection);
            for (uint i = 0; i < restoredTabs.Length; i++) {
                Tab@ tab = restoredTabs[i];
                if (tab !is null) tabs.InsertLast(tab);
            }
            pinnedTabsLoaded = true;
        }
        
        // Render tab bar and update active index
        TabManager::RenderTabBar(tabs, activeIndex, tabBarId, activeIndex, forceSelection);
    }
    
    bool OpenTab(Tab@ tab, const string &in id, uint maxTabs) {
        if (tab is null) return false;
        
        bool opened = TabManager::OpenTab(tabs, activeIndex, id, tab, maxTabs, activeIndex, forceSelection);
        return opened;
    }
    
    void CloseTab(int index) {
        TabManager::CloseTab(tabs, activeIndex, index, activeIndex);
    }
    
    Tab@ GetActiveTab() {
        if (activeIndex >= 0 && activeIndex < int(tabs.Length)) {
            return tabs[activeIndex];
        }
        return null;
    }
    
    bool IsPageTabActive() {
        return activeIndex == 0;
    }
}

