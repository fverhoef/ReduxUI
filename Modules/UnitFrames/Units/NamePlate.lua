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

function UF:UpdateNamePlates() for i, nameplate in ipairs(UF.nameplates) do UF:UpdateNamePlate(nameplate) end end

function UF:CreateNamePlate()
    local configKey = (UnitIsFriend("player", self.unit) and "friendly" or "enemy") .. (UnitIsPlayer(self.unit) and "Player" or "Npc")
    self.config = UF.config.nameplates[configKey]
    self.defaults = UF.defaults.nameplates[configKey]

    self:InitializeFrame()
    self:SetPoint("CENTER")

    table.insert(UF.nameplates, self)

    self.Update = function(self) UF:UpdateNamePlate(self) end
end

function UF:UpdateNamePlate(self)
    if not self then return end

    local configKey = (UnitIsFriend("player", self.unit) and "friendly" or "enemy") .. (UnitIsPlayer(self.unit) and "Player" or "Npc")
    self.config = UF.config.nameplates[configKey]
    self.defaults = UF.defaults.nameplates[configKey]

    self:ConfigureFrame()
    self:SetScale((self.config.scale or 1) * UIParent:GetScale())
    self:ClearAllPoints()
    self:SetPoint("CENTER")
end

UF.NamePlate_Callback = function(self, event, unit)
    if self then
        if self.TargetIndicator then self.TargetIndicator:ForceUpdate() end
        if self.ThreatIndicator then self.ThreatIndicator:ForceUpdate() end
    end
end

UF.NamePlate_DebuffFilter = function(...)
    -- icons, unit, icon, name, texture, count, dispelType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll
    local _, _, _, _, _, _, _, _, _, caster, _, _, _, _, _, _, nameplateShowAll = ...
    return nameplateShowAll or (caster == "player" or caster == "pet" or caster == "vehicle")
end
