namespace BlockExtractor {
    void ExtractSkinningProperties(CGameCtnBlock@ block, CGameCtnEditorFree@ editor) {
        auto@ pluginMap = cast<CGameEditorPluginMap>(editor.PluginMapType);
        auto@ blockModel = block.BlockModel;
        if (pluginMap is null || blockModel is null) return;
        bool isSkinnable = pluginMap.IsBlockModelSkinnable(blockModel);
        State::skinningProperties["IsSkinnable"] = isSkinnable ? "Yes" : "No";
    
        if (!isSkinnable) return;

        SkinExtractor::ExtractBlockSkinProperties(block);    
    }
}
