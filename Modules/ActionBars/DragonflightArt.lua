local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:CreateDragonflightArt()
    local bar = AB.bars[1]
    bar.ArtLeft = bar:CreateTexture("$parentArtLeft", "BACKGROUND")
    bar.ArtLeft:SetTexture(R.media.textures.actionBars.dragonflight.actionBar)
    bar.ArtLeft:SetSize(88, 79)
    bar.ArtLeft:SetPoint("RIGHT", bar, "LEFT", 5, 5)

    bar.ArtRight = bar:CreateTexture("$parentArtRight", "BACKGROUND")
    bar.ArtRight:SetTexture(R.media.textures.actionBars.dragonflight.actionBar)
    bar.ArtRight:SetSize(88, 79)
    bar.ArtRight:SetPoint("LEFT", bar, "RIGHT", -5, 5)

    if R.PlayerInfo.faction == "Alliance" then
        bar.ArtLeft:SetTexCoord(0 / 512, 351 / 512, 208 / 2048, 525 / 2048)
        bar.ArtRight:SetTexCoord(0 / 512, 351 / 512, 555 / 2048, 861 / 2048)
    else
        bar.ArtLeft:SetTexCoord(0 / 512, 351 / 512, 882 / 2048, 1197 / 2048)
        bar.ArtRight:SetTexCoord(0 / 512, 351 / 512, 1218 / 2048, 1533 / 2048)
    end
end