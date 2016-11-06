
#define CHAIRS_CLASS_NAMES 		["Land_CampingChair_V2_F", "Land_CampingChair_V1_F", "Land_Chair_EP1", "Land_RattanChair_01_F", "Land_Bench_F", "Land_ChairWood_F", "Land_OfficeChair_01_F"]
#define IDD_COMPOSITIONS 		133799

#include "\achilles\modules_f_ares\module_header.hpp"

private '_center_object';
_spawn_pos = position _logic;

createDialog "Ares_composition_Dialog";
["LOADED"] spawn Achilles_fnc_RscDisplayAttributes_spawnAdvancedComposition;
waitUntil {!dialog};
if ((uiNamespace getVariable ['Ares_Dialog_Result', -1]) == -1) exitWith {};

_objects_info = [] call compile Ares_var_current_composition;
if (count _objects_info == 0) exitWith {[localize "STR_NO_OBJECT_SELECTED"] call Ares_fnc_ShowZeusMessage; playSound "FD_Start_F"};
_center_object_info = _objects_info select 0;
_objects_info = _objects_info - [_center_object_info];

_type = _center_object_info select 0;
_center_dir = _center_object_info select 2;
_allow_sim = _center_object_info select 3;

_center_object = _type createVehicle [0,0,0];
[_center_object,false] remoteExec ["enableSimulationGlobal",2];
_center_object setPosATL [-500,-500,0];
_center_object setDir _center_dir;

[[_center_object], true] call Ares_fnc_AddUnitsToCurator;
_attached_objects = [];
{
	_object_info = _x;
	
	_type = _object_info select 0;
	_pos = _object_info select 1;
	_dir = _object_info select 2;
	_pos = (getPosWorld _center_object) vectorAdd _pos;
	_dir = _dir - (getDir _center_object);
	_allow_sim = _object_info select 3;
	
	_object = _type createVehicle [0,0,0];
	[_object,_allow_sim] remoteExec ["enableSimulationGlobal",2];
	_object setPosWorld _pos;
	_object attachTo [_center_object];
	[_object, _dir] remoteExec ['setDir',0,true];
	_attached_objects pushBack _object;
} forEach _objects_info;
_center_object setPos _spawn_pos;
[_center_object,true] remoteExec ["enableSimulationGlobal",2];
_center_object setVariable ["ACS_attached_objects",_attached_objects];
_center_object setVariable ["ACS_center_dir", _center_dir];
[_center_object, _attached_objects] spawn {waitUntil {sleep 1; isNull (_this select 0)}; {deleteVehicle _x} forEach (_this select 1)};


#include "\achilles\modules_f_ares\module_footer.hpp"