local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:CreateReputationBar()
    local config = AB.config.reputationBar

    local frame = CreateFrame("Frame", addonName .. "ReputationBar", UIParent, "SecureHandlerStateTemplate")
    frame:SetHeight(11)
    frame:SetPoint("BOTTOMLEFT", AB.bars.Artwork, "BOTTOMLEFT", 3, 0)
    frame:SetPoint("BOTTOMRIGHT", AB.bars.Artwork, "BOTTOMRIGHT", -3, 0)
    frame:SetFrameLevel(AB.bars.MainMenuBar:GetFrameLevel() - 1)

    _G.ReputationWatchBar:SetParent(frame)
    _G.ReputationWatchBar:SetAllPoints()

    _G.ReputationWatchBar.OverlayFrame:SetParent(_G.ReputationWatchBar)
    _G.ReputationWatchBar.OverlayFrame:SetAllPoints()

    _G.ReputationWatchBar.StatusBar:SetParent(_G.ReputationWatchBar)
    _G.ReputationWatchBar.StatusBar:SetAllPoints()

    AB:UpdateReputationBarTextures()

    frame:CreateFader(R.config.faders.onShow)
    frame:Hide()

    return frame
end

function AB:UpdateReputationBar()
    local config = AB.config.reputationBar
    local frame = AB.bars.ReputationBar
    local artwork = AB.bars.Artwork

    if config.enabled then
        frame:LinkFader(artwork)

        -- TODO: support detaching
        -- Blizz's MainMenuTrackingBar_Configure resets the point the bar is attached to; fix that
        _G.ReputationWatchBar:SetParent(frame)
        _G.ReputationWatchBar:SetAllPoints()

        _G.ReputationWatchBar.OverlayFrame.Text:Show()

        AB:UpdateReputationBarTextures()
    else
        frame:UnlinkFader(artwork)
        frame:Hide()
    end
end

function AB:UpdateReputationBarTextures()
    local width = math.floor(_G.ReputationWatchBar.StatusBar:GetWidth() / 4)

    for i = 0, 3 do
        local part = _G.ReputationWatchBar.StatusBar["WatchBarTexture" .. i]
        if part then
            part:ClearAllPoints()
            part:SetSize(width, 12)
            part:SetPoint("BOTTOM", _G.ReputationWatchBar.StatusBar, "BOTTOM", (-1.5 + i * 1) * width, 0)
        end

        local part = _G.ReputationWatchBar.StatusBar["XPBarTexture" .. i]
        if part then
            part:ClearAllPoints()
            part:SetSize(width, 12)
            part:SetPoint("BOTTOM", _G.ReputationWatchBar.StatusBar, "BOTTOM", (-1.5 + i * 1) * width, 0)
        end
    end
end
