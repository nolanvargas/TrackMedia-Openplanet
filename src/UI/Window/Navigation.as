namespace UIWindow {
    class Navigation {
        string activePage = "User";

        void Render(float width, float height) {
            UI::PushStyleColor(UI::Col::ChildBg, Colors::DARK);
            UI::BeginChild("Navigation", vec2(width, height), false, UI::WindowFlags::NoScrollbar);

            float navXOffset = 24.0f;
            float yPos = 20.0f;

            string displayName = SessionStorage::GetDisplayName();
            string userLabel = displayName.Length > 0 ? displayName : "User";

            array<array<string>> navItems = {
                {userLabel, Icons::UserO, "User"},
                {"Browse", Icons::Search, "Browse"},
                {"Collections", Icons::FolderO, "Collections"},
                {"Theme Packs", Icons::Th, "Theme Packs"},
                {"Liked", Icons::HeartO, "Liked"},
                {"Uploads", Icons::Kenney::Upload, "Uploads"}
            };

            for (uint i = 0; i < navItems.Length; i++) {
                UI::SetCursorPos(vec2(navXOffset, yPos));
                RenderNavItem(navItems[i][0], navItems[i][1], navItems[i][2]);
                yPos = UI::GetCursorPos().y;
            }

            UI::EndChild();
            UI::PopStyleColor();
        }

        void RenderNavItem(const string &in label, const string &in icon, const string &in pageId) {
            UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(0, 8));
            bool isActive = (activePage == pageId);

            UI::PushStyleColor(UI::Col::HeaderHovered, Colors::TRANSPARENT);
            UI::PushStyleColor(UI::Col::HeaderActive, Colors::TRANSPARENT);
            UI::PushStyleColor(UI::Col::Header, Colors::TRANSPARENT);

            if (UI::Selectable("##nav_item_" + label, false)) {
                activePage = pageId;
            }
            if (UI::IsItemHovered()) UI::SetMouseCursor(UI::MouseCursor::Hand);
            UI::PopStyleColor(3);

            UI::SameLine();
            vec4 textColor = isActive ? Colors::ACTIVE : Colors::WHITE;
            UI::PushStyleColor(UI::Col::Text, textColor);

            if (icon.Length > 0) {
                UI::PushFontSize(18.0f);
                UI::Text(icon);
                UI::PopFontSize();
                UI::SameLine();
                UI::SetCursorPos(UI::GetCursorPos() + vec2(8, 0));
            }

            UI::PushFontSize(16.0f);
            UI::Text(label);
            UI::PopFontSize();
            UI::PopStyleColor();

            UI::PopStyleVar();
            UI::Dummy(vec2(0, 12));
        }
    }
}
