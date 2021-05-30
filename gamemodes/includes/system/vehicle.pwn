#include <YSI\y_hooks>

/* Vehicle Exterior Define */

// Vehicle Label Timer
#define VLT_TYPE_TOWING  			1
#define VLT_TYPE_PERMITFACTION		2
#define VLT_TYPE_LOCK		  		3
#define VLT_TYPE_UNREGISTER    		4
#define VLT_TYPE_REGISTER           5
#define VLT_TYPE_OPERAFAILED	  	6
#define VLT_TYPE_UPGRADELOCK      	7
#define VLT_TYPE_UPGRADEALARM     	8
#define VLT_TYPE_UPGRADEIMMOB       9
#define VLT_TYPE_UPGRADEINSURANCE 	10
#define VLT_TYPE_BREAKIN		 	11
#define VLT_TYPE_ARMOUR			 	12
#define VLT_TYPE_REFILL			 	13
#define VLT_TYPE_OPERAOUTOFRANG    	14
#define VLT_TYPE_UPGRADEBATTERY     15
#define VLT_TYPE_UPGRADEENGINE  	16
#define	VLT_TYPE_VEHICLELOCK		17
/* Vehicle Exterior Define */

#define MAX_ADMIN_VEHICLES 50
#define MAX_DYNAMIC_VEHICLES 1000

new AdminSpawnedVehicles[MAX_ADMIN_VEHICLES];
new Iterator:Iter_ServerCar<MAX_DYNAMIC_VEHICLES>;

enum E_CAR_DATA {
    vVehicleID,
	vVehicleModelID,
	Float: vVehiclePosition[3],
	Float: vVehicleRotation,
	vVehicleFaction,
    vVehicleFactionID,
	vVehicleColour[2],
	vVehicleScriptID,
	vVehicleWorld,
	vVehicleInterior
}
new vehicleVariables[MAX_DYNAMIC_VEHICLES][E_CAR_DATA];

enum c_data {
	c_price,
	Float:c_maxhp,
	Float:c_engine,
	Float:c_battery,
	Float:c_maxfuel,
	Float:c_fuelrate,
	c_scrap // {10000, 740.0, 50.0, 100.0, 2.0, 49.0, 5000},
};

