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

    local buttonName = button:GetName() or "nil"
    local config = BS.config.auras

    local icon = _G[buttonName .. "Icon"] or _G[buttonName .. "IconTexture"] or button.icon
    local count = _G[buttonName .. "Count"]
    local cooldown = _G[buttonName .. "Cooldown"]
    local duration = _G[buttonName .. "Duration"]
    local symbol = button.symbol

    if not button.__styled then
        button.__styled = true
        BS.auraButtons[button] = true

        local overlay = CreateFrame("Frame", nil, button)
        overlay:SetAllPoints()
        overlay:SetFrameLevel(button:GetFrameLevel() + 1)

        if icon then
            icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
            icon:SetInside(button, 2, 2)
        end

        if count then
            count:SetParent(overlay)
        end

        if cooldown then
            cooldown:SetParent(overlay)
            cooldown:SetInside(button, 1, 1)
        end

        if duration then
            duration:SetParent(overlay)
        end

        if symbol then
            symbol:SetParent(overlay)
        end

        local border = _G[buttonName .. "Border"] or button.Border
        if border then
            border:Hide()
            button.Border = nil
        end

        local border = button:CreateTexture("OVERLAY", "$parentBorder", nil, 7)
        border:SetTexture(R.media.textures.buttons.border)
        button.Border = border
    end

    if count then
        count:SetFont(config.font, config.fontSize, config.fontOutline)
    end

    if duration then
        duration:SetFont(config.font, config.fontSize, config.fontOutline)
    end

    if symbol then
        symbol:SetFont(config.font, config.fontSize, config.fontOutline)
    end

    local borderColor = BS.config.colors.border
    if button.isDebuff then
        local debuffColor = _G.DebuffTypeColor[(button.debuffType or "none")]
        if debuffColor then
            borderColor = { debuffColor.r, debuffColor.g, debuffColor.b, debuffColor.a or 1 }
        end
    end
    if button.isTempEnchant then
        local quality = GetInventoryItemQuality("player", button:GetID())
        if quality and quality > 1 then
            borderColor = { GetItemQualityColor(quality) }
        end
    end

    local borderInset = (button:GetWidth() or 36) / 12
    button.Border:SetOutside(button, borderInset, borderInset)
    button.Border:SetVertexColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4] or 1)

    if icon then
        local iconInset = (button:GetWidth() or 36) / 18
        icon:SetInside(button, iconInset, iconInset)
    end

    if cooldown then
        local cdInset = (button:GetWidth() or 36) / 18
        cooldown:SetInside(button, cdInset, cdInset)
    end
end

function BS:UpdateAllAuraButtons()
    for button in pairs(BS.auraButtons) do
        BS:StyleAuraButton(button)
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
