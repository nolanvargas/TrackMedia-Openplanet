class ThemePackTab : Tab {
    ThemePack@ m_themePack;
    bool m_hasRequestedData = false;
    
    ThemePackTab(ThemePack@ themePack) {
        @m_themePack = themePack;
        color = Colors::TAB_THEME_PACK;
        // If theme pack already has sign types, mark data as requested
        if (themePack !is null && themePack.GetSignTypeKeys().Length > 0) {
            m_hasRequestedData = true;
        }
    }
    
    void EnsureDataRequested() {
        if (m_themePack is null) return;
        // If placeholder (no sign types) and haven't requested data yet, trigger data request
        array<string> signTypeKeys = m_themePack.GetSignTypeKeys();
        if (!m_hasRequestedData && signTypeKeys.Length == 0 && m_themePack.themePackId.Length > 0) {
            startnew(ThemePacksApiService::RequestThemePackByIdWithRef, m_themePack);
            m_hasRequestedData = true;
        }
    }
        
    string GetLabel() override {
        if (m_themePack is null || m_themePack.packName.Length == 0) return "Unknown";
        return m_themePack.packName.Length > 25 ? m_themePack.packName.SubStr(0, 22) + "..." : m_themePack.packName;
    }
    
    vec4 GetColor(int index) override {
        // Use index-based shade colors (index 0 is the Theme Packs page tab, so we start from index 1)
        // Subtract 1 to get the actual theme pack tab index, then apply modulo 5
        int shadeIndex = (index - 1) % 5;
        return TabStyles::GetShadeColor(shadeIndex);
    }
    
    void Render() override {
        if (m_themePack is null) {
            UI::Text("Theme pack not found");
            return;
        }
        
        // Ensure data is requested when tab is rendered
        EnsureDataRequested();
        
        array<string> signTypeKeys = m_themePack.GetSignTypeKeys();
        UI::PushFontSize(24.0f);
        UI::Text(m_themePack.packName);
        UI::PopFontSize();
        UI::Text(m_themePack.userName);
        
        signTypeKeys = m_themePack.GetSignTypeKeys();
        
        UI::Text("Total Items: " + m_themePack.GetTotalItems());
        UI::Separator();
        UI::Dummy(vec2(0, 8));
        
        if (signTypeKeys.Length == 0) {
            if (m_hasRequestedData) {
                UI::Text("Loading theme pack data...");
            } else {
                UI::Text("No sign types in this theme pack.");
            }
            return;
        }
        
        for (uint i = 0; i < signTypeKeys.Length; i++) {
            string signTypeKey = signTypeKeys[i];
            array<MediaItem@>@ items = m_themePack.GetSignTypeItems(signTypeKey);
            
            if (items is null || items.Length == 0) {
                continue;
            }
            
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
