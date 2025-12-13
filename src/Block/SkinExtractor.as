namespace SkinExtractor {
    void ExtractBlockSkinProperties(CGameCtnBlock@ block) {
    if (block is null) return;
    
        auto@ blockSkin = cast<CGameCtnBlockSkin>(block.Skin);
        if (blockSkin is null) return;
    
        string skinIdName = blockSkin.IdName;
        State::skinningProperties["Skin.IdName"] = skinIdName;
    
        auto@ packDescriptor = blockSkin.PackDesc;
        if (packDescriptor !is null) {
            string packDescriptorName = packDescriptor.Name;
            State::skinningProperties["Skin.PackDesc.Name"] = packDescriptorName;
            string packDescriptorUrl = packDescriptor.Url;
            State::skinningProperties["Skin.PackDesc.Url"] = packDescriptorUrl;
        }
    
        auto@ parentPackDescriptor = blockSkin.ParentPackDesc;
        if (parentPackDescriptor !is null) {
            string parentPackDescriptorName = parentPackDescriptor.Name;
            State::skinningProperties["Skin.ParentPackDesc.Name"] = parentPackDescriptorName;
            string parentPackDescriptorUrl = parentPackDescriptor.Url;
            State::skinningProperties["Skin.ParentPackDesc.Url"] = parentPackDescriptorUrl;
        }
    
        auto@ foregroundPackDescriptor = blockSkin.ForegroundPackDesc;
        if (foregroundPackDescriptor !is null) {
            string foregroundPackDescriptorName = foregroundPackDescriptor.Name;
            State::skinningProperties["Skin.ForegroundPackDesc.Name"] = foregroundPackDescriptorName;
            string foregroundPackDescriptorUrl = foregroundPackDescriptor.Url;
            State::skinningProperties["Skin.ForegroundPackDesc.Url"] = foregroundPackDescriptorUrl;
        }
    }
}