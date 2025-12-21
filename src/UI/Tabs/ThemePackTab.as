class ThemePackTab : Tab {
    ThemePack@ m_themePack;
    bool m_hasRequestedData = false;
    
    ThemePackTab(ThemePack@ themePack) {
        @m_themePack = themePack;
        color = Colors::TAB_THEME_PACK;
        if (themePack !is null && themePack.GetSignTypeKeys().Length > 0) m_hasRequestedData = true;
    }
        
    string GetLabel() override {
        if (m_themePack is null || m_themePack.packName.Length == 0) return "Unknown";
        return TruncateLabel(m_themePack.packName);
    }
    
    vec4 GetColor(int index) override {
        return GetShadeColorForIndex(index);
    }
    
    void Render() override {
        if (m_themePack is null) {
            UI::Text("Theme pack not found");
            return;
        }
        array<string> signTypeKeys = m_themePack.GetSignTypeKeys();
        if (!m_hasRequestedData && signTypeKeys.Length == 0 && m_themePack.themePackId.Length > 0) {
            startnew(ThemePacksApiService::RequestThemePackByIdWithRef, m_themePack);
            m_hasRequestedData = true;
        }
        RenderHeader(m_themePack.packName, m_themePack.userName);
        UI::Text("Total Items: " + m_themePack.GetTotalItems());
        UI::Separator();
        UI::Dummy(vec2(0, 8));
        signTypeKeys = m_themePack.GetSignTypeKeys();
        if (signTypeKeys.Length == 0) {
            UI::Text(m_hasRequestedData ? "Loading theme pack data..." : "No sign types in this theme pack.");
            return;
        }
        for (uint i = 0; i < signTypeKeys.Length; i++) {
            string signTypeKey = signTypeKeys[i];
            array<MediaItem@>@ items = m_themePack.GetSignTypeItems(signTypeKey);
            if (items is null || items.Length == 0) continue;
            UI::PushStyleColor(UI::Col::Header, Colors::SHADE_BLACK);
            UI::PushStyleColor(UI::Col::HeaderHovered, Colors::SHADE_BLACK);
            UI::PushStyleColor(UI::Col::HeaderActive, Colors::SHADE_BLACK);
            UI::PushStyleColor(UI::Col::Text, Colors::ACTIVE);
            if (UI::CollapsingHeader(signTypeKey + " (" + items.Length + ")##" + i)) {
                UI::Indent();
                UI::PushID("Gallery##" + i);
                Gallery::Render(items);
                UI::PopID();
                UI::Unindent();
                UI::Dummy(vec2(0, 8));
            }
            UI::PopStyleColor(4);
        }
    }
    
    string GetTabId() override {
        return m_themePack !is null ? m_themePack.themePackId : "";
    }
    
    ThemePack@ GetThemePack() {
        return m_themePack;
    }
}
