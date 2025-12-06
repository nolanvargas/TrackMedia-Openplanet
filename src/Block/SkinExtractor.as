namespace SkinExtractor {
    void ExtractBlockSkinProperties(CGameCtnBlock@ block) {
        if (block is null) {
            return;
        }
        
        auto@ blockSkin = cast<CGameCtnBlockSkin>(block.Skin);
        if (blockSkin is null) {
            return;
        }
        
        string skinId = blockSkin.IdName;
        if (skinId.Length > 0) {
            State::skinningProperties["Skin.IdName"] = skinId;
        }
        
        auto@ packDesc = blockSkin.PackDesc;
        if (packDesc !is null) {
            if (packDesc.Name.Length > 0) {
                State::skinningProperties["Skin.PackDesc.Name"] = packDesc.Name;
            }
            if (packDesc.Url.Length > 0) {
                State::skinningProperties["Skin.PackDesc.Url"] = packDesc.Url;
            }
        }
        
        auto@ parentPackDesc = blockSkin.ParentPackDesc;
        if (parentPackDesc !is null) {
            if (parentPackDesc.Name.Length > 0) {
                State::skinningProperties["Skin.ParentPackDesc.Name"] = parentPackDesc.Name;
            }
            if (parentPackDesc.Url.Length > 0) {
                State::skinningProperties["Skin.ParentPackDesc.Url"] = parentPackDesc.Url;
            }
        }
        
        auto@ foregroundPackDesc = blockSkin.ForegroundPackDesc;
        if (foregroundPackDesc !is null) {
            if (foregroundPackDesc.Name.Length > 0) {
                State::skinningProperties["Skin.ForegroundPackDesc.Name"] = foregroundPackDesc.Name;
            }
            if (foregroundPackDesc.Url.Length > 0) {
                State::skinningProperties["Skin.ForegroundPackDesc.Url"] = foregroundPackDesc.Url;
            }
        }
    }
}
