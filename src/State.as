namespace State {
    // ============================================================================
    // Collections State
    // ============================================================================
    
    bool hasRequestedCollections = false;
    bool isRequestingCollections = false;
    string collectionsRequestStatus = "Not requested";
    array<Collection@> collections;
    
    void ResetCollectionsRequest() {
        isRequestingCollections = true;
        collectionsRequestStatus = "Requesting...";
    }
    
    void SetCollectionsError(const string &in status) {
        collectionsRequestStatus = status;
        isRequestingCollections = false;
    }
    
    void SetCollectionsSuccess() {
        collectionsRequestStatus = "Success";
    }
    
    void SetCollectionsRequestComplete() {
        hasRequestedCollections = true;
        isRequestingCollections = false;
    }
    
    void ClearCollections() {
        collections.RemoveRange(0, collections.Length);
    }

    // ============================================================================
    // Theme Packs State
    // ============================================================================
    
    bool hasRequestedThemePacks = false;
    bool isRequestingThemePacks = false;
    string themePacksRequestStatus = "Not requested";
    array<ThemePack@> themePacks;
    
    void ResetThemePacksRequest() {
        isRequestingThemePacks = true;
        themePacksRequestStatus = "Requesting...";
    }
    
    void SetThemePacksError(const string &in status) {
        themePacksRequestStatus = status;
        isRequestingThemePacks = false;
    }
    
    void SetThemePacksSuccess() {
        themePacksRequestStatus = "Success";
    }
    
    void SetThemePacksRequestComplete() {
        hasRequestedThemePacks = true;
        isRequestingThemePacks = false;
    }
    
    void ClearThemePacks() {
        themePacks.RemoveRange(0, themePacks.Length);
    }

    // ============================================================================
    // Media Items State
    // ============================================================================
    
    bool hasRequestedMediaItems = false;
    bool isRequestingMediaItems = false;
    string mediaItemsRequestStatus = "Not requested";
    array<MediaItem@> mediaItems;
    
    void ClearMediaItems() {
        mediaItems.RemoveRange(0, mediaItems.Length);
    }
    
    void ResetMediaItemsRequest() {
        isRequestingMediaItems = true;
        mediaItemsRequestStatus = "Requesting...";
    }
    
    void SetMediaItemsError(const string &in status, const string &in response = "") {
        mediaItemsRequestStatus = status;
        hasRequestedMediaItems = true;
        isRequestingMediaItems = false;
    }
    
    void SetMediaItemsRequestComplete() {
        hasRequestedMediaItems = true;
        isRequestingMediaItems = false;
    }

    // ============================================================================
    // Tab Management State
    // ============================================================================
    
    TabSystem@ collectionsTabSystem = TabSystem(true);
    TabSystem@ themePacksTabSystem = TabSystem(false);

    // ============================================================================
    // Editor State
    // ============================================================================
    
    bool isInEditor = false;
    bool showUI = false;
    CGameCtnBlock@ selectedBlock = null;
    CGameCtnEditorScriptAnchoredObject@ selectedItem = null;
    dictionary skinningProperties;
}

