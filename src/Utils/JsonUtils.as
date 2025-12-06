namespace JsonUtils {
    string SafeGetString(Json::Value@ json, const string &in key, const string &in defaultValue = "") {
        if (json is null) return defaultValue;
        if (!json.HasKey(key)) return defaultValue;
        try {
            auto value = json.Get(key);
            if (value.GetType() == Json::Type::Null) return defaultValue;
            if (value.GetType() == Json::Type::String) return string(value);
            return tostring(value);
        } catch {
            return defaultValue;
        }
    }

    int64 SafeGetInt64(Json::Value@ json, const string &in key, int64 defaultValue = 0) {
        if (json is null) return defaultValue;
        if (!json.HasKey(key)) return defaultValue;
        try {
            auto value = json.Get(key);
            if (value.GetType() == Json::Type::Null) return defaultValue;
            if (value.GetType() == Json::Type::Number) return int64(value);
            if (value.GetType() == Json::Type::String) {
                string str = value;
                if (str.Length > 0) {
                    return Text::ParseInt(str);
                }
            }
        } catch {}
        return defaultValue;
    }

    bool SafeGetBool(Json::Value@ json, const string &in key, bool defaultValue = false) {
        if (json is null) return defaultValue;
        if (!json.HasKey(key)) return defaultValue;
        try {
            auto value = json.Get(key);
            if (value.GetType() == Json::Type::Null) return defaultValue;
            if (value.GetType() == Json::Type::Number) return int64(value) != 0;
            if (value.GetType() == Json::Type::String) {
                string str = string(value);
                return str == "true" || str == "1" || str == "True" || str == "TRUE";
            }
        } catch {}
        return defaultValue;
    }
}