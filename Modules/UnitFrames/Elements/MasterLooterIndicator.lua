local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreateMasterLooterIndicator = function(self)
    self.MasterLooterIndicatorParent = CreateFrame("Frame", nil, self)
    self.MasterLooterIndicatorParent:SetFrameLevel(self:GetFrameLevel() + 10)

    self.MasterLooterIndicator = self.MasterLooterIndicatorParent:CreateTexture(nil, "OVERLAY")
    self.MasterLooterIndicator:SetSize(14, 14)

    return self.MasterLooterIndicator
end

oUF:RegisterMetaFunction("CreateMasterLooterIndicator", UF.CreateMasterLooterIndicator)

UF.UpdateMasterLooterIndicator = function(self)
    if not self.MasterLooterIndicator then
        return
    end

    local cfg = self.cfg.masterLooterIndicator
    if cfg.enabled then
        self:EnableElement("MasterLooterIndicator")
    else
        self:DisableElement("MasterLooterIndicator")
    end
end

oUF:RegisterMetaFunction("UpdateMasterLooterIndicator", UF.UpdateMasterLooterIndicator)