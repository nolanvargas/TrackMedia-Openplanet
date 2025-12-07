namespace JsonUtils {

    bool has(Json::Value@ json, const string &in key) {
        return json !is null && json.HasKey(key);
    }

    string SafeGetString(Json::Value@ json, const string &in key, const string &in def = "") {
        if (!has(json, key)) return def;
        Json::Value val = json[key];

        try {
            if (val.GetType() == Json::Type::String) return string(val);
            if (val.GetType() == Json::Type::Null) return def;
            return tostring(val);
        } catch {
            return def;
        }
    }

    int64 SafeGetInt64(Json::Value@ json, const string &in key, int64 def = 0) {
        if (!has(json, key)) return def;
        Json::Value val = json[key];

        try {
            if (val.GetType() == Json::Type::Number) return int64(val);
            if (val.GetType() == Json::Type::String) return Text::ParseInt(string(val));
        } catch {}

        return def;
    }

    bool SafeGetBool(Json::Value@ json, const string &in key, bool def = false) {
        if (!has(json, key)) return def;
        Json::Value val = json[key];

        try {
            if (val.GetType() == Json::Type::Number) return int64(val) != 0;
            if (val.GetType() == Json::Type::String) {
                string s = string(val);
                return s == "true" || s == "1" || s == "True" || s == "TRUE";
            }
        } catch {}

        return def;
    }
}
