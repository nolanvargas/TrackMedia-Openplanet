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
        return vec4(0.2f, 0.5f, 0.8f, 1.0f);
    }
    
    vec4 GetTextColor(MediaItem@ item, uint index) {
        return vec4(1.0f, 1.0f, 1.0f, 1.0f);
    }
    
    float GetFontSize(MediaItem@ item, uint index) {
        return 1.0f;
    }
    
    string GetTooltip(MediaItem@ item, uint index) {
        return "";
    }
    
    vec4 GetIconColor(MediaItem@ item, uint index) {
        return vec4(0, 0, 0, 0);
    }
    
    bool IsIconTopRight(MediaItem@ item, uint index) {
        return false;
    }
}

