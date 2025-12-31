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
    
    void Render(array<MediaItem@>@ items, GalleryGrid::Config@ config = null) {
        if (g_applyButton is null) @g_applyButton = ApplyGalleryButton();
        Render(items, g_applyButton, config);
    }
    
    void Render(array<MediaItem@>@ items, GalleryButton@ button, GalleryGrid::Config@ config = null) {
        if (items.Length == 0) {
            UI::Text("No items to display.");
            return;
        }
        if (config is null) {
            g_defaultConfig.columns = GetResponsiveColumnCount();
            g_defaultConfig.itemSpacing = 8.0f;
            g_defaultConfig.columnSpacing = 8.0f;
            @config = g_defaultConfig;
        } else {
            config.columns = GetResponsiveColumnCount();
        }
        GalleryGrid::Render(items, button, config);
    }
    
    void Render(array<Collection@>@ collections, GalleryGrid::Config@ config = null) {
        if (g_collectionButton is null) @g_collectionButton = CollectionGalleryButton();
        Render(collections, g_collectionButton, config);
    }
    
    void Render(array<Collection@>@ collections, CollectionGalleryButton@ button, GalleryGrid::Config@ config = null) {
        if (collections.Length == 0) {
            UI::Text("No collections to display.");
            return;
        }
        if (config is null) {
            g_defaultConfig.columns = GetResponsiveColumnCount();
            g_defaultConfig.itemSpacing = 12.0f;
            g_defaultConfig.columnSpacing = 12.0f;
            @config = g_defaultConfig;
        } else {
            config.columns = GetResponsiveColumnCount();
        }
        GalleryGrid::Render(collections, button, config);
    }
    
    void Render(array<ThemePack@>@ themePacks, GalleryGrid::Config@ config = null) {
        if (g_themePackButton is null) @g_themePackButton = ThemePackGalleryButton();
        Render(themePacks, g_themePackButton, config);
    }
    
    void Render(array<ThemePack@>@ themePacks, ThemePackGalleryButton@ button, GalleryGrid::Config@ config = null) {
        if (themePacks.Length == 0) {
            UI::Text("No theme packs to display.");
            return;
        }
        if (config is null) {
            g_defaultConfig.columns = GetResponsiveColumnCount();
            g_defaultConfig.itemSpacing = 12.0f;
            g_defaultConfig.columnSpacing = 12.0f;
            @config = g_defaultConfig;
        } else {
            config.columns = GetResponsiveColumnCount();
        }
        GalleryGrid::Render(themePacks, button, config);
    }
}

