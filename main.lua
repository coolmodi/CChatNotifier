local _addonName, _addon = ...;
local L = _addon:GetLocalization();

local frame = CreateFrame("Frame");
local handlers = {};
local playerName = UnitName("player");

--- Add new entry to the list
-- @param search The string to search for
function _addon:AddToList(search)
    local ntable = {
        active = true,
        words = {}
    };
    
    for found in string.gmatch(search, "([^,]+)") do
        table.insert(ntable.words, strtrim(found):lower());
    end

    CChatNotifier_data[search] = ntable;
    _addon:FillList();
end

--- Remove entry from list
-- @param search The string to remove
function _addon:RemoveFromList(search)
    CChatNotifier_data[search] = nil;
    _addon:FillList();
end

--- Toggle entry active state
-- @param search The search string to toggle
-- @return the new state
function _addon:ToggleEntry(search)
    if CChatNotifier_data[search] ~= nil then
        CChatNotifier_data[search].active = not CChatNotifier_data[search].active;
        return CChatNotifier_data[search].active;
    end
    return false;
end

--- Clear the whole list
function _addon:ClearList()
    wipe(CChatNotifier_data);
    _addon:FillList();
end

--- Output found message, play sound
-- @param msg The message to search in
-- @param from The player it is from
-- @param source The source of the message (SAY, CHANNEL)
-- @param channelName If source is CHANNEL this is the channel name
-- @param frameNum The chat tab to output to
function _addon:Triggered(search, fstart, fend, msg, from, source, channelName, frameNum)
    local searchOrig = string.sub(msg, fstart, fend);
    local repl = "|cFF00FF00" .. searchOrig .. "|cFFffb178";
    local notifyMsgFormat = "|cFFffb178" .. string.gsub(msg, searchOrig, repl);
    local notifyString;

    if source == "SAY" then
        notifyString = L["CHAT_NOTIFY_FOUND_SAYYELL"]:format(search, from, from, notifyMsgFormat);
    else
        notifyString = L["CHAT_NOTIFY_FOUND_CHANNEL"]:format(search, from, from, channelName, notifyMsgFormat);
    end

    _G["ChatFrame"..frameNum]:AddMessage(notifyString);

    if CChatNotifier_settings.playSound then
        PlaySoundFile(CChatNotifier_settings.soundId, "Master");
    end

    FCF_StartAlertFlash(_G["ChatFrame"..frameNum]);
end

--- Remove server names from names given as "Character-Servername"
-- @param name The name to remove the dash server part from
local function RemoveServerDash(name)
	local dash = name:find("-");
    if dash then 
        return name:sub(1, dash-1); 
    end
	return name;
end

--- Search message for searched terms
-- If one is found then trigger notification.
-- @param msg The message to search in
-- @param from The player it is from
-- @param source The source of the message (SAY, CHANNEL)
-- @param channelName If source is CHANNEL this is the channel name
local function SearchMessage(msg, from, source, channelName)
    local msglow = string.lower(msg);
    local fstart, fend;
    for _, data in pairs(CChatNotifier_data) do
        if data.active then
            for _, search in ipairs(data.words) do
                fstart, fend = string.find(msglow, search);
                if fstart ~= nil then
                    local nameNoDash = RemoveServerDash(from);
                    if nameNoDash == playerName then
                        return;
                    end
                    _addon:Triggered(search, fstart, fend, msg, nameNoDash, source, channelName, CChatNotifier_settings.chatFrame);
                    return;
                end
            end
        end
    end
end

--- Set addon state to current SV value
local function UpdateAddonState()
    if CChatNotifier_settings.isActive then
        frame:RegisterEvent("CHAT_MSG_SAY");
        frame:RegisterEvent("CHAT_MSG_YELL");
        frame:RegisterEvent("CHAT_MSG_CHANNEL");
    else
        frame:UnregisterEvent("CHAT_MSG_SAY");
        frame:UnregisterEvent("CHAT_MSG_YELL");
        frame:UnregisterEvent("CHAT_MSG_CHANNEL");
    end
    _addon:MinimapButtonUpdate();
end

--- Toggle search on/off
function _addon:ToggleAddon()
    CChatNotifier_settings.isActive = not CChatNotifier_settings.isActive;
    UpdateAddonState();
end


------------------------------------------------
-- Events
------------------------------------------------

function handlers.ADDON_LOADED(addonName)
    if addonName ~= _addonName then 
        return; 
    end
	frame:UnregisterEvent("ADDON_LOADED");
    _addon:SetupSettings();
    _addon:FillList();
    UpdateAddonState();

    if CChatNotifier_settings.firstStart then
        _addon:OpenList();
        print(L["FIRST_START_MSG"]);
        CChatNotifier_settings.firstStart = false;
    end
end

function handlers.CHAT_MSG_CHANNEL(text, playerName, _, channelName)
	SearchMessage(text, playerName, "CHANNEL", channelName);
end

function handlers.CHAT_MSG_SAY(text, playerName)
	SearchMessage(text, playerName, "SAY");
end

function handlers.CHAT_MSG_YELL(text, playerName)
	SearchMessage(text, playerName, "SAY");
end

frame:SetScript( "OnEvent",function(self, event, ...) 
	handlers[event](...);
end)

frame:RegisterEvent("ADDON_LOADED");


------------------------------------------------
-- Slash command
------------------------------------------------

SLASH_CCHATNOTIFIER1 = "/ccn";
SlashCmdList["CCHATNOTIFIER"] = function(arg)
    _addon:OpenList();
end;


------------------------------------------------
-- Helper
------------------------------------------------

--- Print error message (red)
-- @param msg The message to print
function _addon:PrintError(msg)
    print("|cFFFF3333" .. _addonName .. ": " .. msg:gsub("|r", "|cFFFF3333"));
end