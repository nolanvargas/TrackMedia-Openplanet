namespace HomePage {
    void Render() {
        UI::PushStyleVar(UI::StyleVar::WindowPadding, vec2(20, 20));
        
        // Welcome section
        UI::PushFontSize(24.0f);
        UI::Text("Welcome to TrackMedia");
        UI::PopFontSize();
        
        UI::Dummy(vec2(0, 16));
        
        UI::PushFontSize(16.0f);
        UI::TextWrapped("Browse and manage your media items, collections, and theme packs for Trackmania.");
        UI::PopFontSize();
        
        UI::Dummy(vec2(0, 32));
        
        // Quick navigation cards
        float cardWidth = (UI::GetContentRegionAvail().x - 20) / 3;
        float cardHeight = 120.0f;
        
        // Browse card
        if (UI::BeginChild("BrowseCard", vec2(cardWidth, cardHeight), true)) {
            UI::PushFontSize(18.0f);
            UI::Text(Icons::Search);
            UI::PopFontSize();
            UI::SameLine();
            UI::SetCursorPos(UI::GetCursorPos() + vec2(8, 0));
            UI::PushFontSize(16.0f);
            UI::Text("Browse");
            UI::PopFontSize();
            UI::Dummy(vec2(0, 8));
            UI::TextWrapped("Search and browse all available media items.");
        }
        UI::EndChild();
        
        UI::SameLine();
        
        // Collections card
        if (UI::BeginChild("CollectionsCard", vec2(cardWidth, cardHeight), true)) {
            UI::PushFontSize(18.0f);
            UI::Text(Icons::Folder);
            UI::PopFontSize();
            UI::SameLine();
            UI::SetCursorPos(UI::GetCursorPos() + vec2(8, 0));
            UI::PushFontSize(16.0f);
            UI::Text("Collections");
            UI::PopFontSize();
            UI::Dummy(vec2(0, 8));
            UI::TextWrapped("Organize media items into collections.");
        }
        UI::EndChild();
        
        UI::SameLine();
        
        // Theme Packs card
        if (UI::BeginChild("ThemePacksCard", vec2(cardWidth, cardHeight), true)) {
            UI::PushFontSize(18.0f);
            UI::Text(Icons::Cubes);
            UI::PopFontSize();
            UI::SameLine();
            UI::SetCursorPos(UI::GetCursorPos() + vec2(8, 0));
            UI::PushFontSize(16.0f);
            UI::Text("Theme Packs");
            UI::PopFontSize();
            UI::Dummy(vec2(0, 8));
            UI::TextWrapped("Browse and apply theme packs to blocks.");
        }
        UI::EndChild();
        
        UI::PopStyleVar();
    }
}
