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

    local buttonName = button:GetName()
    local config = BS.config.auras

    local border = _G[buttonName .. "Border"] or button.Border
    if border then
        border:Hide()
        button.Border = nil
    end

    button:CreateBorder(config.borderSize)
    button.Border:SetTexture(BS.config.borders.texture)
    button.Border:SetVertexColor(BS.config.borders.color)
    button:CreateShadow()
    button:CreateGlossOverlay(nil, nil, nil, 0, 0, -1, 0)

    local icon = _G[buttonName .. "Icon"]
    if icon then
        icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        icon:SetInside(button, 3, 3)
    end

    local overlay = CreateFrame("Frame", nil, button)
    overlay:SetAllPoints()

    local count = _G[buttonName .. "Count"]
    if count then
        count:SetParent(overlay)
        count:SetFont(config.font, config.fontSize, config.fontOutline)
    end

    local duration = _G[buttonName .. "Duration"]
    if duration then
        duration:SetParent(overlay)
        duration:SetFont(config.font, config.fontSize, config.fontOutline)
    end

    local symbol = button.symbol
    if symbol then
        symbol:SetParent(overlay)
        symbol:SetFont(config.font, config.fontSize, config.fontOutline)
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

    local borderColor = BS.config.borders.color
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
    button.Border:SetVertexColor(unpack(borderColor))
end

function BS:UpdateAllAuraButtons()
    local config = BS.config.auras
    for button in pairs(BS.auraButtons) do
        local buttonName = button:GetName()

        button.Border:SetTexture(BS.config.borders.texture)
        button.Border:SetVertexColor(BS.config.borders.color)

        local count = _G[buttonName .. "Count"]
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

        button.Gloss:SetShown(config.glow)

        BS:UpdateAuraButton(button)
    end
end

function BS:BuffFrame_Update()
    local button
    for i = 1, BUFF_MAX_DISPLAY do
        button = _G["BuffButton" .. i]
        if button then
            button.isBuff = true
            button.buffType = select(4, UnitAura("player", i, "HELPFUL"))
            BS:StyleAuraButton(button)
        end
    end
    for i = 1, DEBUFF_MAX_DISPLAY do
        button = _G["DebuffButton" .. i]
        if button then
            button.isDebuff = true
            button.debuffType = select(4, UnitAura("player", i, "HARMFUL"))
            BS:StyleAuraButton(button)
        end
    end
    for i = 1, NUM_TEMP_ENCHANT_FRAMES do
        button = _G["TempEnchant" .. i]
        button.isTempEnchant = true
        BS:StyleAuraButton(button)
    end
end
