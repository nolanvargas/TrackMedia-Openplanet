namespace CollectionsPage {
    void Render() {
        if (!State::collections.hasRequested && !State::collections.isRequesting) {
            State::collections.isRequesting = true;
            startnew(CollectionsApiService::RequestCollections);
        }

        State::collectionsTabSystem.RenderTabBar("CollectionTabs", "Collections");
        UI::Separator();

        // Scrollable content area - keeps tab bar static
        if (UI::BeginChild("CollectionsScroll", vec2(0, 0), false)) {
            Tab@ activeTab = State::collectionsTabSystem.GetActiveTab();
            if (activeTab !is null && !State::collectionsTabSystem.IsPageTabActive()) {
                activeTab.PushTabStyle(State::collectionsTabSystem.activeIndex);
                activeTab.Render();
                activeTab.PopTabStyleWithText();
            } else {
                RenderGrid();
            }
        }
        UI::EndChild();
    }

    void RenderGrid() {
        if (!PageHelpers::RenderGrid(State::allCollections.Length, State::collections.isRequesting, State::collections.status, "Loading collections...", "No collections found.")) {
            StyleHelpers::PushButton();
            if (UI::Button("Refresh")) {
                State::collections.hasRequested = false;
                State::collections.isRequesting = true;
                startnew(CollectionsApiService::RequestCollections);
            }
            StyleHelpers::PopButton();
            return;
        }
        Gallery::Render(State::allCollections);
    }
}
