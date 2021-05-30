#include <YSI\y_hooks>

#define	MAX_FACTIONS			50
#define MAX_FACTION_RANKS		21
#define MAX_FACTION_SKINS		20

#define FACTION_TYPE_NONE	 	-1
#define FACTION_TYPE_UNKNOWN	0
#define FACTION_TYPE_POLICE 	1
#define FACTION_TYPE_GOV 		2
#define FACTION_TYPE_MEDIC		3
#define FACTION_TYPE_NEWS		4
#define FACTION_TYPE_GANG		5
#define FACTION_TYPE_MECHA		6

new Siren[MAX_VEHICLES],
	SirenObject[MAX_VEHICLES];

enum E_FACTION_DATA
{
	fID,
	fName[60],
	fShortName[15],
    fType,
    fColor,
	Float:fSpawnX,
	Float:fSpawnY,
	Float:fSpawnZ,
    Float:fSpawnA,
    fSpawnInt,
    fSpawnWorld,
    fCash,

	// Settings
    fMaxSkins, // max_skin
    fMaxRanks, // max_rank
    fMaxVehicles, // max_veh
	fMinInvite, // max_invite
    bool:fChat,
    bool:fOOC,
    fPickup,

	fSpawnPickup // Gang
};

new factionData[MAX_FACTIONS][E_FACTION_DATA],
	factionRanks[MAX_FACTIONS][MAX_FACTION_RANKS][30],
	factionSkins[MAX_FACTIONS][MAX_FACTION_SKINS];

new Iterator:Iter_Faction<MAX_FACTIONS>;

static
	Float:skinChangPosX[MAX_PLAYERS],
	Float:skinChangPosY[MAX_PLAYERS];

new
	bool:TazerActive[MAX_PLAYERS char],
	bool:BeanbagActive[MAX_PLAYERS char];

hook OnGameModeInit() {

	mysql_query(dbCon, "SELECT * FROM `faction`");

	new
	    rows, str[128];

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_FACTIONS)
	{
        cache_get_value_name_int(i, "id", factionData[i][fID]);
        cache_get_value_name(i, "name", factionData[i][fName], 60);
        cache_get_value_name(i, "short_name", factionData[i][fShortName], 15);
        cache_get_value_name_int(i, "type", factionData[i][fType]);
        cache_get_value_name_int(i, "color", factionData[i][fColor]);
        cache_get_value_name_float(i, "spawnX", factionData[i][fSpawnX]);
        cache_get_value_name_float(i, "spawnY", factionData[i][fSpawnY]);
        cache_get_value_name_float(i, "spawnZ", factionData[i][fSpawnZ]);
        cache_get_value_name_float(i, "spawnA", factionData[i][fSpawnA]);
        cache_get_value_name_int(i, "spawnInt", factionData[i][fSpawnInt]);
        cache_get_value_name_int(i, "spawnWorld", factionData[i][fSpawnWorld]);
        cache_get_value_name_int(i, "cash", factionData[i][fCash]);
		cache_get_value_name_int(i, "maxRank", factionData[i][fMaxRanks]);
		cache_get_value_name_int(i, "maxSkin", factionData[i][fMaxSkins]);
		cache_get_value_name_int(i, "maxVeh", factionData[i][fMaxVehicles]);
		cache_get_value_name_int(i, "minInvite", factionData[i][fMinInvite]);

		format(str, sizeof str, "SELECT * FROM `faction_skin` WHERE `faction_id` = %d", factionData[i][fID]);
		mysql_pquery(dbCon, str, "Faction_LoadSkin", "i", i);

		format(str, sizeof str, "SELECT * FROM `faction_rank` WHERE `faction_id` = %d", factionData[i][fID]);
		mysql_pquery(dbCon, str, "Faction_LoadRank", "i", i);

		if (factionData[i][fType] == FACTION_TYPE_GANG && factionData[i][fSpawnX] != 0.0 && factionData[i][fSpawnY] != 0.0) {
			factionData[i][fSpawnPickup] = CreateDynamicPickup(1550, 21, factionData[i][fSpawnX], factionData[i][fSpawnY], factionData[i][fSpawnZ], factionData[i][fSpawnWorld], factionData[i][fSpawnInt], -1);
			Streamer_SetIntData(STREAMER_TYPE_PICKUP, factionData[i][fSpawnPickup], E_STREAMER_EXTRA_ID, i);
		}

        factionData[i][fOOC] = false;

        Iter_Add(Iter_Faction, i);

		/*format(str, sizeof str, "SELECT * FROM `vehicle` WHERE vehicleFaction = %d", factionData[i][fID]);
		mysql_tquery(dbCon, str, "Vehicle_Load", "");*/
	}

    printf("Faction loaded (%d/%d)", Iter_Count(Iter_Faction), MAX_FACTIONS);
	return 1;
}
/*
forward Faction_Load();
public Faction_Load() {

    new
	    rows, str[128];

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_FACTIONS)
	{
        cache_get_value_name_int(i, "id", factionData[i][fID]);
        cache_get_value_name(i, "name", factionData[i][fName], 60);
        cache_get_value_name(i, "short_name", factionData[i][fShortName], 15);
        cache_get_value_name_int(i, "type", factionData[i][fType]);
        cache_get_value_name_int(i, "color", factionData[i][fColor]);
        cache_get_value_name_float(i, "spawnX", factionData[i][fSpawnX]);
        cache_get_value_name_float(i, "spawnY", factionData[i][fSpawnY]);
        cache_get_value_name_float(i, "spawnZ", factionData[i][fSpawnZ]);
        cache_get_value_name_float(i, "spawnA", factionData[i][fSpawnA]);
        cache_get_value_name_int(i, "spawnInt", factionData[i][fSpawnInt]);
        cache_get_value_name_int(i, "spawnWorld", factionData[i][fSpawnWorld]);
        cache_get_value_name_int(i, "cash", factionData[i][fCash]);
		cache_get_value_name_int(i, "maxRank", factionData[i][fMaxRanks]);
		cache_get_value_name_int(i, "maxSkin", factionData[i][fMaxSkins]);
		cache_get_value_name_int(i, "maxVeh", factionData[i][fMaxVehicles]);
		cache_get_value_name_int(i, "minInvite", factionData[i][fMinInvite]);

		format(str, sizeof str, "SELECT * FROM `faction_skin` WHERE `faction_id` = %d", factionData[i][fID]);
		mysql_pquery(dbCon, str, "Faction_LoadSkin", "i", i);

		format(str, sizeof str, "SELECT * FROM `faction_rank` WHERE `faction_id` = %d", factionData[i][fID]);
		mysql_pquery(dbCon, str, "Faction_LoadRank", "i", i);

		if (factionData[i][fType] == FACTION_TYPE_GANG && factionData[i][fSpawnX] != 0.0 && factionData[i][fSpawnY] != 0.0) {
			factionData[i][fSpawnPickup] = CreateDynamicPickup(1550, 21, factionData[i][fSpawnX], factionData[i][fSpawnY], factionData[i][fSpawnZ], factionData[i][fSpawnWorld], factionData[i][fSpawnInt], -1);
			Streamer_SetIntData(STREAMER_TYPE_PICKUP, factionData[i][fSpawnPickup], E_STREAMER_EXTRA_ID, i);
		}

        factionData[i][fOOC] = false;

        Iter_Add(Iter_Faction, i);
	}

    printf("Faction loaded (%d/%d)", Iter_Count(Iter_Faction), MAX_FACTIONS);
	return 1;
}*/

forward Faction_LoadSkin(id);
public Faction_LoadSkin(id) {

    new
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < factionData[id][fMaxSkins])
	{
		cache_get_value_name_int(i, "skinID", factionSkins[id][i]);
	}
	return 1;
}

forward Faction_LoadRank(id);
public Faction_LoadRank(id) {

    new
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < factionData[id][fMaxRanks])
	{
		cache_get_value_name(i, "rankName", factionRanks[id][i], 30);
	}
	return 1;
}

Faction_Save(id) {
    if(Iter_Contains(Iter_Faction, id)) {
		new query[MAX_STRING];
		MySQLUpdateInit("faction", "id", factionData[id][fID], MYSQL_UPDATE_TYPE_THREAD); 
		MySQLUpdateStr(query, "name",factionData[id][fName]);
		MySQLUpdateStr(query, "short_name",factionData[id][fShortName]);
		MySQLUpdateInt(query, "type",factionData[id][fType]);
 	    MySQLUpdateInt(query, "color",factionData[id][fColor]);
 	    MySQLUpdateFlo(query, "spawnX",factionData[id][fSpawnX]);
		MySQLUpdateFlo(query, "spawnY",factionData[id][fSpawnY]);
		MySQLUpdateFlo(query, "spawnZ",factionData[id][fSpawnZ]);
		MySQLUpdateFlo(query, "spawnA",factionData[id][fSpawnA]);
		MySQLUpdateInt(query, "spawnInt",factionData[id][fSpawnInt]);
		MySQLUpdateInt(query, "spawnWorld",factionData[id][fSpawnWorld]);
		MySQLUpdateInt(query, "cash",factionData[id][fCash]);
		MySQLUpdateInt(query, "maxRank", factionData[id][fMaxRanks]);
		MySQLUpdateInt(query, "maxSkin", factionData[id][fMaxSkins]);
		MySQLUpdateInt(query, "maxVeh", factionData[id][fMaxVehicles]);
		MySQLUpdateInt(query, "minInvite", factionData[id][fMinInvite]);
		MySQLUpdateFinish(query);
    }
    return 1;
}

Faction_SaveRank(id, slot = -1) {
    if(Iter_Contains(Iter_Faction, id)) {
        new query[256];
		if(slot==-1) {
			for (new j = 0; j != MAX_FACTION_RANKS; j ++) if (j < factionData[id][fMaxRanks]) {
				mysql_format(dbCon, query, sizeof(query), "INSERT INTO faction_rank (rank_id, faction_id, rankName) \
				VALUES (%d, %d, '%e') \
				ON DUPLICATE KEY UPDATE rank_id = %d, faction_id = %d, rankName = '%e'", j, factionData[id][fID], factionRanks[id][j], j, factionData[id][fID], factionRanks[id][j]);
				mysql_pquery(dbCon, query);
			}
		}
		else {
			mysql_format(dbCon, query, sizeof(query), "INSERT INTO faction_rank (rank_id, faction_id, rankName) \
				VALUES (%d, %d, '%e') \
				ON DUPLICATE KEY UPDATE rank_id = %d, faction_id = %d, rankName = '%e'", slot, factionData[id][fID], factionRanks[id][slot], slot, factionData[id][fID], factionRanks[id][slot]);
			mysql_pquery(dbCon, query);
		}
    }
    return 1;
}


Faction_SaveSkin(id, slot = -1) {
    if(Iter_Contains(Iter_Faction, id)) {
        new query[256];
		if(slot==-1) {
			for (new j = 0; j != MAX_FACTION_SKINS; j ++) if (j < factionData[id][fMaxSkins]) {
				format(query, sizeof(query), "INSERT INTO faction_skin (skin_id, faction_id, skinID) \
				VALUES (%d, %d, %d) \
				ON DUPLICATE KEY UPDATE skin_id = %d, faction_id = %d, skinID = %d", j, factionData[id][fID], factionSkins[id][j], j, factionData[id][fID], factionSkins[id][j]);
				mysql_pquery(dbCon, query);
			}
		}
		else {
			format(query, sizeof(query), "INSERT INTO faction_skin (skin_id, faction_id, skinID) \
				VALUES (%d, %d, %d) \
				ON DUPLICATE KEY UPDATE skin_id = %d, faction_id = %d, skinID = %d", slot, factionData[id][fID], factionSkins[id][slot], slot, factionData[id][fID], factionSkins[id][slot]);
			mysql_pquery(dbCon, query);
		}
    }
    return 1;
}

forward OnFactionCreated(factionid);
public OnFactionCreated(factionid)
{
	if (factionid == -1)
	    return 0;

	factionData[factionid][fID] = cache_insert_id();

	Faction_Save(factionid);
	Faction_SaveRank(factionid);
    Faction_SaveSkin(factionid);
	return 1;
}
 
CMD:Siren(playerid, params[]) {
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType == FACTION_TYPE_POLICE){
        new type;
        new VID = GetPlayerVehicleID(playerid);
		new modelid = GetVehicleModel(VID);
        if(sscanf(params, "d", type))
        {
            SendClientMessage(playerid, COLOR_WHITE, "การใช้ : /siren [ชนิด]");
            SendClientMessage(playerid, COLOR_GREY, "ชนิด : 1 = ภายใน, 2 = หลังคา, 3 = ถอดออก");
            return 1;
        }
        switch(type)
        {
        	case 1:
            {
                if(Siren[VID] == 1)
                {
                    SendClientMessage(playerid, COLOR_GREY, "รถคันนี้แล้วมีไซเรนแล้ว!");
                    return 1;
                }
				Siren[VID] = 1;
				SirenObject[VID] = CreateDynamicObject(18646, 10.0, 10.0, 10.0, 0, 0, 0);
				AttachDynamicObjectToVehicle(SirenObject[VID], VID, 0.0, 0.75, 0.275, 0.0, 0.1, 0.0);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ติดไซเรนไว้ที่ภายในด้านหน้ารถ %s", ReturnRealName(playerid), ReturnVehicleModelName(modelid));
				return 1;
            }
        	case 2:
            {
                if(Siren[VID] == 1)
                {
                    SendClientMessage(playerid, COLOR_GREY, "รถคันนี้แล้วมีไซเรนแล้ว!");
                    return 1;
                }
                Siren[VID] = 1;
                SirenObject[VID] = CreateDynamicObject(18646, 10.0, 10.0, 10.0, 0, 0, 0);
                AttachDynamicObjectToVehicle(SirenObject[VID], VID, -0.43, 0.0, 0.785, 0.0, 0.1, 0.0);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ติดไซเรนไว้บนหลังคารถ %s", ReturnRealName(playerid), ReturnVehicleModelName(modelid));
                return 1;
            }
        	case 3:
            {
                if(Siren[VID] == 0)
                {
                    SendClientMessage(playerid, COLOR_GREY, "รถคันนี้ไม่มีไซเรน!");
                    return 1;
                }
                Siren[VID] = 0;
                DestroyDynamicObject(SirenObject[VID]);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ถอดไซเรนออกจากรถ %s", ReturnRealName(playerid), ReturnVehicleModelName(modelid));
                return 1;
            }
        	default:
            {
                SendClientMessage(playerid, COLOR_WHITE, "ประเภทสิทธิการใช้งานไม่ถูกต้อง! /siren [ชนิด]");
                SendClientMessage(playerid, COLOR_GREY, "ชนิด : 1 = หลังคา , 2 = ในรถ , 3 = ปิด");
            }
        }
    }
    else SendClientMessage(playerid, COLOR_GREY, "คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");
    return 1;
	
}

// Commands

flags:factioncmds(CMD_MANAGEMENT);
CMD:factioncmds(playerid) {
    SendClientMessage(playerid, COLOR_GRAD1, "คำสั่ง: /factionlist, /makefaction, /removefaction, /makeleader ");
    return 1;
}

flags:makeleader(CMD_LEAD_ADMIN);
CMD:makeleader(playerid, params[])
{
	new
		targetid,
		id;

	if (sscanf(params, "ud", targetid, id))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /makeleader [ไอดีผู้เล่น/ชื่อบางส่วน] [ไอดี (/factionlist)] (ใช้ 0 เพื่อปลด)");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (id == 0)
	{
	    playerData[targetid][pFaction] = 0;
		playerData[targetid][pFactionRank] = 0;
		SetPlayerToTeamColor(targetid);
	    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "   คุณได้ลบ %s จากฝ่ายหรือกลุ่มของเขา", ReturnRealName(targetid));
    	SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "   %s ได้ลบคุณออกจากฝ่ายหรือกลุ่มของคุณ", ReturnRealName(playerid));
		return 1;
	}

	id--;
	if(Iter_Contains(Iter_Faction, id))
	{
		playerData[targetid][pFaction] = factionData[id][fID];
		playerData[targetid][pFactionRank] = 1;
		SetPlayerToTeamColor(targetid);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "   คุณได้ตั้งค่าฝ่ายหรือกลุ่มของ %s เป็น \"%s\"", ReturnRealName(targetid), factionData[id][fName]);
    	SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "   %s ได้ตั้งค่าฝ่ายหรือกลุ่มของคุณเป็น \"%s\"", ReturnRealName(playerid), factionData[id][fName]);
	
	} 
	else SendClientMessageEx(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"ไม่พบแฟคชั่นไอดี "EMBED_ORANGE"%d"EMBED_WHITE" อยู่ในระบบ", id + 1);

    return 1;
}

