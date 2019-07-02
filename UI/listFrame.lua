local _addonName, _addon = ...;
local L = _addon:GetLocalization();
local LISTITEMHEIGHT = 27;

--------------------------------
-- Setup UI elements
--------------------------------
local listElements = {};
local listElemCount = 0;

-- Main frame
local listFrame = CreateFrame("Frame", "CChatNotifierListUI", UIParent, "ButtonFrameTemplate");
listFrame:SetPoint("CENTER", 0, 0);
listFrame:SetWidth(275);
listFrame:SetHeight(340);
listFrame:SetResizable(true);
listFrame:SetClampedToScreen(true);
listFrame:SetMaxResize(400, 449);
listFrame:SetMinResize(250, 340);
listFrame:SetMovable(true);
listFrame:EnableMouse(true);
listFrame:RegisterForDrag("LeftButton");
listFrame:SetScript("OnDragStart", listFrame.StartMoving);
listFrame:SetScript("OnDragStop", listFrame.StopMovingOrSizing);
listFrame.TitleText:SetText(_addonName);
listFrame.portrait:SetTexture([[Interface\AddOns\CChatNotifier\img\logo]]);
listFrame:Hide();

-- Delete button for delete all function
local deleteButton = CreateFrame("Button", nil, listFrame);
deleteButton:SetSize(18, 18);
deleteButton:SetPoint("TOPRIGHT", -15, -35);
deleteButton:SetNormalTexture([[Interface\AddOns\CChatNotifier\img\trash]]);
deleteButton:SetHighlightTexture([[Interface\AddOns\CChatNotifier\img\trash]]);

-- Add button for switching to add content
local addButton = CreateFrame("Button", nil, listFrame);
addButton:SetSize(15, 15);
addButton:SetPoint("RIGHT", deleteButton, "LEFT", -15, 0);
addButton:SetNormalTexture([[Interface\AddOns\CChatNotifier\img\iplus]]);
addButton:SetHighlightTexture([[Interface\AddOns\CChatNotifier\img\iplus]]);

-- Add button for toggling addon on/off
local toggleButton = CreateFrame("Button", nil, listFrame);
toggleButton:SetSize(15, 15);
toggleButton:SetPoint("RIGHT", addButton, "LEFT", -15, 0);
toggleButton:SetNormalTexture([[Interface\AddOns\CChatNotifier\img\on]]);
toggleButton:SetHighlightTexture([[Interface\AddOns\CChatNotifier\img\on]]);

-- Settings button
local settingsButton = CreateFrame("Button", nil, listFrame);
settingsButton:SetSize(18, 18);
settingsButton:SetPoint("TOPLEFT", 70, -35);
settingsButton:SetNormalTexture([[interface/scenarios/scenarioicon-interact.blp]]);
settingsButton:SetHighlightTexture([[interface/scenarios/scenarioicon-interact.blp]]);

-- Resize knob
local resizeButton = CreateFrame("Button", nil, listFrame);
resizeButton:SetSize(18, 18);
resizeButton:SetPoint("BOTTOMRIGHT", -3, 3);
resizeButton:SetNormalTexture([[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Up]]);
resizeButton:SetHighlightTexture([[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Highlight]]);
resizeButton:SetPushedTexture([[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Down]]);

-- Subframe with scroll list of targets
local scrollFrame = CreateFrame("ScrollFrame", "CChatNotifierListUIScroll", listFrame.Inset, "UIPanelScrollFrameTemplate2");
local scrollChild = CreateFrame("Frame", nil, scrollFrame);
scrollFrame:SetPoint("TOPLEFT", 3, -3);
scrollFrame:SetPoint("BOTTOMRIGHT", -5, 3);
scrollFrame:SetClipsChildren(true);
scrollFrame.ScrollBar:ClearAllPoints();
scrollFrame.ScrollBar:SetPoint("TOPRIGHT", scrollFrame, "TOPRIGHT", 0, -17);
scrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", 0, 17);
scrollChild:SetSize(scrollFrame:GetWidth()-24, 100);
scrollFrame:SetScrollChild(scrollChild);

--- Make a basic content frame
-- @param name The object name
-- @param title The title to show
local function MakeSubFrame(name, title)
    local sframe = CreateFrame("Frame", name, listFrame.Inset);
    sframe:SetPoint("TOPLEFT", 0, 0);
    sframe:SetPoint("BOTTOMRIGHT", 0, 0);
    sframe:Hide();
    sframe.title = sframe:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2");
    sframe.title:SetPoint("TOPLEFT", 20, -15);
    sframe.title:SetPoint("TOPRIGHT", -20, -15);
    sframe.title:SetText(title);
    return sframe;
