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
            SendClientMessage(playerid, COLOR_WHITE, "����� : /siren [��Դ]");
            SendClientMessage(playerid, COLOR_GREY, "��Դ : 1 = ����, 2 = ��ѧ��, 3 = �ʹ�͡");
            return 1;
        }
        switch(type)
        {
        	case 1:
            {
                if(Siren[VID] == 1)
                {
                    SendClientMessage(playerid, COLOR_GREY, "ö�ѹ�����������ù����!");
                    return 1;
                }
				Siren[VID] = 1;
				SirenObject[VID] = CreateDynamicObject(18646, 10.0, 10.0, 10.0, 0, 0, 0);
				AttachDynamicObjectToVehicle(SirenObject[VID], VID, 0.0, 0.75, 0.275, 0.0, 0.1, 0.0);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s �Դ��ù��������㹴�ҹ˹��ö %s", ReturnRealName(playerid), ReturnVehicleModelName(modelid));
				return 1;
            }
        	case 2:
            {
                if(Siren[VID] == 1)
                {
                    SendClientMessage(playerid, COLOR_GREY, "ö�ѹ�����������ù����!");
                    return 1;
                }
                Siren[VID] = 1;
                SirenObject[VID] = CreateDynamicObject(18646, 10.0, 10.0, 10.0, 0, 0, 0);
                AttachDynamicObjectToVehicle(SirenObject[VID], VID, -0.43, 0.0, 0.785, 0.0, 0.1, 0.0);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s �Դ��ù��麹��ѧ��ö %s", ReturnRealName(playerid), ReturnVehicleModelName(modelid));
                return 1;
            }
        	case 3:
            {
                if(Siren[VID] == 0)
                {
                    SendClientMessage(playerid, COLOR_GREY, "ö�ѹ����������ù!");
                    return 1;
                }
                Siren[VID] = 0;
                DestroyDynamicObject(SirenObject[VID]);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s �ʹ��ù�͡�ҡö %s", ReturnRealName(playerid), ReturnVehicleModelName(modelid));
                return 1;
            }
        	default:
            {
                SendClientMessage(playerid, COLOR_WHITE, "�������Է�ԡ����ҹ���١��ͧ! /siren [��Դ]");
                SendClientMessage(playerid, COLOR_GREY, "��Դ : 1 = ��ѧ�� , 2 = �ö , 3 = �Դ");
            }
        }
    }
    else SendClientMessage(playerid, COLOR_GREY, "�س������Ѻ͹حҵ��������觹��");
    return 1;
	
}

// Commands

flags:factioncmds(CMD_MANAGEMENT);
CMD:factioncmds(playerid) {
    SendClientMessage(playerid, COLOR_GRAD1, "�����: /factionlist, /makefaction, /removefaction, /makeleader ");
    return 1;
}

flags:makeleader(CMD_LEAD_ADMIN);
CMD:makeleader(playerid, params[])
{
	new
		targetid,
		id;

	if (sscanf(params, "ud", targetid, id))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /makeleader [�ʹռ�����/���ͺҧ��ǹ] [�ʹ� (/factionlist)] (�� 0 ���ͻŴ)");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if (id == 0)
	{
	    playerData[targetid][pFaction] = 0;
		playerData[targetid][pFactionRank] = 0;
		SetPlayerToTeamColor(targetid);
	    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "   �س��ź %s �ҡ�������͡�����ͧ��", ReturnRealName(targetid));
    	SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "   %s ��ź�س�͡�ҡ�������͡�����ͧ�س", ReturnRealName(playerid));
		return 1;
	}

	id--;
	if(Iter_Contains(Iter_Faction, id))
	{
		playerData[targetid][pFaction] = factionData[id][fID];
		playerData[targetid][pFactionRank] = 1;
		SetPlayerToTeamColor(targetid);
		SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "   �س���駤�ҽ������͡�����ͧ %s �� \"%s\"", ReturnRealName(targetid), factionData[id][fName]);
    	SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "   %s ���駤�ҽ������͡�����ͧ�س�� \"%s\"", ReturnRealName(playerid), factionData[id][fName]);
	
	} 
	else SendClientMessageEx(playerid, COLOR_LIGHTRED, "�����Դ��Ҵ: "EMBED_WHITE"��辺ῤ����ʹ� "EMBED_ORANGE"%d"EMBED_WHITE" ������к�", id + 1);

    return 1;
}

flags:asetrank(CMD_LEAD_ADMIN);
CMD:asetrank(playerid, params[])
{
	new
		targetid,
		rank;

	if (sscanf(params, "ud", targetid, rank))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /asetrank [�ʹռ�����/���ͺҧ��ǹ] [��]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if (playerData[targetid][pFaction] == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹���������Ҫԡ�ͧ�������͡����� �");

    /*if (rank < 1 || rank > factionData[factionid][fMaxRanks])
        return SendClientMessageEx(playerid, COLOR_GRAD1, "   �����١��ͧ �Ȣͧ�������͡����������������ҧ 1 �֧ %d", factionData[factionid][fMaxRanks]);
	*/

    if (rank < 1 || rank > 21)
        return SendClientMessageEx(playerid, COLOR_GRAD1, "   �����١��ͧ �Ȣͧ�������͡����������������ҧ 1 �֧ 21");
	
	playerData[targetid][pFactionRank] = rank;

	new fid = Faction_GetID(playerData[targetid][pFaction]);
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "   �س���駤���Ƚ������͡�����ͧ %s �� %s(%d)", ReturnRealName(targetid), Faction_GetRankName(fid, rank), rank);
    SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "   %s ���駤���Ƚ������͡�����ͧ�س�� %s(%d)", ReturnRealName(playerid), Faction_GetRankName(fid, rank), rank);

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
        SendClientMessage(playerid, COLOR_GRAD1, "�����: /makefaction [������] [�������] [���ͽ���] ");
        SendClientMessage(playerid, COLOR_GRAD2, "[������] 0: ����к� 1: ���ѧ�Ѻ�顮���� (Law Enforcement) - 2: �Ѱ��� (Government)");
		SendClientMessage(playerid, COLOR_GRAD2, "[������] 3: ᾷ�� (Medical) - 4: �ѡ���� (News Network) - 5: �ꧤ� - 6: ��ҧ����ö (Mechanic)");
	    SendClientMessage(playerid, COLOR_LIGHTRED,   "[ ! ]"EMBED_WHITE" ������������ժ�ͧ��ҧ");
		return 1;
	}
    if(type < 0 || type > 6) {
        SendClientMessage(playerid, COLOR_LIGHTRED,   "�����Դ��Ҵ: "EMBED_WHITE"������ῤ��蹵�ͧ����ӡ��� "EMBED_ORANGE"0"EMBED_WHITE" �����ҡ���� "EMBED_ORANGE"6");
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
		    format(factionRanks[id][j], 30, "�� %d", j + 1);
		}

		for (new j = 0; j != MAX_FACTION_SKINS; j ++) {
		    factionSkins[id][j] = 0;
		}

	    mysql_tquery(dbCon, "INSERT INTO `faction` (`type`) VALUES(0)", "OnFactionCreated", "d", id);

		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s �����ҧῤ��� %s"EMBED_YELLOW" �ʹ� %d", ReturnPlayerName(playerid), name, id +1);

        Iter_Add(Iter_Faction, id);
    }
    else {
        SendClientMessageEx(playerid, COLOR_LIGHTRED,   "�����Դ��Ҵ: "EMBED_WHITE"�������ö���ҧῤ������ҡ���ҹ������ �ӡѴ����� "EMBED_ORANGE"%d", MAX_FACTIONS);
    }
	return 1;
}

CMD:removefaction(playerid, params[]) {
	new
	    id = 0;

	if (sscanf(params, "d", id))
 	{
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /removefaction [�ʹ� (/factionlist)]");
		return 1;
	}

	id--;
	if(Iter_Contains(Iter_Faction, id))
	{
		new
	        string[80];

		//�Ŵ�������͡�ҡῤ��蹷��١ź
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

		//ź�ҹ��˹з������ͧῤ��� �� FOREIGN KEY ����ź㹰ҹ������
		DestroyFactionVehicle(playerid, id);

		//źῤ���
		format(string, sizeof(string), "DELETE FROM `faction` WHERE `id` = '%d'", factionData[id][fID]);
		mysql_tquery(dbCon, string);

		Log(adminactionlog, INFO, "%s: źῤ��� %s(%d)", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID]);

		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ��źῤ��� %s"EMBED_YELLOW" �ʹ� %d", ReturnPlayerName(playerid), factionData[id][fName], id +1);

		Iter_Remove(Iter_Faction, id);
	}
	else {
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "�����Դ��Ҵ: "EMBED_WHITE"��辺ῤ����ʹ� "EMBED_ORANGE"%d"EMBED_WHITE" ������к�", id + 1);
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
		name[60] = "��ЪҪ�";

 	if (Iter_Contains(Iter_Faction, factionid)) {
		 format(name, 60, factionData[factionid][fName]);
	 }
	return name;
}

Faction_List(playerid)
{
	new string[2048], menu[20], count;

	format(string, sizeof(string), "%s"EMBED_GRAD1"˹�� 1\n", string);

	SetPVarInt(playerid, "page", 1);

	foreach(new i : Iter_Faction) {
		if(count == 20)
		{
			format(string, sizeof(string), "%s"EMBED_GRAD1"˹�� 2\n", string);
			break;
		}
		format(menu, 20, "menu%d", ++count);
		SetPVarInt(playerid, menu, i);
		format(string, sizeof(string), "%s("EMBED_ORANGE"%i"EMBED_WHITE") | %s\n", string, i + 1, factionData[i][fName]);
	}
	if(!count) Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "��ª���ῤ���", "��辺�����Ţͧῤ���..", "�Դ", "");
	else Dialog_Show(playerid, FactionsList, DIALOG_STYLE_LIST, "��ª���ῤ���", string, "���", "��Ѻ");
	return 1;
}

Faction_GetID(factionid) // ���� index
{
	foreach(new i : Iter_Faction) {
		if (factionData[i][fID] == factionid) {
			return i;
		}
	}
	return -1;
}

Faction_GetName(factionid) // ���� index
{
	new name[60] = "��ЪҪ�";
	if (Iter_Contains(Iter_Faction, factionid)) {
		format(name, 60, factionData[factionid][fName]);
	}
	return name;
}

