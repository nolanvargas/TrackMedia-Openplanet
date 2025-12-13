namespace SkinPreviewService {
    UI::Texture@ placeholderTexture = null;
    
    string GetTempDir() {
        string tempDir = IO::FromUserGameFolder("Cache/TrackMedia/SkinPreviews");
        if (!IO::FolderExists(tempDir)) {
            IO::CreateFolder(tempDir, true);
        }
        return tempDir;
    }
    
    CachedImage@ LoadSkinPreview(const string &in cdnUrl) {
        if (cdnUrl.Length == 0) return null;
        return Images::CachedFromURL(cdnUrl);
    }
    
    bool IsPreviewLoaded(CachedImage@ cached) {
        return cached !is null && cached.texture !is null;
    }
    
    UI::Texture@ GetPreviewTexture(CachedImage@ cached) {
        return cached !is null ? cached.texture : null;
    }
    
    bool IsPreviewUnsupportedWebm(CachedImage@ cached) {
        return cached !is null && Images::IsUnsupportedType(cached, "webm");
    }
    
    // Get rid of this
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
                    print("Loaded placeholder texture: " + placeholderPaths[i]);
                    @placeholderTexture = texture;
                    return texture;
                }
            } catch {
                Logging::Debug("Failed to load placeholder texture: " + placeholderPaths[i]);
            }
        }
        return null;
    }
}

