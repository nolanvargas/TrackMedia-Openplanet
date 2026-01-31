namespace Gallery {
    ApplyGalleryButton@ g_applyButton = null;
    CollectionGalleryButton@ g_collectionButton = null;
    ThemePackGalleryButton@ g_themePackButton = null;
    GalleryGrid::Config g_defaultConfig;

    int GetResponsiveColumnCount() {
        float w = UI::GetWindowSize().x;
        if (w < 550.0f) return 2;
        if (w < 800.0f) return 3;
        return 4;
    }

    void SetupConfig(GalleryGrid::Config@ config, float spacing) {
        if (config is null) {
            g_defaultConfig.columns = GetResponsiveColumnCount();
            g_defaultConfig.itemSpacing = spacing;
            g_defaultConfig.columnSpacing = spacing;
        } else {
            config.columns = GetResponsiveColumnCount();
        }
    }

    void Render(array<MediaItem@>@ items, GalleryButton@ button = null) {
        if (items.Length == 0) { UI::Text("No items to display."); return; }
        if (button is null) {
            if (g_applyButton is null) @g_applyButton = ApplyGalleryButton();
            @button = g_applyButton;
        }
        SetupConfig(null, 8.0f);
        GalleryGrid::Render(items, button, g_defaultConfig);
    }

    void Render(array<Collection@>@ collections, CollectionGalleryButton@ button = null) {
        if (collections.Length == 0) { UI::Text("No collections to display."); return; }
        if (button is null) {
            if (g_collectionButton is null) @g_collectionButton = CollectionGalleryButton();
            @button = g_collectionButton;
        }
        SetupConfig(null, 12.0f);
        GalleryGrid::Render(collections, button, g_defaultConfig);
    }

    void Render(array<ThemePack@>@ themePacks, ThemePackGalleryButton@ button = null) {
        if (themePacks.Length == 0) { UI::Text("No theme packs to display."); return; }
        if (button is null) {
            if (g_themePackButton is null) @g_themePackButton = ThemePackGalleryButton();
            @button = g_themePackButton;
        }
        SetupConfig(null, 12.0f);
        GalleryGrid::Render(themePacks, button, g_defaultConfig);
    }
}
