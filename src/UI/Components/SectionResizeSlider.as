namespace SectionResizeSlider {
    const float BUTTON_HEIGHT = 7.0;
    const float BUTTON_WIDTH = 75.0;
    const float BUTTON_HOVER_SIZE_INCREASE = 4.0;
    const float BUTTON_OFFSET_FROM_BOTTOM_TOP = 3.0;
    const float BUTTON_SPACING = 3.0;
    const float TOP_SECTION_BOTTOM_PADDING = 5.0;
    
    float m_bottomSectionHeight = -1.0;
    bool m_buttonWasHovered = false;
    bool m_buttonWasActive = false;
    
    float GetBottomSectionHeight() {
        return m_bottomSectionHeight;
    }
    
    void SetBottomSectionHeight(float height) {
        m_bottomSectionHeight = height;
    }
    
    void CalculateSectionLayout(float contentHeight, float& out topSectionHeight, float& out buttonY, float& out bottomSectionTopY) {
        if (m_bottomSectionHeight < 0.0) {
            m_bottomSectionHeight = contentHeight * 0.5;
        }
        float minBottomHeight = contentHeight * 0.15;
        float maxBottomHeight = contentHeight * 0.35;
        m_bottomSectionHeight = Math::Clamp(m_bottomSectionHeight, minBottomHeight, maxBottomHeight);
        bottomSectionTopY = contentHeight - m_bottomSectionHeight;
        buttonY = bottomSectionTopY - BUTTON_HEIGHT - BUTTON_SPACING;
        topSectionHeight = buttonY - TOP_SECTION_BOTTOM_PADDING;
    }
    
    void Render(float buttonY, vec2 contentAreaWindowPos, float contentHeight) {
        float buttonWidth = BUTTON_WIDTH;
        float buttonHeight = BUTTON_HEIGHT;
        float adjustedButtonY = buttonY;
        if (m_buttonWasHovered || m_buttonWasActive) {
            buttonWidth += BUTTON_HOVER_SIZE_INCREASE;
            buttonHeight += BUTTON_HOVER_SIZE_INCREASE;
            adjustedButtonY -= BUTTON_HOVER_SIZE_INCREASE * 0.5;
        }
        float availableWidth = UI::GetContentRegionAvail().x;
        vec2 currentPos = UI::GetCursorPos();
        float buttonX = currentPos.x + (availableWidth - buttonWidth) * 0.5;
        UI::PushStyleColor(UI::Col::Button, Colors::BUTTON);
        UI::PushStyleColor(UI::Col::ButtonHovered, Colors::BUTTON_HOVERED);
        UI::PushStyleColor(UI::Col::ButtonActive, Colors::BUTTON_ACTIVE);
        UI::SetCursorPos(vec2(buttonX, adjustedButtonY));
        UI::Button("##ResizeButton", vec2(buttonWidth, buttonHeight));
        m_buttonWasHovered = UI::IsItemHovered();
        m_buttonWasActive = UI::IsItemActive();
        if (m_buttonWasActive) {
            vec2 mousePos = UI::GetMousePos();
            float relativeMouseY = mousePos.y - contentAreaWindowPos.y;
            float totalButtonOffset = BUTTON_OFFSET_FROM_BOTTOM_TOP + BUTTON_SPACING;
            m_bottomSectionHeight = contentHeight - relativeMouseY - totalButtonOffset;
            float minBottomHeight = contentHeight * 0.15;
            float maxBottomHeight = contentHeight * 0.35;
            m_bottomSectionHeight = Math::Clamp(m_bottomSectionHeight, minBottomHeight, maxBottomHeight);
        }
        UI::PopStyleColor(3);
    }
}
