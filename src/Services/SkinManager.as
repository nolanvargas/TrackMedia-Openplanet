namespace SkinManager {
    CGameEditorPluginMap@ GetEditorPluginMap() {
        auto editor = cast<CGameCtnEditorFree>(GetApp().Editor);
        return editor !is null ? cast<CGameEditorPluginMap>(editor.PluginMapType) : null;
    }
    
    void SetSelectedBlock(CGameCtnBlock@ block) {
        if (State::selectedBlock is block) return;
        @State::selectedBlock = block;
        if (State::selectedBlock !is null) {
            RefreshBlockSkinLists();
        } else {
            ClearBlockSkinLists();
        }
    }
    
    void SetSelectedItem(CGameCtnEditorScriptAnchoredObject@ item) {
        if (State::selectedItem is item) return;
        @State::selectedItem = item;
        if (State::selectedItem !is null) {
            RefreshItemSkinLists();
        } else {
            ClearItemSkinLists();
        }
    }
    
    void RefreshBlockSkinLists() {
        ClearBlockSkinLists();
        auto@ editor = GetEditorPluginMap();
        if (editor is null || State::selectedBlock is null) return;
        auto blockModel = State::selectedBlock.BlockModel;
        if (blockModel is null || !editor.IsBlockModelSkinnable(blockModel)) return;
        
        wstring currSkin = "";
        wstring currBg = "";
        wstring currFg = "";
        try { currSkin = editor.GetBlockSkin(State::selectedBlock); } catch {}
        try { currBg = editor.GetBlockSkinBg(State::selectedBlock); } catch {}
        try { currFg = editor.GetBlockSkinFg(State::selectedBlock); } catch {}
        
        uint nbSkins = editor.GetNbBlockModelSkins(blockModel);
        for (uint i = 0; i < nbSkins; i++) {
            wstring skinFile = editor.GetBlockModelSkin(blockModel, i);
            bool isFg = editor.IsSkinForeground_Block(blockModel, skinFile);
            string displayName = string(editor.GetSkinDisplayName(skinFile));
            State::blockSkinFiles.InsertLast(skinFile);
            State::blockSkinNames.InsertLast(displayName);
            if (skinFile == currSkin) {
                State::blockSkinSelected = int(State::blockSkinFiles.Length - 1);
            }
            if (isFg) {
                State::blockFgSkinFiles.InsertLast(skinFile);
                State::blockFgSkinNames.InsertLast(displayName);
                if (skinFile == currFg) {
                    State::blockFgSelected = int(State::blockFgSkinFiles.Length - 1);
                }
            } else {
                State::blockBgSkinFiles.InsertLast(skinFile);
                State::blockBgSkinNames.InsertLast(displayName);
                if (skinFile == currBg) {
                    State::blockBgSelected = int(State::blockBgSkinFiles.Length - 1);
                }
            }
        }
        if (State::blockSkinSelected < 0 && State::blockSkinFiles.Length > 0) {
            State::blockSkinSelected = 0;
        }
        if (State::blockBgSelected < 0 && State::blockBgSkinFiles.Length > 0) {
            State::blockBgSelected = 0;
        }
        if (State::blockFgSelected < 0 && State::blockFgSkinFiles.Length > 0) {
            State::blockFgSelected = 0;
        }
    }
    
    void RefreshItemSkinLists() {
        ClearItemSkinLists();
        auto@ editor = GetEditorPluginMap();
        if (editor is null || State::selectedItem is null) return;
        auto itemModel = State::selectedItem.ItemModel;
        if (itemModel is null || !editor.IsItemModelSkinnable(itemModel)) return;
        
        wstring currBg = editor.GetItemSkinBg(State::selectedItem);
        wstring currFg = editor.GetItemSkinFg(State::selectedItem);
        uint nbSkins = editor.GetNbItemModelSkins(itemModel);
        for (uint i = 0; i < nbSkins; i++) {
            wstring skinFile = editor.GetItemModelSkin(itemModel, i);
            bool isFg = editor.IsSkinForeground_Item(itemModel, skinFile);
            string displayName = string(editor.GetSkinDisplayName(skinFile));
            if (isFg) {
                State::itemFgSkinFiles.InsertLast(skinFile);
                State::itemFgSkinNames.InsertLast(displayName);
                if (skinFile == currFg) {
                    State::itemFgSelected = int(State::itemFgSkinFiles.Length - 1);
                }
            } else {
                State::itemBgSkinFiles.InsertLast(skinFile);
                State::itemBgSkinNames.InsertLast(displayName);
                if (skinFile == currBg) {
                    State::itemBgSelected = int(State::itemBgSkinFiles.Length - 1);
                }
            }
        }
        if (State::itemBgSelected < 0 && State::itemBgSkinFiles.Length > 0) {
            State::itemBgSelected = 0;
        }
        if (State::itemFgSelected < 0 && State::itemFgSkinFiles.Length > 0) {
            State::itemFgSelected = 0;
        }
    }
    
    void ClearBlockSkinLists() {
        State::blockSkinFiles.Resize(0);
        State::blockSkinNames.Resize(0);
        State::blockBgSkinFiles.Resize(0);
        State::blockBgSkinNames.Resize(0);
        State::blockFgSkinFiles.Resize(0);
        State::blockFgSkinNames.Resize(0);
        State::blockSkinSelected = -1;
        State::blockBgSelected = -1;
        State::blockFgSelected = -1;
    }
    
    UI::Texture@ LoadSkinTexture(const wstring &in skinFile) {
        return null;
    }
    
    void ClearItemSkinLists() {
        State::itemBgSkinFiles.Resize(0);
        State::itemBgSkinNames.Resize(0);
        State::itemFgSkinFiles.Resize(0);
        State::itemFgSkinNames.Resize(0);
        State::itemBgSelected = -1;
        State::itemFgSelected = -1;
    }
    
    void ApplyBlockSkins() {
        auto@ editor = GetEditorPluginMap();
        if (editor is null || State::selectedBlock is null) return;
        if (State::blockSkinSelected >= 0 && State::blockSkinSelected < int(State::blockSkinFiles.Length)) {
            try {
                editor.SetBlockSkin(State::selectedBlock, State::blockSkinFiles[State::blockSkinSelected]);
            } catch {}
        }
        wstring newBg = "";
        wstring newFg = "";
        if (State::blockBgSelected >= 0 && State::blockBgSelected < int(State::blockBgSkinFiles.Length)) {
            newBg = State::blockBgSkinFiles[State::blockBgSelected];
        }
        if (State::blockFgSelected >= 0 && State::blockFgSelected < int(State::blockFgSkinFiles.Length)) {
            newFg = State::blockFgSkinFiles[State::blockFgSelected];
        }
        if (newBg.Length > 0 || newFg.Length > 0) {
            editor.SetBlockSkins(State::selectedBlock, newBg, newFg);
        }
        RefreshBlockSkinLists();
    }
    
    void SetBlockSkinLayer(const string &in layer, const wstring &in skinFile) {
        auto@ editor = GetEditorPluginMap();
        if (editor is null || State::selectedBlock is null) return;
        if (layer == "skin") {
            try {
                editor.SetBlockSkin(State::selectedBlock, skinFile);
                RefreshBlockSkinLists();
            } catch {}
        } else if (layer == "bg") {
            wstring currFg = "";
            try { currFg = editor.GetBlockSkinFg(State::selectedBlock); } catch {}
            editor.SetBlockSkins(State::selectedBlock, skinFile, currFg);
            RefreshBlockSkinLists();
        } else if (layer == "fg") {
            wstring currBg = "";
            try { currBg = editor.GetBlockSkinBg(State::selectedBlock); } catch {}
            editor.SetBlockSkins(State::selectedBlock, currBg, skinFile);
            RefreshBlockSkinLists();
        }
    }
    
    void SetBlockSkinLayerOff(const string &in layer) {
        SetBlockSkinLayer(layer, wstring(""));
    }
    
    void ApplyItemSkins() {
        auto@ editor = GetEditorPluginMap();
        if (editor is null || State::selectedItem is null) return;
        wstring newBg = "";
        wstring newFg = "";
        if (State::itemBgSelected >= 0 && State::itemBgSelected < int(State::itemBgSkinFiles.Length)) {
            newBg = State::itemBgSkinFiles[State::itemBgSelected];
        }
        if (State::itemFgSelected >= 0 && State::itemFgSelected < int(State::itemFgSkinFiles.Length)) {
            newFg = State::itemFgSkinFiles[State::itemFgSelected];
        }
        if (newBg.Length > 0 || newFg.Length > 0) {
            editor.SetItemSkins(State::selectedItem, newBg, newFg);
            RefreshItemSkinLists();
        }
    }
    
    void SetItemSkinLayer(const string &in layer, const wstring &in skinFile) {
        auto@ editor = GetEditorPluginMap();
        if (editor is null || State::selectedItem is null) return;
        wstring currBg = "";
        wstring currFg = "";
        try { currBg = editor.GetItemSkinBg(State::selectedItem); } catch {}
        try { currFg = editor.GetItemSkinFg(State::selectedItem); } catch {}
        if (layer == "bg") {
            editor.SetItemSkins(State::selectedItem, skinFile, currFg);
            RefreshItemSkinLists();
        } else if (layer == "fg") {
            editor.SetItemSkins(State::selectedItem, currBg, skinFile);
            RefreshItemSkinLists();
        }
    }
    
    void SetItemSkinLayerOff(const string &in layer) {
        SetItemSkinLayer(layer, wstring(""));
    }
}

