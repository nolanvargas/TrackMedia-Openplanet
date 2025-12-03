class ThemePacksPageTab : Tab {
    bool IsVisible() override { return true; }
    bool CanClose() override { return false; }
    
    string GetLabel() override {
        return "Theme Packs";
    }
    
    string GetTooltip() override {
        return "Browse all theme packs";
    }
    
    vec4 GetColor() override {
        return vec4(0.3f, 0.3f, 0.3f, 1);
    }
    
    void Render() override {
    }
}

