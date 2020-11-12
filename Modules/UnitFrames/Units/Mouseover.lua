local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames
local oUF = AddonTable.oUF or oUF

function UF:SpawnMouseOver()
    local config = UF.config.db.profile.mouseover
    if config.enabled then
        return UF:SpawnFrame("Mouseover", "mouseover", UF.CreateMouseover, config)
    end
end

function UF:CreateMouseover()
    self.cfg = UF.config.db.profile.mouseover
end

function UF:UpdateMouseover()
    local self = UF.frames.mouseover
    if self then
    end
end
