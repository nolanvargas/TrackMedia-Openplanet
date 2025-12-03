namespace SkinPreviewService {
    dictionary textureCache;
    UI::Texture@ placeholderTexture = null;
    
    string GetTempDir() {
        string tempDir = IO::FromUserGameFolder("Cache/TrackMedia/SkinPreviews");
        if (!IO::FolderExists(tempDir)) {
            IO::CreateFolder(tempDir, true);
        }
        return tempDir;
    }
    
    UI::Texture@ GetCachedTexture(const string &in cdnUrl) {
        if (textureCache.Exists(cdnUrl)) {
            UI::Texture@ cached = cast<UI::Texture@>(textureCache[cdnUrl]);
            if (cached !is null) {
                return cached;
            }
        }
        return null;
    }
    
    void CacheTexture(const string &in cdnUrl, UI::Texture@ texture) {
        @textureCache[cdnUrl] = texture;
    }
    
    CachedImage@ LoadSkinPreview(const string &in cdnUrl) {
        if (cdnUrl.Length == 0) return null;
        return Images::CachedFromURL(cdnUrl);
    }
    
    void ClearCache() {
        textureCache.DeleteAll();
    }
    
    UI::Texture@ GetPlaceholderTexture() {
        if (placeholderTexture !is null) {
            return placeholderTexture;
        }
        array<string> placeholderPaths = {
            "placeholder.png",
            "assets/placeholder.png",
            "PreviewPlaceholder.png",
            "assets/PreviewPlaceholder.png"
        };
        for (uint i = 0; i < placeholderPaths.Length; i++) {
            try {
                UI::Texture@ texture = UI::LoadTexture(placeholderPaths[i]);
                if (texture !is null) {
                    @placeholderTexture = texture;
                    return texture;
                }
            } catch {}
        }
        return null;
    }
    
    CachedImage@ LoadSkinPreviewWithPlaceholder(const string &in cdnUrl) {
        return LoadSkinPreview(cdnUrl);
    }
}

