class CopyGalleryButton : GalleryButton {
    CopyGalleryButton() {
        width = 32.0f;
    }
    
    bool OnClick(MediaItem@ item, uint index) override {
        if (item is null || item.key.Length == 0) {
            UI::ShowNotification(Icons::Kenney::ButtonTimes + " TrackMedia", "No URL available to copy.", vec4(0.8f, 0.2f, 0.2f, 1.0f), 3000);
            return false;
        }
        
        IO::SetClipboard("https://cdn.trackmedia.io/" + item.key);
        UI::ShowNotification("✓ TrackMedia", "URL copied to clipboard!", vec4(0.2f, 0.8f, 0.2f, 1.0f), 2000);
        return true;
    }
    
    string GetLabel(MediaItem@ item, uint index) override {
        return Icons::Clipboard;
    }
    
    bool IsEnabled(MediaItem@ item, uint index) override {
        return (item !is null && item.key.Length > 0);
    }
    
    float GetWidth(MediaItem@ item, uint index) override {
        return width;
    }
    
    vec4 GetBackgroundColor(MediaItem@ item, uint index) override {
        return vec4(0.3f, 0.3f, 0.3f, 0.6f);
    }
    
    vec4 GetTextColor(MediaItem@ item, uint index) override {
        return vec4(1.0f, 1.0f, 1.0f, 1.0f);
    }
    
    float GetFontSize(MediaItem@ item, uint index) override {
        return 1.0f;
    }
    
    string GetTooltip(MediaItem@ item, uint index) override {
        return "copy URL";
    }
    
    vec4 GetIconColor(MediaItem@ item, uint index) override {
        return vec4(1.0f, 1.0f, 1.0f, 1.0f);
    }
    
    bool IsIconTopRight(MediaItem@ item, uint index) override {
        return false;
    }
}

