#include <YSI\y_timers>
#include <YSI\y_hooks>
#include <YSI\y_ini>

#define PATH "/Industry/industry_%d.ini"

// Ship 
#define NUM_SHIP_ATTACHMENTS 9
#define NUM_SHIP_ROUTE_POINTS 8
#define SPEED_CARGOSHIP  20

new gShipAttachmentModelIds[NUM_SHIP_ATTACHMENTS] = {
5166,
5167,
5156,
5157,
5165,
3724,
5154,
3724,
5155
};

new const Float:gShipAttachmentPos[NUM_SHIP_ATTACHMENTS][6] = {
{0.000000,0.000000,0.000000,0.000000,0.000000,0.000000},
{-107.499977,8.080001,2.000000,0.000000,0.000000,0.000000},
{-55.660057,8.040000,5.699993,0.000000,0.000000,0.049999},
{53.039920,8.200004,11.849996,0.000000,0.000000,0.000000},
{0.000000,0.000000,0.000000,0.000000,0.000000,0.000000},
{5.000000,10.000000,24.000000,0.000000,0.000000,-180.000000},
{-32.000000,8.000000,10.000000,0.000000,0.000000,0.000000},
{-74.000000,8.560012,24.000000,0.000000,0.000000,0.000000},
{-126.000000,8.000000,15.000000,0.000000,0.000000,0.000000}
};

new const Float:gShipRoutePoints[NUM_SHIP_ROUTE_POINTS][6] = {
{2829.915283, -2482.376464, 3.769994, 0.000000,   0.000000, -90.000000},
{2829.915283, -2843.347167, 3.769994, 0.000000, 0.000000, -90.000000},
{3248.907226, -2978.197998, 3.769994, 0.000000, 0.000000, -9.799991},
{3283.973876, -3070.623535, 3.769994, 0.000000, 0.000000, -9.799991},
{3356.869140, -2824.702880, 3.769994, 0.000000, 0.000000, 3.400008},
{3306.186035, -2767.182373, 3.769994, 0.000000, 0.000000, 105.200027},
{3529.560546, -2100.971435, 3.769994, 0.000000, 0.000000, 168.300140},
{2994.928222, -2480.779541, 4.028370, 0.000000, 0.000000, -90.000000}
};

new gMainShipObjectId;
new gShipDeparture;
new gShipRamp1, gShipRamp2;
new gShipTextLine1;
new gShipTextLine2;
new gShipTextLine3;

new gShipsAttachments[NUM_SHIP_ATTACHMENTS];
new gShipCurrentPoint = 1; // current route point the ship is at. We start at route 1

static gShipTime;
//===================================================================

#define MAX_INDUSTRY            			31
#define MAX_INDUSTRY_ITEM       			26
#define MAX_INDUSTRY_STORAGE    			69

#define	TRUCKING_PACKAGE_TYPE_CRATE			0
#define	TRUCKING_PACKAGE_TYPE_LIQUID		2
#define	TRUCKING_PACKAGE_TYPE_LOOSE			3
#define	TRUCKING_PACKAGE_TYPE_STRONGBOX		7

enum 
{
    INDUSTRY_PRIMARY,
    INDUSTRY_SECONDARY,
    INDUSTRY_SPECIAL
}

new const g_arrIndustryNames[][] = {
	"The Ship", "Green Palms Refinery", "Easter Bay Chemicals", "San Andreas Federal Mint", "Whetstone Scrap Yard", "The Panopticon Forest - West", "The Panopticon Forest - East",
	"The Impounder's Farm", "The Farm On a Rock", "The Flint Range Farm", "The Beacon Hill Eggs", "EasterBoard Farm", "The Palomino Farm", "The Leafy Hollow Orchards", "The Hilltop Farm",
	"Fort Carson Quarry", "San Andreas Federal Weapon Factory", "San Andreas Steel Mill", "Angel Pine Sawmill", "Doherty Textile Factory", "FleischBerg Brewery", "SA Food Processing Plant",
	"Ocean Docks Concrete Plant", "Fort Carson Distillery", "Las Payasdas Malt House", "Shafted Appliances", "Solarin Autos", "Rockshore Construction Site", "Doherty Construction Site",
	"Bone County Substation", "Sherman Dam Powerplant"
};

new const g_arrItemNames[MAX_INDUSTRY_ITEM][] = {
	"สีย้อม","ดินปืน","เงินตรา","เศษโลหะ","ไม้ซุง","ฝ้าย","นม","เครื่องดื่ม","เนื้อ","เมล็ดธัญพืช","ไข่","เครื่องใช้ไฟฟ้า","เสื้อผ้า",
	"เชื้อเพลิง","เฟอร์นิเจอร์","ผลไม้","หม้อแปลงไฟฟ้า","ยานพาหนะ", "เศษหิน", "อาวุธ", "รูปทรงเหล็ก","กระดาษ", "อิฐ", "ชิ้นส่วนรถยนต์", "อาหาร", "ข้าวมอลต์"
};

Trucking_Unit(type)
{
	new name[16];
	switch(type)
	{
		case 1: format(name, 16, "พาเลท"); // pallet
		case 2: format(name, 16, "ลูกบาศก์เมตร"); // cubic meter
		case 3: format(name, 16, "ตัน"); // tons
		case 4: format(name, 16, "ยานพาหนะ"); // vehicles
		case 5: format(name, 16, "หม้อแปลง"); // transformer
		case 6: format(name, 16, "ท่อน"); // wood logs
	    case 7: format(name, 16, "ลังเหล็ก"); // strong crates
	    default: format(name, 16, "ลัง"); // crates
	}
	return name;
}
/*
    0 - crates: gunpowder, steel shapes, clothes, wood planks, beverages, meal, car parts, appliances, fruits, meat, eggs
    1 - brick pallets: (1 pallet = 6 slots);
    2 - liquids: fuel, milk, dyes (1 slot = 1 m?)
    3 - loose: scrap metal, cotton, cereal, malt, aggregate (1 slot = 1 ton)
    4 - vehicles (1 slot = 1 vehicles)
    5 - transformer (18 slot = 1 transformer)
    6 - wood (18 slot = 1 wood logs)
    7 - strongboxes
*/

new const g_arrItemPackageType[MAX_INDUSTRY_ITEM] = {
    2,0,0,3,0,3,2,0,0,3,0,0,0,2,0,0,0,0,3,0,0,0,1,0,0,3
};

enum E_INDUSTRY_DATA
{
	bool:industryStatus,
	industryType // - 0 - Primary, 1 - Secondary, 2 - Special
}
new industryData[MAX_INDUSTRY][E_INDUSTRY_DATA];

enum E_INDUSTRY_STORAGE_DATA
{
	Float:industryPosX,
	Float:industryPosY,
	Float:industryPosZ,
	industryID,
    industryItem,
	industryTradingType, // - 0 for sale, 1 wanted
	industryPrice,
	industryConsumption,
	industryStock,
	industryMaximum,

	STREAMER_TAG_3D_TEXT_LABEL:industryLabel,
	industryPickup

};

new industryStorageData[MAX_INDUSTRY_STORAGE][E_INDUSTRY_STORAGE_DATA];

enum E_INDUSTRY_TRUCKING_DATA {
	truckingCrate[MAX_INDUSTRY_ITEM],
	truckingLoading,
	truckingCargo,
	Timer:truckingTimer,
};

new gVehicleTrucking[MAX_VEHICLES][E_INDUSTRY_TRUCKING_DATA];

new playerCarryCrate[MAX_PLAYERS];
new playerPicking[MAX_PLAYERS char];
new Float:TruckerMissionX[MAX_PLAYERS], Float:TruckerMissionY[MAX_PLAYERS], Float:TruckerMissionZ[MAX_PLAYERS];

IndustryPath(id)
{
    new str[80];
    format(str, 80, PATH, id);
    return str;
}

hook OnPlayerConnect(playerid) {
	playerCarryCrate[playerid] = -1;
	playerPicking{playerid} = false;

	TruckerMissionX[playerid] = 0.0;
	TruckerMissionY[playerid] = 0.0;
	TruckerMissionZ[playerid] = 0.0;

	//Cargo Ship
	RemoveBuildingForPlayer(playerid, 5156, 2838.0391, -2423.8828, 10.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 5159, 2838.0313, -2371.9531, 7.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 5160, 2829.9531, -2479.5703, 5.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 5161, 2838.0234, -2358.4766, 21.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 5162, 2838.0391, -2423.8828, 10.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 5163, 2838.0391, -2532.7734, 17.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 5164, 2838.1406, -2447.8438, 15.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 5165, 2838.0313, -2520.1875, 18.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 5166, 2829.9531, -2479.5703, 5.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 5167, 2838.0313, -2371.9531, 7.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 5335, 2829.9531, -2479.5703, 5.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 5336, 2829.9531, -2479.5703, 5.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 5352, 2838.1953, -2488.6641, 29.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 5157, 2838.0391, -2532.7734, 17.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 5154, 2838.1406, -2447.8438, 15.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 3724, 2838.1953, -2488.6641, 29.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 5155, 2838.0234, -2358.4766, 21.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 3724, 2838.1953, -2407.1406, 29.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 5158, 2837.7734, -2334.4766, 11.9922, 0.25);

	return 1;
}

