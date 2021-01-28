local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnMouseOver()
    local config = R.config.db.profile.modules.unitFrames.mouseover
    if config.enabled then
        return UF:SpawnFrame("Mouseover", "mouseover", UF.CreateMouseover, config)
    end
end

function UF:CreateMouseover()
    self.cfg = R.config.db.profile.modules.unitFrames.mouseover
end

function UF:UpdateMouseover()
    local self = UF.frames.mouseover
    if self then
    end
end
