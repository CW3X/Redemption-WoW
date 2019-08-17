--[[

────╔═╗─╔═╗───╔═══════╦══╗╔══╗
────║ ║─║ ║───║ ╔╗ ╔╗ ╠╗ ╚╝ ╔╝
────║ ╚═╝ ╠═══╬═╣║ ║╚═╝╚╗  ╔╝
────║ ╔═╗ ║║ ═╬═╣║ ║───╔╝  ╚╗
────║ ║─║ ║║ ═╣ ║║ ║──╔╝ ╔╗ ╚╗
────╚═╝─╚═╩═══╩═╝╚═╝──╚══╝╚══╝
─────────────╔═══╗─────────╔╗
─────────────║╔═╗║────────╔╝╚╗
─────────────║╚══╦══╦═╦╦══╬╗╔╬══╗
─────────────╚══╗║╔═╣╔╬╣╔╗║║║║══╣
─────────────║╚═╝║╚═╣║║║╚╝║║╚╬══║
─────────────╚═══╩══╩╝╚╣╔═╝╚═╩══╝
───────────────────────║║
───────────────────────╚╝
		Scripts by Heitx may be edited,
			but all credits must be provided.

╔══════════════════════════════════════════╦══════════════════════════════════════════╗
║            Script Information            ║              Script Feature              ║
╠══════════════════════════════════════════╬══════════════════════════════════════════╣
║- Written by: Heitx.                      ║+ Lot of Customization,                   ║
║- Completion: 100 %                       ║+ Different type of rewards               ║
║- Script Name: Killstreak System          ║+ Loopsystem with chance                  ║
║- Description: Sends a message to every   ║+ IPTrack, LevelRange                     ║
║ player in the realm, when player reaches ║+ Custom message for every 'killstreak'   ║
║ x amount of kills and rewards the player.║++ More will hopefully be added!          ║
╚══════════════════════════════════════════╩══════════════════════════════════════════╝
--]]

--[[
╔══════════════════════════════════════════╦══════════════════════════════════════════╗
║            Config Description            ║             Config Variables             ║
╠══════════════════════════════════════════╬══════════════════════════════════════════╣
║ -serverName: Beginning of a announce     ║ "[PvP Announcer]" <- "Heitx is ..."      ║
║ -announcer: The global announce          ║ True -> Enable, False -> Disable         ║
║ -giveRewards: Give the player rewards    ║ {true, false, false} | {item, gold, xp}  ║
║ -giveBonus: Bonus reward every x kills   ║ True -> Enable, False -> Disable         ║
║ -levelRange: Difference allowed in level ║ 5 -> True:(75-80) False:(5-11)           ║
║ -trackIP: track IPs on both              ║ True -> Scan IPs, if same, no killstreak ║
║ -notifyPlayer: Notify on every kill      ║ or when victim dies {player, victim}     ║
║ -notifyMessage: Message to player&victim ║ {"player message", "victim message"}     ║
║ -ksData: Stores the data for message     ║ {"message", xkills}                      ║
║ -colors: Stores the hexcolors for text   ║ {"00FF00", "003366"}                     ║
║ -zoneProtection: disable zone to trigger ║ {ZoneID, ...} Reverse function: Line 134 ║
║ -endOnLogout: Streak ends on logout      ║ True -> Reset, False -> save till restart║
╚══════════════════════════════════════════╩══════════════════════════════════════════╝
--]]

--[[
╔══════════════════════════════════════════╗
║            [Message Features]            ║
╠══════════════════════════════════════════╣
║ |P| : Killer's name                      ║
║ |V| : Victim's name                      ║
║ |PC| : Killer's classID                  ║
║ |VC| : Victim's classID                  ║
║ |C1| ..  : Colors!                       ║
╚══════════════════════════════════════════╝
1 = Warrior, 2 = Paladin, 3 = Hunter, 4 = Rogue,
5 = Priest, 6 = Death Knight, 7 = Shaman,
8 = Mage, 9 = Warlock, 10 = Monk, 11 = Druid
Use this code: |C|PC||
--]]

local scriptActive 	= true

local serverName 	= "|C4|[|C5|PvP Announcer|C4|] "
local announcer 	= true
local giveRewards 	= {true, false, false} -- item, gold, xp
local giveBonus		= true
local levelRange 	= 10
local trackIP 		= false
local notifyPlayers = {true, true}
local notifyMessage = {"|C1|Killstreak: |C2||S|", "Sorry |V|, Killstreak ended."}
local endOnLogout 	= true

local ksData = { -- {"message", xkills, {itemID, amount, gold, xp} } 1 -> 100 -> 100c -> 1s : 10000 = 100s = 1g
	{"|C1||P||C2| is on a killstreak of |C3||S||C2|!", 2, {20880, 2, 100000000, 5000} },
	{"|C1||P||C2| is untouchable! |C3||S||C2| KILLS!", 5, {20880, 2, 100000000, 5000} }
}

local zoneProtection = {}

local ksBonus = { -- { itemID, amount,  loopKills, chance}
	{5435, 1, 15, 10},
	{3004, 5, 30, 5}
}