end

--- Make an editbox
-- @param parent The parent frame
-- @param maxLen Maxmimum input length
-- @param height (optional)
-- @param isMultiline (optional)
local function MakeEditBox(parent, maxLen, height, isMultiline)
    local edit = CreateFrame("EditBox", nil, parent);
    edit:SetMaxLetters(maxLen);
    edit:SetAutoFocus(false);
    if height then
        edit:SetHeight(height);
    end
    edit:SetFont("Fonts\\FRIZQT__.TTF", 11);
    edit:SetJustifyH("LEFT");
    edit:SetJustifyV("CENTER");
    edit:SetTextInsets(7,7,7,7);
    edit:SetBackdrop({
        bgFile = [[Interface\Buttons\WHITE8x8]],
        edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
        edgeSize = 14,
        insets = {left = 3, right = 3, top = 3, bottom = 3},
    });
    edit:SetBackdropColor(0, 0, 0);
    edit:SetBackdropBorderColor(0.3, 0.3, 0.3);
    if isMultiline then
        edit:SetSpacing(3);
        edit:SetMultiLine(true);
    end
    edit:SetScript("OnEnterPressed", function(self) self:ClearFocus(); end);
    edit:SetScript("OnEscapePressed", function(self) self:ClearFocus(); end);
    edit:SetScript("OnEditFocusLost", function(self) EditBox_ClearHighlight(self); end);

    return edit;
end

-- Subframe with add form
local addFrame = MakeSubFrame(nil, L["UI_ADDFORM_TITLE"]);
addFrame.searchLabel = addFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
addFrame.searchLabel:SetPoint("TOPLEFT", addFrame.title, "BOTTOMLEFT", 0, -16);
addFrame.searchLabel:SetPoint("TOPRIGHT", addFrame.title, "BOTTOMRIGHT", 0, -16);
addFrame.searchLabel:SetText(L["UI_ADDFORM_NAME"]);
addFrame.searchLabel:SetJustifyH("LEFT");
addFrame.searchEdit = MakeEditBox(addFrame, 40, 27, false);
addFrame.searchEdit:SetPoint("TOPLEFT", addFrame.searchLabel, "BOTTOMLEFT", 0, -4);
addFrame.searchEdit:SetPoint("TOPRIGHT", addFrame.searchLabel, "BOTTOMRIGHT", 0, -4);
addFrame.okbutton = CreateFrame("Button", nil, addFrame, "OptionsButtonTemplate");
addFrame.okbutton:SetText(L["UI_ADDFORM_ADD_BUTTON"]);
addFrame.okbutton:SetPoint("TOPLEFT", addFrame.searchEdit, "BOTTOMLEFT", 0, -10);
addFrame.okbutton:SetWidth(125);
addFrame.backbutton = CreateFrame("Button", nil, addFrame, "OptionsButtonTemplate");
addFrame.backbutton:SetText(L["UI_BACK"]);
addFrame.backbutton:SetPoint("TOPRIGHT", addFrame.searchEdit, "BOTTOMRIGHT", 0, -10);
addFrame.backbutton:SetWidth(75);

-- Subframe with delete all form
local deleteAllFrame = MakeSubFrame(nil, L["UI_RMALL_TITLE"]);
deleteAllFrame.desc = deleteAllFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
deleteAllFrame.desc:SetPoint("TOPLEFT", deleteAllFrame.title, "BOTTOMLEFT", 0, -16);
deleteAllFrame.desc:SetPoint("TOPRIGHT", deleteAllFrame.title, "BOTTOMRIGHT", 0, -16);
deleteAllFrame.desc:SetText(L["UI_RMALL_DESC"]);
deleteAllFrame.desc:SetJustifyH("LEFT");
deleteAllFrame.desc:SetJustifyV("CENTER");
deleteAllFrame.okbutton = CreateFrame("Button", nil, deleteAllFrame, "OptionsButtonTemplate");
deleteAllFrame.okbutton:SetText(L["UI_RMALL_REMOVE"]);
deleteAllFrame.okbutton:SetPoint("TOPLEFT", deleteAllFrame.desc, "BOTTOMLEFT", 0, -10);
deleteAllFrame.okbutton:SetWidth(125);
deleteAllFrame.backbutton = CreateFrame("Button", nil, deleteAllFrame, "OptionsButtonTemplate");
deleteAllFrame.backbutton:SetText(L["UI_CANCEL"]);
deleteAllFrame.backbutton:SetPoint("TOPRIGHT", deleteAllFrame.desc, "BOTTOMRIGHT", 0, -10);
deleteAllFrame.backbutton:SetWidth(75);


