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

    return frame
end

function AB:UpdateExperienceBar()
    local config = AB.config.experienceBar
    local frame = AB.bars.ExperienceBar

    if config.enabled then
        frame:Show()

        if _G.ReputationWatchBar:IsShown() then
            frame:SetPoint("BOTTOMLEFT", AB.bars.Artwork, "BOTTOMLEFT", 3, 0)
            frame:SetPoint("BOTTOMRIGHT", AB.bars.Artwork, "BOTTOMRIGHT", -3, 0)
        else
            frame:SetPoint("BOTTOMLEFT", AB.bars.Artwork, "BOTTOMLEFT", 3, 0)
            frame:SetPoint("BOTTOMRIGHT", AB.bars.Artwork, "BOTTOMRIGHT", -3, 0)
        end

        _G.MainMenuExpBar:SetAllPoints()

        AB:UpdateExperienceBarTextures()
    else
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
