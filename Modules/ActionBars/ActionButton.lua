local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreateActionButton(name, parent, actionFunc, icon, tooltip)
    local button = CreateFrame("CheckButton", "$parent_Button", parent, "ActionButtonTemplate")
    button.config = parent.config
    button.tooltip = tooltip
    button:SetFrameStrata("MEDIUM")
    _G.Mixin(button, AB.ActionButtonMixin)
    button:EnableMouse(true)
    button:SetScript("OnClick", actionFunc)
    button:SetScript("PostClick", button.PostClick)
    button:SetScript("OnEnter", button.OnEnter)
    button:SetScript("OnLeave", button.OnLeave)
    button.icon:SetTexture(icon)

    button:Configure()
    R.Modules.ButtonStyles:StyleActionButton(button)

    return button
end

AB.ActionButtonMixin = {}

function AB.ActionButtonMixin:Configure()
    self:RegisterForClicks(self.config.clickOnDown and "AnyDown" or "AnyUp")
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
