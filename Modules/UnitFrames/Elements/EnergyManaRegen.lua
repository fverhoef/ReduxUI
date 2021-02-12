local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateEnergyManaRegen = function(self)
    self.EnergyManaRegen = CreateFrame("StatusBar", nil, self.Power)
    self.EnergyManaRegen:SetFrameLevel(self.Power:GetFrameLevel() + 3)
    self.EnergyManaRegen:SetAllPoints()
    self.EnergyManaRegen.Spark = self.EnergyManaRegen:CreateTexture(nil, "OVERLAY")

    return self.EnergyManaRegen
end

oUF:RegisterMetaFunction("CreateEnergyManaRegen", UF.CreateEnergyManaRegen)

UF.UpdateEnergyManaRegen = function(self)
    if not self.EnergyManaRegen then
        return
    end

    if self.config.power.energyManaRegen then
        self:EnableElement("EnergyManaRegen")
    else
        self:DisableElement("EnergyManaRegen")
    end
end

oUF:RegisterMetaFunction("UpdateEnergyManaRegen", UF.UpdateEnergyManaRegen)