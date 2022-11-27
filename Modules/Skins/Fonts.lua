local addonName, ns = ...
local R = _G.ReduxUI
local S = R.Modules.Skins

function S:UpdateBlizzardFonts()
    if not S.config.fonts.enabled then return end

    DAMAGE_TEXT_FONT = S.config.fonts.damage
    UNIT_NAME_FONT = S.config.fonts.unitName

    local fontFace, height, flags = ChatBubbleFont:GetFont()
    ChatBubbleFont:SetFont(S.config.fonts.chatBubble, height, flags)
end
