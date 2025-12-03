namespace UIWindow {
    class SearchBar {
        string m_query;
        uint64 m_lastChange;
        bool m_changed = false;

        void Render(float x, float y, float width) {
            UI::SetCursorPos(vec2(x, y));
            vec2 searchPos = UI::GetCursorPos();
            float fontSize = 18.0f;
            UI::PushFontSize(fontSize);
            UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(4.0f, 6.0f));
            UI::PushItemWidth(width);
            UI::InputText("##NameSearch", m_query, m_changed);
            UI::PopItemWidth();
            UI::PopStyleVar();
            UI::PopFontSize();
            UI::SetCursorPos(searchPos + vec2(-25, 5));
            UI::PushFontSize(fontSize);
            UI::Text(Icons::Search);
            UI::PopFontSize();
            if (m_changed) {
                m_lastChange = Time::Now;
            }
        }
    }
}
