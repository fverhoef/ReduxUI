local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreateActionButton(name, parent, actionFunc, icon, tooltip)
    local button = CreateFrame("CheckButton", "$parent_Button", parent, "ActionButtonTemplate")
    button.config = parent.config
    button.tooltip = tooltip
    button:SetFrameStrata("MEDIUM")
    _G.Mixin(button, ActionButtonMixin)
    button:EnableMouse(true)
    button:SetScript("OnClick", actionFunc)
    button:SetScript("PostClick", ActionButtonMixin.PostClick)
    button:SetScript("OnEnter", ActionButtonMixin.OnEnter)
    button:SetScript("OnLeave", ActionButtonMixin.OnLeave)
    button.icon:SetTexture(icon)

    button:Configure()
    R.Modules.ButtonStyles:StyleActionButton(button)

    return button
end

ActionButtonMixin = {}

function ActionButtonMixin:Configure()
    self:RegisterForClicks(self.config.clickOnDown and "AnyDown" or "AnyUp")
end

function ActionButtonMixin:OnEnter()
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

function ActionButtonMixin:OnLeave()
    if GameTooltip:IsForbidden() then
        return
    end

    GameTooltip:Hide()
end

function ActionButtonMixin:PostClick()
    self:SetChecked(false)
end
