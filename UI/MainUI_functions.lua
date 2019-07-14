local _addonName, _addon = ...;
local L = _addon:GetLocalization();

local HEIGHT_NO_CONTENT = 71;
local listItemHeight = CCNUI_MainUI.scrollFrame.items[1]:GetHeight();
local listElementCount = #CCNUI_MainUI.scrollFrame.items;
local maxElementCount = listElementCount;

local sortedEntries = {};
local entryCount = 0;

----------------------------------------------------------------------------------------------------------------
-- Top bar button actions
----------------------------------------------------------------------------------------------------------------

--- Open settings menu
CCNUI_MainUI.settingsBtn:SetScript("OnClick", function(self) 
    InterfaceOptionsFrame_OpenToCategory(_addonName);
    InterfaceOptionsFrame_OpenToCategory(_addonName);
end);

--- Open add frame
CCNUI_MainUI.addBtn:SetScript("OnClick", function(self)
    _addon:MainUI_ShowAddForm();
end);

--- Toggle addon on/off
CCNUI_MainUI.toggleBtn:SetScript("OnClick", function(self) 
    _addon:ToggleAddon();
    CCNUI_MainUI:UpdateAddonState();
end);

--- Open delete frame
CCNUI_MainUI.deleteBtn:SetScript("OnClick", function(self) 
    CCNUI_MainUI:ShowContent("RM");
end);


----------------------------------------------------------------------------------------------------------------
-- Content frame button actions
----------------------------------------------------------------------------------------------------------------

-- Delete all frame buttons
CCNUI_MainUI.deleteAllFrame.okbutton:SetScript("OnClick", function(self) 
    _addon:ClearList();
    CCNUI_MainUI:ShowContent("LIST");
end);
CCNUI_MainUI.deleteAllFrame.backbutton:SetScript("OnClick", function(self) 
    CCNUI_MainUI:ShowContent("LIST");
end);

-- Add frame buttons
CCNUI_MainUI.addFrame.okbutton:SetScript("OnClick", function (self)
    local sstring = CCNUI_MainUI.addFrame.searchEdit:GetText();
    sstring = strtrim(sstring);
    if string.len(sstring) == 0 then
        _addon:PrintError(L["UI_ADDFORM_ERR_NO_INPUT"]);
		return;
    end
	_addon:AddToList(sstring);
	CCNUI_MainUI:ShowContent("LIST");
end);
CCNUI_MainUI.addFrame.backbutton:SetScript("OnClick", function (self)
	CCNUI_MainUI:ShowContent("LIST");
end);


----------------------------------------------------------------------------------------------------------------
-- Control functions
----------------------------------------------------------------------------------------------------------------

--- Show the add form
-- @param search A search string to prefill (optional)
function _addon:MainUI_ShowAddForm(search)
    if search == nil and CCNUI_MainUI:IsShown() and CCNUI_MainUI.addFrame:IsShown() then 
        return; 
    end
    
	CCNUI_MainUI.addFrame.searchEdit:SetText("");
	if search ~= nil then
		CCNUI_MainUI.addFrame.searchEdit:SetText(search);
		CCNUI_MainUI.addFrame.searchEdit:SetCursorPosition(0);
    else
        CCNUI_MainUI.addFrame.searchEdit:SetFocus();
    end
    
    CCNUI_MainUI:Show();
    CCNUI_MainUI:ShowContent("ADD");
end

