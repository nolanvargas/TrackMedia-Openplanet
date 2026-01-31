namespace UserApiService {
    void RequestUserOverview() {
        string displayName = SessionStorage::GetDisplayName();
        if (displayName.Length == 0) {
            State::userOverview.SetError("Not logged in");
            State::userOverview.Complete();
            return;
        }

        State::userOverview.Reset();
        State::ClearUserOverview();

        string url = API::API_BASE_URL + "/user/" + Net::UrlEncode(displayName);
        auto json = API::GetAsync(url);

        if (json.GetType() == Json::Type::Null) {
            State::userOverview.SetError("Request failed");
            State::userOverview.Complete();
            return;
        }

        if (json.HasKey("media") && json["media"].GetType() == Json::Type::Array) {
            auto arr = json["media"];
            for (uint i = 0; i < arr.Length; i++) {
                MediaItem@ item = MediaItem(arr[i]);
                State::userMedia.InsertLast(item);
                startnew(ThumbnailService::RequestThumbnailForMediaItem, item);
            }
        }

        if (json.HasKey("collections") && json["collections"].GetType() == Json::Type::Array) {
            auto arr = json["collections"];
            for (uint i = 0; i < arr.Length; i++) {
                Collection@ c = Collection(arr[i]);
                State::userCollections.InsertLast(c);
                startnew(ThumbnailService::RequestThumbnailForCollection, c);
            }
        }

        if (json.HasKey("theme_packs") && json["theme_packs"].GetType() == Json::Type::Array) {
            auto arr = json["theme_packs"];
            for (uint i = 0; i < arr.Length; i++) {
                ThemePack@ p = ThemePack(arr[i]);
                State::userThemePacks.InsertLast(p);
                startnew(ThumbnailService::RequestThumbnailForThemePack, p);
            }
        }

        State::userOverview.SetSuccess();
        State::userOverview.Complete();
    }
}