static const VehicleData[][c_data] =
{
	{180000, 1120.0, 100.0, 100.0, 22.0, 13.0, 90000},
	{40000, 900.0, 75.0, 100.0, 15.0, 9.0, 20000},
	{420000, 910.0, 100.0, 100.0, 19.0, 3.0, 210000},
	{750000, 2000.0, 100.0, 100.0, 100.0, 4.0, 375000},
	{80000, 900.0, 75.0, 100.0, 100.0, 15.0, 40000},
	{135000, 940.0, 100.0, 100.0, 17.0, 8.0, 67500},
	{0, 2000.0, 100.0, 100.0, 100.0, 4.0, 0},
	{340000, 1800.0, 100.0, 100.0, 100.0, 11.0, 170000},
	{140900, 2000.0, 100.0, 100.0, 100.0, 3.0, 70450},
	{280000, 1000.0, 100.0, 100.0, 23.0, 11.0, 140000},
	{35000, 900.0, 75.0, 100.0, 14.0, 10.0, 17500},
	{605500, 800.0, 100.0, 100.0, 24.0, 3.0, 302750},
	{65000, 900.0, 75.0, 100.0, 15.0, 6.0, 32500},
	{110000, 1400.0, 100.0, 100.0, 32.0, 20.0, 55000},
	{175000, 1700.0, 100.0, 100.0, 100.0, 17.0, 87500},
	{850000, 800.0, 100.0, 100.0, 23.0, 4.0, 425000},
	{54500, 1300.0, 100.0, 100.0, 65.0, 20.0, 27250},
	{1000000, 1300.0, 100.0, 100.0, 100.0, 0.0, 500000},
	{80000, 1000.0, 100.0, 100.0, 26.0, 23.0, 40000},
	{50000, 900.0, 75.0, 100.0, 16.0, 8.0, 25000},
	{45000, 910.0, 100.0, 100.0, 17.0, 14.0, 22500},
	{100000, 940.0, 100.0, 100.0, 16.0, 8.0, 50000},
	{60000, 1200.0, 100.0, 100.0, 25.0, 13.0, 30000},
	{80000, 1400.0, 100.0, 100.0, 35.0, 26.0, 40000},
	{19000, 900.0, 100.0, 100.0, 9.0, 15.0, 9500},
	{10000000, 1700.0, 100.0, 100.0, 100.0, 0.0, 5000000},
	{135000, 930.0, 100.0, 100.0, 16.0, 8.0, 67500},
	{500000, 1650.0, 100.0, 100.0, 56.0, 15.0, 250000},
	{275500, 1800.0, 100.0, 100.0, 55.0, 10.0, 137750},
	{850000, 800.0, 100.0, 100.0, 23.0, 3.0, 425000},
	{450000, 1200.0, 100.0, 100.0, 80.0, 0.0, 225000},
	{70000, 2000.0, 100.0, 100.0, 100.0, 3.0, 35000},
	{50000000, 5000.0, 100.0, 100.0, 100.0, 3.0, 25000000},
	{7500000, 2200.0, 100.0, 100.0, 100.0, 7.0, 3750000},
	{225000, 880.0, 100.0, 100.0, 10.0, 14.0, 112500},
	{115000, 0.0, 100.0, 100.0, 0.0, 0.0, 57500},
	{40000, 900.0, 75.0, 100.0, 15.0, 9.0, 20000},
	{75000, 2000.0, 100.0, 100.0, 100.0, 2.0, 37500},
	{50000, 910.0, 100.0, 100.0, 17.0, 13.0, 25000},
	{80000, 930.0, 100.0, 100.0, 17.0, 7.0, 40000},
	{100000, 1400.0, 100.0, 100.0, 34.0, 12.0, 50000},
	{15000, 700.0, 100.0, 100.0, 100.0, 0.0, 7500},
	{75000, 1000.0, 100.0, 100.0, 18.0, 10.0, 37500},
	{200000, 2000.0, 100.0, 100.0, 100.0, 9.0, 100000},
	{300000, 1300.0, 100.0, 100.0, 26.0, 6.0, 150000},
	{45000, 910.0, 100.0, 100.0, 16.0, 8.0, 22500},
	{1000000, 850.0, 100.0, 100.0, 75.0, 0.0, 500000},
	{12000000, 850.0, 100.0, 100.0, 46.0, 0.0, 6000000},
	{12999, 740.0, 50.0, 100.0, 2.0, 49.0, 6499},
	{35000000, 1200.0, 100.0, 100.0, 7.0, 12.0, 17500000},
	{115000, 0.0, 100.0, 100.0, 0.0, 0.0, 57500},
	{655500, 800.0, 100.0, 100.0, 23.0, 3.0, 327750},
	{450000, 850.0, 100.0, 100.0, 68.0, 0.0, 225000},
	{180000, 1250.0, 100.0, 100.0, 100.0, 0.0, 90000},
	{299999, 1250.0, 100.0, 100.0, 100.0, 0.0, 149999},
	{3000000, 2000.0, 100.0, 100.0, 100.0, 2.0, 1500000},
	{400000, 1700.0, 100.0, 100.0, 100.0, 14.0, 200000},
	{15000, 800.0, 100.0, 100.0, 0.0, 0.0, 7500},
	{90000, 920.0, 100.0, 100.0, 17.0, 12.0, 45000},
	{60000, 1400.0, 100.0, 100.0, 32.0, 24.0, 30000},
	{3500000, 850.0, 100.0, 100.0, 100.0, 6.0, 1750000},
	{250000, 720.0, 50.0, 100.0, 5.0, 45.0, 125000},
	{10000, 740.0, 50.0, 100.0, 2.0, 49.0, 5000},
	{50000, 740.0, 50.0, 100.0, 5.0, 40.0, 25000},
	{12000, 700.0, 100.0, 100.0, 2.0, 25.0, 6000},
	{12000, 700.0, 100.0, 100.0, 2.0, 25.0, 6000},
	{50000, 900.0, 75.0, 100.0, 14.0, 8.0, 25000},
	{35000, 900.0, 75.0, 100.0, 15.0, 8.0, 17500},
	{165000, 710.0, 50.0, 100.0, 4.0, 45.0, 82500},
	{0, 0.0, 100.0, 100.0, 45.0, 10.0, 0},
	{0, 1650.0, 100.0, 100.0, 26.0, 10.0, 0},
	{100000, 700.0, 50.0, 100.0, 4.0, 48.0, 50000},
	{150000, 1250.0, 100.0, 100.0, 100.0, 15.0, 75000},
	{20000, 750.0, 50.0, 100.0, 13.0, 18.0, 10000},
	{60000, 910.0, 75.0, 100.0, 16.0, 8.0, 30000},
	{160000, 900.0, 100.0, 100.0, 17.0, 3.0, 80000},
	{0, 850.0, 100.0, 100.0, 100.0, 6.0, 0},
	{700000, 830.0, 100.0, 100.0, 17.0, 3.0, 350000},
	{40000, 1200.0, 100.0, 100.0, 25.0, 25.0, 20000},
	{85000, 910.0, 75.0, 100.0, 17.0, 14.0, 42500},
	{625000, 800.0, 100.0, 100.0, 18.0, 9.0, 312500},
	{700, 500.0, 50.0, 100.0, 0.0, 0.0, 350},
	{120000, 1400.0, 100.0, 100.0, 32.0, 12.0, 60000},
	{85000, 1100.0, 100.0, 100.0, 43.0, 12.0, 42500},
	{350000, 750.0, 100.0, 100.0, 100.0, 6.0, 175000},
	{0, 890.0, 100.0, 100.0, 0.0, 0.0, 0},
	{0, 1900.0, 100.0, 100.0, 21.0, 7.0, 0},
	{3500000, 980.0, 100.0, 100.0, 48.0, 6.0, 1750000},
	{1000000, 900.0, 100.0, 100.0, 48.0, 6.0, 500000},
	{110000, 1110.0, 100.0, 100.0, 23.0, 10.0, 55000},
	{255000, 1430.0, 100.0, 100.0, 28.0, 9.0, 127500},
	{41000, 900.0, 75.0, 100.0, 15.0, 8.0, 20500},
	{47000, 900.0, 75.0, 100.0, 15.0, 8.0, 23500},
	{0, 850.0, 100.0, 100.0, 70.0, 11.0, 0},
	{0, 800.0, 100.0, 100.0, 17.0, 3.0, 0},
	{0, 1000.0, 100.0, 100.0, 23.0, 12.0, 0},
	{140000, 800.0, 100.0, 100.0, 11.0, 4.0, 70000},
	{3650000, 0.0, 100.0, 100.0, 49.0, 6.0, 1825000},
	{110000, 1400.0, 100.0, 100.0, 100.0, 6.0, 55000},
	{90000, 1400.0, 100.0, 100.0, 100.0, 17.0, 45000},
	{140000, 920.0, 100.0, 100.0, 19.0, 14.0, 70000},
	{0, 700.0, 100.0, 100.0, 0.0, 25.0, 0},
	{0, 800.0, 100.0, 100.0, 17.0, 3.0, 0},
	{0, 800.0, 100.0, 100.0, 17.0, 3.0, 0},
	{0, 850.0, 100.0, 100.0, 15.0, 7.0, 0},
	{110000, 1110.0, 100.0, 100.0, 15.0, 10.0, 55000},
	{0, 800.0, 100.0, 100.0, 23.0, 3.0, 0},
	{155000, 850.0, 100.0, 100.0, 20.0, 7.0, 77500},
	{180000, 1200.0, 100.0, 100.0, 76.0, 17.0, 90000},
	{1000, 500.0, 50.0, 100.0, 0.0, 0.0, 500},
	{0, 500.0, 50.0, 100.0, 0.0, 0.0, 0},
	{5000000, 850.0, 100.0, 100.0, 100.0, 4.0, 2500000},
	{0, 850.0, 100.0, 100.0, 97.0, 6.0, 0},
	{0, 820.0, 100.0, 100.0, 73.0, 6.0, 0},
	{800000, 2000.0, 100.0, 100.0, 100.0, 4.0, 400000},
	{900000, 2000.0, 100.0, 100.0, 100.0, 3.0, 450000},
	{40000, 900.0, 100.0, 100.0, 18.0, 9.0, 20000},
	{65000, 900.0, 75.0, 100.0, 15.0, 9.0, 32500},
	{45000, 900.0, 75.0, 100.0, 16.0, 8.0, 22500},
	{0, 1200.0, 100.0, 100.0, 100.0, 3.0, 0},
	{0, 1300.0, 100.0, 100.0, 100.0, 4.0, 0},
	{200000, 710.0, 75.0, 100.0, 5.0, 45.0, 100000},
	{400000, 700.0, 75.0, 100.0, 5.0, 48.0, 200000},
	{50000, 0.0, 50.0, 100.0, 7.0, 20.0, 25000},
	{0, 2000.0, 100.0, 100.0, 100.0, 3.0, 0},
	{30000, 1160.0, 100.0, 100.0, 26.0, 17.0, 15000},
	{55000, 900.0, 100.0, 100.0, 15.0, 8.0, 27500},
	{45000, 900.0, 75.0, 100.0, 15.0, 9.0, 22500},
	{500000, 0.0, 100.0, 100.0, 29.0, 15.0, 250000},
	{45000, 900.0, 75.0, 100.0, 15.0, 8.0, 22500},
	{0, 850.0, 100.0, 100.0, 0.0, 0.0, 0},
	{43000, 800.0, 100.0, 100.0, 18.0, 23.0, 21500},
	{25000, 1900.0, 100.0, 100.0, 25.0, 9.0, 12500},
	{65000, 830.0, 100.0, 100.0, 17.0, 8.0, 32500},
	{75000, 925.0, 100.0, 100.0, 16.0, 6.0, 37500},
	{110000, 940.0, 100.0, 100.0, 23.0, 6.0, 55000},
	{65000, 880.0, 75.0, 100.0, 14.0, 7.0, 32500},
	{0, 2000.0, 100.0, 100.0, 100.0, 12.0, 0},
	{0, 2000.0, 100.0, 100.0, 100.0, 12.0, 0},
	{0, 800.0, 100.0, 100.0, 15.0, 12.0, 0},
	{51000, 900.0, 75.0, 100.0, 16.0, 8.0, 25500},
	{1200000, 800.0, 100.0, 100.0, 24.0, 4.0, 600000},
	{135000, 900.0, 75.0, 100.0, 15.0, 8.0, 67500},
	{25000, 1200.0, 100.0, 100.0, 25.0, 13.0, 12500},
	{0, 1800.0, 100.0, 100.0, 25.0, 11.0, 0},
	{85000, 880.0, 100.0, 100.0, 14.0, 13.0, 42500},
	{46000, 910.0, 75.0, 100.0, 15.0, 8.0, 23000},
	{38000, 900.0, 75.0, 100.0, 16.0, 8.0, 19000},
	{0, 1450.0, 100.0, 100.0, 100.0, 2.0, 0},
	{38000, 900.0, 75.0, 100.0, 14.0, 8.0, 19000},
	{55000, 900.0, 100.0, 100.0, 15.0, 8.0, 27500},
	{150000, 950.0, 100.0, 100.0, 19.0, 8.0, 75000},
	{50000, 1270.0, 100.0, 100.0, 12.0, 20.0, 25000},
	{0, 1500.0, 100.0, 100.0, 100.0, 2.0, 0},
	{110000, 1280.0, 100.0, 100.0, 26.0, 9.0, 55000},
	{450000, 820.0, 75.0, 100.0, 15.0, 9.0, 225000},
	{0, 1300.0, 100.0, 100.0, 26.0, 6.0, 0},
	{0, 1300.0, 100.0, 100.0, 26.0, 6.0, 0},
	{330000, 810.0, 100.0, 100.0, 18.0, 3.0, 165000},
	{200000, 810.0, 100.0, 100.0, 17.0, 3.0, 100000},
	{785000, 880.0, 100.0, 100.0, 16.0, 7.0, 392500},
	{110000, 920.0, 100.0, 100.0, 18.0, 12.0, 55000},
	{220000, 880.0, 100.0, 100.0, 18.0, 9.0, 110000},
	{0, 1350.0, 100.0, 100.0, 100.0, 4.0, 0},
	{0, 700.0, 100.0, 100.0, 2.0, 0.0, 0},
	{180000, 810.0, 100.0, 100.0, 13.0, 3.0, 90000},
	{65000, 900.0, 75.0, 100.0, 15.0, 6.0, 32500},
	{85000, 905.0, 75.0, 100.0, 15.0, 7.0, 42500},
	{500000, 850.0, 100.0, 100.0, 8.0, 16.0, 250000},
	{0, 0.0, 100.0, 100.0, 0.0, 12.0, 0},
	{0, 0.0, 100.0, 100.0, 0.0, 0.0, 0},
	{0, 700.0, 100.0, 100.0, 4.0, 22.0, 0},
	{0, 750.0, 100.0, 100.0, 8.0, 18.0, 0},
	{0, 1300.0, 100.0, 100.0, 29.0, 4.0, 0},
	{0, 750.0, 100.0, 100.0, 8.0, 18.0, 0},
	{80000, 900.0, 75.0, 100.0, 16.0, 6.0, 40000},
	{58000, 890.0, 75.0, 100.0, 15.0, 6.0, 29000},
	{0, 1500.0, 100.0, 100.0, 100.0, 1.0, 0},
	{500000, 1800.0, 100.0, 100.0, 100.0, 12.0, 250000},
	{300000, 1150.0, 100.0, 100.0, 25.0, 10.0, 150000},
	{200000, 970.0, 100.0, 100.0, 22.0, 7.0, 100000},
	{0, 710.0, 50.0, 100.0, 4.0, 45.0, 0},
	{80000, 1300.0, 100.0, 100.0, 29.0, 24.0, 40000},
	{0, 750.0, 100.0, 100.0, 8.0, 18.0, 0},
	{0, 0.0, 100.0, 100.0, 0.0, 0.0, 0},
	{60000, 915.0, 100.0, 100.0, 16.0, 8.0, 30000},
	{50000, 740.0, 50.0, 100.0, 7.0, 40.0, 25000},
	{250000, 820.0, 100.0, 100.0, 17.0, 3.0, 125000},
	{80000, 1200.0, 100.0, 100.0, 29.0, 12.0, 40000},
	{160000, 850.0, 100.0, 100.0, 14.0, 3.0, 80000},
	{0, 0.0, 100.0, 100.0, 0.0, 0.0, 0},
	{0, 0.0, 100.0, 100.0, 0.0, 0.0, 0},
	{0, 1500.0, 100.0, 100.0, 100.0, 1.0, 0},
	{4000000, 850.0, 100.0, 100.0, 100.0, 6.0, 2000000},
	{0, 700.0, 100.0, 100.0, 2.0, 50.0, 0},
	{0, 1250.0, 100.0, 100.0, 100.0, 11.0, 0},
	{99999, 1110.0, 100.0, 100.0, 17.0, 13.0, 50000},
	{99999, 1110.0, 100.0, 100.0, 17.0, 13.0, 50000},
	{99999, 1110.0, 100.0, 100.0, 17.0, 13.0, 50000},
	{135000, 1220.0, 100.0, 100.0, 25.0, 21.0, 67500},
	{38000, 920.0, 100.0, 100.0, 22.0, 7.0, 19000},
	{750000, 3500.0, 100.0, 100.0, 100.0, 13.0, 375000},
	{330000, 820.0, 100.0, 100.0, 20.0, 3.0, 165000},
	{650000, 950.0, 100.0, 100.0, 19.0, 3.0, 325000},
	{0, 0.0, 75.0, 100.0, 14.0, 8.0, 0},
	{0, 1200.0, 100.0, 100.0, 25.0, 26.0, 0},
	{0, 0.0, 100.0, 100.0, 0.0, 0.0, 0},
	{0, 0.0, 100.0, 100.0, 0.0, 0.0, 0},
	{0, 0.0, 100.0, 100.0, 0.0, 0.0, 0},
	{0, 1650.0, 100.0, 100.0, 100.0, 12.0, 0},
	{0, 0.0, 100.0, 100.0, 0.0, 0.0, 0},
	{0, 0.0, 100.0, 100.0, 0.0, 0.0, 0}

};

