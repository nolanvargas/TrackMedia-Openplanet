namespace ThemePacksPage {
    void Render() {
        ThemePacksPageTabManager::EnsureThemePacksTabExists();
        
        if (!State::hasRequestedThemePacks && !State::isRequestingThemePacks) {
            Logging::Info("ThemePacksPage: Starting theme packs request");
            State::isRequestingThemePacks = true;
            startnew(ApiService::RequestThemePacks);
        }

        ThemePacksPageTabManager::RenderTabBar();
        UI::Separator();
        
        if (State::activeTabIndex >= 0 && State::activeTabIndex < int(State::openTabs.Length)) {
            Tab@ activeTab = State::openTabs[State::activeTabIndex];
            if (activeTab !is null) {
                if (State::activeTabIndex == 0) {
                    RenderThemePacksGrid();
                    return;
                } else {
                    ThemePackTab@ themePackTab = cast<ThemePackTab>(activeTab);
                    if (themePackTab !is null) {
                        activeTab.PushTabStyle(State::activeTabIndex);
                        activeTab.Render();
                        activeTab.PopTabStyleWithText();  // 6 colors including text color (needed for last 2 shades with black text)
                    } else {
                        activeTab.PushTabStyle();
                        activeTab.Render();
                        activeTab.PopTabStyle();
                    }
                    return;
                }
            }
        }
        
        RenderThemePacksGrid();
    }
    
    void RenderThemePacksGrid() {
        if (State::themePacks.Length == 0) {
            if (State::isRequestingThemePacks) {
                UI::Text("Loading theme packs...");
            } else {
                UI::Text("No theme packs found.");
                UI::Text("Status: " + State::themePacksRequestStatus);
                if (UI::Button("Refresh")) {
                    State::hasRequestedThemePacks = false;
                    State::isRequestingThemePacks = true;
                    startnew(ApiService::RequestThemePacks);
                }
            }
            return;
        }

        // Use Gallery component to render theme packs
        Gallery::Render(State::themePacks);
    }
}

