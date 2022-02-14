local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateClassPower()
    if not self.config.classPower.enabled then return end

    self.ClassPowerHolder = CreateFrame("Frame", "$parentClassPowerHolder", self)
    self.ClassPowerHolder:SetFrameLevel(self.Power:GetFrameLevel())
    self.ClassPowerHolder:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 10, 15)
    self.ClassPowerHolder:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -10, 15)

    self.ClassPower = {}
    for i = 1, 10 do
        local classPower = CreateFrame("StatusBar", nil, self.ClassPowerHolder, BackdropTemplateMixin and "BackdropTemplate")
        classPower:SetStatusBarTexture(UF.config.statusbars.classPower)
        classPower:SetFrameLevel(self.Power:GetFrameLevel())
        classPower:SetBackdrop({bgFile = R.Libs.SharedMedia:Fetch("background", "Solid")})
        classPower:SetBackdropColor(0, 0, 0, 0.70)

        R:CreateBorder(classPower, nil, 8, 2, classPower:GetFrameLevel() + 2)
        R:CreateInlay(classPower)

        self.ClassPower[i] = classPower
    end
    self.ClassPower.PostUpdate = UF.ClassPower_PostUpdate
    self.ClassPower.unitFrame = self

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

    local max = self.ClassPower.max or #(self.ClassPower)
    local holderWidth = self.ClassPowerHolder:GetWidth()
    local classPowerWidth = (holderWidth - (math.max(0, max - 1)) * config.spacing) / max

    for i = 1, max do
        local classPower = self.ClassPower[i]
        classPower:SetSize(classPowerWidth, config.size[2])
        classPower:SetStatusBarTexture(UF.config.statusbars.classPower)
        if i == 1 then
            classPower:SetPoint("BOTTOMLEFT", self.ClassPowerHolder, "BOTTOMLEFT")
        else
            classPower:SetPoint("LEFT", self.ClassPower[i - 1], "RIGHT", config.spacing, 0)
        end

        if config.smooth then
            R.Libs.SmoothStatusBar:SmoothBar(classPower)
        else
            R.Libs.SmoothStatusBar:ResetBar(classPower)
        end
    end
end

oUF:RegisterMetaFunction("ConfigureClassPower", UF.ConfigureClassPower)

function UF:ClassPower_PostUpdate(cur, max, hasMaxChanged, powerType)
    self.max = max
    if hasMaxChanged then
        self.unitFrame:ConfigureClassPower()
    end
end
