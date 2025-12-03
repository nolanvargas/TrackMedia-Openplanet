namespace CollectionsPage {
    void Render() {
        CollectionsPageTabManager::EnsureCollectionsTabExists();
        
        if (!State::hasRequestedCollections && !State::isRequestingCollections) {
            Logging::Info("CollectionsPage: Starting collection request");
            startnew(ApiService::RequestCollections);
        }

        CollectionsPageTabManager::RenderTabBar();
        UI::Separator();
        
        if (State::activeTabIndex >= 0 && State::activeTabIndex < int(State::openTabs.Length)) {
            Tab@ activeTab = State::openTabs[State::activeTabIndex];
            if (activeTab !is null) {
                if (State::activeTabIndex == 0) {
                    RenderCollectionsGrid();
                    return;
                } else {
                    activeTab.PushTabStyle();
                    activeTab.Render();
                    activeTab.PopTabStyle();
                    return;
                }
            }
        }
        
        RenderCollectionsGrid();
    }
    
    void RenderCollectionsGrid() {
        if (State::collections.Length == 0) {
            if (State::isRequestingCollections) {
                UI::Text("Loading collections...");
            } else {
                UI::Text("No collections found.");
                UI::Text("Status: " + State::collectionsRequestStatus);
                if (UI::Button("Refresh")) {
                    State::hasRequestedCollections = false;
                    startnew(ApiService::RequestCollections);
                }
            }
            return;
        }

        // Use Gallery component to render collections
        Gallery::Render(State::collections);
    }
    
}

