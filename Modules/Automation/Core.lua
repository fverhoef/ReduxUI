local addonName, ns = ...
local R = _G.ReduxUI
local AM = R:AddModule("Automation", "AceEvent-3.0", "AceHook-3.0")
local L = R.L

local fastLootDelay = 0
local stopVendoring = true
local vendorList = {}
local totalVendorPrice = 0

function AM:Initialize()
    if not AM.config.enabled then
        return
    end

    AM:RegisterEvent("UI_ERROR_MESSAGE")
    AM:RegisterEvent("LOOT_READY")
    AM:RegisterEvent("MERCHANT_SHOW")
    AM:RegisterEvent("MERCHANT_CLOSED")
    AM:RegisterEvent("RESURRECT_REQUEST")
    AM:RegisterEvent("CONFIRM_SUMMON")
    AM:RegisterEvent("CONFIRM_LOOT_ROLL")
    AM:RegisterEvent("LOOT_BIND_CONFIRM")
    AM:RegisterEvent("MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL")
    AM:RegisterEvent("MAIL_LOCK_SEND_ITEMS")
    AM:RegisterEvent("CHAT_MSG_WHISPER")
    AM:RegisterEvent("CHAT_MSG_BN_WHISPER")
end

function AM:UI_ERROR_MESSAGE(event, errorType, msg)
    if not R.isRetail and AM.config.standDismount then
        if msg == SPELL_FAILED_NOT_STANDING or msg == ERR_CANTATTACK_NOTSTANDING or msg == ERR_LOOT_NOTSTANDING or msg ==
            ERR_TAXINOTSTANDING then
            DoEmote("stand")
            UIErrorsFrame:Clear()
        elseif msg == ERR_ATTACK_MOUNTED or msg == ERR_MOUNT_ALREADYMOUNTED or msg == ERR_NOT_WHILE_MOUNTED or msg ==
            ERR_TAXIPLAYERALREADYMOUNTED or msg == SPELL_FAILED_NOT_MOUNTED then
            if IsMounted() then
                Dismount()
                UIErrorsFrame:Clear()
            end
        end
    end
end

function AM:LOOT_READY(event)
    if not R.isRetail and AM.config.fastLoot then
        if GetTime() - fastLootDelay >= 0.3 then
            fastLootDelay = GetTime()
            if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
                for i = GetNumLootItems(), 1, -1 do
                    LootSlot(i)
                end
                fastLootDelay = GetTime()
            end
        end
    end
end

function AM:MERCHANT_SHOW(event)
    if AM.config.repair then
        AM:Repair()
    end
    if AM.config.vendorGrays then
        stopVendoring = false
        totalVendorPrice = 0
        wipe(vendorList)
        AM:VendorGrays()
    end
end

function AM:MERCHANT_CLOSED(event)
    stopVendoring = true
end

function AM:RESURRECT_REQUEST(event, inviter)
    if AM.config.acceptResurrection then
        AM:AcceptResurrection(inviter)
    end
end

function AM:CONFIRM_SUMMON(event)
    if AM.config.acceptSummon then
        AM:AcceptSummon()
    end
end

function AM:CONFIRM_LOOT_ROLL(event, rollID, rollType, confirmReason)
    if AM.config.disableLootRollConfirmation then
        ConfirmLootRoll(rollID, rollType)
        StaticPopup_Hide("CONFIRM_LOOT_ROLL")
    end
end

function AM:LOOT_BIND_CONFIRM(event, lootSlot)
    if AM.config.disableLootBindConfirmation then
        ConfirmLootSlot(lootSlot)
        StaticPopup_Hide("LOOT_BIND")
    end
end

function AM:MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL(event)
    if AM.config.disableVendorRefundWarning then
        SellCursorItem()
    end
end

function AM:MAIL_LOCK_SEND_ITEMS(event, attachSlot, itemLink)
    if AM.config.disableMailRefundWarning then
        RespondMailLockSendItem(attachSlot, true)
    end
