void Main() {
    Fonts::Load();
    startnew(AuthService::Authenticate);
    while (true) {
        yield();
        EditorMonitor::UpdateEditorState();
    }
}

void Render() {
    UIWindow::Render();
}