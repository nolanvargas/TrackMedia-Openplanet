void Main() {
    print("TrackMedia Plugin initialized");
    Fonts::Load();
    while (true) {
        yield();
        EditorMonitor::UpdateEditorState();
    }
}

void Render() {
    UIWindow::Render();
}