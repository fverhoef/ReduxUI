local addonName, ns = ...
local R = _G.ReduxUI

local function AddApi(object)
    local mt = getmetatable(object).__index
    -- Utilities
    if not object.SetInside then mt.SetInside = R.SetInside end
    if not object.SetOutside then mt.SetOutside = R.SetOutside end
    if not object.Offset then mt.Offset = R.Offset end
    if not object.Point then mt.Point = R.SetPoint end
    if not object.DisableScripts then mt.DisableScripts = R.DisableScripts end
    -- Artwork
    if not object.CreateBackdrop then mt.CreateBackdrop = R.CreateBackdrop end
    if not object.CreateBorder then mt.CreateBorder = R.CreateBorder end
    if not object.CreateShadow then mt.CreateShadow = R.CreateShadow end
    if not object.CreateInlay then mt.CreateInlay = R.CreateInlay end
    -- Fader
    if not object.FadeIn then mt.FadeIn = R.FadeIn end
    if not object.FadeOut then mt.FadeOut = R.FadeOut end
    if not object.CreateFader then mt.CreateFader = R.CreateFader end
    if not object.LinkFader then mt.LinkFader = R.LinkFader end
    if not object.UnlinkFader then mt.UnlinkFader = R.UnlinkFader end
end

local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
AddApi(object)
AddApi(object:CreateTexture())
AddApi(object:CreateFontString())
AddApi(object:CreateMaskTexture())

object = EnumerateFrames()
while object do
    if not object:IsForbidden() and not handled[object:GetObjectType()] then
        AddApi(object)
        handled[object:GetObjectType()] = true
    end

    object = EnumerateFrames(object)
end
