local addonName, ns = ...
local R = _G.ReduxUI
local BS = R:AddModule("ButtonStyles", "AceEvent-3.0", "AceHook-3.0")

function BS:Initialize()
end

function BS:Enable()
    BS.config = BS.config
    BS.masque = LibStub("Masque", true)
    if not BS.masque and (not BS.config.enabled or BS.initalized) then
        return
    end

    if BS.masque then
        BS.masqueGroups = {
            actionButtons = BS.masque:Group(R.title, "Action Buttons"),
            itemButtons = BS.masque:Group(R.title, "Item Buttons"),
            bagSlotButtons = BS.masque:Group(R.title, "Bag Slot Buttons"),
            totemBarButtons = BS.masque:Group(R.title, "Totem Bar Buttons"),
            buffs = BS.masque:Group(R.title, "Buffs"),
            debuffs = BS.masque:Group(R.title, "Debuffs"),
            tempEnchants = BS.masque:Group(R.title, "Temp Enchants")
        }
    end

    BS:StyleAllActionButtons()
    BS:StyleAllMicroButtons()
    BS:StyleAllItemButtons()
    BS:StyleAllTotemBarButtons()

    if not BS.masque then
        if BuffFrame_Update then
            BS:SecureHook("BuffFrame_Update", BS.BuffFrame_Update)
        end
        BS:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
        _G.CharacterFrame:HookScript("OnShow", BS.CharacterFrame_OnShow)
    end
end

function BS:UpdateAll()
    BS:UpdateAllActionButtons()
    BS:UpdateAllAuraButtons()
    BS:UpdateAllItemButtons()
    BS:UpdateAllMicroButtons()
    BS:UpdateAllTotemBarButtons()
end

function BS:PLAYER_EQUIPMENT_CHANGED(event)
    BS:StyleAllItemButtons()
end

function BS:CharacterFrame_OnShow()
    BS:StyleCharacterButtons()
end
