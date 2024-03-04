local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnBossHeader()
    if UF.config.boss.enabled then
        if EditModeManagerFrame and EditModeManagerFrame.AccountSettings then
            EditModeManagerFrame.AccountSettings.RefreshBossFrames = nop
        end
    end
    return UF:SpawnUnitFrameGroup("Boss", "boss", MAX_BOSS_FRAMES, UF.BossMixin, UF.config.boss, UF.defaults.boss)
end

UF.BossMixin = {}
