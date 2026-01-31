namespace UserPage {
    int m_activeSection = 0;

    void Render() {
        string displayName = SessionStorage::GetDisplayName();
        if (displayName.Length == 0) {
            StyleHelpers::PushDimmedText();
            UI::Text("Not logged in.");
            StyleHelpers::PopDimmedText();
            return;
        }

        if (!State::userOverview.hasRequested && !State::userOverview.isRequesting) {
            State::userOverview.isRequesting = true;
            startnew(UserApiService::RequestUserOverview);
        }

        RenderSectionTabs();
        UI::Separator();
        UI::Dummy(vec2(0, 8));

        if (m_activeSection == 0) {
            RenderSection(State::userOverview.isRequesting, State::userMedia, "Loading media...", "No media uploaded yet.");
        } else if (m_activeSection == 1) {
            RenderSection(State::userOverview.isRequesting, State::userCollections, "Loading collections...", "No collections created yet.");
        } else {
            RenderSection(State::userOverview.isRequesting, State::userThemePacks, "Loading theme packs...", "No theme packs created yet.");
        }
    }

    void RenderSectionTabs() {
        UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(12, 6));
        UI::PushStyleColor(UI::Col::Button, Colors::TRANSPARENT);
        UI::PushStyleColor(UI::Col::ButtonHovered, vec4(1, 1, 1, 0.1f));
        UI::PushStyleColor(UI::Col::ButtonActive, Colors::ACTIVE);
        UI::PushStyleColor(UI::Col::HeaderActive, Colors::ACTIVE);

        RenderTab("Media (" + State::userMedia.Length + ")##user_media_tab", 0);
        UI::SameLine();
        RenderTab("Collections (" + State::userCollections.Length + ")##user_collections_tab", 1);
        UI::SameLine();
        RenderTab("Theme Packs (" + State::userThemePacks.Length + ")##user_themepacks_tab", 2);
        UI::SameLine();

        StyleHelpers::PushButton();
        if (UI::Button(Icons::Refresh + " Refresh##user_refresh")) {
            State::userOverview.hasRequested = false;
            State::userOverview.isRequesting = true;
            startnew(UserApiService::RequestUserOverview);
        }
        StyleHelpers::PopButton();
        UI::PopStyleColor(4);
        UI::PopStyleVar();
    }

    void RenderTab(const string &in label, int index) {
        UI::PushStyleColor(UI::Col::Text, m_activeSection == index ? Colors::ACTIVE : Colors::WHITE);
        if (UI::Button(label)) m_activeSection = index;
        if (UI::IsItemHovered()) UI::SetMouseCursor(UI::MouseCursor::Hand);
        UI::PopStyleColor();
    }

    void RenderSection(bool isLoading, array<MediaItem@>@ items, const string &in loadingText, const string &in emptyText) {
        if (isLoading) { UI::Text(loadingText); return; }
        if (items.Length == 0) {
            StyleHelpers::PushDimmedText();
            UI::Text(emptyText);
            StyleHelpers::PopDimmedText();
            return;
        }
        Gallery::Render(items);
    }

    void RenderSection(bool isLoading, array<Collection@>@ items, const string &in loadingText, const string &in emptyText) {
        if (isLoading) { UI::Text(loadingText); return; }
        if (items.Length == 0) {
            StyleHelpers::PushDimmedText();
            UI::Text(emptyText);
            StyleHelpers::PopDimmedText();
            return;
        }
        Gallery::Render(items);
    }

    void RenderSection(bool isLoading, array<ThemePack@>@ items, const string &in loadingText, const string &in emptyText) {
        if (isLoading) { UI::Text(loadingText); return; }
        if (items.Length == 0) {
            StyleHelpers::PushDimmedText();
            UI::Text(emptyText);
            StyleHelpers::PopDimmedText();
            return;
        }
        Gallery::Render(items);
    }
}
