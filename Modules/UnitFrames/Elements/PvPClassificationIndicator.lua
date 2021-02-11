local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreatePvPClassificationIndicator = function(self)
    self.PvPClassificationIndicatorParent = CreateFrame("Frame", nil, self)
    self.PvPClassificationIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.PvPClassificationIndicator = self.PvPClassificationIndicatorParent:CreateTexture(nil, "OVERLAY")
    self.PvPClassificationIndicator:SetSize(24, 24)
    self.PvPClassificationIndicator:SetPoint("CENTER")

    return self.PvPClassificationIndicator
end

oUF:RegisterMetaFunction("CreatePvPClassificationIndicator", UF.CreatePvPClassificationIndicator)

UF.UpdatePvPClassificationIndicator = function(self)
    if not self.PvPClassificationIndicator then
        return
    end

    local cfg = self.cfg.pvpIndicator
    if cfg.enabled then
        self:EnableElement("PvPClassificationIndicator")
    else
        self:DisableElement("PvPClassificationIndicator")
    end
end

oUF:RegisterMetaFunction("UpdatePvPClassificationIndicator", UF.UpdatePvPClassificationIndicator)
