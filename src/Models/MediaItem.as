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

    // Error checking each becuase the API is still being worked on, so I need to know when a value changes type or is missing
    // OpenAPI spec is underway
    void FromJson(Json::Value@ json) {
        if (json is null) {
            Logging::Warn("MediaItem::FromJson called with null JSON");
            return;
        }
        try {
            try {
                mediaId = json.HasKey("media_id") && json["media_id"].GetType() != Json::Type::Null ? string(json["media_id"]) : "";
            } catch {
                Logging::Error("Error parsing media_id: " + getExceptionInfo());
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
                key = json.HasKey("key") && json["key"].GetType() != Json::Type::Null ? string(json["key"]) : "";
            } catch {
                Logging::Error("Error parsing key: " + getExceptionInfo());
            }
            try {
                thumbKey = json.HasKey("thumb_key") && json["thumb_key"].GetType() != Json::Type::Null ? string(json["thumb_key"]) : "";
            } catch {
                Logging::Error("Error parsing thumb_key: " + getExceptionInfo());
            }
            try {
                if (json.HasKey("uploaded_at") && json["uploaded_at"].GetType() != Json::Type::Null) {
                    if (json["uploaded_at"].GetType() == Json::Type::String) {
                        uploadedAt = Text::ParseInt64(string(json["uploaded_at"]));
                    } else {
                        uploadedAt = int64(json["uploaded_at"]);
                    }
                } else {
                    uploadedAt = 0;
                }
            } catch {
                Logging::Error("Error parsing uploaded_at: " + getExceptionInfo());
            }
            try {
                signType = json.HasKey("sign_type") && json["sign_type"].GetType() != Json::Type::Null ? string(json["sign_type"]) : "";
            } catch {
                Logging::Error("Error parsing sign_type: " + getExceptionInfo());
            }
            try {
                signSize = json.HasKey("sign_size") && json["sign_size"].GetType() != Json::Type::Null ? string(json["sign_size"]) : "";
            } catch {
                Logging::Error("Error parsing sign_size: " + getExceptionInfo());
            }
            try {
                fileType = json.HasKey("file_type") && json["file_type"].GetType() != Json::Type::Null ? string(json["file_type"]) : "";
            } catch {
                Logging::Error("Error parsing file_type: " + getExceptionInfo());
            }
            try {
                width = json.HasKey("width") && json["width"].GetType() != Json::Type::Null ? int(json["width"]) : 0;
            } catch {
                Logging::Error("Error parsing width: " + getExceptionInfo());
            }
            try {
                height = json.HasKey("height") && json["height"].GetType() != Json::Type::Null ? int(json["height"]) : 0;
            } catch {
                Logging::Error("Error parsing height: " + getExceptionInfo());
            }
            try {
                liked = json.HasKey("liked") && json["liked"].GetType() != Json::Type::Null ? bool(json["liked"]) : false;
            } catch {
                Logging::Error("Error parsing liked: " + getExceptionInfo());
            }
        } catch {
            Logging::Error("Failed to parse MediaItem JSON: " + getExceptionInfo());
        }
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
