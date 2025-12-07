namespace State {
    // Editor state
    bool isInEditor = false;
    bool showUI = false;
    
    // Selection state
    string currentBlockName = "";
    string currentItemName = "";
    CGameCtnBlock@ selectedBlock = null;
    CGameCtnEditorScriptAnchoredObject@ selectedItem = null;
    dictionary skinningProperties;
}
