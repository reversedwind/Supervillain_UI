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
local _G 		= _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local ipairs 	= _G.ipairs;
local type 		= _G.type;
local tostring 	= _G.tostring;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
--[[ STRING METHODS ]]--
local find, format, upper = string.find, string.format, string.upper;
local match, gsub = string.match, string.gsub;
--[[ MATH METHODS ]]--
local min, random = math.min, math.random;
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
--[[ LOCALIZED BLIZZ FUNCTIONS ]]--
local NewHook = hooksecurefunc;
--[[ 
########################################################## 
GET ADDON DATA AND TEST FOR oUF
##########################################################
]]--
local SVUI_ADDON_NAME, SV = ...
local oUF_Villain = SV.oUF
assert(oUF_Villain, "SVUI was unable to locate oUF.")

local SVLib = LibStub("LibSuperVillain-1.0");
local L = SVLib:Lang();
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
MODULE AND INNER CLASSES
##########################################################
]]--
local MOD = {}
MOD.Units = {}
MOD.Headers = {}

oUF_Villain.SVConfigs = {}
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local LoadedUnitFrames, LoadedGroupHeaders;
local SortAuraBars;
local ReversedUnit = {
	["target"] = true, 
	["targettarget"] = true, 
	["pettarget"] = true,  
	["focustarget"] = true,
	["boss"] = true, 
	["arena"] = true, 
}

do
	local hugeMath = math.huge

	local TRRSort = function(a, b)
		local compA = a.noTime and hugeMath or a.expirationTime
		local compB = b.noTime and hugeMath or b.expirationTime 
		return compA < compB 
	end

	local TDSort = function(a, b)
		local compA = a.noTime and hugeMath or a.duration
		local compB = b.noTime and hugeMath or b.duration 
		return compA > compB 
	end

	local TDRSort = function(a, b)
		local compA = a.noTime and hugeMath or a.duration
		local compB = b.noTime and hugeMath or b.duration 
		return compA < compB 
	end

	local NSort = function(a, b)
		return a.name > b.name 
	end

	SortAuraBars = function(parent, sorting)
		if not parent then return end 
		if sorting == "TIME_REMAINING" then 
			parent.sort = true;
		elseif sorting == "TIME_REMAINING_REVERSE" then 
			parent.sort = TRRSort
		elseif sorting == "TIME_DURATION" then 
			parent.sort = TDSort
		elseif sorting == "TIME_DURATION_REVERSE" then 
			parent.sort = TDRSort
		elseif sorting == "NAME" then 
			parent.sort = NSort
		else 
			parent.sort = nil;
		end 
	end
end

local function FindAnchorFrame(frame, anchor, badPoint)
	if badPoint or anchor == 'FRAME' then 
		if(frame.Combatant and frame.Combatant:IsShown()) then 
			return frame.Combatant
		else
			return frame 
		end
	elseif(anchor == 'TRINKET' and frame.Combatant and frame.Combatant:IsShown()) then 
		return frame.Combatant
	elseif(anchor == 'BUFFS' and frame.Buffs and frame.Buffs:IsShown()) then
		return frame.Buffs 
	elseif(anchor == 'DEBUFFS' and frame.Debuffs and frame.Debuffs:IsShown()) then
		return frame.Debuffs 
	else 
		return frame
	end 
end 
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
do
	local dummy = CreateFrame("Frame", nil)
	dummy:Hide()

	local function deactivate(unitName)
		local frame;
		if type(unitName) == "string" then frame = _G[unitName] else frame = unitName end
		if frame then 
			frame:UnregisterAllEvents()
			frame:Hide()
			frame:SetParent(dummy)
			if frame.healthbar then frame.healthbar:UnregisterAllEvents() end
			if frame.manabar then frame.manabar:UnregisterAllEvents() end
			if frame.spellbar then frame.spellbar:UnregisterAllEvents() end
			if frame.powerBarAlt then frame.powerBarAlt:UnregisterAllEvents() end 
		end 
	end

	function oUF_Villain:DisableBlizzard(unit)
		if(not MOD.db.enable) then return end
		if (not unit) or InCombatLockdown() then return end

		if (unit == "player") then
			deactivate(PlayerFrame)
			PlayerFrame:RegisterUnitEvent("UNIT_ENTERING_VEHICLE", "player")
			PlayerFrame:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
			PlayerFrame:RegisterUnitEvent("UNIT_EXITING_VEHICLE", "player")
			PlayerFrame:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
			PlayerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

			PlayerFrame:SetUserPlaced(true)
			PlayerFrame:SetDontSavePosition(true)
			RuneFrame:SetParent(PlayerFrame)
		elseif(unit == "pet") then
			deactivate(PetFrame)
		elseif(unit == "target") then
			deactivate(TargetFrame)
			deactivate(ComboFrame)
		elseif(unit == "focus") then
			deactivate(FocusFrame)
			deactivate(TargetofFocusFrame)
		elseif(unit == "targettarget") then
			deactivate(TargetFrameToT)
		elseif(unit:match("(boss)%d?$") == "boss") then
		local id = unit:match("boss(%d)")
			if(id) then
				deactivate("Boss"..id.."TargetFrame")
			else
				for i = 1, 4 do
					deactivate(("Boss%dTargetFrame"):format(i))
				end
			end
		elseif(unit:match("(party)%d?$") == "party") then
			local id = unit:match("party(%d)")
			if(id) then
				deactivate("PartyMemberFrame"..id)
			else
				for i = 1, 4 do
					deactivate(("PartyMemberFrame%d"):format(i))
				end
			end
		elseif(unit:match("(arena)%d?$") == "arena") then
			local id = unit:match("arena(%d)")
			if(id) then
				deactivate("ArenaEnemyFrame"..id)
				deactivate("ArenaPrepFrame"..id)
				deactivate("ArenaEnemyFrame"..id.."PetFrame")
			else
				for i = 1, 5 do
					deactivate(("ArenaEnemyFrame%d"):format(i))
					deactivate(("ArenaPrepFrame%d"):format(i))
					deactivate(("ArenaEnemyFrame%dPetFrame"):format(i))
				end
			end
		end
	end
end

function MOD:GetActiveSize(db)
	local width, height, best = 0,0,0

	if(self.db.grid.enable and db.gridAllowed) then
		width = self.db.grid.size
		height = width
		best = width
	else
		width = db.width
		height = db.height
		best = min(width, height);
	end

	return width, height, best
end

function MOD:AllowElement(unitFrame)
	if InCombatLockdown() then return; end
	if not unitFrame.isForced then 
		unitFrame.sourceElement = unitFrame.unit;
		unitFrame.unit = "player"
		unitFrame.isForced = true;
		unitFrame.sourceEvent = unitFrame:GetScript("OnUpdate")
	end

	unitFrame:SetScript("OnUpdate", nil)
	unitFrame.forceShowAuras = true;
	UnregisterUnitWatch(unitFrame)
	RegisterUnitWatch(unitFrame, true)

	unitFrame:Show()
	if unitFrame:IsVisible() and unitFrame.Update then 
		unitFrame:Update()
	end 
