local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreateMainMenuBarArtFrame() AB.MainMenuBarArtFrame = CreateFrame("Frame", addonName .. "MainMenuBarArtFrame", UIParent, "MainMenuBarArtFrameTemplate") end

MainMenuBarArtFrameMixin = {}

function MainMenuBarArtFrameMixin:OnLoad()
    if R.isRetail then StatusTrackingBarManager:SetParent(self) end

    self.PageNumber:SetText(GetActionBarPage())
    ActionBarUpButton:SetParent(self)
    ActionBarUpButton:ClearAllPoints()
    ActionBarUpButton:SetPoint("BOTTOMRIGHT", self.PageNumber, "TOPLEFT", 8, -14)
    ActionBarDownButton:SetParent(self)
    ActionBarDownButton:ClearAllPoints()
    ActionBarDownButton:SetPoint("TOPRIGHT", self.PageNumber, "BOTTOMLEFT", 8, 13)

    self:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PLAYER_LEVEL_UP")
    self:RegisterEvent("PLAYER_UPDATE_RESTING")
    self:RegisterEvent("PLAYER_XP_UPDATE")
    self:RegisterEvent("UPDATE_EXHAUSTION")
    if not R.isRetail then AB:SecureHook("MainMenuBar_UpdateExperienceBars", function() self:Update() end) end

    self:Update()
end

function MainMenuBarArtFrameMixin:OnEvent(event, ...)
    if event == "ACTIONBAR_PAGE_CHANGED" then
        self.PageNumber:SetText(GetActionBarPage())
    else
        self:UpdateRested()
    end
end

function MainMenuBarArtFrameMixin:OnStatusBarsUpdated()
    self:Update()
end

function MainMenuBarArtFrameMixin:GetNumberOfVisibleTrackingBars()
    if R.isRetail then
        return StatusTrackingBarManager:GetNumberVisibleBars()
    else
        return (self.ExperienceBar:IsShown() and 1 or 0) + (self.ReputationBar:IsShown() and 1 or 0)
    end
end

function MainMenuBarArtFrameMixin:UpdateRested()
    if self.ExperienceBar:IsShown() then
        local exhaustionThreshold = GetXPExhaustion()

        if not exhaustionThreshold or exhaustionThreshold <= 0 then
            self.ExperienceBar.RestedTick:Hide()
            self.ExperienceBar.RestedFillBar:Hide()
        else
            local exhaustionTickSet = math.max(((UnitXP("player") + exhaustionThreshold) / UnitXPMax("player")) * self.ExperienceBar:GetWidth(), 0)
            if exhaustionTickSet > self.ExperienceBar:GetWidth() then
                self.ExperienceBar.RestedTick:Hide()
                self.ExperienceBar.RestedFillBar:Hide()
            else
                self.ExperienceBar.RestedTick:Show()
                self.ExperienceBar.RestedTick:SetPoint("CENTER", self.ExperienceBar, "LEFT", exhaustionTickSet, 0)
                self.ExperienceBar.RestedFillBar:Show()
                self.ExperienceBar.RestedFillBar:SetPoint("TOPRIGHT", exhaustionTickSet, 0)
            end
        end
    end
end

