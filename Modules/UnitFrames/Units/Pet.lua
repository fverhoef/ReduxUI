local addonName, ns = ...
local R = _G.ReduxUI
local UF = R.Modules.UnitFrames
local oUF = ns.oUF or oUF

function UF:SpawnPet()
    local config = UF.config.pet
    local default = UF.defaults.pet

    if config.enabled then
        return UF:SpawnFrame("Pet", "pet", UF.CreatePet, config, default)
    end
end

function UF:CreatePet()
    self.config = UF.config.pet
    self.defaults = UF.defaults.pet

    UF:SetupFrame(self)

    self.Texture = self:CreateTexture("$parentFrameTexture", "BORDER")
    self.Texture:SetSize(128, 64)
    self.Texture:SetPoint("TOPLEFT", self, 0, -2)
    self.Texture:SetTexture(R.media.textures.unitFrames.smallTargetingFrame)

    if self.config.auras.enabled then
        if self.Auras then
            self.Auras:ClearAllPoints()
            self.Auras:SetPoint("TOPLEFT", self, "TOPRIGHT", 30, 15)
        else
            self.Buffs:ClearAllPoints()
            self.Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 46, -2)
            self.Buffs.initialAnchor = "TOPLEFT"

            self.Debuffs:ClearAllPoints()
            self.Debuffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 16, 7)
            self.Debuffs.initialAnchor = "TOPLEFT"
        end
    end

    self:CreateRange()
    self:CreateAuraHighlight()

    self.Update = UF.UpdatePet
end

function UF:UpdatePet()
    if not self then
        return
    end
    
    UF:UpdateFrame(self)

    if UF:IsBlizzardTheme() then
        self.Border:Hide()
        self.Shadow:Hide()

        self:EnableElement("Power")
        self:EnableElement("Portrait")

        self:SetSize(175, 42)

        self.Health:ClearAllPoints()
        self.Health:SetSize(70, 9)
        self.Health:SetPoint("TOPLEFT", self.Texture, 45, -20)
        self.Health.Value:Hide()

        self.Power:ClearAllPoints()
        self.Power:SetHeight(self.Health:GetHeight())
        self.Power.Value:Hide()
        self.Power.Border:Hide()
        self.Power.Shadow:Hide()

        self.Texture:ClearAllPoints()
        self.Texture:SetSize(128, 64)
        self.Texture:SetPoint("TOPLEFT", self, 0, -2)
        self.Texture:SetTexture(R.media.textures.unitFrames.smallTargetingFrame)

        self.Name:ClearAllPoints()
        self.Name:SetWidth(110)
        self.Name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, 3)
        self.Name:SetJustifyH("LEFT")
        self.Name:Show()

        self.Level:Hide()

        self.Portrait:ClearAllPoints()
        self.Portrait:SetSize(37, 37)
        self.Portrait:SetPoint("TOPLEFT", self.Texture, 7, -6)
		self.Portrait:SetTexCoord(0, 1, 0, 1)

        self.CastbarParent:ClearAllPoints()
        self.CastbarParent:SetPoint("LEFT", self, "RIGHT", 16, -5)
        
        self.RaidTargetIndicator:ClearAllPoints()
        self.RaidTargetIndicator:SetPoint("CENTER", self.Portrait, "TOP", 0, -1)

        self.Highlight:ClearAllPoints()
        self.Highlight:SetSize(129, 64)
        self.Highlight:SetPoint("TOPLEFT", self.Texture, -5, 13)
        self.Highlight:SetTexture(R.media.textures.unitFrames.partyFrame_Flash)
        self.Highlight:SetTexCoord(0, 1, 1, 0)
    else
        self.Highlight:SetTexture(nil)
    end
end
