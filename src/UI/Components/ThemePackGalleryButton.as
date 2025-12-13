class ThemePackGalleryButton {
    string label = "Open";
    float width = -1.0f; // Sentinel value: use full content width
    vec4 backgroundColor = Colors::GALLERY_COLLECTION_BUTTON_BG;
    vec4 textColor = Colors::SHADE_BLACK;
    float fontSize = 1.0f;
    string tooltip = "";
    vec4 iconColor = Colors::TRANSPARENT;
    
    bool OnClick(ThemePack@ themePack, uint index) {
        if (themePack is null) return false;
        ThemePacksPageTabManager::OpenThemePackTab(themePack);
        return true;
    }
    
    bool IsEnabled(ThemePack@ themePack, uint index) {
        return themePack !is null;
    }
}

