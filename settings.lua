local _addonName, _addon = ...;
local L = _addon:GetLocalization();

local DEFAULTSETTINGS = {
    ["firstStart"] = true,
    ["isActive"] = true,
    ["chatFrame"] = 1,
    ["soundId"] = "sound/interface/itellmessage.ogg",
    ["showMinimapButton"] = true,
    ["snapToMinimap"] = true,
    ["outputFormat"] = "", -- fill from localization
	["version"] = GetAddOnMetadata(_addonName, "Version")
};

local SOUNDS = {
    [""] = L["SOUND_NO_SOUND"],
    ["sound/Doodad/LightHouseFogHorn.ogg"] = "Fog horn", 		                    -- 567094
    ["sound/interface/itellmessage.ogg"] = "Whisper", 		                        -- 567421
    ["sound/character/dwarf/dwarfmale/dwarfmaledeatha.ogg"] = "Dwarf", 		        -- 539885
    ["sound/item/weapons/bow/arrowhitc.ogg"] = "Something", 	                    -- 567671
    ["sound/item/weapons/bow/arrowhita.ogg"] = "Something2",                        -- 567672
    ["sound/item/weapons/axe2h/m2haxehitmetalweaponcrit.ogg"] = "Hurts my ears"     -- 567653
};

--- Handle stuff after settings changed, if needed
local function AfterSettingsChange()
    _addon:MinimapButtonUpdate();
    if CChatNotifier_settings.snapToMinimap then
        _addon:MinimapButtonSnap();
    end
end

--- Setup SV tables, check settings and setup settings menu
function _addon:SetupSettings()
	if CChatNotifier_data == nil then
		CChatNotifier_data = {};
	end
    
    if CChatNotifier_settings == nil then
		CChatNotifier_settings = DEFAULTSETTINGS;
	end
    
	for k, v in pairs(DEFAULTSETTINGS) do
		if CChatNotifier_settings[k] == nil then
			CChatNotifier_settings[k] = v;
		end
	end
	for k, v in pairs(CChatNotifier_settings) do
		if DEFAULTSETTINGS[k] == nil then
			CChatNotifier_settings[k] = nil;
		end
	end

    local settings = _addon:GetSettingsBuilder();
    settings:Setup(CChatNotifier_settings, DEFAULTSETTINGS, nil, [[Interface\AddOns\CChatNotifier\img\logos]], 192, 48, nil, 16);
    settings:SetAfterSaveCallback(AfterSettingsChange);

    settings:MakeHeading(L["SETTINGS_HEAD_GENERAL"]);

    settings:MakeDropdown("chatFrame", L["SETTINGS_CHATFRAME"], L["SETTINGS_CHATFRAME_TT"], 100, function() 
        local chatWindows = {};
        for i = 1, NUM_CHAT_WINDOWS, 1 do
            local name, _, _, _, _, _, shown, _, docked = GetChatWindowInfo(i);
            if name ~= "" and (shown or docked)  then
                chatWindows[i] = name;
            end
        end
        return chatWindows;
    end, 138);

    settings:MakeDropdown("soundId", L["SETTINGS_SOUNDID"], L["SETTINGS_SOUNDID_TT"], 100, function() 
        return SOUNDS;
    end, 138);

    local row = settings:MakeSettingsRow();
    settings:MakeCheckboxOption("showMinimapButton", L["SETTINGS_MINIMAP"], L["SETTINGS_MINIMAP_TT"], row);
    settings:MakeCheckboxOption("snapToMinimap", L["SETTINGS_SNAP_MINIMAP"], L["SETTINGS_SNAP_MINIMAP_TT"], row);

    settings:MakeHeading(L["SETTINGS_HEAD_FORMAT"]);
    settings:MakeStringRow(L["SETTINGS_FORMAT_DESC"], "LEFT");

    local formatEdit = settings:MakeEditBoxOption("outputFormat", nil, 200, false, nil, nil, 0);
    local prevString = settings:MakeStringRow();
    formatEdit:SetScript("OnTextChanged", function(self) 
        local oldFormat = CChatNotifier_settings.outputFormat;
        CChatNotifier_settings.outputFormat = formatEdit:GetText();
        local preview = _addon:FormNotifyMsg("mankrik", "1. General", GetUnitName("player"), "LFM mankriks wife exploration team!", 5, 11);
        prevString:SetText(preview);
        CChatNotifier_settings.outputFormat = oldFormat;
    end);

    row = settings:MakeSettingsRow();

    settings:MakeButton(L["SETTINGS_TEST_CHAT"], function() 
        local oldSound = CChatNotifier_settings.soundId;
        local oldFormat = CChatNotifier_settings.outputFormat;
        CChatNotifier_settings.outputFormat = formatEdit:GetText();
        if settings:GetTempSettings().soundId then
            CChatNotifier_settings.soundId = settings:GetTempSettings().soundId;
        end
        _addon:PostNotification(_addon:FormNotifyMsg("mankrik", L["VICINITY"], GetUnitName("player"), 
            "LFM mankriks wife exploration team!", 5, 11), settings:GetTempSettings().chatFrame or CChatNotifier_settings.chatFrame);
        CChatNotifier_settings.soundId = oldSound;
        CChatNotifier_settings.outputFormat = oldFormat;
    end, row);

    settings:MakeButton(L["SETTINGS_FORMAT_RESET"], function() 
        CChatNotifier_settings.outputFormat = L["CHAT_NOTIFY_FORMAT"];
        formatEdit:SetText(CChatNotifier_settings.outputFormat);
        formatEdit:SetCursorPosition(0);
    end, row);
end