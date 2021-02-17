local addonName, ns = ...
local R = _G.ReduxUI
local BS = R.Modules.ButtonStyles

function BS:StyleMicroButton(button)
    if not button then
        return
    end
    if button.__styled then
        return
    end
    local buttonName = button:GetName()

    local config = BS.config.microMenu

    button.__styled = true
end

function BS:StyleAllMicroButtons()
    for _, buttonName in next, MICRO_BUTTONS do
        BS:StyleMicroButton(_G[buttonName])
    end
end