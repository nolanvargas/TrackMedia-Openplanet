namespace DebugPage {
    void Render() {
        UI::Separator();
                
        // Left column for block or item properties
        string blockLabel = State::currentBlockName;
        string itemLabel = State::currentItemName;
        if (blockLabel != "" && blockLabel != "None" && blockLabel != "Error reading block") {
            UI::Text("Current Block: " + blockLabel);
        } else if (itemLabel != "" && itemLabel != "None" && itemLabel != "Error reading item") {
            UI::Text("Current Item: " + itemLabel);
        } else {
            UI::Text("No Block or Item Picked");
        }
        
        // Display skinning properties if any exist
        if (State::skinningProperties.GetSize() > 0) {
            UI::Text("Skinning Properties:");
            array<string> keys = State::skinningProperties.GetKeys();
            for (uint i = 0; i < keys.Length; i++) {
                string key = keys[i];
                string value = string(State::skinningProperties[key]);
                UI::Text("  " + key + ": " + value);
            }
        } else if (blockLabel != "None" && blockLabel != "Error reading block" && blockLabel != "") {
            UI::Separator();
            UI::Text("No skinning properties found");
        } else if (itemLabel != "None" && itemLabel != "Error reading item" && itemLabel != "") {
            UI::Separator();
            UI::Text("No skinning properties found");
        }

        UI::Separator();
        UI::Text("Skin Manager");
        UI::Separator();
        
        // Block section
        if (State::selectedBlock !is null) {
            UI::Text("Selected block");
            
            // Get current skins
            auto editor = cast<CGameCtnEditorFree>(GetApp().Editor);
            if (editor !is null) {
                auto@ pluginMap = cast<CGameEditorPluginMap>(editor.PluginMapType);
                if (pluginMap !is null) {
                    wstring currSkin = pluginMap.GetBlockSkin(State::selectedBlock);
                    wstring currBg = pluginMap.GetBlockSkinBg(State::selectedBlock);
                    wstring currFg = pluginMap.GetBlockSkinFg(State::selectedBlock);
                    UI::Text("Current Skin: " + string(currSkin));
                    UI::Text("Current BG: " + string(currBg));
                    UI::Text("Current FG: " + string(currFg));
                }
            }
            
            UI::Separator();
            
            // Combo for regular block skin
            if (State::blockSkinNames.Length > 0) {
                UI::Text("Block Skin");
                UI::BeginGroup();
                // Ensure state index is within bounds
                if (State::blockSkinSelected < 0 || State::blockSkinSelected >= int(State::blockSkinNames.Length)) {
                    State::blockSkinSelected = -1;
                }
                string currentSkinName = (State::blockSkinSelected >= 0 && State::blockSkinSelected < int(State::blockSkinNames.Length))
                    ? State::blockSkinNames[State::blockSkinSelected]
                    : "None";
                if (UI::BeginCombo("##BlockSkin", currentSkinName)) {
                    for (uint i = 0; i < State::blockSkinNames.Length; i++) {
                        bool isSelected = (State::blockSkinSelected >= 0 && int(i) == State::blockSkinSelected);
                        if (UI::Selectable(State::blockSkinNames[i], isSelected)) {
                            State::blockSkinSelected = int(i);
                        }
                        if (isSelected) UI::SetItemDefaultFocus();
                    }
                    UI::EndCombo();
                }
                UI::SameLine();
                if (UI::Button("Set##BlockSkin")) {
                    if (State::blockSkinSelected >= 0 && State::blockSkinSelected < int(State::blockSkinFiles.Length)) {
                        SkinManager::SetBlockSkinLayer("skin", State::blockSkinFiles[State::blockSkinSelected]);
                    }
                }
                UI::SameLine();
                if (UI::Button("Off##BlockSkin")) {
                    SkinManager::SetBlockSkinLayerOff("skin");
                }
                UI::EndGroup();
                
                // Preview removed (CDN-only mode)
            }
            
            // Combo for background skins
            if (State::blockBgSkinNames.Length > 0) {
                UI::Text("Block BG Skin");
                UI::BeginGroup();
                // Ensure state index is within bounds
                if (State::blockBgSelected < 0 || State::blockBgSelected >= int(State::blockBgSkinNames.Length)) {
                    State::blockBgSelected = -1;
                }
                string currentBgName = (State::blockBgSelected >= 0 && State::blockBgSelected < int(State::blockBgSkinNames.Length))
                    ? State::blockBgSkinNames[State::blockBgSelected]
                    : "None";
                if (UI::BeginCombo("##BlockBgSkin", currentBgName)) {
                    for (uint i = 0; i < State::blockBgSkinNames.Length; i++) {
                        bool isSelected = (State::blockBgSelected >= 0 && int(i) == State::blockBgSelected);
                        if (UI::Selectable(State::blockBgSkinNames[i], isSelected)) {
                            State::blockBgSelected = int(i);
                        }
                        if (isSelected) UI::SetItemDefaultFocus();
                    }
                    UI::EndCombo();
                }
                UI::SameLine();
                if (UI::Button("Set##BlockBg")) {
                    if (State::blockBgSelected >= 0 && State::blockBgSelected < int(State::blockBgSkinFiles.Length)) {
                        SkinManager::SetBlockSkinLayer("bg", State::blockBgSkinFiles[State::blockBgSelected]);
                    }
                }
                UI::SameLine();
                if (UI::Button("Off##BlockBg")) {
                    SkinManager::SetBlockSkinLayerOff("bg");
                }
                UI::EndGroup();
                
                // Preview removed (CDN-only mode)
            }
            
            UI::Separator();
            if (UI::Button("Apply All Block Skins")) {
                SkinManager::ApplyBlockSkins();
            }
        }
        
        // Item section
        if (State::selectedItem !is null) {
            if (State::selectedBlock !is null) UI::Separator();
            UI::Text("Selected item");
            
            // Get current skins
            auto editor = cast<CGameCtnEditorFree>(GetApp().Editor);
            if (editor !is null) {
                auto@ pluginMap = cast<CGameEditorPluginMap>(editor.PluginMapType);
                if (pluginMap !is null) {
                    wstring currBg = pluginMap.GetItemSkinBg(State::selectedItem);
                    wstring currFg = pluginMap.GetItemSkinFg(State::selectedItem);
                    UI::Text("Current BG: " + string(currBg));
                    UI::Text("Current FG: " + string(currFg));
                }
            }
            
            UI::Separator();
            
            if (State::itemBgSkinNames.Length > 0) {
                UI::Text("Item BG Skin");
                UI::BeginGroup();
                // Ensure state index is within bounds
                if (State::itemBgSelected < 0 || State::itemBgSelected >= int(State::itemBgSkinNames.Length)) {
                    State::itemBgSelected = -1;
                }
                string currentItemBgName = (State::itemBgSelected >= 0 && State::itemBgSelected < int(State::itemBgSkinNames.Length))
                    ? State::itemBgSkinNames[State::itemBgSelected]
                    : "None";
                if (UI::BeginCombo("##ItemBgSkin", currentItemBgName)) {
                    for (uint i = 0; i < State::itemBgSkinNames.Length; i++) {
                        bool isSelected = (State::itemBgSelected >= 0 && int(i) == State::itemBgSelected);
                        if (UI::Selectable(State::itemBgSkinNames[i], isSelected)) {
                            State::itemBgSelected = int(i);
                        }
                        if (isSelected) UI::SetItemDefaultFocus();
                    }
                    UI::EndCombo();
                }
                UI::SameLine();
                if (UI::Button("Set##ItemBg")) {
                    if (State::itemBgSelected >= 0 && State::itemBgSelected < int(State::itemBgSkinFiles.Length)) {
                        SkinManager::SetItemSkinLayer("bg", State::itemBgSkinFiles[State::itemBgSelected]);
                    }
                }
                UI::SameLine();
                if (UI::Button("Off##ItemBg")) {
                    SkinManager::SetItemSkinLayerOff("bg");
                }
                UI::EndGroup();
            }
            
            if (State::itemFgSkinNames.Length > 0) {
                UI::Text("Item FG Skin");
                UI::BeginGroup();
                // Ensure state index is within bounds
                if (State::itemFgSelected < 0 || State::itemFgSelected >= int(State::itemFgSkinNames.Length)) {
                    State::itemFgSelected = -1;
                }
                string currentItemFgName = (State::itemFgSelected >= 0 && State::itemFgSelected < int(State::itemFgSkinNames.Length))
                    ? State::itemFgSkinNames[State::itemFgSelected]
                    : "None";
                if (UI::BeginCombo("##ItemFgSkin", currentItemFgName)) {
                    for (uint i = 0; i < State::itemFgSkinNames.Length; i++) {
                        bool isSelected = (State::itemFgSelected >= 0 && int(i) == State::itemFgSelected);
                        if (UI::Selectable(State::itemFgSkinNames[i], isSelected)) {
                            State::itemFgSelected = int(i);
                        }
                        if (isSelected) UI::SetItemDefaultFocus();
                    }
                    UI::EndCombo();
                }
                UI::SameLine();
                if (UI::Button("Set##ItemFg")) {
                    if (State::itemFgSelected >= 0 && State::itemFgSelected < int(State::itemFgSkinFiles.Length)) {
                        SkinManager::SetItemSkinLayer("fg", State::itemFgSkinFiles[State::itemFgSelected]);
                    }
                }
                UI::SameLine();
                if (UI::Button("Off##ItemFg")) {
                    SkinManager::SetItemSkinLayerOff("fg");
                }
                UI::EndGroup();
            }
            
            UI::Separator();
            if (UI::Button("Apply All Item Skins")) {
                SkinManager::ApplyItemSkins();
            }
        }
        
        if (State::selectedBlock is null && State::selectedItem is null) {
            UI::Text("No block or item selected. Please select one in the editor.");
        }
    }
}
