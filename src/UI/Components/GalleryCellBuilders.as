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
            if (item.HasThumbRequest()) {
                if (item.IsThumbUnsupportedType("webp")) {
                    data.imageState = ImageState::Type::WebpUnsupported;
                } else if (item.IsThumbUnsupportedType("webm")) {
                    data.imageState = ImageState::Type::WebmUnsupported;
                } else if (item.HasThumbError()) {
                    data.imageState = ImageState::Type::Error;
                } else {
                    data.imageState = ImageState::Type::Loading;
                }
            } else {
                // Lazy load: request thumbnail only when cell is being built
                if (item.key.Length > 0) {
                    startnew(ThumbnailService::RequestThumbnailForMediaItem, item);
                }
                data.imageState = ImageState::Type::Loading;
            }
        }

        // Prepare optional animation frames when thumb_key is a webm-based thumbnail.
        // These map to /thumbs/{id}/1.webp .. 3.webp and will be used once webp is supported.
        UpdateMediaItemAnimationFrames(data, item);
    }

    string GetThumbIdFromKey(const string &in thumbKey) {
        if (thumbKey.Length == 0) return "";

        string key = thumbKey;
        // Normalize by removing a leading slash (avoid direct indexing to prevent type issues)
        if (key.Length > 0 && key.SubStr(0, 1) == "/") {
            key = key.SubStr(1);
        }

        // Remove "thumbs/" prefix if present
        if (key.StartsWith("thumbs/")) {
            key = key.SubStr(7);
        }

        // Strip a ".webm" extension if present
        if (key.Length > 5) {
            string ext = key.SubStr(key.Length - 5);
            if (ext == ".webm") {
                key = key.SubStr(0, key.Length - 5);
            }
        }

        // Guard against empty results
        if (key.Length == 0) return "";
        return key;
    }

    void UpdateMediaItemAnimationFrames(GalleryCellData@ data, MediaItem@ item) {
        if (data is null || item is null) return;
        if (item.thumbKey.Length == 0) return;

        // Only apply this to webm-based thumb keys; these map to 3 webp frames.
        if (!FileUtils::IsFileType(item.thumbKey, "webm")) {
            return;
        }

        string thumbId = GetThumbIdFromKey(item.thumbKey);
        if (thumbId.Length == 0) return;

        // Mark that this cell can use animation frames.
        data.hasAnimationFrames = true;
        if (data.animationFrames.Length != 3) {
            data.animationFrames.Resize(3);
            for (uint i = 0; i < data.animationFrames.Length; i++) {
                @data.animationFrames[i] = null;
            }
            data.animationCurrentFrame = 0;
            data.animationLastSwitchTime = 0;
        }

        bool anyFrameLoaded = false;
        for (uint i = 0; i < 3; i++) {
            string framePath = "thumbs/" + thumbId + "/" + (i + 1) + ".webp";
            string url = "https://cdn.trackmedia.io/" + framePath;

            CachedImage@ cached = Images::FindExisting(url);
            if (cached is null) {
                @cached = Images::CachedFromURL(url);
            }

            if (cached !is null && cached.texture !is null) {
                @data.animationFrames[i] = cached.texture;
                anyFrameLoaded = true;
            }
        }

        // Once any frame is successfully loaded (when webp is supported),
        // treat the image as loaded so the animation will render instead of a placeholder.
        if (anyFrameLoaded) {
            data.imageState = ImageState::Type::Loaded;
        }
    }
    
    // Builds cell data from a media item. If items array is provided, button adapters will use it for context.
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
            data.backgroundColor = Colors::GALLERY_CELL_BG;
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
        bool hasCoverRequest = collection.HasCoverRequest();
        bool isCoverLoaded = collection.IsCoverLoaded();
        
        if (isCoverLoaded && hasCoverRequest) {
            UI::Texture@ texture = collection.GetCoverTexture();
            if (texture !is null) {
                @data.imageTexture = texture;
                data.imageState = ImageState::Type::Loaded;
                // Extract actual image dimensions from texture
                vec2 texSize = texture.GetSize();
                if (texSize.x > 0 && texSize.y > 0) {
                    data.imageWidth = int(texSize.x);
                    data.imageHeight = int(texSize.y);
                }
            } else {
                data.imageState = ImageState::Type::None;
            }
        } else if (hasCoverRequest) {
            if (collection.IsCoverUnsupportedType("webp")) {
                data.imageState = ImageState::Type::WebpUnsupported;
            } else if (collection.IsCoverUnsupportedType("webm")) {
                data.imageState = ImageState::Type::WebmUnsupported;
            } else if (collection.HasCoverError()) {
                data.imageState = ImageState::Type::Error;
            } else {
                data.imageState = ImageState::Type::Loading;
            }
        } else if (!hasCoverKey) {
            data.imageState = ImageState::Type::None;
        } else {
            data.imageState = ImageState::Type::Loading;
        }
    }
    
    // Builds cell data from a collection. If collections array is provided, button adapters will use it for context.
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
            data.backgroundColor = Colors::GALLERY_CELL_BG;
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
        bool hasCoverRequest = themePack.HasCoverRequest();
        bool isCoverLoaded = themePack.IsCoverLoaded();
        
        if (isCoverLoaded && hasCoverRequest) {
            UI::Texture@ texture = themePack.GetCoverTexture();
            if (texture !is null) {
                @data.imageTexture = texture;
                data.imageState = ImageState::Type::Loaded;
                // Extract actual image dimensions from texture
                vec2 texSize = texture.GetSize();
                if (texSize.x > 0 && texSize.y > 0) {
                    data.imageWidth = int(texSize.x);
                    data.imageHeight = int(texSize.y);
                }
            } else {
                data.imageState = ImageState::Type::None;
            }
        } else if (hasCoverRequest) {
            if (themePack.IsCoverUnsupportedType("webp")) {
                data.imageState = ImageState::Type::WebpUnsupported;
            } else if (themePack.IsCoverUnsupportedType("webm")) {
                data.imageState = ImageState::Type::WebmUnsupported;
            } else if (themePack.HasCoverError()) {
                data.imageState = ImageState::Type::Error;
            } else {
                data.imageState = ImageState::Type::Loading;
            }
        } else if (!hasCoverId) {
            data.imageState = ImageState::Type::None;
        } else {
            data.imageState = ImageState::Type::Loading;
        }
    }
    
    // Builds cell data from a theme pack. If themePacks array is provided, button adapters will use it for context.
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
            data.backgroundColor = Colors::GALLERY_CELL_BG;
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

