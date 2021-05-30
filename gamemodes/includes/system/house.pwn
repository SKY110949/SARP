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
	{"���㹾���� #1", 1416.2,4.03454,1000.92, 1, false},
	{"���� #2", 244.318,304.978,999.148, 1, true},
	{"���� #3", 267.037,304.977,999.148, 2, true},
	{"���� #4", 302.856,301.355,999.148, 4, true},
	{"���� #5", 344.024,305.102,999.148, 6, true},
	{"���� #6", 446.694,507.029,1001.42, 12, true},
	{"���� #8", 2465.7524,-1698.3430,1013.5152, 2, false},
	{"���� #13", 744.434,1436.92,1102.7, 6, true},
	{"���� #16", 2530.7578,-1583.1094,1016.2422, 1, false},
	{"���� #28", 225.761,1022.19,1084.02, 7, true},
	{"���� #34", 2324.36,-1148.8,1050.71, 12, true},
	{"���� #35", 2233.63,-1114.31,1050.88, 5, true},
	{"���� #36", 2196.2,-1204.35,1049.02, 6, true},
	{"���� #37", 2269.28,-1210.46,1047.56, 10, true},
	{"���� #38", 2309.02,-1212.21,1049.02, 6, true},
	{"���� #40", 2332.96,-1076.47,1049.02, 6, true},
	{"���� #41", 2237.56,-1080.38,1049.02, 2, true},
	{"���� #42", 2217.21,-1076.23,1050.48, 1, true},
	{"���� #43", 2317.73,-1026.01,1050.22, 9, true}
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
     	    format(msg, sizeof(msg), "%s\n�Ҥ�: $%d\n�����: %d", GetHouseAddress(i), houseData[i][hPrice], houseData[i][hLevelbuy]);
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
					if(houseData[h][hOwned] == 1) format(welcomeMSG, sizeof welcomeMSG, "�س������˹�һ�е���ͧ�ͧ %s", houseData[h][hOwner]);
					else format(welcomeMSG, sizeof welcomeMSG, "�س������˹�һ�е���ͧ %s", houseData[h][hAddress]);
				}
				else {
					format(welcomeMSG, sizeof welcomeMSG, GetHouseAddress(h));
				}

				if(houseData[h][hOwned] == 1 && IsHouseOwner(playerid, h))
				{
					SendClientMessage(playerid, COLOR_GREEN, welcomeMSG);
					SendClientMessage(playerid, COLOR_WHITE, "����觷����: /enter, /ds(hout), ddo, /knock, /myhouse");
				}
				else if(houseData[h][hOwned] == 1)
				{
					if(houseData[h][hRentable] == 1)
					{
						SendClientMessage(playerid, COLOR_LIGHTRED, "�����Һ�ҹ��ѧ�����:");
						SendClientMessageEx(playerid, COLOR_WHITE, "$%d", houseData[h][hRentPrice]);
						SendClientMessage(playerid, COLOR_WHITE, "��ͧ�����ҷ������� /rentroom");
						SendClientMessage(playerid, COLOR_GREEN, welcomeMSG);
						SendClientMessage(playerid, COLOR_WHITE, "����觷����: /enter, /ds(hout), ddo, /knock");
					}
					else
					{
						SendClientMessage(playerid, COLOR_GREEN, welcomeMSG);
						SendClientMessage(playerid, COLOR_WHITE, "����觷����: /enter, /ds(hout), ddo, /knock");
					}
				}
				if(houseData[h][hOwned] == 0)
				{
					SendClientMessage(playerid, COLOR_GREEN, welcomeMSG);
					SendClientMessageEx(playerid, COLOR_GREEN, "�ҤҺ�ҹ��ѧ�����: $%d",houseData[h][hPrice]);
					SendClientMessage(playerid, COLOR_WHITE, "�����: /buyhouse");
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
	SendClientMessage(playerid, COLOR_WHITE,"*** HOUSE HELP *** �������������Ѻ��������������������");
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
	            SendClientMessage(playerid, COLOR_GRAD1, "�س��Դ���������¹");
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
	            SendClientMessage(playerid, COLOR_GRAD1, "�س���Դ���������¹");
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
	    else SendClientMessage(playerid, COLOR_LIGHTRED, "���㹹����������������¹");
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ����㹺�ҹ�������Ңͧ");

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
		SendClientMessage(playerid, COLOR_LIGHTRED, "�س����շ�����������");
	}
}

