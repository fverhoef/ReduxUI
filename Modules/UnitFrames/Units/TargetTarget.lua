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
    self.cfg = UF.config.targettarget

    local target = UF.frames.target

    self:SetSize(unpack(self.cfg.size))
    self:SetPoint(unpack(self.cfg.point))
    self:SetFrameStrata("LOW")
    self:SetFrameLevel(20)

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    self:CreateBorder(self.cfg.border.size)
    self:CreateShadow()

    self.Texture = self:CreateTexture("$parentFrameTexture", "BORDER")

    if self.Texture then
        self.Texture:SetVertexColor(unpack(self.cfg.textureColor))
    end

    self:CreateHealth()
    self:CreatePower()
    self:CreateName()
    self:CreateLevel()
    self:CreatePortrait()
    self:CreateRange()

    self.Update = function(self)
        UF:UpdateTargetTarget(self)
    end
end

function UF:UpdateTargetTarget(self)
    if not self then
        return
    end

    UF:UpdateFrame(self)

    if UF:IsBlizzardTheme() then
        self.Border:Hide()
        self.Shadow:Hide()

        self:EnableElement("Power")
        self:EnableElement("Portrait")
        self:EnableElement("LeaderIndicator")
        self:EnableElement("AssistantIndicator")
        self:EnableElement("MasterLooterIndicator")

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
        self.Name:SetJustifyH("LEFT")
        self.Name:SetPoint("TOPLEFT", self.Texture, "BOTTOMLEFT", 16, 10)

        self.Level:Hide()

        self.Portrait:SetSize(35, 35)
        self.Portrait:ClearAllPoints()
        self.Portrait:SetPoint("TOPLEFT", self.Texture, 5, -5)
		self.Portrait:SetTexCoord(0, 1, 0, 1)
    end
end