--------------------------------
-- UI functions
--------------------------------

-- Resize scrollchild while resizing, has no anchors
resizeButton:SetScript("OnMouseDown", function(self, button) 
    listFrame:StartSizing("BOTTOMRIGHT");
    resizeButton:SetScript("OnUpdate", function() 
        scrollChild:SetWidth(scrollFrame:GetWidth()-24);
    end); 
end);
resizeButton:SetScript("OnMouseUp", function(self, button) 
    listFrame:StopMovingOrSizing(); 
    resizeButton:SetScript("OnUpdate", nil);
    scrollChild:SetWidth(scrollFrame:GetWidth()-24);
end);

--- Switch displayed content
-- @param frame Which frame to show, "LIST", "ADD", "RM", defaults to "LIST"
local function ShowSubFrame(frame)
    if frame == "ADD" then
        addFrame:Show();
        scrollFrame:Hide();
        deleteAllFrame:Hide();
        return;
    end

    if frame == "RM" then
        addFrame:Hide();
        scrollFrame:Hide();
        deleteAllFrame:Show();
        return;
    end

    scrollFrame:Show();
    addFrame:Hide();
    deleteAllFrame:Hide();
end

--- Update to current addon state
local function ToggleUpdate()
    if CChatNotifier_settings.isActive then
        toggleButton:SetNormalTexture([[Interface\AddOns\CChatNotifier\img\on]]);
        toggleButton:SetHighlightTexture([[Interface\AddOns\CChatNotifier\img\on]]);
        listFrame.portrait:SetTexture([[Interface\AddOns\CChatNotifier\img\logo]]);
        listFrame.TitleText:SetTextColor(1, 0.82, 0, 1);
    else
        toggleButton:SetNormalTexture([[Interface\AddOns\CChatNotifier\img\off]]);
        toggleButton:SetHighlightTexture([[Interface\AddOns\CChatNotifier\img\off]]);
        listFrame.portrait:SetTexture([[Interface\AddOns\CChatNotifier\img\logoo]]);
        listFrame.TitleText:SetTextColor(1, 0, 0, 1);
    end
end

--- Open settings menu
settingsButton:SetScript("OnClick", function(self) 
    InterfaceOptionsFrame_OpenToCategory(_addonName);
    InterfaceOptionsFrame_OpenToCategory(_addonName);
end);

--- Open add subframe when plus is clicked
addButton:SetScript("OnClick", function(self) 
    if addFrame:IsShown() then
        return;
    end
    _addon:ShowAddForm();
end);

--- Toggle addon on/off
toggleButton:SetScript("OnClick", function(self) 
    _addon:ToggleAddon();
    ToggleUpdate();
end);

--- Show dropdown when delete context button is clicked
deleteButton:SetScript("OnClick", function(self) 
    ShowSubFrame("RM");
end);

-- Delete all frame buttons
deleteAllFrame.okbutton:SetScript("OnClick", function(self) 
    _addon:ClearList();
    ShowSubFrame("LIST");
end);
deleteAllFrame.backbutton:SetScript("OnClick", function(self) 
    ShowSubFrame("LIST");
end);

-- Add frame buttons
addFrame.okbutton:SetScript ("OnClick", function (self)
    local sstring = addFrame.searchEdit:GetText();
    sstring = strtrim(sstring);
    if string.len(sstring) == 0 then
        _addon:PrintError(L["UI_ADDFORM_ERR_NO_INPUT"]);
		return;
    end
	_addon:AddToList(sstring);
	ShowSubFrame("LIST");
end);
addFrame.backbutton:SetScript ("OnClick", function (self)
	ShowSubFrame("LIST");
end);

