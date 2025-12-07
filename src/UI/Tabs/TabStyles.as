namespace TabStyles {
    // Array of 5 black and white shades for collection and theme pack tabs
    const vec4[] SHADES = {
        Colors::SHADE_BLACK,
        Colors::SHADE_DARK_GRAY,
        Colors::SHADE_MEDIUM_GRAY,
        Colors::SHADE_LIGHT_GRAY,
        Colors::SHADE_WHITE
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
        return luminance > 0.5f ? Colors::SHADE_BLACK : Colors::SHADE_WHITE;
    }
}
