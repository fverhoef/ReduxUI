local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateMaxLevelBar()
    local config = AB.config.maxLevelBar

    local frame = CreateFrame("Frame", addonName .. "MaxLevelBar", UIParent, "SecureHandlerStateTemplate")
    frame:SetHeight(11)
    frame:SetPoint("BOTTOMLEFT", AB.bars.Artwork, "BOTTOMLEFT", 3, 0)
    frame:SetPoint("BOTTOMRIGHT", AB.bars.Artwork, "BOTTOMRIGHT", -3, 0)
    frame:SetFrameLevel(AB.bars.MainMenuBar:GetFrameLevel() - 1)

    _G.MainMenuBarMaxLevelBar:SetParent(frame)
    _G.MainMenuBarMaxLevelBar:SetAllPoints()

    AB:UpdateMaxLevelBarTextures()

    frame:CreateFader(R.config.faders.onShow)

    return frame
end

function AB:UpdateMaxLevelBar()
    local config = AB.config.maxLevelBar
    local frame = AB.bars.MaxLevelBar
    local artwork = AB.bars.Artwork
    local artworkConfig = AB.config.artwork

    if config.enabled and artworkConfig.enabled then
        frame:SetShown(not artwork.faded and _G.MainMenuBarMaxLevelBar:IsShown())
        frame:LinkFader(artwork)

        AB:UpdateMaxLevelBarTextures()
    else
        frame:UnlinkFader(artwork)
        frame:Hide()
    end
end

function AB:UpdateMaxLevelBarTextures()
    local width = math.floor(_G.MainMenuBarMaxLevelBar:GetWidth() / 4)

    for i = 0, 3 do
        local part = _G["MainMenuMaxLevelBar" .. i]
        if part then
            part:ClearAllPoints()
            part:SetSize(width, 12)
            part:SetPoint("BOTTOM", _G.MainMenuBarMaxLevelBar, "BOTTOM", (-1.5 + i * 1) * width, 0)
            part:SetDrawLayer("ARTWORK", 1)
        end
    end
end
