local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:SpawnTargetTarget()
    local config = UF.config.db.profile.targettarget
    local default = Addon.config.defaults.profile.modules.unitFrames.targettarget

    if config.enabled then
        return UF:SpawnFrame("TargetTarget", "targettarget", UF.CreateTargetTarget, config, default)
    end
end

function UF:CreateTargetTarget()
    -- config
    self.cfg = UF.config.db.profile.targettarget

    local target = UF.frames.target

    self:SetSize(unpack(self.cfg.size))
    self:SetPoint(unpack(self.cfg.point))
    self:SetFrameStrata("LOW")
    self:SetFrameLevel(20)

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    -- texture
    self.Texture = self:CreateTexture("$parentFrameTexture", "BORDER")
    self.Texture:SetTexture(Addon.media.textures.TargetTargetFrame)
    self.Texture:SetTexCoord(0.015625, 0.7265625, 0, 0.703125)
    self.Texture:SetAllPoints(self)

    if self.Texture then
        self.Texture:SetVertexColor(unpack(self.cfg.textureColor))
    end

    -- health
    UF.CreateHealth(self)
    self.Health:SetSize(46, 7)
    self.Health:SetPoint("TOPRIGHT", self.Texture, -2, -15)
    self.Health.Value:Hide()

    -- power
    UF.CreatePower(self)
    self.Power:SetHeight(self.Health:GetHeight())
    self.Power.Value:Hide()

    -- name
    UF.CreateName(self, 11)
    self.Name:SetWidth(110)
    self.Name:SetPoint("TOPLEFT", self.Texture, "BOTTOMLEFT", 16, 10)

    -- portrait
    UF.CreatePortrait(self)
    self.Portrait:SetSize(35, 35)
    self.Portrait:SetPoint("TOPLEFT", self.Texture, 5, -5)

    -- range check
    self.SpellRange = {
        insideAlpha = 1,
        outsideAlpha = 0.5,
        Update = function(self, inRange)
            if self.fader and not self:IsShown() then
                Addon:StartFadeIn(self, {
                    fadeInAlpha = self.SpellRange[inRange and "insideAlpha" or "outsideAlpha"],
                    fadeInDuration = self.faderConfig.fadeInDuration,
                    fadeInSmooth = self.faderConfig.fadeInSmooth
                })
            else
                self:SetAlpha(self.SpellRange[inRange and "insideAlpha" or "outsideAlpha"])
            end
        end
    }
end

function UF:UpdateTargetTarget()
    local self = UF.frames.targettarget
    if self then
        UF:UpdateFrame(self)

        if UF:IsBlizzardTheme() then
        else
        end
    end
end
