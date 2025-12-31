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
    uint m_totalItems = 0;

    ThemePack() {}
    ThemePack(Json::Value@ json) {
        FromJson(json);
    }

    void FromJson(Json::Value@ json) {
        themePackId = string(json["theme_pack_id"]);
        accountId = string(json["account_id"]);
        userName = string(json["user_name"]);
        packName = string(json["pack_name"]);
        createdAt = int64(json["created_at"]);
        isUnlisted = bool(json["is_unlisted"]);
        
        if (json["cover_id"].GetType() == Json::Type::Null) {
            coverId = "";
        } else {
            coverId = string(json["cover_id"]);
        }
    }

    UI::Texture@ GetCoverTexture() {
        return cachedCover !is null ? cachedCover.texture : null;
    }

    bool IsCoverLoaded() {
        return cachedCover !is null && cachedCover.texture !is null;
    }

    bool HasCoverError() {
        return cachedCover !is null && cachedCover.error;
    }

    bool IsCoverUnsupportedType(const string &in ext) {
        return Images::IsUnsupportedType(cachedCover, ext);
    }

    bool HasCoverRequest() {
        return cachedCover !is null;
    }

    string GetCoverUrl() {
        if (coverId.Length == 0) return "";
        return "https://cdn.trackmedia.io/" + coverId;
    }
    
    void UpdateWithFullData(Json::Value@ json) {
        themePackId = string(json["theme_pack_id"]);
        accountId = string(json["account_id"]);
        packName = string(json["pack_name"]);
        createdAt = int64(json["created_at"]);
        isUnlisted = bool(json["is_unlisted"]);
        
        if (json["cover_id"].GetType() == Json::Type::Null) {
            coverId = "";
        } else {
            coverId = string(json["cover_id"]);
        }
        
        signtypes.DeleteAll();
        m_totalItems = 0;
        auto itemsArray = json["items"];
        for (uint i = 0; i < itemsArray.Length; i++) {
            MediaItem@ item = MediaItem(itemsArray[i]);
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
                m_totalItems++;
                startnew(ThumbnailService::RequestThumbnailForMediaItem, item);
            }
        }
    }
    
    array<MediaItem@>@ GetSignTypeItems(const string &in signType) {
        if (signType.Length == 0 || !signtypes.Exists(signType)) {
            return null;
        }
        array<MediaItem@>@ items;
        signtypes.Get(signType, @items);
        return items;
    }
    
    array<string> GetSignTypeKeys() {
        array<string> keys = signtypes.GetKeys();
        // Sort sign type keys alphabetically
        for (uint i = 0; i < keys.Length; i++) {
            for (uint j = i + 1; j < keys.Length; j++) {
                if (keys[i] > keys[j]) {
                    string temp = keys[i];
                    keys[i] = keys[j];
                    keys[j] = temp;
                }
            }
        }
        return keys;
    }
    
    uint GetTotalItems() {
        return m_totalItems;
    }
}