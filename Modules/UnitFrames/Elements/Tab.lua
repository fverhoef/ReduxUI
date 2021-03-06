local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateTab()
    self.Tab = {}
    local tabCoordTable = {[1] = {0.1875, 0.53125, 0, 1}, [2] = {0.53125, 0.71875, 0, 1}, [3] = {0, 0.1875, 0, 1}}

    for i = 1, 3 do
        self.Tab[i] = self:CreateTexture("$parentTabPart" .. i, "BACKGROUND")
        self.Tab[i]:SetTexture(R.media.textures.unitFrames.groupIndicator)
        self.Tab[i]:SetTexCoord(unpack(tabCoordTable[i]))
        self.Tab[i]:SetSize(24, 18)
        self.Tab[i]:SetAlpha(0.5)
    end

    self.Tab[1]:SetPoint("BOTTOM", self.Health, "TOP", 0, 1)
    self.Tab[2]:SetPoint("LEFT", self.Tab[1], "RIGHT")
    self.Tab[3]:SetPoint("RIGHT", self.Tab[1], "LEFT")

    self.Tab[4] = self:CreateFontString("$parentTabText", "OVERLAY")
    self.Tab[4]:SetFont(UF.config.font, 11)
    self.Tab[4]:SetShadowOffset(1, -1)
    self.Tab[4]:SetPoint("BOTTOM", self.Tab[1], 0, 2)
    self.Tab[4]:SetAlpha(0.5)

    self.Tab[4]:SetText(text)
    local width = self.Tab[4]:GetStringWidth()
    self.Tab[1]:SetWidth((width < 5 and 50) or width + 4)

    self.Tab.FadeIn = function(_, alpha, alpha2)
        UIFrameFadeIn(self.Tab[1], 0.15, self.Tab[1]:GetAlpha(), alpha)
        UIFrameFadeIn(self.Tab[2], 0.15, self.Tab[2]:GetAlpha(), alpha)
        UIFrameFadeIn(self.Tab[3], 0.15, self.Tab[3]:GetAlpha(), alpha)
        UIFrameFadeIn(self.Tab[4], 0.15, self.Tab[4]:GetAlpha(), alpha2 or alpha)
    end

    self.Tab.FadeOut = function(_, alpha, alpha2)
        UIFrameFadeOut(self.Tab[1], 0.15, self.Tab[1]:GetAlpha(), alpha)
        UIFrameFadeOut(self.Tab[2], 0.15, self.Tab[2]:GetAlpha(), alpha)
        UIFrameFadeOut(self.Tab[3], 0.15, self.Tab[3]:GetAlpha(), alpha)
        UIFrameFadeOut(self.Tab[4], 0.15, self.Tab[4]:GetAlpha(), alpha2 or alpha)
    end

    UF.UpdateTab(self)
end

oUF:RegisterMetaFunction("CreateTab", UF.CreateTab)

function UF:UpdateTab()
    if not self.Tab then
        return
    end
    if not IsInRaid() then
        self.Tab:FadeOut(0)
        return
    end

    local numGroupMembers = GetNumGroupMembers()
    for i = 1, MAX_RAID_MEMBERS do
        if i <= numGroupMembers then
            local unitName, _, groupNumber = GetRaidRosterInfo(i)
            if unitName == UnitName("player") then
                self.Tab:FadeIn(0.5, 0.65)
                self.Tab[4]:SetText(GROUP .. " " .. groupNumber)
                self.Tab[1]:SetWidth(self.Tab[4]:GetStringWidth() + 4)
            end
        end
    end
end

oUF:RegisterMetaFunction("UpdateTab", UF.UpdateTab)