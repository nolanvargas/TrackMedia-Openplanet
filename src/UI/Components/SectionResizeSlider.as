namespace SectionResizeSlider {
    // Layout constants
    const float BUTTON_HEIGHT = 7.0;
    const float BUTTON_WIDTH = 75.0;
    const float BUTTON_HOVER_SIZE_INCREASE = 4.0;
    const float BUTTON_OFFSET_FROM_BOTTOM_TOP = 3.0;
    const float BUTTON_SPACING = 3.0;
    const float TOP_SECTION_BOTTOM_PADDING = 5.0;
    const float MIN_BOTTOM_HEIGHT = 50.0;
    const float TOP_SECTION_RESERVE = 100.0;
    
    
    // State
    float m_bottomSectionHeight = -1.0; // -1 means uninitialized
    bool m_buttonWasHovered = false; // Track hover state for size adjustment
    bool m_buttonWasActive = false; // Track active state for size adjustment
    
    // Get current bottom section height
    float GetBottomSectionHeight() {
        return m_bottomSectionHeight;
    }
    
    // Set bottom section height (for initialization)
    void SetBottomSectionHeight(float height) {
        m_bottomSectionHeight = height;
    }
    
    // Helper: Clamp bottom section height to percentage-based range (15% min, 35% max)
    void ClampBottomSectionHeight(float contentHeight) {
        float minBottomHeight = contentHeight * 0.15;
        float maxBottomHeight = contentHeight * 0.35;
        m_bottomSectionHeight = Math::Clamp(m_bottomSectionHeight, minBottomHeight, maxBottomHeight);
    }

    // Helper: Calculate section layout dimensions
    void CalculateSectionLayout(float contentHeight, float& out topSectionHeight, float& out buttonY, float& out bottomSectionTopY) {
        // Initialize bottom section height if not set
        if (m_bottomSectionHeight < 0.0) {
            m_bottomSectionHeight = contentHeight * 0.5;
        }
        
        ClampBottomSectionHeight(contentHeight);
        
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
        m_bottomSectionHeight = contentHeight - relativeMouseY - totalButtonOffset;
        ClampBottomSectionHeight(contentHeight);
    }
    
    // Helper: Push button style colors
    void PushButtonStyles() {
        UI::PushStyleColor(UI::Col::Button, Colors::BUTTON);
        UI::PushStyleColor(UI::Col::ButtonHovered, Colors::BUTTON_HOVERED);
        UI::PushStyleColor(UI::Col::ButtonActive, Colors::BUTTON_ACTIVE);
    }
    
    // Helper: Render resize button between top and bottom sections
    void Render(float buttonY, vec2 contentAreaWindowPos, float contentHeight) {
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
}