end

function MOD:RestrictElement(unitFrame)
	if(InCombatLockdown() or (not unitFrame.isForced)) then return; end

	unitFrame.forceShowAuras = nil
	unitFrame.isForced = nil

	UnregisterUnitWatch(unitFrame)
	RegisterUnitWatch(unitFrame)

	if unitFrame.sourceEvent then 
		unitFrame:SetScript("OnUpdate", unitFrame.sourceEvent)
		unitFrame.sourceEvent = nil 
	end

	unitFrame.unit = unitFrame.sourceElement or unitFrame.unit;

	if unitFrame:IsVisible() and unitFrame.Update then 
		unitFrame:Update()
	end 
end

function MOD:AllowChildren(parentFrame, ...)
	parentFrame.isForced = true;
	
	for i=1, select("#", ...) do
		local childFrame = select(i, ...)
		childFrame:RegisterForClicks(nil)
		childFrame:SetID(i)
		childFrame.TargetGlow:SetAlpha(0)
		self:AllowElement(childFrame)
	end  
end

function MOD:RestrictChildren(parentFrame, ...)
	parentFrame.isForced = nil;

	for i=1,select("#",...) do 
		local childFrame = select(i,...)
		childFrame:RegisterForClicks(MOD.db.fastClickTarget and 'AnyDown' or 'AnyUp')
		childFrame.TargetGlow:SetAlpha(1)
		self:RestrictElement(childFrame)
	end 
end

function MOD:ResetUnitOptions(unit)
	self.db:Reset(unit)
	self:RefreshUnitFrames()
end

function MOD:RefreshUnitColors()
	local db = SV.db.media.unitframes 
	for i, setting in pairs(db) do
		if setting and type(setting) == "table" then
			if(setting[1]) then
				oUF_Villain.colors[i] = setting
			else
				local bt = {}
				for x, color in pairs(setting) do
					if(color)then
						bt[x] = color
					end
					oUF_Villain.colors[i] = bt
				end
			end
		elseif setting then
			oUF_Villain.colors[i] = setting
		end
	end
	local r, g, b = db.health[1], db.health[2], db.health[3]
	oUF_Villain.colors.smooth = {1, 0, 0, 1, 1, 0, r, g, b}

	oUF_Villain.SVConfigs.classbackdrop = self.db.classbackdrop
	oUF_Villain.SVConfigs.healthclass = self.db.healthclass
	oUF_Villain.SVConfigs.colorhealthbyvalue = self.db.colorhealthbyvalue
end

function MOD:RefreshAllUnitMedia()
	if(not self.db or (self.db and self.db.enable ~= true)) then return end
	self:RefreshUnitColors()
	for unit,frame in pairs(self.Units)do
		if self.db[frame.___key].enable then 
			frame:MediaUpdate()
			frame:UpdateAllElements()
		end 
	end
	for _,group in pairs(self.Headers) do
		group:MediaUpdate()
	end
	collectgarbage("collect")
end

function MOD:RefreshUnitFrames()
	if(InCombatLockdown()) then self:RegisterEvent("PLAYER_REGEN_ENABLED"); return end
	self:RefreshUnitColors()
	for unit,frame in pairs(self.Units)do
		if(self.db.enable == true and self.db[frame.___key].enable) then 
			frame:Enable()
			frame:Update()
		else 
			frame:Disable()
		end 
	end
	local _,groupType = IsInInstance()
	local raidDebuffs = SV.oUF_RaidDebuffs or oUF_RaidDebuffs;
	if raidDebuffs then
		raidDebuffs:ResetDebuffData()
		if groupType == "party" or groupType == "raid" then
		  raidDebuffs:RegisterDebuffs(SV.db.filter["Raid"])
		else
		  raidDebuffs:RegisterDebuffs(SV.db.filter["CC"])
		end 
	end

	for _,group in pairs(self.Headers) do
		group:Update()
		if group.SetConfigEnvironment then 
		  group:SetConfigEnvironment()
		end 
	end
	if self.db.disableBlizzard then 
		oUF_Villain:DisableBlizzard('party')
	end
	collectgarbage("collect")
end

function MOD:RefreshUnitMedia(unitName)
    local db = MOD.db
    local key = unitName or self.___key
    if(not (db and db.enable) or not self) then return end
    local CURRENT_BAR_TEXTURE = LSM:Fetch("statusbar", db.statusbar)
    local CURRENT_AURABAR_TEXTURE = LSM:Fetch("statusbar", db.auraBarStatusbar);
    local CURRENT_FONT = LSM:Fetch("font", db.font)
    local CURRENT_AURABAR_FONT = LSM:Fetch("font", db.auraFont);
    local CURRENT_AURABAR_FONTSIZE = db.auraFontSize
    local CURRENT_AURABAR_FONTOUTLINE = db.auraFontOutline
    local unitDB = db[key]
    if(unitDB and unitDB.enable) then
        local panel = self.InfoPanel
        if(panel) then
            if(panel.Name and unitDB.name) then
            	if(db.grid.enable and unitDB.gridAllowed) then
            		panel.Name:SetFont(SV.Media.font.pixel, 8, "MONOCHROMEOUTLINE")
            		panel.Name:SetShadowOffset(1, -1)
					panel.Name:SetShadowColor(0, 0, 0, 0.75)
            	else
                	panel.Name:SetFont(LSM:Fetch("font", unitDB.name.font), unitDB.name.fontSize, unitDB.name.fontOutline)
                	panel.Name:SetShadowOffset(2, -2)
					panel.Name:SetShadowColor(0, 0, 0, 1)
                end
            end
            if(panel.Health) then
                panel.Health:SetFont(CURRENT_FONT, db.fontSize, db.fontOutline)
            end
            if(panel.Power) then
                panel.Power:SetFont(CURRENT_FONT, db.fontSize, db.fontOutline)
            end
            if(panel.Misc) then
                panel.Misc:SetFont(CURRENT_FONT, db.fontSize, db.fontOutline)
            end
        end
        if(self.Health and (unitDB.health and unitDB.health.enable)) then
            self.Health:SetStatusBarTexture(CURRENT_BAR_TEXTURE)
        end
        if(self.Power and (unitDB.power and unitDB.power.enable)) then
            self.Power:SetStatusBarTexture(CURRENT_BAR_TEXTURE)
        end
        if(self.Castbar and (unitDB.castbar)) then
            if(unitDB.castbar.useCustomColor) then
				cr,cg,cb = unitDB.castbar.castingColor[1], unitDB.castbar.castingColor[2], unitDB.castbar.castingColor[3];
				self.Castbar.CastColor = {cr,cg,cb}
				cr,cg,cb = unitDB.castbar.sparkColor[1], unitDB.castbar.sparkColor[2], unitDB.castbar.sparkColor[3];
				self.Castbar.SparkColor = {cr,cg,cb}
			else
				self.Castbar.CastColor = oUF_Villain.colors.casting
				self.Castbar.SparkColor = oUF_Villain.colors.spark
			end
        end
        if(self.AuraBars and (unitDB.aurabar and unitDB.aurabar.enable)) then
            local ab = self.AuraBars
            ab.auraBarTexture = CURRENT_AURABAR_TEXTURE
            ab.textFont = CURRENT_AURABAR_FONT
            ab.textSize = db.auraFontSize
            ab.textOutline = db.auraFontOutline
            ab.buffColor = oUF_Villain.colors.buff_bars

			if MOD.db.auraBarByType then 
				ab.debuffColor = nil;
				ab.defaultDebuffColor = oUF_Villain.colors.debuff_bars
			else 
				ab.debuffColor = oUF_Villain.colors.debuff_bars
				ab.defaultDebuffColor = nil 
			end
        end
        if(self.Buffs and (unitDB.buffs and unitDB.buffs.enable)) then
            local buffs = self.Buffs
            buffs.textFont = CURRENT_AURABAR_FONT
            buffs.textSize = db.auraFontSize
            buffs.textOutline = db.auraFontOutline
        end
        if(self.Debuffs and (unitDB.debuffs and unitDB.debuffs.enable)) then
            local debuffs = self.Debuffs
            debuffs.textFont = CURRENT_AURABAR_FONT
            debuffs.textSize = db.auraFontSize
            debuffs.textOutline = db.auraFontOutline
        end
        if(self.RaidDebuffs and (unitDB.rdebuffs and unitDB.rdebuffs.enable)) then
            local rdebuffs = self.RaidDebuffs;
            rdebuffs.count:SetFont(CURRENT_AURABAR_FONT, db.auraFontSize, db.auraFontOutline)
            rdebuffs.time:SetFont(CURRENT_AURABAR_FONT, db.auraFontSize, db.auraFontOutline)
        end
    end