flags:asetrank(CMD_LEAD_ADMIN);
CMD:asetrank(playerid, params[])
{
	new
		targetid,
		rank;

	if (sscanf(params, "ud", targetid, rank))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /asetrank [ไอดีผู้เล่น/ชื่อบางส่วน] [ยศ]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (playerData[targetid][pFaction] == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ใช่สมาชิกของฝ่ายหรือกลุ่มใด ๆ");

    /*if (rank < 1 || rank > factionData[factionid][fMaxRanks])
        return SendClientMessageEx(playerid, COLOR_GRAD1, "   ยศไม่ถูกต้อง ยศของฝ่ายหรือกลุ่มนี้อยู่ระหว่าง 1 ถึง %d", factionData[factionid][fMaxRanks]);
	*/

    if (rank < 1 || rank > 21)
        return SendClientMessageEx(playerid, COLOR_GRAD1, "   ยศไม่ถูกต้อง ยศของฝ่ายหรือกลุ่มนี้อยู่ระหว่าง 1 ถึง 21");
	
	playerData[targetid][pFactionRank] = rank;

	new fid = Faction_GetID(playerData[targetid][pFaction]);
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "   คุณได้ตั้งค่ายศฝ่ายหรือกลุ่มของ %s เป็น %s(%d)", ReturnRealName(targetid), Faction_GetRankName(fid, rank), rank);
    SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "   %s ได้ตั้งค่ายศฝ่ายหรือกลุ่มของคุณเป็น %s(%d)", ReturnRealName(playerid), Faction_GetRankName(fid, rank), rank);

    return 1;
}

flags:makefaction(CMD_MANAGEMENT);
CMD:makefaction(playerid, params[])
{
	new
		type,
        id = -1,
        abbrev[15],
		name[60];

	if (sscanf(params, "ds[15]s[60]", type, abbrev, name))
	{
        SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /makefaction [ประเภท] [ชื่อย่อ] [ชื่อฝ่าย] ");
        SendClientMessage(playerid, COLOR_GRAD2, "[ประเภท] 0: ไม่ระบุ 1: ผู้บังคับใช้กฎหมาย (Law Enforcement) - 2: รัฐบาล (Government)");
		SendClientMessage(playerid, COLOR_GRAD2, "[ประเภท] 3: แพทย์ (Medical) - 4: นักข่าว (News Network) - 5: แก๊งค์ - 6: ช่างซ่อมรถ (Mechanic)");
	    SendClientMessage(playerid, COLOR_LIGHTRED,   "[ ! ]"EMBED_WHITE" ชื่อย่อห้ามมีช่องว่าง");
		return 1;
	}
    if(type < 0 || type > 6) {
        SendClientMessage(playerid, COLOR_LIGHTRED,   "ความผิดพลาด: "EMBED_WHITE"ประเภทแฟคชั่นต้องไม่ต่ำกว่า "EMBED_ORANGE"0"EMBED_WHITE" หรือมากกว่า "EMBED_ORANGE"6");
        return 1;
    }

    if((id = Iter_Free(Iter_Faction)) != -1) {

	    format(factionData[id][fName], 60, name);
        format(factionData[id][fShortName], 15, abbrev);

        factionData[id][fColor] = 0xFFFFFF;
        factionData[id][fType] = type;
        factionData[id][fMaxRanks] = 6;
        factionData[id][fMaxSkins] = 0;
        factionData[id][fMaxVehicles] = 0;
		factionData[id][fMinInvite] = 1;

		for (new j = 0; j != MAX_FACTION_RANKS; j ++) {
		    format(factionRanks[id][j], 30, "ยศ %d", j + 1);
		}

		for (new j = 0; j != MAX_FACTION_SKINS; j ++) {
		    factionSkins[id][j] = 0;
		}

	    mysql_tquery(dbCon, "INSERT INTO `faction` (`type`) VALUES(0)", "OnFactionCreated", "d", id);

		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้สร้างแฟคชั่น %s"EMBED_YELLOW" ไอดี %d", ReturnPlayerName(playerid), name, id +1);

        Iter_Add(Iter_Faction, id);
    }
    else {
        SendClientMessageEx(playerid, COLOR_LIGHTRED,   "ความผิดพลาด: "EMBED_WHITE"ไม่สามารถสร้างแฟคชั่นได้มากกว่านี้แล้ว จำกัดไว้ที่ "EMBED_ORANGE"%d", MAX_FACTIONS);
    }
	return 1;
}

CMD:removefaction(playerid, params[]) {
	new
	    id = 0;

	if (sscanf(params, "d", id))
 	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /removefaction [ไอดี (/factionlist)]");
		return 1;
	}

	id--;
	if(Iter_Contains(Iter_Faction, id))
	{
		new
	        string[80];

		//ปลดผู้เล่นออกจากแฟคชั่นที่ถูกลบ
		format(string, sizeof(string), "UPDATE `players` SET `faction_id`=0,`SpawnType`=0  WHERE `faction_id`=%d", factionData[id][fID]);
		mysql_tquery(dbCon, string);

		foreach (new i : Player)
		{
			if (playerData[i][pFaction] == factionData[id][fID]) {
		    	playerData[i][pFaction] = 0;
		    	playerData[i][pFactionRank] = 0;
				SetPlayerSkin(i, playerData[i][pModel]);
			}
			DeletePVar(i, "FactionEditID");
		}

		//ลบยานพาหนะทั้งหมดของแฟคชั่น ใช้ FOREIGN KEY ช่วยลบในฐานข้อมูล
		DestroyFactionVehicle(playerid, id);

		//ลบแฟคชั่น
		format(string, sizeof(string), "DELETE FROM `faction` WHERE `id` = '%d'", factionData[id][fID]);
		mysql_tquery(dbCon, string);

		Log(adminactionlog, INFO, "%s: ลบแฟคชั่น %s(%d)", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID]);

		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้ลบแฟคชั่น %s"EMBED_YELLOW" ไอดี %d", ReturnPlayerName(playerid), factionData[id][fName], id +1);

		Iter_Remove(Iter_Faction, id);
	}
	else {
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"ไม่พบแฟคชั่นไอดี "EMBED_ORANGE"%d"EMBED_WHITE" อยู่ในระบบ", id + 1);
	}
	return 1;
}

flags:factionlist(CMD_LEAD_ADMIN);
CMD:factionlist(playerid) {
    Faction_List(playerid);
    return 1;
}

Faction_Name(factionid)
{
    new
		name[60] = "ประชาชน";

 	if (Iter_Contains(Iter_Faction, factionid)) {
		 format(name, 60, factionData[factionid][fName]);
	 }
	return name;
}

Faction_List(playerid)
{
	new string[2048], menu[20], count;

	format(string, sizeof(string), "%s"EMBED_GRAD1"หน้า 1\n", string);

	SetPVarInt(playerid, "page", 1);

	foreach(new i : Iter_Faction) {
		if(count == 20)
		{
			format(string, sizeof(string), "%s"EMBED_GRAD1"หน้า 2\n", string);
			break;
		}
		format(menu, 20, "menu%d", ++count);
		SetPVarInt(playerid, menu, i);
		format(string, sizeof(string), "%s("EMBED_ORANGE"%i"EMBED_WHITE") | %s\n", string, i + 1, factionData[i][fName]);
	}
	if(!count) Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "รายชื่อแฟคชั่น", "ไม่พบข้อมูลของแฟคชั่น..", "ปิด", "");
	else Dialog_Show(playerid, FactionsList, DIALOG_STYLE_LIST, "รายชื่อแฟคชั่น", string, "แก้ไข", "กลับ");
	return 1;
}

Faction_GetID(factionid) // ค้นหา index
{
	foreach(new i : Iter_Faction) {
		if (factionData[i][fID] == factionid) {
			return i;
		}
	}
	return -1;
}

Faction_GetName(factionid) // ค้นหา index
{
	new name[60] = "ประชาชน";
	if (Iter_Contains(Iter_Faction, factionid)) {
		format(name, 60, factionData[factionid][fName]);
	}
	return name;
}

Faction_GetRankName(factionid, rankid)
{
	new name[30] = "ไม่มี";
	if (Iter_Contains(Iter_Faction, factionid)) {
		if (rankid > 0) {
			format(name, 30, factionRanks[factionid][rankid - 1]);
		}
	}
	return name;
}

Faction_GetTypeID(factionid)
{
	foreach(new i : Iter_Faction) {
		if (factionData[i][fID] == factionid) {
			return factionData[i][fType];
		}
	}
	return FACTION_TYPE_NONE;
}

Faction_GetTypeName(type) {
    new faction_type[24];
    switch(type) {
        case FACTION_TYPE_POLICE: format(faction_type, sizeof faction_type, "ผู้บังคับใช้กฎหมาย");
		case FACTION_TYPE_GOV: format(faction_type, sizeof faction_type, "รัฐบาล");
        case FACTION_TYPE_MEDIC: format(faction_type, sizeof faction_type, "แพทย์");
        case FACTION_TYPE_NEWS: format(faction_type, sizeof faction_type, "นักข่าว");
        case FACTION_TYPE_GANG: format(faction_type, sizeof faction_type, "แก๊งค์");
		case FACTION_TYPE_MECHA: format(faction_type, sizeof faction_type, "ช่างซ่อมรถ");
        default: format(faction_type, sizeof faction_type, "ไม่ระบุ");
    }
    return faction_type;
}

Dialog:FactionsList(playerid, response, listitem, inputtext[])
{
	if(response) {

		new menu[20];
		if(listitem != 0 && listitem != 21) {

			if(!(playerData[playerid][pCMDPermission] & CMD_MANAGEMENT)) {
				SendClientMessage(playerid, COLOR_LIGHTRED, "ความผิดพลาด"EMBED_WHITE": คุณไม่ได้รับอนุญาตให้ใช้ฟังก์ชั่นการแก้ไข "EMBED_RED"(MANAGEMENT ONLY)");
				return Faction_List(playerid);
			}
			new str_biz[20];
			format(str_biz, 20, "menu%d", listitem);

			SetPVarInt(playerid, "FactionEditID", GetPVarInt(playerid, str_biz));
			Faction_EditMenu(playerid);
			return 1;
		}

		new currentPage = GetPVarInt(playerid, "page");
		if(listitem==0) {
			if(currentPage>1) currentPage--;
		}
		else if(listitem == 21) currentPage++;

		new string[2048], count;
		format(string, sizeof(string), "%s"EMBED_GRAD1"หน้า %d\n", string, (currentPage==1) ? 1 : currentPage-1);

		SetPVarInt(playerid, "page", currentPage);

		new skipitem = (currentPage-1) * 20;

		foreach(new i : Iter_Faction) {

			if(skipitem)
			{
				skipitem--;
				continue;
			}
			if(count == 20)
			{
				format(string, sizeof(string), "%s"EMBED_GRAD1"หน้า 2\n", string);
				break;
			}
			format(menu, 20, "menu%d", ++count);
			SetPVarInt(playerid, menu, i);
			format(string, sizeof(string), "%s("EMBED_ORANGE"%i"EMBED_WHITE") | %s\n", string, i + 1, factionData[i][fName]);

		}

		Dialog_Show(playerid, FactionsList, DIALOG_STYLE_LIST, "รายชื่อแฟคชั่น", string, "แก้ไข", "กลับ");
	}
	return 1;
}

Faction_EditMenu(playerid)
{
    new id = GetPVarInt(playerid, "FactionEditID");
	if(Iter_Contains(Iter_Faction, id))
	{
		new caption[128], dialog_str[1024];
		format(caption, sizeof(caption), "แฟคชั่น: "EMBED_WHITE"%s"EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")", factionData[id][fName], id + 1);
        format(dialog_str, sizeof dialog_str, "ชื่อ\t%s\n", factionData[id][fName]);
        format(dialog_str, sizeof dialog_str, "%sชื่อย่อ\t%s\n", dialog_str, factionData[id][fShortName]);
        format(dialog_str, sizeof dialog_str, "%sสี\t{%06x}%06x\n", dialog_str, factionData[id][fColor] >>> 8, factionData[id][fColor]  >>> 8);
        format(dialog_str, sizeof dialog_str, "%sประเภท\t%s\n", dialog_str, Faction_GetTypeName(factionData[id][fType]));
       /*format(dialog_str, sizeof dialog_str, "%sยศ\t%d/%d\n", dialog_str, factionData[id][fMaxRanks], MAX_FACTION_RANKS);
        format(dialog_str, sizeof dialog_str, "%sสกิน\t%d/%d\n", dialog_str, factionData[id][fMaxSkins], MAX_FACTION_SKINS);
        format(dialog_str, sizeof dialog_str, "%sยานพาหนะ\t%d\n", dialog_str, factionData[id][fMaxVehicles]);*/
        format(dialog_str, sizeof dialog_str, "%sตั้งค่าอื่น ๆ", dialog_str);
		Dialog_Show(playerid, FactionEdit, DIALOG_STYLE_TABLIST, caption, dialog_str, "เลือก", "กลับ");
	}
	return 1;
}

Dialog:FactionEdit(playerid, response, listitem, inputtext[])
{
	if(response) {
  
        new id = GetPVarInt(playerid, "FactionEditID");
		switch(listitem)
		{
			case 0: // แก้ไขชื่อ
			{
				Dialog_Show(playerid, FactionEdit_Name, DIALOG_STYLE_INPUT, sprintf("แก้ไข -> ชื่อ: "EMBED_YELLOW"%s", factionData[id][fName]), ""EMBED_WHITE"ความยาวของชื่อต้องมากกว่า "EMBED_ORANGE"0 "EMBED_WHITE"และไม่เกิน "EMBED_ORANGE"60 "EMBED_WHITE"ตัวอักษร\n\nกรอกชื่อแฟคชั่นที่ต้องการในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ");
			}
			case 1: // แก้ไขชื่อย่อ
			{
				Dialog_Show(playerid, FactionEdit_ShortName, DIALOG_STYLE_INPUT, sprintf("แก้ไข -> ชื่อย่อ: "EMBED_YELLOW"%s", factionData[id][fShortName]), ""EMBED_WHITE"ความยาวของชื่อย่อต้องมากกว่า "EMBED_ORANGE"0 "EMBED_WHITE"และไม่เกิน "EMBED_ORANGE"15 "EMBED_WHITE"ตัวอักษร\n\nกรอกชื่อแฟคชั่นที่ต้องการในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ");
			}
			case 2: // แก้ไขสี
			{
				Dialog_Show(playerid, FactionEdit_Color, DIALOG_STYLE_INPUT, sprintf("แก้ไข -> สี: {%06x}%06x", factionData[id][fColor] >>> 8, factionData[id][fColor] >>> 8), ""EMBED_WHITE"ตัวอย่างโค้ดสี: "EMBED_YELLOW"ffff00"EMBED_WHITE"\n\nกรอกโค้ดสีที่ต้องการในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ");
			}
			case 3: // แก้ไขประเภท
			{
				/*
				UNKNOWN		0
				POLICE 		1
				GOV 		2
				MEDIC		3
				NEWS		4
				GANG		5
				*/
				Dialog_Show(playerid, FactionEdit_Type, DIALOG_STYLE_LIST, sprintf("แก้ไข -> ประเภท: %s", Faction_GetTypeName(factionData[id][fType])), "0: ไม่ระบุ\n1: ผู้บังคับใช้กฎหมาย (Law Enforcement)\n2: รัฐบาล (Government)\n3: แพทย์ (Medical)\n4: นักข่าว (News Network)\n5: ผิดกฎหมาย\n6: ช่างซ่อมรถ", "เปลี่ยน", "กลับ");
			}
			case 4: // ตั้งค่าอื่น ๆ
			{
				Dialog_Show(playerid, FactionEdit_Settings, DIALOG_STYLE_TABLIST, "แก้ไข -> ตั้งค่าอื่น ๆ", "ยศ\t%d/%d\nสกิน\t%d/%d\nยานพาหนะสูงสุด\t%d\nยศต่ำสุดที่เชิญ/เตะได้\t%d\nจุดเกิด\t", "เลือก", "กลับ", factionData[id][fMaxRanks], MAX_FACTION_RANKS, factionData[id][fMaxSkins], MAX_FACTION_SKINS, factionData[id][fMaxVehicles], factionData[id][fMinInvite]);
			}
			/*case 4: // แก้ไขยศ
			{
				Dialog_Show(playerid, FactionEdit_Rank, DIALOG_STYLE_LIST, "แก้ไข -> ยศ", "ยศที่ใช้งานได้\t(%d/%d)\nชื่อยศ\t", "แก้ไข", "กลับ", factionData[id][fMaxRanks], MAX_FACTION_RANKS);
			}
			case 5: // แก้ไขสกิน
			{
				Dialog_Show(playerid, FactionEdit_Skin, DIALOG_STYLE_LIST, "แก้ไข -> สกิน", "สกินที่ใช้ได้\t(%d/%d)\nไอดีสกิน\t", "แก้ไข", "กลับ", factionData[id][fMaxSkins], MAX_FACTION_SKINS);
			}
			case 6: // แก้ไขพาหนะ
			{
				Dialog_Show(playerid, FactionEdit_VehMax, DIALOG_STYLE_INPUT, "แก้ไข -> พาหนะ", "ปัจจุบัน: %d\n\nกรอกจำนวนพาหนะสูงสุดในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ", factionData[id][fMaxVehicles]);
			}
			case 7: // จุดเกิด
			{
				Dialog_Show(playerid, FactionEdit_Spawn, DIALOG_STYLE_LIST, "แก้ไข -> ตั้งค่าจุดเกิด", "ปรับจุดเกิด\nลบล้างจุดเกิด", "ปรับ", "กลับ");
			}*/
		}
	}
	else
	{
	    DeletePVar(playerid, "FactionEditID");
        Faction_List(playerid);
	}
    return 1;
}

