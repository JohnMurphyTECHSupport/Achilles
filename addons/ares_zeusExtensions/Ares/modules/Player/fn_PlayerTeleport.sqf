////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	AUTHOR: Kex
//	DATE: 6/9/16
//	VERSION: 1.0
//	FILE: Ares\functions\fn_PlayerTeleport.sqf
//  DESCRIPTION: Teleport Module
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include "\ares_zeusExtensions\Ares\module_header.hpp"

_tp_pos = position _logic;

_dialogResult = [
	localize "STR_TELEPORT", 
	[ 
		["STR_MODE",[localize "STR_ALL",localize "STR_SELECTION",localize "STR_SIDE"]],
		[localize "STR_SIDE","ALLSIDE"]
	],
	true
] call Ares_fnc_ShowChooseDialog;

_playersToTeleport = switch (_dialogResult select 0) do
{
	case 0: 
	{
		[{alive _this}, allPlayers] call Achilles_fnc_filter;
	};
	case 1: 
	{
		_selection = [toLower localize "STR_PLAYERS"] call Achilles_fnc_SelectUnits;
		if (isNil "_selection") exitWith {nil};
		[{isPlayer _this},_selection] call Achilles_fnc_filter;
	};
	case 2: 
	{
		_side_index = _dialogResult select 1;
		if (_side_index == 0) exitWith {[player]};
		_side = [east,west,independent,civilian] select ((_dialogResult select 1) - 1);
		[{(alive _this) and (side _this == _side)}, allPlayers] call Achilles_fnc_filter};
	;
};
sleep 1;

if (isNil "_playersToTeleport") exitWith {};
if (count _playersToTeleport == 0) exitWith 
{
	["No players in selection!"] call Ares_fnc_ShowZeusMessage; 
	playSound "FD_Start_F";
};

// Call the teleport function.
[_playersToTeleport, _tp_pos] call Ares_fnc_TeleportPlayers;

[objNull, format["Teleported %1 players to %2", (count _playersToTeleport), _tp_pos]] call bis_fnc_showCuratorFeedbackMessage;

#include "\ares_zeusExtensions\Ares\module_footer.hpp"

