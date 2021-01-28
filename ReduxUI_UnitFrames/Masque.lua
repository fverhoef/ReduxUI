local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames

function UF:SetupMasque()
    if LibStub("Masque", true) and not UF.masqueGroups then
        UF.masqueGroups = {
            AuraGroup = LibStub("Masque"):Group(R.title, "Auras"),
            BlizzardBuffGroup = LibStub("Masque"):Group(R.title, "Blizzard Buffs"),
            BlizzardDebuffGroup = LibStub("Masque"):Group(R.title, "Blizzard Debuffs"),
            BlizzardTempEnchantGroup = LibStub("Masque"):Group(R.title, "Blizzard Temp Enchants")
        }

        UF:AddBuffButtonsToMasque()
        UF:AddDebuffButtonsToMasque()
        UF:AddTempEnchantsToMasque()

        UF:SecureHook("BuffFrame_UpdateAllBuffAnchors", function()
            UF:AddBuffButtonsToMasque()
        end)
        UF:SecureHook("DebuffButton_UpdateAnchors", function(buttonName, i)
            UF:AddDebuffButtonToMasque(i)
        end)
    end
end

function UF:AddBuffButtonsToMasque()
    for i = 1, BUFF_MAX_DISPLAY do
        UF:AddBuffButtonToMasque(i)
    end
end

function UF:AddBuffButtonToMasque(i)
    local button = _G["BuffButton" .. i]
    if button then
        UF.masqueGroups.BlizzardBuffGroup:AddButton(button)
    end
end

function UF:AddDebuffButtonsToMasque()
    for i = 1, BUFF_MAX_DISPLAY do
        UF:AddDebuffButtonToMasque(i)
    end
end

function UF:AddDebuffButtonToMasque(i)
    local button = _G["DebuffButton" .. i]
    if button then
        UF.masqueGroups.BlizzardDebuffGroup:AddButton(button)
    end
end

function UF:AddTempEnchantsToMasque()
    for i = 1, NUM_TEMP_ENCHANT_FRAMES do
        local button = _G["TempEnchant" .. i]
        if button then
            UF.masqueGroups.BlizzardTempEnchantGroup:AddButton(button)

            local border = _G["TempEnchant" .. i .. "Border"]
            if border then
                border:SetVertexColor(.75, 0, 1)
            end
        end
    end
end