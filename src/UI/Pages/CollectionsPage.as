namespace CollectionsPage {
    void Render() {
        if (!State::hasRequestedCollections && !State::isRequestingCollections) {
            Logging::Info("CollectionsPage: Starting collection request");
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
                activeTab.PushTabStyle(State::collectionsActiveTabIndex);
                activeTab.Render();
                activeTab.PopTabStyleWithText();
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

