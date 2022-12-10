local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreateActionButton(name, parent, actionFunc, icon, tooltip)
    local button = CreateFrame("CheckButton", "$parent_Button", parent, "ActionButtonTemplate")
    button.header = parent
    button.tooltip = tooltip
    button:SetFrameStrata("MEDIUM")
    _G.Mixin(button, AB.ActionButtonMixin)
    button:EnableMouse(true)
    button:SetScript("OnClick", actionFunc)
    button:SetScript("PostClick", button.PostClick)
    button:SetScript("OnEnter", button.OnEnter)
    button:SetScript("OnLeave", button.OnLeave)

    button:Configure()

    if icon then
        button.icon:SetTexture(icon)
    end

    return button
end

AB.ActionButtonMixin = {}

function AB.ActionButtonMixin:Configure()
    self:RegisterForClicks(self.header.config.buttonStyle.clickOnDown and "AnyDown" or "AnyUp")
    self:SetAttribute("buttonlock", true)
    self:SetAttribute("checkselfcast", self.header.config.buttonStyle.checkSelfCast)
    self:SetAttribute("checkfocuscast", self.header.config.buttonStyle.checkFocusCast)
    self:SetAttribute("checkmouseovercast", self.header.config.buttonStyle.checkMouseoverCast)
    self:SetAttribute("showgrid", self.header.config.showGrid and 1 or 0)
    self.HotKey:Hide()
    self.Name:Hide()

    self:ApplyStyle()
end

function AB.ActionButtonMixin:ApplyStyle()
    if not self.__styled then
        self.__styled = true

        self.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        self.icon:SetInside(self, 2, 2)

        self.raisedContainer = CreateFrame("Frame", nil, self)
        self.raisedContainer:SetAllPoints()
        self.raisedContainer:SetFrameLevel(self:GetFrameLevel() + 1)

        self.cooldown:SetInside(self, 2, 2)
        self.cooldown:SetSwipeColor(0, 0, 0)

        self.Count:SetParent(self.raisedContainer)
        self.HotKey:SetParent(self.raisedContainer)
        self.Name:SetParent(self.raisedContainer)

        self:CreateBackdrop({ bgFile = R.media.textures.buttons.backdrop, edgeSize = 2, insets = { left = 2, right = 2, top = 2, bottom = 2 } })
    end

    self:SetNormalTexture(R.media.textures.buttons.border)
    local normalTexture = self:GetNormalTexture()
    normalTexture:SetOutside(self, 4, 4)
    normalTexture:SetTexCoord(0, 1, 0, 1)
    normalTexture:SetVertexColor(0.7, 0.7, 0.7)

    self:SetPushedTexture(R.media.textures.buttons.border)
    local pushedTexture = self:GetPushedTexture()
    pushedTexture:SetOutside(self, 4, 4)
    pushedTexture:SetTexCoord(0, 1, 0, 1)
    pushedTexture:SetVertexColor(1, 0.78, 0, 1)

    self:GetCheckedTexture():SetOutside(self, 2, 2)
    self:GetHighlightTexture():SetInside(self, 0, 0)
end

function AB.ActionButtonMixin:OnEnter()
    if GameTooltip:IsForbidden() then
        return
    end

    if GetCVar("UberTooltips") == "1" then
        GameTooltip_SetDefaultAnchor(GameTooltip, self)
    else
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    end

    GameTooltip:SetText(self.tooltip)
end

function AB.ActionButtonMixin:OnLeave()
    if GameTooltip:IsForbidden() then
        return
    end

    GameTooltip:Hide()
end

function AB.ActionButtonMixin:PostClick()
    self:SetChecked(false)
end
