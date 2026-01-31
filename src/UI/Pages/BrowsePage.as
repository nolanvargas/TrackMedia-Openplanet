namespace BrowsePage {
    void Render(bool justActivated) {
        if (FilterBar::Render() && !State::mediaItems.isRequesting) {
            State::mediaItems.hasRequested = false;
            State::mediaItems.isRequesting = true;
            startnew(MediaItemsApiService::RequestMediaItems);
        }
        UI::Dummy(vec2(0, 4));

        if (justActivated && !State::mediaItems.hasRequested && !State::mediaItems.isRequesting) {
            State::mediaItems.isRequesting = true;
            startnew(MediaItemsApiService::RequestMediaItems);
        }

        if (UI::BeginChild("BrowseScroll", vec2(0, 0), false)) {
            if (State::allMediaItems.Length == 0) {
                if (State::mediaItems.isRequesting) {
                    PageHelpers::RenderCenteredMessage("Loading...");
                } else {
                    PageHelpers::RenderCenteredMessage("No media items found.");
                }
            } else {
                Gallery::Render(State::allMediaItems);
            }
        }
        UI::EndChild();
    }
}
