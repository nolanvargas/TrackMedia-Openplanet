namespace UploadsPage {
    void Render(bool justActivated) {
        if (!SessionStorage::HasSession()) {
            PageHelpers::RenderSessionError();
            return;
        }

        if (justActivated && !State::uploads.hasRequested && !State::uploads.isRequesting) {
            State::uploads.isRequesting = true;
            startnew(RequestUploads);
        }

        UI::Dummy(vec2(0, 4));

        if (FilterBar::Render() && !State::uploads.isRequesting) {
            State::ClearUploads();
            State::uploads.isRequesting = true;
            startnew(RequestUploads);
        }
        UI::Dummy(vec2(0, 4));

        if (UI::BeginChild("UploadsScroll", vec2(0, 0), false)) {
            if (State::uploads.isRequesting) {
                UI::Text("Loading uploads...");
            } else if (State::allUploads.Length == 0) {
                UI::PushStyleColor(UI::Col::Text, Colors::TEXT_DIMMED);
                UI::Text("No uploads yet.");
                UI::PopStyleColor();
            } else {
                Gallery::Render(State::allUploads);
            }
        }
        UI::EndChild();
    }

    void RequestUploads() {
        MediaApiService::FetchMediaItems(
            "/media/uploads?limit=50" + FilterBar::BuildQueryParams(),
            State::uploads,
            State::allUploads
        );
    }
}
