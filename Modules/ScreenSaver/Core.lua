local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local SS = Addon.Modules.ScreenSaver
local L = Addon.L

function SS:OnEnable()
    local config = SS.config.db.profile

    SS.Canvas = CreateFrame("Frame", nil, UIParent)
    SS.Canvas:SetFrameStrata("FULLSCREEN")
    SS.Canvas:SetAllPoints()
    SS.Canvas.height = SS.Canvas:GetHeight()
    --SS.Canvas:EnableMouse(true)
    SS.Canvas:SetAlpha(0)
    SS.Canvas:Hide()
    Addon:CreateFrameFader(SS.Canvas, config.fader)

    SS.Canvas.Background = SS.Canvas:CreateTexture(nil, "BACKGROUND", nil, -8)
    SS.Canvas.Background:SetColorTexture(1, 1, 1)
    SS.Canvas.Background:SetVertexColor(0, 0, 0, 1)
    SS.Canvas.Background:SetAllPoints()
    --SS.Canvas.Background:Hide()

    SS.Canvas.Galaxy = CreateFrame("PlayerModel", nil, SS.Canvas)
    SS.Canvas.Galaxy:SetAllPoints()

    SS.Canvas.Model = CreateFrame("PlayerModel", nil, SS.Canvas.Galaxy)
    SS.Canvas.Model:SetSize(SS.Canvas.height, SS.Canvas.height * 1.5)
    SS.Canvas.Model:SetPoint("BOTTOMRIGHT", SS.Canvas.height * 0.25, -SS.Canvas.height * 0.5)

    SS.Canvas.Gradient = SS.Canvas.Model:CreateTexture(nil, "BACKGROUND", nil, -7)
    SS.Canvas.Gradient:SetColorTexture(1, 1, 1)
    SS.Canvas.Gradient:SetVertexColor(0, 0, 0, 1)
    SS.Canvas.Gradient:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
    SS.Canvas.Gradient:SetPoint("BOTTOMLEFT", SS.Canvas)
    SS.Canvas.Gradient:SetPoint("BOTTOMRIGHT", SS.Canvas)
    SS.Canvas.Gradient:SetHeight(100)

    local button = CreateFrame("Button", AddonName .. "ScreenSaverCloseButton", SS.Canvas.Model, "UIPanelButtonTemplate")
    button.text = _G[button:GetName() .. "Text"]
    button.text:SetText(L["Close"])
    button:SetWidth(button.text:GetStringWidth() + 20)
    button:SetHeight(button.text:GetStringHeight() + 12)
    button:SetPoint("BOTTOMLEFT", SS.Canvas, 10, 10)
    button:SetAlpha(0.5)
    button:HookScript("OnClick", function(self)
        SS:Hide()
    end)

    SS:RegisterEvent("PLAYER_FLAGS_CHANGED", SS.OnEvent)
    SS:RegisterEvent("PLAYER_ENTERING_WORLD", SS.OnEvent)
    SS:RegisterEvent("PLAYER_LEAVING_WORLD", SS.OnEvent)
    SS:RegisterEvent("PLAYER_LOGIN", SS.OnEvent)
end

function SS:OnEvent()
    local event = self
    if event == "PLAYER_LOGIN" then
        SS.Canvas.Model:SetUnit("player")
        SS.Canvas.Model:SetRotation(math.rad(-110))
        SS.Canvas.Galaxy:SetDisplayInfo(67918)
        SS.Canvas.Galaxy:SetCamDistanceScale(2.2)
        -- self.galaxy:SetRotation(math.rad(180))
        return
    end
    if UnitIsAFK("player") then
        SS:Show()
    else
        SS:Hide()
    end
end

function SS:Show()
    if SS.Canvas.isActive then
        return
    end
    SS.Canvas.isActive = true
    SS.Canvas:Show()
    Addon:StartFadeIn(SS.Canvas)
end

function SS:Hide()
    if not SS.Canvas.isActive then
        return
    end
    SS.Canvas.isActive = false
    SS.Canvas:Hide()
    Addon:StartFadeOut(SS.Canvas)
end
