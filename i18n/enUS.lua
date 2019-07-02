local _addonName, _addon = ...;
local L = _addon:AddLocalization("enUS", true);
if L == nil then return; end

L["FIRST_START_MSG"] = "|cFF00FF00" .. _addonName .. "|r|cFFffb178: List UI can be opened with /ccn or the button on the minimap. You can hide the button in settings.";

L["CHAT_NOTIFY_FOUND_SAYYELL"] = "Found |cFF00FF00%s|r! |cFFFF66FF|Hplayer:%s|h[%s]|h|r: %s";
L["CHAT_NOTIFY_FOUND_CHANNEL"] = "Found |cFF00FF00%s|r! |cFFFF66FF|Hplayer:%s|h[%s]|h|r in %s: %s";

L["SETTINGS_PLAY_SOUND"] = "Activate sound";
L["SETTINGS_PLAY_SOUND_TT"] = "Play sound when a search keyword was found.";
L["SETTINGS_TEST_CHAT"] = "Test";
L["SETTINGS_CHATFRAME"] = "Notification chatframe:";
L["SETTINGS_CHATFRAME_TT"] = "Choose chatframe (tab) in which the notifications should appear.";
L["SETTINGS_MINIMAP"] = "Show minimap button";
L["SETTINGS_MINIMAP_TT"] = "Show button for opening the list. Alternatively you can use /ccn.";
L["SETTINGS_SNAP_MINIMAP"] = "Snap button to minimap";
L["SETTINGS_SNAP_MINIMAP_TT"] = "Snap minimap button to minimap border.";
L["SETTINGS_SOUNDID"] = "Notification sound:";
L["SETTINGS_SOUNDID_TT"] = "Choose sound to play as notification.";

L["UI_ADDFORM_TITLE"] = "New Search";
L["UI_ADDFORM_NAME"] = "Enter keyword(s) below. Multiple words are separated by a comma, use dot for wildcards:";
L["UI_ADDFORM_ADD_BUTTON"] = "Add";
L["UI_BACK"] = "Back";
L["UI_ADDFORM_ERR_NO_INPUT"] = "Term field is empty!";

L["UI_RMALL_TITLE"] = "Delete Everything";
L["UI_RMALL_DESC"] = "Delete all entries from the list?";
L["UI_RMALL_REMOVE"] = "Delete";
L["UI_CANCEL"] = "Cancel";

L["UI_MMB_OPEN"] = "Open " .. _addonName;