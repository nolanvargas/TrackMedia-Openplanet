// Base button style properties shared across all button types
class ButtonStyle {
    string label = "Button";
    float width = 100.0f;
    vec4 backgroundColor = Colors::GALLERY_BUTTON_BG;
    vec4 textColor = Colors::WHITE;
    float fontSize = 1.0f;
    string tooltip = "";
    vec4 iconColor = Colors::TRANSPARENT;
}

// Shared base for "Open" style buttons
class OpenGalleryButton : ButtonStyle {
    OpenGalleryButton() {
        label = "Open";
        width = -1.0f;
        backgroundColor = Colors::ACTIVE;
        textColor = vec4(0, 0, 0, 1);
    }
}

class GalleryButton : ButtonStyle {
    bool OnClick(MediaItem@ item, uint index) { return false; }
    bool IsEnabled(MediaItem@ item, uint index) { return true; }
}

class CollectionGalleryButton : OpenGalleryButton {
    bool OnClick(Collection@ c, uint index) {
        PageHelpers::OpenCollectionTab(c);
        return true;
    }
    bool IsEnabled(Collection@ c, uint index) { return true; }
}

class ThemePackGalleryButton : OpenGalleryButton {
    bool OnClick(ThemePack@ p, uint index) {
        PageHelpers::OpenThemePackTab(p);
        return true;
    }
    bool IsEnabled(ThemePack@ p, uint index) { return true; }
}

// Base adapter with common property delegation
class BaseButtonAdapter : ICellButton {
    protected ButtonStyle@ style;

    string GetLabel(uint i) override { return style.label; }
    float GetWidth(uint i) override { return style.width; }
    vec4 GetBackgroundColor(uint i) override { return style.backgroundColor; }
    vec4 GetTextColor(uint i) override { return style.textColor; }
    float GetFontSize(uint i) override { return style.fontSize; }
    string GetTooltip(uint i) override { return style.tooltip; }
    vec4 GetIconColor(uint i) override { return style.iconColor; }

    bool IsEnabled(uint i) override { return true; }
    bool OnClick(uint i) override { return false; }
}

class MediaItemButtonAdapter : BaseButtonAdapter {
    GalleryButton@ button;
    MediaItem@ item;
    array<MediaItem@>@ items;

    MediaItemButtonAdapter(GalleryButton@ btn, MediaItem@ m) { @button = btn; @style = btn; @item = m; }
    MediaItemButtonAdapter(GalleryButton@ btn, array<MediaItem@>@ arr) { @button = btn; @style = btn; @items = arr; }

    MediaItem@ Get(uint i) { return item !is null ? item : (items !is null && i < items.Length ? items[i] : null); }

    bool IsEnabled(uint i) override { auto@ m = Get(i); return m !is null && button.IsEnabled(m, i); }
    bool OnClick(uint i) override { auto@ m = Get(i); return m !is null && button.OnClick(m, i); }
}

class CollectionButtonAdapter : BaseButtonAdapter {
    CollectionGalleryButton@ button;
    Collection@ collection;
    array<Collection@>@ collections;

    CollectionButtonAdapter(CollectionGalleryButton@ btn, Collection@ c) { @button = btn; @style = btn; @collection = c; }
    CollectionButtonAdapter(CollectionGalleryButton@ btn, array<Collection@>@ arr) { @button = btn; @style = btn; @collections = arr; }

    Collection@ Get(uint i) { return collection !is null ? collection : (collections !is null && i < collections.Length ? collections[i] : null); }

    bool IsEnabled(uint i) override { auto@ c = Get(i); return c !is null && button.IsEnabled(c, i); }
    bool OnClick(uint i) override { auto@ c = Get(i); return c !is null && button.OnClick(c, i); }
}

class ThemePackButtonAdapter : BaseButtonAdapter {
    ThemePackGalleryButton@ button;
    ThemePack@ themePack;
    array<ThemePack@>@ themePacks;

    ThemePackButtonAdapter(ThemePackGalleryButton@ btn, ThemePack@ p) { @button = btn; @style = btn; @themePack = p; }
    ThemePackButtonAdapter(ThemePackGalleryButton@ btn, array<ThemePack@>@ arr) { @button = btn; @style = btn; @themePacks = arr; }

    ThemePack@ Get(uint i) { return themePack !is null ? themePack : (themePacks !is null && i < themePacks.Length ? themePacks[i] : null); }

    bool IsEnabled(uint i) override { auto@ p = Get(i); return p !is null && button.IsEnabled(p, i); }
    bool OnClick(uint i) override { auto@ p = Get(i); return p !is null && button.OnClick(p, i); }
}
