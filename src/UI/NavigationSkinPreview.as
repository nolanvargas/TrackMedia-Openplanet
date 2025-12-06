namespace NavigationSkinPreview {
    float m_cachedPreviewHeight = 120.0;
    string m_cachedPreviewSkinFile = "";
    UI::Texture@ m_cachedTexture = null;
    string m_cachedTextureUrl = "";
    
    UI::Texture@ GetSkinTexture(const string &in skinFile) {
        // Return cached texture if same file
        if (skinFile == m_cachedPreviewSkinFile && m_cachedTexture !is null) {
            return m_cachedTexture;
        }
        
        UI::Texture@ result = null;
        
        if (State::skinningProperties.Exists("Skin.PackDesc.Url")) {
            string packDescUrl = string(State::skinningProperties["Skin.PackDesc.Url"]);
            if (packDescUrl.Length > 0) {
                auto cached = Images::FindExisting(packDescUrl);
                if (cached !is null && cached.texture !is null) {
                    @result = cached.texture;
                } else {
                    auto newCached = SkinPreviewService::LoadSkinPreview(packDescUrl);
                    if (newCached !is null && newCached.texture !is null) {
                        @result = newCached.texture;
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
                    if (cached !is null && cached.texture !is null) {
                        @result = cached.texture;
                    }
                }
            } else if (skinFile.StartsWith("http")) {
                auto cached = SkinPreviewService::LoadSkinPreview(skinFile);
                if (cached !is null && cached.texture !is null) {
                    @result = cached.texture;
                }
            } else {
                @result = UI::LoadTexture(skinFile);
            }
        }
        
        if (result is null) {
            @result = SkinPreviewService::GetPlaceholderTexture();
        }
        
        // Cache result
        m_cachedPreviewSkinFile = skinFile;
        @m_cachedTexture = result;
        
        return result;
    }
    
    void RenderTexture(UI::Texture@ tex) {
        if (tex is null) return;
        
        vec2 avail = UI::GetContentRegionAvail();
        if (avail.x <= 0 || avail.y <= 0) return;
        
        vec2 texSize = tex.GetSize();
        if (texSize.x <= 0 || texSize.y <= 0) return;
        
        float aspect = texSize.x / texSize.y;
        vec2 maxSize = vec2(avail.x * 0.8, avail.y * 0.8);
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
        
        UI::SetCursorPos(vec2(padX, padY));
        if (UI::BeginChild("CenteredTexture", display, false, UI::WindowFlags::NoScrollbar | UI::WindowFlags::NoInputs)) {
            UI::Image(tex, display);
            UI::EndChild();
        }
    }
    
    void Render(float maxWidth) {
        if (State::selectedBlock is null) return;
        if (State::blockSkinSelected < 0 || State::blockSkinSelected >= int(State::blockSkinFiles.Length)) return;

        // Cache string conversion to avoid per-frame allocation
        wstring skinFileW = State::blockSkinFiles[State::blockSkinSelected];
        string skinFile = string(skinFileW);
        
        // Early return if same file already cached
        if (skinFile == m_cachedPreviewSkinFile && m_cachedTexture !is null) {
            RenderTexture(m_cachedTexture);
            return;
        }
        
        UI::Texture@ tex = GetSkinTexture(skinFile);
        RenderTexture(tex);
    }

}

