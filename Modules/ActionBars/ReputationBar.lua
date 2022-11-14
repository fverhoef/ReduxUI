local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreateReputationBar()
    return CreateFrame("StatusBar", addonName .. "_ReputationBar", UIParent, "ReputationBarTemplate_")
end

ReputationBarMixin = {}

function ReputationBarMixin:OnLoad()
    self.config = AB.config.reputationBar
    self.defaults = AB.defaults.reputationBar
    self:SetNormalizedSize(AB.config.reputationBar.size)
    self:SetNormalizedPoint(AB.config.reputationBar.point)
    self:CreateMover(L["Reputation Bar"], AB.defaults.reputationBar.point)
    
    self.Backdrop:SetBackdropColor(BACKDROP_COLOR.r, BACKDROP_COLOR.g, BACKDROP_COLOR.b, BACKDROP_COLOR.a)
    self.Backdrop:SetBackdropBorderColor(BACKDROP_BORDER_COLOR.r, BACKDROP_BORDER_COLOR.g, BACKDROP_BORDER_COLOR.b, BACKDROP_BORDER_COLOR.a)
end

function ReputationBarMixin:OnEnter()
    self.OverlayFrame.Text:Show()
end

function ReputationBarMixin:OnLeave()
    self.OverlayFrame.Text:Hide()
end

function ReputationBarMixin:Update()
    local watchedFactionName = GetWatchedFactionInfo()
    local showRep = watchedFactionName ~= nil
    local repMin, repMax = ReputationWatchBar.StatusBar:GetMinMaxValues()
    local repValue = ReputationWatchBar.StatusBar:GetValue()
    local repText = string.format("%s %i / %i", watchedFactionName or "None", repValue, repMax)
    self:SetStatusBarTexture(R.Media.Textures.StatusBars.Redux)
    self:SetStatusBarColor(unpack({ReputationWatchBar.StatusBar:GetStatusBarColor()}))
    self:SetMinMaxValues(repMin, repMax)
    self:SetValue(repValue)
    self:SetShown(showRep)
    self.OverlayFrame.Text:SetText(repText)
    self.OverlayFrame.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
end