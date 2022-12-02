local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars
local L = R.L

local MICRO_BUTTONS = MICRO_BUTTONS or {
    "CharacterMicroButton", "SpellbookMicroButton", "TalentMicroButton", "AchievementMicroButton", "QuestLogMicroButton", "GuildMicroButton", "LFDMicroButton", "EJMicroButton",
    "CollectionsMicroButton", "MainMenuMicroButton", "HelpMicroButton", "StoreMicroButton"
}

function AB:CreateMicroButtonAndBagsBar()
    AB.SettingsMicroButton = CreateFrame("Button", "SettingsMicroButton", UIParent, "SettingsMicroButtonTemplate")
    AB.MicroButtonAndBagsBar = CreateFrame("Frame", addonName .. "MicroButtonAndBagsBar", UIParent, "MicroButtonAndBagsBarTemplate")
end

AB.MicroButtonAndBagsBarMixin = {}
ReduxMicroButtonAndBagsBarMixin = AB.MicroButtonAndBagsBarMixin

function AB.MicroButtonAndBagsBarMixin:OnLoad()
    self:HideBlizzard()
    self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
    self:SetWidth(R.isRetail and 298 or 283)

    self.buttonList = { MainMenuBarBackpackButton, CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot, SettingsMicroButton }
    if not R.isRetail then
        table.insert(self.buttonList, KeyRingButton)
    end
    for i = 1, #MICRO_BUTTONS do
        table.insert(self.buttonList, _G[MICRO_BUTTONS[i]])
    end
    self:UpdateMicroButtonsParent()
    self:CreateFader(AB.config.microButtonAndBags.fader, self.buttonList)

    MainMenuBarBackpackButton:ClearAllPoints()
    MainMenuBarBackpackButton:SetPoint("TOPRIGHT", self, "TOPRIGHT", -4, -4)
    MainMenuBarBackpackButton:SetSize(40, 40)
    R:FixNormalTextureSize(MainMenuBarBackpackButton)

    CharacterBag0Slot:ClearAllPoints()
    CharacterBag0Slot:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", -4, -4)
    CharacterBag0Slot:SetSize(30, 30)
    R:FixNormalTextureSize(CharacterBag0Slot)

    CharacterBag1Slot:ClearAllPoints()
    CharacterBag1Slot:SetPoint("RIGHT", CharacterBag0Slot, "LEFT", -2, 0)
    CharacterBag1Slot:SetSize(30, 30)
    R:FixNormalTextureSize(CharacterBag1Slot)

    CharacterBag2Slot:ClearAllPoints()
    CharacterBag2Slot:SetPoint("RIGHT", CharacterBag1Slot, "LEFT", -2, 0)
    CharacterBag2Slot:SetSize(30, 30)
    R:FixNormalTextureSize(CharacterBag2Slot)

    CharacterBag3Slot:ClearAllPoints()
    CharacterBag3Slot:SetPoint("RIGHT", CharacterBag2Slot, "LEFT", -2, 0)
    CharacterBag3Slot:SetSize(30, 30)
    R:FixNormalTextureSize(CharacterBag3Slot)

    if not R.isRetail then
        KeyRingButton:SetParent(R.HiddenFrame)
        KeyRingButton:ClearAllPoints()
        KeyRingButton:SetPoint("BOTTOMRIGHT", CharacterBag3Slot, "BOTTOMLEFT", -4, -2)
        KeyRingButton:SetSize(16, 32)
    end

    CharacterMicroButton:ClearAllPoints()
    CharacterMicroButton:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 3)

    if not R.isRetail then
        MainMenuMicroButton.PerformanceBar = CreateFrame("Frame", nil, MainMenuMicroButton)
        MainMenuMicroButton.PerformanceBar:SetSize(28, 58)
        MainMenuMicroButton.PerformanceBar:SetPoint("BOTTOM", MainMenuMicroButton, "BOTTOM", 0, 0)

        MainMenuMicroButton.PerformanceBar.Texture = MainMenuMicroButton.PerformanceBar:CreateTexture("OVERLAY")
        MainMenuMicroButton.PerformanceBar.Texture:SetAllPoints()
        MainMenuMicroButton.PerformanceBar.Texture:SetTexture(R.media.textures.actionBars.performanceBar)

        self:UpdateMainMenuButton()
    end

    AB:SecureHook("UpdateMicroButtonsParent", function()
        self:UpdateMicroButtonsParent()
    end)

    -- prevent other bars from calling MoveMicroButtons without tainting
    MainMenuBar:SetScript("OnShow", R.EmptyFunction)
    if OverrideActionBar then
        OverrideActionBar:SetScript("OnEvent", R.EmptyFunction)
        OverrideActionBar:SetScript("OnShow", R.EmptyFunction)
    end
end

function AB.MicroButtonAndBagsBarMixin:HideBlizzard()
    if MicroButtonAndBagsBar then
        MicroButtonAndBagsBar:SetParent(R.HiddenFrame)
    end
end

function AB.MicroButtonAndBagsBarMixin:UpdateMicroButtonsParent()
    for i, button in ipairs(self.buttonList) do
        button:SetParent(self)
    end
end

function AB.MicroButtonAndBagsBarMixin:UpdateMainMenuButton()
    if R.isRetail then
        return
    end

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

    AB:ScheduleTimer(self.UpdateMainMenuButton, PERFORMANCEBAR_UPDATE_INTERVAL, self)
end
