namespace AuthService {
    void Authenticate() {
        if (SessionStorage::HasSession()) { return; }

        // Get the auth token from Openplanet
        auto tokenTask = Auth::GetToken();
        while (!tokenTask.Finished()) { yield(); }
        string token = tokenTask.Token();

        if (token.Length == 0) {
            Logging::Error("Failed to get Openplanet auth token - token is empty");
            return;
        }
        string url = API::API_BASE_URL + "/auth/plugin?token=" + token;
        auto response = API::PostAsync(url);
        if (response.GetType() == Json::Type::Null) {
            Logging::Error("Auth request failed - no response");
            return;
        }
        if (!JsonHelpers::GetBool(response, "success", false)) {
            Logging::Error("Auth failed - server returned success=false");
            return;
        }
        SessionStorage::Save(
            JsonHelpers::GetString(response, "sessionId", ""),
            JsonHelpers::GetString(response, "displayName", ""),
            Time::Stamp + JsonHelpers::GetInt(response, "maxAge", 0)
        );
    }
}
