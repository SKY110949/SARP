#include <YSI\y_hooks>

//249 Alandele Avenue, Ganton, Los Santos 516
/*
	[ID] [Street], [Neighborhood], [City] [Area Code]
*/

#define MAX_HOUSES          399
#define MAX_HOUSE_WEAPONS 	40
#define	HOUSE_WORLD			4000
#define	MAX_OWN_HOUSE		5
#define	MAX_STREET_NAME		30

#define	PROPERTY_TYPE_HOUSE	1
#define	PROPERTY_TYPE_APART	2
#define	PROPERTY_TYPE_ROOM	3

enum houseE
{
	hID,
	STREAMER_TAG_3D_TEXT_LABEL:hLabel,
	hPickup,
	hCheckPoint,
	Float:hPosX,
	Float:hPosY,
	Float:hPosZ,
	hPosInt,
	hPosWorld,
	Float:hExtX,
	Float:hExtY,
	Float:hExtZ,
	hExtInt,
	hExtWorld,
	hAddress[MAX_STREET_NAME],
	hOwner[MAX_PLAYER_NAME],
	hOwned,
	hLocked,
	hPrice,
	hLevelbuy,
	hRentPrice,
	hRentable,
	hCash,
    hApartment,
    hWarehouse,

	hBareSwitch,
	hSwitchStatus,

	hAreaExt,
	hAreaInt,
	hMapIcon,

	hWeapon[MAX_HOUSE_WEAPONS],
	hAmmo[MAX_HOUSE_WEAPONS],

	Float:hCheckPosX,
	Float:hCheckPosY,
	Float:hCheckPosZ,

	hMats,
	hRMoney
};

new houseData[MAX_HOUSES][houseE];

new Iterator:Iter_House<MAX_HOUSES>;

new nearHouse_var[MAX_PLAYERS];
new insideHouseID[MAX_PLAYERS];

enum hIntE
{
	hIntName[16],
    Float:hIntPosX,
    Float:hIntPosY,
    Float:hIntPosZ,
	hInt,
	bool:bareswitch
};

static const houseInterior[][hIntE] = {
	{"ภายในพิเศษ #1", 1416.2,4.03454,1000.92, 1, false},
	{"ภายใน #2", 244.318,304.978,999.148, 1, true},
	{"ภายใน #3", 267.037,304.977,999.148, 2, true},
	{"ภายใน #4", 302.856,301.355,999.148, 4, true},
	{"ภายใน #5", 344.024,305.102,999.148, 6, true},
	{"ภายใน #6", 446.694,507.029,1001.42, 12, true},
	{"ภายใน #8", 2465.7524,-1698.3430,1013.5152, 2, false},
	{"ภายใน #13", 744.434,1436.92,1102.7, 6, true},
	{"ภายใน #16", 2530.7578,-1583.1094,1016.2422, 1, false},
	{"ภายใน #28", 225.761,1022.19,1084.02, 7, true},
	{"ภายใน #34", 2324.36,-1148.8,1050.71, 12, true},
	{"ภายใน #35", 2233.63,-1114.31,1050.88, 5, true},
	{"ภายใน #36", 2196.2,-1204.35,1049.02, 6, true},
	{"ภายใน #37", 2269.28,-1210.46,1047.56, 10, true},
	{"ภายใน #38", 2309.02,-1212.21,1049.02, 6, true},
	{"ภายใน #40", 2332.96,-1076.47,1049.02, 6, true},
	{"ภายใน #41", 2237.56,-1080.38,1049.02, 2, true},
	{"ภายใน #42", 2217.21,-1076.23,1050.48, 1, true},
	{"ภายใน #43", 2317.73,-1026.01,1050.22, 9, true}
};

hook OnPlayerConnect(playerid) {
	nearHouse_var[playerid]=
	insideHouseID[playerid]=-1;
	return 1;
}

hook OnGameModeInit() {
	mysql_tquery(dbCon, "SELECT * FROM `house`", "House_Load", "");
	return 1;
}

forward House_Load();
public House_Load() {

    new
	    rows,
		weapons[256],
		msg[128];

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_HOUSES)
	{
        cache_get_value_name_int(i, "house_id", houseData[i][hID]);
        cache_get_value_name_float(i, "posX", houseData[i][hPosX]);
        cache_get_value_name_float(i, "posY", houseData[i][hPosY]);
        cache_get_value_name_float(i, "posZ", houseData[i][hPosZ]);
        cache_get_value_name_int(i, "posInt", houseData[i][hPosInt]);
		cache_get_value_name_int(i, "posWorld", houseData[i][hPosWorld]);

        cache_get_value_name_float(i, "extX", houseData[i][hExtX]);
        cache_get_value_name_float(i, "extY", houseData[i][hExtY]);
        cache_get_value_name_float(i, "extZ", houseData[i][hExtZ]);
        cache_get_value_name_int(i, "extInt", houseData[i][hExtInt]);
		cache_get_value_name_int(i, "extWorld", houseData[i][hExtWorld]);
				
        cache_get_value_name(i, "address", houseData[i][hAddress], MAX_STREET_NAME);
		cache_get_value_name(i, "owner", houseData[i][hOwner], MAX_PLAYER_NAME);

        cache_get_value_name_int(i, "owned", houseData[i][hOwned]);
        cache_get_value_name_int(i, "locked", houseData[i][hLocked]);
        cache_get_value_name_int(i, "marketPrice", houseData[i][hPrice]);
        cache_get_value_name_int(i, "levelBuy", houseData[i][hLevelbuy]);
        cache_get_value_name_int(i, "rentPrice", houseData[i][hRentPrice]);
        cache_get_value_name_int(i, "rentable", houseData[i][hRentable]);
		cache_get_value_name_int(i, "cash", houseData[i][hCash]);

		cache_get_value_name_int(i, "Apartment", houseData[i][hApartment]);
		cache_get_value_name_int(i, "WareHouse", houseData[i][hWarehouse]);

		cache_get_value_name_int(i, "bareSwitch", houseData[i][hBareSwitch]);
		cache_get_value_name_int(i, "switchStatus", houseData[i][hSwitchStatus]);

		cache_get_value_index(i, 26, weapons);

		cache_get_value_name_float(i, "checkx", houseData[i][hCheckPosX]);
		cache_get_value_name_float(i, "checky", houseData[i][hCheckPosY]);
		cache_get_value_name_float(i, "checkz", houseData[i][hCheckPosZ]);

		cache_get_value_name_int(i, "Mats", houseData[i][hMats]);
		cache_get_value_name_int(i, "RMoney", houseData[i][hRMoney]);

		AssignHouseWeapons(i, weapons);
        Iter_Add(Iter_House, i);

		if(houseData[i][hApartment] == PROPERTY_TYPE_APART) houseData[i][hPickup] = CreateDynamicPickup(1314, 23, houseData[i][hPosX], houseData[i][hPosY], houseData[i][hPosZ], 0, 0);
		else if(houseData[i][hApartment] == PROPERTY_TYPE_HOUSE) {
			houseData[i][hPickup] = CreateDynamicPickup(1273, 23, houseData[i][hPosX], houseData[i][hPosY], houseData[i][hPosZ], 0, 0);
			Streamer_SetIntData(STREAMER_TYPE_PICKUP, houseData[i][hPickup], E_STREAMER_EXTRA_ID, i);
		}
		houseData[i][hCheckPoint] = CreateDynamicCP(houseData[i][hPosX], houseData[i][hPosY], houseData[i][hPosZ], 3.0, houseData[i][hPosWorld], houseData[i][hPosInt], -1, 3.5);

     	if(!houseData[i][hOwned] && houseData[i][hApartment] != PROPERTY_TYPE_APART) {
     	    format(msg, sizeof(msg), "%s\nราคา: $%d\nเลเวล: %d", GetHouseAddress(i), houseData[i][hPrice], houseData[i][hLevelbuy]);
     	    houseData[i][hLabel] = CreateDynamic3DTextLabel(msg, 0xFFFF00FF, houseData[i][hPosX], houseData[i][hPosY], houseData[i][hPosZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, houseData[i][hPosWorld], houseData[i][hPosInt], -1, 100.0);
		}

		houseData[i][hAreaExt] = CreateDynamicSphere(houseData[i][hPosX], houseData[i][hPosY], houseData[i][hPosZ], 3.0, houseData[i][hPosWorld], houseData[i][hPosInt]); // The house exterior.
		Streamer_SetIntData(STREAMER_TYPE_AREA, houseData[i][hAreaExt], E_STREAMER_EXTRA_ID, i);
		if(houseData[i][hExtX] != 0.0 && houseData[i][hExtY] != 0.0) {
			houseData[i][hAreaInt] = CreateDynamicSphere(houseData[i][hExtX], houseData[i][hExtY], houseData[i][hExtZ], 3.0, houseData[i][hExtWorld], houseData[i][hExtInt]); // The house interior.
			Streamer_SetIntData(STREAMER_TYPE_AREA, houseData[i][hAreaInt], E_STREAMER_EXTRA_ID, i);
		}

		/*if(houseData[i][hApartment] == PROPERTY_TYPE_HOUSE)
			houseData[i][hMapIcon] = CreateDynamicMapIcon(houseData[i][hPosX], houseData[i][hPosY], houseData[i][hPosZ], 31, 0xFFFFFFFF, 0, 0);
		*/
		format(msg, sizeof(msg), "SELECT * FROM `house_furnitures` WHERE `houseid` = %d", houseData[i][hID]);
		mysql_pquery(dbCon, msg, "OnHouseFurnituresLoad", "i", i);
	}

    printf("House loaded (%d/%d)", Iter_Count(Iter_House), MAX_HOUSES);
	return 1;
}

House_SavePackage(houseid) {

	new query[1024];

	format(query, sizeof(query), "UPDATE `house` SET `weapons` = '%s' WHERE `house_id` = %d",
		FormatHouseWeapons(houseid),
		houseData[houseid][hID]
	);

	return mysql_tquery(dbCon, query);
}

FormatHouseWeapons(house)
{
	new wstr[800];
	new tmp[32];
	for(new a = 0; a != MAX_HOUSE_WEAPONS; ++a)
	{
		new w = houseData[house][hWeapon][a];
		new am = houseData[house][hAmmo][a];

		if(!a) format(tmp,sizeof(tmp),"%d=%d=0",w,am);
		else format(tmp,sizeof(tmp),"|%d=%d=0",w,am);
		strins(wstr,tmp,strlen(wstr));
	}
	return wstr;
}