hook OnGameModeInit()
{
	// Cargo Ship Ocean Docks

	CreateDynamicObject(3574, 2766.07422, -2343.62280, 15.32000,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(3574, 2784.20313, -2339.03198, 15.32000,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(3574, 2777.94604, -2353.44263, 15.32000,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(3620, 2811.82642, -2337.77661, 25.60000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3573, 2767.30200, -2361.99194, 15.32000,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(8168, 2778.80908, -2365.26611, 14.47350,   0.00000, 0.00000, 16.60000);

	CreateDynamicObject(997, 2810.6557, -2333.0559, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2336.4272, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2339.8183, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2343.2580, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2346.5666, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2349.9460, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2353.2963, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2356.7460, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2360.1179, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2363.5085, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2366.9194, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2370.2993, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2373.6801, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2377.1003, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2380.5322, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2383.9028, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2393.7619, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2397.1435, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2400.4636, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2403.7536, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2407.0339, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2410.3041, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2413.6250, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2416.9355, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2420.2348, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2423.5439, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2426.8264, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2430.1384, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2433.5578, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2443.5703, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2446.9309, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2450.2619, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2453.5625, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2456.8833, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2460.2421, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2463.6833, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2467.0842, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2470.5249, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2477.3752, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2473.9455, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2480.8051, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2484.5053, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2488.1062, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2491.5168, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2495.0566, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2498.5961, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2502.1064, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2505.7080, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2509.2277, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2512.8386, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2516.4602, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2519.9389, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2523.4487, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2526.9499, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2530.5593, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2534.0993, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2537.7204, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2541.3017, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2544.9025, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2548.4328, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2551.8347, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2555.3164, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2558.6860, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2562.0368, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3
	CreateDynamicObject(997, 2810.6557, -2565.3854, 12.6369, 0.0000, 0.0000, 90.0000); //lhouse_barrier3

	CreateDynamicObject(1215, 2810.5329, -2384.1938, 13.1770, 0.0000, 0.0000, 0.0000); //BollardLight3
	CreateDynamicObject(1215, 2810.5329, -2386.2158, 13.1770, 0.0000, 0.0000, 0.0000); //BollardLight3
	CreateDynamicObject(1215, 2810.5329, -2388.1938, 13.1770, 0.0000, 0.0000, 0.0000); //BollardLight3
	CreateDynamicObject(1215, 2810.5329, -2390.2158, 13.1770, 0.0000, 0.0000, 0.0000); //BollardLight3

	CreateDynamicObject(1215, 2810.5329, -2433.9448, 13.1770, 0.0000, 0.0000, 0.0000); //BollardLight3
	CreateDynamicObject(1215, 2810.5329, -2435.9565, 13.1770, 0.0000, 0.0000, 0.0000); //BollardLight3
	CreateDynamicObject(1215, 2810.5329, -2437.9448, 13.1770, 0.0000, 0.0000, 0.0000); //BollardLight3
	CreateDynamicObject(1215, 2810.5329, -2439.9565, 13.1770, 0.0000, 0.0000, 0.0000); //BollardLight3
	CreateDynamicObject(19279, 2808.5371, -2392.8281, 12.8371, 0.0000, 0.0000, -90.0000); //LCSmallLight1

	for(new i=0;i!=MAX_INDUSTRY;i++)
	{
		if(i > 26) industryData[i][industryType] = INDUSTRY_SPECIAL;
		else if(i > 15) industryData[i][industryType] = INDUSTRY_SECONDARY;
		else industryData[i][industryType] = INDUSTRY_PRIMARY;
		industryData[i][industryStatus] = true;
	}

    new string[128];
    for(new i=0;i!=MAX_INDUSTRY_STORAGE;i++)
	{
        if(fexist(IndustryPath(i))) {
            INI_ParseFile(IndustryPath(i), "LoadIndustry_%s", .bExtra = true, .extra = i);

            industryStorageData[i][industryPickup] = CreateDynamicPickup(1318, 23, industryStorageData[i][industryPosX],industryStorageData[i][industryPosY], industryStorageData[i][industryPosZ], 0, 0);
            format(string, 128, "["EMBED_LIMEGREEN"%s"EMBED_WHITE"]\nความจุโกดัง: %d / %d\nราคา: %s / หน่วย", g_arrItemNames[industryStorageData[i][industryItem]], industryStorageData[i][industryStock], industryStorageData[i][industryMaximum], FormatNumber(industryStorageData[i][industryPrice]));
            industryStorageData[i][industryLabel] = CreateDynamic3DTextLabel(string, -1, industryStorageData[i][industryPosX],industryStorageData[i][industryPosY], industryStorageData[i][industryPosZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 100.0);
        }
        else {
            printf("Warning: Industry %d was not found.", i);
        }
	}

	gShipTime = gettime();

	gMainShipObjectId = CreateObject(5160, gShipRoutePoints[0][0], gShipRoutePoints[0][1], gShipRoutePoints[0][2], gShipRoutePoints[0][3], gShipRoutePoints[0][4], gShipRoutePoints[0][5]);

	gShipRamp1 = CreateDynamicObject(3069, 2810.9445, -2387.2998, 12.6255, -20.4000, 0.0000, -90.3000); //d9_ramp
	gShipRamp2 = CreateDynamicObject(3069, 2810.6875, -2436.9775, 12.6250, -20.4000, 0.0000, -90.3000); //d9_ramp

	new x=0;
	while(x != NUM_SHIP_ATTACHMENTS) {
	    gShipsAttachments[x] = CreateObject(gShipAttachmentModelIds[x], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
		AttachObjectToObject(gShipsAttachments[x], gMainShipObjectId,
					gShipAttachmentPos[x][0],
					gShipAttachmentPos[x][1],
					gShipAttachmentPos[x][2],
					gShipAttachmentPos[x][3],
					gShipAttachmentPos[x][4],
					gShipAttachmentPos[x][5]);
		x++;
	}

	CreateDynamicObject(3077, 2809.9897, -2392.7746, 12.6257, 0.0000, 0.0000, 90.3998);

	gShipTextLine1 = CreateDynamicObject(19482, 2809.9184, -2392.7329, 15.2910, 0.0000, 0.0000, 180.0000);
    SetDynamicObjectMaterialText(gShipTextLine1, 0, "OCEAN DOCKS SHIP", OBJECT_MATERIAL_SIZE_256x256, "Arial", 16, 1, 0xFFFFFFFF, 0, 1);

 	new gShipHour, gShipMinute, gShipSecond, ShipString[24];
    TimestampToTime(gShipTime + 2440, gShipHour, gShipMinute, gShipSecond);
	
	gShipTextLine2 = CreateDynamicObject(19482, 2809.9284, -2392.7329, 14.6810, 0.0000, 0.0000, 180.0000);
	format(ShipString, sizeof(ShipString), "ออกเดินทาง: %02d:%02d:%02d", gShipHour, gShipMinute, gShipSecond);
	SetDynamicObjectMaterialText(gShipTextLine2, 0, ShipString, OBJECT_MATERIAL_SIZE_256x256, "Arial", 16, 1, 0xFFFFFFFF, 0, 1);

    TimestampToTime(gShipTime + 2740, gShipHour, gShipMinute, gShipSecond);
	gShipTextLine3 = CreateDynamicObject(19482, 2809.9184, -2392.7329, 14.2610, 0.0000, 0.0000, 180.0000);
	format(ShipString, sizeof(ShipString), "กลับมาเทียบท่า: %02d:%02d:%02d", gShipHour, gShipMinute, gShipSecond);
	SetDynamicObjectMaterialText(gShipTextLine3, 0, ShipString, OBJECT_MATERIAL_SIZE_256x256, "Arial", 16, 1, 0xFFFFFFFF, 0, 1);
}

forward LoadIndustry_Data(index, name[], value[]);
public LoadIndustry_Data(index, name[], value[])
{

    INI_Float("PosX", industryStorageData[index][industryPosX]);
    INI_Float("PosY", industryStorageData[index][industryPosY]);
    INI_Float("PosZ", industryStorageData[index][industryPosZ]);

    INI_Int("Name", industryStorageData[index][industryID]);
    INI_Int("Item", industryStorageData[index][industryItem]);
    INI_Int("TradingType", industryStorageData[index][industryTradingType]);
    INI_Int("Price", industryStorageData[index][industryPrice]);
    INI_Int("Consumption", industryStorageData[index][industryConsumption]);
    INI_Int("Stock", industryStorageData[index][industryStock]);
    INI_Int("Maximum", industryStorageData[index][industryMaximum]);
    return 1;
}

Trucking_UpdateIndustry(index) {
	if (industryData[industryStorageData[index][industryID]][industryStatus]) {
		new string[128];
		format(string, 128, "["EMBED_LIMEGREEN"%s"EMBED_WHITE"]\nความจุโกดัง: %d / %d\nราคา: %s / หน่วย", g_arrItemNames[industryStorageData[index][industryItem]], industryStorageData[index][industryStock], industryStorageData[index][industryMaximum], FormatNumber(industryStorageData[index][industryPrice]));
		UpdateDynamic3DTextLabelText(industryStorageData[index][industryLabel], -1, string);
		SaveIndustry(index);
	}
}

SaveIndustry(index)
{
    new INI:File = INI_Open(IndustryPath(index));
    INI_SetTag(File,"Data");

    INI_WriteInt(File,"Stock", industryStorageData[index][industryStock]);

    INI_Close(File);
    return 1;
}

Trucking_VehicleCarry(vehicleid, itemType)
{
    if(IsTrailerAttachedToVehicle(vehicleid))
        vehicleid = GetVehicleTrailer(vehicleid);

    new model = GetVehicleModel(vehicleid);

    switch(itemType) {
        case 0: { // crates
            switch(model) {
                case 435, 591, 456, 499, 414, 554, 498, 440, 482, 459, 413, 478, 422, 543, 605, 600, 530: return true;
            }
        }
        case 1: { // brick pallet
            switch(model) {
                case 435, 591, 456, 499, 414, 554: return true;
            }
        }
        case 2: { // liquids
            switch(model) {
                case 584: return true;
            }
        }
        case 3: { // looses
            switch(model) {
                case 450, 455: return true;
            }
        }
        case 4: { // vehicles
            switch(model) {
                case 443: return true;
            }
        }
        case 5: { // transformer
            switch(model) {
                case 578: return true;
            }
        }
        case 6: { // wood
            switch(model) {
                case 578: return true;
            }
        }
        case 7: { // strongboxes
            switch(model) {
                case 428: return true;
            }
        }
    }
	return false;
}

Trucking_VehicleSlot(model)
{
	switch(model)
	{
		case 600, 543, 605, 443: return 2;
		case 422, 530: return 3;
		case 478: return 4;
		case 554: return 6;
		case 413, 459, 482: return 10;
		case 440, 498: return 12;
		case 499, 428, 455: return 16;
		case 414, 578: return 18;
		case 456: return 24;
		case 435, 591: return 36;
		case 450: return 30;
		case 584: return 40;
	}
	return 0;
}

Trucking_VehicleSkill(model)
{
	switch(model)
	{
	    case 413, 459, 482: return 1;
	    case 440, 498: return 2;
	    case 499, 414, 578, 443, 428: return 3;
	    case 456, 455: return 4;
	    case 403: return 5;
	}
	return 0;
}

Industry_Nearest(playerid, Float:radius = 5.0)
{
    for(new i=0;i!=MAX_INDUSTRY_STORAGE;i++) if (IsPlayerInRangeOfPoint(playerid, radius, industryStorageData[i][industryPosX], industryStorageData[i][industryPosY], industryStorageData[i][industryPosZ]))
	{
		return i;
	}
	return -1;
}

CMD:trailer(playerid, params[])
{
	new option[8];

	if (sscanf(params, "s[8]", option))
	{
	    SendClientMessage(playerid, COLOR_GRAD2, "คำสั่งที่ใช้งานได้:");
	    SendClientMessage(playerid, -1, ""EMBED_YELLOW"/trailer lock "EMBED_WHITE"- ล็อก/ปลดล็อก รถพ่วงที่ติดอยู่กับยานพาหนะของคุณ");
	    SendClientMessage(playerid, -1, ""EMBED_YELLOW"/trailer detach "EMBED_WHITE"- ถอดรถพ่วงออกจากยานพาหนะของคุณ");
        SendClientMessage(playerid, -1, ""EMBED_YELLOW"/trailer lights "EMBED_WHITE"- เปิด/ปิด หลอดไฟของรถพ่วง");
        SendClientMessage(playerid, -1, ""EMBED_YELLOW"/trailer cargo "EMBED_WHITE"- แสดงอะไรก็ตามที่บรรจุอยู่ในรถพ่วง");
        return 1;
	}

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่คนขับ");

	new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsTrailerAttachedToVehicle(vehicleid))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่บนยานพาหนะที่มีรถพ่วงติดอยู่");

  	new trailerid = GetVehicleTrailer(vehicleid);

	if(isequal(option, "lock", true))
	{
	    new statusString[90]; 

     	new engine, lights, alarm, doors, bonnet, boot, objective;
     	GetVehicleParamsEx(trailerid, engine, lights, alarm, doors, bonnet, boot, objective);
     	
     	if(boot != VEHICLE_PARAMS_ON) {
			SetVehicleParamsEx(trailerid, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_ON, objective);
			format(statusString, sizeof(statusString), "~g~%s UNLOCKED", g_arrVehicleNames[GetVehicleModel(trailerid) - 400]);
			GameTextForPlayer(playerid, statusString, 2000, 4);
		}
		else {
			format(statusString, sizeof(statusString), "~r~%s LOCKED", g_arrVehicleNames[GetVehicleModel(trailerid) - 400]);
		    GameTextForPlayer(playerid, statusString, 2000, 4);
		}
		GameTextForPlayer(playerid, statusString, 3000, 3);
	}
	else if(isequal(option, "detach", true))
	{
	    DetachTrailerFromVehicle(trailerid);
	}
	else if(isequal(option, "lights", true))
	{
		switch (GetLightStatus(vehicleid))
		{
		    case false:
		    {
		        SetLightStatus(vehicleid, true);
			}
			case true:
			{
			    SetLightStatus(vehicleid, false);
			}
		}
	}
	else if(isequal(option, "cargo", true))
	{
		new engine, lights, alarm, doors, bonnet, boot, objective;
     	GetVehicleParamsEx(trailerid, engine, lights, alarm, doors, bonnet, boot, objective);
     	
     	if(boot != VEHICLE_PARAMS_ON)
			return SendClientMessage(playerid, COLOR_WHITE, "รถพ่วงล็อกอยู่");

		new count, str[512];

		for(new i=0;i<MAX_INDUSTRY_ITEM;i++) if(gVehicleTrucking[trailerid][truckingCrate][i])
		{
			format(str, 512, "%s"EMBED_BLACK"%02d\t"EMBED_LIMEGREEN"%s\t%d %s\n", str, i + 1, g_arrItemNames[i], gVehicleTrucking[trailerid][truckingCrate][i], Trucking_Unit(g_arrItemPackageType[i]));
			count++;
		}
		if(!count) Dialog_Show(playerid, DEFAULT, DIALOG_STYLE_MSGBOX, "Trailer Cargo", ""EMBED_LIMEGREEN"ไม่มีสินค้าที่บรรจุในยานพาหนะคันนี้", "ปิด", "");
		else Dialog_Show(playerid, DEFAULT, DIALOG_STYLE_TABLIST, "Trailer Cargo", str, "ปิด", "");
	}
	else {
		return SendClientMessage(playerid, COLOR_LIGHTRED, " พารามิเตอร์ไม่ถูกต้อง"); 
	}
	return 1;
}

CMD:cargo(playerid, params[]) {

	if(playerData[playerid][pJob] != JOB_TRUCKER && playerData[playerid][pSideJob] != JOB_TRUCKER)
	    return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ใช่ Trucker");

	new option[16], amount, id = -1;
	if (sscanf(params, "s[16]D(0)", option, amount)) 
    {
	    SendClientMessage(playerid, COLOR_GRAD2, "คำสั่งที่ใช้งานได้:");
	    SendClientMessage(playerid, -1, ""EMBED_YELLOW"/cargo list "EMBED_WHITE"- แสดงรายการสินค้าที่บรรจุอยู่ในยานพาหนะที่ปลดล็อกอยู่ใกล้ ๆ");
	    SendClientMessage(playerid, -1, ""EMBED_YELLOW"/cargo listpickup [ID] "EMBED_WHITE"- ถ้าคำสั่ง "EMBED_YELLOW"/cargo list"EMBED_WHITE" บัค ใช้ทางเลือกนี้; [ID] คือหมายเลขที่อยู่ในลิสต์");
        SendClientMessage(playerid, -1, ""EMBED_YELLOW"/cargo place "EMBED_WHITE"- วางลังสินค้าที่ถืออยู่ไปที่ยานพาหนะใกล้ ๆ");
        SendClientMessage(playerid, -1, ""EMBED_YELLOW"/cargo fork "EMBED_WHITE"- ขนส่งสินค้าในยานพาหนะที่ใกล้ที่สุดเพื่อยกไปยังรถโฟล์คลิฟท์ของคุณ");
        SendClientMessage(playerid, -1, ""EMBED_YELLOW"/cargo putdown "EMBED_WHITE"- วางลังสินค้าที่ถืออยู่ลงพื้น");
        SendClientMessage(playerid, -1, ""EMBED_YELLOW"/cargo pickup "EMBED_WHITE"- หยิบลังสินค้าขึ้นมาจากพื้น");
        SendClientMessage(playerid, -1, ""EMBED_YELLOW"/cargo buy "EMBED_WHITE"- ช่วยให้คุณสามารถซื้อสินค้าจากอุตสาหกรรมได้");
        SendClientMessage(playerid, -1, ""EMBED_YELLOW"/cargo sell "EMBED_WHITE"- ขายสินค้าให้กับอุตสาหกรรม / ธุรกิจ");
		return 1;
	}

	if(isequal(option, "list", true)) // DIALOG_STYLE_LIST
	{
	    new vehicleid = -1;

	    vehicleid = Vehicle_Nearest(playerid);

		if(IsTrailerAttachedToVehicle(vehicleid)) 
            return SendClientMessage(playerid, COLOR_YELLOW, "ใช้คำสั่ง:"EMBED_WHITE" /trailer cargo");

		if(vehicleid != INVALID_VEHICLE_ID)
		{
            new engine, lights, alarm, doors, bonnet, boot, objective;
            GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
            
            if(boot != VEHICLE_PARAMS_ON)
                return SendClientMessage(playerid, COLOR_WHITE, "ไม่พบยานพาหนะที่"EMBED_YELLOW"ปลดล็อก"EMBED_WHITE"กระโปรงท้ายรถ"); 
                
		    new count, str[512];

			for(new i=0;i!=MAX_INDUSTRY_ITEM;i++) if(gVehicleTrucking[vehicleid][truckingCrate][i])
			{
				format(str, 512, "%s %02d %s %d %s\n", str, i + 1, g_arrItemNames[i], gVehicleTrucking[vehicleid][truckingCrate][i], Trucking_Unit(g_arrItemPackageType[i]));
				count++;
			}
			if(!count) Dialog_Show(playerid, DEFAULT, DIALOG_STYLE_MSGBOX, "Vehicle Cargo", ""EMBED_LIMEGREEN"ไม่มีสินค้าที่บรรจุในยานพาหนะคันนี้", "ปิด", "");
			//else Dialog_Show(playerid, VehiclePickupCrate, DIALOG_STYLE_TABLIST, "Vehicle Cargo", str, "หยิบ", "ปิด");
			else Dialog_Show(playerid, VehiclePickupCrate, DIALOG_STYLE_LIST, "Vehicle Cargo", str, "หยิบ", "ปิด");
		}
		else SendClientMessage(playerid, COLOR_WHITE, "ไม่พบยานพาหนะที่"EMBED_YELLOW"ปลดล็อก"EMBED_WHITE"กระโปรงท้ายรถ");
	}
    else if(isequal(option, "listpickup", true))
	{
		if(amount > 0)
		{
			if(playerPicking{playerid}) 
            	return 1;
				
		    amount--;

			new vehicleid = Vehicle_Nearest(playerid);

         	if(IsTrailerAttachedToVehicle(vehicleid)) 
         	    return SendClientMessage(playerid, COLOR_YELLOW, "ใช้คำสั่ง:"EMBED_WHITE" /trailer cargo");

			if(playerCarryCrate[playerid] == -1 && vehicleid != INVALID_VEHICLE_ID && g_arrItemPackageType[gVehicleTrucking[vehicleid][truckingCrate][amount]] == TRUCKING_PACKAGE_TYPE_CRATE) {

            	new engine, lights, alarm, doors, bonnet, boot, objective;
            	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
            	
            	if(boot != VEHICLE_PARAMS_ON)
            	    return SendClientMessage(playerid, COLOR_WHITE, "ไม่พบยานพาหนะที่"EMBED_YELLOW"ปลดล็อก"EMBED_WHITE"กระโปรงท้ายรถ"); 
            	    
				if(gVehicleTrucking[vehicleid][truckingCrate][amount])
				{
				    gVehicleTrucking[vehicleid][truckingCrate][amount]--;

				    Trucking_UpdateVehicleObject(vehicleid);
					Streamer_Update(playerid, STREAMER_TYPE_OBJECT);

					playerPicking{playerid} = true;
					ApplyAnimation(playerid, "CARRY","liftup105", 4.1, 0, 0, 0, 0, 0, 1);
					SetTimerEx("PickupCrate", 200, 0, "ii", playerid, amount);
					return 1;
				}
			}
		}
		SendClientMessage(playerid, COLOR_WHITE, "ค่าไม่ถูกต้อง");
	}
	else if(isequal(option, "place", true))
	{
		if(playerPicking{playerid}) 
          	return 1;

    	if(playerCarryCrate[playerid] != -1) {

		    new vehicleid = Vehicle_Nearest(playerid);

       		new engine, lights, alarm, doors, bonnet, boot, objective;
       		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	
       		if(boot != VEHICLE_PARAMS_ON)
       		    return SendClientMessage(playerid, COLOR_WHITE, "ไม่พบยานพาหนะที่"EMBED_YELLOW"ปลดล็อก"EMBED_WHITE"กระโปรงท้ายรถ"); 

			if(vehicleid != INVALID_VEHICLE_ID && IsPlayerNearBoot(playerid, vehicleid))
			{
				new itemType = g_arrItemPackageType[playerCarryCrate[playerid]];
				if(Trucking_VehicleCarry(vehicleid, itemType))
				{
					new model = GetVehicleModel(vehicleid);
					if(Trucking_VehicleWeight(vehicleid) + Trucking_PackageWeight(playerCarryCrate[playerid]) <= Trucking_VehicleSlot(model))
					{
						gVehicleTrucking[vehicleid][truckingCrate][playerCarryCrate[playerid]]++;

						if (itemType != TRUCKING_PACKAGE_TYPE_LIQUID && itemType != TRUCKING_PACKAGE_TYPE_LOOSE) {
							Trucking_UpdateVehicleObject(vehicleid);
							Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
						}

						ApplyAnimation(playerid, "CARRY","putdwn105", 4.1, 0, 0, 0, 0, 0, 1);
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
						RemovePlayerAttachedObject(playerid, 9);
						playerCarryCrate[playerid] = -1;

						new targetid = INVALID_PLAYER_ID;
					    if ((targetid = GetVehicleDriver(vehicleid)) != INVALID_PLAYER_ID)
					    {
							if(playerData[targetid][pJobRank] >= Trucking_VehicleSkill(model)) 
								RemovePlayerFromVehicle(targetid), SendClientMessage(targetid, COLOR_WHITE, "ทักษะของคุณมีไม่เพียงพอสำหรับการขนส่งสินค้าบนยานพาหนะคันนี้");
						}

					}
					else SendClientMessage(playerid, COLOR_WHITE, "ไม่สามารถบรรจุสินค้าได้มากกว่านี้แล้ว");
				}
				else SendClientMessage(playerid, COLOR_WHITE, "ยานพาหนะของคุณไม่สามารถขนส่งสินค้าชนิดนี้ได้");
			}
			else SendClientMessage(playerid, COLOR_WHITE, "ไม่พบยานพาหนะที่"EMBED_YELLOW"ปลดล็อก"EMBED_WHITE"กระโปรงหลังรถรอบ ๆ ตัวคุณ");
		}
    	else SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้ถือลังไม้อยู่");
	}
	else if(isequal(option, "buy", true))
	{
		if ((id = Industry_Nearest(playerid)) != -1 && industryData[industryStorageData[id][industryID]][industryStatus])
		{
			if (g_arrItemPackageType[industryStorageData[id][industryItem]] == TRUCKING_PACKAGE_TYPE_CRATE) 
			{
				if(playerPicking{playerid}) 
					return 1;
					
				if(IsPlayerInAnyVehicle(playerid))
				{
					return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องไม่อยู่บนยานพาหนะ");
				}

				if(playerCarryCrate[playerid] != -1)
				{
					return SendClientMessage(playerid, COLOR_GRAD1, "   คุณกำลังถือลังไม้อยู่");
				}				

              	if(industryStorageData[id][industryTradingType] != 0) {
					return SendClientMessage(playerid, COLOR_WHITE, "คุณไม่สามารถซื้ออะไรในอุตสาหกรรมนี้ได้");
				}

				if(industryStorageData[id][industryStock] <= 0)
				{
					return SendClientMessage(playerid, COLOR_WHITE, "อุตสาหกรรมนี้ว่างเปล่า");
				}
				
	          	if(playerData[playerid][pCash] >= industryStorageData[id][industryPrice]) {
				   
		      	    industryStorageData[id][industryStock]--;
		      	    Trucking_UpdateIndustry(id);

		      	    GivePlayerMoneyEx(playerid, -industryStorageData[id][industryPrice]);

					playerPicking{playerid} = true;
		      	    ApplyAnimation(playerid, "CARRY","liftup", 4.1, 0, 0, 0, 0, 0, 1);
					SetTimerEx("PickupCrate", 200, 0, "ii", playerid, industryStorageData[id][industryItem]);
	          	}
	          	else SendClientMessage(playerid, COLOR_WHITE, "คุณมีเงินไม่เพียงพอ");
			}
			else 
			{
				if(!IsPlayerInAnyVehicle(playerid))
					return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่บนยานพาหนะ");

				if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
					return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่คนขับ");

				new itemType = g_arrItemPackageType[industryStorageData[id][industryItem]];

				if (itemType == TRUCKING_PACKAGE_TYPE_LIQUID || itemType == TRUCKING_PACKAGE_TYPE_LOOSE) {
					
					if (amount <= 0) {
						SendClientMessage(playerid, -1, "คุณต้องระบุจำนวนของสินค้าใช้ "EMBED_LIGHTGREEN"/cargo buy [จำนวน]");

						if (itemType != TRUCKING_PACKAGE_TYPE_LIQUID) {
							SendClientMessage(playerid, -1, "Dump trailer ความจุ: {E5FF00}30 ตัน");
							SendClientMessage(playerid, -1, "Flatbed ความจุ:  {E5FF00}16 ตัน");
						}
						else {
							SendClientMessage(playerid, -1, "Tanker ความจุ: {E5FF00}40 ลูกบาศก์เมตร");
						}
						return 1;
					}
				}
				else amount = 1;

				new vehicleid = GetPlayerVehicleID(playerid);

				if(!Trucking_VehicleCarry(vehicleid, itemType)) 
					return SendClientMessage(playerid, -1, "ยานพาหนะของคุณไม่สามารถขนส่งสินค้าชนิดนี้ได้");

				if(playerData[playerid][pJobRank] >= Trucking_VehicleSkill(GetVehicleModel(vehicleid))) 
					return SendClientMessage(playerid, -1, "ทักษะของคุณมีไม่เพียงพอสำหรับการขนส่งสินค้าบนยานพาหนะคันนี้");

              	if(industryStorageData[id][industryTradingType] != 0) {
					return SendClientMessage(playerid, COLOR_WHITE, "คุณไม่สามารถซื้ออะไรในอุตสาหกรรมนี้ได้");
				}

				if(playerData[playerid][pCash] >= industryStorageData[id][industryPrice] * amount) {

					if(IsTrailerAttachedToVehicle(vehicleid))
						vehicleid = GetVehicleTrailer(vehicleid);

					if(Trucking_VehicleWeight(vehicleid) + (Trucking_PackageWeight(industryStorageData[id][industryItem]) * amount) <= Trucking_VehicleSlot(GetVehicleModel(vehicleid)))
					{
						new engine, lights, alarm, doors, bonnet, boot, objective;
						GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
						
						if(boot != VEHICLE_PARAMS_ON) {
							if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
								return SendClientMessage(playerid, COLOR_WHITE, "รถพ่วงล็อกอยู่");
							else 
								return SendClientMessage(playerid, COLOR_WHITE, "ไม่พบยานพาหนะที่"EMBED_YELLOW"ปลดล็อก"EMBED_WHITE"กระโปรงท้ายรถ"); 
						}

						if (itemType != TRUCKING_PACKAGE_TYPE_LIQUID && itemType != TRUCKING_PACKAGE_TYPE_LOOSE) 
						{
							gVehicleTrucking[vehicleid][truckingCrate][industryStorageData[id][industryItem]]++;
							Trucking_UpdateVehicleObject(vehicleid);
							Streamer_Update(playerid, STREAMER_TYPE_OBJECT);

							industryStorageData[id][industryStock]--;
							Trucking_UpdateIndustry(id);

							GivePlayerMoneyEx(playerid, -industryStorageData[id][industryPrice]);
						}
						else
						{
							new cargo_in_vehicle = -1;
							for(new i=0;i<MAX_INDUSTRY_ITEM;i++) {
								if(gVehicleTrucking[vehicleid][truckingCrate][i])
								{
									cargo_in_vehicle = i;
									break;
								}
							}

							if(cargo_in_vehicle == -1 || industryStorageData[id][industryItem] == cargo_in_vehicle)
							{
								if(gVehicleTrucking[vehicleid][truckingLoading] == 0)
								{
									industryStorageData[id][industryStock] -= amount;
									Trucking_UpdateIndustry(id);
									GivePlayerMoneyEx(playerid, -industryStorageData[id][industryPrice] * amount);
									gVehicleTrucking[vehicleid][truckingLoading] = amount * 2;
									gVehicleTrucking[vehicleid][truckingCargo] = amount;
									gVehicleTrucking[vehicleid][truckingTimer] = repeat TruckingLoading(vehicleid, playerid, id, false, -1);
									GameTextForPlayer(playerid, "~r~Cargo is being (un)loaded,~n~~b~Please wait...", 1000, 3);
								}
								else SendClientMessage(playerid, COLOR_WHITE, "รถบรรทุกกำลังบรรจุสินค้าอยู่ในขณะนี้");
							}
							else SendClientMessage(playerid, COLOR_WHITE, "ไม่สามารถขนส่งสินค้าต่างชนิดกันได้");
						}
					}
					else SendClientMessage(playerid, COLOR_WHITE, "ไม่สามารถขนส่งสินค้าได้มากกว่านี้แล้ว");
				}
				else SendClientMessage(playerid, COLOR_WHITE, "คุณมีเงินไม่เพียงพอ");
			}
		}
		else SendClientMessage(playerid, COLOR_WHITE, "ไม่มีอุตสาหกรรมที่นี่");
	}
	else if(isequal(option, "sell", true))
	{
		if ((id = Industry_Nearest(playerid)) != -1 && industryData[industryStorageData[id][industryID]][industryStatus])
		{
			if (g_arrItemPackageType[industryStorageData[id][industryItem]] == TRUCKING_PACKAGE_TYPE_CRATE) 
			{
				if(playerPicking{playerid}) 
					return 1;
					
				if(IsPlayerInAnyVehicle(playerid))
				{
					return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องไม่อยู่บนยานพาหนะ");
				}

				if(playerCarryCrate[playerid] == -1)
				{
					return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้ถือลังไม้อยู่");
				}				

				if(industryStorageData[id][industryStock] == industryStorageData[id][industryMaximum])
				{
					return SendClientMessage(playerid, COLOR_WHITE, "อุตสาหกรรมนี้เต็มแล้ว");
				}
		      	industryStorageData[id][industryStock]++;
		      	Trucking_UpdateIndustry(id);

				GivePlayerMoneyEx(playerid, industryStorageData[id][industryPrice]);

	           	playerCarryCrate[playerid] = -1;

				ApplyAnimation(playerid, "CARRY","putdwn", 4.1, 0, 0, 0, 0, 0, 1);
				SetTimerEx("PlaceCrate", 900, 0, "i", playerid);
			}
			else 
			{
				if(!IsPlayerInAnyVehicle(playerid))
					return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่บนยานพาหนะ");

				if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
					return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่คนขับ");

				new itemType = g_arrItemPackageType[industryStorageData[id][industryItem]];

				if (itemType == TRUCKING_PACKAGE_TYPE_LIQUID || itemType == TRUCKING_PACKAGE_TYPE_LOOSE) {
					if (amount <= 0) {
						SendClientMessage(playerid, -1, "คุณต้องระบุจำนวนของสินค้าใช้ "EMBED_LIGHTGREEN"/cargo sell [จำนวน]");
						return 1;
					}
				}
				else amount = 1;

				new vehicleid = GetPlayerVehicleID(playerid);

				if(playerData[playerid][pJobRank] >= Trucking_VehicleSkill(GetVehicleModel(vehicleid))) 
					return SendClientMessage(playerid, -1, "ทักษะของคุณมีไม่เพียงพอสำหรับการขนส่งสินค้าบนยานพาหนะคันนี้");

				if(IsTrailerAttachedToVehicle(vehicleid))
					vehicleid = GetVehicleTrailer(vehicleid);
				
				if(gVehicleTrucking[vehicleid][truckingCrate][industryStorageData[id][industryItem]] < amount)
				{
					return SendClientMessage(playerid, COLOR_WHITE, "จำนวนสินค้าไม่ถูกต้อง");
				}

				new engine, lights, alarm, doors, bonnet, boot, objective;
				GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
				
				if(boot != VEHICLE_PARAMS_ON) {
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
						return SendClientMessage(playerid, COLOR_WHITE, "รถพ่วงล็อกอยู่");
					else 
						return SendClientMessage(playerid, COLOR_WHITE, "ไม่พบยานพาหนะที่"EMBED_YELLOW"ปลดล็อก"EMBED_WHITE"กระโปรงท้ายรถ"); 
				}

				if(industryStorageData[id][industryStock] + amount > industryStorageData[id][industryMaximum])
				{
					return SendClientMessage(playerid, COLOR_WHITE, "อุตสาหกรรมนี้มีพื้นที่ไม่เพียงพอ");
				}

				if (itemType != TRUCKING_PACKAGE_TYPE_LIQUID && itemType != TRUCKING_PACKAGE_TYPE_LOOSE) 
				{
					gVehicleTrucking[vehicleid][truckingCrate][industryStorageData[id][industryItem]]--;
					Trucking_UpdateVehicleObject(vehicleid);
					Streamer_Update(playerid, STREAMER_TYPE_OBJECT);

					industryStorageData[id][industryStock]++;
					Trucking_UpdateIndustry(id);

					GivePlayerMoneyEx(playerid, industryStorageData[id][industryPrice]);
				}
				else
				{

					new cargo_in_vehicle = -1;
					for(new i=0;i<MAX_INDUSTRY_ITEM;i++) {
						if(gVehicleTrucking[vehicleid][truckingCrate][i])
						{
							cargo_in_vehicle = i;
							break;
						}
					}

					if(cargo_in_vehicle == -1 || industryStorageData[id][industryItem] == cargo_in_vehicle)
					{
						if(gVehicleTrucking[vehicleid][truckingLoading] == 0)
						{
							industryStorageData[id][industryStock] += amount;
							Trucking_UpdateIndustry(id);

							gVehicleTrucking[vehicleid][truckingLoading] = amount * 2;
							gVehicleTrucking[vehicleid][truckingCargo] = amount;
							gVehicleTrucking[vehicleid][truckingTimer] = repeat TruckingLoading(vehicleid, playerid, id, true, -1);
							GameTextForPlayer(playerid, "~r~Cargo is being (un)loaded,~n~~b~Please wait...", 1000, 3);
						}
						else SendClientMessage(playerid, COLOR_WHITE, "รถบรรทุกกำลังบรรจุสินค้าอยู่ในขณะนี้");
					}
					else SendClientMessage(playerid, COLOR_WHITE, "ไม่สามารถขนส่งสินค้าต่างชนิดกันได้");
				}
			}
		}
		else SendClientMessage(playerid, COLOR_WHITE, "ไม่มีอุตสาหกรรมที่นี่");
	}
	return 1;
}

forward PickupCrate(playerid, type);
public PickupCrate(playerid, type)
{
	playerPicking{playerid} = false;
	playerCarryCrate[playerid] = type;
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	SetPlayerAttachedObject(playerid, 9, 2912, 1, -0.019, 0.713999, -0.076, 0, 87.1, -9.4, 1.0000, 1.0000, 1.0000);
}

forward  PlaceCrate(playerid);
public PlaceCrate(playerid)
{
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	RemovePlayerAttachedObject(playerid, 9);
}

Trucking_VehicleWeight(vehicleid)
{
	new count;
	for(new i=0;i<MAX_INDUSTRY_ITEM;i++) if(gVehicleTrucking[vehicleid][truckingCrate][i])
	{
	    count += gVehicleTrucking[vehicleid][truckingCrate][i] * Trucking_PackageWeight(i);
	}
	return count;
}

Trucking_PackageWeight(itemid)
{
	if(itemid == 22) return 6;
	else if(itemid == 4 || itemid == 16) return 18;
	return 1;
}

Trucking_UpdateVehicleObject(vehicleid)
{

	for(new i, maxval = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT); i <= maxval; ++i)
	{
		if(!IsValidDynamicObject(i)) continue;

		if (Streamer_GetIntData(STREAMER_TYPE_OBJECT, i, E_STREAMER_ATTACHED_VEHICLE) == vehicleid) {
			DestroyDynamicObject(i);
		}
	}

	new 
		model = GetVehicleModel(vehicleid), 
		count = Trucking_VehicleWeight(vehicleid)
	;

	switch(model) {
	    case 422: {
			for(new i=0;i!=3;i++)
			{
				if(i < count) {
					switch(i) {
						case 0: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, -0.344999, -0.769999, -0.294999, 0.000000, 0.000000, 0.000000);
						case 1: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, 0.364999, -0.769999, -0.299999, 0.000000, 0.000000, 0.000000);
						case 2: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, 0.159999, -1.839998, -0.299999, 0.000000, 0.000000, 0.000000);
					}
				}
			}
	    }
	    case 543, 605: {
			for(new i=0;i!=2;i++)
			{
				if(i < count) {
					switch(i) {
						case 0: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, -0.344999, -0.769999, -0.294999, 0.000000, 0.000000, 0.000000); //Object Model: 2912 | CRATE
						case 1: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, 0.364999, -0.769999, -0.299999, 0.000000, 0.000000, 0.000000); //Object Model: 2912 | CRATE
					}

				}
			}
	    }
		case 600: {
			for(new i=0;i!=2;i++)
			{
				if(i < count) {
					switch(i) {
						case 0: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, -0.344999, -0.92, -0.294999, 0.000000, 0.000000, 0.000000); //Object Model: 2912 | CRATE
						case 1: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, 0.364999, -0.92, -0.299999, 0.000000, 0.000000, 0.000000); //Object Model: 2912 | CRATE
					}
				}
			}
		}
		case 530: {
			for(new i=0;i!=3;i++)
			{

				if(i < count) {
					switch(i) {
						case 0: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, 0.354999, 0.489999, -0.059999, 0.000000, 0.000000, 0.000000); //Object Model: 2912 | CRATE
						case 1: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, -0.344999, 0.489999, -0.059999, 0.000000, 0.000000, 0.000000); //Object Model: 2912 | CRATE
						case 2: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, 0.009999, 0.484999, 0.634999, 0.000000, 0.000000, 0.000000); //Object Model: 2912 | CRATE
					}
				}

			}
		}
		case 478: {
			for(new i=0;i!=4;i++)
			{
				if(i < count) {
					switch(i) {
						case 0: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, -0.354999, -0.949999, 0.000000, 0.000000, 0.000000, 0.000000); //Object Model: 2912 |
						case 1: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, 0.354999, -0.949999, 0.000000, 0.000000, 0.000000, 0.000000); //Object Model: 2912 |
						case 2: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, -0.354999, -1.664998, 0.000000, 0.000000, 0.000000, 0.000000); //Object Model: 2912 |
						case 3: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, 0.354999, -1.664998, 0.000000, 0.000000, 0.000000, 0.000000); //Object Model: 2912 |
					}
				}

			}
		}
		case 554: {
            if(gVehicleTrucking[vehicleid][truckingCrate][22])
            {
                AttachDynamicObjectToVehicle(CreateDynamicObject(1685, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, 0.000000, -1.754998, 0.859999, 0.000000, 0.000000, 0.000000); //Object Model: 1685 |
            }
            else {
				for(new i=0;i!=4;i++)
				{
					if(i < count) {
						switch(i) {
							case 0: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, 0.294999, -0.989999, -0.239999, 0.000000, 0.000000, 0.000000); //Object Model: 2912 |
							case 1: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, -0.409999, -1.694998, -0.239999, 0.000000, 0.000000, 0.000000); //Object Model: 2912 |
							case 2: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, 0.295000, -1.694998, -0.239999, 0.000000, 0.000000, 0.000000); //Object Model: 2912 |
							case 3: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, -0.414999, -2.405007, -0.239999, 0.000000, 0.000000, 0.000000); //Object Model: 2912 |
       						case 4: AttachDynamicObjectToVehicle(CreateDynamicObject(2912, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, 0.295000, -2.410007, -0.239999, 0.000000, 0.000000, 0.000000); //Object Model: 2912 |
						}
					}

				}
			}
		}
		case 578: { // DFT-30
            if(gVehicleTrucking[vehicleid][truckingCrate][4]) { // wood logs
				AttachDynamicObjectToVehicle(CreateDynamicObject(18609, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, 0.205000, -5.895015, 0.839999, 0.000000, 0.000000, 3.900000);
            }
			else if(gVehicleTrucking[vehicleid][truckingCrate][16]) { // transformer
				AttachDynamicObjectToVehicle(CreateDynamicObject(3273, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, -0.000000, -0.404999, 0.799999, 0.000000, 90.449951, -90.449951); //Object Model: 3273 |
			}
		}
		case 443: { // Packer
            if(gVehicleTrucking[vehicleid][truckingCrate][17] == 1) {
				AttachDynamicObjectToVehicle(CreateDynamicObject(3593, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, 0.205000, -5.895015, 0.839999, 0.000000, 0.000000, 3.900000);
			}
			else
			{
				AttachDynamicObjectToVehicle(CreateDynamicObject(3593, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, 0.000000, 0.344999, 1.819998, 15.074999, 0.000000, 0.000000); //Object Model: 3593 |  CAR DESTROY
				AttachDynamicObjectToVehicle(CreateDynamicObject(3593, 0.0, 0.0, -20.0, 0.0, 0.0, 0.0), vehicleid, -0.005000, -6.455012, 0.024998, 15.074999, 0.000000, 0.000000); //Object Model: 3593 |  CAR DESTROY
			}
		}
	}
}

Dialog:VehiclePickupCrate(playerid, response, listitem, inputtext[]) {
	if(response)
	{
	    if (IsPlayerInAnyVehicle(playerid)) 	
			return SendClientMessage(playerid, COLOR_GRAD1, "   คุณอยู่ในรถ!");
		
        if(playerCarryCrate[playerid] == -1) {

			new vehicleid = Vehicle_Nearest(playerid);

			if(vehicleid != INVALID_VEHICLE_ID)
			{
				new cargoid = strval(inputtext) - 1;
				if(gVehicleTrucking[vehicleid][truckingCrate][cargoid] > 0)
				{
				    gVehicleTrucking[vehicleid][truckingCrate][cargoid]--;
				    Trucking_UpdateVehicleObject(vehicleid);
					Streamer_Update(playerid, STREAMER_TYPE_OBJECT);

					playerPicking{playerid} = true;
					ApplyAnimation(playerid, "CARRY","liftup105", 4.1, 0, 0, 0, 0, 0, 1);
					SetTimerEx("PickupCrate", 200, 0, "ii", playerid, cargoid);
				} 
				else SendClientMessage(playerid, COLOR_WHITE, "ไม่มีอะไรอยู่ที่นั้น..");
			}
			else SendClientMessage(playerid, COLOR_WHITE, "ไม่พบยานพาหนะที่"EMBED_YELLOW"ปลดล็อก"EMBED_WHITE"กระโปรงหลังรถ");
		}
		else SendClientMessage(playerid, COLOR_GRAD1, "   คุณกำลังถือลังไม้อยู่");
	}
	return 1;
}

Dialog:TruckerPDANavigate(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new menu[10];
	    format(menu, 10, "menu%d", listitem);
	    new id = GetPVarInt(playerid, menu);

		SendClientMessage(playerid, COLOR_WHITE, "การนำทาง! (หากไม่มีเช็คพ้อยใช้ /updatemission)");

		// Checkpoint Mission
		TruckerMissionX[playerid] = industryStorageData[id][industryPosX];
		TruckerMissionY[playerid] = industryStorageData[id][industryPosY];
		TruckerMissionZ[playerid] = industryStorageData[id][industryPosZ];
		
		SetPlayerRaceCheckpoint(playerid, 2, industryStorageData[id][industryPosX], industryStorageData[id][industryPosY], industryStorageData[id][industryPosZ], 0.0, 0.0, 0.0, 3.5);
	}
	else {

		new industryid = GetPVarInt(playerid, "IndustrySelected");

		if(industryid) ShowIndustry(playerid, GetPVarInt(playerid, "IndustrySelected"));
		else ShowCargoShip(playerid);
	}
	return 1;
}

alias:updatemission("um");
CMD:updatemission(playerid)
{
	if(TruckerMissionX[playerid] != 0.0 && TruckerMissionY[playerid] != 0.0)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "เช็คพ้อยถูกปรับปรุงใหม่! (หากยังไม่เห็นอะไร พยายามใช้ /removecp และ /updatemission)");
	    SetPlayerRaceCheckpoint(playerid, 2, TruckerMissionX[playerid], TruckerMissionY[playerid], TruckerMissionZ[playerid], 0.0, 0.0, 0.0, 3.5);
	}
	else {
		SendClientMessage(playerid, COLOR_WHITE, "ไม่มีเช็คพ้อยสำหรับ Trucker ให้อัปเดต");
	}
	return 1;
}

