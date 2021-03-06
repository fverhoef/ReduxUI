local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnNamePlates()
    local config = UF.config.nameplates
    if config.enabled then
        oUF:RegisterStyle(addonName .. "Nameplate", UF.CreateNamePlate)
        oUF:SetActiveStyle(addonName .. "Nameplate")
        oUF:SpawnNamePlates(addonName, UF.NamePlate_Callback, config.cvars)
    end
end

function UF:UpdateNamePlates()
    for i, nameplate in ipairs(UF.nameplates) do
        UF:UpdateNamePlate(nameplate)
    end
end

function UF:CreateNamePlate()
    self.config = UF.config.nameplates
    self.defaults = UF.defaults.nameplates
    
    UF:SetupFrame(self)
    self:SetPoint("CENTER")

    if self.config.showComboPoints then
        self:CreateComboFrame()
    end

    table.insert(UF.nameplates, self)

    self.Update = function(self)
        UF:UpdateNamePlate(self)
    end
end

function UF:UpdateNamePlate(self)
    if not self then
        return
    end

    UF:UpdateFrame(self)
    self:SetScale((self.config.scale or 1) * UIParent:GetScale())
end

UF.NamePlate_Callback = function(self, event, unit)
    if self then
        if self.TargetIndicator then
            self.TargetIndicator:ForceUpdate()
        end
        if self.ThreatIndicator then
            self.ThreatIndicator:ForceUpdate()
        end
    end
end

UF.NamePlate_DebuffFilter = function(...)
    -- icons, unit, icon, name, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll
    local _, _, _, _, _, _, _, _, _, caster, _, _, _, _, _, _, nameplateShowAll = ...
    return nameplateShowAll or (caster == "player" or caster == "pet" or caster == "vehicle")
end
