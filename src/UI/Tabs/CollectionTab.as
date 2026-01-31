class CollectionTab : Tab {
    Collection@ m_collection;
    bool m_hasRequestedData = false;

    CollectionTab(Collection@ collection) {
        @m_collection = collection;
        color = Colors::TAB_DEFAULT;
        UpdateTabProperties();
        if (collection !is null && collection.items.Length > 0) m_hasRequestedData = true;
    }

    void UpdateTabProperties() {
        if (m_collection !is null) {
            tabId = m_collection.collectionId;
            label = m_collection.collectionName.Length > 0 ? TruncateLabel(m_collection.collectionName) : "Unknown";
        } else {
            tabId = "";
            label = "Unknown";
        }
    }

    void Render() override {
        if (m_collection is null) {
            UI::Text("Collection not found");
            return;
        }
        UpdateTabProperties();

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

    Collection@ GetCollection() {
        return m_collection;
    }
}
