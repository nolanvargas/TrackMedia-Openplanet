namespace Fonts {
    UI::Font@ trebuchetFont = null;
    
    void Load() {
        @trebuchetFont = UI::LoadFont("trebuc.ttf", 16.0f);
        if (trebuchetFont is null) {
            print("TrackMedia: Warning - Failed to load Trebuchet font");
        } else {
            print("TrackMedia: Successfully loaded Trebuchet font");
        }
    }
    
    UI::Font@ GetTrebuchetFont() {
        return trebuchetFont;
    }
    
    bool PushTrebuchetFont(float size = 0.0f) {
        if (trebuchetFont is null) return false;
        if (size > 0.0f) {
            UI::PushFont(trebuchetFont, size);
        } else {
            UI::PushFont(trebuchetFont);
        }
        return true;
    }
}