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
        if (json is null) {
            Logging::Warn("Collection::FromJson called with null JSON");
            return;
        }
        try {
            try {
                collectionId = json.HasKey("collection_id") && json["collection_id"].GetType() != Json::Type::Null ? string(json["collection_id"]) : "";
            } catch {
                Logging::Error("Error parsing collection_id: " + getExceptionInfo());
            }
            try {
                accountId = json.HasKey("account_id") && json["account_id"].GetType() != Json::Type::Null ? string(json["account_id"]) : "";
            } catch {
                Logging::Error("Error parsing account_id: " + getExceptionInfo());
            }
            try {
                userName = json.HasKey("user_name") && json["user_name"].GetType() != Json::Type::Null ? string(json["user_name"]) : "";
            } catch {
                Logging::Error("Error parsing user_name: " + getExceptionInfo());
            }
            try {
                coverKey = json.HasKey("cover_key") && json["cover_key"].GetType() != Json::Type::Null ? string(json["cover_key"]) : "";
            } catch {
                Logging::Error("Error parsing cover_key: " + getExceptionInfo());
            }
            try {
                collectionName = json.HasKey("collection_name") && json["collection_name"].GetType() != Json::Type::Null ? string(json["collection_name"]) : "";
            } catch {
                Logging::Error("Error parsing collection_name: " + getExceptionInfo());
            }
            try {
                createdAt = json.HasKey("created_at") && json["created_at"].GetType() != Json::Type::Null ? int64(json["created_at"]) : 0;
            } catch {
                Logging::Error("Error parsing created_at: " + getExceptionInfo());
            }
            try {
                isUnlisted = json.HasKey("is_unlisted") && json["is_unlisted"].GetType() != Json::Type::Null ? bool(json["is_unlisted"]) : false;
            } catch {
                Logging::Error("Error parsing is_unlisted: " + getExceptionInfo());
            }
        } catch {
            Logging::Error("Failed to parse Collection JSON: " + getExceptionInfo());
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
        if (coverKey.Length == 0) return "";
        return "https://cdn.trackmedia.io/" + coverKey;
    }
    
    void UpdateWithFullData(Json::Value@ json) {
        if (json is null) {
            Logging::Warn("Collection::UpdateWithFullData called with null JSON");
            return;
        }
        try {
            collectionId = string(json["collection_id"]);
            accountId = string(json["account_id"]);
            collectionName = string(json["collection_name"]);
            createdAt = int64(json["created_at"]);
            isUnlisted = bool(json["is_unlisted"]);
            
            string newCoverKey = json.HasKey("cover_key") && json["cover_key"].GetType() != Json::Type::Null ? string(json["cover_key"]) : "";
            coverKey = newCoverKey.Length > 0 ? newCoverKey : "";
            
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
            Logging::Error("Failed to update Collection with full data: " + getExceptionInfo());
        }
    }
}