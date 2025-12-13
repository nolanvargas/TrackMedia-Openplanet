namespace ThemePacksPage {
    void Render() {
        if (!State::hasRequestedThemePacks && !State::isRequestingThemePacks) {
            Logging::Info("ThemePacksPage: Starting theme packs request");
            State::isRequestingThemePacks = true;
            startnew(ThemePacksApiService::RequestThemePacks);
        }

        ThemePacksPageTabManager::RenderTabBar();
        UI::Separator();
        
        if (State::themePacksActiveTabIndex >= 0 && State::themePacksActiveTabIndex < int(State::themePacksTabs.Length)) {
            Tab@ activeTab = State::themePacksTabs[State::themePacksActiveTabIndex];
            if (State::themePacksActiveTabIndex == 0) {
                RenderGrid();
                return;
            } else {
                // Ensure data is requested for theme pack tabs before rendering
                ThemePackTab@ themePackTab = cast<ThemePackTab>(activeTab);
                if (themePackTab !is null) {
                    themePackTab.EnsureDataRequested();
                }
                
                activeTab.PushTabStyle(State::themePacksActiveTabIndex);
                activeTab.Render();
                activeTab.PopTabStyleWithText();
                return;
            }
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

