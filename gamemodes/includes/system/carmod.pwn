#include <YSI\y_hooks>

new bool:VCarModingSetting[MAX_PLAYERS char];
new VCarModingBiz[MAX_PLAYERS];
new VCarModingType[MAX_PLAYERS];
new VCarModingTypeMax[MAX_PLAYERS];
new VCarModingCompRow[MAX_PLAYERS];
new VCarModingVehicle[MAX_PLAYERS];

new
    VCarModingComponent[MAX_PLAYERS][ZVEH_MAX_COMPONENTS],
    VCarModingComponent_count[MAX_PLAYERS];

// CAR Modding Shop System 12/18/2017 03:43 AM
new PlayerText:TD_CarModing[MAX_PLAYERS];

new const Float:CarModingShopExit[10][4] = {
{195.5442,-1436.5524,12.8537,319.5366},
{197.8506,-1438.4629,12.8594,318.7462},
{200.2923,-1440.3585,12.8648,318.7568},
{202.1477,-1442.6298,12.8643,318.7457},
{204.6279,-1444.2933,12.8745,318.2960},
{209.8788,-1421.3091,13.0359,134.1930},
{212.0232,-1423.3677,13.0384,133.5355},
{213.9254,-1425.6904,13.0405,133.8086},
{216.0700,-1427.6934,13.0447,134.0883},
{218.1033,-1429.9534,13.0519,133.7612}
};

enum compPriceE
{
    compID,
    compPrice
};

new const Component[][compPriceE]={
{1000,400},
{1001,550},
{1002,200},
{1003,250},
{1004,100},
{1005,150},
{1006,80},
{1007,500},
{1008,500},
{1010,1000},
{1011,220},
{1012,250},
{1013,100},
{1014,400},
{1015,500},
{1016,200},
{1018,400},
{1019,300},
{1020,250},
{1021,200},
{1022,150},
{1023,350},
{1024,50},
{1025,1000},
{1027,480},
{1028,770},
{1029,680},
{1030,370},
{1032,170},
{1033,120},
{1034,790},
{1035,150},
{1037,690},
{1038,190},
{1039,390},
{1040,500},
{1043,500},
{1044,500},
{1045,510},
{1046,710},
{1049,810},
{1050,620},
{1051,670},
{1052,530},
{1053,130},
{1054,210},
{1055,230},
{1058,620},
{1059,720},
{1060,530},
{1061,180},
{1062,520},
{1063,430},
{1064,830},
{1065,850},
{1066,750},
{1067,250},
{1068,200},
{1071,550},
{1072,450},
{1073,1100},
{1074,1030},
{1075,980},
{1076,1560},
{1077,1620},
{1078,1200},
{1079,1030},
{1080,900},
{1081,1230},
{1082,820},
{1083,1560},
{1084,1350},
{1085,770},
{1087,1500},
{1088,150},
{1089,650},
{1091,100},
{1092,750},
{1094,450},
{1096,1000},
{1097,620},
{1098,1140},
{1099,1000},
{1100,940},
{1101,780},
{1102,830},
{1103,3250},
{1104,1610},
{1105,1540},
{1107,780},
{1109,1610},
{1110,1540},
{1113,3340},
{1114,3250},
{1115,2130},
{1116,2050},
{1117,2040},
{1120,780},
{1121,940},
{1123,860},
{1124,780},
{1125,1120},
{1126,3340},
{1127,3250},
{1128,3340},
{1129,1650},
{1130,3380},
{1131,3290},
{1132,1590},
{1135,1500},
{1136,1000},
{1137,800},
{1138,580},
{1139,470},
{1140,870},
{1141,980},
{1143,150},
{1145,100},
{1146,490},
{1147,600},
{1148,890},
{1149,1000},
{1150,1090},
{1151,840},
{1152,910},
{1153,1200},
{1154,1030},
{1155,1030},
{1156,920},
{1157,930},
{1158,550},
{1159,1050},
{1160,1050},
{1161,950},
{1162,650},
{1163,450},
{1164,550},
{1165,850},
{1166,950},
{1167,850},
{1168,950},
{1169,970},
{1170,880},
{1171,990},
{1172,900},
{1173,950},
{1174,1000},
{1175,1000},
{1176,900},
{1177,900},
{1178,2050},
{1179,2150},
{1180,2130},
{1181,2050},
{1182,2130},
{1183,2040},
{1184,2150},
{1185,2040},
{1186,2095},
{1187,2175},
{1188,2080},
{1189,2200},
{1190,1200},
{1191,1040},
{1192,940},
{1193,1100}
};

enum carmodE
{
    carmodName[16],
    Float:carmodX,
    Float:carmodY,
    Float:carmodZ
};

new const CarModingType[][carmodE] = {
	{"Spoiler",435.131134,-1294.205322,14.991717}, // 439.729034,-1301.680786,15.053193
	{"Hood",443.911743,-1300.434936,17.590143},
	{"Roof",444.050933,-1298.404785,17.270915},
	{"Side skirts",436.656738,-1301.559082,14.946612},
	{"Lamps",444.308593,-1300.461059,15.841529},
	{"Nitro",435.131134,-1294.205322,14.991717},
	{"Exhaust",437.189208,-1292.348144,14.372162},
	{"Wheels",436.504364,-1298.758300,14.665670},
	{"XM Radio",444.378692,-1297.051391,14.839973},
	{"Hydraulics",441.439239,-1301.580566,14.592674},
	{"Front Bumper",443.863677,-1300.346679,14.286822},
	{"Rear Bumper",434.656799,-1296.568725,14.443280},
	{"Right Vent",441.627014,-1302.406860,17.886425},
	{"Left Vent",444.337402,-1298.160888,17.639688},
	{"PaintJobs",444.378692,-1297.051391,14.839973},
	{"Remove",435.131134,-1294.205322,14.991717}
};

