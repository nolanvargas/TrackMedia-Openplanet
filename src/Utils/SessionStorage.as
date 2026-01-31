namespace SessionStorage {
    string g_sessionId = "";
    string g_displayName = "";
    int64 g_expiresAt = 0;
    bool g_loaded = false;

    void Load() {
        if (g_loaded) return;
        g_loaded = true;
        string filePath = IO::FromStorageFolder("session.json");
        if (!IO::FileExists(filePath)) return;
        try {
            Json::Value@ root = Json::FromFile(filePath);
            if (root is null) return;
            g_sessionId = JsonHelpers::GetString(root, "sessionId", "");
            g_displayName = JsonHelpers::GetString(root, "displayName", "");
            g_expiresAt = JsonHelpers::GetInt64(root, "expiresAt", 0);
        } catch {
            Logging::Error("Failed to load session: " + getExceptionInfo());
        }
    }

    void Save(const string &in sessionId, const string &in displayName, int64 expiresAt) {
        g_sessionId = sessionId;
        g_displayName = displayName;
        g_expiresAt = expiresAt;
        g_loaded = true;
        Json::Value root = Json::Object();
        root["sessionId"] = sessionId;
        root["displayName"] = displayName;
        root["expiresAt"] = expiresAt;
        string filePath = IO::FromStorageFolder("session.json");
        try {
            Json::ToFile(filePath, root);
        } catch {
            Logging::Error("Failed to save session: " + getExceptionInfo());
        }
    }

    void Clear() {
        g_sessionId = "";
        g_displayName = "";
        g_expiresAt = 0;
        string filePath = IO::FromStorageFolder("session.json");
        if (IO::FileExists(filePath)) {
            IO::Delete(filePath);
        }
    }

    string GetSessionId() {
        Load();
        if (g_sessionId.Length == 0) return "";
        if (Time::Stamp >= g_expiresAt) {
            Clear();
            return "";
        }
        return g_sessionId;
    }

    bool HasSession() {
        return GetSessionId().Length > 0;
    }

    string GetDisplayName() {
        Load();
        if (g_sessionId.Length == 0 || Time::Stamp >= g_expiresAt) {
            return "";
        }
        return g_displayName;
    }
}
