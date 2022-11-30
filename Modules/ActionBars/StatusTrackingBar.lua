local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

AB.statusTrackingBarManager = CreateFrame("Frame", addonName .. "_StatusTrackingBarManager", UIParent)

function AB:CreateStatusTrackingBar()
    if R.isRetail then
        StatusTrackingBarManager:SetParent(AB.statusTrackingBarManager)
        StatusTrackingBarManager:AddBarFromTemplate("FRAME", "ReputationStatusBarTemplate")
        StatusTrackingBarManager:AddBarFromTemplate("FRAME", "HonorStatusBarTemplate")
        StatusTrackingBarManager:AddBarFromTemplate("FRAME", "ArtifactStatusBarTemplate")
        StatusTrackingBarManager:AddBarFromTemplate("FRAME", "ExpStatusBarTemplate")
        StatusTrackingBarManager:AddBarFromTemplate("FRAME", "AzeriteBarTemplate")
    end

    return CreateFrame("StatusBar", addonName .. "_StatusTrackingBar", UIParent, "StatusTrackingBarTemplate_")
end

AB.StatusTrackingBarMixin = {}
ReduxStatusTrackingBarMixin = AB.StatusTrackingBarMixin

function AB.StatusTrackingBarMixin:OnLoad()
    self.config = AB.config.statusTrackingBar
    self.defaults = AB.defaults.statusTrackingBar

    self:CreateBackdrop({ bgFile = R.media.textures.blank })
    self:CreateBorder(nil, 8, 2)
    self:CreateShadow(nil, 10, 4)
    self:CreateFader(self.config.fader)
    self:CreateMover(L["Reputation/Tracking Bar"], self.defaults.point)

    self:Update()
end

function AB.StatusTrackingBarMixin:OnEnter()
    self.OverlayFrame.Text:Show()
end

function AB.StatusTrackingBarMixin:OnLeave()
    self.OverlayFrame.Text:Hide()
end

function AB.StatusTrackingBarMixin:Update()
    if not self.config.enabled then
        self:Hide()
        return
    end

    self:ClearAllPoints()
    self:SetNormalizedPoint(self.config.point)
    self:SetNormalizedSize(self.config.size)
    self.Backdrop:SetShown(self.config.backdrop)
    self.Border:SetShown(self.config.border)
    self.Shadow:SetShown(self.config.shadow)
    self.Mover:Unlock()
    self:CreateFader(self.config.fader)

    local watchedFactionName = GetWatchedFactionInfo()
    local showRep = watchedFactionName ~= nil
    local repMin, repMax = ReputationWatchBar.StatusBar:GetMinMaxValues()
    local repValue = ReputationWatchBar.StatusBar:GetValue()
    local repText = string.format("%s %i / %i", watchedFactionName or "None", repValue, repMax)
    self:SetStatusBarTexture(R.media.textures.statusBars.redux)
    self:SetStatusBarColor(unpack({ ReputationWatchBar.StatusBar:GetStatusBarColor() }))
    self:SetMinMaxValues(repMin, repMax)
    self:SetValue(repValue)
    self:SetShown(showRep)
    self.OverlayFrame.Text:SetText(repText)
    self.OverlayFrame.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
end
