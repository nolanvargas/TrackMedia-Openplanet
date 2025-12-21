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

    // Error checking each becuase the API is still being worked on, so I need to know when a value changes type or is missing
    // OpenAPI spec is underway
    void FromJson(Json::Value@ json) {
        if (json is null) {
            Logging::Warn("ThemePack::FromJson called with null JSON");
            return;
        }
        try {
            try {
                themePackId = json.HasKey("theme_pack_id") ? string(json["theme_pack_id"]) : "";
            } catch {
                Logging::Error("Error parsing theme_pack_id: " + getExceptionInfo());
            }
            try {
                accountId = json.HasKey("account_id") ? string(json["account_id"]) : "";
            } catch {
                Logging::Error("Error parsing account_id: " + getExceptionInfo());
            }
            try {
                userName = json.HasKey("user_name")  ? string(json["user_name"]) : "";
            } catch {
                Logging::Error("Error parsing user_name: " + getExceptionInfo());
            }
            try {
                coverId = json.HasKey("cover_id") ? string(json["cover_id"]) : "";
            } catch {
                Logging::Error("Error parsing cover_id: " + getExceptionInfo());
            }
            try {
                packName = json.HasKey("pack_name")  ? string(json["pack_name"]) : "";
            } catch {
                Logging::Error("Error parsing pack_name: " + getExceptionInfo());
            }
            try {
                createdAt = json.HasKey("created_at") ? int64(json["created_at"]) : 0;
            } catch {
                Logging::Error("Error parsing created_at: " + getExceptionInfo());
            }
            try {
                isUnlisted = json.HasKey("is_unlisted")  ? bool(json["is_unlisted"]) : false;
            } catch {
                Logging::Error("Error parsing is_unlisted: " + getExceptionInfo());
            }
        } catch {
            Logging::Error("Failed to parse ThemePack JSON: " + getExceptionInfo());
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
        if (json is null) {
            Logging::Warn("ThemePack::UpdateWithFullData called with null JSON");
            return;
        }
        try {
            themePackId = string(json["theme_pack_id"]);
            accountId = string(json["account_id"]);
            packName = string(json["pack_name"]);
            createdAt = int64(json["created_at"]);
            isUnlisted = bool(json["is_unlisted"]);
            
            string newCoverId = json.HasKey("cover_id") && json["cover_id"].GetType() != Json::Type::Null ? string(json["cover_id"]) : "";
            if (newCoverId.Length > 0) {
                coverId = newCoverId;
            }
            
            signtypes.DeleteAll();
            m_totalItems = 0;
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
                                    m_totalItems++;
                                    startnew(ThumbnailService::RequestThumbnailForMediaItem, item);
                                }
                            } catch {
                                Logging::Error("Failed to parse theme pack item in size group '" + sizeKeys[i] + "'[" + j + "]: " + getExceptionInfo());
                            }
                        }
                    }
                }
            }
        } catch {
            Logging::Error("Failed to update ThemePack with full data: " + getExceptionInfo());
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