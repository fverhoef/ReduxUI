local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreatePvPIndicator()
    if not self.config.pvpIndicator.enabled then
        return
    end

    self.PvPIndicator = self:CreateTexture("$parentPvPIcon", "OVERLAY", nil, 7)
    self.PvPIndicator:SetParent(self.Overlay)
    self.PvPIndicator:SetSize(40, 42)

    if self.unit == "player" then
        self.PvPTimerFrame = CreateFrame("Frame", "$parentPvPTimerFrame", self)
        self.PvPTimerFrame:SetAllPoints(self.PvPIndicator)
        self.PvPTimerFrame:SetScript("OnEnter", function()
            if UnitIsPVPFreeForAll(self.unit) or UnitIsPVP(self.unit) then
                local timer = GetPVPTimer()

                GameTooltip:SetOwner(self, "ANCHOR_TOP")
                GameTooltip:AddLine("PvP")

                if timer ~= 301000 and timer ~= -1 then
                    local mins = floor((timer / 1000) / 60)
                    local secs = floor((timer / 1000) - (mins * 60))
                    local text = string.format("Timer: (%01.f:%02.f)", mins, secs)
                    GameTooltip:AddLine(text, 1, 1, 1)
                end

                GameTooltip:Show()
            end
        end)
        self.PvPTimerFrame:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    return self.PvPIndicator
end

oUF:RegisterMetaFunction("CreatePvPIndicator", UF.CreatePvPIndicator)

function UF:ConfigurePvPIndicator()
    local config = self.config.pvpIndicator
    if not config.enabled then
        self:DisableElement("PvPIndicator")
        return
    elseif not self.PvPIndicator then
        self:CreatePvPIndicator()
    end

    self:EnableElement("PvPIndicator")

    self.PvPIndicator:SetSize(unpack(config.size))
    self.PvPIndicator:ClearAllPoints()
    self.PvPIndicator:Point(unpack(config.point))
end

oUF:RegisterMetaFunction("ConfigurePvPIndicator", UF.ConfigurePvPIndicator)
