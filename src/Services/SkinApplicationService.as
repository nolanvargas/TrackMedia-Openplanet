namespace SkinApplicationService {
    
    bool ApplySkinFromMediaItem(MediaItem@ mediaItem, const string &in layer = "bg") {
        if (mediaItem is null || mediaItem.key.Length == 0) {
            Logging::Error("Cannot apply skin: media item is null or has no key", true);
            return false;
        }
        
        string skinUrl = "https://cdn.trackmedia.io/" + mediaItem.key;
        
        if (State::selectedBlock !is null) {
            return ApplyBlockSkin(State::selectedBlock, skinUrl, layer);
        } else if (State::selectedItem !is null) {
            return ApplyItemSkin(State::selectedItem, skinUrl, layer);
        } else {
            Logging::Warn("Cannot apply skin: no block or item selected", true);
            return false;
        }
    }

    // Helper: Calculate new bg/fg skin URLs based on layer
    void CalculateSkinUrls(const string &in layer, const wstring &in skinUrlW, const wstring &in currBg, const wstring &in currFg, wstring &out newBg, wstring &out newFg) {
        newBg = (layer == "bg" || layer == "all") ? skinUrlW : currBg;
        newFg = (layer == "fg") ? skinUrlW : (layer == "all" ? wstring("") : currFg);
    }

    void GetCurrentBlockSkins(CGameEditorPluginMap@ pluginMap, CGameCtnBlock@ block, wstring &out currBg, wstring &out currFg) {
        currBg = "";
        currFg = "";
        
        try {
            currBg = pluginMap.GetBlockSkinBg(block);
        } catch {
            Logging::Debug("Failed to get block background skin");
        }
        
        try {
            currFg = pluginMap.GetBlockSkinFg(block);
        } catch {
            Logging::Debug("Failed to get block foreground skin");
        }
    }

    void GetCurrentItemSkins(CGameEditorPluginMap@ pluginMap, CGameCtnEditorScriptAnchoredObject@ item, wstring &out currBg, wstring &out currFg) {
        currBg = "";
        currFg = "";
        
        try {
            currBg = pluginMap.GetItemSkinBg(item);
        } catch {
            Logging::Debug("Failed to get item background skin");
        }
        
        try {
            currFg = pluginMap.GetItemSkinFg(item);
        } catch {
            Logging::Debug("Failed to get item foreground skin");
        }
    }

    bool ApplyBlockSkin(CGameCtnBlock@ block, const string &in skinUrl, const string &in layer) {
        if (block is null || skinUrl.Length == 0) {
            return false;
        }
        
        auto pluginMap = EditorUtils::GetEditorPluginMap();
        if (pluginMap is null) {
            Logging::Error("Cannot apply block skin: editor plugin map not available", true);
            return false;
        }
        
        wstring skinUrlW = wstring(skinUrl);
        wstring currBg, currFg;
        GetCurrentBlockSkins(pluginMap, block, currBg, currFg);
        
        wstring newBg, newFg;
        CalculateSkinUrls(layer, skinUrlW, currBg, currFg, newBg, newFg);
        
        try {
            pluginMap.SetBlockSkins(block, newBg, newFg);
            SkinPreviewRenderer::SetAppliedSkin(skinUrl);
            // Look into this
            SkinManager::RefreshBlockSkinLists();
            return true;
        } catch {
            Logging::Error("Failed to apply block skin: " + getExceptionInfo(), true);
            return false;
        }
    }

    bool ApplyItemSkin(CGameCtnEditorScriptAnchoredObject@ item, const string &in skinUrl, const string &in layer) {
        if (item is null || skinUrl.Length == 0) {
            return false;
        }
        
        auto pluginMap = EditorUtils::GetEditorPluginMap();
        if (pluginMap is null) {
            Logging::Error("Cannot apply item skin: editor plugin map not available", true);
            return false;
        }
        
        wstring skinUrlW = wstring(skinUrl);
        wstring currBg, currFg;
        GetCurrentItemSkins(pluginMap, item, currBg, currFg);
        
        wstring newBg, newFg;
        CalculateSkinUrls(layer, skinUrlW, currBg, currFg, newBg, newFg);
        
        try {
            pluginMap.SetItemSkins(item, newBg, newFg);
            SkinPreviewRenderer::SetAppliedSkin(skinUrl);
            SkinManager::RefreshItemSkinLists();
            return true;
        } catch {
            Logging::Error("Failed to apply item skin: " + getExceptionInfo(), true);
            return false;
        }
    }

}

