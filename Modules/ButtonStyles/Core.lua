local addonName, ns = ...
local R = _G.ReduxUI
local BS = R:AddModule("ButtonStyles", "AceEvent-3.0", "AceHook-3.0")

function BS:Initialize()
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
            buffs = BS.masque:Group(R.title, "Buffs"),
            debuffs = BS.masque:Group(R.title, "Debuffs"),
            tempEnchants = BS.masque:Group(R.title, "Temp Enchants")
        }
    end

    BS:StyleAllActionButtons()
    BS:StyleAllMicroButtons()
    BS:StyleAllItemButtons()

    if not BS.masque then
        BS:SecureHook("BuffFrame_Update", BS.BuffFrame_Update)
        BS:SecureHook(nil, "SetItemButtonCount", BS.SetItemButtonCount)
        BS:SecureHook(nil, "SetItemButtonQuality", BS.SetItemButtonQuality)
        BS:SecureHook(nil, "SetItemButtonTexture", BS.SetItemButtonTexture)
        BS:SecureHook(nil, "SetItemButtonNormalTextureVertexColor", BS.SetItemButtonNormalTextureVertexColor)
        BS:SecureHook(nil, "QuestInfo_ShowRewards", BS.QuestInfo_ShowRewards)
        BS:SecureHook(nil, "QuestFrameItems_Update", BS.QuestFrameItems_Update)
        BS:RegisterEvent("ADDON_LOADED")
        BS:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
        _G.CharacterFrame:HookScript("OnShow", BS.CharacterFrame_OnShow)
    end
end

function BS:UpdateAll()
    BS:UpdateAllActionButtons()
    BS:UpdateAllAuraButtons()
    BS:UpdateAllItemButtons()
    BS:UpdateAllMicroButtons()
end

function BS:ADDON_LOADED(event, addonName)
    if addonName == "Blizzard_AuctionUI" then
        for i = 1, _G.NUM_BROWSE_TO_DISPLAY do
            local button = _G["BrowseButton" .. i .. "Item"]
            button.tag = BS.tags.AuctionBrowse
            BS:StyleItemButton(button)
        end
    elseif addonName == "Blizzard_TradeSkillUI" then
        BS:SecureHook(nil, "TradeSkillFrame_SetSelection", BS.TradeSkillFrame_SetSelection)
    end
end

function BS:PLAYER_EQUIPMENT_CHANGED(event)
    BS:StyleAllItemButtons()
end

function BS:CharacterFrame_OnShow()
    BS:StyleCharacterButtons()
end

function BS:QuestInfo_ShowRewards()
    for i = 1, #_G.QuestInfoRewardsFrame.RewardButtons do
        local button = _G["QuestInfoRewardsFrameQuestInfoItem" .. i]
        button.itemIDOrLink = button.type and (GetQuestLogItemLink or GetQuestItemLink)(button.type, button:GetID())
        BS:StyleItemButton(button)
    end
end

function BS:QuestFrameItems_Update()
    for i = 1, _G.MAX_NUM_ITEMS do
        local button = _G["QuestLogItem" .. i]
        button.itemIDOrLink = button.type and (GetQuestLogItemLink or GetQuestItemLink)(button.type, button:GetID())
        BS:StyleItemButton(button)
    end
end

function BS:TradeSkillFrame_SetSelection()
    local id = self

    -- TODO: style trade skill selected skill icon
    -- local itemLink = GetTradeSkillItemLink(id)

    for i = 1, GetTradeSkillNumReagents(id) do
        local button = _G["TradeSkillReagent" .. i]
        button.itemIDOrLink = GetTradeSkillReagentItemLink(id, i)
        BS:StyleItemButton(button)
    end
end
