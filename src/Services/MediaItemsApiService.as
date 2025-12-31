namespace MediaItemsApiService {
    void RequestMediaItems() {
        RequestMediaItemsWithParams("", 20);
    }

    void RequestMediaItemsWithParams(const string &in after = "", int limit = 20) {
        State::ResetMediaItemsRequest();
        
        string url = API::API_BASE_URL + "/media/latest?limit=" + limit;
        if (after.Length > 0) {
            url += "&after=" + after;
        }
        
        auto json = API::GetAsync(url);
        if (json.GetType() == Json::Type::Null) {
            State::SetMediaItemsError("Error", "");
            State::isRequestingMediaItems = false;
            return;
        }
        
        State::ClearMediaItems();
        
        for (uint i = 0; i < json.Length; i++) {
            MediaItem@ item = MediaItem(json[i]);
            State::mediaItems.InsertLast(item);
        }
        
        State::hasRequestedMediaItems = true;
        
        State::isRequestingMediaItems = false;
    }
}
