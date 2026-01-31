namespace PageRouter {
    string m_previousActivePage = "";

    void Render(const string &in activePage) {
        bool fontPushed = Fonts::PushTrebuchetFont();

        // Check if search results should be shown
        if (State::hasSearchResults || State::isSearching) {
            // Save return page when search starts
            if (State::searchReturnPage.Length == 0) {
                State::searchReturnPage = activePage;
            }
            SearchResultsPage::Render(State::searchReturnPage);
            if (fontPushed) UI::PopFont();
            return;
        }

        bool pageJustActivated = activePage != m_previousActivePage;

        if (activePage == "User") {
            UserPage::Render();
        } else if (activePage == "Browse") {
            BrowsePage::Render(pageJustActivated);
        } else if (activePage == "Collections") {
            CollectionsPage::Render();
        } else if (activePage == "Theme Packs") {
            ThemePacksPage::Render();
        } else if (activePage == "Liked") {
            LikedPage::Render(pageJustActivated);
        } else if (activePage == "Uploads") {
            UploadsPage::Render(pageJustActivated);
        } else {
            HomePage::Render();
        }

        m_previousActivePage = activePage;
        if (fontPushed) UI::PopFont();
    }
}
