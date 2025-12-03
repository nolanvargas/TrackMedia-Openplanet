namespace State {
    bool isInEditor = false;
    bool showUI = false;
    bool skinManagerWindowOpen = true;
    
    string currentBlockName = "";
    string currentItemName = "";
    CGameCtnBlock@ selectedBlock = null;
    CGameCtnEditorScriptAnchoredObject@ selectedItem = null;
    dictionary skinningProperties;
    
    bool hasRequestedThumbs = false;
    bool isRequestingThumbs = false;
    string thumbsRequestStatus = "Not requested";
    string thumbsResponse = "";
    int thumbsStatusCode = 0;
    
    bool hasRequestedCollections = false;
    bool isRequestingCollections = false;
    string collectionsRequestStatus = "Not requested";
    
    bool hasRequestedThemePacks = false;
    bool isRequestingThemePacks = false;
    string themePacksRequestStatus = "Not requested";
    string themePacksResponse = "";
    
    array<MediaItem@> mediaItems;
    array<Collection@> collections;
    array<ThemePack@> themePacks;
    
    array<Tab@> openTabs;
    int activeTabIndex = -1;
    bool forceTabSelection = false;
    
    array<wstring> blockSkinFiles;
    array<string> blockSkinNames;
    array<wstring> blockBgSkinFiles;
    array<string> blockBgSkinNames;
    array<wstring> blockFgSkinFiles;
    array<string> blockFgSkinNames;
    int blockSkinSelected = -1;
    int blockBgSelected = -1;
    int blockFgSelected = -1;
    
    array<wstring> itemBgSkinFiles;
    array<string> itemBgSkinNames;
    array<wstring> itemFgSkinFiles;
    array<string> itemFgSkinNames;
    int itemBgSelected = -1;
    int itemFgSelected = -1;
}
