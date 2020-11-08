local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

function UF:SetupMasque()
    if LibStub("Masque", true) and not UF.masqueGroups then
        UF.masqueGroups = {
            AuraGroup = LibStub("Masque"):Group(Addon.title, "Auras"),
            BlizzardBuffGroup = LibStub("Masque"):Group(Addon.title, "Blizzard Buffs"),
            BlizzardDebuffGroup = LibStub("Masque"):Group(Addon.title, "Blizzard Debuffs"),
            BlizzardTempEnchantGroup = LibStub("Masque"):Group(Addon.title, "Blizzard Temp Enchants")
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

function UF:UpdateAuraCooldown(buttonName, index, filter)
    local cd = _G[self:GetName() .. "Cooldown"]
    if not cd then
        cd = CreateFrame("Cooldown", self:GetName() .. "Cooldown", self, "CooldownFrameTemplate")
        cd:SetAllPoints()
    end

    local _, _, _, _, duration, expirationTime = UnitAura("player", self:GetID(), nil)
    if expirationTime then -- TODO: expiration is nil for temp enchants, see how to get start time
        cd:SetCooldown(expirationTime - duration, duration)
    end
end