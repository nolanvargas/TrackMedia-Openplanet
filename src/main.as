void Main() {
    Logging::Info("TrackMedia plugin initialized");
    Fonts::Load();
    
    // Pinned tabs will be loaded by tab managers when they render
    
    while (true) {
        yield();
        EditorMonitor::UpdateEditorState();
    }
}

void Render() {
    UIWindow::Render();
}