hook OnGameModeInit() {

	mysql_query(dbCon, "SELECT * FROM `vehicle`");

	new
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_VEHICLES)
	{
	    cache_get_value_name_int(i, "vehicleID", vehicleVariables[i][vVehicleID]);
	    cache_get_value_name_int(i, "vehicleModelID", vehicleVariables[i][vVehicleModelID]);
	    cache_get_value_name_float(i, "vehiclePosX", vehicleVariables[i][vVehiclePosition][0]);
	    cache_get_value_name_float(i, "vehiclePosY", vehicleVariables[i][vVehiclePosition][1]);
	    cache_get_value_name_float(i, "vehiclePosZ", vehicleVariables[i][vVehiclePosition][2]);
	    cache_get_value_name_float(i, "vehiclePosRotation", vehicleVariables[i][vVehicleRotation]);

	    cache_get_value_name_int(i, "vehicleFaction", vehicleVariables[i][vVehicleFaction]);

	    cache_get_value_name_int(i, "vehicleCol1", vehicleVariables[i][vVehicleColour][0]);
	    cache_get_value_name_int(i, "vehicleCol2", vehicleVariables[i][vVehicleColour][1]);
	    cache_get_value_name_int(i, "vehicleWorld", vehicleVariables[i][vVehicleWorld]);
	    cache_get_value_name_int(i, "vehicleInterior", vehicleVariables[i][vVehicleInterior]);

	    vehicleVariables[i][vVehicleFactionID] = -1;

	    if(vehicleVariables[i][vVehicleColour][0] < 0) {
	    	vehicleVariables[i][vVehicleColour][0] = random(126);
	    }
	    if(vehicleVariables[i][vVehicleColour][1] < 0) {
	    	vehicleVariables[i][vVehicleColour][1] = random(126);
	    }

	    vehicleVariables[i][vVehicleScriptID] = CreateVehicle(vehicleVariables[i][vVehicleModelID], vehicleVariables[i][vVehiclePosition][0], vehicleVariables[i][vVehiclePosition][1], vehicleVariables[i][vVehiclePosition][2], vehicleVariables[i][vVehicleRotation], vehicleVariables[i][vVehicleColour][0], vehicleVariables[i][vVehicleColour][1], 60000);

	    LinkVehicleToInterior(vehicleVariables[i][vVehicleScriptID], vehicleVariables[i][vVehicleInterior]);
	    SetVehicleVirtualWorld(vehicleVariables[i][vVehicleScriptID], vehicleVariables[i][vVehicleWorld]);

	    if(vehicleVariables[i][vVehicleFaction] != 0) {
			foreach(new x : Iter_Faction) {
				if(factionData[x][fID] == vehicleVariables[i][vVehicleFaction]) {
					vehicleVariables[i][vVehicleFactionID] = x;
					break;
				}
			}
			if (vehicleVariables[i][vVehicleFactionID] != -1) {
				SetVehicleNumberPlate(vehicleVariables[i][vVehicleScriptID], factionData[vehicleVariables[i][vVehicleFactionID]][fShortName]);
			}
	    }
	    else {
	    	new plate[8];
	    	format(plate, sizeof(plate), Vehicle_RandomPlate());
	    	SetVehicleNumberPlate(vehicleVariables[i][vVehicleScriptID], plate);
	    }

		SetEngineStatus(vehicleVariables[i][vVehicleScriptID], false);
		// SetLockStatus(vehicleVariables[i][vVehicleScriptID], false);

		Vehicle_ResetVehicle(vehicleVariables[i][vVehicleScriptID]);
        Iter_Add(Iter_ServerCar, i);
	}
    printf("Vehicle loaded (%d/%d)", Iter_Count(Iter_ServerCar), MAX_VEHICLES);
	return 1;
}

flags:veh(CMD_ADM_3);
CMD:veh(playerid, params[]) {

    new
    	carid[32],
    	Float: carSpawnPos[4],
    	color1,
    	color2
    ;

    if (!sscanf(params, "s[32]I(-1)I(-1)", carid, color1, color2)) {

        if ((carid[0] = GetVehicleModelByName(carid)) == 0)
            return SendClientMessage(playerid, COLOR_GREY, "   เลขยานพาหนะต้องไม่ต่ำกว่า 400 หรือมากกว่า 611 ! ");

        for(new i=0;i!=MAX_ADMIN_VEHICLES;i++) if(!AdminSpawnedVehicles[i])
        {
        	GetPlayerPos(playerid, carSpawnPos[0], carSpawnPos[1], carSpawnPos[2]);
        	GetPlayerFacingAngle(playerid, carSpawnPos[3]);

            if(color1 < 0) {
                color1 = random(126);
            }
            if(color2 < 0) {
                color2 = random(126);
            }
            
        	AdminSpawnedVehicles[i] = CreateVehicle(carid[0], carSpawnPos[0], carSpawnPos[1], carSpawnPos[2], carSpawnPos[3], color1, color2, -1);
        	LinkVehicleToInterior(AdminSpawnedVehicles[i], GetPlayerInterior(playerid));
        	SetVehicleVirtualWorld(AdminSpawnedVehicles[i], GetPlayerVirtualWorld(playerid));

        	PutPlayerInVehicle(playerid, AdminSpawnedVehicles[i], 0);

        	new
        		engine,
        		lights,
        		alarm,
        		doors,
        		bonnet,
        		boot,
        		objective;

        	GetVehicleParamsEx(AdminSpawnedVehicles[i], engine, lights, alarm, doors, bonnet, boot, objective);
        	SetVehicleParamsEx(AdminSpawnedVehicles[i], 1, lights, alarm, doors, bonnet, boot, objective);


			SetLockStatus(AdminSpawnedVehicles[i], false);
        	/*switch(carid[0]) {
        		case 427, 428, 432, 601, 528: SetVehicleHealth(AdminSpawnedVehicles[i], 5000.0);
        	}*/

			Vehicle_ResetVehicle(AdminSpawnedVehicles[i]);

			SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, "AdmAction: %s ได้สร้างยานพาหนะ %s ไอดี %d ", ReturnPlayerName(playerid), ReturnVehicleModelName(carid[0]), AdminSpawnedVehicles[i]);
        	break;
        }
    }
    else {
        SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /veh [ไอดีรุ่น/ชื่อบางส่วน] <สีที่ 1> <สีที่ 2> ");
    }
	return 1;
}

IsAdminVehicle(vehicleid) {
	for(new i=0;i!=MAX_ADMIN_VEHICLES;i++)
        if(AdminSpawnedVehicles[i] == vehicleid) return true;

	return false;
}

alias:davehs("deletevehicles", "desvehicles");
flags:davehs(CMD_ADM_3);
CMD:davehs(playerid, params[]) {
    new vehCount;
    for(new i=0;i!=MAX_ADMIN_VEHICLES;i++) {
        if(AdminSpawnedVehicles[i]) {
            DestroyVehicle(AdminSpawnedVehicles[i]);
    		AdminSpawnedVehicles[i] = 0;
    		vehCount++;
    	}
    }

    if(vehCount)
    	SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, "AdmWarning: %s ได้ทำลายยานพาหนะแอดมินทั้งหมด จำนวน %d คัน ", ReturnPlayerName(playerid), vehCount);
	return 1;
}

alias:daveh("deletevehicle", "desvehicle");
flags:daveh(CMD_ADM_3);
CMD:daveh(playerid, params[]) {
    new id, bool:success;
    if (sscanf(params, "d", id))
    {
     	if (IsPlayerInAnyVehicle(playerid))
    	 	id = GetPlayerVehicleID(playerid);
    	else {
            SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /daveh [ไอดียานพาหนะ] ");
            return 1;
        }
    }

    for(new i=0;i!=MAX_ADMIN_VEHICLES;i++) if(AdminSpawnedVehicles[i] == id)
    {
    	//SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณได้ทำลายยานพาหนะไอดี "EMBED_ORANGE"%d", AdminSpawnedVehicles[i]);
		SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, "AdmAction: %s ได้ทำลายยานพาหนะ %s ไอดี %d ", ReturnPlayerName(playerid), ReturnVehicleModelName(GetVehicleModel(AdminSpawnedVehicles[i])), AdminSpawnedVehicles[i]);
    	DestroyVehicle(AdminSpawnedVehicles[i]);
    	AdminSpawnedVehicles[i] = 0;
    	success = true;
    	return 1;
    }

    if(!success) 
		SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ในยานพาหนะที่แอดมินเสกขึ้น ");

	return 1;
}

flags:vehcmds(CMD_MANAGEMENT);
CMD:vehcmds(playerid) {
    SendClientMessage(playerid, COLOR_GRAD1, "คำสั่ง: /saveveh (ใช้กับ /veh เท่านั้น), /removeveh ");
    return 1;
}

flags:removeveh(CMD_MANAGEMENT);
CMD:removeveh(playerid, params[])
{
	new
	    id = 0;

	if (sscanf(params, "d", id))
 	{
	 	if (IsPlayerInAnyVehicle(playerid))
		 	id = GetPlayerVehicleID(playerid);

		else {
			SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /removeveh [ไอดี (/dl)] ");
			return 1;
		}
	}
	if((id = Vehicle_GetID(id)) != -1)
	{
		new
	        string[64];

		format(string, sizeof(string), "DELETE FROM `vehicle` WHERE `vehicleID` = '%d'", vehicleVariables[id][vVehicleID]);
		mysql_tquery(dbCon, string);

		if(vehicleVariables[id][vVehicleFactionID] != -1) {
			Log(adminactionlog, INFO, "%s: ลบยานพาหนะ %s(SQLID %d) ของแฟคชั่น %s(%d)", ReturnPlayerName(playerid), ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), vehicleVariables[id][vVehicleID], factionData[vehicleVariables[id][vVehicleFactionID]][fName], factionData[vehicleVariables[id][vVehicleFactionID]][fID]);
		}
		else {
			Log(adminactionlog, INFO, "%s: ลบยานพาหนะ %s(SQLID %d)", ReturnPlayerName(playerid), ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), vehicleVariables[id][vVehicleID]);
		}

		//SendClientMessageEx(playerid, COLOR_YELLOW, "เซิร์ฟเวอร์: "EMBED_WHITE"ยานพาหนะ "EMBED_YELLOW"%s"EMBED_WHITE" (ไอดี "EMBED_ORANGE"%d"EMBED_WHITE") ถูกลบออกจากระบบเรียบร้อยแล้ว", ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), vehicleVariables[id][vVehicleScriptID]);
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้ลบยานพาหนะ %s ไอดี %d ออกจากระบบ ", ReturnPlayerName(playerid), ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), vehicleVariables[id][vVehicleScriptID]);
		
		DestroyVehicle(vehicleVariables[id][vVehicleScriptID]);
		Iter_Remove(Iter_ServerCar, id);
	}
	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "ต้องเป็นยานพาหนะ Dynamic เท่านั้น ");
	}
	return 1;
}

