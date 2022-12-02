local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles

local MICRO_BUTTONS = MICRO_BUTTONS or {
    "CharacterMicroButton", "SpellbookMicroButton", "TalentMicroButton", "AchievementMicroButton", "QuestLogMicroButton", "GuildMicroButton", "LFDMicroButton", "EJMicroButton",
    "CollectionsMicroButton", "MainMenuMicroButton", "HelpMicroButton", "StoreMicroButton"
}

BS.microButtons = {}

function BS:StyleMicroButton(button)
    if not button then
        return
    end

    local buttonName = button:GetName()
    local config = BS.config.microMenu

    if not button.__styled then
        button.__styled = true
        BS.microButtons[button] = true
    end
end

function BS:StyleAllMicroButtons()
    for _, buttonName in next, MICRO_BUTTONS do
        BS:StyleMicroButton(_G[buttonName])
    end
    BS:StyleMicroButton(_G["SettingsMicroButton"])
end

function BS:UpdateAllMicroButtons()
    for button in pairs(BS.microButtons) do
        BS:StyleMicroButton(button)
    end
end
