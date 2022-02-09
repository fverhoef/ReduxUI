local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

SettingsMicroButtonMixin = {}

function SettingsMicroButtonMixin:OnLoad()
    self.tooltipText = R.title
    self.newbieText = L["Click to open config dialog. Shift-click to reload UI. Alt-click to lock/unlock frames."]
    self:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    self:SetNormalTexture(R.media.textures.actionBars.microButtonSettings_Up)
    self:SetPushedTexture(R.media.textures.actionBars.microButtonSettings_Down)
    self:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight")
end

function SettingsMicroButtonMixin:OnClick()
    if IsShiftKeyDown() then
        ReloadUI()
    elseif IsAltKeyDown() then
        R:ToggleDragFrames()
    else
        R:ShowOptionsDialog()
    end
end

function SettingsMicroButtonMixin:OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(R.title)
    GameTooltip:AddLine(L["Click: show options dialog."], 1, 1, 1)
    GameTooltip:AddLine(L["Shift-click: reload UI."], 1, 1, 1)
    GameTooltip:AddLine(L["Alt-click: lock/unlock frames."], 1, 1, 1)
    
    if IsShiftKeyDown() then
        AB:AddSystemInfo(GameTooltip)
    else
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(L["Hold Shift to show system statistics."])
    end

    GameTooltip:Show()
end

function SettingsMicroButtonMixin:OnLeave()
    _G.GameTooltip:Hide()
end