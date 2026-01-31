namespace FileUtils {
    // Unsupported media formats that cannot be rendered as textures
    const array<string> UNSUPPORTED_FORMATS = {"webm"};

    // Returns the lowercase file extension from a path (e.g. "png", "webm", "dds")
    // Returns empty string if no extension found
    string GetExtension(const string &in path) {
        if (path.Length == 0) return "";
        int lastDot = -1;
        for (int i = int(path.Length) - 1; i >= 0; i--) {
            string c = path.SubStr(i, 1);
            if (c == ".") {
                lastDot = i;
                break;
            }
            if (c == "/" || c == "\\") break;
        }
        if (lastDot < 0 || lastDot >= int(path.Length) - 1) return "";
        return path.SubStr(lastDot + 1).ToLower();
    }

    bool IsFileType(const string &in path, const string &in fileType) {
        return GetExtension(path) == fileType.ToLower();
    }

    bool IsWebm(const string &in path) {
        return GetExtension(path) == "webm";
    }

    bool IsUnsupportedFormat(const string &in path) {
        string ext = GetExtension(path);
        if (ext.Length == 0) return false;
        for (uint i = 0; i < UNSUPPORTED_FORMATS.Length; i++) {
            if (ext == UNSUPPORTED_FORMATS[i]) return true;
        }
        return false;
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

