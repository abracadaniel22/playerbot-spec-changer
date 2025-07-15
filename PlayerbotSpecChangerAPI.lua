-- This file contains shared functionality used by other modules
-- @author Abracadaniel22

local AddonName, Addon = ...

local PlayerbotSpecChanger = LibStub("AceAddon-3.0"):GetAddon(PLAYERBOT_SPEC_CHANGER_ADDON_ID)
local API = {}
PlayerbotSpecChanger.API = API

local HALF_A_SECOND = 0.5

API.CLASS_SPECS = {
    WARRIOR = {
        { label = "[DPS] Arms", value = "arms pve" },
        { label = "[DPS] Fury", value = "fury pve" },
        { label = "[TANK] Protection", value = "prot pve" },
    },
    PALADIN = {
        { label = "[HEALER] Holy", value = "holy pve" },
        { label = "[TANK] Protection", value = "prot pve" },
        { label = "[DPS] Retribution", value = "ret pve" },
    },
    HUNTER = {
        { label = "Beast Mastery", value = "bm pve" },
        { label = "Marksmanship", value = "mm pve" },
        { label = "Survival", value = "surv pve" },
    },
    ROGUE = {
        { label = "Assassination", value = "as pve" },
        { label = "Combat", value = "combat pve" },
        { label = "Subtlety", value = "subtlety pve" },
    },
    PRIEST = {
        { label = "[HEALER] Discipline", value = "disc pve" },
        { label = "[HEALER] Holy", value = "holy pve" },
        { label = "[DPS] Shadow", value = "shadow pve" },
    },
    DEATHKNIGHT = {
        { label = "[TANK] Blood", value = "blood pve" },
        { label = "[DPS]Frost", value = "frost pve" },
        { label = "[DPS] Unholy", value = "unholy pve" },
        { label = "[TANK] Double Aura Blood", value = "double aura blood pve" },
    },
    SHAMAN = {
        { label = "[DPS RANGED] Elemental", value = "ele pve" },
        { label = "[DPS] Enhancement", value = "enh pve" },
        { label = "[HEALER] Restoration", value = "resto pve" },
    },
    MAGE = {
        { label = "Arcane", value = "arcane pve" },
        { label = "Fire", value = "fire pve" },
        { label = "Frost", value = "frost pve" },
        { label = "Frostfire", value = "frostfire pve" },
    },
    WARLOCK = {
        { label = "Affliction", value = "affli pve" },
        { label = "Demonology", value = "demo pve" },
        { label = "Destruction", value = "destro pve" },
    },
    DRUID = {
        { label = "[DPS RANGED] Balance", value = "balance pve" },
        { label = "[TANK] Bear", value = "bear pve" },
        { label = "[HEALER] Restoration", value = "resto pve" },
        { label = "[DPS] Cat", value = "cat pve" },
    },
}

API.currentTalentQuerySentTo = nil

local function isempty(s)
  return s == nil or s == ''
end

function API:GetBotCurrentSpec(targetName, callback)
    self.onCurrentSpecResponse = callback
    self.currentTalentQuerySentTo = targetName
    SendChatMessage("talents", "WHISPER", nil, targetName)
end

function API:HandleIncomingWhisper(msg, author, ...)
    if isempty(msg) or isempty(author) or isempty(self.currentTalentQuerySentTo) then return end
    if author ~= self.currentTalentQuerySentTo then return end
    
    self.currentTalentQuerySentTo = nil
    if msg:find("^My current talent spec is:") then
        local spec = msg:match("My current talent spec is:%s*(.-)%s*Talents usage")
        self.onCurrentSpecResponse(spec)
        return true
    else
        self.onCurrentSpecResponse(nil)
        return false
    end
end

function API:GetTargetClass()
    if UnitExists("target") and UnitIsPlayer("target") then
        local _, class = UnitClass("target")
        return class
    end
    return nil
end

function API:GetTargetName()
    if UnitExists("target") and UnitIsPlayer("target") then
        return UnitName("target")
    end
    return nil
end

function API:SendUpdateSpecCommands(target, spec)
    local commands = {
        "talents spec " .. spec,
        "maitenance",
        "reset botAI",
        "autogear",
    }
    if not PlayerbotSpecChanger.ScheduleTimer then
        print("|cffff0000" .. PLAYERBOT_SPEC_CHANGER_ADDON_ID .. " WARNING: no AceTimer found, this is likely a bug. Sending bot commands with no delay, which may lead to commands being ignored and spec change incomplete.|r")
    end
    local i = 1
    local function sendNext()
        if i <= #commands then
            print("To: [" .. target .. "], Command: [" .. commands[i] .. "]")
            SendChatMessage(commands[i], "WHISPER", nil, target)
            i = i + 1
            if i <= #commands then
                if PlayerbotSpecChanger.ScheduleTimer then
                    PlayerbotSpecChanger:ScheduleTimer(sendNext, HALF_A_SECOND)
                else
                    sendNext()
                end
            end
        end
    end
    sendNext()
end

function API:IsTargetSelf()
    return UnitIsUnit("target", "player")
end
