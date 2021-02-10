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
    self.cfg = UF.config.focustarget

    self:CreateBorder(self.cfg.border.size)
    self:CreateShadow()

    self.Update = function(self)
        UF:UpdateFocusTarget(self)
    end
end

function UF:UpdateFocusTarget(self)
    if not self then
        return
    end

    UF:UpdateFrame(self)

    if UF:IsBlizzardTheme() then
    end
end
