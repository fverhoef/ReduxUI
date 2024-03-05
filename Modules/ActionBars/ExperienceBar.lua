local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreateExperienceBar()
    return CreateFrame("StatusBar", addonName .. "_ExperienceBar", UIParent, "ExperienceBarTemplate")
end

AB.ExperienceBarMixin = {}
ReduxExperienceBarMixin = AB.ExperienceBarMixin

function AB.ExperienceBarMixin:OnLoad()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PLAYER_LEVEL_UP")
    self:RegisterEvent("PLAYER_UPDATE_RESTING")
    self:RegisterEvent("PLAYER_XP_UPDATE")
    self:RegisterEvent("UPDATE_EXHAUSTION")

    self.config = AB.config.experienceBar
    self.defaults = AB.defaults.experienceBar

    self:CreateBackdrop({ bgFile = R.media.textures.blank })
    self:CreateBorder(nil, 8, 2)
    self:CreateShadow(nil, 10, 4)
    self:CreateFader(self.config.fader)
    self:CreateMover(L["Experience Bar"], self.defaults.point)

    self:Update()
end

function AB.ExperienceBarMixin:OnEvent(event, ...)
    self:Update()
end

function AB.ExperienceBarMixin:OnEnter()
    self.OverlayFrame.Text:Show()
end

function AB.ExperienceBarMixin:OnLeave()
    self.OverlayFrame.Text:Hide()
end

function AB.ExperienceBarMixin:Update()
    if not self.config.enabled then
        self:Hide()
        return
    end

    if not AB.config.actionBar1.vanillaArt.enabled then
        self:ClearAllPoints()
        self:SetNormalizedPoint(self.config.point)
        self:SetNormalizedSize(self.config.size)
        self.Backdrop:SetShown(self.config.backdrop)
        self.Border:SetShown(self.config.border)
        self.Shadow:SetShown(self.config.shadow)
        self.Mover:Unlock()
        self:CreateFader(self.config.fader)
    end

    local showXP = UnitLevel("player") < GetMaxPlayerLevel() and not IsXPUserDisabled()
    if showXP then
        local isCapped = false
        if GameLimitedMode_IsActive() then
            local rLevel = GetRestrictedAccountData()
            if UnitLevel("player") >= rLevel then
                isCapped = true
                MainMenuExpBar:SetMinMaxValues(0, 1)
                MainMenuExpBar:SetValue(1)
                MainMenuExpBar:SetStatusBarColor(0.58, 0.0, 0.55, 1.0)

                local trialXP = UnitTrialXP("player")
                local bankedLevels = UnitTrialBankedLevels("player")
                if trialXP > 0 then
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    local text = TRIAL_CAP_BANKED_XP_TOOLTIP
                    if bankedLevels > 0 then
                        text = TRIAL_CAP_BANKED_LEVELS_TOOLTIP:format(bankedLevels)
                    end
                    self.OverlayFrame.Text:SetText(text, nil, nil, nil, nil, true)
                else
                    self.OverlayFrame.Text:SetText(XP .. " " .. RED_FONT_COLOR_CODE .. CAP_REACHED_TRIAL .. "|r")
                end

                self.OverlayFrame.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
            end
        end

        if not isCapped then
            local expMax = UnitXPMax("player")
            local expValue = UnitXP("player")
            local exhaustionThreshold = GetXPExhaustion()
            local expText = string.format("%s: %i / %i", XP, expValue, expMax)
            if exhaustionThreshold and exhaustionThreshold > 0 then
                expText = string.format("%s (%i rested)", expText, exhaustionThreshold)
            end
            local restState = GetRestState()
            self:SetStatusBarTexture(restState == 1 and R.media.textures.statusBars.experienceRested or R.media.textures.statusBars.experienceNormal)
            self:SetMinMaxValues(math.min(0, expValue), expMax)
            self:SetValue(expValue)
            self.OverlayFrame.Text:SetText(expText)
            self.OverlayFrame.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
        end
    end
    self:SetShown(showXP)

    self:UpdateRested()
end

function AB.ExperienceBarMixin:UpdateRested()
    if self:IsShown() then
        local exhaustionThreshold = GetXPExhaustion()

        if not exhaustionThreshold or exhaustionThreshold <= 0 then
            self.RestedTick:Hide()
            self.RestedFillBar:Hide()
        else
            local exhaustionTickSet = math.max(((UnitXP("player") + exhaustionThreshold) / UnitXPMax("player")) * self:GetWidth(), 0)
            if exhaustionTickSet > self:GetWidth() then
                self.RestedTick:Hide()
                self.RestedFillBar:Hide()
            else
                self.RestedTick:Show()
                self.RestedTick:SetPoint("CENTER", self, "LEFT", exhaustionTickSet, 0)
                self.RestedFillBar:Show()
                self.RestedFillBar:SetPoint("TOPRIGHT", self, "TOPLEFT", exhaustionTickSet, 0)
            end
        end
    end
end
