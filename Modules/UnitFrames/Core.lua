local addonName, ns = ...
local R = _G.ReduxUI
local UF = R:AddModule("UnitFrames", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local oUF = ns.oUF or oUF

UF.frames = {}
UF.forceShowRaid = false

function UF:Initialize()
    if not R.config.db.profile.modules.unitFrames.enabled then
        return
    end

    UF:UpdateColors()

    UF.frames.player = UF:SpawnPlayer()
    UF.frames.target = UF:SpawnTarget()
    UF.frames.targetTarget = UF:SpawnTargetTarget()
    UF.frames.pet = UF:SpawnPet()
    UF.frames.focus = UF:SpawnFocus()
    UF.frames.focusTarget = UF:SpawnFocusTarget()
    UF.frames.mouseover = UF:SpawnMouseOver()

    UF.frames.partyHeader = UF:SpawnParty()
    UF.frames.raidHeader = UF:SpawnRaidHeader()
    UF.frames.tankHeader = UF:SpawnTank()
    UF.frames.assistHeader = UF:SpawnAssist()
    UF.frames.bossHeader = UF:SpawnBoss()
    UF.frames.arenaHeader = UF:SpawnArena()

    UF:SpawnNamePlates()

    UF:RegisterEvent("PLAYER_ENTERING_WORLD", UF.SetupMasque)

    UF:UpdateAll()
end

function UF:UpdateAll()
    UF:UpdateColors()

    UF:UpdatePlayer()
    UF:UpdateTarget()
    UF:UpdateTargetTarget()
    UF:UpdatePet()
    UF:UpdateFocus()
    UF:UpdateFocusTarget()
    UF:UpdateMouseover()

    UF:UpdateParty()
    UF:UpdateRaidHeader()
    UF:UpdateTank()
    UF:UpdateAssist()
    UF:UpdateBoss()
    UF:UpdateArena()

    UF:UpdateNamePlates()
end

function UF:UpdateColors()
    oUF.colors.health = R.config.db.profile.modules.unitFrames.health
    oUF.colors.power["MANA"] = R.config.db.profile.modules.unitFrames.colors.mana
    oUF.colors.power["RAGE"] = R.config.db.profile.modules.unitFrames.colors.rage
    oUF.colors.power["ENERGY"] = R.config.db.profile.modules.unitFrames.colors.energy
    oUF.colors.power["FOCUS"] = R.config.db.profile.modules.unitFrames.colors.focus
    oUF.colors.power["COMBO_POINTS"] = R.config.db.profile.modules.unitFrames.colors.comboPoints

    for key, value in next, R.config.db.profile.modules.unitFrames.colors.class do
        if RAID_CLASS_COLORS[key] then
            RAID_CLASS_COLORS[key]["r"] = value[1]
            RAID_CLASS_COLORS[key]["g"] = value[2]
            RAID_CLASS_COLORS[key]["b"] = value[3]
        end
        oUF.colors.class[key] = value
    end
end

function UF:SpawnFrame(name, unit, func, config, defaultConfig)
    oUF:RegisterStyle(addonName .. name, func)
    oUF:SetActiveStyle(addonName .. name)

    local frame = oUF:Spawn(unit, addonName .. name)

    if config.fader and config.fader.enabled then
        R:CreateFrameFader(frame, config.fader)
    end

    R:CreateDragFrame(frame, name, defaultConfig and defaultConfig.point or nil)

    return frame
end

function UF:SpawnHeader(name, index, func, config, defaultConfig)
    -- oUF:RegisterStyle(addonName .. name, func)
    -- oUF:SetActiveStyle(addonName .. name)

    local header = oUF:SpawnHeader(addonName .. name .. "Header" .. index, nil, config.visibility, "showPlayer",
                                   config.showPlayer, "showSolo", config.showSolo, "showParty", config.showParty, "showRaid",
                                   config.showRaid, "point", config.unitAnchorPoint, "groupFilter", tostring(index), "oUF-initialConfigFunction", ([[
            self:SetWidth(%d)
            self:SetHeight(%d)
            self:GetParent():SetScale(%f)
        ]]):format(config.size[1], config.size[2], config.scale))

    if config.fader and config.fader.enabled then
        R:CreateFrameFader(header, config.fader)
    end

    return header
end

function UF:UpdateFrame(self)
    if not self then
        return
    end

    self:SetScale(self.cfg.scale or 1)

    UF.UpdateHealth(self)
    UF.UpdatePower(self)
    UF.UpdatePowerPrediction(self)
    UF.UpdateAdditionalPower(self)
    UF.UpdateCastbar(self)
    UF.UpdateAuraHighlight(self)
    UF.UpdateAuras(self)
    UF.UpdateCombatFeedback(self)

    if self.Texture then
        self.Texture:SetVertexColor(unpack(self.cfg.textureColor))
    end

    self:UpdateAllElements("OnUpdate")
end

local configEnv
local originalEnvs = {}
local overrideFuncs = {}

local function CreateConfigEnv()
    if (configEnv) then
        return
    end
    configEnv = setmetatable({
        UnitPower = function(unit, displayType)
            if unit:find("target") or unit:find("focus") then
                return UnitPower(unit, displayType)
            end

            return random(1, UnitPowerMax(unit, displayType) or 1)
        end,
        UnitHealth = function(unit)
            if unit:find("target") or unit:find("focus") then
                return UnitHealth(unit)
            end

            return random(1, UnitHealthMax(unit))
        end,
        UnitName = function(unit)
            if unit:find("target") or unit:find("focus") then
                return UnitName(unit)
            end
            if E.CreditsList then
                local max = #E.CreditsList
                return E.CreditsList[random(1, max)]
            end
            return "Test Name"
        end,
        UnitClass = function(unit)
            if unit:find("target") or unit:find("focus") then
                return UnitClass(unit)
            end

            local classToken = CLASS_SORT_ORDER[random(1, #(CLASS_SORT_ORDER))]
            return LOCALIZED_CLASS_NAMES_MALE[classToken], classToken
        end,
        Hex = function(r, g, b)
            if type(r) == "table" then
                if r.r then
                    r, g, b = r.r, r.g, r.b
                else
                    r, g, b = unpack(r)
                end
            end
            return format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
        end,
        ColorGradient = oUF.ColorGradient,
        _COLORS = oUF.colors
    }, {
        __index = _G,
        __newindex = function(_, key, value)
            _G[key] = value
        end
    })

    overrideFuncs["namecolor"] = oUF.Tags.Methods["namecolor"]
    overrideFuncs["name:veryshort"] = oUF.Tags.Methods["name:veryshort"]
    overrideFuncs["name:short"] = oUF.Tags.Methods["name:short"]
    overrideFuncs["name:medium"] = oUF.Tags.Methods["name:medium"]
    overrideFuncs["name:long"] = oUF.Tags.Methods["name:long"]

    overrideFuncs["healthcolor"] = oUF.Tags.Methods["healthcolor"]
    overrideFuncs["health:current"] = oUF.Tags.Methods["health:current"]
    overrideFuncs["health:deficit"] = oUF.Tags.Methods["health:deficit"]
    overrideFuncs["health:current-percent"] = oUF.Tags.Methods["health:current-percent"]
    overrideFuncs["health:current-max"] = oUF.Tags.Methods["health:current-max"]
    overrideFuncs["health:current-max-percent"] = oUF.Tags.Methods["health:current-max-percent"]
    overrideFuncs["health:max"] = oUF.Tags.Methods["health:max"]
    overrideFuncs["health:percent"] = oUF.Tags.Methods["health:percent"]

    overrideFuncs["powercolor"] = oUF.Tags.Methods["powercolor"]
    overrideFuncs["power:current"] = oUF.Tags.Methods["power:current"]
    overrideFuncs["power:deficit"] = oUF.Tags.Methods["power:deficit"]
    overrideFuncs["power:current-percent"] = oUF.Tags.Methods["power:current-percent"]
    overrideFuncs["power:current-max"] = oUF.Tags.Methods["power:current-max"]
    overrideFuncs["power:current-max-percent"] = oUF.Tags.Methods["power:current-max-percent"]
    overrideFuncs["power:max"] = oUF.Tags.Methods["power:max"]
    overrideFuncs["power:percent"] = oUF.Tags.Methods["power:percent"]
end

function UF:ForceShow(frame)
    if InCombatLockdown() then
        return;
    end
    if not frame.isForced then
        frame.oldUnit = frame.unit
        frame.unit = "player"
        frame.isForced = true
        frame.oldOnUpdate = frame:GetScript("OnUpdate")
    end

    frame:SetScript("OnUpdate", nil)
    frame.forceShowAuras = true
    UnregisterUnitWatch(frame)
    RegisterUnitWatch(frame, true)

    frame:EnableMouse(false)

    frame:Show()
    if frame:IsVisible() and frame.Update then
        frame:Update()
    end

    if (_G[frame:GetName() .. "Target"]) then
        self:ForceShow(_G[frame:GetName() .. "Target"])
    end

    if (_G[frame:GetName() .. "Pet"]) then
        self:ForceShow(_G[frame:GetName() .. "Pet"])
    end
end

function UF:UnforceShow(frame)
    if InCombatLockdown() then
        return;
    end
    if not frame.isForced then
        return
    end
    frame.forceShowAuras = nil
    frame.isForced = nil

    -- Ask the SecureStateDriver to show/hide the frame for us
    UnregisterUnitWatch(frame)
    RegisterUnitWatch(frame)

    frame:EnableMouse(true)

    if frame.oldOnUpdate then
        frame:SetScript("OnUpdate", frame.oldOnUpdate)
        frame.oldOnUpdate = nil
    end

    frame.unit = frame.oldUnit or frame.unit
    -- If we're visible force an update so everything is properly in a
    -- non-config mode state
    if frame:IsVisible() and frame.Update then
        frame:Update()
    end

    if (_G[frame:GetName() .. "Target"]) then
        self:UnforceShow(_G[frame:GetName() .. "Target"])
    end

    if (_G[frame:GetName() .. "Pet"]) then
        self:UnforceShow(_G[frame:GetName() .. "Pet"])
    end
end

function UF:ForceShowRaid()
    if InCombatLockdown() then
        return
    end

    CreateConfigEnv()
    for _, func in pairs(overrideFuncs) do
        if type(func) == "function" then
            if not originalEnvs[func] then
                originalEnvs[func] = getfenv(func)
                setfenv(func, configEnv)
            end
        end
    end

    for _, group in ipairs(UF.frames.raidHeader.groups) do
        if group:IsShown() then
            group.isForced = true
            group.forceShow = true
            group:SetAttribute("startingIndex", -4)

            for i = 1, group:GetNumChildren() do
                local child = group:GetAttribute("child" .. i)
                self:ForceShow(child)
            end
        
            if group.Update then
                group:Update()
            end
        end
    end

    UF.forceShowRaid = true
end

function UF:UnforceShowRaid()
    if InCombatLockdown() then
        return
    end

    for func, env in pairs(originalEnvs) do
        setfenv(func, env)
        originalEnvs[func] = nil
    end

    for _, group in ipairs(UF.frames.raidHeader.groups) do
        if group:IsShown() then
            group.isForced = nil
            group.forceShow = nil
            group:SetAttribute("startingIndex", 1)

            for i = 1, group:GetNumChildren() do
                local child = group:GetAttribute("child" .. i)
                self:UnforceShow(child)
            end
        
            if group.Update then
                group:Update()
            end
        end
    end

    UF.forceShowRaid = false
end

function UF:PLAYER_REGEN_DISABLED()
    UF:UnforceShowRaid()
end

UF:RegisterEvent("PLAYER_REGEN_DISABLED")
