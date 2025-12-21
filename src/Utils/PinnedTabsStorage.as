namespace PinnedTabsStorage {
    dictionary@ g_pinnedCollections = null;
    dictionary@ g_pinnedThemePacks = null;
    bool g_loaded = false;
    
    void LoadPinnedTabsCache() {
        if (g_loaded) return;
        @g_pinnedCollections = dictionary();
        @g_pinnedThemePacks = dictionary();
        g_loaded = true;
        string filePath = IO::FromStorageFolder("pinned_tabs.json");
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
                if (id.Length > 0) {
                    g_pinnedCollections[id] = string(item["name"]);
                }
            }
            Json::Value themePacksArray = root["themePacks"];
            for (uint i = 0; i < themePacksArray.Length; i++) {
                Json::Value item = themePacksArray[i];
                string id = string(item["id"]);
                if (id.Length > 0) {
                    g_pinnedThemePacks[id] = string(item["name"]);
                }
            }
        } catch {
            Logging::Error("Failed to load pinned tabs cache: " + getExceptionInfo());
        }
    }
    
    void PinTab(const string &in id, const string &in name, bool isCollection) {
        LoadPinnedTabsCache();
        dictionary@ targetDict = isCollection ? g_pinnedCollections : g_pinnedThemePacks;
        if (targetDict is null) return;
        targetDict[id] = name;
        SaveToDisk();
    }
    
    void UnpinTab(const string &in id, bool isCollection) {
        LoadPinnedTabsCache();
        dictionary@ targetDict = isCollection ? g_pinnedCollections : g_pinnedThemePacks;
        if (targetDict is null) return;
        if (targetDict.Exists(id)) {
            targetDict.Delete(id);
            SaveToDisk();
        }
    }
    
    array<Tab@>@ RestorePinnedTabs(bool isCollection) {
        array<Tab@>@ restoredTabs = array<Tab@>();
        LoadPinnedTabsCache();
        dictionary@ src = isCollection ? g_pinnedCollections : g_pinnedThemePacks;
        if (src is null) return restoredTabs;
        array<string> ids = src.GetKeys();
        for (uint i = 0; i < ids.Length; i++) {
            string id = ids[i];
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
    
    void SaveToDisk() {
        Json::Value root = Json::Object();
        Json::Value collectionsArray = Json::Array();
        Json::Value themePacksArray = Json::Array();
        if (g_pinnedCollections !is null) {
            array<string> collectionIds = g_pinnedCollections.GetKeys();
            for (uint i = 0; i < collectionIds.Length; i++) {
                string id = collectionIds[i];
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
                Json::Value item = Json::Object();
                item["id"] = id;
                item["name"] = g_pinnedThemePacks.Exists(id) ? string(g_pinnedThemePacks[id]) : "";
                themePacksArray.Add(item);
            }
        }
        root["collections"] = collectionsArray;
        root["themePacks"] = themePacksArray;
        string filePath = IO::FromStorageFolder("pinned_tabs.json");
        try {
            IO::File file(filePath, IO::FileMode::Write);
            file.Write(Json::Write(root));
            file.Close();
        } catch {
            Logging::Error("Failed to save pinned tabs: " + getExceptionInfo());
        }
    }
}
