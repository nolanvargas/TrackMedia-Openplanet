namespace CollectionsPagePlaceholders {
    void DrawPlaceholderImage(float size) {
        DrawPlaceholder(size, vec4(0.15f, 0.15f, 0.15f, 1.0f), "No image");
    }
    
    void DrawLoadingPlaceholder(float size) {
        DrawPlaceholder(size, vec4(0.15f, 0.15f, 0.15f, 1.0f), "Loading...");
    }
    
    void DrawErrorPlaceholder(float size) {
        DrawPlaceholder(size, vec4(0.2f, 0.1f, 0.1f, 1.0f), "Error");
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

