local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateOfflineIcon = function(self)
    self.OfflineIcon = self:CreateTexture("$parentOfflineIcon", "OVERLAY")
    self.OfflineIcon:SetPoint("CENTER", self.Portrait, 0, 0)
    self.OfflineIcon:SetSize(64, 64)

    return self.OfflineIcon
end

oUF:RegisterMetaFunction("CreateOfflineIcon", UF.CreateOfflineIcon)