class ThemePackGalleryButton {
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
        return -1.0f; // Sentinel value: use full content width
    }
    
    vec4 GetBackgroundColor(ThemePack@ themePack, uint index) {
        return Colors::GALLERY_COLLECTION_BUTTON_BG;
    }
    
    vec4 GetTextColor(ThemePack@ themePack, uint index) {
        return Colors::SHADE_BLACK;
    }
    
    float GetFontSize(ThemePack@ themePack, uint index) {
        return 1.0f;
    }
    
    string GetTooltip(ThemePack@ themePack, uint index) {
        return "";
    }
    
    vec4 GetIconColor(ThemePack@ themePack, uint index) {
        return Colors::TRANSPARENT;
    }
    
    bool IsIconTopRight(ThemePack@ themePack, uint index) {
        return false;
    }
}

