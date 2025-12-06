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
            Logging::Warn("CachedImage: Empty URL");
            return;
        }
        
        auto req = API::Get(url);
        if (req is null) {
            error = true;
            Logging::Warn("CachedImage: Failed to create request for " + url);
            return;
        }
        
        while (!req.Finished()) {
            yield();
        }
        
        responseCode = req.ResponseCode();
        if (responseCode != 200) {
            notFound = (responseCode == 404);
            error = true;
            Logging::Warn("CachedImage: HTTP " + responseCode + " for " + url);
            return;
        }
        
        string riffHeader = req.Buffer().ReadString(4);
        if (riffHeader == "RIFF") {
            // RIFF format: bytes 8-11 contain the format identifier
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
                    if (texture is null || texture.GetSize().x == 0) {
                        @texture = null;
                        error = true;
                        Logging::Warn("CachedImage: Failed to load WebP texture from " + url);
                    }
                } else {
                    unsupportedFormat = true;
                    error = true;
                    Logging::Warn("CachedImage: WebP conversion failed (HTTP " + webpReq.ResponseCode() + ")");
                }
            } else if (formatId == "WEBM") {
                unsupportedFormat = true;
                error = true;
                Logging::Warn("CachedImage: WebM format not supported");
            } else {
                // For other RIFF formats or malformed files, try loading directly
                req.Buffer().Seek(0);
                @texture = UI::LoadTexture(req.Buffer());
                if (texture is null || texture.GetSize().x == 0) {
                    @texture = null;
                    unsupportedFormat = true;
                    error = true;
                    Logging::Warn("CachedImage: Unknown or unsupported RIFF format: " + formatId);
                }
            }
        } else {
            req.Buffer().Seek(0);
            @texture = UI::LoadTexture(req.Buffer());
            if (texture is null || texture.GetSize().x == 0) {
                @texture = null;
                error = true;
                Logging::Warn("CachedImage: Failed to load texture from " + url);
            }
        }
    }
}

namespace Images {
    dictionary g_cachedImages;

    CachedImage@ FindExisting(const string &in url) {
        if (url.Length == 0) {
            return null;
        }
        CachedImage@ ret = null;
        g_cachedImages.Get(url, @ret);
        return ret;
    }

    CachedImage@ CachedFromURL(const string &in url) {
        if (url.Length == 0) {
            Logging::Warn("Images::CachedFromURL called with empty URL");
            return null;
        }
        
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