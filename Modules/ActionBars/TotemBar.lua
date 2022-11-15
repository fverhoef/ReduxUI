local addonName, ns = ...
local R = _G.ReduxUI
local AB = R.Modules.ActionBars

local L = R.L

function AB:CreateTotemBar()
    if R.isRetail then return end

    local bar = _G.MultiCastActionBarFrame
    bar:SetParent(UIParent)
    bar:Show()
    bar.config = AB.config.totemBar
    bar.defaults = AB.defaults.totemBar

    bar:SetScript("OnShow", nil)
    bar:SetScript("OnHide", nil)
    bar:SetScript("OnUpdate", nil)

    bar.ignoreFramePositionManager = true
    bar:SetAttribute("ignoreFramePositionManager", true)
    UIPARENT_MANAGED_FRAME_POSITIONS[bar:GetName()] = nil

    bar:CreateBackdrop({ bgFile = R.media.textures.blank })
    bar:CreateBorder()
    bar:CreateShadow()
    bar:CreateMover(L["Totem Bar"], bar.defaults.point)
    bar:CreateFader(bar.config.fader)

    -- TODO: Styling
    -- TODO: KeyBound support

    return bar
end

function AB:ConfigureTotemBar()
    if R.isRetail then return end
    
    local bar = _G.MultiCastActionBarFrame

    bar:ClearAllPoints()
    bar:SetNormalizedPoint(bar.config.point)

    bar.Backdrop:SetShown(bar.config.backdrop)
    bar.Border:SetShown(bar.config.border)
    bar.Shadow:SetShown(bar.config.shadow)
    bar.Mover:Unlock()
end