Dialog:FactionEdit_Name(playerid, response, listitem, inputtext[])
{
	if(response) {
		new caption[128];
		new id = GetPVarInt(playerid, "FactionEditID");

		if(isnull(inputtext) || strlen(inputtext) >= 60) {
			format(caption, sizeof(caption), "แก้ไข -> ชื่อ: "EMBED_YELLOW"%s", factionData[id][fName]);
			Dialog_Show(playerid, FactionEdit_Name, DIALOG_STYLE_INPUT, caption, ""EMBED_LIGHTRED"พบข้อผิดพลาด:\n"EMBED_WHITE"ความยาวของชื่อต้องมากกว่า "EMBED_YELLOW"0 "EMBED_WHITE"และไม่เกิน "EMBED_YELLOW"60 "EMBED_WHITE"ตัวอักษร", "เปลี่ยน", "กลับ");
			return 1;
		}
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนชื่อแฟคชั่น %s"EMBED_YELLOW" เป็น %s", ReturnPlayerName(playerid), factionData[id][fName], inputtext);
	
		Log(adminactionlog, INFO, "%s: เปลี่ยนชื่อ %s(%d) จาก %s เป็น %s", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fName], inputtext);

		format(factionData[id][fName], 60, inputtext);

		Faction_Save(id);
	}
	return Faction_EditMenu(playerid);
}

Dialog:FactionEdit_ShortName(playerid, response, listitem, inputtext[])
{
	if(response) {
		new caption[128];
		new id = GetPVarInt(playerid, "FactionEditID");

		if(isnull(inputtext) || strlen(inputtext) >= 15) {
			format(caption, sizeof(caption), "แก้ไข -> ชื่อย่อ: "EMBED_YELLOW"%s", factionData[id][fShortName]);
			Dialog_Show(playerid, FactionEdit_ShortName, DIALOG_STYLE_INPUT, caption, ""EMBED_LIGHTRED"พบข้อผิดพลาด:\n"EMBED_WHITE"ความยาวของชื่อย่อต้องมากกว่า "EMBED_YELLOW"0 "EMBED_WHITE"และไม่เกิน "EMBED_YELLOW"15 "EMBED_WHITE"ตัวอักษร", "เปลี่ยน", "กลับ");
			return 1;
		}
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนชื่อย่อแฟคชั่น %s"EMBED_YELLOW" เป็น %s", ReturnPlayerName(playerid), factionData[id][fName], inputtext);

		Log(adminactionlog, INFO, "%s: เปลี่ยนชื่อย่อ %s(%d) จาก %s เป็น %s", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fShortName], inputtext);
	
		format(factionData[id][fShortName], 15, inputtext);
		Faction_Save(id);
	}
	return Faction_EditMenu(playerid);
}

Dialog:FactionEdit_Color(playerid, response, listitem, inputtext[])
{
	if(response) {

		new caption[128], id = GetPVarInt(playerid, "FactionEditID"), color;
		if (sscanf(inputtext, "x", color)) {
			format(caption, sizeof(caption), "แก้ไข -> สี: {%06x}%06x", factionData[id][fColor], factionData[id][fColor]);
			return Dialog_Show(playerid, FactionEdit_Color, DIALOG_STYLE_INPUT, caption, ""EMBED_WHITE"ตัวอย่างโค้ดสี: "EMBED_YELLOW"ffff0077"EMBED_WHITE"\n\nกรอกโค้ดสีที่ต้องการในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ");
		}
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนสีของแฟคชั่น %s"EMBED_YELLOW" เป็น {%06x}%06x", ReturnPlayerName(playerid), factionData[id][fName], color >>> 8, color >>> 8);

		new string[256];
		format(string, sizeof string, "%s: เปลี่ยนสี %s(%d) จาก %06x เป็น %06x", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fColor], color);
		Log(adminactionlog, INFO, string);

	    factionData[id][fColor] = color;
	    Faction_Save(id);
	}
	return Faction_EditMenu(playerid);
}

Dialog:FactionEdit_Type(playerid, response, listitem, inputtext[])
{
	if(response) {
		new id = GetPVarInt(playerid, "FactionEditID");
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนประเภทแฟคชั่น %s"EMBED_YELLOW" เป็น %s", ReturnPlayerName(playerid), factionData[id][fName], Faction_GetTypeName(factionData[id][fType]), Faction_GetTypeName(listitem));
		Log(adminactionlog, INFO, "%s: เปลี่ยนประเภท %s(%d) จาก %s เป็น %s", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], Faction_GetTypeName(factionData[id][fType]), Faction_GetTypeName(listitem));
		factionData[id][fType] = listitem;
	    Faction_Save(id);
	}
	return Faction_EditMenu(playerid);
}

Dialog:FactionEdit_Settings(playerid, response, listitem, inputtext[])
{
	if(response) { 
		new id = GetPVarInt(playerid, "FactionEditID");
		switch(listitem) {
			case 0: {
				return Dialog_Show(playerid, FactionEdit_Rank, DIALOG_STYLE_LIST, "แก้ไข -> ยศ", "ยศที่ใช้งานได้\t(%d/%d)\nชื่อยศ\t", "เลือก", "กลับ", factionData[id][fMaxRanks], MAX_FACTION_RANKS);
			}
			case 1: {
				return Dialog_Show(playerid, FactionEdit_Skin, DIALOG_STYLE_LIST, "แก้ไข -> สกิน", "สกินที่ใช้ได้\t(%d/%d)\nไอดีสกิน\t", "เลือก", "กลับ", factionData[id][fMaxSkins], MAX_FACTION_SKINS);
			}
			case 2: {
				return Dialog_Show(playerid, FactionEdit_VehMax, DIALOG_STYLE_INPUT, "แก้ไข -> พาหนะ", "ปัจจุบัน: %d\n\nกรอกจำนวนพาหนะสูงสุดในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ", factionData[id][fMaxVehicles]);
			}
			case 3: {
				return Dialog_Show(playerid, FactionEdit_Invite, DIALOG_STYLE_INPUT, "แก้ไข -> การเชิญ", "ปัจจุบัน: %d\n\nกรอกหมายเลขยศต่ำสุดที่ต้องการให้มีสิทธิ์เชิญในช่องว่างด้านล่างนี้ (1-%d):", "เปลี่ยน", "กลับ", factionData[id][fMinInvite], factionData[id][fMaxRanks]);
			}
			case 4: {
				return Dialog_Show(playerid, FactionEdit_Spawn, DIALOG_STYLE_LIST, "แก้ไข -> ตั้งค่าจุดเกิด", "ปรับจุดเกิด\nลบล้างจุดเกิด", "ปรับ", "กลับ");
			}
		}
	}
	return Faction_EditMenu(playerid);
}

Dialog:FactionEdit_Rank(playerid, response, listitem, inputtext[])
{
	if(response) { 
        new id = GetPVarInt(playerid, "FactionEditID");
		switch(listitem) {
			case 0: {
				return Dialog_Show(playerid, FactionEdit_RankMax, DIALOG_STYLE_INPUT, "แก้ไข -> ยศ", ""EMBED_WHITE"ปัจจุบัน: %d/%d\n\nกรอกจำนวนยศสูงสุดในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ", factionData[id][fMaxRanks], MAX_FACTION_RANKS);
			}
			case 1: {
				if(factionData[id][fMaxRanks] == 0) return Dialog_Show(playerid, FactionEdit_Rank, DIALOG_STYLE_LIST, "แก้ไข -> ยศ", "ยศที่ใช้งานได้\t(%d/%d)\nชื่อยศ\t", "แก้ไข", "กลับ", factionData[id][fMaxRanks], MAX_FACTION_RANKS);
				else return Faction_EditMenu_RankList(playerid);
			}
		}
	}
	return Faction_EditMenu(playerid);
}

Faction_EditMenu_RankList(playerid) {
	new
		string[45 * MAX_FACTION_RANKS], id = GetPVarInt(playerid, "FactionEditID");

	for (new i = 0; i < factionData[id][fMaxRanks]; i ++)
		format(string, sizeof(string), "%sยศ %d: "EMBED_YELLOW"%s\n", string, i + 1, factionRanks[id][i]);

	return Dialog_Show(playerid, FactionEdit_RankName, DIALOG_STYLE_LIST, "ยศ -> ชื่อยศ", string, "แก้ไข", "กลับ");
}

Dialog:FactionEdit_RankName(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "FactionEditID");
	if (response)
	{
		SetPVarInt(playerid, "FactionEditSlot", listitem);
		return Dialog_Show(playerid, FactionEdit_SetRankName, DIALOG_STYLE_INPUT, "ยศ -> ชื่อยศ", ""EMBED_WHITE"ยศ: "EMBED_YELLOW"%s "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\nกรุณาป้อนชื่อยศใหม่ด้านล่างนี้:", "เปลี่ยน", "กลับ", factionRanks[id][listitem], listitem + 1);
	}
	return Dialog_Show(playerid, FactionEdit_Rank, DIALOG_STYLE_LIST, "แก้ไข -> ยศ", "ยศที่ใช้งานได้\t(%d/%d)\nชื่อยศ\t", "แก้ไข", "กลับ", factionData[id][fMaxRanks], MAX_FACTION_RANKS);
}

Dialog:FactionEdit_SetRankName(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new rank_slot = GetPVarInt(playerid, "FactionEditSlot"), id = GetPVarInt(playerid, "FactionEditID");

	    if (isnull(inputtext))
			return Dialog_Show(playerid, FactionEdit_SetRankName, DIALOG_STYLE_INPUT, "ยศ -> ชื่อยศ", ""EMBED_WHITE"ยศ: "EMBED_YELLOW"%s "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\nกรุณาป้อนชื่อยศใหม่ด้านล่างนี้:", "เปลี่ยน", "กลับ", factionRanks[id][rank_slot], rank_slot + 1);

	    if (strlen(inputtext) < 1 || strlen(inputtext) > 30)
	        return Dialog_Show(playerid, FactionEdit_SetRankName, DIALOG_STYLE_INPUT, "ยศ -> ชื่อยศ", ""EMBED_WHITE"ยศ: "EMBED_YELLOW"%s "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n"EMBED_LIGHTRED"ข้อผิดพลาด"EMBED_WHITE": ความยาวของชื่อต้องไม่ต่ำกว่า "EMBED_ORANGE"1"EMBED_WHITE" หรือมากกว่า "EMBED_ORANGE"30"EMBED_WHITE"\n\nกรุณาป้อนชื่อยศใหม่ด้านล่างนี้:", "เปลี่ยน", "กลับ", factionRanks[id][rank_slot], rank_slot + 1);

		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนชื่อยศที่ %d ของแฟคชั่น %s"EMBED_YELLOW" เป็น %s", ReturnPlayerName(playerid), rank_slot + 1, factionData[id][fName], inputtext);

		Log(adminactionlog, INFO, "%s: เปลี่ยนชื่อยศของ %s(%d) ยศที่ %d จาก %s เป็น %s", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], rank_slot + 1, factionRanks[id][rank_slot], inputtext);
		format(factionRanks[id][rank_slot], 30, inputtext);
	    Faction_SaveRank(id, rank_slot);
	}
	return Faction_EditMenu_RankList(playerid);
}

Dialog:FactionEdit_RankMax(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "FactionEditID");
	if(response) {
		new typeint = strval(inputtext);
		if(typeint < 0 || typeint > MAX_FACTION_RANKS) {
			return Dialog_Show(playerid, FactionEdit_RankMax, DIALOG_STYLE_INPUT, "แก้ไข -> ยศ", ""EMBED_WHITE"ปัจจุบัน: %d/%d\n"EMBED_LIGHTRED"ข้อผิดพลาด"EMBED_WHITE": จำนวนต้องไม่ต่ำกว่า "EMBED_ORANGE"0"EMBED_WHITE" หรือมากกว่า "EMBED_ORANGE"%d"EMBED_WHITE"\n\nกรอกจำนวนยศสูงสุดในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ", factionData[id][fMaxRanks], MAX_FACTION_RANKS, MAX_FACTION_RANKS);
		}
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนยศที่ใช้งานได้ของแฟคชั่น %s"EMBED_YELLOW" เป็น %d", ReturnPlayerName(playerid), factionData[id][fName], typeint);

		Log(adminactionlog, INFO, "%s: เปลี่ยนยศสูงสุดของ %s(%d) จาก %d เป็น %d", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fMaxRanks], typeint);
	    factionData[id][fMaxRanks] = typeint;
	    Faction_Save(id);
	}
	return Dialog_Show(playerid, FactionEdit_Rank, DIALOG_STYLE_LIST, "แก้ไข -> ยศ", "จำนวนยศ\t(%d/%d)\nชื่อยศ\t", "แก้ไข", "กลับ", factionData[id][fMaxRanks], MAX_FACTION_RANKS);
}

Dialog:FactionEdit_Invite(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "FactionEditID");
	if(response) {
		new typeint = strval(inputtext);
		if(typeint < 1 || typeint > factionData[id][fMaxRanks]) {
			return Dialog_Show(playerid, FactionEdit_Invite, DIALOG_STYLE_INPUT, "แก้ไข -> การเชิญ", "ปัจจุบัน: %d\n\nกรอกหมายเลขยศต่ำสุดที่ต้องการให้มีสิทธิ์เชิญในช่องว่างด้านล่างนี้ (1-%d):", "เปลี่ยน", "กลับ", factionData[id][fMinInvite], factionData[id][fMaxRanks]);
		}
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนยศต่ำสุดที่สามารถเชิญได้ของแฟคชั่น %s"EMBED_YELLOW" เป็น %d", ReturnPlayerName(playerid), factionData[id][fName], typeint);

		Log(adminactionlog, INFO, "%s: เปลี่ยนยศยศต่ำสุดที่สามารถเชิญได้ของ %s(%d) จาก %d เป็น %d", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fMinInvite], typeint);
	    factionData[id][fMinInvite] = typeint;
	    Faction_Save(id);
	}
	return Faction_EditMenu(playerid);
}

