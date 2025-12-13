class CollectionTab : Tab {
    Collection@ m_collection;
    bool m_hasRequestedData = false;
    
    CollectionTab(Collection@ collection) {
        @m_collection = collection;
        color = Colors::TAB_DEFAULT;
        // If collection already has items, mark data as requested
        if (collection !is null && collection.items.Length > 0) {
            m_hasRequestedData = true;
        }
    }
    
    void EnsureDataRequested() {
        if (m_collection is null) return;
        // If placeholder (no items) and haven't requested data yet, trigger data request
        if (!m_hasRequestedData && m_collection.items.Length == 0 && m_collection.collectionId.Length > 0) {
            startnew(CollectionsApiService::RequestCollectionByIdWithRef, m_collection);
            m_hasRequestedData = true;
        }
    }
    
    string GetLabel() override {
        if (m_collection is null || m_collection.collectionName.Length == 0) return "Unknown";
        return m_collection.collectionName.Length > 25 ? m_collection.collectionName.SubStr(0, 22) + "..." : m_collection.collectionName;
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
        
        // Ensure data is requested when tab is rendered
        EnsureDataRequested();
        
        UI::PushFontSize(24.0f);
        UI::Text(m_collection.collectionName);
        UI::PopFontSize();
        UI::Text(m_collection.userName);
        
        if (m_collection.items.Length == 0) {
            if (m_hasRequestedData) {
                UI::Text("Loading collection data...");
            } else {
                UI::Text("No items in this collection.");
            }
            return;
        }
        
        Gallery::Render(m_collection.items);
    }
    
    string GetTabId() override {
        return m_collection !is null ? m_collection.collectionId : "";
    }
    
    Collection@ GetCollection() {
        return m_collection;
    }
}
