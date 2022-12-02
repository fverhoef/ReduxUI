local addonName, ns = ...
local R = _G.ReduxUI

local function AddApi(object)
    local mt = getmetatable(object).__index
	-- Layout
	if not object.GetNormalizedPoint then mt.GetNormalizedPoint = R.GetNormalizedPoint end
	if not object.SetNormalizedPoint then mt.SetNormalizedPoint = R.SetNormalizedPoint end
	if not object.SetNormalizedSize then mt.SetNormalizedSize = R.SetNormalizedSize end
    if not object.SetOutside then mt.SetOutside = R.SetOutside end
    if not object.SetInside then mt.SetInside = R.SetInside end
    if not object.Offset then mt.Offset = R.Offset end
	-- Artwork
    if not object.CreateBackdrop then mt.CreateBackdrop = R.CreateBackdrop end
    if not object.CreateBorder then mt.CreateBorder = R.CreateBorder end
    if not object.CreateShadow then mt.CreateShadow = R.CreateShadow end
    if not object.CreateInlay then mt.CreateInlay = R.CreateInlay end
    if not object.CreateSeparator then mt.CreateSeparator = R.CreateSeparator end
	-- Fader
    if not object.FadeIn then mt.FadeIn = R.FadeIn end
    if not object.FadeOut then mt.FadeOut = R.FadeOut end
    if not object.CreateFader then mt.CreateFader = R.CreateFader end
	-- Mover
    if not object.CreateMover then mt.CreateMover = R.CreateMover end
	-- Utilities
    --TODO: rename to something less likely to exist?
    --if not object.Disable then mt.Disable = R.Disable end
end

local handled = {Frame = true}
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

AddApi(_G.GameFontNormal) -- Add API to `CreateFont` objects without actually creating one
AddApi(CreateFrame("ScrollFrame")) -- Hacky fix for issue on 7.1 PTR where scroll frames no longer seem to inherit the methods from the 'Frame' widget
