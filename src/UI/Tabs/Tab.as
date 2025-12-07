class Tab {
    bool m_isPinned = false;
    
    bool IsVisible() { return true; }
    bool CanClose() { return true; }
    bool IsPinned() { return m_isPinned; }
    void SetPinned(bool pinned) { m_isPinned = pinned; }
    string GetLabel() { return ""; }
    string GetTooltip() { return ""; }
    string GetTabId() { return ""; }  // Override in subclasses for tab matching
    vec4 GetColor() { return Colors::TAB_DEFAULT; }
    vec4 GetColor(int index) { return GetColor(); }  // Override for index-based colors

    void PushTabStyle() {
        vec4 color = GetColor();
        UI::PushStyleColor(UI::Col::Tab, color * Colors::TAB_MULTIPLIER);
        UI::PushStyleColor(UI::Col::TabHovered, color * Colors::TAB_HOVERED_MULTIPLIER);
        UI::PushStyleColor(UI::Col::TabActive, color);
        UI::PushStyleColor(UI::Col::TableRowBgAlt, Colors::TABLE_ROW_BG_ALT);
        UI::PushStyleColor(UI::Col::TableRowBg, Colors::TABLE_ROW_BG);
    }

    void PushTabStyle(int index) {
        vec4 color = GetColor(index);
        vec4 textColor = TabStyles::GetTextColor(color);
        
        UI::PushStyleColor(UI::Col::Tab, color * Colors::TAB_MULTIPLIER);
        UI::PushStyleColor(UI::Col::TabHovered, color * Colors::TAB_HOVERED_MULTIPLIER);
        UI::PushStyleColor(UI::Col::TabActive, color);
        UI::PushStyleColor(UI::Col::Text, textColor);
        UI::PushStyleColor(UI::Col::TableRowBgAlt, Colors::TABLE_ROW_BG_ALT);
        UI::PushStyleColor(UI::Col::TableRowBg, Colors::TABLE_ROW_BG);
    }

    void PopTabStyle() {
        UI::PopStyleColor(5);
    }
    
    void PopTabStyle(int colorCount) {
        UI::PopStyleColor(colorCount);
    }
    
    void PopTabStyleWithText() {
        UI::PopStyleColor(6);  // 6 colors including text color
    }

    void Reload() {}
    void Render() {}
}
