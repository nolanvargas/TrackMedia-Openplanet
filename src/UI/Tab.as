namespace TabStyles {
    // Array of 5 black and white shades for collection and theme pack tabs
    const vec4[] SHADES = {
        vec4(0.0f, 0.0f, 0.0f, 1.0f),       // Black
        vec4(0.25f, 0.25f, 0.25f, 1.0f),    // Dark gray
        vec4(0.5f, 0.5f, 0.5f, 1.0f),       // Medium gray
        vec4(0.75f, 0.75f, 0.75f, 1.0f),    // Light gray
        vec4(1.0f, 1.0f, 1.0f, 1.0f)        // White
    };
    
    vec4 GetShadeColor(int index) {
        if (index < 0) index = 0;
        return SHADES[index % int(SHADES.Length)];
    }
    
    // Calculate relative luminance to determine text color
    float CalculateLuminance(vec4 color) {
        // Using sRGB luminance formula: 0.2126*R + 0.7152*G + 0.0722*B
        // Note: vec4 uses x, y, z, w components (x=R, y=G, z=B, w=A)
        return 0.2126f * color.x + 0.7152f * color.y + 0.0722f * color.z;
    }
    
    vec4 GetTextColor(vec4 backgroundColor) {
        float luminance = CalculateLuminance(backgroundColor);
        // If background is light (luminance > 0.5), use black text, otherwise white
        return luminance > 0.5f ? vec4(0.0f, 0.0f, 0.0f, 1.0f) : vec4(1.0f, 1.0f, 1.0f, 1.0f);
    }
}

class Tab {
    bool IsVisible() { return true; }
    bool CanClose() { return false; }
    string GetLabel() { return ""; }
    string GetTooltip() { return ""; }
    vec4 GetColor() { return vec4(0.2f, 0.4f, 0.8f, 1); }
    vec4 GetColor(int index) { return GetColor(); }  // Override for index-based colors

    void PushTabStyle() {
        vec4 color = GetColor();
        UI::PushStyleColor(UI::Col::Tab, color * vec4(0.5f, 0.5f, 0.5f, 0.75f));
        UI::PushStyleColor(UI::Col::TabHovered, color * vec4(1.2f, 1.2f, 1.2f, 0.85f));
        UI::PushStyleColor(UI::Col::TabActive, color);
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.10f, 0.10f, 0.10f, 1));
        UI::PushStyleColor(UI::Col::TableRowBg, vec4(0.13f, 0.13f, 0.13f, 1));
    }

    void PushTabStyle(int index) {
        vec4 color = GetColor(index);
        vec4 textColor = TabStyles::GetTextColor(color);
        
        UI::PushStyleColor(UI::Col::Tab, color * vec4(0.5f, 0.5f, 0.5f, 0.75f));
        UI::PushStyleColor(UI::Col::TabHovered, color * vec4(1.2f, 1.2f, 1.2f, 0.85f));
        UI::PushStyleColor(UI::Col::TabActive, color);
        UI::PushStyleColor(UI::Col::Text, textColor);
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.10f, 0.10f, 0.10f, 1));
        UI::PushStyleColor(UI::Col::TableRowBg, vec4(0.13f, 0.13f, 0.13f, 1));
    }

    void PopTabStyle() {
        UI::PopStyleColor(5);
    }
    
    void PopTabStyle(int colorCount) {
        UI::PopStyleColor(colorCount);
    }
    
    void PopTabStyleWithText() {
        UI::PopStyleColor(6);  // 6 colors including text color
    }

    void Reload() {}
    void Render() {}
}