end

function AM:CHAT_MSG_WHISPER(event, text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID,
                             channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle,
                             hideSenderInLetterbox, supressRaidIcons)
    if not AM.config.autoInvite then
        return
    end

    if R:PlayerCanInvite() and AM:TextMatchesAutoInvitePassword(text) then
        InviteUnit(playerName)
    end
end

function AM:CHAT_MSG_BN_WHISPER(event, text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID,
                                channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle,
                                hideSenderInLetterbox, supressRaidIcons)
    if not AM.config.autoInvite then
        return
    end

    if R:PlayerCanInvite() and AM:TextMatchesAutoInvitePassword(text) then
        if bnSenderID and BNIsFriend(bnSenderID) then
            local index = BNGetFriendIndex(bnSenderID)
            if index then
                local toonID = select(6, BNGetFriendInfo(index))
                if toonID then
                    BNInviteFriend(toonID)
                end
            end
        end
    end
end

function AM:TextMatchesAutoInvitePassword(text)
    return string.lower(string.trim(text)) == string.lower(AM.config.autoInvitePassword)
end

function AM:Repair()
    if IsShiftKeyDown() then
        return
    end
    if CanMerchantRepair() then
        local repairCost, canRepair = GetRepairAllCost()
        if canRepair then
            if GetMoney() >= repairCost and repairCost > 0 then
                RepairAllItems()
                R:Print(L["Repaired for %s."], GetCoinText(repairCost)) -- TODO: Localization
            end
        end
    end
end

function AM:VendorGrays()
    if IsShiftKeyDown() then
        return
    end
    if stopVendoring then
        AM:ReportVendorResult()
        return
    end
    for bag = 0, 4 do
        for slot = 0, GetContainerNumSlots(bag) do
            if stopVendoring then
                AM:ReportVendorResult()
                return
            end
            local link = GetContainerItemLink(bag, slot)
            if link then
                local _, _, rarity, _, _, _, _, _, _, _, itemPrice = GetItemInfo(link)
                if rarity == 0 and not vendorList["b" .. bag .. "s" .. slot] then
                    totalVendorPrice = totalVendorPrice + itemPrice
                    vendorList["b" .. bag .. "s" .. slot] = true
                    UseContainerItem(bag, slot)
                    C_Timer.After(0.2, AM.VendorGrays)
                    return
                end
            end
        end
    end

    -- if we reached this point we didn't sell anything (this iteration) - so report
    AM:ReportVendorResult()
end

function AM:ReportVendorResult()
    if totalVendorPrice > 0 then
        R:Print(L["Sold trash for %s."], GetCoinText(totalVendorPrice)) -- TODO: Localization
    end
end

function AM:AcceptSummon()
    if not UnitAffectingCombat("player") then
        local summoner = GetSummonConfirmSummoner()
        local summonArea = GetSummonConfirmAreaName()
        R:Print(L["Accepting summons from %s to %s in 10 seconds."], summoner, summonArea) -- TODO: Localization
        C_Timer.After(10, function()
            local newSummoner = GetSummonConfirmSummoner()
            local newSummonArea = GetSummonConfirmAreaName()
            if summoner == newSummoner and summonArea == newSummonArea then
                -- Automatically accept summon after 10 seconds if summoner name and location have not changed
                C_SummonInfo.ConfirmSummon()
                StaticPopup_Hide("CONFIRM_SUMMON")
            end
        end)
    end
end

function AM:AcceptResurrection(unit)
    if not unit or unit == L["Chained Spirit"] then
        return
    end

    local delay = GetCorpseRecoveryDelay()
    if delay and delay > 0 then
        C_Timer.After(delay + 1, function()
            if not UnitAffectingCombat(unit) then
                AcceptResurrect()
            end
        end)
    else
        if not UnitAffectingCombat(unit) then
            AcceptResurrect()
        end
    end
end
