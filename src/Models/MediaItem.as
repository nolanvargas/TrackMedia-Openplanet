class MediaItem {
    string mediaId;
    string accountId;
    string userName;
    string key;
    string thumbKey;
    int64 uploadedAt;
    string signType;
    string signSize;
    string fileType;
    int width;
    int height;
    bool liked;
    CachedImage@ cachedThumb = null;

    MediaItem() {}
    MediaItem(Json::Value@ json) {
        FromJson(json);
    }

    void FromJson(Json::Value@ json) {
        if (json is null) {
            Logging::Warn("MediaItem::FromJson called with null JSON");
            return;
        }
        try {
            mediaId = JsonUtils::SafeGetString(json, "mediaId", JsonUtils::SafeGetString(json, "media_id", ""));
            accountId = JsonUtils::SafeGetString(json, "accountId", JsonUtils::SafeGetString(json, "account_id", ""));
            userName = JsonUtils::SafeGetString(json, "userName", JsonUtils::SafeGetString(json, "user_name", ""));
            key = JsonUtils::SafeGetString(json, "key", "");
            thumbKey = JsonUtils::SafeGetString(json, "thumbKey", JsonUtils::SafeGetString(json, "thumb_key", ""));
            uploadedAt = JsonUtils::SafeGetInt64(json, "uploadedAt", JsonUtils::SafeGetInt64(json, "uploaded_at", 0));
            signType = JsonUtils::SafeGetString(json, "signType", JsonUtils::SafeGetString(json, "sign_type", ""));
            signSize = JsonUtils::SafeGetString(json, "signSize", JsonUtils::SafeGetString(json, "sign_size", ""));
            fileType = JsonUtils::SafeGetString(json, "fileType", JsonUtils::SafeGetString(json, "file_type", ""));
            
            // Safely parse width and height - they might be strings or numbers
            width = SafeGetInt(json, "width", 0);
            height = SafeGetInt(json, "height", 0);
            
            liked = JsonUtils::SafeGetBool(json, "liked", false);
        } catch {
            Logging::Error("Failed to parse MediaItem JSON: " + getExceptionInfo());
        }
    }
    
    int SafeGetInt(Json::Value@ json, const string &in key, int defaultValue) {
        if (json is null || !json.HasKey(key)) {
            return defaultValue;
        }
        try {
            auto value = json.Get(key);
            if (value.GetType() == Json::Type::Null) {
                return defaultValue;
            }
            if (value.GetType() == Json::Type::Number) {
                return int(value);
            }
            if (value.GetType() == Json::Type::String) {
                string str = value;
                if (str.Length > 0) {
                    return Text::ParseInt(str);
                }
            }
        } catch {}
        return defaultValue;
    }

    UI::Texture@ GetThumbTexture() {
        return cachedThumb !is null ? cachedThumb.texture : null;
    }

    bool IsThumbLoaded() {
        return cachedThumb !is null && cachedThumb.texture !is null;
    }

    bool HasThumbError() {
        return cachedThumb !is null && cachedThumb.error;
    }

    bool IsThumbUnsupportedType(const string &in ext) {
        return Images::IsUnsupportedType(cachedThumb, ext);
    }

    bool HasThumbRequest() {
        return cachedThumb !is null;
    }
}
