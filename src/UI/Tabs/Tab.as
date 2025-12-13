class Tab {
    bool m_isPinned = false;
    bool isVisible = true;
    bool canClose = true;
    string label = "";
    string tooltip = "";
    string tabId = "";
    vec4 color = Colors::TAB_DEFAULT;
    
    bool IsPinned() { return m_isPinned; }
    void SetPinned(bool pinned) { m_isPinned = pinned; }
    string GetLabel() { return label; }
    string GetTooltip() { return tooltip; }
    string GetTabId() { return tabId; }
    vec4 GetColor(int index) { return color; }  // Override for index-based colors

    void PushTabStyle() {
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

    void Render() {}
}
