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
    
    // Helper: Truncates a label to maxLength with ellipsis
    string TruncateLabel(const string &in text, int maxLength = 25) {
        if (int(text.Length) <= maxLength) return text;
        return text.SubStr(0, maxLength - 3) + "...";
    }
    
    // Helper: Gets shade color for index-based tabs (modulo 5)
    vec4 GetShadeColorForIndex(int index) {
        int shadeIndex = (index - 1) % 5;
        return TabStyles::GetShadeColor(shadeIndex);
    }

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

    void PopTabStyle(bool includeText = false) {
        UI::PopStyleColor(includeText ? 6 : 5);
    }
    
    void PopTabStyleWithText() {
        PopTabStyle(true);
    }

    void Render() {}
    
    void RenderHeader(const string &in title, const string &in subtitle) {
        UI::PushFontSize(24.0f);
        UI::Text(title);
        UI::PopFontSize();
        UI::Text(subtitle);
    }
}

class PageTab : Tab {
    PageTab(const string &in label) {
        this.label = label;
        canClose = false;
        color = Colors::TAB_PAGE;
    }
}
