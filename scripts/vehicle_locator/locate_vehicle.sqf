private ["_characterID","_found","_i","_keyID","_keyIDS","_keyList","_keyName","_keyNames","_vehicleMarker","_vehicleName","_targetPosition","_vehicle_type","_showMapMarker","_markerColour"];

//**************************************************************************************************************************************
// CONFIG

_showMapMarker = True;            // True = display the map markers, False = just identify the keys
_markerColour = "ColorOrange";    // Alternatives = "ColorBlack", "ColorRed", "ColorGreen", "ColorBlue", "ColorYellow", "ColorWhite"

//**************************************************************************************************************************************

_keyList = call epoch_tempKeys;
_keyIDS = _keyList select 0;
_keyNames = _keyList select 1;

_i = 0;
for "_i" from 0 to 60 do {deleteMarkerLocal ("vehicleMarker"+ (str _i));};

if (count _keyIDS == 0) exitWith {systemchat "No key found!"};

_i = 0;
{
	_keyID = parseNumber (_keyIDS select _forEachIndex);
	_keyName = _keyNames select _forEachIndex;
	_found = 0;
	{
		_vehicle_type = typeOf _x;
		_characterID = parseNumber (_x getVariable ["CharacterID","0"]);
		if ((_characterID == _keyID) && {_vehicle_type isKindOf "Air" || _vehicle_type isKindOf "LandVehicle" || _vehicle_type isKindOf "Ship"}) then {
			_found = _found +1;
			_i = _i +1;
			
			_vehicleName = getText (configFile >> "CfgVehicles" >> _vehicle_type >> "displayName");
			
			if (_showMapMarker){
				_targetPosition = getPos _x;
				_vehicleMarker = createMarkerLocal ["vehicleMarker" + (str _i),[_targetPosition select 0,_targetPosition select 1]];
				_vehicleMarker setMarkerShapeLocal "ICON";
				_vehicleMarker setMarkerTypeLocal "DOT";
				_vehicleMarker setMarkerColorLocal _markerColour;
				_vehicleMarker setMarkerSizeLocal [1.0, 1.0];
				_vehicleMarker setMarkerTextLocal format ["Here is your: %1",_vehicleName];
			};
			
			systemChat format ["%1 belongs to %2%3.",_keyName,_vehicleName,if (!alive _x) then {" (destroyed)"} else {""}];
		};
	} forEach vehicles;
	if (_found == 0) then {systemChat format ["No vehicles found for %1.",_keyName]};
} forEach _keyIDS;

if (_i > 0 && _showMapMarker) then {systemChat format ["Found %1 matching vehicles, check your map for marked locations.",_i];};
