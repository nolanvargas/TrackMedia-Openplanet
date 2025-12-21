namespace CollectionsPage {
    void Render() {
        if (!State::hasRequestedCollections && !State::isRequestingCollections) {
            State::isRequestingCollections = true;
            startnew(CollectionsApiService::RequestCollections);
        }

        State::collectionsTabSystem.RenderTabBar("CollectionTabs", "Collections");
        UI::Separator();
        
        Tab@ activeTab = State::collectionsTabSystem.GetActiveTab();
        if (activeTab !is null && !State::collectionsTabSystem.IsPageTabActive()) {
            activeTab.PushTabStyle(State::collectionsTabSystem.activeIndex);
            activeTab.Render();
            activeTab.PopTabStyleWithText();
            return;
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

