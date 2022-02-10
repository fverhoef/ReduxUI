local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:SetupMicroButtonAndBagsBar()
    if not MicroButtonAndBagsBar then
        MicroButtonAndBagsBar = CreateFrame("Frame", "MicroButtonAndBagsBar", MainMenuBar, "MicroButtonAndBagsBarTemplate")
        MicroButtonAndBagsBar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
    end

    MicroButtonAndBagsBar.buttonList = {
        MainMenuBarBackpackButton,
        CharacterBag0Slot,
        CharacterBag1Slot,
        CharacterBag2Slot,
        CharacterBag3Slot,
        SettingsMicroButton
    }
	for i=1, #MICRO_BUTTONS do
		table.insert(MicroButtonAndBagsBar.buttonList, _G[MICRO_BUTTONS[i]])
	end
    AB.UpdateMicroButtonsParent(MicroButtonAndBagsBar)
    MicroButtonAndBagsBar:CreateFader(AB.config.microButtonAndBags.fader, MicroButtonAndBagsBar.buttonList)

    if not MicroButtonAndBagsBar.MicroBagBarEndCap then
        MicroButtonAndBagsBar.MicroBagBarEndCap = MicroButtonAndBagsBar:CreateTexture("MicroBagBarEndCap", "BACKGROUND", nil, 7)
        MicroButtonAndBagsBar.MicroBagBarEndCap:SetSize(96, 88)
        MicroButtonAndBagsBar.MicroBagBarEndCap:SetPoint("BOTTOMLEFT", MicroButtonAndBagsBar, "BOTTOMLEFT", -24, 0)
        MicroButtonAndBagsBar.MicroBagBarEndCap:SetTexture(R.media.textures.actionBars.mainMenuBar)
        MicroButtonAndBagsBar.MicroBagBarEndCap:SetTexCoord(0.238281, 0.332031, 0.652344, 0.996094)
    end
    
    AB:SecureHook("MoveMicroButtons", AB.MoveMicroButtons)
    AB:SecureHook("UpdateMicroButtonsParent", AB.UpdateMicroButtonsParent)

    AB:MoveCharacterMicroButton()
end

function AB:UpdateMicroButtonAndBagsBar()
end

function AB:MoveCharacterMicroButton()
    CharacterMicroButton:ClearAllPoints()
    CharacterMicroButton:SetPoint("BOTTOMLEFT", MicroButtonAndBagsBar, "BOTTOMLEFT", -18, 3)
end

AB.MoveMicroButtons = function(anchor, anchorTo, relAnchor, x, y, isStacked)
    if (anchorTo == MicroButtonAndBagsBar or anchorTo == MainMenuBarArtFrame) then
        AB:MoveCharacterMicroButton()
    end
end

AB.UpdateMicroButtonsParent = function(parent)
    if parent == MainMenuBarArtFrame or parent == MicroButtonAndBagsBar then
        for i, button in ipairs(MicroButtonAndBagsBar.buttonList) do
            button:SetParent(MicroButtonAndBagsBar)
        end
        SettingsMicroButton:Show()
    else
        SettingsMicroButton:Hide()
    end
end