namespace LikedPage {
    void Render(bool justActivated) {
        if (!SessionStorage::HasSession()) {
            PageHelpers::RenderSessionError();
            return;
        }

        if (justActivated && !State::likedMedia.hasRequested && !State::likedMedia.isRequesting) {
            State::likedMedia.isRequesting = true;
            startnew(RequestLikedMedia);
        }

        UI::Dummy(vec2(0, 4));

        if (FilterBar::Render() && !State::likedMedia.isRequesting) {
            State::ClearLikedMedia();
            State::likedMedia.isRequesting = true;
            startnew(RequestLikedMedia);
        }
        UI::Dummy(vec2(0, 4));

        if (UI::BeginChild("LikedScroll", vec2(0, 0), false)) {
            if (State::likedMedia.isRequesting) {
                UI::Text("Loading liked media...");
            } else if (State::allLikedMedia.Length == 0) {
                UI::PushStyleColor(UI::Col::Text, Colors::TEXT_DIMMED);
                UI::Text("No liked media yet.");
                UI::PopStyleColor();
            } else {
                Gallery::Render(State::allLikedMedia);
            }
        }
        UI::EndChild();
    }

    void RequestLikedMedia() {
        MediaApiService::FetchMediaItems(
            "/media/liked?limit=50" + FilterBar::BuildQueryParams(),
            State::likedMedia,
            State::allLikedMedia
        );
    }
}
