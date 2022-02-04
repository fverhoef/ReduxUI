local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateEnergyManaRegen()
    if not self.config.power.energyManaRegen then
        return
    end

    self.EnergyManaRegen = CreateFrame("StatusBar", nil, self.Power)
    self.EnergyManaRegen:SetFrameLevel(self.Power:GetFrameLevel() + 3)
    self.EnergyManaRegen:SetAllPoints()
    self.EnergyManaRegen.Spark = self.EnergyManaRegen:CreateTexture(nil, "OVERLAY")

    return self.EnergyManaRegen
end

oUF:RegisterMetaFunction("CreateEnergyManaRegen", UF.CreateEnergyManaRegen)

function UF:ConfigureEnergyManaRegen()
    local config = self.config.portrait
    if not config.energyManaRegen then
        self:DisableElement("EnergyManaRegen")
        return
    elseif not self.EnergyManaRegen then
        self:CreateEnergyManaRegen()
    end
    
    self:EnableElement("EnergyManaRegen")
end

oUF:RegisterMetaFunction("ConfigureEnergyManaRegen", UF.ConfigureEnergyManaRegen)