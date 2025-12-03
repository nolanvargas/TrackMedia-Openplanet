namespace NavigationSkinPreview {
    float m_cachedPreviewHeight = 120.0;
    string m_cachedPreviewSkinFile = "";
    
    UI::Texture@ GetSkinTexture(const string &in skinFile) {
        if (State::skinningProperties.Exists("Skin.PackDesc.Url")) {
            string packDescUrl = string(State::skinningProperties["Skin.PackDesc.Url"]);
            if (packDescUrl.Length > 0) {
                auto cached = Images::FindExisting(packDescUrl);
                if (cached !is null && cached.texture !is null) {
                    return cached.texture;
                }
                auto newCached = SkinPreviewService::LoadSkinPreview(packDescUrl);
                if (newCached !is null && newCached.texture !is null) {
                    return newCached.texture;
                }
            }
        }
        
        if (skinFile.StartsWith("https://cdn.trackmedia.io/")) {
            string key = skinFile.SubStr(28);
            for (uint i = 0; i < State::mediaItems.Length; i++) {
                MediaItem@ item = State::mediaItems[i];
                if (item.key == key && item.IsThumbLoaded()) {
                    return item.GetThumbTexture();
                }
            }
            auto cached = SkinPreviewService::LoadSkinPreview(skinFile);
            if (cached !is null && cached.texture !is null) {
                return cached.texture;
            }
        } else if (skinFile.StartsWith("http")) {
            auto cached = SkinPreviewService::LoadSkinPreview(skinFile);
            if (cached !is null && cached.texture !is null) {
                return cached.texture;
            }
        } else {
            return UI::LoadTexture(skinFile);
        }
        
        return SkinPreviewService::GetPlaceholderTexture();
    }
    
    void Render(float maxWidth) {
        if (State::selectedBlock is null) return;
        if (State::blockSkinSelected < 0 || State::blockSkinSelected >= int(State::blockSkinFiles.Length)) return;

        string skinName = State::blockSkinNames[State::blockSkinSelected];
        string skinFile = string(State::blockSkinFiles[State::blockSkinSelected]);

        float padding = 8.0;
        float maxWidthAdjusted = Math::Max(UI::GetContentRegionAvail().x - (padding * 2), 50.0);
        UI::Texture@ tex = GetSkinTexture(skinFile);
        
        float maxPreviewHeight = 200.0;
        float previewHeight = m_cachedPreviewHeight;
        
        if (m_cachedPreviewSkinFile != skinFile && tex !is null) {
            vec2 texSize = tex.GetSize();
            if (texSize.x > 0 && texSize.y > 0) {
                previewHeight = Math::Max(Math::Min((maxWidthAdjusted / (texSize.x / texSize.y)) + 40.0, maxPreviewHeight), 80.0);
                m_cachedPreviewHeight = previewHeight;
                m_cachedPreviewSkinFile = skinFile;
            } else {
                previewHeight = 120.0;
            }
        }
        
        UI::PushStyleVar(UI::StyleVar::ChildRounding, 3.0);
        UI::PushStyleColor(UI::Col::ChildBg, vec4(0.15, 0.15, 0.15, 1.0));
        if (UI::BeginChild("SkinPreview", vec2(0, previewHeight), false, UI::WindowFlags::NoScrollbar | UI::WindowFlags::NoScrollWithMouse)) {
            UI::Dummy(vec2(0, 4));
            
            if (tex !is null) {
                vec2 texSize = tex.GetSize();
                float aspectRatio = (texSize.x > 0 && texSize.y > 0) ? texSize.x / texSize.y : 1.0;
                vec2 displaySize = vec2(maxWidthAdjusted, maxWidthAdjusted / aspectRatio);
                float maxImageHeight = maxPreviewHeight - 40.0;
                if (displaySize.y > maxImageHeight) {
                    displaySize = vec2(maxImageHeight * aspectRatio, maxImageHeight);
                }
                if (displaySize.x < 10 || displaySize.y < 10) {
                    displaySize = vec2(64, 64);
                }
                UI::SetCursorPosX(padding);
                UI::Image(tex, displaySize);
            } else {
                float fallbackSize = Math::Min(maxWidthAdjusted, maxPreviewHeight - 24.0);
                UI::PushStyleColor(UI::Col::ChildBg, vec4(0.2, 0.2, 0.2, 1.0));
                UI::SetCursorPosX(padding);
                UI::Dummy(vec2(fallbackSize, fallbackSize));
                UI::PopStyleColor();
            }
            
            UI::Dummy(vec2(0, 2));
            UI::Text(skinName.Length == 0 ? "Unknown" : skinName);
            UI::EndChild();
        }
        UI::PopStyleColor();
        UI::PopStyleVar();
        
        UI::Dummy(vec2(0, 8));
    }
}

