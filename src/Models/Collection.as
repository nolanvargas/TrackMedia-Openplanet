class Collection : BaseEntity {
    string collectionId;
    string coverKey;
    string coverThumbKey;
    string collectionName;
    string externalUrl;
    bool isExternal = false;
    CachedImage@ cachedCover = null;
    array<MediaItem@> items;

    Collection() {}
    Collection(Json::Value@ json) { FromJson(json); }

    void FromJson(Json::Value@ json) {
        if (json.GetType() != Json::Type::Object) return;

        ParseBaseFields(json);

        collectionId = JsonHelpers::GetString(json, "collection_id");
        collectionName = JsonHelpers::GetString(json, "collection_name");
        coverKey = JsonHelpers::GetString(json, "cover_key");
        coverThumbKey = JsonHelpers::GetString(json, "cover_thumb_key");
        externalUrl = JsonHelpers::GetString(json, "external_url");
        isExternal = externalUrl.Length > 0 || collectionId.Length == 0;
    }

    // BaseEntity overrides
    string GetId() override { return collectionId; }
    string GetDisplayName() override { return collectionName; }

    UI::Texture@ GetCoverTexture() { return CoverHelpers::GetTexture(cachedCover); }
    bool IsCoverLoaded() { return CoverHelpers::IsLoaded(cachedCover); }
    bool HasCoverError() { return CoverHelpers::HasError(cachedCover); }
    bool IsCoverUnsupportedType(const string &in ext) { return CoverHelpers::IsUnsupportedType(cachedCover, ext); }
    bool HasCoverRequest() { return CoverHelpers::HasRequest(cachedCover); }
    string GetCoverUrl() { return CoverHelpers::GetUrl(coverKey, coverThumbKey); }
    bool HasCoverKey() { return CoverHelpers::HasKey(coverKey, coverThumbKey); }
    bool IsCoverFormatUnsupported() { return CoverHelpers::IsFormatUnsupported(coverKey, coverThumbKey); }
    bool IsCoverWebm() { return CoverHelpers::IsWebm(coverKey, coverThumbKey); }

    void UpdateWithFullData(Json::Value@ json) {
        if (json.GetType() != Json::Type::Object) return;
        FromJson(json);

        items.Resize(0);
        if (json.HasKey("items") && json["items"].GetType() == Json::Type::Array) {
            auto arr = json["items"];
            for (uint i = 0; i < arr.Length; i++) {
                MediaItem@ item = MediaItem(arr[i]);
                items.InsertLast(item);
                startnew(ThumbnailService::RequestThumbnailForMediaItem, item);
            }
        }
    }
}
