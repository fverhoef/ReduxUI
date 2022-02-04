local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnArenaHeader()
    return UF:SpawnUnitFrameGroup("Arena", "arena", 5, UF.config.arena, UF.defaults.arena, UF.CreateArena)
end

function UF:CreateArena()
    self.config = UF.config.arena
    self.defaults = UF.defaults.arena
    self.isGroupUnit = true

    self:InitializeFrame()

    self.Update = UF.UpdateArena
end

function UF:UpdateArena()
    if not self then return end

    self:ConfigureFrame()
end
