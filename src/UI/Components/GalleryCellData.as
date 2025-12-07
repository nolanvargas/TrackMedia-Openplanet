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
    bool IsIconTopRight(uint index);
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
    string title = "";
    string subtitle = "";
    array<ICellButton@> buttons;
}

