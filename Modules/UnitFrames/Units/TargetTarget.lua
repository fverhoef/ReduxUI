local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTargetTarget()
    local config = R.config.db.profile.modules.unitFrames.targettarget
    local default = R.config.defaults.profile.modules.unitFrames.targettarget

    if config.enabled then
        return UF:SpawnFrame("TargetTarget", "targettarget", UF.CreateTargetTarget, config, default)
    end
end

function UF:CreateTargetTarget()
    self.cfg = R.config.db.profile.modules.unitFrames.targettarget

    local target = UF.frames.target

    self:SetSize(unpack(self.cfg.size))
    self:SetPoint(unpack(self.cfg.point))
    self:SetFrameStrata("LOW")
    self:SetFrameLevel(20)

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    self:CreateBorder(self.cfg.border.size)
    self:SetBorderPadding(1, 1, 0, 0)
    self:CreateShadow()
    self:SetShadowPadding(1, 1, 0, 0)

    self.Texture = self:CreateTexture("$parentFrameTexture", "BORDER")

    if self.Texture then
        self.Texture:SetVertexColor(unpack(self.cfg.textureColor))
    end

    self:CreateHealth()
    self:CreatePower()
    self:CreateName(11)
    self:CreatePortrait()
    self:CreateRange()
end

function UF:UpdateTargetTarget(self)
    if not self then
        return
    end

    UF:UpdateFrame(self)

    if UF:IsBlizzardTheme() then
        self.Border:Hide()
        self.Shadow:Hide()

        self.Texture:SetTexture(R.media.textures.unitFrames.targetTargetFrame)
        self.Texture:SetTexCoord(0.015625, 0.7265625, 0, 0.703125)
        self.Texture:ClearAllPoints()
        self.Texture:SetAllPoints(self)

        self.Health:SetSize(46, 7)
        self.Health:ClearAllPoints()
        self.Health:SetPoint("TOPRIGHT", self.Texture, -2, -15)
        self.Health.Value:Hide()

        self.Power:SetHeight(self.Health:GetHeight())
        self.Power:ClearAllPoints()
        self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, 0)
        self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, 0)
        self.Power.Value:Hide()

        self.Name:SetWidth(110)
        self.Name:ClearAllPoints()
        self.Name:SetPoint("TOPLEFT", self.Texture, "BOTTOMLEFT", 16, 10)

        self.Portrait:SetSize(35, 35)
        self.Portrait:ClearAllPoints()
        self.Portrait:SetPoint("TOPLEFT", self.Texture, 5, -5)
    end
end
