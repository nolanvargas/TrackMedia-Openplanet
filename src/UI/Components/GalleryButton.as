class GalleryButton {
    float width = 100.0f;
    
    bool OnClick(MediaItem@ item, uint index) {
        return false;
    }
    
    string GetLabel(MediaItem@ item, uint index) {
        return "Button";
    }
    
    bool IsEnabled(MediaItem@ item, uint index) {
        return true;
    }
    
    float GetWidth(MediaItem@ item, uint index) {
        return width;
    }
    
    vec4 GetBackgroundColor(MediaItem@ item, uint index) {
        return Colors::GALLERY_BUTTON_BG;
    }
    
    vec4 GetTextColor(MediaItem@ item, uint index) {
        return Colors::SHADE_WHITE;
    }
    
    float GetFontSize(MediaItem@ item, uint index) {
        return 1.0f;
    }
    
    string GetTooltip(MediaItem@ item, uint index) {
        return "";
    }
    
    vec4 GetIconColor(MediaItem@ item, uint index) {
        return Colors::TRANSPARENT;
    }
    
    bool IsIconTopRight(MediaItem@ item, uint index) {
        return false;
    }
}

