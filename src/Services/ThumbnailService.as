namespace ThumbnailService {
    void RequestThumbnailForMediaItem(ref@ data) {
        MediaItem@ item = cast<MediaItem>(data);
        if (item is null || item.key.Length == 0) {
            return;
        }
        @item.cachedThumb = Images::CachedFromURL("https://cdn.trackmedia.io/" + item.key);
    }
    
    void RequestThumbnailForCollection(ref@ data) {
        Collection@ collection = cast<Collection>(data);
        if (collection is null || collection.coverKey.Length == 0) {
            return;
        }
        @collection.cachedCover = Images::CachedFromURL(collection.GetCoverUrl());
    }
    
    void RequestThumbnailForThemePack(ref@ data) {
        ThemePack@ themePack = cast<ThemePack>(data);
        if (themePack is null || themePack.coverId.Length == 0) {
            return;
        }
        @themePack.cachedCover = Images::CachedFromURL(themePack.GetCoverUrl());
    }
}
