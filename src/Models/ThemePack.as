class ThemePack {
    string themePackId;
    string accountId;
    string userName;
    string coverId;
    string packName;
    int64 createdAt;
    bool isUnlisted;
    CachedImage@ cachedCover = null;
    dictionary signtypes;

    ThemePack() {}
    ThemePack(Json::Value@ json) {
        FromJson(json);
    }

    void FromJson(Json::Value@ json) {
        try {
            themePackId = JsonUtils::SafeGetString(json, "theme_pack_id");
            accountId = JsonUtils::SafeGetString(json, "account_id");
            userName = JsonUtils::SafeGetString(json, "user_name");
            coverId = JsonUtils::SafeGetString(json, "cover_id");
            packName = JsonUtils::SafeGetString(json, "pack_name");
            createdAt = JsonUtils::SafeGetInt64(json, "created_at");
            isUnlisted = JsonUtils::SafeGetBool(json, "is_unlisted");
        } catch {
            warn("Error parsing ThemePack JSON: " + getExceptionInfo());
        }
    }

    UI::Texture@ GetCoverTexture() {
        return cachedCover !is null ? cachedCover.texture : null;
    }

    bool IsCoverLoaded() {
        return cachedCover !is null && cachedCover.texture !is null;
    }

    string GetCoverUrl() {
        if (coverId.Length == 0) return "";
        return "https://cdn.trackmedia.io/" + coverId;
    }
    
    void UpdateWithFullData(Json::Value@ json) {
        try {
            themePackId = JsonUtils::SafeGetString(json, "theme_pack_id");
            accountId = JsonUtils::SafeGetString(json, "account_id");
            packName = JsonUtils::SafeGetString(json, "pack_name");
            createdAt = JsonUtils::SafeGetInt64(json, "created_at");
            isUnlisted = JsonUtils::SafeGetBool(json, "is_unlisted");
            string newCoverId = JsonUtils::SafeGetString(json, "cover_id");
            if (newCoverId.Length > 0) {
                coverId = newCoverId;
            }
            signtypes.DeleteAll();
            if (json.HasKey("itemsBySize") && json.Get("itemsBySize").GetType() == Json::Type::Object) {
                auto itemsBySizeObj = json.Get("itemsBySize");
                array<string> sizeKeys = itemsBySizeObj.GetKeys();
                for (uint i = 0; i < sizeKeys.Length; i++) {
                    auto sizeValue = itemsBySizeObj.Get(sizeKeys[i]);
                    if (sizeValue.GetType() == Json::Type::Array) {
                        for (uint j = 0; j < sizeValue.Length; j++) {
                            try {
                                MediaItem@ item = MediaItem(sizeValue[j]);
                                string itemSignType = item.signType;
                                if (itemSignType.Length == 0) continue;
                                array<MediaItem@>@ signTypeItems;
                                if (!signtypes.Exists(itemSignType)) {
                                    array<MediaItem@> newArray;
                                    signtypes[itemSignType] = newArray;
                                }
                                signtypes.Get(itemSignType, @signTypeItems);
                                if (signTypeItems !is null) {
                                    signTypeItems.InsertLast(item);
                                }
                                startnew(ThumbnailService::RequestThumbnailForMediaItem, item);
                            } catch {
                                Logging::Error("Failed to parse theme pack item in size group '" + sizeKeys[i] + "'[" + j + "]: " + getExceptionInfo());
                            }
                        }
                    }
                }
            }
        } catch {
            Logging::Error("Error updating ThemePack with full data: " + getExceptionInfo());
        }
    }
    
    array<MediaItem@>@ GetSignTypeItems(const string &in signType) {
        if (!signtypes.Exists(signType)) {
            return null;
        }
        array<MediaItem@>@ items;
        signtypes.Get(signType, @items);
        return items;
    }
    
    array<string> GetSignTypeKeys() {
        return signtypes.GetKeys();
    }
}