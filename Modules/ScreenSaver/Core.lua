local addonName, ns = ...
local R = _G.ReduxUI
local SS = R:AddModule("ScreenSaver", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local L = R.L

local CAMERA_SPEED = 0.035
local ignoreKeys = {LALT = true, LSHIFT = true, RSHIFT = true}
local printKeys = {PRINTSCREEN = true}

if IsMacClient() then
    printKeys[_G.KEY_PRINTSCREEN_MAC] = true
end

function SS:Initialize()    
    if not R.config.db.profile.modules.screenSaver.enabled then
        return
    end

    local config = R.config.db.profile.modules.screenSaver

    SS.Canvas = CreateFrame("Frame", "ScreenSaverCanvas")
    SS.Canvas:SetFrameLevel(1)
    SS.Canvas:SetScale(_G.UIParent:GetScale())
    SS.Canvas:SetAllPoints(_G.UIParent)
    SS.Canvas:EnableKeyboard(true)
    SS.Canvas:SetScript("OnKeyDown", SS.OnKeyDown)
    SS.Canvas:Hide()

    SS.Canvas.Bottom = CreateFrame("Frame", nil, SS.Canvas, BackdropTemplateMixin and "BackdropTemplate")
    SS.Canvas.Bottom:SetFrameLevel(0)
    SS.Canvas.Bottom:SetPoint("BOTTOM", SS.Canvas, "BOTTOM", 0, 0)
    SS.Canvas.Bottom:SetWidth(GetScreenWidth())
    SS.Canvas.Bottom:SetHeight(GetScreenHeight() * (1 / 10))
    SS.Canvas.Bottom:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        tile = false,
        tileEdge = false,
        tileSize = 16,
        edgeSize = 16,
        insets = {left = 0, right = 0, top = 0, bottom = 0}
    })
    SS.Canvas.Bottom:SetBackdropColor(0.08, 0.08, 0.1, 0.92)

    SS.Canvas.Bottom.Border = SS.Canvas.Bottom:CreateTexture(nil, "OVERLAY")
    SS.Canvas.Bottom.Border:SetTexture(R.media.textures.borders.beautycase)
    SS.Canvas.Bottom.Border:SetParent(SS.Canvas.Bottom)
    SS.Canvas.Bottom.Border:SetHeight(6)
    SS.Canvas.Bottom.Border:SetTexCoord(1 / 3, 2 / 3, 0, 1 / 3)
    SS.Canvas.Bottom.Border:SetPoint("TOPLEFT", SS.Canvas.Bottom, "TOPLEFT")
    SS.Canvas.Bottom.Border:SetPoint("TOPRIGHT", SS.Canvas.Bottom, "TOPRIGHT")

    SS.Canvas.Bottom.BorderShadow = SS.Canvas.Bottom:CreateTexture(nil, "OVERLAY")
    SS.Canvas.Bottom.BorderShadow:SetTexture(R.media.textures.borders.shadow)
    SS.Canvas.Bottom.BorderShadow:SetVertexColor(0, 0, 0, 1)
    SS.Canvas.Bottom.BorderShadow:SetParent(SS.Canvas.Bottom)
    SS.Canvas.Bottom.BorderShadow:SetHeight(6)
    SS.Canvas.Bottom.BorderShadow:SetTexCoord(1 / 3, 2 / 3, 0, 1 / 3)
    SS.Canvas.Bottom.BorderShadow:SetPoint("TOPLEFT", SS.Canvas.Bottom, "TOPLEFT", 0, 2)
    SS.Canvas.Bottom.BorderShadow:SetPoint("TOPRIGHT", SS.Canvas.Bottom, "TOPRIGHT", 0, 2)

    SS.Canvas.Bottom.LogoTop = SS.Canvas:CreateTexture(nil, "OVERLAY")
    SS.Canvas.Bottom.LogoTop:SetSize(320, 150)
    SS.Canvas.Bottom.LogoTop:SetPoint("CENTER", SS.Canvas.Bottom, "CENTER", 0, 50)
    -- SS.Canvas.Bottom.LogoTop:SetTexture(E.Media.Textures.LogoTop)

    SS.Canvas.Bottom.LogoBottom = SS.Canvas:CreateTexture(nil, "OVERLAY")
    SS.Canvas.Bottom.LogoBottom:SetSize(320, 150)
    SS.Canvas.Bottom.LogoBottom:SetPoint("CENTER", SS.Canvas.Bottom, "CENTER", 0, 50)
    -- SS.Canvas.Bottom.LogoBottom:SetTexture(E.Media.Textures.LogoBottom)

    local factionGroup, size, offsetX, offsetY, nameOffsetX, nameOffsetY = R.PlayerFaction, 140, -20, -16, -10, -28

    SS.Canvas.Bottom.Faction = SS.Canvas.Bottom:CreateTexture(nil, "OVERLAY")
    SS.Canvas.Bottom.Faction:SetPoint("BOTTOMLEFT", SS.Canvas.Bottom, "BOTTOMLEFT", offsetX, offsetY)
    SS.Canvas.Bottom.Faction:SetTexture(format([[Interface\Timer\%s-Logo]], factionGroup))
    SS.Canvas.Bottom.Faction:SetSize(size, size)

    local classColor = _G.RAID_CLASS_COLORS[R.PlayerClass]
    SS.Canvas.Bottom.Name = SS.Canvas.Bottom:CreateFontString(nil, "OVERLAY")
    SS.Canvas.Bottom.Name:SetFont(unpack(config.font))
    SS.Canvas.Bottom.Name:SetFormattedText("%s-%s", R.PlayerName, R.PlayerRealm)
    SS.Canvas.Bottom.Name:SetPoint("TOPLEFT", SS.Canvas.Bottom.Faction, "TOPRIGHT", nameOffsetX, nameOffsetY)
    SS.Canvas.Bottom.Name:SetTextColor(classColor.r, classColor.g, classColor.b)

    SS.Canvas.Bottom.Guild = SS.Canvas.Bottom:CreateFontString(nil, "OVERLAY")
    SS.Canvas.Bottom.Guild:SetFont(unpack(config.font))
    SS.Canvas.Bottom.Guild:SetText(L["No Guild"])
    SS.Canvas.Bottom.Guild:SetPoint("TOPLEFT", SS.Canvas.Bottom.Name, "BOTTOMLEFT", 0, -6)
    SS.Canvas.Bottom.Guild:SetTextColor(0.7, 0.7, 0.7)

    SS.Canvas.Bottom.Time = SS.Canvas.Bottom:CreateFontString(nil, "OVERLAY")
    SS.Canvas.Bottom.Time:SetFont(unpack(config.font))
    SS.Canvas.Bottom.Time:SetText("00:00")
    SS.Canvas.Bottom.Time:SetPoint("TOPLEFT", SS.Canvas.Bottom.Guild, "BOTTOMLEFT", 0, -6)
    SS.Canvas.Bottom.Time:SetTextColor(0.7, 0.7, 0.7)

    -- Use this frame to control position of the model
    SS.Canvas.Bottom.ModelHolder = CreateFrame("Frame", nil, SS.Canvas.Bottom)
    SS.Canvas.Bottom.ModelHolder:SetSize(150, 150)
    SS.Canvas.Bottom.ModelHolder:SetPoint("BOTTOMRIGHT", SS.Canvas.Bottom, "BOTTOMRIGHT", -200, 220)

    SS.Canvas.Bottom.Model = CreateFrame("PlayerModel", "ScreenSaverPlayerModel", SS.Canvas.Bottom.ModelHolder)
    SS.Canvas.Bottom.Model:SetPoint("CENTER", SS.Canvas.Bottom.ModelHolder, "CENTER")
    SS.Canvas.Bottom.Model:SetSize(GetScreenWidth() * 2, GetScreenHeight() * 2) -- YES, double screen size. This prevents clipping of models. Position is controlled with the helper frame.
    SS.Canvas.Bottom.Model:SetCamDistanceScale(4.5) -- Since the model frame is huge, we need to zoom out quite a bit.
    SS.Canvas.Bottom.Model:SetFacing(6)
    SS.Canvas.Bottom.Model:SetScript("OnUpdate", function(model)
        if SS.isActive and not model.isIdle then
            local timePassed = GetTime() - model.startTime
            if timePassed > model.duration then
                model:SetAnimation(0)
                model.isIdle = true
                SS.animTimer = SS:ScheduleTimer("LoopAnimations", model.idleDuration)
            end
        end
    end)

    R:CreateFrameFader(SS.Canvas, config.fader)

    SS:Toggle()

    SS:RegisterEvent("PLAYER_FLAGS_CHANGED", SS.OnEvent)
    SS:RegisterEvent("PLAYER_ENTERING_WORLD", SS.OnEvent)
    SS:RegisterEvent("PLAYER_LEAVING_WORLD", SS.OnEvent)
    SS:RegisterEvent("PLAYER_LOGIN", SS.OnEvent)
    SS:RegisterEvent("PLAYER_REGEN_DISABLED", SS.OnEvent)
    SS:RegisterEvent("UPDATE_BATTLEFIELD_STATUS", SS.OnEvent)
