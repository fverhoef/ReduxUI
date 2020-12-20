local AddonName, AddonTable = ...
local Addon = AddonTable[1]

Addon.RegisteredShadows = {}

function Addon:CreateShadow(frame, size, pass)
    if not pass and frame.shadow then
        return
    end

    local shadow = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
    shadow:SetFrameLevel(1)
    shadow:SetFrameStrata(frame:GetFrameStrata())
    Addon:SetOutside(shadow, frame, size or 3, size or 3)
    shadow:SetBackdrop({edgeFile = Addon.media.textures.Glow, edgeSize = 3})
    shadow:SetBackdropColor(0, 0, 0, 0)
    shadow:SetBackdropBorderColor(0, 0, 0, 0.9)

    Addon.RegisteredShadows[shadow] = true

    if not pass then
        frame.shadow = shadow
    end

    return shadow
end
