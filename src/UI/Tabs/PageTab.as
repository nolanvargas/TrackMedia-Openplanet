class PageTab : Tab {
    PageTab(const string &in label) {
        this.label = label;
        canClose = false;
        color = Colors::TAB_PAGE;
    }
}
