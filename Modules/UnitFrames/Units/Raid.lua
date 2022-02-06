local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnRaidHeader()
    local config = UF.config.raid
    if not config.enabled then return end

    CompactRaidFrameManager_SetSetting("IsShown", "0")
    _G.UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")
    _G.CompactRaidFrameManager:UnregisterAllEvents()
    _G.CompactRaidFrameManager:SetParent(R.HiddenFrame)

    return UF:SpawnHeader("Raid", NUM_RAID_GROUPS, config, UF.defaults.raid, UF.CreateRaid)
end

function UF:CreateRaid()
    self.config = UF.config.raid
    self.defaults = UF.defaults.raid
    self.isGroupUnit = true

    self:InitializeFrame()

    self.Update = UF.UpdateRaid
end

function UF:UpdateRaid()
    if not self then return end

    self:ConfigureFrame()
end