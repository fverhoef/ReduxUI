local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles

BS.microButtons = {}

function BS:StyleMicroButton(button)
    if not button then
        return
    end
    if button.__styled then
        BS:UpdateMicroButton(button)
        return
    end

    local buttonName = button:GetName()
    local config = BS.config.microMenu

    BS.microButtons[button] = true
    button.__styled = true

    BS:UpdateMicroButton(button)
end

function BS:UpdateMicroButton(button)
    if not button or not button.__styled then
        return
    end
end

function BS:StyleAllMicroButtons()
    for _, buttonName in next, _G.MICRO_BUTTONS do
        BS:StyleMicroButton(_G[buttonName])
    end
end

function BS:UpdateAllMicroButtons()
    for button in pairs(BS.microButtons) do
        BS:UpdateMicroButton(button)
    end
end