CMD:setrentable(playerid, params[])
{
	new status;
	new house = insideHouseID[playerid];

	if (IsHouseOwner(playerid, house))
	{
		if(sscanf(params,"d",status)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /setrentable ([0/1])");
		if(status > 1 || status < 0) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /setrentable ([0/1])");
		houseData[house][hRentable] = status;
		SendClientMessageEx(playerid, COLOR_GRAD1, "�س���ʶҹС������� %s", status ? ("�Դ������") : ("�Դ������"));
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ����㹺�ҹ�������Ңͧ");
	return 1;
}

CMD:setrent(playerid, params[])
{
	new status;
	new house = insideHouseID[playerid];

	if (IsHouseOwner(playerid, house))
	{
		if(sscanf(params,"d",status)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /setrent ($1-$10,000)");
		if(status < 1 || status > 10000) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /setrent ($1-$10,000)");
		houseData[house][hRentPrice] = status;
		SendClientMessageEx(playerid, COLOR_GRAD1, "�ҤҤ����Ҷ١����� $%d", houseData[house][hRentPrice]);
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ����㹺�ҹ�������Ңͧ");
	return 1;
}

alias:rentroom("rent");
CMD:rentroom(playerid, params[])
{
	new h = -1;
	if ((h = nearHouse_var[playerid]) != -1) {

		if(houseData[h][hOwned])
		{
			if(houseData[h][hRentable] == 0) return SendClientMessage(playerid, COLOR_GRAD1, "��ҹ��ѧ���������Դ������");
			if(CountPlayerOwnHouse(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "�س�������ö��Һ�ҹ㹢�з������Ңͧ��ҹ� � ��");
			if(playerData[playerid][pHouseKey] != 0) return SendClientMessage(playerid, COLOR_GRAD1, "�س�������ö��Һ�ҹ㹢�з��س�繼��������� (/unrent)");
			if(playerData[playerid][pCash] < houseData[h][hRentPrice]) {
			    SendClientMessage(playerid, COLOR_GRAD1, "�س���Թ���ͷ������!");
			    return 1;
			}

			playerData[playerid][pHouseKey] = houseData[h][hID];
			playerData[playerid][pSpawnType] = SPAWN_TYPE_PROPERTY;
			playerData[playerid][pCash] -= houseData[h][hRentPrice];
			houseData[h][hCash] += houseData[h][hRentPrice];

			SendClientMessage(playerid, COLOR_WHITE, "�س���Դ�����㹢�й��!");
			SendClientMessageEx(playerid, COLOR_WHITE, "�����Һ�ҹ��ѧ����� $%d", houseData[h][hRentPrice]);
			return 1;
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "��ҧ��ѧ����������Ңͧ!");
		}
	}
	return 1;
}

CMD:unrent(playerid, params[])
{
	new housekey = House_GetID(playerData[playerid][pHouseKey]);
	if (housekey != -1) {
		if(IsHouseOwner(playerid, housekey)) return SendClientMessage(playerid, COLOR_GRAD1, "�������ö��ԡ��Һ�ҹ�ͧ����ͧ��...");

		playerData[playerid][pHouseKey] = 0;
		SendClientMessage(playerid, COLOR_GRAD1, "   �س�������Һ�ҹ� � ����");
	}
	else {
		SendClientMessage(playerid, COLOR_GRAD1, "�س�������Һ�ҹ� �");
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
	else SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ����㹺�ҹ�������Ңͧ");
	return 1;
}

forward ShowTenantsAmount(playerid);
public ShowTenantsAmount(playerid)
{
	new rows, tenantname[MAX_PLAYER_NAME], tid;
	cache_get_row_count(rows);
	if(!rows) return SendClientMessage(playerid, COLOR_GRAD1, "���������Һ�ҹ�ͧ�س");
	
	SendClientMessage(playerid, COLOR_YELLOW, "|_______________������_______________|");
	for(new i=0; i!=rows; ++i)
	{
		cache_get_value_index_int(i, 0, tid);
		cache_get_value_index(i, 1, tenantname);
		SendClientMessageEx(playerid, COLOR_GREEN, "[������ %d] %s", tid, tenantname);
	}
	SendClientMessage(playerid, COLOR_YELLOW, "|_______________������_______________|");
	return 1;
}


CMD:evict(playerid, params[])
{
	new tid;
	if(sscanf(params,"d", tid)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /evict [�����Ţ������] (/tenants)");

	new house = insideHouseID[playerid];
	if (IsHouseOwner(playerid, house))
	{
		new query[128];
		mysql_format(dbCon, query, sizeof(query), "UPDATE `players` SET houseKey=0 WHERE houseKey=%d AND id=%d", houseData[house][hID], tid);
		mysql_tquery(dbCon, query, "KickTenant", "ii", playerid, tid);
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ����㹺�ҹ�������Ңͧ");

	return 1;
}

forward KickTenant(playerid, tenantid);
public KickTenant(playerid, tenantid) {
	if (cache_affected_rows()) {
		foreach(new i : Player) {
			if (playerData[i][pSID] == tenantid) {
				playerData[i][pHouseKey] = 0;
				SendClientMessage(i, COLOR_GRAD1, "�س�١�Ѻ����͡�ҡ��ҹ �س�繼����������������㹢�й��");
				break;
			}
		}
		return SendClientMessage(playerid, COLOR_GRAD1, "�س��Ѻ�������ҹ���͡�ҡ��ҹ�ͧ�س���º��������");
	}
	return SendClientMessage(playerid, COLOR_YELLOW, "�����蹹���������Һ�ҹ�ͧ�س");
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
	else SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ����㹺�ҹ�������Ңͧ");

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
				SendClientMessage(i, COLOR_YELLOW, "�س�١�Ѻ����͡�ҡ��ҹ����Ңͧ");
			}
		}
		return SendClientMessage(playerid, COLOR_YELLOW, "�����ҷ������١�Ѻ����͡�ҡ��ҹ�ͧ�س����");
	}
	return SendClientMessage(playerid, COLOR_GRAD1, "���������Һ�ҹ�ͧ�س");
}

flags:edithouse(CMD_MANAGEMENT);
CMD:edithouse(playerid, params[])
{
	new text[160], type;

	if(sscanf(params,"ds[160]", type, text)) {
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /edithouse [������͡] [���]");
		SendClientMessage(playerid, COLOR_GRAD2, "������͡�������: 1-�������, 2-��Ңͧ, 3-����Ңͧ, 4-��͡, 5-�Ҥ�, 6-����ŷ�������, 7-�Թ㹺�ҹ");
		SendClientMessage(playerid, COLOR_GRAD2, "������͡�������: 8-������");
		return 1;
	}

	new house = nearHouse_var[playerid] == -1 ? insideHouseID[playerid] : nearHouse_var[playerid];
	if (house != -1 && Iter_Contains(Iter_House, house))
	{
		switch(type) {
			case 1: {
				new info[128];
				if(sscanf(text,"s[128]", info)) {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /edithouse ������� [����]");
					return 1;
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹��������ҹ #%d �ҡ %s �� %s", ReturnPlayerName(playerid), houseData[house][hID], houseData[house][hAddress], info);
				format(houseData[house][hAddress], 128, info);
				House_Save(house);
			}
			case 2: {
				new name[MAX_PLAYER_NAME];
				if(sscanf(text,"s[24]", name)) {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /edithouse ��Ңͧ [������Ңͧ]");
					return 1;
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹������Ңͧ��ҹ #%d �ҡ %s �� %s", ReturnPlayerName(playerid), houseData[house][hID], houseData[house][hOwner], name);
				format(houseData[house][hOwner], MAX_PLAYER_NAME, name);
				House_Save(house);
			}
			case 3: {
				new status;
				if(sscanf(text,"i", status)) {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /edithouse ����Ңͧ [0-�������Ңͧ, 1-����Ңͧ]");
					return 1;
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹�������Ңͧ��ҹ #%d �� %s", ReturnPlayerName(playerid), houseData[house][hID], (!!status) ? ("����Ңͧ") : ("�������Ңͧ"));
				houseData[house][hOwned] = !!status;
				House_Save(house);
			}
			case 5: {
				new price;
				if(sscanf(text,"d", price)) {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /edithouse �Ҥ� [�ӹǹ]");
					return 1;
				}
				if (price <= 0 || price >= 50000000) {
					SendClientMessage(playerid, COLOR_GRAD1, "   �ҤҺ�ҹ��ͧ����ӡ���������ҡѺ 0");
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹�ҤҢͧ��ҹ #%d �ҡ %d �� %d", ReturnPlayerName(playerid), houseData[house][hID], houseData[house][hPrice], price);
				houseData[house][hPrice] = price;
				House_Save(house);
			}
			case 6: {
				new level;
				if(sscanf(text,"d", level)) {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /edithouse ����ŷ������� [�����]");
					return 1;
				}
				if (level <= 0 || level >= 50000000) {
					SendClientMessage(playerid, COLOR_GRAD1, "   ����Ţ�鹵��㹡�ë��ͺ�ҹ��ͧ����ӡ���������ҡѺ 0");
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹����Ţ�鹵��㹡�ë��ͧ͢��ҹ #%d �ҡ %d �� %d", ReturnPlayerName(playerid), houseData[house][hID], houseData[house][hLevelbuy], level);
				houseData[house][hLevelbuy] = level;
				House_Save(house);
			}
			case 7: {
				new till;
				if(sscanf(text,"d", till)) {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /edithouse �Թ㹺�ҹ [�ӹǹ]");
					return 1;
				}
				if (till <= 0 || till >= 50000000) {
					SendClientMessage(playerid, COLOR_GRAD1, "   �Թ㹺�ҹ��ͧ����ӡ���������ҡѺ 0");
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹�Թ�ͧ��ҹ #%d �ҡ %d �� %d", ReturnPlayerName(playerid), houseData[house][hID], houseData[house][hCash], till);
				houseData[house][hCash] = till;
				House_Save(house);
			}
			case 8: {
				new htype;
				if(sscanf(text,"d", htype)) {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /edithouse ������ [�����Ţ]");
					ShowAllBusinessType(playerid);
					return 1;
				}
				if(htype < 1 || htype > 3) {
					SendClientMessage(playerid, COLOR_GRAD1, "   ��������ͧ�� 1 �֧ 3 ��ҹ�� !!");
					return 1;
				}
			
				new 
					pint=GetPlayerInterior(playerid), 
					pworld=GetPlayerVirtualWorld(playerid);

				if(htype == PROPERTY_TYPE_HOUSE && (pworld != 0 || pint != 0))
					return SendClientMessage(playerid, COLOR_LIGHTRED, "�����Դ��Ҵ: "EMBED_WHITE"�������ö���ҧ��ҹ������������");
				else if(htype == PROPERTY_TYPE_APART && (pworld != 0 || pint != 0))
					return SendClientMessage(playerid, COLOR_LIGHTRED, "�����Դ��Ҵ: "EMBED_WHITE"�������ö���ҧ;�����鹷�������������");
				else if(htype == PROPERTY_TYPE_ROOM && (pworld == 0))
					return SendClientMessage(playerid, COLOR_LIGHTRED, "�����Դ��Ҵ: "EMBED_WHITE"�������ö���ҧ��ͧ;�����鹷������¹͡�Ҥ����");

				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹�������ͧ��ҹ #%d �ҡ %d �� %d", ReturnPlayerName(playerid), houseData[house][hID], houseData[house][hApartment], htype);
				houseData[house][hApartment]=htype;
				House_Save(house);
			}
		}
	}
	else return SendClientMessage(playerid, COLOR_GRAD2, "�س�������������ҹ� �");
	return 1;
}

CMD:myhouse(playerid, params[])
{
    new option[10], param2[128];
	new house = nearHouse_var[playerid] == -1 ? insideHouseID[playerid] : nearHouse_var[playerid];

	if (house != -1 && IsHouseOwner(playerid, house))
	{
		if(sscanf(params, "s[10]S()[128]", option, param2)) {
			SendClientMessage(playerid, COLOR_GRAD1, "�����: /myhouse [������͡]");
			SendClientMessage(playerid, COLOR_GRAD2, "[������͡] �Թʴ | �Թ�׹ | �Թᴧ |������");
			return 1;
		}
    	if(!strcmp(option, "������", true))
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "�����ź�ҹ: ��ҹ�ʹ� - %d �Ҥҵ�Ҵ - $%d �Ҥ���� - $%d", houseData[house][hID], houseData[house][hPrice], houseData[house][hRentPrice]);
		}
    	/*else if(!strcmp(option, "�����", true))
		{
			if (insideHouseID[playerid] != -1 && insideHouseID[playerid] == house) {
				ShowHouseItemDetail(playerid, house);
			}
			else SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ����㹺�ҹ���س����Ңͧ");
		}*/
		else if(!strcmp(option, "�Թʴ", true))
		{
			if (insideHouseID[playerid] != -1 && insideHouseID[playerid] == house) {
				new amount;
				if(sscanf(param2, "s[10]d", option, amount))
				{
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /myhouse �Թʴ [�͹/�ҡ] [�ӹǹ]");
					SendClientMessageEx(playerid, COLOR_GRAD1, "�س�� $%d ����㹡��ͧ�Թʴ", houseData[house][hCash]);
					return 1;
				}

				if(!strcmp(option, "�͹", true))
				{
					if (amount > houseData[house][hCash] || amount < 1) 
						return SendClientMessage(playerid, COLOR_GRAD1, "�س��������ҡ��Ҵ���!");

					playerData[playerid][pCash] += amount;
					houseData[house][hCash] -= amount;

					SendClientMessageEx(playerid, COLOR_GRAD1, "�س�͹ $%d �ҡ���ͧ�Թʴ �ʹ�������: $%d ", amount, houseData[house][hCash]);
            		SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdmCmd: %s ��ӡ�ö͹�Թ㹺�ҹ�ӹǹ %s (�Ѩ�غѹ��ҹ�ʹ� %d ���Թ㹺�ҹ������ %s)", ReturnPlayerName(playerid), FormatNumber(amount), house, FormatNumber(houseData[house][hCash]));

				}
				else if(!strcmp(option, "�ҡ", true))
				{
					if (amount > playerData[playerid][pCash] || amount < 1)
						return SendClientMessage(playerid, COLOR_GRAD1, "�س��������ҡ��Ҵ���!");

					playerData[playerid][pCash] -= amount;
					houseData[house][hCash] += amount;
					SendClientMessageEx(playerid, COLOR_GRAD1, "�س���ҧ $%d 㹡��ͧ�Թʴ�ͧ�س �ʹ���������: $%d ", amount, houseData[house][hCash]);
				
            		SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdmCmd: %s ��ӡ�ýҡ�Թ㹺�ҹ�ӹǹ %s (�Ѩ�غѹ��ҹ�ʹ� %d ���Թ㹺�ҹ������ %s)", ReturnPlayerName(playerid), FormatNumber(amount), house, FormatNumber(houseData[house][hCash]));
				}
				else {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /myhouse �Թʴ [�͹/�ҡ] [�ӹǹ]");
				}
			}
			else SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ����㹺�ҹ���س����Ңͧ");
		}

		else if(!strcmp(option, "�Թ�׹", true))
		{
			if (insideHouseID[playerid] != -1 && insideHouseID[playerid] == house) {
				new amount;
				if(sscanf(param2, "s[10]d", option, amount))
				{
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /myhouse �Թ�׹ [�͹/�ҡ] [�ӹǹ]");
					SendClientMessageEx(playerid, COLOR_GRAD1, "�س�մԹ�׹����ӹǹ %d 㹤�ѧ�红ͧ��ҹ�ͧ�س", houseData[house][hMats]);
					return 1;
				}

				if(!strcmp(option, "�͹", true))
				{
					if (amount > houseData[house][hMats] || amount < 1) 
						return SendClientMessage(playerid, COLOR_GRAD1, "�س��������ҡ��Ҵ���!");

					playerData[playerid][pMaterials] += amount;
					houseData[house][hMats] -= amount;
					House_Save(house);

					SendClientMessageEx(playerid, COLOR_GRAD1, "�س�͹ $%d �ҡ��ѧ��ҹ, �ʹ�������: $%d ", amount, houseData[house][hMats]);
				}
				else if(!strcmp(option, "�ҡ", true))
				{
					if (amount > playerData[playerid][pMaterials] || amount < 1)
						return SendClientMessage(playerid, COLOR_GRAD1, "�س��������ҡ��Ҵ���!");

					playerData[playerid][pMaterials] -= amount;
					houseData[house][hMats] += amount;
					House_Save(house);

					SendClientMessageEx(playerid, COLOR_GRAD1, "�س���ҧ $%d �ҡ��ѧ��ҹ, �ʹ���������: $%d ", amount, houseData[house][hMats]);
				}
				else {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /myhouse �Թ�׹ [�͹/�ҡ] [�ӹǹ]");
				}
			}
			else SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ����㹺�ҹ���س����Ңͧ");
		}

		else if(!strcmp(option, "�Թᴧ", true))
		{
			if (insideHouseID[playerid] != -1 && insideHouseID[playerid] == house) {
				new amount;
				if(sscanf(param2, "s[10]d", option, amount))
				{
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /myhouse �Թᴧ [�͹/�ҡ] [�ӹǹ]");
					SendClientMessageEx(playerid, COLOR_GRAD1, "�س���Թᴧ����ӹǹ %d 㹤�ѧ�红ͧ��ҹ�ͧ�س", houseData[house][hRMoney]);
					return 1;
				}

				if(!strcmp(option, "�͹", true))
				{
					if (amount > houseData[house][hRMoney] || amount < 1) 
						return SendClientMessage(playerid, COLOR_GRAD1, "�س��������ҡ��Ҵ���!");

					playerData[playerid][pRMoney] += amount;
					houseData[house][hRMoney] -= amount;
					House_Save(house);

					SendClientMessageEx(playerid, COLOR_GRAD1, "�س�͹ $%d �ҡ��ѧ��ҹ, �ʹ�������: $%d ", amount, houseData[house][hRMoney]);
				}
				else if(!strcmp(option, "�ҡ", true))
				{
					if (amount > playerData[playerid][pRMoney] || amount < 1)
						return SendClientMessage(playerid, COLOR_GRAD1, "�س��������ҡ��Ҵ���!");

					playerData[playerid][pRMoney] -= amount;
					houseData[house][hRMoney] += amount;
					House_Save(house);
					
					SendClientMessageEx(playerid, COLOR_GRAD1, "�س���ҧ $%d �ҡ��ѧ��ҹ, �ʹ���������: $%d ", amount, houseData[house][hRMoney]);
				}
				else {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /myhouse �Թᴧ [�͹/�ҡ] [�ӹǹ]");
				}
			}
			else SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ����㹺�ҹ���س����Ңͧ");
		}

		else {
			SendClientMessage(playerid, COLOR_GRAD1, "�����: /myhouse [������͡]");
			SendClientMessage(playerid, COLOR_GRAD2, "[������͡] �Թʴ | ������");
		}
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ����㹺���ǳ��ҹ���س����Ңͧ");
	return 1;
}

flags:housecmds(CMD_MANAGEMENT);
CMD:housecmds(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GRAD1, "�����: /makehouse, /houseenter, /houseexit, /edithouse, /sethint, /gotohouse");
	return 1;
}

flags:makehouse(CMD_MANAGEMENT);
CMD:makehouse(playerid, params[])
{
	new houseid, buylevel, price, type, hinfo[MAX_STREET_NAME];
	if(sscanf(params,"ddds[30]", type, buylevel, price, hinfo)) {
        SendClientMessage(playerid, COLOR_GRAD1, "�����: /makehouse [������] [�����] [�Ҥ�] [��������´(���/��ͧ)]");
        SendClientMessage(playerid, COLOR_GRAD2, "[������] 1: ��ҹ 2: ;�����鹷� 3: ��ͧ;�����鹷�");
		return 1;
	}
	if(type < 1 || type > 3) {
        SendClientMessage(playerid, COLOR_GRAD1, "   ��������ͧ�� 1 �֧ 3 ��ҹ�� !!");
		return 1;
	}

    if((houseid = Iter_Free(Iter_House)) != -1) {

		new 
			pint=GetPlayerInterior(playerid), 
			pworld=GetPlayerVirtualWorld(playerid);

		if(type == PROPERTY_TYPE_HOUSE && (pworld != 0 || pint != 0))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "�����Դ��Ҵ: "EMBED_WHITE"�������ö���ҧ��ҹ������������");
		else if(type == PROPERTY_TYPE_APART && (pworld != 0 || pint != 0))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "�����Դ��Ҵ: "EMBED_WHITE"�������ö���ҧ;�����鹷�������������");
		else if(type == PROPERTY_TYPE_ROOM && (pworld == 0))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "�����Դ��Ҵ: "EMBED_WHITE"�������ö���ҧ��ͧ;�����鹷������¹͡�Ҥ����");

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
		format(houseData[houseid][hOwner], MAX_PLAYER_NAME, "�Ѱ");

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
	else SendClientMessageEx(playerid, COLOR_LIGHTRED, "�����Դ��Ҵ: "EMBED_WHITE"�������ö���ҧ��ҹ���ҡ���ҹ������ �ӡѴ����� "EMBED_ORANGE"%d", MAX_HOUSES);

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
			format(str, sizeof(str), ""EMBED_YELLOW"%s\n�Ҥ�: $%d\n�����: %d", GetHouseAddress(houseid), houseData[houseid][hPrice], houseData[houseid][hLevelbuy]);
			houseData[houseid][hLabel] = CreateDynamic3DTextLabel(str, -1, houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, houseData[houseid][hPosWorld], houseData[houseid][hPosInt], -1, 100.0);
		}

		House_Save(houseid);
	}
	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "�����Դ��Ҵ: "EMBED_WHITE"�������ö���������ź�ҹŧ�ҹ�������� �ô�Դ��� DEV");
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
			return SendClientMessage(playerid, COLOR_GRAD1, "�س�������ö������ѧ�������Ѿ������!");

		new numhouse = CountPlayerOwnHouse(playerid);
		new extra_price = numhouse * 10;
		new houseprice = houseData[h][hPrice];

		if(extra_price) 
			houseprice *= extra_price;

   		if(!sscanf(params, "s[8]", confirm) && !strcmp(confirm, "yes", true)) {

			if(numhouse >= MAX_OWN_HOUSE) return SendClientMessage(playerid, COLOR_GRAD1, "�س�պ�ҹ����ӹǹ�٧�ش���� �� /sellhouse ���͢�º�ҹ�ͧ�س");
			if(playerData[playerid][pLevel] < houseData[h][hLevelbuy]) return SendClientMessage(playerid, COLOR_GRAD1, "�س�������ö������ѧ�������Ѿ������!");
			if(playerData[playerid][pCash] < houseprice || houseprice <= 0) return SendClientMessage(playerid, COLOR_GRAD1, "�س�������ö������ѧ�������Ѿ������!");

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

			SendClientMessage(playerid, COLOR_WHITE, "���ʴ������Թ��㹡����觫�������ͧ�س!");
			SendClientMessage(playerid, COLOR_WHITE, "�� /help ���͡�õ�Ǩ�ͺ�����Ҷ֧����ͧ�س  !");

			if(IsValidDynamic3DTextLabel(STREAMER_TAG_3D_TEXT_LABEL:houseData[h][hLabel])) 
				DestroyDyn3DTextLabelFix(STREAMER_TAG_3D_TEXT_LABEL:houseData[h][hLabel]);

			House_Save(h);
			OnAccountUpdate(playerid);

			return 1;
		}
	 	else
	 	{
	 	    SendClientMessage(playerid, COLOR_GRAD1, "�����: /buyhouse yes");
			SendClientMessageEx(playerid, COLOR_GREY, "��ҹ���س���ѧ�����Ҥ� $%d", houseprice);
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
					SendClientMessageEx(playerid, COLOR_GRAD2, "�س���Ѻ�Թʴ�ҡ��ҹ $%d", houseData[houseid][hCash]);
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

				strmid(houseData[houseid][hOwner], "�Ѱ", 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);

				playerData[playerid][pCash] += houseprice-housetax;

				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				format(str, sizeof(str), "~w~Congratulations~n~ You have sold your property for ~n~~g~$%d", houseprice-housetax);
				GameTextForPlayer(playerid, str, 10000, 3);
				SendClientMessageEx(playerid, COLOR_GRAD3, "���բͧ�Ѱ: $%d", housetax);

				format(str, sizeof(str), ""EMBED_YELLOW"%s\n�Ҥ�: $%d\n�����: %d", GetHouseAddress(houseid), houseData[houseid][hPrice], houseData[houseid][hLevelbuy]);
				houseData[houseid][hLabel] = CreateDynamic3DTextLabel(str, -1, houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, houseData[houseid][hPosWorld], houseData[houseid][hPosInt], -1, 100.0);

				House_Save(houseid);

				format(str, sizeof(str), "UPDATE `players` SET `House`=0 WHERE `House`=%d", houseData[houseid][hID]);
				mysql_tquery(dbCon, str, "OnPlayerSellHouse", "i", houseid);

				playerData[playerid][pHouseKey] = 0;

				return 1;
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD1, "�����: /sellhouse yes");
				SendClientMessageEx(playerid, COLOR_GREY, "��ҹ���س���ѧ����Ҥ� $%d ��������� $%d", houseprice, housetax);
			}
		}
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ����㹺�ҹ�������Ңͧ");
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
			SendClientMessage(i, COLOR_GRAD1, "��ҹ���س��Ҷ١������� �͹���س����շ�����������");
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
        return SendClientMessage(playerid, COLOR_GRAD1, "�����: /houseenter [�ʹպ�ҹ]");
	}
	new houseid = House_GetID(hid);
	
	if(!Iter_Contains(Iter_House, houseid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   �ʹպ�ҹ���١��ͧ !!");

	new Float:px,Float:py,Float:pz;
	GetPlayerPos(playerid, px, py, pz);

	new 
		pint=GetPlayerInterior(playerid), 
		pworld=GetPlayerVirtualWorld(playerid);

	if(houseData[houseid][hApartment] == PROPERTY_TYPE_HOUSE && (pworld != 0 || pint != 0)) // House
		return SendClientMessage(playerid, COLOR_LIGHTRED, "�����Դ��Ҵ: "EMBED_WHITE"�������ö��Ѻ�ҧ��Ңͧ��ҹ������������");
	else if(houseData[houseid][hApartment] == PROPERTY_TYPE_APART && (pworld != 0 || pint != 0)) // Complex
		return SendClientMessage(playerid, COLOR_LIGHTRED, "�����Դ��Ҵ: "EMBED_WHITE"�������ö��Ѻ�ҧ���;�����鹷�������������");
	else if(houseData[houseid][hApartment] == PROPERTY_TYPE_ROOM && (pworld == 0)) // Room
		return SendClientMessage(playerid, COLOR_LIGHTRED, "�����Դ��Ҵ: "EMBED_WHITE"�������ö��Ѻ�ҧ�����ͧ;�����鹷������¹͡�Ҥ����");

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
		format(query, sizeof(query), ""EMBED_YELLOW"%s\n�Ҥ�: $%d\n�����: %d", GetHouseAddress(houseid), houseData[houseid][hPrice], houseData[houseid][hLevelbuy]);
		houseData[houseid][hLabel] = CreateDynamic3DTextLabel(query, -1, houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 100.0);
	}

	House_Save(houseid);
	SendClientMessageEx(playerid, COLOR_GRAD1, "   ��ҹ�ʹ� %d �١��Ѻ�ҧ����������º�������� !!", houseData[houseid][hID]);
	
	return 1;
}

flags:houseexit(CMD_MANAGEMENT);
CMD:houseexit(playerid,params[])
{
	new hid = -1;
	if(sscanf(params,"d",hid)) {
        return SendClientMessage(playerid, COLOR_GRAD1, "�����: /houseexit [�ʹպ�ҹ]");
	}
	new houseid = House_GetID(hid);
	
	if(!Iter_Contains(Iter_House, houseid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   �ʹպ�ҹ���١��ͧ !!");

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
	SendClientMessageEx(playerid, COLOR_GRAD1, "   ��ҹ�ʹ� %d �١��Ѻ�ҧ�͡�������º�������� !!", houseData[houseid][hID]);

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
        return SendClientMessage(playerid, COLOR_GRAD1, "�����: /gotohouse [�ʹպ�ҹ]");
	}
	new houseid = House_GetID(hid);
	
	if(!Iter_Contains(Iter_House, houseid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   �ʹպ�ҹ���١��ͧ !!");


	SetPlayerVirtualWorld(playerid, houseData[houseid][hPosWorld]);
	SetPlayerInterior(playerid, houseData[houseid][hPosInt]);
	SetPlayerPos(playerid, houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ]);

	SendClientMessageEx(playerid, COLOR_GRAD1, "   �س��������ѧ��ҹ�ʹ� %d", houseData[houseid][hID]);
	
	return 1;
}

flags:sethint(CMD_MANAGEMENT);
CMD:sethint(playerid,params[])
{
	new str[512];
	new hid = -1;
	if(sscanf(params,"d",hid)) {
        return SendClientMessage(playerid, COLOR_GRAD1, "�����: /sethint [�ʹպ�ҹ]");
	}
	new houseid = House_GetID(hid);

	if(!Iter_Contains(Iter_House, houseid)) 
			return SendClientMessage(playerid, COLOR_GRAD1, "   �ʹպ�ҹ���١��ͧ !!");

	SetPVarInt(playerid, "SetHouseInterior", houseid);

	for (new i=0, j = sizeof(houseInterior); i!=j; i++) {
		format(str, sizeof str, "%s\n%s", str, houseInterior[i][hIntName]);
	}
	Dialog_Show(playerid, HouseInteriorDialog, DIALOG_STYLE_LIST, "���͡�ٻẺ����:", str, "��Ѻ", "¡��ԡ");
	return 1;
}

Dialog:HouseInteriorDialog(playerid, response, listitem, inputtext[])
{
	if (response) {
		new houseid = GetPVarInt(playerid, "SetHouseInterior");

		if(!Iter_Contains(Iter_House, houseid)) 
				return SendClientMessage(playerid, COLOR_GRAD1, "   �ʹպ�ҹ���١��ͧ !!");
				
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

		SendClientMessageEx(playerid, COLOR_GRAD1, "   ��ҹ�ʹ� %d �١��Ѻ�ٻẺ�ҧ�͡���º�������� !! (%s)", houseData[houseid][hID], houseInterior[listitem][hIntName]);
		SendClientMessage(playerid, COLOR_LIGHTRED, "[ ! ]"EMBED_WHITE" �� /houseexit ���͡�˹��ҧ�͡");

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
			SendClientMessage(playerid, COLOR_LIGHTRED, "[ ! ]"EMBED_WHITE" �س���Թ㹸�Ҥ�����ͨ��¤����Һ�ҹ...");
	}
	else
	{
	    if(!IsHouseOwner(playerid, house))
	    {
	        SendClientMessage(playerid, COLOR_LIGHTRED, "�����Һ�ҹ��ѧ�����:");
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

	SendClientMessage(targetid, COLOR_GRAD1, "|_______ �����㹻Ѩ�غѹ _______|");

	new bool:count;
	house++;
	if(!count) SendClientMessage(targetid, COLOR_GRAD1, "��辺������ �");
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
	    SendClientMessage(playerid, COLOR_YELLOW, "�س���駵��૿�ͧ�س���㹵��˹觻Ѩ�غѹ����");

	    House_Save(house);
	}
	else {
	    SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ����㹺�ҹ�������Ңͧ");
	}
	return 1;
}

CMD:removehouse(playerid,params[])
{
	new houseid = -1,
		string[128],
		str[128];

	if(playerData[playerid][pAdmin] < 3)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س������Ѻ͹حҵ��������觹��");

	if((houseid = GetClosestHouseID(playerid)) != -1) {

	    if(houseData[houseid][hOwned]) return SendClientMessage(playerid, COLOR_LIGHTRED, "�������ö����º�ҹ�������Ңͧ���ô�� /asellhouse");

		DestroyDynamic3DTextLabel(STREAMER_TAG_3D_TEXT_LABEL:houseData[houseid][hLabel]);

		format(string,sizeof(string),"�س�����º�ҹ䴹��Ԥ�ʹ�: %d!",houseData[houseid][hID]);
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
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س������Ѻ͹حҵ��������觹��");

	if(sscanf(params,"d",houseid)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /asellhouse [houseid]");
	
	houseid = GetHouseSID(houseid);
	
	if(!Iter_Contains(Iter_House, houseid)) return SendClientMessage(playerid, COLOR_GRAD1, "Invalid house ID.");
	if(!houseData[houseid][hOwned]) return SendClientMessage(playerid, COLOR_GRAD1, "   �����������Ңͧ��ҹ��ѧ���");

	foreach(new i : Player)
	{
	    if(playerData[i][pHouseKey] == houseid)
	    {
	        playerData[i][pHouseKey] = -1;
			format(strMSG, sizeof(strMSG), "������ %s ���º�ҹ�ͧ�س���Ѻ��Ҵ �س�繼����������������", ReturnPlayerName(playerid));
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
			SendClientMessage(i, COLOR_GRAD1, "��ҹ���س��Ҷ١������� �͹���س����շ�����������");
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
	        format(strMSG, sizeof(strMSG), ""EMBED_YELLOW"%s\n�Ҥ�: $%d\n�����: %d", GetHouseAddress(houseid), houseData[houseid][hPrice], houseData[houseid][hLevelbuy]);
	        houseData[houseid][hLabel] = CreateDynamic3DTextLabel(strMSG, -1, houseData[houseid][hPosX], houseData[houseid][hPosY], houseData[houseid][hPosZ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, houseData[houseid][hPosWorld], houseData[houseid][hPosInt], -1, 100.0);
			return 1;
		}

		format(strMSG, sizeof(strMSG), ""EMBED_YELLOW"%s\n�Ҥ�: $%d\n�����: %d", GetHouseAddress(houseid), houseData[houseid][hPrice], houseData[houseid][hLevelbuy]);
        UpdateDynamic3DTextLabelText(houseData[houseid][hLabel], -1, strMSG);
	}
	else
	{
		if(IsValidDynamic3DTextLabel(STREAMER_TAG_3D_TEXT_LABEL:houseData[houseid][hLabel])) DestroyDynamic3DTextLabel(STREAMER_TAG_3D_TEXT_LABEL:houseData[houseid][hLabel]);
	}
	return 1;
}


