/*
Function name: MRH_fnc_MilsimTools_Core_InitPlayerLocal
Author: Mr H.
Description: Sets player "MRH_MilsimTools_Core_HasDied" variable at init, calls the Jip menu if the plyaer joined midgame
Return value: None
Public: No
Parameters: None 
Example(s):
called from cba post init eventhandlers, clientside only

MRH_fnc_MilsimTools_Core_InitPlayerLocal;
*/
#include "MRH_C_Path.hpp"
FUNC(BriefingAdminMenuLink);
//======init for the Has died variable
player setVariable ["MRH_MilsimTools_Core_HasDied", false, true];
FUNC(AddBriefingRoster);
//removes the map of players that are not leaders according to setting
_mapKeepSetting = ["MRH_MilsimTools_Rmv_map_nolead"] call cba_settings_fnc_get;
if (_mapKeepSetting) then 
{
	[] spawn 
	{
	waitUntil {(player == player) && (!isNull (findDisplay 46))};
	if (!isFormationLeader player) then {player unlinkItem "ItemMap";};
	};
};
// play cutcene
_cutSceneSetting = ["MRH_MilsimTools_PlayIntro_ToPlayer"] call cba_settings_fnc_get;
if (_cutSceneSetting) then 
{
	[] spawn 
	{
	waitUntil {(player == player) && (!isNull (findDisplay 46))};
	call MRH_fnc_MilsimTools_Core_CutsceneToPlayer;
	};
};

//===adds eventHandler when player is killed
_EHkilledIdx = player addEventHandler ["killed", 
	{
	
	//sets the hasdied variable
	player setVariable ["MRH_MilsimTools_Core_HasDied", true, true];
	
	//Tells the server a player has died
	MRH_MilsimTools_Core_PlayerDied = true;
	publicVariableServer "MRH_MilsimTools_Core_PlayerDied";
	// shows hint to admin
	[[],MRH_fnc_MilsimTools_Core_AdminDeadCount] RemoteExec ["Call",[0,-2] select isDedicated];
	
	}
];

//====opens Jip menu if Player did jip
if (didJip) then {
	// checks if player was killed and disconnected
	_deadPlayers = missionNamespace getVariable ["MRH_MilsimTools_Core_allIncludingDisconnectedDeadPlayers",[]];
	_uid = getPlayerUID player;
	_playerHasDiedAndReconnected = false;
		{
		if (_uid == _x select 0) then 
			{
			_playerHasDiedAndReconnected = true
			
			};
		} forEach _deadPlayers;
	// if so takes appropriate measures
	if (_playerHasDiedAndReconnected) then
	{
	[] spawn 
		{	waitUntil {(player == player) && (!isNull (findDisplay 46))};
			_AdminPref = ["MRH_MilsimTools_AllowDeadReco"] call cba_settings_fnc_get;
			if (_AdminPref) then 
			{
			
			["MRH_SpawnedDead",[localize "STR_MRH_MS_SPAWNDEADMESSAGE"]] call BIS_fnc_showNotification;
			sleep 10;
			player setDamage 1;
			};
		};
		
	}
	else
	{
	Diag_log format ["MRHMilsimTools Core -Player %1 didJip status %2 - Jip Menu called",str player, str didJip];
	// if not calls the Jip Menu
	[] spawn 
		{	
		waitUntil {(player == player) && (!isNull (findDisplay 46))};
		_adminJipPref = ["MRH_MilsimTools_Jip_MenuAllow"] call cba_settings_fnc_get;
		if (_adminJipPref) then 
			{
				call MRH_fnc_MilsimTools_Jip_Open_Menu;
			};
		};
	};
};
//respawn eventhandlers kept here for future use
/*
_EHrsp = player addEventHandler ["Respawn", {
	params ["_unit", "_corpse"];
	

}];
*/