CMD:removecp(playerid)
{
    DisablePlayerCheckpoint(playerid);
    DisablePlayerRaceCheckpoint(playerid);
	return 1;
}

hook OP_EnterRaceCheckpoint(playerid)
{
	if(TruckerMissionX[playerid] != 0.0 && TruckerMissionY[playerid] != 0.0)
	{
		TruckerMissionX[playerid] = 0.0;
		TruckerMissionY[playerid] = 0.0;
		TruckerMissionZ[playerid] = 0.0;
		DisablePlayerRaceCheckpoint(playerid);
	}
}

timer TruckingLoading[1000](vehicleid, playerid, id, bool:sell, b_id)
{
	if(IsPlayerConnected(playerid)) {
		new str[70];
		format(str, sizeof(str), "~r~Cargo is being (un)loaded,~n~~b~Please wait...~n~(%d Seconds left)", gVehicleTrucking[vehicleid][truckingLoading]);
		GameTextForPlayer(playerid, str, 1000, 3);
	}

	gVehicleTrucking[vehicleid][truckingLoading]--;

	if ((b_id == -1 && GetVehicleDistanceFromPoint(vehicleid, industryStorageData[id][industryPosX], industryStorageData[id][industryPosY], industryStorageData[id][industryPosZ]) <= 20.0) || (b_id != -1 && GetVehicleDistanceFromPoint(vehicleid, businessData[b_id][bPosX],businessData[b_id][bPosY],businessData[b_id][bPosZ]) <= 20.0))
	{
		if (gVehicleTrucking[vehicleid][truckingLoading] <= 0) {
			if (sell) {
				if(b_id != -1) 
				{
					/*BizInfo[industryid][bProducts] += CoreVehicles[i][vehicleIsCargoLoad] * GetProductPerCargo(BizInfo[industryid][bType]);
					playerData[playerid][pCash]+=BizInfo[industryid][bPriceProd] * CoreVehicles[i][vehicleIsCargoLoad];
					BizInfo[industryid][bTill]-=BizInfo[industryid][bPriceProd] * CoreVehicles[i][vehicleIsCargoLoad];

					new cargotype = GetProductCargo(BizInfo[industryid][bType]);
				    CoreVehicles[i][vehicleCrate][cargotype] -= CoreVehicles[i][vehicleIsCargoLoad];*/
				}
				else 
				{
					GivePlayerMoneyEx(playerid, industryStorageData[id][industryPrice] * gVehicleTrucking[vehicleid][truckingCargo]);
				    gVehicleTrucking[vehicleid][truckingCrate][industryStorageData[id][industryItem]] = 0;
				}
			}
			else 
			{
				gVehicleTrucking[vehicleid][truckingCrate][industryStorageData[id][industryItem]] += gVehicleTrucking[vehicleid][truckingCargo];
			}

			if(IsPlayerConnected(playerid)) {
				SendClientMessage(playerid, COLOR_WHITE, "บรรทุกสินค้าสำเร็จ");
			}


			gVehicleTrucking[vehicleid][truckingLoading] = 0;
			gVehicleTrucking[vehicleid][truckingCargo] = 0;
			stop gVehicleTrucking[vehicleid][truckingTimer];
		}
	}
	else {
		if (!sell) industryStorageData[id][industryStock] += gVehicleTrucking[vehicleid][truckingCargo];
		else industryStorageData[id][industryStock] -= gVehicleTrucking[vehicleid][truckingCargo];

		Trucking_UpdateIndustry(id);
		gVehicleTrucking[vehicleid][truckingLoading] = 0;
		gVehicleTrucking[vehicleid][truckingCargo] = 0;
		stop gVehicleTrucking[vehicleid][truckingTimer];
	}
}

