class MediaItem : BaseEntity {
    string mediaId;
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
    MediaItem(Json::Value@ json) { FromJson(json); }

    void FromJson(Json::Value@ json) {
        if (json.GetType() != Json::Type::Object) return;

        ParseBaseFields(json);

        mediaId = JsonHelpers::GetString(json, "media_id");
        key = JsonHelpers::GetString(json, "key");
        thumbKey = JsonHelpers::GetString(json, "thumb_key");
        uploadedAt = JsonHelpers::GetInt64(json, "uploaded_at");
        signType = JsonHelpers::GetString(json, "sign_type");
        signSize = JsonHelpers::GetString(json, "sign_size");
        fileType = JsonHelpers::GetString(json, "file_type");
        width = JsonHelpers::GetInt(json, "width");
        height = JsonHelpers::GetInt(json, "height");
        liked = JsonHelpers::GetBool(json, "liked");
    }

    // BaseEntity overrides
    string GetId() override { return mediaId; }
    string GetDisplayName() override { return userName; }

    UI::Texture@ GetThumbTexture() { return cachedThumb !is null ? cachedThumb.texture : null; }
    bool IsThumbLoaded() { return cachedThumb !is null && cachedThumb.texture !is null; }
    bool HasThumbError() { return cachedThumb !is null && cachedThumb.error; }
    bool IsThumbUnsupportedType(const string &in ext) { return Images::IsUnsupportedType(cachedThumb, ext); }
    bool HasThumbRequest() { return cachedThumb !is null; }
}
