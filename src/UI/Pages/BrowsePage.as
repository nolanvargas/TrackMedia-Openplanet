namespace BrowsePage {
    void Render(bool justActivated) {
        // Only fetch data when page is first activated
        if (justActivated && !State::hasRequestedMediaItems && !State::isRequestingMediaItems) {
            State::isRequestingMediaItems = true;
            startnew(MediaItemsApiService::RequestMediaItems);
        }

        if (State::mediaItems.Length == 0) {
            if (State::isRequestingMediaItems) {
                UI::Text("Loading...");
            } else {
                UI::Text("No media items found.");
                if (UI::Button("Refresh")) {
                    State::hasRequestedMediaItems = false;
                    State::isRequestingMediaItems = true;
                    startnew(MediaItemsApiService::RequestMediaItems);
                }
            }
            return;
        }

        Gallery::Render(State::mediaItems);
    }
}
