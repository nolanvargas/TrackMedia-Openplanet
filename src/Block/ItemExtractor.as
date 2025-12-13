namespace ItemExtractor {
    void ExtractSkinningProperties(CGameCtnAnchoredObject@ item, CGameCtnEditorFree@ editor) {
        if (item is null || editor is null) return;
        auto@ pluginMap = cast<CGameEditorPluginMap>(editor.PluginMapType);
        if (pluginMap is null) return;
    
        auto@ itemModel = item.ItemModel;
        if (itemModel !is null) {
            State::skinningProperties["ItemModel.IdName"] = itemModel.IdName;
            State::skinningProperties["ItemModel.Name"] = itemModel.Name;
        }
    
        auto@ scriptAnchoredObject = cast<CGameCtnEditorScriptAnchoredObject>(item);
        if (scriptAnchoredObject is null) return;
    
        string itemColorString = "";
        try { itemColorString = tostring(pluginMap.GetMapElemColorItem(scriptAnchoredObject)); } catch {
            Logging::Debug("Failed to get item color");
        }
        State::skinningProperties["ItemColor"] = itemColorString;
    
        wstring itemSkinBackground = "";
        try { itemSkinBackground = pluginMap.GetItemSkinBg(scriptAnchoredObject); } catch {
            Logging::Debug("Failed to get item background skin");
        }
        State::skinningProperties["ItemSkinBg"] = string(itemSkinBackground);
    
        wstring itemSkinForeground = "";
        try { itemSkinForeground = pluginMap.GetItemSkinFg(scriptAnchoredObject); } catch {
            Logging::Debug("Failed to get item foreground skin");
        }
        State::skinningProperties["ItemSkinFg"] = string(itemSkinForeground);
    }
}