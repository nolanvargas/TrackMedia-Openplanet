void Main() {
    Fonts::Load();
    while (true) {
        yield();
        EditorMonitor::UpdateEditorState();
    }
}

void Render() {
    UIWindow::Render();
}