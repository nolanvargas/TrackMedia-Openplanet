class CollectionGalleryButton {
    string label = "Open";
    float width = -1.0f; // Sentinel value: use full content width
    vec4 backgroundColor = Colors::GALLERY_COLLECTION_BUTTON_BG;
    vec4 textColor = Colors::SHADE_BLACK;
    float fontSize = 1.0f;
    string tooltip = "";
    vec4 iconColor = Colors::TRANSPARENT;
    
    bool OnClick(Collection@ collection, uint index) {
        if (collection is null) return false;
        CollectionsPageTabManager::OpenCollectionTab(collection);
        return true;
    }
    
    bool IsEnabled(Collection@ collection, uint index) {
        return collection !is null;
    }
}