end

function SS:OnEvent()
    SS:Toggle()
end

function SS:OnKeyDown(key)
    if ignoreKeys[key] then
        return
    end

    if printKeys[key] then
        Screenshot()
    else
        SS:Hide()
        SS:ScheduleTimer("OnEvent", 60)
    end
end

function SS:Toggle()
    if UnitIsAFK("player") then
        SS:Show()
    else
        SS:Hide()
    end
end

function SS:Show()
    if SS.isActive then
        return
    end

    SS.isActive = true

    MoveViewLeftStart(CAMERA_SPEED)
    SS.Canvas:Show()
    _G.UIParent:Hide()
    CloseAllWindows()

    if IsInGuild() then
        local guildName, guildRankName = GetGuildInfo("player")
        SS.Canvas.Bottom.Guild:SetFormattedText("%s [%s]", guildName, guildRankName)
        SS.Canvas.Bottom.Guild:SetTextColor(0, 230 / 255, 0)
    else
        SS.Canvas.Bottom.Guild:SetText(L["No Guild"])
        SS.Canvas.Bottom.Guild:SetTextColor(0.7, 0.7, 0.7)
    end

    SS.Canvas.Bottom.Model.curAnimation = "wave"
    SS.Canvas.Bottom.Model.startTime = GetTime()
    SS.Canvas.Bottom.Model.duration = 2.3
    SS.Canvas.Bottom.Model:SetUnit("player")
    SS.Canvas.Bottom.Model.isIdle = nil
    SS.Canvas.Bottom.Model:SetAnimation(67)
    SS.Canvas.Bottom.Model.idleDuration = 40
    SS.startTime = GetTime()

    SS.timer = SS:ScheduleRepeatingTimer("UpdateTimer", 1)
    R:StartFadeIn(SS.Canvas)

    SetCVar("autoClearAFK", "1")
end

function SS:Hide()
    if not SS.isActive then
        return
    end
    if InCombatLockdown() or CinematicFrame:IsShown() or MovieFrame:IsShown() then
        return
    end

    SS.isActive = false

    MoveViewLeftStop()
    SS.Canvas:Hide()
    _G.UIParent:Show()

    SS:CancelTimer(SS.timer)
    R:StartFadeOut(SS.Canvas)
end

function SS:UpdateTimer()
    local time = GetTime() - self.startTime
    SS.Canvas.Bottom.Time:SetFormattedText("%02d:%02d", floor(time / 60), time % 60)
end

function SS:LoopAnimations()
    if _G.ScreenSaverPlayerModel.curAnimation == "wave" then
        _G.ScreenSaverPlayerModel:SetAnimation(69)
        _G.ScreenSaverPlayerModel.curAnimation = "dance"
        _G.ScreenSaverPlayerModel.startTime = GetTime()
        _G.ScreenSaverPlayerModel.duration = 300
        _G.ScreenSaverPlayerModel.isIdle = false
        _G.ScreenSaverPlayerModel.idleDuration = 120
    end
end
