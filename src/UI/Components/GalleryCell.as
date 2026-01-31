namespace GalleryCell {
    // Global animation timer - single source of truth for all webm cells
    const float ANIMATION_INTERVAL_MS = 660.0f;
    const uint ANIMATION_FRAME_COUNT = 3;
    uint64 g_animationLastUpdate = 0;
    uint g_animationCurrentFrame = 0;

    void UpdateGlobalAnimation() {
        uint64 now = Time::Now;
        if (now - g_animationLastUpdate >= uint64(ANIMATION_INTERVAL_MS)) {
            g_animationLastUpdate = now;
            g_animationCurrentFrame = (g_animationCurrentFrame + 1) % ANIMATION_FRAME_COUNT;
        }
    }

    class Config {
        float imageWidth = 150.0f;
        float buttonHeight = 32.0f;
        float padding = 8.0f;
        float textHeight = 20.0f;
        float chipHeight = 18.0f;
        float chipPadding = 4.0f;
        float chipSpacing = 4.0f;
        float chipRounding = 3.0f;
    }

    float RenderChip(const string &in text, vec2 pos, vec4 bgColor, vec4 textColor, Config@ config) {
        float textWidth = text.Length * 8.0f;
        float chipWidth = config.chipPadding * 2 + textWidth;

        UI::SetCursorPos(pos);
        UI::PushStyleColor(UI::Col::ChildBg, bgColor);
        UI::PushStyleVar(UI::StyleVar::ChildRounding, config.chipRounding);
        UI::BeginChild("Chip##" + text, vec2(chipWidth, config.chipHeight), false, UI::WindowFlags::NoScrollbar);

        UI::SetCursorPos(vec2(config.chipPadding, 1));
        UI::PushStyleColor(UI::Col::Text, textColor);
        UI::PushFontSize(14.0f);
        UI::Text(text);
        UI::PopFontSize();
        UI::PopStyleColor();

        UI::EndChild();
        UI::PopStyleVar();
        UI::PopStyleColor();
        return chipWidth;
    }

    float CalculateImageHeight(GalleryCellData@ data, float contentWidth, float defaultWidth) {
        // Use fixed aspect ratio for unsupported format placeholders
        if (data.imageState == ImageState::Type::WebmUnsupported) {
            return UnsupportedPlaceholder::GetHeightForWidth(contentWidth);
        }
        if (data.imageState == ImageState::Type::Loaded && data.imageTexture !is null) {
            vec2 sz = data.imageTexture.GetSize();
            if (sz.x > 0 && sz.y > 0) return (sz.y / sz.x) * contentWidth;
        }
        if (data.imageWidth > 0 && data.imageHeight > 0) {
            return (float(data.imageHeight) / float(data.imageWidth)) * contentWidth;
        }
        return data.lockedAspectRatio ? contentWidth : defaultWidth;
    }

    float CalculateHeight(GalleryCellData@ data, float colWidth, Config@ config) {
        float contentWidth = colWidth - (config.padding * 2);
        float imgH = CalculateImageHeight(data, contentWidth, config.imageWidth);
        float textH = (data.title.Length > 0 ? config.textHeight : 0) + (data.subtitle.Length > 0 ? config.textHeight : 0);
        float btnH = (data.buttons.Length > 0 || data.HasChips()) ? config.buttonHeight : 0;
        float padTotal = config.padding * 2;
        if (data.title.Length > 0 || data.subtitle.Length > 0) padTotal += config.padding;
        if (data.buttons.Length > 0 || data.HasChips()) padTotal += config.padding;
        return padTotal + imgH + textH + btnH;
    }

    void Render(GalleryCellData@ data, uint index, float colWidth, float cellHeight, Config@ config) {
        UI::PushStyleColor(UI::Col::ChildBg, data.backgroundColor);
        UI::PushStyleVar(UI::StyleVar::ItemSpacing, vec2(0, 0));
        if (UI::BeginChild("GalleryCell##" + index, vec2(colWidth, cellHeight), false, UI::WindowFlags::NoScrollbar | UI::WindowFlags::NoScrollWithMouse)) {
            UI::PushID(int(index));
            float contentWidth = colWidth - (config.padding * 2);
            UI::Dummy(vec2(0, config.padding));
            UI::SetCursorPosX(config.padding);

            float imgH = CalculateImageHeight(data, contentWidth, config.imageWidth);
            vec2 imgSize = vec2(contentWidth, imgH);

            // Determine which texture to render (animation frame or static)
            UI::Texture@ textureToRender = null;
            if (data.hasAnimationFrames && data.animationFrames.Length > 0) {
                uint frameIdx = g_animationCurrentFrame % data.animationFrames.Length;
                @textureToRender = data.animationFrames[frameIdx];
            }
            if (textureToRender is null) {
                @textureToRender = data.imageTexture;
            }

            if (data.imageState == ImageState::Type::Loaded && textureToRender !is null) {
                UI::Image(textureToRender, imgSize);
            } else {
                RenderPlaceholder(data, imgSize);
            }

            if (data.title.Length > 0 || data.fileType.Length > 0) {
                UI::Dummy(vec2(0, config.padding));
                float rowY = UI::GetCursorPos().y;

                // Render title on left
                if (data.title.Length > 0) {
                    UI::SetCursorPosX(config.padding);
                    UI::Text(data.title.Length > 30 ? data.title.SubStr(0, 27) + "..." : data.title);
                }

                // Render file type badge on right
                if (data.fileType.Length > 0) {
                    string badgeText = data.fileType.ToUpper();
                    float badgeTextWidth = badgeText.Length * 7.0f;
                    float badgeWidth = config.chipPadding * 2 + badgeTextWidth;
                    float badgeX = config.padding + contentWidth - badgeWidth;
                    float badgeY = rowY + (config.textHeight - config.chipHeight) / 2.0f;
                    RenderChip(badgeText, vec2(badgeX, badgeY), Colors::CHIP_BG, Colors::WHITE, config);
                    UI::SetCursorPosY(rowY + config.textHeight);
                }
            }
            if (data.subtitle.Length > 0) {
                UI::SetCursorPosX(config.padding);
                UI::Text(data.subtitle);
            }
            if (data.buttons.Length > 0 || data.HasChips()) {
                UI::Dummy(vec2(0, config.padding));
                UI::SetCursorPosX(config.padding);
                RenderButtonsAndChips(data, index, contentWidth, config);
            }
            UI::Dummy(vec2(0, config.padding));
            UI::PopID();
        }
        UI::EndChild();
        UI::PopStyleVar();
        UI::PopStyleColor();
    }

    void RenderPlaceholder(GalleryCellData@ data, vec2 size) {
        // For unsupported formats, render the placeholder image
        if (data.imageState == ImageState::Type::WebmUnsupported) {
            UI::Texture@ placeholder = UnsupportedPlaceholder::Get();
            if (placeholder !is null) {
                UI::Image(placeholder, size);
                return;
            }
        }

        UI::PushStyleColor(UI::Col::ChildBg, Colors::GALLERY_CELL_PLACEHOLDER_BG);
        UI::Dummy(size);
        vec2 pos = UI::GetCursorPos();
        UI::SetCursorPos(pos - vec2(0, size.y));

        string text = "No image";
        bool isError = false;
        if (data.imageState == ImageState::Type::Loading) text = "Loading...";
        else if (data.imageState == ImageState::Type::Error) { text = "Error"; isError = true; }
        else if (data.imageState == ImageState::Type::WebmUnsupported) { text = "WEBM unsupported"; isError = true; }

        if (isError) UI::PushStyleColor(UI::Col::Text, Colors::ERROR);
        UI::Text(text);
        if (isError) UI::PopStyleColor();
        UI::SetCursorPos(pos);
        UI::PopStyleColor();
    }

    void RenderButtonsAndChips(GalleryCellData@ data, uint index, float contentWidth, Config@ config) {
        UI::PushID("ButtonsRow##" + index);
        array<ICellButton@>@ buttons = data.buttons;
        for (uint i = 0; i < buttons.Length; i++) {
            ICellButton@ btn = buttons[i];
            UI::PushID(int(i));
            if (i > 0) { UI::SameLine(); UI::Dummy(vec2(config.padding, 0)); UI::SameLine(); }

            float w = btn.GetWidth(index);
            if (w == 100.0f) w = config.buttonHeight;
            else if (w < 0.0f) w = (contentWidth - config.padding * float(buttons.Length - 1)) / float(buttons.Length);

            vec4 bg = btn.GetBackgroundColor(index);
            vec4 iconCol = btn.GetIconColor(index);
            bool useIcon = iconCol.w > 0.0f;

            StyleHelpers::PushCellButton(bg, useIcon ? iconCol : btn.GetTextColor(index));

            float fontMult = btn.GetFontSize(index);
            if (fontMult != 1.0f) UI::PushFontSize(13.0f * fontMult);

            bool enabled = btn.IsEnabled(index);
            if (!enabled) UI::BeginDisabled();

            string label = btn.GetLabel(index);
            string id = label.Length > 0 ? label + "##btn" + i : "##btn" + i;
            if (UI::Button(id, vec2(w, config.buttonHeight))) btn.OnClick(index);
            if (w < 0.0f && UI::IsItemHovered()) UI::SetMouseCursor(UI::MouseCursor::Hand);

            string tip = btn.GetTooltip(index);
            if (tip.Length > 0 && UI::IsItemHovered()) { UI::BeginTooltip(); UI::Text(tip); UI::EndTooltip(); }

            if (!enabled) UI::EndDisabled();
            if (fontMult != 1.0f) UI::PopFontSize();
            StyleHelpers::PopCellButton();
            UI::PopID();
        }

        // Render chips to the right of buttons
        if (data.HasChips()) {
            // Use button colors for chips (from first button if available)
            vec4 chipBg = buttons.Length > 0 ? buttons[0].GetBackgroundColor(index) : Colors::CHIP_BG;
            vec4 chipText = buttons.Length > 0 ? buttons[0].GetIconColor(index) : Colors::WHITE;

            float chipY = (config.buttonHeight - config.chipHeight) / 2.0f;
            if (buttons.Length > 0) {
                UI::SameLine();
                UI::Dummy(vec2(config.padding, 0));
                UI::SameLine();
            }
            vec2 cursorPos = UI::GetCursorPos();
            if (data.signSize.Length > 0 && data.signSize != "N/A") {
                float chipWidth = RenderChip(data.signSize, vec2(cursorPos.x, cursorPos.y + chipY), chipBg, chipText, config);
                cursorPos.x += chipWidth + config.chipSpacing;
            }
            if (data.signType.Length > 0 && data.signType != "N/A") {
                RenderChip(data.signType, vec2(cursorPos.x, cursorPos.y + chipY), chipBg, chipText, config);
            }
        }

        UI::PopID();
    }
}
