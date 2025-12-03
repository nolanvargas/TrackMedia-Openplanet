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
        try {
            mediaId = json.Get("mediaId", json.Get("media_id", ""));
            accountId = json.Get("accountId", json.Get("account_id", ""));
            userName = json.Get("userName", json.Get("user_name", ""));
            key = json.Get("key", "");
            thumbKey = json.Get("thumbKey", json.Get("thumb_key", ""));
            uploadedAt = json.Get("uploadedAt", json.Get("uploaded_at", 0));
            signType = json.Get("signType", json.Get("sign_type", ""));
            signSize = json.Get("signSize", json.Get("sign_size", ""));
            fileType = json.Get("fileType", json.Get("file_type", ""));
            width = json.Get("width", 0);
            height = json.Get("height", 0);
            liked = json.Get("liked", false);
        } catch {
            warn("Error parsing MediaItem JSON");
        }
    }

    UI::Texture@ GetThumbTexture() {
        return cachedThumb !is null ? cachedThumb.texture : null;
    }

    bool IsThumbLoaded() {
        return cachedThumb !is null && cachedThumb.texture !is null;
    }
}
