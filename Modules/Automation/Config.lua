local addonName, ns = ...
local R = _G.ReduxUI
local AM = R.Modules.Automation

R:RegisterModuleConfig(AM, {
    enabled = true,
    fastLoot = true,
    standDismount = true,
    vendorGrays = true,
    repair = true,
    acceptSummon = false,
    acceptResurrection = true,
    disableLootRollConfirmation = true,
    disableLootBindConfirmation = false,
    disableVendorRefundWarning = true,
    disableMailRefundWarning = true,
    autoInvite = true,
    autoInvitePassword = "inv"
})