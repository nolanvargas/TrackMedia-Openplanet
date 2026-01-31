namespace HomePage {
    bool m_statsRequested = false;

    void RenderFeatureCard(const string &in id, const string &in icon, const string &in title, const string &in description, vec2 size) {
        StyleHelpers::PushCardStyle();
        UI::PushStyleVar(UI::StyleVar::WindowPadding, vec2(12, 12));

        if (UI::BeginChild(id, size, true, UI::WindowFlags::NoScrollbar)) {
            UI::PushStyleColor(UI::Col::Text, Colors::ACTIVE);
            UI::Text(icon);
            UI::PopStyleColor();

            UI::Dummy(vec2(0, 4));

            UI::PushStyleColor(UI::Col::Text, Colors::ACTIVE);
            UI::Text(title);
            UI::PopStyleColor();

            UI::Dummy(vec2(0, 4));

            StyleHelpers::PushDimmedText();
            UI::TextWrapped(description);
            StyleHelpers::PopDimmedText();
        }
        UI::EndChild();

        UI::PopStyleVar();
        StyleHelpers::PopCardStyle();
    }

    void RenderStatCard(const string &in id, int value, const string &in label, vec2 size) {
        StyleHelpers::PushCardStyle();
        UI::PushStyleVar(UI::StyleVar::WindowPadding, vec2(12, 8));

        if (UI::BeginChild(id, size, true, UI::WindowFlags::NoScrollbar)) {
            UI::PushStyleColor(UI::Col::Text, Colors::ACTIVE);
            UI::PushFontSize(24.0f);
            UI::Text(tostring(value));
            UI::PopFontSize();
            UI::PopStyleColor();

            StyleHelpers::PushDimmedText();
            UI::Text(label);
            StyleHelpers::PopDimmedText();
        }
        UI::EndChild();

        UI::PopStyleVar();
        StyleHelpers::PopCardStyle();
    }

    void Render() {
        // Request stats on first render
        if (!m_statsRequested && !State::stats.isRequesting) {
            m_statsRequested = true;
            startnew(StatsApiService::RequestStats);
        }

        float availWidth = UI::GetContentRegionAvail().x;
        float maxWidth = 500.0f;
        float contentWidth = Math::Min(availWidth, maxWidth);

        // Center the content if wider than max
        if (availWidth > maxWidth) {
            float padding = (availWidth - maxWidth) / 2.0f;
            UI::SetCursorPos(UI::GetCursorPos() + vec2(padding, 0));
        }

        UI::BeginChild("HomeContent", vec2(contentWidth, 0), false, UI::WindowFlags::NoScrollbar);
        UI::Dummy(vec2(0, 64));

        // Title (centered using estimated character width)
        UI::PushStyleColor(UI::Col::Text, Colors::ACTIVE);
        UI::PushFontSize(36.0f);
        string titleText = "TRACKMEDIA.io";
        // Estimate: ~20px per character at font size 36
        float titleWidth = titleText.Length * 20.0f;
        UI::SetCursorPosX(UI::GetCursorPos().x + (contentWidth - titleWidth) / 2.0f);
        UI::Text(titleText);
        UI::PopFontSize();
        UI::PopStyleColor();

        UI::Dummy(vec2(0, 12));

        // Description (centered using indentation)
        UI::PushStyleColor(UI::Col::Text, Colors::LIGHT);
        string descText = "Share your Trackmania signs, create collections, and discover theme packs made by the community. Upload, organize, and showcase your creative assets with tools designed for Trackmania mappers.";
        float descIndent = contentWidth * 0.05f;
        UI::SetCursorPosX(UI::GetCursorPos().x + descIndent);
        UI::PushItemWidth(contentWidth - descIndent * 2);
        UI::TextWrapped(descText);
        UI::PopItemWidth();
        UI::PopStyleColor();

        UI::Dummy(vec2(0, 24));

        // Subtitle (centered using estimated character width)
        UI::PushStyleColor(UI::Col::Text, Colors::WHITE);
        string subtitleLine1 = "Everything you need to manage, organize, and share your Trackmania";
        string subtitleLine2 = "media assets";
        // Estimate: ~7px per character at default font size
        float line1Width = subtitleLine1.Length * 7.0f;
        float line2Width = subtitleLine2.Length * 7.0f;
        UI::SetCursorPosX(UI::GetCursorPos().x + (contentWidth - line1Width) / 2.0f);
        UI::Text(subtitleLine1);
        UI::SetCursorPosX(UI::GetCursorPos().x + (contentWidth - line2Width) / 2.0f);
        UI::Text(subtitleLine2);
        UI::PopStyleColor();

        UI::Dummy(vec2(0, 16));

        // Feature cards (3 column layout)
        float cardSpacing = 12.0f;
        float cardWidth = (contentWidth - cardSpacing * 2) / 3;
        float cardHeight = 130.0f;
        vec2 cardSize = vec2(cardWidth, cardHeight);

        // Row 1
        RenderFeatureCard("BrowseCard", Icons::CloudUpload, "Browse & Share", "Discover Trackmania signs and media files.", cardSize);
        UI::SameLine();
        RenderFeatureCard("CollectionsCard", Icons::FolderOpen, "Collections", "Organize your media into themed collections.", cardSize);
        UI::SameLine();
        RenderFeatureCard("ThemePacksCard", Icons::PaintBrush, "Theme Packs", "Create complete sign sets with sizes and types.", cardSize);

        UI::Dummy(vec2(0, cardSpacing));

        // Show reload button if not logged in
        if (!State::hasUbisoftId) {
            StyleHelpers::PushDimmedText();
            string loginMsg = "Not logged in. Try reloading the plugin if you're already signed in to Ubisoft Connect.";
            float msgIndent = contentWidth * 0.05f;
            UI::SetCursorPosX(UI::GetCursorPos().x + msgIndent);
            UI::PushItemWidth(contentWidth - msgIndent * 2);
            UI::TextWrapped(loginMsg);
            UI::PopItemWidth();
            StyleHelpers::PopDimmedText();

            UI::Dummy(vec2(0, 12));

            // Centered reload button with non-blue styling
            float buttonWidth = 150.0f;
            UI::SetCursorPosX(UI::GetCursorPos().x + (contentWidth - buttonWidth) / 2.0f);

            StyleHelpers::PushButton();
            UI::PushStyleVar(UI::StyleVar::FrameRounding, 4.0f);
            UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(16, 8));

            if (UI::Button(Icons::Refresh + " Reload Plugin", vec2(buttonWidth, 0))) {
                Meta::ReloadPlugin(Meta::ExecutingPlugin());
            }

            UI::PopStyleVar(2);
            StyleHelpers::PopButton();

            UI::Dummy(vec2(0, cardSpacing));
        }

        // Stats section
        if (State::stats.hasRequested && !State::stats.isRequesting) {
            float statCardWidth = (contentWidth - cardSpacing * 2) / 3;
            float statCardHeight = 60.0f;
            vec2 statSize = vec2(statCardWidth, statCardHeight);

            RenderStatCard("MediaStat", State::statsMediaCount, "Media Files", statSize);
            UI::SameLine();
            RenderStatCard("CollectionsStat", State::statsCollectionsCount, "Collections", statSize);
            UI::SameLine();
            RenderStatCard("ThemePacksStat", State::statsThemePacksCount, "Theme Packs", statSize);
        } else if (State::stats.isRequesting) {
            UI::PushStyleColor(UI::Col::Text, Colors::TEXT_DIMMED);
            UI::Text("Loading stats...");
            UI::PopStyleColor();
        }

        UI::EndChild();
    }
}
