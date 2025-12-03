class ThemePackGalleryButton {
    float width = 100.0f;
    
    bool OnClick(ThemePack@ themePack, uint index) {
        if (themePack is null) return false;
        ThemePacksPageTabManager::OpenThemePackTab(themePack);
        return true;
    }
    
    string GetLabel(ThemePack@ themePack, uint index) {
        return "Open";
    }
    
    bool IsEnabled(ThemePack@ themePack, uint index) {
        return themePack !is null;
    }
    
    float GetWidth(ThemePack@ themePack, uint index) {
        return width;
    }
    
    vec4 GetBackgroundColor(ThemePack@ themePack, uint index) {
        return vec4(0.2f, 0.5f, 0.8f, 1.0f);
    }
    
    vec4 GetTextColor(ThemePack@ themePack, uint index) {
        return vec4(1.0f, 1.0f, 1.0f, 1.0f);
    }
    
    float GetFontSize(ThemePack@ themePack, uint index) {
        return 1.0f;
    }
    
    string GetTooltip(ThemePack@ themePack, uint index) {
        return "";
    }
    
    vec4 GetIconColor(ThemePack@ themePack, uint index) {
        return vec4(0, 0, 0, 0);
    }
    
    bool IsIconTopRight(ThemePack@ themePack, uint index) {
        return false;
    }
}

