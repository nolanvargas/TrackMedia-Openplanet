namespace BottomSection {

    void Render(float bottomSectionHeight) {
        UI::PushStyleColor(UI::Col::ChildBg, Colors::BOTTOM_SECTION_BG);

        UI::BeginChild("BottomSection", vec2(0, bottomSectionHeight), true, UI::WindowFlags::NoScrollbar);

        bool showPreview = State::selectedBlock !is null &&
                           State::blockSkinSelected >= 0 &&
                           State::blockSkinSelected < int(State::blockSkinFiles.Length);
        if (showPreview) {
            float w = UI::GetContentRegionAvail().x;
            float h = UI::GetContentRegionAvail().y;

            UI::SetCursorPos(vec2(0, 0));

            UI::BeginChild("PreviewContainer", vec2(w, h), false, UI::WindowFlags::NoScrollbar);
            SkinPreviewRenderer::Render(vec2(w, h));
            UI::EndChild();
        }

        UI::EndChild();
        UI::PopStyleColor();
    }
}