ShowTPDAMenu(playerid) {
	if(playerData[playerid][pJob] != JOB_TRUCKER && playerData[playerid][pSideJob] != JOB_TRUCKER)
	    return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ใช่ Trucker");

	return Dialog_Show(playerid, TruckerPDA, DIALOG_STYLE_LIST, "Trucker PDA", ""EMBED_GRAD"แสดง"EMBED_WHITE"อุตสาหกรรมทั้งหมด\n"EMBED_GRAD"แสดง"EMBED_WHITE"ธุรกิจที่รับสินค้า\n"EMBED_GRAD"แสดง"EMBED_WHITE"ข้อมูลเรือ", "เลือก", "ออก");
}

CMD:tpda(playerid, params[])
{
	ShowTPDAMenu(playerid);
	return 1;
}

Dialog:TruckerPDA(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		switch(listitem)
		{
		    case 0: {
				ShowAllIndustry(playerid);
		    }
		    case 1: {
				/*new string[1024], menu[10], count;

				format(string, sizeof(string), " \t \t \t \n");
				format(string, sizeof(string), "%s"EMBED_LIGHTGREEN"หน้า 1"EMBED_WHITE"\t\t\t\n", string);

				SetPVarInt(playerid, "page", 1);

				foreach(new i : sv_business)
				{
					if(BizInfo[i][bPriceProd] && GetBusinessCargoCanBuy(i) && GetProductCargo(BizInfo[i][bType]) != -1)
					{
						if(count == 10)
						{
							format(string, sizeof(string), "%s"EMBED_LIGHTGREEN"หน้า 2"EMBED_WHITE"\t\t\t\n", string);
							break;
						}
						format(menu, 10, "menu%d", ++count);
						SetPVarInt(playerid, menu, i);
						format(string, sizeof(string), "%s%s\t%s / หน่วย\tต้องการ: %d %s\t%s\n", string, g_arrItemNames[GetProductCargo(BizInfo[i][bType])], FormatNumber(BizInfo[i][bPriceProd]), GetBusinessCargoCanBuy(i), ReturnCargoUnits(GetProductCargo(BizInfo[i][bType])), ClearGameTextColor(BizInfo[i][bInfo]));
					}

				}
				if(!count) Dialog_Show(playerid, DEFAULT, DIALOG_STYLE_MSGBOX, "Trucker PDA - ธุรกิจ", "ไม่มีธุรกิจไหนต้องการสินค้า", "โอเค", "");
				else Dialog_Show(playerid, TruckerPDABusiness, DIALOG_STYLE_TABLIST_HEADERS, "Trucker PDA - ธุรกิจ", string, "นำทาง", "กลับ");*/
				Dialog_Show(playerid, DEFAULT, DIALOG_STYLE_MSGBOX, "Trucker PDA - ธุรกิจ", "ไม่มีธุรกิจไหนต้องการสินค้า", "โอเค", "");
		    }
		    case 2: {
				ShowCargoShip(playerid);
		    }
		}
	}
	return 1;
}

