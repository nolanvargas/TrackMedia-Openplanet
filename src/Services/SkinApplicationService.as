namespace SkinApplicationService {

    bool ApplySkinFromMediaItem(MediaItem@ mediaItem) {
        if (mediaItem is null) return false;

        string skinUrl = "https://cdn.trackmedia.io/" + mediaItem.key;
        auto pluginMap = EditorUtils::GetEditorPluginMap();

        try {
            if (State::selectedBlock !is null) {
                pluginMap.SetBlockSkins(State::selectedBlock, skinUrl, "");
            } else if (State::selectedItem !is null) {
                pluginMap.SetItemSkins(State::selectedItem, skinUrl, "");
            } else {
                Logging::Warn("Cannot apply skin: no block or item selected", true);
                return false;
            }

            SkinPreviewRenderer::SetAppliedSkin(skinUrl);
            return true;
        } catch {
            Logging::Error("Failed to apply skin: " + getExceptionInfo(), true);
            return false;
        }
    }

}
