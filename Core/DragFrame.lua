local AddonName, AddonTable = ...
local Addon = AddonTable[1]
Addon.dragFrames = {}

local function OnDragStart(self, button)
    if IsShiftKeyDown() then
        if button == "LeftButton" then
            self.frame:StartMoving()
        end
        if button == "RightButton" then
            self.frame:StartSizing()
        end
    end
end

local function OnDragStop(self)
    self.frame:StopMovingOrSizing()
    if self.frame.cfg and self.frame.cfg.point then
        local _, _, _, x, y = self.frame:GetPoint()
        self.frame.cfg.point[1] = "CENTER"
        self.frame.cfg.point[2] = "UIParent"
        self.frame.cfg.point[3] = "CENTER"
        self.frame.cfg.point[4] = x
        self.frame.cfg.point[5] = y
    end
end

local function OnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine(self.frame:GetName(), 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddLine("Hold SHIFT+LeftButton to drag!", 1, 1, 1, 1, 1, 1)
    if self.frame.__resizable then
        GameTooltip:AddLine("Hold SHIFT+RightButton to resize!", 1, 1, 1, 1, 1, 1)
    end
    GameTooltip:Show()
end

local function OnLeave(self)
    GameTooltip:Hide()
end

local function OnShow(self)
    if self.frame.fader then
        Addon:StartFadeIn(dragFrame.frame)
    end
end

local function OnHide(self)
    if self.frame.fader then
        Addon:StartFadeOut(dragFrame.frame)
    end
end

function Addon:CreateDragFrame(frame, displayName, defaultPoint, width, height)
    if not frame then
        return
    end

    table.insert(Addon.dragFrames, frame)

    -- save the default position so we can reset to it
    frame.defaultPoint = defaultPoint or Addon:GetPoint(frame)

    -- anchor a dragable frame on frame
    local dragFrame = CreateFrame("Frame")
    dragFrame.frame = frame
    dragFrame.displayName = displayName or frame:GetName()
    if width or height then
        dragFrame:SetPoint("CENTER", frame, "CENTER")
        dragFrame:SetSize(width or frame:GetWidth(), height or frame:GetHeight())
    else
        dragFrame:SetAllPoints(frame)
    end
    dragFrame:SetFrameStrata("HIGH")
    dragFrame:EnableMouse(true)
    dragFrame:SetMovable(true)
    dragFrame:RegisterForDrag("LeftButton")
    dragFrame:SetScript("OnDragStart", OnDragStart)
    dragFrame:SetScript("OnDragStop", OnDragStop)
    dragFrame:SetScript("OnEnter", OnEnter)
    dragFrame:SetScript("OnLeave", OnLeave)
    dragFrame:SetScript("OnShow", OnShow)
    dragFrame:SetScript("OnHide", OnHide)
    dragFrame:Hide()

    -- overlay texture
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

    -- frame stuff
    frame.DragFrame = dragFrame
    frame:SetMovable(true)

    if resizable then
        frame.defaultSize = Addon:GetSize(frame)
        frame:SetResizable(true)
        frame.__resizable = true
        frame.DragFrame:RegisterForDrag("LeftButton", "RightButton")
    end
end

function Addon:LockFrame(frame)
    if frame.frameVisibility then
        if frame.frameVisibilityFunc then
            UnregisterStateDriver(frame, "visibility")
            -- hack to make it refresh properly, otherwise if you had state n (no vehicle exit button) it would not update properly because the state n is still in place
            RegisterStateDriver(frame, frame.frameVisibilityFunc, "foo")
            RegisterStateDriver(frame, frame.frameVisibilityFunc, frame.frameVisibility)
        else
            RegisterStateDriver(frame, "visibility", frame.frameVisibility)
        end
    end
    frame.DragFrame:Hide()
end

function Addon:UnlockFrame(frame)
    if frame.frameVisibility then
        if frame.frameVisibilityFunc then
            UnregisterStateDriver(frame, frame.frameVisibilityFunc)
        end
        RegisterStateDriver(frame, "visibility", "show")
    end
    frame.DragFrame:Show()
end

function Addon:LockFrames()
    for idx, frame in next, Addon.dragFrames do
        Addon:LockFrame(frame)
    end
    Addon:Print("Frames locked.")
end

function Addon:UnlockFrames()
    for idx, frame in next, Addon.dragFrames do
        Addon:UnlockFrame(frame)
    end
    Addon:Print("Frames unlocked.")
end

function Addon:ResetFrames()
    if InCombatLockdown() then
        Addon:PrintError("Resetting frames is not allowed while in combat!")
        return
    end
    for _, frame in next, Addon.dragFrames do
        Addon:ResetPoint(frame)
        Addon:ResetSize(frame)
    end
    Addon:Print("Frame positions and sizes have been reset.")
end

function Addon:ResetSize(frame)
    if not frame or not frame.defaultSize or InCombatLockdown() then
        return
    end
    frame:SetSize(unpack(frame.defaultSize))
    frame.cfg.size = frame.defaultSize
end

function Addon:ResetPoint(frame)
    if not frame or not frame.defaultPoint or InCombatLockdown() then
        return
    end
    frame:ClearAllPoints()
    frame:SetPoint(unpack(frame.defaultPoint))
    frame.cfg.point = frame.defaultPoint
end