Faction_GetRankName(factionid, rankid)
{
	new name[30] = "�����";
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
        case FACTION_TYPE_POLICE: format(faction_type, sizeof faction_type, "���ѧ�Ѻ�顮����");
		case FACTION_TYPE_GOV: format(faction_type, sizeof faction_type, "�Ѱ���");
        case FACTION_TYPE_MEDIC: format(faction_type, sizeof faction_type, "ᾷ��");
        case FACTION_TYPE_NEWS: format(faction_type, sizeof faction_type, "�ѡ����");
        case FACTION_TYPE_GANG: format(faction_type, sizeof faction_type, "�ꧤ�");
		case FACTION_TYPE_MECHA: format(faction_type, sizeof faction_type, "��ҧ����ö");
        default: format(faction_type, sizeof faction_type, "����к�");
    }
    return faction_type;
}

Dialog:FactionsList(playerid, response, listitem, inputtext[])
{
	if(response) {

		new menu[20];
		if(listitem != 0 && listitem != 21) {

			if(!(playerData[playerid][pCMDPermission] & CMD_MANAGEMENT)) {
				SendClientMessage(playerid, COLOR_LIGHTRED, "�����Դ��Ҵ"EMBED_WHITE": �س������Ѻ͹حҵ�����ѧ���蹡����� "EMBED_RED"(MANAGEMENT ONLY)");
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
		format(string, sizeof(string), "%s"EMBED_GRAD1"˹�� %d\n", string, (currentPage==1) ? 1 : currentPage-1);

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
				format(string, sizeof(string), "%s"EMBED_GRAD1"˹�� 2\n", string);
				break;
			}
			format(menu, 20, "menu%d", ++count);
			SetPVarInt(playerid, menu, i);
			format(string, sizeof(string), "%s("EMBED_ORANGE"%i"EMBED_WHITE") | %s\n", string, i + 1, factionData[i][fName]);

		}

		Dialog_Show(playerid, FactionsList, DIALOG_STYLE_LIST, "��ª���ῤ���", string, "���", "��Ѻ");
	}
	return 1;
}

Faction_EditMenu(playerid)
{
    new id = GetPVarInt(playerid, "FactionEditID");
	if(Iter_Contains(Iter_Faction, id))
	{
		new caption[128], dialog_str[1024];
		format(caption, sizeof(caption), "ῤ���: "EMBED_WHITE"%s"EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")", factionData[id][fName], id + 1);
        format(dialog_str, sizeof dialog_str, "����\t%s\n", factionData[id][fName]);
        format(dialog_str, sizeof dialog_str, "%s�������\t%s\n", dialog_str, factionData[id][fShortName]);
        format(dialog_str, sizeof dialog_str, "%s��\t{%06x}%06x\n", dialog_str, factionData[id][fColor] >>> 8, factionData[id][fColor]  >>> 8);
        format(dialog_str, sizeof dialog_str, "%s������\t%s\n", dialog_str, Faction_GetTypeName(factionData[id][fType]));
       /*format(dialog_str, sizeof dialog_str, "%s��\t%d/%d\n", dialog_str, factionData[id][fMaxRanks], MAX_FACTION_RANKS);
        format(dialog_str, sizeof dialog_str, "%sʡԹ\t%d/%d\n", dialog_str, factionData[id][fMaxSkins], MAX_FACTION_SKINS);
        format(dialog_str, sizeof dialog_str, "%s�ҹ��˹�\t%d\n", dialog_str, factionData[id][fMaxVehicles]);*/
        format(dialog_str, sizeof dialog_str, "%s��駤����� �", dialog_str);
		Dialog_Show(playerid, FactionEdit, DIALOG_STYLE_TABLIST, caption, dialog_str, "���͡", "��Ѻ");
	}
	return 1;
}

