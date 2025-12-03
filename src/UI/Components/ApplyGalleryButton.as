class ApplyGalleryButton : GalleryButton {
    ApplyGalleryButton() {
        width = 32.0f;
    }
    
    bool OnClick(MediaItem@ item, uint index) override {
        if (SkinApplicationService::ApplySkinFromMediaItem(item)) {
            UI::ShowNotification("✓ TrackMedia", "Skin applied successfully!", vec4(0.2f, 0.8f, 0.2f, 1.0f), 3000);
            return true;
        }
        UI::ShowNotification(Icons::Kenney::ButtonTimes + " TrackMedia", "Failed to apply skin. Check logs for details.", vec4(0.8f, 0.2f, 0.2f, 1.0f), 5000);
        return false;
    }
    
    string GetLabel(MediaItem@ item, uint index) override {
        return Icons::Kenney::Fill;
    }
    
    bool IsEnabled(MediaItem@ item, uint index) override {
        return (State::selectedBlock !is null || State::selectedItem !is null);
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
        return "apply";
    }
    
    vec4 GetIconColor(MediaItem@ item, uint index) override {
        return vec4(1.0f, 1.0f, 1.0f, 1.0f);
    }
    
    bool IsIconTopRight(MediaItem@ item, uint index) override {
        return true;
    }
}

