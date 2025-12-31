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
        collectionId = string(json["collection_id"]);
        accountId = string(json["account_id"]);
        userName = string(json["user_name"]);
        collectionName = string(json["collection_name"]);
        createdAt = int64(json["created_at"]);
        isUnlisted = bool(json["is_unlisted"]);
        
        if (json["cover_key"].GetType() == Json::Type::Null) {
            coverKey = "";
        } else {
            coverKey = string(json["cover_key"]);
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
        collectionId = string(json["collection_id"]);
        accountId = string(json["account_id"]);
        collectionName = string(json["collection_name"]);
        createdAt = int64(json["created_at"]);
        isUnlisted = bool(json["is_unlisted"]);
        
        if (json["cover_key"].GetType() == Json::Type::Null) {
            coverKey = "";
        } else {
            coverKey = string(json["cover_key"]);
        }
        
        items.RemoveRange(0, items.Length);
        auto itemsArray = json["items"];
        for (uint i = 0; i < itemsArray.Length; i++) {
            MediaItem@ item = MediaItem(itemsArray[i]);
            items.InsertLast(item);
            startnew(ThumbnailService::RequestThumbnailForMediaItem, item);
        }
    }
}