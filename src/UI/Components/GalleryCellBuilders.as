namespace GalleryCellBuilders {
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
        
        GalleryCellData@ data = GalleryCellData();
        data.backgroundColor = vec4(0.25f, 0.25f, 0.25f, 1.0f);
        data.imageWidth = item.width;
        data.imageHeight = item.height;
        data.lockedAspectRatio = false;
        SetMediaItemImageState(data, item);
        data.title = item.userName;
        data.subtitle = item.signSize;
        
        if (item.key.Length > 0) {
            CopyGalleryButton@ copyButton = CopyGalleryButton();
            MediaItemButtonAdapter@ copyAdapter = (items !is null) 
                ? MediaItemButtonAdapter(copyButton, items)
                : MediaItemButtonAdapter(copyButton, item);
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
        
        GalleryCellData@ data = GalleryCellData();
        data.backgroundColor = vec4(0.25f, 0.25f, 0.25f, 1.0f);
        data.lockedAspectRatio = true;
        data.imageWidth = 1;
        data.imageHeight = 1;
        SetCollectionImageState(data, collection);
        data.title = collection.collectionName.Length == 0 ? "Unnamed Collection" : collection.collectionName;
        data.subtitle = collection.userName.Length == 0 ? "Unknown" : collection.userName;
        
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
        
        GalleryCellData@ data = GalleryCellData();
        data.backgroundColor = vec4(0.25f, 0.25f, 0.25f, 1.0f);
        data.lockedAspectRatio = true;
        data.imageWidth = 1;
        data.imageHeight = 1;
        SetThemePackImageState(data, themePack);
        data.title = themePack.packName.Length == 0 ? "Unnamed Theme Pack" : themePack.packName;
        data.subtitle = themePack.userName.Length == 0 ? "Unknown" : themePack.userName;
        
        if (button !is null) {
            ThemePackButtonAdapter@ adapter = (themePacks !is null)
                ? ThemePackButtonAdapter(button, themePacks)
                : ThemePackButtonAdapter(button, themePack);
            data.buttons.InsertLast(adapter);
        }
        
        return data;
    }
}

