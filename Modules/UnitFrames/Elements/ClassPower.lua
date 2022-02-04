local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateClassPower()
    if not self.config.classPower.enabled then
        return
    end
    
    self.ClassPowerHolder = CreateFrame("Frame", "$parentClassPowerHolder", self)
    self.ClassPowerHolder:SetFrameLevel(self.Power:GetFrameLevel())
    self.ClassPowerHolder:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 5)
    self.ClassPowerHolder:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 5)

    -- TODO: have the right amount of bars per class
    -- TODO: use class-specific textures
    local max = 5 -- math.max(MAX_COMBO_POINTS)
    self.ClassPower = {}
    for i = 1, max do
        self.ClassPower[i] = CreateFrame("StatusBar", nil, self.ClassPowerHolder, BackdropTemplateMixin and "BackdropTemplate")
        self.ClassPower[i]:SetSize(16, 16)
        self.ClassPower[i]:SetStatusBarTexture(UF.config.statusbars.classPower)
        self.ClassPower[i]:SetFrameLevel(self.Power:GetFrameLevel())
        self.ClassPower[i]:SetBackdrop({bgFile = R.Libs.SharedMedia:Fetch("background", "Solid")})
        self.ClassPower[i]:SetBackdropColor(0, 0, 0, 0.70)

        self.ClassPower[i]:SetPoint("TOPLEFT", self.ClassPowerHolder, "TOPLEFT", (i - 1) * 16, 0)
    end

    return self.ClassPower
end

oUF:RegisterMetaFunction("CreateClassPower", UF.CreateClassPower)

function UF:ConfigureClassPower()
    local config = self.config.classPower
    if not config.enabled then
        self:DisableElement("ClassPower")
        return
    elseif not self.ClassPower then
        self:CreateClassPower()
    end

    self:EnableElement("ClassPower")

    self.ClassPowerHolder:SetSize(unpack(config.size))

    local xOffset = 0
    local yOffset = 0

    local max = #(self.ClassPower)
    for i = 1, max do
        self.ClassPower[i]:SetSize(16, 16)
        self.ClassPower[i]:SetStatusBarTexture(UF.config.statusbars.classPower)
        self.ClassPower[i]:SetPoint("TOPLEFT", self.ClassPowerHolder, "TOPLEFT", xOffset + (i - 1) * 16, yOffset)

        if config.smooth then
            R.Libs.SmoothStatusBar:SmoothBar(self.ClassPower[i])
        else
            R.Libs.SmoothStatusBar:ResetBar(self.ClassPower[i])
        end
    end
end

oUF:RegisterMetaFunction("ConfigureClassPower", UF.ConfigureClassPower)
