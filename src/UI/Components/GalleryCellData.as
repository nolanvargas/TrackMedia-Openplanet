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

namespace UnsupportedPlaceholder {
    UI::Texture@ g_texture = null;
    bool g_loadAttempted = false;
    const float WIDTH = 432.0f;
    const float HEIGHT = 216.0f;
    const float ASPECT_RATIO = WIDTH / HEIGHT; // 2:1

    UI::Texture@ Get() {
        if (!g_loadAttempted) {
            g_loadAttempted = true;
            try {
                @g_texture = UI::LoadTexture("webm_unsupported.png");
            } catch {
            }
        }
        return g_texture;
    }

    float GetHeightForWidth(float width) {
        return width / ASPECT_RATIO;
    }
}

namespace ImageState {
    enum Type {
        None,
        Loading,
        Error,
        Loaded,
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

    // Chips/badges (like React's sign_size and sign_type chips)
    string signSize = "";    // e.g. "1x1", "2x1", "4x1", "6x1"
    string signType = "";    // e.g. "checkpoint", "finish", "up", "down", etc.

    string title = "";
    string subtitle = "";
    string fileType = "";  // e.g. "webm", "png", "dds" - shown as badge
    array<ICellButton@> buttons;

    bool HasChips() {
        return (signSize.Length > 0 && signSize != "N/A") || (signType.Length > 0 && signType != "N/A");
    }
}

