namespace FileUtils {
    bool IsFileType(const string &in url, const string &in fileType) {
        if (url.Length == 0 || fileType.Length == 0) return false;
        string lowerUrl = url.ToLower();
        string lowerType = fileType.ToLower();
        int urlLen = lowerUrl.Length;
        int typeLen = lowerType.Length;
        return urlLen >= typeLen + 1 && lowerUrl.SubStr(urlLen - typeLen - 1) == "." + lowerType;
    }
}

namespace EditorUtils {
    CGameEditorPluginMap@ GetEditorPluginMap() {
        auto editor = cast<CGameCtnEditorFree>(GetApp().Editor);
        if (editor is null) {
            return null;
        }
        return cast<CGameEditorPluginMap>(editor.PluginMapType);
    }
    
    void ExtractSkinningProperties(CGameCtnBlock@ block, CGameCtnEditorFree@ editor) {
        auto@ pluginMap = cast<CGameEditorPluginMap>(editor.PluginMapType);
        if (pluginMap is null) return;
        if (!pluginMap.IsBlockModelSkinnable(block.BlockModel)) return;
        auto@ blockSkin = cast<CGameCtnBlockSkin>(block.Skin);
        if (blockSkin is null) return;
        auto@ packDescriptor = blockSkin.PackDesc;
        if (packDescriptor !is null) {
            State::skinningProperties["Skin.PackDesc.Url"] = packDescriptor.Url;
        }
    }
}

namespace Fonts {
    UI::Font@ g_trebuchetFont = null;
    
    void Load() {
        @g_trebuchetFont = UI::LoadFont("trebuc.ttf", 16.0f);
        if (g_trebuchetFont is null) {
            Logging::Warn("Failed to load Trebuchet font");
        }
    }

    bool PushTrebuchetFont(float size = 0.0f) {
        if (g_trebuchetFont is null) return false;
        if (size > 0.0f) {
            UI::PushFont(g_trebuchetFont, size);
        } else {
            UI::PushFont(g_trebuchetFont);
        }
        return true;
    }
}