ShowAllIndustry(playerid)
{
    new string[1900];
	for(new i=1;i!=sizeof(g_arrIndustryNames);i++) format(string, sizeof(string), "%s%s "EMBED_GRAD"(%s,%s)\n", string, g_arrIndustryNames[i], industryData[i][industryType] == INDUSTRY_PRIMARY ? ("หลัก") : industryData[i][industryType] == INDUSTRY_SECONDARY ? ("รอง") : ("พิเศษ"), (!industryData[i][industryStatus]) ? ("{CD324D}ปิด{B4B5B7}") : ("{A4D247}เปิด{B4B5B7}"));
	Dialog_Show(playerid, TruckerPDADetail, DIALOG_STYLE_LIST, "Trucker PDA - อุตสาหกรรม", string, "เลือก", "กลับ");
}

ShowCargoShip(playerid)
{
	new string[1500];
	format(string, sizeof(string),
	""EMBED_WHITE"ยินดีต้อนรับสู่ {A4D247}The Ship"EMBED_WHITE"!\n\nปัจจุบันอุตสาหกรรมนี้ %s"EMBED_WHITE"\n\nเวลาต่อไปนี้เป็นการประมาณซึ่งไม่แน่นอน!\n\n",
	(!industryData[0][industryStatus]) ? ("{CD324D}ไม่อยู่ท่าเรือ") : ("{A4D247}เทียบท่า"));

	new gShipHour, gShipMinute, gShipSecond;

	if(!industryData[0][industryStatus])
	{
	    TimestampToTime(gShipTime + 2740, gShipHour, gShipMinute, gShipSecond);

	    format(string, sizeof(string), "%sเรือจะมาถึงเมื่อ:\t%02d:%02d:%02d\n\n", string, gShipHour, gShipMinute, gShipSecond);
	}
	else
	{
	    TimestampToTime(gShipTime, gShipHour, gShipMinute, gShipSecond);

	    format(string, sizeof(string), "%sเรือมาถึงเมื่อ:\t%02d:%02d:%02d\n", string, gShipHour, gShipMinute, gShipSecond);

        TimestampToTime(gShipTime + 2440, gShipHour, gShipMinute, gShipSecond);
		format(string, sizeof(string), "%sเรือออกเดินทางเมื่อ:\t%02d:%02d:%02d\n", string, gShipHour, gShipMinute, gShipSecond);

	    TimestampToTime(gShipTime + 2740, gShipHour, gShipMinute, gShipSecond);
	    format(string, sizeof(string), "%sจะมาถึงในครั้งถัดไปเมื่อ:\t%02d:%02d:%02d\n\n", string, gShipHour, gShipMinute, gShipSecond);
	}


	format(string, sizeof(string), "%s{A4D247}สำหรับขาย:\n{B4B5B7}The Ship ไม่ขายอะไรทั้งนั้น มันรับซื้อสินค้าจาก San Andreas เท่านั้น\n", string);


	format(string, sizeof(string),
	"%s\n{A4D247}ต้องการ:\n{B4B5B7}สินค้า\t\tราคา\t\tมีสินค้าในสต๊อก(ขนาดสต๊อก)\n",
	string);

	for(new i=0;i!=MAX_INDUSTRY_STORAGE;i++) if(industryStorageData[i][industryTradingType] && industryStorageData[i][industryID] == 0)
	{
			format(string, sizeof(string),
			"%s"EMBED_WHITE"%s%s$%d\t\t%d %s {B4B5B7}(%d)\n",
			string,
			g_arrItemNames[industryStorageData[i][industryItem]],
			(strlen(g_arrItemNames[industryStorageData[i][industryItem]]) < 13) ? ("\t\t"):("\t"),
			industryStorageData[i][industryPrice],
			industryStorageData[i][industryStock],
			Trucking_Unit(g_arrItemPackageType[industryStorageData[i][industryItem]]),
			industryStorageData[i][industryMaximum]);
	}
	SetPVarInt(playerid, "IndustrySelected", 0);
    Dialog_Show(playerid, TruckerPDAProcess, DIALOG_STYLE_MSGBOX, "The Ship", string, "ถัดไป", "ออก" );
	return 1;
}

