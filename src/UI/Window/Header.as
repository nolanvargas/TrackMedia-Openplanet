namespace UIWindow {
    class Header {
        SearchBar@ m_searchBar;
        CachedImage@ m_logo = null;
        string LOGO_URL = "https://www.trackmedia.io/logoFull.png";

        Header() {
            @m_searchBar = SearchBar();
        }

        void Render(float navWidth) {
            if (m_logo is null) {
                @m_logo = Images::CachedFromURL(LOGO_URL);
            }
            float headerHeight = 63;
            
            UI::PushStyleColor(UI::Col::ChildBg, Colors::HEADER_BG);
            UI::BeginChild("Header", vec2(0, headerHeight), false, UI::WindowFlags::NoScrollbar);
            
            if (UI::IsItemHovered()) {
                UI::SetMouseCursor(UI::MouseCursor::ResizeAll);
            }
            
            if (m_logo !is null && m_logo.texture !is null) {
                vec2 logoDisplaySize = vec2(200, 40);
                
                UI::SetCursorPos(vec2(15.0, 12.0));
                UI::Image(m_logo.texture, logoDisplaySize);
                
                // Search bar coming soon
                // float availableWidth = UI::GetWindowSize().x - 250.0;
                // float inputW = Math::Min(350.0, availableWidth - 100.0);
                // float searchX = navWidth + (availableWidth - inputW) * 0.5 + 50.0;
                
                // UI::SameLine();
                // float searchY = UI::GetCursorPos().y + (logoDisplaySize.y * 0.5) - 13.0;
                // m_searchBar.Render(searchX, searchY, inputW);
            }
            UI::EndChild();
            UI::PopStyleColor();
        }
    }
}