Dialog:FactionEdit(playerid, response, listitem, inputtext[])
{
	if(response) {
  
        new id = GetPVarInt(playerid, "FactionEditID");
		switch(listitem)
		{
			case 0: // ��䢪���
			{
				Dialog_Show(playerid, FactionEdit_Name, DIALOG_STYLE_INPUT, sprintf("��� -> ����: "EMBED_YELLOW"%s", factionData[id][fName]), ""EMBED_WHITE"������Ǣͧ���͵�ͧ�ҡ���� "EMBED_ORANGE"0 "EMBED_WHITE"�������Թ "EMBED_ORANGE"60 "EMBED_WHITE"����ѡ��\n\n��͡����ῤ��蹷���ͧ���㹪�ͧ��ҧ��ҹ��ҧ���:", "����¹", "��Ѻ");
			}
			case 1: // ��䢪������
			{
				Dialog_Show(playerid, FactionEdit_ShortName, DIALOG_STYLE_INPUT, sprintf("��� -> �������: "EMBED_YELLOW"%s", factionData[id][fShortName]), ""EMBED_WHITE"������Ǣͧ������͵�ͧ�ҡ���� "EMBED_ORANGE"0 "EMBED_WHITE"�������Թ "EMBED_ORANGE"15 "EMBED_WHITE"����ѡ��\n\n��͡����ῤ��蹷���ͧ���㹪�ͧ��ҧ��ҹ��ҧ���:", "����¹", "��Ѻ");
			}
			case 2: // �����
			{
				Dialog_Show(playerid, FactionEdit_Color, DIALOG_STYLE_INPUT, sprintf("��� -> ��: {%06x}%06x", factionData[id][fColor] >>> 8, factionData[id][fColor] >>> 8), ""EMBED_WHITE"������ҧ����: "EMBED_YELLOW"ffff00"EMBED_WHITE"\n\n��͡���շ���ͧ���㹪�ͧ��ҧ��ҹ��ҧ���:", "����¹", "��Ѻ");
			}
			case 3: // ��䢻�����
			{
				/*
				UNKNOWN		0
				POLICE 		1
				GOV 		2
				MEDIC		3
				NEWS		4
				GANG		5
				*/
				Dialog_Show(playerid, FactionEdit_Type, DIALOG_STYLE_LIST, sprintf("��� -> ������: %s", Faction_GetTypeName(factionData[id][fType])), "0: ����к�\n1: ���ѧ�Ѻ�顮���� (Law Enforcement)\n2: �Ѱ��� (Government)\n3: ᾷ�� (Medical)\n4: �ѡ���� (News Network)\n5: �Դ������\n6: ��ҧ����ö", "����¹", "��Ѻ");
			}
			case 4: // ��駤����� �
			{
				Dialog_Show(playerid, FactionEdit_Settings, DIALOG_STYLE_TABLIST, "��� -> ��駤����� �", "��\t%d/%d\nʡԹ\t%d/%d\n�ҹ��˹��٧�ش\t%d\n�ȵ���ش����ԭ/����\t%d\n�ش�Դ\t", "���͡", "��Ѻ", factionData[id][fMaxRanks], MAX_FACTION_RANKS, factionData[id][fMaxSkins], MAX_FACTION_SKINS, factionData[id][fMaxVehicles], factionData[id][fMinInvite]);
			}
			/*case 4: // �����
			{
				Dialog_Show(playerid, FactionEdit_Rank, DIALOG_STYLE_LIST, "��� -> ��", "�ȷ����ҹ��\t(%d/%d)\n������\t", "���", "��Ѻ", factionData[id][fMaxRanks], MAX_FACTION_RANKS);
			}
			case 5: // ���ʡԹ
			{
				Dialog_Show(playerid, FactionEdit_Skin, DIALOG_STYLE_LIST, "��� -> ʡԹ", "ʡԹ�������\t(%d/%d)\n�ʹ�ʡԹ\t", "���", "��Ѻ", factionData[id][fMaxSkins], MAX_FACTION_SKINS);
			}
			case 6: // ��䢾�˹�
			{
				Dialog_Show(playerid, FactionEdit_VehMax, DIALOG_STYLE_INPUT, "��� -> ��˹�", "�Ѩ�غѹ: %d\n\n��͡�ӹǹ��˹��٧�ش㹪�ͧ��ҧ��ҹ��ҧ���:", "����¹", "��Ѻ", factionData[id][fMaxVehicles]);
			}
			case 7: // �ش�Դ
			{
				Dialog_Show(playerid, FactionEdit_Spawn, DIALOG_STYLE_LIST, "��� -> ��駤�Ҩش�Դ", "��Ѻ�ش�Դ\nź��ҧ�ش�Դ", "��Ѻ", "��Ѻ");
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
			format(caption, sizeof(caption), "��� -> ����: "EMBED_YELLOW"%s", factionData[id][fName]);
			Dialog_Show(playerid, FactionEdit_Name, DIALOG_STYLE_INPUT, caption, ""EMBED_LIGHTRED"����ͼԴ��Ҵ:\n"EMBED_WHITE"������Ǣͧ���͵�ͧ�ҡ���� "EMBED_YELLOW"0 "EMBED_WHITE"�������Թ "EMBED_YELLOW"60 "EMBED_WHITE"����ѡ��", "����¹", "��Ѻ");
			return 1;
		}
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹����ῤ��� %s"EMBED_YELLOW" �� %s", ReturnPlayerName(playerid), factionData[id][fName], inputtext);
	
		Log(adminactionlog, INFO, "%s: ����¹���� %s(%d) �ҡ %s �� %s", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fName], inputtext);

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
			format(caption, sizeof(caption), "��� -> �������: "EMBED_YELLOW"%s", factionData[id][fShortName]);
			Dialog_Show(playerid, FactionEdit_ShortName, DIALOG_STYLE_INPUT, caption, ""EMBED_LIGHTRED"����ͼԴ��Ҵ:\n"EMBED_WHITE"������Ǣͧ������͵�ͧ�ҡ���� "EMBED_YELLOW"0 "EMBED_WHITE"�������Թ "EMBED_YELLOW"15 "EMBED_WHITE"����ѡ��", "����¹", "��Ѻ");
			return 1;
		}
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹�������ῤ��� %s"EMBED_YELLOW" �� %s", ReturnPlayerName(playerid), factionData[id][fName], inputtext);

		Log(adminactionlog, INFO, "%s: ����¹������� %s(%d) �ҡ %s �� %s", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fShortName], inputtext);
	
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
			format(caption, sizeof(caption), "��� -> ��: {%06x}%06x", factionData[id][fColor], factionData[id][fColor]);
			return Dialog_Show(playerid, FactionEdit_Color, DIALOG_STYLE_INPUT, caption, ""EMBED_WHITE"������ҧ����: "EMBED_YELLOW"ffff0077"EMBED_WHITE"\n\n��͡���շ���ͧ���㹪�ͧ��ҧ��ҹ��ҧ���:", "����¹", "��Ѻ");
		}
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹�բͧῤ��� %s"EMBED_YELLOW" �� {%06x}%06x", ReturnPlayerName(playerid), factionData[id][fName], color >>> 8, color >>> 8);

		new string[256];
		format(string, sizeof string, "%s: ����¹�� %s(%d) �ҡ %06x �� %06x", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fColor], color);
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
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹������ῤ��� %s"EMBED_YELLOW" �� %s", ReturnPlayerName(playerid), factionData[id][fName], Faction_GetTypeName(factionData[id][fType]), Faction_GetTypeName(listitem));
		Log(adminactionlog, INFO, "%s: ����¹������ %s(%d) �ҡ %s �� %s", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], Faction_GetTypeName(factionData[id][fType]), Faction_GetTypeName(listitem));
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
				return Dialog_Show(playerid, FactionEdit_Rank, DIALOG_STYLE_LIST, "��� -> ��", "�ȷ����ҹ��\t(%d/%d)\n������\t", "���͡", "��Ѻ", factionData[id][fMaxRanks], MAX_FACTION_RANKS);
			}
			case 1: {
				return Dialog_Show(playerid, FactionEdit_Skin, DIALOG_STYLE_LIST, "��� -> ʡԹ", "ʡԹ�������\t(%d/%d)\n�ʹ�ʡԹ\t", "���͡", "��Ѻ", factionData[id][fMaxSkins], MAX_FACTION_SKINS);
			}
			case 2: {
				return Dialog_Show(playerid, FactionEdit_VehMax, DIALOG_STYLE_INPUT, "��� -> ��˹�", "�Ѩ�غѹ: %d\n\n��͡�ӹǹ��˹��٧�ش㹪�ͧ��ҧ��ҹ��ҧ���:", "����¹", "��Ѻ", factionData[id][fMaxVehicles]);
			}
			case 3: {
				return Dialog_Show(playerid, FactionEdit_Invite, DIALOG_STYLE_INPUT, "��� -> ����ԭ", "�Ѩ�غѹ: %d\n\n��͡�����Ţ�ȵ���ش����ͧ���������Է����ԭ㹪�ͧ��ҧ��ҹ��ҧ��� (1-%d):", "����¹", "��Ѻ", factionData[id][fMinInvite], factionData[id][fMaxRanks]);
			}
			case 4: {
				return Dialog_Show(playerid, FactionEdit_Spawn, DIALOG_STYLE_LIST, "��� -> ��駤�Ҩش�Դ", "��Ѻ�ش�Դ\nź��ҧ�ش�Դ", "��Ѻ", "��Ѻ");
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
				return Dialog_Show(playerid, FactionEdit_RankMax, DIALOG_STYLE_INPUT, "��� -> ��", ""EMBED_WHITE"�Ѩ�غѹ: %d/%d\n\n��͡�ӹǹ���٧�ش㹪�ͧ��ҧ��ҹ��ҧ���:", "����¹", "��Ѻ", factionData[id][fMaxRanks], MAX_FACTION_RANKS);
			}
			case 1: {
				if(factionData[id][fMaxRanks] == 0) return Dialog_Show(playerid, FactionEdit_Rank, DIALOG_STYLE_LIST, "��� -> ��", "�ȷ����ҹ��\t(%d/%d)\n������\t", "���", "��Ѻ", factionData[id][fMaxRanks], MAX_FACTION_RANKS);
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
		format(string, sizeof(string), "%s�� %d: "EMBED_YELLOW"%s\n", string, i + 1, factionRanks[id][i]);

	return Dialog_Show(playerid, FactionEdit_RankName, DIALOG_STYLE_LIST, "�� -> ������", string, "���", "��Ѻ");
}

Dialog:FactionEdit_RankName(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "FactionEditID");
	if (response)
	{
		SetPVarInt(playerid, "FactionEditSlot", listitem);
		return Dialog_Show(playerid, FactionEdit_SetRankName, DIALOG_STYLE_INPUT, "�� -> ������", ""EMBED_WHITE"��: "EMBED_YELLOW"%s "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\n��سһ�͹�����������ҹ��ҧ���:", "����¹", "��Ѻ", factionRanks[id][listitem], listitem + 1);
	}
	return Dialog_Show(playerid, FactionEdit_Rank, DIALOG_STYLE_LIST, "��� -> ��", "�ȷ����ҹ��\t(%d/%d)\n������\t", "���", "��Ѻ", factionData[id][fMaxRanks], MAX_FACTION_RANKS);
}

Dialog:FactionEdit_SetRankName(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new rank_slot = GetPVarInt(playerid, "FactionEditSlot"), id = GetPVarInt(playerid, "FactionEditID");

	    if (isnull(inputtext))
			return Dialog_Show(playerid, FactionEdit_SetRankName, DIALOG_STYLE_INPUT, "�� -> ������", ""EMBED_WHITE"��: "EMBED_YELLOW"%s "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\n��سһ�͹�����������ҹ��ҧ���:", "����¹", "��Ѻ", factionRanks[id][rank_slot], rank_slot + 1);

	    if (strlen(inputtext) < 1 || strlen(inputtext) > 30)
	        return Dialog_Show(playerid, FactionEdit_SetRankName, DIALOG_STYLE_INPUT, "�� -> ������", ""EMBED_WHITE"��: "EMBED_YELLOW"%s "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n"EMBED_LIGHTRED"��ͼԴ��Ҵ"EMBED_WHITE": ������Ǣͧ���͵�ͧ����ӡ��� "EMBED_ORANGE"1"EMBED_WHITE" �����ҡ���� "EMBED_ORANGE"30"EMBED_WHITE"\n\n��سһ�͹�����������ҹ��ҧ���:", "����¹", "��Ѻ", factionRanks[id][rank_slot], rank_slot + 1);

		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹�����ȷ�� %d �ͧῤ��� %s"EMBED_YELLOW" �� %s", ReturnPlayerName(playerid), rank_slot + 1, factionData[id][fName], inputtext);

		Log(adminactionlog, INFO, "%s: ����¹�����Ȣͧ %s(%d) �ȷ�� %d �ҡ %s �� %s", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], rank_slot + 1, factionRanks[id][rank_slot], inputtext);
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
			return Dialog_Show(playerid, FactionEdit_RankMax, DIALOG_STYLE_INPUT, "��� -> ��", ""EMBED_WHITE"�Ѩ�غѹ: %d/%d\n"EMBED_LIGHTRED"��ͼԴ��Ҵ"EMBED_WHITE": �ӹǹ��ͧ����ӡ��� "EMBED_ORANGE"0"EMBED_WHITE" �����ҡ���� "EMBED_ORANGE"%d"EMBED_WHITE"\n\n��͡�ӹǹ���٧�ش㹪�ͧ��ҧ��ҹ��ҧ���:", "����¹", "��Ѻ", factionData[id][fMaxRanks], MAX_FACTION_RANKS, MAX_FACTION_RANKS);
		}
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹�ȷ����ҹ��ͧῤ��� %s"EMBED_YELLOW" �� %d", ReturnPlayerName(playerid), factionData[id][fName], typeint);

		Log(adminactionlog, INFO, "%s: ����¹���٧�ش�ͧ %s(%d) �ҡ %d �� %d", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fMaxRanks], typeint);
	    factionData[id][fMaxRanks] = typeint;
	    Faction_Save(id);
	}
	return Dialog_Show(playerid, FactionEdit_Rank, DIALOG_STYLE_LIST, "��� -> ��", "�ӹǹ��\t(%d/%d)\n������\t", "���", "��Ѻ", factionData[id][fMaxRanks], MAX_FACTION_RANKS);
}

Dialog:FactionEdit_Invite(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "FactionEditID");
	if(response) {
		new typeint = strval(inputtext);
		if(typeint < 1 || typeint > factionData[id][fMaxRanks]) {
			return Dialog_Show(playerid, FactionEdit_Invite, DIALOG_STYLE_INPUT, "��� -> ����ԭ", "�Ѩ�غѹ: %d\n\n��͡�����Ţ�ȵ���ش����ͧ���������Է����ԭ㹪�ͧ��ҧ��ҹ��ҧ��� (1-%d):", "����¹", "��Ѻ", factionData[id][fMinInvite], factionData[id][fMaxRanks]);
		}
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹�ȵ���ش�������ö�ԭ��ͧῤ��� %s"EMBED_YELLOW" �� %d", ReturnPlayerName(playerid), factionData[id][fName], typeint);

		Log(adminactionlog, INFO, "%s: ����¹���ȵ���ش�������ö�ԭ��ͧ %s(%d) �ҡ %d �� %d", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fMinInvite], typeint);
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
				return Dialog_Show(playerid, FactionEdit_SkinMax, DIALOG_STYLE_INPUT, "��� -> ʡԹ", ""EMBED_WHITE"�Ѩ�غѹ: %d/%d\n\n��͡�ӹǹʡԹ�٧�ش㹪�ͧ��ҧ��ҹ��ҧ���:", "����¹", "��Ѻ", factionData[id][fMaxSkins], MAX_FACTION_SKINS);
			}
			case 1: {
				if(factionData[id][fMaxSkins] == 0) return Dialog_Show(playerid, FactionEdit_Skin, DIALOG_STYLE_LIST, "��� -> ʡԹ", "ʡԹ�������\t(%d/%d)\n�ʹ�ʡԹ\t", "���", "��Ѻ", factionData[id][fMaxSkins], MAX_FACTION_SKINS);
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
		format(string, sizeof(string), "%sʡԹ %d: "EMBED_YELLOW"%d\n", string, i + 1, factionSkins[id][i]);

	return Dialog_Show(playerid, FactionEdit_SkinID, DIALOG_STYLE_LIST, "ʡԹ -> �ʹ�ʡԹ", string, "���", "��Ѻ");
}

Dialog:FactionEdit_SkinMax(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "FactionEditID");
	if(response) {
		new typeint = strval(inputtext);
		if(typeint < 0 || typeint > MAX_FACTION_SKINS) {
			return Dialog_Show(playerid, FactionEdit_SkinMax, DIALOG_STYLE_INPUT, "��� -> ʡԹ", ""EMBED_WHITE"�Ѩ�غѹ: %d/%d\n"EMBED_LIGHTRED"��ͼԴ��Ҵ"EMBED_WHITE": �ӹǹ��ͧ����ӡ��� "EMBED_ORANGE"0"EMBED_WHITE" �����ҡ���� "EMBED_ORANGE"%d"EMBED_WHITE"\n\n��͡�ӹǹʡԹ�٧�ش㹪�ͧ��ҧ��ҹ��ҧ���:", "����¹", "��Ѻ", factionData[id][fMaxRanks], MAX_FACTION_RANKS, MAX_FACTION_RANKS);
		}
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹ʡԹ�����ҹ��ͧῤ��� %s"EMBED_YELLOW" �� %d", ReturnPlayerName(playerid), factionData[id][fName], typeint);

		Log(adminactionlog, INFO, "%s: ����¹ʡԹ�٧�ش�ͧ %s(%d) �ҡ %d �� %d", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fMaxSkins], typeint);

	    factionData[id][fMaxSkins] = typeint;
	    Faction_Save(id);
	}
	return Dialog_Show(playerid, FactionEdit_Skin, DIALOG_STYLE_LIST, "��� -> ʡԹ", "ʡԹ�������\t(%d/%d)\n�ʹ�ʡԹ\t", "���", "��Ѻ", factionData[id][fMaxSkins], MAX_FACTION_SKINS);
}

Dialog:FactionEdit_SkinID(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "FactionEditID");
	if (response)
	{
		SetPVarInt(playerid, "FactionEditSlot", listitem);
		return Dialog_Show(playerid, FactionEdit_SetSkinID, DIALOG_STYLE_INPUT, "ʡԹ -> �ʹ�ʡԹ", ""EMBED_WHITE"ʡԹ: "EMBED_YELLOW"%d "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\n��سһ�͹�ʹ�ʡԹ�����ҹ��ҧ���:", "����¹", "��Ѻ", factionSkins[id][listitem], listitem + 1);
	}
	return Dialog_Show(playerid, FactionEdit_Skin, DIALOG_STYLE_LIST, "��� -> ʡԹ", "ʡԹ�������\t(%d/%d)\n�ʹ�ʡԹ\t", "���", "��Ѻ", factionData[id][fMaxSkins], MAX_FACTION_RANKS);
}

Dialog:FactionEdit_SetSkinID(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new skin_slot = GetPVarInt(playerid, "FactionEditSlot"), id = GetPVarInt(playerid, "FactionEditID"), skin_id = strval(inputtext);

	    if (isnull(inputtext))
			return Dialog_Show(playerid, FactionEdit_SetSkinID, DIALOG_STYLE_INPUT, "ʡԹ -> �ʹ�ʡԹ", ""EMBED_WHITE"ʡԹ: "EMBED_YELLOW"%d "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\n��سһ�͹�ʹ�ʡԹ�����ҹ��ҧ���:", "����¹", "��Ѻ", factionSkins[id][skin_slot], skin_slot + 1);

		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹ʡԹ��� %d �ͧῤ��� %s"EMBED_YELLOW" �� %d", ReturnPlayerName(playerid), skin_slot + 1, factionData[id][fName], skin_id);
		Log(adminactionlog, INFO, "%s: ����¹�ʹ�ʡԹ�ͧ %s(%d) ʡԹ��� %d �ҡ %d �� %d", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], skin_slot + 1, factionSkins[id][skin_slot], skin_id);
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
			return Dialog_Show(playerid, FactionEdit_VehMax, DIALOG_STYLE_INPUT, "��� -> ��˹�", "�Ѩ�غѹ: %d\n\n��͡�ӹǹ��˹��٧�ش㹪�ͧ��ҧ��ҹ��ҧ���:", "����¹", "��Ѻ", factionData[id][fMaxVehicles]);
		}
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹�ӹǹ��˹��٧�ش�ͧῤ��� %s"EMBED_YELLOW" �� %s", ReturnPlayerName(playerid), factionData[id][fName], typeint);
		Log(adminactionlog, INFO, "%s: ����¹�ӹǹ��˹��٧�ش�ͧ %s(%d) �ҡ %d �� %d", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fMaxVehicles], typeint);
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
				return Dialog_Show(playerid, FactionEdit_SpawnConf, DIALOG_STYLE_MSGBOX, "��� -> ��駤�Ҩش�Դ", "�س������ͷ��л�Ѻ�ش�Դῤ��蹹�����ѧ���˹觻Ѩ�غѹ�ͧ�س", "�׹�ѹ", "��Ѻ");
			}
			case 1: {
				new id = GetPVarInt(playerid, "FactionEditID");
				if(factionData[id][fSpawnX] != 0.0 && factionData[id][fSpawnY] != 0.0) {

					SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ��ź��ҧ�ش�Դ�ͧῤ��� %s", ReturnPlayerName(playerid), factionData[id][fName]);
					Log(adminactionlog, INFO, "%s: ź�ش�Դ�ͧ %s(%d) �ҡ %f,%f,%f (int:%d|world:%d)", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fSpawnX], factionData[id][fSpawnY], factionData[id][fSpawnZ], factionData[id][fSpawnInt], factionData[id][fSpawnWorld]);

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
					SendClientMessage(playerid, COLOR_LIGHTRED, "�����Դ��Ҵ: "EMBED_WHITE"�ش�Դ�ͧῤ��蹹���ѧ�����١��駤�Ҩ֧�������öź��ҧ��");
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

		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹�ش�Դ�ͧῤ��� %s"EMBED_YELLOW" ���ѧ���˹觻Ѩ�غѹ�ͧ��", ReturnPlayerName(playerid), factionData[id][fName]);
		Log(adminactionlog, INFO, "%s: ����¹�ش�Դ�ͧ %s(%d) �ҡ %f,%f,%f (int:%d|world:%d) �� %f,%f,%f (int:%d|world:%d)", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fSpawnX], factionData[id][fSpawnY], factionData[id][fSpawnZ], factionData[id][fSpawnInt], factionData[id][fSpawnWorld], px, py, pz, pint, pworld);

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
	return Dialog_Show(playerid, FactionEdit_Spawn, DIALOG_STYLE_LIST, "��� -> ��駤�Ҩش�Դ", "��Ѻ�ش�Դ\nź��ҧ�ش�Դ", "���͡", "��Ѻ");
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
 		    SendClientMessage(playerid,COLOR_GREEN,"____________________ ��������˹�ҷ����Ǩ ____________________");
 		    SendClientMessage(playerid, COLOR_LIGHTCYAN, "[LSPD] /(gov)ernment (/d)epartments (/m)egaphone /duty /carsign /revoke");
			SendClientMessage(playerid, COLOR_LIGHTCYAN, "[LSPD] /siren /rb(1-10) /rrb(1-10) /cone /disband (/p)ut(incar) /arrest, /ticket, /tickets");
            SendClientMessage(playerid, COLOR_LIGHTCYAN, "[LSPD] (/su)spect /badge /tazer1 /tazer2 /cuff /uncuff /drag /wanted /revoke /takedrug /rubberbullets ");
            SendClientMessage(playerid,COLOR_GREEN,"____________________ ����������Ѻ��Ժ���ظ ____________________");
            SendClientMessage(playerid, COLOR_LIGHTCYAN, "[LSPD] /cartakegun ( ��Ժ�ػ�ó컡�� ) /takeshotgun ( ��Ժ shotgun ) /takem4 ( ��Ժ m4 )");
		}
		else if (factionType == FACTION_TYPE_MEDIC) {
			SendClientMessage(playerid,COLOR_GREEN,"____________________ �����ᾷ�� ____________________");
 		    SendClientMessage(playerid, COLOR_LIGHTCYAN, "[LSMD] /(gov)ernment (/d)epartments (/m)egaphone /duty /carsign");
			SendClientMessage(playerid, COLOR_LIGHTCYAN, "[LSMD] (/p)ut(incar) /cpr /heal");
		}
	}
    return 1;
}

CMD:leavefaction(playerid) {
 	if (playerData[playerid][pFaction] == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ����Ҫԡ�ͧ�������͡����");

	SendFactionIDMessage(playerData[playerid][pFaction], COLOR_FACTION, "%s �����͡�ҡῤ���", ReturnRealName(playerid));

	playerData[playerid][pWear] = 0;
    playerData[playerid][pFaction] = 0;
    playerData[playerid][pFactionRank] = 0;
	SpawnPlayer(playerid);
	return 1;
}

CMD:factions(playerid, params[])
{
 	if (playerData[playerid][pFaction] == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ����Ҫԡ�ͧ�������͡����");

	new factionid = Faction_GetID(playerData[playerid][pFaction]);

	if (factionid != -1) {
		SendClientMessageEx(playerid, COLOR_GRAD1, "��Ҫԡ %s ����͹�Ź�:", factionData[factionid][fName]);

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
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ����Ҫԡ�ͧ�������͡����");

    if(playerData[playerid][pFactionRank] > 4)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �س������Ѻ͹حҵ��������觹��");

	if(!factionData[factionid][fChat])
	{
		factionData[factionid][fChat] = true;
 		SendFactionIDMessage(playerData[playerid][pFaction], COLOR_FACTION, "(( %s [%d] %s: ��Դ����к�᪷����� ))", playerData[playerid][pFactionRank], Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
	}
	else
	{
		factionData[factionid][fChat] = false;
		SendFactionIDMessage(playerData[playerid][pFaction], COLOR_FACTION, "(( %s [%d] %s: ���Դ��ҹ�к�᪷����� ))", playerData[playerid][pFactionRank], Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
	}
	return 1;
}

alias:fac("f");
CMD:fac(playerid, params[])
{

 	if (playerData[playerid][pFaction] == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ����Ҫԡ�ͧ�������͡����");

    new factionid = Faction_GetID(playerData[playerid][pFaction]);

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /(f)ac [��ͤ���]");

	if (factionData[factionid][fChat])
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "᪷������١�Դ���");

    if (BitFlag_Get(gPlayerBitFlag[playerid], TOGGLE_FACTION))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�Դ�����ҹ᪷�ͧ�������͡������͹");

	SendFactionIDMessage(playerData[playerid][pFaction], COLOR_FACTION, "(( [%d] %s %s: %s ))", playerData[playerid][pFactionRank], Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid), params);
	return 1;
}

alias:admin("a");
flags:admin(CMD_ADM_1);
CMD:admin(playerid, params[])
{
	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /(a)dmin [��ͤ���]");

	SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, "{ChatAdmin  [%d] {%d} %s : %s }", playerid,playerData[playerid][pAdmin],ReturnRealName(playerid), params);
	return 1;
}
CMD:invite(playerid, params[])
{
	new
	    targetid;

	if (playerData[playerid][pFaction] == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ����Ҫԡ�ͧ�������͡����");

	//new id = Faction_GetID(playerData[playerid][pFaction]);
	if (playerData[playerid][pFactionRank] > 4)
	    return SendClientMessageEx(playerid, COLOR_GRAD1, "   �س�������ö�����觹����!");

	if (sscanf(params, "u", targetid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /invite [�ʹռ�����/���ͺҧ��ǹ]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if (playerData[targetid][pFaction] == playerData[playerid][pFaction])
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹������ǹ˹�觢ͧ�������͡�����س����");

    if (playerData[targetid][pFaction] != 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹������ǹ˹�觢ͧ�������͡���������������");

	SetPVarInt(targetid, "OfferID", playerid);
	SetPVarInt(targetid, "OfferFactionID", playerData[playerid][pFaction]);

	new factionid = Faction_GetID(playerData[playerid][pFaction]);
    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "   �س���觤���ͧ�֧ %s ���������� \"%s\"", ReturnRealName(targetid), Faction_GetName(factionid));
    SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "   %s ���ʹ����س������� \"%s\" (�� \"/accept invite\")", ReturnRealName(playerid), Faction_GetName(factionid));

	return 1;
}

CMD:uninvite(playerid, params[])
{
	new
	    targetid;

	if (playerData[playerid][pFaction] == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ����Ҫԡ�ͧ�������͡����");

	if (playerData[playerid][pFactionRank] > 3)
	    return SendClientMessageEx(playerid, COLOR_GRAD1, "   �س�������ö�����觹����!");

	if (sscanf(params, "u", targetid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /uninvite [�ʹռ�����/���ͺҧ��ǹ]");

	if(targetid == INVALID_PLAYER_ID) {
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");
	}

	if (playerData[targetid][pFaction] != playerData[playerid][pFaction])
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�����������ǹ˹�觢ͧ�������͡�������ǡѺ�س");

	new factionid = Faction_GetID(playerData[playerid][pFaction]);

    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "   �س��ź %s �͡�ҡ \"%s\"", ReturnRealName(targetid), Faction_GetName(factionid));
    SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "   %s ��ź�س�͡�ҡ�������͡���� \"%s\"", ReturnRealName(playerid), Faction_GetName(factionid));

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
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ����Ҫԡ�ͧ�������͡����");

	if (playerData[playerid][pFactionRank] > 3)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö�����觹����!");

	new factionid = Faction_GetID(playerData[playerid][pFaction]);

	if (sscanf(params, "ud", targetid, rankid))
	    return SendClientMessageEx(playerid, COLOR_GRAD1, "�����: /giverank [�ʹռ�����/���ͺҧ��ǹ] [�� (1-%d)]", factionData[factionid][fMaxRanks]);

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if (targetid == playerid)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö��Ѻ�ȵ���ͧ��");

	if (playerData[targetid][pFaction] != playerData[playerid][pFaction])
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�����������ǹ˹�觢ͧ�������͡�������ǡѺ�س");

	if (rankid < 0 || rankid > factionData[factionid][fMaxRanks])
	    return SendClientMessageEx(playerid, COLOR_GRAD1, "   �ȷ���к����١��ͧ �ȵ�ͧ���������ҧ 1 �֧ %d", factionData[factionid][fMaxRanks]);

	if(playerData[targetid][pFactionRank] >= rankid)
	{
	    playerData[targetid][pFactionRank] = rankid;
	    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "   �س������͹���˹� %s �� %s (%d)", ReturnRealName(targetid), Faction_GetRankName(factionid, rankid), rankid);
	    SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "   %s ������͹���˹觤س�� %s (%d)", ReturnRealName(playerid), Faction_GetRankName(factionid, rankid), rankid);
	}
	else
	{
	    playerData[targetid][pFactionRank] = rankid;
	    SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "   �س��Ŵ���˹� %s �� %s (%d)", ReturnRealName(targetid), Faction_GetRankName(factionid, rankid), rankid);
	    SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "   %s ��Ŵ���˹觤س�� %s (%d)", ReturnRealName(playerid), Faction_GetRankName(factionid, rankid), rankid);
	}

	return 1;
}


CMD:editrankname(playerid, params[])
{
	if (playerData[playerid][pFaction] == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ����Ҫԡ�ͧ�������͡����");

	if (playerData[playerid][pFactionRank] > 2)
	    return SendClientMessageEx(playerid, COLOR_GRAD1, "   �س������繼���!");

	SetPVarInt(playerid, "FactionEditID", Faction_GetID(playerData[playerid][pFaction]));
	Player_EditRanks(playerid);
	return 1;
}

Player_EditRanks(playerid) {
	new
		string[45 * MAX_FACTION_RANKS], factionid = GetPVarInt(playerid, "FactionEditID");

	for (new i = 0; i < factionData[factionid][fMaxRanks]; i ++)
		format(string, sizeof(string), "%s�� %d: "EMBED_YELLOW"%s\n", string, i + 1, factionRanks[factionid][i]);

	return Dialog_Show(playerid, PlayerEdit_RankName, DIALOG_STYLE_LIST, "�� -> ������", string, "���", "��Ѻ");
}

Dialog:PlayerEdit_RankName(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "FactionEditID");
	if (response)
	{
		SetPVarInt(playerid, "FactionEditSlot", listitem);
		return Dialog_Show(playerid, PlayerEdit_SetRankName, DIALOG_STYLE_INPUT, "�� -> ������", ""EMBED_WHITE"��: "EMBED_YELLOW"%s "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\n��سһ�͹�����������ҹ��ҧ���:", "����¹", "��Ѻ", factionRanks[id][listitem], listitem + 1);
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
			return Dialog_Show(playerid, PlayerEdit_SetRankName, DIALOG_STYLE_INPUT, "�� -> ������", ""EMBED_WHITE"��: "EMBED_YELLOW"%s "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\n��سһ�͹�����������ҹ��ҧ���:", "����¹", "��Ѻ", factionRanks[id][rank_slot], rank_slot + 1);

	    if (strlen(inputtext) < 1 || strlen(inputtext) > 20)
	        return Dialog_Show(playerid, PlayerEdit_SetRankName, DIALOG_STYLE_INPUT, "�� -> ������", ""EMBED_WHITE"��: "EMBED_YELLOW"%s "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n"EMBED_LIGHTRED"��ͼԴ��Ҵ"EMBED_WHITE": ������Ǣͧ���͵�ͧ����ӡ��� "EMBED_ORANGE"1"EMBED_WHITE" �����ҡ���� "EMBED_ORANGE"20"EMBED_WHITE"\n\n��سһ�͹�����������ҹ��ҧ���:", "����¹", "��Ѻ", factionRanks[id][rank_slot], rank_slot + 1);

		// SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹�����ȷ�� %d �ͧῤ��� %s"EMBED_YELLOW" �� %s", ReturnPlayerName(playerid), rank_slot + 1, factionData[id][fName], inputtext);
		Log(adminactionlog, INFO, "%s: ����¹�����Ȣͧ %s(%d) �ȷ�� %d �ҡ %s �� %s", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], rank_slot + 1, factionRanks[id][rank_slot], inputtext);
		format(factionRanks[id][rank_slot], 20, inputtext);
	    Faction_SaveRank(id, rank_slot);
	}
	return Player_EditRanks(playerid);
}

CMD:suit(playerid) {
	new id = Faction_GetID(playerData[playerid][pFaction]);
	if (id != -1) {

		if(!IsPlayerInRangeOfPoint(playerid, 5.0, factionData[id][fSpawnX],factionData[id][fSpawnY],factionData[id][fSpawnZ]))
			return SendClientMessage(playerid, COLOR_GRAD1, "   �س�����������ش�Դ�ͧῤ���");

		if (GetPVarType(playerid, "SkinSelection"))
			return SendClientMessage(playerid, COLOR_GRAD1, "   �س���ѧ���͡����Ф�����...");

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

		SendClientMessage(playerid, COLOR_GRAD1, "* ������ "EMBED_YELLOW"NUM4"EMBED_GRAD1" ���� "EMBED_YELLOW"NUM6"EMBED_GRAD1" ��������¹����Ф��繵�ǶѴ�");
		SendClientMessage(playerid, COLOR_GRAD1, "* ��Ҥس��ͧ�����ʡԹ����Фù����顴���� "EMBED_YELLOW"Y"EMBED_GRAD1" ������� "EMBED_YELLOW"N"EMBED_GRAD1" ����¡��ԡ");
		SendClientMessage(playerid, COLOR_GRAD2, "���й�: �س����ö����� <, >, Y, N ᷹��á�������");

		SetPVarInt(playerid, "SkinSelection", -1);
	}
	else {
		SendClientMessage(playerid, COLOR_GRAD1, "�س���������ǹ˹�觢ͧῤ���� �");
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
	//	return SendClientMessage(playerid, COLOR_LIGHTRED,"����Ѻ˹��§ҹᾷ����ҹ��");

	new targetid;
	if (sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_GRAD1, "�����: /helpup [�ʹռ�����/���ͺҧ��ǹ]");

	if (targetid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, targetid, 10.0))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "�����蹹�鹵Ѵ���������������������������س");

	if (targetid == playerid)
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "�س�������ö���Թ��õ���ͧ��");

	if (!gIsInjuredMode{targetid} || gIsDeathMode{targetid})
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "�����蹹��������Ѻ�Ҵ�����ͼ����蹹�鹵������");

	Damage_Reset(targetid);
	gIsDeathMode{targetid}=true;
	gInjuredTime[targetid]=0;
	gIsInjuredMode{targetid}=false;
	ClearAnimations(targetid);
	TogglePlayerControllable(targetid, true);

	ApplyAnimation(playerid,"MEDIC","CPR",4.1, 0, 1, 1, 0, 1, 1);
	//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s �ӡ���ѡ����п�鹿���ҧ������Ѻ %s", ReturnRealName(playerid), ReturnRealName(targetid));
	return 1;
}

CMD:cpr(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);

	if (factionType != FACTION_TYPE_MEDIC) 
		return SendClientMessage(playerid, COLOR_LIGHTRED,"����Ѻ˹��§ҹᾷ����ҹ��");

	new targetid;
	if (sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_GRAD1, "�����: /cpr [�ʹռ�����/���ͺҧ��ǹ]");

	if (targetid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, targetid, 10.0))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "�����蹹�鹵Ѵ���������������������������س");

	if (targetid == playerid)
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "�س�������ö���Թ��õ���ͧ��");

	if (!gIsInjuredMode{targetid} || gIsDeathMode{targetid})
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "�����蹹��������Ѻ�Ҵ�����ͼ����蹹�鹵������");

	Damage_Reset(targetid);
	gIsDeathMode{targetid}=false;
	gInjuredTime[targetid]=0;
	gIsInjuredMode{targetid}=false;
	ClearAnimations(targetid);
	TogglePlayerControllable(targetid, true);

	ApplyAnimation(playerid,"MEDIC","CPR",4.1, 0, 1, 1, 0, 1, 1);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s �ӡ���ѡ����п�鹿���ҧ������Ѻ %s", ReturnRealName(playerid), ReturnRealName(targetid));
	return 1;
}

CMD:heal(playerid, params[])
{
	new id, factionType = Faction_GetTypeID(playerData[playerid][pFaction]);

	if (factionType != FACTION_TYPE_MEDIC) 
		return SendClientMessage(playerid, COLOR_LIGHTRED,"����Ѻ˹��§ҹᾷ����ҹ��");

	if(sscanf(params,"u", id)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /heal [�ʹռ�����/���ͺҧ��ǹ]");

	if(id == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if(id == playerid)
		return SendClientMessage(playerid, COLOR_GRAD2, "�س�������ö�ѡ�ҵ���ͧ��");

	if (!IsPlayerNearPlayer(playerid, id, 3.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������س");

	Damage_Reset(id);
	gIsDeathMode{id}=false;
	gInjuredTime[id]=0;
	gIsInjuredMode{id}=false;
	
	SetPlayerHealthEx(id, 100.0 + playerData[id][pSHealth]);

	SendClientMessage(playerid, COLOR_YELLOW2, "INFO: �����蹹�����Ѻ��� HP ����ӹǹ�٧�ش�ͧ��");
	//SendClientMessage(playerid, COLOR_GRAD1, "�س���Ѻ�Թ $500 �ҡ����ӹ�¡��ᾷ��, ���ͧ�ҡ�س����ª��Ե�����");

	//GivePlayerMoneyEx(playerid, 500);

	return 1;
}

alias:government("gov");
CMD:government(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);

	if (factionType == 0 || factionType == FACTION_TYPE_GANG) 
		return SendClientMessage(playerid, COLOR_LIGHTRED,"   �س��ͧ����Ҫԡ�ͧ�������͡����");

    if(playerData[playerid][pFactionRank] > 2)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �س������Ѻ͹حҵ��������觹��");

	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GRAD1, "�����: /(gov)ernment [��ͤ���]");

	new factionid = Faction_GetID(playerData[playerid][pFaction]);
	SendClientMessageToAllEx(COLOR_WHITE, "{%06x}------ ������èҡ (%s) ------", factionData[factionid][fColor] >>> 8, factionData[factionid][fName]);
	SendClientMessageToAllEx(COLOR_WHITE, "*[HQ] %s: %s", ReturnRealName(playerid), params);
	SendClientMessageToAllEx(COLOR_WHITE, "{%06x}------ ������èҡ (%s) ------", factionData[factionid][fColor] >>> 8, factionData[factionid][fName]);
	return 1;
}

alias:departments("d");
CMD:departments(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	printf("%d", factionType);
	if (factionType != FACTION_TYPE_POLICE && factionType != FACTION_TYPE_MEDIC && factionType != FACTION_TYPE_GOV)
	    return SendClientMessage(playerid, COLOR_GRAD2,"   �س�������ǹ˹�觢ͧ��� !");

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: (/d)epartments [��ͤ�������Ѻ��¹͡Ἱ�]");

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
	    return SendClientMessage(playerid, COLOR_GRAD2,"   ����Ѻ���˹�ҷ����ҹ�� !");

	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid) && Vehicle_IsFaction(vehicleid, playerData[playerid][pFaction]))
	{
		if(isnull(params)) 
			return SendClientMessage(playerid, COLOR_GRAD1, "�����: /carsign [��ͤ���]");

		if(!IsValidDynamic3DTextLabel(vehicleData[vehicleid][vehSignText]))
	    {
			vehicleData[vehicleid][vehSignText] = Create3DTextLabel(params, 0xFFFFFFFF, 0.0, 0.0, 0.0, 50.0, 0, 1);
			Attach3DTextLabelToVehicle(vehicleData[vehicleid][vehSignText], vehicleid, -0.7, -1.9, -0.3);

	     	SendClientMessage(playerid, COLOR_LIGHTRED, "�����: /remove_carsign - "EMBED_WHITE" �ҡ��ҹ����");
		}
	} else SendClientMessage(playerid, COLOR_RED, "�س��ͧ������ҹ��˹Тͧ˹��§ҹ");

	return 1;
}

CMD:remove_carsign(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && factionType != FACTION_TYPE_MEDIC)
	    return SendClientMessage(playerid, COLOR_GRAD2,"   ����Ѻ���˹�ҷ����ҹ�� !");

	new vehicleid = GetPlayerVehicleID(playerid);
	if (IsPlayerInAnyVehicle(playerid)) {
		if(IsValidDynamic3DTextLabel(vehicleData[vehicleid][vehSignText]))
		{
			Delete3DTextLabel(vehicleData[vehicleid][vehSignText]);
		} else SendClientMessage(playerid, COLOR_RED, "�س������ѭ�ҳ���¡�ҹ���ҹ��˹Тͧ�س");
	} else SendClientMessage(playerid, COLOR_RED, "�س��ͧ������ҹ��˹Тͧ˹��§ҹ");

	return 1;
}

alias:suspect("su");
CMD:suspect(playerid, params[])
{
	new userid, reason[128], factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   ����Ѻ���˹�ҷ����Ǩ��ҹ�� !");

	if (sscanf(params, "u[128]", userid, reason))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "�����: /suspect [�ʹռ�����/���ͺҧ��ǹ]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GREY, "   �����蹹������� Online !");

    if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_GREY, "   �س�������ö�ԧ tezer ������ͧ��!");

	if (!IsPlayerNearPlayer(playerid, userid, 8.0))
	    return SendClientMessage(playerid, COLOR_GREY, "   �����蹹��������������س !");


	SetPlayerCriminal(userid, playerid, reason);

    return 1;
}

CMD:badge(playerid, params[])
{
	if(!playerData[playerid][pFaction])
		return SendClientMessage(playerid, COLOR_GREY, "�س���������ǹ˹�觢ͧῤ���� �");
		
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType == FACTION_TYPE_NONE || factionType == FACTION_TYPE_GANG)
	    return SendClientMessage(playerid, COLOR_GRAD2,"   ����Ѻ���˹�ҷ����ҹ�� !");
		
	new playerb, factionid = Faction_GetID(playerData[playerid][pFaction]);
	
	if(sscanf(params, "u", playerb))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "�����: /badge [�ʹռ�����/��ǹ˹�觢ͧ����]"); 
		
	if(!IsPlayerConnected(playerb))
		return SendClientMessage(playerid, COLOR_GREY, "   �����蹷��س�к�������������͡Ѻ���������");
		
	if(!IsPlayerNearPlayer(playerid, playerb, 5.0))
		return SendClientMessage(playerid, COLOR_GREY, "   �س����������������蹤����");
		
	if(playerb == playerid)
		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s ��价���Ңͧ��", ReturnRealName(playerid));
	
	else SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s �ʴ���Ңͧ�����Ѻ %s", ReturnRealName(playerid), ReturnRealName(playerb));
	
	SendClientMessage(playerb, COLOR_LIGHTBLUE, "______________________________________");
	
	SendClientMessageEx(playerb, COLOR_GRAD2, "  ����: %s", ReturnRealName(playerid));
	SendClientMessageEx(playerb, COLOR_GRAD2, "  ���˹�: %s", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]));
	SendClientMessageEx(playerb, COLOR_GRAD2, "  ˹��§ҹ: %s", Faction_GetName(factionid));
	
	SendClientMessage(playerb, COLOR_LIGHTBLUE, "______________________________________");
	return 1;
}

CMD:tazer1(playerid, params[])
{
	new userid, factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   ����Ѻ���˹�ҷ����Ǩ��ҹ�� !");

	if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "�����: /tazer1 [�ʹռ�����/���ͺҧ��ǹ]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GREY, "   �����蹹������� Online !");

    if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_GREY, "   �س�������ö�ԧ tezer ������ͧ��!");

	if (!IsPlayerNearPlayer(playerid, userid, 8.0))
	    return SendClientMessage(playerid, COLOR_GREY, "   �����蹹��������������س !");

	if (GetPlayerState(userid) != PLAYER_STATE_ONFOOT)
	    return SendClientMessage(playerid, COLOR_GREY, "   �����蹹�鹵�ͧ������躹�ҹ��˹�");

    if (BitFlag_Get(gPlayerBitFlag[userid],IS_CUFFED))
        return SendClientMessage(playerid, COLOR_GREY, "   �����蹹�鹶١�ԧ���� tezer ����");

	new randtazer = random(100);
	switch(randtazer)
	{
		case 0..9:
		{
			Mobile_GameTextForPlayer(userid, sprintf("You failed to shoot Tazed", ReturnRealName(playerid)), 3000, 3);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ���ԧ Tazer ��� %s ���������", ReturnRealName(playerid), ReturnRealName(userid));
		}
		default:
		{
			BitFlag_On(gPlayerBitFlag[userid],IS_CUFFED);

			TogglePlayerControllable(userid, false);

			ApplyAnimation(userid, "PED", "KO_skid_front", 3.0, 1, 0, 0, 0, 0); // Taking Cover
			SetPlayerDrunkLevel(playerid, 4000);
			Mobile_GameTextForPlayer(userid, sprintf("You've been ~r~Tazed~w~ by %s.", ReturnRealName(playerid)), 5000, 3);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ���ԧ tazer ��� %s �����", ReturnRealName(playerid), ReturnRealName(userid));
		}
	}

    return 1;
}

CMD:swat(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]),
        factionid = Faction_GetID(playerData[playerid][pFaction]);

	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   ����Ѻ���˹�ҷ����Ǩ��ҹ�� !");

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
			
			SendFactionTypeMessage(FACTION_TYPE_POLICE, 0x9189EFFF, "** HQ: %s %s ��������鹡�û�Ժѵ�˹�ҷ��㹢�й��! [S.W.A.T.] **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ��Ժ���������ظ�ҡ��͡����ͧ��", ReturnRealName(playerid));
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
			
			SendFactionTypeMessage(FACTION_TYPE_POLICE, 0x9189EFFF, "** HQ: %s %s ���͡�ҡ��û�Ժѵ�˹�ҷ��㹢�й��! [S.W.A.T] **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s �纵��������ظ�����͡����ͧ��", ReturnRealName(playerid));
			return 1;
		}
		//return 1;
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "�س�����������ӹѡ�ҹ���Ǩ!");

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

				SendFactionTypeMessage(FACTION_TYPE_MEDIC, 0x8D8DFFFF, "** HQ: %s %s ��������鹡�û�Ժѵ�˹�ҷ��㹢�й��! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ��Ժ���������ظ�ҡ��͡����ͧ��", ReturnRealName(playerid));
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

				SendFactionTypeMessage(FACTION_TYPE_MEDIC, 0x8D8DFFFF, "** HQ: %s %s ���͡�ҡ��û�Ժѵ�˹�ҷ��㹢�й��! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s �纵��������ظ�����͡����ͧ��", ReturnRealName(playerid));
                return 1;
			}
		}
	}

	if (factionType == FACTION_TYPE_POLICE)
	{
		if(sscanf(params,"s[12]", type))
			return SendClientMessage(playerid, COLOR_GRAD1, "�����: /duty [�ʹ���¡�÷��س��ͧ���] (��¡��: 1.��Ժѵ�˹�ҷ�������ͧẺ, 2.��Ժѵ�˹�ҷ��͡����ͧẺ)");

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

					SendFactionTypeMessage(FACTION_TYPE_POLICE, 0x9189EFFF, "** HQ: %s %s ��������鹡�û�Ժѵ�˹�ҷ��㹢�й��! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ��Ժ���������ظ�ҡ��͡����ͧ��", ReturnRealName(playerid));
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

					SendFactionTypeMessage(FACTION_TYPE_POLICE, 0x9189EFFF, "** HQ: %s %s ���͡�ҡ��û�Ժѵ�˹�ҷ��㹢�й��! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s �纵��������ظ�����͡����ͧ��", ReturnRealName(playerid));
					return 1;
				}
				//return 1;
			}
			else return SendClientMessage(playerid, COLOR_GRAD1, "�س�����������ӹѡ�ҹ���Ǩ!");
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

					SendFactionTypeMessage(FACTION_TYPE_POLICE, 0x9189EFFF, "** HQ: %s %s ��������鹡�û�Ժѵ�˹�ҷ��㹢�й��! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ��Ժ���������ظ�ҡ��͡����ͧ��", ReturnRealName(playerid));
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

					SendFactionTypeMessage(FACTION_TYPE_POLICE, 0x9189EFFF, "** HQ: %s %s ���͡�ҡ��û�Ժѵ�˹�ҷ��㹢�й��! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s �纵��������ظ�����͡����ͧ��", ReturnRealName(playerid));
					return 1;
				}
				//return 1;


			}
			else return SendClientMessage(playerid, COLOR_GRAD1, "�س�����������ӹѡ�ҹ���Ǩ!");
		}
	}

    return 1;
}
CMD:callsign(playerid, params[])
{

 	if (playerData[playerid][pFaction] == 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ����Ҫԡ�ͧ�������͡����");

    new factionid = Faction_GetID(playerData[playerid][pFaction]);

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /callsign [��ͤ���]");

   // if (BitFlag_Get(gPlayerBitFlag[playerid], TOGGLE_FACTION))
	//	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�Դ�����ҹ᪷�ͧ�������͡������͹");

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
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ��Ժ���������ظ�ҡ��͡����ͧ��", ReturnRealName(playerid));
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
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s �纵��������ظ�����͡����ͧ��", ReturnRealName(playerid));
                return 1;
			}
		}
		else return SendClientMessage(playerid, COLOR_GRAD1, "�س�����������ش duty");
	}

	if (factionType == FACTION_TYPE_POLICE)
	{
		if(sscanf(params,"s[12]", type))
			return SendClientMessage(playerid, COLOR_GRAD1, "�����: /duty [�ʹ���¡�÷��س��ͧ���] (��¡��: 1.��Ժѵ�˹�ҷ�������ͧẺ, 2.��Ժѵ�˹�ҷ��͡����ͧẺ)");

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
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ��Ժ���������ظ�ҡ��͡����ͧ��", ReturnRealName(playerid));
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
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s �纵��������ظ�����͡����ͧ��", ReturnRealName(playerid));
					return 1;
				}
				//return 1;
			}
			else return SendClientMessage(playerid, COLOR_GRAD1, "�س�����������ӹѡ�ҹ���Ǩ!");
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
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ��Ժ���������ظ�ҡ��͡����ͧ��", ReturnRealName(playerid));
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
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s �纵��������ظ�����͡����ͧ��", ReturnRealName(playerid));
					return 1;
				}
				//return 1;
				
			
			}
			else return SendClientMessage(playerid, COLOR_GRAD1, "�س�����������ӹѡ�ҹ���Ǩ!");
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

				SendFactionTypeMessage(FACTION_TYPE_NEWS, 0x8D8DFFFF, "** HQ: %s %s ��������鹡�û�Ժѵ�˹�ҷ��㹢�й��! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ��Ժ�����С��ͧ�ҡ��͡����ͧ��", ReturnRealName(playerid));
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

				SendFactionTypeMessage(FACTION_TYPE_NEWS, 0x8D8DFFFF, "** HQ: %s %s ���͡�ҡ��û�Ժѵ�˹�ҷ��㹢�й��! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s �纵����С��ͧ�ҡ��͡����ͧ��", ReturnRealName(playerid));
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
	    return SendClientMessage(playerid, COLOR_GRAD2,"   ����Ѻ���˹�ҷ����Ǩ��ҹ�� !");

	if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "�����: /untezer [�ʹռ�����/���ͺҧ��ǹ]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GREY, "   �����蹹������� Online !");

    /*if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_GREY, "   �س�������ö¡��ԡ����ԧ����ͧ��");*/

    if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendClientMessage(playerid, COLOR_GREY, "   �����蹹��������������س !");

    if (!BitFlag_Get(gPlayerBitFlag[userid],IS_CUFFED))
        return SendClientMessage(playerid, COLOR_GREY, "   �����蹹�������١�ԧ tezer");

    BitFlag_Off(gPlayerBitFlag[userid],IS_CUFFED);
    //SetPlayerSpecialAction(userid, SPECIAL_ACTION_NONE);
    //RemovePlayerAttachedObject(userid, FREESLOT9);
	TogglePlayerControllable(userid, true);

	Mobile_GameTextForPlayer(userid, sprintf("You've been ~g~untazer~w~ by %s.", ReturnRealName(playerid)), 5000, 3);

	if(gPlayerDrag[userid] == playerid) {
		gPlayerDrag[userid] = INVALID_PLAYER_ID;
	}

    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ¡��ԡ����ԧ tazer ���� %s", ReturnRealName(playerid), ReturnRealName(userid));
	SetPlayerDrunkLevel(playerid, 0);
    return 1;
}
CMD:cuff(playerid, params[])
{
	new userid, factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   ����Ѻ���˹�ҷ����Ǩ��ҹ�� !");

	if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "�����: /cuff [�ʹռ�����/���ͺҧ��ǹ]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GREY, "   �����蹹������� Online !");

    if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_GREY, "   �س�������ö���ح���͵���ͧ��!");

	if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendClientMessage(playerid, COLOR_GREY, "   �����蹹��������������س !");

    /*if (!BitFlag_Get(gPlayerBitFlag[playerid], IS_TAZERED) && GetPlayerSpecialAction(userid) != SPECIAL_ACTION_HANDSUP && !IsPlayerIdle(userid))
	    return SendClientMessage(playerid, COLOR_GREY, "   �����蹹�鹵�ͧ�����ʶҹз�������Ѵ�׹");*/

	if (GetPlayerState(userid) != PLAYER_STATE_ONFOOT)
	    return SendClientMessage(playerid, COLOR_GREY, "   �����蹹�鹵�ͧ������躹�ҹ��˹�");

    if (BitFlag_Get(gPlayerBitFlag[userid],IS_CUFFED))
        return SendClientMessage(playerid, COLOR_GREY, "   �����蹹�鹶١���ح��������");

    BitFlag_On(gPlayerBitFlag[userid],IS_CUFFED);
    //SetPlayerSpecialAction(userid, SPECIAL_ACTION_CUFFED);
    //SetPlayerAttachedObject(userid, FREESLOT9, 19418, 6, -0.011000, 0.028000, -0.022000, -15.600012, -33.699977, -81.700035, 0.891999, 1.000000, 1.168000);

	TogglePlayerControllable(userid, false);
	//ApplyAnimation(userid, "ped", "cower", 3.0, 1, 0, 0, 0, 0); // Taking Cover

	Mobile_GameTextForPlayer(userid, sprintf("You've been ~r~cuffed~w~ by %s.", ReturnRealName(playerid)), 5000, 3);

    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ��Ѻ�����ͤ���鹢ͧ %s ���ҧ�Ѵ�����������ح����", ReturnRealName(playerid), ReturnRealName(userid));
    return 1;
}

CMD:uncuff(playerid, params[])
{
	new userid, factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   ����Ѻ���˹�ҷ����Ǩ��ҹ�� !");

	if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "�����: /uncuff [�ʹռ�����/���ͺҧ��ǹ]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GREY, "   �����蹹������� Online !");

    if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_GREY, "   �س�������ö�Ŵ�ح���͵���ͧ��");

    if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendClientMessage(playerid, COLOR_GREY, "   �����蹹��������������س !");

    if (!BitFlag_Get(gPlayerBitFlag[userid],IS_CUFFED))
        return SendClientMessage(playerid, COLOR_GREY, "   �����蹹�������١���ح����");

    BitFlag_Off(gPlayerBitFlag[userid],IS_CUFFED);
    //SetPlayerSpecialAction(userid, SPECIAL_ACTION_NONE);
    //RemovePlayerAttachedObject(userid, FREESLOT9);
	TogglePlayerControllable(userid, true);

	Mobile_GameTextForPlayer(userid, sprintf("You've been ~g~uncuffed~w~ by %s.", ReturnRealName(playerid)), 5000, 3);

	if(gPlayerDrag[userid] == playerid) {
		gPlayerDrag[userid] = INVALID_PLAYER_ID;
	}

    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ��ح�������Ѻ�����ͧ͢ %s", ReturnRealName(playerid), ReturnRealName(userid));
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
	    return SendClientMessage(playerid, COLOR_GRAD2,"   ����Ѻ���˹�ҷ����ҹ�� !");

	if (sscanf(params, "u", userid))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "�����: /putincar [�ʹռ�����/���ͺҧ��ǹ]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 10.0))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "�����蹹�鹵Ѵ���������������������������س");

	if (userid == playerid)
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "�س�������ö����͹���µ���ͧ���ö��");

	for(new i=0;i!=MAX_VEHICLES;i++) if (GetPlayerVehicleID(playerid) == i || IsPlayerNearBoot(playerid, i, 3.0))
	{
	    seatid = GetAvailableSeat(i, 2);

	    if (seatid == -1)
	        return SendClientMessage(playerid, COLOR_LIGHTRED, "����շ����ҧ����Ѻ�����蹹��");

		PutPlayerInVehicle(userid, i, seatid);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ����͹���µ�� %s ��麹 %s", ReturnRealName(playerid), ReturnRealName(userid), g_arrVehicleNames[GetVehicleModel(i) - 400]);
		//TogglePlayerControllable(userid, true);
		return 1;
	}
	SendClientMessage(playerid, COLOR_LIGHTRED, "�س��ͧ�������������������ҹ��˹�");
	return 1;
}

