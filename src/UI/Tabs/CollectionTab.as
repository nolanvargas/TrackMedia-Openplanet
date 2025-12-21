class CollectionTab : Tab {
    Collection@ m_collection;
    bool m_hasRequestedData = false;
    
    CollectionTab(Collection@ collection) {
        @m_collection = collection;
        color = Colors::TAB_DEFAULT;
        if (collection !is null && collection.items.Length > 0) m_hasRequestedData = true;
    }
    
    string GetLabel() override {
        if (m_collection is null || m_collection.collectionName.Length == 0) return "Unknown";
        return TruncateLabel(m_collection.collectionName);
    }
    
    vec4 GetColor(int index) override {
        return GetShadeColorForIndex(index);
    }
    
    void Render() override {
        if (m_collection is null) {
            UI::Text("Collection not found");
            return;
        }
        if (!m_hasRequestedData && m_collection.items.Length == 0 && m_collection.collectionId.Length > 0) {
            startnew(CollectionsApiService::RequestCollectionByIdWithRef, m_collection);
            m_hasRequestedData = true;
        }
        RenderHeader(m_collection.collectionName, m_collection.userName);
        if (m_collection.items.Length == 0) {
            UI::Text(m_hasRequestedData ? "Loading collection data..." : "No items in this collection.");
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
