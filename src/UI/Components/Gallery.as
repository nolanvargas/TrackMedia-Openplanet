namespace Gallery {
    // Cached button instances to avoid per-frame allocation
    ApplyGalleryButton@ g_applyButton = null;
    CollectionGalleryButton@ g_collectionButton = null;
    ThemePackGalleryButton@ g_themePackButton = null;
    
    // Helper: Calculate responsive column count based on window width
    int GetResponsiveColumnCount() {
        float windowWidth = UI::GetWindowSize().x;
        if (windowWidth < 550.0f) {
            return 2;
        } else if (windowWidth < 800.0f) {
            return 3;
        }
        return 4;
    }
    
    ApplyGalleryButton@ GetApplyButton() {
        if (g_applyButton is null) {
            @g_applyButton = ApplyGalleryButton();
        }
        return g_applyButton;
    }
    
    CollectionGalleryButton@ GetCollectionButton() {
        if (g_collectionButton is null) {
            @g_collectionButton = CollectionGalleryButton();
        }
        return g_collectionButton;
    }
    
    ThemePackGalleryButton@ GetThemePackButton() {
        if (g_themePackButton is null) {
            @g_themePackButton = ThemePackGalleryButton();
        }
        return g_themePackButton;
    }
    
    void Render(array<MediaItem@>@ items, GalleryGrid::Config@ config = null) {
        Render(items, GetApplyButton(), config);
    }
    
    void Render(array<MediaItem@>@ items, GalleryButton@ button, GalleryGrid::Config@ config = null) {
        if (items is null || items.Length == 0) {
            UI::Text("No items to display.");
            return;
        }
        if (config is null) {
            GalleryGrid::Config defaultConfig;
            defaultConfig.columns = GetResponsiveColumnCount();
            defaultConfig.itemSpacing = 8.0f;
            defaultConfig.columnSpacing = 8.0f;
            GalleryGrid::Render(items, button, defaultConfig);
        } else {
            config.columns = GetResponsiveColumnCount();
            GalleryGrid::Render(items, button, config);
        }
    }
    
    void Render(array<Collection@>@ collections, GalleryGrid::Config@ config = null) {
        Render(collections, GetCollectionButton(), config);
    }
    
    void Render(array<Collection@>@ collections, CollectionGalleryButton@ button, GalleryGrid::Config@ config = null) {
        if (collections is null || collections.Length == 0) {
            UI::Text("No collections to display.");
            return;
        }
        if (config is null) {
            GalleryGrid::Config defaultConfig;
            defaultConfig.columns = GetResponsiveColumnCount();
            defaultConfig.itemSpacing = 12.0f;
            defaultConfig.columnSpacing = 12.0f;
            GalleryGrid::Render(collections, button, defaultConfig);
        } else {
            config.columns = GetResponsiveColumnCount();
            GalleryGrid::Render(collections, button, config);
        }
    }
    
    void Render(array<ThemePack@>@ themePacks, GalleryGrid::Config@ config = null) {
        Render(themePacks, GetThemePackButton(), config);
    }
    
    void Render(array<ThemePack@>@ themePacks, ThemePackGalleryButton@ button, GalleryGrid::Config@ config = null) {
        if (themePacks is null || themePacks.Length == 0) {
            UI::Text("No theme packs to display.");
            return;
        }
        if (config is null) {
            GalleryGrid::Config defaultConfig;
            defaultConfig.columns = GetResponsiveColumnCount();
            defaultConfig.itemSpacing = 12.0f;
            defaultConfig.columnSpacing = 12.0f;
            GalleryGrid::Render(themePacks, button, defaultConfig);
        } else {
            config.columns = GetResponsiveColumnCount();
            GalleryGrid::Render(themePacks, button, config);
        }
    }
}

