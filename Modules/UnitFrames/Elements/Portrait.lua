local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreatePortrait = function(self)
    self.Portrait = self.Health:CreateTexture("$parentPortrait", "BACKGROUND")
    self.Portrait.PostUpdate = function()
        self.Portrait:SetDesaturated(not UnitIsConnected(self.unit))
    end

    return self.Portrait
end

oUF:RegisterMetaFunction("CreatePortrait", UF.CreatePortrait)

UF.UpdatePortrait = function(self)
    if not self.Portrait then
        return
    end

    local cfg = self.cfg.portrait
    if cfg.enabled then
        self:EnableElement("Portrait")

        self.Portrait:SetSize(unpack(cfg.size))

        local xOffset = self.cfg.border.enabled and 2 or 0
        self.Portrait:ClearAllPoints()
        self.Portrait:SetPoint("TOPLEFT", self, "TOPLEFT", xOffset, 0)
        self.Portrait:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", xOffset, 0)
		self.Portrait:SetTexCoord(0.15, 0.85, 0.15, 0.85)

        -- TODO: support detached portrait
    else
        self:DisableElement("Portrait")
    end
end

oUF:RegisterMetaFunction("UpdatePortrait", UF.UpdatePortrait)
