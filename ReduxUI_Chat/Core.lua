local AddonName, AddonTable = ...
local R = _G.ReduxUI
local C = R:AddModule("Chat", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

C.HyperlinkTypes = {
    achievement = true,
    apower = true,
    currency = true,
    enchant = true,
    glyph = true,
    instancelock = true,
    item = true,
    keystone = true,
    quest = true,
    spell = true,
    talent = true,
    unit = true
}

function C:Initialize()    
    C.chatMessages = R.config.db.char.modules.chat.chatMessages

    -- font size
    CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}

    -- tabs
    CHAT_TAB_HIDE_DELAY = 1
    CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
    CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
    CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
    CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
    CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
    CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 1

    -- channels
    CHAT_WHISPER_GET = "From %s "
    CHAT_WHISPER_INFORM_GET = "To %s "
    CHAT_BN_WHISPER_GET = "From %s "
    CHAT_BN_WHISPER_INFORM_GET = "To %s "
    CHAT_YELL_GET = "%s "
    CHAT_SAY_GET = "%s "
    CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|hBG.|h %s: "
    CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|hBGL.|h %s: "
    CHAT_GUILD_GET = "|Hchannel:Guild|hG.|h %s: "
    CHAT_OFFICER_GET = "|Hchannel:Officer|hGO.|h %s: "
    CHAT_PARTY_GET = "|Hchannel:Party|hP.|h %s: "
    CHAT_PARTY_LEADER_GET = "|Hchannel:Party|hPL.|h %s: "
    CHAT_PARTY_GUIDE_GET = "|Hchannel:Party|hPG.|h %s: "
    CHAT_RAID_GET = "|Hchannel:Raid|hR.|h %s: "
    CHAT_RAID_LEADER_GET = "|Hchannel:Raid|hRL.|h %s: "
    CHAT_RAID_WARNING_GET = "|Hchannel:RaidWarning|hRW.|h %s: "
    CHAT_INSTANCE_CHAT_GET = "|Hchannel:Battleground|hI.|h %s: "
    CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:Battleground|hIL.|h %s: "
    -- CHAT_MONSTER_PARTY_GET       = CHAT_PARTY_GET
    -- CHAT_MONSTER_SAY_GET         = CHAT_SAY_GET
    -- CHAT_MONSTER_WHISPER_GET     = CHAT_WHISPER_GET
    -- CHAT_MONSTER_YELL_GET        = CHAT_YELL_GET
    CHAT_FLAG_AFK = "<AFK> "
    CHAT_FLAG_DND = "<DND> "
    CHAT_FLAG_GM = "<[GM]> "

    -- remove the annoying guild loot messages by replacing them with the original ones
    YOU_LOOT_MONEY_GUILD = YOU_LOOT_MONEY
    LOOT_MONEY_SPLIT_GUILD = LOOT_MONEY_SPLIT

    -- don't cut the toastframe
    BNToastFrame:SetClampedToScreen(true)
    BNToastFrame:SetClampRectInsets(-15, 15, 15, -15)

    -- parse links for alt-click invite and url copy
    local SetItemRef_Base = SetItemRef
    SetItemRef = function(link, ...)
        local type, value = link:match("(%a+):(.+)")
        if IsAltKeyDown() and type == "player" then
            InviteUnit(value:match("([^:]+)"))
        elseif (type == "url") then
            local eb = LAST_ACTIVE_CHAT_EDIT_BOX or ChatFrame1EditBox
            if not eb then
                return
            end
            eb:SetText(value)
            eb:SetFocus()
            eb:HighlightText()
            if not eb:IsShown() then
                eb:Show()
            end
        else
            return SetItemRef_Base(link, ...)
        end
    end

    for i = 1, NUM_CHAT_WINDOWS do
        local chatframe = _G["ChatFrame" .. i]

        if (i ~= 2) then
            chatframe.AddMessage_Base = chatframe.AddMessage
            chatframe.AddMessage = function(frame, text, ...)
                -- store text in DB
                C:StoreChatMessage(chatframe, text, ...)

                text = text:gsub("(|h%[%d+%. .-%]|h)", function(s)
                    local index = s:match("|h%[(%d+)%.")
                    local channel = s:match("|h%[%d+%. (.-)%]|h")

                    -- replace "General - Orgrimmar" with "General", and similarly for Trade, LocalDefense etc
                    local general = channel:match("(.+) %- .+")
                    if general then
                        channel = general
                    else
                        -- abbreviate channel names using only their uppercased letters
                        local abbr = ""
                        for letter in string.gmatch(channel, "%u") do
                            abbr = abbr .. letter
                        end
                        if abbr ~= "" then
                            channel = abbr
                        else
                            channel = channel:sub(1, 1):upper()
                        end
                    end

                    return "|h" .. index .. ". " .. channel .. "|h"
                end)

                -- style urls
                text = text:gsub("([wWhH][wWtT][wWtT][%.pP]%S+[^%p%s])", "|cffffffff|Hurl:%1|h[%1]|h|r")

                -- TODO: support emojis
                -- TODO: support [inv] links

                return frame.AddMessage_Base(frame, text, ...)
            end
        end

        C:LoadChatHistory(chatframe)
    end

    -- skin temporary chat windows
    C:SecureHook("FCF_OpenTemporaryWindow", function()
        for _, name in next, CHAT_FRAMES do
            local chatframe = _G[name]
            if (chatframe.isTemporary) then
                C:SkinChatFrame(chatframe)
            end
        end
    end)

    -- fix weird combat log background issues
    C:SecureHook("FloatingChatFrame_UpdateBackgroundAnchors", function(chatframe)
        chatframe:SetClampRectInsets(0, 0, 0, 0)
    end)

    -- holding shift scrolls to top/bottom
    FloatingChatFrame_OnMouseScroll = function(chatframe, dir)
        if (dir > 0) then
            if (IsShiftKeyDown()) then
                chatframe:ScrollToTop()
            else
                chatframe:ScrollUp()
            end
        else
            if (IsShiftKeyDown()) then
                chatframe:ScrollToBottom()
            else
                chatframe:ScrollDown()
            end
        end
    end

    C:UpdateChatFrames()
