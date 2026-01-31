namespace StatsApiService {
    void RequestStats() {
        State::stats.Reset();
        string url = API::API_BASE_URL + "/stats";
        auto json = API::GetAsync(url);

        if (json.GetType() == Json::Type::Null) {
            State::stats.SetError("Failed to fetch stats");
            State::stats.Complete();
            return;
        }

        State::statsMediaCount = JsonHelpers::GetInt(json, "media");
        State::statsCollectionsCount = JsonHelpers::GetInt(json, "collections");
        State::statsThemePacksCount = JsonHelpers::GetInt(json, "themePacks");

        State::stats.SetSuccess();
        State::stats.Complete();
    }
}
