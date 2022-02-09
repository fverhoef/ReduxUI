local addonName, ns = ...
local R = _G.ReduxUI
local MM = R.Modules.Minimap
local L = R.L

function MM:CreateZoneBackground()
    MinimapCluster.ZoneBackground = MinimapCluster:CreateTexture("BACKGROUND")
    MinimapCluster.ZoneBackground:SetTexture([[Interface\QUESTFRAME\BonusObjectives]])
    MinimapCluster.ZoneBackground:SetTexCoord(30 / 512, 394 / 512, 183 / 512, 261 / 512)
    MinimapCluster.ZoneBackground:SetHeight(30)
    MinimapCluster.ZoneBackground:SetPoint("TOPLEFT", MinimapCluster, "TOPLEFT")
    MinimapCluster.ZoneBackground:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT")
end