class ApplyGalleryButton : GalleryButton {
    ApplyGalleryButton() {
        width = 32.0f;
    }
    
    bool OnClick(MediaItem@ item, uint index) override {
        if (SkinApplicationService::ApplySkinFromMediaItem(item)) {
            UI::ShowNotification("✓ TrackMedia", "Skin applied successfully!", Colors::SUCCESS, 3000);
            return true;
        }
        UI::ShowNotification(Icons::Kenney::ButtonTimes + " TrackMedia", "Failed to apply skin. Check logs for details.", Colors::ERROR, 5000);
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
        return Colors::GALLERY_BUTTON_BG_SEMI;
    }
    
    vec4 GetTextColor(MediaItem@ item, uint index) override {
        return Colors::SHADE_WHITE;
    }
    
    float GetFontSize(MediaItem@ item, uint index) override {
        return 1.0f;
    }
    
    string GetTooltip(MediaItem@ item, uint index) override {
        return "apply";
    }
    
    vec4 GetIconColor(MediaItem@ item, uint index) override {
        return Colors::SHADE_WHITE;
    }
    
    bool IsIconTopRight(MediaItem@ item, uint index) override {
        return true;
    }
}

