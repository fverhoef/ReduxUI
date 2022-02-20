local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

local MIN_DURATION = 3
local MAX_DURATION = 300
local TARGET_FPS = 60
local SMOOTHING_AMOUNT = 0.33
local WEAPON_ENCHANT_MAIN = "WEAPON_ENCHANT_MAIN"
local WEAPON_ENCHANT_OFFHAND = "WEAPON_ENCHANT_OFFHAND"
local WEAPON_ENCHANT_RANGED = "WEAPON_ENCHANT_RANGED"
local RES_TIMER = "RES_TIMER"
local COOLDOWN_TYPES = {SPELL = "SPELL", PET = "PET", ITEM = "ITEM", RES_TIMER = "RES_TIMER", WEAPON_ENCHANT = "WEAPON_ENCHANT"}

function AB:LoadCooldownBars()
    AB.cooldowns = {}
    AB.cooldownBars = {}
    for name, config in pairs(AB.config.cooldownBars) do if config.enabled then AB.cooldownBars[name] = AB:CreateCooldownBar(name, config) end end
    
    if #AB.cooldownBars <= 0 then return end

    AB:RegisterEvent("BAG_UPDATE_COOLDOWN")
    AB:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
    AB:RegisterEvent("PET_BAR_UPDATE_COOLDOWN")
    AB:RegisterEvent("PLAYER_DEAD")
    AB:RegisterEvent("SPELL_UPDATE_COOLDOWN")
    AB:RegisterEvent("UNIT_INVENTORY_CHANGED")

    AB:ScheduleRepeatingTimer("UpdateCooldownBars", 1 / 30)
end

function AB:UpdateCooldownBars()
    if #AB.cooldownBars <= 0 then return end

    for name, cd in pairs(AB.cooldowns) do cd:Update() end

    for name, bar in pairs(AB.cooldownBars) do
        if AB.config.cooldownBars[name] then
            bar:Update()
            bar.Mover:Unlock()
        else
            bar:Hide()
            bar.Mover:Lock(true)
            AB.cooldownBars[name] = nil
        end
    end
end

function AB:OnSettingChanged(setting)
    for name, config in pairs(AB.config.cooldownBars) do
        local bar = AB.cooldownBars[name]
        if not bar then bar = AB:CreateCooldownBar(name, config) end
        bar:Configure()
    end
end

function AB:BAG_UPDATE_COOLDOWN() AB:ScanBags() end

function AB:ACTIONBAR_UPDATE_COOLDOWN() AB:ScanActions() end

function AB:PET_BAR_UPDATE_COOLDOWN() AB:ScanPetActions() end

function AB:PLAYER_DEAD() AB:ScanResTimer() end

function AB:SPELL_UPDATE_COOLDOWN() AB:ScanSpellBook() end

function AB:UNIT_INVENTORY_CHANGED() AB:ScanWeaponEnchants() end

function AB:ScanBags()
    local _, spell, start, duration, texture
    local id
    local enabled
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            id = GetContainerItemID(bag, slot)
            AB:CheckItemCooldown(id)
        end
    end
end

function AB:ScanActions()
    local _, name, start, duration, enabled, texture
    local actionType, id
    local enabled
    for i = 1, 120 do
        actionType, id, subType = GetActionInfo(i)
        if actionType == "item" then
            AB:CheckItemCooldown(id)
        elseif actionType == "spell" then
            AB:CheckSpellCooldown(id)
        end
    end
    for i = 1, 19 do
        id = GetInventoryItemID("player", i)
        AB:CheckItemCooldown(id)
    end
end

function AB:ScanPetActions() for id = 1, 10 do AB:CheckPetCooldown(id) end end

function AB:ScanResTimer()
    local resTimer = GetCorpseRecoveryDelay()
    if resTimer > 0 then AB:AddCooldown(RES_TIMER, nil, GetTime(), resTimer, "Interface\\Icons\\Ability_Creature_Cursed_02", COOLDOWN_TYPES.RES_TIMER) end
end

function AB:ScanSpellBook()
    for i = 1, GetNumSpellTabs() do
        local _, _, offset, numSlots = GetSpellTabInfo(i)
        for j = offset + 1, offset + numSlots do
            local id = select(2, GetSpellBookItemInfo(j, BOOKTYPE_SPELL))
            AB:CheckSpellCooldown(id)
        end
    end