Dialog:TruckerPDAProcess(playerid, response, listitem, inputtext[])
{
    new industryid = GetPVarInt(playerid, "IndustrySelected");
	if(response)
	{
        new string[1500], menu[10], count;
		for(new i=0;i!=MAX_INDUSTRY_STORAGE;i++)
		{
		    if(industryStorageData[i][industryID] == industryid) {

		        format(menu, 10, "menu%d", count);
		        SetPVarInt(playerid, menu, i);

				format(string, sizeof(string), "%s{B4B5B7}โกดัง {A4D247}%s{B4B5B7} ("EMBED_WHITE"%s{B4B5B7}, "EMBED_WHITE"$%d{B4B5B7} / หน่วย, "EMBED_WHITE"%d{B4B5B7} / %d)\n", string, g_arrItemNames[industryStorageData[i][industryItem]], (industryStorageData[i][industryTradingType]) ? ("ต้องการ"):("สำหรับขาย"), industryStorageData[i][industryPrice], industryStorageData[i][industryStock], industryStorageData[i][industryMaximum]);
                count++;
			}
		}
		Dialog_Show(playerid, TruckerPDANavigate, DIALOG_STYLE_LIST, "การนำทางอุตสาหกรรม", string, "นำทาง", "กลับ");
	}
	else {
	    if(!industryid) ShowTPDAMenu(playerid);
	    else ShowAllIndustry(playerid);
	}
	return 1;
}

