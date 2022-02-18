local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles

BS.auraButtons = {}

function BS:StyleAuraButton(button)
    if not button then
        return
    end
    if BS.masque then
        if button.isDebuff then
            BS.masqueGroups.debuffs:AddButton(button)
        elseif button.isTempEnchant then
            BS.masqueGroups.tempEnchants:AddButton(button)
        else
            BS.masqueGroups.buffs:AddButton(button)
        end
        return
    end
    if button.__styled then
        BS:UpdateAuraButton(button)
        return
    end

    local buttonName = button:GetName() or "NIL"
    local config = BS.config.auras

    local border = _G[buttonName .. "Border"] or button.Border
    if border then
        border:Hide()
        button.Border = nil
    end

    R:CreateBorder(button, nil, nil, 0)
    --R:CreateShadow(button)
    --button:CreateGlossOverlay(nil, nil, nil, 0, 0, -1, 0)

    local icon = _G[buttonName .. "Icon"] or button.icon
    if icon then
        icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        R:SetInside(icon, button, 3, 3)
    end

    local overlay = CreateFrame("Frame", nil, button)
    overlay:SetAllPoints()

    local count = _G[buttonName .. "Count"] or button.count
    if count then
        count:SetParent(overlay)
    end

    local duration = _G[buttonName .. "Duration"]
    if duration then
        duration:SetParent(overlay)
    end

    local symbol = button.symbol
    if symbol then
        symbol:SetParent(overlay)
    end

    local cooldown = _G[buttonName .. "Cooldown"] or button.cd
    if cooldown then
        cooldown:SetParent(overlay)
        R:SetInside(cooldown, button, 1, 1)
    end

    BS.auraButtons[button] = true
    button.__styled = true

    BS:UpdateAuraButton(button)
end

function BS:UpdateAuraButton(button)
    if not button then
        return
    end
    if not button.__styled then
        BS:StyleAuraButton(button)
        return
    end
    
    local config = BS.config.auras
    local buttonName = button:GetName() or "NIL"

    local count = _G[buttonName .. "Count"] or button.count
    if count then
        count:SetFont(config.font, config.fontSize, config.fontOutline)
    end

    local duration = _G[buttonName .. "Duration"]
    if duration then
        duration:SetFont(config.font, config.fontSize, config.fontOutline)
    end

    local symbol = button.symbol
    if symbol then
        symbol:SetFont(config.font, config.fontSize, config.fontOutline)
    end

    local borderColor = BS.config.colors.border
    if button.isDebuff then
        local debuffColor = _G.DebuffTypeColor[(button.debuffType or "none")]
        if debuffColor then
            borderColor = {debuffColor.r, debuffColor.g, debuffColor.b, debuffColor.a or 1}
        end
    end
    if button.isTempEnchant then
        local quality = GetInventoryItemQuality("player", button:GetID())
        if quality and quality > 1 then
            borderColor = {GetItemQualityColor(quality)}
        end
    end
    
    button.Border:SetBackdropBorderColor(unpack(borderColor))

    --button.Gloss:SetShown(config.gloss)
end

function BS:UpdateAllAuraButtons()
    for button in pairs(BS.auraButtons) do
        BS:UpdateAuraButton(button)
    end
end

function BS:BuffFrame_Update()
    local button
    for i = 1, _G.BUFF_MAX_DISPLAY do
        button = _G["BuffButton" .. i]
        if button then
            button.isBuff = true
            button.buffType = select(4, UnitAura("player", i, "HELPFUL"))
            BS:StyleAuraButton(button)
        end
    end
    for i = 1, _G.DEBUFF_MAX_DISPLAY do
        button = _G["DebuffButton" .. i]
        if button then
            button.isDebuff = true
            button.debuffType = select(4, UnitAura("player", i, "HARMFUL"))
            BS:StyleAuraButton(button)
        end
    end
    for i = 1, _G.NUM_TEMP_ENCHANT_FRAMES do
        button = _G["TempEnchant" .. i]
        button.isTempEnchant = true
        BS:StyleAuraButton(button)
    end
end
