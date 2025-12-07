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