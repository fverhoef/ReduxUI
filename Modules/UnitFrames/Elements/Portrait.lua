local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreatePortrait()
    if not self.config.portrait.enabled then return end

    self.PortraitHolder = CreateFrame("Frame", "$parentPortraitHolder", self)
    self.PortraitHolder:SetFrameLevel(self:GetFrameLevel())

    self.Portrait2D = self:CreateTexture("$parentPortrait2D", "BACKGROUND")
    self.Portrait2D.PostUpdate = function() self:UpdatePortraitTexture() end
    self.Portrait2D:SetAllPoints(self.PortraitHolder)

    self.Portrait3D = CreateFrame("PlayerModel", "$parentPortrait3D", self)
    self.Portrait3D:SetAllPoints(self.PortraitHolder)

    self.Portrait = self.Portrait2D
end

oUF:RegisterMetaFunction("CreatePortrait", UF.CreatePortrait)

function UF:ConfigurePortrait()
    local config = self.config.portrait
    if not config.enabled then
        if self.PortraitHolder then self.PortraitHolder:Hide() end
        self:DisableElement("Portrait")
        return
    elseif not self.Portrait then
        self:CreatePortrait()
    end

    if config.class then
        config.model = false
    elseif config.model then
        config.class = false
    end

    if config.model and self.Portrait == self.Portrait2D then
        self:DisableElement("Portrait")
        self.Portrait = self.Portrait3D
    elseif not config.model and self.Portrait == self.Portrait3D then
        self:DisableElement("Portrait")
        self.Portrait = self.Portrait2D
    end
    self:EnableElement("Portrait")

    self.PortraitHolder:Show()
    self.PortraitHolder:SetSize(unpack(config.size))
    self.PortraitHolder:ClearAllPoints()
    if config.point == "LEFT" then
        self.PortraitHolder:SetNormalizedPoint("TOPLEFT")
        self.PortraitHolder:SetNormalizedPoint("BOTTOMLEFT")
        self.PortraitHolder:CreateSeparator(nil, nil, nil, nil, "RIGHT")
    else
        self.PortraitHolder:SetNormalizedPoint("TOPRIGHT")
        self.PortraitHolder:SetNormalizedPoint("BOTTOMRIGHT")
        self.PortraitHolder:CreateSeparator(nil, nil, nil, nil, "LEFT")
    end
    
    self.PortraitHolder.Separator:SetShown(config.showSeparator)

    self:UpdatePortraitTexture()
end

oUF:RegisterMetaFunction("ConfigurePortrait", UF.ConfigurePortrait)

function UF:UpdatePortraitTexture()
    if not self.Portrait then return end

    local config = self.config.portrait
    if not config.enabled or config.model then return end

    self.Portrait:SetDesaturated(not UnitIsConnected(self.unit))

    if config.class and UnitIsPlayer(self.unit) then
        local coords = _G.CLASS_ICON_TCOORDS[select(2, UnitClass(self.unit))]
        if coords then
            self.Portrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
            local l, r, t, b = unpack(coords)
            local width = r - l
            local height = b - t

            l = l + 0.15 * width
            r = r - 0.15 * width
            t = t + 0.15 * height
            b = b - 0.15 * height
            self.Portrait:SetTexCoord(l, r, t, b)
        end
    else
        SetPortraitTexture(self.Portrait, self.unit)
        self.Portrait:SetTexCoord(0.15, 0.85, 0.15, 0.85)
    end
end

oUF:RegisterMetaFunction("UpdatePortraitTexture", UF.UpdatePortraitTexture)
