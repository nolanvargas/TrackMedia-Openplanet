namespace UIWindow {
    // Layout constants
    const float NAV_WIDTH = 180.0;
    const float MIN_WINDOW_WIDTH = NAV_WIDTH + 50.0;
    const float ITEM_SPACING = 2.0;
    
    // Section layout constants
    const float BUTTON_HEIGHT = 7.0;
    const float BUTTON_WIDTH = 75.0;
    const float BUTTON_HOVER_SIZE_INCREASE = 4.0;
    const float BUTTON_OFFSET_FROM_BOTTOM_TOP = 3.0;
    const float BUTTON_SPACING = 3.0;
    const float TOP_SECTION_BOTTOM_PADDING = 5.0;
    const float MIN_BOTTOM_HEIGHT = 50.0;
    const float TOP_SECTION_RESERVE = 100.0;
    
    // Color constants
    const vec4 COLOR_WINDOW_BG = vec4(0.45, 0.45, 0.45, 1.0);
    const vec4 COLOR_CHILD_BG = vec4(0.2, 0.2, 0.2, 1.0);
    const vec4 COLOR_BUTTON = vec4(0.533, 0.533, 0.533, 1.0);
    const vec4 COLOR_BUTTON_HOVERED = vec4(0.6, 0.6, 0.6, 1.0);
    const vec4 COLOR_BUTTON_ACTIVE = vec4(0.7, 0.7, 0.7, 1.0);
    const vec4 COLOR_BOTTOM_SECTION_BG = vec4(0.15, 0.15, 0.15, 1.0); // Darker background for bottom section
    const vec4 COLOR_BOTTOM_SECTION_BORDER = vec4(0.533, 0.533, 0.533, 1.0); // #888 border color
    
    // State
    Header@ m_header = Header();
    Navigation@ m_navigation = Navigation();
    float m_bottomSectionHeight = -1.0; // -1 means uninitialized
    bool m_buttonWasHovered = false; // Track hover state for size adjustment
    bool m_buttonWasActive = false; // Track active state for size adjustment
    
    // Helper: Calculate section layout dimensions
    void CalculateSectionLayout(float contentHeight, float& out topSectionHeight, float& out buttonY, float& out bottomSectionTopY) {
        // Initialize bottom section height if not set
        if (m_bottomSectionHeight < 0.0) {
            m_bottomSectionHeight = contentHeight * 0.5;
        }
        
        // Clamp bottom section height to percentage-based range (15% min, 35% max)
        float minBottomHeight = contentHeight * 0.15;
        float maxBottomHeight = contentHeight * 0.35;
        m_bottomSectionHeight = Math::Clamp(m_bottomSectionHeight, minBottomHeight, maxBottomHeight);
        
        // Calculate positions: bottom section starts at bottom, button is offset from its top
        bottomSectionTopY = contentHeight - m_bottomSectionHeight;
        buttonY = bottomSectionTopY - BUTTON_HEIGHT - BUTTON_SPACING;
        topSectionHeight = buttonY - TOP_SECTION_BOTTOM_PADDING;
    }
    
    // Helper: Calculate button X position (centered)
    float CalculateButtonX(float buttonWidth) {
        float availableWidth = UI::GetContentRegionAvail().x;
        vec2 currentPos = UI::GetCursorPos();
        return currentPos.x + (availableWidth - buttonWidth) * 0.5;
    }
    
    // Helper: Update bottom section height during drag
    void UpdateBottomSectionHeight(vec2 contentAreaWindowPos, float contentHeight) {
        vec2 mousePos = UI::GetMousePos();
        float relativeMouseY = mousePos.y - contentAreaWindowPos.y;
        float totalButtonOffset = BUTTON_OFFSET_FROM_BOTTOM_TOP + BUTTON_SPACING;
        float newBottomHeight = contentHeight - relativeMouseY - totalButtonOffset;
        // Clamp to percentage-based range (15% min, 35% max)
        float minBottomHeight = contentHeight * 0.15;
        float maxBottomHeight = contentHeight * 0.35;
        m_bottomSectionHeight = Math::Clamp(newBottomHeight, minBottomHeight, maxBottomHeight);
    }
    
    // Helper: Push button style colors
    void PushButtonStyles() {
        UI::PushStyleColor(UI::Col::Button, COLOR_BUTTON);
        UI::PushStyleColor(UI::Col::ButtonHovered, COLOR_BUTTON_HOVERED);
        UI::PushStyleColor(UI::Col::ButtonActive, COLOR_BUTTON_ACTIVE);
    }
    
    // Helper: Calculate preview container dimensions
    void CalculatePreviewContainerSize(float availableWidth, float availableHeight, float& out containerWidth, float& out containerHeight) {
        // Calculate 80% of width and height
        float previewWidth80 = availableWidth * 0.8;
        float previewHeight80 = availableHeight * 0.8;
        
        // Determine which dimension is more constraining based on typical aspect ratio
        float typicalAspectRatio = 4.0 / 3.0;
        float estimatedHeightFromWidth = (previewWidth80 / typicalAspectRatio) + 40.0; // +40 for padding/text
        float estimatedWidthFromHeight = (previewHeight80 - 40.0) * typicalAspectRatio;
        
        if (estimatedHeightFromWidth <= previewHeight80) {
            // Width constraint is more limiting - use 80% width
            containerWidth = previewWidth80;
            containerHeight = estimatedHeightFromWidth;
        } else {
            // Height constraint is more limiting - use 80% height
            containerWidth = estimatedWidthFromHeight;
            containerHeight = previewHeight80;
        }
    }
    
    // Helper: Render resize button between top and bottom sections
    void RenderResizeButton(float buttonY, vec2 contentAreaWindowPos, float contentHeight) {
        // Use previous frame hover/active state to determine button size
        float buttonWidth = BUTTON_WIDTH;
        float buttonHeight = BUTTON_HEIGHT;
        float adjustedButtonY = buttonY;
        
        // Adjust size if was hovered or active last frame
        if (m_buttonWasHovered || m_buttonWasActive) {
            buttonWidth += BUTTON_HOVER_SIZE_INCREASE;
            buttonHeight += BUTTON_HOVER_SIZE_INCREASE;
            // Move Y position up by half the height increase to keep center aligned
            adjustedButtonY -= BUTTON_HOVER_SIZE_INCREASE * 0.5;
        }
        
        float buttonX = CalculateButtonX(buttonWidth);
        PushButtonStyles();
        UI::SetCursorPos(vec2(buttonX, adjustedButtonY));
        if (UI::Button("##ResizeButton", vec2(buttonWidth, buttonHeight))) {
            // Button clicked
        }
        
        // Update hover and active state for next frame
        m_buttonWasHovered = UI::IsItemHovered();
        m_buttonWasActive = UI::IsItemActive();
        
        // Update bottom section height while dragging (for next frame)
        if (m_buttonWasActive) {
            UpdateBottomSectionHeight(contentAreaWindowPos, contentHeight);
        }
        
        UI::PopStyleColor(3);
    }
    
    // Helper: Render bottom section with media preview
    void RenderBottomSection(float bottomSectionHeight) {
        // Style bottom section with darker background
        UI::PushStyleColor(UI::Col::ChildBg, COLOR_BOTTOM_SECTION_BG);
        
        if (UI::BeginChild("BottomSection", vec2(0, bottomSectionHeight), true, UI::WindowFlags::NoScrollbar)) {
            // Draw thin top border using a colored separator
            UI::PushStyleColor(UI::Col::Separator, COLOR_BOTTOM_SECTION_BORDER);
            UI::Separator();
            UI::PopStyleColor();
            
            bool showPreview = State::selectedBlock !is null && 
                               State::blockSkinSelected >= 0 && 
                               State::blockSkinSelected < int(State::blockSkinFiles.Length);
            
            if (showPreview) {
                float availableWidth = UI::GetContentRegionAvail().x;
                float availableHeight = UI::GetContentRegionAvail().y;
                
                float containerWidth, containerHeight;
                CalculatePreviewContainerSize(availableWidth, availableHeight, containerWidth, containerHeight);
                
                // Center the preview container
                float leftOffset = (availableWidth - containerWidth) * 0.5;
                float topOffset = (availableHeight - containerHeight) * 0.5;
                
                UI::SetCursorPos(vec2(leftOffset, topOffset));
                if (UI::BeginChild("PreviewContainer", vec2(containerWidth, 0), false, UI::WindowFlags::NoScrollbar)) {
                    NavigationSkinPreview::Render(containerWidth);
                    UI::EndChild();
                }
            }
            UI::EndChild();
        }
        
        UI::PopStyleColor();
    }
    
    // Helper: Render active page content
    void RenderPageContent() {
        bool fontPushed = Fonts::PushTrebuchetFont();
        string activePage = m_navigation.m_activePage;
        
        if (activePage == "Debug") {
            DebugPage::Render();
        } else if (activePage == "Browse") {
            BrowsePage::Render();
        } else if (activePage == "Collections") {
            CollectionsPage::Render();
        } else if (activePage == "Theme Packs") {
            ThemePacksPage::Render();
        } else {
            UI::Text("Page: " + activePage);
        }
        
        if (fontPushed) {
            UI::PopFont();
        }
    }

    void Render() {
        if (!State::isInEditor || !State::showUI) return;
        
        UI::PushStyleColor(UI::Col::WindowBg, COLOR_WINDOW_BG);
        UI::PushStyleVar(UI::StyleVar::WindowPadding, vec2(0, 0));
        UI::Begin("TrackMedia", UI::WindowFlags::NoTitleBar);
        UI::PushStyleVar(UI::StyleVar::ItemSpacing, vec2(ITEM_SPACING, ITEM_SPACING));
        
        m_header.Render(NAV_WIDTH);
        float contentHeight = UI::GetContentRegionAvail().y;
        
        if (UI::GetWindowSize().x < MIN_WINDOW_WIDTH) {
            UI::Text("Window too small. Please resize to at least " + MIN_WINDOW_WIDTH + "px wide.");
        } else {
            m_navigation.Render(NAV_WIDTH, contentHeight);
            UI::SameLine();
            
            UI::PushStyleColor(UI::Col::ChildBg, COLOR_CHILD_BG);
            vec2 contentAreaWindowPos = vec2(0, 0);
            if (UI::BeginChild("ContentArea", vec2(0, contentHeight), false, UI::WindowFlags::NoScrollbar)) {
                contentAreaWindowPos = UI::GetWindowPos();
                
                float topSectionHeight, buttonY, bottomSectionTopY;
                CalculateSectionLayout(contentHeight, topSectionHeight, buttonY, bottomSectionTopY);
                
                // Top section - page content
                if (UI::BeginChild("Content", vec2(0, topSectionHeight), false, UI::WindowFlags::NoScrollbar)) {
                    RenderPageContent();
                    UI::EndChild();
                }
                
                // Resize button between top and bottom sections
                RenderResizeButton(buttonY, contentAreaWindowPos, contentHeight);
                
                // Bottom section - media preview
                RenderBottomSection(m_bottomSectionHeight);
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
