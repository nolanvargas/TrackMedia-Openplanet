class CachedImage {
    string url;
    UI::Texture@ texture;
    int responseCode;
    bool error = false;
    bool unsupportedFormat = false;

    void DownloadFromURLAsync() {
        if (url.Length == 0) {
            error = true;
            Logging::Warn("CachedImage: Empty URL " + url);
            return;
        }

        if (FileUtils::IsFileType(url, "webm")) {
            unsupportedFormat = true;
            return;
        }

        Net::HttpRequest@ req = API::Get(url);
        if (req is null) {
            error = true;
            Logging::Warn("CachedImage: Could not create request for " + url);
            return;
        }

        while (!req.Finished()) yield();

        responseCode = req.ResponseCode();
        if (responseCode != 200) {
            error = true;
            Logging::Warn("CachedImage: HTTP " + responseCode + " for " + url);
            return;
        }

        auto buffer = req.Buffer();
        uint64 bufferSize = buffer.GetSize();
        buffer.Seek(0);
        @texture = UI::LoadTexture(buffer);
        if (texture is null || texture.GetSize().x == 0) {
            @texture = null;
            error = true;
            Logging::Warn("CachedImage: Failed to load texture from " + url + " (buffer size: " + bufferSize + ")");
        }
    }
}

namespace Images {
    // LRU cache with max 200 images, evicts 20 at a time when full
    LRUCache@ g_imageCache = LRUCache(200, 20);

    CachedImage@ FindExisting(const string &in url) {
        return cast<CachedImage>(g_imageCache.Get(url));
    }

    CachedImage@ CachedFromURL(const string &in url) {
        CachedImage@ existing = cast<CachedImage>(g_imageCache.Get(url));
        if (existing !is null) return existing;

        auto created = CachedImage();
        created.url = url;
        g_imageCache.Set(url, @created);
        startnew(CoroutineFunc(created.DownloadFromURLAsync));
        return created;
    }

    bool IsUnsupportedType(CachedImage@ cached, const string &in ext) {
        return cached !is null && cached.unsupportedFormat && cached.texture is null && FileUtils::IsFileType(cached.url, ext);
    }
}
