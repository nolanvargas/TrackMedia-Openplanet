namespace GalleryCell {
    class Config {
        float imageWidth = 150.0f;
        float buttonHeight = 32.0f;
        float padding = 8.0f;
        float textHeight = 20.0f;
    }
    
    float CalculateHeight(GalleryCellData@ data, float columnWidth, Config@ config) {
        if (data is null) return 0.0f;
        
        float contentWidth = columnWidth - (config.padding * 2);
        float imageHeight = CalculateImageHeight(data, contentWidth, config.imageWidth);
        
        float textHeight = 0.0f;
        if (data.title.Length > 0) textHeight += config.textHeight;
        if (data.subtitle.Length > 0) textHeight += config.textHeight;
        
        float buttonHeight = (data.buttons.Length > 0) ? config.buttonHeight : 0.0f;
        
        float paddingTotal = config.padding * 2;
        if (data.title.Length > 0 || data.subtitle.Length > 0) paddingTotal += config.padding;
        if (data.buttons.Length > 0) paddingTotal += config.padding;
        
        return paddingTotal + imageHeight + textHeight + buttonHeight;
    }
    
    float CalculateImageHeight(GalleryCellData@ data, float contentWidth, float defaultImageWidth) {
        if (data.lockedAspectRatio) {
            return contentWidth;
        }
        if (data.imageWidth > 0 && data.imageHeight > 0) {
            return (float(data.imageHeight) / float(data.imageWidth)) * contentWidth;
        }
        return defaultImageWidth;
    }
    
    void Render(GalleryCellData@ data, uint index, float columnWidth, float cellHeight, Config@ config) {
        if (data is null) return;
        
        UI::PushStyleColor(UI::Col::ChildBg, data.backgroundColor);
        UI::PushStyleVar(UI::StyleVar::ItemSpacing, vec2(0, 0));
        
        if (UI::BeginChild("GalleryCell##" + index, vec2(columnWidth, cellHeight), false, UI::WindowFlags::NoScrollbar | UI::WindowFlags::NoScrollWithMouse)) {
            float contentWidth = columnWidth - (config.padding * 2);
            
            UI::Dummy(vec2(0, config.padding));
            UI::SetCursorPosX(config.padding);
            RenderImage(data, contentWidth, config.imageWidth);
            
            if (data.title.Length > 0) {
                UI::Dummy(vec2(0, config.padding));
                UI::SetCursorPosX(config.padding);
                UI::Text(data.title.Length > 30 ? data.title.SubStr(0, 27) + "..." : data.title);
            }
            
            if (data.subtitle.Length > 0) {
                UI::SetCursorPosX(config.padding);
                UI::Text(data.subtitle);
            }
            
            if (data.buttons.Length > 0) {
                UI::Dummy(vec2(0, config.padding));
                UI::SetCursorPosX(config.padding);
                RenderButtonsRow(data.buttons, index, contentWidth, config);
            }
            
            UI::Dummy(vec2(0, config.padding));
        }
        UI::EndChild();
        
        UI::PopStyleVar();
        UI::PopStyleColor();
    }
    
    void RenderButtonsRow(array<ICellButton@>@ buttons, uint index, float contentWidth, Config@ config) {
        if (buttons is null || buttons.Length == 0) return;
        
        for (uint i = 0; i < buttons.Length; i++) {
            ICellButton@ button = buttons[i];
            if (button is null) continue;
            
            if (i > 0) {
                UI::SameLine();
                UI::Dummy(vec2(config.padding, 0));
                UI::SameLine();
            }
            
            float buttonWidth = button.GetWidth(index);
            if (buttonWidth == 100.0f) {
                buttonWidth = config.buttonHeight;
            }
            
            vec4 bgColor = button.GetBackgroundColor(index);
            vec4 textColor = button.GetTextColor(index);
            vec4 iconColor = button.GetIconColor(index);
            bool useIconColor = (iconColor.w > 0.0f);
            
            vec4 hoverColor = (bgColor.w > 0.5f) 
                ? vec4(bgColor.x * 1.3f, bgColor.y * 1.3f, bgColor.z * 1.3f, Math::Min(bgColor.w * 1.2f, 1.0f))
                : vec4(bgColor.x + 0.2f, bgColor.y + 0.2f, bgColor.z + 0.2f, Math::Min(bgColor.w + 0.2f, 1.0f));
            
            UI::PushStyleColor(UI::Col::Button, bgColor);
            UI::PushStyleColor(UI::Col::ButtonHovered, hoverColor);
            UI::PushStyleColor(UI::Col::ButtonActive, vec4(bgColor.x * 0.9f, bgColor.y * 0.9f, bgColor.z * 0.9f, bgColor.w));
            UI::PushStyleColor(UI::Col::Text, useIconColor ? iconColor : textColor);
            UI::PushStyleVar(UI::StyleVar::FrameRounding, 4.0f);
            
            float fontSizeMultiplier = button.GetFontSize(index);
            if (fontSizeMultiplier != 1.0f) {
                UI::PushFontSize(13.0f * fontSizeMultiplier);
            }
            
            bool enabled = button.IsEnabled(index);
            if (!enabled) {
                UI::BeginDisabled();
            }
            
            if (UI::Button(button.GetLabel(index) + "##btn" + index + "_" + i, vec2(buttonWidth, config.buttonHeight))) {
                button.OnClick(index);
            }
            
            if (button.IsIconTopRight(index) && UI::IsItemHovered()) {
                UI::SetMouseCursor(UI::MouseCursor::Hand);
            }
            
            string tooltip = button.GetTooltip(index);
            if (tooltip.Length > 0 && UI::IsItemHovered()) {
                UI::BeginTooltip();
                UI::Text(tooltip);
                UI::EndTooltip();
            }
            
            if (!enabled) {
                UI::EndDisabled();
            }
            
            if (fontSizeMultiplier != 1.0f) {
                UI::PopFontSize();
            }
            
            UI::PopStyleVar();
            UI::PopStyleColor(4);
        }
    }
    
    void RenderImage(GalleryCellData@ data, float contentWidth, float defaultImageWidth) {
        vec2 imageSize = vec2(contentWidth, CalculateImageHeight(data, contentWidth, defaultImageWidth));
        
        if (data.imageState == ImageState::Type::Loaded && data.imageTexture !is null) {
            UI::Image(data.imageTexture, imageSize);
        } else {
            RenderPlaceholder(imageSize, data.imageState);
        }
    }
    
    void RenderPlaceholder(vec2 size, ImageState::Type state) {
        UI::PushStyleColor(UI::Col::ChildBg, vec4(0.15f, 0.15f, 0.15f, 1.0f));
        UI::Dummy(size);
        vec2 dummyPos = UI::GetCursorPos();
        UI::SetCursorPos(dummyPos - vec2(0, size.y));
        
        string placeholderText = "No image";
        if (state == ImageState::Type::Loading) {
            placeholderText = "Loading...";
        } else if (state == ImageState::Type::Error) {
            placeholderText = "Error";
            UI::PushStyleColor(UI::Col::Text, vec4(0.8f, 0.2f, 0.2f, 1.0f));
        }
        
        UI::Text(placeholderText);
        
        if (state == ImageState::Type::Error) {
            UI::PopStyleColor();
        }
        
        UI::SetCursorPos(dummyPos);
        UI::PopStyleColor();
    }
    
}
