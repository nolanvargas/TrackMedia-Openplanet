class CachedImage {
    string url;
    UI::Texture@ texture;
    int responseCode;
    bool error = false;
    bool notFound = false;
    bool unsupportedFormat = false;

    void DownloadFromURLAsync() {
        auto req = API::Get(url);
        while (!req.Finished()) {
            yield();
        }
        responseCode = req.ResponseCode();
        if (responseCode == 200) {
            string riffHeader = req.Buffer().ReadString(4);
            if (riffHeader == "RIFF") {
                req.Buffer().Seek(8);
                string formatId = req.Buffer().ReadString(4);
                if (formatId == "WEBP") {
                    req.Buffer().Seek(0);
                    auto webpReq = Net::HttpPost("https://map-monitor.xk.io/tmx/convert_webp", url);
                    while (!webpReq.Finished()) {
                        yield();
                    }
                    if (webpReq.ResponseCode() == 200) {
                        @texture = UI::LoadTexture(webpReq.Buffer());
                        if (texture.GetSize().x == 0) {
                            @texture = null;
                            error = true;
                            Logging::Warn("CachedImage: Failed to load WebP texture from " + url);
                        }
                    } else {
                        unsupportedFormat = true;
                        error = true;
                        Logging::Warn("CachedImage: WebP conversion failed for " + url + " (response code: " + webpReq.ResponseCode() + ")");
                    }
                } else if (formatId == "WEBM") {
                    unsupportedFormat = true;
                    error = true;
                    Logging::Warn("CachedImage: WebM video format not supported for " + url);
                } else {
                    unsupportedFormat = true;
                    error = true;
                    Logging::Warn("CachedImage: Unknown RIFF format (" + formatId + ") for " + url);
                }
            } else {
                req.Buffer().Seek(0);
                @texture = UI::LoadTexture(req.Buffer());
                if (texture.GetSize().x == 0) {
                    @texture = null;
                    error = true;
                    Logging::Warn("CachedImage: Failed to load texture from " + url);
                }
            }
        } else {
            notFound = (responseCode == 404);
            error = true;
            Logging::Warn("CachedImage: HTTP error " + responseCode + " for " + url);
        }
    }
}

namespace Images {
    dictionary g_cachedImages;

    CachedImage@ FindExisting(const string &in url) {
        CachedImage@ ret = null;
        g_cachedImages.Get(url, @ret);
        return ret;
    }

    CachedImage@ CachedFromURL(const string &in url) {
        auto existing = FindExisting(url);
        if (existing !is null) {
            return existing;
        }
        auto ret = CachedImage();
        ret.url = url;
        g_cachedImages.Set(url, @ret);
        startnew(CoroutineFunc(ret.DownloadFromURLAsync));
        return ret;
    }
}