Dialog:FactionEdit_Skin(playerid, response, listitem, inputtext[])
{
	if(response) { 
        new id = GetPVarInt(playerid, "FactionEditID");
		switch(listitem) {
			case 0: {
				return Dialog_Show(playerid, FactionEdit_SkinMax, DIALOG_STYLE_INPUT, "แก้ไข -> สกิน", ""EMBED_WHITE"ปัจจุบัน: %d/%d\n\nกรอกจำนวนสกินสูงสุดในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ", factionData[id][fMaxSkins], MAX_FACTION_SKINS);
			}
			case 1: {
				if(factionData[id][fMaxSkins] == 0) return Dialog_Show(playerid, FactionEdit_Skin, DIALOG_STYLE_LIST, "แก้ไข -> สกิน", "สกินที่ใช้ได้\t(%d/%d)\nไอดีสกิน\t", "แก้ไข", "กลับ", factionData[id][fMaxSkins], MAX_FACTION_SKINS);
				else return Faction_EditMenu_SkinList(playerid);
			}
		}
	}
	return Faction_EditMenu(playerid);
}

Faction_EditMenu_SkinList(playerid) {
	new
		string[45 * MAX_FACTION_SKINS], id = GetPVarInt(playerid, "FactionEditID");

	for (new i = 0; i < factionData[id][fMaxSkins]; i ++)
		format(string, sizeof(string), "%sสกิน %d: "EMBED_YELLOW"%d\n", string, i + 1, factionSkins[id][i]);

	return Dialog_Show(playerid, FactionEdit_SkinID, DIALOG_STYLE_LIST, "สกิน -> ไอดีสกิน", string, "แก้ไข", "กลับ");
}

Dialog:FactionEdit_SkinMax(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "FactionEditID");
	if(response) {
		new typeint = strval(inputtext);
		if(typeint < 0 || typeint > MAX_FACTION_SKINS) {
			return Dialog_Show(playerid, FactionEdit_SkinMax, DIALOG_STYLE_INPUT, "แก้ไข -> สกิน", ""EMBED_WHITE"ปัจจุบัน: %d/%d\n"EMBED_LIGHTRED"ข้อผิดพลาด"EMBED_WHITE": จำนวนต้องไม่ต่ำกว่า "EMBED_ORANGE"0"EMBED_WHITE" หรือมากกว่า "EMBED_ORANGE"%d"EMBED_WHITE"\n\nกรอกจำนวนสกินสูงสุดในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ", factionData[id][fMaxRanks], MAX_FACTION_RANKS, MAX_FACTION_RANKS);
		}
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนสกินที่ใช้งานได้ของแฟคชั่น %s"EMBED_YELLOW" เป็น %d", ReturnPlayerName(playerid), factionData[id][fName], typeint);

		Log(adminactionlog, INFO, "%s: เปลี่ยนสกินสูงสุดของ %s(%d) จาก %d เป็น %d", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fMaxSkins], typeint);

	    factionData[id][fMaxSkins] = typeint;
	    Faction_Save(id);
	}
	return Dialog_Show(playerid, FactionEdit_Skin, DIALOG_STYLE_LIST, "แก้ไข -> สกิน", "สกินที่ใช้ได้\t(%d/%d)\nไอดีสกิน\t", "แก้ไข", "กลับ", factionData[id][fMaxSkins], MAX_FACTION_SKINS);
}

Dialog:FactionEdit_SkinID(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "FactionEditID");
	if (response)
	{
		SetPVarInt(playerid, "FactionEditSlot", listitem);
		return Dialog_Show(playerid, FactionEdit_SetSkinID, DIALOG_STYLE_INPUT, "สกิน -> ไอดีสกิน", ""EMBED_WHITE"สกิน: "EMBED_YELLOW"%d "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\nกรุณาป้อนไอดีสกินใหม่ด้านล่างนี้:", "เปลี่ยน", "กลับ", factionSkins[id][listitem], listitem + 1);
	}
	return Dialog_Show(playerid, FactionEdit_Skin, DIALOG_STYLE_LIST, "แก้ไข -> สกิน", "สกินที่ใช้ได้\t(%d/%d)\nไอดีสกิน\t", "แก้ไข", "กลับ", factionData[id][fMaxSkins], MAX_FACTION_RANKS);
}

Dialog:FactionEdit_SetSkinID(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new skin_slot = GetPVarInt(playerid, "FactionEditSlot"), id = GetPVarInt(playerid, "FactionEditID"), skin_id = strval(inputtext);

	    if (isnull(inputtext))
			return Dialog_Show(playerid, FactionEdit_SetSkinID, DIALOG_STYLE_INPUT, "สกิน -> ไอดีสกิน", ""EMBED_WHITE"สกิน: "EMBED_YELLOW"%d "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\nกรุณาป้อนไอดีสกินใหม่ด้านล่างนี้:", "เปลี่ยน", "กลับ", factionSkins[id][skin_slot], skin_slot + 1);

		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนสกินที่ %d ของแฟคชั่น %s"EMBED_YELLOW" เป็น %d", ReturnPlayerName(playerid), skin_slot + 1, factionData[id][fName], skin_id);
		Log(adminactionlog, INFO, "%s: เปลี่ยนไอดีสกินของ %s(%d) สกินที่ %d จาก %d เป็น %d", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], skin_slot + 1, factionSkins[id][skin_slot], skin_id);
		factionSkins[id][skin_slot] = skin_id;
	    Faction_SaveSkin(id, skin_slot);
	}
	return Faction_EditMenu_SkinList(playerid);
}

Dialog:FactionEdit_VehMax(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "FactionEditID");
	if(response) {
		new typeint = strval(inputtext);
		if(typeint < 0) {
			return Dialog_Show(playerid, FactionEdit_VehMax, DIALOG_STYLE_INPUT, "แก้ไข -> พาหนะ", "ปัจจุบัน: %d\n\nกรอกจำนวนพาหนะสูงสุดในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ", factionData[id][fMaxVehicles]);
		}
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนจำนวนพาหนะสูงสุดของแฟคชั่น %s"EMBED_YELLOW" เป็น %s", ReturnPlayerName(playerid), factionData[id][fName], typeint);
		Log(adminactionlog, INFO, "%s: เปลี่ยนจำนวนพาหนะสูงสุดของ %s(%d) จาก %d เป็น %d", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fMaxVehicles], typeint);
	    factionData[id][fMaxVehicles] = typeint;
	    Faction_Save(id);
	}
	return Faction_EditMenu(playerid);
}

Dialog:FactionEdit_Spawn(playerid, response, listitem, inputtext[])
{
	if(response) {
		switch(listitem) {
			case 0: {
				return Dialog_Show(playerid, FactionEdit_SpawnConf, DIALOG_STYLE_MSGBOX, "แก้ไข -> ตั้งค่าจุดเกิด", "คุณแน่ใจหรือที่จะปรับจุดเกิดแฟคชั่นนี้มายังตำแหน่งปัจจุบันของคุณ", "ยืนยัน", "กลับ");
			}
			case 1: {
				new id = GetPVarInt(playerid, "FactionEditID");
				if(factionData[id][fSpawnX] != 0.0 && factionData[id][fSpawnY] != 0.0) {

					SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้ลบล้างจุดเกิดของแฟคชั่น %s", ReturnPlayerName(playerid), factionData[id][fName]);
					Log(adminactionlog, INFO, "%s: ลบจุดเกิดของ %s(%d) จาก %f,%f,%f (int:%d|world:%d)", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fSpawnX], factionData[id][fSpawnY], factionData[id][fSpawnZ], factionData[id][fSpawnInt], factionData[id][fSpawnWorld]);

					factionData[id][fSpawnX]=
					factionData[id][fSpawnY]=
					factionData[id][fSpawnZ]=
					factionData[id][fSpawnA]=0.0;

					factionData[id][fSpawnInt]=
					factionData[id][fSpawnWorld]=0;

					if (IsValidDynamicPickup(factionData[id][fSpawnPickup])) {
						DestroyDynamicPickup(factionData[id][fSpawnPickup]);
					}

					Faction_Save(id);
				}
				else {
					SendClientMessage(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"จุดเกิดของแฟคชั่นนี้ยังไม่ได้ถูกตั้งค่าจึงไม่สามารถลบล้างได้");
				}
			}
		}
	}
	return Faction_EditMenu(playerid);
}

Dialog:FactionEdit_SpawnConf(playerid, response, listitem, inputtext[])
{
	if(response) {
		new id = GetPVarInt(playerid, "FactionEditID");
		new Float:px, Float:py, Float:pz, Float:pa, pint = GetPlayerInterior(playerid), pworld = GetPlayerVirtualWorld(playerid);
		GetPlayerPos(playerid, px, py, pz);
		GetPlayerFacingAngle(playerid, pa);

		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนจุดเกิดของแฟคชั่น %s"EMBED_YELLOW" มายังตำแหน่งปัจจุบันของเขา", ReturnPlayerName(playerid), factionData[id][fName]);
		Log(adminactionlog, INFO, "%s: เปลี่ยนจุดเกิดของ %s(%d) จาก %f,%f,%f (int:%d|world:%d) เป็น %f,%f,%f (int:%d|world:%d)", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fSpawnX], factionData[id][fSpawnY], factionData[id][fSpawnZ], factionData[id][fSpawnInt], factionData[id][fSpawnWorld], px, py, pz, pint, pworld);

        factionData[id][fSpawnX]=px;
        factionData[id][fSpawnY]=py;
        factionData[id][fSpawnZ]=pz;
		factionData[id][fSpawnA]=pa;
        factionData[id][fSpawnInt]=pint;
        factionData[id][fSpawnWorld]=pworld;

		if (IsValidDynamicPickup(factionData[id][fSpawnPickup])) {
			DestroyDynamicPickup(factionData[id][fSpawnPickup]);
		}
		if (factionData[id][fType] == FACTION_TYPE_GANG) {
			factionData[id][fSpawnPickup] = CreateDynamicPickup(1550, 21, factionData[id][fSpawnX], factionData[id][fSpawnY], factionData[id][fSpawnZ], factionData[id][fSpawnWorld], factionData[id][fSpawnInt], -1);
			Streamer_SetIntData(STREAMER_TYPE_PICKUP, factionData[id][fSpawnPickup], E_STREAMER_EXTRA_ID, id);
		}

	   	Faction_Save(id);
	}
	return Dialog_Show(playerid, FactionEdit_Spawn, DIALOG_STYLE_LIST, "แก้ไข -> ตั้งค่าจุดเกิด", "ปรับจุดเกิด\nลบล้างจุดเกิด", "เลือก", "กลับ");
}

SendFactionTypeMessage(factiontype, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string
		#emit PUSH.C args

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		foreach (new i : Player) if (Faction_GetTypeID(playerData[i][pFaction]) == factiontype) {
		    SendClientMessage(i, color, string);
		}
		return 1;
	}
	foreach (new i : Player) if (Faction_GetTypeID(playerData[i][pFaction]) == factiontype) {
		SendClientMessage(i, color, str);
	}
	return 1;
}

SendFactionIDMessage(factionid, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string
		#emit PUSH.C args

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		foreach (new i : Player) if (playerData[i][pFaction] == factionid) {
		    SendClientMessage(i, color, string);
		}
		return 1;
	}
	foreach (new i : Player) if (playerData[i][pFaction] == factionid) {
		SendClientMessage(i, color, str);
	}
	return 1;
}

CMD:factionhelp(playerid) {

	SendClientMessage(playerid, COLOR_WHITE, "[FACTION] /factions, /(f)ac, /nofam, /invite, /uninvite, /leavefaction, /giverank, /editrankname, /suit, /park, /towcars");
	if (playerData[playerid][pFaction] != 0) {
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE) {
 		    SendClientMessage(playerid,COLOR_GREEN,"____________________ คำสั่งเจ้าหน้าที่ตำรวจ ____________________");
 		    SendClientMessage(playerid, COLOR_LIGHTCYAN, "[LSPD] /(gov)ernment (/d)epartments (/m)egaphone /duty /carsign /revoke");
			SendClientMessage(playerid, COLOR_LIGHTCYAN, "[LSPD] /siren /rb(1-10) /rrb(1-10) /cone /disband (/p)ut(incar) /arrest, /ticket, /tickets");
            SendClientMessage(playerid, COLOR_LIGHTCYAN, "[LSPD] (/su)spect /badge /tazer1 /tazer2 /cuff /uncuff /drag /wanted /revoke /takedrug /rubberbullets ");
            SendClientMessage(playerid,COLOR_GREEN,"____________________ คำสั่งสําหรับหยิบอาวุธ ____________________");
            SendClientMessage(playerid, COLOR_LIGHTCYAN, "[LSPD] /cartakegun ( หยิบอุปกรณ์ปกติ ) /takeshotgun ( หยิบ shotgun ) /takem4 ( หยิบ m4 )");
		}
		else if (factionType == FACTION_TYPE_MEDIC) {
			SendClientMessage(playerid,COLOR_GREEN,"____________________ คำสั่งแพทย์ ____________________");
 		    SendClientMessage(playerid, COLOR_LIGHTCYAN, "[LSMD] /(gov)ernment (/d)epartments (/m)egaphone /duty /carsign");
			SendClientMessage(playerid, COLOR_LIGHTCYAN, "[LSMD] (/p)ut(incar) /cpr /heal");
		}
	}
    return 1;
}

CMD:leavefaction(playerid) {
 	if (playerData[playerid][pFaction] == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องเป็นสมาชิกของฝ่ายหรือกลุ่ม");

	SendFactionIDMessage(playerData[playerid][pFaction], COLOR_FACTION, "%s ได้ลาออกจากแฟคชั่น", ReturnRealName(playerid));

	playerData[playerid][pWear] = 0;
    playerData[playerid][pFaction] = 0;
    playerData[playerid][pFactionRank] = 0;
	SpawnPlayer(playerid);
	return 1;
}

CMD:factions(playerid, params[])
{
 	if (playerData[playerid][pFaction] == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องเป็นสมาชิกของฝ่ายหรือกลุ่ม");

	new factionid = Faction_GetID(playerData[playerid][pFaction]);

	if (factionid != -1) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "สมาชิก %s ที่ออนไลน์:", factionData[factionid][fName]);

		foreach (new i : Player) if (playerData[i][pFaction] == playerData[playerid][pFaction]) {
			SendClientMessageEx(playerid, COLOR_GRAD2, "(ID: %03d) {%06x} %s %s", i, factionData[factionid][fColor]  >>> 8, Faction_GetRankName(factionid, playerData[i][pFactionRank]), ReturnRealName(i));
		}
	}
	return 1;
}