Dialog:TruckerPDADetail(playerid, response, listitem, inputtext[])
{
	if(response) ShowIndustry(playerid, listitem + 1);
	else ShowTPDAMenu(playerid);
	return 1;
}

ShowIndustry(playerid, index)
{
	static string[900];
	format(string, sizeof(string),
	""EMBED_WHITE"ยินดีต้อนรับสู่ {A4D247}%s"EMBED_WHITE"!\n\nปัจจุบันอุตสาหกรรมนี้ %s\n\n{A4D247}สำหรับขาย:\n{B4B5B7}สินค้า\t\tราคา\tการผลิต/ชั่วโมง\tมีสินค้าในสต๊อก(ขนาดสต๊อก)\n",
	g_arrIndustryNames[index],
	(!industryData[index][industryStatus]) ? ("{CD324D}ปิด") : ("เปิด{A4D247}"));

	for(new i=0;i!=MAX_INDUSTRY_STORAGE;i++) if(industryStorageData[i][industryTradingType] == 0 && industryStorageData[i][industryID] == index) //For Sale
	{
	    new type = industryData[index][industryType];

		if(type == INDUSTRY_PRIMARY)
	    {
			format(string, sizeof(string),
			"%s"EMBED_WHITE"%s%s$%d\t+%d\t\t%d %s {B4B5B7}(%d)\n",
			string,
			g_arrItemNames[industryStorageData[i][industryItem]],
			(strlen(g_arrItemNames[industryStorageData[i][industryItem]]) - (CE_CountVowel(g_arrItemNames[industryStorageData[i][industryItem]])) <= 9) ? ("\t\t"):("\t"),
			industryStorageData[i][industryPrice],
			industryStorageData[i][industryConsumption],
			industryStorageData[i][industryStock],
			Trucking_Unit(g_arrItemPackageType[industryStorageData[i][industryItem]]),
			industryStorageData[i][industryMaximum]);
		}
		else
		{
			format(string, sizeof(string),
			"%s"EMBED_WHITE"%s%s$%d\t+%d {B4B5B7}ต่อทรัพยากร"EMBED_WHITE"\t%d %s {B4B5B7}(%d)\n",
			string,
			g_arrItemNames[industryStorageData[i][industryItem]],
			(strlen(g_arrItemNames[industryStorageData[i][industryItem]]) - (CE_CountVowel(g_arrItemNames[industryStorageData[i][industryItem]])) <= 9 ? ("\t\t"):("\t")),
			industryStorageData[i][industryPrice],
			industryStorageData[i][industryConsumption],
			industryStorageData[i][industryStock],
			Trucking_Unit(g_arrItemPackageType[industryStorageData[i][industryItem]]),
			industryStorageData[i][industryMaximum]);
	    }
	}

	format(string, sizeof(string),
	"%s\n{A4D247}ต้องการ:\n{B4B5B7}สินค้า\t\tราคา\tการผลิต/ชั่วโมง\tมีสินค้าในสต๊อก(ขนาดสต๊อก)\n",
	string);

	for(new i=0;i!=MAX_INDUSTRY_STORAGE;i++) if(industryStorageData[i][industryTradingType] != 0 && industryStorageData[i][industryID] == index) //Wanted
	{
	    new type = industryData[index][industryType];

	    if(type == INDUSTRY_PRIMARY)
	    {
			format(string, sizeof(string), "%s{B4B5B7}นี่เป็นอุตสาหกรรมหลักและไม่จำเป็นต้องมีทรัพยากรใด ๆ", string);
			break;
		}
		else
		{
			format(string, sizeof(string),
			"%s"EMBED_WHITE"%s%s$%d\t-%d {B4B5B7}หน่วย"EMBED_WHITE"\t\t%d %s {B4B5B7}(%d)\n",
			string,
			g_arrItemNames[industryStorageData[i][industryItem]],
			(strlen(g_arrItemNames[industryStorageData[i][industryItem]]) - (CE_CountVowel(g_arrItemNames[industryStorageData[i][industryItem]])) <= 9) ? ("\t\t"):("\t"),
			industryStorageData[i][industryPrice],
			industryStorageData[i][industryConsumption],
			industryStorageData[i][industryStock],
			Trucking_Unit(g_arrItemPackageType[industryStorageData[i][industryItem]]),
			industryStorageData[i][industryMaximum]);
	    }
	}
	SetPVarInt(playerid, "IndustrySelected", index);
    Dialog_Show(playerid, TruckerPDAProcess, DIALOG_STYLE_MSGBOX, g_arrIndustryNames[index], string, "ถัดไป", "ออก" );
}

task ShipTimer[1000]() 
{
	new tmphour, tmpminute, tmpsecond;
	gettime(tmphour, tmpminute, tmpsecond);

	new gShipHour, gShipMinute, gShipSecond;
	TimestampToTime(gShipTime + 2400, gShipHour, gShipMinute, gShipSecond);
	if (!gShipDeparture && tmphour == gShipHour && tmpminute == gShipMinute && tmpsecond == gShipSecond) 
	{
		RampsClosed();
	}
}

