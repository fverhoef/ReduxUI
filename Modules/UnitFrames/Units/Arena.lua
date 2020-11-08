local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

function UF:CreateArenaStyle()
    self.cfg = UF.config.db.profile.arena
end
