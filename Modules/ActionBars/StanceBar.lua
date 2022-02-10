local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:SetupStanceBar()
    local buttonList = {}

    for i = 1, _G.NUM_STANCE_SLOTS do
        local button = _G["StanceButton" .. i]
        if not button then break end

        table.insert(buttonList, button)
    end
    StanceBarFrame.config = AB.config.stanceBar
    StanceBarFrame:CreateFader(AB.config.stanceBar.fader, buttonList)
    --R:CreateDragFrame(StanceBarFrame, L["Stance Bar"], AB.defaults.stanceBar.point)
end

function AB:UpdateStanceBar()
end

function AB:UpdateStanceBarTextures()
    if AB.config.mainMenuBar.stackBottomBars and (MultiBarBottomLeft:IsShown() or MultiBarBottomRight:IsShown()) then
        SlidingActionBarTexture0:Hide()
        SlidingActionBarTexture1:Hide()
        if StanceBarFrame then
            StanceBarLeft:Hide()
            StanceBarRight:Hide()
            StanceBarMiddle:Hide()
            for i = 1, NUM_STANCE_SLOTS do
                _G["StanceButton" .. i]:GetNormalTexture():SetWidth(52)
                _G["StanceButton" .. i]:GetNormalTexture():SetHeight(52)
            end
        end
    end
end