end

function AB:ScanWeaponEnchants()
    local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges, hasThrownEnchant, thrownExpiration, thrownCharges = GetWeaponEnchantInfo()

    if hasMainHandEnchant then
        local texture = GetInventoryItemTexture("player", select(1, GetInventorySlotInfo("MainHandSlot")))
        AB:AddCooldown(WEAPON_ENCHANT_MAIN, nil, GetTime(), mainHandExpiration / 1000, texture, COOLDOWN_TYPES.WEAPON_ENCHANT)
    elseif AB.cooldowns[WEAPON_ENCHANT_MAIN] then
        AB.cooldowns[WEAPON_ENCHANT_MAIN]:Update()
    end
    if hasOffHandEnchant and offHandExpiration then
        local texture = GetInventoryItemTexture("player", select(1, GetInventorySlotInfo("SecondaryHandSlot")))
        AB:AddCooldown(WEAPON_ENCHANT_OFFHAND, nil, GetTime(), offHandExpiration / 1000, texture, COOLDOWN_TYPES.WEAPON_ENCHANT)
    elseif AB.cooldowns[WEAPON_ENCHANT_OFFHAND] then
        AB.cooldowns[WEAPON_ENCHANT_OFFHAND]:Update()
    end
    if hasThrownEnchant and thrownExpiration then
        local texture = GetInventoryItemTexture("player", select(1, GetInventorySlotInfo("RangedSlot")))
        AB:AddCooldown(WEAPON_ENCHANT_RANGED, nil, GetTime(), thrownExpiration / 1000, texture, COOLDOWN_TYPES.WEAPON_ENCHANT)
    elseif AB.cooldowns[WEAPON_ENCHANT_RANGED] then
        AB.cooldowns[WEAPON_ENCHANT_RANGED]:Update()
    end
end

local function UpdateCooldown(cd)
    if not cd then return end

    if cd.type == COOLDOWN_TYPES.SPELL then
        local start, duration = GetSpellCooldown(cd.id)
        if duration and duration > MIN_DURATION then
            cd.start = start
            cd.duration = duration
        end
    end

    cd.timeLeft = cd.start + cd.duration - GetTime()

    if cd.enabled and (cd.timeLeft < 0.01) then
        cd.enabled = false
    elseif (not cd.enabled) and (cd.timeLeft > 0.01) then
        cd.enabled = true
    end
end

function AB:AddCooldown(name, id, start, duration, texture, type)
    if duration < MIN_DURATION then return end

    local cd = AB.cooldowns[name]
    if cd then
        cd.start = start
        cd.duration = duration
        cd.texture = texture
    else
        cd = {id = id, name = name, start = start, duration = duration, texture = texture, type = type}
        cd.Update = UpdateCooldown
        AB.cooldowns[name] = cd
    end

    cd:Update()
end

function AB:CheckItemCooldown(id)
    if id then
        local name, _, _, _, _, _, _, _, _, texture, _, classID, subclassID = GetItemInfo(id)
        if name then
            local start, duration, enabled = GetItemCooldown(id)
            if enabled then
                if classID == Enum.ItemClass.Consumable then
                    if subclassID == Enum.ItemConsumableSubclass.Potion then
                        name = "Potion"
                        texture = "Interface\\Icons\\inv_potion_137"
                    elseif subclassID == Enum.ItemConsumableSubclass.Generic then
                        name = "Stone"
                        texture = "Interface\\Icons\\INV_Stone_04"
                    end
                end
                AB:AddCooldown(name, id, start, duration, texture, COOLDOWN_TYPES.ITEM)
            end
        end
    end
end

function AB:CheckSpellCooldown(id)
    if id then
        local name, _, texture = GetSpellInfo(id)
        local start, duration, enabled = GetSpellCooldown(id)
        if enabled then AB:AddCooldown(name, id, start, duration, texture, COOLDOWN_TYPES.SPELL) end
    end
end

function AB:CheckPetCooldown(id)
    if id then
        local name, _, texture = GetPetActionInfo(id)
        if name then
            local start, duration, enabled = GetPetActionCooldown(id)
            if enabled then AB:AddCooldown(name, id, start, duration, texture, COOLDOWN_TYPES.PET) end
        end
    end
end

