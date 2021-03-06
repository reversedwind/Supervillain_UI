--[[
##############################################################################
_____/\\\\\\\\\\\____/\\\________/\\\__/\\\________/\\\__/\\\\\\\\\\\_       #
 ___/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_\/////\\\///__      #
  __\//\\\______\///__\//\\\______/\\\__\/\\\_______\/\\\_____\/\\\_____     #
   ___\////\\\__________\//\\\____/\\\___\/\\\_______\/\\\_____\/\\\_____    #
	______\////\\\________\//\\\__/\\\____\/\\\_______\/\\\_____\/\\\_____   #
	 _________\////\\\______\//\\\/\\\_____\/\\\_______\/\\\_____\/\\\_____  #
	  __/\\\______\//\\\______\//\\\\\______\//\\\______/\\\______\/\\\_____ #
	   _\///\\\\\\\\\\\/________\//\\\________\///\\\\\\\\\/____/\\\\\\\\\\\_#
		___\///////////___________\///___________\/////////_____\///////////_#
##############################################################################
S U P E R - V I L L A I N - U I   By: Munglunch                              #
##############################################################################
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
local ipairs    = _G.ipairs;
local type      = _G.type;
local error     = _G.error;
local pcall     = _G.pcall;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;
--[[ TABLE METHODS ]]--
local tremove, twipe = table.remove, table.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
local LSM = LibStub("LibSharedMedia-3.0")
local MOD = SV.SVQuest;
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local ROW_WIDTH = 300;
local ROW_HEIGHT = 24;
local INNER_HEIGHT = ROW_HEIGHT - 4;
local LARGE_ROW_HEIGHT = ROW_HEIGHT * 2;
local LARGE_INNER_HEIGHT = LARGE_ROW_HEIGHT - 4;

local NO_ICON = [[Interface\AddOns\SVUI\assets\artwork\Template\EMPTY]];

local OBJ_ICON_ACTIVE = [[Interface\COMMON\Indicator-Yellow]];
local OBJ_ICON_COMPLETE = [[Interface\COMMON\Indicator-Green]];
local OBJ_ICON_INCOMPLETE = [[Interface\COMMON\Indicator-Gray]];

local QUEST_ICON = [[Interface\AddOns\SVUI\assets\artwork\Quest\QUEST-INCOMPLETE-ICON]];
local QUEST_ICON_COMPLETE = [[Interface\AddOns\SVUI\assets\artwork\Quest\QUEST-COMPLETE-ICON]];
--[[ 
########################################################## 
SCRIPT HANDLERS
##########################################################
]]--
local PopUpButton_OnClick = function(self, button)
	local questIndex = self:GetID();
	if(questIndex and (questIndex ~= 0) and self.PopUpType) then
		local questID = select(8, GetQuestLogTitle(questIndex));
		if(self.PopUpType == "OFFER") then
			ShowQuestOffer(questID);
		else
			ShowQuestComplete(questID);
		end
		MOD.Headers["Popups"]:RemovePopup(questID)
	end
end
--[[ 
########################################################## 
TRACKER FUNCTIONS
##########################################################
]]--
local GetPopUpRow = function(self, index)
	if(not self.Rows[index]) then 
		local previousFrame = self.Rows[#self.Rows]
		local index = #self.Rows + 1;
		local row = CreateFrame("Frame", nil, self)
		if(previousFrame) then
			row:SetPoint("TOPLEFT", previousFrame, "BOTTOMLEFT", 0, -2);
			row:SetPoint("TOPRIGHT", previousFrame, "BOTTOMRIGHT", 0, -2);
		else
			row:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -2);
			row:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, -2);
		end
		row:SetHeightToScale(LARGE_ROW_HEIGHT);
		row.Button = CreateFrame("Button", nil, row)
		row.Button:SetPointToScale("TOPLEFT", row, "TOPLEFT", 0, 0);
		row.Button:SetPointToScale("BOTTOMRIGHT", row, "BOTTOMRIGHT", 0, 8);
		row.Button:SetStylePanel("Framed", "FramedTop")
		row.Button:SetPanelColor("yellow")
		row.Button:SetID(0)
		row.Button.PopUpType = nil;
		row.Button:SetScript("OnClick", PopUpButton_OnClick)
		row.Badge = CreateFrame("Frame", nil, row.Button)
		row.Badge:SetPointToScale("TOPLEFT", row.Button, "TOPLEFT", 4, -4);
		row.Badge:SetSizeToScale((LARGE_INNER_HEIGHT - 4), (LARGE_INNER_HEIGHT - 4));
		row.Badge:SetStylePanel("Fixed", "Inset")
		row.Badge.Icon = row.Badge:CreateTexture(nil,"OVERLAY")
		row.Badge.Icon:SetAllPointsIn(row.Badge);
		row.Badge.Icon:SetTexture(QUEST_ICON)
		row.Badge.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		row.Header = CreateFrame("Frame", nil, row.Button)
		row.Header:SetPointToScale("TOPLEFT", row.Badge, "TOPRIGHT", 4, -1);
		row.Header:SetPointToScale("BOTTOMRIGHT", row.Button, "BOTTOMRIGHT", -2, 2);
		row.Header:SetStylePanel("Default")
		row.Header.Text = row.Header:CreateFontString(nil,"OVERLAY")
		row.Header.Text:FontManager("questdialog", "LEFT");
		row.Header.Text:SetTextColor(1,1,0)
		row.Header.Text:SetText('')
		row.Header.Text:SetPointToScale("TOPLEFT", row.Header, "TOPLEFT", 0, 0);
		row.Header.Text:SetPointToScale("BOTTOMRIGHT", row.Header, "BOTTOMRIGHT", 0, 0);
		row.RowID = 0;
		self.Rows[index] = row;
		return row;
	end

	return self.Rows[index];
end

local SetPopupRow = function(self, index, title, popUpType, questID, questLogIndex)
	index = index + 1;
	local icon = (popUpType == 'COMPLETED') and QUEST_ICON_COMPLETE or QUEST_ICON
	local row = self:GetPopup(index);
	row.RowID = questID
	row.Header:SetAlpha(1);
	row.Header.Text:SetText(title)
	row.Badge.Icon:SetTexture(icon);
	row.Badge:SetAlpha(1);
	row.Button:Enable();
	row.Button:SetID(questLogIndex);
	row:SetHeightToScale(LARGE_ROW_HEIGHT);
	row:FadeIn();

	local fill_height = LARGE_ROW_HEIGHT + 6;

	return index, fill_height;
end

local RefreshPopupObjective = function(self, event, ...)
	local rows = 0;
	local fill_height = 0;
	for i = 1, GetNumAutoQuestPopUps() do
		local questID, popUpType = GetAutoQuestPopUp(i);
		if(questID) then
			local questLogIndex = GetQuestLogIndexByID(questID);
			local title = GetQuestLogTitle(questLogIndex);
			if(title and title ~= '') then
				local add_height = 0;
				rows, add_height = self:SetPopup(rows, title, popUpType, questID, questLogIndex)
				fill_height = fill_height + add_height
			end
		end
	end

	if(rows == 0 or (fill_height <= 1)) then
		self:SetHeight(1);
		self:SetAlpha(0);
	else
		self:SetHeightToScale(fill_height + 2);
		self:FadeIn();
	end
end

local ResetPopupBlock = function(self)
	for x = 1, #self.Rows do
		local row = self.Rows[x]
		if(row) then
			row.RowID = 0;
			row.Header.Text:SetText('');
			row.Header:SetAlpha(0);
			row.Button:SetID(0);
			row.Button:Disable();
			row.Badge:SetAlpha(0);
			row.Badge.Icon:SetTexture(NO_ICON);
			row:SetHeight(1);
			row:SetAlpha(0);
		end
	end
end

local AddAutoPopUp = function(self, questID, popUpType, noCheck)
	local checkPassed = true;
	if(not noCheck) then
		checkPassed = AddAutoQuestPopUp(questID, popUpType)
	end
	if(checkPassed) then
		self:Reset()
		self:Refresh();
		MOD:UpdateDimensions();
		PlaySound("UI_AutoQuestComplete");
	end
end

local RemoveAutoPopUp = function(self, questID, noRemove)
	if(not noRemove) then
		RemoveAutoQuestPopUp(questID);
	end
	self:Reset();
	self:Refresh();
	MOD:UpdateDimensions();
end

local _hook_AddAutoPopUpQuests = function(questID, popUpType)
	MOD.Headers["Popups"]:AddPopup(questID, popUpType, true)
end

local _hook_RemoveAutoPopUpQuests = function(questID)
	MOD.Headers["Popups"]:RemovePopup(questID, true)
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:UpdatePopupQuests(event, ...)
	local questID = ...;
	self.Headers["Popups"]:AddPopup(questID, "COMPLETE");
end

local function UpdatePopupLocals(...)
	ROW_WIDTH, ROW_HEIGHT, INNER_HEIGHT, LARGE_ROW_HEIGHT, LARGE_INNER_HEIGHT = ...;
end

SV.Events:On("QUEST_UPVALUES_UPDATED", "UpdatePopupLocals", UpdatePopupLocals);

function MOD:InitializePopups()
	local scrollChild = self.Docklet.ScrollFrame.ScrollChild;

	local popups = CreateFrame("Frame", nil, scrollChild)
	popups:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, 0);
	popups:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, 0);
	popups:SetHeight(1);
	popups.Rows = {};

	popups.GetPopup = GetPopUpRow;
	popups.SetPopup = SetPopupRow;
	popups.AddPopup = AddAutoPopUp;
	popups.RemovePopup = RemoveAutoPopUp;
	popups.Reset = ResetPopupBlock;
	popups.Refresh = RefreshPopupObjective;

	self.Headers["Popups"] = popups;

	self:RegisterEvent("QUEST_AUTOCOMPLETE", self.UpdatePopupQuests);

	hooksecurefunc("AutoQuestPopupTracker_AddPopUp", _hook_AddAutoPopUpQuests);
	hooksecurefunc("AutoQuestPopupTracker_RemovePopUp", _hook_RemoveAutoPopUpQuests);
end