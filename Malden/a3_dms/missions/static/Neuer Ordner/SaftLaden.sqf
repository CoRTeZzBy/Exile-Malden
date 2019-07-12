/*
	"SaftLaden." v1 static mission for Taunus.
	Created by Thomas TKO
	O_T_LSV_02_armed_viper_F increases persistent chance with difficulty
	tko-gameserver.de
*/

private ["_AICount", "_AIMaxReinforcements", "_AItrigger", "_AIwave", "_AIdelay", "_staticguns", "_missionObjs", "_crate0", "_crate1", "_crate_loot_values0", "_crate_loot_values1", "_crate_weapons0", "_crate_weapons1", "_crate_items0", "_crate_items1", "_crate_backpacks0", "_crate_backpacks1", "_difficultyM", "_difficulty", "_PossibleDifficulty", "_msgWIN", "_vehicle", "_pinCode", "_VehicleChance"];

// For logging purposes
_num = DMS_MissionCount;

// Set mission side (only "bandit" is supported for now)
_side = "bandit";

_pos = [17499.1,12270,0]; //insert the centre here

if ([_pos,DMS_StaticMinPlayerDistance] call DMS_fnc_IsPlayerNearby) exitWith {"delay"};

//create possible difficulty add more of one difficulty to weight it towards that
_PossibleDifficulty		= 	[	

								"moderate",
								"difficult",
								"hardcore"
							];
//choose mission difficulty and set value and is also marker colour
_difficultyM = selectRandom _PossibleDifficulty;

switch (_difficultyM) do
{
	case "easy":
	{
_difficulty = "easy";									//AI difficulty
_AICount = (20 + (round (random 5)));					//AI starting numbers
_AIMaxReinforcements = (1 + (round (random 4)));		//AI reinforcement cap , AI Verstärkungskappe
_AItrigger = (6 + (round (random 5)));					//If AI numbers fall below this number then reinforce if any left from AIMax , Maximaler AI-Wert in Verstärkungswellen
_AIwave = (6 + (round (random 4)));						//Max amount of AI in reinforcement wave
_AIdelay = (2 + (round (random 10)));					//The delay between reinforcements ,Die Verzögerung zwischen Verstärkungen
_VehicleChance = 10;									//10% SpawnPersistentVehicle chance
_crate_weapons0 	= (5 + (round (random 20)));		//Crate 0 weapons number
_crate_items0 		= (5 + (round (random 20)));		//Crate 0 items number
_crate_backpacks0 	= (3 + (round (random 1)));			//Crate 0 back packs number
_crate_weapons1 	= (4 + (round (random 2)));			//Crate 1 weapons number
_crate_items1 		= (10 + (round (random 40)));		//Crate 1 items number
_crate_backpacks1 	= (1 + (round (random 8)));			//Crate 1 back packs number
	};
	case "moderate":
	{
_difficulty = "moderate";
_AICount = (20 + (round (random 5)));
_AIMaxReinforcements = (2 + (round (random 4)));
_AItrigger = (8 + (round (random 5)));
_AIwave = (4 + (round (random 4)));
_AIdelay = (2 + (round (random 10)));					//The delay between reinforcements ,Die Verzögerung zwischen Verstärkungen
_VehicleChance = 10;									//20% SpawnPersistentVehicle chance
_crate_weapons0 	= (30 + (round (random 5)));
_crate_items0 		= (30 + (round (random 5)));
_crate_backpacks0 	= (5 + (round (random 1)));
_crate_weapons1 	= (30 + (round (random 5)));
_crate_items1 		= (30 + (round (random 5)));
_crate_backpacks1 	= (5 + (round (random 5)));
	};
	case "difficult":
	{
_difficulty = "difficult";
_AICount = (22 + (round (random 5)));
_AIMaxReinforcements = (2 + (round (random 4)));
_AItrigger = (8 + (round (random 5)));
_AIwave = (4 + (round (random 4)));
_AIdelay = (2 + (round (random 10)));					//The delay between reinforcements ,Die Verzögerung zwischen Verstärkungen
_VehicleChance = 20;									//20% SpawnPersistentVehicle chance
_crate_weapons0 	= (40 + (round (random 5)));
_crate_items0 		= (30 + (round (random 5)));
_crate_backpacks0 	= (5 + (round (random 1)));
_crate_weapons1 	= (30 + (round (random 5)));
_crate_items1 		= (40 + (round (random 5)));
_crate_backpacks1 	= (5 + (round (random 5)));
	};
	//case "hardcore":
	default
	{
_difficulty = "hardcore";
_AICount = (25 + (round (random 5)));
_AIMaxReinforcements = (2 + (round (random 4)));
_AItrigger = (8 + (round (random 5)));
_AIwave = (4 + (round (random 4)));
_AIdelay = (2 + (round (random 10)));					//The delay between reinforcements ,Die Verzögerung zwischen Verstärkungen
_VehicleChance = 50;									//20% SpawnPersistentVehicle chance
_crate_weapons0 	= (40 + (round (random 5)));
_crate_items0 		= (40 + (round (random 5)));
_crate_backpacks0 	= (5 + (round (random 1)));
_crate_weapons1 	= (35 + (round (random 5)));
_crate_items1 		= (35 + (round (random 5)));
_crate_backpacks1 	= (5 + (round (random 5)));
	};
};

