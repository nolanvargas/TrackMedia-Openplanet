class PageTab : Tab {
    string m_label;
    
    PageTab(const string &in label) {
        m_label = label;
    }
    
    bool CanClose() override { return false; }
    
    string GetLabel() override { return m_label; }

    vec4 GetColor() override { return Colors::TAB_PAGE; }
}
