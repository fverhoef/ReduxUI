local addonName, ns = ...
local R = _G.ReduxUI
R.movers = {}

local FADED_MOVER_ALPHA = 0.3

MoverMixin = {}

function MoverMixin:OnMouseWheel(offset)
    if IsShiftKeyDown() then
        local point = R:GetPoint(self.frame)
        point[5] = point[5] + offset
        R:SetPoint(self.frame, point)
    elseif IsControlKeyDown() then
        local point = R:GetPoint(self.frame)
        point[4] = point[4] + offset
        R:SetPoint(self.frame, point)
    end

    if GameTooltip:IsOwned(self) then self:OnEnter() end
end

function MoverMixin:OnDragStart(button)
    if self.isLocked then return end

    if IsShiftKeyDown() then
        if button == "LeftButton" then self.frame:StartMoving() end
        if button == "RightButton" then self.frame:StartSizing() end
    end
end

function MoverMixin:OnDragStop()
    self.frame:StopMovingOrSizing()
    if self.frame.config and self.frame.config.point then self.frame.config.point = R:GetPoint(self.frame) end
end

function MoverMixin:OnEnter()
    local point = R:GetPoint(self.frame)

    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine(self.displayName, 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(string.format("%s" .. R.L["Point"] .. ":|r %s", R:Hex(R.NORMAL_FONT_COLOR), point[1]), 1, 1, 1)
    GameTooltip:AddLine(string.format("%s" .. R.L["Attached to"] .. ":|r %s of %s|r", R:Hex(R.NORMAL_FONT_COLOR), point[3], point[2]), 1, 1, 1)
    GameTooltip:AddLine(string.format("%sX:|r %s, %sY:|r %s", R:Hex(R.NORMAL_FONT_COLOR), point[4], R:Hex(R.NORMAL_FONT_COLOR), point[5]), 1, 1, 1)
    GameTooltip:AddLine("|cffffd100X:|r " .. point[4] .. ", |cffffd100Y:|r " .. point[5], 1, 1, 1)
    GameTooltip:Show()

    R:FadeIn(self, 0.3, self:GetAlpha(), 1)
end

function MoverMixin:OnLeave()
    GameTooltip:Hide()
    R:FadeOut(self, 0.3, self:GetAlpha(), FADED_MOVER_ALPHA)
end

function MoverMixin:OnShow()
    if self.isLocked and self.hideWhenLocked then
        self:Hide()
        return
    end

    self.displayNameText:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
    if self.frame.visibility and (not self.frame.config or self.frame.config.enabled) then RegisterStateDriver(self.frame, "visibility", "show") end
    if self.frame.faderConfig and (not self.frame.config or self.frame.config.enabled) then R:FadeIn(self.frame) end
end

function MoverMixin:OnHide()
    if self.frame.visibility then RegisterStateDriver(self.frame, "visibility", self.frame.visibility) end
    if self.frame.faderConfig and (not self.frame.config or self.frame.config.enabled) then R.Fader_OnEnterOrLeave(self.frame) end
end

function MoverMixin:OnMouseDown(button)
    if IsShiftKeyDown() and button == "RightButton" then
        self:ResetPoint()
        self:ResetSize()
    end
end

function MoverMixin:ResetSize()
    if not self.frame or not self.frame.defaultSize or InCombatLockdown() then return end
    self.frame:SetSize(unpack(self.frame.defaultSize))
    if self.frame.config then self.frame.config.size = self.frame.defaultSize end
end

function MoverMixin:ResetPoint()
    if not self.frame or not self.frame.defaultPoint or InCombatLockdown() then return end
    self.frame:ClearAllPoints()
    R:SetPoint(self.frame, self.frame.defaultPoint)
    if self.frame.config then self.frame.config.point = self.frame.defaultPoint end
end

function MoverMixin:Lock(hideWhenLocked)
    if not self.frame then return end

    self.isLocked = true
    self.hideWhenLocked = hideWhenLocked
    self.texture:SetVertexColor(1, 0, 0)

    if not R.framesLocked then self:Hide() end
end

function MoverMixin:Unlock()
    if not self.frame or self.isDisabled then return end

    self.isLocked = false
    self.texture:SetVertexColor(0, 1, 0)

    if not R.framesLocked then self:Show() end
end

function R:CreateMover(frame, displayName, defaultPoint, width, height, point)
    if not frame or frame.Mover then return end

    frame.defaultPoint = defaultPoint or R:GetPoint(frame)

    local name = frame:GetName()
    local mover = Mixin(CreateFrame("Frame", name and name .. "Mover" or nil), MoverMixin)
    mover.frame = frame
    mover.displayName = displayName or name

    if width or height then
        if point then
            mover:SetPoint(unpack(point))
        else
            mover:SetPoint("CENTER", frame, "CENTER")
        end
        mover:SetSize(width or frame:GetWidth(), height or frame:GetHeight())
    else
        mover:SetAllPoints(frame)
    end
    mover:SetFrameStrata("HIGH")
    mover:SetFrameLevel(1)
    mover:SetAlpha(FADED_MOVER_ALPHA)
    mover:EnableMouse(true)
    mover:SetMovable(true)
    mover:RegisterForDrag("LeftButton")
    mover:SetScript("OnMouseWheel", mover.OnMouseWheel)
    mover:SetScript("OnDragStart", mover.OnDragStart)
    mover:SetScript("OnDragStop", mover.OnDragStop)
    mover:SetScript("OnEnter", mover.OnEnter)
    mover:SetScript("OnLeave", mover.OnLeave)
    mover:SetScript("OnShow", mover.OnShow)
    mover:SetScript("OnHide", mover.OnHide)
    mover:SetScript("OnMouseDown", mover.OnMouseDown)
    mover:Hide()

    mover.texture = mover:CreateTexture(nil, "OVERLAY", nil, 6)
    mover.texture:SetAllPoints(mover)
    mover.texture:SetColorTexture(1, 1, 1)
    mover.texture:SetVertexColor(0, 1, 0)
    mover.texture:SetAlpha(0.3)

    mover.displayNameText = mover:CreateFontString(nil, "OVERLAY")
    mover.displayNameText:SetAllPoints(mover)
    mover.displayNameText:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    mover.displayNameText:SetText(mover.displayName)

    table.insert(R.movers, mover)

    frame.Mover = mover
    frame:SetMovable(true)

    if frame:IsResizable() then
        frame.defaultSize = R:GetSize(frame)
        frame.Mover:RegisterForDrag("LeftButton", "RightButton")
    end
end

function R:HideMovers()
    for _, mover in next, R.movers do mover:Hide() end
    R:Print("Frames locked.")
    R:HideGrid()
    R.framesLocked = true

    if R.moverSettings then R.moverSettings:Hide() end
end

function R:ShowMovers()
    for _, mover in next, R.movers do mover:Show() end
    R:Print("Frames unlocked.")
    R:ShowGrid()
    R.framesLocked = false

    if not R.moverSettings then R.moverSettings = R:CreateMoverSettingsFrame() end
    R.moverSettings:Show()
end

function R:ToggleMovers()
    if R.framesLocked then
        R:ShowMovers()
    else
        R:HideMovers()
    end
end

function R:ResetMovers()
    if InCombatLockdown() then
        R:PrintError("Resetting frames is not allowed while in combat!")
        return
    end
    for _, mover in next, R.movers do
        mover:ResetPoint()
        mover:ResetSize()

        if mover.frame.Update then mover.frame:Update() end
    end
    R:Print("Frame positions and sizes have been reset.")
end

function R:CreateBlizzardMovers()
    if ObjectiveTrackerFrame then
        ObjectiveTrackerFrame:SetMovable(true)
        ObjectiveTrackerFrame:SetUserPlaced(true)
        ObjectiveTrackerFrame:ClearAllPoints()
        R:SetPoint(ObjectiveTrackerFrame, unpack(R.config.db.profile.movers.objectiveTracker.point))
        R:CreateMover(ObjectiveTrackerFrame, "Objective Tracker", R.config.defaults.profile.movers.objectiveTracker.point)
    end
end

function R:CreateMoverSettingsFrame()
    local settings = CreateFrame("Frame", addonName .. "MoverSettings", UIParent)
    settings:SetSize(320, 160)
    settings:SetPoint("CENTER")
    settings:SetMovable(true)
    settings:SetClampedToScreen(true)
    settings:EnableMouse(true)
    settings:RegisterForDrag("LeftButton")
    settings:SetScript("OnDragStart", settings.StartMoving)
    settings:SetScript("OnDragStop", settings.StopMovingOrSizing)

    settings.bg = settings:CreateTexture(nil, "BACKGROUND", nil, -7)
    settings.bg:SetAllPoints()
    settings.bg:SetTexture([[Interface\HELPFRAME\DarkSandstone-Tile]], "REPEAT", "REPEAT")
    settings.bg:SetHorizTile(true)
    settings.bg:SetVertTile(true)

    settings.title = settings:CreateFontString(nil, "OVERLAY")
    settings.title:SetFont(STANDARD_TEXT_FONT, 14)
    settings.title:SetPoint("TOPLEFT", 4, -4)
    settings.title:SetPoint("TOPRIGHT", -4, -4)
    settings.title:SetJustifyH("MIDDLE")
    settings.title:SetJustifyV("TOP")
    settings.title:SetText(R.title .. ": " .. R.L["Moving Frames"])

    settings.usageText = settings:CreateFontString(nil, "OVERLAY")
    settings.usageText:SetFont(STANDARD_TEXT_FONT, 12)
    settings.usageText:SetPoint("TOPLEFT", 4, -24)
    settings.usageText:SetPoint("BOTTOMRIGHT", -4, 26)
    settings.usageText:SetJustifyH("LEFT")
    settings.usageText:SetJustifyV("MIDDLE")
    settings.usageText:SetText(string.format(R.L["Use %sShift/Ctrl + Mouse Wheel|r or %sArrow keys|r for 1px adjustments."] .. "\n\n" ..
                                                 R.L["%sShift + Right Click|r to reset the position of the frame."] .. "\n\n" .. R.L["Press the %sAlt|r key to cycle through frames under the cursor."],
                                             R:Hex(R.NORMAL_FONT_COLOR), R:Hex(R.NORMAL_FONT_COLOR), R:Hex(R.NORMAL_FONT_COLOR), R:Hex(R.NORMAL_FONT_COLOR)))

    settings.lockButton = CreateFrame("Button", "$parentLockButton", settings, "UIPanelButtonTemplate")
    settings.lockButton:SetSize(80, 21)
    settings.lockButton:SetPoint("BOTTOMRIGHT", -4, 4)
    settings.lockButton:SetScript("OnClick", R.HideMovers)
    settings.lockButton.Text:SetText(R.L["Lock"])

    settings.resetButton = CreateFrame("Button", "$parentResetButton", settings, "UIPanelButtonTemplate")
    settings.resetButton:SetSize(140, 21)
    settings.resetButton:SetPoint("BOTTOMRIGHT", settings.lockButton, "BOTTOMLEFT", -4, 0)
    settings.resetButton:SetScript("OnClick", R.ResetMovers)
    settings.resetButton.Text:SetText(R.L["Reset All Frames"])

    R:CreateBorder(settings)
    R:CreateShadow(settings)

    settings.highlightIndex = 1
    settings.HighlightMovers = function(self)
        local trackedMovers = {}
        for _, mover in next, R.movers do if mover:IsMouseOver(4, -4, -4, 4) then table.insert(trackedMovers, mover) end end

        if #trackedMovers > 0 then
            if self.highlightIndex > #trackedMovers or #trackedMovers == 1 then self.highlightIndex = 1 end

            for i, mover in next, trackedMovers do
                if i == self.highlightIndex then
                    if mover ~= self.mover then
                        mover:SetFrameLevel(2)
                        mover:OnEnter()

                        self.mover = mover
                    end
                else
                    mover:SetFrameLevel(1)
                    mover:OnLeave()
                end
            end

            self.highlightIndex = self.highlightIndex + 1
        else
            for _, mover in next, R.movers do R:FadeIn(mover, 0.3, mover:GetAlpha(), 1) end
            self.mover = nil
        end
    end
    settings:SetScript("OnKeyDown", function(self, key) if key == "LALT" or key == "RALT" then self:HighlightMovers() end end)
    settings:Hide()

    return settings
end