CMD:nofam(playerid, params[])
{
    new factionid = Faction_GetID(playerData[playerid][pFaction]);

 	if (factionid == -1)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องเป็นสมาชิกของฝ่ายหรือกลุ่ม");

    if(playerData[playerid][pFactionRank] > 4)
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

	if(!factionData[factionid][fChat])
	{
		factionData[factionid][fChat] = true;
 		SendFactionIDMessage(playerData[playerid][pFaction], COLOR_FACTION, "(( %s [%d] %s: ได้ปิดกั้นระบบแชทกลุ่ม ))", playerData[playerid][pFactionRank], Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
	}
	else
	{
		factionData[factionid][fChat] = false;
		SendFactionIDMessage(playerData[playerid][pFaction], COLOR_FACTION, "(( %s [%d] %s: ได้เปิดใช้งานระบบแชทกลุ่ม ))", playerData[playerid][pFactionRank], Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
	}
	return 1;
}

alias:fac("f");
CMD:fac(playerid, params[])
{

 	if (playerData[playerid][pFaction] == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องเป็นสมาชิกของฝ่ายหรือกลุ่ม");

    new factionid = Faction_GetID(playerData[playerid][pFaction]);

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /(f)ac [ข้อความ]");

	if (factionData[factionid][fChat])
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "แชทกลุ่มถูกปิดกั้น");

    if (BitFlag_Get(gPlayerBitFlag[playerid], TOGGLE_FACTION))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องเปิดการใช้งานแชทของฝ่ายหรือกลุ่มก่อน");

	SendFactionIDMessage(playerData[playerid][pFaction], COLOR_FACTION, "(( [%d] %s %s: %s ))", playerData[playerid][pFactionRank], Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid), params);
	return 1;
}

alias:admin("a");
flags:admin(CMD_ADM_1);
CMD:admin(playerid, params[])
{
	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /(a)dmin [ข้อความ]");

	SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, "{ChatAdmin  [%d] {%d} %s : %s }", playerid,playerData[playerid][pAdmin],ReturnRealName(playerid), params);
	return 1;
}
CMD:invite(playerid, params[])
{
	new
	    targetid;

	if (playerData[playerid][pFaction] == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องเป็นสมาชิกของฝ่ายหรือกลุ่ม");

	//new id = Faction_GetID(playerData[playerid][pFaction]);
	if (playerData[playerid][pFactionRank] > 4)
	    return SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณไม่สามารถใช้คำสั่งนี้ได้!");

	if (sscanf(params, "u", targetid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /invite [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (playerData[targetid][pFaction] == playerData[playerid][pFaction])
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นเป็นส่วนหนึ่งของฝ่ายหรือกลุ่มคุณแล้ว");

    if (playerData[targetid][pFaction] != 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นเป็นส่วนหนึ่งของฝ่ายหรือกลุ่มอื่นอยู่แล้ว");

	SetPVarInt(targetid, "OfferID", playerid);
	SetPVarInt(targetid, "OfferFactionID", playerData[playerid][pFaction]);

	new factionid = Faction_GetID(playerData[playerid][pFaction]);
    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "   คุณได้ส่งคำร้องถึง %s ให้เข้าร่วม \"%s\"", ReturnRealName(targetid), Faction_GetName(factionid));
    SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "   %s ได้เสนอให้คุณเข้าร่วม \"%s\" (ใช้ \"/accept invite\")", ReturnRealName(playerid), Faction_GetName(factionid));

	return 1;
}

CMD:uninvite(playerid, params[])
{
	new
	    targetid;

	if (playerData[playerid][pFaction] == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องเป็นสมาชิกของฝ่ายหรือกลุ่ม");

	if (playerData[playerid][pFactionRank] > 3)
	    return SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณไม่สามารถใช้คำสั่งนี้ได้!");

	if (sscanf(params, "u", targetid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /uninvite [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(targetid == INVALID_PLAYER_ID) {
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");
	}

	if (playerData[targetid][pFaction] != playerData[playerid][pFaction])
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้เป็นส่วนหนึ่งของฝ่ายหรือกลุ่มเดียวกับคุณ");

	new factionid = Faction_GetID(playerData[playerid][pFaction]);

    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "   คุณได้ลบ %s ออกจาก \"%s\"", ReturnRealName(targetid), Faction_GetName(factionid));
    SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "   %s ได้ลบคุณออกจากฝ่ายหรือกลุ่ม \"%s\"", ReturnRealName(playerid), Faction_GetName(factionid));

	playerData[targetid][pWear] = 0;
    playerData[targetid][pFaction] = 0;
    playerData[targetid][pFactionRank] = 0;
	SpawnPlayer(targetid);
	return 1;
}

CMD:giverank(playerid, params[])
{
    new
	    targetid,
		rankid;

	if (playerData[playerid][pFaction] == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องเป็นสมาชิกของฝ่ายหรือกลุ่ม");

	if (playerData[playerid][pFactionRank] > 3)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถใช้คำสั่งนี้ได้!");

	new factionid = Faction_GetID(playerData[playerid][pFaction]);

	if (sscanf(params, "ud", targetid, rankid))
	    return SendClientMessageEx(playerid, COLOR_GRAD1, "การใช้: /giverank [ไอดีผู้เล่น/ชื่อบางส่วน] [ยศ (1-%d)]", factionData[factionid][fMaxRanks]);

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (targetid == playerid)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถปรับยศตัวเองได้");

	if (playerData[targetid][pFaction] != playerData[playerid][pFaction])
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้เป็นส่วนหนึ่งของฝ่ายหรือกลุ่มเดียวกับคุณ");

	if (rankid < 0 || rankid > factionData[factionid][fMaxRanks])
	    return SendClientMessageEx(playerid, COLOR_GRAD1, "   ยศที่ระบุไม่ถูกต้อง ยศต้องอยู่ระหว่าง 1 ถึง %d", factionData[factionid][fMaxRanks]);

	if(playerData[targetid][pFactionRank] >= rankid)
	{
	    playerData[targetid][pFactionRank] = rankid;
	    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "   คุณได้เลื่อนตำแหน่ง %s เป็น %s (%d)", ReturnRealName(targetid), Faction_GetRankName(factionid, rankid), rankid);
	    SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "   %s ได้เลื่อนตำแหน่งคุณเป็น %s (%d)", ReturnRealName(playerid), Faction_GetRankName(factionid, rankid), rankid);
	}
	else
	{
	    playerData[targetid][pFactionRank] = rankid;
	    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "   คุณได้ลดตำแหน่ง %s เป็น %s (%d)", ReturnRealName(targetid), Faction_GetRankName(factionid, rankid), rankid);
	    SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "   %s ได้ลดตำแหน่งคุณเป็น %s (%d)", ReturnRealName(playerid), Faction_GetRankName(factionid, rankid), rankid);
	}

	return 1;
}


CMD:editrankname(playerid, params[])
{
	if (playerData[playerid][pFaction] == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องเป็นสมาชิกของฝ่ายหรือกลุ่ม");

	if (playerData[playerid][pFactionRank] > 2)
	    return SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณไม่ได้เป็นผู้นำ!");

	SetPVarInt(playerid, "FactionEditID", Faction_GetID(playerData[playerid][pFaction]));
	Player_EditRanks(playerid);
	return 1;
}

Player_EditRanks(playerid) {
	new
		string[45 * MAX_FACTION_RANKS], factionid = GetPVarInt(playerid, "FactionEditID");

	for (new i = 0; i < factionData[factionid][fMaxRanks]; i ++)
		format(string, sizeof(string), "%sยศ %d: "EMBED_YELLOW"%s\n", string, i + 1, factionRanks[factionid][i]);

	return Dialog_Show(playerid, PlayerEdit_RankName, DIALOG_STYLE_LIST, "ยศ -> ชื่อยศ", string, "แก้ไข", "กลับ");
}

Dialog:PlayerEdit_RankName(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "FactionEditID");
	if (response)
	{
		SetPVarInt(playerid, "FactionEditSlot", listitem);
		return Dialog_Show(playerid, PlayerEdit_SetRankName, DIALOG_STYLE_INPUT, "ยศ -> ชื่อยศ", ""EMBED_WHITE"ยศ: "EMBED_YELLOW"%s "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\nกรุณาป้อนชื่อยศใหม่ด้านล่างนี้:", "เปลี่ยน", "กลับ", factionRanks[id][listitem], listitem + 1);
	}
	else {
		DeletePVar(playerid, "FactionEditID");
	}
	return 1;
}

Dialog:PlayerEdit_SetRankName(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new rank_slot = GetPVarInt(playerid, "FactionEditSlot"), id = GetPVarInt(playerid, "FactionEditID");

	    if (isnull(inputtext))
			return Dialog_Show(playerid, PlayerEdit_SetRankName, DIALOG_STYLE_INPUT, "ยศ -> ชื่อยศ", ""EMBED_WHITE"ยศ: "EMBED_YELLOW"%s "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\nกรุณาป้อนชื่อยศใหม่ด้านล่างนี้:", "เปลี่ยน", "กลับ", factionRanks[id][rank_slot], rank_slot + 1);

	    if (strlen(inputtext) < 1 || strlen(inputtext) > 20)
	        return Dialog_Show(playerid, PlayerEdit_SetRankName, DIALOG_STYLE_INPUT, "ยศ -> ชื่อยศ", ""EMBED_WHITE"ยศ: "EMBED_YELLOW"%s "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n"EMBED_LIGHTRED"ข้อผิดพลาด"EMBED_WHITE": ความยาวของชื่อต้องไม่ต่ำกว่า "EMBED_ORANGE"1"EMBED_WHITE" หรือมากกว่า "EMBED_ORANGE"20"EMBED_WHITE"\n\nกรุณาป้อนชื่อยศใหม่ด้านล่างนี้:", "เปลี่ยน", "กลับ", factionRanks[id][rank_slot], rank_slot + 1);

		// SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนชื่อยศที่ %d ของแฟคชั่น %s"EMBED_YELLOW" เป็น %s", ReturnPlayerName(playerid), rank_slot + 1, factionData[id][fName], inputtext);
		Log(adminactionlog, INFO, "%s: เปลี่ยนชื่อยศของ %s(%d) ยศที่ %d จาก %s เป็น %s", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], rank_slot + 1, factionRanks[id][rank_slot], inputtext);
		format(factionRanks[id][rank_slot], 20, inputtext);
	    Faction_SaveRank(id, rank_slot);
	}
	return Player_EditRanks(playerid);
}

CMD:suit(playerid) {
	new id = Faction_GetID(playerData[playerid][pFaction]);
	if (id != -1) {

		if(!IsPlayerInRangeOfPoint(playerid, 5.0, factionData[id][fSpawnX],factionData[id][fSpawnY],factionData[id][fSpawnZ]))
			return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้อยู่ที่จุดเกิดของแฟคชั่น");

		if (GetPVarType(playerid, "SkinSelection"))
			return SendClientMessage(playerid, COLOR_GRAD1, "   คุณกำลังเลือกตัวละครอยู่...");

		// new Float:pX, Float:pY, Float:pZ;
		GetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
		GetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
		// new Float:cX, Float:cY;
		GetXYInFrontOfPlayer(playerid,skinChangPosX[playerid], skinChangPosY[playerid], 3.5);
		// SetPlayerCameraPos(playerid, skinChangPosX[playerid], skinChangPosY[playerid], playerData[playerid][pPosZ] + 0.8);
		// SetPlayerCameraLookAt(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ] + 0.2);

		// TogglePlayerControllable(playerid, false);
		SetPlayerSkin(playerid, playerData[playerid][pModel]);

		ResyncSkin(playerid);
		TogglePlayerControllable(playerid, false);
		SetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
		SetPlayerCameraPos(playerid, skinChangPosX[playerid], skinChangPosY[playerid], playerData[playerid][pPosZ] + 0.8);
		SetPlayerCameraLookAt(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ] + 0.2);

		SendClientMessage(playerid, COLOR_GRAD1, "* กดปุ่ม "EMBED_YELLOW"NUM4"EMBED_GRAD1" หรือ "EMBED_YELLOW"NUM6"EMBED_GRAD1" เพื่อเปลี่ยนตัวละครเป็นตัวถัดไป");
		SendClientMessage(playerid, COLOR_GRAD1, "* ถ้าคุณต้องการใช้สกินตัวละครนั้นให้กดปุ่ม "EMBED_YELLOW"Y"EMBED_GRAD1" และหรือ "EMBED_YELLOW"N"EMBED_GRAD1" เพื่อยกเลิก");
		SendClientMessage(playerid, COLOR_GRAD2, "คำแนะนำ: คุณสามารถพิมพ์ <, >, Y, N แทนการกดปุ่มได้");

		SetPVarInt(playerid, "SkinSelection", -1);
	}
	else {
		SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้เป็นส่วนหนึ่งของแฟคชั่นใด ๆ");
	}
	return 1;
}

hook OnPlayerText(playerid, const text[]) {
	if (GetPVarType(playerid, "SkinSelection")) {

		if (isequal(text, ">", true)) {
			new id = Faction_GetID(playerData[playerid][pFaction]);
			if (id != -1) {
				new skinid = GetPVarInt(playerid, "SkinSelection"), change = skinid;
				Faction_GetNextSkin(id, change);
				if (change != -1 && skinid != change) {
					GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Faction skin~n~(ID:%d)", factionSkins[id][change]), 8000, 3);
					SetPlayerSkin(playerid, factionSkins[id][change]);
				}
				else {
					GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Base skin~n~(ID:%d)", playerData[playerid][pModel]), 8000, 3);
					SetPlayerSkin(playerid, playerData[playerid][pModel]);
				}
				SetPVarInt(playerid, "SkinSelection", change);
				ResyncSkin(playerid);
				TogglePlayerControllable(playerid, false);
				SetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
				SetPlayerCameraPos(playerid, skinChangPosX[playerid], skinChangPosY[playerid], playerData[playerid][pPosZ] + 0.8);
				SetPlayerCameraLookAt(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ] + 0.2);
			}
		}
		else if (isequal(text, "<", true)) {
			new id = Faction_GetID(playerData[playerid][pFaction]);
			if (id != -1) {
				new skinid = GetPVarInt(playerid, "SkinSelection"), change = skinid;
				Faction_PreviousSkin(id, change);
				if (change != -1 && skinid != change) {
					GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Faction skin~n~(ID:%d)", factionSkins[id][change]), 8000, 3);
					SetPlayerSkin(playerid, factionSkins[id][change]);
				}
				else {
					GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Base skin~n~(ID:%d)", playerData[playerid][pModel]), 8000, 3);
					SetPlayerSkin(playerid, playerData[playerid][pModel]);
				}
				SetPVarInt(playerid, "SkinSelection", change);
				ResyncSkin(playerid);
				TogglePlayerControllable(playerid, false);
				SetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
				SetPlayerCameraPos(playerid, skinChangPosX[playerid], skinChangPosY[playerid], playerData[playerid][pPosZ] + 0.8);
				SetPlayerCameraLookAt(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ] + 0.2);
			}		
		}
		else if (isequal(text, "Y", true)) {
			playerData[playerid][pWear] = GetPlayerSkin(playerid);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);
			DeletePVar(playerid, "SkinSelection");
			// ResyncSkin(playerid);
			GameTextForPlayer(playerid, "~g~UPDATED YOUR SKIN!", 2500, 4);
		}
		else if (isequal(text, "N", true)) {
			SetPlayerSkin(playerid, playerData[playerid][pWear] ? playerData[playerid][pWear] : playerData[playerid][pModel]);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);
			DeletePVar(playerid, "SkinSelection");
			ResyncSkin(playerid);
			GameTextForPlayer(playerid, "", 100, 3);
		}
		return -1;
	}
	return 0;
}
 
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) { 
	if (GetPVarType(playerid, "SkinSelection")) {
		if (PRESSED(KEY_ANALOG_LEFT)) {
			new id = Faction_GetID(playerData[playerid][pFaction]);
			if (id != -1) {
				new skinid = GetPVarInt(playerid, "SkinSelection"), change = skinid;
				Faction_PreviousSkin(id, change);
				if (change != -1 && skinid != change) {
					GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Faction skin~n~(ID:%d)", factionSkins[id][change]), 8000, 3);
					SetPlayerSkin(playerid, factionSkins[id][change]);
				}
				else {
					GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Base skin~n~(ID:%d)", playerData[playerid][pModel]), 8000, 3);
					SetPlayerSkin(playerid, playerData[playerid][pModel]);
				}
				SetPVarInt(playerid, "SkinSelection", change);
				ResyncSkin(playerid);
				TogglePlayerControllable(playerid, false);
				SetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
				SetPlayerCameraPos(playerid, skinChangPosX[playerid], skinChangPosY[playerid], playerData[playerid][pPosZ] + 0.8);
				SetPlayerCameraLookAt(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ] + 0.2);
			}
		}
		else if (PRESSED(KEY_ANALOG_RIGHT)) {
			new id = Faction_GetID(playerData[playerid][pFaction]);
			if (id != -1) {
				new skinid = GetPVarInt(playerid, "SkinSelection"), change = skinid;
				Faction_GetNextSkin(id, change);
				if (change != -1 && skinid != change) {
					GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Faction skin~n~(ID:%d)", factionSkins[id][change]), 8000, 3);
					SetPlayerSkin(playerid, factionSkins[id][change]);
				}
				else {
					GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Base skin~n~(ID:%d)", playerData[playerid][pModel]), 8000, 3);
					SetPlayerSkin(playerid, playerData[playerid][pModel]);
				}
				SetPVarInt(playerid, "SkinSelection", change);
				TogglePlayerControllable(playerid, false);
				SetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
				SetPlayerCameraPos(playerid, skinChangPosX[playerid], skinChangPosY[playerid], playerData[playerid][pPosZ] + 0.8);
				SetPlayerCameraLookAt(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ] + 0.2);
			}
		}
		else if (RELEASED(KEY_YES)) {
			playerData[playerid][pWear] = GetPlayerSkin(playerid);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);
			DeletePVar(playerid, "SkinSelection");
			//ResyncSkin(playerid);
			GameTextForPlayer(playerid, "~g~UPDATED YOUR SKIN!", 2500, 4);
		}
		else if (RELEASED(KEY_NO)) {
			SetPlayerSkin(playerid, playerData[playerid][pWear] ? playerData[playerid][pWear] : playerData[playerid][pModel]);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);
			DeletePVar(playerid, "SkinSelection");
			ResyncSkin(playerid);
			GameTextForPlayer(playerid, "", 100, 3);
		}
	}
	return 1;
}

