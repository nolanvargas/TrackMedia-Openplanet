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

    void RenderPinButton(Tab@ tab, uint i, bool isSelected) {
        if (!tab.canClose || i == 0 || (!isSelected && !tab.isPinned)) return;

        UI::SameLine(0, 0);
        vec2 p = UI::GetCursorPos();
        UI::SetCursorPos(vec2(p.x - 44, p.y + 6));

        vec2 size = vec2(16, 16);
        vec2 screen = UI::GetCursorScreenPos();

        UI::PushStyleColor(UI::Col::Button, Colors::TRANSPARENT);
        UI::PushStyleColor(UI::Col::ButtonHovered, Colors::TRANSPARENT);
        UI::PushStyleColor(UI::Col::ButtonActive, Colors::ACTIVE);
        UI::PushStyleColor(UI::Col::HeaderActive, Colors::ACTIVE);

        if (UI::Button("##Pin" + i, size)) {
            tab.isPinned = !tab.isPinned;
            if (tab.tabId.Length > 0) {
                bool isCollection = cast<CollectionTab>(tab) !is null;
                tab.isPinned
                    ? PinnedTabsStorage::PinTab(tab.tabId, GetTabDisplayName(tab), isCollection)
                    : PinnedTabsStorage::UnpinTab(tab.tabId, isCollection);
            }
        }

        bool hovered = UI::IsItemHovered();
        UI::PopStyleColor(4);

        UI::SetCursorScreenPos(screen + vec2(0, 3));
        UI::PushStyleColor(UI::Col::Text,
            tab.isPinned ? Colors::ACTIVE : (hovered ? Colors::UNPINNED : vec4(1,1,1,0.15f)));
        UI::PushFontSize(12);
        UI::Text(Icons::MapPin);
        UI::PopFontSize();
        UI::PopStyleColor();
    }

    void RenderTabBar(array<Tab@>@ tabs, int active, const string &in id,
        int&out newActive, bool&out forceSelection) {

        int cur = (active < 0 || active >= int(tabs.Length)) ? 0 : active;
        if (tabs.Length == 0) { newActive = cur; forceSelection = false; return; }

        UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(11, 7));
        UI::BeginTabBar(id);

        int closeAt = -1, selected = -1;

        for (uint i = 0; i < tabs.Length; i++) {
            auto t = tabs[i]; if (t is null) continue;

            string label = t.label + ((t.canClose && i > 0) ? "    " : "");
            bool useIndex = t.canClose && i > 0;
            useIndex ? t.PushTabStyle(i) : t.PushTabStyle();

            bool open = true;
            auto flags = (forceSelection && int(i) == cur)
                ? UI::TabItemFlags::SetSelected : UI::TabItemFlags::None;

            bool activeTab = t.canClose && i > 0
                ? UI::BeginTabItem(label, open, flags)
                : UI::BeginTabItem(label, flags);

            if (activeTab) { if (selected < 0) selected = int(i); UI::EndTabItem(); }

            RenderPinButton(t, i, int(i) == cur);
            if (!open && t.canClose && i > 0) closeAt = int(i);

            useIndex ? t.PopTabStyleWithText() : t.PopTabStyle();
        }

        if (selected >= 0 && selected != cur) cur = selected;
        if (closeAt >= 0) CloseTab(tabs, cur, closeAt, cur);

        UI::EndTabBar();
        UI::PopStyleVar();

        newActive = cur;
        forceSelection = false;
    }

    bool OpenTab(array<Tab@>@ tabs, int active,
        const string &in id, Tab@ tab, uint max,
        int&out newActive, bool&out forceSelection) {

        if (tab is null) { newActive = active; forceSelection = false; return false; }

        for (uint i = 1; i < tabs.Length; i++)
            if (tabs[i] !is null && tabs[i].tabId == id) {
                newActive = int(i); forceSelection = true; return false;
            }

        int cur = active;
        int closeAt = FindTabToClose(tabs, max);
        if (closeAt >= 0) CloseTab(tabs, cur, closeAt, cur);

        tabs.InsertLast(tab);
        newActive = int(tabs.Length - 1);
        forceSelection = true;
        return true;
    }

    void CloseTab(array<Tab@>@ tabs, int active, int idx, int&out outActive) {
        if (idx <= 0 || idx >= int(tabs.Length)) { outActive = active; return; }

        auto t = tabs[idx];
        if (t !is null && t.isPinned && t.canClose && t.tabId.Length > 0)
            PinnedTabsStorage::UnpinTab(t.tabId, cast<CollectionTab>(t) !is null);

        int cur = active;
        bool was = cur == idx;
        tabs.RemoveAt(idx);

        if (was) cur = Math::Min(int(tabs.Length) - 1, Math::Max(0, idx - 1));
        else if (cur > idx) cur--;

        outActive = cur;
    }

    int FindTabToClose(array<Tab@>@ tabs, uint max) {
        if (tabs.Length <= 1 || tabs.Length - 1 < max) return -1;
        for (uint i = 1; i < tabs.Length; i++)
            if (tabs[i] !is null && !tabs[i].isPinned) return int(i);
        return 1;
    }
}




