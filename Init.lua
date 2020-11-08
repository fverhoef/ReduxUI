local AddonName, AddonTable = ...

local AceAddon = _G.LibStub("AceAddon-3.0")
local Addon = AceAddon:NewAddon(AddonName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
AddonTable[1] = Addon
_G[AddonName] = Addon

Addon.title = "|cff00c3ffRedux|r |cffd78219UI|r"
Addon.shortcut = "rui"

Addon.IsClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
Addon.IsRetail = not Addon.IsClassic

Addon.Libs = {}
function Addon:AddLib(name, major, minor)
    if not name then
        return
    end

    Addon.Libs[name] = _G.LibStub(major, minor)
end

Addon:AddLib("AceConsole", "AceConsole-3.0")
Addon:AddLib("AceDB", "AceDB-3.0")
Addon:AddLib("AceDBOptions", "AceDBOptions-3.0")
Addon:AddLib("AceConfig", "AceConfig-3.0")
Addon:AddLib("AceConfigDialog", "AceConfigDialog-3.0")
Addon:AddLib("AceConfigRegistry", "AceConfigRegistry-3.0")
Addon:AddLib("SharedMedia", "LibSharedMedia-3.0")

if Addon.IsClassic then
    Addon:AddLib("ClassicSpellActionCount", "LibClassicSpellActionCount-1.0")
    Addon:AddLib("ClassicDurations", "LibClassicDurations")
    Addon.Libs.ClassicDurations:Register(AddonName)
end

Addon.Modules = {}
function Addon:AddModule(name)
    if not name then
        return
    end

    local module = Addon.Modules[name]
    if not module then
        module = Addon:NewModule(name, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
        Addon.Modules[name] = module
    end

    return module
end

function Addon:OnInitialize()
    Addon:SetupConfig()
    Addon:UpdateBlizzardFonts()

    Addon.Libs.AceConsole:RegisterChatCommand(Addon.shortcut, function(args)
        if args:match "unlock" then
            Addon:UnlockFrames()
        elseif args:match "lock" then
            Addon:LockFrames()
        elseif args:match "reset" then
            Addon:ResetFrames()
        else
            Addon:Print("Command list:")
            Addon:Print("/" .. Addon.shortcut .. " lock|r, to lock all frames")
            Addon:Print("/" .. Addon.shortcut .. " unlock|r, to unlock all frames")
            Addon:Print("/" .. Addon.shortcut .. " reset|r, to reset all frames")
        end
    end)
    Addon:Print("Loaded. Use /" .. Addon.shortcut .. " to display the command list.")
end
