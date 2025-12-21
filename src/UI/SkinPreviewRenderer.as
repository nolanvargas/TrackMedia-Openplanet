namespace SkinPreviewRenderer {
    string m_cachedPreviewSkinFile = "";
    UI::Texture@ m_cachedTexture = null;
    string m_appliedSkinUrl = "";
    bool m_isWebmUnsupported = false;
    
    UI::Texture@ GetSkinTexture(const string &in skinFile) {
        // Return cached texture if same file
        if (skinFile == m_cachedPreviewSkinFile && m_cachedTexture !is null) {
            m_isWebmUnsupported = false;
            return m_cachedTexture;
        }
        
        UI::Texture@ result = null;
        m_isWebmUnsupported = false;
        
        if (State::skinningProperties.Exists("Skin.PackDesc.Url")) {
            string packDescUrl = string(State::skinningProperties["Skin.PackDesc.Url"]);
            if (packDescUrl.Length > 0) {
                auto cached = Images::FindExisting(packDescUrl);
                if (SkinPreviewService::IsPreviewLoaded(cached)) {
                    @result = SkinPreviewService::GetPreviewTexture(cached);
                } else {
                    auto newCached = SkinPreviewService::LoadSkinPreview(packDescUrl);
                    if (SkinPreviewService::IsPreviewLoaded(newCached)) {
                        @result = SkinPreviewService::GetPreviewTexture(newCached);
                    } else if (SkinPreviewService::IsPreviewUnsupportedWebm(newCached)) {
                        m_isWebmUnsupported = true;
                    }
                }
            }
        }
        
        if (result is null) {
            if (skinFile.StartsWith("https://cdn.trackmedia.io/")) {
                string key = skinFile.SubStr(28);
                for (uint i = 0; i < State::mediaItems.Length; i++) {
                    MediaItem@ item = State::mediaItems[i];
                    if (item.key == key && item.IsThumbLoaded()) {
                        @result = item.GetThumbTexture();
                        break;
                    }
                }
                if (result is null) {
                    auto cached = SkinPreviewService::LoadSkinPreview(skinFile);
                    if (SkinPreviewService::IsPreviewLoaded(cached)) {
                        @result = SkinPreviewService::GetPreviewTexture(cached);
                    } else if (SkinPreviewService::IsPreviewUnsupportedWebm(cached)) {
                        m_isWebmUnsupported = true;
                    }
                }
            } else if (skinFile.StartsWith("http")) {
                auto cached = SkinPreviewService::LoadSkinPreview(skinFile);
                if (SkinPreviewService::IsPreviewLoaded(cached)) {
                    @result = SkinPreviewService::GetPreviewTexture(cached);
                } else if (SkinPreviewService::IsPreviewUnsupportedWebm(cached)) {
                    m_isWebmUnsupported = true;
                }
            } else {
                @result = UI::LoadTexture(skinFile);
            }
        }
        
        
        // Cache result
        m_cachedPreviewSkinFile = skinFile;
        @m_cachedTexture = result;
        
        return result;
    }
    
    void RenderWebmUnsupported(vec2 avail, float& out textBottomY) {
        textBottomY = 0.0f;
        if (avail.x <= 0 || avail.y <= 0) return;
        
        string text = "WEBM unsupported";
        
        // Center text approximately (without precise measurement)
        float padY = avail.y * 0.5 - 10.0f; // Approximate text height offset
        float padX = avail.x * 0.5 - 60.0f; // Approximate text width offset
        
        textBottomY = padY + 20.0f; // Approximate text height
        
        UI::SetCursorPos(vec2(padX, padY));
        UI::Text(text);
    }
    
    void RenderTexture(UI::Texture@ tex, vec2 avail, float& out textureBottomY) {
        textureBottomY = 0.0f;

        if (tex is null) return;
        if (avail.x <= 0 || avail.y <= 0) return;
        float paddingPercent = 0.8f;
        
        vec2 texSize = tex.GetSize();
        if (texSize.x <= 0 || texSize.y <= 0) return;
        
        float aspect = texSize.x / texSize.y;

        vec2 maxSize = avail;
        maxSize.x *= paddingPercent;
        maxSize.y *= paddingPercent;
        vec2 display = maxSize;
        
        float wideH = maxSize.x / aspect;
        if (wideH <= maxSize.y) {
            display = vec2(maxSize.x, wideH);

        } else {
            float tallW = maxSize.y * aspect;

            display = vec2(tallW, maxSize.y);

        }
        
        float padX = (avail.x - display.x) * 0.5;
        float padY = (avail.y - display.y) * 0.5;
        
        textureBottomY = padY + display.y;
        
        UI::SetCursorPos(vec2(padX, padY));
        UI::BeginChild("CenteredTexture", display, false, UI::WindowFlags::NoScrollbar | UI::WindowFlags::NoInputs);
        UI::Image(tex, display);
        UI::EndChild();
    }
    
    void SetAppliedSkin(const string &in skinUrl) {
        m_appliedSkinUrl = skinUrl;
        // Clear cache to force reload
        m_cachedPreviewSkinFile = "";
        @m_cachedTexture = null;
        m_isWebmUnsupported = false;
    }
    
    void Render(vec2 availableSize) {
        if (State::selectedBlock is null) return;
        
        string skinFile = "";
        
        // First check if a skin was just applied - show it immediately
        if (m_appliedSkinUrl.Length > 0) {
            skinFile = m_appliedSkinUrl;
        } else {
            // Otherwise get current skin from block
            auto@ editor = EditorUtils::GetEditorPluginMap();
            if (editor !is null) {
                wstring currSkin = "";
                try { 
                    currSkin = editor.GetBlockSkin(State::selectedBlock); 
                } catch {
                    Logging::Debug("Failed to get block skin for preview");
                }
                
                if (currSkin.Length > 0) {
                    skinFile = string(currSkin);
                }
            }
            
            // If no skin found, don't render preview
            if (skinFile.Length == 0) {
                return;
            }
        }
        
        // Clear cache if skin file changed
        if (skinFile != m_cachedPreviewSkinFile) {
            m_cachedPreviewSkinFile = "";
            @m_cachedTexture = null;
            m_isWebmUnsupported = false;
        }
        
        float textureBottomY = 0.0f;
        UI::Texture@ tex = GetSkinTexture(skinFile);
        
        if (m_isWebmUnsupported) {
            RenderWebmUnsupported(availableSize, textureBottomY);
        } else {
            RenderTexture(tex, availableSize, textureBottomY);
        }
        
        // Clear applied skin after showing it (so next frame reads from block)
        if (m_appliedSkinUrl.Length > 0) {
            m_appliedSkinUrl = "";
        }
    }

}

