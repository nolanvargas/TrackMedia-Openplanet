namespace UIWindow {
    class Navigation {
        string m_activePage = "Browse";

        void Render(float width, float height) {
            UI::PushStyleColor(UI::Col::ChildBg, vec4(0.133, 0.145, 0.141, 1.0));
            if (UI::BeginChild("Navigation", vec2(width, height), false, UI::WindowFlags::NoScrollbar | UI::WindowFlags::NoMove)) {
                float navXOffset = 28.0f;
                float verticalPadding = 22.0f;
                float yPos = verticalPadding;
                
                UI::SetCursorPos(vec2(navXOffset, yPos));
                RenderNavItem("Browse", Icons::Search, "Browse");
                yPos = UI::GetCursorPos().y;
                
                UI::SetCursorPos(vec2(navXOffset, yPos));
                RenderNavItem("Collections", Icons::Folder, "Collections");
                yPos = UI::GetCursorPos().y;
                
                UI::SetCursorPos(vec2(navXOffset, yPos));
                RenderNavItem("Theme Packs", Icons::Cubes, "Theme Packs");
                
                float targetDebugButtonY = height - verticalPadding * 2;
                float currentY = UI::GetCursorPos().y;

                
                UI::SetCursorPos(vec2(navXOffset, targetDebugButtonY));
                RenderNavItem("Debug", Icons::InfoCircle, "Debug");
                UI::EndChild();
            }
            UI::PopStyleColor();
        }

        void RenderNavItem(const string &in label, const string &in icon, const string &in pageId) {
            UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(0, 10));
            bool isActive = (m_activePage == pageId);
            vec4 activeColor = vec4(1.0, 0.85, 0.2, 1.0);
            
            UI::PushStyleColor(UI::Col::HeaderHovered, vec4(0, 0, 0, 0));
            UI::PushStyleColor(UI::Col::HeaderActive, vec4(0, 0, 0, 0));
            UI::PushStyleColor(UI::Col::Header, vec4(0, 0, 0, 0));
            
            if (UI::Selectable("##nav_item_" + label, false)) {
                m_activePage = pageId;
            }
            if (UI::IsItemHovered()) {
                UI::SetMouseCursor(UI::MouseCursor::Hand);
            }
            UI::PopStyleColor(3);
            
            UI::SameLine();
            if (isActive) UI::PushStyleColor(UI::Col::Text, activeColor);
            UI::PushFontSize(19.0f);
            UI::Text(icon);
            UI::PopFontSize();
            if (isActive) UI::PopStyleColor();
            
            UI::SameLine();
            UI::SetCursorPos(UI::GetCursorPos() + vec2(6, 0));
            if (isActive) UI::PushStyleColor(UI::Col::Text, activeColor);
            UI::PushFontSize(18.0f);
            UI::Text(label);
            UI::PopFontSize();
            if (isActive) UI::PopStyleColor();
            
            UI::PopStyleVar();
            UI::Dummy(vec2(0, 16));
        }
    }
}
