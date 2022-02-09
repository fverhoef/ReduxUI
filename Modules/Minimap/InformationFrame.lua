local addonName, ns = ...
local R = _G.ReduxUI
local MM = R.Modules.Minimap
local L = R.L

function MM:CreateInformationFrame()
    Minimap.InformationFrame = CreateFrame("FRAME", addonName .. "MinimapInformationFrame", Minimap)
    Minimap.InformationFrame:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, 0)
    Minimap.InformationFrame:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, 0)
    Minimap.InformationFrame:SetHeight(25)

    Minimap.InformationFrame.Background = Minimap.InformationFrame:CreateTexture("BACKGROUND")
    Minimap.InformationFrame.Background:SetTexture([[Interface\QUESTFRAME\AutoQuest-Parts]])
    Minimap.InformationFrame.Background:SetTexCoord(224 / 512, (224 + 245) / 512, 0 / 64, 64 / 64)
    Minimap.InformationFrame.Background:SetHeight(50)
    Minimap.InformationFrame.Background:SetPoint("TOPLEFT", Minimap.InformationFrame, "TOPLEFT", 0, 0)
    Minimap.InformationFrame.Background:SetPoint("TOPRIGHT", Minimap.InformationFrame, "TOPRIGHT", 0, 0)
end