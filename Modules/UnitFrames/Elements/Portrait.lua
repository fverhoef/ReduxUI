local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreatePortrait()
    self.PortraitHolder = CreateFrame("Frame", "$parentPortraitHolder", self, "PortraitHolderTemplate")
    self.PortraitHolder:SetFrameLevel(self:GetFrameLevel())

    self.PortraitHolder.Portrait2D.PostUpdate = function()
        self:UpdatePortraitTexture()
    end
    self.PortraitHolder.PortraitRound.PostUpdate = function()
        self:UpdatePortraitTexture()
    end
    self.PortraitHolder.PortraitMasked.PostUpdate = function()
        self:UpdatePortraitTexture()
    end

    self.Portrait = self.PortraitHolder.Portrait2D
end

oUF:RegisterMetaFunction("CreatePortrait", UF.CreatePortrait)

function UF:ConfigurePortrait()
    local config = self.config.portrait
    if not config.enabled and self:IsCustomStyled() then
        if self.PortraitHolder then
            self.PortraitHolder:Hide()
        end
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
    
    if self.config.style ~= UF.Styles.Custom then
        config.detached = false
        config.model = false
    end

    if config.model and self.PortraitHolder.Portrait ~= self.PortraitHolder.Portrait3D then
        self:DisableElement("Portrait")
        self.Portrait = self.PortraitHolder.Portrait3D
    elseif not config.model and self.Portrait ~= self.PortraitHolder.Portrait2D then
        self:DisableElement("Portrait")
        self.Portrait = self.PortraitHolder.Portrait2D
    end
    self.PortraitHolder.Portrait2D.showClass = config.class
    self.PortraitHolder.PortraitRound.showClass = config.class
    self.PortraitHolder.PortraitMasked.showClass = config.class
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
    self.PortraitHolder.PortraitMaskedCornerIcon:Hide()

    self:UpdatePortraitTexture()
end

oUF:RegisterMetaFunction("ConfigurePortrait", UF.ConfigurePortrait)

function UF:UpdatePortraitTexture()
    if not self.Portrait then
        return
    end

    local config = self.config.portrait
    if self:IsCustomStyled() and (not config.enabled or config.model) then
        return
    end

    self.Portrait:SetDesaturated(not UnitIsConnected(self.unit))

    local ULx,ULy,LLx,LLy,URx,URy,LRx,LRy = self.Portrait:GetTexCoord()
    local l, r, t, b = ULx, URx, ULy, LLy
    local width = r - l
    local height = b - t

    if self:IsCustomStyled() then
        l = l + 0.15 * width
        r = r - 0.15 * width
        t = t + 0.15 * height
        b = b - 0.15 * height
    elseif self.config.style == UF.Styles.Modern and self.unit == "player" then
        l = l
        r = r - 0.08 * width
        t = t
        b = b - 0.08 * height
    end

    self.Portrait:SetTexCoord(l, r, t, b)
end

oUF:RegisterMetaFunction("UpdatePortraitTexture", UF.UpdatePortraitTexture)
