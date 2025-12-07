class CollectionGalleryButton {
    bool OnClick(Collection@ collection, uint index) {
        if (collection is null) return false;
        CollectionsPageTabManager::OpenCollectionTab(collection);
        return true;
    }
    
    string GetLabel(Collection@ collection, uint index) {
        return "Open";
    }
    
    bool IsEnabled(Collection@ collection, uint index) {
        return collection !is null;
    }
    
    float GetWidth(Collection@ collection, uint index) {
        return -1.0f; // Sentinel value: use full content width
    }
    
    vec4 GetBackgroundColor(Collection@ collection, uint index) {
        return Colors::GALLERY_COLLECTION_BUTTON_BG;
    }
    
    vec4 GetTextColor(Collection@ collection, uint index) {
        return Colors::SHADE_BLACK;
    }
    
    float GetFontSize(Collection@ collection, uint index) {
        return 1.0f;
    }
    
    string GetTooltip(Collection@ collection, uint index) {
        return "";
    }
    
    vec4 GetIconColor(Collection@ collection, uint index) {
        return Colors::TRANSPARENT;
    }
    
    bool IsIconTopRight(Collection@ collection, uint index) {
        return false;
    }
}

