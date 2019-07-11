local _addonName, _addon = ...;
local L = _addon:AddLocalization("deDE", true);
if L == nil then return; end

L["FIRST_START_MSG"] = "|cFF00FF00" .. _addonName .. "|r|cFFffb178: Listen-UI kann mit /ccn oder dem Button an der Minimap geöffnet werden. Den Button kannst du in den Einstellungen verstecken.";

L["CHAT_NOTIFY_FOUND_SAYYELL"] = "Begriff |cFF00FF00%s|r gefunden! |cFFFF66FF|Hplayer:%s|h[%s]|h|r: %s";
L["CHAT_NOTIFY_FOUND_CHANNEL"] = "Begriff |cFF00FF00%s|r gefunden! |cFFFF66FF|Hplayer:%s|h[%s]|h|r in %s: %s";

L["CHAT_NOTIFY_FORMAT"] = "<<ccaaaa>>[{T}] <00ff00>{K}<> gefunden! [{S}]<ff66ff>[{P}]<>: <ffffaa>{MS}<00ff00>{MF}<ffffaa>{ME}";
L["ERR_NOTIFY_FORMAT_MISSING"] = "Kein Format festgelegt, gehe in die Einstellungen um eines zu erstellen, oder auf den Standardwert zurückzusetzen.";

L["SOUND_NO_SOUND"] = "- Kein Ton -";

L["SETTINGS_HEAD_GENERAL"] = "Allgemein";
L["SETTINGS_PLAY_SOUND"] = "Ton aktivieren";
L["SETTINGS_PLAY_SOUND_TT"] = "Spiele Ton wenn ein Schlüsselwort gefunden wurde.";
L["SETTINGS_TEST_CHAT"] = "Benachrichtigung testen";
L["SETTINGS_CHATFRAME"] = "Chatfenster:";
L["SETTINGS_CHATFRAME_TT"] = "Wähle in welchem Chatfenster (Tab) die Benachrichtigung erscheinen soll.";
L["SETTINGS_MINIMAP"] = "Minimapbutton anzeigen";
L["SETTINGS_MINIMAP_TT"] = "Zeige Button zum Öffnen der Liste an. Alternativ kann /ccn verwendet werden.";
L["SETTINGS_SNAP_MINIMAP"] = "Button an Minimap einrasten";
L["SETTINGS_SNAP_MINIMAP_TT"] = "Raste den Minimapbutton an Rand der Minimap ein.";
L["SETTINGS_SOUNDID"] = "Benachrichtigungston:";
L["SETTINGS_SOUNDID_TT"] = "Wähle welcher Ton als Benachrichtigung abgespielt werden soll.";
L["SETTINGS_HEAD_FORMAT"] = "Benachrichtigungsformat";
L["SETTINGS_FORMAT_DESC"] = 
[[Du kannst ein eigenes Format für Benachrichtigungen erstellen! Siehe Standardformat bezüglich Nutzung.

|cFFFFFF00Setze Farben mit:
|cFF00FFFF<RRGGBB>|r Färbt nachfolgenden Text. RRGGBB ist eine Hexfarbe, nutze google wenn nötig!
|cFF00FFFF<<RRGGBB>>|r Legt die Standardfarbe fest, weiß wenn nicht gesetzt.
|cFF00FFFF<>|r Nachfolgender Text hat wieder Standardfarbe.

|cFFFFFF00Platzhalter für Inhalt:
|cFF00FFFF{K}|r Das gefunde Schlüsselwort.
|cFF00FFFF{S}|r Der Quellenkanal der Nachricht.
|cFF00FFFF{P}|r Spielerlink der Verfassers.
|cFF00FFFF{MS}|r Anfang der Nachricht.
|cFF00FFFF{MF}|r Nachrichtenteil mit gefundenem Schlüsselwort.
|cFF00FFFF{ME}|r Der Rest der Nachricht.
|cFF00FFFF{T}|r Die aktuelle Serverzeit als hh:mm.]];
L["SETTINGS_FORMAT_RESET"] = "Format zurücksetzen";

L["VICINITY"] = "Umgebung";

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