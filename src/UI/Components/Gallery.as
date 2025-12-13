namespace Gallery {
    ApplyGalleryButton@ g_applyButton = null;
    CollectionGalleryButton@ g_collectionButton = null;
    ThemePackGalleryButton@ g_themePackButton = null;
    
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
    
    // Overload: Renders media items with the default Apply button.
    // Use this when you want the standard apply functionality without specifying a custom button.
    void Render(array<MediaItem@>@ items, GalleryGrid::Config@ config = null) {
        Render(items, GetApplyButton(), config);
    }
    
    // Overload: Renders media items with a custom button.
    // Use this when you need to provide a specific GalleryButton instance for custom behavior.
    void Render(array<MediaItem@>@ items, GalleryButton@ button, GalleryGrid::Config@ config = null) {
        if (items is null || items.Length == 0) {
            UI::Text("No items to display.");
            return;
        }
        RenderWithConfig(items, button, config, 8.0f, 8.0f);
    }
    
    // Helper: Applies responsive column count and spacing to config, then renders.
    void RenderWithConfig(array<MediaItem@>@ items, GalleryButton@ button, GalleryGrid::Config@ config, float itemSpacing, float columnSpacing) {
        if (config is null) {
            GalleryGrid::Config defaultConfig;
            defaultConfig.columns = GetResponsiveColumnCount();
            defaultConfig.itemSpacing = itemSpacing;
            defaultConfig.columnSpacing = columnSpacing;
            GalleryGrid::Render(items, button, defaultConfig);
        } else {
            config.columns = GetResponsiveColumnCount();
            GalleryGrid::Render(items, button, config);
        }
    }
    
    // Overload: Renders collections with the default Collection button.
    // Use this when you want the standard open collection functionality without specifying a custom button.
    void Render(array<Collection@>@ collections, GalleryGrid::Config@ config = null) {
        Render(collections, GetCollectionButton(), config);
    }
    
    // Overload: Renders collections with a custom button.
    // Use this when you need to provide a specific CollectionGalleryButton instance for custom behavior.
    void Render(array<Collection@>@ collections, CollectionGalleryButton@ button, GalleryGrid::Config@ config = null) {
        if (collections is null || collections.Length == 0) {
            UI::Text("No collections to display.");
            return;
        }
        RenderWithConfig(collections, button, config, 12.0f, 12.0f);
    }
    
    // Helper: Applies responsive column count and spacing to config, then renders.
    void RenderWithConfig(array<Collection@>@ collections, CollectionGalleryButton@ button, GalleryGrid::Config@ config, float itemSpacing, float columnSpacing) {
        if (config is null) {
            GalleryGrid::Config defaultConfig;
            defaultConfig.columns = GetResponsiveColumnCount();
            defaultConfig.itemSpacing = itemSpacing;
            defaultConfig.columnSpacing = columnSpacing;
            GalleryGrid::Render(collections, button, defaultConfig);
        } else {
            config.columns = GetResponsiveColumnCount();
            GalleryGrid::Render(collections, button, config);
        }
    }
    
    // Overload: Renders theme packs with the default ThemePack button.
    // Use this when you want the standard open theme pack functionality without specifying a custom button.
    void Render(array<ThemePack@>@ themePacks, GalleryGrid::Config@ config = null) {
        Render(themePacks, GetThemePackButton(), config);
    }
    
    // Overload: Renders theme packs with a custom button.
    // Use this when you need to provide a specific ThemePackGalleryButton instance for custom behavior.
    void Render(array<ThemePack@>@ themePacks, ThemePackGalleryButton@ button, GalleryGrid::Config@ config = null) {
        if (themePacks is null || themePacks.Length == 0) {
            UI::Text("No theme packs to display.");
            return;
        }
        RenderWithConfig(themePacks, button, config, 12.0f, 12.0f);
    }
    
    // Helper: Applies responsive column count and spacing to config, then renders.
    void RenderWithConfig(array<ThemePack@>@ themePacks, ThemePackGalleryButton@ button, GalleryGrid::Config@ config, float itemSpacing, float columnSpacing) {
        if (config is null) {
            GalleryGrid::Config defaultConfig;
            defaultConfig.columns = GetResponsiveColumnCount();
            defaultConfig.itemSpacing = itemSpacing;
            defaultConfig.columnSpacing = columnSpacing;
            GalleryGrid::Render(themePacks, button, defaultConfig);
        } else {
            config.columns = GetResponsiveColumnCount();
            GalleryGrid::Render(themePacks, button, config);
        }
    }
}

