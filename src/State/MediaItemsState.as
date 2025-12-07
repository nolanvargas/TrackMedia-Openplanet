namespace State {
    // Media items state
    bool hasRequestedMediaItems = false;
    bool isRequestingMediaItems = false;
    string mediaItemsRequestStatus = "Not requested";
    string mediaItemsResponse = "";
    int mediaItemsStatusCode = 0;
    array<MediaItem@> mediaItems;
}
