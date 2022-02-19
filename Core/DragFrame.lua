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
    dragFrame:SetScript("OnMouseWheel", R.DragFrame_OnMouseWheel)
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

    if frame:IsResizable() then
        frame.defaultSize = R:GetSize(frame)
        frame.DragFrame:RegisterForDrag("LeftButton", "RightButton")
    end
end

function R:DragFrame_OnMouseWheel(offset)
    if IsShiftKeyDown() then
        local point = R:GetPoint(self.frame)
        point[5] = point[5] + offset
        R:SetPoint(self.frame, point)
    elseif IsControlKeyDown() then
        local point = R:GetPoint(self.frame)
        point[4] = point[4] + offset
        R:SetPoint(self.frame, point)
    end

    if GameTooltip:IsOwned(self) then R.DragFrame_OnEnter(self) end
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
    if self.frame.config and self.frame.config.point then self.frame.config.point = R:GetPoint(self.frame) end
end

function R:DragFrame_OnEnter()
    local point = R:GetPoint(self.frame)

    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine(self.displayName, 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine("|cffffd100Point:|r " .. point[1], 1, 1, 1)
    GameTooltip:AddLine("|cffffd100Attached to:|r " .. point[3] .. " |cffffd100of|r " .. point[2], 1, 1, 1)
    GameTooltip:AddLine("|cffffd100X:|r " .. point[4] .. ", |cffffd100Y:|r " .. point[5], 1, 1, 1)
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine("Hold SHIFT+LeftButton to drag!", 1, 1, 1, 1, 1, 1)
    if self.frame:IsResizable() then GameTooltip:AddLine("Hold SHIFT+RightButton to resize!", 1, 1, 1, 1, 1, 1) end
    GameTooltip:Show()
end

function R:DragFrame_OnLeave() GameTooltip:Hide() end

function R:DragFrame_OnShow() if self.frame.faderConfig and (not self.frame.config or self.frame.config.enabled) then R:FadeIn(self.frame) end end

function R:DragFrame_OnHide() if self.frame.faderConfig and (not self.frame.config or self.frame.config.enabled) then R.Fader_OnEnterOrLeave(self.frame) end end

function R:HideDragFrame(frame)
    if not frame or not frame.DragFrame then return end

    if frame.visibility then RegisterStateDriver(frame, "visibility", frame.visibility) end
    frame.DragFrame:Hide()
end

function R:ShowDragFrame(frame)
    if not frame or not frame.DragFrame or (frame.DragFrame.isLocked and frame.DragFrame.hideWhenLocked) or (frame.config and frame.config.enabled == false) then return end

    if frame.visibility and (not frame.config or frame.config.enabled) then RegisterStateDriver(frame, "visibility", "show") end
    frame.DragFrame:Show()
end

function R:HideDragFrames()
    for idx, frame in next, R.dragFrames do R:HideDragFrame(frame) end
    R:Print("Frames locked.")
    R:HideGrid()
    R.framesLocked = true
end

function R:ShowDragFrames()
    for idx, frame in next, R.dragFrames do R:ShowDragFrame(frame) end
    R:Print("Frames unlocked.")
    R:ShowGrid()
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
    if not frame or not frame.DragFrame or frame.DragFrame.isDisabled then return end

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
        ObjectiveTrackerFrame:SetMovable(true)
        ObjectiveTrackerFrame:SetUserPlaced(true)
        ObjectiveTrackerFrame:ClearAllPoints()
        R:SetPoint(ObjectiveTrackerFrame, unpack(R.config.db.profile.dragFrames.objectiveTracker.point))
        R:CreateDragFrame(ObjectiveTrackerFrame, "Objective Tracker", R.config.defaults.profile.dragFrames.objectiveTracker.point)
    end
end
