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
    
    MediaItem@ GetItem(uint index) {
        if (item !is null) return item;
        if (items !is null && index < items.Length) return items[index];
        return null;
    }
    
    string GetLabel(uint index) override {
        MediaItem@ targetItem = GetItem(index);
        return (button !is null && targetItem !is null) ? button.GetLabel(targetItem, index) : "Button";
    }
    
    bool IsEnabled(uint index) override {
        MediaItem@ targetItem = GetItem(index);
        return (button !is null && targetItem !is null) && button.IsEnabled(targetItem, index);
    }
    
    bool OnClick(uint index) override {
        MediaItem@ targetItem = GetItem(index);
        return (button !is null && targetItem !is null) && button.OnClick(targetItem, index);
    }
    
    float GetWidth(uint index) override {
        MediaItem@ targetItem = GetItem(index);
        return (button !is null && targetItem !is null) ? button.GetWidth(targetItem, index) : 100.0f;
    }
    
    vec4 GetBackgroundColor(uint index) override {
        MediaItem@ targetItem = GetItem(index);
        return (button !is null && targetItem !is null) ? button.GetBackgroundColor(targetItem, index) : vec4(0.2f, 0.5f, 0.8f, 1.0f);
    }
    
    vec4 GetTextColor(uint index) override {
        MediaItem@ targetItem = GetItem(index);
        return (button !is null && targetItem !is null) ? button.GetTextColor(targetItem, index) : vec4(1.0f, 1.0f, 1.0f, 1.0f);
    }
    
    float GetFontSize(uint index) override {
        MediaItem@ targetItem = GetItem(index);
        return (button !is null && targetItem !is null) ? button.GetFontSize(targetItem, index) : 1.0f;
    }
    
    string GetTooltip(uint index) override {
        MediaItem@ targetItem = GetItem(index);
        return (button !is null && targetItem !is null) ? button.GetTooltip(targetItem, index) : "";
    }
    
    vec4 GetIconColor(uint index) override {
        MediaItem@ targetItem = GetItem(index);
        return (button !is null && targetItem !is null) ? button.GetIconColor(targetItem, index) : vec4(0, 0, 0, 0);
    }
    
    bool IsIconTopRight(uint index) override {
        MediaItem@ targetItem = GetItem(index);
        return (button !is null && targetItem !is null) && button.IsIconTopRight(targetItem, index);
    }
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
    
    Collection@ GetCollection(uint index) {
        if (collection !is null) return collection;
        if (collections !is null && index < collections.Length) return collections[index];
        return null;
    }
    
    string GetLabel(uint index) override {
        Collection@ targetCollection = GetCollection(index);
        return (button !is null && targetCollection !is null) ? button.GetLabel(targetCollection, index) : "Button";
    }
    
    bool IsEnabled(uint index) override {
        Collection@ targetCollection = GetCollection(index);
        return (button !is null && targetCollection !is null) && button.IsEnabled(targetCollection, index);
    }
    
    bool OnClick(uint index) override {
        Collection@ targetCollection = GetCollection(index);
        return (button !is null && targetCollection !is null) && button.OnClick(targetCollection, index);
    }
    
    float GetWidth(uint index) override {
        Collection@ targetCollection = GetCollection(index);
        return (button !is null && targetCollection !is null) ? button.GetWidth(targetCollection, index) : 100.0f;
    }
    
    vec4 GetBackgroundColor(uint index) override {
        Collection@ targetCollection = GetCollection(index);
        return (button !is null && targetCollection !is null) ? button.GetBackgroundColor(targetCollection, index) : vec4(0.2f, 0.5f, 0.8f, 1.0f);
    }
    
    vec4 GetTextColor(uint index) override {
        Collection@ targetCollection = GetCollection(index);
        return (button !is null && targetCollection !is null) ? button.GetTextColor(targetCollection, index) : vec4(1.0f, 1.0f, 1.0f, 1.0f);
    }
    
    float GetFontSize(uint index) override {
        Collection@ targetCollection = GetCollection(index);
        return (button !is null && targetCollection !is null) ? button.GetFontSize(targetCollection, index) : 1.0f;
    }
    
    string GetTooltip(uint index) override {
        Collection@ targetCollection = GetCollection(index);
        return (button !is null && targetCollection !is null) ? button.GetTooltip(targetCollection, index) : "";
    }
    
    vec4 GetIconColor(uint index) override {
        Collection@ targetCollection = GetCollection(index);
        return (button !is null && targetCollection !is null) ? button.GetIconColor(targetCollection, index) : vec4(0, 0, 0, 0);
    }
    
    bool IsIconTopRight(uint index) override {
        Collection@ targetCollection = GetCollection(index);
        return (button !is null && targetCollection !is null) && button.IsIconTopRight(targetCollection, index);
    }
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
    
    ThemePack@ GetThemePack(uint index) {
        if (themePack !is null) return themePack;
        if (themePacks !is null && index < themePacks.Length) return themePacks[index];
        return null;
    }
    
    string GetLabel(uint index) override {
        ThemePack@ targetPack = GetThemePack(index);
        return (button !is null && targetPack !is null) ? button.GetLabel(targetPack, index) : "Button";
    }
    
    bool IsEnabled(uint index) override {
        ThemePack@ targetPack = GetThemePack(index);
        return (button !is null && targetPack !is null) && button.IsEnabled(targetPack, index);
    }
    
    bool OnClick(uint index) override {
        ThemePack@ targetPack = GetThemePack(index);
        return (button !is null && targetPack !is null) && button.OnClick(targetPack, index);
    }
    
    float GetWidth(uint index) override {
        ThemePack@ targetPack = GetThemePack(index);
        return (button !is null && targetPack !is null) ? button.GetWidth(targetPack, index) : 100.0f;
    }
    
    vec4 GetBackgroundColor(uint index) override {
        ThemePack@ targetPack = GetThemePack(index);
        return (button !is null && targetPack !is null) ? button.GetBackgroundColor(targetPack, index) : vec4(0.2f, 0.5f, 0.8f, 1.0f);
    }
    
    vec4 GetTextColor(uint index) override {
        ThemePack@ targetPack = GetThemePack(index);
        return (button !is null && targetPack !is null) ? button.GetTextColor(targetPack, index) : vec4(1.0f, 1.0f, 1.0f, 1.0f);
    }
    
    float GetFontSize(uint index) override {
        ThemePack@ targetPack = GetThemePack(index);
        return (button !is null && targetPack !is null) ? button.GetFontSize(targetPack, index) : 1.0f;
    }
    
    string GetTooltip(uint index) override {
        ThemePack@ targetPack = GetThemePack(index);
        return (button !is null && targetPack !is null) ? button.GetTooltip(targetPack, index) : "";
    }
    
    vec4 GetIconColor(uint index) override {
        ThemePack@ targetPack = GetThemePack(index);
        return (button !is null && targetPack !is null) ? button.GetIconColor(targetPack, index) : vec4(0, 0, 0, 0);
    }
    
    bool IsIconTopRight(uint index) override {
        ThemePack@ targetPack = GetThemePack(index);
        return (button !is null && targetPack !is null) && button.IsIconTopRight(targetPack, index);
    }
}

