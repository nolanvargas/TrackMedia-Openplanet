class TabSystem {
    array<Tab@> tabs;
    int activeIndex = -1;
    bool pinnedTabsLoaded, isCollection, forceSelection;

    TabSystem(bool isCollection) { this.isCollection = isCollection; }

    void RenderTabBar(const string &in tabBarId, const string &in pageTabLabel) {
        if (tabs.Length == 0 || cast<PageTab>(tabs[0]) is null) {
            tabs.InsertAt(0, PageTab(pageTabLabel));
            activeIndex = 0;
        }

        if (!pinnedTabsLoaded) {
            auto restored = PinnedTabsStorage::RestorePinnedTabs(isCollection);
            for (uint i = 0; i < restored.Length; i++)
                if (restored[i] !is null) tabs.InsertLast(restored[i]);
            pinnedTabsLoaded = true;
        }

        TabManager::RenderTabBar(tabs, activeIndex, tabBarId, activeIndex, forceSelection);
    }

    bool OpenTab(Tab@ tab, const string &in id, uint maxTabs) {
        return tab !is null
            && TabManager::OpenTab(tabs, activeIndex, id, tab, maxTabs, activeIndex, forceSelection);
    }

    void CloseTab(int index) {
        TabManager::CloseTab(tabs, activeIndex, index, activeIndex);
    }

    Tab@ GetActiveTab() {
        return (activeIndex >= 0 && activeIndex < int(tabs.Length)) ? tabs[activeIndex] : null;
    }

    bool IsPageTabActive() { return activeIndex == 0; }
}