end

function C:UpdateChatFrames()
    -- editbox font
    ChatFontNormal:SetFont(unpack(R.config.db.profile.modules.chat.font))

    -- ChatFrameMenuButton
    ChatFrameMenuButton:HookScript("OnShow", function()
        if R.config.db.profile.modules.chat.hideMenuButton then
            ChatFrameMenuButton:Hide()
        end
    end)
    if R.config.db.profile.modules.chat.hideMenuButton then
        ChatFrameMenuButton:Hide()
    else
        ChatFrameMenuButton:Show()
    end

    -- ChatFrameChannelButton
    ChatFrameChannelButton:HookScript("OnShow", function()
        if R.config.db.profile.modules.chat.hideChannelButton then
            ChatFrameChannelButton:Hide()
        end
    end)
    if R.config.db.profile.modules.chat.hideChannelButton then
        ChatFrameChannelButton:Hide()
    else
        ChatFrameChannelButton:Show()
    end

    -- show/hide class colors
    if R.config.db.profile.modules.chat.showClassColors then
        SetCVar("chatClassColorOverride", 0)
    else
        SetCVar("chatClassColorOverride", 1)
    end

    for i = 1, NUM_CHAT_WINDOWS do
        local chatframe = _G["ChatFrame" .. i]
        C:SkinChatFrame(chatframe)
    end

    for _, name in next, CHAT_FRAMES do
        local chatframe = _G[name]
        if (chatframe.isTemporary) then
            C:SkinChatFrame(chatframe)
        end
    end
end

