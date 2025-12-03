namespace JsonUtils {
    string SafeGetString(Json::Value@ json, const string &in key, const string &in defaultValue = "") {
        if (json is null || !json.HasKey(key) || json.Get(key).GetType() == Json::Type::Null) {
            return defaultValue;
        }
        return json.Get(key, defaultValue);
    }

    int64 SafeGetInt64(Json::Value@ json, const string &in key, int64 defaultValue = 0) {
        if (json is null || !json.HasKey(key) || json.Get(key).GetType() == Json::Type::Null) {
            return defaultValue;
        }
        return json.Get(key, defaultValue);
    }

    bool SafeGetBool(Json::Value@ json, const string &in key, bool defaultValue = false) {
        if (json is null || !json.HasKey(key) || json.Get(key).GetType() == Json::Type::Null) {
            return defaultValue;
        }
        return json.Get(key, defaultValue);
    }
}

