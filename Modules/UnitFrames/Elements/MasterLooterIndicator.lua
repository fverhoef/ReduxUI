local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateMasterLooterIndicator = function(self)
    self.MasterLooterIndicator = self:CreateTexture(nil, "OVERLAY")
    self.MasterLooterIndicator:SetParent(self.Overlay)
    self.MasterLooterIndicator:SetSize(14, 14)

    return self.MasterLooterIndicator
end

oUF:RegisterMetaFunction("CreateMasterLooterIndicator", UF.CreateMasterLooterIndicator)

UF.UpdateMasterLooterIndicator = function(self)
    if not self.MasterLooterIndicator then
        return
    end

    local config = self.config.masterLooterIndicator
    if config.enabled then
        self:EnableElement("MasterLooterIndicator")

        self.MasterLooterIndicator:SetSize(unpack(config.size))
        self.MasterLooterIndicator:ClearAllPoints()
        self.MasterLooterIndicator:SetPoint(unpack(config.point))
    else
        self:DisableElement("MasterLooterIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateMasterLooterIndicator", UF.UpdateMasterLooterIndicator)