function MainMenuBarArtFrameMixin:Update()
    if not AB.config.mainMenuBarArt.enabled then
        self:Hide()
        return
    else
        self:Show()
    end

    local isLarge = not AB.config.mainMenuBarArt.stackBottomBars and AB.config.actionBar4.enabled
    self:SetSize(isLarge and 804 or 550, 49)
    self.BackgroundLarge:SetShown(isLarge)
    self.BackgroundSmall:SetShown(not isLarge)

    if not R.isRetail then
        local watchedFactionName = GetWatchedFactionInfo()
        local showXP = UnitLevel("player") < GetMaxPlayerLevel()
        local showRep = watchedFactionName ~= nil

        local expMin, expMax = MainMenuExpBar:GetMinMaxValues()
        local expValue = MainMenuExpBar:GetValue()
        local expText = string.format("%s %i / %i", XP, expValue, expMax)
        self.ExperienceBar:SetStatusBarTexture(AB.config.statusbars.experience)
        self.ExperienceBar:SetStatusBarColor(unpack({MainMenuExpBar:GetStatusBarColor()}))
        self.ExperienceBar:SetMinMaxValues(expMin, expMax)
        self.ExperienceBar:SetValue(expValue)
        self.ExperienceBar:SetShown(showXP)
        self.ExperienceBar.OverlayFrame.Text:SetText(expText)
        self.ExperienceBar.OverlayFrame.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")

        self.ExperienceBar:SetHeight(11)
        self.ExperienceBar:SetPoint("BOTTOMLEFT", 0, showRep and -19 or -13)
        self.ExperienceBar:SetPoint("BOTTOMRIGHT", 0, showRep and -19 or -13)

        self:UpdateRested()

        local repMin, repMax = ReputationWatchBar.StatusBar:GetMinMaxValues()
        local repValue = ReputationWatchBar.StatusBar:GetValue()
        local repText = string.format("%s %i / %i", watchedFactionName or "None", repValue, repMax)
        self.ReputationBar:SetStatusBarTexture(AB.config.statusbars.reputation)
        self.ReputationBar:SetStatusBarColor(unpack({ReputationWatchBar.StatusBar:GetStatusBarColor()}))
        self.ReputationBar:SetMinMaxValues(repMin, repMax)
        self.ReputationBar:SetValue(repValue)
        self.ReputationBar:SetShown(showRep)
        self.ReputationBar.OverlayFrame.Text:SetText(repText)
        self.ReputationBar.OverlayFrame.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")

        self.ReputationBar:SetHeight(showXP and 9 or 11)
        self.ReputationBar:SetPoint("BOTTOMLEFT", 0, showXP and -8 or -13)
        self.ReputationBar:SetPoint("BOTTOMRIGHT", 0, showXP and -8 or -13)
    end

    local numBars = self:GetNumberOfVisibleTrackingBars()
    local isDouble = numBars >= 2

    if numBars >= 2 then
        self:SetPoint("BOTTOM", 0, 19)
        self.LeftEndCap:SetPoint("BOTTOMLEFT", -97, -19)
        self.RightEndCap:SetPoint("BOTTOMRIGHT", 97, -19)
    elseif numBars == 1 then
        self:SetPoint("BOTTOM", 0, 14)
        self.LeftEndCap:SetPoint("BOTTOMLEFT", -97, -14)
        self.RightEndCap:SetPoint("BOTTOMRIGHT", 97, -14)
    else
        self:SetPoint("BOTTOM", 0, 0)
        self.LeftEndCap:SetPoint("BOTTOMLEFT", -97, 0)
        self.RightEndCap:SetPoint("BOTTOMRIGHT", 97, 0)
    end

    self.SingleBarLarge:SetHeight(isDouble and 10 or 14)
    self.SingleBarLarge:SetShown(numBars > 0 and isLarge)
    self.SingleBarLargeUpper:SetHeight(isDouble and 10 or 14)
    self.SingleBarLargeUpper:SetShown(numBars > 0 and isDouble and isLarge)
    self.SingleBarSmall:SetShown(numBars > 0 and not isLarge)
    self.SingleBarSmall:SetHeight(isDouble and 10 or 14)
    self.SingleBarSmallUpper:SetShown(numBars > 0 and isDouble and not isLarge)
    self.SingleBarSmallUpper:SetHeight(isDouble and 10 or 14)
end

function MainMenuBarArtFrameMixin:ExperienceBar_OnEnter() self.OverlayFrame.Text:Show() end

function MainMenuBarArtFrameMixin:ExperienceBar_OnLeave() self.OverlayFrame.Text:Hide() end

function MainMenuBarArtFrameMixin:ReputationBar_OnEnter() self.OverlayFrame.Text:Show() end

function MainMenuBarArtFrameMixin:ReputationBar_OnLeave() self.OverlayFrame.Text:Hide() end
