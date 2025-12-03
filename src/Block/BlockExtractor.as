namespace BlockExtractor {
    void ExtractSkinningProperties(CGameCtnBlock@ block, CGameCtnEditorFree@ editor) {
        if (block is null || editor is null) return;
        auto@ pluginMap = cast<CGameEditorPluginMap>(editor.PluginMapType);
        if (pluginMap is null) return;
        auto@ blockModel = block.BlockModel;
        if (blockModel is null) return;
        
        string colorStr = tostring(pluginMap.GetMapElemColorBlock(block));
        if (colorStr.Length > 0) {
            State::skinningProperties["BlockColor"] = colorStr;
        }
        string nextColorStr = tostring(pluginMap.NextMapElemColor);
        if (nextColorStr.Length > 0) {
            State::skinningProperties["NextMapElemColor"] = nextColorStr;
        }
        string qualityStr = tostring(pluginMap.NextMapElemLightmapQuality);
        if (qualityStr.Length > 0) {
            State::skinningProperties["NextMapElemLightmapQuality"] = qualityStr;
        }
        
        bool isSkinnable = pluginMap.IsBlockModelSkinnable(blockModel);
        State::skinningProperties["IsSkinnable"] = isSkinnable ? "Yes" : "No";
        
        if (isSkinnable) {
            uint skinCount = pluginMap.GetNbBlockModelSkins(blockModel);
            State::skinningProperties["SkinCount"] = tostring(skinCount);
            if (skinCount > 0) {
                string skinList = "";
                for (uint i = 0; i < skinCount; i++) {
                    string skinName = pluginMap.GetBlockModelSkin(blockModel, i);
                    if (skinName.Length > 0) {
                        if (skinList.Length > 0) skinList += ", ";
                        skinList += skinName;
                    }
                }
                if (skinList.Length > 0) {
                    State::skinningProperties["AvailableSkins"] = skinList;
                }
            }
            SkinExtractor::ExtractBlockSkinProperties(block);
        }
    }
}
