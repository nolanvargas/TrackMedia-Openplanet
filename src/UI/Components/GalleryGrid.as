namespace GalleryGrid {
    class Config {
        int columns = 4;
        float itemSpacing = 8.0f;
        float columnSpacing = 8.0f;
    }
    
    void Render(array<GalleryCellData@>@ cellDataArray, Config@ config) {
        if (cellDataArray is null || cellDataArray.Length == 0) return;
        
        float availableWidth = UI::GetContentRegionAvail().x;
        float maxColumnWidth = 300.0f;
        float calculatedColumnWidth = (availableWidth - (config.columnSpacing * (config.columns - 1))) / config.columns;
        float columnWidth = Math::Min(calculatedColumnWidth, maxColumnWidth);
        float totalGalleryWidth = (columnWidth * config.columns) + (config.columnSpacing * (config.columns - 1));
        
        vec2 startPos = UI::GetCursorPos();
        startPos.x += (availableWidth - totalGalleryWidth) / 2.0f;
        
        array<float> columnHeights;
        columnHeights.Resize(config.columns);
        for (uint i = 0; i < columnHeights.Length; i++) {
            columnHeights[i] = 0.0f;
        }
        
        GalleryCell::Config cellConfig;
        array<float> itemHeights;
        itemHeights.Resize(cellDataArray.Length);
        for (uint i = 0; i < cellDataArray.Length; i++) {
            GalleryCellData@ data = cellDataArray[i];
            itemHeights[i] = (data !is null) ? GalleryCell::CalculateHeight(data, columnWidth, cellConfig) : 0.0f;
        }
        
        for (uint i = 0; i < cellDataArray.Length; i++) {
            GalleryCellData@ data = cellDataArray[i];
            if (data is null) continue;
            
            int targetColumn = 0;
            float minHeight = columnHeights[0];
            for (uint col = 1; col < columnHeights.Length; col++) {
                if (columnHeights[col] < minHeight) {
                    minHeight = columnHeights[col];
                    targetColumn = int(col);
                }
            }
            
            float xPos = startPos.x + targetColumn * (columnWidth + config.columnSpacing);
            float yPos = startPos.y + columnHeights[targetColumn];
            UI::SetCursorPos(vec2(xPos, yPos));
            UI::Dummy(vec2(0, itemHeights[i]));
            UI::SetCursorPos(vec2(xPos, yPos));
            GalleryCell::Render(data, i, columnWidth, itemHeights[i], cellConfig);
            columnHeights[targetColumn] += itemHeights[i] + config.itemSpacing;
        }
        
        float maxHeight = 0.0f;
        for (uint i = 0; i < columnHeights.Length; i++) {
            if (columnHeights[i] > maxHeight) maxHeight = columnHeights[i];
        }
        UI::SetCursorPos(vec2(startPos.x, startPos.y + maxHeight));
        UI::Dummy(vec2(0, 0));
    }
    
    void Render(array<MediaItem@>@ items, GalleryButton@ button, Config@ config) {
        if (items is null || items.Length == 0) return;
        
        array<GalleryCellData@> cellDataArray;
        for (uint i = 0; i < items.Length; i++) {
            GalleryCellData@ data = GalleryCellBuilders::BuildFromMediaItem(items[i], i, button, items);
            if (data !is null) {
                cellDataArray.InsertLast(data);
            }
        }
        Render(cellDataArray, config);
    }
    
    void Render(array<Collection@>@ collections, CollectionGalleryButton@ button, Config@ config) {
        if (collections is null || collections.Length == 0) return;
        
        array<GalleryCellData@> cellDataArray;
        for (uint i = 0; i < collections.Length; i++) {
            GalleryCellData@ data = GalleryCellBuilders::BuildFromCollection(collections[i], i, button, collections);
            if (data !is null) {
                cellDataArray.InsertLast(data);
            }
        }
        Render(cellDataArray, config);
    }
    
    void Render(array<ThemePack@>@ themePacks, ThemePackGalleryButton@ button, Config@ config) {
        if (themePacks is null || themePacks.Length == 0) return;
        
        array<GalleryCellData@> cellDataArray;
        for (uint i = 0; i < themePacks.Length; i++) {
            GalleryCellData@ data = GalleryCellBuilders::BuildFromThemePack(themePacks[i], i, button, themePacks);
            if (data !is null) {
                cellDataArray.InsertLast(data);
            }
        }
        Render(cellDataArray, config);
    }
}

