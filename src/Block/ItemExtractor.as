namespace ItemExtractor {
    void ExtractSkinningProperties(CGameCtnAnchoredObject@ item, CGameCtnEditorFree@ editor) {
        if (item is null || editor is null) {
            return;
        }
        
        auto@ pluginMap = cast<CGameEditorPluginMap>(editor.PluginMapType);
        if (pluginMap is null) {
            return;
        }
        
        auto@ itemModel = item.ItemModel;
        if (itemModel !is null) {
            State::skinningProperties["ItemModel.IdName"] = itemModel.IdName;
            State::skinningProperties["ItemModel.Name"] = itemModel.Name;
        }
        
        auto@ scriptAnchoredObject = cast<CGameCtnEditorScriptAnchoredObject>(item);
        if (scriptAnchoredObject !is null) {
            try {
                string colorStr = tostring(pluginMap.GetMapElemColorItem(scriptAnchoredObject));
                if (colorStr.Length > 0) {
                    State::skinningProperties["ItemColor"] = colorStr;
                }
            } catch {}
            
            try {
                wstring itemSkinBg = pluginMap.GetItemSkinBg(scriptAnchoredObject);
                if (itemSkinBg.Length > 0) {
                    State::skinningProperties["ItemSkinBg"] = string(itemSkinBg);
                }
            } catch {}
            
            try {
                wstring itemSkinFg = pluginMap.GetItemSkinFg(scriptAnchoredObject);
                if (itemSkinFg.Length > 0) {
                    State::skinningProperties["ItemSkinFg"] = string(itemSkinFg);
                }
            } catch {}
        }
    }
}
