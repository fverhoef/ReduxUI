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

    self:ClearAllPoints()
    self:SetNormalizedPoint(self.config.point)
    self:SetNormalizedSize(self.config.size)
    self.Backdrop:SetShown(self.config.backdrop)
    self.Border:SetShown(self.config.border)
    self.Shadow:SetShown(self.config.shadow)
    self.Mover:Unlock()
    self:CreateFader(self.config.fader)

    local showXP = UnitLevel("player") < GetMaxPlayerLevel()
    local expMin, expMax = MainMenuExpBar:GetMinMaxValues()
    local expValue = MainMenuExpBar:GetValue()
    local exhaustionThreshold = GetXPExhaustion()
    local expText = string.format("%s: %i / %i", XP, expValue, expMax)
    if exhaustionThreshold and exhaustionThreshold > 0 then
        expText = string.format("%s (%i rested)", expText, GetXPExhaustion())
    end
    self:SetStatusBarTexture(R.media.textures.statusBars.redux)
    self:SetStatusBarColor(unpack({ MainMenuExpBar:GetStatusBarColor() }))
    self:SetMinMaxValues(expMin, expMax)
    self:SetValue(expValue)
    self:SetShown(showXP)
    self.OverlayFrame.Text:SetText(expText)
    self.OverlayFrame.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")

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
