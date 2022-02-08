local addonName, ns = ...
local R = _G.ReduxUI
local SS = R:AddModule("ScreenSaver", "AceEvent-3.0")
local L = R.L

local CAMERA_SPEED = 0.035
local ignoreKeys = {LALT = true, LSHIFT = true, RSHIFT = true}
local printKeys = {PRINTSCREEN = true}

if IsMacClient() then printKeys[_G.KEY_PRINTSCREEN_MAC] = true end

function SS:Initialize()
    if not SS.config.enabled then return end

    local config = SS.config

    SS.Canvas = CreateFrame("Frame", addonName .. "ScreenSaverCanvas")
    SS.Canvas:SetFrameLevel(1)
    SS.Canvas:SetScale(_G.UIParent:GetScale())
    SS.Canvas:SetAllPoints(_G.UIParent)
    SS.Canvas:SetAlpha(0)
    SS.Canvas:Hide()

    SS.Canvas.Bottom = CreateFrame("Frame", nil, SS.Canvas, BackdropTemplateMixin and "BackdropTemplate")
    SS.Canvas.Bottom:SetFrameLevel(0)
    SS.Canvas.Bottom:SetPoint("BOTTOM", SS.Canvas, "BOTTOM", 0, 0)
    SS.Canvas.Bottom:SetWidth(GetScreenWidth())
    SS.Canvas.Bottom:SetHeight(GetScreenHeight() * (1 / 10))
    SS.Canvas.Bottom:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", tile = false, tileEdge = false, tileSize = 16, edgeSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}})
    SS.Canvas.Bottom:SetBackdropColor(0.08, 0.08, 0.1, 0.92)

    SS.Canvas.Bottom.Faction = SS.Canvas.Bottom:CreateTexture(nil, "OVERLAY")
    SS.Canvas.Bottom.Faction:SetPoint("BOTTOMLEFT", SS.Canvas.Bottom, "BOTTOMLEFT", -20, -16)
    SS.Canvas.Bottom.Faction:SetTexture(format([[Interface\Timer\%s-Logo]], R.PlayerInfo.faction))
    SS.Canvas.Bottom.Faction:SetSize(140, 140)

    local classColor = _G.RAID_CLASS_COLORS[R.PlayerInfo.class]
    SS.Canvas.Bottom.Name = SS.Canvas.Bottom:CreateFontString(nil, "OVERLAY")
    SS.Canvas.Bottom.Name:SetFont(config.font, config.fontSize or 13, config.fontOutline or "OUTLINE")
    SS.Canvas.Bottom.Name:SetShadowOffset(config.fontShadow and 1 or 0, config.fontShadow and -1 or 0)
    SS.Canvas.Bottom.Name:SetFont(unpack(config.font))
    SS.Canvas.Bottom.Name:SetFormattedText("%s-%s", R.PlayerInfo.name, R.PlayerInfo.realm)
    SS.Canvas.Bottom.Name:SetPoint("TOPLEFT", SS.Canvas.Bottom.Faction, "TOPRIGHT", -10, -28)
    SS.Canvas.Bottom.Name:SetTextColor(classColor.r, classColor.g, classColor.b)

    SS.Canvas.Bottom.Guild = SS.Canvas.Bottom:CreateFontString(nil, "OVERLAY")
    SS.Canvas.Bottom.Guild:SetFont(config.font, config.fontSize or 13, config.fontOutline or "OUTLINE")
    SS.Canvas.Bottom.Guild:SetShadowOffset(config.fontShadow and 1 or 0, config.fontShadow and -1 or 0)
    SS.Canvas.Bottom.Guild:SetText(L["No Guild"])
    SS.Canvas.Bottom.Guild:SetPoint("TOPLEFT", SS.Canvas.Bottom.Name, "BOTTOMLEFT", 0, -6)
    SS.Canvas.Bottom.Guild:SetTextColor(0.7, 0.7, 0.7)

    SS.Canvas.Bottom.Time = SS.Canvas.Bottom:CreateFontString(nil, "OVERLAY")
    SS.Canvas.Bottom.Time:SetFont(config.font, config.fontSize or 13, config.fontOutline or "OUTLINE")
    SS.Canvas.Bottom.Time:SetShadowOffset(config.fontShadow and 1 or 0, config.fontShadow and -1 or 0)
    SS.Canvas.Bottom.Time:SetText("00:00")
    SS.Canvas.Bottom.Time:SetPoint("TOPLEFT", SS.Canvas.Bottom.Guild, "BOTTOMLEFT", 0, -6)
    SS.Canvas.Bottom.Time:SetTextColor(0.7, 0.7, 0.7)

    SS.Canvas.Bottom.ModelHolder = CreateFrame("Frame", nil, SS.Canvas.Bottom)
    SS.Canvas.Bottom.ModelHolder:SetSize(150, 150)
    SS.Canvas.Bottom.ModelHolder:SetPoint("BOTTOMRIGHT", SS.Canvas.Bottom, "BOTTOMRIGHT", -200, 220)

    SS.Canvas.Bottom.Model = CreateFrame("PlayerModel", "ScreenSaverPlayerModel", SS.Canvas.Bottom.ModelHolder)
    SS.Canvas.Bottom.Model:SetPoint("CENTER", SS.Canvas.Bottom.ModelHolder, "CENTER")
    SS.Canvas.Bottom.Model:SetSize(GetScreenWidth() * 2, GetScreenHeight() * 2)
    SS.Canvas.Bottom.Model:SetCamDistanceScale(4.5)
    SS.Canvas.Bottom.Model:SetFacing(6)

    SS:Toggle()

    SS:RegisterEvent("PLAYER_FLAGS_CHANGED", SS.OnEvent)
    SS:RegisterEvent("PLAYER_ENTERING_WORLD", SS.OnEvent)
    SS:RegisterEvent("PLAYER_LEAVING_WORLD", SS.OnEvent)
    SS:RegisterEvent("PLAYER_LOGIN", SS.OnEvent)
    SS:RegisterEvent("PLAYER_REGEN_DISABLED", SS.OnEvent)
    SS:RegisterEvent("UPDATE_BATTLEFIELD_STATUS", SS.OnEvent)
