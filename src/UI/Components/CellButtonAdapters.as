class GalleryButton {
    float width = 100.0f;
    string label = "Button";
    vec4 backgroundColor = Colors::GALLERY_BUTTON_BG;
    vec4 textColor = Colors::SHADE_WHITE;
    float fontSize = 1.0f;
    string tooltip = "";
    vec4 iconColor = Colors::TRANSPARENT;
    
    bool OnClick(MediaItem@ item, uint index) {
        return false;
    }
    
    bool IsEnabled(MediaItem@ item, uint index) {
        return true;
    }
}

class CollectionGalleryButton {
    string label = "Open";
    float width = -1.0f;
    vec4 backgroundColor = Colors::GALLERY_COLLECTION_BUTTON_BG;
    vec4 textColor = Colors::SHADE_BLACK;
    float fontSize = 1.0f;
    string tooltip = "";
    vec4 iconColor = Colors::TRANSPARENT;
    
    bool OnClick(Collection@ collection, uint index) {
        PageHelpers::OpenCollectionTab(collection);
        return true;
    }
    
    bool IsEnabled(Collection@ collection, uint index) {
        return true;
    }
}

class ThemePackGalleryButton {
    string label = "Open";
    float width = -1.0f;
    vec4 backgroundColor = Colors::GALLERY_COLLECTION_BUTTON_BG;
    vec4 textColor = Colors::SHADE_BLACK;
    float fontSize = 1.0f;
    string tooltip = "";
    vec4 iconColor = Colors::TRANSPARENT;
    
    bool OnClick(ThemePack@ themePack, uint index) {
        PageHelpers::OpenThemePackTab(themePack);
        return true;
    }
    
    bool IsEnabled(ThemePack@ themePack, uint index) {
        return true;
    }
}

class MediaItemButtonAdapter : ICellButton {
    GalleryButton@ button;
    MediaItem@ item;
    array<MediaItem@>@ items;
    
    MediaItemButtonAdapter(GalleryButton@ btn, MediaItem@ mediaItem) {
        @button = btn;
        @item = mediaItem;
    }
    
    MediaItemButtonAdapter(GalleryButton@ btn, array<MediaItem@>@ itemsArray) {
        @button = btn;
        @items = itemsArray;
    }
    
    MediaItem@ GetTargetItem(uint index) {
        if (item !is null) return item;
        if (index < items.Length) return items[index];
        return null;
    }
    
    string GetLabel(uint index) override { return button.label; }
    bool IsEnabled(uint index) override { return button.IsEnabled(GetTargetItem(index), index); }
    bool OnClick(uint index) override { return button.OnClick(GetTargetItem(index), index); }
    float GetWidth(uint index) override { return button.width; }
    vec4 GetBackgroundColor(uint index) override { return button.backgroundColor; }
    vec4 GetTextColor(uint index) override { return button.textColor; }
    float GetFontSize(uint index) override { return button.fontSize; }
    string GetTooltip(uint index) override { return button.tooltip; }
    vec4 GetIconColor(uint index) override { return button.iconColor; }
}

class CollectionButtonAdapter : ICellButton {
    CollectionGalleryButton@ button;
    Collection@ collection;
    array<Collection@>@ collections;
    
    CollectionButtonAdapter(CollectionGalleryButton@ btn, Collection@ coll) {
        @button = btn;
        @collection = coll;
    }
    
    CollectionButtonAdapter(CollectionGalleryButton@ btn, array<Collection@>@ collectionsArray) {
        @button = btn;
        @collections = collectionsArray;
    }
    
    Collection@ GetTargetCollection(uint index) {
        if (collection !is null) return collection;
        if (index < collections.Length) return collections[index];
        return null;
    }
    
    string GetLabel(uint index) override { return button.label; }
    bool IsEnabled(uint index) override { return button.IsEnabled(GetTargetCollection(index), index); }
    bool OnClick(uint index) override { return button.OnClick(GetTargetCollection(index), index); }
    float GetWidth(uint index) override { return button.width; }
    vec4 GetBackgroundColor(uint index) override { return button.backgroundColor; }
    vec4 GetTextColor(uint index) override { return button.textColor; }
    float GetFontSize(uint index) override { return button.fontSize; }
    string GetTooltip(uint index) override { return button.tooltip; }
    vec4 GetIconColor(uint index) override { return button.iconColor; }
}

class ThemePackButtonAdapter : ICellButton {
    ThemePackGalleryButton@ button;
    ThemePack@ themePack;
    array<ThemePack@>@ themePacks;
    
    ThemePackButtonAdapter(ThemePackGalleryButton@ btn, ThemePack@ pack) {
        @button = btn;
        @themePack = pack;
    }
    
    ThemePackButtonAdapter(ThemePackGalleryButton@ btn, array<ThemePack@>@ themePacksArray) {
        @button = btn;
        @themePacks = themePacksArray;
    }
    
    ThemePack@ GetTargetThemePack(uint index) {
        if (themePack !is null) return themePack;
        if (index < themePacks.Length) return themePacks[index];
        return null;
    }
    
    string GetLabel(uint index) override { return button.label; }
    bool IsEnabled(uint index) override { return button.IsEnabled(GetTargetThemePack(index), index); }
    bool OnClick(uint index) override { return button.OnClick(GetTargetThemePack(index), index); }
    float GetWidth(uint index) override { return button.width; }
    vec4 GetBackgroundColor(uint index) override { return button.backgroundColor; }
    vec4 GetTextColor(uint index) override { return button.textColor; }
    float GetFontSize(uint index) override { return button.fontSize; }
    string GetTooltip(uint index) override { return button.tooltip; }
    vec4 GetIconColor(uint index) override { return button.iconColor; }
}