// Define spawn locations for AI Soldiers. These will be used for the initial spawning of AI as well as reinforcements.
// The center spawn location is added 3 times so at least 3 AI will spawn initially at the center location, and so that future reinforcements are more likely to spawn at the center.
_AISoldierSpawnLocations =
[
	//AI
	[17469.2,12292.6,0],
	[17466.8,12272.3,0],
	[17497.4,12289.7,0],
	[17467.9,12249.8,0],
	[17487.5,12242.1,0],
	[17544.9,12276.8,0],
	[17554.5,12271.4,0],
	[17547.3,12256.5,0],
	[17532.8,12228.6,0],
	[17526.4,12272.9,0],
	[17538.1,12259.4,0],
	[17508.1,12292.4,0],
	[17460.5,12281,0],
	[17463.2,12265.8,0],
	[17454.2,12271.9,0],
	[17493.8,12258.9,0],
	[17508.5,12230.8,0],
	[17468.8,12302.2,0]
];

_group =
[
	_AISoldierSpawnLocations+[_pos,_pos,_pos],			// Pass the regular spawn locations as well as the center pos 3x
	_AICount,											// Set in difficulty select
	_difficulty,										// Set in difficulty select
	"random",
	_side
] call DMS_fnc_SpawnAIGroup_MultiPos;