AssignHouseWeapons(house, const str[])
{
	new wtmp[MAX_HOUSE_WEAPONS][32];
	strexplode(wtmp,str,"|");
	for(new z = 0; z != MAX_HOUSE_WEAPONS; ++z)
	{
		new wtmp2[3][32];
		strexplode(wtmp2,wtmp[z],"=");
		houseData[house][hWeapon][z] = strval(wtmp2[0]);
		houseData[house][hAmmo][z] = strval(wtmp2[1]);
	}
}

House_Save(houseid)
{
    if(Iter_Contains(Iter_House, houseid)) {
        new query[MAX_STRING];
        MySQLUpdateInit("house", "house_id", houseData[houseid][hID], MYSQL_UPDATE_TYPE_THREAD); 
        MySQLUpdateInt(query, "house_id", houseData[houseid][hID]);
        MySQLUpdateFlo(query, "posX", houseData[houseid][hPosX]);
        MySQLUpdateFlo(query, "posY", houseData[houseid][hPosY]);
        MySQLUpdateFlo(query, "posZ", houseData[houseid][hPosZ]);
        MySQLUpdateInt(query, "posInt", houseData[houseid][hPosInt]);
		MySQLUpdateInt(query, "posWorld", houseData[houseid][hPosWorld]);
        MySQLUpdateFlo(query, "extX", houseData[houseid][hExtX]);
        MySQLUpdateFlo(query, "extY", houseData[houseid][hExtY]);
        MySQLUpdateFlo(query, "extZ", houseData[houseid][hExtZ]);
        MySQLUpdateInt(query, "extInt", houseData[houseid][hExtInt]);
		MySQLUpdateInt(query, "extWorld", houseData[houseid][hExtWorld]);
        MySQLUpdateStr(query, "address", houseData[houseid][hAddress]);
		MySQLUpdateStr(query, "owner", houseData[houseid][hOwner]);
        MySQLUpdateInt(query, "owned", houseData[houseid][hOwned]);
        MySQLUpdateInt(query, "locked", houseData[houseid][hLocked]);
        MySQLUpdateInt(query, "marketPrice", houseData[houseid][hPrice]);
        MySQLUpdateInt(query, "levelBuy", houseData[houseid][hLevelbuy]);
        MySQLUpdateInt(query, "rentPrice", houseData[houseid][hRentPrice]);
        MySQLUpdateInt(query, "rentable", houseData[houseid][hRentable]);
		MySQLUpdateInt(query, "cash", houseData[houseid][hCash]);
		MySQLUpdateInt(query, "Apartment", houseData[houseid][hApartment]);
		MySQLUpdateInt(query, "WareHouse", houseData[houseid][hWarehouse]);
		MySQLUpdateInt(query, "bareSwitch", houseData[houseid][hBareSwitch]);
		MySQLUpdateInt(query, "switchStatus", houseData[houseid][hSwitchStatus]);
		MySQLUpdateFlo(query, "checkx", houseData[houseid][hCheckPosX]);
		MySQLUpdateFlo(query, "checky", houseData[houseid][hCheckPosY]);
		MySQLUpdateFlo(query, "checkz", houseData[houseid][hCheckPosZ]);
		MySQLUpdateInt(query, "Mats", houseData[houseid][hMats]);
		MySQLUpdateInt(query, "RMoney", houseData[houseid][hRMoney]);
		FormatHouseWeapons(houseid);
		MySQLUpdateFinish(query);
    }
	return 1;
}

GetHouseAddress(id) {
	//[ID] [Street], [Neighborhood], [City] [Area Code], San Andreas
	new addressString[128];
	if(houseData[id][hApartment] == PROPERTY_TYPE_ROOM) format(addressString, 128, houseData[id][hAddress]);
	else format(addressString, 128, "%d %s, %s, %s, San Andreas", houseData[id][hID], houseData[id][hAddress], GetCoordsZone(houseData[id][hPosX], houseData[id][hPosY]), GetCoordsCity(houseData[id][hPosX], houseData[id][hPosY]));
	return addressString;
}

hook OP_PickUpDynamicPickup(playerid, pickupid)
{
	new h = Streamer_GetIntData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_EXTRA_ID);

    if(Iter_Contains(Iter_House, h)) {
            
    	if(houseData[h][hPickup] == pickupid) {
			new string[128];
			if(houseData[h][hOwned] == 1)
			{
				if(!houseData[h][hRentable])
				{
					format(string, sizeof(string), "~w~This House is owned by~n~%s~n~Level : %d",houseData[h][hOwner],houseData[h][hLevelbuy]);
				}
				else
				{
					format(string, sizeof(string), "~w~This House is owned by~n~%s~n~Rent: $%d Level : %d~n~Type /rentroom to rent a room",houseData[h][hOwner],houseData[h][hRentPrice],houseData[h][hLevelbuy]);
				}
				GameTextForPlayer(playerid, string, 5000, 3);
				return 1;
			}
			else
			{
				format(string, sizeof(string), "~w~This House is for sale~n~Discription: %s ~n~Cost: ~g~$%d~n~~w~ Level : %d~n~to buy this house type /buyhouse",houseData[h][hAddress],houseData[h][hPrice],houseData[h][hLevelbuy]);
			}
			Mobile_GameTextForPlayer(playerid, string, 5000, 3);
    		
    		return 1;
    	}
    }
	return 1;
}

hook OP_EnterDynamicArea(playerid, areaid)
{
	new h = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID);
	if(Iter_Contains(Iter_House, h)) {
		if(areaid == houseData[h][hAreaInt] ||  areaid == houseData[h][hAreaExt]) {

			if(areaid == houseData[h][hAreaExt]) {

				// SetPlayerCheckpoint(playerid, houseData[house][hExtX], houseData[house][hExtY], houseData[house][hExtZ], 3.0, houseData[house][hExtWorld], houseData[house][hExtInt]);
			
				new welcomeMSG[128];
				if(houseData[h][hApartment] == PROPERTY_TYPE_ROOM) {
					if(houseData[h][hOwned] == 1) format(welcomeMSG, sizeof welcomeMSG, "คุณอยู่ที่หน้าประตูห้องของ %s", houseData[h][hOwner]);
					else format(welcomeMSG, sizeof welcomeMSG, "คุณอยู่ที่หน้าประตูห้อง %s", houseData[h][hAddress]);
				}
				else {
					format(welcomeMSG, sizeof welcomeMSG, GetHouseAddress(h));
				}

				if(houseData[h][hOwned] == 1 && IsHouseOwner(playerid, h))
				{
					SendClientMessage(playerid, COLOR_GREEN, welcomeMSG);
					SendClientMessage(playerid, COLOR_WHITE, "คำสั่งที่มี: /enter, /ds(hout), ddo, /knock, /myhouse");
				}
				else if(houseData[h][hOwned] == 1)
				{
					if(houseData[h][hRentable] == 1)
					{
						SendClientMessage(playerid, COLOR_LIGHTRED, "ค่าเช่าบ้านหลังนี้คือ:");
						SendClientMessageEx(playerid, COLOR_WHITE, "$%d", houseData[h][hRentPrice]);
						SendClientMessage(playerid, COLOR_WHITE, "ต้องการเช่าที่นี่ไหม /rentroom");
						SendClientMessage(playerid, COLOR_GREEN, welcomeMSG);
						SendClientMessage(playerid, COLOR_WHITE, "คำสั่งที่มี: /enter, /ds(hout), ddo, /knock");
					}
					else
					{
						SendClientMessage(playerid, COLOR_GREEN, welcomeMSG);
						SendClientMessage(playerid, COLOR_WHITE, "คำสั่งที่มี: /enter, /ds(hout), ddo, /knock");
					}
				}
				if(houseData[h][hOwned] == 0)
				{
					SendClientMessage(playerid, COLOR_GREEN, welcomeMSG);
					SendClientMessageEx(playerid, COLOR_GREEN, "ราคาบ้านหลังนี้คือ: $%d",houseData[h][hPrice]);
					SendClientMessage(playerid, COLOR_WHITE, "คำสั่ง: /buyhouse");
				}
			}
			nearHouse_var[playerid] = h;
		}
	}
	return 1;
}

hook OP_LeaveDynamicArea(playerid, areaid) {
	new h = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID);
	if(Iter_Contains(Iter_House, h)) {
		if(areaid == houseData[h][hAreaInt] ||  areaid == houseData[h][hAreaExt]) {
			// DisablePlayerCheckpoint(playerid);
	        nearHouse_var[playerid] = -1;
		}
	}
	return 1;
}

CMD:househelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
	SendClientMessage(playerid, COLOR_WHITE,"*** HOUSE HELP *** พิมพ์คำสั่งสำหรับความช่วยเหลือเพิ่มเติม");
	SendClientMessage(playerid, COLOR_GRAD3,"*** House *** /home /myhouse /setrentable /setrent /rentroom /unrent /tenants /bareswitch");
	SendClientMessage(playerid, COLOR_GRAD3,"*** House *** /evict /evictall /lock");
	SendClientMessage(playerid, COLOR_GRAD3,"*** Other *** /furniture /grantbuild");
	return 1;
}

