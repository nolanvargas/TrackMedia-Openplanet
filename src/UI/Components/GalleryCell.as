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
        if (data.imageState == ImageState::Type::Loaded && data.imageTexture !is null) {
            vec2 texSize = data.imageTexture.GetSize();
            if (texSize.x > 0 && texSize.y > 0) {
                return (texSize.y / texSize.x) * contentWidth;
            }
        }
        if (data.imageWidth > 0 && data.imageHeight > 0) {
            return (float(data.imageHeight) / float(data.imageWidth)) * contentWidth;
        }
        if (data.lockedAspectRatio) {
            return contentWidth;
        }
        return defaultImageWidth;
    }
    
    void Render(GalleryCellData@ data, uint index, float columnWidth, float cellHeight, Config@ config) {
        if (data is null) return;
        
        UI::PushStyleColor(UI::Col::ChildBg, data.backgroundColor);
        UI::PushStyleVar(UI::StyleVar::ItemSpacing, vec2(0, 0));
        
        if (UI::BeginChild("GalleryCell##" + index, vec2(columnWidth, cellHeight), false, UI::WindowFlags::NoScrollbar | UI::WindowFlags::NoScrollWithMouse)) {
            UI::PushID(int(index));
            
            float contentWidth = columnWidth - (config.padding * 2);
            
            UI::Dummy(vec2(0, config.padding));
            UI::SetCursorPosX(config.padding);
            RenderImage(data, contentWidth, config.imageWidth);
            
            if (data.title.Length > 0) {
                UI::Dummy(vec2(0, config.padding));
                UI::SetCursorPosX(config.padding);
                if (data.title.Length > 30) {
                    UI::Text(data.title.SubStr(0, 27) + "...");
                } else {
                    UI::Text(data.title);
                }
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
            
            UI::PopID();
        }
        UI::EndChild();
        
        UI::PopStyleVar();
        UI::PopStyleColor();
    }
    
    void RenderButtonsRow(array<ICellButton@>@ buttons, uint index, float contentWidth, Config@ config) {
        if (buttons is null || buttons.Length == 0) return;
        
        UI::PushID("ButtonsRow##" + index);
        
        for (uint i = 0; i < buttons.Length; i++) {
            ICellButton@ button = buttons[i];
            if (button is null) continue;
            
            UI::PushID(int(i));
            
            if (i > 0) {
                UI::SameLine();
                UI::Dummy(vec2(config.padding, 0));
                UI::SameLine();
            }
            
            float buttonWidth = button.GetWidth(index);
            // Special width values: 100.0f = square button, negative = full width
            if (buttonWidth == 100.0f) {
                buttonWidth = config.buttonHeight;
            } else if (buttonWidth < 0.0f) {
                // Sentinel value: use full content width (minus spacing for multiple buttons)
                float totalSpacing = config.padding * float(buttons.Length - 1);
                buttonWidth = (contentWidth - totalSpacing) / float(buttons.Length);
            }
            
            vec4 bgColor = button.GetBackgroundColor(index);
            vec4 textColor = button.GetTextColor(index);
            vec4 iconColor = button.GetIconColor(index);
            bool useIconColor = (iconColor.w > 0.0f);
            
            UI::PushStyleColor(UI::Col::Button, bgColor);
            UI::PushStyleColor(UI::Col::ButtonHovered, bgColor); // Same color as non-hovered
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
            
            string label = button.GetLabel(index);
            string buttonId = (label.Length > 0) 
                ? (label + "##btn" + i)
                : ("##btn" + i);
            
            if (UI::Button(buttonId, vec2(buttonWidth, config.buttonHeight))) {
                button.OnClick(index);
            }
            
            if (buttonWidth < 0.0f && UI::IsItemHovered()) {
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
            UI::PopStyleColor(4); // Button, ButtonHovered, ButtonActive, Text
            
            UI::PopID();
        }
        
        UI::PopID();
    }
    
    void RenderImage(GalleryCellData@ data, float contentWidth, float defaultImageWidth) {
        vec2 imageSize = vec2(contentWidth, CalculateImageHeight(data, contentWidth, defaultImageWidth));
        
        if (data.imageState == ImageState::Type::Loaded) {
            UI::Texture@ tex = data.imageTexture;

            // To be applied when webp support is added
            // UI::Texture@ animTex = GetAnimationFrameTexture(data);
            // if (animTex !is null) {
            //     @tex = animTex;
            // }

            if (tex !is null) {
                UI::Image(tex, imageSize);
                return;
            }
        }

        RenderPlaceholder(imageSize, data.imageState);
    }
    
    void RenderPlaceholder(vec2 size, ImageState::Type state) {
        UI::PushStyleColor(UI::Col::ChildBg, Colors::GALLERY_CELL_PLACEHOLDER_BG);
        UI::Dummy(size);
        vec2 dummyPos = UI::GetCursorPos();
        UI::SetCursorPos(dummyPos - vec2(0, size.y));
        
        string placeholderText = "No image";
        bool isErrorState = false;
        if (state == ImageState::Type::Loading) {
            placeholderText = "Loading...";
        } else if (state == ImageState::Type::Error) {
            placeholderText = "Error";
            isErrorState = true;
        } else if (state == ImageState::Type::WebpUnsupported) {
            placeholderText = "WebP support coming soon";
            isErrorState = true;
        } else if (state == ImageState::Type::WebmUnsupported) {
            placeholderText = "WEBM unsupported";
            isErrorState = true;
        }
        
        if (isErrorState) {
            UI::PushStyleColor(UI::Col::Text, Colors::ERROR);
        }
        
        UI::Text(placeholderText);
        
        if (isErrorState) {
            UI::PopStyleColor();
        }
        
        UI::SetCursorPos(dummyPos);
        UI::PopStyleColor();
    }
    
}
