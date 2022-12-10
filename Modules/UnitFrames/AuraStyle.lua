local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local L = R.L

AuraStyleMixin = {}

function AuraStyleMixin:ApplyStyle()
    local name = self:GetName() or "nil"
    local config = self.config or {}

    local icon = _G[name .. "Icon"] or _G[name .. "IconTexture"] or self.icon or self.Icon
    local count = _G[name .. "Count"] or self.Count
    local cooldown = _G[name .. "Cooldown"] or self.Cooldown
    local cooldownText = cooldown and cooldown:GetRegions()
    local duration = _G[name .. "Duration"]

    if not self.__styled then
        self.__styled = true

        self.raisedContainer = CreateFrame("Frame", nil, self)
        self.raisedContainer:SetAllPoints()
        self.raisedContainer:SetFrameLevel(self:GetFrameLevel() + 1)

        if icon then
            icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
            icon:SetInside(self, 2, 2)
        end

        if count then
            count:SetParent(self.raisedContainer)
        end

        if cooldown then
            cooldown:SetInside(self, 2, 2)
            cooldown:SetSwipeColor(0, 0, 0)
            cooldown.ShowBase = cooldown.Show
            cooldown.HideBase = cooldown.Hide
            cooldown.Show = function()
                cooldown:ShowBase()
                cooldownText:Show()
            end
            cooldown.Hide = function()
                cooldown:HideBase()
                cooldownText:Hide()
            end
        end

        if duration then
            duration:SetParent(self.raisedContainer)
        end

        if symbol then
            symbol:SetParent(self.raisedContainer)
        end

        local border = _G[name .. "Border"] or self.Border
        if border then
            border:Hide()
            self.Border = nil
        end

        local border = self.raisedContainer:CreateTexture("$parentBorder", "OVERLAY", nil, 7)
        border:SetTexture(R.media.textures.buttons.border)
        self.Border = border
    end

    if count then
        count:SetFont(config.countFont, config.countFontSize, config.countFontOutline)
        count:SetShadowOffset(config.countFontShadow and 1 or 0, config.countFontShadow and -1 or 0)
    end

    if duration then
        duration:SetFont(config.durationFont, config.durationFontSize, config.durationFontOutline)
        duration:SetShadowOffset(config.durationFontShadow and 1 or 0, config.durationFontShadow and -1 or 0)
    end

    if cooldownText then
        cooldownText:SetFont(config.durationFont, config.durationFontSize, config.durationFontOutline)
        cooldownText:SetShadowOffset(config.durationFontShadow and 1 or 0, config.durationFontShadow and -1 or 0)
    end

    local r, g, b = 0.7, 0.7, 0.7
    if self.isDebuff then
        local debuffColor = _G.DebuffTypeColor[(self.debuffType or "none")]
        if debuffColor then
            r, g, b = debuffColor.r, debuffColor.g, debuffColor.b
        end
    end
    if self.isTempEnchant then
        local quality = GetInventoryItemQuality("player", self:GetID())
        if quality and quality > 1 then
            r, g, b = GetItemQualityColor(quality)
        end
    end

    local borderInset = (self:GetWidth() or 36) / 12
    self.Border:SetOutside(self, borderInset, borderInset)
    self.Border:SetVertexColor(r, g, b, 1)

    if icon then
        local iconInset = (self:GetWidth() or 36) / 18
        icon:SetInside(self, iconInset, iconInset)
    end

    if cooldown then
        local cdInset = (self:GetWidth() or 36) / 18
        cooldown:SetInside(self, cdInset, cdInset)
        cooldown:SetHideCountdownNumbers(not config.showDuration or self:GetWidth() < (config.minSizeToShowDuration or 0))
    end
end