task IndustryTimer[3600000]() {
	for(new i=0;i!=MAX_INDUSTRY_STORAGE;i++) {
		
		if(industryStorageData[i][industryTradingType]) industryStorageData[i][industryStock]-=industryStorageData[i][industryConsumption];
		else industryStorageData[i][industryStock]+=industryStorageData[i][industryConsumption];
		
		if(industryStorageData[i][industryStock] > industryStorageData[i][industryMaximum]) industryStorageData[i][industryStock]=industryStorageData[i][industryMaximum];
		else if(industryStorageData[i][industryStock] < 0) industryStorageData[i][industryStock]=0;
		
		Trucking_UpdateIndustry(i);
	}
}

// CARGO SHIP

forward StartMovingTimer();
public StartMovingTimer()
{
	MoveObject(gMainShipObjectId,gShipRoutePoints[gShipCurrentPoint][0],
	                           gShipRoutePoints[gShipCurrentPoint][1],
							   gShipRoutePoints[gShipCurrentPoint][2],
							   SPEED_CARGOSHIP / 2, // slower for the first route
							   gShipRoutePoints[gShipCurrentPoint][3],
							   gShipRoutePoints[gShipCurrentPoint][4],
							   gShipRoutePoints[gShipCurrentPoint][5]);
}

//-------------------------------------------------

hook OnDynamicObjectMoved(objectid)
{
	if(objectid == gShipRamp1)
	{
		industryData[0][industryStatus] = !!!gShipDeparture;

	    if(gShipDeparture) {

			StartMovingTimer();

			SetDynamicObjectMaterialText(gShipTextLine1, 0, "OCEAN DOCKS SHIP", OBJECT_MATERIAL_SIZE_256x256, "Arial", 16, 1, 0xFFFFFFFF, 0, 1);
   			SetDynamicObjectMaterialText(gShipTextLine2, 0, "", OBJECT_MATERIAL_SIZE_256x256, "Arial", 16, 1, 0xFFFFFFFF, 0, 1);

			for(new i=0;i!=MAX_INDUSTRY_STORAGE;i++) if(industryStorageData[i][industryID] == 0) {
				DestroyDynamicPickup(industryStorageData[i][industryPickup]);
				DestroyDynamic3DTextLabel(industryStorageData[i][industryLabel]);
			}
		}
		else
		{
			new string[128];
			for(new i=0;i!=MAX_INDUSTRY_STORAGE;i++) if(industryStorageData[i][industryID] == 0)
			{
			    industryStorageData[i][industryStock]=0;

				industryStorageData[i][industryPickup] = CreateDynamicPickup(1318, 23, industryStorageData[i][industryPosX],industryStorageData[i][industryPosY], industryStorageData[i][industryPosZ], 0, 0);
				format(string, 128, "["EMBED_LIMEGREEN"%s"EMBED_WHITE"]\nความจุโกดัง: %d / %d\nราคา: %s / หน่วย", g_arrItemNames[industryStorageData[i][industryItem]], industryStorageData[i][industryStock], industryStorageData[i][industryMaximum], FormatNumber(industryStorageData[i][industryPrice]));
				industryStorageData[i][industryLabel] = CreateDynamic3DTextLabel(string, -1, industryStorageData[i][industryPosX],industryStorageData[i][industryPosY], industryStorageData[i][industryPosZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 100.0);
			}
		}
	}
	return 1;
}


hook OnObjectMoved(objectid)
{
	if(objectid == gMainShipObjectId) {

		gShipCurrentPoint++;

		if(gShipCurrentPoint == NUM_SHIP_ROUTE_POINTS) {
			gShipCurrentPoint = 0;

			MoveObject(gMainShipObjectId,gShipRoutePoints[gShipCurrentPoint][0],
								gShipRoutePoints[gShipCurrentPoint][1],
								gShipRoutePoints[gShipCurrentPoint][2],
								SPEED_CARGOSHIP / 5, // slower for the last route
								gShipRoutePoints[gShipCurrentPoint][3],
								gShipRoutePoints[gShipCurrentPoint][4],
								gShipRoutePoints[gShipCurrentPoint][5]);
			return 1;
		}

		if(gShipCurrentPoint == 1) {

			gShipDeparture = false;

			MoveDynamicObject(gShipRamp1,2810.9445, -2387.2998, 12.6255, 0.01, -20.4000, 0.0000, -90.3000);
			MoveDynamicObject(gShipRamp2,2810.6875, -2436.9775, 12.6250, 0.01, -20.4000, 0.0000, -90.3000);
			gShipTime = gettime();
			

			new gShipHour, gShipMinute, gShipSecond;
			TimestampToTime(gShipTime + 2440, gShipHour, gShipMinute, gShipSecond);
			SetDynamicObjectMaterialText(gShipTextLine2, 0, sprintf("เรือออกเดินทางเมื่อ: %02d:%02d:%02d", gShipHour, gShipMinute, gShipSecond), OBJECT_MATERIAL_SIZE_256x256, "Arial", 14, 1, 0xFFFFFFFF, 0, 1);

			TimestampToTime(gShipTime + 2740, gShipHour, gShipMinute, gShipSecond);
			SetDynamicObjectMaterialText(gShipTextLine3, 0, sprintf("จะมาถึงในครั้งถัดไปเมื่อ: %02d:%02d:%02d", gShipHour, gShipMinute, gShipSecond), OBJECT_MATERIAL_SIZE_256x256, "Arial", 14, 1, 0xFFFFFFFF, 0, 1);
			return 1;
		}

		MoveObject(gMainShipObjectId,gShipRoutePoints[gShipCurrentPoint][0],
	                           gShipRoutePoints[gShipCurrentPoint][1],
							   gShipRoutePoints[gShipCurrentPoint][2],
							   SPEED_CARGOSHIP / 2,
							   gShipRoutePoints[gShipCurrentPoint][3],
							   gShipRoutePoints[gShipCurrentPoint][4],
							   gShipRoutePoints[gShipCurrentPoint][5]);
	}
 	return 1;
}

forward RampsClosed();
public RampsClosed()
{
	foreach(new i : Player)
	{
	    if(IsPlayerInRangeOfPoint(i, 100.0, 2809.9849,-2391.3201,13.6282) || IsPlayerInRangeOfPoint(i, 30.0, 2810.5256,-2440.7012,13.6328))
	    {
	        SendClientMessage(i, COLOR_GRAD1, "___________________________________________________________________________________");
			SendClientMessage(i, COLOR_RED, "ข้อควรระวัง! เรือกำลังจะออกเดินทางในอีก 40 วินาที ! สะพานจะปิดในอีก 20 วินาที !");
            SendClientMessage(i, COLOR_WHITE, "หากคุณตัดสินใจต้องการอยู่บนเรือ กรุณาอย่ากระโดดในขณะที่เรือกำลังเคลื่อนที่และมันอาจฆ่าคุณได้");
            SendClientMessage(i, COLOR_WHITE, "\"อย่านั่งบนยานพาหนะใด ๆ ในขณะที่เรือกำลังเคลื่อนตัว !\"");
            SendClientMessage(i, COLOR_GRAD1, "___________________________________________________________________________________");

            GameTextForPlayer(i, "~r~attention!~n~~w~ship departs~n~in 40 seconds!", 5000, 1);
		}
	}
	SetTimer("RampsClosing",20000, 0);
}

forward RampsClosing();
public RampsClosing()
{
	foreach(new i : Player)
	{
	    if(IsPlayerInRangeOfPoint(i, 100.0, 2809.9849,-2391.3201,13.6282) || IsPlayerInRangeOfPoint(i, 30.0, 2810.5256,-2440.7012,13.6328))
	    {
	        SendClientMessage(i, COLOR_GRAD1, "___________________________________________________________________________________");
			SendClientMessage(i, COLOR_RED, "ข้อควรระวัง! เรือกำลังจะออกเดินทางในอีก 20 วินาที ! สะพานได้ปิดลงแล้ว!");
            SendClientMessage(i, COLOR_WHITE, "หากคุณตัดสินใจต้องการอยู่บนเรือ กรุณาอย่ากระโดดในขณะที่เรือกำลังเคลื่อนที่และมันอาจฆ่าคุณได้");
            SendClientMessage(i, COLOR_WHITE, "\"อย่านั่งบนยานพาหนะใด ๆ ในขณะที่เรือกำลังเคลื่อนตัว !\"");
            SendClientMessage(i, COLOR_GRAD1, "___________________________________________________________________________________");
            GameTextForPlayer(i, "~r~attention!~n~~w~ship departs~n~in 20 seconds!", 5000, 1);
		}
	}
	gShipDeparture = true;
	MoveDynamicObject(gShipRamp1,2810.9445, -2387.2998, 12.6255-0.1, 0.01, 49.6999, 0.0000, -90.3000);
	MoveDynamicObject(gShipRamp2,2810.6875, -2436.9775, 12.6250-0.1, 0.01, 49.6999, 0.0000, -90.3000);
}

CMD:truckerjob(playerid)
{
	if(playerData[playerid][pJob] != 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "   คุณมีอาชีพอยู่แล้ว พิมพ์ /leavejob เพื่อออกจากอาชีพ");

	new faction = playerData[playerid][pFaction];
	if (faction != 0 && Faction_GetTypeID(playerData[playerid][pFaction]) != FACTION_TYPE_GANG)
	    return SendClientMessage(playerid, COLOR_WHITE, "ขออภัย อาชีพนี้สำหรับประชาชนเท่านั้น (ใครก็ตามที่ไม่ได้อยู่ในกลุ่มของทางการ)");

	if (IsPlayerInRangeOfPoint(playerid, 3.0, -78.0338,-1136.1221,1.0781)) {

        playerData[playerid][pJob] = JOB_TRUCKER;
        SendClientMessageEx(playerid, -1, "ตอนนี้คุณเป็น %s แล้ว", ReturnJobName(playerData[playerid][pJob]));
		return 1;
	}
	else
	{
		TruckerMissionX[playerid] = -78.0338;
		TruckerMissionY[playerid] = -1136.1221;
		TruckerMissionZ[playerid] = 1.0781;

	    SetPlayerRaceCheckpoint(playerid, 2, -78.0338,-1136.1221,1.0781,0,0,0,2.5);
	}
	return 1;
}

CMD:industry(playerid, params[])
{
	new i = -1;

	if((i = Industry_Nearest(playerid)) != -1) {
		ShowIndustry(playerid, industryStorageData[i][industryID]);
	}
	return 1;
}