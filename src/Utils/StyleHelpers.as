// Shared UI style pushing patterns
namespace StyleHelpers {
    // Standard button style (5 colors)
    void PushButton() {
        UI::PushStyleColor(UI::Col::Button, Colors::BUTTON);
        UI::PushStyleColor(UI::Col::ButtonHovered, Colors::BUTTON_HOVERED);
        UI::PushStyleColor(UI::Col::ButtonActive, Colors::ACTIVE);
        UI::PushStyleColor(UI::Col::HeaderActive, Colors::ACTIVE);
        UI::PushStyleColor(UI::Col::Text, Colors::WHITE);
    }

    void PopButton() {
        UI::PopStyleColor(5);
    }

    // Selectable button style for filter bars (5 colors)
    void PushSelectableButton(bool selected) {
        UI::PushStyleColor(UI::Col::Button, selected ? Colors::ACTIVE : Colors::BUTTON);
        UI::PushStyleColor(UI::Col::ButtonHovered, selected ? Colors::ACTIVE : Colors::BUTTON_HOVERED);
        UI::PushStyleColor(UI::Col::ButtonActive, Colors::ACTIVE);
        UI::PushStyleColor(UI::Col::HeaderActive, Colors::ACTIVE);
        UI::PushStyleColor(UI::Col::Text, selected ? vec4(0,0,0,1) : Colors::TEXT_DIMMED);
    }

    void PopSelectableButton() {
        UI::PopStyleColor(5);
    }

    // Combo box style (11 colors)
    void PushCombo() {
        UI::PushStyleColor(UI::Col::FrameBg, Colors::BUTTON);
        UI::PushStyleColor(UI::Col::FrameBgHovered, Colors::BUTTON_HOVERED);
        UI::PushStyleColor(UI::Col::FrameBgActive, Colors::ACTIVE);
        UI::PushStyleColor(UI::Col::Button, Colors::BUTTON);
        UI::PushStyleColor(UI::Col::ButtonHovered, Colors::BUTTON_HOVERED);
        UI::PushStyleColor(UI::Col::ButtonActive, Colors::ACTIVE);
        UI::PushStyleColor(UI::Col::Header, Colors::ACTIVE);
        UI::PushStyleColor(UI::Col::HeaderHovered, Colors::ACTIVE);
        UI::PushStyleColor(UI::Col::HeaderActive, Colors::ACTIVE);
        UI::PushStyleColor(UI::Col::PopupBg, Colors::DARK);
        UI::PushStyleColor(UI::Col::Text, Colors::WHITE);
    }

    void PopCombo() {
        UI::PopStyleColor(11);
    }

    // Dimmed text style
    void PushDimmedText() {
        UI::PushStyleColor(UI::Col::Text, Colors::TEXT_DIMMED);
    }

    void PopDimmedText() {
        UI::PopStyleColor();
    }

    // Card style (ChildBg, Border, rounding)
    void PushCardStyle() {
        UI::PushStyleColor(UI::Col::ChildBg, Colors::GALLERY_CELL_BG);
        UI::PushStyleColor(UI::Col::Border, vec4(0.3f, 0.3f, 0.3f, 1.0f));
        UI::PushStyleVar(UI::StyleVar::ChildRounding, 4.0f);
        UI::PushStyleVar(UI::StyleVar::ChildBorderSize, 1.0f);
    }

    void PopCardStyle() {
        UI::PopStyleVar(2);
        UI::PopStyleColor(2);
    }

    // Gallery cell button style (5 colors + 1 var)
    void PushCellButton(vec4 bg, vec4 textColor) {
        UI::PushStyleColor(UI::Col::Button, bg);
        UI::PushStyleColor(UI::Col::ButtonHovered, bg);
        UI::PushStyleColor(UI::Col::ButtonActive, vec4(bg.x * 0.9f, bg.y * 0.9f, bg.z * 0.9f, bg.w));
        UI::PushStyleColor(UI::Col::HeaderActive, Colors::ACTIVE);
        UI::PushStyleColor(UI::Col::Text, textColor);
        UI::PushStyleVar(UI::StyleVar::FrameRounding, 4.0f);
    }

    void PopCellButton() {
        UI::PopStyleVar();
        UI::PopStyleColor(5);
    }
}
