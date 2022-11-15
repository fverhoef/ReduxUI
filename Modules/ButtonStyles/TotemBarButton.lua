local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles

BS.totemBarButtons = {}

local ELEMENTS = { "EARTH", "FIRE", "WATER", "AIR", "SUMMON", "RECALL" }

function BS:StyleTotemBarButton(button, element)
    if not button then
        return
    end
    if BS.masque then
        BS.masqueGroups.totemBarButtons:AddButton(button)
        return
    end

    local buttonName = button:GetName()
    local config = BS.config.totemBarButtons

    local icon = _G[buttonName .. "Icon"] or _G[buttonName .. "IconTexture"] or button.icon

    if not button.__styled then
        button.__styled = true
        BS.totemBarButtons[button] = true

        button.element = ELEMENTS[element]

        if icon then
            button.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
            button.icon:SetInside(button, 2, 2)
        end

        local cooldown = _G[buttonName .. "Cooldown"]
        if cooldown then
            cooldown:SetFrameLevel(cooldown:GetParent():GetFrameLevel())
            cooldown:SetInside(button, 1, 1)
            cooldown:SetSwipeColor(0, 0, 0)
        end

        if button.overlayTex then
            button.overlayTex:SetTexture(R.media.textures.buttons.border)
            button.overlayTex:SetOutside(button, 3, 3)
        end
        
        local highlight = _G[buttonName .. "Highlight"]
        if highlight then
            highlight:SetTexture(R.media.textures.buttons.border)
            highlight:SetTexCoord(0, 1, 0, 1)
            highlight:SetVertexColor(unpack(config.colors[button.element]))
            highlight:SetOutside(button, 3, 3)
        end
    end

    if icon then
        icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    end
    if button.overlayTex then
        button.overlayTex:SetTexCoord(0, 1, 0, 1)
        button.overlayTex:SetVertexColor(unpack(config.colors[button.element]))
    end
end

function BS:StyleAllTotemBarButtons()
    for i = 1, 4 do
        BS:StyleTotemBarButton(_G["MultiCastSlotButton" .. i], i)
    end

    for i = 1, 3 do
        for j = 1, 4 do
            BS:StyleTotemBarButton(_G["MultiCastActionButton" .. (j + (i - 1) * 4)], j)
        end
    end

    BS:SecureHook("MultiCastActionButton_Update", function(self)
        BS:StyleTotemBarButton(self)
    end)
    BS:SecureHook("MultiCastSlotButton_Update", function(self)
        BS:StyleTotemBarButton(self)
    end)

    BS:StyleTotemBarButton(MultiCastSummonSpellButton, 5)
    BS:StyleTotemBarButton(MultiCastRecallSpellButton, 6)
end

function BS:UpdateAllTotemBarButtons()
    for button in pairs(BS.totemBarButtons) do
        BS:StyleTotemBarButton(button)
    end
end
