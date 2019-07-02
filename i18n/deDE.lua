local _addonName, _addon = ...;
local L = _addon:AddLocalization("deDE", true);
if L == nil then return; end

L["FIRST_START_MSG"] = "|cFF00FF00" .. _addonName .. "|r|cFFffb178: Listen-UI kann mit /ccn oder dem Button an der Minimap geöffnet werden. Den Button kannst du in den Einstellungen verstecken.";

L["CHAT_NOTIFY_FOUND_SAYYELL"] = "Begriff |cFF00FF00%s|r gefunden! |cFFFF66FF|Hplayer:%s|h[%s]|h|r: %s";
L["CHAT_NOTIFY_FOUND_CHANNEL"] = "Begriff |cFF00FF00%s|r gefunden! |cFFFF66FF|Hplayer:%s|h[%s]|h|r in %s: %s";

L["SETTINGS_PLAY_SOUND"] = "Ton aktivieren";
L["SETTINGS_PLAY_SOUND_TT"] = "Spiele Ton wenn ein Schlüsselwort gefunden wurde.";
L["SETTINGS_TEST_CHAT"] = "Testen";
L["SETTINGS_CHATFRAME"] = "Chatfenster:";
L["SETTINGS_CHATFRAME_TT"] = "Wähle in welchem Chatfenster (Tab) die Benachrichtigung erscheinen soll.";
L["SETTINGS_MINIMAP"] = "Minimapbutton anzeigen";
L["SETTINGS_MINIMAP_TT"] = "Zeige Button zum Öffnen der Liste an. Alternativ kann /ccn verwendet werden.";
L["SETTINGS_SNAP_MINIMAP"] = "Button an Minimap einrasten";
L["SETTINGS_SNAP_MINIMAP_TT"] = "Raste den Minimapbutton an Rand der Minimap ein.";
L["SETTINGS_SOUNDID"] = "Benachrichtigungston:";
L["SETTINGS_SOUNDID_TT"] = "Wähle welcher Ton als Benachrichtigung abgespielt werden soll.";

L["UI_ADDFORM_TITLE"] = "Neue Suche";
L["UI_ADDFORM_NAME"] = "Gebe Suchbegriff(e) ein. Mehrere Wörter durch ein Komma trennen, nutze einen Punkt als Platzhalter:";
L["UI_ADDFORM_ADD_BUTTON"] = "Hinzufügen";
L["UI_BACK"] = "Zurück";
L["UI_ADDFORM_ERR_NO_INPUT"] = "Begriffsfeld ist leer!";

L["UI_RMALL_TITLE"] = "Alles Löschen";
L["UI_RMALL_DESC"] = "Alle Einträge aus der Liste löschen?";
L["UI_RMALL_REMOVE"] = "Löschen";
L["UI_CANCEL"] = "Abbrechen";

L["UI_MMB_OPEN"] = "Öffne " .. _addonName;