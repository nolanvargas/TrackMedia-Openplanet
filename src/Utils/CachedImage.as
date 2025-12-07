class CachedImage {
    string url;
    UI::Texture@ texture;
    int responseCode;
    bool error = false;
    bool notFound = false;
    bool unsupportedFormat = false;

    void fail(const string &in msg) {
        error = true;
        Logging::Warn(msg + " " + url);
    }

    void loadTexture(Net::HttpRequest@ req) {
        req.Buffer().Seek(0);
        @texture = UI::LoadTexture(req.Buffer());
        if (texture is null || texture.GetSize().x == 0) {
            @texture = null;
            fail("CachedImage: Failed to load texture from");
        }
    }

    void DownloadFromURLAsync() {
        if (url.Length == 0) {
            fail("CachedImage: Empty URL");
            return;
        }

        if (FileUtils::IsFileType(url, "webp") || FileUtils::IsFileType(url, "webm")) {
            unsupportedFormat = true;
            return;
        }

        Net::HttpRequest@ req = API::Get(url);
        if (req is null) {
            fail("CachedImage: Could not create request for");
            return;
        }

        while (!req.Finished()) yield();

        responseCode = req.ResponseCode();
        if (responseCode != 200) {
            notFound = responseCode == 404;
            fail("CachedImage: HTTP " + responseCode + " for");
            return;
        }

        loadTexture(req);
    }
}

namespace Images {
    dictionary g_cachedImages;

    CachedImage@ FindExisting(const string &in url) {
        if (url.Length == 0) return null;
        CachedImage@ img;
        g_cachedImages.Get(url, @img);
        return img;
    }

    CachedImage@ CachedFromURL(const string &in url) {
        if (url.Length == 0) {
            Logging::Warn("Images::CachedFromURL called with empty URL");
            return null;
        }

        auto existing = FindExisting(url);
        if (existing !is null) return existing;

        auto created = CachedImage();
        created.url = url;
        g_cachedImages.Set(url, @created);
        startnew(CoroutineFunc(created.DownloadFromURLAsync));
        return created;
    }

    bool IsUnsupportedType(CachedImage@ cached, const string &in ext) {
        if (cached is null) return false;
        if (!cached.unsupportedFormat) return false;
        if (cached.texture !is null) return false;
        return FileUtils::IsFileType(cached.url, ext);
    }
}
