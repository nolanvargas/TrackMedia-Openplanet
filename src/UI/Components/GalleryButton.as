class GalleryButton {
    float width = 100.0f;
    string label = "Button";
    vec4 backgroundColor = Colors::GALLERY_BUTTON_BG;
    vec4 textColor = Colors::SHADE_WHITE;
    float fontSize = 1.0f;
    string tooltip = "";
    vec4 iconColor = Colors::TRANSPARENT;
    
    bool OnClick(MediaItem@ item, uint index) {
        return false;
    }
    
    bool IsEnabled(MediaItem@ item, uint index) {
        return true;
    }
}