Faction_GetNextSkin(factionid, &current) {
	if (current+1 >= factionData[factionid][fMaxSkins]) {
		current = -1;
		return 1;
	}
	for (new i = current+1; i < MAX_FACTION_SKINS; i ++)
	{
		if(factionSkins[factionid][i]) {
			current = i;
			break;
		}
	}
	return 1;
}

Faction_PreviousSkin(factionid, &current) {
	if (current-1 == -1) {
		current = -1;
		return 1;
	}
	else if (current-1 == -2) {
		current = factionData[factionid][fMaxSkins] - 1;
		return 1;
	}
	for (new i = current-1; i >= 0; i --)
	{
		if(factionSkins[factionid][i]) {
			current = i;
			break;
		}
	}
	return 1;
}


SetPlayerFactionSpawn(playerid, factionid) {
	new id = Faction_GetID(factionid);
	if(id != -1 && Iter_Contains(Iter_Faction, id) && factionData[id][fSpawnX] != 0.0 && factionData[id][fSpawnY] != 0.0) {
		SetPlayerPos(playerid, factionData[id][fSpawnX], factionData[id][fSpawnY], factionData[id][fSpawnZ]);
		SetPlayerFacingAngle(playerid, factionData[id][fSpawnA]);
		SetPlayerInterior(playerid, factionData[id][fSpawnInt]);
		SetPlayerVirtualWorld(playerid, factionData[id][fSpawnWorld]);
	}
	else {
		Main_SetPlayerDefaultSpawn(playerid);
	}
}

SetPlayerToTeamColor(playerid) {
	new id = Faction_GetID(playerData[playerid][pFaction]);
	if(id != -1 && Iter_Contains(Iter_Faction, id)) {

		new r, g, b, a;
		HexToRGBA(factionData[id][fColor], r, g, b, a);
		SetPlayerColor(playerid, RGBAToHex(r, g, b, 0x00));
	}
	else {
		SetPlayerColor(playerid, PLAYER_COLOR_WHITE);
	}
	// RemoveMarkers(playerid);
	return 1;
}

Faction_GetTurfColor(factionid) {
	if(Iter_Contains(Iter_Faction, factionid)) {
		new r, g, b, a;
		HexToRGBA(factionData[factionid][fColor], r, g, b, a);
		return RGBAToHex(r, g, b, 0x80);
	}
	return 0xFFFFFF50;
}

stock RGBAToHex(r, g, b, a) //By Betamaster
{
    return (r<<24 | g<<16 | b<<8 | a);
}

stock HexToRGBA(colour, &r, &g, &b, &a) //By Betamaster
{
    r = (colour >> 24) & 0xFF;
    g = (colour >> 16) & 0xFF;
    b = (colour >> 8) & 0xFF;
    a = colour & 0xFF;
}
CMD:helpup(playerid, params[])
{
	//new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);

	//if (factionType != FACTION_TYPE_MEDIC)
	//	return SendClientMessage(playerid, COLOR_LIGHTRED,"สำหรับหน่วยงานแพทย์เท่านั้น");

	new targetid;
	if (sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /helpup [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if (targetid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, targetid, 10.0))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "ผู้เล่นนั้นตัดการเชื่อมต่อหรือไม่ได้อยู่ใกล้คุณ");

	if (targetid == playerid)
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถดำเนินการตัวเองได้");

	if (!gIsInjuredMode{targetid} || gIsDeathMode{targetid})
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "ผู้เล่นนั้นไม่ได้รับบาดเจ็บหรือผู้เล่นนั้นตายแล้ว");

	Damage_Reset(targetid);
	gIsDeathMode{targetid}=true;
	gInjuredTime[targetid]=0;
	gIsInjuredMode{targetid}=false;
	ClearAnimations(targetid);
	TogglePlayerControllable(targetid, true);

	ApplyAnimation(playerid,"MEDIC","CPR",4.1, 0, 1, 1, 0, 1, 1);
	//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ทำการรักษาและฟื้นฟูร่างกายให้กับ %s", ReturnRealName(playerid), ReturnRealName(targetid));
	return 1;
}

CMD:cpr(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);

	if (factionType != FACTION_TYPE_MEDIC) 
		return SendClientMessage(playerid, COLOR_LIGHTRED,"สำหรับหน่วยงานแพทย์เท่านั้น");

	new targetid;
	if (sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /cpr [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if (targetid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, targetid, 10.0))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "ผู้เล่นนั้นตัดการเชื่อมต่อหรือไม่ได้อยู่ใกล้คุณ");

	if (targetid == playerid)
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถดำเนินการตัวเองได้");

	if (!gIsInjuredMode{targetid} || gIsDeathMode{targetid})
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "ผู้เล่นนั้นไม่ได้รับบาดเจ็บหรือผู้เล่นนั้นตายแล้ว");

	Damage_Reset(targetid);
	gIsDeathMode{targetid}=false;
	gInjuredTime[targetid]=0;
	gIsInjuredMode{targetid}=false;
	ClearAnimations(targetid);
	TogglePlayerControllable(targetid, true);

	ApplyAnimation(playerid,"MEDIC","CPR",4.1, 0, 1, 1, 0, 1, 1);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ทำการรักษาและฟื้นฟูร่างกายให้กับ %s", ReturnRealName(playerid), ReturnRealName(targetid));
	return 1;
}

CMD:heal(playerid, params[])
{
	new id, factionType = Faction_GetTypeID(playerData[playerid][pFaction]);

	if (factionType != FACTION_TYPE_MEDIC) 
		return SendClientMessage(playerid, COLOR_LIGHTRED,"สำหรับหน่วยงานแพทย์เท่านั้น");

	if(sscanf(params,"u", id)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /heal [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(id == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if(id == playerid)
		return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่สามารถรักษาตัวเองได้");

	if (!IsPlayerNearPlayer(playerid, id, 3.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

	Damage_Reset(id);
	gIsDeathMode{id}=false;
	gInjuredTime[id]=0;
	gIsInjuredMode{id}=false;
	
	SetPlayerHealthEx(id, 100.0 + playerData[id][pSHealth]);

	SendClientMessage(playerid, COLOR_YELLOW2, "INFO: ผู้เล่นนั้นได้รับค่า HP เต็มจำนวนสูงสุดของเขา");
	//SendClientMessage(playerid, COLOR_GRAD1, "คุณได้รับเงิน $500 จากผู้อำนวยการแพทย์, เนื่องจากคุณได้ช่วยชีวิตคนไว้");

	//GivePlayerMoneyEx(playerid, 500);

	return 1;
}

alias:government("gov");
CMD:government(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);

	if (factionType == 0 || factionType == FACTION_TYPE_GANG) 
		return SendClientMessage(playerid, COLOR_LIGHTRED,"   คุณต้องเป็นสมาชิกของฝ่ายหรือกลุ่ม");

    if(playerData[playerid][pFactionRank] > 2)
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /(gov)ernment [ข้อความ]");

	new factionid = Faction_GetID(playerData[playerid][pFaction]);
	SendClientMessageToAllEx(COLOR_WHITE, "{%06x}------ ข่าวสารจาก (%s) ------", factionData[factionid][fColor] >>> 8, factionData[factionid][fName]);
	SendClientMessageToAllEx(COLOR_WHITE, "*[HQ] %s: %s", ReturnRealName(playerid), params);
	SendClientMessageToAllEx(COLOR_WHITE, "{%06x}------ ข่าวสารจาก (%s) ------", factionData[factionid][fColor] >>> 8, factionData[factionid][fName]);
	return 1;
}

alias:departments("d");
CMD:departments(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	printf("%d", factionType);
	if (factionType != FACTION_TYPE_POLICE && factionType != FACTION_TYPE_MEDIC && factionType != FACTION_TYPE_GOV)
	    return SendClientMessage(playerid, COLOR_GRAD2,"   คุณไม่ใช่ส่วนหนึ่งของทีม !");

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: (/d)epartments [ข้อความสำหรับคุยนอกแผนก]");

	new fid = Faction_GetID(playerData[playerid][pFaction]);

	foreach(new i : Iter_Faction) {
		if (factionData[i][fType] == FACTION_TYPE_POLICE  || factionData[i][fType] == FACTION_TYPE_MEDIC || factionData[i][fType] == FACTION_TYPE_GOV) {
			SendFactionIDMessage(factionData[i][fID], TEAM_CYAN_COLOR, "** [%s] %s %s: %s **", factionData[fid][fShortName], Faction_GetRankName(fid, playerData[playerid][pFactionRank]), ReturnRealName(playerid), params);
		}
	}
	return 1;
}

CMD:carsign(playerid,params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && factionType != FACTION_TYPE_MEDIC)
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่เท่านั้น !");

	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid) && Vehicle_IsFaction(vehicleid, playerData[playerid][pFaction]))
	{
		if(isnull(params)) 
			return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /carsign [ข้อความ]");

		if(!IsValidDynamic3DTextLabel(vehicleData[vehicleid][vehSignText]))
	    {
			vehicleData[vehicleid][vehSignText] = Create3DTextLabel(params, 0xFFFFFFFF, 0.0, 0.0, 0.0, 50.0, 0, 1);
			Attach3DTextLabelToVehicle(vehicleData[vehicleid][vehSignText], vehicleid, -0.7, -1.9, -0.3);

	     	SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: /remove_carsign - "EMBED_WHITE" หากใช้งานเสร็จ");
		}
	} else SendClientMessage(playerid, COLOR_RED, "คุณต้องอยู่ในยานพาหนะของหน่วยงาน");

	return 1;
}

CMD:remove_carsign(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && factionType != FACTION_TYPE_MEDIC)
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่เท่านั้น !");

	new vehicleid = GetPlayerVehicleID(playerid);
	if (IsPlayerInAnyVehicle(playerid)) {
		if(IsValidDynamic3DTextLabel(vehicleData[vehicleid][vehSignText]))
		{
			Delete3DTextLabel(vehicleData[vehicleid][vehSignText]);
		} else SendClientMessage(playerid, COLOR_RED, "คุณไม่มีสัญญาณเรียกขานบนยานพาหนะของคุณ");
	} else SendClientMessage(playerid, COLOR_RED, "คุณต้องอยู่ในยานพาหนะของหน่วยงาน");

	return 1;
}

alias:suspect("su");
CMD:suspect(playerid, params[])
{
	new userid, reason[128], factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่ตำรวจเท่านั้น !");

	if (sscanf(params, "u[128]", userid, reason))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: /suspect [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GREY, "   ผู้เล่นนั้นไม่ได้ Online !");

    if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_GREY, "   คุณไม่สามารถยิง tezer ใส่ตัวเองได้!");

	if (!IsPlayerNearPlayer(playerid, userid, 8.0))
	    return SendClientMessage(playerid, COLOR_GREY, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ !");


	SetPlayerCriminal(userid, playerid, reason);

    return 1;
}

CMD:badge(playerid, params[])
{
	if(!playerData[playerid][pFaction])
		return SendClientMessage(playerid, COLOR_GREY, "คุณไม่ได้เป็นส่วนหนึ่งของแฟคชั่นใด ๆ");
		
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType == FACTION_TYPE_NONE || factionType == FACTION_TYPE_GANG)
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่เท่านั้น !");
		
	new playerb, factionid = Faction_GetID(playerData[playerid][pFaction]);
	
	if(sscanf(params, "u", playerb))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: /badge [ไอดีผู้เล่น/ส่วนหนึ่งของชื่อ]"); 
		
	if(!IsPlayerConnected(playerb))
		return SendClientMessage(playerid, COLOR_GREY, "   ผู้เล่นที่คุณระบุไม่ได้เชื่อมต่อกับเซิร์ฟเวอร์");
		
	if(!IsPlayerNearPlayer(playerid, playerb, 5.0))
		return SendClientMessage(playerid, COLOR_GREY, "   คุณไม่ได้อยู่ใกล้ผู้เล่นคนนั้น");
		
	if(playerb == playerid)
		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s ดูไปที่ตราของเขา", ReturnRealName(playerid));
	
	else SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s แสดงตราของเขาให้กับ %s", ReturnRealName(playerid), ReturnRealName(playerb));
	
	SendClientMessage(playerb, COLOR_LIGHTBLUE, "______________________________________");
	
	SendClientMessageEx(playerb, COLOR_GRAD2, "  ชื่อ: %s", ReturnRealName(playerid));
	SendClientMessageEx(playerb, COLOR_GRAD2, "  ตำแหน่ง: %s", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]));
	SendClientMessageEx(playerb, COLOR_GRAD2, "  หน่วยงาน: %s", Faction_GetName(factionid));
	
	SendClientMessage(playerb, COLOR_LIGHTBLUE, "______________________________________");
	return 1;
}

CMD:tazer1(playerid, params[])
{
	new userid, factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่ตำรวจเท่านั้น !");

	if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: /tazer1 [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GREY, "   ผู้เล่นนั้นไม่ได้ Online !");

    if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_GREY, "   คุณไม่สามารถยิง tezer ใส่ตัวเองได้!");

	if (!IsPlayerNearPlayer(playerid, userid, 8.0))
	    return SendClientMessage(playerid, COLOR_GREY, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ !");

	if (GetPlayerState(userid) != PLAYER_STATE_ONFOOT)
	    return SendClientMessage(playerid, COLOR_GREY, "   ผู้เล่นนั้นต้องไม่อยู่บนยานพาหนะ");

    if (BitFlag_Get(gPlayerBitFlag[userid],IS_CUFFED))
        return SendClientMessage(playerid, COLOR_GREY, "   ผู้เล่นนั้นถูกยิงด้วย tezer แล้ว");

	new randtazer = random(100);
	switch(randtazer)
	{
		case 0..9:
		{
			Mobile_GameTextForPlayer(userid, sprintf("You failed to shoot Tazed", ReturnRealName(playerid)), 3000, 3);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้ยิง Tazer ใส่ %s แต่ล้มเหลว", ReturnRealName(playerid), ReturnRealName(userid));
		}
		default:
		{
			BitFlag_On(gPlayerBitFlag[userid],IS_CUFFED);

			TogglePlayerControllable(userid, false);

			ApplyAnimation(userid, "PED", "KO_skid_front", 3.0, 1, 0, 0, 0, 0); // Taking Cover
			SetPlayerDrunkLevel(playerid, 4000);
			Mobile_GameTextForPlayer(userid, sprintf("You've been ~r~Tazed~w~ by %s.", ReturnRealName(playerid)), 5000, 3);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้ยิง tazer ใส่ %s สำเร็จ", ReturnRealName(playerid), ReturnRealName(userid));
		}
	}

    return 1;
}

CMD:swat(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]),
        factionid = Faction_GetID(playerData[playerid][pFaction]);

	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่ตำรวจเท่านั้น !");

	if (IsPlayerInRangeOfPoint(playerid, 3.0, 261.8440, 109.7867, 1004.6172))
	{
		if (playerData[playerid][pOnDuty] == 0) // Duty
		{
			playerData[playerid][pOnDuty] = 1;
			//givePlayerValidWeapon(playerid, 3, 1);

			ResetWeapons(playerid);
			GivePlayerWeaponEx(playerid, 41, 5000);
			GivePlayerWeaponEx(playerid, 3, 1);
			GivePlayerWeaponEx(playerid, 24, 100);
			GivePlayerWeaponEx(playerid, 25, 100);
			GivePlayerWeaponEx(playerid, 31, 300);

			SetPlayerColor(playerid, 0x9189EF00);
			//SetPlayerToTeamColor(playerid);

			SetPlayerHealth(playerid, 100);
			SetPlayerArmour(playerid, 200);

			SetPlayerSkin(playerid, 285);
			
			SendFactionTypeMessage(FACTION_TYPE_POLICE, 0x9189EFFF, "** HQ: %s %s ได้เริ่มต้นการปฏิบัติหน้าที่ในขณะนี้! [S.W.A.T.] **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s หยิบตราและอาวุธจากล็อกเกอร์ของเขา", ReturnRealName(playerid));
			return 1;
		}
		else // Off Duty
		{
			playerData[playerid][pOnDuty] = 0;
			//validResetPlayerWeapons(playerid);

			ResetWeapons(playerid);
			SetPlayerWeapons(playerid);

			SetPlayerColor(playerid, PLAYER_COLOR_WHITE);

			SetPlayerHealth(playerid, 100);
			SetPlayerArmour(playerid, 0);
			
			SendFactionTypeMessage(FACTION_TYPE_POLICE, 0x9189EFFF, "** HQ: %s %s ได้ออกจากการปฏิบัติหน้าที่ในขณะนี้! [S.W.A.T] **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s เก็บตราและอาวุธเข้าล็อกเกอร์ของเขา", ReturnRealName(playerid));
			return 1;
		}
		//return 1;
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ในสำนักงานตำรวจ!");

    return 1;
}

