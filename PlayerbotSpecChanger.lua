-- Main addon file - handles minimap button and events
-- @author Abracadaniel22

local AddonName, Addon = ...
PLAYERBOT_SPEC_CHANGER_ADDON_ID = "PlayerbotSpecChanger"
PLAYERBOT_SPEC_CHANGER_ADDON_TITLE = "Playerbot Spec Changer"

local AceAddon = LibStub("AceAddon-3.0")
local LDB = LibStub("LibDataBroker-1.1")
local LDBIcon = LibStub("LibDBIcon-1.0")

local PlayerbotSpecChanger = AceAddon:NewAddon(PLAYERBOT_SPEC_CHANGER_ADDON_ID, "AceEvent-3.0")

local AceEvent = LibStub("AceEvent-3.0")
AceEvent:Embed(PlayerbotSpecChanger)
local AceTimer = LibStub("AceTimer-3.0")
AceTimer:Embed(PlayerbotSpecChanger)

function PlayerbotSpecChanger:OnInitialize()
    local minimapIconData = LDB:NewDataObject(PLAYERBOT_SPEC_CHANGER_ADDON_ID, {
        type = "launcher",
        text = PLAYERBOT_SPEC_CHANGER_ADDON_ID,
        icon = "Interface\\ICONS\\Ability_DualWieldSpecialization" ,
        OnClick = function(clickedframe, button)
            PlayerbotSpecChanger.UI:ShowUI()
        end,
        OnTooltipShow = function(tooltip)
            tooltip:AddLine(PLAYERBOT_SPEC_CHANGER_ADDON_TITLE)
            tooltip:AddLine("Click to change bot spec.")
        end,
    })
    LDBIcon:Register(PLAYERBOT_SPEC_CHANGER_ADDON_ID, minimapIconData, { hide = false })
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99PlayerbotSpecChanger|r" .. ": Loaded")
end

function PlayerbotSpecChanger:OnEnable()
    self:RegisterEvent("PLAYER_TARGET_CHANGED")
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", function(chatFrame, event, msg, author, ...) return self.API:HandleIncomingWhisper(msg, author, ...) end)
end

function PlayerbotSpecChanger:PLAYER_TARGET_CHANGED()
    self.UI:RefreshUIIfOpen()
end
