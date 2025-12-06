void Main() {
    Logging::Info("TrackMedia plugin initialized");
    Fonts::Load();
    while (true) {
        yield();
        EditorMonitor::UpdateEditorState();
    }
}

void Render() {
    UIWindow::Render();
}