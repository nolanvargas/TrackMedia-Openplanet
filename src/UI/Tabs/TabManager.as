namespace TabManager {
    void RenderPinButton(Tab@ tab, uint i) {
        if (!tab.CanClose() || i == 0) return;
    
        UI::SameLine(0, 0);
        vec2 p = UI::GetCursorPos();
        UI::SetCursorPos(vec2(p.x - 34, p.y + 4));
    
        vec2 size = vec2(16, 16);
        vec2 screen = UI::GetCursorScreenPos();
    
        UI::PushStyleColor(UI::Col::Button, Colors::TRANSPARENT);
        UI::PushStyleColor(UI::Col::ButtonHovered, Colors::TRANSPARENT);
    
        if (UI::Button("##Pin" + i, size)) {
            bool wasPinned = tab.IsPinned();
            tab.SetPinned(!wasPinned);
            
            string tabId = tab.GetTabId();
            if (tabId.Length > 0) {
                CollectionTab@ collectionTab = cast<CollectionTab>(tab);
                bool isCollection = collectionTab !is null;
                
                if (!wasPinned) {
                    // Pinning: get the name from the tab
                    string name = "";
                    if (isCollection) {
                        Collection@ c = collectionTab.GetCollection();
                        if (c !is null) {
                            name = c.collectionName;
                        }
                    } else {
                        ThemePackTab@ themePackTab = cast<ThemePackTab>(tab);
                        if (themePackTab !is null) {
                            ThemePack@ p = themePackTab.GetThemePack();
                            if (p !is null) {
                                name = p.packName;
                            }
                        }
                    }
                    PinnedTabsStorage::PinTab(tabId, name, isCollection);
                } else {
                    // Unpinning
                    PinnedTabsStorage::UnpinTab(tabId, isCollection);
                }
            }
        }
    
        bool hovered = UI::IsItemHovered();
        bool pinned = tab.IsPinned();
    
        UI::PopStyleColor(2);
    
        if (!hovered && !pinned) return;
    
        UI::SetCursorScreenPos(screen + vec2(0, 3));
        UI::PushStyleColor(UI::Col::Text, pinned 
            ? Colors::ACTIVE
            : Colors::UNPINNED);
    
        UI::PushFontSize(12);
        UI::Text(Icons::MapPin);
        UI::PopFontSize();
        UI::PopStyleColor();
    }
    
    void RenderTabBar(array<Tab@>@ tabs, int active, bool force, string id,
        int&out newActive, bool&out newForce) {

        int cur = active;
        if (cur < 0 || cur >= int(tabs.Length)) cur = 0;

        if (tabs.Length == 0) {
            newActive = cur;
            newForce = false;
            return;
        }

        UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(4, 4.8));
        UI::BeginTabBar(id);

        int closeAt = -1;
        int selected = -1;

        for (uint i = 0; i < tabs.Length; i++) {
            Tab@ t = tabs[i];
            if (t is null) continue;

            string label = t.GetLabel();
            if (label.Length == 0) label = "Tab " + i;
            if (t.CanClose() && i > 0) label += "    ";

            bool useIndex = t.CanClose() && i > 0;
            if (useIndex) t.PushTabStyle(i);
            else t.PushTabStyle();

            UI::TabItemFlags f = (force && int(i) == cur)
            ? UI::TabItemFlags::SetSelected
            : UI::TabItemFlags::None;

            bool open = true;
            if (UI::BeginTabItem(label, open, f)) {
                if (selected < 0) selected = int(i);
                UI::EndTabItem();
            }

            RenderPinButton(t, i);

            if (!open && t.CanClose() && i > 0)
            closeAt = int(i);

            if (useIndex) t.PopTabStyleWithText();
            else t.PopTabStyle();
        }

        if (selected >= 0 && selected != cur)
        cur = selected;

        if (closeAt >= 0)
        CloseTab(tabs, cur, closeAt, cur);

        UI::EndTabBar();
        UI::PopStyleVar();

        newActive = cur;
        newForce = false;
    }

    // Open a tab by ID - finds existing tab or creates new one
    // Returns true if tab was opened/activated, false if newTab is null
    bool OpenTab(array<Tab@>@ tabs, int active, bool force,
        string id, Tab@ tab, uint max,
        int&out newActive, bool&out newForce) {

            if (tab is null) {
                newActive = active;
                newForce = force;
                return false;
            }

            int cur = active;

            for (uint i = 1; i < tabs.Length; i++) {
                    Tab@ t = tabs[i];
                    if (t !is null && t.GetTabId() == id) {
                        newActive = int(i);
                        newForce = true;
                        return true;
                    }
                }

                int closeAt = FindTabToClose(tabs, max);
                if (closeAt >= 0)
                    CloseTab(tabs, cur, closeAt, cur);

                tabs.InsertLast(tab);
                cur = int(tabs.Length - 1);

                newActive = cur;
                newForce = true;
                return true;
            }

    void CloseTab(array<Tab@>@ tabs, int active, int idx, int&out outActive) {
        if (idx <= 0 || idx >= int(tabs.Length)) {
            outActive = active;
            return;
        }
    
        // Get the tab before removing it to check if it was pinned
        Tab@ closingTab = tabs[idx];
        if (closingTab !is null && closingTab.IsPinned() && closingTab.CanClose()) {
            // Remove from storage if it was pinned
            string tabId = closingTab.GetTabId();
            if (tabId.Length > 0) {
                CollectionTab@ collectionTab = cast<CollectionTab>(closingTab);
                bool isCollection = collectionTab !is null;
                PinnedTabsStorage::UnpinTab(tabId, isCollection);
            }
        }
    
        int cur = active;
        bool was = (cur == idx);
    
        tabs.RemoveAt(idx);
    
        if (was) {
            cur = Math::Min(int(tabs.Length) - 1, Math::Max(0, idx - 1));
        } else if (cur > idx) {
            cur--;
        }
    
        outActive = cur;
    }
    
    
    // Find index of oldest unpinned tab to close if at max capacity
    // Returns -1 if no tab needs to be closed
    int FindTabToClose(array<Tab@>@ tabs, uint max) {
        uint count = tabs.Length > 0 ? tabs.Length - 1 : 0;
        if (count < max) return -1;
        for (uint i = 1; i < tabs.Length; i++) {
            Tab@ t = tabs[i];
            if (t !is null && !t.IsPinned())
                return int(i);
        }
        return 1;
    }
    
}
