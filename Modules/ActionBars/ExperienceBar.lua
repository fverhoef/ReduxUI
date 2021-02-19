local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateExperienceBar()
    local config = AB.config.experienceBar

    local frame = CreateFrame("Frame", addonName .. "ExperienceBar", UIParent, "SecureHandlerStateTemplate")
    frame:SetHeight(11)
    frame:SetPoint("BOTTOMLEFT", AB.bars.Artwork, "BOTTOMLEFT", 3, 0)
    frame:SetPoint("BOTTOMRIGHT", AB.bars.Artwork, "BOTTOMRIGHT", -3, 0)
    frame:SetFrameLevel(AB.bars.MainMenuBar:GetFrameLevel() - 1)

    _G.MainMenuExpBar:SetParent(frame)
    _G.MainMenuExpBar:SetAllPoints()

    AB:UpdateExperienceBarTextures()

    frame:CreateFader(R.config.faders.onShow)

    return frame
end

function AB:UpdateExperienceBar()
    local config = AB.config.experienceBar
    local frame = AB.bars.ExperienceBar
    local artwork = AB.bars.Artwork

    if config.enabled then
        frame:SetShown(not artwork.faded and _G.MainMenuExpBar:IsShown())
        frame:LinkFader(artwork)

        -- TODO: support detaching
        if _G.ReputationWatchBar:IsShown() then
            frame:SetPoint("BOTTOMLEFT", artwork, "BOTTOMLEFT", 3, 0)
            frame:SetPoint("BOTTOMRIGHT", artwork, "BOTTOMRIGHT", -3, 0)
        else
            frame:SetPoint("BOTTOMLEFT", artwork, "BOTTOMLEFT", 3, 0)
            frame:SetPoint("BOTTOMRIGHT", artwork, "BOTTOMRIGHT", -3, 0)
        end

        _G.MainMenuExpBar:SetAllPoints()
        
        _G.MainMenuExpBar.OverlayFrame.Text:Show()

        AB:UpdateExperienceBarTextures()
    else
        frame:UnlinkFader(artwork)
        frame:Hide()
    end
end

function AB:UpdateExperienceBarTextures()
    local width = math.floor(_G.MainMenuExpBar:GetWidth() / 4)

    for i = 0, 3 do
        local part = _G["MainMenuXPBarTexture" .. i]
        if part then
            part:ClearAllPoints()
            part:SetSize(width, 12)
            part:SetPoint("BOTTOM", _G.MainMenuExpBar, "BOTTOM", (-1.5 + i * 1) * width, 0)
        end
    end
end
