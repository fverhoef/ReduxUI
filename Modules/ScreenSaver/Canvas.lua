local addonName, ns = ...
local R = _G.ReduxUI
local SS = R.Modules.ScreenSaver
local L = R.L

ScreenSaverCanvasMixin = {}

function ScreenSaverCanvasMixin:Initialize()
    self:SetScale(_G.UIParent:GetScale())
    self:SetAllPoints(_G.UIParent)
    -- self.Bottom:SetHeight(GetScreenHeight() * (1 / 10))
    self.Bottom:SetBackdrop({
        edgeFile = R.media.textures.edgeFiles.border,
        bgFile = "Interface\\Buttons\\WHITE8x8",
        tile = false,
        tileEdge = false,
        tileSize = 16,
        edgeSize = 16,
        insets = {left = 0, right = 0, top = 0, bottom = 0}
    })
    self.Bottom:SetBackdropColor(0.08, 0.08, 0.1, 0.92)

    self.ModelHolder.Model:Initialize()
end

function ScreenSaverCanvasMixin:Configure()
    local config = SS.config

    self.Bottom.Faction:SetTexture(format([[Interface\Timer\%s-Logo]], R.PlayerInfo.faction))

    local classColor = _G.RAID_CLASS_COLORS[R.PlayerInfo.class]
    self.Bottom.Name:SetFont(config.font, config.fontSize or 13, config.fontOutline or "OUTLINE")
    self.Bottom.Name:SetShadowOffset(config.fontShadow and 1 or 0, config.fontShadow and -1 or 0)
    self.Bottom.Name:SetFormattedText("%s-%s", R.PlayerInfo.name, R.PlayerInfo.realm)
    self.Bottom.Name:SetTextColor(classColor.r, classColor.g, classColor.b)

    self.Bottom.Guild:SetFont(config.font, config.fontSize or 13, config.fontOutline or "OUTLINE")
    self.Bottom.Guild:SetShadowOffset(config.fontShadow and 1 or 0, config.fontShadow and -1 or 0)
    self.Bottom.Guild:SetText(L["No Guild"])
    self.Bottom.Guild:SetTextColor(0.7, 0.7, 0.7)

    self.Bottom.Time:SetFont(config.font, config.fontSize or 13, config.fontOutline or "OUTLINE")
    self.Bottom.Time:SetShadowOffset(config.fontShadow and 1 or 0, config.fontShadow and -1 or 0)
    self.Bottom.Time:SetText("AFK for 00:00")
    self.Bottom.Time:SetTextColor(0.7, 0.7, 0.7)

    self.ModelHolder.Model:Initialize()
end

function ScreenSaverCanvasMixin:Enable()
    self:Show()
    self:EnableKeyboard(true)
    self:SetScript("OnKeyDown", ScreenSaverCanvasMixin.OnKeyDown)

    if IsInGuild() then
        local guildName, guildRankName = GetGuildInfo("player")
        self.Bottom.Guild:SetFormattedText("%s [%s]", guildName, guildRankName)
        self.Bottom.Guild:SetTextColor(0, 230 / 255, 0)
    else
        self.Bottom.Guild:SetText(L["No Guild"])
        self.Bottom.Guild:SetTextColor(0.7, 0.7, 0.7)
    end

    self.ModelHolder.Model:Enable()
    UIFrameFadeIn(self, 1, 0, 1)
end

function ScreenSaverCanvasMixin:Disable()
    self:Hide()
    self:EnableKeyboard(false)
    self:SetScript("OnKeyDown", nil)
    self.ModelHolder.Model:Disable()
    UIFrameFadeOut(self, 0.2, 1, 0)
end

function ScreenSaverCanvasMixin:UpdateTimer()
    local time = GetTime() - SS.startTime
    self.Bottom.Time:SetFormattedText("AFK for %02d:%02d", math.floor(time / 60), time % 60)
end

local ignoreKeys = {LALT = true, LSHIFT = true, RSHIFT = true}
local printKeys = {PRINTSCREEN = true}

if IsMacClient() then printKeys[_G.KEY_PRINTSCREEN_MAC] = true end

function ScreenSaverCanvasMixin:OnKeyDown(key)
    if ignoreKeys[key] then return end

    if printKeys[key] then
        Screenshot()
    else
        SS:Hide()
        SS:ScheduleTimer("OnEvent", 60)
    end
end

ScreenSaverCanvasPlayerModelMixin = {}

function ScreenSaverCanvasPlayerModelMixin:Initialize()
    self:SetSize(GetScreenWidth() * 2, GetScreenHeight() * 2)
    self:SetCamDistanceScale(4.5)
    self:SetFacing(6)
end

function ScreenSaverCanvasPlayerModelMixin:Enable()
    self.curAnimation = "wave"
    self.startTime = GetTime()
    self.duration = 2.3
    self:SetUnit("player")
    self.isIdle = nil
    self:SetAnimation(67)
    self.idleDuration = 30
    self:SetScript("OnUpdate", ScreenSaverCanvasPlayerModelMixin.OnUpdate)
end

function ScreenSaverCanvasPlayerModelMixin:Disable() self:SetScript("OnUpdate", nil) end

function ScreenSaverCanvasPlayerModelMixin:OnUpdate()
    if SS.isActive and not self.isIdle then
        local timePassed = GetTime() - self.startTime
        if timePassed > self.duration then
            self:SetAnimation(0)
            self.isIdle = true
            SS.animTimer = SS:ScheduleTimer(self.LoopAnimations, self.idleDuration, self)
        end
    end
end

function ScreenSaverCanvasPlayerModelMixin:LoopAnimations()
    if self.curAnimation == "wave" then
        self:SetAnimation(69)
        self.curAnimation = "dance"
        self.startTime = GetTime()
        self.duration = 300
        self.isIdle = false
        self.idleDuration = 120
    end
end
