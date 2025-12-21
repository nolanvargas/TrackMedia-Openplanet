namespace EditorMonitor {
    void SetSelectedBlock(CGameCtnBlock@ block) {
        if (State::selectedBlock is block) return;
        @State::selectedBlock = block;
    }
    
    void SetSelectedItem(CGameCtnEditorScriptAnchoredObject@ item) {
        if (State::selectedItem is item) return;
        @State::selectedItem = item;
    }
    
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
            State::skinningProperties.DeleteAll();
            return;
        }
        
        string placeModeStr = "";
        try { placeModeStr = tostring(mapType.PlaceMode); } catch {
            Logging::Debug("Failed to get place mode");
        }
        
        if (placeModeStr != "Skin") {
            State::showUI = false;
            State::skinningProperties.DeleteAll();
            return;
        }
        
        State::showUI = true;
        
        HandleSelection(editor);
    }

    void HandleSelection(CGameCtnEditorFree@ editor) {
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
        State::skinningProperties.DeleteAll();
        EditorUtils::ExtractSkinningProperties(block, editor);
        SetSelectedBlock(block);
        SetSelectedItem(null);
    }

    void HandleItemSelection(CGameCtnAnchoredObject@ item, CGameCtnEditorFree@ editor) {
        State::skinningProperties.DeleteAll();
        SetSelectedItem(cast<CGameCtnEditorScriptAnchoredObject>(item));
        SetSelectedBlock(null);
    }

    void ClearSelection() {
        State::skinningProperties.DeleteAll();
        SetSelectedBlock(null);
        SetSelectedItem(null);
    }
}