hook OnGameModeInit()
{
    //[SFCARS] ๏ฟฝ๏ฟฝาน๏ฟฝ๏ฟฝรถ๏ฟฝ๏ฟฝ๏ฟฝ Idlewood
    SetDynamicObjectMaterial(CreateDynamicObject(11317, 416.12988, -1299.62488, 24.90450,   0.00000, 0.00000, 123.35995), 0, 10789, "xenon_sfse", "ws_plasterwall2", 0xFFFFFFFF); //Texture ??????????
	CreateDynamicObject(19462, 421.42050, -1293.57239, 21.97474,   0.00000, 0.00000, -72.60002);
	CreateDynamicObject(19462, 430.51709, -1290.70166, 21.97474,   0.00000, 0.00000, -72.60002);
	CreateDynamicObject(19357, 450.58820, -1298.11621, 12.67601,   0.00000, 0.00000, 33.77999);
	CreateDynamicObject(19357, 448.95609, -1295.69141, 14.63113,   0.00000, 0.00000, 33.77999);
	CreateDynamicObject(19357, 443.07162, -1287.02332, 19.23394,   0.00000, 0.00000, 33.77999);
	CreateDynamicObject(19357, 443.09079, -1287.10095, 22.43356,   0.00000, 0.00000, 33.77999);
	CreateDynamicObject(19357, 443.09079, -1287.10095, 15.89582,   0.00000, 0.00000, 33.77999);
	CreateDynamicObject(19357, 443.09079, -1287.10095, 15.50099,   0.00000, 0.00000, 33.77999);
	CreateDynamicObject(19357, 444.88956, -1289.76648, 16.92632,   0.00000, 0.00000, 33.77999);
	CreateDynamicObject(19357, 444.88956, -1289.76648, 15.46483,   0.00000, 0.00000, 33.77999);
	CreateDynamicObject(19462, 421.42050, -1293.57239, 18.56551,   0.00000, 0.00000, -72.60002);
	CreateDynamicObject(19462, 430.51709, -1290.70166, 18.53311,   0.00000, 0.00000, -72.60002);
	CreateDynamicObject(19462, 437.84503, -1288.34534, 22.00487,   0.00000, 0.00000, -72.60002);
	CreateDynamicObject(19357, 442.09799, -1288.52881, 22.43356,   0.00000, 0.00000, 33.77999);
	CreateDynamicObject(19357, 442.14044, -1288.58716, 18.96287,   0.00000, 0.00000, 33.77999);
	CreateDynamicObject(19462, 437.80280, -1288.36023, 18.49092,   0.00000, 0.00000, -72.60002);
	CreateDynamicObject(19462, 421.54132, -1294.70044, 16.37840,   0.00000, 0.00000, -72.60002);
	CreateDynamicObject(19462, 421.54132, -1294.70044, 12.90918,   0.00000, 0.00000, -72.60002);
	CreateDynamicObject(19462, 430.39569, -1291.91968, 12.90918,   0.00000, 0.00000, -72.60002);
	CreateDynamicObject(19462, 438.31860, -1289.41589, 12.90918,   0.00000, 0.00000, -72.60002);
	CreateDynamicObject(19462, 430.39569, -1291.91968, 16.36354,   0.00000, 0.00000, -72.60002);
	CreateDynamicObject(19462, 438.31042, -1289.43420, 16.33996,   0.00000, 0.00000, -72.60002);
	CreateDynamicObject(3851, 407.60535, -1326.74475, 16.09286,   0.00000, 0.00000, -56.76001);
	CreateDynamicObject(3851, 422.44904, -1316.97778, 16.09286,   0.00000, 0.00000, -56.76001);
	CreateDynamicObject(3851, 433.47101, -1309.78931, 16.09286,   0.00000, 0.00000, -56.76001);
	CreateDynamicObject(3851, 444.40485, -1302.52600, 16.09286,   0.00000, 0.00000, -56.76001);
	CreateDynamicObject(3851, 407.60535, -1326.74475, 21.57703,   0.00000, 0.00000, -56.76001);
	CreateDynamicObject(3851, 422.44904, -1316.97778, 21.64590,   0.00000, 0.00000, -56.76001);
	CreateDynamicObject(3851, 433.47101, -1309.78931, 21.64959,   0.00000, 0.00000, -56.76001);
	CreateDynamicObject(3851, 444.40485, -1302.52600, 21.65079,   0.00000, 0.00000, -56.76001);
	CreateDynamicObject(3850, 401.20044, -1324.18896, 20.20962,   0.00000, 0.00000, -56.51998);
	CreateDynamicObject(3850, 404.11301, -1322.28210, 20.20962,   0.00000, 0.00000, -56.51998);
	CreateDynamicObject(3850, 407.02304, -1320.36963, 20.20962,   0.00000, 0.00000, -56.51998);
	CreateDynamicObject(3850, 409.98401, -1318.42578, 20.20962,   0.00000, 0.00000, -57.05999);
	CreateDynamicObject(3850, 412.92914, -1316.52490, 20.20962,   0.00000, 0.00000, -57.05999);
	CreateDynamicObject(3850, 415.86438, -1314.60352, 20.20962,   0.00000, 0.00000, -57.05999);
	CreateDynamicObject(3850, 418.80359, -1312.70166, 20.20962,   0.00000, 0.00000, -57.05999);
	CreateDynamicObject(3850, 421.75204, -1310.77820, 20.20962,   0.00000, 0.00000, -57.05999);
	CreateDynamicObject(3850, 424.71109, -1308.87134, 20.20962,   0.00000, 0.00000, -57.05999);
	CreateDynamicObject(3850, 427.63824, -1306.91394, 20.20962,   0.00000, 0.00000, -57.05999);
	CreateDynamicObject(3850, 430.59924, -1304.93481, 20.20962,   0.00000, 0.00000, -57.05999);
	CreateDynamicObject(3850, 433.55664, -1302.98840, 20.20962,   0.00000, 0.00000, -57.05999);
	CreateDynamicObject(3850, 436.54324, -1301.05054, 20.20962,   0.00000, 0.00000, -57.05999);
	CreateDynamicObject(3850, 439.50217, -1299.10669, 20.20962,   0.00000, 0.00000, -57.05999);
	CreateDynamicObject(3850, 442.45453, -1297.18103, 20.20962,   0.00000, 0.00000, -57.05999);
	CreateDynamicObject(3850, 445.37909, -1295.25049, 20.20962,   0.00000, 0.00000, -57.05999);
	CreateDynamicObject(3850, 417.98611, -1306.05859, 20.20962,   0.00000, 0.00000, -57.05999);
	CreateDynamicObject(3850, 420.85236, -1304.19507, 20.20962,   0.00000, 0.00000, -57.05999);
	CreateDynamicObject(3850, 415.11951, -1307.91040, 20.20962,   0.00000, 0.00000, -57.05999);
	CreateDynamicObject(3850, 412.71143, -1307.31116, 20.20962,   0.00000, 0.00000, -147.23996);
	CreateDynamicObject(632, 419.43201, -1295.76343, 20.12067,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(632, 419.66635, -1296.54065, 14.50196,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(632, 442.59094, -1289.66541, 14.50196,   0.00000, 0.00000, -17.94000);
	CreateDynamicObject(632, 447.98438, -1299.97791, 14.50196,   0.00000, 0.00000, -80.46000);
	CreateDynamicObject(632, 396.78268, -1317.45789, 14.50196,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(632, 404.51855, -1328.22083, 14.50196,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(632, 441.57803, -1288.85352, 20.15004,   0.00000, 0.00000, -17.94000);
	CreateDynamicObject(632, 396.70331, -1317.42822, 20.04161,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(644, 411.53738, -1306.99744, 19.89842,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1702, 407.74277, -1309.28772, 19.67182,   0.00000, 0.00000, 33.24000);
	CreateDynamicObject(1702, 397.72580, -1316.08154, 19.67182,   0.00000, 0.00000, 33.24000);
	CreateDynamicObject(2258, 402.95908, -1311.71985, 22.05025,   0.00000, 0.00000, 33.30000);
	CreateDynamicObject(2259, 404.64194, -1311.19006, 21.39433,   0.00000, 0.00000, 33.41999);
	CreateDynamicObject(2267, 403.24524, -1311.56860, 20.72342,   0.00000, 0.00000, 33.18002);
	CreateDynamicObject(2185, 437.12729, -1291.47095, 19.66992,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2356, 438.26306, -1290.06165, 19.67522,   0.00000, 0.00000, -208.20001);
	CreateDynamicObject(1721, 437.20486, -1292.99634, 19.67509,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1721, 438.41745, -1293.11157, 19.67509,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1702, 442.86938, -1291.01367, 19.67310,   0.00000, 0.00000, -55.98002);
	CreateDynamicObject(957, 440.36234, -1292.56067, 23.67186,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(957, 417.94797, -1309.06067, 23.67186,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(957, 406.41068, -1315.83081, 23.67186,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(957, 423.74521, -1298.67651, 23.67186,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(957, 422.59735, -1302.88013, 18.09679,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(957, 407.75305, -1313.68762, 18.09679,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(957, 405.27469, -1319.04822, 18.09679,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(957, 417.71591, -1308.83167, 18.09679,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(957, 422.57068, -1297.57336, 18.09679,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(957, 429.54855, -1297.83447, 18.09679,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(957, 438.78308, -1296.35596, 18.09679,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2185, 421.88138, -1297.63318, 14.09354,   0.00000, 0.00000, 32.64002);
	CreateDynamicObject(2356, 421.27774, -1296.48328, 14.09453,   0.00000, 0.00000, -113.28002);
	CreateDynamicObject(1721, 422.53140, -1298.83496, 14.09445,   0.00000, 0.00000, 34.68000);
	CreateDynamicObject(1721, 423.64764, -1298.15405, 14.09445,   0.00000, 0.00000, 34.68000);
	CreateDynamicObject(1702, 442.86938, -1291.01367, 14.08149,   0.00000, 0.00000, -55.98002);
	CreateDynamicObject(1702, 445.59134, -1295.04919, 14.08149,   0.00000, 0.00000, -55.98002);
	CreateDynamicObject(1702, 397.72580, -1316.08154, 14.06328,   0.00000, 0.00000, 33.24000);
	CreateDynamicObject(19172, 405.96399, -1309.74670, 16.41333,   0.00000, 0.00000, 33.47999);
	CreateDynamicObject(19172, 407.33710, -1308.81250, 22.38511,   0.00000, 0.00000, 33.47999);
	CreateDynamicObject(19174, 399.05588, -1324.06738, 16.09689,   0.00000, 0.00000, -236.15994);
	CreateDynamicObject(19173, 397.45566, -1321.60730, 21.72462,   0.00000, 0.00000, -56.87994);
	//

}

hook OnPlayerConnect(playerid)
{
	//[SFCARS] ร้านแต่งรถแถวๆ Idlewood
	
    RemoveBuildingForPlayer(playerid, 6359, 421.4297, -1307.9922, 24.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 394.1172, -1317.8750, 13.2344, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 395.8594, -1323.7578, 13.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 404.8359, -1303.7266, 13.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 404.9766, -1329.1016, 13.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 418.6953, -1321.5469, 13.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 6355, 421.4297, -1307.9922, 24.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 6363, 428.1016, -1348.8125, 29.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 441.8672, -1305.8438, 14.3594, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 450.2813, -1295.9688, 14.2891, 0.25);

	TD_CarModing[playerid] = CreatePlayerTextDraw(playerid, 310.400115, 288.560028, "~y~nitro ~w~(~<~) exhaust (~>~) ~y~wheels~n~~w~----------------~n~~y~price:~w~$11140~n~~y~name:~w~slamin exhaust (#1114).~n~~y~buying this will replace your current mod for this.~n~~w~press (~y~y~w~) to ~y~confirm~w~. press (~y~n~w~) to ~y~exit~w~.");
	PlayerTextDrawLetterSize(playerid, TD_CarModing[playerid], 0.411999, 1.814042);
	PlayerTextDrawTextSize(playerid, TD_CarModing[playerid], 630.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, TD_CarModing[playerid], 1);
	PlayerTextDrawColor(playerid, TD_CarModing[playerid], -1);
	PlayerTextDrawSetOutline(playerid, TD_CarModing[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, TD_CarModing[playerid], 255);
	PlayerTextDrawFont(playerid, TD_CarModing[playerid], 3);
	PlayerTextDrawSetProportional(playerid, TD_CarModing[playerid], 1);
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(VCarModingSetting{playerid}) {

        if (IsPlayerInAnyVehicle(playerid)) {

		   	new keys, ud, lr;
			GetPlayerKeys(playerid, keys, ud, lr);

			if ( newkeys & KEY_LOOK_RIGHT ) {
			    VCarModingType[playerid]+=1;
			    VCarModingCompRow[playerid]=0;
			    RenderPlayerModingMenu(playerid, VCarModingType[playerid]);
			}
			else if ( newkeys & KEY_LOOK_LEFT ) {
			    VCarModingType[playerid]-=1;
			    VCarModingCompRow[playerid]=0;
			    RenderPlayerModingMenu(playerid, VCarModingType[playerid]);
			}
			else if ( newkeys & KEY_SPRINT || keys == 8) {
			    VCarModingCompRow[playerid]--;
			    if(VCarModingCompRow[playerid] < 0) VCarModingCompRow[playerid] = 0;
			    RenderPlayerModingMenu(playerid, VCarModingType[playerid]);
			}
			else if ( newkeys & KEY_JUMP || keys == 32) {
			    VCarModingCompRow[playerid]++;
			    if(VCarModingCompRow[playerid] >= VCarModingTypeMax[playerid]) VCarModingCompRow[playerid]=VCarModingTypeMax[playerid]-1;
			    RenderPlayerModingMenu(playerid, VCarModingType[playerid]);
			}
		}
	}
	
	if(newkeys == KEY_NO)
	{
		if(VCarModingSetting{playerid}) {

	        if (IsPlayerInAnyVehicle(playerid)) {
				SetVehicleExitCarModingShop(playerid);
				return 1;
			}
		}
	}
	
	if(newkeys == KEY_YES)
	{
		if(VCarModingSetting{playerid}) {

	        if (IsPlayerInAnyVehicle(playerid)) {
				RenderPlayerModingMenu(playerid, VCarModingType[playerid], true);
				return 1;
			}
		}
	}
	
	return 1;
}

CMD:carmod(playerid)
{
	if (IsPlayerInAnyVehicle(playerid)) {
	    new vehicleid = GetPlayerVehicleID(playerid), carid = -1;
		if((carid = PlayerCar_GetID(vehicleid)) != -1)
		{
			PutPlayerModingVehicle(playerid, carid);
		} else SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: คำสั่งนี้สามารถใช้ได้เฉพาะยานพาหนะส่วนตัว แต่คุณอยู่ในยานพาหนะสาธารณะ (Static)");
	} else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่บนยานพาหนะ!");

	return 1;
}

PutPlayerModingVehicle(playerid, carid) // "EMBED_YELLOW"
{
    SendClientMessage(playerid, COLOR_WHITE, "ข้อแนะ: กดปุ่ม "EMBED_YELLOW"Q"EMBED_WHITE" และหรือ "EMBED_YELLOW"E"EMBED_WHITE" เพื่อเปลี่ยนชนิดของส่วนประกอบรถยนต์");
    SendClientMessage(playerid, COLOR_WHITE, "ข้อแนะ: กดปุ่ม "EMBED_YELLOW"LSHIFT"EMBED_WHITE" และหรือ "EMBED_YELLOW"SPACE"EMBED_WHITE" เพื่อเปลี่ยนส่วนประกอบรถยนต์");

    new Float:vXz, Float:vYz, Float:vZz, model = GetVehicleModel(playerCarData[carid][carVehicle]);

    SetPlayerVirtualWorld(playerid, playerid+1);
    SetVehicleVirtualWorld(playerCarData[carid][carVehicle], playerid+1);

    SetEngineStatus(playerCarData[carid][carVehicle], false);

	//VCarModingBiz[playerid] = id;
	VCarModingSetting{playerid} = true;
	VCarModingType[playerid]=0;
	VCarModingCompRow[playerid]=0;

	TogglePlayerControllable(playerid, 0);

	GetVehiclePos(playerCarData[carid][carVehicle],vXz,vYz,vZz);

	InterpolateCameraPos(playerid, vXz,vYz,vZz, 439.729034,-1301.680786,15.053193, 1500, 1);
	InterpolateCameraLookAt(playerid, vXz,vYz,vZz, 439.3171,-1297.0559,14.8794, 1300, 1);

	SetVehiclePos(playerCarData[carid][carVehicle], 439.3171,-1297.0559,14.8794);
	SetVehicleZAngle(playerCarData[carid][carVehicle], 234.4732);

	PutPlayerInVehicle(playerid, playerCarData[carid][carVehicle], 0);

	VCarModingVehicle[playerid] = carid;

	GetVehicleCompatibleUpgrades(model, VCarModingComponent[playerid], VCarModingComponent_count[playerid]);

	RenderPlayerModingMenu(playerid, VCarModingType[playerid]);
	return 1;
}


RenderPlayerModingMenu(playerid, &mod, bool:buy=false) {

	new string[512], preview[32], nextview[32], VehComponent[128], CarModText[128], max_type = sizeof(CarModingType), compid = 0, comp_slot;

	if(mod >= max_type) mod -= max_type;
	else if(mod < 0) mod += max_type;

	for(new i = 0; i != 14; i++)
	{
		compid = GetVehicleComponentInSlot(playerCarData[VCarModingVehicle[playerid]][carVehicle], i);
		if (compid != 0)
			RemoveVehicleComponent(playerCarData[VCarModingVehicle[playerid]][carVehicle], compid);

		switch(playerCarData[VCarModingVehicle[playerid]][carMods][i])
		{
			case 1008..1010: if(IsPlayerInInvalidNosVehicle(playerid)) {
				RemoveVehicleComponent(playerCarData[VCarModingVehicle[playerid]][carVehicle], playerCarData[VCarModingVehicle[playerid]][carMods][i]);
				playerCarData[VCarModingVehicle[playerid]][carNos] = 0;
			}
		}
		if(IsComponentidCompatible(playerCarData[VCarModingVehicle[playerid]][carModel], playerCarData[VCarModingVehicle[playerid]][carMods][i])) AddVehicleComponent(playerCarData[VCarModingVehicle[playerid]][carVehicle], playerCarData[VCarModingVehicle[playerid]][carMods][i]);
	}

	if(mod != 14) ChangeVehiclePaintjob(playerCarData[VCarModingVehicle[playerid]][carVehicle], 3 - playerCarData[VCarModingVehicle[playerid]][carPaintjob]);

	if(mod > 0) {
        format(preview, 32, "~y~%s ~w~(~<~) ", CarModingType[mod-1][carmodName]);
	}
	if(mod+1 < max_type) {
        format(nextview, 32, " (~>~) ~y~%s", CarModingType[mod+1][carmodName]);
	}

	if(mod == 8 || mod == 14 || mod == 15) {
		switch(mod) {
			case 8: { // XM Radio
				new compprice = 25000;
                VCarModingTypeMax[playerid]=1;

			    format(VehComponent, 128, "~n~~y~price:~w~%s~n~~y~name:~w~XM Radio.", FormatNumber(25000));

				if(playerCarData[VCarModingVehicle[playerid]][carXM]) {
					format(CarModText, 128, "~n~~r~you already have this.");
				}
				else {
				    //BUY
				    if(buy) {
				        if(playerData[playerid][pCash] < compprice) {
				            format(CarModText, 128, "~n~~r~you can't afford it.");
				        }
				        else {
            				playerData[playerid][pCash]-=compprice;

							playerCarData[VCarModingVehicle[playerid]][carXM]=1;
							format(CarModText, 128, "~n~~r~you already have this.");
							PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				        }
				    }
				}
			}
 			case 14: { // PaintJob

				//new vehz = VCarModingVehicle[playerid];
				new compprice=25000;
                VCarModingTypeMax[playerid]=1;

				if(playerCarData[VCarModingVehicle[playerid]][carModel] == 562 ||
				playerCarData[VCarModingVehicle[playerid]][carModel] == 565 ||
				playerCarData[VCarModingVehicle[playerid]][carModel] == 559 ||
				playerCarData[VCarModingVehicle[playerid]][carModel] == 561 ||
				playerCarData[VCarModingVehicle[playerid]][carModel] == 560 ||
				playerCarData[VCarModingVehicle[playerid]][carModel] == 575 ||
				playerCarData[VCarModingVehicle[playerid]][carModel] == 534 ||
				playerCarData[VCarModingVehicle[playerid]][carModel] == 567 ||
				playerCarData[VCarModingVehicle[playerid]][carModel] == 536 ||
				playerCarData[VCarModingVehicle[playerid]][carModel] == 535 ||
				playerCarData[VCarModingVehicle[playerid]][carModel] == 576 ||
				playerCarData[VCarModingVehicle[playerid]][carModel] == 558)
		        {
                    VCarModingTypeMax[playerid]=4;
		        }

		        new paintjobid=0;

				switch(VCarModingCompRow[playerid]) {
				    case 0: {
				        format(VehComponent, 128, "~n~~y~price:~w~none~n~~y~name:~w~Paintjob none.");
				        paintjobid=0;
				    }
				    case 1: {
				        format(VehComponent, 128, "~n~~y~price:~w~%s~n~~y~name:~w~Paintjob 1.", FormatNumber(compprice));
				        paintjobid=3;
				    }
				    case 2: {
				        format(VehComponent, 128, "~n~~y~price:~w~%s~n~~y~name:~w~Paintjob 2.", FormatNumber(compprice));
				        paintjobid=2;
				    }
				    case 3: {
				        format(VehComponent, 128, "~n~~y~price:~w~%s~n~~y~name:~w~Paintjob 3.", FormatNumber(compprice));
				        paintjobid=1;
				    }
				}
				if(playerCarData[VCarModingVehicle[playerid]][carPaintjob] == paintjobid && paintjobid != 0) {
            		format(CarModText, 128, "~n~~r~you already have this.");
				}
				else {
					if(buy) {

						if(playerData[playerid][pCash] < compprice && paintjobid != 0) {
							format(CarModText, 128, "~n~~r~you can't afford it.");
						}
						else {
						    if(paintjobid != 0) {
								playerData[playerid][pCash]-=compprice;
	                            PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
								format(CarModText, 128, "~n~~r~you already have this.");
							}
			                playerCarData[VCarModingVehicle[playerid]][carPaintjob] = paintjobid;
						}
					}
				}
				ChangeVehiclePaintjob(playerCarData[VCarModingVehicle[playerid]][carVehicle], 3 - paintjobid);
			}
 			case 15: { // Remove

                new componentID[14];
                new nextitem = VCarModingCompRow[playerid],ComponentName[ZVEH_MAX_COMPONENT_NAME];
                VCarModingTypeMax[playerid]=0;

		       	for(new x = 0; x != 14; x++) {
			    	if(playerCarData[VCarModingVehicle[playerid]][carMods][x]) {
			    	    componentID[x]=playerCarData[VCarModingVehicle[playerid]][carMods][x];
			    	    VCarModingTypeMax[playerid]++;
			    	}
				}

				if(!VCarModingTypeMax[playerid]) {
				    format(CarModText, 128, "~n~~y~nothing to remove.");
				}
				else {
					for(new x = 0; x != 14; x++) {
			            if(componentID[x]) {
							if(nextitem) {
								nextitem--;
								continue;
							}
							comp_slot = GetVehicleComponentType(componentID[x]);
							GetVehicleComponentName(componentID[x], ComponentName);
							format(VehComponent, 128, "~n~~y~name:~w~%s (#%d)", ComponentName, componentID[x]);

							if(buy) {
							    if(playerCarData[VCarModingVehicle[playerid]][carMods][x]) {
								    playerCarData[VCarModingVehicle[playerid]][carMods][x]=0;
								    RenderPlayerModingMenu(playerid, VCarModingType[playerid]);

								    return 1;
							 	}
							}
							break;
						}
					}
				}
			}
		}
	}
	else {
		new componentID[ZVEH_MAX_COMPONENTS];
		new nextitem = VCarModingCompRow[playerid], ComponentName[ZVEH_MAX_COMPONENT_NAME];
        VCarModingTypeMax[playerid]=0;

		for (new i = 0; i < VCarModingComponent_count[playerid]; i++) {
		    if(IsVehicleUpgradeCompatible(playerCarData[VCarModingVehicle[playerid]][carModel], VCarModingComponent[playerid][i]) && IsComponentidCompatible(playerCarData[VCarModingVehicle[playerid]][carModel], VCarModingComponent[playerid][i])) {
			    switch(mod) {
			        case 0: {
			            switch(VCarModingComponent[playerid][i]) {
			                case 1000..1003, 1014..1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162..1164:
							{
								componentID[i]=VCarModingComponent[playerid][i];
								VCarModingTypeMax[playerid]++;
							}
			            }
			        }
			        case 1: {
			            switch(VCarModingComponent[playerid][i]) {
			                case 1004, 1005, 1011, 1012:
							{
							    componentID[i]=VCarModingComponent[playerid][i];
							    VCarModingTypeMax[playerid]++;
							}
			            }
			        }
			        case 2: {
			            switch(VCarModingComponent[playerid][i]) {
			                case 1006,1032,1033,1035,1038,1053..1055, 1061,1067,1068,1088,1091,1103,1128,1130,1131:
							{
							    componentID[i]=VCarModingComponent[playerid][i];
							    VCarModingTypeMax[playerid]++;
							}
			            }
			        }
			        case 3: {
			            switch(VCarModingComponent[playerid][i]) {
			                case 1007,1027,1030,1031,1036,1039..1042,1047,1048,1051,1052,1056,1057,1062,1063,1069..1072,1090,1093..1095,1099,1101,1102,1106,1108,1118,1122,1124,1134,1137:
							{
							    componentID[i]=VCarModingComponent[playerid][i];
							    VCarModingTypeMax[playerid]++;
							}
			            }
			        }
					case 4: {
			            switch(VCarModingComponent[playerid][i]) {
			                case 1013,1024:
							{
							    componentID[i]=VCarModingComponent[playerid][i];
							    VCarModingTypeMax[playerid]++;
							}
			            }
			        }
					case 5: {
			            switch(VCarModingComponent[playerid][i]) {
			                case 1008,1010:
							{
							    componentID[i]=VCarModingComponent[playerid][i];
							    VCarModingTypeMax[playerid]++;
							}
			            }
			        }
					case 6: {
			            switch(VCarModingComponent[playerid][i]) {
			                case 1018,1022,1028,1029,1034,1037,1043..1046,1059,1064..1066,1089,1092,1104,1105,1113,1114,1126,1127,1129,1132,1135,1136:
							{
							    componentID[i]=VCarModingComponent[playerid][i];
							    VCarModingTypeMax[playerid]++;
							}
			            }
					}
					case 7: {
			            switch(VCarModingComponent[playerid][i]) {
			                case 1025,1073..1085,1096..1098:
							{
							    componentID[i]=VCarModingComponent[playerid][i];
							    VCarModingTypeMax[playerid]++;
							}
			            }
			        }
			        case 9: {
			            if(VCarModingComponent[playerid][i] == 1087) {
							componentID[i]=VCarModingComponent[playerid][i];
							VCarModingTypeMax[playerid]++;
			            }
			        }
			        case 10: {
			            switch(VCarModingComponent[playerid][i]) {
			                case 1117,1152,1153,1155,1157,1160,1165,1166,1169..1175,1179,1181,1182,1185,1188..1191:
							{
							    componentID[i]=VCarModingComponent[playerid][i];
							    VCarModingTypeMax[playerid]++;
							}
			            }
			        }
			        case 11: {
			            switch(VCarModingComponent[playerid][i]) {
			                case 1140,1141,1148..1151,1154,1156,1159,1161,1167,1168,1176..1178,1180,1183,1184,1186,1187,1192,1193:
							{
							    componentID[i]=VCarModingComponent[playerid][i];
							    VCarModingTypeMax[playerid]++;
							}
			            }
			        }
			        case 12: {
			            switch(VCarModingComponent[playerid][i]) {
			                case 1143, 1145:
							{
							    componentID[i]=VCarModingComponent[playerid][i];
							    VCarModingTypeMax[playerid]++;
							}
			            }
			        }
			        case 13: {
			            switch(VCarModingComponent[playerid][i]) {
			                case 1142, 1144:
							{
							    componentID[i]=VCarModingComponent[playerid][i];
							    VCarModingTypeMax[playerid]++;
							}
			            }
			        }
			    }
		    }
		}
		if(!VCarModingTypeMax[playerid]) {
		 	format(CarModText, 128, "~n~~y~There are no components compatible here.");
		}

        for (new i = 0; i < VCarModingComponent_count[playerid]; i++) {

            if(componentID[i]) {
				if(nextitem) {
					nextitem--;
					continue;
				}

				new compprice = 25000;
				for(new x=0;x<sizeof(Component);x++) {
					if(Component[x][compID] == VCarModingComponent[playerid][i]) {
						compprice += Component[x][compPrice];
					}
				}
				GetVehicleComponentName(VCarModingComponent[playerid][i], ComponentName);
				format(VehComponent, 128, "~n~~y~price:~w~%s~n~~y~name:~w~%s (#%d).", FormatNumber(compprice), ComponentName, VCarModingComponent[playerid][i]);


				if(playerCarData[VCarModingVehicle[playerid]][carMods][GetVehicleComponentType(VCarModingComponent[playerid][i])] == VCarModingComponent[playerid][i] && !IsNosComponent(VCarModingComponent[playerid][i]) || (playerCarData[VCarModingVehicle[playerid]][carNos] >= 100 && IsNosComponent(VCarModingComponent[playerid][i]))) {
					format(CarModText, 128, "~n~~r~you already have this.");
				}
				else
				{
					if(GetVehicleComponentInSlot(playerCarData[VCarModingVehicle[playerid]][carVehicle], mod)) {
						format(CarModText, 128, "~n~~y~buying this will replace your current mod for this.");
	           		}

					AddVehicleComponent(playerCarData[VCarModingVehicle[playerid]][carVehicle], VCarModingComponent[playerid][i]);

					if(buy) {
						if (IsNosComponent(VCarModingComponent[playerid][i])) {
							if (VCarModingComponent[playerid][i] == 1008) {
								compprice = 6500;
							}
							else {
								compprice = 5700;
							}
						}
						if(playerData[playerid][pCash] < compprice) {
						   	format(CarModText, 128, "~n~~r~you can't afford it.");
						}
						else {
							if (IsNosComponent(VCarModingComponent[playerid][i])) {
								if (VCarModingComponent[playerid][i] == 1008) {
									format(CarModText, 128, "~n~~y~half nitro purchased.");
									playerCarData[VCarModingVehicle[playerid]][carNos] += 50;
									if(playerCarData[VCarModingVehicle[playerid]][carNos] > 100) playerCarData[VCarModingVehicle[playerid]][carNos] = 100;
								}
								else {
									format(CarModText, 128, "~n~~y~full nitro purchased.");
									playerCarData[VCarModingVehicle[playerid]][carNos] += 100;
									if(playerCarData[VCarModingVehicle[playerid]][carNos] > 100) playerCarData[VCarModingVehicle[playerid]][carNos] = 100;
								}
							}
							else {
								playerCarData[VCarModingVehicle[playerid]][carMods][GetVehicleComponentType(VCarModingComponent[playerid][i])]=VCarModingComponent[playerid][i];
								format(CarModText, 128, "~n~~r~you already have this.");
							}

							playerData[playerid][pCash]-=compprice;
						 	PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						}
					}
				}
				break;
			}
		}

	}

	new Float:vX, Float:vY, Float:vZ;
	GetPlayerPos(playerid,vX,vY,vZ);
	if(comp_slot) SetPlayerCameraPos(playerid, CarModingType[comp_slot][carmodX],CarModingType[comp_slot][carmodY],CarModingType[comp_slot][carmodZ]);
	else SetPlayerCameraPos(playerid, CarModingType[mod][carmodX],CarModingType[mod][carmodY],CarModingType[mod][carmodZ]);
	SetPlayerCameraLookAt(playerid, vX,vY,vZ);

	format(string, 512, "%s~w~%s%s~n~~w~----------------%s%s~n~~w~press (~y~y~w~) to ~y~confirm~w~. press (~y~n~w~) to_~y~exit~w~.", preview, CarModingType[mod][carmodName], nextview, VehComponent, CarModText);
	PlayerTextDrawSetString(playerid, TD_CarModing[playerid], string);
	PlayerTextDrawShow(playerid, TD_CarModing[playerid]);
	return 1;
}

IsNosComponent(comid) {
	return (comid == 1008 || comid == 1010);
}

SetVehicleExitCarModingShop(playerid) {
	new compid;
	for(new i = 0; i != 14; i++)
	{
		compid = GetVehicleComponentInSlot(playerCarData[VCarModingVehicle[playerid]][carVehicle], i);
		if (compid != 0)
			RemoveVehicleComponent(playerCarData[VCarModingVehicle[playerid]][carVehicle], compid);

	    if(playerCarData[VCarModingVehicle[playerid]][carMods][i]) {
		    switch(playerCarData[VCarModingVehicle[playerid]][carMods][i])
			{
			    case 1008..1010: if(IsPlayerInInvalidNosVehicle(playerid)) RemoveVehicleComponent(playerCarData[VCarModingVehicle[playerid]][carVehicle], playerCarData[VCarModingVehicle[playerid]][carMods][i]);
			}
			if(IsComponentidCompatible(playerCarData[VCarModingVehicle[playerid]][carModel], playerCarData[VCarModingVehicle[playerid]][carMods][i])) AddVehicleComponent(playerCarData[VCarModingVehicle[playerid]][carVehicle], playerCarData[VCarModingVehicle[playerid]][carMods][i]);
		}
	}

	//ChangeVehiclePaintjob(playerCarData[VCarModingVehicle[playerid]][carVehicle], 3 - playerCarData[VCarModingVehicle[playerid]][carPaintjob]);

    SetPlayerVirtualWorld(playerid, 0);
    SetVehicleVirtualWorld(playerCarData[VCarModingVehicle[playerid]][carVehicle], 0);
    TogglePlayerControllable(playerid, 1);
    SetCameraBehindPlayer(playerid);

	new rd = random(sizeof(CarModingShopExit));
	SetVehiclePos(playerCarData[VCarModingVehicle[playerid]][carVehicle], CarModingShopExit[rd][0],CarModingShopExit[rd][1],CarModingShopExit[rd][2]);
	SetVehicleZAngle(playerCarData[VCarModingVehicle[playerid]][carVehicle], CarModingShopExit[rd][3]);
    ChangeVehiclePaintjob(playerCarData[VCarModingVehicle[playerid]][carVehicle], 3 - playerCarData[VCarModingVehicle[playerid]][carPaintjob]);
	PutPlayerInVehicle(playerid, playerCarData[VCarModingVehicle[playerid]][carVehicle], 0);
	//Car_SaveID(VCarModingVehicle[playerid]);

	VCarModingSetting{playerid} = false;
	VCarModingBiz[playerid]=-1;
	VCarModingType[playerid]=0;
	VCarModingTypeMax[playerid]=0;
	VCarModingCompRow[playerid]=0;
	VCarModingVehicle[playerid]=-1;


	VCarModingComponent[playerid][0]='\0';
	VCarModingComponent_count[playerid]=0;

	PlayerTextDrawHide(playerid, TD_CarModing[playerid]);
	return 1;
}
