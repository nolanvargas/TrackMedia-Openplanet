namespace PageRouter {
    string m_previousActivePage = "";
    
    // Render active page content
    void Render(const string &in activePage) {
        bool fontPushed = Fonts::PushTrebuchetFont();
        
        // Detect page activation (page just switched to this one)
        bool pageJustActivated = (activePage != m_previousActivePage);
        
        if (activePage == "Home") {
            HomePage::Render();
        } else if (activePage == "Debug") {
            DebugPage::Render();
        } else if (activePage == "Browse") {
            BrowsePage::Render(pageJustActivated);
        } else if (activePage == "Collections") {
            CollectionsPage::Render();
        } else if (activePage == "Theme Packs") {
            ThemePacksPage::Render();
        } else {
            UI::Text("Page: " + activePage);
        }
        
        m_previousActivePage = activePage;
        
        if (fontPushed) {
            UI::PopFont();
        }
    }
}
