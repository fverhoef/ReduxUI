local addonName, ns = ...

local R = _G.LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
ns[1] = R
_G[addonName] = R

R.name = R.name or addonName
R.title = "|cff00c3ffRedux|r |cffd78219UI|r"
R.shortcut = "rui"

R.isClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
R.isRetail = not R.isClassic

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
R:AddLib("ItemSearch", "LibItemSearch-1.2")

if R.isClassic then
    R:AddLib("ClassicSpellActionCount", "LibClassicSpellActionCount-1.0")
    R:AddLib("ClassicDurations", "LibClassicDurations")
    R.Libs.ClassicDurations:Register(addonName)
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
    R:SetupConfig()
    R:UpdateBlizzardFonts()

    R.Libs.AceConsole:RegisterChatCommand(R.shortcut, function(args)
        if args:match("unlock") then
            R:ShowDragFrames()
        elseif args:match("lock") then
            R:HideDragFrames()
        elseif args:match("reset") then
            R:ResetFrames()
        elseif args:match("options") then
            R.Libs.AceConfigDialog:Open(addonName)
        else
            R:Print("Command list:")
            R:Print("/" .. R.shortcut .. " options|r, to show the options dialog")
            R:Print("/" .. R.shortcut .. " lock|r, to lock all frames")
            R:Print("/" .. R.shortcut .. " unlock|r, to unlock all frames")
            R:Print("/" .. R.shortcut .. " reset|r, to reset all frames")
        end
    end)

    R.framesLocked = true
end

function R:OnEnable()
    R:RefreshConfig()

    for name, module in pairs(R.Modules) do
        module.config = R.config.db.profile.modules[name]
        module.charConfig = R.config.db.char.modules[name]
        module.realmConfig = R.config.db.realm.modules[name]
    end

    for name, module in pairs(R.Modules) do
        if module.Initialize and not module.initialized then
            module.Initialize()
            module.initialized = true
        end
    end

    R:Print("Loaded. Use /" .. R.shortcut .. " to display the command list.")
end
