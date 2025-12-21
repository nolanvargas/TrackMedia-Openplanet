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
    
    void Render(array<GalleryCellData@>@ cellDataArray, Config@ config) {
        float availableWidth = UI::GetContentRegionAvail().x;
        float maxColumnWidth = 250.0f;
        float calculatedColumnWidth = (availableWidth - (config.columnSpacing * (config.columns - 1))) / config.columns;
        float columnWidth = Math::Min(calculatedColumnWidth, maxColumnWidth);
        float totalGalleryWidth = (columnWidth * config.columns) + (config.columnSpacing * (config.columns - 1));
        vec2 startPos = UI::GetCursorPos();
        startPos.x += (availableWidth - totalGalleryWidth) / 2.0f;
        g_columnHeights.Resize(config.columns);
        for (uint i = 0; i < g_columnHeights.Length; i++) {
            g_columnHeights[i] = 0.0f;
        }
        g_itemHeights.Resize(cellDataArray.Length);
        for (uint i = 0; i < cellDataArray.Length; i++) {
            g_itemHeights[i] = GalleryCell::CalculateHeight(cellDataArray[i], columnWidth, g_cellConfig);
        }
        for (uint i = 0; i < cellDataArray.Length; i++) {
            GalleryCellData@ data = cellDataArray[i];
            int targetColumn = 0;
            float minHeight = g_columnHeights[0];
            for (uint col = 1; col < g_columnHeights.Length; col++) {
                if (g_columnHeights[col] < minHeight) {
                    minHeight = g_columnHeights[col];
                    targetColumn = int(col);
                }
            }
            float xPos = startPos.x + targetColumn * (columnWidth + config.columnSpacing);
            float yPos = startPos.y + g_columnHeights[targetColumn];
            UI::SetCursorPos(vec2(xPos, yPos));
            UI::Dummy(vec2(0, g_itemHeights[i]));
            UI::SetCursorPos(vec2(xPos, yPos));
            GalleryCell::Render(data, i, columnWidth, g_itemHeights[i], g_cellConfig);
            g_columnHeights[targetColumn] += g_itemHeights[i] + config.itemSpacing;
        }
        float maxHeight = 0.0f;
        for (uint i = 0; i < g_columnHeights.Length; i++) {
            if (g_columnHeights[i] > maxHeight) maxHeight = g_columnHeights[i];
        }
        UI::SetCursorPos(vec2(startPos.x, startPos.y + maxHeight));
        UI::Dummy(vec2(0, 0));
    }
    
    void Render(array<MediaItem@>@ items, GalleryButton@ button, Config@ config) {
        g_reusableCellDataArray.Resize(0);
        for (uint i = 0; i < items.Length; i++) {
            GalleryCellData@ data = GalleryCellBuilders::BuildFromMediaItem(items[i], i, button, items);
            if (data !is null) {
                g_reusableCellDataArray.InsertLast(data);
            }
        }
        Render(g_reusableCellDataArray, config);
    }
    
    void Render(array<Collection@>@ collections, CollectionGalleryButton@ button, Config@ config) {
        g_reusableCellDataArray.Resize(0);
        for (uint i = 0; i < collections.Length; i++) {
            GalleryCellData@ data = GalleryCellBuilders::BuildFromCollection(collections[i], i, button, collections);
            if (data !is null) {
                g_reusableCellDataArray.InsertLast(data);
            }
        }
        Render(g_reusableCellDataArray, config);
    }
    
    void Render(array<ThemePack@>@ themePacks, ThemePackGalleryButton@ button, Config@ config) {
        g_reusableCellDataArray.Resize(0);
        for (uint i = 0; i < themePacks.Length; i++) {
            GalleryCellData@ data = GalleryCellBuilders::BuildFromThemePack(themePacks[i], i, button, themePacks);
            if (data !is null) {
                g_reusableCellDataArray.InsertLast(data);
            }
        }
        Render(g_reusableCellDataArray, config);
    }
}

