class RequestState {
    bool hasRequested = false;
    bool isRequesting = false;
    bool hasError = false;
    string status = "Not requested";

    void Reset() {
        isRequesting = true;
        status = "Requesting...";
    }

    void SetError(const string &in err) {
        status = err;
        isRequesting = false;
        hasRequested = true;
    }

    void SetSuccess() {
        status = "Success";
    }

    void Complete() {
        hasRequested = true;
        isRequesting = false;
    }
}

namespace State {
    // User Account
    string ubisoftAccountId = "";
    bool hasUbisoftId = false;

    // Request States
    RequestState userOverview;
    RequestState collections;
    RequestState themePacks;
    RequestState mediaItems;
    RequestState likedMedia;
    RequestState uploads;
    RequestState stats;

    // Stats
    int statsMediaCount = 0;
    int statsCollectionsCount = 0;
    int statsThemePacksCount = 0;

    // Data Arrays
    array<MediaItem@> userMedia;
    array<Collection@> userCollections;
    array<ThemePack@> userThemePacks;
    array<Collection@> allCollections;
    array<ThemePack@> allThemePacks;
    array<MediaItem@> allMediaItems;
    array<MediaItem@> allLikedMedia;
    array<MediaItem@> allUploads;


    // Tab Management
    TabSystem@ collectionsTabSystem = TabSystem(true);
    TabSystem@ themePacksTabSystem = TabSystem(false);

    // Editor State
    bool isInEditor = false;
    bool showUI = false;
    CGameCtnBlock@ selectedBlock = null;
    CGameCtnEditorScriptAnchoredObject@ selectedItem = null;
    dictionary skinningProperties;

    // Search State
    string searchQuery = "";
    bool isSearching = false;
    bool hasSearchResults = false;
    string searchReturnPage = "";
    array<MediaItem@> searchResultsMedia;
    array<Collection@> searchResultsCollections;
    array<ThemePack@> searchResultsThemePacks;

    void OnSearchSubmit() {
        if (searchQuery.Length == 0) {
            hasSearchResults = false;
            searchResultsMedia.Resize(0);
            searchResultsCollections.Resize(0);
            searchResultsThemePacks.Resize(0);
            return;
        }
        // Prevent spawning multiple simultaneous search coroutines
        if (isSearching) return;
        isSearching = true;
        startnew(SearchApiCoroutine);
    }

    void SearchApiCoroutine() {
        string url = API::API_BASE_URL + "/search?q=" + Net::UrlEncode(searchQuery);
        auto json = API::GetAsync(url);

        searchResultsMedia.Resize(0);
        searchResultsCollections.Resize(0);
        searchResultsThemePacks.Resize(0);

        if (json.GetType() != Json::Type::Object) {
            isSearching = false;
            hasSearchResults = true;
            return;
        }

        // Parse media results
        if (json.HasKey("media") && json["media"].GetType() == Json::Type::Array) {
            auto arr = json["media"];
            for (uint i = 0; i < arr.Length; i++) {
                MediaItem@ item = MediaItem(arr[i]);
                searchResultsMedia.InsertLast(item);
                ThumbnailService::RequestThumbnailForMediaItem(item);
            }
        }

        // Parse collection results
        if (json.HasKey("collections") && json["collections"].GetType() == Json::Type::Array) {
            auto arr = json["collections"];
            for (uint i = 0; i < arr.Length; i++) {
                Collection@ col = Collection(arr[i]);
                searchResultsCollections.InsertLast(col);
                ThumbnailService::RequestThumbnailForCollection(col);
            }
        }

        // Parse theme pack results
        if (json.HasKey("theme_packs") && json["theme_packs"].GetType() == Json::Type::Array) {
            auto arr = json["theme_packs"];
            for (uint i = 0; i < arr.Length; i++) {
                ThemePack@ tp = ThemePack(arr[i]);
                searchResultsThemePacks.InsertLast(tp);
                ThumbnailService::RequestThumbnailForThemePack(tp);
            }
        }

        hasSearchResults = true;
        isSearching = false;
    }

    void ClearSearch() {
        searchQuery = "";
        hasSearchResults = false;
        isSearching = false;
        searchReturnPage = "";
        searchResultsMedia.Resize(0);
        searchResultsCollections.Resize(0);
        searchResultsThemePacks.Resize(0);
        // Clear cell caches to free memory from old search results
        GalleryCellBuilders::ClearAllCaches();
    }

    // Helpers for clearing arrays
    void ClearUserOverview() {
        userMedia.Resize(0);
        userCollections.Resize(0);
        userThemePacks.Resize(0);
        userOverview.hasRequested = false;
    }

    void ClearCollections() { allCollections.Resize(0); }
    void ClearThemePacks() { allThemePacks.Resize(0); }
    void ClearMediaItems() { allMediaItems.Resize(0); }
    void ClearLikedMedia() { allLikedMedia.Resize(0); likedMedia.hasRequested = false; }
    void ClearUploads() { allUploads.Resize(0); uploads.hasRequested = false; }
}
