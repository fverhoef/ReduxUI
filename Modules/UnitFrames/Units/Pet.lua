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
    self.cfg = UF.config.pet

    local player = UF.frames.player

    self:SetSize(unpack(self.cfg.size))
    self:SetPoint(unpack(self.cfg.point))
    self:SetFrameStrata("LOW")
    self:SetFrameLevel(20)

    self:RegisterForClicks("AnyUp")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    self:CreateBorder(self.cfg.border.size)
    self:CreateShadow()

    -- texture
    self.Texture = self:CreateTexture("$parentFrameTexture", "BORDER")
    self.Texture:SetSize(128, 64)
    self.Texture:SetPoint("TOPLEFT", self, 0, -2)
    self.Texture:SetTexture(R.media.textures.unitFrames.smallTargetingFrame)

    self:CreateHealth()
    self:CreatePower()
    self:CreateName()
    self:CreateLevel()
    self:CreatePortrait()
    self:CreateCombatFeedback()
    self:CreateRaidTargetIndicator()

    if self.cfg.auras.enabled then
        self:CreateAuras()
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

    self:CreateCastbar()

    self:CreateRange()

    self.Update = function(self)
        UF:UpdatePet(self)
    end
end

function UF:UpdatePet(self)
    if not self then
        return
    end
    
    UF:UpdateFrame(self)

    if UF:IsBlizzardTheme() then
        self.Border:Hide()
        self.Shadow:Hide()

        self:EnableElement("Power")
        self:EnableElement("Portrait")

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

        self.NameParent:ClearAllPoints()
        self.NameParent:SetWidth(110)
        self.NameParent:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 2, 3)
        self.Name:SetJustifyH("LEFT")
        self.Name:Show()

        self.Level:Hide()

        self.Portrait:ClearAllPoints()
        self.Portrait:SetSize(37, 37)
        self.Portrait:SetPoint("TOPLEFT", self.Texture, 7, -6)
		self.Portrait:SetTexCoord(0, 1, 0, 1)

        self.CastbarParent:ClearAllPoints()
        self.CastbarParent:SetPoint("LEFT", self, "RIGHT", 16, -5)
    end
end
