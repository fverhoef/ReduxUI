local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:CreateStatusFlash()
    self.StatusFlashParent = CreateFrame("Frame", nil, self)
    self.StatusFlash = self:CreateTexture("$parentStatusFlash", "ARTWORK")
    self.StatusFlash:SetTexCoord(0, 0.74609375, 0, 0.53125)
    self.StatusFlash:SetBlendMode("ADD")
    self.StatusFlash:SetSize(192, 66)
    self.StatusFlash:SetPoint("TOPLEFT", self.Texture, 35, -9)
    self.StatusFlash:SetAlpha(0)

    self.StatusFlash.counter = 0
    self.StatusFlash.sign = -1
    self.StatusFlash.updateInterval = 0.01
    self.StatusFlash.timeSinceLastUpdate = 0

    UF.UpdateStatusFlashVisibility(self)

    return self.StatusFlash
end

oUF:RegisterMetaFunction("CreateStatusFlash", UF.CreateStatusFlash)

function UF:UpdateStatusFlashVisibility()
    if not self.StatusFlash then
        return
    end

    if UnitIsDeadOrGhost("player") then
        self.StatusFlash:Hide()
        return
    end

    if IsResting() then
        self.StatusFlash:SetVertexColor(1.0, 0.88, 0.25, 1.0)
        self.StatusFlash:Show()
    elseif self.inCombat then
        self.StatusFlash:SetVertexColor(1.0, 0.0, 0.0, 1.0)
        self.StatusFlash:Show()
    else
        self.StatusFlash:Hide()
    end

    if self.StatusFlash:IsShown() then
        if not UF:IsHooked(self.StatusFlashParent, "OnUpdate") then
            UF:HookScript(self.StatusFlashParent, "OnUpdate", function(parent, elapsed)
                UF.UpdateStatusFlash(self, elapsed)
            end)
        end
    else
        UF:Unhook(self.StatusFlashParent, "OnUpdate")
    end
end

function UF:UpdateStatusFlash(elapsed)
    if not self.StatusFlash then
        return
    end
    self.StatusFlash.timeSinceLastUpdate = self.StatusFlash.timeSinceLastUpdate + elapsed

    if (self.StatusFlash.timeSinceLastUpdate > self.StatusFlash.updateInterval) then
        if self.StatusFlash:IsShown() then
            local alpha = 255
            local counter = self.StatusFlash.counter + elapsed
            local sign = self.StatusFlash.sign

            if counter > 0.5 then
                sign = -sign
                self.StatusFlash.sign = sign
            end
            counter = mod(counter, 0.5)
            self.StatusFlash.counter = counter

            if sign == 1 then
                alpha = (55 + (counter * 400)) / 255
            else
                alpha = (255 - (counter * 400)) / 255
            end
            self.StatusFlash:SetAlpha(alpha)

            if self.RestingIndicator and self.RestingIndicator.Glow:IsShown() then
                self.RestingIndicator.Glow:SetAlpha(alpha)
            elseif self.CombatIndicator and self.CombatIndicator.Glow:IsShown() then
                self.CombatIndicator.Glow:SetAlpha(alpha)
            end
        end

        self.StatusFlash.timeSinceLastUpdate = 0
    end
end
