local addonName, ns = ...
local R = _G.ReduxUI
local MM = R.Modules.Minimap
local L = R.L

ButtonFrameToggleButtonMixin = {}

function ButtonFrameToggleButtonMixin:UpdateTooltip()
    GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(L["Minimap"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    if self:GetChecked() then
        GameTooltip:AddLine(L["Hide Minimap Buttons"], 1, 1, 1)
    else
        GameTooltip:AddLine(L["Show Minimap Buttons"], 1, 1, 1)
    end
    GameTooltip:Show()
end

function MM:CreateButtonFrameToggleButton()
    Minimap.ButtonFrame.ToggleButton = CreateFrame("CheckButton", "MinimapButtonFrameToggle", Minimap.InformationFrame)
    Minimap.ButtonFrame.ToggleButton:SetSize(16, 16)
    Minimap.ButtonFrame.ToggleButton:SetPoint("TOPRIGHT", Minimap.InformationFrame, "TOPRIGHT", -5, 4)
    Minimap.ButtonFrame.ToggleButton:SetChecked(not MM.config.buttonFrame.collapsed)
    Minimap.ButtonFrame.ToggleButton:SetScript("OnEnter", function(self) self:UpdateTooltip() end)
    Minimap.ButtonFrame.ToggleButton:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    Minimap.ButtonFrame.ToggleButton:SetScript("OnClick", function(self)
        self:UpdateTooltip()
        Minimap.ButtonFrame:Toggle()
    end)

    _G.Mixin(Minimap.ButtonFrame.ToggleButton, ButtonFrameToggleButtonMixin)
end