class CollectionGalleryButton {
    float width = 100.0f;
    
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
        return width;
    }
    
    vec4 GetBackgroundColor(Collection@ collection, uint index) {
        return vec4(0.2f, 0.5f, 0.8f, 1.0f);
    }
    
    vec4 GetTextColor(Collection@ collection, uint index) {
        return vec4(1.0f, 1.0f, 1.0f, 1.0f);
    }
    
    float GetFontSize(Collection@ collection, uint index) {
        return 1.0f;
    }
    
    string GetTooltip(Collection@ collection, uint index) {
        return "";
    }
    
    vec4 GetIconColor(Collection@ collection, uint index) {
        return vec4(0, 0, 0, 0);
    }
    
    bool IsIconTopRight(Collection@ collection, uint index) {
        return false;
    }
}

