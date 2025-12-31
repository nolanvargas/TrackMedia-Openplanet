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
        mediaId = string(json["media_id"]);
        accountId = string(json["account_id"]);
        userName = string(json["user_name"]);
        key = string(json["key"]);
        thumbKey = string(json["thumb_key"]);
        uploadedAt = int64(json["uploaded_at"]);
        signType = string(json["sign_type"]);
        signSize = string(json["sign_size"]);
        fileType = string(json["file_type"]);
        width = int(json["width"]);
        height = int(json["height"]);
        liked = bool(json["liked"]);
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
