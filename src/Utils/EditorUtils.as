namespace EditorUtils {
    CGameEditorPluginMap@ GetEditorPluginMap() {
        auto editor = cast<CGameCtnEditorFree>(GetApp().Editor);
        if (editor is null) {
            return null;
        }
        return cast<CGameEditorPluginMap>(editor.PluginMapType);
    }
}

