namespace MediaItemsApiService {
    const int LIMIT = 30;

    void RequestMediaItems() {
        State::mediaItems.Reset();

        auto json = API::GetAsync(
            API::API_BASE_URL + "/media/latest?limit=" + LIMIT + FilterBar::BuildQueryParams()
        );
        if (json.GetType() == Json::Type::Null) { State::mediaItems.SetError("Error"); return; }

        State::ClearMediaItems();
        for (uint i = 0; i < json.Length; i++)
            State::allMediaItems.InsertLast(MediaItem(json[i]));

        State::mediaItems.Complete();
    }
}