alias:megaphone("m");
CMD:megaphone(playerid,params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid) && Vehicle_IsFaction(vehicleid, playerData[playerid][pFaction]))
	{
	 	if (isnull(params)) return SendClientMessage(playerid, COLOR_LIGHTRED, "�����: (/m)egaphone [᪷]");

		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE || factionType == FACTION_TYPE_MEDIC)
			SendNearbyMessage(playerid, 60.0, COLOR_YELLOW, "[ %s:o< %s ]", ReturnRealName(playerid), params);
		else
			SendClientMessage(playerid, COLOR_GRAD2, "   ����Ѻ���˹�ҷ����ҹ��!");
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "�س�е�ͧ�����ö�Ҵ����ǹ�ͧ���Ǩ!");
    return 1;
}

CMD:drag(playerid, params[]) {

	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   ����Ѻ���˹�ҷ����Ǩ��ҹ�� !");

	foreach(new i : Player) {
		if(gPlayerDrag[i] == playerid) {
			gPlayerDrag[i] = INVALID_PLAYER_ID;
			SendClientMessageEx(playerid, COLOR_WHITE, "�س����ش�ҡ��� %s", ReturnRealName(i));
			return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s ����ش�ҡ��� %s ��� �����������������", ReturnRealName(playerid), ReturnRealName(i));
		}
	}

	new
		targetid;
		
	if(sscanf(params, "u", targetid))
		SendClientMessage(playerid, COLOR_LIGHTRED, "�����: /drag [�ʹռ�����/���ͺҧ��ǹ] (���ա����������ش)");

	else if(BitFlag_Get(gPlayerBitFlag[targetid], IS_CUFFED) || BitFlag_Get(gPlayerBitFlag[targetid], IS_TAZERED)) {
		if(IsPlayerNearPlayer(playerid, targetid, 2.5)) {
			if(!IsPlayerInAnyVehicle(targetid) && !IsPlayerInAnyVehicle(playerid)) {

				gPlayerDrag[targetid] = playerid;

				SendClientMessageEx(playerid, COLOR_WHITE, "�س���ѧ�ҡ��� %s", ReturnRealName(targetid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s ����ҵ�� %s ����ҡ�����", ReturnRealName(playerid), ReturnRealName(targetid));
			}
			else SendClientMessage(playerid, COLOR_GREY, "��駤س����Ҩ��������ö�ҡ���ҡ�������㹾�˹�");
		}
		else SendClientMessage(playerid, COLOR_GREY, "�����蹹���������Թ�");
	}
	else SendClientMessage(playerid, COLOR_GREY, "�����蹨й�鹨ж١�ҡ��������Ҩе�ͧ�١���ح�������Ͷ١��͵");
	return 1;
}

CMD:wanted(playerid, params[]) {

	new str[1024];
	foreach(new i : Player) if(playerData[i][pWarrants] > 0) {
		format(str, sizeof(str), "%s\n%s(%d) | %d", str, ReturnRealName(i), i, playerData[i][pWarrants]);
	}
	Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "MDC: ����ͧ��", str, "�Դ", "");
	return 1;
}

CMD:arrest(playerid, params[])
{
	new id, cell, time, fine;

	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   ����Ѻ���˹�ҷ����Ǩ��ҹ�� !");

	// if(!playerData[playerid][pOnDuty]) return SendClientMessage(playerid, COLOR_GRAD1,"   �س�ѧ������������Ժѵ�˹�ҷ��");

	if(IsPlayerInRangeOfPoint(playerid, 6.0, 227.4311,114.2517,999.0156) || IsPlayerInRangeOfPoint(playerid, 6.0, 227.2659,114.3330,999.0156) || IsPlayerInRangeOfPoint(playerid, 6.0, 190.7101,179.1334,1003)) { // LSPD
		if(sscanf(params,"uddd",id,cell,time,fine)) return SendClientMessage(playerid, COLOR_LIGHTRED, "�����: /arrest [�ʹռ�����/���ͺҧ��ǹ] [��ͧ�ѧ(1-4)] [����(�ҷ�)] [��һ�Ѻ]");
		
		if(id == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

		if (id == playerid) return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö�ѧ����ͧ��");
		if (!IsPlayerNearPlayer(playerid, id, 5.0)) return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������س");

		if(cell < 1 || cell > 5) return SendClientMessage(playerid, COLOR_GRAD2, "��ͧ�ѧ��ͧ����ӡ��� 1 �����ҡ���� 4");
		if(fine < 0 || fine > 500000) return SendClientMessage(playerid, COLOR_GRAD2, "��һ�Ѻ��ͧ����Թ $500,000 ���͵�ӡ��� $0");
		if(time < 1 || time > 240) return SendClientMessage(playerid, COLOR_GRAD2, "���ҵ�ͧ����ҡ���� 240 �ҷ����͵�ӡ��� 1 �ҷ�");

		if(playerData[id][pJailed] == 2) return SendClientMessage(playerid, COLOR_LIGHTRED, "�����蹹����١�Ѻ����");

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
		SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_LIGHTBLUE, "[��ͧ�ѧ] %s %s �����ѧ %s ���� %d �ҷ�", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid), ReturnRealName(id), time);

		SendClientMessageEx(id, COLOR_LIGHTRED, "[ ! ] ���¤�һ�Ѻ $%d", fine, time);
		SendClientMessage(id, COLOR_LIGHTRED, "[ ! ] ����͹: �س����㹤ء�ѧ������Ѿ��ͧ�س�֧�١�Դ�����������Դ����ͧ������͡�ҡ�ء");
	}
	else SendClientMessage(playerid, COLOR_LIGHTRED, "�س���������˹����ͧ�ѧ");

	return 1;
}

