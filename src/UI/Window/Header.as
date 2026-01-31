namespace UIWindow {
    class Header {
        CachedImage@ m_logo = null;
        string LOGO_URL = "https://www.trackmedia.io/logoFull.png";
        string m_searchQuery = "";
        bool m_searchFocused = false;

        Header() {
        }

        void Render(float navWidth) {
            if (m_logo is null) {
                @m_logo = Images::CachedFromURL(LOGO_URL);
            }
            float headerHeight = 56;

            UI::PushStyleColor(UI::Col::ChildBg, Colors::DARK);
            UI::BeginChild("Header", vec2(0, headerHeight), false, UI::WindowFlags::NoScrollbar);

            // Allow dragging the window from header
            if (UI::IsItemHovered()) {
                UI::SetMouseCursor(UI::MouseCursor::ResizeAll);
            }

            vec2 windowSize = UI::GetWindowSize();

            // Logo on the left - clickable to go to Home
            if (m_logo !is null && m_logo.texture !is null) {
                vec2 logoDisplaySize = vec2(180, 36);
                vec2 logoPos = vec2(12.0, (headerHeight - logoDisplaySize.y) / 2);
                UI::SetCursorPos(logoPos);
                UI::Image(m_logo.texture, logoDisplaySize);

                // Invisible button overlay for click handling
                UI::SetCursorPos(logoPos);
                UI::PushStyleColor(UI::Col::Button, Colors::TRANSPARENT);
                UI::PushStyleColor(UI::Col::ButtonHovered, Colors::TRANSPARENT);
                UI::PushStyleColor(UI::Col::ButtonActive, Colors::TRANSPARENT);
                if (UI::Button("##LogoBtn", logoDisplaySize)) {
                    UIWindow::SetActivePage("Home");
                }
                if (UI::IsItemHovered()) UI::SetMouseCursor(UI::MouseCursor::Hand);
                UI::PopStyleColor(3);
            }

            // Search bar - centered in the remaining space
            float searchBarWidth = Math::Min(400.0f, windowSize.x - navWidth - 280.0f);
            if (searchBarWidth > 150.0f) {
                float searchX = navWidth + (windowSize.x - navWidth - searchBarWidth) / 2.0f;
                float searchY = (headerHeight - 32) / 2.0f;
                RenderSearchBar(searchX, searchY, searchBarWidth);
            }

            UI::EndChild();
            UI::PopStyleColor();
        }

        void RenderSearchBar(float x, float y, float width) {
            // Sync with State when search is cleared
            if (State::searchQuery.Length == 0 && m_searchQuery.Length > 0 && !State::hasSearchResults && !State::isSearching) {
                m_searchQuery = "";
            }

            UI::SetCursorPos(vec2(x, y));

            // Search container with border
            vec4 borderColor = m_searchFocused ? Colors::ACTIVE : Colors::SEARCH_BORDER;
            UI::PushStyleColor(UI::Col::ChildBg, Colors::SEARCH_BG);
            UI::PushStyleColor(UI::Col::Border, borderColor);
            UI::PushStyleVar(UI::StyleVar::ChildRounding, 6.0f);
            UI::PushStyleVar(UI::StyleVar::ChildBorderSize, 2.0f);

            UI::BeginChild("SearchContainer", vec2(width, 32), true, UI::WindowFlags::NoScrollbar);

            float buttonWidth = 24.0f;
            float buttonX = 4.0f;
            float inputX = buttonX + buttonWidth + 8.0f;
            float inputWidth = width - inputX - 8.0f;

            // Search button (left side)
            UI::SetCursorPos(vec2(buttonX, 4));
            UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(0, 0));
            UI::PushStyleColor(UI::Col::Button, Colors::ACTIVE);
            UI::PushStyleColor(UI::Col::ButtonHovered, Colors::ACTIVE);
            UI::PushStyleColor(UI::Col::ButtonActive, Colors::ACTIVE);
            UI::PushStyleColor(UI::Col::HeaderActive, Colors::ACTIVE);
            UI::PushStyleColor(UI::Col::Text, vec4(0, 0, 0, 1));
            if (UI::Button(Icons::Search + "##SearchBtn", vec2(buttonWidth, 24))) {
                if (m_searchQuery.Length > 0) {
                    State::searchQuery = m_searchQuery;
                    State::OnSearchSubmit();
                }
            }
            UI::PopStyleColor(5);
            UI::PopStyleVar();

            // Search input
            UI::SetCursorPos(vec2(inputX, 4));
            UI::PushStyleColor(UI::Col::FrameBg, Colors::TRANSPARENT);
            UI::PushStyleColor(UI::Col::Text, Colors::WHITE);
            UI::PushItemWidth(inputWidth);

            bool enterPressed = false;
            m_searchQuery = UI::InputText("##SearchInput", m_searchQuery, enterPressed, UI::InputTextFlags::EnterReturnsTrue);
            m_searchFocused = UI::IsItemActive();

            // Submit search on Enter key
            if (enterPressed && m_searchQuery.Length > 0) {
                State::searchQuery = m_searchQuery;
                State::OnSearchSubmit();
            }

            UI::PopItemWidth();
            UI::PopStyleColor(2);

            UI::EndChild();
            UI::PopStyleVar(2);
            UI::PopStyleColor(2);
        }
    }
}
