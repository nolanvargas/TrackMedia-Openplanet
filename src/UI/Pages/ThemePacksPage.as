namespace ThemePacksPage {
    void Render() {
        if (!State::themePacks.hasRequested && !State::themePacks.isRequesting) {
            State::themePacks.isRequesting = true;
            startnew(ThemePacksApiService::RequestThemePacks);
        }

        State::themePacksTabSystem.RenderTabBar("ThemePackTabs", "Theme Packs");
        UI::Separator();

        // Scrollable content area - keeps tab bar static
        if (UI::BeginChild("ThemePacksScroll", vec2(0, 0), false)) {
            Tab@ activeTab = State::themePacksTabSystem.GetActiveTab();
            if (activeTab !is null && !State::themePacksTabSystem.IsPageTabActive()) {
                activeTab.PushTabStyle(State::themePacksTabSystem.activeIndex);
                activeTab.Render();
                activeTab.PopTabStyleWithText();
            } else {
                RenderGrid();
            }
        }
        UI::EndChild();
    }

    void RenderGrid() {
        if (!PageHelpers::RenderGrid(State::allThemePacks.Length, State::themePacks.isRequesting, State::themePacks.status, "Loading theme packs...", "No theme packs found.")) {
            StyleHelpers::PushButton();
            if (UI::Button("Refresh")) {
                State::themePacks.hasRequested = false;
                State::themePacks.isRequesting = true;
                startnew(ThemePacksApiService::RequestThemePacks);
            }
            StyleHelpers::PopButton();
            return;
        }
        Gallery::Render(State::allThemePacks);
    }
}
