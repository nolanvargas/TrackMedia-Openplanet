namespace GalleryCellBuilders {
    // Cached button instance to avoid per-frame allocation
    CopyGalleryButton@ g_copyButton = null;
    
    // Cache GalleryCellData objects to avoid per-frame allocation
    dictionary g_mediaItemCellCache;
    dictionary g_collectionCellCache;
    dictionary g_themePackCellCache;
    
    CopyGalleryButton@ GetCopyButton() {
        if (g_copyButton is null) {
            @g_copyButton = CopyGalleryButton();
        }
        return g_copyButton;
    }
    
    void UpdateMediaItemCellData(GalleryCellData@ data, MediaItem@ item) {
        if (data is null || item is null) return;
        data.imageWidth = item.width;
        data.imageHeight = item.height;
        SetMediaItemImageState(data, item);
        data.title = item.userName;
        data.subtitle = item.signSize;
    }
    
    void UpdateCollectionCellData(GalleryCellData@ data, Collection@ collection) {
        if (data is null || collection is null) return;
        SetCollectionImageState(data, collection);
        data.title = collection.collectionName.Length == 0 ? "Unnamed Collection" : collection.collectionName;
        data.subtitle = collection.userName.Length == 0 ? "Unknown" : collection.userName;
    }
    
    void UpdateThemePackCellData(GalleryCellData@ data, ThemePack@ themePack) {
        if (data is null || themePack is null) return;
        SetThemePackImageState(data, themePack);
        data.title = themePack.packName.Length == 0 ? "Unnamed Theme Pack" : themePack.packName;
        data.subtitle = themePack.userName.Length == 0 ? "Unknown" : themePack.userName;
    }
    
    void SetMediaItemImageState(GalleryCellData@ data, MediaItem@ item) {
        if (item.IsThumbLoaded()) {
            UI::Texture@ texture = item.GetThumbTexture();
            if (texture !is null) {
                @data.imageTexture = texture;
                data.imageState = ImageState::Type::Loaded;
            } else {
                data.imageState = ImageState::Type::Loading;
            }
        } else {
            data.imageState = (item.cachedThumb !is null && item.cachedThumb.error) 
                ? ImageState::Type::Error 
                : ImageState::Type::Loading;
        }
    }
    
    GalleryCellData@ BuildFromMediaItem(MediaItem@ item, uint index, GalleryButton@ button, array<MediaItem@>@ items = null) {
        if (item is null) return null;
        
        // Try to reuse cached cell data
        string cacheKey = item.mediaId.Length > 0 ? item.mediaId : item.key;
        GalleryCellData@ data = null;
        if (cacheKey.Length > 0 && g_mediaItemCellCache.Exists(cacheKey)) {
            g_mediaItemCellCache.Get(cacheKey, @data);
        }
        
        // Create new if not cached
        if (data is null) {
            @data = GalleryCellData();
            data.backgroundColor = vec4(0.25f, 0.25f, 0.25f, 1.0f);
            data.lockedAspectRatio = false;
            if (cacheKey.Length > 0) {
                g_mediaItemCellCache.Set(cacheKey, @data);
            }
        } else {
            // Clear buttons array for reuse
            data.buttons.Resize(0);
        }
        
        // Update data from item
        UpdateMediaItemCellData(data, item);
        
        // Rebuild buttons (these need fresh references)
        if (item.key.Length > 0) {
            MediaItemButtonAdapter@ copyAdapter = (items !is null) 
                ? MediaItemButtonAdapter(GetCopyButton(), items)
                : MediaItemButtonAdapter(GetCopyButton(), item);
            data.buttons.InsertLast(copyAdapter);
        }
        
        if (button !is null) {
            MediaItemButtonAdapter@ adapter = (items !is null)
                ? MediaItemButtonAdapter(button, items)
                : MediaItemButtonAdapter(button, item);
            data.buttons.InsertLast(adapter);
        }
        
        return data;
    }
    
    void SetCollectionImageState(GalleryCellData@ data, Collection@ collection) {
        bool hasCoverKey = collection.coverKey.Length > 0;
        bool hasCachedCover = collection.cachedCover !is null;
        bool isCoverLoaded = collection.IsCoverLoaded();
        
        if (isCoverLoaded && hasCachedCover) {
            UI::Texture@ texture = collection.GetCoverTexture();
            if (texture !is null) {
                @data.imageTexture = texture;
                data.imageState = ImageState::Type::Loaded;
            } else {
                data.imageState = ImageState::Type::None;
            }
        } else if (hasCachedCover) {
            data.imageState = collection.cachedCover.error ? ImageState::Type::Error : ImageState::Type::Loading;
        } else if (!hasCoverKey) {
            data.imageState = ImageState::Type::None;
        } else {
            data.imageState = ImageState::Type::Loading;
        }
    }
    
    GalleryCellData@ BuildFromCollection(Collection@ collection, uint index, CollectionGalleryButton@ button, array<Collection@>@ collections = null) {
        if (collection is null) return null;
        
        // Try to reuse cached cell data
        string cacheKey = collection.collectionId;
        GalleryCellData@ data = null;
        if (cacheKey.Length > 0 && g_collectionCellCache.Exists(cacheKey)) {
            g_collectionCellCache.Get(cacheKey, @data);
        }
        
        // Create new if not cached
        if (data is null) {
            @data = GalleryCellData();
            data.backgroundColor = vec4(0.25f, 0.25f, 0.25f, 1.0f);
            data.lockedAspectRatio = true;
            data.imageWidth = 1;
            data.imageHeight = 1;
            if (cacheKey.Length > 0) {
                g_collectionCellCache.Set(cacheKey, @data);
            }
        } else {
            // Clear buttons array for reuse
            data.buttons.Resize(0);
        }
        
        // Update data from collection
        UpdateCollectionCellData(data, collection);
        
        // Rebuild buttons
        if (button !is null) {
            CollectionButtonAdapter@ adapter = (collections !is null)
                ? CollectionButtonAdapter(button, collections)
                : CollectionButtonAdapter(button, collection);
            data.buttons.InsertLast(adapter);
        }
        
        return data;
    }
    
    void SetThemePackImageState(GalleryCellData@ data, ThemePack@ themePack) {
        bool hasCoverId = themePack.coverId.Length > 0;
        bool hasCachedCover = themePack.cachedCover !is null;
        bool isCoverLoaded = themePack.IsCoverLoaded();
        
        if (isCoverLoaded && hasCachedCover) {
            UI::Texture@ texture = themePack.GetCoverTexture();
            if (texture !is null) {
                @data.imageTexture = texture;
                data.imageState = ImageState::Type::Loaded;
            } else {
                data.imageState = ImageState::Type::None;
            }
        } else if (hasCachedCover) {
            data.imageState = themePack.cachedCover.error ? ImageState::Type::Error : ImageState::Type::Loading;
        } else if (!hasCoverId) {
            data.imageState = ImageState::Type::None;
        } else {
            data.imageState = ImageState::Type::Loading;
        }
    }
    
    GalleryCellData@ BuildFromThemePack(ThemePack@ themePack, uint index, ThemePackGalleryButton@ button, array<ThemePack@>@ themePacks = null) {
        if (themePack is null) return null;
        
        // Try to reuse cached cell data
        string cacheKey = themePack.themePackId;
        GalleryCellData@ data = null;
        if (cacheKey.Length > 0 && g_themePackCellCache.Exists(cacheKey)) {
            g_themePackCellCache.Get(cacheKey, @data);
        }
        
        // Create new if not cached
        if (data is null) {
            @data = GalleryCellData();
            data.backgroundColor = vec4(0.25f, 0.25f, 0.25f, 1.0f);
            data.lockedAspectRatio = true;
            data.imageWidth = 1;
            data.imageHeight = 1;
            if (cacheKey.Length > 0) {
                g_themePackCellCache.Set(cacheKey, @data);
            }
        } else {
            // Clear buttons array for reuse
            data.buttons.Resize(0);
        }
        
        // Update data from theme pack
        UpdateThemePackCellData(data, themePack);
        
        // Rebuild buttons
        if (button !is null) {
            ThemePackButtonAdapter@ adapter = (themePacks !is null)
                ? ThemePackButtonAdapter(button, themePacks)
                : ThemePackButtonAdapter(button, themePack);
            data.buttons.InsertLast(adapter);
        }
        
        return data;
    }
}