--- Update scroll frame 
local function UpdateScrollFrame()
    local scrollHeight = 0;
	if entryCount > 0 then
        scrollHeight = (entryCount - listElementCount) * listItemHeight;
        if scrollHeight < 0 then
            scrollHeight = 0;
        end
    end

    local maxRange = (entryCount - listElementCount) * listItemHeight;
    if maxRange < 0 then
        maxRange = 0;
    end

    CCNUI_MainUI.scrollFrame.ScrollBar:SetMinMaxValues(0, maxRange);
    CCNUI_MainUI.scrollFrame.ScrollBar:SetValueStep(listItemHeight);
    CCNUI_MainUI.scrollFrame.ScrollBar:SetStepsPerPage(listElementCount-1);

    if CCNUI_MainUI.scrollFrame.ScrollBar:GetValue() == 0 then
        CCNUI_MainUI.scrollFrame.ScrollBar.ScrollUpButton:Disable();
    else
        CCNUI_MainUI.scrollFrame.ScrollBar.ScrollUpButton:Enable();
    end

    if (CCNUI_MainUI.scrollFrame.ScrollBar:GetValue() - scrollHeight) == 0 then
        CCNUI_MainUI.scrollFrame.ScrollBar.ScrollDownButton:Disable();
    else
        CCNUI_MainUI.scrollFrame.ScrollBar.ScrollDownButton:Enable();
    end	

    for line = 1, listElementCount, 1 do
      local offsetLine = line + FauxScrollFrame_GetOffset(CCNUI_MainUI.scrollFrame);
      local item = CCNUI_MainUI.scrollFrame.items[line];
      if offsetLine <= entryCount then
        curdta = CChatNotifier_data[sortedEntries[offsetLine]];
        item.searchString:SetText(sortedEntries[offsetLine]);
		if curdta.active then
			item.disb:SetNormalTexture([[Interface\AddOns\CChatNotifier\img\on]]);
            item.disb:SetHighlightTexture([[Interface\AddOns\CChatNotifier\img\on]]);
            item.disb:GetParent():SetBackdropColor(0.2,0.2,0.2,0.8);
            item.searchString:SetTextColor(1, 1, 1, 1);
		else
			item.disb:SetNormalTexture([[Interface\AddOns\CChatNotifier\img\off]]);
            item.disb:SetHighlightTexture([[Interface\AddOns\CChatNotifier\img\off]]);
            item.disb:GetParent():SetBackdropColor(0.2,0.2,0.2,0.4);
            item.searchString:SetTextColor(0.5, 0.5, 0.5, 1);
        end
        item:Show();
      else
        item:Hide();
      end
    end
end

--- Recalculates height and shown item count
-- @param ignoreHeight If true will not resize and reanchor UI
local function RecalculateSize(ignoreHeight)
    local oldHeight = CCNUI_MainUI:GetHeight();
    local showCount = math.floor((oldHeight - HEIGHT_NO_CONTENT + (listItemHeight/2 + 2)) / listItemHeight);

    if ignoreHeight ~= true then
        local newHeight = showCount * listItemHeight + HEIGHT_NO_CONTENT;

        CCNUI_MainUI:SetHeight(newHeight);

        local point, relTo, relPoint, x, y = CCNUI_MainUI:GetPoint(1);
        local yadjust = 0;

        if point == "CENTER" or point == "LEFT" or point == "RIGHT" then
            yadjust = (oldHeight - newHeight) / 2;
        elseif point == "BOTTOM" or point == "BOTTOMRIGHT" or point == "BOTTOMLEFT" then
            yadjust = oldHeight - newHeight;
        end

        CCNUI_MainUI:ClearAllPoints();
        CCNUI_MainUI:SetPoint(point, relTo, relPoint, x, y + yadjust);
    end

    for i = 1, maxElementCount, 1 do
        if i > showCount then
            CCNUI_MainUI.scrollFrame.items[i]:Hide();
        end
    end

    listElementCount = showCount;
    UpdateScrollFrame();
end

--- Fill list from SV data
function _addon:MainUI_UpdateList()
	entryCount = 0;
	wipe(sortedEntries);
	for k in pairs(CChatNotifier_data) do 
		table.insert(sortedEntries, k);
		entryCount = entryCount + 1;
	end
    table.sort(sortedEntries);
    UpdateScrollFrame();
end

--- Open the main list frame
function _addon:MainUI_OpenList()
    CCNUI_MainUI:Show();
    CCNUI_MainUI:ShowContent("LIST");
    CCNUI_MainUI:UpdateAddonState();
    RecalculateSize(true);
    UpdateScrollFrame();
end


----------------------------------------------------------------------------------------------------------------
-- Resize behaviour
----------------------------------------------------------------------------------------------------------------

-- Trigger update on scroll action
CCNUI_MainUI.scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
    FauxScrollFrame_OnVerticalScroll(self, offset, listItemHeight, UpdateScrollFrame);
end);

CCNUI_MainUI.resizeBtn:SetScript("OnMouseDown", function(self, button) 
    CCNUI_MainUI:StartSizing("BOTTOMRIGHT"); 
end);

-- Resize snaps to full list items shown, updates list accordingly
CCNUI_MainUI.resizeBtn:SetScript("OnMouseUp", function(self, button) 
    CCNUI_MainUI:StopMovingOrSizing(); 
    RecalculateSize();
end);