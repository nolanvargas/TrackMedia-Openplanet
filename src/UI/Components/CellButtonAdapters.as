class MediaItemButtonAdapter : ICellButton {
    GalleryButton@ button;
    MediaItem@ item;
    array<MediaItem@>@ items;
    
    // Constructor overload: Creates adapter for a single media item.
    // Use this when you have one specific item to bind to the button.
    MediaItemButtonAdapter(GalleryButton@ btn, MediaItem@ mediaItem) {
        @button = btn;
        @item = mediaItem;
    }
    
    // Constructor overload: Creates adapter for an array of media items.
    // Use this when you have multiple items and the button needs to access items by index.
    // The GetItem method will use the index parameter to select the correct item from the array.
    MediaItemButtonAdapter(GalleryButton@ btn, array<MediaItem@>@ itemsArray) {
        @button = btn;
        @items = itemsArray;
    }
    
    // Resolves the target media item for the given index.
    // Returns the single item if set, or the item at the specified index from the array.
    MediaItem@ GetTargetItem(uint index) {
        if (item !is null) return item;
        if (items !is null && index < items.Length) return items[index];
        return null;
    }
    
    string GetLabel(uint index) override { return (button !is null) ? button.label : "Button"; }
    
    bool IsEnabled(uint index) override {
        MediaItem@ targetItem = GetTargetItem(index);
        return (button !is null && targetItem !is null) && button.IsEnabled(targetItem, index);
    }
    
    bool OnClick(uint index) override {
        MediaItem@ targetItem = GetTargetItem(index);
        return (button !is null && targetItem !is null) && button.OnClick(targetItem, index);
    }
    
    float GetWidth(uint index) override { return (button !is null) ? button.width : 100.0f; }
    
    vec4 GetBackgroundColor(uint index) override { return (button !is null) ? button.backgroundColor : Colors::GALLERY_BUTTON_BG; }
    
    vec4 GetTextColor(uint index) override { return (button !is null) ? button.textColor : Colors::SHADE_WHITE; }
    
    float GetFontSize(uint index) override { return (button !is null) ? button.fontSize : 1.0f; }
    
    string GetTooltip(uint index) override { return (button !is null) ? button.tooltip : ""; }
    
    vec4 GetIconColor(uint index) override { return (button !is null) ? button.iconColor : Colors::TRANSPARENT; }
    
}

class CollectionButtonAdapter : ICellButton {
    CollectionGalleryButton@ button;
    Collection@ collection;
    array<Collection@>@ collections;
    
    // Constructor overload: Creates adapter for a single collection.
    // Use this when you have one specific collection to bind to the button.
    CollectionButtonAdapter(CollectionGalleryButton@ btn, Collection@ coll) {
        @button = btn;
        @collection = coll;
    }
    
    // Constructor overload: Creates adapter for an array of collections.
    // Use this when you have multiple collections and the button needs to access collections by index.
    // The GetCollection method will use the index parameter to select the correct collection from the array.
    CollectionButtonAdapter(CollectionGalleryButton@ btn, array<Collection@>@ collectionsArray) {
        @button = btn;
        @collections = collectionsArray;
    }
    
    // Resolves the target collection for the given index.
    // Returns the single collection if set, or the collection at the specified index from the array.
    Collection@ GetTargetCollection(uint index) {
        if (collection !is null) return collection;
        if (collections !is null && index < collections.Length) return collections[index];
        return null;
    }
    
    string GetLabel(uint index) override { return (button !is null) ? button.label : "Button"; }
    
    bool IsEnabled(uint index) override {
        Collection@ targetCollection = GetTargetCollection(index);
        return (button !is null && targetCollection !is null) && button.IsEnabled(targetCollection, index);
    }
    
    bool OnClick(uint index) override {
        Collection@ targetCollection = GetTargetCollection(index);
        return (button !is null && targetCollection !is null) && button.OnClick(targetCollection, index);
    }
    
    float GetWidth(uint index) override { return (button !is null) ? button.width : 100.0f; }
    
    vec4 GetBackgroundColor(uint index) override { return (button !is null) ? button.backgroundColor : Colors::GALLERY_BUTTON_BG; }
    
    vec4 GetTextColor(uint index) override { return (button !is null) ? button.textColor : Colors::SHADE_WHITE; }
    
    float GetFontSize(uint index) override { return (button !is null) ? button.fontSize : 1.0f; }
    
    string GetTooltip(uint index) override { return (button !is null) ? button.tooltip : ""; }
    
    vec4 GetIconColor(uint index) override { return (button !is null) ? button.iconColor : Colors::TRANSPARENT; }
    
}

class ThemePackButtonAdapter : ICellButton {
    ThemePackGalleryButton@ button;
    ThemePack@ themePack;
    array<ThemePack@>@ themePacks;
    
    // Constructor overload: Creates adapter for a single theme pack.
    // Use this when you have one specific theme pack to bind to the button.
    ThemePackButtonAdapter(ThemePackGalleryButton@ btn, ThemePack@ pack) {
        @button = btn;
        @themePack = pack;
    }
    
    // Constructor overload: Creates adapter for an array of theme packs.
    // Use this when you have multiple theme packs and the button needs to access theme packs by index.
    // The GetThemePack method will use the index parameter to select the correct theme pack from the array.
    ThemePackButtonAdapter(ThemePackGalleryButton@ btn, array<ThemePack@>@ themePacksArray) {
        @button = btn;
        @themePacks = themePacksArray;
    }
    
    // Resolves the target theme pack for the given index.
    // Returns the single theme pack if set, or the theme pack at the specified index from the array.
    ThemePack@ GetTargetThemePack(uint index) {
        if (themePack !is null) return themePack;
        if (themePacks !is null && index < themePacks.Length) return themePacks[index];
        return null;
    }
    
    string GetLabel(uint index) override { return (button !is null) ? button.label : "Button"; }
    
    bool IsEnabled(uint index) override {
        ThemePack@ targetPack = GetTargetThemePack(index);
        return (button !is null && targetPack !is null) && button.IsEnabled(targetPack, index);
    }
    
    bool OnClick(uint index) override {
        ThemePack@ targetPack = GetTargetThemePack(index);
        return (button !is null && targetPack !is null) && button.OnClick(targetPack, index);
    }
    
    float GetWidth(uint index) override { return (button !is null) ? button.width : 100.0f; }
    
    vec4 GetBackgroundColor(uint index) override { return (button !is null) ? button.backgroundColor : Colors::GALLERY_BUTTON_BG; }
    
    vec4 GetTextColor(uint index) override { return (button !is null) ? button.textColor : Colors::SHADE_WHITE; }
    
    float GetFontSize(uint index) override { return (button !is null) ? button.fontSize : 1.0f; }
    
    string GetTooltip(uint index) override { return (button !is null) ? button.tooltip : ""; }
    
    vec4 GetIconColor(uint index) override { return (button !is null) ? button.iconColor : Colors::TRANSPARENT; }
    
}

