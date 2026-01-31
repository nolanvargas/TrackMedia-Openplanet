namespace FilterBar {
    // Shared filter state
    int signSizeIndex = 0;
    int signTypeIndex = 0;
    int hoveredTypeIndex = -1;

    const array<string> SIGN_SIZES = {"N/A", "all", "1x1", "2x1", "4x1", "6x1"};
    const array<string> SIGN_TYPES = {
        "N/A", "all", "up", "up-right", "right", "down-right", "down", "down-left", "left", "up-left",
        "start", "checkpoint", "multilap", "finish", "accelerate", "brake", "drift", "no-slide",
        "neo-slide", "jump", "loop", "road-center", "road-outside", "chicane left", "chicane right",
        "u-turn left", "u-turn right", "wallride left", "wallride right", "fragile", "no-steer",
        "engine off", "slowmo", "no brakes", "wet", "cruise", "reset", "stadium car", "desert",
        "rally", "road split", "speedslide", "caution", "danger", "wrong-way", "gps", "no grip", "snow"
    };

    bool Render() {
        bool changed = false;
        int prevSize = signSizeIndex;
        int prevType = signTypeIndex;

        // Padding
        UI::Dummy(vec2(0, 12));
        UI::Dummy(vec2(8, 0));
        UI::SameLine();
        
        // Size buttons
        StyleHelpers::PushDimmedText();
        UI::Text("Size:");
        StyleHelpers::PopDimmedText();
        UI::SameLine();

        UI::PushStyleVar(UI::StyleVar::FrameRounding, 4.0f);
        UI::PushStyleVar(UI::StyleVar::ItemSpacing, vec2(2, 0));
        for (uint i = 0; i < SIGN_SIZES.Length; i++) {
            if (i > 0) UI::SameLine();
            bool sel = (int(i) == signSizeIndex);
            StyleHelpers::PushSelectableButton(sel);
            if (UI::Button(SIGN_SIZES[i] + "##sz" + i, vec2(40, 24))) signSizeIndex = i;
            StyleHelpers::PopSelectableButton();
        }
        UI::PopStyleVar(2);

        UI::SameLine();
        UI::Dummy(vec2(12, 0));
        UI::SameLine();

        // Type dropdown
        StyleHelpers::PushDimmedText();
        UI::Text("Type:");
        StyleHelpers::PopDimmedText();
        UI::SameLine();

        UI::SetNextItemWidth(140);
        StyleHelpers::PushCombo();
        if (UI::BeginCombo("##type", SIGN_TYPES[signTypeIndex], UI::ComboFlags::HeightLargest)) {
            int newHovered = -1;
            for (uint i = 0; i < SIGN_TYPES.Length; i++) {
                bool sel = (int(i) == signTypeIndex);
                bool wasHovered = (int(i) == hoveredTypeIndex);
                if (sel || wasHovered) UI::PushStyleColor(UI::Col::Text, vec4(0,0,0,1));
                if (UI::Selectable(SIGN_TYPES[i], sel)) signTypeIndex = i;
                if (UI::IsItemHovered()) newHovered = int(i);
                if (sel || wasHovered) UI::PopStyleColor();
                if (sel) UI::SetItemDefaultFocus();
            }
            hoveredTypeIndex = newHovered;
            UI::EndCombo();
        } else {
            hoveredTypeIndex = -1;
        }
        StyleHelpers::PopCombo();

        // Reset button
        if (signSizeIndex != 0 || signTypeIndex != 0) {
            UI::SameLine();
            UI::Dummy(vec2(12, 0));
            UI::SameLine();
            StyleHelpers::PushSelectableButton(false);
            if (UI::Button(Icons::Times + " Reset")) {
                signSizeIndex = 0;
                signTypeIndex = 0;
            }
            StyleHelpers::PopSelectableButton();
        }

        UI::Dummy(vec2(0, 4));

        changed = (signSizeIndex != prevSize || signTypeIndex != prevType);
        return changed;
    }

    string GetSizeParam() {
        string v = SIGN_SIZES[signSizeIndex];
        return (v == "N/A" || v == "all") ? "" : v;
    }

    string GetTypeParam() {
        string v = SIGN_TYPES[signTypeIndex];
        return (v == "N/A" || v == "all") ? "" : v;
    }

    string BuildQueryParams() {
        string params = "";
        string size = GetSizeParam();
        string type = GetTypeParam();
        if (size.Length > 0) params += "&signSize=" + Net::UrlEncode(size);
        if (type.Length > 0) params += "&signType=" + Net::UrlEncode(type);
        return params;
    }
}
