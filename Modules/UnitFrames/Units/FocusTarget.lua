local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnFocusTarget()
    local config = R.config.db.profile.modules.unitFrames.focustarget
    local default = R.config.defaults.profile.modules.unitFrames.focustarget

    if R.isRetail and config.enabled then
        return UF:SpawnFrame("FocusTarget", "focustarget", UF.CreateFocusTarget, config, default)
    end
end

function UF:CreateFocusTarget()
    self.cfg = R.config.db.profile.modules.unitFrames.focustarget

    local focus = UF.frames.focus

    self:SetSize(unpack(self.cfg.size))
    self:SetPoint("TOPRIGHT", focus, "BOTTOMRIGHT", 15, 0)
    self:SetFrameStrata("LOW")

    self:RegisterForClicks("AnyUp")

    self:CreateBorder(self.cfg.border.size)
    self:SetBorderPadding(1, 1, 0, 0)
    self:CreateShadow()
    self:SetShadowPadding(1, 1, 0, 0)

    -- texture
    self.Texture = self:CreateTexture("$parentFrameTexture", "BORDER")
    self.Texture:SetTexture(R.media.textures.unitFrames.targetTargetFrame)
    self.Texture:SetTexCoord(0.015625, 0.7265625, 0, 0.703125)
    self.Texture:SetAllPoints(self)

    -- health
    self:CreateHealth()
    self.Health:SetSize(46, 7)
    self.Health:SetPoint("TOPRIGHT", self.Texture, -2, -15)
    self.Health.Value:Hide()

    -- power
    self:CreatePower()
    self.Power:SetHeight(self.Health:GetHeight())
    self.Power.Value:Hide()

    -- name
    self:CreateName(11)
    self.Name:SetWidth(110)
    self.Name:SetPoint("TOPLEFT", self.Texture, "BOTTOMLEFT", 16, 10)

    -- portrait
    self:CreatePortrait()
    self.Portrait:SetSize(35, 35)
    self.Portrait:SetPoint("TOPLEFT", self.Texture, 5, -5)
end

function UF:UpdateFocusTarget(self)
    if not self then
        return
    end

    UF:UpdateFrame(self)

    if UF:IsBlizzardTheme() then
    end
end
