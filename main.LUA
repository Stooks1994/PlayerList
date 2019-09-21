SLASH_ADD_TO_TABLE1 = "/pladd"
function SlashCmdList.ADD_TO_TABLE(msg)
	local player_name, reason = string.match(msg, '(%a+)%s(.+)');
	if player_name ~= nil and reason ~= nil then
		if Players[player_name] ~= nil then
			print(player_name .. " has already been added to the list");
		else
			Players[player_name] = reason .. " [" .. date("%m/%d/%y") .. "]";
			print("Add successful");
		end
	else
		print("Adds a player to your PlayerList. Use format: /pladd <name> <reason>")
	end
end

SLASH_CHECK_TABLE1 = "/plcheck"
function SlashCmdList.CHECK_TABLE(msg)
	local player_name = string.match(msg, '(%a+)');
	if player_name ~= nil then
		if Players[player_name] ~= nil then
			print(player_name .. " " .. Players[player_name]);
		else 
			print(player_name .. " was not found");
		end
	else
		print("Checks your PlayerList for a player. Use format: /plcheck <name>");
	end
end

SLASH_REMOVE_FROM_TABLE1 = "/plremove"
function SlashCmdList.REMOVE_FROM_TABLE(msg)
	local player_name = string.match(msg, '(%a+)');
	if player_name ~= nil then
		if Players[player_name] ~= nil then
			Players[player_name] = nil;
			print("Remove successful");
		else
			print(player_name .. " was not on your PlayerList");
		end
	else
		print("Removes a player from your PlayerList. Use format /plremove <name>");
	end
end

SLASH_CLEAR_TABLE1 = "/plclear"
function SlashCmdList.CLEAR_TABLE()
	Players = {};
	print("Cleared PlayerList");
end

SLASH_PRINT_TABLE1 = "/plprint"
function SlashCmdList.PRINT_TABLE()
	for k, v in pairs(Players) do
		print(k, v);
	end
end
	
SLASH_HELP1 = "/pl"
SLASH_HELP2 = "/plhelp"
function SlashCmdList.HELP()
	print("Use one of the commands: /pladd, /plcheck, /plvalue, /plprint, /plclear")
end

addon_loaded = IsAddOnLoaded("PlayerList");

if addon_loaded ~= nil then
	if Players == nil then
		Players = {};
	end
else
	print("failed load");
end

function CreateListOfPlayers()
	local plist = {}
	if IsInRaid() then
		for i=1, 40 do
			if (UnitName('raid'..i)) then
				tinsert(plist, (UnitName('raid'..i)));
			end
		end
	elseif IsInGroup() then
		for i=1, 4 do
			if (UnitName('party'..i)) then
				tinsert(plist, (UnitName('party'..i)));
			end
		end
	end
	return plist;
end

function CheckPlayerList(player_name)
	if Players[player_name] ~= nil then
		print(player_name .. " " .. Players[player_name])
	end
end
		
--[[local frame = CreateFrame("FRAME", "PlayerListFrame");
frame:RegisterEvent("GROUP_ROSTER_UPDATE");
local function eventHandler(self, event, ...)
	group_members = CreateListOfPlayers();
	for k, v in pairs(group_members) do		
		CheckPlayerList(v);
	end
end
frame:SetScript("OnEvent", eventHandler);]]

local current_group = {};
local frame, events = CreateFrame("Frame"), {};

function events:GROUP_ROSTER_UPDATE(...)
	group_members = CreateListOfPlayers();
	for k, v in pairs(group_members) do
		if current_group[v] ~= nil then
			CheckPlayerList(v);
			current_group[v] = "";
		end
	end
end

function events:GROUP_LEFT(...)
	current_group = {};
end

frame:SetScript("OnEvent", function(self, event, ...)
	events[event](self, ...);
end);

for k, v in pairs(events) do
	frame:RegisterEvent(k);
end




