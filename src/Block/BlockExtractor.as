namespace BlockExtractor {
    void ExtractSkinningProperties(CGameCtnBlock@ block, CGameCtnEditorFree@ editor) {
        if (block is null || editor is null) {
            return;
        }
        
        auto@ pluginMap = cast<CGameEditorPluginMap>(editor.PluginMapType);
        if (pluginMap is null) {
            return;
        }
        
        auto@ blockModel = block.BlockModel;
        if (blockModel is null) {
            return;
        }
        
        // Cache string conversions to avoid repeated allocations
        string colorStr = "";
        try {
            colorStr = tostring(pluginMap.GetMapElemColorBlock(block));
            if (colorStr.Length > 0) {
                State::skinningProperties["BlockColor"] = colorStr;
            }
        } catch {}
        
        string nextColorStr = "";
        try {
            nextColorStr = tostring(pluginMap.NextMapElemColor);
            if (nextColorStr.Length > 0) {
                State::skinningProperties["NextMapElemColor"] = nextColorStr;
            }
        } catch {}
        
        string qualityStr = "";
        try {
            qualityStr = tostring(pluginMap.NextMapElemLightmapQuality);
            if (qualityStr.Length > 0) {
                State::skinningProperties["NextMapElemLightmapQuality"] = qualityStr;
            }
        } catch {}
        
        bool isSkinnable = false;
        try {
            isSkinnable = pluginMap.IsBlockModelSkinnable(blockModel);
        } catch {}
        
        State::skinningProperties["IsSkinnable"] = isSkinnable ? "Yes" : "No";
        
        if (isSkinnable) {
            uint skinCount = 0;
            try {
                skinCount = pluginMap.GetNbBlockModelSkins(blockModel);
            } catch {}
            
            // Cache string conversion
            string skinCountStr = "";
            try {
                skinCountStr = tostring(skinCount);
                State::skinningProperties["SkinCount"] = skinCountStr;
            } catch {}
            
            if (skinCount > 0) {
                // Use array to build skin list efficiently, then join once
                array<string> skinNames;
                for (uint i = 0; i < skinCount; i++) {
                    try {
                        string skinName = pluginMap.GetBlockModelSkin(blockModel, i);
                        if (skinName.Length > 0) {
                            skinNames.InsertLast(skinName);
                        }
                    } catch {}
                }
                
                if (skinNames.Length > 0) {
                    // Build string once instead of repeated concatenation
                    string skinList = "";
                    for (uint i = 0; i < skinNames.Length; i++) {
                        if (i > 0) {
                            skinList += ", ";
                        }
                        skinList += skinNames[i];
                    }
                    State::skinningProperties["AvailableSkins"] = skinList;
                }
            }
            
            SkinExtractor::ExtractBlockSkinProperties(block);
        }
    }
}
