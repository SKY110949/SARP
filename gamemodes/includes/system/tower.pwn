//--------------------------------[TOWER.PWN]--------------------------------
#include <YSI\y_hooks>

enum E_RADIOTOWER_DATA {
	RadioName[64 char],
	Float:RadioX,
	Float:RadioY,
	Float:RadioZ,
	Float:RadioRange
};

stock const RadioTower[59][E_RADIOTOWER_DATA] = {
	{!"Ocean Docks Tower", 2836.939941, -2577.139892, -16.810800, 500.000000},
	{!"Airport Tower", 2130.580078, -2264.649902, 14.782899, 500.000000},
	{!"Verdant Bluffs Tower", 1626.380004, -2018.189941, 29.945100, 500.000000},
	{!"Verdant Bluffs Tower 2", 986.421020, -2193.270019, 13.085900, 500.000000},
	{!"Rodeo Tower", 267.686004, -1605.050048, 33.298099, 500.000000},
	{!"Stage 25 Tower", 462.997985, -1500.729980, 42.573101, 500.000000},
	{!"Mall Tower", 1063.020019, -1563.920043, 13.546799, 500.000000},
	{!"Main Street Tower", 1365.489990, -1838.180053, 13.581299, 500.000000},
	{!"Glen Park Tower", 1881.930053, -1168.979980, 23.900800, 500.000000},
	{!"Downtown Tower", 1817.010009, -1219.920043, 23.828100, 500.000000},
	{!"Downtown Tower 2", 1493.520019, -1317.209960, 23.617099, 500.000000},
	{!"Downtown Tower 3", 1692.180053, -1414.670043, 84.994102, 500.000000},
	{!"County General Tower", 2057.729980, -1394.229980, 23.879400, 500.000000},
	{!"Willowfield Tower ", 2484.310058, -1917.040039, 25.549999, 500.000000},
	{!"Jefferson Motel Tower", 2262.379882, -1106.510009, 37.976501, 500.000000},
	{!"Los Flores Tower", 2711.320068, -1337.910034, 70.989799, 500.000000},
	{!"East Beach Tower", 2864.659912, -1412.180053, 45.214500, 500.000000},
	{!"North Rock Tower", 2607.669921, -658.961975, 132.779006, 450.000000},
	{!"LS/LV Highway Tower", 1807.540039, -418.557006, 84.549598, 550.000000},
	{!"Dillimore Tower", 596.056030, -482.928985, 16.483800, 500.000000},
	{!"Vinewood Tower 2", 914.443969, -1021.950012, 111.055000, 500.000000},
	{!"Vinewood Tower", 1460.239990, -784.158996, 97.815299, 500.000000},
	{!"Blueberry Factory Tower", -53.004299, -248.141998, 32.839698, 750.000000},
	{!"Montgomery South Tower", 1074.170043, 272.532989, 26.881200, 550.000000},
	{!"Montgomery North Tower", 1665.239990, 398.843994, 20.200599, 500.000000},
	{!"Palomino Creek Tower", 2603.790039, 205.462005, 58.100299, 500.000000},
	{!"Ramiro Cruz Tower", 2765.889892, 181.158004, 21.707399, 500.000000},
	{!"Red County Tower", 2607.679931, 657.258972, 10.820300, 500.000000},
	{!"SF Missionairy Hill Tower", -2540.850097, -719.270019, 139.320007, 1000.000000},
	{!"San Fierro Airport Tower", -1443.349975, -974.934997, 199.664001, 550.000000},
	{!"Flint Range Tower", -603.653015, -1791.569946, 97.113601, 500.000000},
	{!"Black O Beyond Tower 3", -227.337997, -2167.770019, 29.213899, 500.000000},
	{!"Black O Beyond Tower 1", -372.263000, -2394.699951, 95.280197, 500.000000},
	{!"Black O Beyond Tower 2", -496.996002, -2730.510009, 151.759002, 500.000000},
	{!"Angel West Tower", -1387.520019, -2815.479980, 61.776000, 500.000000},
	{!"Angel East Tower", -2236.270019, -2746.639892, 37.241699, 500.000000},
	{!"Angel North Tower", -1968.869995, -2206.370117, 67.393699, 500.000000},
	{!"San Fierro DMV Tower", -2193.820068, -7.007100, 63.595100, 500.000000},
	{!"San Fierro Midtown Tower 2", -1760.170043, 774.651000, 167.656005, 500.000000},
	{!"San Fierro Midtown Tower 1", -2558.530029, 517.166015, 47.781200, 500.000000},
	{!"San Fierro Hospital Tower", -2740.389892, 553.276977, 14.559599, 750.000000},
	{!"San Fierro Golden Gate Tower", -2708.169921, 1466.739990, 7.156499, 750.000000},
	{!"Bayside Tower", -2299.360107, 2633.639892, 54.885799, 500.000000},
	{!"Las Barrancas Tower", -699.625000, 1528.060058, 81.991897, 500.000000},
	{!"Big Ear Tower", -225.533996, 1397.900024, 69.936500, 750.000000},
	{!"SACF East Tower", 576.575988, 2090.179931, 43.848899, 500.000000},
	{!"SACF South Tower", 123.230003, 1607.819946, 31.933300, 500.000000},
	{!"Las Venturas North Tower 1", 1208.560058, 2978.370117, 24.960800, 550.000000},
	{!"Las Venturas North Tower 3", 2174.760009, 2960.070068, 24.241100, 550.000000},
	{!"Las Venturas North Tower 2", 2971.760009, 2708.479980, 24.148399, 550.000000},
	{!"Las Venturas Midtown Tower 1", 2462.719970, 2282.689941, 91.629997, 500.000000},
	{!"Las Venturas Visage Tower", 2030.810058, 2063.419921, 16.837400, 500.000000},
	{!"Las Venturas Midtown Tower 2", 2443.550048, 1599.369995, 10.820300, 750.000000},
	{!"Las Venturas Midtown Tower 3", 2487.050048, 1031.109985, 57.501598, 500.000000},
	{!"Las Venturas Midtown Tower 4", 1913.869995, 1161.449951, 18.085899, 500.000000},
	{!"Las Venturas South Tower", 1257.400024, 709.361999, 10.497300, 500.000000},
	{!"Las Venturas West Tower", 831.752990, 1407.260009, 31.932600, 500.000000},
	{!"Las Venturas Airport Tower", 1568.040039, 1892.680053, 10.820300, 500.000000},
	{!"Las Venturas Julius Thruway North", 1796.589965, 2444.709960, 10.854299, 550.000000}
};

GetPlayerClosestRadioTower(playerid, &Float:fDistance = FLOAT_INFINITY)
{
	new
	    iIndex = -1
	;
	for (new i = 0; i < sizeof(RadioTower); i ++)
	{
		new
      		Float:temp = FLOAT_NAN, Float:playerPosX, Float:playerPosY, Float:playerPosZ;
      	
		GetDynamicPlayerPos(playerid, playerPosX, playerPosY, playerPosZ);
		
	    temp = GetPointDistanceToPoint(playerPosX, playerPosY, RadioTower[i][RadioX], RadioTower[i][RadioY]);

		if (temp < fDistance && RadioTower[i][RadioRange] >= temp)
		{
		    fDistance = temp;
		    iIndex = i;
		}
	}
	return iIndex;
}

GetPlayerRadioSignal(playerid, &radioID = -1)
{
	new signal, Float:dist = FLOAT_NAN;
	
	radioID = GetPlayerClosestRadioTower(playerid, dist);
	
	if(radioID == -1) signal = 0;
	else signal = floatround((((RadioTower[radioID][RadioRange] - dist) / RadioTower[radioID][RadioRange]) * 10.0) / 2.0, floatround_ceil);
	return signal;
}