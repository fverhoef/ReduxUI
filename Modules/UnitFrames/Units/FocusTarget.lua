local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnFocusTarget()
    local config = UF.config.focustarget
    local default = UF.defaults.focustarget

    if R.isRetail and config.enabled then
        return UF:SpawnFrame("FocusTarget", "focustarget", UF.CreateFocusTarget, config, default)
    end
end

function UF:CreateFocusTarget()
    self.config = UF.config.focustarget
    self.defaults = UF.defaults.focustarget

    UF:SetupFrame(self)

    self.Update = UF.UpdateFocusTarget
end

function UF:UpdateFocusTarget()
    if not self then
        return
    end

    UF:UpdateFrame(self)
end
