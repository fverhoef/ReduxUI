local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreatePvPIndicator = function(self)
    self.PvPIndicatorParent = CreateFrame("Frame", nil, self)
    self.PvPIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.PvPIndicator = self.PvPIndicatorParent:CreateTexture("$parentPvPIcon", "OVERLAY", nil, 7)
    self.PvPIndicator:SetSize(40, 42)

    return self.PvPIndicator
end

oUF:RegisterMetaFunction("CreatePvPIndicator", UF.CreatePvPIndicator)

UF.UpdatePvPIndicator = function(self)
    if not self.PvPIndicator then
        return
    end

    local cfg = self.cfg.pvpIndicator
    if cfg.enabled then
        self:EnableElement("UpdatePvPIndicator")
    else
        self:DisableElement("UpdatePvPIndicator")
    end
end

oUF:RegisterMetaFunction("UpdatePvPIndicator", UF.UpdatePvPIndicator)