CMD:bareswitch(playerid, params[])
{
	new house = insideHouseID[playerid];
	if (IsHouseOwner(playerid, house))
	{
	    if(houseData[house][hBareSwitch]) {

			new
				Float:fX,
	    		Float:fY,
	    		Float:fZ;

	        if(houseData[house][hSwitchStatus]) {
	            houseData[house][hSwitchStatus]=0;
	            SendClientMessage(playerid, COLOR_GRAD1, "คุณได้ปิดโหมดโล่งเตียน");
	            houseData[house][hExtZ]+=100.0;

				foreach(new i : Player)
				{
					if(insideHouseID[i] == house)
     				{
						GetPlayerPos(i, fX, fY, fZ);
						SetPlayerPos(i, fX, fY, fZ+100.5);
					}
				}
	        }
	        else {
	            houseData[house][hSwitchStatus]=1;
	            SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เปิดโหมดโล่งเตียน");
				houseData[house][hExtZ]-=100.0;

				foreach(new i : Player)
				{
					if(insideHouseID[i] == house)
     				{
						GetPlayerPos(i, fX, fY, fZ);
						SetPlayerPos(i, fX, fY, fZ-100.5);
					}
				}
	        }

			if(IsValidDynamicArea(houseData[house][hAreaInt]))
				DestroyDynamicArea(houseData[house][hAreaInt]);

			houseData[house][hAreaInt] = CreateDynamicSphere(houseData[house][hExtX], houseData[house][hExtY], houseData[house][hExtZ], 3.0, houseData[house][hExtWorld], houseData[house][hExtInt]);
			Streamer_SetIntData(STREAMER_TYPE_AREA, houseData[house][hAreaInt], E_STREAMER_EXTRA_ID, house);

			House_Save(house);
	    }
	    else SendClientMessage(playerid, COLOR_LIGHTRED, "ภายในนี้ไม่มีโหมดโล่งเตียน");
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องอยู่ในบ้านที่เป็นเจ้าของ");

	return 1;
}

CMD:home(playerid, params[])
{
	new bool:success;
	foreach(new i : Iter_House)
	{
		if(houseData[i][hOwned] == 1 && (playerData[playerid][pHouseKey] == houseData[i][hID] || IsHouseOwner(playerid, i))) {
			if(houseData[i][hApartment] == PROPERTY_TYPE_ROOM) {
				new roomid = GetComplex_RoomID(i);
				if (roomid != -1) {
					i = roomid;
				}
			}
			SetPlayerCheckpoint(playerid, houseData[i][hPosX], houseData[i][hPosY], houseData[i][hPosZ], 3.0);
			success = true;
			break;
		}
	}
	
	if (!success) {
		SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่มีที่อยู่อาศัย");
	}
}

CMD:setrentable(playerid, params[])
{
	new status;
	new house = insideHouseID[playerid];

	if (IsHouseOwner(playerid, house))
	{
		if(sscanf(params,"d",status)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /setrentable ([0/1])");
		if(status > 1 || status < 0) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /setrentable ([0/1])");
		houseData[house][hRentable] = status;
		SendClientMessageEx(playerid, COLOR_GRAD1, "คุณตั้งสถานะการเช่าเป็น %s", status ? ("เปิดให้เช่า") : ("ปิดให้เช่า"));
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องอยู่ในบ้านที่เป็นเจ้าของ");
	return 1;
}

CMD:setrent(playerid, params[])
{
	new status;
	new house = insideHouseID[playerid];

	if (IsHouseOwner(playerid, house))
	{
		if(sscanf(params,"d",status)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /setrent ($1-$10,000)");
		if(status < 1 || status > 10000) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /setrent ($1-$10,000)");
		houseData[house][hRentPrice] = status;
		SendClientMessageEx(playerid, COLOR_GRAD1, "ราคาค่าเช่าถูกตั้งเป็น $%d", houseData[house][hRentPrice]);
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องอยู่ในบ้านที่เป็นเจ้าของ");
	return 1;
}

alias:rentroom("rent");
CMD:rentroom(playerid, params[])
{
	new h = -1;
	if ((h = nearHouse_var[playerid]) != -1) {

		if(houseData[h][hOwned])
		{
			if(houseData[h][hRentable] == 0) return SendClientMessage(playerid, COLOR_GRAD1, "บ้านหลังนี้ไม่ได้เปิดให้เช่า");
			if(CountPlayerOwnHouse(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่สามารถเช่าบ้านในขณะที่เป็นเจ้าของบ้านใด ๆ ได้");
			if(playerData[playerid][pHouseKey] != 0) return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่สามารถเช่าบ้านในขณะที่คุณเป็นผู้เช่าอยู่ (/unrent)");
			if(playerData[playerid][pCash] < houseData[h][hRentPrice]) {
			    SendClientMessage(playerid, COLOR_GRAD1, "คุณมีเงินไม่พอที่จะเช่า!");
			    return 1;
			}

			playerData[playerid][pHouseKey] = houseData[h][hID];
			playerData[playerid][pSpawnType] = SPAWN_TYPE_PROPERTY;
			playerData[playerid][pCash] -= houseData[h][hRentPrice];
			houseData[h][hCash] += houseData[h][hRentPrice];

			SendClientMessage(playerid, COLOR_WHITE, "คุณจะเกิดที่นี่ในขณะนี้!");
			SendClientMessageEx(playerid, COLOR_WHITE, "ค่าเช่าบ้านหลังนี้คือ $%d", houseData[h][hRentPrice]);
			return 1;
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "บ้างหลังนี้ไม่มีเจ้าของ!");
		}
	}
	return 1;
}

CMD:unrent(playerid, params[])
{
	new housekey = House_GetID(playerData[playerid][pHouseKey]);
	if (housekey != -1) {
		if(IsHouseOwner(playerid, housekey)) return SendClientMessage(playerid, COLOR_GRAD1, "ไม่สามารถเลิกเช่าบ้านของตัวเองได้...");

		playerData[playerid][pHouseKey] = 0;
		SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้เช่าบ้านใด ๆ แล้ว");
	}
	else {
		SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้เช่าบ้านใด ๆ");
	}
	return 1;
}

CMD:tenants(playerid, params[])
{
	new house = insideHouseID[playerid];
	if (IsHouseOwner(playerid, house))
	{
		new query[128];
		format(query, sizeof(query), "SELECT id, name FROM `players` WHERE houseKey=%d AND id!=%d", houseData[house][hID], playerData[playerid][pSID]);
		mysql_tquery(dbCon, query, "ShowTenantsAmount", "i", playerid);
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องอยู่ในบ้านที่เป็นเจ้าของ");
	return 1;
}

forward ShowTenantsAmount(playerid);
public ShowTenantsAmount(playerid)
{
	new rows, tenantname[MAX_PLAYER_NAME], tid;
	cache_get_row_count(rows);
	if(!rows) return SendClientMessage(playerid, COLOR_GRAD1, "ไม่มีใครเช่าบ้านของคุณ");
	
	SendClientMessage(playerid, COLOR_YELLOW, "|_______________ผู้เช่า_______________|");
	for(new i=0; i!=rows; ++i)
	{
		cache_get_value_index_int(i, 0, tid);
		cache_get_value_index(i, 1, tenantname);
		SendClientMessageEx(playerid, COLOR_GREEN, "[ผู้เช่า %d] %s", tid, tenantname);
	}
	SendClientMessage(playerid, COLOR_YELLOW, "|_______________ผู้เช่า_______________|");
	return 1;
}


CMD:evict(playerid, params[])
{
	new tid;
	if(sscanf(params,"d", tid)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /evict [หมายเลขผู้เช่า] (/tenants)");

	new house = insideHouseID[playerid];
	if (IsHouseOwner(playerid, house))
	{
		new query[128];
		mysql_format(dbCon, query, sizeof(query), "UPDATE `players` SET houseKey=0 WHERE houseKey=%d AND id=%d", houseData[house][hID], tid);
		mysql_tquery(dbCon, query, "KickTenant", "ii", playerid, tid);
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องอยู่ในบ้านที่เป็นเจ้าของ");

	return 1;
}

forward KickTenant(playerid, tenantid);
public KickTenant(playerid, tenantid) {
	if (cache_affected_rows()) {
		foreach(new i : Player) {
			if (playerData[i][pSID] == tenantid) {
				playerData[i][pHouseKey] = 0;
				SendClientMessage(i, COLOR_GRAD1, "คุณถูกขับไล่ออกจากบ้าน คุณเป็นผู้ไร้ที่อยู่อาศัยในขณะนี้");
				break;
			}
		}
		return SendClientMessage(playerid, COLOR_GRAD1, "คุณได้ขับไล่ผู้เช่านั้นออกจากบ้านของคุณเรียบร้อยแล้ว");
	}
	return SendClientMessage(playerid, COLOR_YELLOW, "ผู้เล่นนั้นไม่ได้เช่าบ้านของคุณ");
}

CMD:evictall(playerid, params[])
{
	new house = insideHouseID[playerid];
	if (IsHouseOwner(playerid, house))
	{
		new query[90];
		format(query, sizeof(query), "UPDATE `players` SET houseKey=0 WHERE houseKey=%d AND id!=%d", houseData[house][hID], playerData[playerid][pSID]);
		mysql_tquery(dbCon, query, "KickAllTenant", "ii", playerid, houseData[house][hID]);
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องอยู่ในบ้านที่เป็นเจ้าของ");

	return 1;
}

forward KickAllTenant(playerid, house);
public KickAllTenant(playerid, house)
{
	if (cache_affected_rows()) {
		foreach(new i : Player)
		{
			if(i == playerid) continue;
			if(playerData[i][pHouseKey] == house)
			{
				playerData[i][pHouseKey] = 0;
				SendClientMessage(i, COLOR_YELLOW, "คุณถูกขับไล่ออกจากบ้านโดยเจ้าของ");
			}
		}
		return SendClientMessage(playerid, COLOR_YELLOW, "ผู้เช่าทั้งหมดถูกขับไล่ออกจากบ้านของคุณแล้ว");
	}
	return SendClientMessage(playerid, COLOR_GRAD1, "ไม่มีใครเช่าบ้านของคุณ");
}

flags:edithouse(CMD_MANAGEMENT);
CMD:edithouse(playerid, params[])
{
	new text[160], type;

	if(sscanf(params,"ds[160]", type, text)) {
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /edithouse [ตัวเลือก] [ค่า]");
		SendClientMessage(playerid, COLOR_GRAD2, "ตัวเลือกที่ใช้ได้: 1-ที่อยู่, 2-เจ้าของ, 3-เป็นเจ้าของ, 4-ล็อก, 5-ราคา, 6-เลเวลที่ซื้อได้, 7-เงินในบ้าน");
		SendClientMessage(playerid, COLOR_GRAD2, "ตัวเลือกที่ใช้ได้: 8-ประเภท");
		return 1;
	}

	new house = nearHouse_var[playerid] == -1 ? insideHouseID[playerid] : nearHouse_var[playerid];
	if (house != -1 && Iter_Contains(Iter_House, house))
	{
		switch(type) {
			case 1: {
				new info[128];
				if(sscanf(text,"s[128]", info)) {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /edithouse ที่อยู่ [ชื่อ]");
					return 1;
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนที่อยู่บ้าน #%d จาก %s เป็น %s", ReturnPlayerName(playerid), houseData[house][hID], houseData[house][hAddress], info);
				format(houseData[house][hAddress], 128, info);
				House_Save(house);
			}
			case 2: {
				new name[MAX_PLAYER_NAME];
				if(sscanf(text,"s[24]", name)) {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /edithouse เจ้าของ [ชื่อเจ้าของ]");
					return 1;
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนชื่อเจ้าของบ้าน #%d จาก %s เป็น %s", ReturnPlayerName(playerid), houseData[house][hID], houseData[house][hOwner], name);
				format(houseData[house][hOwner], MAX_PLAYER_NAME, name);
				House_Save(house);
			}
			case 3: {
				new status;
				if(sscanf(text,"i", status)) {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /edithouse เป็นเจ้าของ [0-ไม่มีเจ้าของ, 1-มีเจ้าของ]");
					return 1;
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนการเป็นเจ้าของบ้าน #%d เป็น %s", ReturnPlayerName(playerid), houseData[house][hID], (!!status) ? ("มีเจ้าของ") : ("ไม่มีเจ้าของ"));
				houseData[house][hOwned] = !!status;
				House_Save(house);
			}
			case 5: {
				new price;
				if(sscanf(text,"d", price)) {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /edithouse ราคา [จำนวน]");
					return 1;
				}
				if (price <= 0 || price >= 50000000) {
					SendClientMessage(playerid, COLOR_GRAD1, "   ราคาบ้านต้องไม่ต่ำกว่าหรือเท่ากับ 0");
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนราคาของบ้าน #%d จาก %d เป็น %d", ReturnPlayerName(playerid), houseData[house][hID], houseData[house][hPrice], price);
				houseData[house][hPrice] = price;
				House_Save(house);
			}
			case 6: {
				new level;
				if(sscanf(text,"d", level)) {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /edithouse เลเวลที่ซื้อได้ [เลเวล]");
					return 1;
				}
				if (level <= 0 || level >= 50000000) {
					SendClientMessage(playerid, COLOR_GRAD1, "   เลเวลขั้นต่ำในการซื้อบ้านต้องไม่ต่ำกว่าหรือเท่ากับ 0");
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนเลเวลขั้นต่ำในการซื้อของบ้าน #%d จาก %d เป็น %d", ReturnPlayerName(playerid), houseData[house][hID], houseData[house][hLevelbuy], level);
				houseData[house][hLevelbuy] = level;
				House_Save(house);
			}
			case 7: {
				new till;
				if(sscanf(text,"d", till)) {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /edithouse เงินในบ้าน [จำนวน]");
					return 1;
				}
				if (till <= 0 || till >= 50000000) {
					SendClientMessage(playerid, COLOR_GRAD1, "   เงินในบ้านต้องไม่ต่ำกว่าหรือเท่ากับ 0");
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนเงินของบ้าน #%d จาก %d เป็น %d", ReturnPlayerName(playerid), houseData[house][hID], houseData[house][hCash], till);
				houseData[house][hCash] = till;
				House_Save(house);
			}
			case 8: {
				new htype;
				if(sscanf(text,"d", htype)) {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /edithouse ประเภท [หมายเลข]");
					ShowAllBusinessType(playerid);
					return 1;
				}
				if(htype < 1 || htype > 3) {
					SendClientMessage(playerid, COLOR_GRAD1, "   ประเภทต้องเป็น 1 ถึง 3 เท่านั้น !!");
					return 1;
				}
			
				new 
					pint=GetPlayerInterior(playerid), 
					pworld=GetPlayerVirtualWorld(playerid);

				if(htype == PROPERTY_TYPE_HOUSE && (pworld != 0 || pint != 0))
					return SendClientMessage(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"ไม่สามารถสร้างบ้านไว้ภายในอื่นได้");
				else if(htype == PROPERTY_TYPE_APART && (pworld != 0 || pint != 0))
					return SendClientMessage(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"ไม่สามารถสร้างอพาร์ทเม้นท์ไว้ภายในอื่นได้");
				else if(htype == PROPERTY_TYPE_ROOM && (pworld == 0))
					return SendClientMessage(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"ไม่สามารถสร้างห้องอพาร์ทเม้นท์ไว้ภายนอกอาคารได้");

				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนประเภทของบ้าน #%d จาก %d เป็น %d", ReturnPlayerName(playerid), houseData[house][hID], houseData[house][hApartment], htype);
				houseData[house][hApartment]=htype;
				House_Save(house);
			}
		}
	}
	else return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่ได้อยู่ใกล้บ้านใด ๆ");
	return 1;
}

CMD:myhouse(playerid, params[])
{
    new option[10], param2[128];
	new house = nearHouse_var[playerid] == -1 ? insideHouseID[playerid] : nearHouse_var[playerid];

	if (house != -1 && IsHouseOwner(playerid, house))
	{
		if(sscanf(params, "s[10]S()[128]", option, param2)) {
			SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /myhouse [ตัวเลือก]");
			SendClientMessage(playerid, COLOR_GRAD2, "[ตัวเลือก] เงินสด | ดินปืน | เงินแดง |ข้อมูล");
			return 1;
		}
    	if(!strcmp(option, "ข้อมูล", true))
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "ข้อมูลบ้าน: บ้านไอดี - %d ราคาตลาด - $%d ราคาเช่า - $%d", houseData[house][hID], houseData[house][hPrice], houseData[house][hRentPrice]);
		}
    	/*else if(!strcmp(option, "ไอเท็ม", true))
		{
			if (insideHouseID[playerid] != -1 && insideHouseID[playerid] == house) {
				ShowHouseItemDetail(playerid, house);
			}
			else SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องอยู่ในบ้านที่คุณเป็นเจ้าของ");
		}*/
		else if(!strcmp(option, "เงินสด", true))
		{
			if (insideHouseID[playerid] != -1 && insideHouseID[playerid] == house) {
				new amount;
				if(sscanf(param2, "s[10]d", option, amount))
				{
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /myhouse เงินสด [ถอน/ฝาก] [จำนวน]");
					SendClientMessageEx(playerid, COLOR_GRAD1, "คุณมี $%d อยู่ในกล่องเงินสด", houseData[house][hCash]);
					return 1;
				}

				if(!strcmp(option, "ถอน", true))
				{
					if (amount > houseData[house][hCash] || amount < 1) 
						return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้มีมากขนาดนั้น!");

					playerData[playerid][pCash] += amount;
					houseData[house][hCash] -= amount;

					SendClientMessageEx(playerid, COLOR_GRAD1, "คุณถอน $%d จากกล่องเงินสด ยอดคงเหลือ: $%d ", amount, houseData[house][hCash]);
            		SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdmCmd: %s ได้ทำการถอนเงินในบ้านจำนวน %s (ปัจจุบันบ้านไอดี %d มีเงินในบ้านทั้งหมด %s)", ReturnPlayerName(playerid), FormatNumber(amount), house, FormatNumber(houseData[house][hCash]));

				}
				else if(!strcmp(option, "ฝาก", true))
				{
					if (amount > playerData[playerid][pCash] || amount < 1)
						return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้มีมากขนาดนั้น!");

					playerData[playerid][pCash] -= amount;
					houseData[house][hCash] += amount;
					SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้วาง $%d ในกล่องเงินสดของคุณ ยอดรวมทั้งหมด: $%d ", amount, houseData[house][hCash]);
				
            		SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdmCmd: %s ได้ทำการฝากเงินในบ้านจำนวน %s (ปัจจุบันบ้านไอดี %d มีเงินในบ้านทั้งหมด %s)", ReturnPlayerName(playerid), FormatNumber(amount), house, FormatNumber(houseData[house][hCash]));
				}
				else {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /myhouse เงินสด [ถอน/ฝาก] [จำนวน]");
				}
			}
			else SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องอยู่ในบ้านที่คุณเป็นเจ้าของ");
		}

		else if(!strcmp(option, "ดินปืน", true))
		{
			if (insideHouseID[playerid] != -1 && insideHouseID[playerid] == house) {
				new amount;
				if(sscanf(param2, "s[10]d", option, amount))
				{
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /myhouse ดินปืน [ถอน/ฝาก] [จำนวน]");
					SendClientMessageEx(playerid, COLOR_GRAD1, "คุณมีดินปืนอยู่จำนวน %d ในคลังเก็บของบ้านของคุณ", houseData[house][hMats]);
					return 1;
				}

				if(!strcmp(option, "ถอน", true))
				{
					if (amount > houseData[house][hMats] || amount < 1) 
						return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้มีมากขนาดนั้น!");

					playerData[playerid][pMaterials] += amount;
					houseData[house][hMats] -= amount;
					House_Save(house);

					SendClientMessageEx(playerid, COLOR_GRAD1, "คุณถอน $%d จากคลังบ้าน, ยอดคงเหลือ: $%d ", amount, houseData[house][hMats]);
				}
				else if(!strcmp(option, "ฝาก", true))
				{
					if (amount > playerData[playerid][pMaterials] || amount < 1)
						return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้มีมากขนาดนั้น!");

					playerData[playerid][pMaterials] -= amount;
					houseData[house][hMats] += amount;
					House_Save(house);

					SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้วาง $%d จากคลังบ้าน, ยอดรวมทั้งหมด: $%d ", amount, houseData[house][hMats]);
				}
				else {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /myhouse ดินปืน [ถอน/ฝาก] [จำนวน]");
				}
			}
			else SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องอยู่ในบ้านที่คุณเป็นเจ้าของ");
		}

		else if(!strcmp(option, "เงินแดง", true))
		{
			if (insideHouseID[playerid] != -1 && insideHouseID[playerid] == house) {
				new amount;
				if(sscanf(param2, "s[10]d", option, amount))
				{
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /myhouse เงินแดง [ถอน/ฝาก] [จำนวน]");
					SendClientMessageEx(playerid, COLOR_GRAD1, "คุณมีเงินแดงอยู่จำนวน %d ในคลังเก็บของบ้านของคุณ", houseData[house][hRMoney]);
					return 1;
				}

				if(!strcmp(option, "ถอน", true))
				{
					if (amount > houseData[house][hRMoney] || amount < 1) 
						return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้มีมากขนาดนั้น!");

					playerData[playerid][pRMoney] += amount;
					houseData[house][hRMoney] -= amount;
					House_Save(house);

					SendClientMessageEx(playerid, COLOR_GRAD1, "คุณถอน $%d จากคลังบ้าน, ยอดคงเหลือ: $%d ", amount, houseData[house][hRMoney]);
				}
				else if(!strcmp(option, "ฝาก", true))
				{
					if (amount > playerData[playerid][pRMoney] || amount < 1)
						return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้มีมากขนาดนั้น!");

					playerData[playerid][pRMoney] -= amount;
					houseData[house][hRMoney] += amount;
					House_Save(house);
					
					SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้วาง $%d จากคลังบ้าน, ยอดรวมทั้งหมด: $%d ", amount, houseData[house][hRMoney]);
				}
				else {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /myhouse เงินแดง [ถอน/ฝาก] [จำนวน]");
				}
			}
			else SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องอยู่ในบ้านที่คุณเป็นเจ้าของ");
		}

		else {
			SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /myhouse [ตัวเลือก]");
			SendClientMessage(playerid, COLOR_GRAD2, "[ตัวเลือก] เงินสด | ข้อมูล");
		}
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องอยู่ในบริเวณบ้านที่คุณเป็นเจ้าของ");
	return 1;
}

flags:housecmds(CMD_MANAGEMENT);
CMD:housecmds(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GRAD1, "คำสั่ง: /makehouse, /houseenter, /houseexit, /edithouse, /sethint, /gotohouse");
	return 1;
}

flags:makehouse(CMD_MANAGEMENT);
CMD:makehouse(playerid, params[])
{
	new houseid, buylevel, price, type, hinfo[MAX_STREET_NAME];
	if(sscanf(params,"ddds[30]", type, buylevel, price, hinfo)) {
        SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /makehouse [ประเภท] [เลเวล] [ราคา] [รายละเอียด(ถนน/ห้อง)]");
        SendClientMessage(playerid, COLOR_GRAD2, "[ประเภท] 1: บ้าน 2: อพาร์ทเม้นท์ 3: ห้องอพาร์ทเม้นท์");
		return 1;
	}
	if(type < 1 || type > 3) {
        SendClientMessage(playerid, COLOR_GRAD1, "   ประเภทต้องเป็น 1 ถึง 3 เท่านั้น !!");
		return 1;
	}

    if((houseid = Iter_Free(Iter_House)) != -1) {

		new 
			pint=GetPlayerInterior(playerid), 
			pworld=GetPlayerVirtualWorld(playerid);

		if(type == PROPERTY_TYPE_HOUSE && (pworld != 0 || pint != 0))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"ไม่สามารถสร้างบ้านไว้ภายในอื่นได้");
		else if(type == PROPERTY_TYPE_APART && (pworld != 0 || pint != 0))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"ไม่สามารถสร้างอพาร์ทเม้นท์ไว้ภายในอื่นได้");
		else if(type == PROPERTY_TYPE_ROOM && (pworld == 0))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"ไม่สามารถสร้างห้องอพาร์ทเม้นท์ไว้ภายนอกอาคารได้");

		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);

		houseData[houseid][hPosX] = x;
		houseData[houseid][hPosY] = y;
		houseData[houseid][hPosZ] = z;
		houseData[houseid][hPosInt] = pint;
		houseData[houseid][hPosWorld] = pworld;
		houseData[houseid][hExtX] = 0.0;
		houseData[houseid][hExtY] = 0.0;
		houseData[houseid][hExtZ] = 0.0;
		houseData[houseid][hExtInt] = 0;
		houseData[houseid][hExtWorld] = 0;
		houseData[houseid][hPrice] = price;
		houseData[houseid][hOwned] = 0;
		houseData[houseid][hLocked] = 1;
		houseData[houseid][hRentPrice] = 0;
		houseData[houseid][hRentable] = 0;
		houseData[houseid][hCash] = 0;
		houseData[houseid][hBareSwitch] = 0;
		houseData[houseid][hSwitchStatus] = 0;
		houseData[houseid][hLevelbuy] = buylevel;
		houseData[houseid][hWarehouse]=-1;
		houseData[houseid][hApartment]=type;

		houseData[houseid][hRMoney] = 0;
		houseData[houseid][hMats] = 0;
	
		format(houseData[houseid][hAddress], MAX_STREET_NAME, hinfo);
		format(houseData[houseid][hOwner], MAX_PLAYER_NAME, "รัฐ");

		if(IsValidDynamicArea(houseData[houseid][hAreaExt]))
			DestroyDynamicArea(houseData[houseid][hAreaExt]);

		houseData[houseid][hAreaExt] = CreateDynamicSphere(houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ], 3.0, houseData[houseid][hPosWorld], houseData[houseid][hPosInt]); // The house exterior.	
		Streamer_SetIntData(STREAMER_TYPE_AREA, houseData[houseid][hAreaExt], E_STREAMER_EXTRA_ID, houseid);

		if(houseData[houseid][hApartment] == PROPERTY_TYPE_APART) houseData[houseid][hPickup] = CreateDynamicPickup(1314, 23, houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ], 0, 0);
		else if(houseData[houseid][hApartment] == PROPERTY_TYPE_HOUSE) {
			houseData[houseid][hPickup] = CreateDynamicPickup(1273, 23, houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ], 0, 0);
			Streamer_SetIntData(STREAMER_TYPE_PICKUP, houseData[houseid][hPickup], E_STREAMER_EXTRA_ID, houseid);
		}
		houseData[houseid][hCheckPoint] = CreateDynamicCP(houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ], 3.0, houseData[houseid][hPosWorld], houseData[houseid][hPosInt], -1, 3.5);

		if(houseData[houseid][hApartment] == PROPERTY_TYPE_HOUSE)
			houseData[houseid][hMapIcon] = CreateDynamicMapIcon(houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ], 31, 0xFFFFFFFF, 0, 0);


		new query[256];
		mysql_format(dbCon, query, sizeof query, "INSERT INTO `house` (`levelBuy`,`marketPrice`) VALUES(%d,%d)", buylevel, price);
		mysql_tquery(dbCon, query, "OnHouseCreated", "ii", playerid, houseid);
    }
	else SendClientMessageEx(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"ไม่สามารถสร้างบ้านได้มากกว่านี้แล้ว จำกัดไว้ที่ "EMBED_ORANGE"%d", MAX_HOUSES);

	return 1;
}

forward OnHouseCreated(playerid, houseid);
public OnHouseCreated(playerid, houseid)
{
	new insert_id = cache_insert_id();
	if(insert_id) {
		Iter_Add(Iter_House, houseid);
		houseData[houseid][hID] = cache_insert_id();

		if(houseData[houseid][hApartment] != PROPERTY_TYPE_APART) {
			new str[128];
			format(str, sizeof(str), ""EMBED_YELLOW"%s\nราคา: $%d\nเลเวล: %d", GetHouseAddress(houseid), houseData[houseid][hPrice], houseData[houseid][hLevelbuy]);
			houseData[houseid][hLabel] = CreateDynamic3DTextLabel(str, -1, houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, houseData[houseid][hPosWorld], houseData[houseid][hPosInt], -1, 100.0);
		}

		House_Save(houseid);
	}
	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"ไม่สามารถเพิ่มข้อมูลบ้านลงฐานข้อมูลได้ โปรดติดต่อ DEV");
	}
	return 1;
}

CountPlayerOwnHouse(playerid)
{
	new hcount;
	foreach(new i : Iter_House)
	{
		if(houseData[i][hOwned] == 1 && IsHouseOwner(playerid, i)) hcount++;
	}
	return hcount;
}

CMD:buyhouse(playerid, params[])
{
	new confirm[8], h = -1;

	if ((h = nearHouse_var[playerid]) != -1 && !houseData[h][hOwned]) {

		if(houseData[h][hApartment] == PROPERTY_TYPE_APART)
			return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่สามารถซื้ออสังหาริมทรัพย์นี้ได้!");

		new numhouse = CountPlayerOwnHouse(playerid);
		new extra_price = numhouse * 10;
		new houseprice = houseData[h][hPrice];

		if(extra_price) 
			houseprice *= extra_price;

   		if(!sscanf(params, "s[8]", confirm) && !strcmp(confirm, "yes", true)) {

			if(numhouse >= MAX_OWN_HOUSE) return SendClientMessage(playerid, COLOR_GRAD1, "คุณมีบ้านเต็มจำนวนสูงสุดแล้ว ใช้ /sellhouse เพื่อขายบ้านของคุณ");
			if(playerData[playerid][pLevel] < houseData[h][hLevelbuy]) return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่สามารถซื้ออสังหาริมทรัพย์นี้ได้!");
			if(playerData[playerid][pCash] < houseprice || houseprice <= 0) return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่สามารถซื้ออสังหาริมทรัพย์นี้ได้!");

			playerData[playerid][pHouseKey] = houseData[h][hID];
			playerData[playerid][pSpawnType] = SPAWN_TYPE_PROPERTY;
			houseData[h][hOwned] = 1;
			houseData[h][hLocked] = 1;
			houseData[h][hRentable] = 0;
			houseData[h][hRentPrice] = 0;
			houseData[h][hCash] = 0;
			houseData[h][hMats] = 0;
			houseData[h][hRMoney] = 0;
			strmid(houseData[h][hOwner], ReturnPlayerName(playerid), 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
			playerData[playerid][pCash]-=houseprice;

			SendClientMessage(playerid, COLOR_WHITE, "ขอแสดงความยินดีในการสั่งซื้อใหม่ของคุณ!");
			SendClientMessage(playerid, COLOR_WHITE, "ใช้ /help เพื่อการตรวจสอบการเข้าถึงใหม่ของคุณ  !");

			if(IsValidDynamic3DTextLabel(STREAMER_TAG_3D_TEXT_LABEL:houseData[h][hLabel])) 
				DestroyDyn3DTextLabelFix(STREAMER_TAG_3D_TEXT_LABEL:houseData[h][hLabel]);

			House_Save(h);
			OnAccountUpdate(playerid);

			return 1;
		}
	 	else
	 	{
	 	    SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /buyhouse yes");
			SendClientMessageEx(playerid, COLOR_GREY, "บ้านที่คุณกำลังซื้อราคา $%d", houseprice);
	 	}
 	}
	return 1;
}

CMD:sellhouse(playerid, params[])
{
	new confirm[8], houseid = -1, str[128];
	if ((houseid = nearHouse_var[playerid]) != -1) {
		if(IsHouseOwner(playerid, houseid))
		{
			new houseprice = houseData[houseid][hPrice];
			new housetax = floatround(houseprice / 100.0);
			if(!sscanf(params, "s[8]", confirm) && !strcmp(confirm, "yes", true)) {

				if(houseData[houseid][hCash] > 0)
				{
					playerData[playerid][pCash] += houseData[houseid][hCash];
					SendClientMessageEx(playerid, COLOR_GRAD2, "คุณได้รับเงินสดจากบ้าน $%d", houseData[houseid][hCash]);
				}
				houseData[houseid][hLocked] = 1;
				houseData[houseid][hOwned] = 0;
				houseData[houseid][hRentable] = 0;
				houseData[houseid][hRentPrice] = 0;
				houseData[houseid][hCash] = 0;

				houseData[houseid][hRMoney] = 0;
				houseData[houseid][hMats] = 0;

				if(playerData[playerid][pHouseKey] == houseData[houseid][hID]) {
					playerData[playerid][pSpawnType] = SPAWN_TYPE_DEFAULT;
				}

				strmid(houseData[houseid][hOwner], "รัฐ", 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);

				playerData[playerid][pCash] += houseprice-housetax;

				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				format(str, sizeof(str), "~w~Congratulations~n~ You have sold your property for ~n~~g~$%d", houseprice-housetax);
				GameTextForPlayer(playerid, str, 10000, 3);
				SendClientMessageEx(playerid, COLOR_GRAD3, "ภาษีของรัฐ: $%d", housetax);

				format(str, sizeof(str), ""EMBED_YELLOW"%s\nราคา: $%d\nเลเวล: %d", GetHouseAddress(houseid), houseData[houseid][hPrice], houseData[houseid][hLevelbuy]);
				houseData[houseid][hLabel] = CreateDynamic3DTextLabel(str, -1, houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, houseData[houseid][hPosWorld], houseData[houseid][hPosInt], -1, 100.0);

				House_Save(houseid);

				format(str, sizeof(str), "UPDATE `players` SET `House`=0 WHERE `House`=%d", houseData[houseid][hID]);
				mysql_tquery(dbCon, str, "OnPlayerSellHouse", "i", houseid);

				playerData[playerid][pHouseKey] = 0;

				return 1;
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /sellhouse yes");
				SendClientMessageEx(playerid, COLOR_GREY, "บ้านที่คุณกำลังขายราคา $%d และมีภาษี $%d", houseprice, housetax);
			}
		}
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องอยู่ในบ้านที่เป็นเจ้าของ");
	return 1;
}

House_GetID(houseid) {
	foreach(new i : Iter_House) {
		if(houseData[i][hID] == houseid) {
			return i;
		}
	}
	return -1;
}

GetComplex_RoomID(roomid) {
	if(Iter_Contains(Iter_House, roomid) && houseData[roomid][hApartment] == PROPERTY_TYPE_ROOM) {
		foreach(new i : Iter_House) {
			if(houseData[i][hApartment] == PROPERTY_TYPE_APART && houseData[i][hID] == houseData[roomid][hPosWorld] - HOUSE_WORLD) {
				return i;
			}
		}
	}
	return -1;
}

forward OnPlayerSellHouse(houseid);
public OnPlayerSellHouse(houseid)
{
	foreach(new i : Player)
	{
		if(playerData[i][pHouseKey] == houseData[houseid][hID])
		{
			SendClientMessage(i, COLOR_GRAD1, "บ้านที่คุณเช่าถูกขายแล้ว ตอนนี้คุณไม่มีที่อยู่อาศัย");
			playerData[i][pHouseKey] = 0;
		}
	}
	return 1;
}

flags:houseenter(CMD_MANAGEMENT);
CMD:houseenter(playerid,params[])
{
	new hid = -1;
	if(sscanf(params,"d",hid)) {
        return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /houseenter [ไอดีบ้าน]");
	}
	new houseid = House_GetID(hid);
	
	if(!Iter_Contains(Iter_House, houseid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   ไอดีบ้านไม่ถูกต้อง !!");

	new Float:px,Float:py,Float:pz;
	GetPlayerPos(playerid, px, py, pz);

	new 
		pint=GetPlayerInterior(playerid), 
		pworld=GetPlayerVirtualWorld(playerid);

	if(houseData[houseid][hApartment] == PROPERTY_TYPE_HOUSE && (pworld != 0 || pint != 0)) // House
		return SendClientMessage(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"ไม่สามารถปรับทางเข้าของบ้านไว้ภายในอื่นได้");
	else if(houseData[houseid][hApartment] == PROPERTY_TYPE_APART && (pworld != 0 || pint != 0)) // Complex
		return SendClientMessage(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"ไม่สามารถปรับทางเข้าอพาร์ทเม้นท์ไว้ภายในอื่นได้");
	else if(houseData[houseid][hApartment] == PROPERTY_TYPE_ROOM && (pworld == 0)) // Room
		return SendClientMessage(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"ไม่สามารถปรับทางเข้าห้องอพาร์ทเม้นท์ไว้ภายนอกอาคารได้");

	houseData[houseid][hPosX] = px;
	houseData[houseid][hPosY] = py;
	houseData[houseid][hPosZ] = pz;
	houseData[houseid][hPosInt] = pint;
	houseData[houseid][hPosWorld] = pworld;

	if(IsValidDynamicArea(houseData[houseid][hAreaExt]))
		DestroyDynamicArea(houseData[houseid][hAreaExt]);

	if(IsValidDynamicPickup(houseData[houseid][hPickup]))
		DestroyDynamicPickup(houseData[houseid][hPickup]);

	if(IsValidDynamicCP(houseData[houseid][hCheckPoint]))
		DestroyDynamicCP(houseData[houseid][hCheckPoint]);

	if(IsValidDynamic3DTextLabel(houseData[houseid][hLabel]))
		DestroyDyn3DTextLabelFix(houseData[houseid][hLabel]);

	if (IsValidDynamicMapIcon(houseData[houseid][hMapIcon])) {
		DestroyDynamicMapIcon(houseData[houseid][hMapIcon]);
	}

	if(houseData[houseid][hApartment] == PROPERTY_TYPE_HOUSE)
		houseData[houseid][hMapIcon] = CreateDynamicMapIcon(houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ], 31, 0xFFFFFFFF, 0, 0);

	houseData[houseid][hAreaExt] = CreateDynamicSphere(houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ], 3.0, houseData[houseid][hPosWorld], houseData[houseid][hPosInt]); // The house exterior.	
	Streamer_SetIntData(STREAMER_TYPE_AREA, houseData[houseid][hAreaExt], E_STREAMER_EXTRA_ID, houseid);

	if(houseData[houseid][hApartment] == PROPERTY_TYPE_APART) houseData[houseid][hPickup] = CreateDynamicPickup(1314, 23, houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ], 0, 0);
	else if(houseData[houseid][hApartment] == PROPERTY_TYPE_HOUSE) { 
		houseData[houseid][hPickup] = CreateDynamicPickup(1273, 23, houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ], 0, 0);
		Streamer_SetIntData(STREAMER_TYPE_PICKUP, houseData[houseid][hPickup], E_STREAMER_EXTRA_ID, houseid);
	}
	houseData[houseid][hCheckPoint] = CreateDynamicCP(houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ], 3.0, houseData[houseid][hPosWorld], houseData[houseid][hPosInt], -1, 3.5);

	new query[128];
	if(houseData[houseid][hApartment] != PROPERTY_TYPE_APART) {
		format(query, sizeof(query), ""EMBED_YELLOW"%s\nราคา: $%d\nเลเวล: %d", GetHouseAddress(houseid), houseData[houseid][hPrice], houseData[houseid][hLevelbuy]);
		houseData[houseid][hLabel] = CreateDynamic3DTextLabel(query, -1, houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 100.0);
	}

	House_Save(houseid);
	SendClientMessageEx(playerid, COLOR_GRAD1, "   บ้านไอดี %d ถูกปรับทางเข้าใหม่เรียบร้อยแล้ว !!", houseData[houseid][hID]);
	
	return 1;
}

flags:houseexit(CMD_MANAGEMENT);
CMD:houseexit(playerid,params[])
{
	new hid = -1;
	if(sscanf(params,"d",hid)) {
        return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /houseexit [ไอดีบ้าน]");
	}
	new houseid = House_GetID(hid);
	
	if(!Iter_Contains(Iter_House, houseid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   ไอดีบ้านไม่ถูกต้อง !!");

	new Float:px,Float:py,Float:pz;
	GetPlayerPos(playerid, px, py, pz);

	houseData[houseid][hSwitchStatus] = 0;
	houseData[houseid][hExtX] = px;
	houseData[houseid][hExtY] = py;
	houseData[houseid][hExtZ] = pz;
	houseData[houseid][hExtInt] = GetPlayerInterior(playerid);
	houseData[houseid][hExtWorld] = houseData[houseid][hID] + HOUSE_WORLD;
	insideHouseID[playerid] = houseid;
	SetPlayerVirtualWorld(playerid, houseData[houseid][hExtWorld]);

	if(IsValidDynamicArea(houseData[houseid][hAreaInt]))
		DestroyDynamicArea(houseData[houseid][hAreaInt]);

	houseData[houseid][hAreaInt] = CreateDynamicSphere(houseData[houseid][hExtX], houseData[houseid][hExtY], houseData[houseid][hExtZ], 3.0, houseData[houseid][hExtWorld], houseData[houseid][hExtInt]);
	Streamer_SetIntData(STREAMER_TYPE_AREA, houseData[houseid][hAreaInt], E_STREAMER_EXTRA_ID, houseid);

	House_Save(houseid);
	SendClientMessageEx(playerid, COLOR_GRAD1, "   บ้านไอดี %d ถูกปรับทางออกใหม่เรียบร้อยแล้ว !!", houseData[houseid][hID]);

	return 1;
}

IsPlayerAtHouseArea(playerid) {
	new id = nearHouse_var[playerid];
	if (id != -1 && Iter_Contains(Iter_House, id) && (IsPlayerInRangeOfPoint(playerid, 3.0, houseData[id][hExtX],houseData[id][hExtY],houseData[id][hExtZ]) || (IsPlayerInRangeOfPoint(playerid, 3.0, houseData[id][hPosX],houseData[id][hPosY],houseData[id][hPosZ]) && houseData[id][hPosX] != 0.0 && houseData[id][hPosY] != 0.0))) return true;	
	else return false;
}

IsPlayerAtHouseEntrance(playerid) {
	new id = nearHouse_var[playerid];
	if (id != -1 && Iter_Contains(Iter_House, id) && IsPlayerInRangeOfPoint(playerid, 3.0, houseData[id][hPosX],houseData[id][hPosY],houseData[id][hPosZ]) && houseData[id][hPosX] != 0.0 && houseData[id][hPosY] != 0.0) return true;
	else return false;
}

IsPlayerAtHouseExit(playerid) {
	new id = nearHouse_var[playerid];
	if (id != -1 && Iter_Contains(Iter_House, id) && IsPlayerInRangeOfPoint(playerid, 3.0, houseData[id][hExtX],houseData[id][hExtY],houseData[id][hExtZ])) return true;
	else return false;
}

House_DynamicPos(playerid, world, &Float:X, &Float:Y, &Float:Z) {
	new id = insideHouseID[playerid];
	if (Iter_Contains(Iter_House, id) && houseData[id][hPosWorld] == world) {
		X = houseData[id][hExtX];
		Y = houseData[id][hExtY];
		Z = houseData[id][hExtZ];
		return id;
	}
	return -1;
}

PlayerLockHouse(playerid) {
	new id = nearHouse_var[playerid];
	if (id != -1 && Iter_Contains(Iter_House, id) && (IsPlayerInRangeOfPoint(playerid, 3.0, houseData[id][hExtX],houseData[id][hExtY],houseData[id][hExtZ]) || (IsPlayerInRangeOfPoint(playerid, 3.0, houseData[id][hPosX],houseData[id][hPosY],houseData[id][hPosZ]) && houseData[id][hPosX] != 0.0 && houseData[id][hPosY] != 0.0)))
	{
		if(houseData[id][hLocked] == 1)
		{
			houseData[id][hLocked] = 0;
			GameTextForPlayer(playerid, "~w~House ~g~Unlocked", 5000, 6);
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		}
		else {
			houseData[id][hLocked] = 1;
			GameTextForPlayer(playerid, "~w~House ~r~Locked", 5000, 6);
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		}
		House_Save(id);
	}
	return 1;
}

PlayerEnterNearestHouse(playerid) {
	new id = nearHouse_var[playerid];
	if (id != -1 && Iter_Contains(Iter_House, id) && houseData[id][hPosX] != 0.0 && houseData[id][hPosY] != 0.0 && houseData[id][hExtX] != 0.0 && houseData[id][hExtY] != 0.0)
	{
		if(houseData[id][hLocked] == 1) 
			return GameTextForPlayer(playerid, "~r~Locked", 5000, 1);

		SetPlayerPos(playerid,houseData[id][hExtX],houseData[id][hExtY],houseData[id][hExtZ]);
		SetPlayerInterior(playerid,houseData[id][hExtInt]);
		SetPlayerVirtualWorld(playerid,houseData[id][hExtWorld]);
		playerData[playerid][pInterior] = houseData[id][hExtInt];
		playerData[playerid][pVWorld] = houseData[id][hExtWorld];
		insideHouseID[playerid] = id;

		if(playerData[playerid][pHouseKey] == houseData[id][hID]) 
			return GameTextForPlayer(playerid, "~w~Welcome to the house", 5000, 1);
	}
	return 1;
}

PlayerExitHouse(playerid) {
	new id = nearHouse_var[playerid];
	if (id != -1 && Iter_Contains(Iter_House, id) && IsPlayerInRangeOfPoint(playerid, 3.0, houseData[id][hExtX],houseData[id][hExtY],houseData[id][hExtZ])) {

		SetCameraBehindPlayer(playerid);
		SetPlayerPos(playerid,houseData[id][hPosX],houseData[id][hPosY],houseData[id][hPosZ]);
		SetPlayerInterior(playerid,houseData[id][hPosInt]);
		SetPlayerVirtualWorld(playerid,houseData[id][hPosWorld]);
		playerData[playerid][pInterior] = houseData[id][hPosInt];
		playerData[playerid][pVWorld] = houseData[id][hPosWorld];
		insideHouseID[playerid] = -1;
		//grantbuild[playerid]=-1;
	}
	return 1;
}

House_GetInsideID(playerid) {
	return insideHouseID[playerid];
}
/*
CMD:enter_house(playerid, params[])
{
	new id = -1;

	if ((id = nearHouse_var[playerid]) != -1 && houseData[id][hPosX] != 0.0 && houseData[id][hPosY] != 0.0)
	{
		if(houseData[id][hLocked] == 1) 
			return GameTextForPlayer(playerid, "~r~Locked", 5000, 1);

		SetPlayerPos(playerid,houseData[id][hExtX],houseData[id][hExtY],houseData[id][hExtZ]);
		SetPlayerInterior(playerid,houseData[id][hExtInt]);
		SetPlayerVirtualWorld(playerid,houseData[id][hExtWorld]);
		playerData[playerid][pInterior] = houseData[id][hExtInt];
		playerData[playerid][pVWorld] = houseData[id][hExtWorld];
		insideHouseID[playerid] = id;

		if(playerData[playerid][pHouseKey] == houseData[id][hID]) 
			GameTextForPlayer(playerid, "~w~Welcome to the house", 5000, 1);
	}
	return 1;
}

CMD:exit_house(playerid, params[])
{
	new id;

	if ((id = nearHouse_var[playerid]) != -1 && IsPlayerInRangeOfPoint(playerid, 3.0, houseData[id][hExtX],houseData[id][hExtY],houseData[id][hExtZ])) {

		SetCameraBehindPlayer(playerid);
	
		SetPlayerPos(playerid,houseData[id][hPosX],houseData[id][hPosY],houseData[id][hPosZ]);
		SetPlayerInterior(playerid,houseData[id][hPosInt]);
		SetPlayerVirtualWorld(playerid,houseData[id][hPosWorld]);
		playerData[playerid][pInterior] = houseData[id][hPosInt];
		playerData[playerid][pVWorld] = houseData[id][hPosWorld];
		
		//grantbuild[playerid]=-1;
	}
	return 1;
}
*/

flags:gotohouse(CMD_ADM_2);
CMD:gotohouse(playerid,params[])
{
	new hid = -1;
	if(sscanf(params,"d",hid)) {
        return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /gotohouse [ไอดีบ้าน]");
	}
	new houseid = House_GetID(hid);
	
	if(!Iter_Contains(Iter_House, houseid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   ไอดีบ้านไม่ถูกต้อง !!");


	SetPlayerVirtualWorld(playerid, houseData[houseid][hPosWorld]);
	SetPlayerInterior(playerid, houseData[houseid][hPosInt]);
	SetPlayerPos(playerid, houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ]);

	SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณได้วาร์ปไปยังบ้านไอดี %d", houseData[houseid][hID]);
	
	return 1;
}

flags:sethint(CMD_MANAGEMENT);
CMD:sethint(playerid,params[])
{
	new str[512];
	new hid = -1;
	if(sscanf(params,"d",hid)) {
        return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /sethint [ไอดีบ้าน]");
	}
	new houseid = House_GetID(hid);

	if(!Iter_Contains(Iter_House, houseid)) 
			return SendClientMessage(playerid, COLOR_GRAD1, "   ไอดีบ้านไม่ถูกต้อง !!");

	SetPVarInt(playerid, "SetHouseInterior", houseid);

	for (new i=0, j = sizeof(houseInterior); i!=j; i++) {
		format(str, sizeof str, "%s\n%s", str, houseInterior[i][hIntName]);
	}
	Dialog_Show(playerid, HouseInteriorDialog, DIALOG_STYLE_LIST, "เลือกรูปแบบภายใน:", str, "ปรับ", "ยกเลิก");
	return 1;
}

Dialog:HouseInteriorDialog(playerid, response, listitem, inputtext[])
{
	if (response) {
		new houseid = GetPVarInt(playerid, "SetHouseInterior");

		if(!Iter_Contains(Iter_House, houseid)) 
				return SendClientMessage(playerid, COLOR_GRAD1, "   ไอดีบ้านไม่ถูกต้อง !!");
				
		houseData[houseid][hSwitchStatus] = 0;
		houseData[houseid][hBareSwitch] = houseInterior[listitem][bareswitch];

		houseData[houseid][hExtX] = houseInterior[listitem][hIntPosX];
		houseData[houseid][hExtY] = houseInterior[listitem][hIntPosY];
		houseData[houseid][hExtZ] = houseInterior[listitem][hIntPosZ];
		houseData[houseid][hExtInt] = houseInterior[listitem][hInt];
		houseData[houseid][hExtWorld] = houseData[houseid][hID] + HOUSE_WORLD;

		if(IsValidDynamicArea(houseData[houseid][hAreaInt]))
			DestroyDynamicArea(houseData[houseid][hAreaInt]);

		houseData[houseid][hAreaInt] = CreateDynamicSphere(houseData[houseid][hExtX], houseData[houseid][hExtY], houseData[houseid][hExtZ], 3.0, houseData[houseid][hExtWorld], houseData[houseid][hExtInt]);
		Streamer_SetIntData(STREAMER_TYPE_AREA, houseData[houseid][hAreaInt], E_STREAMER_EXTRA_ID, houseid);

		SendClientMessageEx(playerid, COLOR_GRAD1, "   บ้านไอดี %d ถูกปรับรูปแบบทางออกเรียบร้อยแล้ว !! (%s)", houseData[houseid][hID], houseInterior[listitem][hIntName]);
		SendClientMessage(playerid, COLOR_LIGHTRED, "[ ! ]"EMBED_WHITE" ใช้ /houseexit เพื่อกำหนดทางออก");

		insideHouseID[playerid] = houseid;
		SetPlayerVirtualWorld(playerid, houseData[houseid][hExtWorld]);
		SetPlayerInterior(playerid, houseInterior[listitem][hInt]);
		SetPlayerPos(playerid, houseInterior[listitem][hIntPosX], houseInterior[listitem][hIntPosY], houseInterior[listitem][hIntPosZ]);
	}
	return 1;
}

SetPlayerHouseSpawn(playerid, id) {
	new house = House_GetID(id);
	if(house == -1 || !houseData[house][hOwned])
	{
		SetPlayerPos(playerid, 1643.0010,-2331.7056,-2.6797);
		SetPlayerFacingAngle(playerid,359.8919);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		playerData[playerid][pInterior] = 0;
		playerData[playerid][pVWorld] = 0;
		playerData[playerid][pSpawnType]=SPAWN_TYPE_DEFAULT;

		if(house == -1)
			SendClientMessage(playerid, COLOR_LIGHTRED, "[ ! ]"EMBED_WHITE" คุณมีเงินในธนาคารไม่พอจ่ายค่าเช่าบ้าน...");
	}
	else
	{
	    if(!IsHouseOwner(playerid, house))
	    {
	        SendClientMessage(playerid, COLOR_LIGHTRED, "ค่าเช่าบ้านหลังนี้คือ:");
	        SendClientMessageEx(playerid, COLOR_WHITE, "$%d", houseData[house][hRentPrice]);
	    }

		SetPlayerPos(playerid, houseData[house][hExtX], houseData[house][hExtY],houseData[house][hExtZ]);
		SetPlayerFacingAngle(playerid, 0);
		SetPlayerInterior(playerid, houseData[house][hExtInt]);
		SetPlayerVirtualWorld(playerid, houseData[house][hExtWorld]);

		playerData[playerid][pInterior] = houseData[house][hExtInt];
		playerData[playerid][pVWorld] = houseData[house][hExtWorld];
	}
}

/*
ShowHouseItemDetail(targetid, house) {

	SendClientMessage(targetid, COLOR_GRAD1, "|_______ ไอเท็มในปัจจุบัน _______|");

	new bool:count;
	house++;
	if(!count) SendClientMessage(targetid, COLOR_GRAD1, "ไม่พบไอเท็มใด ๆ");
}*/

/*
FindHouseAtWorld(worldid) {
	foreach(new i : Iter_House) {
		if(houseData[i][hExtWorld] == worldid) {
			return i;
		}
	}
	return -1;
}
*/

IsHouseOwner(playerid, houseid)
{
	if(IsPlayerConnected(playerid) && houseid != -1 && Iter_Contains(Iter_House, houseid)) {
		if (houseData[houseid][hOwned] == 1 && !strcmp(ReturnPlayerName(playerid), houseData[houseid][hOwner], true))
			return 1;
	}
	return 0;
}

House_SetInside(playerid, value) {
	insideHouseID[playerid] = value;
}

GetClosestHouseID(playerid)
{
	new
	    Float:fDistance = FLOAT_INFINITY,
	    iIndex = -1
	;
	foreach (new i : Iter_House) {

		new
		 	Float:temp = GetPlayerDistanceFromPoint(playerid, houseData[i][hPosX], houseData[i][hPosY], houseData[i][hPosZ]);

		if (temp < fDistance && temp < 3.0)
		{
			fDistance = temp;
			iIndex = i;
		}
	}
	return iIndex;
}

GetHouseSID(houseid) {
	foreach(new h : Iter_House) {
		if(houseData[h][hID] == houseid) {
			return h;
		}
	}
	return -1;
}

CMD:setsafe(playerid, params[])
{
	new house = insideHouseID[playerid];

	if (IsHouseOwner(playerid, house) && strcmp(ReturnPlayerName(playerid), houseData[house][hOwner], true) == 0)
	{
	    GetPlayerPos(playerid, houseData[house][hCheckPosX], houseData[house][hCheckPosY], houseData[house][hCheckPosZ]);
	    SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ตั้งตู้เซฟของคุณไว้ในตำแหน่งปัจจุบันแล้ว");

	    House_Save(house);
	}
	else {
	    SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องอยู่ในบ้านที่เป็นเจ้าของ");
	}
	return 1;
}

CMD:removehouse(playerid,params[])
{
	new houseid = -1,
		string[128],
		str[128];

	if(playerData[playerid][pAdmin] < 3)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

	if((houseid = GetClosestHouseID(playerid)) != -1) {

	    if(houseData[houseid][hOwned]) return SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่สามารถทำลายบ้านที่มีเจ้าของได้โปรดใช้ /asellhouse");

		DestroyDynamic3DTextLabel(STREAMER_TAG_3D_TEXT_LABEL:houseData[houseid][hLabel]);

		format(string,sizeof(string),"คุณได้ทำลายบ้านไดนามิคไอดี: %d!",houseData[houseid][hID]);
		SendClientMessage(playerid, COLOR_YELLOW, string);
		
		format(str, sizeof(str), "DELETE FROM `house` WHERE `house_id` = %d",houseData[houseid][hID]);
		mysql_tquery(dbCon, str, "OnHouseRemove", "i", houseid);
	}
	return 1;
}

CMD:asellhouse(playerid, params[])
{
	new houseid, strMSG[128], str[128];

	if(playerData[playerid][pAdmin] < 3)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

	if(sscanf(params,"d",houseid)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /asellhouse [houseid]");
	
	houseid = GetHouseSID(houseid);
	
	if(!Iter_Contains(Iter_House, houseid)) return SendClientMessage(playerid, COLOR_GRAD1, "Invalid house ID.");
	if(!houseData[houseid][hOwned]) return SendClientMessage(playerid, COLOR_GRAD1, "   ไม่มีใครเป็นเจ้าของบ้านหลังนี้");

	foreach(new i : Player)
	{
	    if(playerData[i][pHouseKey] == houseid)
	    {
	        playerData[i][pHouseKey] = -1;
			format(strMSG, sizeof(strMSG), "ผู้ดูแล %s ได้ขายบ้านของคุณให้กับตลาด คุณเป็นผู้ไร้ที่อยู่อาศัย", ReturnPlayerName(playerid));
			SendClientMessage(i, -1, strMSG);
	        break;
	    }
	}

	format(str, sizeof(str), "UPDATE `players` SET `House` = %d WHERE `House` = %d", -1, houseid);
	mysql_query(dbCon, str);

	format(str, sizeof(str), "UPDATE `house` SET `owner` = '%s', `owned` = %d, `locked` = %d, `rentPrice` = %d, `rentable` = %d, `cash` = %d, `checkx` = %f, `checky` = %f, `checkz` = %f WHERE `id` = %d", "The State", 0, 1, 0, 0, 0, 0.0, 0.0, 0.0, houseData[houseid][hID]);
	mysql_tquery(dbCon, str, "OnAdminSellHouse", "i", houseid);
	return 1;
}

forward OnHouseRemove(houseid);
public OnHouseRemove(houseid)
{
	if (IsValidDynamicPickup(houseData[houseid][hPickup]))
		DestroyDynamicPickup(houseData[houseid][hPickup]);

	houseData[houseid][hID] = 0;
	houseData[houseid][hPosX] = 0.0000;
	houseData[houseid][hPosY] = 0.0000;
	houseData[houseid][hPosZ] = 0.0000;
	houseData[houseid][hExtX] = 0.0000;
	houseData[houseid][hExtY] = 0.0000;
	houseData[houseid][hExtZ] = 0.0000;
	houseData[houseid][hCheckPosX] = 0.0000;
	houseData[houseid][hCheckPosY] = 0.0000;
	houseData[houseid][hCheckPosZ] = 0.0000;
	houseData[houseid][hLevelbuy] = 0;
	houseData[houseid][hPrice] = 0;
	houseData[houseid][hOwned] = 0;
	houseData[houseid][hLocked] = 0;
	houseData[houseid][hRentPrice] = 0;
	houseData[houseid][hRentable] = 0;
	houseData[houseid][hPosInt] = 0;
	houseData[houseid][hPosWorld] = 0;
	houseData[houseid][hCash] = 0;
	//houseData[houseid][hSubid] = -1;
	houseData[houseid][hMats] = 0;
	houseData[houseid][hRMoney] = 0;
	//houseData[houseid][hType] = 0;
	//houseData[houseid][hRadio] = 0;
	format(houseData[houseid][hOwner], 256, "The State");
	houseData[houseid][hLabel] = STREAMER_TAG_3D_TEXT_LABEL:INVALID_3DTEXT_ID;
	Iter_Remove(Iter_House, houseid);
	return 1;
}

forward OnAdminSellHouse(houseid);
public OnAdminSellHouse(houseid)
{
	foreach(new i : Player)
	{
		if(playerData[i][pHouseKey] == houseid)
		{
			SendClientMessage(i, COLOR_GRAD1, "บ้านที่คุณเช่าถูกขายแล้ว ตอนนี้คุณไม่มีที่อยู่อาศัย");
			playerData[i][pHouseKey] = -1;
		}
	}
	houseData[houseid][hOwned] = 0;
	houseData[houseid][hLocked] = 1;
	houseData[houseid][hRentPrice] = 0;
	houseData[houseid][hRentable] = 0;
	houseData[houseid][hCash] = 0;
	//houseData[houseid][hRadio] = 0;
	houseData[houseid][hCheckPosX] = 0.0000;
	houseData[houseid][hCheckPosY] = 0.0000;
	houseData[houseid][hCheckPosZ] = 0.0000;
	
	if(houseData[houseid][hID] != -1) {
		houseData[houseData[houseid][hID]][hCash] -= houseData[houseid][hPrice];
	}
	
	format(houseData[houseid][hOwner], 256, "The State");
	UpdateHouseText(houseid);
	return 1;
}

UpdateHouseText(houseid)
{
	new strMSG[128];

	if(!houseData[houseid][hOwned]) {
	    if(!IsValidDynamic3DTextLabel(STREAMER_TAG_3D_TEXT_LABEL:houseData[houseid][hLabel])) {
	        format(strMSG, sizeof(strMSG), ""EMBED_YELLOW"%s\nราคา: $%d\nเลเวล: %d", GetHouseAddress(houseid), houseData[houseid][hPrice], houseData[houseid][hLevelbuy]);
	        houseData[houseid][hLabel] = CreateDynamic3DTextLabel(strMSG, -1, houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, houseData[houseid][hPosWorld], houseData[houseid][hPosInt], -1, 100.0);
			return 1;
		}

		format(strMSG, sizeof(strMSG), ""EMBED_YELLOW"%s\nราคา: $%d\nเลเวล: %d", GetHouseAddress(houseid), houseData[houseid][hPrice], houseData[houseid][hLevelbuy]);
        UpdateDynamic3DTextLabelText(houseData[houseid][hLabel], -1, strMSG);
	}
	else
	{
		if(IsValidDynamic3DTextLabel(STREAMER_TAG_3D_TEXT_LABEL:houseData[houseid][hLabel])) DestroyDynamic3DTextLabel(STREAMER_TAG_3D_TEXT_LABEL:houseData[houseid][hLabel]);
	}
	return 1;
}


