local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnRaidHeader()
    if UF.config.raid.enabled then
        _G.UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")

        if _G.CompactRaidFrameContainer then
            _G.CompactRaidFrameContainer:UnregisterAllEvents()
        end

        if CompactRaidFrameManager_SetSetting then
            CompactRaidFrameManager_SetSetting("IsShown", "0")
        end
        if _G.CompactRaidFrameManager then
            _G.CompactRaidFrameManager:UnregisterAllEvents()
            _G.CompactRaidFrameManager:SetParent(R.HiddenFrame)
        end

        if EditModeManagerFrame and EditModeManagerFrame.AccountSettings then
            EditModeManagerFrame.AccountSettings.RefreshRaidFrames = nop
            EditModeManagerFrame.AccountSettings.ResetRaidFrames = nop
        end
    end

    return UF:SpawnHeader("Raid", NUM_RAID_GROUPS, UF.RaidMixin, UF.config.raid, UF.defaults.raid)
end

UF.RaidMixin = {}
