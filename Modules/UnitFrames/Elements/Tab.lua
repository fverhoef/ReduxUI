local AddonName, AddonTable = ...
local Addon = AddonTable[1]
local UF = Addon.Modules.UnitFrames

UF.CreateTab = function(self)
    self.Tab = {}
    local tabCoordTable = {[1] = {0.1875, 0.53125, 0, 1}, [2] = {0.53125, 0.71875, 0, 1}, [3] = {0, 0.1875, 0, 1}}

    for i = 1, 3 do
        self.Tab[i] = self:CreateTexture("$parentTabPart" .. i, "BACKGROUND")
        self.Tab[i]:SetTexture(Addon.media.textures.GroupIndicator)
        self.Tab[i]:SetTexCoord(unpack(tabCoordTable[i]))
        self.Tab[i]:SetSize(24, 18)
        self.Tab[i]:SetAlpha(0.5)
    end

    self.Tab[1]:SetPoint("BOTTOM", self.Health, "TOP", 0, 1)
    self.Tab[2]:SetPoint("LEFT", self.Tab[1], "RIGHT")
    self.Tab[3]:SetPoint("RIGHT", self.Tab[1], "LEFT")

    self.Tab[4] = self:CreateFontString("$parentTabText", "OVERLAY")
    self.Tab[4]:SetFont(UF.config.db.profile.font, 11)
    self.Tab[4]:SetShadowOffset(1, -1)
    self.Tab[4]:SetPoint("BOTTOM", self.Tab[1], 0, 2)
    self.Tab[4]:SetAlpha(0.5)

    self.Tab[4]:SetText(text)
    local width = self.Tab[4]:GetStringWidth()
    self.Tab[1]:SetWidth((width < 5 and 50) or width + 4)

    self.Tab.FadeIn = function(_, alpha, alpha2)
        for i = 1, 4 do
            securecall("UIFrameFadeIn", self.Tab[i], 0.15, self.Tab[i]:GetAlpha(), alpha)
            securecall("UIFrameFadeIn", self.Tab[4], 0.15, self.Tab[4]:GetAlpha(), alpha2 or alpha)
        end
    end

    self.Tab.FadeOut = function(_, alpha, alpha2)
        for i = 1, 4 do
            securecall("UIFrameFadeOut", self.Tab[i], 0.15, self.Tab[i]:GetAlpha(), alpha)
            securecall("UIFrameFadeOut", self.Tab[4], 0.15, self.Tab[4]:GetAlpha(), alpha2 or alpha)
        end
    end

    UF.UpdateTab(self)
end

UF.UpdateTab = function(self)
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