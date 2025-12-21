namespace DebugPage {
    void Render() {
        // Block section
        if (State::selectedBlock !is null) {
            UI::Text("Selected block");
            
            auto editor = cast<CGameCtnEditorFree>(GetApp().Editor);
            if (editor !is null) {
                auto@ pluginMap = cast<CGameEditorPluginMap>(editor.PluginMapType);
                if (pluginMap !is null) {
                    wstring currSkin = "";
                    wstring currBg = "";
                    wstring currFg = "";
                    try { currSkin = pluginMap.GetBlockSkin(State::selectedBlock); } catch {}
                    try { currBg = pluginMap.GetBlockSkinBg(State::selectedBlock); } catch {}
                    try { currFg = pluginMap.GetBlockSkinFg(State::selectedBlock); } catch {}
                    UI::Text("Current Skin: " + string(currSkin));
                    UI::Text("Current BG: " + string(currBg));
                    UI::Text("Current FG: " + string(currFg));
                }
            }
        }
        
        if (State::selectedItem !is null) {
            if (State::selectedBlock !is null) UI::Separator();
            UI::Text("Selected item");
            
            auto editor = cast<CGameCtnEditorFree>(GetApp().Editor);
            if (editor !is null) {
                auto@ pluginMap = cast<CGameEditorPluginMap>(editor.PluginMapType);
                if (pluginMap !is null) {
                    wstring currBg = "";
                    wstring currFg = "";
                    try { currBg = pluginMap.GetItemSkinBg(State::selectedItem); } catch {}
                    try { currFg = pluginMap.GetItemSkinFg(State::selectedItem); } catch {}
                    UI::Text("Current BG: " + string(currBg));
                    UI::Text("Current FG: " + string(currFg));
                }
            }
        }
        
        if (State::selectedBlock is null && State::selectedItem is null) {
            UI::Text("No block or item selected. Please select one in the editor.");
        }
        
    }
}
