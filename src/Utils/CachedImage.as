class CachedImage {
    string url;
    UI::Texture@ texture;
    int responseCode;
    bool error = false;
    bool notFound = false;
    bool unsupportedFormat = false;

    void DownloadFromURLAsync() {
        if (url.Length == 0) {
            error = true;
            Logging::Warn("CachedImage: Empty URL " + url);
            return;
        }

        if (FileUtils::IsFileType(url, "webp") || FileUtils::IsFileType(url, "webm")) {
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
            notFound = responseCode == 404;
            error = true;
            Logging::Warn("CachedImage: HTTP " + responseCode + " for " + url);
            return;
        }

        req.Buffer().Seek(0);
        @texture = UI::LoadTexture(req.Buffer());
        if (texture is null || texture.GetSize().x == 0) {
            @texture = null;
            error = true;
            Logging::Warn("CachedImage: Failed to load texture from " + url);
        }
    }
}

namespace Images {
    dictionary g_cachedImages;

    CachedImage@ FindExisting(const string &in url) {
        CachedImage@ img;
        g_cachedImages.Get(url, @img);
        return img;
    }

    CachedImage@ CachedFromURL(const string &in url) {
        CachedImage@ existing;
        g_cachedImages.Get(url, @existing);
        if (existing !is null) return existing;
        auto created = CachedImage();
        created.url = url;
        g_cachedImages.Set(url, @created);
        startnew(CoroutineFunc(created.DownloadFromURLAsync));
        return created;
    }

    bool IsUnsupportedType(CachedImage@ cached, const string &in ext) {
        return cached !is null && cached.unsupportedFormat && cached.texture is null && FileUtils::IsFileType(cached.url, ext);
    }
}
