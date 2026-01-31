funcdef void ClearFunc();
funcdef void RequestFunc();

namespace PageHelpers {

    void RenderSessionError() {
        StyleHelpers::PushDimmedText();
        UI::Text("An error occurred. Please restart the plugin.");
        StyleHelpers::PopDimmedText();
    }

    void RenderCenteredMessage(const string &in message) {
        vec2 avail = UI::GetContentRegionAvail();
        UI::Dummy(vec2(0, avail.y * 0.4f));
        UI::PushStyleColor(UI::Col::Text, Colors::TEXT_DIMMED);
        float width = UI::GetContentRegionAvail().x;
        UI::SetCursorPosX(UI::GetCursorPos().x + width * 0.5f - 50);
        UI::Text(message);
        UI::PopStyleColor();
    }

    bool RenderGrid(uint itemCount, bool isRequesting, const string &in status, const string &in loadingText = "Loading...", const string &in emptyText = "No items found.") {
        if (itemCount == 0) {
            if (isRequesting) {
                UI::Text(loadingText);
            } else {
                UI::Text(emptyText);
                UI::Text("Status: " + status);
            }
            return false;
        }
        return true;
    }
    
    void RenderTabContent(TabSystem@ tabSystem) {
        Tab@ activeTab = tabSystem.GetActiveTab();
        if (activeTab !is null) {
            if (tabSystem.IsPageTabActive()) { return; }
            else {
                activeTab.PushTabStyle(tabSystem.activeIndex);
                activeTab.Render();
                activeTab.PopTabStyleWithText();
            }
        }
    }
    
    void OpenCollectionTab(Collection@ collection) {
        if (collection is null) return;
        CollectionTab@ newTab = CollectionTab(collection);
        if (State::collectionsTabSystem.OpenTab(newTab, collection.collectionId, 5)) {
            UIWindow::SetActivePage("Collections");
            startnew(CollectionsApiService::RequestCollectionByIdWithRef, collection);
        }
    }
    
    void OpenThemePackTab(ThemePack@ pack) {
        if (pack is null) return;
        ThemePackTab@ newTab = ThemePackTab(pack);
        if (State::themePacksTabSystem.OpenTab(newTab, pack.themePackId, 5)) {
            UIWindow::SetActivePage("Theme Packs");
            startnew(ThemePacksApiService::RequestThemePackByIdWithRef, pack);
        }
    }
}
