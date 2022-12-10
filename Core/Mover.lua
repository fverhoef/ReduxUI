local addonName, ns = ...
local R = _G.ReduxUI
R.movers = {}

local FADED_MOVER_ALPHA = 0.3

R.MoverMixin = {}

function R.MoverMixin:OnMouseWheel(offset)
    if IsShiftKeyDown() then
        local point = self.frame:GetNormalizedPoint()
        point[5] = point[5] + offset
        self.frame:SetNormalizedPoint(point)
    elseif IsControlKeyDown() then
        local point = self.frame:GetNormalizedPoint()
        point[4] = point[4] + offset
        self.frame:SetNormalizedPoint(point)
    end

    if self.frame.config and self.frame.config.point then
        self.frame.config.point = self.frame:GetNormalizedPoint()
    end

    if GameTooltip:IsOwned(self) then
        self:OnEnter()
    end
end

function R.MoverMixin:OnDragStart(button)
    if self.isLocked then
        return
    end

    if IsShiftKeyDown() then
        self.frame:StartMoving()
    end
end

function R.MoverMixin:OnDragStop()
    self.frame:StopMovingOrSizing()
    if self.frame.config and self.frame.config.point then
        self.frame.config.point = self.frame:GetNormalizedPoint()
    end
end

function R.MoverMixin:OnEnter()
    local point = self.frame:GetNormalizedPoint()

    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine(self.displayName, 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(string.format("%s" .. R.L["Point"] .. ":|r %s", R:Hex(R.NORMAL_FONT_COLOR), point[1]), 1, 1, 1)
    GameTooltip:AddLine(string.format("%s" .. R.L["Attached to"] .. ":|r %s of %s|r", R:Hex(R.NORMAL_FONT_COLOR), point[3], point[2]), 1, 1, 1)
    GameTooltip:AddLine(string.format("%sX:|r %s, %sY:|r %s", R:Hex(R.NORMAL_FONT_COLOR), point[4], R:Hex(R.NORMAL_FONT_COLOR), point[5]), 1, 1, 1)
    GameTooltip:AddLine("|cffffd100X:|r " .. point[4] .. ", |cffffd100Y:|r " .. point[5], 1, 1, 1)
    GameTooltip:Show()

    self:FadeIn(0.3, self:GetAlpha(), 1)
    self:UpdateArtwork(true)
end

function R.MoverMixin:OnLeave()
    GameTooltip:Hide()
    self:FadeOut(0.3, self:GetAlpha(), FADED_MOVER_ALPHA)
    self:UpdateArtwork(false)
end

function R.MoverMixin:UpdateArtwork(selected)
    self:CreateBorder(nil, 8, 2, nil, selected and R.media.textures.edgeFiles.moverSelected or R.media.textures.edgeFiles.moverHighlight)
    self:CreateBackdrop({ bgFile = selected and R.media.textures.backdrops.moverSelectedBackground or R.media.textures.backdrops.moverHighlightBackground }, { 1, 1, 1 })
    self.Backdrop:SetInside(self, 2, 2)
end

function R.MoverMixin:OnShow()
    if self.isLocked and self.hideWhenLocked then
        self:Hide()
        return
    end

    self.Label:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
    if self.frame.visibility and (not self.frame.config or self.frame.config.enabled) then
        RegisterStateDriver(self.frame, "visibility", "show")
    end
    if self.frame.Fader and (not self.frame.config or self.frame.config.enabled) then
        self.frame:FadeIn()
    end
end

function R.MoverMixin:OnHide()
    if self.frame.visibility then
        RegisterStateDriver(self.frame, "visibility", self.frame.visibility)
    end
    if self.frame.Fader and (not self.frame.config or self.frame.config.enabled) then
        self.frame.Fader:OnEnterOrLeave()
    end
end

function R.MoverMixin:OnMouseDown(button)
    if IsShiftKeyDown() and button == "RightButton" then
        self:ResetPoint()
        self:ResetSize()
    end
end

function R.MoverMixin:ResetSize()
    if not self.frame or not self.frame.defaultSize or InCombatLockdown() then
        return
    end
    self.frame:SetSize(unpack(self.frame.defaultSize))
    if self.frame.config then
        self.frame.config.size = self.frame.defaultSize
    end
end

function R.MoverMixin:ResetPoint()
    if not self.frame or not self.frame.defaultPoint or InCombatLockdown() then
        return
    end
    self.frame:ClearAllPoints()
    self.frame:SetNormalizedPoint(self.frame.defaultPoint)
    if self.frame.config then
        self.frame.config.point = self.frame.defaultPoint
    end
end

function R.MoverMixin:Lock(hideWhenLocked)
    if not self.frame then
        return
    end

    self.isLocked = true
    self.hideWhenLocked = hideWhenLocked
    -- TODO: apply locked texture
    -- self.texture:SetVertexColor(1, 0, 0)

    if not R.framesLocked then
        self:Hide()
    end
end

function R.MoverMixin:Unlock()
    if not self.frame or self.isDisabled then
        return
    end

    self.isLocked = false
    -- TODO: apply unlocked texture
    -- self.texture:SetVertexColor(0, 1, 0)

    if not R.framesLocked then
        self:Show()
    end
end

function R:CreateMover(displayName, defaultPoint, width, height, point)
    if not self or self.Mover then
        return
    end

    self.defaultPoint = defaultPoint or self:GetNormalizedPoint()

    local name = self:GetName()
    local mover = Mixin(CreateFrame("Frame", name and name .. "Mover" or nil), R.MoverMixin)
    mover.frame = self
    mover.displayName = displayName or name

    if width or height then
        if point then
            mover:SetPoint(unpack(point))
        else
            mover:SetPoint("CENTER", self, "CENTER")
        end
        mover:SetSize(width or self:GetWidth(), height or self:GetHeight())
    else
        mover:SetAllPoints(self)
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

    mover.Label = mover:CreateFontString(nil, "OVERLAY")
    mover.Label:SetAllPoints(mover)
    mover.Label:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    mover.Label:SetText(mover.displayName)

    mover:UpdateArtwork(false)

    table.insert(R.movers, mover)

    self.Mover = mover
    self:SetMovable(true)
end

function R:HideMovers()
    for _, mover in next, R.movers do
        mover:Hide()
    end
    R:Print("Frames locked.")
    R:HideGrid()
    R.framesLocked = true

    if R.moverSettings then
        R.moverSettings:Hide()
    end
end

function R:ShowMovers()
    for _, mover in next, R.movers do
        mover:Show()
    end
    R:Print("Frames unlocked.")
    R:ShowGrid()
    R.framesLocked = false

    if not R.moverSettings then
        R.moverSettings = R:CreateMoverSettingsFrame()
    end
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

        if mover.frame.Configure then
            mover.frame:Configure()
        end
        if mover.frame.Update then
            mover.frame:Update()
        end
    end
    R:Print("Frame positions and sizes have been reset.")
end

function R:CreateMoverSettingsFrame()
    local settings = CreateFrame("Frame", addonName .. "MoverSettings", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
    settings:SetFrameStrata("DIALOG")
    settings:SetToplevel(true)
    settings:EnableMouse(true)
    settings:SetMovable(true)
    settings:SetClampedToScreen(true)
    settings:SetWidth(360)
    settings:SetHeight(180)
    settings:SetBackdrop{
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        insets = { left = 11, right = 12, top = 12, bottom = 11 },
        tileSize = 32,
        edgeSize = 32
    }
    settings:SetPoint("TOP", 0, -64)
    settings:RegisterForDrag("LeftButton")
    settings:SetScript("OnDragStart", settings.StartMoving)
    settings:SetScript("OnDragStop", settings.StopMovingOrSizing)

    settings.header = settings:CreateTexture(nil, "ARTWORK")
    settings.header:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
    settings.header:SetWidth(286);
    settings.header:SetHeight(64)
    settings.header:SetPoint("TOP", 0, 12)

    settings.title = settings:CreateFontString(nil, "ARTWORK")
    settings.title:SetFont(STANDARD_TEXT_FONT, 14)
    settings.title:SetJustifyV("TOP")
    settings.title:SetJustifyH("CENTER")
    settings.title:SetPoint("TOP", settings.header, "TOP", 0, -13)
    settings.title:SetText(R.title .. ": " .. R.L["Edit Mode"])

    settings.description = settings:CreateFontString(nil, "OVERLAY")
    settings.description:SetFont(STANDARD_TEXT_FONT, 12)
    settings.description:SetJustifyV("TOP")
    settings.description:SetJustifyH("LEFT")
    settings.description:SetPoint("TOPLEFT", 18, -32)
    settings.description:SetPoint("BOTTOMRIGHT", -18, 48)
    settings.description:SetText(string.format(R.L["Hold %sShift|r to enable dragging."] .. "\n\n" .. R.L["Use %sShift/Ctrl + Mouse Wheel|r or %sArrow keys|r for 1px adjustments."] .. "\n\n" ..
                                                   R.L["%sShift + Right Click|r to reset the position of the frame."] .. "\n\n" ..
                                                   R.L["Press the %sAlt|r key to cycle through frames under the cursor."], R:Hex(R.NORMAL_FONT_COLOR), R:Hex(R.NORMAL_FONT_COLOR),
                                               R:Hex(R.NORMAL_FONT_COLOR), R:Hex(R.NORMAL_FONT_COLOR), R:Hex(R.NORMAL_FONT_COLOR)))

    settings.lockButton = CreateFrame("Button", "$parentLockButton", settings, "UIPanelButtonTemplate")
    settings.lockButton:SetSize(80, 21)
    settings.lockButton:SetPoint("BOTTOMRIGHT", -14, 14)
    settings.lockButton:SetScript("OnClick", R.HideMovers)
    settings.lockButton.Text:SetText(R.L["Lock"])

    settings.resetButton = CreateFrame("Button", "$parentResetButton", settings, "UIPanelButtonTemplate")
    settings.resetButton:SetSize(140, 21)
    settings.resetButton:SetPoint("BOTTOMRIGHT", settings.lockButton, "BOTTOMLEFT", -4, 0)
    settings.resetButton:SetScript("OnClick", R.ResetMovers)
    settings.resetButton.Text:SetText(R.L["Reset All Frames"])

    settings.highlightIndex = 1
    settings.HighlightMovers = function(self)
        local trackedMovers = {}
        for _, mover in next, R.movers do
            if mover:IsMouseOver(4, -4, -4, 4) then
                table.insert(trackedMovers, mover)
            end
        end

        if #trackedMovers > 0 then
            if self.highlightIndex > #trackedMovers or #trackedMovers == 1 then
                self.highlightIndex = 1
            end

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
        end
    end
    settings:SetScript("OnKeyDown", function(self, key)
        if key == "LALT" or key == "RALT" then
            self:HighlightMovers()
        end
    end)
    settings:Hide()

    return settings
end
