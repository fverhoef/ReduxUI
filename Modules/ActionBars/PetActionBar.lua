local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:SetupPetActionBar()
    local config = AB.config.petActionBar

    local buttonList = {}
    for i = 1, _G.NUM_PET_ACTION_SLOTS do
        local button = _G["PetActionButton" .. i]
        if not button then break end

        table.insert(buttonList, button)
    end
    PetActionBarFrame.config = AB.config.petActionBar
    R:CreateFader(PetActionBarFrame, AB.config.petActionBar.fader, buttonList)
    --R:CreateDragFrame(PetActionBarFrame, L["Pet Action Bar"])
end

function AB:UpdatePetActionBar()
end
