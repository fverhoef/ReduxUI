local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnMouseOver()
    local config = UF.config.mouseover
    if config.enabled then
        return UF:SpawnFrame("Mouseover", "mouseover", UF.CreateMouseover, config)
    end
end

function UF:CreateMouseover()
    self.config = UF.config.mouseover
    self.defaults = UF.defaults.mouseover

    UF:SetupFrame(self)

    self.Update = UF.UpdateMouseover
end

function UF:UpdateMouseover()
    if not self then
        return
    end

    UF:UpdateFrame(self)
end
