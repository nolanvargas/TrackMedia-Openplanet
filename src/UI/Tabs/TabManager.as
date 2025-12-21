namespace TabManager {
    string GetTabDisplayName(Tab@ tab) {
        CollectionTab@ cTab = cast<CollectionTab>(tab);
        if (cTab !is null) {
            Collection@ c = cTab.GetCollection();
            return c !is null ? c.collectionName : "";
        }
        ThemePackTab@ pTab = cast<ThemePackTab>(tab);
        if (pTab !is null) {
            ThemePack@ p = pTab.GetThemePack();
            return p !is null ? p.packName : "";
        }
        return "";
    }
    
    void RenderPinButton(Tab@ tab, uint i) {
        if (!tab.canClose || i == 0) return;
    
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
                    string name = GetTabDisplayName(tab);
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
    
    void RenderTabBar(array<Tab@>@ tabs, int active, const string &in id,
        int&out newActive, bool&out forceSelection) {

        int cur = active;
        if (cur < 0 || cur >= int(tabs.Length)) cur = 0;

        if (tabs.Length == 0) {
            newActive = cur;
            forceSelection = false;
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
            if (t.canClose && i > 0) label += "    "; // leave space for pin

            bool useIndex = t.canClose && i > 0;
            if (useIndex) t.PushTabStyle(i);
            else t.PushTabStyle();

            UI::TabItemFlags flags = (forceSelection && int(i) == cur)
            ? UI::TabItemFlags::SetSelected
            : UI::TabItemFlags::None;

            bool open = true;
            if (UI::BeginTabItem(label, open, flags)) {
                if (selected < 0) selected = int(i);
                UI::EndTabItem();
            }

            RenderPinButton(t, i);

            if (!open && t.canClose && i > 0)
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
        forceSelection = false;
    }

    // Open a tab by ID - finds existing tab or creates new one
    // Returns true if tab was opened/activated, false if newTab is null
    // Sets forceSelection to true if a tab was opened/activated programmatically
    bool OpenTab(array<Tab@>@ tabs, int active,
        const string &in id, Tab@ tab, uint max,
        int&out newActive, bool&out forceSelection) {

            if (tab is null) {
                newActive = active;
                forceSelection = false;
                return false;
            }

            int cur = active;

            for (uint i = 1; i < tabs.Length; i++) {
                    Tab@ t = tabs[i];
                    if (t !is null && t.GetTabId() == id) {
                        newActive = int(i);
                        forceSelection = true;
                        return true;
                    }
                }

                int closeAt = FindTabToClose(tabs, max);
                if (closeAt >= 0)
                    CloseTab(tabs, cur, closeAt, cur);

                tabs.InsertLast(tab);
                cur = int(tabs.Length - 1);

                newActive = cur;
                forceSelection = true;
                return true;
            }
            

    void CloseTab(array<Tab@>@ tabs, int active, int idx, int&out outActive) {
        if (idx <= 0 || idx >= int(tabs.Length)) {
            outActive = active;
            return;
        }
    
        // Get the tab before removing it to check if it was pinned
        Tab@ closingTab = tabs[idx];
        if (closingTab !is null && closingTab.IsPinned() && closingTab.canClose) {
            // Remove from storage if it was pinned
            string tabId = closingTab.tabId;
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