flags:saveveh(CMD_MANAGEMENT);
CMD:saveveh(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))
    	return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่บนยานพาหนะเพื่อบันทึกมัน ");

    if(GetPVarInt(playerid, "sCc") == GetPlayerVehicleID(playerid)) {
    	new i = Iter_Free(Iter_ServerCar);
        if(i != -1)
    	{

            // เปลี่ยนรถเสกแอดมินเป็นรถ Dynamic
            new
                vehicleid = GetPlayerVehicleID(playerid); // x, y, z + z angle

            new bool:checked=false;
    	    for(new x=0;x!=MAX_ADMIN_VEHICLES;x++) {
    	    	if(AdminSpawnedVehicles[x] == vehicleid) {
     	    		AdminSpawnedVehicles[x] = 0;
                    checked = true;

                    new
                        queryString[255],
                        Float: vPos[4];

                    GetVehiclePos(vehicleid, vPos[0], vPos[1], vPos[2]);
                    GetVehicleZAngle(vehicleid, vPos[3]);

                    format(queryString, sizeof(queryString), "INSERT INTO vehicle (vehicleModelID, vehiclePosX, vehiclePosY, vehiclePosZ, vehiclePosRotation) VALUES('%d', '%f', '%f', '%f', '%f')", GetVehicleModel(vehicleid), vPos[0], vPos[1], vPos[2], vPos[3]);
                    mysql_query(dbCon,queryString);

                    new insertid = cache_insert_id();

                    vehicleVariables[i][vVehicleID] = insertid;
                    vehicleVariables[i][vVehicleModelID] = GetVehicleModel(vehicleid);
                    vehicleVariables[i][vVehiclePosition][0] = vPos[0];
                    vehicleVariables[i][vVehiclePosition][1] = vPos[1];
                    vehicleVariables[i][vVehiclePosition][2] = vPos[2];
                    vehicleVariables[i][vVehicleRotation] = vPos[3];
                    vehicleVariables[i][vVehicleFaction] = 0;
                    vehicleVariables[i][vVehicleFactionID] = -1;
                    vehicleVariables[i][vVehicleScriptID] = vehicleid;

                    ChangeVehicleColor(vehicleid, vehicleVariables[i][vVehicleColour][0], vehicleVariables[i][vVehicleColour][1]);

                    Iter_Add(Iter_ServerCar, i);

                    DeletePVar(playerid, "sCc");

					//SendClientMessageEx(playerid, COLOR_YELLOW, "เซิร์ฟเวอร์: "EMBED_WHITE"ยานพาหนะ "EMBED_YELLOW"%s"EMBED_WHITE" (ไอดี "EMBED_ORANGE"%d"EMBED_WHITE") ถูกเพิ่มเข้าไปในระบบเรียบร้อยแล้ว", ReturnVehicleModelName(vehicleVariables[i][vVehicleModelID]), vehicleid);
					SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เพิ่มยานพาหนะ %s ไอดี %d เข้าระบบ ", ReturnPlayerName(playerid), ReturnVehicleModelName(vehicleVariables[i][vVehicleModelID]), vehicleid);
					break;
    	    	}
    	    }
            if(!checked) {
                SendClientMessage(playerid, COLOR_LIGHTRED, "ต้องใช้ยานพาหนะที่ถูกสร้างจากแอดมินเท่านั้น (/veh) ");
            }
    	    return 1;
    	}
    }
    else {
        SetPVarInt(playerid, "sCc", GetPlayerVehicleID(playerid));
        return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณแน่ใจหรือว่าจะบันทึกยานพาหนะนี้? พิมพ์คำสั่งนี้อีกครั้งเพื่อยืนยัน ");
    }
	return 1;
}

flags:editveh(CMD_MANAGEMENT);
CMD:editveh(playerid, params[])
{
    new id = -1;
    if((id = Vehicle_GetID(GetPlayerVehicleID(playerid))) != -1)
	{
        SetPVarInt(playerid, "VehicleDynamicID", id);    
        EditVehicleMenu(playerid);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "คุณจำเป็นต้องอยู่ในยานพาหนะที่ถูกนำเข้าระบบเท่านั้น");
	}
    return 1;
}

EditVehicleMenu(playerid) {

	new caption[128], id = GetPVarInt(playerid, "VehicleDynamicID");

	if(GetPVarType(playerid, "vcolorselectID")) {
     	DestroyVehicle(vehicleVariables[id][vVehicleScriptID]);
     	
     	vehicleVariables[id][vVehicleScriptID] = CreateVehicle(vehicleVariables[id][vVehicleModelID], vehicleVariables[id][vVehiclePosition][0], vehicleVariables[id][vVehiclePosition][1], vehicleVariables[id][vVehiclePosition][2], vehicleVariables[id][vVehicleRotation], vehicleVariables[id][vVehicleColour][0], vehicleVariables[id][vVehicleColour][1], 60000);

     	LinkVehicleToInterior(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleInterior]);
     	SetVehicleVirtualWorld(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleWorld]);

     	if(vehicleVariables[id][vVehicleFactionID] != -1) {
     	    SetVehicleNumberPlate(vehicleVariables[id][vVehicleScriptID], factionData[vehicleVariables[id][vVehicleFactionID]][fShortName]);
     	}
     	else {
     	    new plate[8];
     	    format(plate, 8, "%s", Vehicle_RandomPlate());
     	    SetVehicleNumberPlate(vehicleVariables[id][vVehicleScriptID], plate);
     	}
     	PutPlayerInVehicle(playerid, vehicleVariables[id][vVehicleScriptID], 0);
     	    
     	// Waiting for engine system
     	new
     	    engine,
     	    lights,
     	    alarm,
     	    doors,
     	    bonnet,
     	    boot,
     	    objective;

     	GetVehicleParamsEx(vehicleVariables[id][vVehicleScriptID], engine, lights, alarm, doors, bonnet, boot, objective);
     	SetVehicleParamsEx(vehicleVariables[id][vVehicleScriptID], 1, lights, alarm, doors, bonnet, boot, objective);
		DeletePVar(playerid, "vcolorselectID");
	}
    format(caption, sizeof caption, "แก้ไข %s(%d): (SQLID %d) ", ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleID]);
    return Dialog_Show(playerid, VehicleEditDialog, DIALOG_STYLE_LIST, caption, "รายละเอียด\nเปลี่ยนสี\nย้ายจุดเกิด\nสำหรับแฟคชั่น %s ", "เลือก", "ยกเลิก", vehicleVariables[id][vVehicleFactionID] == -1 ? ("...") : (Faction_Name(vehicleVariables[id][vVehicleFactionID])));
}

Dialog:VehicleEdit_Faction(playerid, response, listitem, inputtext[])
{
	if(response) {
        if(GetPVarType(playerid, "VehicleDynamicID")) {
            new id = GetPVarInt(playerid, "VehicleDynamicID");
            new factionid = strval(inputtext) - 1;

            if(vehicleVariables[id][vVehicleFactionID] != factionid) {

                if(factionid >= 0) {
                    if(Iter_Contains(Iter_Faction, factionid)) {
                    	vehicleVariables[id][vVehicleFactionID] = factionid;
						vehicleVariables[id][vVehicleFaction] = factionData[factionid][fID];
                    }
					else {
						return EditVehicleMenu(playerid);
					}
                }
                else {
                    vehicleVariables[id][vVehicleFactionID] = -1;
					vehicleVariables[id][vVehicleFaction] = 0;
                }
                Vehicle_Save(id);
                SendClientMessageEx(playerid, COLOR_GRAD, "   สิทธิ์ของยานพาหนะ "EMBED_WHITE"%s"EMBED_GRAD" เป็นของ %s"EMBED_GRAD"("EMBED_WHITE"%d"EMBED_GRAD")", ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), Faction_Name(vehicleVariables[id][vVehicleFactionID]), vehicleVariables[id][vVehicleFactionID] + 1);
                Log(adminactionlog, INFO, "%s: เปลี่ยนเจ้าของยานพาหนะ %s(%d) เป็น %s(%d)", ReturnPlayerName(playerid), ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), vehicleVariables[id][vVehicleID], Faction_Name(vehicleVariables[id][vVehicleFactionID]), vehicleVariables[id][vVehicleFactionID] + 1);
            }
        }
    }
    return EditVehicleMenu(playerid);
}