-- Color a specific class? 1 = Warrior, etc. |C|PC|||P||C12| : Replace P with V for victim.
local colors = {
	"C79C6E", -- |C1| (Warrior)
	"F58CBA", -- |C2| (Paladin)
	"ABD473", -- |C3| (Hunter)
	"FFF569", -- |C4| (Rogue)
	"FFFFFF", -- |C5| (Priest)
	"C41F3B", -- |C6| (Death Knight)
	"0070DE", -- |C7| (Shaman)
	"69CCF0", -- |C8| (Mage)
	"9482C9", -- |C9| (Warlock)
	"00FF96", -- |C10| (Monk)
	"FF7D0A", -- |C11| (Druid)
	"CC0000", -- |C12| (CUSTOM)
}

--[[ The section beneath this line is untouchable, 
		unless you know what you're doing! --]]

local streakSave = {} -- killstreak holder

local func = {} -- function holder

local function Killstreak_onKill(event, player, victim)
	local pGUID = player:GetGUIDLow()
	local vGUID = victim:GetGUIDLow()

	math.randomseed( os.time() )

	-- Adds functionality to 'message feature' is described
	local function TextMessage(message)
		message = message:gsub("|P|", player:GetName())
		message = message:gsub("|V|", victim:GetName())
		message = message:gsub("|PC|", player:GetClass())
		message = message:gsub("|VC|", victim:GetClass())

		if (streakSave[pGUID] ~= nil) then
			message = message:gsub("|S|", streakSave[pGUID])
		end

		for i, v in pairs(colors) do
			message = message:gsub("|C" .. i .. "|", '|cff' .. v)
		end

		return message
	end

	-- Add the message features to TAG string.
	serverName = TextMessage(serverName) -- (message)

	if ( func.IdenticalIP(player, victim) == false) then -- player's & victim's IP are not identical (player, victim)
		if (func.ZonePlayerCheck(player) == false) then -- Reverse false to true, to reverse the zoneProtection effect
			if (pGUID ~= vGUID) and (math.abs(player:GetLevel() - victim:GetLevel()) <= levelRange) then
				-- Player has no value, set is to 0
				if ( streakSave[pGUID] == nil ) then
					streakSave[pGUID] = 0
				end

				-- Player has a value, add +1 to it
				if ( streakSave[pGUID] ~= nil ) then
					streakSave[pGUID] = streakSave[pGUID] + 1
				end

				-- Victim's killstreak returns back to 0, if its above 0
				if (streakSave[vGUID] ~= nil) then
					streakSave[vGUID] = 0
				end

				func.NotifyPlayer( player, victim, TextMessage(notifyMessage[1]), TextMessage(notifyMessage[2]) ) -- (player, victim, message1, message2)
				func.Rewards(player)
				func.BonusReward(player)

				for i, v in pairs(ksData) do
					if ( v[2] == streakSave[player:GetGUIDLow()] ) then
						if (announcer) then
							SendWorldMessage(serverName .. TextMessage(v[1]) .. '|r')
						end

						return false
					end
				end

			end -- end pGUID
		end -- end ZoneCheckPlayer
	end -- end IdenticalIP--]]
end

local function Killstreak_onLogout(event, player)
	if (endOnLogout) then
		streakSave[player:GetGUIDLow()] = 0
	end
end

--[[ CUSTOM FUNCTIONS : SAVED IN func TABLE ]]

function func.IdenticalIP(player, victim)
	if (trackIP) then -- trackIP == true
		if (player:GetPlayerIP() == victim:GetPlayerIP()) then -- if player & victim IP are identical
			return true -- return true
		end
	end

	return false -- always return false, unless true
end

function func.ZonePlayerCheck(player)
	if (#zoneProtection > 0) then -- if zoneprotection is above 0
		for i, v in pairs(zoneProtection) do -- for every number inside zoneProctection
			if (player:GetZoneId() == v) then -- if player is inside one of the zones
				return true -- return true
			end
		end
	end

	return false -- always return false, unless true
end

function func.NotifyPlayer(player, victim, message1, message2)
	if (notifyPlayers[1] == true) then -- if player is true
		player:SendBroadcastMessage(serverName .. message1) -- send message to player
	end
	if (notifyPlayers[2] == true) then -- if victim is true
		victim:SendBroadcastMessage(serverName .. message2) -- send message to player
	end
end

function func.Rewards(player)
	for i, v in pairs(ksData) do
		if ( v[2] == streakSave[player:GetGUIDLow()] ) then
			if (giveRewards[1] == true) then
				player:AddItem(v[3][1], v[3][2])
			end
			if (giveRewards[2] == true) then
				player:ModifyMoney(v[3][3])
			end
			if (giveRewards[3] == true) then
				player:GiveXP(v[3][4])
			end

			return false
		end
	end
end

function func.BonusReward(player) -- { itemID, amount,  loopKills, chance}
	if (giveBonus) then
		for i, v in pairs(ksBonus) do
			if ( streakSave[player:GetGUIDLow()] % v[3] == 0 ) and ( streakSave[player:GetGUIDLow()] ~= 0) then
				if ( math.random(1, 100) >= 100 - v[4] ) then
					player:AddItem(v[1], v[2])
				end
			end
		end
	end
end

if (scriptActive == true) then
	RegisterPlayerEvent(6, Killstreak_onKill)
	RegisterPlayerEvent(4, Killstreak_onLogout)
end