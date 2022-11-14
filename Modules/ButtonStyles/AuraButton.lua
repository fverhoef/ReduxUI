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

    if not button.__styled then
        button.__styled = true
        BS.auraButtons[button] = true

        local overlay = CreateFrame("Frame", "$parentOverlay", button)
        overlay:SetAllPoints()
        overlay:SetFrameLevel(button:GetFrameLevel() + 1)

        button.icon = _G[buttonName .. "Icon"] or button.icon
        if button.icon then
            button.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
            button.icon:SetInside(button, 2, 2)
        end

        button.count = _G[buttonName .. "Count"]
        if button.count then
            button.count:SetParent(overlay)
        end

        button.cooldown = _G[buttonName .. "Cooldown"]
        if button.cooldown then
            button.cooldown:SetParent(overlay)
            button.cooldown:SetInside(button, 1, 1)
        end

        button.duration = _G[buttonName .. "Duration"]
        if button.duration then
            button.duration:SetParent(overlay)
        end

        if button.symbol then
            button.symbol:SetParent(overlay)
        end

        local border = _G[buttonName .. "Border"] or button.Border
        if border then
            border:Hide()
            button.Border = nil
        end

        button:CreateBorder(nil, nil, 0)
        -- button:CreateShadow()
        -- button:CreateGlossOverlay(nil, nil, nil, 0, 0, -1, 0)
    end

    if button.count then
        button.count:SetFont(config.font, config.fontSize, config.fontOutline)
    end

    if button.duration then
        button.duration:SetFont(config.font, config.fontSize, config.fontOutline)
    end

    if button.symbol then
        button.symbol:SetFont(config.font, config.fontSize, config.fontOutline)
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
