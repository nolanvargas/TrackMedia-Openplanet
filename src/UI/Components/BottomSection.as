namespace BottomSection {
    
    // Render bottom section with media preview
    void Render(float bottomSectionHeight) {
        // Style bottom section with darker background
        UI::PushStyleColor(UI::Col::ChildBg, Colors::BOTTOM_SECTION_BG);
        
        if (UI::BeginChild("BottomSection", vec2(0, bottomSectionHeight), true, UI::WindowFlags::NoScrollbar)) {
            // Draw thin top border using a colored separator
            UI::PushStyleColor(UI::Col::Separator, Colors::BUTTON);
            UI::Separator();
            UI::PopStyleColor();
            
            bool showPreview = State::selectedBlock !is null && 
                               State::blockSkinSelected >= 0 && 
                               State::blockSkinSelected < int(State::blockSkinFiles.Length);
            
            if (showPreview) {
                float availableWidth = UI::GetContentRegionAvail().x;
                float availableHeight = UI::GetContentRegionAvail().y;
                
                UI::SetCursorPos(vec2(0, 0));
                if (UI::BeginChild("PreviewContainer", vec2(availableWidth, availableHeight), false, UI::WindowFlags::NoScrollbar)) {
                    SkinPreviewRenderer::Render(vec2(availableWidth, availableHeight));
                    UI::EndChild();
                }
            }
            UI::EndChild();
        }
        
        UI::PopStyleColor();
    }
}
