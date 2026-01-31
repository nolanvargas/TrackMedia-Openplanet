class Tab {
    bool isPinned = false;
    bool canClose = true;
    string label = "";
    string tabId = "";
    vec4 color = Colors::TAB_DEFAULT;

    string TruncateLabel(const string &in text, int maxLength = 25) {
        if (int(text.Length) <= maxLength) return text;
        return text.SubStr(0, maxLength - 3) + "...";
    }

    void PushTabStyle() {
        UI::PushStyleColor(UI::Col::Tab, Colors::TRANSPARENT);
        UI::PushStyleColor(UI::Col::TabHovered, vec4(1, 1, 1, 0.1f));
        UI::PushStyleColor(UI::Col::TabActive, vec4(1, 1, 1, 0.15f));
        UI::PushStyleColor(UI::Col::HeaderActive, Colors::ACTIVE);
        UI::PushStyleColor(UI::Col::TableRowBgAlt, Colors::TABLE_ROW_BG_ALT);
        UI::PushStyleColor(UI::Col::TableRowBg, Colors::TABLE_ROW_BG);
    }

    void PushTabStyle(int index) {
        UI::PushStyleColor(UI::Col::Tab, Colors::TRANSPARENT);
        UI::PushStyleColor(UI::Col::TabHovered, vec4(1, 1, 1, 0.1f));
        UI::PushStyleColor(UI::Col::TabActive, vec4(1, 1, 1, 0.15f));
        UI::PushStyleColor(UI::Col::HeaderActive, Colors::ACTIVE);
        UI::PushStyleColor(UI::Col::Text, Colors::WHITE);
        UI::PushStyleColor(UI::Col::TableRowBgAlt, Colors::TABLE_ROW_BG_ALT);
        UI::PushStyleColor(UI::Col::TableRowBg, Colors::TABLE_ROW_BG);
    }

    void PopTabStyle(bool includeText = false) {
        UI::PopStyleColor(includeText ? 7 : 6);
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
