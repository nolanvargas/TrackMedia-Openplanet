namespace State {
    // Tab management - Collections
    array<Tab@> collectionsTabs;
    int collectionsActiveTabIndex = -1;
    bool collectionsForceTabSelection = false;
    bool collectionsPinnedTabsLoaded = false;
    
    // Tab management - Theme Packs
    array<Tab@> themePacksTabs;
    int themePacksActiveTabIndex = -1;
    bool themePacksForceTabSelection = false;
    bool themePacksPinnedTabsLoaded = false;
}
