namespace BlockExtractor {
    void ExtractSkinningProperties(CGameCtnBlock@ block, CGameCtnEditorFree@ editor) {
        auto@ pluginMap = cast<CGameEditorPluginMap>(editor.PluginMapType);
        auto@ blockModel = block.BlockModel;
        if (pluginMap is null || blockModel is null) return;
    
        string blockColorString = "";
        try { blockColorString = tostring(pluginMap.GetMapElemColorBlock(block)); } catch {
            Logging::Debug("Failed to get block color");
        }
        State::skinningProperties["BlockColor"] = blockColorString;
    
        string nextMapElementColorString = "";
        try { nextMapElementColorString = tostring(pluginMap.NextMapElemColor); } catch {
            Logging::Debug("Failed to get next map element color");
        }
        State::skinningProperties["NextMapElemColor"] = nextMapElementColorString;
    
        string nextMapElementLightmapQualityString = "";
        try { nextMapElementLightmapQualityString = tostring(pluginMap.NextMapElemLightmapQuality); } catch {
            Logging::Debug("Failed to get next map element lightmap quality");
        }
        State::skinningProperties["NextMapElemLightmapQuality"] = nextMapElementLightmapQualityString;
    
        bool isSkinnable = false;
        try { isSkinnable = pluginMap.IsBlockModelSkinnable(blockModel); } catch {
            Logging::Debug("Failed to check if block model is skinnable");
        }
        State::skinningProperties["IsSkinnable"] = isSkinnable ? "Yes" : "No";
    
        if (!isSkinnable) return;
    
        uint skinCount = 0;
        try { skinCount = pluginMap.GetNbBlockModelSkins(blockModel); } catch {
            Logging::Debug("Failed to get block model skin count");
        }
    
        string skinCountString = "";
        try { skinCountString = tostring(skinCount); } catch {
            Logging::Debug("Failed to convert skin count to string");
        }
        State::skinningProperties["SkinCount"] = skinCountString;
    
        if (skinCount > 0) {
            array<string> skinNames;
            for (uint i = 0; i < skinCount; i++) {
                try {
                    string skinName = pluginMap.GetBlockModelSkin(blockModel, i);
                    skinNames.InsertLast(skinName);
                } catch {
                    Logging::Debug("Failed to get block model skin at index " + i);
                }
            }
    
            string skinListString = "";
            for (uint i = 0; i < skinNames.Length; i++) {
                if (i > 0) skinListString += ", ";
                skinListString += skinNames[i];
            }
            State::skinningProperties["AvailableSkins"] = skinListString;
        }
    
        SkinExtractor::ExtractBlockSkinProperties(block);    
    }
}