end

function SS:OnEvent() SS:Toggle() end

function SS:OnKeyDown(key)
    if ignoreKeys[key] then return end

    if printKeys[key] then
        Screenshot()
    else
        SS:Hide()
        SS:ScheduleTimer("OnEvent", 60)
    end
end

function SS:OnUpdateModel()
    local model = self
    if SS.isActive and not model.isIdle then
        local timePassed = GetTime() - model.startTime
        if timePassed > model.duration then
            model:SetAnimation(0)
            model.isIdle = true
            SS.animTimer = SS:ScheduleTimer("LoopAnimations", model.idleDuration)
        end
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
    if SS.isActive then return end

    SS.isActive = true

    MoveViewLeftStart(CAMERA_SPEED)
    SS.Canvas:Show()
    SS.Canvas:EnableKeyboard(true)
    SS.Canvas:SetScript("OnKeyDown", SS.OnKeyDown)
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
    SS.Canvas.Bottom.Model:SetScript("OnUpdate", SS.OnUpdateModel)
    SS.startTime = GetTime()

    SS.timer = SS:ScheduleRepeatingTimer("UpdateTimer", 1)
    SS.Canvas:FadeIn(1, 0, 1)

    SetCVar("autoClearAFK", "1")
end

function SS:Hide()
    if not SS.isActive then return end
    if InCombatLockdown() or CinematicFrame:IsShown() or MovieFrame:IsShown() then return end

    SS.isActive = false

    MoveViewLeftStop()
    SS.Canvas:Hide()
    SS.Canvas:EnableKeyboard(false)
    SS.Canvas:SetScript("OnKeyDown", nil)
    SS.Canvas.Bottom.Model:SetScript("OnUpdate", nil)
    _G.UIParent:Show()

    SS:CancelTimer(SS.timer)
    SS.timer = nil
    UIFrameFadeOut(SS.Canvas, 0.2, 1, 0)
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
