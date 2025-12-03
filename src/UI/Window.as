namespace UIWindow {
    Header@ m_header = Header();
    Navigation@ m_navigation = Navigation();

    void Render() {
        if (!State::isInEditor || !State::showUI) return;
        UI::PushStyleColor(UI::Col::WindowBg, vec4(0.45, 0.45, 0.45, 1.0));
        UI::PushStyleVar(UI::StyleVar::WindowPadding, vec2(0, 0));
        UI::Begin("TrackMedia", UI::WindowFlags::NoTitleBar);
        UI::PushStyleVar(UI::StyleVar::ItemSpacing, vec2(2, 2));
        
        float navWidth = 180;
        m_header.Render(navWidth);
        float contentHeight = UI::GetContentRegionAvail().y;
        
        if (UI::GetWindowSize().x < navWidth + 50) {
            UI::Text("Window too small. Please resize to at least " + (navWidth + 50) + "px wide.");
        } else {
            m_navigation.Render(navWidth, contentHeight);
            UI::SameLine();
            UI::PushStyleColor(UI::Col::ChildBg, vec4(0.2, 0.2, 0.2, 1.0));
            if (UI::BeginChild("Content", vec2(0, contentHeight), false, UI::WindowFlags::NoScrollbar)) {
                bool fontPushed = Fonts::PushTrebuchetFont();
                if (m_navigation.m_activePage == "Debug") {
                    DebugPage::Render();
                } else if (m_navigation.m_activePage == "Browse") {
                    BrowsePage::Render();
                } else if (m_navigation.m_activePage == "Collections") {
                    CollectionsPage::Render();
                } else if (m_navigation.m_activePage == "Theme Packs") {
                    ThemePacksPage::Render();
                } else {
                    UI::Text("Page: " + m_navigation.m_activePage);
                }
                if (fontPushed) {
                    UI::PopFont();
                }
                UI::EndChild();
            }
            UI::PopStyleColor();
        }
        
        UI::PopStyleVar();
        UI::End();
        UI::PopStyleVar();
        UI::PopStyleColor();
    }
}