Dialog:VehicleEditDialog(playerid, response, listitem, inputtext[])
{
	if(response) {
	    if(!(playerData[playerid][pCMDPermission] & CMD_MANAGEMENT)) {
	    	SendClientMessage(playerid, COLOR_LIGHTRED, "เกิดข้อผิดพลาด"EMBED_WHITE": คุณไม่ได้รับอนุญาตให้ใช้ฟังก์ชั่นการแก้ไข "EMBED_RED"(MANAGEMENT ONLY)");
	    	return EditVehicleMenu(playerid);
	    }
		new id = GetPVarInt(playerid, "VehicleDynamicID");
        if(GetPVarType(playerid, "VehicleDynamicID") && GetPlayerVehicleID(playerid) == vehicleVariables[id][vVehicleScriptID]) {
            switch(listitem) {
                case 0: { // รายละเอียด
					new str[512];
					format(str, sizeof str, "ไอดี: "EMBED_ORANGE"%d"EMBED_DIALOG" (/dl)\nไอดีหลัก: "EMBED_ORANGE"%d"EMBED_DIALOG"\n\nรุ่น: "EMBED_YELLOW"%s"EMBED_DIALOG" ("EMBED_ORANGE"%d"EMBED_DIALOG")\nสี: {%06x}#"EMBED_DIALOG"%d / {%06x}#"EMBED_DIALOG"%d\nสิทธิ์การเข้าถึง: "EMBED_YELLOW"%s"EMBED_DIALOG"", vehicleVariables[id][vVehicleScriptID], id, ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), vehicleVariables[id][vVehicleModelID], g_arrCarColors[vehicleVariables[id][vVehicleColour][0]] >>> 8, vehicleVariables[id][vVehicleColour][0], g_arrCarColors[vehicleVariables[id][vVehicleColour][1]] >>> 8, vehicleVariables[id][vVehicleColour][1], Faction_Name(vehicleVariables[id][vVehicleFactionID]));
					Dialog_Show(playerid, VehicleDetails, DIALOG_STYLE_MSGBOX, "รายละเอียดยานพาหนะ", str, "กลับ", "");
                }
                case 1: { // เปลี่ยนสี
					// ฟังก์ชั่นใน vcolorselect.pwn
					SetPVarInt(playerid, "vcolorselectID", vehicleVariables[id][vVehicleScriptID]);
                    ShowPlayerColorSelection(playerid, 1, vehicleVariables[id][vVehicleColour][0]);
                    ShowPlayerColorSelection2(playerid, 1, vehicleVariables[id][vVehicleColour][1]);
                }
                case 2: { // ย้ายจุดเกิด
                    new vehicleid = vehicleVariables[id][vVehicleScriptID];
                    GetVehiclePos(vehicleid, vehicleVariables[id][vVehiclePosition][0], vehicleVariables[id][vVehiclePosition][1], vehicleVariables[id][vVehiclePosition][2]);
                    GetVehicleZAngle(vehicleid, vehicleVariables[id][vVehicleRotation]);

                    vehicleVariables[id][vVehicleWorld]=GetPlayerVirtualWorld(playerid);
                    vehicleVariables[id][vVehicleInterior]=GetPlayerInterior(playerid);

                    Vehicle_Save(id);

                    DestroyVehicle(vehicleVariables[id][vVehicleScriptID]);
            
                    vehicleVariables[id][vVehicleScriptID] = CreateVehicle(vehicleVariables[id][vVehicleModelID], vehicleVariables[id][vVehiclePosition][0], vehicleVariables[id][vVehiclePosition][1], vehicleVariables[id][vVehiclePosition][2], vehicleVariables[id][vVehicleRotation], vehicleVariables[id][vVehicleColour][0], vehicleVariables[id][vVehicleColour][1], 60000);

                    LinkVehicleToInterior(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleInterior]);
                    SetVehicleVirtualWorld(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleWorld]);

                    if(vehicleVariables[id][vVehicleFactionID] != -1) {
                        SetVehicleNumberPlate(vehicleVariables[id][vVehicleScriptID], factionData[vehicleVariables[id][vVehicleFactionID]][fShortName]);
                    }
                    else {
                        new plate[8];
                        format(plate, 8, "%s", Vehicle_RandomPlate());
                        SetVehicleNumberPlate(vehicleVariables[id][vVehicleScriptID], plate);
                    }
                    PutPlayerInVehicle(playerid, vehicleVariables[id][vVehicleScriptID], 0);

                    // Waiting for engine system
                    new
                        engine,
                        lights,
                        alarm,
                        doors,
                        bonnet,
                        boot,
                        objective;

                    GetVehicleParamsEx(vehicleVariables[id][vVehicleScriptID], engine, lights, alarm, doors, bonnet, boot, objective);
                    SetVehicleParamsEx(vehicleVariables[id][vVehicleScriptID], 1, lights, alarm, doors, bonnet, boot, objective);

                    SendClientMessageEx(playerid, COLOR_GRAD, "   จุดเกิดของ "EMBED_WHITE"%s"EMBED_GRAD" ถูกเปลี่ยนมายังที่อยู่ปัจจุบันของคุณแล้ว", ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]));
                    Log(adminactionlog, INFO, "%s: เปลี่ยนจุดเกิดของ %s(%d)", ReturnPlayerName(playerid), ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), vehicleVariables[id][vVehicleID]);
                }
                case 3: { // กำหนดเจ้าของ
					new caption[128];
					format(caption, sizeof caption, "แก้ไข %s(%d): (SQLID %d) -> แฟคชั่น", ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleID]);
                    Dialog_Show(playerid, VehicleEdit_Faction, DIALOG_STYLE_INPUT, caption, ""EMBED_WHITE"สิทธิ์ในการเข้าถึงยานพาหนะ: "EMBED_WHITE"%s"EMBED_WHITE"\n\nรายละเอียดแฟคชั่น "EMBED_YELLOW"/viewfactions"EMBED_WHITE" (พิมพ์ "EMBED_ORANGE"0"EMBED_WHITE" เพื่อให้ทุกคนสามารถมีสิทธิ์ใช้งาน)\nกรอกไอดีแฟคชั่นที่ต้องการให้สิทธิ์ในกล่องด้านล่างนี้:", "ปรับ", "ยกเลิก", Faction_Name(vehicleVariables[id][vVehicleFactionID]));    
                }
            }
        }
	}
    else {
        DeletePVar(playerid, "VehicleDynamicID");
    }
	return 1;
}

Dialog:VehicleDetails(playerid, response, listitem, inputtext[])
{
	EditVehicleMenu(playerid);
	return 1;
}
/*
forward Vehicle_Load();
public Vehicle_Load()
{
    new
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_VEHICLES)
	{
	    cache_get_value_name_int(i, "vehicleID", vehicleVariables[i][vVehicleID]);
	    cache_get_value_name_int(i, "vehicleModelID", vehicleVariables[i][vVehicleModelID]);
	    cache_get_value_name_float(i, "vehiclePosX", vehicleVariables[i][vVehiclePosition][0]);
	    cache_get_value_name_float(i, "vehiclePosY", vehicleVariables[i][vVehiclePosition][1]);
	    cache_get_value_name_float(i, "vehiclePosZ", vehicleVariables[i][vVehiclePosition][2]);
	    cache_get_value_name_float(i, "vehiclePosRotation", vehicleVariables[i][vVehicleRotation]);

	    cache_get_value_name_int(i, "vehicleFaction", vehicleVariables[i][vVehicleFaction]);

	    cache_get_value_name_int(i, "vehicleCol1", vehicleVariables[i][vVehicleColour][0]);
	    cache_get_value_name_int(i, "vehicleCol2", vehicleVariables[i][vVehicleColour][1]);
	    cache_get_value_name_int(i, "vehicleWorld", vehicleVariables[i][vVehicleWorld]);
	    cache_get_value_name_int(i, "vehicleInterior", vehicleVariables[i][vVehicleInterior]);

	    vehicleVariables[i][vVehicleFactionID] = -1;

	    if(vehicleVariables[i][vVehicleColour][0] < 0) {
	    	vehicleVariables[i][vVehicleColour][0] = random(126);
	    }
	    if(vehicleVariables[i][vVehicleColour][1] < 0) {
	    	vehicleVariables[i][vVehicleColour][1] = random(126);
	    }

	    vehicleVariables[i][vVehicleScriptID] = CreateVehicle(vehicleVariables[i][vVehicleModelID], vehicleVariables[i][vVehiclePosition][0], vehicleVariables[i][vVehiclePosition][1], vehicleVariables[i][vVehiclePosition][2], vehicleVariables[i][vVehicleRotation], vehicleVariables[i][vVehicleColour][0], vehicleVariables[i][vVehicleColour][1], 60000);

	    LinkVehicleToInterior(vehicleVariables[i][vVehicleScriptID], vehicleVariables[i][vVehicleInterior]);
	    SetVehicleVirtualWorld(vehicleVariables[i][vVehicleScriptID], vehicleVariables[i][vVehicleWorld]);

	    if(vehicleVariables[i][vVehicleFaction] != 0) {
			foreach(new x : Iter_Faction) {
				if(factionData[x][fID] == vehicleVariables[i][vVehicleFaction]) {
					vehicleVariables[i][vVehicleFactionID] = x;
					break;
				}
			}
			if (vehicleVariables[i][vVehicleFactionID] != -1) {
				SetVehicleNumberPlate(vehicleVariables[i][vVehicleScriptID], factionData[vehicleVariables[i][vVehicleFactionID]][fShortName]);
			}
	    }
	    else {
	    	new plate[8];
	    	format(plate, sizeof(plate), Vehicle_RandomPlate());
	    	SetVehicleNumberPlate(vehicleVariables[i][vVehicleScriptID], plate);
	    }

		SetEngineStatus(vehicleVariables[i][vVehicleScriptID], false);
		// SetLockStatus(vehicleVariables[i][vVehicleScriptID], false);

		Vehicle_ResetVehicle(vehicleVariables[i][vVehicleScriptID]);
        Iter_Add(Iter_ServerCar, i);
	}
    // printf("Vehicle loaded (%d/%d)", Iter_Count(Iter_ServerCar), MAX_VEHICLES);
	return 1;
}*/

Vehicle_Save(id) {
	if(Iter_Contains(Iter_ServerCar, id)) {
        new largeQuery[512];
	    //GetVehiclePos(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehiclePosition][0], vehicleVariables[id][vVehiclePosition][1], vehicleVariables[id][vVehiclePosition][2]);
	    //GetVehicleZAngle(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleRotation]);

	    format(largeQuery, sizeof(largeQuery), "UPDATE vehicle SET vehicleModelID = '%d', vehiclePosX = '%.4f', vehiclePosY = '%.4f', vehiclePosZ = '%.4f', vehiclePosRotation = '%.4f', vehicleFaction = '%d', vehicleCol1 = '%d', vehicleCol2 = '%d', vehicleWorld = '%d', vehicleInterior = '%d' WHERE vehicleID = '%d'", vehicleVariables[id][vVehicleModelID],	vehicleVariables[id][vVehiclePosition][0],
		vehicleVariables[id][vVehiclePosition][1], vehicleVariables[id][vVehiclePosition][2], vehicleVariables[id][vVehicleRotation], vehicleVariables[id][vVehicleFaction], vehicleVariables[id][vVehicleColour][0], vehicleVariables[id][vVehicleColour][1], vehicleVariables[id][vVehicleWorld], vehicleVariables[id][vVehicleInterior], vehicleVariables[id][vVehicleID]);
		mysql_query(dbCon,largeQuery);
	}
	return 1;
}

static Vehicle_RandomPlate()
{
	const len = 7;
	new plate[len+1];
	for (new i = 0; i < len; i++)
	{
	    if (i > 0 && i < 4) // letter or number?
	    {
	     	plate[i] = 'A' + random(26);
	    }
	    else
	    { // number
	    	plate[i] = '0' + random(10);
	    }
	}
	return plate;
}

Vehicle_GetID(id)
{
	foreach(new i : Iter_ServerCar) if (vehicleVariables[i][vVehicleScriptID] == id) {
		return i;
	}
	return -1;
}

