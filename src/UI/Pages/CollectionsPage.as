namespace CollectionsPage {
    void Render() {
        if (!State::hasRequestedCollections && !State::isRequestingCollections) {
            State::isRequestingCollections = true;
            startnew(CollectionsApiService::RequestCollections);
        }

        CollectionsPageTabManager::RenderTabBar();
        UI::Separator();
        
        if (State::collectionsActiveTabIndex >= 0 && State::collectionsActiveTabIndex < int(State::collectionsTabs.Length)) {
            Tab@ activeTab = State::collectionsTabs[State::collectionsActiveTabIndex];
            if (State::collectionsActiveTabIndex == 0) {
                RenderGrid();
                return;
            } else {
                // Ensure data is requested for collection tabs before rendering
                CollectionTab@ collectionTab = cast<CollectionTab>(activeTab);
                if (collectionTab !is null) {
                    collectionTab.EnsureDataRequested();
                }
                
                activeTab.PushTabStyle(State::collectionsActiveTabIndex);
                activeTab.Render();
                activeTab.PopTabStyleWithText();
                return;
            }
        }
        
        RenderGrid();
    }
    
    void RenderGrid() {
        if (!PageHelpers::RenderGrid(State::collections.Length, State::isRequestingCollections, State::collectionsRequestStatus, "Loading collections...", "No collections found.")) {
            if (UI::Button("Refresh")) {
                State::hasRequestedCollections = false;
                State::isRequestingCollections = true;
                startnew(CollectionsApiService::RequestCollections);
            }
            return;
        }
        Gallery::Render(State::collections);
    }
}