//Reduce Static guns if mission is easy
if (_difficultyM isEqualTo "easy") then {
_staticGuns =
[
	[
    //Hoch HMG
	[17541,12284.7,18.212],
	[17536.5,12275.3,18.212],
	[17520.3,12293.3,17.409],
	[17511.3,12281.8,17.445],
	[17521.5,12277.4,17.855],
	[17480.8,12287.6,3.686],
	[17500.4,12249.7,4.793],
	[17528.4,12237,5.594],
	[17534,12249.3,5.434],
	[17515.8,12258,4.861],
	[17505.3,12266.5,1.878],
	[17539,12250.3,3.020],
	[17536.7,12274.9,13.094],
	//Boden HMG
	[17492.5,12295.2,0],
	[17473.5,12301.8,0],
	[17451.9,12272.4,0],
	[17526.4,12232.4,0],
    //Hoch HMG
	[17523.4,12248.1,5.260],
	[17512.4,12259.5,4.745],
	[17537.8,12287.1,1.141],
	//Boden HMG
	[17511.2,12291,0],
	[17519.5,12262.7,0],
	[17544.7,12281,0],
	[17560.2,12273.6,0],
	[17553.6,12255.4,0],
	[17531.1,12221.2,0],
	[17498,12239.5,0],
	[17539.1,12252.2,0]	
	],
	_group,
	"assault",
	_difficulty,
	"bandit",
	"random"
] call DMS_fnc_SpawnAIStaticMG;
										} else
										{
_staticGuns =
[
	[
    //Hoch HMG
	[17541,12284.7,18.212],
	[17536.5,12275.3,18.212],
	[17520.3,12293.3,17.409],
	[17511.3,12281.8,17.445],
	[17521.5,12277.4,17.855],
	[17480.8,12287.6,3.686],
	[17500.4,12249.7,4.793],
	[17528.4,12237,5.594],
	[17534,12249.3,5.434],
	[17515.8,12258,4.861],
	[17505.3,12266.5,1.878],
	[17539,12250.3,3.020],
	[17536.7,12274.9,13.094],
	//Boden HMG
	[17492.5,12295.2,0],
	[17473.5,12301.8,0],
	[17451.9,12272.4,0],
	[17526.4,12232.4,0],
    //Hoch HMG
	[17523.4,12248.1,5.260],
	[17512.4,12259.5,4.745],
	[17537.8,12287.1,1.141],
	//Boden HMG
	[17511.2,12291,0],
	[17519.5,12262.7,0],
	[17544.7,12281,0],
	[17560.2,12273.6,0],
	[17553.6,12255.4,0],
	[17531.1,12221.2,0],
	[17498,12239.5,0],
	[17539.1,12252.2,0]	
	],
	_group,
	"assault",
	_difficulty,
	"bandit",
	"random"
] call DMS_fnc_SpawnAIStaticMG;
										};

// Define the classnames and locations where the crates can spawn (at least 2, since we're spawning 2 crates)
_crateClasses_and_Positions =
[
	[[17502.3,12288.2,0],"I_CargoNet_01_ammo_F"],
	[[17551.2,12261.2,0],"I_CargoNet_01_ammo_F"],
	[[17457.2,12276.5,0],"I_CargoNet_01_ammo_F"], 
	[[17468.8,12261.1,0],"I_CargoNet_01_ammo_F"]
];

{
	deleteVehicle (nearestObject _x);		// Make sure to remove any previous crates.
} forEach _crateClasses_and_Positions;

// Shuffle the list
_crateClasses_and_Positions = _crateClasses_and_Positions call ExileClient_util_array_shuffle;


// Create Crates
_crate0 = [_crateClasses_and_Positions select 0 select 1, _crateClasses_and_Positions select 0 select 0] call DMS_fnc_SpawnCrate;
_crate1 = [_crateClasses_and_Positions select 1 select 1, _crateClasses_and_Positions select 1 select 0] call DMS_fnc_SpawnCrate;

// Don't think an armed AI vehicle fit the idea behind the mission. You're welcome to uncomment this if you want.
//_veh =
//[
//	[
//		[_pos,100,random 360] call DMS_fnc_SelectOffsetPos,
//		_pos
//	],
//	_group,
//	"assault",
//	_difficulty,
//	_side
//] call DMS_fnc_SpawnAIVehicle;

// Enable smoke on the crates due to size of area
{
	_x setVariable ["DMS_AllowSmoke", true];
} forEach [_crate0,_crate1];

// Define mission-spawned AI Units
_missionAIUnits =
[
	_group 		// We only spawned the single group for this mission
];

// Define the group reinforcements
_groupReinforcementsInfo =
[
	[
		_group,			// pass the group
		[
			[
				0,		// Let's limit number of units instead...
				0
			],
			[
				_AIMaxReinforcements,	// Maximum units that can be given as reinforcements (defined in difficulty selection).
				0
			]
		],
		[
			_AIdelay,		// The delay between reinforcements. >> you can change this in difficulty settings
			diag_tickTime
		],
		_AISoldierSpawnLocations,
		"random",
		_difficulty,
		_side,
		"reinforce",
		[
			_AItrigger,		// Set in difficulty select - Reinforcements will only trigger if there's fewer than X members left
			_AIwave			// X reinforcement units per wave. >> you can change this in mission difficulty section
		]
	]
];

