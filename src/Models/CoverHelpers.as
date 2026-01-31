// Shared cover image handling for Collection and ThemePack classes
namespace CoverHelpers {
    const string CDN_BASE = "https://cdn.trackmedia.io/";

    UI::Texture@ GetTexture(CachedImage@ cached) {
        return cached !is null ? cached.texture : null;
    }

    bool IsLoaded(CachedImage@ cached) {
        return cached !is null && cached.texture !is null;
    }

    bool HasError(CachedImage@ cached) {
        return cached !is null && cached.error;
    }

    bool IsUnsupportedType(CachedImage@ cached, const string &in ext) {
        return Images::IsUnsupportedType(cached, ext);
    }

    bool HasRequest(CachedImage@ cached) {
        return cached !is null;
    }

    bool IsUnsupportedFormat(const string &in key) {
        return FileUtils::IsUnsupportedFormat(key);
    }

    string GetUrl(const string &in coverKey, const string &in coverThumbKey, bool allowExternalFallback = true) {
        // External resources have full URLs in coverThumbKey
        if (coverThumbKey.StartsWith("http")) {
            if (!IsUnsupportedFormat(coverThumbKey)) return coverThumbKey;
            // External resource with unsupported format - no fallback
            if (!allowExternalFallback) return "";
        }

        // Prefer coverThumbKey unless it's webm
        if (coverThumbKey.Length > 0 && !IsUnsupportedFormat(coverThumbKey)) {
            return CDN_BASE + coverThumbKey;
        }

        // Fall back to coverKey
        if (coverKey.Length > 0 && !IsUnsupportedFormat(coverKey)) {
            return CDN_BASE + coverKey;
        }

        return "";
    }

    bool HasKey(const string &in coverKey, const string &in coverThumbKey) {
        return coverKey.Length > 0 || coverThumbKey.Length > 0;
    }

    bool IsFormatUnsupported(const string &in coverKey, const string &in coverThumbKey) {
        if (coverThumbKey.Length > 0 && IsUnsupportedFormat(coverThumbKey)) {
            if (coverKey.Length == 0 || IsUnsupportedFormat(coverKey)) {
                return true;
            }
        }
        return false;
    }

    bool IsWebm(const string &in coverKey, const string &in coverThumbKey) {
        string key = coverThumbKey.Length > 0 ? coverThumbKey : coverKey;
        return FileUtils::IsWebm(key);
    }
}