CMD:aduty(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]),
        factionid = Faction_GetID(playerData[playerid][pFaction]);

	new type[12];

	if (factionType == FACTION_TYPE_MEDIC)
	{
		if (IsPlayerInRangeOfPoint(playerid, 3.0, 244.1459,190.3897,1008.1719))
		{
			if (playerData[playerid][pOnDuty] == 0) // Duty
			{
				playerData[playerid][pOnDuty] = 1;
				//givePlayerValidWeapon(playerid, 3, 1);

				ResetWeapons(playerid);
				GivePlayerWeaponEx(playerid, 42, 5000);

				SetPlayerColor(playerid, 0x-10066313);
				//SetPlayerToTeamColor(playerid);

				SetPlayerHealth(playerid, 100);
				SetPlayerArmour(playerid, 100);

				SendFactionTypeMessage(FACTION_TYPE_MEDIC, 0x8D8DFFFF, "** HQ: %s %s ได้เริ่มต้นการปฏิบัติหน้าที่ในขณะนี้! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s หยิบตราและอาวุธจากล็อกเกอร์ของเขา", ReturnRealName(playerid));
				return 1;
			}
			else // Off Duty
			{
				playerData[playerid][pOnDuty] = 0;
				//validResetPlayerWeapons(playerid);

				ResetWeapons(playerid);
				SetPlayerWeapons(playerid);

				SetPlayerColor(playerid, PLAYER_COLOR_WHITE);

				SetPlayerHealth(playerid, 100);
				SetPlayerArmour(playerid, 0);

				SendFactionTypeMessage(FACTION_TYPE_MEDIC, 0x8D8DFFFF, "** HQ: %s %s ได้ออกจากการปฏิบัติหน้าที่ในขณะนี้! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s เก็บตราและอาวุธเข้าล็อกเกอร์ของเขา", ReturnRealName(playerid));
                return 1;
			}
		}
	}

	if (factionType == FACTION_TYPE_POLICE)
	{
		if(sscanf(params,"s[12]", type))
			return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /duty [ไอดีรายการที่คุณต้องการ] (รายการ: 1.ปฏิบัติหน้าที่ในเครื่องแบบ, 2.ปฏิบัติหน้าที่นอกเครื่องแบบ)");

		if(!strcmp(type, "1", true))
		{
			if (IsPlayerInRangeOfPoint(playerid, 3.0, 244.1459,190.3897,1008.1719))
			{
				if (playerData[playerid][pOnDuty] == 0) // Duty
				{
					playerData[playerid][pOnDuty] = 1;
					//givePlayerValidWeapon(playerid, 3, 1);

					ResetWeapons(playerid);
					GivePlayerWeaponEx(playerid, 41, 5000);
					GivePlayerWeaponEx(playerid, 3, 1);
					GivePlayerWeaponEx(playerid, 24, 100);
					GivePlayerWeaponEx(playerid, 25, 100);

					SetPlayerColor(playerid, 0x9189EF00);
					//SetPlayerToTeamColor(playerid);

					SetPlayerHealth(playerid, 100);
					SetPlayerArmour(playerid, 100);

					SendFactionTypeMessage(FACTION_TYPE_POLICE, 0x9189EFFF, "** HQ: %s %s ได้เริ่มต้นการปฏิบัติหน้าที่ในขณะนี้! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s หยิบตราและอาวุธจากล็อกเกอร์ของเขา", ReturnRealName(playerid));
					return 1;
				}
				else // Off Duty
				{
					playerData[playerid][pOnDuty] = 0;
					//validResetPlayerWeapons(playerid);

					ResetWeapons(playerid);
					SetPlayerWeapons(playerid);

					SetPlayerColor(playerid, PLAYER_COLOR_WHITE);

					SetPlayerHealth(playerid, 100);
					SetPlayerArmour(playerid, 0);

					SendFactionTypeMessage(FACTION_TYPE_POLICE, 0x9189EFFF, "** HQ: %s %s ได้ออกจากการปฏิบัติหน้าที่ในขณะนี้! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s เก็บตราและอาวุธเข้าล็อกเกอร์ของเขา", ReturnRealName(playerid));
					return 1;
				}
				//return 1;
			}
			else return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ในสำนักงานตำรวจ!");
		}

		if(!strcmp(type, "2", true))
		{
			if (IsPlayerInRangeOfPoint(playerid, 3.0, 244.1459,190.3897,1008.1719))
			{
				if (playerData[playerid][pOnDuty] == 0) // Duty
				{
					playerData[playerid][pOnDuty] = 1;
					//givePlayerValidWeapon(playerid, 3, 1);

					ResetWeapons(playerid);
					GivePlayerWeaponEx(playerid, 41, 5000);
					GivePlayerWeaponEx(playerid, 3, 1);
					GivePlayerWeaponEx(playerid, 24, 100);
					GivePlayerWeaponEx(playerid, 25, 100);

					SetPlayerColor(playerid, PLAYER_COLOR_WHITE);
					//SetPlayerToTeamColor(playerid);

					SetPlayerHealth(playerid, 100);
					//SetPlayerArmour(playerid, 100);

					SendFactionTypeMessage(FACTION_TYPE_POLICE, 0x9189EFFF, "** HQ: %s %s ได้เริ่มต้นการปฏิบัติหน้าที่ในขณะนี้! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s หยิบตราและอาวุธจากล็อกเกอร์ของเขา", ReturnRealName(playerid));
					return 1;
				}
				else // Off Duty
				{
					playerData[playerid][pOnDuty] = 0;
					//validResetPlayerWeapons(playerid);

					ResetWeapons(playerid);
					SetPlayerWeapons(playerid);

					SetPlayerColor(playerid, PLAYER_COLOR_WHITE);

					SetPlayerHealth(playerid, 100);
					SetPlayerArmour(playerid, 0);

					SendFactionTypeMessage(FACTION_TYPE_POLICE, 0x9189EFFF, "** HQ: %s %s ได้ออกจากการปฏิบัติหน้าที่ในขณะนี้! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s เก็บตราและอาวุธเข้าล็อกเกอร์ของเขา", ReturnRealName(playerid));
					return 1;
				}
				//return 1;


			}
			else return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ในสำนักงานตำรวจ!");
		}
	}

    return 1;
}
CMD:callsign(playerid, params[])
{

 	if (playerData[playerid][pFaction] == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องเป็นสมาชิกของฝ่ายหรือกลุ่ม");

    new factionid = Faction_GetID(playerData[playerid][pFaction]);

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /callsign [ข้อความ]");

   // if (BitFlag_Get(gPlayerBitFlag[playerid], TOGGLE_FACTION))
	//	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องเปิดการใช้งานแชทของฝ่ายหรือกลุ่มก่อน");

	SendFactionIDMessage(playerData[playerid][pFaction], 0x8D8DFFFF, "** HQ: %s %s is now under %s ))",Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid), params);
	//SendFactionTypeMessage(FACTION_TYPE_MEDIC, 0x8D8DFFFF, "** HQ: %s %s is now under %s **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
	return 1;
}

CMD:duty(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]),
        factionid = Faction_GetID(playerData[playerid][pFaction]);

	new type[12];

	if (factionType == FACTION_TYPE_MEDIC)
	{
		if (IsPlayerInRangeOfPoint(playerid, 3.0, 1970.7809,1173.4547,-5.2087))
		{                                         
			if (playerData[playerid][pOnDuty] == 0) // Duty
			{
				playerData[playerid][pOnDuty] = 1;
				//givePlayerValidWeapon(playerid, 3, 1);

				ResetWeapons(playerid);
			//	GivePlayerWeaponEx(playerid, 42, 5000);

				SetPlayerColor(playerid, 0x-10066313);
				//SetPlayerToTeamColor(playerid);

				SetPlayerHealth(playerid, 100);
				SetPlayerArmour(playerid, 100);

				SendFactionTypeMessage(FACTION_TYPE_MEDIC, 0x8D8DFFFF, "** HQ: %s %s has gone on duty! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s หยิบตราและอาวุธจากล็อกเกอร์ของเขา", ReturnRealName(playerid));
				return 1;
			}
			else // Off Duty
			{
				playerData[playerid][pOnDuty] = 0;
				//validResetPlayerWeapons(playerid);

				ResetWeapons(playerid);
				SetPlayerWeapons(playerid);

				SetPlayerColor(playerid, PLAYER_COLOR_WHITE);

				SetPlayerHealth(playerid, 100);
				SetPlayerArmour(playerid, 0);

				SendFactionTypeMessage(FACTION_TYPE_MEDIC, 0x8D8DFFFF, "** HQ: %s %s has gone off duty! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s เก็บตราและอาวุธเข้าล็อกเกอร์ของเขา", ReturnRealName(playerid));
                return 1;
			}
		}
		else return SendClientMessage(playerid, COLOR_GRAD1, "คุณไมไม่ได้อยู่จุด duty");
	}

	if (factionType == FACTION_TYPE_POLICE)
	{
		if(sscanf(params,"s[12]", type))
			return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /duty [ไอดีรายการที่คุณต้องการ] (รายการ: 1.ปฏิบัติหน้าที่ในเครื่องแบบ, 2.ปฏิบัติหน้าที่นอกเครื่องแบบ)");

		if(!strcmp(type, "1", true))
		{
			if (IsPlayerInRangeOfPoint(playerid, 3.0, 1345.0021,29.6081,1019.1917))
			{
				if (playerData[playerid][pOnDuty] == 0) // Duty
				{
					playerData[playerid][pOnDuty] = 1;
					//givePlayerValidWeapon(playerid, 3, 1);

					ResetWeapons(playerid);
					GivePlayerWeaponEx(playerid, 41, 5000);
					GivePlayerWeaponEx(playerid, 3, 1);
					GivePlayerWeaponEx(playerid, 24, 100);
					//GivePlayerWeaponEx(playerid, 25, 100);

					SetPlayerColor(playerid, 0x9189EF00);
					//SetPlayerToTeamColor(playerid);

					SetPlayerHealth(playerid, 100);
					SetPlayerArmour(playerid, 100);

					SendFactionTypeMessage(FACTION_TYPE_POLICE, 0x9189EFFF, "** HQ: %s %s has gone on duty! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s หยิบตราและอาวุธจากล็อกเกอร์ของเขา", ReturnRealName(playerid));
					return 1;
				}
				else // Off Duty
				{
					playerData[playerid][pOnDuty] = 0;
					//validResetPlayerWeapons(playerid);

					ResetWeapons(playerid);
					SetPlayerWeapons(playerid);

					SetPlayerColor(playerid, PLAYER_COLOR_WHITE);

					SetPlayerHealth(playerid, 100);
					SetPlayerArmour(playerid, 0);

					SendFactionTypeMessage(FACTION_TYPE_POLICE, 0x9189EFFF, "** HQ: %s %s has gone off duty! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s เก็บตราและอาวุธเข้าล็อกเกอร์ของเขา", ReturnRealName(playerid));
					return 1;
				}
				//return 1;
			}
			else return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ในสำนักงานตำรวจ!");
		}

		if(!strcmp(type, "2", true))
		{
			if (IsPlayerInRangeOfPoint(playerid, 3.0, 261.8440, 109.7867, 1004.6172))
			{
				if (playerData[playerid][pOnDuty] == 0) // Duty
				{
					playerData[playerid][pOnDuty] = 1;
					//givePlayerValidWeapon(playerid, 3, 1);

					ResetWeapons(playerid);
					GivePlayerWeaponEx(playerid, 41, 5000);
					GivePlayerWeaponEx(playerid, 3, 1);
					GivePlayerWeaponEx(playerid, 24, 100);
				//	GivePlayerWeaponEx(playerid, 25, 100);

					SetPlayerColor(playerid, PLAYER_COLOR_WHITE);
					//SetPlayerToTeamColor(playerid);

					SetPlayerHealth(playerid, 100);
					//SetPlayerArmour(playerid, 100);

					SendFactionTypeMessage(FACTION_TYPE_POLICE, 0x9189EFFF, "** HQ: %s %s has gone on duty! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s หยิบตราและอาวุธจากล็อกเกอร์ของเขา", ReturnRealName(playerid));
					return 1;
				}
				else // Off Duty
				{
					playerData[playerid][pOnDuty] = 0;
					//validResetPlayerWeapons(playerid);

					ResetWeapons(playerid);
					SetPlayerWeapons(playerid);

					SetPlayerColor(playerid, PLAYER_COLOR_WHITE);

					SetPlayerHealth(playerid, 100);
					SetPlayerArmour(playerid, 0);

					SendFactionTypeMessage(FACTION_TYPE_POLICE, 0x9189EFFF, "** HQ: %s %s has gone off duty! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s เก็บตราและอาวุธเข้าล็อกเกอร์ของเขา", ReturnRealName(playerid));
					return 1;
				}
				//return 1;
				
			
			}
			else return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ในสำนักงานตำรวจ!");
		}
	}

    return 1;
}

CMD:nduty(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]),
        factionid = Faction_GetID(playerData[playerid][pFaction]);

	if (factionType == FACTION_TYPE_NEWS)
	{
		if (IsPlayerInRangeOfPoint(playerid, 3.0, 355.0871, 161.7024, 1019.9844))
		{
			if (playerData[playerid][pOnDuty] == 0) // Duty
			{
				playerData[playerid][pOnDuty] = 1;
				//givePlayerValidWeapon(playerid, 3, 1);
				
				ResetWeapons(playerid);
				GivePlayerWeaponEx(playerid, 43, 5000);
				//GivePlayerWeaponEx(playerid, 45, 1);

				SetPlayerColor(playerid, 0x00FFFFAA);
				//SetPlayerToTeamColor(playerid);

				SetPlayerHealth(playerid, 100);
				SetPlayerArmour(playerid, 100);

				SendFactionTypeMessage(FACTION_TYPE_NEWS, 0x8D8DFFFF, "** HQ: %s %s ได้เริ่มต้นการปฏิบัติหน้าที่ในขณะนี้! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s หยิบตราและกล้องจากล็อกเกอร์ของเขา", ReturnRealName(playerid));
				return 1;
			}
			else // Off Duty
			{
				playerData[playerid][pOnDuty] = 0;
				//validResetPlayerWeapons(playerid);

				ResetWeapons(playerid);
				SetPlayerWeapons(playerid);

				SetPlayerColor(playerid, PLAYER_COLOR_WHITE);

				SetPlayerHealth(playerid, 100);
				SetPlayerArmour(playerid, 0);

				SendFactionTypeMessage(FACTION_TYPE_NEWS, 0x8D8DFFFF, "** HQ: %s %s ได้ออกจากการปฏิบัติหน้าที่ในขณะนี้! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s เก็บตราและกล้องจากล็อกเกอร์ของเขา", ReturnRealName(playerid));
                return 1;
			}
		}

	}

    return 1;
}

