-- TODO: replace with lib version from other addon later

local _addonName, _addon = ...;
local L = _addon:GetLocalization();

local DEFAULTSETTINGS = {
    ["firstStart"] = true,
    ["isActive"] = true,
    ["chatFrame"] = 1,
    ["playSound"] = true,
    ["soundId"] = 567421,
    ["showMinimapButton"] = true,
    ["snapToMinimap"] = true,
    ["outputFormat"] = "", -- fill from localization
	["version"] = GetAddOnMetadata(_addonName, "Version")
};

local SOUNDS = {
    [567094] = "Fog horn", -- sound/Doodad/LightHouseFogHorn.ogg
    [567421] = "Whisper", --sound/interface/itellmessage.ogg
    [539885] = "Dwarf", -- sound/character/dwarf/dwarfmale/dwarfmaledeatha.ogg
    [567671] = "Something", -- sound/item/weapons/bow/arrowhitc.ogg	
    [567672] = "Something2", -- sound/item/weapons/bow/arrowhita.ogg
    [567653] = "Hurts my ears", -- sound/item/weapons/axe2h/m2haxehitmetalweaponcrit.ogg
};

local ROW_V_SPACE = 20;
local tempSettings = {};
local inputs = {};

local settingsPanel = CreateFrame("FRAME");
settingsPanel.name = _addonName;

local vinfo = settingsPanel:CreateFontString(nil, nil, 'GameFontDisableSmall');
vinfo:SetPoint('BOTTOMRIGHT', -10, 6);
vinfo:SetText("Version " .. GetAddOnMetadata(_addonName, "Version"));

local logo = settingsPanel:CreateTexture (nil, "overlay");
logo:SetPoint("TOPLEFT", settingsPanel, "TOPLEFT", 20, -20);
logo:SetTexture ([[Interface\AddOns\CChatNotifier\img\logos]]);
logo:SetSize(192, 48);

--------------------------------
-- Builder functions
--------------------------------
local lastline = nil;

--- Create settings row
-- @param height Custom height (optional)
-- @return The row frame object
local function MakeSettingsRow(height)
    if height == nil then 
        height = 35; 
    end

	local frame = CreateFrame("Frame", nil, settingsPanel);
	frame:SetHeight(height);
	
	if lastline == nil then
		frame:SetPoint("TOPLEFT", 10, -70);
		frame:SetPoint("TOPRIGHT", -10, -70);
	else
		frame:SetPoint("TOPLEFT", lastline, "BOTTOMLEFT", 0, 0);
		frame:SetPoint("TOPRIGHT", lastline, "BOTTOMRIGHT", 0, 0);
	end
    
    frame.anchorAt = 0;

	lastline = frame;
	return frame;
end

--- Create checkbox option
-- @param settingName The key in the settings saved vars
-- @param text The label text
-- @param tooltip The tooltip text
-- @param row Row to insert it into, if nit row is created (optional)
-- @return The checkbox frame object
local function MakeCheckboxOption(settingName, text, tooltip, row)
    if row == nil then 
        row = MakeSettingsRow(); 
    end

	local cb = CreateFrame("CheckButton", _addonName .. settingName .. "CB", row, "ChatConfigCheckButtonTemplate");
	cb.settingName = settingName;
	cb.tooltip = tooltip;
	_G[_addonName .. settingName .. "CBText"]:SetText(" " .. text);
	cb:SetPoint("LEFT", row.anchorAt, 0);
	cb:SetScript("OnClick", function(self) 
		tempSettings[self.settingName] = self:GetChecked();
	end);

	cb.RefreshState = function(self) 
		self:SetChecked(CChatNotifier_settings[settingName]);
	end

    cb:SetHitRectInsets(0, -(text:len()*6), 0, 0);
    row.anchorAt = row.anchorAt + cb:GetWidth() + _G[_addonName .. settingName .. "CBText"]:GetStringWidth() + ROW_V_SPACE;

	inputs[settingName] = cb;
	return cb;
end

--- Create button
-- @param text The button text
-- @param func The function to use on click
-- @param row Row to insert it into, if nit row is created (optional)
-- @return The button frame object
local function MakeButton(text, func, row)
    if row == nil then 
        row = MakeSettingsRow(); 
    end

	local button = CreateFrame ("Button", nil, row, "OptionsButtonTemplate");
    button:SetText (text);
	button:SetPoint ("LEFT", row.anchorAt, 0);
	button:SetWidth (text:len() * 7 + 15);
    button:SetScript ("OnClick", func);
    row.anchorAt = row.anchorAt + button:GetWidth() + ROW_V_SPACE;

	return button;
end

