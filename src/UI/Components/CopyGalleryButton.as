class CopyGalleryButton : GalleryButton {
    CopyGalleryButton() {
        width = 32.0f;
    }
    
    bool OnClick(MediaItem@ item, uint index) override {
        if (item is null || item.key.Length == 0) {
            UI::ShowNotification(Icons::Kenney::ButtonTimes + " TrackMedia", "No URL available to copy.", Colors::ERROR, 3000);
            return false;
        }
        
        IO::SetClipboard("https://cdn.trackmedia.io/" + item.key);
        UI::ShowNotification("✓ TrackMedia", "URL copied to clipboard!", Colors::SUCCESS, 2000);
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
        return Colors::GALLERY_BUTTON_BG_SEMI;
    }
    
    vec4 GetTextColor(MediaItem@ item, uint index) override {
        return Colors::SHADE_WHITE;
    }
    
    float GetFontSize(MediaItem@ item, uint index) override {
        return 1.0f;
    }
    
    string GetTooltip(MediaItem@ item, uint index) override {
        return "copy URL";
    }
    
    vec4 GetIconColor(MediaItem@ item, uint index) override {
        return Colors::SHADE_WHITE;
    }
    
    bool IsIconTopRight(MediaItem@ item, uint index) override {
        return false;
    }
}

