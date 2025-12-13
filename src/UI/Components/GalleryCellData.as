interface ICellButton {
    string GetLabel(uint index);
    bool IsEnabled(uint index);
    bool OnClick(uint index);
    float GetWidth(uint index);
    vec4 GetBackgroundColor(uint index);
    vec4 GetTextColor(uint index);
    float GetFontSize(uint index);
    string GetTooltip(uint index);
    vec4 GetIconColor(uint index);
}

namespace ImageState {
    enum Type {
        None,
        Loading,
        Error,
        Loaded,
        WebpUnsupported,
        WebmUnsupported
    }
}

class GalleryCellData {
    vec4 backgroundColor = Colors::GALLERY_CELL_BG;
    UI::Texture@ imageTexture = null;
    ImageState::Type imageState = ImageState::Type::None;
    int imageWidth = 0;
    int imageHeight = 0;
    bool lockedAspectRatio = false;

    // Optional animation frames for thumbnails (e.g. webm thumb_key mapped to 3 webp frames)
    array<UI::Texture@> animationFrames;
    bool hasAnimationFrames = false;
    uint animationCurrentFrame = 0;
    uint64 animationLastSwitchTime = 0;
    float animationIntervalMs = 660.0f; // 0.66 seconds per frame

    string title = "";
    string subtitle = "";
    array<ICellButton@> buttons;
}