--- Create dropdown
-- @param settingName The key in the settings saved vars
-- @param label The label text
-- @param tooltip The tooltip text
-- @param func The function to get list items from (value is displayed name)
-- @param row Row to insert it into, if nit row is created (optional)
-- @return The button frame object
local function MakeDropdown(settingName, label, tooltip, func, row)
    if row == nil then 
        row = MakeSettingsRow(); 
    end

    local dropDown = CreateFrame("Frame", nil, row, "UIDropDownMenuTemplate");
    dropDown.settingName = settingName;
    dropDown.Text:SetJustifyH("LEFT");
    UIDropDownMenu_SetWidth(dropDown, 100);
    UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo();
        info.func = function(self, arg1, arg2) 
            tempSettings[settingName] = arg1;
            UIDropDownMenu_SetText(dropDown, arg2);
        end;
        for k, v in pairs(func()) do
            info.text = v;
            info.arg1 = k;
            info.arg2 = v;
            if tempSettings[settingName] ~= nil then
                info.checked = (k == tempSettings[settingName]);
            else
                info.checked = (k == CChatNotifier_settings[settingName]);
            end
            UIDropDownMenu_AddButton(info);
        end
    end);

    dropDown.label = dropDown:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	dropDown.label:SetPoint("LEFT", row, "LEFT", row.anchorAt, 0);
    dropDown.label:SetText(label);
    dropDown:SetPoint("LEFT", row, "LEFT", dropDown.label:GetStringWidth() + row.anchorAt, 0);

    dropDown.RefreshState = function(self) 
        local optionName = "NOT SET!";
        for k,v in pairs(func()) do
            if k == CChatNotifier_settings[settingName] then
                optionName = v;
                break;
            end
        end
        UIDropDownMenu_SetText(dropDown, optionName);
    end;
    
    dropDown:SetScript("OnEnter", function(self) 
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT");
        GameTooltip:SetText(tooltip);
        GameTooltip:Show();
    end);
    dropDown:SetScript("OnLeave", function(self) 
        GameTooltip:Hide();
    end);

    inputs[settingName] = dropDown;
    row.anchorAt = row.anchorAt + dropDown:GetWidth() + dropDown.label:GetStringWidth() - 15 + ROW_V_SPACE;
	return dropDown;
end

--- Create editbox option
-- @param settingName The key in the settings saved vars
-- @param label The label text
-- @param max The max text length
-- @param numeric Is the editbox numeric only
-- @param tooltip The tooltip text
-- @param row Row to insert it into, if nit row is created (optional)
-- @param maxWidth If true will take the whole width possible (optional)
-- @return The editbox frame object
local function MakeEditBoxOption(settingName, label, max, numeric, tooltip, row, maxWidth)
    if row == nil then 
        row = MakeSettingsRow(); 
    end

	local edit = CreateFrame("EditBox", nil, row, "InputBoxTemplate");
    edit.settingName = settingName;
    edit.isEditBox = true;
	edit:SetMaxLetters(max);
	edit:SetAutoFocus(false);
	edit:SetHeight(15);
	if numeric then edit:SetNumeric(true) end
    edit:SetScript("OnEnterPressed", function(self) self:ClearFocus(); end);
    edit:SetScript("OnEscapePressed", function(self) self:ClearFocus(); end);
	edit:SetScript("OnEditFocusLost", function(self)
		EditBox_ClearHighlight(self);
		if self:IsNumeric() then
			tempSettings[self.settingName] = self:GetNumber();
		else
			tempSettings[self.settingName] = self:GetText();
		end
	end)
	edit.label = edit:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	edit.label:SetPoint("LEFT", row, "LEFT", row.anchorAt, 0);
    edit.label:SetText(label);
    local offset = 15;
    if label == nil then 
        offset = 5; 
    end
    edit:SetPoint("LEFT", edit.label, "RIGHT", offset, 0);
    if maxWidth then
        edit:SetPoint("RIGHT", row, "RIGHT", 0, 0);
    else
        edit:SetWidth(7*max + 10);
    end
    
	if tooltip then
		edit:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
            GameTooltip:SetText(tooltip, 1, 0.8, 0, 1, true);
			GameTooltip:Show()
		end)
		edit:SetScript("OnLeave", function() GameTooltip:Hide(); end);
	end
	
    edit.RefreshState = function(self) 
		self:SetText(CChatNotifier_settings[self.settingName]);
		self:SetCursorPosition(0);
	end
    
    row.anchorAt = row.anchorAt + 110 + 8*max + 15 + ROW_V_SPACE;
    print(edit);
	inputs[settingName] = edit;
	return edit;
end

--- Create heading
-- @param ttext The title string
local function MakeHeading(ttext)
    local row = MakeSettingsRow(45);
    row.label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2");
	row.label:SetPoint("LEFT", row, "LEFT", 0, -7);
	row.label:SetText(ttext);
end

