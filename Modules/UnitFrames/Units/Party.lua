local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnPartyHeader()
    local config = UF.config.party
    if not config.enabled then return end

    return UF:SpawnHeader("Party", 1, config, UF.defaults.party, UF.CreateParty)
end

function UF:CreateParty()
    self.config = UF.config.party
    self.defaults = UF.defaults.party
    self.isGroupUnit = true

    self:InitializeFrame()

    self.Update = UF.UpdateParty
end

function UF:UpdateParty()
    if not self then return end

    self:ConfigureFrame()
end
