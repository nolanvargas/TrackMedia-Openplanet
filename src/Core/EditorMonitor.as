namespace EditorMonitor {
    void UpdateEditorState() {
        auto editor = cast<CGameCtnEditorFree>(GetApp().Editor);
        if (editor is null) {
            State::isInEditor = false;
            State::showUI = false;
            return;
        }
        
        State::isInEditor = true;
        auto@ mapType = cast<CGameEditorPluginMapMapType>(editor.PluginMapType);
        if (mapType is null) {
            State::showUI = false;
            State::currentBlockName = "";
            State::skinningProperties.DeleteAll();
            return;
        }
        
        // Cache PlaceMode string to avoid per-frame allocation
        string placeModeStr = "";
        try {
            placeModeStr = tostring(mapType.PlaceMode);
        } catch {}
        
        if (placeModeStr != "Skin") {
            State::showUI = false;
            State::currentBlockName = "";
            State::skinningProperties.DeleteAll();
            return;
        }
        
        State::showUI = true;
        
        HandleSelection(editor);
    }

    void HandleSelection(CGameCtnEditorFree@ editor) {
        if (editor is null) {
            ClearSelection();
            return;
        }
        
        auto@ pickedBlock = cast<CGameCtnBlock>(editor.PickedBlock);
        if (pickedBlock !is null) {
            HandleBlockSelection(pickedBlock, editor);
        } else {
            auto@ pickedItem = editor.PickedObject;
            if (pickedItem !is null) {
                HandleItemSelection(pickedItem, editor);
            } else {
                ClearSelection();
            }
        }
    }

    void HandleBlockSelection(CGameCtnBlock@ block, CGameCtnEditorFree@ editor) {
        if (block is null || block.BlockModel is null) {
            State::currentBlockName = "";
            State::skinningProperties.DeleteAll();
            SkinManager::SetSelectedBlock(null);
            return;
        }
        
        State::currentBlockName = block.BlockModel.IdName;
        State::currentItemName = "";
        State::skinningProperties.DeleteAll();
        BlockExtractor::ExtractSkinningProperties(block, editor);
        SkinManager::SetSelectedBlock(block);
        SkinManager::SetSelectedItem(null);
    }

    void HandleItemSelection(CGameCtnAnchoredObject@ item, CGameCtnEditorFree@ editor) {
        if (item is null || item.ItemModel is null) {
            State::currentItemName = "";
            State::skinningProperties.DeleteAll();
            SkinManager::SetSelectedItem(null);
            return;
        }
        
        State::currentItemName = item.ItemModel.IdName;
        State::currentBlockName = "";
        State::skinningProperties.DeleteAll();
        ItemExtractor::ExtractSkinningProperties(item, editor);
        SkinManager::SetSelectedItem(cast<CGameCtnEditorScriptAnchoredObject>(item));
        SkinManager::SetSelectedBlock(null);
    }

    void ClearSelection() {
        State::currentBlockName = "";
        State::currentItemName = "";
        State::skinningProperties.DeleteAll();
        SkinManager::SetSelectedBlock(null);
        SkinManager::SetSelectedItem(null);
    }
}