--- Create row with fontstring
-- @param initialText Initial text to set, height will be set to fit it
-- @param justify The justifyH value, optional
-- @return the fontstring object
local function MakeStringRow(initialText, justify)
    local row = MakeSettingsRow(400);
    local fstring = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    fstring:SetAllPoints();
    if justify ~= nil then
        fstring:SetJustifyH(justify);
    end
    fstring:SetSpacing(2);
    fstring:SetText(initialText);
    local hi = fstring:GetStringHeight();
    if hi < 30 then
        hi = 30;
    end
    row:SetHeight(hi);
    return fstring;
end

--------------------------------
-- Panel functions
--------------------------------

settingsPanel.refresh = function()
	for _,v in pairs(inputs) do
		v:RefreshState();
	end
end

settingsPanel.okay = function()
	-- handle edit fields that aren't entered when button is pressed
	for k, v in pairs(inputs) do
		if v.isEditBox then
			if v:IsNumeric() then
				tempSettings[k] = v:GetNumber();
			else
				tempSettings[k] = v:GetText();
			end
		end
	end
    
    for k, v in pairs(tempSettings) do
		CChatNotifier_settings[k] = v;
	end

    _addon:MinimapButtonUpdate();
    if CChatNotifier_settings.snapToMinimap then
        _addon:MinimapButtonSnap();
    end
end

settingsPanel.cancel = function()
	wipe(tempSettings);
end

settingsPanel.default = function()
	wipe(tempSettings);
	for k, v in pairs(DEFAULTSETTINGS) do
		CChatNotifier_settings[k] = v;
	end
end

InterfaceOptions_AddCategory(settingsPanel);


--------------------------------
-- Addon functions
--------------------------------

--- Setup SV and settings panel
function _addon:SetupSettings()
	if CChatNotifier_data == nil then
		CChatNotifier_data = {};
	end
    
    if CChatNotifier_settings == nil then
		CChatNotifier_settings = DEFAULTSETTINGS;
	end

    MakeDropdown("chatFrame", L["SETTINGS_CHATFRAME"], L["SETTINGS_CHATFRAME_TT"], function() 
        local chatWindows = {};
        for i = 1, NUM_CHAT_WINDOWS, 1 do
            local name, _, _, _, _, _, shown, _, docked = GetChatWindowInfo(i);
            if name ~= "" and (shown or docked)  then
                chatWindows[i] = name;
            end
        end
        return chatWindows;
    end);

    local row = MakeSettingsRow();
    MakeDropdown("soundId", L["SETTINGS_SOUNDID"], L["SETTINGS_SOUNDID_TT"], function() 
        return SOUNDS;
    end, row);
    MakeCheckboxOption("playSound", L["SETTINGS_PLAY_SOUND"], L["SETTINGS_PLAY_SOUND_TT"], row);

    row = MakeSettingsRow();
    MakeCheckboxOption("showMinimapButton", L["SETTINGS_MINIMAP"], L["SETTINGS_MINIMAP_TT"], row);
    MakeCheckboxOption("snapToMinimap", L["SETTINGS_SNAP_MINIMAP"], L["SETTINGS_SNAP_MINIMAP_TT"], row);

    MakeHeading(L["SETTINGS_HEAD_FORMAT"]);
    MakeStringRow(L["SETTINGS_FORMAT_DESC"], "LEFT");
    local formatEdit = MakeEditBoxOption("outputFormat", nil, 200, false, nil, nil, true);
    local prevString = MakeStringRow();
    formatEdit:SetScript("OnTextChanged", function(self) 
        local oldFormat = CChatNotifier_settings.outputFormat;
        CChatNotifier_settings.outputFormat = formatEdit:GetText();
        local testlkel = _addon:FormNotifyMsg("mankrik", "1. General", GetUnitName("player"), "LFM mankriks wife exploration team!", 5, 11);
        prevString:SetText(testlkel);
        CChatNotifier_settings.outputFormat = oldFormat;
    end);

    row = MakeSettingsRow();
    MakeButton(L["SETTINGS_TEST_CHAT"], function() 
        local oldSound = CChatNotifier_settings.soundId;
        local oldFormat = CChatNotifier_settings.outputFormat;
        CChatNotifier_settings.outputFormat = formatEdit:GetText();
        if tempSettings.soundId then
            CChatNotifier_settings.soundId = tempSettings.soundId;
        end
        _addon:PostNotification(_addon:FormNotifyMsg("mankrik", L["VICINITY"], GetUnitName("player"), "LFM mankriks wife exploration team!", 5, 11), tempSettings.chatFrame or CChatNotifier_settings.chatFrame);
        CChatNotifier_settings.soundId = oldSound;
        CChatNotifier_settings.outputFormat = oldFormat;
    end, row);
    MakeButton(L["SETTINGS_FORMAT_RESET"], function() 
        CChatNotifier_settings.outputFormat = L["CHAT_NOTIFY_FORMAT"];
        formatEdit:SetText(CChatNotifier_settings.outputFormat);
        formatEdit:SetCursorPosition(0);
    end, row);

    settingsPanel.refresh();
end