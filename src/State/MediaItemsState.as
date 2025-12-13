namespace State {
    // Media items state
    bool hasRequestedMediaItems = false;
    bool isRequestingMediaItems = false;
    string mediaItemsRequestStatus = "Not requested";
    array<MediaItem@> mediaItems;

    void ClearMediaItems() {
        mediaItems.RemoveRange(0, mediaItems.Length);
    }
    
    void ResetMediaItemsRequest() {
        isRequestingMediaItems = true;
        mediaItemsRequestStatus = "Requesting...";
    }
    
    void SetMediaItemsError(const string &in status, const string &in response = "") {
        mediaItemsRequestStatus = status;
        hasRequestedMediaItems = true;
        isRequestingMediaItems = false;
    }
    
    void SetMediaItemsRequestComplete() {
        hasRequestedMediaItems = true;
        isRequestingMediaItems = false;
    }
}
