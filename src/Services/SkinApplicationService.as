namespace SkinApplicationService {
    bool ApplySkinFromMediaItemBg(MediaItem@ mediaItem) {
        return ApplySkinFromMediaItem(mediaItem, "bg");
    }
    
    bool ApplySkinFromMediaItemFg(MediaItem@ mediaItem) {
        return ApplySkinFromMediaItem(mediaItem, "fg");
    }
    
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

    // Helper: Get current block skins with error handling
    void GetCurrentBlockSkins(CGameEditorPluginMap@ pluginMap, CGameCtnBlock@ block, wstring &out currBg, wstring &out currFg) {
        currBg = "";
        currFg = "";
        
        try {
            currBg = pluginMap.GetBlockSkinBg(block);
        } catch {}
        
        try {
            currFg = pluginMap.GetBlockSkinFg(block);
        } catch {}
    }

    // Helper: Get current item skins with error handling
    void GetCurrentItemSkins(CGameEditorPluginMap@ pluginMap, CGameCtnEditorScriptAnchoredObject@ item, wstring &out currBg, wstring &out currFg) {
        currBg = "";
        currFg = "";
        
        try {
            currBg = pluginMap.GetItemSkinBg(item);
        } catch {}
        
        try {
            currFg = pluginMap.GetItemSkinFg(item);
        } catch {}
    }

    bool ApplyBlockSkin(CGameCtnBlock@ block, const string &in skinUrl, const string &in layer) {
        if (block is null || skinUrl.Length == 0) {
            return false;
        }
        
        auto pluginMap = GetPluginMap();
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
        
        auto pluginMap = GetPluginMap();
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

    CGameEditorPluginMap@ GetPluginMap() {
        auto editor = cast<CGameCtnEditorFree>(GetApp().Editor);
        if (editor is null) {
            return null;
        }
        return cast<CGameEditorPluginMap>(editor.PluginMapType);
    }
}

