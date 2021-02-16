local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreatePvPClassificationIndicator = function(self)
    self.PvPClassificationIndicator = self:CreateTexture(nil, "OVERLAY")
    self.PvPClassificationIndicator:SetParent(self.Overlay)
    self.PvPClassificationIndicator:SetSize(24, 24)

    return self.PvPClassificationIndicator
end

oUF:RegisterMetaFunction("CreatePvPClassificationIndicator", UF.CreatePvPClassificationIndicator)

UF.UpdatePvPClassificationIndicator = function(self)
    if not self.PvPClassificationIndicator then
        return
    end

    local config = self.config.pvpIndicator
    if config.enabled then
        self:EnableElement("PvPClassificationIndicator")

        self.PvPClassificationIndicator:SetSize(unpack(config.size))
        self.PvPClassificationIndicator:ClearAllPoints()
        self.PvPClassificationIndicator:Point(unpack(config.point))
    else
        self:DisableElement("PvPClassificationIndicator")
    end
end

oUF:RegisterMetaFunction("UpdatePvPClassificationIndicator", UF.UpdatePvPClassificationIndicator)
