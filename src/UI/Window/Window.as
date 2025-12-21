namespace UIWindow {
    // Layout constants
    const float NAV_WIDTH = 180.0;
    const float MIN_WINDOW_WIDTH = NAV_WIDTH + 50.0;
    const float ITEM_SPACING = 2.0;
    
    // State
    Header@ m_header = Header();
    Navigation@ m_navigation = Navigation();
    
    void SetActivePage(const string &in pageId) {
        if (m_navigation !is null) {
            m_navigation.SetActivePage(pageId);
        }
    }
    
    void RenderBottomSection(float bottomSectionHeight) {
        UI::PushStyleColor(UI::Col::ChildBg, Colors::BOTTOM_SECTION_BG);
        UI::BeginChild("BottomSection", vec2(0, bottomSectionHeight), true, UI::WindowFlags::NoScrollbar);
        if (State::selectedBlock !is null) {
            vec2 size = UI::GetContentRegionAvail();
            UI::SetCursorPos(vec2(0, 0));
            UI::BeginChild("PreviewContainer", size, false, UI::WindowFlags::NoScrollbar);
            SkinPreviewRenderer::Render(size);
            UI::EndChild();
        }
        UI::EndChild();
        UI::PopStyleColor();
    }

    void Render() {
        if (!State::isInEditor || !State::showUI) return;
        
        UI::PushStyleColor(UI::Col::WindowBg, Colors::WINDOW_BG);
        UI::PushStyleVar(UI::StyleVar::WindowPadding, vec2(0, 0));
        UI::Begin("TrackMedia", UI::WindowFlags::NoTitleBar);
        UI::PushStyleVar(UI::StyleVar::ItemSpacing, vec2(ITEM_SPACING, ITEM_SPACING));
        
        m_header.Render(NAV_WIDTH);
        float contentHeight = UI::GetContentRegionAvail().y;
        
        if (UI::GetWindowSize().x < MIN_WINDOW_WIDTH) {
            UI::Text("Window too small");
            UI::Text("Please resize to at least");
            UI::Text(MIN_WINDOW_WIDTH + "px wide.");
        } else {
            m_navigation.Render(NAV_WIDTH, contentHeight);
            UI::SameLine();
            
            UI::PushStyleColor(UI::Col::ChildBg, Colors::CHILD_BG);
            vec2 contentAreaWindowPos = vec2(0, 0);
            if (UI::BeginChild("ContentArea", vec2(0, contentHeight), false, UI::WindowFlags::NoScrollbar | UI::WindowFlags::NoMove)) {
                contentAreaWindowPos = UI::GetWindowPos();
                
                float topSectionHeight, buttonY, bottomSectionTopY;
                SectionResizeSlider::CalculateSectionLayout(contentHeight, topSectionHeight, buttonY, bottomSectionTopY);
                
                // Top section - page content
                if (UI::BeginChild("Content", vec2(0, topSectionHeight), false, UI::WindowFlags::NoScrollbar | UI::WindowFlags::NoMove)) {
                    PageRouter::Render(m_navigation.m_activePage);
                    UI::EndChild();
                }
                
                // Resize button between top and bottom sections
                SectionResizeSlider::Render(buttonY, contentAreaWindowPos, contentHeight);
                
                // Bottom section - media preview
                RenderBottomSection(SectionResizeSlider::GetBottomSectionHeight());
            }
            UI::EndChild();
            UI::PopStyleColor();
        }
        
        UI::PopStyleVar();
        UI::End();
        UI::PopStyleVar();
        UI::PopStyleColor();
    }
}
