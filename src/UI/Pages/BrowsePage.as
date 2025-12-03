namespace BrowsePage {
    void Render() {
        // Auto-fetch data if not yet requested
        if (!State::hasRequestedThumbs && !State::isRequestingThumbs) {
            startnew(ApiService::RequestThumbs);
        }

        if (State::mediaItems.Length == 0) {
            if (State::isRequestingThumbs) {
                UI::Text("Loading...");
            } else {
                UI::Text("No media items found.");
                if (UI::Button("Refresh")) {
                    startnew(ApiService::RequestThumbs);
                }
            }
            return;
        }

        // Render gallery with default apply button
        Gallery::Render(State::mediaItems);
    }
}