local function CalculateOffset(timeLeft, range) return max(0, min(1, (0.5 + log10(timeLeft * 0.5)) / (0.5 + log10(MAX_DURATION * 0.5))) * range) end

local function UpdateCooldownButton(button)
    if not button.enabled then return end

    button:SetSize(button.bar.config.iconSize, button.bar.config.iconSize)

    local width = button.bar:GetWidth()
    local range = width - button:GetWidth()
    local newOffset = CalculateOffset(button.cd.timeLeft, range)

    button.offset = button.offset and Lerp(newOffset, button.offset, 0.05) or newOffset
    if math.abs(button.offset - newOffset) <= 0.001 then button.offset = newOffset end

    button:SetPoint("LEFT", button.bar, "LEFT", button.offset, 0)

    if button.cd.timeLeft < 5 and not button.flashing then
        button:StartFlash()
    elseif button.cd.timeLeft >= 5 and button.flashing then
        button:StopFlash()
    end
end

local function CooldownButton_ShowTooltip(button)
    local timeLeft = button.cd.start + button.cd.duration - GetTime()
    local hours = floor(mod(timeLeft, 86400) / 3600)
    local minutes = floor(mod(timeLeft, 3600) / 60)
    local seconds = floor(mod(timeLeft, 60))

    local text
    if hours > 0 then
        text = string.format("%s: %.0fh %.0fm %.0fs.", button.cd.name, hours, minutes, seconds)
    elseif minutes > 0 then
        text = string.format("%s: %.0fm %.0fs.", button.cd.name, minutes, seconds)
    elseif timeLeft > 2.5 then
        text = string.format("%s: %.0f second(s).", button.cd.name, seconds)
    else
        text = string.format("%s: %.1f second(s).", button.cd.name, timeLeft)
    end
    if button.tooltip ~= text then
        button.tooltip = text
        _G.GameTooltip:SetOwner(button, "ANCHOR_TOPLEFT")
        _G.GameTooltip:SetText(string.format("|T%s:20:20:0:0:64:64:5:59:5:59:%d|t %s", button.cd.texture, 40, button.tooltip))
        _G.GameTooltip:Show()
    end
end

local function CooldownButton_StartFlash(button)
    button.flashing = 1
    button.flashtime = 0
end

local function CooldownButton_StopFlash(button)
    button.flashing = 0
    button.Flash:Hide()
end

local function CooldownButton_OnEnter(button) button.mouseOver = true end

local function CooldownButton_OnLeave(button)
    button.mouseOver = false
    _G.GameTooltip:Hide()
end

local function CooldownButton_OnUpdate(button, elapsed)
    if button.flashing == 1 then
        local flashtime = button.flashtime
        flashtime = flashtime - elapsed

        if (flashtime <= 0) then
            local overtime = -flashtime
            if (overtime >= ATTACK_BUTTON_FLASH_TIME) then overtime = 0 end
            flashtime = ATTACK_BUTTON_FLASH_TIME - overtime

            local flashTexture = button.Flash
            if (flashTexture:IsShown()) then
                flashTexture:Hide()
            else
                flashTexture:Show()
            end
        end

        button.flashtime = flashtime
    end

    if button.mouseOver then button:ShowTooltip() end
end

local function CreateCooldownButton(bar, cd)
    local button = CreateFrame("Button", bar:GetName() .. "_" .. cd.name, bar, "ActionButtonTemplate")
    button.bar = bar
    button.cd = cd
    button.Update = UpdateCooldownButton

    button.icon:SetTexture(cd.texture)
    button.Flash:SetTexture([[Interface\Buttons\UI-Quickslot-Depress]]) -- Interface\Buttons\UI-QuickslotRed
    button.enabled = false
    button.Enable = function(self)
        if not self.enabled then
            self.enabled = true
            self.offset = 0
            self:Show()
        end
        CooldownFrame_Set(self.cooldown, self.cd.start, self.cd.duration, true)
        self.cooldown:SetSwipeColor(0, 0, 0)
        self:Update()
    end
    button.Disable = function(self)
        self.enabled = false
        self:Hide()
    end

    button.ShowTooltip = CooldownButton_ShowTooltip
    button.StartFlash = CooldownButton_StartFlash
    button.StopFlash = CooldownButton_StopFlash

    button:SetScript("OnEnter", CooldownButton_OnEnter)
    button:SetScript("OnLeave", CooldownButton_OnLeave)
    button:SetScript("OnUpdate", CooldownButton_OnUpdate)

    R.Modules.ButtonStyles:StyleActionButton(button)

    bar.buttons[cd.name] = button
    return button
