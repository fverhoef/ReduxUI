local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnTargetTarget()
    local config = UF.config.targettarget
    local default = UF.defaults.targettarget

    if config.enabled then
        return UF:SpawnFrame("TargetTarget", "targettarget", UF.CreateTargetTarget, config, default)
    end
end

function UF:CreateTargetTarget()
    self.config = UF.config.targettarget
    self.defaults = UF.defaults.targettarget

    UF:SetupFrame(self)

    self.Texture = self:CreateTexture("$parentFrameTexture", "BORDER")

    self:CreateRange()

    self.Update = UF.UpdateTargetTarget
end

function UF:UpdateTargetTarget()
    if not self then
        return
    end

    UF:UpdateFrame(self)

    if UF:IsBlizzardTheme() then
        self.Border:Hide()
        self.Shadow:Hide()

        self:EnableElement("Power")
        self:EnableElement("Portrait")

        self:SetSize(95, 45)

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
        self.Power.Border:Hide()
        self.Power.Shadow:Hide()

        self.Name:ClearAllPoints()
        self.Name:SetWidth(110)
        self.Name:SetPoint("TOPLEFT", self.Texture, "BOTTOMLEFT", 16, 10)
        self.Name:SetJustifyH("LEFT")
        self.Name:Show()

        self.Level:Hide()

        self.Portrait:SetSize(35, 35)
        self.Portrait:ClearAllPoints()
        self.Portrait:SetPoint("TOPLEFT", self.Texture, 5, -5)
		self.Portrait:SetTexCoord(0, 1, 0, 1)
    end
end
