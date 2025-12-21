namespace SkinPreviewService {
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
}

