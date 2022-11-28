local addonName, ns = ...

local R = _G.LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
ns[1] = R
_G[addonName] = R

R.name = R.name or addonName
R.title = "|cff00c3ffRedux|r |cffd78219UI|r"
R.shortcut = "rui"
R.debug = true

R.isRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE

R.Libs = {}
function R:AddLib(name, major, minor)
    if not name then return end

    R.Libs[name] = _G.LibStub(major, minor)
end

R:AddLib("AceConsole", "AceConsole-3.0")
R:AddLib("AceDB", "AceDB-3.0")
R:AddLib("AceDBOptions", "AceDBOptions-3.0")
R:AddLib("AceConfig", "AceConfig-3.0")
R:AddLib("AceConfigDialog", "AceConfigDialog-3.0")
R:AddLib("AceConfigRegistry", "AceConfigRegistry-3.0")

R:AddLib("CallbackHandler", "CallbackHandler-1.0")
R:AddLib("SharedMedia", "LibSharedMedia-3.0")

R:AddLib("Dispel", "LibDispel-1.0")
R:AddLib("DRList", "DRList-1.0")
R:AddLib("ItemSearch", "LibItemSearch-1.2")
R:AddLib("KeyBound", "LibKeyBound-1.0")
R:AddLib("SmoothStatusBar", "LibSmoothStatusBar-1.0")

R.Modules = {}
function R:AddModule(name, ...)
    if not name then return end

    local module = R.Modules[name]
    if not module then
        module = R:NewModule(name, ...)
        module.name = name
        module.initialized = false
        R.Modules[name] = module
    end

    return module
end
function R:AddEarlyLoadModule(name, ...)
    local module = R:AddModule(name, ...)
    if module then
        module.loadEarly = true
    end
    return module
end

R.ChatCommands = {
    ["unlock"] = {func = function() R:ShowMovers() end, description = "unlock all frames"},
    ["lock"] = {func = function() R:HideMovers() end, description = "lock all frames"},
    ["reset"] = {func = function() R:ResetMovers() end, description = "reset all frames"},
    ["options"] = {func = function() R:ShowOptionsDialog() end, description = "open the config dialog"},
    ["bind"] = {func = function() R.Libs.KeyBound:Toggle() end, description = "toggle keybind mode"}
}

function R:OnInitialize()
    R:SetupConfig()
    R:SetupOptions()

    R.Libs.AceConsole:RegisterChatCommand(R.shortcut, function(args)
        local arg1, funcArgs = strsplit(" ", args, 2)
        local command = R.ChatCommands[arg1]
        if command then
            command.func(funcArgs and strsplit(" ", funcArgs))
        else
            R:Print("Command list:")
            for key, value in pairs(R.ChatCommands) do R:Print("/" .. R.shortcut .. " " .. key .. "|r: " .. value.description) end
        end
    end)

    R.framesLocked = true

    SetCVar("scriptErrors", R.debug)
    if R.debug then
        R:RegisterEvent("ADDON_ACTION_BLOCKED", R.LogTaintError)
        R:RegisterEvent("ADDON_ACTION_FORBIDDEN", R.LogTaintError)
    end

    R:RegisterEvent("PLAYER_REGEN_DISABLED", R.CloseOptionsDialog)
    
    for name, module in pairs(R.Modules) do
        module.config = R.config.db.profile.modules[name]
        module.charConfig = R.config.db.char.modules[name]
        module.realmConfig = R.config.db.realm.modules[name]
        if module.CreateOptions then module:CreateOptions() end
    end

    for name, module in pairs(R.Modules) do
        if module.loadEarly then
            module:Initialize()
            module.initialized = true
        end
    end

    for name, module in pairs(R.Modules) do
        if not module.initialized then
            module:Initialize()
            module.initialized = true
        end
    end
end

function R:OnEnable()
    for name, module in pairs(R.Modules) do
        if module.Enable and not module.enabled then
            module:Enable()
            module.enabled = true
        end
    end

    R:Print("Loaded. Use /" .. R.shortcut .. " to display the command list.")
end

function R:LogTaintError(event, addonName, addonFunc)
    _G.ScriptErrorsFrame:OnError(R.L["%s: %s tried to call the protected function '%s'."]:format(event, addonName or "<name>", addonFunc or "<func>"), false, false)
end