hook OP_EnterVehicle(playerid, vehicleid, ispassenger)
{
	foreach(new i : Iter_ServerCar) {
		if(vehicleVariables[i][vVehicleScriptID] == vehicleid && vehicleVariables[i][vVehicleFaction] != 0 && vehicleVariables[i][vVehicleFaction] != playerData[playerid][pFaction]) {

			// SendClientMessageEx(playerid, -1, "VehicleFaction %d player faac %d", vehicleVariables[i][vVehicleFaction], playerData[playerid][pFaction]);

			if(playerData[playerid][pAdmin]) {
				SendClientMessageEx(playerid, COLOR_GREY, "   %s (รุ่น %d, ไอดี %d) สิทธิ์การเข้าถึงเป็นของ %s"EMBED_GREY"(%d)", ReturnVehicleModelName(vehicleVariables[i][vVehicleModelID]), vehicleVariables[i][vVehicleModelID], vehicleVariables[i][vVehicleScriptID], Faction_Name(vehicleVariables[i][vVehicleFactionID]), vehicleVariables[i][vVehicleFactionID] + 1);
				return 1;
			}
			else {
                if (GetLockStatus(vehicleid) || !ispassenger) {
					PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
				    SetVehicleLabel(vehicleid, VLT_TYPE_PERMITFACTION, 5);
				    ClearAnimations(playerid);
					// TogglePlayerControllable(playerid, false);
                }
				return 1;
			}
		}
	}
    return 1;
}

hook OP_StateChange(playerid, newstate, oldstate)
{
	#if defined SV_DEBUG
		printf("vehicle.pwn: OnPlayerStateChange(playerid %d, newstate %d, oldstate %d)", playerid, newstate, oldstate);
	#endif

	if (newstate == PLAYER_STATE_ONFOOT) {
	    DeletePVar(playerid, "VehicleDynamicID");
    }
	else if (newstate == PLAYER_STATE_DRIVER) {
		new vehicleid = GetPlayerVehicleID(playerid);
		foreach(new i : Iter_ServerCar) {
			if(vehicleVariables[i][vVehicleScriptID] == vehicleid && vehicleVariables[i][vVehicleFaction] != 0 && vehicleVariables[i][vVehicleFaction] != playerData[playerid][pFaction]) {
				if(!playerData[playerid][pAdmin]) {
					SendClientMessage(playerid, COLOR_GRAD1, "   รถคันนี้เป็นของแฟคชั่น");
					Mobile_GameTextForPlayer(playerid, "~r~This vehicle Locked", 4000, 4);
					RemovePlayerFromVehicle(playerid);
					return -2;
				}
			}
		}
    }
    return 1;
}

flags:editveh2(CMD_MANAGEMENT);
CMD:editveh2(playerid, params[])
{
	new
	    id,
	    type[24],
	    string[128],
		str[128];

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /editveh2 [ไอดี (/dl)] [ตั้งค่า]");
	    SendClientMessage(playerid, COLOR_GREY, "ตั้งค่าที่ใช้ได้: ตำแหน่ง, แฟคชั่น, สี1, สี2");
		return 1;
	}
	if((id = Vehicle_GetID(id)) != -1)
	{
		if (!strcmp(type, "ตำแหน่ง", true))
		{
        	new vehicleid = vehicleVariables[id][vVehicleScriptID];
        	GetVehiclePos(vehicleid, vehicleVariables[id][vVehiclePosition][0], vehicleVariables[id][vVehiclePosition][1], vehicleVariables[id][vVehiclePosition][2]);
        	GetVehicleZAngle(vehicleid, vehicleVariables[id][vVehicleRotation]);

        	vehicleVariables[id][vVehicleWorld]=GetPlayerVirtualWorld(playerid);
        	vehicleVariables[id][vVehicleInterior]=GetPlayerInterior(playerid);

        	Vehicle_Save(id);

        	DestroyVehicle(vehicleVariables[id][vVehicleScriptID]);
        	
        	vehicleVariables[id][vVehicleScriptID] = CreateVehicle(vehicleVariables[id][vVehicleModelID], vehicleVariables[id][vVehiclePosition][0], vehicleVariables[id][vVehiclePosition][1], vehicleVariables[id][vVehiclePosition][2], vehicleVariables[id][vVehicleRotation], vehicleVariables[id][vVehicleColour][0], vehicleVariables[id][vVehicleColour][1], 60000);

        	LinkVehicleToInterior(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleInterior]);
        	SetVehicleVirtualWorld(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleWorld]);

        	if(vehicleVariables[id][vVehicleFactionID] != -1) {
        	    SetVehicleNumberPlate(vehicleVariables[id][vVehicleScriptID], factionData[vehicleVariables[id][vVehicleFactionID]][fShortName]);
        	}
        	else {
        	    new plate[8];
        	    format(plate, 8, "%s", Vehicle_RandomPlate());
        	    SetVehicleNumberPlate(vehicleVariables[id][vVehicleScriptID], plate);
        	}
        	PutPlayerInVehicle(playerid, vehicleVariables[id][vVehicleScriptID], 0);
        	    
        	// Waiting for engine system
        	new
        	    engine,
        	    lights,
        	    alarm,
        	    doors,
        	    bonnet,
        	    boot,
        	    objective;

        	GetVehicleParamsEx(vehicleVariables[id][vVehicleScriptID], engine, lights, alarm, doors, bonnet, boot, objective);
        	SetVehicleParamsEx(vehicleVariables[id][vVehicleScriptID], 1, lights, alarm, doors, bonnet, boot, objective);

        	SendClientMessageEx(playerid, COLOR_GRAD, "   จุดเกิดของ "EMBED_WHITE"%s"EMBED_GRAD" ถูกเปลี่ยนมายังที่อยู่ปัจจุบันของคุณแล้ว", ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]));
        	Log(adminactionlog, INFO, "%s: เปลี่ยนจุดเกิดของ %s(%d)", ReturnPlayerName(playerid), ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), vehicleVariables[id][vVehicleID]);
		}
		else if (!strcmp(type, "แฟคชั่น", true))
		{
		    new factionid;

		    if (sscanf(string, "d", factionid))
		 	{
				format(str, sizeof str, "การใช้: /editveh2 %d แฟคชั่น [ไอดี (/viewfactions)]", id);
				SendClientMessage(playerid, COLOR_GRAD1, str);
			 	return 1;
			}
            factionid--;
            if(vehicleVariables[id][vVehicleFactionID] != factionid) {

                if(factionid >= 0) {
                    if(Iter_Contains(Iter_Faction, factionid)) {
                    	vehicleVariables[id][vVehicleFactionID] = factionid;
						vehicleVariables[id][vVehicleFaction] = factionData[factionid][fID];
                    }
					else {
						SendClientMessage(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"ไม่พบไอดีแฟคชั่นที่ระบุ โปรดลองใหม่อีกครั้ง");
						return 1;
					}
                }
                else {
                    vehicleVariables[id][vVehicleFactionID] = -1;
					vehicleVariables[id][vVehicleFaction] = 0;
                }
                Vehicle_Save(id);
                SendClientMessageEx(playerid, COLOR_GRAD, "   สิทธิ์ของยานพาหนะ "EMBED_WHITE"%s"EMBED_GRAD" เป็นของ %s"EMBED_GRAD"("EMBED_WHITE"%d"EMBED_GRAD")", ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), Faction_Name(vehicleVariables[id][vVehicleFactionID]), vehicleVariables[id][vVehicleFactionID] + 1);
                Log(adminactionlog, INFO, "%s: เปลี่ยนเจ้าของยานพาหนะ %s(%d) เป็น %s(%d)", ReturnPlayerName(playerid), ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), vehicleVariables[id][vVehicleID], Faction_Name(vehicleVariables[id][vVehicleFactionID]), vehicleVariables[id][vVehicleFactionID] + 1);
            }
		}
		else if (!strcmp(type, "สี1", true))
		{
		    new color1;
		    if (sscanf(string, "d", color1)) {
				format(str, sizeof str, "การใช้: /editveh2 %d สี1 [หมายเลข 0-255]", id);
				SendClientMessage(playerid, COLOR_GRAD1, str);
				return 1;
			}
			if (color1 < 0 || color1 > 255)
			    return SendClientMessage(playerid, COLOR_GRAD1, "   สีต้องไม่ต่ำกว่า 0 หรือมากกว่า 255");

			vehicleVariables[id][vVehicleColour][0] = color1;
			ChangeVehicleColor(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleColour][0], vehicleVariables[id][vVehicleColour][1]);

         	SendClientMessageEx(playerid, COLOR_GRAD, "   สีที่ 1 ของยานพาหนะ "EMBED_WHITE"%s"EMBED_GRAD" เป็น "EMBED_WHITE"%d"EMBED_GRAD"", ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), color1);
         	Log(adminactionlog, INFO, "%s: เปลี่ยนสีที่ 1 ของยานพาหนะ %s(%d) เป็น %d", ReturnPlayerName(playerid), ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), vehicleVariables[id][vVehicleID], color1);

			Vehicle_Save(id);
		}
		else if (!strcmp(type, "สี2", true))
		{
		    new color2;

		    if (sscanf(string, "d", color2)) {
				format(str, sizeof str, "การใช้: /editveh2 %d สี2 [หมายเลข 0-255]", id);
				SendClientMessage(playerid, COLOR_GRAD1, str);
				return 1;
			}

			if (color2 < 0 || color2 > 255)
			    return SendClientMessage(playerid, COLOR_GRAD1, "   สีต้องไม่ต่ำกว่า 0 หรือมากกว่า 255");

			vehicleVariables[id][vVehicleColour][1] = color2;
			ChangeVehicleColor(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleColour][0], vehicleVariables[id][vVehicleColour][1]);

         	SendClientMessageEx(playerid, COLOR_GRAD, "   สีที่ 2 ของยานพาหนะ "EMBED_WHITE"%s"EMBED_GRAD" เป็น "EMBED_WHITE"%d"EMBED_GRAD"", ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), color2);
         	Log(adminactionlog, INFO, "%s: เปลี่ยนสีที่ 2 ของยานพาหนะ %s(%d) เป็น %d", ReturnPlayerName(playerid), ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), vehicleVariables[id][vVehicleID], color2);

			Vehicle_Save(id);
		}
		else
		{
			SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /editveh2 [ไอดี (/dl)] [ตั้งค่า]");
			SendClientMessage(playerid, COLOR_GREY, "ตั้งค่าที่ใช้ได้: ตำแหน่ง, แฟคชั่น, สี1, สี2");
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_GRAD2, "   ไอดียานพาหนะไม่ถูกต้อง");
	}
	return 1;
}