// setup crates with items from choices
_crate_loot_values0 =
[
	_crate_weapons0,		// Set in difficulty select - Weapons
	_crate_items0,			// Set in difficulty select - Items
	_crate_backpacks0 		// Set in difficulty select - Backpacks
];
_crate_loot_values1 =
[
	_crate_weapons1,		// Set in difficulty select - Weapons
	_crate_items1,			// Set in difficulty select - Items
	_crate_backpacks1 		// Set in difficulty select - Backpacks
];

// is %chance greater than random number[30026.7,17458.6,5]O_T_VTOL_02_vehicle_grey_F
if (_VehicleChance >= (random 100)) then {
											_pinCode = (1000 +(round (random 8999)));
											_vehicle = ["Mrshounka_veneno_c_jaune",[17549.8,12268.4,0],_pinCode] call DMS_fnc_SpawnPersistentVehicle;
											_msgWIN = ['#0080ff',format ["Haste schoen gemacht der code ist %1...",_pinCode]];
											} else
											{
											_vehicle = ["Mrshounka_veneno_c_jaune",[17549.8,12268.4,0]] call DMS_fnc_SpawnNonPersistentVehicle;
											_msgWIN = ['#0080ff',"Haste schoen gemacht code gibt es nicht"];
											};

// Define mission-spawned objects and loot values with vehicle
_missionObjs =
[
	_staticGuns,			// static gun(s). Note, we don't add the base itself because it already spawns on server start.
	[_vehicle],				// vehicle prize
	[[_crate0,_crate_loot_values0],[_crate1,_crate_loot_values1]]
];	
											
// Define Mission Start message
_msgStart = ['#FFFF00',format["Ai Party im Strom verteiler Werk %1 Truppen",_difficultyM]];

// Define Mission Win message defined in vehicle choice

// Define Mission Lose message
_msgLOSE = ['#FF0000',"Kein wunder mit der Knifte"];

// Define mission name (for map marker and logging)
_missionName = "SaftLaden";

// Create Markers
_markers =
[
	_pos,
	_missionName,
	_difficultyM
] call DMS_fnc_CreateMarker;

_circle = _markers select 1;
_circle setMarkerDir 0;
_circle setMarkerSize [400,400];

_time = diag_tickTime;

// Parse and add mission info to missions monitor
_added =
[
	_pos,
	[
		[
			"kill",
			_group
		],
		[
			"playerNear",
			[_pos,100]
		]
	],
	_groupReinforcementsInfo,
	[
		_time,
		DMS_StaticMissionTimeOut call DMS_fnc_SelectRandomVal
	],
	_missionAIUnits,
	_missionObjs,
	[_missionName,_msgWIN,_msgLOSE],
	_markers,
	_side,
	_difficultyM,
	[[],[]]
] call DMS_fnc_AddMissionToMonitor_Static;

// Check to see if it was added correctly, otherwise delete the stuff
if !(_added) exitWith
{
	diag_log format ["DMS ERROR :: Attempt to set up mission %1 with invalid parameters for DMS_fnc_AddMissionToMonitor_Static! Deleting mission objects and resetting DMS_MissionCount.",_missionName];

	_cleanup = [];
	{
		_cleanup pushBack _x;
	} forEach _missionAIUnits;

	_cleanup pushBack ((_missionObjs select 0)+(_missionObjs select 1));
	
	{
		_cleanup pushBack (_x select 0);
	} foreach (_missionObjs select 2);

	_cleanup call DMS_fnc_CleanUp;

	// Delete the markers directly
	{deleteMarker _x;} forEach _markers;

	// Reset the mission count
	DMS_MissionCount = DMS_MissionCount - 1;
};

// Notify players
[_missionName,_msgStart] call DMS_fnc_BroadcastMissionStatus;

if (DMS_DEBUG) then
{
	(format ["MISSION: (%1) :: Mission #%2 started at %3 with %4 AI units and %5 difficulty at time %6",_missionName,_num,_pos,_AICount,_difficulty,_time]) call DMS_fnc_DebugLog;
};