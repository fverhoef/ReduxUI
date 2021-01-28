local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnFocus()
    local config = R.config.db.profile.modules.unitFrames.focus
    local default = R.config.defaults.profile.modules.unitFrames.focus
    
    if R.isRetail and config.enabled then
        return UF:SpawnFrame("Focus", "focus", UF.CreateFocus, config, default)
    end
end

function UF:CreateFocus()
    self.cfg = R.config.db.profile.modules.unitFrames.focus
end

function UF:UpdateFocus()
    local self = UF.frames.focus
    if self then
        UF:UpdateFrame(self)

        if UF:IsBlizzardTheme() then
        else
        end
    end
end
