namespace GalleryCellBuilders {
    CopyGalleryButton@ g_copyButton = null;
    dictionary g_mediaItemCellCache;
    dictionary g_collectionCellCache;
    dictionary g_themePackCellCache;
    
    string GetThumbIdFromKey(const string &in thumbKey) {
        if (thumbKey.Length == 0) return "";
        string key = thumbKey;
        if (key.Length > 0 && key.SubStr(0, 1) == "/") {
            key = key.SubStr(1);
        }
        if (key.StartsWith("thumbs/")) {
            key = key.SubStr(7);
        }
        if (key.Length > 5) {
            string ext = key.SubStr(key.Length - 5);
            if (ext == ".webm") {
                key = key.SubStr(0, key.Length - 5);
            }
        }
        return key;
    }
    
    GalleryCellData@ BuildFromMediaItem(MediaItem@ item, uint index, GalleryButton@ button, array<MediaItem@>@ items = null) {
        string cacheKey = item.mediaId.Length > 0 ? item.mediaId : item.key;
        GalleryCellData@ data = null;
        if (cacheKey.Length > 0 && g_mediaItemCellCache.Exists(cacheKey)) {
            g_mediaItemCellCache.Get(cacheKey, @data);
        }
        if (data is null) {
            @data = GalleryCellData();
            data.backgroundColor = Colors::GALLERY_CELL_BG;
            data.lockedAspectRatio = false;
            if (cacheKey.Length > 0) {
                g_mediaItemCellCache.Set(cacheKey, @data);
            }
        } else {
            data.buttons.Resize(0);
        }
        data.imageWidth = item.width;
        data.imageHeight = item.height;
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
                if (item.key.Length > 0) {
                    startnew(ThumbnailService::RequestThumbnailForMediaItem, item);
                }
                data.imageState = ImageState::Type::Loading;
            }
        }
        if (item.thumbKey.Length > 0 && FileUtils::IsFileType(item.thumbKey, "webm")) {
            string thumbId = GetThumbIdFromKey(item.thumbKey);
            if (thumbId.Length > 0) {
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
                if (anyFrameLoaded) {
                    data.imageState = ImageState::Type::Loaded;
                }
            }
        }
        data.title = item.userName;
        data.subtitle = item.signSize;
        if (item.key.Length > 0) {
            if (g_copyButton is null) @g_copyButton = CopyGalleryButton();
            data.buttons.InsertLast(items !is null ? MediaItemButtonAdapter(g_copyButton, items) : MediaItemButtonAdapter(g_copyButton, item));
        }
        if (button !is null) {
            data.buttons.InsertLast(items !is null ? MediaItemButtonAdapter(button, items) : MediaItemButtonAdapter(button, item));
        }
        return data;
    }
    
    void SetCoverImageState(GalleryCellData@ data, Collection@ collection) {
        bool hasCoverKey = collection.coverKey.Length > 0;
        bool hasCoverRequest = collection.HasCoverRequest();
        bool isCoverLoaded = collection.IsCoverLoaded();
        UI::Texture@ texture = collection.GetCoverTexture();
        if (isCoverLoaded && hasCoverRequest) {
            if (texture !is null) {
                @data.imageTexture = texture;
                data.imageState = ImageState::Type::Loaded;
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
    
    void SetCoverImageState(GalleryCellData@ data, ThemePack@ themePack) {
        bool hasCoverId = themePack.coverId.Length > 0;
        bool hasCoverRequest = themePack.HasCoverRequest();
        bool isCoverLoaded = themePack.IsCoverLoaded();
        UI::Texture@ texture = themePack.GetCoverTexture();
        if (isCoverLoaded && hasCoverRequest) {
            if (texture !is null) {
                @data.imageTexture = texture;
                data.imageState = ImageState::Type::Loaded;
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
    
    GalleryCellData@ BuildFromCollection(Collection@ collection, uint index, CollectionGalleryButton@ button, array<Collection@>@ collections = null) {
        GalleryCellData@ data = null;
        if (collection.collectionId.Length > 0 && g_collectionCellCache.Exists(collection.collectionId)) {
            g_collectionCellCache.Get(collection.collectionId, @data);
        }
        if (data is null) {
            @data = GalleryCellData();
            data.backgroundColor = Colors::GALLERY_CELL_BG;
            data.lockedAspectRatio = true;
            data.imageWidth = 1;
            data.imageHeight = 1;
            if (collection.collectionId.Length > 0) {
                g_collectionCellCache.Set(collection.collectionId, @data);
            }
        } else {
            data.buttons.Resize(0);
        }
        SetCoverImageState(data, collection);
        data.title = collection.collectionName.Length == 0 ? "Unnamed Collection" : collection.collectionName;
        data.subtitle = collection.userName.Length == 0 ? "Unknown" : collection.userName;
        if (button !is null) {
            data.buttons.InsertLast(collections !is null ? CollectionButtonAdapter(button, collections) : CollectionButtonAdapter(button, collection));
        }
        return data;
    }
    
    GalleryCellData@ BuildFromThemePack(ThemePack@ themePack, uint index, ThemePackGalleryButton@ button, array<ThemePack@>@ themePacks = null) {
        GalleryCellData@ data = null;
        if (themePack.themePackId.Length > 0 && g_themePackCellCache.Exists(themePack.themePackId)) {
            g_themePackCellCache.Get(themePack.themePackId, @data);
        }
        if (data is null) {
            @data = GalleryCellData();
            data.backgroundColor = Colors::GALLERY_CELL_BG;
            data.lockedAspectRatio = true;
            data.imageWidth = 1;
            data.imageHeight = 1;
            if (themePack.themePackId.Length > 0) {
                g_themePackCellCache.Set(themePack.themePackId, @data);
            }
        } else {
            data.buttons.Resize(0);
        }
        SetCoverImageState(data, themePack);
        data.title = themePack.packName.Length == 0 ? "Unnamed Theme Pack" : themePack.packName;
        data.subtitle = themePack.userName.Length == 0 ? "Unknown" : themePack.userName;
        if (button !is null) {
            data.buttons.InsertLast(themePacks !is null ? ThemePackButtonAdapter(button, themePacks) : ThemePackButtonAdapter(button, themePack));
        }
        return data;
    }
}

