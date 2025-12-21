namespace HomePage {
    void RenderCard(const string &in id, const string &in icon, const string &in title, const string &in description, vec2 size) {
        if (UI::BeginChild(id, size, true)) {
            UI::PushFontSize(18.0f);
            UI::Text(icon);
            UI::PopFontSize();
            UI::SameLine();
            UI::SetCursorPos(UI::GetCursorPos() + vec2(8, 0));
            UI::PushFontSize(16.0f);
            UI::Text(title);
            UI::PopFontSize();
            UI::Dummy(vec2(0, 8));
            UI::TextWrapped(description);
        }
        UI::EndChild();
    }
    
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
        vec2 cardSize = vec2(cardWidth, cardHeight);
        
        RenderCard("BrowseCard", Icons::Search, "Browse", "Search and browse all available media items.", cardSize);
        UI::SameLine();
        RenderCard("CollectionsCard", Icons::Folder, "Collections", "Organize media items into collections.", cardSize);
        UI::SameLine();
        RenderCard("ThemePacksCard", Icons::Cubes, "Theme Packs", "Browse and apply theme packs to blocks.", cardSize);
        
        UI::PopStyleVar();
    }
}