CMD:untazer(playerid, params[])
{
	new userid, factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่ตำรวจเท่านั้น !");

	if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: /untezer [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GREY, "   ผู้เล่นนั้นไม่ได้ Online !");

    /*if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_GREY, "   คุณไม่สามารถยกเลิกการยิงตัวเองได้");*/

    if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendClientMessage(playerid, COLOR_GREY, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ !");

    if (!BitFlag_Get(gPlayerBitFlag[userid],IS_CUFFED))
        return SendClientMessage(playerid, COLOR_GREY, "   ผู้เล่นนั้นไม่ได้ถูกยิง tezer");

    BitFlag_Off(gPlayerBitFlag[userid],IS_CUFFED);
    //SetPlayerSpecialAction(userid, SPECIAL_ACTION_NONE);
    //RemovePlayerAttachedObject(userid, FREESLOT9);
	TogglePlayerControllable(userid, true);

	Mobile_GameTextForPlayer(userid, sprintf("You've been ~g~untazer~w~ by %s.", ReturnRealName(playerid)), 5000, 3);

	if(gPlayerDrag[userid] == playerid) {
		gPlayerDrag[userid] = INVALID_PLAYER_ID;
	}

    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ยกเลิกการยิง tazer แล้ว %s", ReturnRealName(playerid), ReturnRealName(userid));
	SetPlayerDrunkLevel(playerid, 0);
    return 1;
}
CMD:cuff(playerid, params[])
{
	new userid, factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่ตำรวจเท่านั้น !");

	if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: /cuff [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GREY, "   ผู้เล่นนั้นไม่ได้ Online !");

    if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_GREY, "   คุณไม่สามารถใส่กุญแจมือตัวเองได้!");

	if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendClientMessage(playerid, COLOR_GREY, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ !");

    /*if (!BitFlag_Get(gPlayerBitFlag[playerid], IS_TAZERED) && GetPlayerSpecialAction(userid) != SPECIAL_ACTION_HANDSUP && !IsPlayerIdle(userid))
	    return SendClientMessage(playerid, COLOR_GREY, "   ผู้เล่นนั้นต้องอยู่ในสถานะที่ไม่ได้ขัดขืน");*/

	if (GetPlayerState(userid) != PLAYER_STATE_ONFOOT)
	    return SendClientMessage(playerid, COLOR_GREY, "   ผู้เล่นนั้นต้องไม่อยู่บนยานพาหนะ");

    if (BitFlag_Get(gPlayerBitFlag[userid],IS_CUFFED))
        return SendClientMessage(playerid, COLOR_GREY, "   ผู้เล่นนั้นถูกใส่กุญแจมือแล้ว");

    BitFlag_On(gPlayerBitFlag[userid],IS_CUFFED);
    //SetPlayerSpecialAction(userid, SPECIAL_ACTION_CUFFED);
    //SetPlayerAttachedObject(userid, FREESLOT9, 19418, 6, -0.011000, 0.028000, -0.022000, -15.600012, -33.699977, -81.700035, 0.891999, 1.000000, 1.168000);

	TogglePlayerControllable(userid, false);
	//ApplyAnimation(userid, "ped", "cower", 3.0, 1, 0, 0, 0, 0); // Taking Cover

	Mobile_GameTextForPlayer(userid, sprintf("You've been ~r~cuffed~w~ by %s.", ReturnRealName(playerid)), 5000, 3);

    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้จับข้อมือคู่นั้นของ %s อย่างรัดกุมพร้อมใส่กุญแจมือ", ReturnRealName(playerid), ReturnRealName(userid));
    return 1;
}

CMD:uncuff(playerid, params[])
{
	new userid, factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่ตำรวจเท่านั้น !");

	if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: /uncuff [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GREY, "   ผู้เล่นนั้นไม่ได้ Online !");

    if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_GREY, "   คุณไม่สามารถปลดกุญแจมือตัวเองได้");

    if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendClientMessage(playerid, COLOR_GREY, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ !");

    if (!BitFlag_Get(gPlayerBitFlag[userid],IS_CUFFED))
        return SendClientMessage(playerid, COLOR_GREY, "   ผู้เล่นนั้นไม่ได้ถูกใส่กุญแจมือ");

    BitFlag_Off(gPlayerBitFlag[userid],IS_CUFFED);
    //SetPlayerSpecialAction(userid, SPECIAL_ACTION_NONE);
    //RemovePlayerAttachedObject(userid, FREESLOT9);
	TogglePlayerControllable(userid, true);

	Mobile_GameTextForPlayer(userid, sprintf("You've been ~g~uncuffed~w~ by %s.", ReturnRealName(playerid)), 5000, 3);

	if(gPlayerDrag[userid] == playerid) {
		gPlayerDrag[userid] = INVALID_PLAYER_ID;
	}

    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s แก้กุญแจมือให้กับข้อมือของ %s", ReturnRealName(playerid), ReturnRealName(userid));
    return 1;
}

alias:putincar("pincar");
CMD:putincar(playerid, params[])
{
	new
	    userid,
		seatid;

	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && factionType != FACTION_TYPE_MEDIC)
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่เท่านั้น !");

	if (sscanf(params, "u", userid))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: /putincar [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 10.0))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "ผู้เล่นนั้นตัดการเชื่อมต่อหรือไม่ได้อยู่ใกล้คุณ");

	if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถเคลื่อนย้ายตัวเองใส่รถได้");

	for(new i=0;i!=MAX_VEHICLES;i++) if (GetPlayerVehicleID(playerid) == i || IsPlayerNearBoot(playerid, i, 3.0))
	{
	    seatid = GetAvailableSeat(i, 2);

	    if (seatid == -1)
	        return SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่มีที่ว่างสำหรับผู้เล่นนี้");

		PutPlayerInVehicle(userid, i, seatid);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s เคลื่อนย้ายตัว %s ไว้บน %s", ReturnRealName(playerid), ReturnRealName(userid), g_arrVehicleNames[GetVehicleModel(i) - 400]);
		//TogglePlayerControllable(userid, true);
		return 1;
	}
	SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่ใกล้ท้ายหรือภายในยานพาหนะ");
	return 1;
}

alias:megaphone("m");
CMD:megaphone(playerid,params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid) && Vehicle_IsFaction(vehicleid, playerData[playerid][pFaction]))
	{
	 	if (isnull(params)) return SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: (/m)egaphone [แชท]");

		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE || factionType == FACTION_TYPE_MEDIC)
			SendNearbyMessage(playerid, 60.0, COLOR_YELLOW, "[ %s:o< %s ]", ReturnRealName(playerid), params);
		else
			SendClientMessage(playerid, COLOR_GRAD2, "   สำหรับเจ้าหน้าที่เท่านั้น!");
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณจะต้องอยู่ในรถลาดตระเวนของตำรวจ!");
    return 1;
}

CMD:drag(playerid, params[]) {

	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่ตำรวจเท่านั้น !");

	foreach(new i : Player) {
		if(gPlayerDrag[i] == playerid) {
			gPlayerDrag[i] = INVALID_PLAYER_ID;
			SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้หยุดลากตัว %s", ReturnRealName(i));
			return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s ได้หยุดลากตัว %s และ ปล่อยเขาให้เป็นอิสระ", ReturnRealName(playerid), ReturnRealName(i));
		}
	}

	new
		targetid;
		
	if(sscanf(params, "u", targetid))
		SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: /drag [ไอดีผู้เล่น/ชื่อบางส่วน] (ใช้อีกครั้งเพื่อหยุด)");

	else if(BitFlag_Get(gPlayerBitFlag[targetid], IS_CUFFED) || BitFlag_Get(gPlayerBitFlag[targetid], IS_TAZERED)) {
		if(IsPlayerNearPlayer(playerid, targetid, 2.5)) {
			if(!IsPlayerInAnyVehicle(targetid) && !IsPlayerInAnyVehicle(playerid)) {

				gPlayerDrag[targetid] = playerid;

				SendClientMessageEx(playerid, COLOR_WHITE, "คุณกำลังลากตัว %s", ReturnRealName(targetid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s ได้คว้าตัว %s และลากตัวเขา", ReturnRealName(playerid), ReturnRealName(targetid));
			}
			else SendClientMessage(playerid, COLOR_GREY, "ทั้งคุณและเขาจะไม่สามารถลากได้หากอยู่ภายในพาหนะ");
		}
		else SendClientMessage(playerid, COLOR_GREY, "ผู้เล่นนั้นอยู่ไกลเกินไป");
	}
	else SendClientMessage(playerid, COLOR_GREY, "ผู้เล่นจะนั้นจะถูกลากตัวได้โดยเขาจะต้องถูกใส่กุญแจมือหรือถูกช็อต");
	return 1;
}

CMD:wanted(playerid, params[]) {

	new str[1024];
	foreach(new i : Player) if(playerData[i][pWarrants] > 0) {
		format(str, sizeof(str), "%s\n%s(%d) | %d", str, ReturnRealName(i), i, playerData[i][pWarrants]);
	}
	Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "MDC: ผู้ต้องหา", str, "ปิด", "");
	return 1;
}

CMD:arrest(playerid, params[])
{
	new id, cell, time, fine;

	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่ตำรวจเท่านั้น !");

	// if(!playerData[playerid][pOnDuty]) return SendClientMessage(playerid, COLOR_GRAD1,"   คุณยังไม่ได้เริ่มปฏิบัติหน้าที่");

	if(IsPlayerInRangeOfPoint(playerid, 6.0, 227.4311,114.2517,999.0156) || IsPlayerInRangeOfPoint(playerid, 6.0, 227.2659,114.3330,999.0156) || IsPlayerInRangeOfPoint(playerid, 6.0, 190.7101,179.1334,1003)) { // LSPD
		if(sscanf(params,"uddd",id,cell,time,fine)) return SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: /arrest [ไอดีผู้เล่น/ชื่อบางส่วน] [ห้องขัง(1-4)] [เวลา(นาที)] [ค่าปรับ]");
		
		if(id == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

		if (id == playerid) return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถขังตัวเองได้");
		if (!IsPlayerNearPlayer(playerid, id, 5.0)) return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

		if(cell < 1 || cell > 5) return SendClientMessage(playerid, COLOR_GRAD2, "ห้องขังต้องไม่ต่ำกว่า 1 หรือมากกว่า 4");
		if(fine < 0 || fine > 500000) return SendClientMessage(playerid, COLOR_GRAD2, "ค่าปรับต้องไม่เกิน $500,000 หรือต่ำกว่า $0");
		if(time < 1 || time > 240) return SendClientMessage(playerid, COLOR_GRAD2, "เวลาต้องไม่มากกว่า 240 นาทีหรือต่ำกว่า 1 นาที");

		if(playerData[id][pJailed] == 2) return SendClientMessage(playerid, COLOR_LIGHTRED, "ผู้เล่นนั้นได้ถูกจับแล้ว");

	    BitFlag_Off(gPlayerBitFlag[id],IS_CUFFED);
	    //SetPlayerSpecialAction(id, SPECIAL_ACTION_NONE);
	    //RemovePlayerAttachedObject(id, FREESLOT9);
		GivePlayerMoneyEx(id, -fine);
		// FullResetPlayerWeapons(id);
		FullResetPlayerWeapons(id);
		playerData[id][pJailTime] = time * 60;
		playerData[id][pJailed] = 2;
		playerData[id][pArrested] += 1;
		PutPlayerInCell(id, cell);

		TurnOffPhone(id);

		playerData[id][pWarrants] = 0;
		SetPlayerWantedLevel(id, 0);
		ClearCrime(id);

		if(gPlayerDrag[id] == playerid) {
			gPlayerDrag[id] = INVALID_PLAYER_ID;
		}
		
		new factionid = Faction_GetID(playerData[playerid][pFaction]);
		SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_LIGHTBLUE, "[ห้องขัง] %s %s ได้คุมขัง %s เวลา %d นาที", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid), ReturnRealName(id), time);

		SendClientMessageEx(id, COLOR_LIGHTRED, "[ ! ] จ่ายค่าปรับ $%d", fine, time);
		SendClientMessage(id, COLOR_LIGHTRED, "[ ! ] คำเตือน: คุณอยู่ในคุกดังนั้นโทรศัพท์ของคุณจึงถูกปิดและอย่าลืมเปิดเครื่องเมื่อออกจากคุก");
	}
	else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่หน้าห้องขัง");

	return 1;
}

CMD:revoke(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE)
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่ตำรวจเท่านั้น !");

	new userid, type[24];

	if(sscanf(params,"us[24]", userid, type)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /revoke [ไอดีผู้เล่น/ชื่อบางส่วน] [ใบขับขี่,เงินแดง,อาวุธ,ดินปืน]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (!IsPlayerNearPlayer(playerid, userid, 4.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

	if(!strcmp(type, "ใบขับขี่", true))
	{
		SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "* %s ได้ยึดใบอนุณาตขับขี่ของ %s ไป", ReturnRealName(playerid), ReturnRealName(userid));
		SendClientMessageEx(userid, COLOR_WHITE, "ใบอนุญาตขับขี่ของคุณถูกเพิกถอนโดย %s", ReturnRealName(playerid));
		playerData[userid][pCarLic] = false;
		return 1;
	}

	else if(!strcmp(type, "เงินแดง", true))
	{
		SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "* %s ได้ยึดเงินแดงของ %s ไป", ReturnRealName(playerid), ReturnRealName(userid));
		SendClientMessageEx(userid, COLOR_WHITE, "เงินแดงที่คุณมีทั้งหมดถูกยึดโดย %s", ReturnRealName(playerid));
		playerData[userid][pRMoney] = 0;

		return 1;
	}

	else if(!strcmp(type, "อาวุธ", true))
	{
		SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "* %s ได้ยึดอาวุธจาก %s", ReturnRealName(playerid), ReturnRealName(userid));
		SendClientMessageEx(userid, COLOR_WHITE, "อาวุธของคุณทั้งหมดถูกยึดโดย %s", ReturnRealName(playerid));
		FullResetPlayerWeapons(userid);

		return 1;
	}

	else if(!strcmp(type, "ดินปืน", true))
	{
		SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "* %s ได้ยึดดินปืนจาก %s", ReturnRealName(playerid), ReturnRealName(userid));
		SendClientMessageEx(userid, COLOR_WHITE, "ดินปืนของคุณทั้งหมดถูกยึดโดย %s", ReturnRealName(playerid));
		playerData[userid][pMaterials] = 0;

		return 1;
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /revoke [ไอดีผู้เล่น/ชื่อบางส่วน] [ใบขับขี่,เงินแดง,อาวุธ,ดินปืน]");

	return 1;
}

PutPlayerInCell(playerid, cell)
{
	switch(cell)
	{
		case 1:
		{
			SetPlayerSkin(playerid, 268);
			playerData[playerid][pPosX] = 227.3882;
			playerData[playerid][pPosY] = 110.0966;
			playerData[playerid][pPosZ] = 999.0156;
			playerData[playerid][pPosA] = 358.5468;

		    playerData[playerid][pInterior] = GetPlayerInterior(playerid);
		    playerData[playerid][pVWorld] = GetPlayerVirtualWorld(playerid);

			SpawnPlayer(playerid);
		}
		case 2:
		{
			SetPlayerSkin(playerid, 268);
			playerData[playerid][pPosX] = 223.3852;
			playerData[playerid][pPosY] = 110.0966;
			playerData[playerid][pPosZ] = 999.0156;
			playerData[playerid][pPosA] = 358.5468;

		    playerData[playerid][pInterior] = GetPlayerInterior(playerid);
		    playerData[playerid][pVWorld] = GetPlayerVirtualWorld(playerid);

			SpawnPlayer(playerid);
		}
		case 3:
		{
			SetPlayerSkin(playerid, 268);
			playerData[playerid][pPosX] = 219.5155;
			playerData[playerid][pPosY] = 110.9922;
			playerData[playerid][pPosZ] = 999.0156;
			playerData[playerid][pPosA] = 358.5468;

		    playerData[playerid][pInterior] = GetPlayerInterior(playerid);
		    playerData[playerid][pVWorld] = GetPlayerVirtualWorld(playerid);
			SpawnPlayer(playerid);
		}
		case 4:
		{
			SetPlayerSkin(playerid, 268);
			playerData[playerid][pPosX] = 223.3155;
			playerData[playerid][pPosY] = 110.9922;
			playerData[playerid][pPosZ] = 999.0156;
			playerData[playerid][pPosA] = 358.5468;

		    playerData[playerid][pInterior] = GetPlayerInterior(playerid);
		    playerData[playerid][pVWorld] = GetPlayerVirtualWorld(playerid);
			SpawnPlayer(playerid);
		}
		case 5:
		{
			SetPlayerSkin(playerid, 268);
			playerData[playerid][pPosX] = 263.4523;
			playerData[playerid][pPosY] = 77.3231;
			playerData[playerid][pPosZ] = 1001.0391;
			playerData[playerid][pPosA] = 221.4960;

		    playerData[playerid][pInterior] = GetPlayerInterior(playerid);
		    playerData[playerid][pVWorld] = GetPlayerVirtualWorld(playerid);
			SpawnPlayer(playerid);
		}
	}
	return 1;
}

Faction_OnlineCount(type) {
	new count;
	foreach (new i : Player) {
		if (playerData[i][pFaction] != 0 && Faction_GetTypeID(playerData[i][pFaction]) == type) {
			count++;
		}
	}
	return count;
}

