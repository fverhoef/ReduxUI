local addonName, ns = ...
local R = _G.ReduxUI

R.config = {}
R.config.defaults = {
    profile = {
        borders = {size = 5, texture = R.media.textures.borders.redux, color = {89 / 255, 89 / 255, 89 / 255, 1}},
        fonts = {
            damage = R.Libs.SharedMedia:Fetch("font", "Adventure"),
            normal = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            number = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            unitName = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            chatBubble = R.Libs.SharedMedia:Fetch("font", "Expressway Free"),
            replaceBlizzardFonts = true
        },
        modules = {}
    },
    char = {modules = {}},
    realm = {inventory = {}, modules = {}}
}

R.config.faders = {none = nil, onShow = 1, mouseOver = 2}

function R:RegisterModuleConfig(module, profile, char, realm)
    R.config.defaults.profile.modules[module.name] = profile
    module.defaults = profile
    if char then
        R.config.defaults.char.modules[module.name] = char
        module.charDefaults = char
    end
    if realm then
        R.config.defaults.realm.modules[module.name] = realm
        module.realmDefaults = realm
    end
end

function R:SetupConfig()
    R.config.db = R.Libs.AceDB:New(addonName .. "_DB", R.config.defaults)
end
