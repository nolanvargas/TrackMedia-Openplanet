class ApplyGalleryButton : GalleryButton {
    ApplyGalleryButton() {
        width = 32.0f;
        label = Icons::Kenney::Fill;
        backgroundColor = Colors::GALLERY_BUTTON_BG_SEMI;
        textColor = Colors::SHADE_WHITE;
        fontSize = 1.0f;
        tooltip = "apply";
        iconColor = Colors::SHADE_WHITE;
    }
    
    bool OnClick(MediaItem@ item, uint index) override {
        if (SkinApplicationService::ApplySkinFromMediaItem(item)) {
            return true;
        }
        UI::ShowNotification(Icons::Kenney::ButtonTimes + " TrackMedia", "Failed to apply skin. Check logs for details.", Colors::ERROR, 5000);
        return false;
    }
    
    bool IsEnabled(MediaItem@ item, uint index) override {
        return (State::selectedBlock !is null || State::selectedItem !is null);
    }
}

