namespace CollectionsPageTabManager {
    void EnsureCollectionsTabExists() {
        if (State::openTabs.Length > 0) {
            CollectionsPageTab@ collectionsTab = cast<CollectionsPageTab>(State::openTabs[0]);
            if (collectionsTab !is null) return;
        }
        
        CollectionsPageTab@ collectionsTab = CollectionsPageTab();
        State::openTabs.InsertAt(0, collectionsTab);
        
        if (State::activeTabIndex < 0) {
            State::activeTabIndex = 0;
        } else {
            State::activeTabIndex++;
        }
    }
    
    void RenderTabBar() {
        EnsureCollectionsTabExists();
        
        if (State::activeTabIndex < 0 || State::activeTabIndex >= int(State::openTabs.Length)) {
            State::activeTabIndex = 0;
        }
        
        if (State::openTabs.Length == 0) return;
        
        // Increase tab height by 20% (default FramePadding y=4, so 4*1.2=4.8)
        UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(4.0f, 4.8f));
        UI::BeginTabBar("CollectionTabs");
        int tabToClose = -1;
        int imGuiSelectedTab = -1;
        
        for (uint i = 0; i < State::openTabs.Length; i++) {
            Tab@ tab = State::openTabs[i];
            if (tab is null) continue;
            
            bool isTargetTab = (int(i) == State::activeTabIndex);
            string tabLabel = tab.GetLabel();
            if (tabLabel.Length == 0) tabLabel = "Tab " + i;
            
            // Check if this is a CollectionTab (index > 0) to use index-based styling
            CollectionTab@ collectionTab = cast<CollectionTab>(tab);
            if (collectionTab !is null && i > 0) {
                tab.PushTabStyle(int(i));
            } else {
                tab.PushTabStyle();
            }
            
            UI::TabItemFlags flags = (State::forceTabSelection && isTargetTab) 
                ? UI::TabItemFlags::SetSelected 
                : UI::TabItemFlags::None;
            
            bool tabOpen = true;
            if (UI::BeginTabItem(tabLabel, tabOpen, flags)) {
                if (imGuiSelectedTab < 0) {
                    imGuiSelectedTab = int(i);
                }
                UI::EndTabItem();
            }
            
            if (!tabOpen && tab.CanClose() && i > 0) {
                tabToClose = int(i);
            }
            
            if (collectionTab !is null && i > 0) {
                tab.PopTabStyleWithText();  // 6 colors including text color (needed for last 2 shades with black text)
            } else {
                tab.PopTabStyle();
            }
        }
        
        if (imGuiSelectedTab >= 0 && imGuiSelectedTab != State::activeTabIndex) {
            State::activeTabIndex = imGuiSelectedTab;
        }
        State::forceTabSelection = false;
        
        if (tabToClose >= 0) {
            CloseTab(tabToClose);
        }
        
        UI::EndTabBar();
        UI::PopStyleVar();
    }
    
    void OpenCollectionTab(Collection@ collection) {
        if (collection is null) {
            Logging::Error("CollectionsPage: Cannot open null collection");
            return;
        }
        
        for (uint i = 1; i < State::openTabs.Length; i++) {
            Tab@ tab = State::openTabs[i];
            if (tab is null) continue;
            
            CollectionTab@ collectionTab = cast<CollectionTab>(tab);
            if (collectionTab !is null) {
                if (collectionTab.GetCollectionId() == collection.collectionId) {
                    State::activeTabIndex = int(i);
                    State::forceTabSelection = true;
                    Logging::Info("Activated existing collection tab at index " + i + ", activeTabIndex: " + State::activeTabIndex);
                    return;
                }
            }
        }
        
        CollectionTab@ newTab = CollectionTab(collection);
        State::openTabs.InsertLast(newTab);
        State::activeTabIndex = int(State::openTabs.Length - 1);
        State::forceTabSelection = true;
        
        // Request collection data from API
        startnew(ApiService::RequestCollectionById, collection.collectionId);
        
        Logging::Info("Opened new collection tab: " + collection.collectionName + " at index " + State::activeTabIndex + ", total tabs: " + State::openTabs.Length);
    }
    
    void CloseTab(int index) {
        if (index < 0 || index >= int(State::openTabs.Length) || index == 0) return;
        
        bool wasActive = (State::activeTabIndex == index);
        State::openTabs.RemoveAt(index);
        
        if (wasActive) {
            State::activeTabIndex = Math::Max(0, index - 1);
            if (State::activeTabIndex >= int(State::openTabs.Length)) {
                State::activeTabIndex = int(State::openTabs.Length) - 1;
            }
        } else if (State::activeTabIndex > index) {
            State::activeTabIndex--;
        }
    }
}

