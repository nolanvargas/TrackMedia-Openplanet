namespace JsonHelpers {
    string GetString(Json::Value@ json, const string &in key, const string &in defaultValue = "") {
        if (json is null || !json.HasKey(key)) return defaultValue;
        auto val = json[key];
        if (val.GetType() == Json::Type::Null) return defaultValue;
        if (val.GetType() != Json::Type::String) {
            warn("[TrackMedia] JsonHelpers::GetString - Key '" + key + "' is not a string, got: " + tostring(val.GetType()));
            return defaultValue;
        }
        return string(val);
    }

    int64 GetInt64(Json::Value@ json, const string &in key, int64 defaultValue = 0) {
        if (json is null || !json.HasKey(key)) return defaultValue;
        auto val = json[key];
        if (val.GetType() == Json::Type::Null) return defaultValue;
        if (val.GetType() == Json::Type::Number) {
            return int64(val);
        }
        if (val.GetType() == Json::Type::String) {
            return Text::ParseInt64(string(val));
        }
        warn("[TrackMedia] JsonHelpers::GetInt64 - Key '" + key + "' is not a number or string, got: " + tostring(val.GetType()));
        return defaultValue;
    }

    bool GetBool(Json::Value@ json, const string &in key, bool defaultValue = false) {
        if (json is null || !json.HasKey(key)) return defaultValue;
        auto val = json[key];
        if (val.GetType() == Json::Type::Null) return defaultValue;
        if (val.GetType() != Json::Type::Boolean) {
            warn("[TrackMedia] JsonHelpers::GetBool - Key '" + key + "' is not a boolean, got: " + tostring(val.GetType()));
            return defaultValue;
        }
        return bool(val);
    }

    int GetInt(Json::Value@ json, const string &in key, int defaultValue = 0) {
        if (json is null || !json.HasKey(key)) return defaultValue;
        auto val = json[key];
        if (val.GetType() == Json::Type::Null) return defaultValue;
        if (val.GetType() != Json::Type::Number) {
            warn("[TrackMedia] JsonHelpers::GetInt - Key '" + key + "' is not a number, got: " + tostring(val.GetType()));
            return defaultValue;
        }
        return int(val);
    }
}
