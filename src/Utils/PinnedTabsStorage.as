namespace PinnedTabsStorage {
    dictionary@ g_pinnedCollections = null;  // key: collection_id, value: collection_name
    dictionary@ g_pinnedThemePacks = null;   // key: theme_pack_id, value: pack_name
    bool g_loaded = false;
    
    string GetStoragePath() {
        return IO::FromStorageFolder("pinned_tabs.json");
    }
    
    void LoadPinnedTabsCache() {
        if (g_loaded) return;
        
        @g_pinnedCollections = dictionary();
        @g_pinnedThemePacks = dictionary();
        g_loaded = true;
        
        string filePath = GetStoragePath();
        if (!IO::FileExists(filePath)) return;
        
        try {
            IO::File file(filePath, IO::FileMode::Read);
            string content = file.ReadToEnd();
            file.Close();
            
            if (content.Length == 0) return;
            
            Json::Value root = Json::Parse(content);
            
            Json::Value collectionsArray = root["collections"];
            for (uint i = 0; i < collectionsArray.Length; i++) {
                Json::Value item = collectionsArray[i];
                string id = string(item["id"]);
                string name = string(item["name"]);
                if (id.Length > 0) {
                    g_pinnedCollections[id] = name;
                }
            }
            
            Json::Value themePacksArray = root["themePacks"];
            for (uint i = 0; i < themePacksArray.Length; i++) {
                Json::Value item = themePacksArray[i];
                string id = string(item["id"]);
                string name = string(item["name"]);
                if (id.Length > 0) {
                    g_pinnedThemePacks[id] = name;
                }
            }
        } catch {
            Logging::Error("Failed to load pinned tabs cache: " + getExceptionInfo());
        }
    }
    
    void PinTab(const string &in id, const string &in name, bool isCollection) {
        if (id.Length == 0) return;
        
        LoadPinnedTabsCache();
        
        dictionary@ targetDict = isCollection ? g_pinnedCollections : g_pinnedThemePacks;
        if (targetDict is null) return;
        
        targetDict[id] = name;
        SaveToDisk();
    }
    
    void UnpinTab(const string &in id, bool isCollection) {
        if (id.Length == 0) return;
        
        LoadPinnedTabsCache();
        
        dictionary@ targetDict = isCollection ? g_pinnedCollections : g_pinnedThemePacks;
        if (targetDict is null) return;
        
        if (targetDict.Exists(id)) {
            targetDict.Delete(id);
            SaveToDisk();
        }
    }
    
    // Restore pinned tabs for a specific type (collections or theme packs)
    // Returns array of restored tabs that should be added to the tab manager
    array<Tab@>@ RestorePinnedTabs(bool isCollection) {
        array<Tab@>@ restoredTabs = array<Tab@>();
        LoadPinnedTabsCache();
        
        dictionary@ src = isCollection ? g_pinnedCollections : g_pinnedThemePacks;
        if (src is null) return restoredTabs;
        
        array<string> ids = src.GetKeys();
        for (uint i = 0; i < ids.Length; i++) {
            string id = ids[i];
            if (id.Length == 0) continue;
            
            string name = src.Exists(id) ? string(src[id]) : "";
            
            if (isCollection) {
                Collection@ c = Collection();
                c.collectionId = id;
                c.collectionName = name;
                CollectionTab@ tab = CollectionTab(c);
                tab.SetPinned(true);
                restoredTabs.InsertLast(tab);
            } else {
                ThemePack@ p = ThemePack();
                p.themePackId = id;
                p.packName = name;
                ThemePackTab@ tab = ThemePackTab(p);
                tab.SetPinned(true);
                restoredTabs.InsertLast(tab);
            }
        }
        
        return restoredTabs;
    }
    
    // Internal save function that saves current cache state to disk
    void SaveToDisk() {
        Json::Value root = Json::Object();
        Json::Value collectionsArray = Json::Array();
        Json::Value themePacksArray = Json::Array();
        
        if (g_pinnedCollections !is null) {
            array<string> collectionIds = g_pinnedCollections.GetKeys();
            for (uint i = 0; i < collectionIds.Length; i++) {
                string id = collectionIds[i];
                if (id.Length == 0) continue;
                
                Json::Value item = Json::Object();
                item["id"] = id;
                item["name"] = g_pinnedCollections.Exists(id) ? string(g_pinnedCollections[id]) : "";
                collectionsArray.Add(item);
            }
        }
        
        if (g_pinnedThemePacks !is null) {
            array<string> themePackIds = g_pinnedThemePacks.GetKeys();
            for (uint i = 0; i < themePackIds.Length; i++) {
                string id = themePackIds[i];
                if (id.Length == 0) continue;
                
                Json::Value item = Json::Object();
                item["id"] = id;
                item["name"] = g_pinnedThemePacks.Exists(id) ? string(g_pinnedThemePacks[id]) : "";
                themePacksArray.Add(item);
            }
        }
        
        root["collections"] = collectionsArray;
        root["themePacks"] = themePacksArray;
        
        string filePath = GetStoragePath();
        try {
            IO::File file(filePath, IO::FileMode::Write);
            file.Write(Json::Write(root));
            file.Close();
        } catch {
            Logging::Error("Failed to save pinned tabs: " + getExceptionInfo());
        }
    }
}
