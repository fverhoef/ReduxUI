local addonName, ns = ...
local R = _G.ReduxUI
local AM = R:AddModule("Automation", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local L = R.L

local fastLootDelay = 0
local stopVendoring = true
local vendorList = {}
local totalVendorPrice = 0

function AM:Initialize()
    if not R.config.db.profile.modules.automation.enabled then
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
end

function AM:UI_ERROR_MESSAGE(msg)
    if R.config.db.profile.modules.automation.standDismount then
        if msg == SPELL_FAILED_NOT_STANDING or msg == ERR_CANTATTACK_NOTSTANDING or msg == ERR_LOOT_NOTSTANDING or msg == ERR_TAXINOTSTANDING then
            DoEmote("stand")
            UIErrorsFrame:Clear()
        elseif msg == ERR_ATTACK_MOUNTED or msg == ERR_MOUNT_ALREADYMOUNTED or msg == ERR_NOT_WHILE_MOUNTED or msg == ERR_TAXIPLAYERALREADYMOUNTED or msg ==
            SPELL_FAILED_NOT_MOUNTED then
            if IsMounted() then
                Dismount()
                UIErrorsFrame:Clear()
            end
        end
    end
end

function AM:LOOT_READY()
    if R.config.db.profile.modules.automation.fastLoot then
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

function AM:MERCHANT_SHOW()
    if R.config.db.profile.modules.automation.repair then
        AM:Repair()
    end
    if R.config.db.profile.modules.automation.vendorGrays then
        stopVendoring = false
        totalVendorPrice = 0
        wipe(vendorList)
        AM:VendorGrays()
    end
end

function AM:MERCHANT_CLOSED()
    stopVendoring = true
end

function AM:RESURRECT_REQUEST()
    if R.config.db.profile.modules.automation.acceptResurrection then
        AM:AcceptResurrection(self)
    end
end

function AM:CONFIRM_SUMMON()
    if R.config.db.profile.modules.automation.acceptSummon then
        AM:AcceptSummon()
    end
end

function AM:CONFIRM_LOOT_ROLL(arg1, arg2)
    if R.config.db.profile.modules.automation.disableLootRollConfirmation then
        ConfirmLootRoll(arg1, arg2)
        StaticPopup_Hide("CONFIRM_LOOT_ROLL")
    end
end

function AM:LOOT_BIND_CONFIRM(arg1, arg2, ...)
    if R.config.db.profile.modules.automation.disableLootBindConfirmation then
        ConfirmLootSlot(arg1, arg2)
        StaticPopup_Hide("LOOT_BIND", ...)
    end
end

function AM:MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL()
    if R.config.db.profile.modules.automation.disableVendorRefundWarning then
        SellCursorItem()
    end
end

function AM:MAIL_LOCK_SEND_ITEMS(arg1)
    if R.config.db.profile.modules.automation.disableMailRefundWarning then
        RespondMailLockSendItem(arg1, true)
    end
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
                R:Print("Repaired for " .. GetCoinText(repairCost) .. ".") -- TODO: Localization
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
        R:Print("Sold trash for " .. GetCoinText(totalVendorPrice) .. ".") -- TODO: Localization
    end
end

function AM:AcceptSummon()
    if not UnitAffectingCombat("player") then
        local summoner = GetSummonConfirmSummoner()
        local summonArea = GetSummonConfirmAreaName()
        R:Print("Accepting summons from " .. summoner .. " to " .. summonArea .. " in 10 seconds.")
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
    -- Exclude Chained Spirit (Zul'Gurub)
    if unit == L["Chained Spirit"] then
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
