namespace ThemePacksPage {
    void Render() {
        if (!State::hasRequestedThemePacks && !State::isRequestingThemePacks) {
            Logging::Info("ThemePacksPage: Starting theme packs request");
            State::isRequestingThemePacks = true;
            startnew(ThemePacksApiService::RequestThemePacks);
        }

        State::themePacksTabSystem.RenderTabBar("ThemePackTabs", "Theme Packs");
        UI::Separator();
        
        Tab@ activeTab = State::themePacksTabSystem.GetActiveTab();
        if (activeTab !is null && !State::themePacksTabSystem.IsPageTabActive()) {
            activeTab.PushTabStyle(State::themePacksTabSystem.activeIndex);
            activeTab.Render();
            activeTab.PopTabStyleWithText();
            return;
        }
        
        RenderGrid();
    }
    
    void RenderGrid() {
        if (!PageHelpers::RenderGrid(State::themePacks.Length, State::isRequestingThemePacks, State::themePacksRequestStatus, "Loading theme packs...", "No theme packs found.")) {
            if (UI::Button("Refresh")) {
                State::hasRequestedThemePacks = false;
                State::isRequestingThemePacks = true;
                startnew(ThemePacksApiService::RequestThemePacks);
            }
            return;
        }
        Gallery::Render(State::themePacks);
    }
}

