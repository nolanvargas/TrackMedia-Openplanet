namespace GalleryCellBuilders {
    CopyGalleryButton@ g_copyButton = null;
    dictionary g_mediaItemCellCache;
    dictionary g_collectionCellCache;
    dictionary g_themePackCellCache;

    // Clear caches to prevent unbounded memory growth
    void ClearMediaItemCache() { g_mediaItemCellCache.DeleteAll(); }
    void ClearCollectionCache() { g_collectionCellCache.DeleteAll(); }
    void ClearThemePackCache() { g_themePackCellCache.DeleteAll(); }
    void ClearAllCaches() {
        g_mediaItemCellCache.DeleteAll();
        g_collectionCellCache.DeleteAll();
        g_themePackCellCache.DeleteAll();
    }

    string GetThumbIdFromKey(const string &in thumbKey) {
        if (thumbKey.Length == 0) return "";
        string key = thumbKey;
        if (key.SubStr(0, 1) == "/") key = key.SubStr(1);
        if (key.StartsWith("thumbs/")) key = key.SubStr(7);
        if (FileUtils::IsWebm(key)) {
            key = key.SubStr(0, key.Length - 5);
        }
        return key;
    }

    // Shared helper: Load webp animation frames for a webm thumbnail
    // Returns true if any frame was loaded
    bool LoadWebpAnimationFrames(GalleryCellData@ data, const string &in thumbKey) {
        if (thumbKey.Length == 0 || !FileUtils::IsWebm(thumbKey)) return false;

        string thumbId = GetThumbIdFromKey(thumbKey);
        if (thumbId.Length == 0) return false;

        data.hasAnimationFrames = true;
        if (data.animationFrames.Length != 3) {
            data.animationFrames.Resize(3);
            for (uint i = 0; i < 3; i++) @data.animationFrames[i] = null;
        }

        bool anyLoaded = false;
        string frameStatus = "";
        for (uint i = 0; i < 3; i++) {
            string url = "https://cdn.trackmedia.io/thumbs/" + thumbId + "/" + (i + 1) + ".webp";
            CachedImage@ cached = Images::FindExisting(url);
            if (cached is null) @cached = Images::CachedFromURL(url);
            if (cached !is null && cached.texture !is null) {
                @data.animationFrames[i] = cached.texture;
                anyLoaded = true;
                frameStatus += (i + 1) + ":OK ";
            } else if (cached !is null && cached.error) {
                frameStatus += (i + 1) + ":ERR ";
            } else if (cached !is null && cached.unsupportedFormat) {
                frameStatus += (i + 1) + ":UNSUP ";
            } else {
                frameStatus += (i + 1) + ":LOAD ";
            }
        }

        if (anyLoaded) {
            data.imageState = ImageState::Type::Loaded;
        }

        return anyLoaded;
    }

    void SetImageStateFromCached(GalleryCellData@ data, CachedImage@ cached, bool hasKey) {
        if (cached is null) {
            data.imageState = hasKey ? ImageState::Type::Loading : ImageState::Type::None;
            return;
        }

        if (cached.texture !is null) {
            @data.imageTexture = cached.texture;
            data.imageState = ImageState::Type::Loaded;
            vec2 texSize = cached.texture.GetSize();
            if (texSize.x > 0 && texSize.y > 0) {
                data.imageWidth = int(texSize.x);
                data.imageHeight = int(texSize.y);
            }
        } else if (Images::IsUnsupportedType(cached, "webm")) {
            data.imageState = ImageState::Type::WebmUnsupported;
        } else if (cached.error) {
            data.imageState = ImageState::Type::Error;
        } else {
            data.imageState = ImageState::Type::Loading;
        }
    }

    GalleryCellData@ BuildFromMediaItem(MediaItem@ item, uint index, GalleryButton@ button, array<MediaItem@>@ items = null) {
        string cacheKey = item.mediaId.Length > 0 ? item.mediaId : item.key;
        GalleryCellData@ data = null;
        bool isNewCell = false;
        if (cacheKey.Length > 0 && g_mediaItemCellCache.Exists(cacheKey)) {
            g_mediaItemCellCache.Get(cacheKey, @data);
        }
        if (data is null) {
            @data = GalleryCellData();
            data.backgroundColor = Colors::GALLERY_CELL_BG;
            data.lockedAspectRatio = false;
            isNewCell = true;
            if (cacheKey.Length > 0) g_mediaItemCellCache.Set(cacheKey, @data);
        }

        data.imageWidth = item.width;
        data.imageHeight = item.height;

        if (item.IsThumbLoaded() && item.GetThumbTexture() !is null) {
            @data.imageTexture = item.GetThumbTexture();
            data.imageState = ImageState::Type::Loaded;
        } else if (item.HasThumbRequest()) {
            if (item.IsThumbUnsupportedType("webm")) data.imageState = ImageState::Type::WebmUnsupported;
            else if (item.HasThumbError()) data.imageState = ImageState::Type::Error;
            else data.imageState = ImageState::Type::Loading;
        } else {
            if (item.key.Length > 0) startnew(ThumbnailService::RequestThumbnailForMediaItem, item);
            data.imageState = ImageState::Type::Loading;
        }

        // Handle webm animation frames (3 webp cycle)
        LoadWebpAnimationFrames(data, item.thumbKey);

        data.signSize = item.signSize;
        data.signType = item.signType;
        data.title = item.userName;
        data.subtitle = "";
        data.fileType = item.fileType;

        // Only create button adapters for new cells to avoid ref count explosion
        if (isNewCell) {
            if (item.key.Length > 0) {
                if (g_copyButton is null) @g_copyButton = CopyGalleryButton();
                data.buttons.InsertLast(items !is null ? MediaItemButtonAdapter(g_copyButton, items) : MediaItemButtonAdapter(g_copyButton, item));
            }
            if (button !is null) {
                data.buttons.InsertLast(items !is null ? MediaItemButtonAdapter(button, items) : MediaItemButtonAdapter(button, item));
            }
        }
        return data;
    }

    GalleryCellData@ BuildFromCollection(Collection@ c, uint index, CollectionGalleryButton@ button, array<Collection@>@ collections = null) {
        GalleryCellData@ data = null;
        bool isNewCell = false;
        if (c.collectionId.Length > 0 && g_collectionCellCache.Exists(c.collectionId)) {
            g_collectionCellCache.Get(c.collectionId, @data);
        }
        if (data is null) {
            @data = GalleryCellData();
            data.backgroundColor = Colors::GALLERY_CELL_BG;
            data.lockedAspectRatio = true;
            data.imageWidth = 1;
            data.imageHeight = 1;
            isNewCell = true;
            if (c.collectionId.Length > 0) g_collectionCellCache.Set(c.collectionId, @data);
        }

        // Check for unsupported formats first
        if (c.IsCoverFormatUnsupported()) {
            data.imageState = ImageState::Type::WebmUnsupported;
        } else {
            SetImageStateFromCached(data, c.cachedCover, c.HasCoverKey());
        }

        // Handle webm animation frames (3 webp cycle)
        LoadWebpAnimationFrames(data, c.coverThumbKey);

        data.title = c.collectionName.Length == 0 ? "Unnamed Collection" : c.collectionName;
        data.subtitle = c.userName.Length == 0 ? "Unknown" : c.userName;

        // Only create button adapters for new cells to avoid ref count explosion
        if (isNewCell && button !is null) {
            data.buttons.InsertLast(collections !is null ? CollectionButtonAdapter(button, collections) : CollectionButtonAdapter(button, c));
        }
        return data;
    }

    GalleryCellData@ BuildFromThemePack(ThemePack@ p, uint index, ThemePackGalleryButton@ button, array<ThemePack@>@ themePacks = null) {
        GalleryCellData@ data = null;
        bool isNewCell = false;
        if (p.themePackId.Length > 0 && g_themePackCellCache.Exists(p.themePackId)) {
            g_themePackCellCache.Get(p.themePackId, @data);
        }
        if (data is null) {
            @data = GalleryCellData();
            data.backgroundColor = Colors::GALLERY_CELL_BG;
            data.lockedAspectRatio = true;
            data.imageWidth = 1;
            data.imageHeight = 1;
            isNewCell = true;
            if (p.themePackId.Length > 0) g_themePackCellCache.Set(p.themePackId, @data);
        }

        // Check for unsupported formats first
        if (p.IsCoverFormatUnsupported()) {
            data.imageState = ImageState::Type::WebmUnsupported;
        } else {
            SetImageStateFromCached(data, p.cachedCover, p.HasCoverKey());
        }

        // Handle webm animation frames (3 webp cycle)
        LoadWebpAnimationFrames(data, p.coverThumbKey);

        data.title = p.packName.Length == 0 ? "Unnamed Theme Pack" : p.packName;
        data.subtitle = p.userName.Length == 0 ? "Unknown" : p.userName;

        // Only create button adapters for new cells to avoid ref count explosion
        if (isNewCell && button !is null) {
            data.buttons.InsertLast(themePacks !is null ? ThemePackButtonAdapter(button, themePacks) : ThemePackButtonAdapter(button, p));
        }
        return data;
    }
}
