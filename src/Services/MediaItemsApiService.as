namespace MediaItemsApiService {
    void RequestMediaItems() {
        State::ResetMediaItemsRequest();
        
        try {
            auto json = API::GetAsync("https://api.trackmedia.io/media/latest");
            auto itemsArray = json["items"];
            State::ClearMediaItems();
            
            for (uint i = 0; i < itemsArray.Length; i++) {
                try {
                    MediaItem@ item = MediaItem(itemsArray[i]);
                    State::mediaItems.InsertLast(item);
                } catch {
                    Logging::Error("Failed to parse media item " + i + ": " + getExceptionInfo());
                }
            }
            
            State::hasRequestedMediaItems = true;
        } catch {
            State::SetMediaItemsError("Error", "Exception: " + getExceptionInfo());
            Logging::Error("RequestMediaItems exception: " + getExceptionInfo());
        }
        
        State::isRequestingMediaItems = false;
    }
}