end

local function UpdateCooldownBar(bar)
    if not bar then return end

    local count = 0
    local sortedButtons = {}
    for name, cd in pairs(AB.cooldowns) do
        local button = bar.buttons[cd.name]
        if cd.enabled then
            if not button then button = bar:CreateButton(cd) end
            button:Enable()
            button:Update()

            table.insert(sortedButtons, button)

            count = count + 1
        elseif button.enabled then
            button:Disable()
        end
    end

    if count > 1 then
        table.sort(sortedButtons, function(a, b) return a.cd.timeLeft > b.cd.timeLeft end)

        local baseFrameLevel = bar:GetFrameLevel()
        local frameLevel
        for _, button in pairs(sortedButtons) do
            frameLevel = (frameLevel or baseFrameLevel) + 4
            button:SetFrameLevel(frameLevel)
            if button.icon.backdrop and button.icon.backdrop.border then button.icon.backdrop.border:SetFrameLevel(frameLevel + 1) end
        end
    end

    bar:SetShown(count > 0)

    R:CreateFader(bar, bar.config.fader, bar.buttons)
end

local function ConfigureCooldownBar(bar)
    if not bar then return end

    bar:SetSize(unpack(bar.config.size))
    R:SetPoint(bar, bar.config.point)
    bar.Backdrop:SetShown(bar.config.backdrop)
    bar.Border:SetShown(bar.config.border)
    bar.Shadow:SetShown(bar.config.shadow)

    local labels = bar.config.showLabels and (bar.config.labels or AB.DEFAULT_COOLDOWN_LABELS) or {}
    for i, time in ipairs(labels) do
        local label = bar.labels[i]
        if not label then
            label = CreateFrame("Frame", nil, bar)

            label.text = label:CreateFontString(nil, "OVERLAY")
            label.text:SetAllPoints()
            label.text:SetJustifyH("CENTER")
            label.text:SetJustifyV("CENTER")
            label.text:SetShadowOffset(1, -1)
            label.text:SetFont(_G.STANDARD_TEXT_FONT, 11)
            label.text:SetTextColor(0.5, 0.5, 0.5)

            label.indicator = label:CreateTexture(nil, "BACKGROUND")
            label.indicator:SetTexture(R.media.textures.blank)
            label.indicator:SetPoint("TOP", label, "TOP", 0, -1)
            label.indicator:SetPoint("BOTTOM", label, "BOTTOM", 0, 1)
            label.indicator:SetWidth(1)
            label.indicator:SetVertexColor(0.5, 0.5, 0.5)
            label.indicator:SetAlpha(0.5)
        end
        label:Show()

        local minutes = math.floor(time / 60)
        local seconds = time % 60
        local text
        if minutes > 0 and seconds > 0 then
            text = string.format("%.0fm %.0fs", minutes, seconds)
        elseif minutes > 0 then
            text = string.format("%.0fm", minutes)
        elseif seconds > 0 then
            text = string.format("%.0fs", seconds)
        end
        label.text:SetText(text)

        label:SetSize(bar.config.size[2], 24)
        label:SetPoint("CENTER", bar, "LEFT", math.floor(CalculateOffset(time, bar:GetWidth())), 0)

        bar.labels[i] = label
    end

    for i, label in ipairs(bar.labels) do if not labels[i] then label:Hide() end end
end

function AB:CreateCooldownBar(name, config)
    local bar = CreateFrame("Frame", addonName .. "_" .. name, UIParent)
    R:CreateBackdrop(bar, {bgFile = R.media.textures.blank})
    R:CreateBorder(bar)
    R:CreateShadow(bar)

    bar.config = config
    bar.buttons = {}
    bar.labels = {}
    bar.CreateButton = CreateCooldownButton
    bar.Configure = ConfigureCooldownBar
    bar.Update = UpdateCooldownBar

    R:CreateFader(bar, bar.config.fader, bar.buttons)
    R:CreateMover(bar, addonName .. "_" .. name, AB.defaults.cooldownBars[name].point)
    bar:Configure()
    bar:Update()

    return bar
end
