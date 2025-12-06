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
    
    // Media items state
    bool hasRequestedThumbs = false;
    bool isRequestingThumbs = false;
    string thumbsRequestStatus = "Not requested";
    string thumbsResponse = "";
    int thumbsStatusCode = 0;
    array<MediaItem@> mediaItems;
    
    // Collections state
    bool hasRequestedCollections = false;
    bool isRequestingCollections = false;
    string collectionsRequestStatus = "Not requested";
    array<Collection@> collections;
    
    // Theme packs state
    bool hasRequestedThemePacks = false;
    bool isRequestingThemePacks = false;
    string themePacksRequestStatus = "Not requested";
    string themePacksResponse = "";
    array<ThemePack@> themePacks;
    
    // Tab management
    array<Tab@> openTabs;
    int activeTabIndex = -1;
    bool forceTabSelection = false;
    
    // Block skin state
    array<wstring> blockSkinFiles;
    array<string> blockSkinNames;
    array<wstring> blockBgSkinFiles;
    array<string> blockBgSkinNames;
    array<wstring> blockFgSkinFiles;
    array<string> blockFgSkinNames;
    int blockSkinSelected = -1;
    int blockBgSelected = -1;
    int blockFgSelected = -1;
    
    // Item skin state
    array<wstring> itemBgSkinFiles;
    array<string> itemBgSkinNames;
    array<wstring> itemFgSkinFiles;
    array<string> itemFgSkinNames;
    int itemBgSelected = -1;
    int itemFgSelected = -1;
}
