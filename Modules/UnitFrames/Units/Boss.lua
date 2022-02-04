local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnBossHeader()
    return UF:SpawnUnitFrameGroup("Boss", "boss", MAX_BOSS_FRAMES, UF.config.boss, UF.defaults.boss, UF.CreateBoss)
end

function UF:CreateBoss()
    self.config = UF.config.boss
    self.defaults = UF.defaults.boss
    self.isGroupUnit = true

    self:InitializeFrame()

    self.Update = UF.UpdateBoss
end

function UF:UpdateBoss()
    if not self then return end

    self:ConfigureFrame()
end
