namespace UIWindow {
    class Header {
        SearchBar@ m_searchBar;

        Header() {
            @m_searchBar = SearchBar();
        }

        void Render(float navWidth) {
            UI::PushStyleColor(UI::Col::ChildBg, vec4(0.133, 0.145, 0.141, 1.0));
            auto logo = Images::CachedFromURL("https://cdn.trackmedia.io/media/70b34c60-15d6-4c8f-81d9-a10119961687.png");
            float headerHeight = logo.texture !is null ? 63 : 50;
            
            if (UI::BeginChild("Header", vec2(0, headerHeight), false, UI::WindowFlags::NoScrollbar)) {
                if (logo.texture !is null) {
                    vec2 logoDisplaySize = vec2(200, 40);
                    float paddingVertical = 12.0;
                    float leftOffset = 15.0;
                    
                    UI::Dummy(vec2(0, paddingVertical));
                    UI::SetCursorPos(vec2(leftOffset, paddingVertical));
                    UI::Image(logo.texture, logoDisplaySize);
                    
                    float maxInputW = 350.0;
                    float windowWidth = UI::GetWindowSize().x;
                    float availableWidth = windowWidth - 250.0;
                    float inputW = Math::Min(maxInputW, availableWidth - 100.0);
                    float searchX = navWidth + (availableWidth - inputW) * 0.5 + 50.0;
                    
                    UI::SameLine();
                    float searchY = UI::GetCursorPos().y + (logoDisplaySize.y * 0.5) - 13.0;
                    m_searchBar.Render(searchX, searchY, inputW);
                    
                    UI::SetCursorPos(vec2(0, paddingVertical + logoDisplaySize.y + paddingVertical));
                    UI::Dummy(vec2(0, 0));
                }
                UI::EndChild();
            }
            UI::PopStyleColor();
        }
    }
}