function C:SkinChatFrame(frame)
    if not frame then
        return
    end

    local name = frame:GetName()

    -- chat frame resizing
    frame:SetClampRectInsets(0, 0, 0, 0)
    frame:SetMaxResize(UIParent:GetWidth() / 2, UIParent:GetHeight() / 2)
    frame:SetMinResize(100, 50)
    frame:SetFont(unpack(R.config.db.profile.modules.chat.font))

    -- chat fading
    frame:SetFading(true)

    -- hide button frame
    local buttonFrame = _G[name .. "ButtonFrame"]
    buttonFrame:HookScript("OnShow", buttonFrame.Hide)
    buttonFrame:Hide()

    -- editbox
    local editBox = _G[name .. "EditBox"]
    editBox:SetAltArrowKeyMode(false)

    -- textures
    _G[name .. "EditBoxLeft"]:Hide()
    _G[name .. "EditBoxMid"]:Hide()
    _G[name .. "EditBoxRight"]:Hide()

    -- reposition
    editBox:ClearAllPoints()
    if name == "ChatFrame2" then
        editBox:SetPoint("BOTTOM", frame, "TOP", 0, 22 + 24) -- CombatLogQuickButtonFrame_Custom:GetHeight()
    else
        editBox:SetPoint("BOTTOM", frame, "TOP", 0, 22)
    end
    editBox:SetPoint("LEFT", frame, -5, 0)
    editBox:SetPoint("RIGHT", frame, 10, 0)

    -- set max lines
    frame:SetMaxLines(R.config.db.profile.modules.chat.maxMessageCount)

    -- style hyperlinks
    if not frame.scriptsSet then
        C:HookScript(frame, "OnHyperlinkEnter")
        C:HookScript(frame, "OnHyperlinkLeave")
        C:HookScript(frame, "OnMouseWheel")
        frame:SetScript("OnMouseWheel", C.ChatFrame_OnMouseWheel)
        C:SecureHook(frame, "SetScript", C.ChatFrame_SetScript)

        frame.scriptsSet = true
    end
end

function C:GetFrameHistory(frame)
    local frameName = frame:GetName()
    if not C.chatMessages[frameName] then
        C.chatMessages[frameName] = {}
    end

    return C.chatMessages[frameName]
end

function C:LoadChatHistory(frame)
    local db = C:GetFrameHistory(frame)

    if db and #db > 0 then
        frame.isLoadingHistory = true
        for i, message in next, db do
            if message.text then
                frame.AddMessage(frame, message.text, unpack(message.args))
            end
        end
        frame.isLoadingHistory = false
    end
end

function C:ClearChatHistory()
    R.config.db.char.modules.chat.chatMessages = {}
    C.chatMessages = R.config.db.char.modules.chat.chatMessages
end

function C:StoreChatMessage(frame, text, ...)
    if frame.isLoadingHistory then
        return
    end

    -- check to make sure we're only storing certain messages
    local patterns = {
        "|Hplayer:", -- Say/Yell/Whisper
        "|Hchannel:" -- Channel messages
    }

    local matchesPattern = false
    for i, pattern in next, patterns do
        if strfind(text, pattern) then
            matchesPattern = true
            break
        end
    end

    if not matchesPattern then
        return
    end

    local message = {text = text, time = time(), args = {...}}
    local db = C:GetFrameHistory(frame)
    table.insert(db, message)

    local count = #db
    local countOverMax = count - R.config.db.profile.modules.chat.maxHistoryCount
    if countOverMax > 0 then
        for i = 1, countOverMax do
            table.remove(db, 1)
        end
    end
end

function C:OnHyperlinkEnter(frame, refString)
    if InCombatLockdown() then
        return
    end

    local linkToken = strmatch(refString, "^([^:]+)")
    if C.HyperlinkTypes[linkToken] then
        _G.GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
        _G.GameTooltip:SetHyperlink(refString)
        _G.GameTooltip:Show()
        C.HyperLinkFrame = frame
    end
end

function C:OnHyperlinkLeave()
    if C.HyperLinkFrame then
        C.HyperLinkFrame = nil
        _G.GameTooltip:Hide()
    end
end

function C:OnMouseWheel(frame)
    if C.HyperLinkFrame == frame then
        C.HyperLinkFrame = nil
        _G.GameTooltip:Hide()
    end
end

function C:ChatFrame_SetScript(script, func)
    if script == "OnMouseWheel" and func ~= C.ChatFrame_OnMouseScroll then
        self:SetScript(script, C.ChatFrame_OnMouseWheel)
    end
end

function C:ChatFrame_OnMouseWheel(delta)
    local numScrollMessages = 3
    if delta < 0 then
        if IsShiftKeyDown() then
            self:ScrollToBottom()
        elseif IsAltKeyDown() then
            self:ScrollDown()
        else
            for _ = 1, numScrollMessages do
                self:ScrollDown()
            end
        end
    elseif delta > 0 then
        if IsShiftKeyDown() then
            self:ScrollToTop()
        elseif IsAltKeyDown() then
            self:ScrollUp()
        else
            for _ = 1, numScrollMessages do
                self:ScrollUp()
            end
        end
    end
end
