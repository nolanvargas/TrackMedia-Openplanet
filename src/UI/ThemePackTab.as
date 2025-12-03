class ThemePackTab : Tab {
    ThemePack@ m_themePack;
    
    ThemePackTab(ThemePack@ themePack) {
        @m_themePack = themePack;
    }
    
    bool IsVisible() override { return true; }
    
    bool CanClose() override { return true; }
    
    string GetLabel() override {
        if (m_themePack is null) return "Unknown";
        string name = m_themePack.packName.Length == 0 ? "Unnamed Theme Pack" : m_themePack.packName;
        return name.Length > 25 ? name.SubStr(0, 22) + "..." : name;
    }
    
    string GetTooltip() override {
        return m_themePack !is null ? m_themePack.packName : "";
    }
    
    vec4 GetColor() override {
        return vec4(0.8f, 0.4f, 0.2f, 1); // Orange color to differentiate from collections
    }
    
    void Render() override {
        if (m_themePack is null) {
            UI::Text("Theme pack not found");
            return;
        }
        
        UI::Text("Theme Pack: " + m_themePack.packName);
        UI::Separator();
        UI::Text("User: " + m_themePack.userName);
        UI::Text("ID: " + m_themePack.themePackId);
        
        array<string> signTypeKeys = m_themePack.GetSignTypeKeys();
        uint totalItems = 0;
        for (uint i = 0; i < signTypeKeys.Length; i++) {
            array<MediaItem@>@ items = m_themePack.GetSignTypeItems(signTypeKeys[i]);
            if (items !is null) {
                totalItems += items.Length;
            }
        }
        UI::Text("Sign Types: " + signTypeKeys.Length);
        UI::Text("Total Items: " + totalItems);
        UI::Separator();
        UI::Dummy(vec2(0, 8));
        
        if (signTypeKeys.Length == 0) {
            UI::Text("No sign types in this theme pack.");
            return;
        }
        
        for (uint i = 0; i < signTypeKeys.Length; i++) {
            string signTypeKey = signTypeKeys[i];
            array<MediaItem@>@ items = m_themePack.GetSignTypeItems(signTypeKey);
            
            if (items is null || items.Length == 0) {
                continue;
            }
            
            if (UI::CollapsingHeader(signTypeKey + " (" + items.Length + ")")) {
                UI::Indent();
                Gallery::Render(items);
                UI::Unindent();
                UI::Dummy(vec2(0, 8));
            }
        }
    }
    
    string GetThemePackId() {
        return m_themePack !is null ? m_themePack.themePackId : "";
    }
    
    ThemePack@ GetThemePack() {
        return m_themePack;
    }
}