end

function MOD:RefreshUnitLayout(frame, template)
	local db = self.db[template]

	local TOP_ANCHOR1, TOP_ANCHOR2, TOP_MODIFIER = "TOPRIGHT", "TOPLEFT", 1;
	local BOTTOM_ANCHOR1, BOTTOM_ANCHOR2, BOTTOM_MODIFIER = "BOTTOMLEFT", "BOTTOMRIGHT", -1;
	if(ReversedUnit[template]) then
		TOP_ANCHOR1 = "TOPLEFT"
		TOP_ANCHOR2 = "TOPRIGHT"
		TOP_MODIFIER = -1
		BOTTOM_ANCHOR1 = "BOTTOMRIGHT"
		BOTTOM_ANCHOR2 = "BOTTOMLEFT"
		BOTTOM_MODIFIER = 1
	end

	local UNIT_WIDTH, UNIT_HEIGHT, BEST_SIZE = self:GetActiveSize(db)
	local POWER_HEIGHT = (db.power and db.power.enable) and (db.power.height - 1) or 1;
	local PORTRAIT_WIDTH = (1 * TOP_MODIFIER)
	local GRID_MODE = (self.db.grid.enable and db.gridAllowed) or false
	local MINI_GRID = (GRID_MODE and self.db.grid.size < 26) or false

	local healthPanel = frame.HealthPanel
	local infoPanel = frame.InfoPanel
	local portraitOverlay = false
	local overlayAnimation = false

	if(db.portrait and db.portrait.enable) then 
		if(not db.portrait.overlay) then
			PORTRAIT_WIDTH = ((db.portrait.width * TOP_MODIFIER) + (1 * TOP_MODIFIER))
		else
			portraitOverlay = true
			overlayAnimation = self.db.overlayAnimation
		end
	end

	if GRID_MODE then portraitOverlay = false end

	if frame.Portrait then
		frame.Portrait:Hide()
		frame.Portrait:ClearAllPoints()
	end 
	if db.portrait and frame.PortraitTexture and frame.PortraitModel then
		if db.portrait.style == '2D' then
			frame.Portrait = frame.PortraitTexture
		else
			frame.PortraitModel.UserRotation = db.portrait.rotation;
			frame.PortraitModel.UserCamDistance = db.portrait.camDistanceScale;
			frame.Portrait = frame.PortraitModel
		end
	end 

	healthPanel:ClearAllPoints()
	healthPanel:Point(TOP_ANCHOR1, frame, TOP_ANCHOR1, (1 * BOTTOM_MODIFIER), -1)
	healthPanel:Point(BOTTOM_ANCHOR1, frame, BOTTOM_ANCHOR1, PORTRAIT_WIDTH, POWER_HEIGHT)

	if(frame.StatusPanel) then
		if(template ~= "player" and template ~= "pet" and template ~= "target" and template ~= "targettarget" and template ~= "focus" and template ~= "focustarget") then
			local size = healthPanel:GetHeight()
			frame.StatusPanel:SetSize(size, size)
			frame.StatusPanel:SetPoint("CENTER", healthPanel, "CENTER", 0, 0)
		end
	end

	--[[ THREAT LAYOUT ]]--

	if frame.Threat then 
		local threat = frame.Threat;
		if db.threatEnabled then 
			if not frame:IsElementEnabled('Threat')then 
				frame:EnableElement('Threat')
			end 
		elseif frame:IsElementEnabled('Threat')then 
			frame:DisableElement('Threat')
		end 
	end 

	--[[ TARGETGLOW LAYOUT ]]--

	if frame.TargetGlow then 
		local glow = frame.TargetGlow;
		glow:ClearAllPoints()
		glow:Point("TOPLEFT", -3, 3)
		glow:Point("TOPRIGHT", 3, 3)
		glow:Point("BOTTOMLEFT", -3, -3)
		glow:Point("BOTTOMRIGHT", 3, -3)
	end 

	--[[ INFO TEXTS ]]--
	local point,cX,cY;

	if(infoPanel.Name and db.name) then
		local nametext = infoPanel.Name
		if(GRID_MODE) then
			if(self.db.grid.shownames and self.db.grid.size >= 30) then
				if(not nametext:IsShown()) then nametext:Show() end
				nametext:Point("CENTER", frame, "CENTER", 0, 0)
				nametext:SetJustifyH("CENTER")
				nametext:SetJustifyV("MIDDLE")
				frame:Tag(nametext, "[name:grid]")
			else
				nametext:Hide()
			end
		else
			point = db.name.position
			cX = db.name.xOffset
			cY = db.name.yOffset
			nametext:ClearAllPoints()
			SV:ReversePoint(nametext, point, infoPanel, cX, cY)

			if(nametext.initialAnchor:find("RIGHT")) then
				nametext:SetJustifyH("RIGHT")
			elseif(nametext.initialAnchor:find("LEFT")) then
				nametext:SetJustifyH("LEFT")
			else
				nametext:SetJustifyH("CENTER")
			end

			if(nametext.initialAnchor:find("TOP")) then
				nametext:SetJustifyV("TOP")
			elseif(nametext.initialAnchor:find("BOTTOM")) then
				nametext:SetJustifyV("BOTTOM")
			else
				nametext:SetJustifyV("MIDDLE")
			end
				
			frame:Tag(nametext, db.name.tags)
		end
	end

	if(frame.Health and infoPanel.Health and db.health) then
		if(GRID_MODE) then
			infoPanel.Health:Hide()
		else
			if(not infoPanel.Health:IsShown()) then infoPanel.Health:Show() end
			local healthtext = infoPanel.Health
			point = db.health.position
			cX = db.health.xOffset
			cY = db.health.yOffset
			healthtext:ClearAllPoints()
			SV:ReversePoint(healthtext, point, infoPanel, cX, cY)
			frame:Tag(healthtext, db.health.tags)
		end
	end

	if(frame.Power and infoPanel.Power and db.power) then
		if(GRID_MODE) then
			infoPanel.Power:Hide()
		else
			if(not infoPanel.Power:IsShown()) then infoPanel.Power:Show() end
			local powertext = infoPanel.Power
			if db.power.tags ~= nil and db.power.tags ~= '' then
				point = db.power.position
				cX = db.power.xOffset
				cY = db.power.yOffset
				powertext:ClearAllPoints()
				SV:ReversePoint(powertext, point, infoPanel, cX, cY)
				if db.power.attachTextToPower then 
					powertext:SetParent(frame.Power)
				else 
					powertext:SetParent(infoPanel)
				end
			end
			frame:Tag(powertext, db.power.tags)
		end
	end

	if(infoPanel.Misc and db.misc) then
		if(GRID_MODE) then
			infoPanel.Misc:Hide()
		else
			if(not infoPanel.Misc:IsShown()) then infoPanel.Misc:Show() end
			frame:Tag(infoPanel.Misc, db.misc.tags)
		end
	end

	--[[ HEALTH LAYOUT ]]--

	do 
		local health = frame.Health;
		if(db.health and (db.health.reversed  ~= nil)) then
			health.fillInverted = db.health.reversed;
		else
			health.fillInverted = false
		end

		health.Smooth = self.db.smoothbars;
		health.colorSmooth = nil;
		health.colorHealth = nil;
		health.colorClass = nil;
		health.colorReaction = nil;
		health.colorOverlay = nil;
		health.overlayAnimation = overlayAnimation

		if(not GRID_MODE and frame.HealPrediction) then
			frame.HealPrediction["frequentUpdates"] = health.frequentUpdates
		end
		if(not GRID_MODE and portraitOverlay and self.db.forceHealthColor) then
			health.colorOverlay = true;
		else
			if(GRID_MODE or (db.colorOverride and db.colorOverride == "FORCE_ON")) then 
				health.colorClass = true;
				health.colorReaction = true 
			elseif(db.colorOverride and db.colorOverride == "FORCE_OFF") then 
				if self.db.colorhealthbyvalue == true then 
					health.colorSmooth = true 
				else 
					health.colorHealth = true 
				end 
			else
				if(not self.db.healthclass) then 
					if self.db.colorhealthbyvalue == true then 
						health.colorSmooth = true 
					else 
						health.colorHealth = true 
					end 
				else 
					health.colorClass = true;
					health.colorReaction = true 
				end 
			end
		end
		health:ClearAllPoints()
		health:SetAllPoints(healthPanel)

		health.gridMode = GRID_MODE;

		if(db.health and db.health.orientation) then
			health:SetOrientation(GRID_MODE and "VERTICAL" or db.health.orientation)
		end

		self:RefreshHealthBar(frame, portraitOverlay)
	end 

	--[[ POWER LAYOUT ]]--

	do
		if frame.Power then
			local power = frame.Power;
			if db.power.enable then 
				if not frame:IsElementEnabled('Power')then 
					frame:EnableElement('Power')
					power:Show()
				end

				power.Smooth = self.db.smoothbars;
 
				power.colorClass = nil;
				power.colorReaction = nil;
				power.colorPower = nil;
				if self.db.powerclass then 
					power.colorClass = true;
					power.colorReaction = true 
				else 
					power.colorPower = true 
				end 
				if(db.power.frequentUpdates) then
					power.frequentUpdates = db.power.frequentUpdates
				end
				power:ClearAllPoints()
				power:Height(POWER_HEIGHT - 2)
				power:Point(BOTTOM_ANCHOR1, frame, BOTTOM_ANCHOR1, (PORTRAIT_WIDTH - (1 * BOTTOM_MODIFIER)), 2)
				power:Point(BOTTOM_ANCHOR2, frame, BOTTOM_ANCHOR2, (2 * BOTTOM_MODIFIER), 2)
			elseif frame:IsElementEnabled('Power')then 
				frame:DisableElement('Power')
				power:Hide()
			end 
		end

		--[[ ALTPOWER LAYOUT ]]--

		if frame.AltPowerBar then
			local altPower = frame.AltPowerBar;
			local Alt_OnShow = function()
				healthPanel:Point(TOP_ANCHOR2, PORTRAIT_WIDTH, -(POWER_HEIGHT + 1))
			end 
			local Alt_OnHide = function()
				healthPanel:Point(TOP_ANCHOR2, PORTRAIT_WIDTH, -1)
				altPower.text:SetText("")
			end 
			if db.power.enable then 
				frame:EnableElement('AltPowerBar')
				if(infoPanel.Health) then
					altPower.text:SetFont(infoPanel.Health:GetFont())
				end
				altPower.text:SetAlpha(1)
				altPower:Point(TOP_ANCHOR2, frame, TOP_ANCHOR2, PORTRAIT_WIDTH, -1)
				altPower:Point(TOP_ANCHOR1, frame, TOP_ANCHOR1, (1 * BOTTOM_MODIFIER), -1)
				altPower:SetHeight(POWER_HEIGHT)
				altPower.Smooth = self.db.smoothbars;
				altPower:HookScript("OnShow", Alt_OnShow)
				altPower:HookScript("OnHide", Alt_OnHide)
			else 
				frame:DisableElement('AltPowerBar')
				altPower.text:SetAlpha(0)
				altPower:Hide()
			end 
		end
	end

	--[[ PORTRAIT LAYOUT ]]--

	if db.portrait and frame.Portrait then
		local portrait = frame.Portrait;

		if(not GRID_MODE and db.portrait.enable) then
			portrait:Show()

			if not frame:IsElementEnabled('Portrait')then 
				frame:EnableElement('Portrait')
			end 
			portrait:ClearAllPoints()
			portrait:SetAlpha(1)
		
			if db.portrait.overlay then 
				if db.portrait.style == '3D' then
					portrait:SetFrameLevel(frame.ActionPanel:GetFrameLevel())
					portrait:SetCamDistanceScale(db.portrait.camDistanceScale)
				elseif db.portrait.style == '2D' then 
					portrait.anchor:SetFrameLevel(frame.ActionPanel:GetFrameLevel())
				end 
				
				portrait:Point(TOP_ANCHOR2, healthPanel, TOP_ANCHOR2, (1 * TOP_MODIFIER), -1)
				portrait:Point(BOTTOM_ANCHOR2, healthPanel, BOTTOM_ANCHOR2, (1 * BOTTOM_MODIFIER), 1)
				
				portrait.Panel:Show()
			else
				portrait.Panel:Show()
				if db.portrait.style == '3D' then 
					portrait:SetFrameLevel(frame.ActionPanel:GetFrameLevel())
					portrait:SetCamDistanceScale(db.portrait.camDistanceScale)
				elseif db.portrait.style == '2D' then 
					portrait.anchor:SetFrameLevel(frame.ActionPanel:GetFrameLevel())
				end 
				
				if not frame.Power or not db.power.enable then 
					portrait:Point(TOP_ANCHOR2, frame, TOP_ANCHOR2, (1 * TOP_MODIFIER), -1)
					portrait:Point(BOTTOM_ANCHOR2, healthPanel, BOTTOM_ANCHOR1, (4 * BOTTOM_MODIFIER), 0)
				else 
					portrait:Point(TOP_ANCHOR2, frame, TOP_ANCHOR2, (1 * TOP_MODIFIER), -1)
					portrait:Point(BOTTOM_ANCHOR2, frame.Power, BOTTOM_ANCHOR1, (4 * BOTTOM_MODIFIER), 0)
				end 
			end
		else 
			portrait:Hide()
			portrait.Panel:Hide()

			if frame:IsElementEnabled('Portrait') then 
				frame:DisableElement('Portrait')
			end 
		end
	end 

	--[[ CASTBAR LAYOUT ]]--

	if db.castbar and frame.Castbar then
		local castbar = frame.Castbar;
		local castHeight = db.castbar.height;
		local castWidth
		if(db.castbar.matchFrameWidth) then
			castWidth = UNIT_WIDTH
		else
			castWidth = db.castbar.width
		end
		local sparkSize = castHeight * 4;
		local adjustedWidth = castWidth - 2;
		local lazerScale = castHeight * 1.8;

		if(db.castbar.format) then castbar.TimeFormat = db.castbar.format end
		
		if(not castbar.pewpew) then
			castbar:SetSize(adjustedWidth, castHeight)
		elseif(castbar:GetHeight() ~= lazerScale) then
			castbar:SetSize(adjustedWidth, lazerScale)
		end

		if castbar.Spark and db.castbar.spark then 
			castbar.Spark:Show()
			castbar.Spark:SetSize(sparkSize, sparkSize)
			if castbar.Spark[1] and castbar.Spark[2] then
				castbar.Spark[1]:SetAllPoints(castbar.Spark)
				castbar.Spark[2]:FillInner(castbar.Spark, 4, 4)
			end
			castbar.Spark.SetHeight = SV.fubar 
		end 
		castbar:SetFrameStrata("HIGH")
		if castbar.Holder then
			castbar.Holder:Width(castWidth + 2)
			castbar.Holder:Height(castHeight + 6)
			local holderUpdate = castbar.Holder:GetScript('OnSizeChanged')
			if holderUpdate then
				holderUpdate(castbar.Holder)
			end
		end
		castbar:GetStatusBarTexture():SetHorizTile(false)
		if db.castbar.latency then 
			castbar.SafeZone = castbar.LatencyTexture;
			castbar.LatencyTexture:Show()
		else 
			castbar.SafeZone = nil;
			castbar.LatencyTexture:Hide()
		end 
		if castbar.Icon then
			if db.castbar.icon then
				castbar.Icon.bg:Width(castHeight + 2)
				castbar.Icon.bg:Height(castHeight + 2)
				castbar.Icon.bg:Show()
			else 
				castbar.Icon.bg:Hide()
				castbar.Icon = nil 
			end 
		end
		
		local cr,cg,cb
		if(db.castbar.useCustomColor) then
			cr,cg,cb = db.castbar.castingColor[1], db.castbar.castingColor[2], db.castbar.castingColor[3];
			castbar.CastColor = {cr,cg,cb}
			cr,cg,cb = db.castbar.sparkColor[1], db.castbar.sparkColor[2], db.castbar.sparkColor[3];
			castbar.SparkColor = {cr,cg,cb}
		else
			castbar.CastColor = oUF_Villain.colors.casting
			castbar.SparkColor = oUF_Villain.colors.spark
		end

		if db.castbar.enable and not frame:IsElementEnabled('Castbar')then 
			frame:EnableElement('Castbar')
		elseif not db.castbar.enable and frame:IsElementEnabled('Castbar')then
			SV:AddonMessage("No castbar")
			frame:DisableElement('Castbar') 
		end
	end 

	--[[ AURA LAYOUT ]]--

	if frame.Buffs and frame.Debuffs then
		do
			if db.debuffs.enable or db.buffs.enable then 
				if not frame:IsElementEnabled('Aura')then 
					frame:EnableElement('Aura')
				end 
			else 
				if frame:IsElementEnabled('Aura')then 
					frame:DisableElement('Aura')
				end 
			end 
			frame.Buffs:ClearAllPoints()
			frame.Debuffs:ClearAllPoints()
		end 

		do 
			local buffs = frame.Buffs;
			local numRows = db.buffs.numrows;
			local perRow = db.buffs.perrow;
			local buffCount = perRow * numRows;
			
			buffs.forceShow = frame.forceShowAuras;
			buffs.num = GRID_MODE and 0 or buffCount;

			local tempSize = (((UNIT_WIDTH + 2) - (buffs.spacing * (perRow - 1))) / perRow);
			local auraSize = min(BEST_SIZE, tempSize)
			if(db.buffs.sizeOverride and db.buffs.sizeOverride > 0) then
				auraSize = db.buffs.sizeOverride
				buffs:SetWidth(perRow * db.buffs.sizeOverride)
			end

			buffs.size = auraSize;

			local attachTo = FindAnchorFrame(frame, db.buffs.attachTo, db.debuffs.attachTo == 'BUFFS' and db.buffs.attachTo == 'DEBUFFS')

			SV:ReversePoint(buffs, db.buffs.anchorPoint, attachTo, db.buffs.xOffset + BOTTOM_MODIFIER, db.buffs.yOffset)
			buffs:SetWidth((auraSize + buffs.spacing) * perRow)
			buffs:Height((auraSize + buffs.spacing) * numRows)
			buffs["growth-y"] = db.buffs.verticalGrowth;
			buffs["growth-x"] = db.buffs.horizontalGrowth;

			if db.buffs.enable then 
				buffs:Show()
			else 
				buffs:Hide()
			end 
		end 
		do 
			local debuffs = frame.Debuffs;
			local numRows = db.debuffs.numrows;
			local perRow = db.debuffs.perrow;
			local debuffCount = perRow * numRows;
			
			debuffs.forceShow = frame.forceShowAuras;
			debuffs.num = GRID_MODE and 0 or debuffCount;

			local tempSize = (((UNIT_WIDTH + 2) - (debuffs.spacing * (perRow - 1))) / perRow);
			local auraSize = min(BEST_SIZE,tempSize)
			if(db.debuffs.sizeOverride and db.debuffs.sizeOverride > 0) then
				auraSize = db.debuffs.sizeOverride
				debuffs:SetWidth(perRow * db.debuffs.sizeOverride)
			end

			debuffs.size = auraSize;

			local attachTo = FindAnchorFrame(frame, db.debuffs.attachTo, db.debuffs.attachTo == 'BUFFS' and db.buffs.attachTo == 'DEBUFFS')

			SV:ReversePoint(debuffs, db.debuffs.anchorPoint, attachTo, db.debuffs.xOffset + BOTTOM_MODIFIER, db.debuffs.yOffset)
			debuffs:SetWidth((auraSize + debuffs.spacing) * perRow)
			debuffs:Height((auraSize + debuffs.spacing) * numRows)
			debuffs["growth-y"] = db.debuffs.verticalGrowth;
			debuffs["growth-x"] = db.debuffs.horizontalGrowth;

			if db.debuffs.enable then 
				debuffs:Show()
			else 
				debuffs:Hide()
			end 
		end 
	end 

	--[[ AURABAR LAYOUT ]]--

	if frame.AuraBars then
		local auraBar = frame.AuraBars;
		if db.aurabar.enable then 
			if not frame:IsElementEnabled("AuraBars") then frame:EnableElement("AuraBars") end 
			auraBar:Show()
			auraBar.friendlyAuraType = db.aurabar.friendlyAuraType
			auraBar.enemyAuraType = db.aurabar.enemyAuraType

			local attachTo = frame.ActionPanel;
			local preOffset = 1;
			if(db.aurabar.attachTo == "BUFFS" and frame.Buffs and frame.Buffs:IsShown()) then 
				attachTo = frame.Buffs
				preOffset = 10
			elseif(db.aurabar.attachTo == "DEBUFFS" and frame.Debuffs and frame.Debuffs:IsShown()) then 
				attachTo = frame.Debuffs
				preOffset = 10
			elseif not isPlayer and SVUI_Player and db.aurabar.attachTo == "PLAYER_AURABARS" then
				attachTo = SVUI_Player.AuraBars
				preOffset = 10
			end

			auraBar.auraBarHeight = db.aurabar.height;
			auraBar:ClearAllPoints()
			auraBar:SetSize(UNIT_WIDTH, db.aurabar.height)

			if db.aurabar.anchorPoint == "BELOW" then
				auraBar:Point("TOPLEFT", attachTo, "BOTTOMLEFT", 1, -preOffset)
				auraBar.down = true
			else
				auraBar:Point("BOTTOMLEFT", attachTo, "TOPLEFT", 1, preOffset)
				auraBar.down = false
			end 
			auraBar.buffColor = oUF_Villain.colors.buff_bars

			if self.db.auraBarByType then 
				auraBar.debuffColor = nil;
				auraBar.defaultDebuffColor = oUF_Villain.colors.debuff_bars
			else 
				auraBar.debuffColor = oUF_Villain.colors.debuff_bars
				auraBar.defaultDebuffColor = nil 
			end

			SortAuraBars(auraBar, db.aurabar.sort)
			auraBar:SetAnchors()
		else 
			if frame:IsElementEnabled("AuraBars")then frame:DisableElement("AuraBars")auraBar:Hide()end 
		end
	end 

	--[[ ICON LAYOUTS ]]--

	do
		if db.icons then
			local ico = db.icons;

			--[[ RAIDICON ]]--

			if(ico.raidicon and frame.RaidIcon) then
				local raidIcon = frame.RaidIcon;
				if ico.raidicon.enable then
					raidIcon:Show()
					frame:EnableElement('RaidIcon')
					local size = ico.raidicon.size;
					raidIcon:ClearAllPoints()

					if(GRID_MODE) then
						raidIcon:SetAlpha(0.7)
						raidIcon:Size(10)
						raidIcon:Point("TOP", healthPanel, "TOP", 0, 0)
					else
						raidIcon:SetAlpha(1)
						raidIcon:Size(size)
						SV:ReversePoint(raidIcon, ico.raidicon.attachTo, healthPanel, ico.raidicon.xOffset, ico.raidicon.yOffset)
					end
				else 
					frame:DisableElement('RaidIcon')
					raidIcon:Hide()
				end
			end

			--[[ ROLEICON ]]--

			if(ico.roleIcon and frame.LFDRole) then 
				local lfd = frame.LFDRole;
				if(not MINI_GRID and ico.roleIcon.enable) then
					lfd:Show()
					frame:EnableElement('LFDRole')
					local size = ico.roleIcon.size;
					lfd:ClearAllPoints()

					if(GRID_MODE) then
						lfd:SetAlpha(0.7)
						lfd:Size(10)
						lfd:Point("BOTTOM", healthPanel, "BOTTOM", 0, 0)
					else
						lfd:SetAlpha(1)
						lfd:Size(size)
						SV:ReversePoint(lfd, ico.roleIcon.attachTo, healthPanel, ico.roleIcon.xOffset, ico.roleIcon.yOffset)
					end
				else 
					frame:DisableElement('LFDRole')
					lfd:Hide()
				end 
			end 

			--[[ RAIDROLEICON ]]--

			if(ico.raidRoleIcons and frame.RaidRoleFramesAnchor) then 
				local roles = frame.RaidRoleFramesAnchor;
				if(not MINI_GRID and ico.raidRoleIcons.enable) then
					roles:Show()
					frame:EnableElement('Leader')
					frame:EnableElement('MasterLooter')
					local size = ico.raidRoleIcons.size;
					roles:ClearAllPoints()

					if(GRID_MODE) then
						roles:SetAlpha(0.7)
						roles:Size(10)
						roles:Point("CENTER", healthPanel, "TOPLEFT", 0, 2)
					else
						roles:SetAlpha(1)
						roles:Size(size)
						SV:ReversePoint(roles, ico.raidRoleIcons.attachTo, healthPanel, ico.raidRoleIcons.xOffset, ico.raidRoleIcons.yOffset)
					end
				else 
					roles:Hide()
					frame:DisableElement('Leader')
					frame:DisableElement('MasterLooter')
				end 
			end 

		end 
	end

	--[[ HEAL PREDICTION LAYOUT ]]--

	if frame.HealPrediction then
		if db.predict then 
			if not frame:IsElementEnabled('HealPrediction')then 
				frame:EnableElement('HealPrediction')
			end 
		else 
			if frame:IsElementEnabled('HealPrediction')then 
				frame:DisableElement('HealPrediction')
			end 
		end
	end 

	--[[ DEBUFF HIGHLIGHT LAYOUT ]]--

	if frame.Afflicted then
		if self.db.debuffHighlighting then
			if(template ~= "player" and template ~= "target" and template ~= "focus") then
				frame.Afflicted:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
			end
			frame:EnableElement('Afflicted')
		else 
			frame:DisableElement('Afflicted')
		end
	end 

	--[[ RANGE CHECK LAYOUT ]]--

	if frame.Range then
		if(template:find("raid") or template:find("party")) then
			frame.Range.outsideAlpha = self.db.groupOORAlpha or 1
		else
			frame.Range.outsideAlpha = self.db.OORAlpha or 1
		end

		if db.rangeCheck then 
			if not frame:IsElementEnabled('Range')then 
				frame:EnableElement('Range')
			end  
		else 
			if frame:IsElementEnabled('Range')then 
				frame:DisableElement('Range')
			end 
		end 
	end
