local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

function AB:SetupMicroButtonAndBagsBar()
    if not MicroButtonAndBagsBar then
        MicroButtonAndBagsBar = CreateFrame("Frame", "MicroButtonAndBagsBar", MainMenuBar, "MicroButtonAndBagsBarTemplate")
        MicroButtonAndBagsBar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
    end

    MicroButtonAndBagsBar.buttonList = {MainMenuBarBackpackButton, CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot, SettingsMicroButton}

    if not R.isRetail then table.insert(MicroButtonAndBagsBar.buttonList, KeyRingButton) end

    for i = 1, #MICRO_BUTTONS do table.insert(MicroButtonAndBagsBar.buttonList, _G[MICRO_BUTTONS[i]]) end
    AB.UpdateMicroButtonsParent(MicroButtonAndBagsBar)
    MicroButtonAndBagsBar:CreateFader(AB.config.microButtonAndBags.fader, MicroButtonAndBagsBar.buttonList)

    if not R.isRetail then
        MainMenuBarBackpackButton:ClearAllPoints()
        MainMenuBarBackpackButton:SetPoint("TOPRIGHT", -4, -4)
        MainMenuBarBackpackButton:SetSize(40, 40)
        R:FixNormalTextureSize(MainMenuBarBackpackButton)

        CharacterBag0Slot:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", -4, -4)
        CharacterBag0Slot:SetSize(30, 30)
        R:FixNormalTextureSize(CharacterBag0Slot)

        CharacterBag1Slot:SetPoint("RIGHT", CharacterBag0Slot, "LEFT", -2, 0)
        CharacterBag1Slot:SetSize(30, 30)
        R:FixNormalTextureSize(CharacterBag1Slot)

        CharacterBag2Slot:SetPoint("RIGHT", CharacterBag1Slot, "LEFT", -2, 0)
        CharacterBag2Slot:SetSize(30, 30)
        R:FixNormalTextureSize(CharacterBag2Slot)

        CharacterBag3Slot:SetPoint("RIGHT", CharacterBag2Slot, "LEFT", -2, 0)
        CharacterBag3Slot:SetSize(30, 30)
        R:FixNormalTextureSize(CharacterBag3Slot)

        KeyRingButton:ClearAllPoints()
        KeyRingButton:SetPoint("BOTTOMRIGHT", CharacterBag3Slot, "BOTTOMLEFT", -4, -2)
        KeyRingButton:SetSize(16, 32)

        MainMenuMicroButton.PerformanceBar = CreateFrame("Frame", nil, MainMenuMicroButton)
        MainMenuMicroButton.PerformanceBar:SetSize(28, 58)
        MainMenuMicroButton.PerformanceBar:SetPoint("BOTTOM", MainMenuMicroButton, "BOTTOM", 0, 0)

        MainMenuMicroButton.PerformanceBar.Texture = MainMenuMicroButton.PerformanceBar:CreateTexture("OVERLAY")
        MainMenuMicroButton.PerformanceBar.Texture:SetAllPoints()
        MainMenuMicroButton.PerformanceBar.Texture:SetTexture(R.media.textures.actionBars.performanceBar)

        AB:MainMenuMicroButton_Update()
    end

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

function AB:UpdateMicroButtonAndBagsBar() end

function AB:MoveCharacterMicroButton()
    CharacterMicroButton:ClearAllPoints()
    CharacterMicroButton:SetPoint("BOTTOMLEFT", MicroButtonAndBagsBar, "BOTTOMLEFT", -18, 3)
end

AB.MoveMicroButtons = function(anchor, anchorTo, relAnchor, x, y, isStacked) if (anchorTo == MicroButtonAndBagsBar or anchorTo == MainMenuBarArtFrame) then AB:MoveCharacterMicroButton() end end

AB.UpdateMicroButtonsParent = function(parent)
    if parent == MainMenuBarArtFrame or parent == MicroButtonAndBagsBar then
        for i, button in ipairs(MicroButtonAndBagsBar.buttonList) do button:SetParent(MicroButtonAndBagsBar) end
        SettingsMicroButton:Show()
    else
        SettingsMicroButton:Hide()
    end
end

function AB:MainMenuMicroButton_Update()
    if R.isRetail then return end
    R.SystemInfo:Update(false)

    local latencyColor
    local latency = R.SystemInfo.homePing > R.SystemInfo.worldPing and R.SystemInfo.homePing or R.SystemInfo.worldPing
    if latency > AB.config.systemInfo.mediumLatencyTreshold then
        latencyColor = AB.config.systemInfo.highLatencyColor
    elseif latency > AB.config.systemInfo.lowLatencyTreshold then
        latencyColor = AB.config.systemInfo.mediumLatencyColor
    else
        latencyColor = AB.config.systemInfo.lowLatencyColor
    end

    MainMenuMicroButton.PerformanceBar.Texture:SetVertexColor(unpack(latencyColor))

    AB:ScheduleTimer(AB.MainMenuMicroButton_Update, PERFORMANCEBAR_UPDATE_INTERVAL)
end
