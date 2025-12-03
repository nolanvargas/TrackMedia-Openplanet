namespace ThemePacksPageTabManager {
    void EnsureThemePacksTabExists() {
        if (State::openTabs.Length > 0) {
            ThemePacksPageTab@ themePacksTab = cast<ThemePacksPageTab>(State::openTabs[0]);
            if (themePacksTab !is null) return;
        }
        
        ThemePacksPageTab@ themePacksTab = ThemePacksPageTab();
        State::openTabs.InsertAt(0, themePacksTab);
        
        if (State::activeTabIndex < 0) {
            State::activeTabIndex = 0;
        } else {
            State::activeTabIndex++;
        }
    }
    
    void RenderTabBar() {
        EnsureThemePacksTabExists();
        
        if (State::activeTabIndex < 0 || State::activeTabIndex >= int(State::openTabs.Length)) {
            State::activeTabIndex = 0;
        }
        
        if (State::openTabs.Length == 0) return;
        
        UI::BeginTabBar("ThemePackTabs");
        int tabToClose = -1;
        int imGuiSelectedTab = -1;
        
        for (uint i = 0; i < State::openTabs.Length; i++) {
            Tab@ tab = State::openTabs[i];
            if (tab is null) continue;
            
            bool isTargetTab = (int(i) == State::activeTabIndex);
            string tabLabel = tab.GetLabel();
            if (tabLabel.Length == 0) tabLabel = "Tab " + i;
            
            tab.PushTabStyle();
            
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
            
            tab.PopTabStyle();
        }
        
        if (imGuiSelectedTab >= 0 && imGuiSelectedTab != State::activeTabIndex) {
            State::activeTabIndex = imGuiSelectedTab;
        }
        State::forceTabSelection = false;
        
        if (tabToClose >= 0) {
            CloseTab(tabToClose);
        }
        
        UI::EndTabBar();
    }
    
    void OpenThemePackTab(ThemePack@ themePack) {
        if (themePack is null) {
            Logging::Error("ThemePacksPage: Cannot open null theme pack");
            return;
        }
        
        for (uint i = 1; i < State::openTabs.Length; i++) {
            Tab@ tab = State::openTabs[i];
            if (tab is null) continue;
            
            ThemePackTab@ themePackTab = cast<ThemePackTab>(tab);
            if (themePackTab !is null) {
                if (themePackTab.GetThemePackId() == themePack.themePackId) {
                    State::activeTabIndex = int(i);
                    State::forceTabSelection = true;
                    Logging::Info("Activated existing theme pack tab at index " + i + ", activeTabIndex: " + State::activeTabIndex);
                    return;
                }
            }
        }
        
        ThemePackTab@ newTab = ThemePackTab(themePack);
        State::openTabs.InsertLast(newTab);
        State::activeTabIndex = int(State::openTabs.Length - 1);
        State::forceTabSelection = true;
        
        // Request theme pack data from API
        startnew(ApiService::RequestThemePackById, themePack.themePackId);
        
        Logging::Info("Opened new theme pack tab: " + themePack.packName + " at index " + State::activeTabIndex + ", total tabs: " + State::openTabs.Length);
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

