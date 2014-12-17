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

local OBJ_ICON_ACTIVE = [[Interface\COMMON\Indicator-Yellow]];
local OBJ_ICON_COMPLETE = [[Interface\COMMON\Indicator-Green]];
local OBJ_ICON_INCOMPLETE = [[Interface\COMMON\Indicator-Gray]];
local LINE_QUEST_ICON = [[Interface\ICONS\Ability_Hisek_Aim]];
local LINE_POPUP_COMPLETE = [[Interface\ICONS\Ability_Hisek_Aim]];
local LINE_POPUP_OFFER = [[Interface\ICONS\Ability_Hisek_Aim]];
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
		AutoQuestPopupTracker_RemovePopUp(questID);
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
		row.Badge.Icon:SetTexture(LINE_QUEST_ICON)
		row.Badge.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		row.Header = CreateFrame("Frame", nil, row.Button)
		row.Header:SetPointToScale("TOPLEFT", row.Badge, "TOPRIGHT", 4, -1);
		row.Header:SetPointToScale("BOTTOMRIGHT", row.Button, "BOTTOMRIGHT", -2, 2);
		row.Header:SetStylePanel("Default")
		row.Header.Text = row.Header:CreateFontString(nil,"OVERLAY")
		row.Header.Text:SetFont(SV.Media.font.roboto, 13, "NONE")
		row.Header.Text:SetTextColor(1,1,0)
		row.Header.Text:SetShadowOffset(-1,-1)
		row.Header.Text:SetShadowColor(0,0,0,0.5)
		row.Header.Text:SetJustifyH('LEFT')
		row.Header.Text:SetJustifyV('MIDDLE')
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
	local row = self:Get(index);
	row.RowID = questID

	local icon = (popUpType == 'COMPLETED') and LINE_POPUP_COMPLETE or LINE_POPUP_OFFER

	row.Header.Text:SetText(title)
	row.Badge.Icon:SetTexture(icon)
	row.Button.PopUpType = popUpType
	row.Button:SetID(questLogIndex)
	row:Show()
end

local RefreshPopupObjective = function(self, event, ...)
	local nextLine = 0;
	for i = 1, GetNumAutoQuestPopUps() do
		local questID, popUpType = GetAutoQuestPopUp(i);
		local questLogIndex = GetQuestLogIndexByID(questID);
		local title = GetQuestLogTitle(questLogIndex);
		if(title and title ~= '') then
			nextLine = nextLine + 1;
			self:Set(nextLine, title, popUpType, questID, questLogIndex)
		end
	end

	nextLine = nextLine + 1;

	local numLines = #self.Rows;
	for x = nextLine, numLines do
		local row = self.Rows[x]
		if(row) then
			row.RowID = 0;
			row.Header.Text:SetText('');
			row.Button:SetID(0);
			row.Button.PopUpType = nil;
			row.Badge.Icon:SetTexture(0,0,0,0)
			if(row:IsShown()) then
				row:Hide()
			end
		end
	end

	local newHeight = (nextLine * (LARGE_ROW_HEIGHT + 2)) + (ROW_HEIGHT + (nextLine * 2));
	self:SetHeight(newHeight);
end

local _hook_AutoPopUpQuests = function(...)
	MOD.Headers["Popups"]:Refresh(...);
	MOD:UpdateDimensions();
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local function UpdatePopupLocals(...)
	ROW_WIDTH, ROW_HEIGHT, INNER_HEIGHT, LARGE_ROW_HEIGHT, LARGE_INNER_HEIGHT = ...;
end

SV.Events:On("QUEST_UPVALUES_UPDATED", "UpdatePopupLocals", UpdatePopupLocals);

function MOD:InitializePopups()
	local scrollChild = self.Docklet.ScrollFrame.ScrollChild;

	local popups = CreateFrame("Frame", nil, scrollChild)
	popups:SetWidth(ROW_WIDTH);
	popups:SetHeight(1);
	popups:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, 0);

	popups.Rows = {};

	popups.Get = GetPopUpRow;
	popups.Set = SetPopupRow;
	popups.Refresh = RefreshPopupObjective;

	self.Headers["Popups"] = popups;

	hooksecurefunc("AddAutoQuestPopUp", _hook_AutoPopUpQuests)
	hooksecurefunc("RemoveAutoQuestPopUp", _hook_AutoPopUpQuests)
end