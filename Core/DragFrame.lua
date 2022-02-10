local addonName, ns = ...
local R = _G.ReduxUI
R.dragFrames = {}

function R:CreateDragFrame(frame, displayName, defaultPoint, width, height, point)
    if not frame or frame.DragFrame then return end

    table.insert(R.dragFrames, frame)

    frame.defaultPoint = defaultPoint or R:GetPoint(frame)

    local dragFrame = CreateFrame("Frame", nil)
    dragFrame.frame = frame
    dragFrame.displayName = displayName or frame:GetName()

    if width or height then
        if point then
            dragFrame:SetPoint(unpack(point))
        else
            dragFrame:SetPoint("CENTER", frame, "CENTER")
        end
        dragFrame:SetSize(width or frame:GetWidth(), height or frame:GetHeight())
    else
        dragFrame:SetAllPoints(frame)
    end
    dragFrame:SetFrameStrata("HIGH")
    dragFrame:EnableMouse(true)
    dragFrame:SetMovable(true)
    dragFrame:RegisterForDrag("LeftButton")
    dragFrame:SetScript("OnDragStart", R.DragFrame_OnDragStart)
    dragFrame:SetScript("OnDragStop", R.DragFrame_OnDragStop)
    dragFrame:SetScript("OnEnter", R.DragFrame_OnEnter)
    dragFrame:SetScript("OnLeave", R.DragFrame_OnLeave)
    dragFrame:SetScript("OnShow", R.DragFrame_OnShow)
    dragFrame:SetScript("OnHide", R.DragFrame_OnHide)
    dragFrame:Hide()

    local overlay = dragFrame:CreateTexture(nil, "OVERLAY", nil, 6)
    overlay:SetAllPoints(dragFrame)
    overlay:SetColorTexture(1, 1, 1)
    overlay:SetVertexColor(0, 1, 0)
    overlay:SetAlpha(0.3)
    dragFrame.texture = overlay

    local name = dragFrame:CreateFontString(nil, "OVERLAY")
    name:SetAllPoints(dragFrame)
    name:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    name:SetText(dragFrame.displayName)

    frame.DragFrame = dragFrame
    frame:SetMovable(true)

    if resizable then
        frame.defaultSize = R:GetSize(frame)
        frame:SetResizable(true)
        frame.__resizable = true
        frame.DragFrame:RegisterForDrag("LeftButton", "RightButton")
    end
end

function R:DragFrame_OnDragStart(button)
    if self.isLocked then return end

    if IsShiftKeyDown() then
        if button == "LeftButton" then self.frame:StartMoving() end
        if button == "RightButton" then self.frame:StartSizing() end
    end
end

function R:DragFrame_OnDragStop()
    self.frame:StopMovingOrSizing()
    if self.frame.config and self.frame.config.point then
        local _, _, _, x, y = self.frame:GetPoint()
        self.frame.config.point[1] = "CENTER"
        self.frame.config.point[2] = "UIParent"
        self.frame.config.point[3] = "CENTER"
        self.frame.config.point[4] = x
        self.frame.config.point[5] = y
    end
end

function R:DragFrame_OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine(self.displayName, 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddLine("Hold SHIFT+LeftButton to drag!", 1, 1, 1, 1, 1, 1)
    if self.frame.__resizable then GameTooltip:AddLine("Hold SHIFT+RightButton to resize!", 1, 1, 1, 1, 1, 1) end
    GameTooltip:Show()
end

function R:DragFrame_OnLeave() GameTooltip:Hide() end

function R:DragFrame_OnShow() if self.frame.faderConfig then self.frame:FadeIn() end end

function R:DragFrame_OnHide()
    if self.frame.faderConfig then
        -- self.frame:FadeOut()
    end
end

function R:HideDragFrame(frame)
    if not frame or not frame.DragFrame then return end

    if frame.frameVisibility then RegisterStateDriver(frame, "visibility", frame.frameVisibility) end
    frame.DragFrame:Hide()
end

function R:ShowDragFrame(frame)
    if not frame or not frame.DragFrame or frame.DragFrame.isLocked and frame.DragFrame.hideWhenLocked then return end

    if frame.frameVisibility then RegisterStateDriver(frame, "visibility", "show") end
    frame.DragFrame:Show()
end

function R:HideDragFrames()
    for idx, frame in next, R.dragFrames do R:HideDragFrame(frame) end
    R:Print("Frames locked.")
    R.framesLocked = true
end

function R:ShowDragFrames()
    for idx, frame in next, R.dragFrames do R:ShowDragFrame(frame) end
    R:Print("Frames unlocked.")
    R.framesLocked = false
end

function R:ToggleDragFrames()
    if R.framesLocked then
        R:ShowDragFrames()
    else
        R:HideDragFrames()
    end
end

function R:LockDragFrame(frame, hideWhenLocked)
    if not frame or not frame.DragFrame then return end

    frame.DragFrame.isLocked = true
    frame.DragFrame.hideWhenLocked = hideWhenLocked
    frame.DragFrame.texture:SetVertexColor(1, 0, 0)

    if not R.framesLocked then R:HideDragFrame(frame) end
end

function R:UnlockDragFrame(frame)
    if not frame or not frame.DragFrame then return end

    frame.DragFrame.isLocked = false
    frame.DragFrame.texture:SetVertexColor(0, 1, 0)

    if not R.framesLocked then R:ShowDragFrame(frame) end
end

function R:ResetFrames()
    if InCombatLockdown() then
        R:PrintError("Resetting frames is not allowed while in combat!")
        return
    end
    for _, frame in next, R.dragFrames do
        R:ResetPoint(frame)
        R:ResetSize(frame)

        if frame.Update then frame:Update() end
    end
    R:Print("Frame positions and sizes have been reset.")
end

function R:ResetSize(frame)
    if not frame or not frame.defaultSize or InCombatLockdown() then return end
    frame:SetSize(unpack(frame.defaultSize))
    if frame.config then frame.config.size = frame.defaultSize end
end

function R:ResetPoint(frame)
    if not frame or not frame.defaultPoint or InCombatLockdown() then return end
    frame:ClearAllPoints()
    frame:SetPoint(unpack(frame.defaultPoint))
    if frame.config then frame.config.point = frame.defaultPoint end
end

function R:CreateBlizzardDragFrames()
    if ObjectiveTrackerFrame then
        R:CreateDragFrame(ObjectiveTrackerFrame, "Objective Tracker", R.config.db.profile.dragFrames.objectiveTracker.point)
        ObjectiveTrackerFrame:ClearAllPoints()
        ObjectiveTrackerFrame:Point(unpack(R.config.db.profile.dragFrames.objectiveTracker.point))
    end
end
