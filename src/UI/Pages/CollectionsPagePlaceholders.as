namespace CollectionsPagePlaceholders {
    void DrawPlaceholderImage(float size) {
        DrawPlaceholder(size, Colors::GALLERY_CELL_PLACEHOLDER_BG, "No image");
    }
    
    void DrawLoadingPlaceholder(float size) {
        DrawPlaceholder(size, Colors::GALLERY_CELL_PLACEHOLDER_BG, "Loading...");
    }
    
    void DrawErrorPlaceholder(float size) {
        DrawPlaceholder(size, Colors::ERROR_BG, "Error");
    }
    
    void DrawPlaceholder(float size, vec4 color, const string &in text) {
        UI::PushStyleColor(UI::Col::ChildBg, color);
        UI::Dummy(vec2(size, size));
        vec2 dummyPos = UI::GetCursorPos();
        UI::SetCursorPos(dummyPos - vec2(0, size));
        UI::Text(text);
        UI::SetCursorPos(dummyPos);
        UI::PopStyleColor();
    }
}

