namespace ThumbnailService {
    void RequestThumbnailForMediaItem(ref@ data) {
        MediaItem@ item = cast<MediaItem>(data);
        if (item is null || item.key.Length == 0) return;
        @item.cachedThumb = Images::CachedFromURL("https://cdn.trackmedia.io/" + item.key);
    }
    
    void RequestThumbnailForCollection(ref@ data) {
        Collection@ collection = cast<Collection>(data);
        if (collection is null) return;
        string url = collection.GetCoverUrl();
        if (url.Length == 0) return;
        @collection.cachedCover = Images::CachedFromURL(url);
    }
    
    void RequestThumbnailForThemePack(ref@ data) {
        ThemePack@ themePack = cast<ThemePack>(data);
        if (themePack is null) return;
        string url = themePack.GetCoverUrl();
        if (url.Length == 0) return;
        @themePack.cachedCover = Images::CachedFromURL(url);
    }
}
