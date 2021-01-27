local AddonName, AddonTable = ...

local AceAddon = _G.LibStub("AceAddon-3.0")
local R = AceAddon:NewAddon(AddonName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
AddonTable[1] = R
_G[AddonName] = R

R.name = R.name or AddonName
R.title = "|cff00c3ffRedux|r |cffd78219UI|r"
R.shortcut = "rui"

R.IsClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
R.IsRetail = not R.IsClassic

R.Libs = {}
function R:AddLib(name, major, minor)
    if not name then
        return
    end

    R.Libs[name] = _G.LibStub(major, minor)
end

R:AddLib("AceConsole", "AceConsole-3.0")
R:AddLib("AceDB", "AceDB-3.0")
R:AddLib("AceDBOptions", "AceDBOptions-3.0")
R:AddLib("AceConfig", "AceConfig-3.0")
R:AddLib("AceConfigDialog", "AceConfigDialog-3.0")
R:AddLib("AceConfigRegistry", "AceConfigRegistry-3.0")
R:AddLib("SharedMedia", "LibSharedMedia-3.0")

if R.IsClassic then
    R:AddLib("ClassicSpellActionCount", "LibClassicSpellActionCount-1.0")
end

R.Modules = {}
function R:AddModule(name)
    if not name then
        return
    end

    local module = R.Modules[name]
    if not module then
        module = R:NewModule(name, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
        module.name = name
        module.initialized = false
        R.Modules[name] = module
    end

    return module
end

function R:OnInitialize()
    R.Libs.AceConsole:RegisterChatCommand(R.shortcut, function(args)
        if args:match "unlock" then
            R:UnlockFrames()
        elseif args:match "lock" then
            R:LockFrames()
        elseif args:match "reset" then
            R:ResetFrames()
        else
            R:Print("Command list:")
            R:Print("/" .. R.shortcut .. " lock|r, to lock all frames")
            R:Print("/" .. R.shortcut .. " unlock|r, to unlock all frames")
            R:Print("/" .. R.shortcut .. " reset|r, to reset all frames")
        end
    end)
end

function R:OnEnable()
    R:SetupConfig()
    R:UpdateBlizzardFonts()

    for name, module in pairs(R.Modules) do
        if module.Initialize and not module.initialized then
            module.Initialize()
            module.initialized = true
        end
    end
    
    R:Print("Loaded. Use /" .. R.shortcut .. " to display the command list.")
end