CMD:park(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่บนยานพาหนะ");

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่คนขับ");

	new vehicleid = GetPlayerVehicleID(playerid), factionid = playerData[playerid][pFaction];

 	if (factionid == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องเป็นสมาชิกของฝ่ายหรือกลุ่ม");

	new id = -1;
	if((id = Vehicle_GetFactionID(vehicleid, factionid)) != -1)
	{
		GetVehiclePos(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehiclePosition][0], vehicleVariables[id][vVehiclePosition][1], vehicleVariables[id][vVehiclePosition][2]);
		GetVehicleZAngle(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleRotation]);
		vehicleVariables[id][vVehicleWorld]=GetPlayerVirtualWorld(playerid);
		vehicleVariables[id][vVehicleInterior]=GetPlayerInterior(playerid);
		Vehicle_Save(id);
		
		new temp_damages[4], Float:temp_vhealth;
		GetVehicleDamageStatus(vehicleVariables[id][vVehicleScriptID], temp_damages[0], temp_damages[1], temp_damages[2], temp_damages[3]);
		GetVehicleHealth(vehicleVariables[id][vVehicleScriptID], temp_vhealth);

		DestroyVehicle(vehicleVariables[id][vVehicleScriptID]);

		vehicleVariables[id][vVehicleScriptID] = CreateVehicle(vehicleVariables[id][vVehicleModelID], vehicleVariables[id][vVehiclePosition][0], vehicleVariables[id][vVehiclePosition][1], vehicleVariables[id][vVehiclePosition][2], vehicleVariables[id][vVehicleRotation], vehicleVariables[id][vVehicleColour][0], vehicleVariables[id][vVehicleColour][1], 60000);
		LinkVehicleToInterior(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleInterior]);
		SetVehicleVirtualWorld(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleWorld]);

     	if(vehicleVariables[id][vVehicleFactionID] != -1) {
     	    SetVehicleNumberPlate(vehicleVariables[id][vVehicleScriptID], factionData[vehicleVariables[id][vVehicleFactionID]][fShortName]);
     	}
     	else {
     	    new plate[8];
     	    format(plate, 8, "%s", Vehicle_RandomPlate());
     	    SetVehicleNumberPlate(vehicleVariables[id][vVehicleScriptID], plate);
     	}

		SetVehicleHealth(vehicleVariables[id][vVehicleScriptID], temp_vhealth);
		UpdateVehicleDamageStatus(vehicleVariables[id][vVehicleScriptID], temp_damages[0], temp_damages[1], temp_damages[2], temp_damages[3]);
		//SetVehicleDamageStatus(vehicleVariables[id][vVehicleScriptID], temp_damages[0], temp_damages[1], temp_damages[2], temp_damages[3]);

        PutPlayerInVehicle(playerid, vehicleVariables[id][vVehicleScriptID], 0);

        SendFactionIDMessage(factionid, COLOR_FACTION, "(( (%d) %s ได้ปรับตำแหน่งยานพาหนะไอดี %d ))", playerData[playerid][pFactionRank], ReturnPlayerName(playerid), vehicleid);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่บนยานพาหนะที่เป็นเจ้าของโดยแฟคชั่นเดียวกับคุณ");
	}
	return 1;
}

