class Collection {
    string collectionId;
    string accountId;
    string userName;
    string coverKey;
    string collectionName;
    int64 createdAt;
    bool isUnlisted;
    CachedImage@ cachedCover = null;
    array<MediaItem@> items;

    Collection() {}
    Collection(Json::Value@ json) {
        FromJson(json);
    }

    void FromJson(Json::Value@ json) {
        try {
            collectionId = JsonUtils::SafeGetString(json, "collection_id");
            accountId = JsonUtils::SafeGetString(json, "account_id");
            userName = JsonUtils::SafeGetString(json, "user_name");
            coverKey = JsonUtils::SafeGetString(json, "cover_key");
            collectionName = JsonUtils::SafeGetString(json, "collection_name");
            createdAt = JsonUtils::SafeGetInt64(json, "created_at");
            isUnlisted = JsonUtils::SafeGetBool(json, "is_unlisted");
        } catch {
            warn("Error parsing Collection JSON: " + getExceptionInfo());
        }
    }

    UI::Texture@ GetCoverTexture() {
        return cachedCover !is null ? cachedCover.texture : null;
    }

    bool IsCoverLoaded() {
        return cachedCover !is null && cachedCover.texture !is null;
    }

    string GetCoverUrl() {
        if (coverKey.Length == 0) return "";
        return "https://cdn.trackmedia.io/" + coverKey;
    }
    
    void UpdateWithFullData(Json::Value@ json) {
        try {
            collectionId = JsonUtils::SafeGetString(json, "collection_id");
            accountId = JsonUtils::SafeGetString(json, "account_id");
            collectionName = JsonUtils::SafeGetString(json, "collection_name");
            createdAt = JsonUtils::SafeGetInt64(json, "created_at");
            isUnlisted = JsonUtils::SafeGetBool(json, "is_unlisted");
            string newCoverKey = JsonUtils::SafeGetString(json, "cover_key");
            if (newCoverKey.Length > 0) {
                coverKey = newCoverKey;
            }
            items.RemoveRange(0, items.Length);
            if (json.HasKey("items") && json.Get("items").GetType() == Json::Type::Array) {
                auto itemsArray = json.Get("items");
                for (uint i = 0; i < itemsArray.Length; i++) {
                    try {
                        MediaItem@ item = MediaItem(itemsArray[i]);
                        items.InsertLast(item);
                        startnew(ThumbnailService::RequestThumbnailForMediaItem, item);
                    } catch {
                        Logging::Error("Failed to parse collection item " + i + ": " + getExceptionInfo());
                    }
                }
            }
        } catch {
            Logging::Error("Error updating Collection with full data: " + getExceptionInfo());
        }
    }
}