CMD:revoke(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE)
	    return SendClientMessage(playerid, COLOR_GRAD2,"   ����Ѻ���˹�ҷ����Ǩ��ҹ�� !");

	new userid, type[24];

	if(sscanf(params,"us[24]", userid, type)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "�����: /revoke [�ʹռ�����/���ͺҧ��ǹ] [㺢Ѻ���,�Թᴧ,���ظ,�Թ�׹]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if (!IsPlayerNearPlayer(playerid, userid, 4.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������س");

	if(!strcmp(type, "㺢Ѻ���", true))
	{
		SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "* %s ���ִ�͹سҵ�Ѻ���ͧ %s �", ReturnRealName(playerid), ReturnRealName(userid));
		SendClientMessageEx(userid, COLOR_WHITE, "�͹حҵ�Ѻ���ͧ�س�١�ԡ�͹�� %s", ReturnRealName(playerid));
		playerData[userid][pCarLic] = false;
		return 1;
	}

	else if(!strcmp(type, "�Թᴧ", true))
	{
		SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "* %s ���ִ�Թᴧ�ͧ %s �", ReturnRealName(playerid), ReturnRealName(userid));
		SendClientMessageEx(userid, COLOR_WHITE, "�Թᴧ���س�շ������١�ִ�� %s", ReturnRealName(playerid));
		playerData[userid][pRMoney] = 0;

		return 1;
	}

	else if(!strcmp(type, "���ظ", true))
	{
		SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "* %s ���ִ���ظ�ҡ %s", ReturnRealName(playerid), ReturnRealName(userid));
		SendClientMessageEx(userid, COLOR_WHITE, "���ظ�ͧ�س�������١�ִ�� %s", ReturnRealName(playerid));
		FullResetPlayerWeapons(userid);

		return 1;
	}

	else if(!strcmp(type, "�Թ�׹", true))
	{
		SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "* %s ���ִ�Թ�׹�ҡ %s", ReturnRealName(playerid), ReturnRealName(userid));
		SendClientMessageEx(userid, COLOR_WHITE, "�Թ�׹�ͧ�س�������١�ִ�� %s", ReturnRealName(playerid));
		playerData[userid][pMaterials] = 0;

		return 1;
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "�����: /revoke [�ʹռ�����/���ͺҧ��ǹ] [㺢Ѻ���,�Թᴧ,���ظ,�Թ�׹]");

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

