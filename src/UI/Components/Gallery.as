namespace Gallery {
    void Render(array<MediaItem@>@ items, GalleryGrid::Config@ config = null) {
        Render(items, ApplyGalleryButton(), config);
    }
    
    void Render(array<MediaItem@>@ items, GalleryButton@ button, GalleryGrid::Config@ config = null) {
        if (items is null || items.Length == 0) {
            UI::Text("No items to display.");
            return;
        }
        if (config is null) {
            GalleryGrid::Config defaultConfig;
            defaultConfig.columns = 4;
            defaultConfig.itemSpacing = 8.0f;
            defaultConfig.columnSpacing = 8.0f;
            GalleryGrid::Render(items, button, defaultConfig);
        } else {
            GalleryGrid::Render(items, button, config);
        }
    }
    
    void Render(array<Collection@>@ collections, GalleryGrid::Config@ config = null) {
        Render(collections, CollectionGalleryButton(), config);
    }
    
    void Render(array<Collection@>@ collections, CollectionGalleryButton@ button, GalleryGrid::Config@ config = null) {
        if (collections is null || collections.Length == 0) {
            UI::Text("No collections to display.");
            return;
        }
        if (config is null) {
            GalleryGrid::Config defaultConfig;
            defaultConfig.columns = 4;
            defaultConfig.itemSpacing = 12.0f;
            defaultConfig.columnSpacing = 12.0f;
            GalleryGrid::Render(collections, button, defaultConfig);
        } else {
            GalleryGrid::Render(collections, button, config);
        }
    }
    
    void Render(array<ThemePack@>@ themePacks, GalleryGrid::Config@ config = null) {
        Render(themePacks, ThemePackGalleryButton(), config);
    }
    
    void Render(array<ThemePack@>@ themePacks, ThemePackGalleryButton@ button, GalleryGrid::Config@ config = null) {
        if (themePacks is null || themePacks.Length == 0) {
            UI::Text("No theme packs to display.");
            return;
        }
        if (config is null) {
            GalleryGrid::Config defaultConfig;
            defaultConfig.columns = 4;
            defaultConfig.itemSpacing = 12.0f;
            defaultConfig.columnSpacing = 12.0f;
            GalleryGrid::Render(themePacks, button, defaultConfig);
        } else {
            GalleryGrid::Render(themePacks, button, config);
        }
    }
}