end
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local definedEnvs,tags = {}, {};
local CharacterSelect = {"Munglunch", "Elv", "Tukz", "Azilroka", "Sortokk", "AlleyKat", "Quokka", "Haleth", "P3lim", "Haste", "Totalpackage", "Kryso", "Thepilli", "Doonga", "Judicate", "Cazart506", "Movster", "MuffinMonster", "Joelsoul", "Trendkill09", "Luamar", "Zharooz", "Lyn3x5", "Madh4tt3r", "Xarioth", "Sinnisterr", "Melonmaniac", "Hojowameeat", "Xandeca", "Bkan", "Daigan", "AtomicKiller", "Meljen", "Moondoggy", "Stormblade", "Schreibstift", "Anj", "Risien", "", ""};
local _PROXY;
local _ENV = {
	UnitPower = function(unit, g)
		if unit:find('target') or unit:find('focus') then 
			return UnitPower(unit, g)
		end
		return random(1, UnitPowerMax(unit, g)or 1)
	end, 
	UnitHealth = function(unit)
		if unit:find('target') or unit:find('focus') then 
			return UnitHealth(unit)
		end
		return random(1, UnitHealthMax(unit))
	end, 
	UnitName = function(unit)
		if unit:find('target') or unit:find('focus') then 
			return UnitName(unit)
		end
		local randomSelect = random(1, 40)
		local name = CharacterSelect[randomSelect];
		return name
	end, 
	UnitClass = function(unit)
		if unit:find('target') or unit:find('focus') then 
			return UnitClass(unit)
		end
		local token = CLASS_SORT_ORDER[random(1, #(CLASS_SORT_ORDER))]
		return LOCALIZED_CLASS_NAMES_MALE[token], token 
	end,
	Hex = function(r, g, b)
		if type(r) == "table" then
			if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return format("|cff%02x%02x%02x", r*255, g*255, b*255)
	end,
	ColorGradient = oUF_Villain.ColorGradient,
};
--[[ 
########################################################## 
GROUP CONFIG VISIBILITY
##########################################################
]]--
local function SetProxyEnv()
	if(_PROXY ~= nil) then return end
	_PROXY = setmetatable(_ENV, {__index = _G, __newindex = function(_,key,value) _G[key]=value end});
	tags['name:color'] = oUF_Villain.Tags.Methods['name:color']
	for i=1, 30 do
		tags['name:'..i] = oUF_Villain.Tags.Methods['name:'..i]
	end
	tags['name:grid'] = oUF_Villain.Tags.Methods['name:grid']
	tags['health:color'] = oUF_Villain.Tags.Methods['health:color']
	tags['health:current'] = oUF_Villain.Tags.Methods['health:current']
	tags['health:deficit'] = oUF_Villain.Tags.Methods['health:deficit']
	tags['health:curpercent'] = oUF_Villain.Tags.Methods['health:curpercent']
	tags['health:curmax'] = oUF_Villain.Tags.Methods['health:curmax']
	tags['health:curmax-percent'] = oUF_Villain.Tags.Methods['health:curmax-percent']
	tags['health:max'] = oUF_Villain.Tags.Methods['health:max']
	tags['health:percent'] = oUF_Villain.Tags.Methods['health:percent']
	tags['power:color'] = oUF_Villain.Tags.Methods['power:color']
	tags['power:current'] = oUF_Villain.Tags.Methods['power:current']
	tags['power:deficit'] = oUF_Villain.Tags.Methods['power:deficit']
	tags['power:curpercent'] = oUF_Villain.Tags.Methods['power:curpercent']
	tags['power:curmax'] = oUF_Villain.Tags.Methods['power:curmax']
	tags['power:curmax-percent'] = oUF_Villain.Tags.Methods['power:curmax-percent']
	tags['power:max'] = oUF_Villain.Tags.Methods['power:max']
	tags['power:percent'] = oUF_Villain.Tags.Methods['power:percent']
end

local function ChangeGroupIndex(self)
	if not self:GetParent().forceShow and not self.forceShow then return end
	if not self:IsShown() then return end

	local max = MAX_RAID_MEMBERS;
	local key = self.___groupkey
	local db = MOD.db[key]

	local newIndex = db.customSorting and -(min(db.groupCount * (db.gRowCol * 5), max) + 1 ) or -4;
	if self:GetAttribute("startingIndex") ~= newIndex then 
		self:SetAttribute("startingIndex", newIndex)
		self.isForced = true;
		MOD:AllowChildren(self, self:GetChildren())
	end
end

function MOD:SwapElement(unit, numGroup)
	if InCombatLockdown()then return end
	for i=1, numGroup do
		local unitName = unit..i
		local frame = self.Units[unitName]
		if(frame) then
			if(not frame.isForced) then 
				self:AllowElement(frame)
			else
				self:RestrictElement(frame)
			end
		end
	end 
end

local attrOverride = {
	["showRaid"] = true,
	["showParty"] = true,
	["showSolo"] = true
}
	
function MOD:UpdateGroupConfig(headerFrame, setForced)
	if InCombatLockdown() then return end

	SetProxyEnv()
	local key = headerFrame.___groupkey
	local db = self.db[key]
	headerFrame.forceShow = setForced;
	headerFrame.forceShowAuras = setForced;
	headerFrame.isForced = setForced;

	if setForced then 
		for _, func in pairs(tags) do 
			if type(func) == "function" then 
				if not definedEnvs[func] then 
					definedEnvs[func] = getfenv(func)
					setfenv(func, _PROXY)
				end 
			end 
		end
		RegisterStateDriver(headerFrame, "visibility", "show")
	else 
		for func, fenv in pairs(definedEnvs)do 
			setfenv(func, fenv)
			definedEnvs[func] = nil 
		end
		RegisterStateDriver(headerFrame, "visibility", db.visibility)
		local eventScript = headerFrame:GetScript("OnEvent")
		if eventScript then
			eventScript(headerFrame, "PLAYER_ENTERING_WORLD")
		end
	end

	for i = 1, #headerFrame.groups do
		local groupFrame = headerFrame.groups[i]

		if groupFrame:IsShown()then 
			groupFrame.forceShow = headerFrame.forceShow;
			groupFrame.forceShowAuras = headerFrame.forceShowAuras;
			groupFrame:HookScript("OnAttributeChanged", ChangeGroupIndex)
			if setForced then 
				for attr in pairs(attrOverride)do 
					groupFrame:SetAttribute(attr, nil)
				end

				ChangeGroupIndex(groupFrame)
				groupFrame:Update()
			else 
				for attr in pairs(attrOverride)do 
					groupFrame:SetAttribute(attr, true)
				end

				self:RestrictChildren(groupFrame, groupFrame:GetChildren())
				groupFrame:SetAttribute("startingIndex", 1)
				groupFrame:Update()
			end
		end 
	end

	headerFrame:SetActiveState()
	collectgarbage("collect")
end
--[[ 
########################################################## 
EVENTS AND INITIALIZE
##########################################################
]]--
function MOD:FrameForge()
	if not LoadedUnitFrames then
		self:SetUnitFrame("player")
		self:SetUnitFrame("pet")
		self:SetUnitFrame("pettarget")
		self:SetUnitFrame("target")
		self:SetUnitFrame("targettarget")
		self:SetUnitFrame("focus")
		self:SetUnitFrame("focustarget")
		self:SetEnemyFrames("boss", MAX_BOSS_FRAMES)
		self:SetEnemyFrames("arena", 5)
		LoadedUnitFrames = true;
	end
	if not LoadedGroupHeaders then
		self:SetGroupFrame("raid10")
		self:SetGroupFrame("raid25")
		self:SetGroupFrame("raid40")
		self:SetGroupFrame("raidpet", nil, "SVUI_UNITPET", nil, "SecureGroupPetHeaderTemplate")
		self:SetGroupFrame("party", nil, "SVUI_UNITPET, SVUI_UNITTARGET")
		self:SetGroupFrame("tank", "MAINTANK", "SVUI_UNITTARGET")
		self:SetGroupFrame("assist", "MAINASSIST", "SVUI_UNITTARGET")
		LoadedGroupHeaders = true
	end
end

function MOD:KillBlizzardRaidFrames()
	if InCombatLockdown() then return end
	CompactRaidFrameManager:Die()
	CompactRaidFrameContainer:Die()
	CompactUnitFrameProfiles:Die()
	local crfmTest = CompactRaidFrameManager_GetSetting("IsShown")
	if crfmTest and crfmTest ~= "0" then 
		CompactRaidFrameManager_SetSetting("IsShown","0")
	end
end

function MOD:GROUP_ROSTER_UPDATE()
	self:KillBlizzardRaidFrames()
	if(IsInGroup()) then
		if(not self:IsEventRegistered("ZONE_CHANGED_NEW_AREA")) then
			self:ZONE_CHANGED_NEW_AREA()
			self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		end
	else
		self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	end;
end

function MOD:PLAYER_REGEN_DISABLED()
	for _,frame in pairs(self.Headers) do 
		if frame and frame.forceShow then 
			self:UpdateGroupConfig(frame)
		end 
	end

	for _,frame in pairs(self.Units) do
		if frame and frame.forceShow then 
			self:RestrictElement(frame)
		end 
	end
end

function MOD:PLAYER_REGEN_ENABLED()
	self:UnregisterEvent("PLAYER_REGEN_ENABLED");
	self:RefreshUnitFrames()
end

function MOD:ADDON_LOADED(event, addon)
	self:KillBlizzardRaidFrames()
	if addon == 'Blizzard_ArenaUI' then
		oUF_Villain:DisableBlizzard('arena')
		self:UnregisterEvent("ADDON_LOADED")
	end
end

function MOD:PLAYER_ENTERING_WORLD()
	self:RefreshUnitFrames()
end

local UnitFrameThreatIndicator_Hook = function(unit, unitFrame)
	unitFrame:UnregisterAllEvents()
end
--[[ 
########################################################## 
BUILD FUNCTION / UPDATE
##########################################################
]]--
function MOD:ReLoad()
	if(not self.db.enable) then return end
	self:RefreshUnitFrames()
end

function MOD:Load()
	if(not self.db.enable) then return end
	self:RefreshUnitColors()

	local SVUI_UnitFrameParent = CreateFrame("Frame", "SVUI_UnitFrameParent", SV.UIParent, "SecureHandlerStateTemplate")
	RegisterStateDriver(SVUI_UnitFrameParent, "visibility", "[petbattle] hide; show")

	self:FrameForge()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")

	if(self.db.disableBlizzard) then 
		self:KillBlizzardRaidFrames()
		NewHook("CompactUnitFrame_RegisterEvents", CompactUnitFrame_UnregisterEvents)
		NewHook("UnitFrameThreatIndicator_Initialize", UnitFrameThreatIndicator_Hook)

		InterfaceOptionsFrameCategoriesButton10:SetScale(0.0001)
		InterfaceOptionsFrameCategoriesButton11:SetScale(0.0001)
		InterfaceOptionsStatusTextPanelPlayer:SetScale(0.0001)
		InterfaceOptionsStatusTextPanelTarget:SetScale(0.0001)
		InterfaceOptionsStatusTextPanelParty:SetScale(0.0001)
		InterfaceOptionsStatusTextPanelPet:SetScale(0.0001)
		InterfaceOptionsStatusTextPanelPlayer:SetAlpha(0)
		InterfaceOptionsStatusTextPanelTarget:SetAlpha(0)
		InterfaceOptionsStatusTextPanelParty:SetAlpha(0)
		InterfaceOptionsStatusTextPanelPet:SetAlpha(0)
		InterfaceOptionsCombatPanelEnemyCastBarsOnPortrait:SetAlpha(0)
		InterfaceOptionsCombatPanelEnemyCastBarsOnPortrait:EnableMouse(false)
		InterfaceOptionsCombatPanelTargetOfTarget:SetScale(0.0001)
		InterfaceOptionsCombatPanelTargetOfTarget:SetAlpha(0)
		InterfaceOptionsCombatPanelEnemyCastBarsOnNameplates:ClearAllPoints()
		InterfaceOptionsCombatPanelEnemyCastBarsOnNameplates:SetPoint(InterfaceOptionsCombatPanelEnemyCastBarsOnPortrait:GetPoint())
		InterfaceOptionsDisplayPanelShowAggroPercentage:SetScale(0.0001)
		InterfaceOptionsDisplayPanelShowAggroPercentage:SetAlpha(0)

		if not IsAddOnLoaded("Blizzard_ArenaUI") then 
			self:RegisterEvent("ADDON_LOADED")
		else 
			oUF_Villain:DisableBlizzard("arena")
		end

		self:RegisterEvent("GROUP_ROSTER_UPDATE", "KillBlizzardRaidFrames")
		UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")
	else 
		CompactUnitFrameProfiles:RegisterEvent("VARIABLES_LOADED")
	end
	
	local rDebuffs = SV.oUF_RaidDebuffs or oUF_RaidDebuffs;
	if not rDebuffs then return end
	rDebuffs.ShowDispelableDebuff = true;
	rDebuffs.FilterDispellableDebuff = true;
	rDebuffs.MatchBySpellName = true;
end
--[[ 
########################################################## 
DEFINE CONFIG AND REGISTER
##########################################################
]]--
SVLib:NewPackage(MOD, "SVUnit")