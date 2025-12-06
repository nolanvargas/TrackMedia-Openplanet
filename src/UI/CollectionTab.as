class CollectionTab : Tab {
    Collection@ m_collection;
    
    CollectionTab(Collection@ collection) {
        @m_collection = collection;
    }
    
    bool IsVisible() override { return true; }
    
    bool CanClose() override { return true; }
    
    string GetLabel() override {
        if (m_collection is null) return "Unknown";
        string name = m_collection.collectionName.Length == 0 ? "Unnamed Collection" : m_collection.collectionName;
        return name.Length > 25 ? name.SubStr(0, 22) + "..." : name;
    }
    
    string GetTooltip() override {
        return m_collection !is null ? m_collection.collectionName : "";
    }
    
    vec4 GetColor() override {
        return vec4(0.2f, 0.4f, 0.8f, 1);
    }
    
    vec4 GetColor(int index) override {
        // Use index-based shade colors (index 0 is the Collections page tab, so we start from index 1)
        // Subtract 1 to get the actual collection tab index, then apply modulo 5
        int shadeIndex = (index - 1) % 5;
        return TabStyles::GetShadeColor(shadeIndex);
    }
    
    void Render() override {
        if (m_collection is null) {
            UI::Text("Collection not found");
            return;
        }
        
        UI::Text("Collection: " + m_collection.collectionName);
        UI::Separator();
        UI::Text("User: " + m_collection.userName);
        UI::Text("ID: " + m_collection.collectionId);
        UI::Text("Items: " + m_collection.items.Length);
        UI::Separator();
        UI::Dummy(vec2(0, 8));
        
        if (m_collection.items.Length == 0) {
            UI::Text("No items in this collection.");
            return;
        }
        
        Gallery::Render(m_collection.items);
    }
    
    string GetCollectionId() {
        return m_collection !is null ? m_collection.collectionId : "";
    }
    
    Collection@ GetCollection() {
        return m_collection;
    }
}

