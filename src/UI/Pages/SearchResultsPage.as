namespace SearchResultsPage {
    void Render(const string &in returnPage) {
        // Back button and search info header
        UI::PushStyleColor(UI::Col::Button, Colors::BUTTON);
        UI::PushStyleColor(UI::Col::ButtonHovered, Colors::BUTTON_HOVERED);
        UI::PushStyleColor(UI::Col::ButtonActive, Colors::ACTIVE);
        UI::PushStyleColor(UI::Col::HeaderActive, Colors::ACTIVE);
        UI::PushStyleColor(UI::Col::Text, Colors::WHITE);
        if (UI::Button(Icons::ArrowLeft + " Back")) {
            State::ClearSearch();
        }
        UI::PopStyleColor(5);

        UI::SameLine();
        UI::PushStyleColor(UI::Col::Text, Colors::TEXT_DIMMED);
        UI::Text("Search results for: ");
        UI::PopStyleColor();
        UI::SameLine();
        UI::PushStyleColor(UI::Col::Text, Colors::WHITE);
        UI::Text("\"" + State::searchQuery + "\"");
        UI::PopStyleColor();

        UI::Dummy(vec2(0, 8));

        if (UI::BeginChild("SearchScroll", vec2(0, 0), false)) {
            if (State::isSearching) {
                PageHelpers::RenderCenteredMessage("Searching...");
            } else {
                uint totalResults = State::searchResultsMedia.Length +
                                   State::searchResultsCollections.Length +
                                   State::searchResultsThemePacks.Length;

                if (totalResults == 0) {
                    PageHelpers::RenderCenteredMessage("No results found.");
                } else {
                    // Collections section
                    if (State::searchResultsCollections.Length > 0) {
                        RenderSection("Collections", State::searchResultsCollections.Length);
                        Gallery::Render(State::searchResultsCollections);
                        UI::Dummy(vec2(0, 16));
                    }

                    // Theme Packs section
                    if (State::searchResultsThemePacks.Length > 0) {
                        RenderSection("Theme Packs", State::searchResultsThemePacks.Length);
                        Gallery::Render(State::searchResultsThemePacks);
                        UI::Dummy(vec2(0, 16));
                    }

                    // Media section
                    if (State::searchResultsMedia.Length > 0) {
                        RenderSection("Media", State::searchResultsMedia.Length);
                        Gallery::Render(State::searchResultsMedia);
                    }
                }
            }
        }
        UI::EndChild();
    }

    void RenderSection(const string &in title, uint count) {
        UI::PushStyleColor(UI::Col::Text, Colors::WHITE);
        UI::Text(title);
        UI::PopStyleColor();
        UI::SameLine();
        UI::PushStyleColor(UI::Col::Text, Colors::TEXT_DIMMED);
        UI::Text("(" + count + ")");
        UI::PopStyleColor();
        UI::Dummy(vec2(0, 4));
    }
}
