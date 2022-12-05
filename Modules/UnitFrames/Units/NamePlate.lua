local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnNamePlates()
    local config = UF.config.nameplates
    if config.enabled then
        oUF:RegisterStyle(addonName .. "Nameplate", function(frame)
            local configKey = (UnitIsFriend("player", frame.unit) and "friendly" or "enemy") .. (UnitIsPlayer(frame.unit) and "Player" or "Npc")
            frame.config = UF.config.nameplates[configKey]
            frame.defaults = UF.defaults.nameplates[configKey]
            frame.isNameplate = true

            _G.Mixin(frame, UF.UnitFrameMixin)
            _G.Mixin(frame, UF.NameplateMixin)

            table.insert(UF.nameplates, frame)

            frame:Initialize()
            frame:SetPoint("CENTER")
        end)
        oUF:SetActiveStyle(addonName .. "Nameplate")
        oUF:SpawnNamePlates(addonName, UF.NameplateMixin.Callback, config.cvars)
    end
end

UF.NameplateMixin = {}

function UF.NameplateMixin:PreConfigure()
    local configKey = (UnitIsFriend("player", self.unit) and "friendly" or "enemy") .. (UnitIsPlayer(self.unit) and "Player" or "Npc")
    self.config = UF.config.nameplates[configKey]
    self.defaults = UF.defaults.nameplates[configKey]
end

function UF.NameplateMixin:PostConfigure()
    self:SetScale((self.config.scale or 1) * UIParent:GetScale())
    self:ClearAllPoints()
    self:SetPoint("CENTER")
end

function UF.NameplateMixin:Callback(event, unit)
    if self then
        if self.TargetIndicator then
            self.TargetIndicator:ForceUpdate()
        end
        if self.ThreatIndicator then
            self.ThreatIndicator:ForceUpdate()
        end
    end
end
