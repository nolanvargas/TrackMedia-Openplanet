namespace GalleryGrid {
    class Config {
        int columns = 4;
        float itemSpacing = 8.0f;
        float columnSpacing = 8.0f;
    }

    array<float> g_columnHeights;
    array<float> g_itemHeights;
    GalleryCell::Config g_cellConfig;
    array<GalleryCellData@> g_reusableCellDataArray;

    void Render(array<GalleryCellData@>@ cells, Config@ config) {
        // Update global animation timer once per frame
        GalleryCell::UpdateGlobalAnimation();

        float availableWidth = UI::GetContentRegionAvail().x;
        float maxColWidth = 250.0f;
        float colWidth = Math::Min((availableWidth - (config.columnSpacing * (config.columns - 1))) / config.columns, maxColWidth);
        float totalWidth = (colWidth * config.columns) + (config.columnSpacing * (config.columns - 1));

        vec2 startPos = UI::GetCursorPos();
        startPos.x += (availableWidth - totalWidth) / 2.0f;

        g_columnHeights.Resize(config.columns);
        for (uint i = 0; i < g_columnHeights.Length; i++) g_columnHeights[i] = 0.0f;

        g_itemHeights.Resize(cells.Length);
        for (uint i = 0; i < cells.Length; i++) {
            g_itemHeights[i] = GalleryCell::CalculateHeight(cells[i], colWidth, g_cellConfig);
        }

        for (uint i = 0; i < cells.Length; i++) {
            int targetCol = 0;
            float minH = g_columnHeights[0];
            for (uint c = 1; c < g_columnHeights.Length; c++) {
                if (g_columnHeights[c] < minH) { minH = g_columnHeights[c]; targetCol = int(c); }
            }

            float x = startPos.x + targetCol * (colWidth + config.columnSpacing);
            float y = startPos.y + g_columnHeights[targetCol];
            UI::SetCursorPos(vec2(x, y));
            UI::Dummy(vec2(0, g_itemHeights[i]));
            UI::SetCursorPos(vec2(x, y));
            GalleryCell::Render(cells[i], i, colWidth, g_itemHeights[i], g_cellConfig);
            g_columnHeights[targetCol] += g_itemHeights[i] + config.itemSpacing;
        }

        float maxH = 0.0f;
        for (uint i = 0; i < g_columnHeights.Length; i++) {
            if (g_columnHeights[i] > maxH) maxH = g_columnHeights[i];
        }
        UI::SetCursorPos(vec2(startPos.x, startPos.y + maxH));
        UI::Dummy(vec2(0, 0));
    }

    void Render(array<MediaItem@>@ items, GalleryButton@ button, Config@ config) {
        BuildCellData(items, button);
        Render(g_reusableCellDataArray, config);
    }

    void Render(array<Collection@>@ items, CollectionGalleryButton@ button, Config@ config) {
        BuildCellData(items, button);
        Render(g_reusableCellDataArray, config);
    }

    void Render(array<ThemePack@>@ items, ThemePackGalleryButton@ button, Config@ config) {
        BuildCellData(items, button);
        Render(g_reusableCellDataArray, config);
    }

    void BuildCellData(array<MediaItem@>@ items, GalleryButton@ button) {
        g_reusableCellDataArray.Resize(0);
        for (uint i = 0; i < items.Length; i++) {
            GalleryCellData@ d = GalleryCellBuilders::BuildFromMediaItem(items[i], i, button, items);
            if (d !is null) g_reusableCellDataArray.InsertLast(d);
        }
    }

    void BuildCellData(array<Collection@>@ items, CollectionGalleryButton@ button) {
        g_reusableCellDataArray.Resize(0);
        for (uint i = 0; i < items.Length; i++) {
            GalleryCellData@ d = GalleryCellBuilders::BuildFromCollection(items[i], i, button, items);
            if (d !is null) g_reusableCellDataArray.InsertLast(d);
        }
    }

    void BuildCellData(array<ThemePack@>@ items, ThemePackGalleryButton@ button) {
        g_reusableCellDataArray.Resize(0);
        for (uint i = 0; i < items.Length; i++) {
            GalleryCellData@ d = GalleryCellBuilders::BuildFromThemePack(items[i], i, button, items);
            if (d !is null) g_reusableCellDataArray.InsertLast(d);
        }
    }
}