--- Create a list element
-- @param pos The position to create it for
local function CreateListElement(pos)
    if listElements[pos] ~= nil then 
        return; 
    end
	
	local item = CreateFrame("Frame", nil, scrollFrame);
	item:SetHeight(LISTITEMHEIGHT);
	
	if pos == 1 then
		item:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, 0);
		item:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, 0);
	else
		item:SetPoint("TOPLEFT", listElements[pos-1], "BOTTOMLEFT", 0, 0);
		item:SetPoint("TOPRIGHT", listElements[pos-1], "BOTTOMRIGHT", 0, 0);
	end
	
    item:SetBackdrop({bgFile = [[Interface\AddOns\CChatNotifier\img\bar]]});
    item:SetBackdropColor(0.2,0.2,0.2,0.8);
	
	item.searchString = item:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    item.searchString:SetPoint("LEFT", 10, 0);
    item.searchString:SetPoint("RIGHT", -70, 0);
    item.searchString:SetHeight(10);
    item.searchString:SetJustifyH("LEFT");
    
	item.delb = CreateFrame("Button", nil, item);
	item.delb:SetWidth(12);
	item.delb:SetHeight(12);
	item.delb:SetPoint("RIGHT", item, "RIGHT", -10, 0);
	item.delb:SetNormalTexture([[Interface\AddOns\CChatNotifier\img\iclose]]);
	item.delb:SetHighlightTexture([[Interface\AddOns\CChatNotifier\img\iclose]]);

    item.delb:SetScript("OnClick", function(self)
		_addon:RemoveFromList(self:GetParent().searchString:GetText());
	end)

    item.disb = CreateFrame("Button", nil, item);
	item.disb:SetWidth(12);
	item.disb:SetHeight(12);
	item.disb:SetPoint("RIGHT", item.delb, "LEFT", -17, 0);
	item.disb:SetNormalTexture([[Interface\AddOns\CChatNotifier\img\on]]);
	item.disb:SetHighlightTexture([[Interface\AddOns\CChatNotifier\img\on]]);

    item.disb:SetScript("OnClick", function(self)
        local isOn = _addon:ToggleEntry(self:GetParent().searchString:GetText());
        if isOn then
            self:SetNormalTexture([[Interface\AddOns\CChatNotifier\img\on]]);
            self:SetHighlightTexture([[Interface\AddOns\CChatNotifier\img\on]]);
            self:GetParent():SetBackdropColor(0.2,0.2,0.2,0.8);
            self:GetParent().searchString:SetTextColor(1, 1, 1, 1);
        else
            self:SetNormalTexture([[Interface\AddOns\CChatNotifier\img\off]]);
            self:SetHighlightTexture([[Interface\AddOns\CChatNotifier\img\off]]);
            self:GetParent():SetBackdropColor(0.2,0.2,0.2,0.4);
            self:GetParent().searchString:SetTextColor(0.5, 0.5, 0.5, 1);
        end
	end)
	
	listElemCount = pos;
	listElements[pos] = item;
end


--------------------------------
-- Addon functions
--------------------------------

--- Fill list from SV data
function _addon:FillList()
	local count = 0;
	local tkeys = {};
	for k in pairs(CChatNotifier_data) do 
		table.insert(tkeys, k);
		count = count + 1;
	end
	table.sort(tkeys);
	
	local curitm, curdta;
	for i, search in ipairs(tkeys) do
		CreateListElement(i);
		curitm = listElements[i];
        curdta = CChatNotifier_data[search];
		curitm.searchString:SetText(search);
		
		if curdta.active then
			curitm.disb:SetNormalTexture([[Interface\AddOns\CChatNotifier\img\on]]);
            curitm.disb:SetHighlightTexture([[Interface\AddOns\CChatNotifier\img\on]]);
            curitm.disb:GetParent():SetBackdropColor(0.2,0.2,0.2,0.8);
            curitm.searchString:SetTextColor(1, 1, 1, 1);
		else
			curitm.disb:SetNormalTexture([[Interface\AddOns\CChatNotifier\img\off]]);
            curitm.disb:SetHighlightTexture([[Interface\AddOns\CChatNotifier\img\off]]);
            curitm.disb:GetParent():SetBackdropColor(0.2,0.2,0.2,0.4);
            curitm.searchString:SetTextColor(0.5, 0.5, 0.5, 1);
		end
		
		curitm:Show();
	end
	
	for i = count + 1, listElemCount, 1 do
		listElements[i]:Hide();
	end
	
	scrollChild:SetHeight(count*LISTITEMHEIGHT);
end

--- Show the add form
-- @param search A search string to prefill (optional)
function _addon:ShowAddForm(search)
    if search == nil and listFrame:IsShown() and addFrame:IsShown() then 
        return; 
    end
    
	addFrame.searchEdit:SetText("");
	if search ~= nil then
		addFrame.searchEdit:SetText(search);
		addFrame.searchEdit:SetCursorPosition(0);
    else
        addFrame.searchEdit:SetFocus();
    end
    
    listFrame:Show();
    ShowSubFrame("ADD");
end

--- Open the main list frame
function _addon:OpenList()
    listFrame:Show();
    ShowSubFrame("LIST");
    scrollChild:SetWidth(scrollFrame:GetWidth()-24);
    ToggleUpdate();
end