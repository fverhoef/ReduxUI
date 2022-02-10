local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

function AB:SetupPetActionBar()
    local config = AB.config.petActionBar

    local buttonList = {}
    for i = 1, _G.NUM_PET_ACTION_SLOTS do
        local button = _G["PetActionButton" .. i]
        if not button then break end

        table.insert(buttonList, button)
    end
    PetActionBarFrame.config = AB.config.petActionBar
    PetActionBarFrame:CreateFader(AB.config.petActionBar.fader, buttonList)
    --R:CreateDragFrame(PetActionBarFrame, L["Pet Action Bar"], AB.defaults.petActionBar.point)
end

function AB:UpdatePetActionBar()
end
