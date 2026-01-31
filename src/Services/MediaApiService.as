namespace MediaApiService {
    void FetchMediaItems(const string &in endpoint, RequestState@ state, array<MediaItem@>@ results) {
        state.Reset();
        auto req = API::Get(API::API_BASE_URL + endpoint);
        if (req is null) { state.SetError("Request failed"); return; }

        while (!req.Finished()) yield();
        if (req.ResponseCode() != 200) { state.SetError("HTTP " + req.ResponseCode()); return; }

        Json::Value json;
        try { json = Json::Parse(req.String()); }
        catch { state.SetError("JSON parse error"); return; }
        if (json.GetType() == Json::Type::Null) { state.SetError("Empty response"); return; }

        results.Resize(0);
        for (uint i = 0; i < json.Length; i++) {
            auto item = MediaItem(json[i]);
            results.InsertLast(item);
            ThumbnailService::RequestThumbnailForMediaItem(item);
        }

        state.SetSuccess();
        state.Complete();
    }
}
