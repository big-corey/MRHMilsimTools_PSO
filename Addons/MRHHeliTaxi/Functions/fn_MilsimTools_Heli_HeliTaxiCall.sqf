openMap [true,true];
hint localize "STR_MRH_HeliTaxi_HintSelectLZ";
onMapSingleClick {
	onMapSingleClick "";
	_availableDoubleCheck = call MRH_fnc_MilsimTools_Heli_isHeliTaxiAvailable;
	if !(_availableDoubleCheck) ExitWith {hint (localize "STR_MRH_HeliTaxi_HintUnavailable");openMap [false,false];};
	deleteMarkerLocal "MRH_LZ_Marker";
	hint localize "STR_MRH_HeliTaxi_HintLZSet";
	_suitablePos = [_pos] call MRH_fnc_MilsimTools_Heli_findSuitableLZ;
	_marker = createMarkerLocal ["MRH_LZ_Marker", _suitablePos];
	_marker setMarkerTypeLocal "MRH_Heli";
	_marker setMarkerTextLocal (localize "STR_MRH_HeliTaxi_MarkerSelectedLz");
	_marker setMarkerColorLocal "ColorGreen";
	_marker setMarkerAlphaLocal 1;
	[] Spawn {sleep 5; openMap [false,false];};
	[_suitablePos] call MRH_fnc_MilsimTools_Heli_HeliOnTheWay;
	_VarName = "MRH_HeliTaxi_Available" + str (side player);
	missionNamespace setVariable [_VarName,false,true];
};