local addonName, ns = ...
local R = _G.ReduxUI
local Installer = R:AddModule("Installer", "AceEvent-3.0", "AceHook-3.0")
local L = R.L

function Installer:Initialize()
    StaticPopupDialogs[R.name .. "_INSTALLER_DETAILS"] = {
        text = R.title .. " detected you are using Details. Would you like to install the " .. R.title .. " Details profile?",
        button1 = L["Yes"],
        button2 = L["No"],
        OnAccept = Installer.SetupDetails
    }
end

function Installer:Enable() if not Installer.config.details.installed and _G.Details then StaticPopup_Show(R.name .. "_INSTALLER_DETAILS") end end
