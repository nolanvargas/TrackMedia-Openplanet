class ThemePack : BaseEntity {
    string themePackId;
    string coverId;
    string coverKey;
    string coverThumbKey;
    string packName;
    CachedImage@ cachedCover = null;
    dictionary signtypes;
    uint m_totalItems = 0;

    ThemePack() {}
    ThemePack(Json::Value@ json) { FromJson(json); }

    void FromJson(Json::Value@ json) {
        if (json.GetType() != Json::Type::Object) return;

        ParseBaseFields(json);

        themePackId = JsonHelpers::GetString(json, "theme_pack_id");
        packName = JsonHelpers::GetString(json, "pack_name");
        coverId = JsonHelpers::GetString(json, "cover_id");
        coverKey = JsonHelpers::GetString(json, "cover_key");
        coverThumbKey = JsonHelpers::GetString(json, "cover_thumb_key");
    }

    // BaseEntity overrides
    string GetId() override { return themePackId; }
    string GetDisplayName() override { return packName; }

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

        signtypes.DeleteAll();
        m_totalItems = 0;

        array<string> sizes = {"1x1", "2x1", "4x1", "6x1"};
        for (uint s = 0; s < sizes.Length; s++) {
            if (json[sizes[s]].GetType() != Json::Type::Array) continue;
            auto arr = json[sizes[s]];
            if (arr.Length == 0) continue;

            array<MediaItem@> sizeItems;
            for (uint i = 0; i < arr.Length; i++) {
                MediaItem@ item = MediaItem(arr[i]);
                sizeItems.InsertLast(item);
                m_totalItems++;
                startnew(ThumbnailService::RequestThumbnailForMediaItem, item);
            }
            signtypes[sizes[s]] = sizeItems;
        }
    }

    array<MediaItem@>@ GetSignTypeItems(const string &in signType) {
        if (signType.Length == 0 || !signtypes.Exists(signType)) return null;
        array<MediaItem@>@ items;
        signtypes.Get(signType, @items);
        return items;
    }

    array<string> GetSignTypeKeys() {
        array<string> keys = signtypes.GetKeys();
        // Simple bubble sort for small arrays
        for (uint i = 0; i < keys.Length; i++) {
            for (uint j = i + 1; j < keys.Length; j++) {
                if (keys[i] > keys[j]) {
                    string t = keys[i];
                    keys[i] = keys[j];
                    keys[j] = t;
                }
            }
        }
        return keys;
    }

    uint GetTotalItems() { return m_totalItems; }
}