CMD:towcars(playerid, params[])
{
	new factionid = playerData[playerid][pFaction];

 	if (factionid == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องเป็นสมาชิกของฝ่ายหรือกลุ่ม");

    if(playerData[playerid][pFactionRank] > 7)
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

	// new faction = Faction_GetID(factionid);

	/*if (factionData[faction][fType] == FACTION_TYPE_GANG)
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "คำสั่งนี้สำหรับหน่วยงานรัฐเท่านั้น");
		*/
	foreach(new i : Iter_ServerCar) if(vehicleVariables[i][vVehicleFaction] != 0 && vehicleVariables[i][vVehicleFaction] == factionid && GetVehicleDriver(vehicleVariables[i][vVehicleScriptID]) == INVALID_PLAYER_ID)
	{
        SetVehicleToRespawn(vehicleVariables[i][vVehicleScriptID]);
		LinkVehicleToInterior(vehicleVariables[i][vVehicleScriptID], vehicleVariables[i][vVehicleInterior]);
		SetVehicleVirtualWorld(vehicleVariables[i][vVehicleScriptID], vehicleVariables[i][vVehicleWorld]);
	}
	SendFactionIDMessage(factionid, COLOR_FACTION, "** (( (%d) %s ได้ส่งยานพาหนะที่ไม่มีคนนั่งของกลุ่มกลับจุดเกิดทั้งหมด ))", playerData[playerid][pFactionRank], ReturnPlayerName(playerid));
	return 1;
}

DestroyFactionVehicle(playerid, factionid) {
	new
		string[80];

	foreach(new i : Iter_ServerCar) {
		new
			cur = i;
		if(vehicleVariables[i][vVehicleFaction] != 0 && vehicleVariables[i][vVehicleFaction] == factionid) {

			Log(adminactionlog, INFO, "%s: ลบยานพาหนะ %s(%d) ของแฟคชั่น %s(%d)", ReturnPlayerName(playerid), ReturnVehicleModelName(vehicleVariables[i][vVehicleModelID]), vehicleVariables[i][vVehicleID], Faction_Name(factionid), factionid);

			format(string, sizeof(string), "DELETE FROM `vehicle` WHERE `vehicleID` = %d", vehicleVariables[i][vVehicleID]);
			mysql_tquery(dbCon, string);

			DestroyVehicle(vehicleVariables[i][vVehicleScriptID]);
			Iter_SafeRemove(Iter_ServerCar, cur, i);
		}
	}
	return 1;
}

GetVehiclePrice(modelid)
{
	if(modelid >= 400) {
		if(VehicleData[modelid - 400][c_price]) return VehicleData[modelid - 400][c_price];
	}
	return 0;
}

GetVehicleDonatePrice(modelid)
{
	if(modelid >= 400) {
		if(VehicleData[modelid - 400][c_price]) return floatround(float(VehicleData[modelid - 400][c_price]) / 600.0);
	}
	return 0;
}
/*GetVehicleSize(modelID, &Float: size_X, &Float: size_Y, &Float: size_Z) // Author: RyDeR`
{
	static const
		Float: sizeData[212][3] =
		{
			{ 2.32, 5.11, 1.63 }, { 2.56, 5.82, 1.71 }, { 2.41, 5.80, 1.52 }, { 3.15, 9.22, 4.17 },
			{ 2.20, 5.80, 1.84 }, { 2.34, 6.00, 1.49 }, { 5.26, 11.59, 4.42 }, { 2.84, 8.96, 2.70 },
			{ 3.11, 10.68, 3.91 }, { 2.36, 8.18, 1.52 }, { 2.25, 5.01, 1.79 }, { 2.39, 5.78, 1.37 },
			{ 2.45, 7.30, 1.38 }, { 2.27, 5.88, 2.23 }, { 2.51, 7.07, 4.59 }, { 2.31, 5.51, 1.13 },
			{ 2.73, 8.01, 3.40 }, { 5.44, 23.27, 6.61 }, { 2.56, 5.67, 2.14 }, { 2.40, 6.21, 1.40 },
			{ 2.41, 5.90, 1.76 }, { 2.25, 6.38, 1.37 }, { 2.26, 5.38, 1.54 }, { 2.31, 4.84, 4.90 },
			{ 2.46, 3.85, 1.77 }, { 5.15, 18.62, 5.19 }, { 2.41, 5.90, 1.76 }, { 2.64, 8.19, 3.23 },
			{ 2.73, 6.28, 3.48 }, { 2.21, 5.17, 1.27 }, { 4.76, 16.89, 5.92 }, { 3.00, 12.21, 4.42 },
			{ 4.30, 9.17, 3.88 }, { 3.40, 10.00, 4.86 }, { 2.28, 4.57, 1.72 }, { 3.16, 13.52, 4.76 },
			{ 2.27, 5.51, 1.72 }, { 3.03, 11.76, 4.01 }, { 2.41, 5.82, 1.72 }, { 2.22, 5.28, 1.47 },
			{ 2.30, 5.55, 2.75 }, { 0.87, 1.40, 1.01 }, { 2.60, 6.67, 1.75 }, { 4.15, 20.04, 4.42 },
			{ 3.66, 6.01, 3.28 }, { 2.29, 5.86, 1.75 }, { 4.76, 17.02, 4.30 }, { 2.42, 14.80, 3.15 },
			{ 0.70, 2.19, 1.62 }, { 3.02, 9.02, 4.98 }, { 3.06, 13.51, 3.72 }, { 2.31, 5.46, 1.22 },
			{ 3.60, 14.56, 3.28 }, { 5.13, 13.77, 9.28 }, { 6.61, 19.04, 13.84 }, { 3.31, 9.69, 3.63 },
			{ 3.23, 9.52, 4.98 }, { 1.83, 2.60, 2.72 }, { 2.41, 6.13, 1.47 }, { 2.29, 5.71, 2.23 },
			{ 10.85, 13.55, 4.44 }, { 0.69, 2.46, 1.67 }, { 0.70, 2.19, 1.62 }, { 0.69, 2.42, 1.34 },
			{ 1.58, 1.54, 1.14 }, { 0.87, 1.40, 1.01 }, { 2.52, 6.17, 1.64 }, { 2.52, 6.36, 1.66 },
			{ 0.70, 2.23, 1.41 }, { 2.42, 14.80, 3.15 }, { 2.66, 5.48, 2.09 }, { 1.41, 2.00, 1.71 },
			{ 2.67, 9.34, 4.86 }, { 2.90, 5.40, 2.22 }, { 2.43, 6.03, 1.69 }, { 2.45, 5.78, 1.48 },
			{ 11.02, 11.28, 3.28 }, { 2.67, 5.92, 1.39 }, { 2.45, 5.57, 1.74 }, { 2.25, 6.15, 1.99 },
			{ 2.26, 5.26, 1.41 }, { 0.70, 1.87, 1.32 }, { 2.33, 5.69, 1.87 }, { 2.04, 6.19, 2.10 },
			{ 5.34, 26.20, 7.15 }, { 1.97, 4.07, 1.44 }, { 4.34, 7.84, 4.44 }, { 2.32, 15.03, 4.67 },
			{ 2.32, 12.60, 4.65 }, { 2.53, 5.69, 2.14 }, { 2.92, 6.92, 2.14 }, { 2.30, 6.32, 1.28 },
			{ 2.34, 6.17, 1.78 }, { 4.76, 17.82, 3.84 }, { 2.25, 6.48, 1.50 }, { 2.77, 5.44, 1.99 },
			{ 2.27, 4.75, 1.78 }, { 2.32, 15.03, 4.65 }, { 2.90, 6.59, 4.28 }, { 2.64, 7.19, 3.75 },
			{ 2.28, 5.01, 1.85 }, { 0.87, 1.40, 1.01 }, { 2.34, 5.96, 1.51 }, { 2.21, 6.13, 1.62 },
			{ 2.52, 6.03, 1.64 }, { 2.53, 5.69, 2.14 }, { 2.25, 5.21, 1.16 }, { 2.56, 6.59, 1.62 },
			{ 2.96, 8.05, 3.33 }, { 0.70, 1.89, 1.32 }, { 0.72, 1.74, 1.12 }, { 21.21, 21.19, 5.05 },
			{ 11.15, 6.15, 2.99 }, { 8.69, 9.00, 2.23 }, { 3.19, 10.06, 3.05 }, { 3.54, 9.94, 3.42 },
			{ 2.59, 6.23, 1.71 }, { 2.52, 6.32, 1.64 }, { 2.43, 6.00, 1.57 }, { 20.30, 19.29, 6.94 },
			{ 8.75, 14.31, 2.16 }, { 0.69, 2.46, 1.67 }, { 0.69, 2.46, 1.67 }, { 0.69, 2.47, 1.67 },
			{ 3.58, 8.84, 3.64 }, { 3.04, 6.46, 3.28 }, { 2.20, 5.40, 1.25 }, { 2.43, 5.71, 1.74 },
			{ 2.54, 5.55, 2.14 }, { 2.38, 5.63, 1.86 }, { 1.58, 4.23, 2.68 }, { 1.96, 3.70, 1.66 },
			{ 8.61, 11.39, 4.17 }, { 2.38, 5.42, 1.49 }, { 2.18, 6.26, 1.15 }, { 2.67, 5.48, 1.58 },
			{ 2.46, 6.42, 1.29 }, { 3.32, 18.43, 5.19 }, { 3.26, 16.59, 4.94 }, { 2.50, 3.86, 2.55 },
			{ 2.58, 6.07, 1.50 }, { 2.26, 4.94, 1.24 }, { 2.48, 6.40, 1.70 }, { 2.38, 5.73, 1.86 },
			{ 2.80, 12.85, 3.89 }, { 2.19, 4.80, 1.69 }, { 2.56, 5.86, 1.66 }, { 2.49, 5.84, 1.76 },
			{ 4.17, 24.42, 4.90 }, { 2.40, 5.53, 1.42 }, { 2.53, 5.88, 1.53 }, { 2.66, 6.71, 1.76 },
			{ 2.65, 6.71, 3.55 }, { 28.73, 23.48, 7.38 }, { 2.68, 6.17, 2.08 }, { 2.00, 5.13, 1.41 },
			{ 3.66, 6.36, 3.28 }, { 3.66, 6.26, 3.28 }, { 2.23, 5.25, 1.75 }, { 2.27, 5.48, 1.39 },
			{ 2.31, 5.40, 1.62 }, { 2.50, 5.80, 1.78 }, { 2.25, 5.30, 1.50 }, { 3.39, 18.62, 4.71 },
			{ 0.87, 1.40, 1.01 }, { 2.02, 4.82, 1.50 }, { 2.50, 6.46, 1.65 }, { 2.71, 6.63, 1.58 },
			{ 2.71, 4.61, 1.41 }, { 3.25, 18.43, 5.03 }, { 3.47, 21.06, 5.19 }, { 1.57, 2.32, 1.58 },
			{ 1.65, 2.34, 2.01 }, { 2.93, 7.38, 3.16 }, { 1.62, 3.84, 2.50 }, { 2.49, 5.82, 1.92 },
			{ 2.42, 6.36, 1.85 }, { 62.49, 61.43, 34.95 }, { 3.15, 11.78, 2.77 }, { 2.47, 6.21, 2.55 },
			{ 2.66, 5.76, 2.24 }, { 0.69, 2.46, 1.67 }, { 2.44, 7.21, 3.19 }, { 1.66, 3.66, 3.21 },
			{ 3.54, 15.90, 3.40 }, { 2.44, 6.53, 2.05 }, { 0.69, 2.79, 1.96 }, { 2.60, 5.76, 1.45 },
			{ 3.07, 8.61, 7.53 }, { 2.25, 5.09, 2.11 }, { 3.44, 18.39, 5.03 }, { 3.18, 13.63, 4.65 },
			{ 44.45, 57.56, 18.43 }, { 12.59, 13.55, 3.56 }, { 0.50, 0.92, 0.30 }, { 2.84, 13.47, 2.21 },
			{ 2.41, 5.90, 1.76 }, { 2.41, 5.90, 1.76 }, { 2.41, 5.78, 1.76 }, { 2.92, 6.15, 2.14 },
			{ 2.40, 6.05, 1.55 }, { 3.07, 6.96, 3.82 }, { 2.31, 5.53, 1.28 }, { 2.64, 6.07, 1.42 },
			{ 2.52, 6.17, 1.64 }, { 2.38, 5.73, 1.86 }, { 2.93, 3.38, 1.97 }, { 3.01, 3.25, 1.60 },
			{ 1.45, 4.65, 6.36 }, { 2.90, 6.59, 4.21 }, { 2.48, 1.42, 1.62 }, { 2.13, 3.16, 1.83 }
		}
	;
	if(400 <= modelID <= 611)
	{
		size_X = sizeData[modelID - 400][0];
		size_Y = sizeData[modelID - 400][1];
		size_Z = sizeData[modelID - 400][2];
		return 1;
	}
	return 0;
}*/

Float:GetVehicleDataHealth(modelid)
{
	if(modelid >= 400) {
		if(VehicleData[modelid - 400][c_maxhp]) return VehicleData[modelid - 400][c_maxhp];
	}
	return 1000.0;
}

GetVehicleDataScrap(modelid)
{
	if(modelid >= 400) {
		if(VehicleData[modelid - 400][c_scrap]) return VehicleData[modelid - 400][c_scrap];
	}
	return 0;
}

Float:GetVehicleDataBattery(modelid)
{
	if(modelid >= 400) {
		if(VehicleData[modelid - 400][c_battery]) return VehicleData[modelid - 400][c_battery];
	}
	return 100.0;
}

Float:GetVehicleDataEngine(modelid)
{
	if(modelid >= 400) {
		if(VehicleData[modelid - 400][c_engine]) return VehicleData[modelid - 400][c_engine];
	}
	return 100.0;
}

Float:GetVehicleDataFuelRate(modelid)
{
	if(modelid >= 400) {
		if(VehicleData[modelid - 400][c_fuelrate]) return VehicleData[modelid - 400][c_fuelrate];
	}
	return 15.0;
}

Float:GetVehicleConsumptionPerSecond(vehicleid)
{
	new Float:vSpeed = GetVehicleSpeed(vehicleid, true);
	new Float:MPG = GetVehicleDataFuelRate(GetVehicleModel(vehicleid)) / 10.0;
	return (((vSpeed < 5.0 ? 5.0 : vSpeed) / 3600.0) * MPG / 25.0);

	/*new Float:vSpeed = GetVehicleSpeed(vehicleid, true);
	return (((vSpeed < 5.0 ? 5.0 : vSpeed) / 3600.0)) / (GetVehicleDataFuelRate(GetVehicleModel(vehicleid)));*/
}

Float:GetVehicleDataFuel(modelid)
{
	if(modelid >= 400) {
		if(VehicleData[modelid - 400][c_maxfuel]) return VehicleData[modelid - 400][c_maxfuel];
	}
	return 25.0;
}

forward SetVehicleHealthEx(vehicleid, Float:hp);
public SetVehicleHealthEx(vehicleid, Float:hp)
{
	vehicleData[vehicleid][vHealth]=hp;
    SetVehicleHealth(vehicleid, hp);
    return 1;
}


Vehicle_ResetVehicle(vehicleid)
{
	if (IsValidVehicle(vehicleid))
	{

		new bool:global_vehicle = false;

		foreach(new i : Iter_ServerCar) {
			if(vehicleVariables[i][vVehicleScriptID] == vehicleid && vehicleVariables[i][vVehicleFaction] == 0) {
                global_vehicle = true;
                break;
			}
		}

		if(!global_vehicle) {
		    if(PlayerCar_GetID(vehicleid) == -1) {
				new vmodel = GetVehicleModel(vehicleid);
				vehicleData[vehicleid][vFuel] = GetVehicleDataFuel(vmodel);
				switch(vmodel) {
					case 427, 428, 432, 528, 601: SetVehicleHealthEx(vehicleid, 10000.0);
					default: {
						SetVehicleHealthEx(vehicleid, GetVehicleDataHealth(vmodel));
					}
				}
			}
		}
		else {
			new vmodel = GetVehicleModel(vehicleid);
			vehicleData[vehicleid][vFuel] = GetVehicleDataFuel(vmodel);
			vehicleData[vehicleid][vMiles] = float(random(200));
			SetVehicleHealth(vehicleid, GetVehicleDataHealth(vmodel));
			SetLockStatus(vehicleid, false);
		}

		if(IsValidDynamic3DTextLabel(vehicleData[vehicleid][vehSignText]))
			Delete3DTextLabel(vehicleData[vehicleid][vehSignText]);

      	// new model = GetVehicleModel(vehicleid);
		vehicleData[vehicleid][vOwnerID] = INVALID_PLAYER_ID;
		vehicleData[vehicleid][vUpgradeID] = 
		vehicleData[vehicleid][vbreakin] = 
		vehicleData[vehicleid][vbreaktime] = 
		vehicleData[vehicleid][vbreakdelay] = 0;

	    vehicleData[vehicleid][startup_delay_sender] = INVALID_PLAYER_ID;
	    vehicleData[vehicleid][startup_delay] = 
	    vehicleData[vehicleid][startup_delay_random] = 
	    vehicleData[vehicleid][vehicleBadlyDamage] = 0;
		vehicleData[vehicleid][vHealth] = 0.0;
		
		// vehicleData[vehicleid][vFuel] = GetVehicleDataFuel(model);
		// vehicleData[vehicleid][vMiles] = float(random(200));
		// SetVehicleHealthEx(vehicleid, 1000.0);
	}
	return 1;
}

Vehicle_GetFactionID(vehicleid, factionid) {
	foreach(new id : Iter_ServerCar) {
		if (vehicleVariables[id][vVehicleScriptID] == vehicleid && vehicleVariables[id][vVehicleFaction] == factionid) {
			return id;
		}
	}
	return -1;
}

Vehicle_IsFaction(vehicleid, factionid) {
	foreach(new id : Iter_ServerCar) {
		if (vehicleVariables[id][vVehicleScriptID] == vehicleid && vehicleVariables[id][vVehicleFaction] == factionid) {
			return true;
		}
	}
	return false;
}

hook OnVehicleSpawn(vehicleid) {
	if(Vehicle_GetID(vehicleid) != -1) {
		SetLockStatus(vehicleid, false);
	}
	return 1;
}