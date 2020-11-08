local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:SpawnFocusTarget()
    local config = UF.config.db.profile.focustarget
    local default = Addon.config.defaults.profile.modules.unitFrames.focustarget

    if UF.IsRetail and config.enabled then
        return UF:SpawnFrame("FocusTarget", "focustarget", UF.CreateFocusTargetStyle, config, default)
    end
end

function UF:CreateFocusTargetStyle()
    self.cfg = UF.config.db.profile.focus

    local focus = UF.frames.focus

    self:SetSize(unpack(self.cfg.size))
    self:SetPoint("TOPRIGHT", focus, "BOTTOMRIGHT", 15, 0)
    self:SetFrameStrata("LOW")

    self:RegisterForClicks("AnyUp")

    -- texture
    self.Texture = self:CreateTexture("$parentFrameTexture", "BORDER")
    self.Texture:SetTexture(Addon.media.textures.TargetTargetFrame)
    self.Texture:SetTexCoord(0.015625, 0.7265625, 0, 0.703125)
    self.Texture:SetAllPoints(self)

    -- health
    UF.CreateHealthBar(self)
    self.Health:SetSize(46, 7)
    self.Health:SetPoint("TOPRIGHT", self.Texture, -2, -15)
    self.Health.Value:Hide()

    -- power
    UF.CreatePowerBar(self)
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
end
