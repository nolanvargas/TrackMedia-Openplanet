class CopyGalleryButton : GalleryButton {
    CopyGalleryButton() {
        width = 32.0f;
        label = Icons::Clipboard;
        backgroundColor = Colors::GALLERY_BUTTON_BG_SEMI;
        textColor = Colors::SHADE_WHITE;
        fontSize = 1.0f;
        tooltip = "copy URL";
        iconColor = Colors::SHADE_WHITE;
    }
    
    bool OnClick(MediaItem@ item, uint index) override {
        if (item.key.Length == 0) {
            UI::ShowNotification(Icons::Kenney::ButtonTimes + " TrackMedia", "No URL available to copy.", Colors::ERROR, 3000);
            return false;
        }
        IO::SetClipboard("https://cdn.trackmedia.io/" + item.key);
        UI::ShowNotification("✓ TrackMedia", "URL copied to clipboard!", Colors::SUCCESS, 2000);
        return true;
    }
    
    bool IsEnabled(MediaItem@ item, uint index) override {
        return item.key.Length > 0;
    }
}

