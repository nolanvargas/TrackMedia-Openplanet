namespace SkinExtractor {
    void ExtractBlockSkinProperties(CGameCtnBlock@ block) {    
        auto@ blockSkin = cast<CGameCtnBlockSkin>(block.Skin);
        if (blockSkin is null) return;
    
        State::skinningProperties["Skin.IdName"] = blockSkin.IdName;
    
        auto@ packDescriptor = blockSkin.PackDesc;
        if (packDescriptor !is null) {
            State::skinningProperties["Skin.PackDesc.Name"] = packDescriptor.Name;
            State::skinningProperties["Skin.PackDesc.Url"] = packDescriptor.Url;
        }
    
        auto@ parentPackDescriptor = blockSkin.ParentPackDesc;
        if (parentPackDescriptor !is null) {
            State::skinningProperties["Skin.ParentPackDesc.Name"] = parentPackDescriptor.Name;
            State::skinningProperties["Skin.ParentPackDesc.Url"] = parentPackDescriptor.Url;
        }
    
        auto@ foregroundPackDescriptor = blockSkin.ForegroundPackDesc;
        if (foregroundPackDescriptor !is null) {
            State::skinningProperties["Skin.ForegroundPackDesc.Name"] = foregroundPackDescriptor.Name;
            State::skinningProperties["Skin.ForegroundPackDesc.Url"] = foregroundPackDescriptor.Url;
        }
    }
}
