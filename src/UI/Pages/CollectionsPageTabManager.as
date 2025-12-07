namespace CollectionsPageTabManager {
    void RenderTabBar() {
        PageHelpers::RenderTabBar(State::collectionsTabs, State::collectionsActiveTabIndex, State::collectionsForceTabSelection, "CollectionTabs", "Collections", State::collectionsPinnedTabsLoaded, true);
    }
    
    void OpenCollectionTab(Collection@ collection) {
        if (collection is null) return;
        CollectionTab@ newTab = CollectionTab(collection);
        if (TabManager::OpenTab(State::collectionsTabs, State::collectionsActiveTabIndex, State::collectionsForceTabSelection, collection.collectionId, newTab, 5, State::collectionsActiveTabIndex, State::collectionsForceTabSelection)) {
            startnew(CollectionsApiService::RequestCollectionById, collection.collectionId);
        }
    }
    
    void CloseTab(int index) {
        PageHelpers::CloseTab(State::collectionsTabs, State::collectionsActiveTabIndex, index);
    }
}

