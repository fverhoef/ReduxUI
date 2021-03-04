local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreatePortrait()
    self.Portrait = self:CreateTexture("$parentPortrait", "BACKGROUND")
    self.Portrait.PostUpdate = function()
        self.Portrait:SetDesaturated(not UnitIsConnected(self.unit))
        self:UpdatePortrait()
    end

    self.PortraitHolder = CreateFrame("Frame", "$parentPortraitHolder", self)
    self.PortraitHolder:SetAllPoints(self.Portrait)
    self.PortraitHolder:CreateBorder()

    return self.Portrait
end

oUF:RegisterMetaFunction("CreatePortrait", UF.CreatePortrait)

function UF:UpdatePortrait()
    if not self.Portrait then
        return
    end

    local config = self.config.portrait
    if config.enabled then
        self:EnableElement("Portrait")

        self.Portrait:SetSize(unpack(config.size))

        local xOffset = self.config.border.enabled and self.config.border.size / 2 or 0
        local yOffset = self.config.border.enabled and self.config.border.size / 2 or 0

        self.Portrait:ClearAllPoints()
        if config.detached then
            self.Portrait:SetParent(self)
            self.Portrait:Point(unpack(config.point))
        elseif config.attachedPoint == "LEFT" then
            self.Portrait:SetPoint("TOPLEFT", self, "TOPLEFT", xOffset, -yOffset)
            self.Portrait:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", xOffset, yOffset)
        elseif config.attachedPoint == "RIGHT" then
            self.Portrait:SetPoint("TOPRIGHT", self, "TOPRIGHT", -xOffset, -yOffset)
            self.Portrait:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -xOffset, yOffset)
        end

        if config.class and UnitIsPlayer(self.unit) then
            local coords = _G.CLASS_ICON_TCOORDS[select(2, UnitClass(self.unit))]
            if coords then
                self.Portrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
                local l, r, t, b = unpack(coords)
                if not config.round then
                    local width = r - l
                    local height = b - t

                    l = l + 0.15 * width
                    r = r - 0.15 * width
                    t = t + 0.15 * height
                    b = b - 0.15 * height
                end
                self.Portrait:SetTexCoord(l, r, t, b)
            end
        elseif config.round then
            SetPortraitTexture(self.Portrait, self.unit)
            self.Portrait:SetTexCoord(0, 1, 0, 1)
        else
            SetPortraitTexture(self.Portrait, self.unit)
            self.Portrait:SetTexCoord(0.15, 0.85, 0.15, 0.85)
        end

        self.PortraitHolder.Border:SetShown(config.detached and config.border.enabled)
        self.PortraitHolder:SetBorderSize(config.border.size)
    else
        self:DisableElement("Portrait")
        self.PortraitHolder.Border:Hide()
    end
end

oUF:RegisterMetaFunction("UpdatePortrait", UF.UpdatePortrait)
