local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnFocusTarget()
    local config = UF.config.focustarget
    if not config.enabled then return end

    return UF:SpawnFrame("FocusTarget", "focustarget", UF.CreateFocusTarget, config, UF.defaults.focustarget)
end

function UF:CreateFocusTarget()
    self.config = UF.config.focustarget
    self.defaults = UF.defaults.focustarget

    self:InitializeFrame()

    self.Update = UF.UpdateFocusTarget
end

function UF:UpdateFocusTarget()
    if not self then return end

    self:ConfigureFrame()
end