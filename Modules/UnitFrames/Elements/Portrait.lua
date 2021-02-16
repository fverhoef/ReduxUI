local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

UF.CreatePortrait = function(self)
    self.Portrait = self.Health:CreateTexture("$parentPortrait", "BACKGROUND")
    self.Portrait.PostUpdate = function()
        self.Portrait:SetDesaturated(not UnitIsConnected(self.unit))
    end

    self.PortraitHolder = CreateFrame("Frame", "$parentPortraitHolder", self)
    self.PortraitHolder:SetAllPoints(self.Portrait)
    self.PortraitHolder:CreateBorder()

    return self.Portrait
end

oUF:RegisterMetaFunction("CreatePortrait", UF.CreatePortrait)

UF.UpdatePortrait = function(self)
    if not self.Portrait then
        return
    end

    local config = self.config.portrait
    if config.enabled then
        self:EnableElement("Portrait")

        self.Portrait:SetSize(unpack(config.size))

        local xOffset = self.config.border.enabled and 2 or 0
        self.Portrait:ClearAllPoints()
        if config.detached then
            self.Portrait:SetPoint(unpack(config.point))
        elseif config.attachedPoint == "LEFT" then
            self.Portrait:SetPoint("TOPLEFT", self, "TOPLEFT", xOffset, 0)
            self.Portrait:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", xOffset, 0)
        elseif config.attachedPoint == "RIGHT" then
            self.Portrait:SetPoint("TOPRIGHT", self, "TOPRIGHT", -xOffset, 0)
            self.Portrait:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -xOffset, 0)
        end

        self.Portrait:SetTexCoord(0.15, 0.85, 0.15, 0.85)

        self.PortraitHolder.Border:SetShown(config.detached and config.border.enabled)
        self.PortraitHolder:SetBorderSize(config.border.size)
    else
        self:DisableElement("Portrait")
        self.PortraitHolder.Border:Hide()
    end
end

oUF:RegisterMetaFunction("UpdatePortrait", UF.UpdatePortrait)
