#include <YSI\y_hooks>

#define MAX_OWN_BIZ             			1
#define MAX_BIZS                 			100
#define	BIZ_WORLD			    			10000

#define BUSINESS_TYPE_NONE      			0
#define BUSINESS_TYPE_STORE     			1
#define BUSINESS_TYPE_GAS       			2
#define BUSINESS_TYPE_BANK					3
#define BUSINESS_TYPE_CLOTH					4
#define BUSINESS_TYPE_DEALERSHIP			5
#define BUSINESS_TYPE_RESTAURANT			6
#define BUSINESS_TYPE_ADVERTISEMENT			7

enum businessE
{
	bID,
	bPickup,
	Float:bPosX,
	Float:bPosY,
	Float:bPosZ,
	bPosInt,
	bPosWorld,
	Float:bIntX,
	Float:bIntY,
	Float:bIntZ,
	bIntInt,
	bIntWorld,
	bInfo[128],
	bOwner[MAX_PLAYER_NAME],
	bool:bOwned,
	bLocked,
	bPrice,
	bLevelbuy,
	bCash,
	bAreaExt,
	bAreaInt,
    bEntranceCost,
    bType,
	bMapIcon
};

new businessData[MAX_BIZS][businessE];

new Iterator:Iter_Business<MAX_BIZS>;

new nearBusiness_var[MAX_PLAYERS];
new insideBusinessID[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
	nearBusiness_var[playerid]=
	insideBusinessID[playerid]=-1;
	return 1;
}

hook OnGameModeInit() {
	mysql_tquery(dbCon, "SELECT * FROM `business`", "Business_Load", "");
	return 1;
}

forward Business_Load();
public Business_Load() {

    new
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_BIZS)
	{
        cache_get_value_name_int(i, "business_id", businessData[i][bID]);
        cache_get_value_name_float(i, "posX", businessData[i][bPosX]);
        cache_get_value_name_float(i, "posY", businessData[i][bPosY]);
        cache_get_value_name_float(i, "posZ", businessData[i][bPosZ]);
        cache_get_value_name_int(i, "posInt", businessData[i][bPosInt]);
		cache_get_value_name_int(i, "posWorld", businessData[i][bPosWorld]);

        cache_get_value_name_float(i, "extX", businessData[i][bIntX]);
        cache_get_value_name_float(i, "extY", businessData[i][bIntY]);
        cache_get_value_name_float(i, "extZ", businessData[i][bIntZ]);
        cache_get_value_name_int(i, "extInt", businessData[i][bIntInt]);
		cache_get_value_name_int(i, "extWorld", businessData[i][bIntWorld]);
				
        cache_get_value_name(i, "info", businessData[i][bInfo], 128);
		cache_get_value_name(i, "owner", businessData[i][bOwner], MAX_PLAYER_NAME);

        cache_get_value_name_bool(i, "owned", businessData[i][bOwned]);
        cache_get_value_name_int(i, "locked", businessData[i][bLocked]);
        cache_get_value_name_int(i, "marketPrice", businessData[i][bPrice]);
        cache_get_value_name_int(i, "levelBuy", businessData[i][bLevelbuy]);
		cache_get_value_name_int(i, "cash", businessData[i][bCash]);
        cache_get_value_name_int(i, "entranceCost", businessData[i][bEntranceCost]);
        cache_get_value_name_int(i, "type", businessData[i][bType]);

        Iter_Add(Iter_Business, i);

		businessData[i][bPickup] = CreateDynamicPickup(businessData[i][bOwned] ? 1239 : 1272, 23, businessData[i][bPosX], businessData[i][bPosY], businessData[i][bPosZ], 0, 0);
        Streamer_SetIntData(STREAMER_TYPE_PICKUP, businessData[i][bPickup], E_STREAMER_EXTRA_ID, i);

		businessData[i][bAreaExt] = CreateDynamicSphere(businessData[i][bPosX], businessData[i][bPosY], businessData[i][bPosZ], 3.0, businessData[i][bPosWorld], businessData[i][bPosInt]); // The business exterior.
		Streamer_SetIntData(STREAMER_TYPE_AREA, businessData[i][bAreaExt], E_STREAMER_EXTRA_ID, i);

        if(businessData[i][bIntX] != 0.0 && businessData[i][bIntY] != 0.0) {
			businessData[i][bAreaInt] = CreateDynamicSphere(businessData[i][bIntX], businessData[i][bIntY], businessData[i][bIntZ], 3.0, businessData[i][bIntWorld], businessData[i][bIntInt]); // The business interior.
			Streamer_SetIntData(STREAMER_TYPE_AREA, businessData[i][bAreaInt], E_STREAMER_EXTRA_ID, i);
		}

		BusinessMapIcon(i);

		/*format(msg, sizeof(msg), "SELECT * FROM `business_furnitures` WHERE `businessid` = %d", businessData[i][bID]);
		mysql_pquery(dbCon, msg, "OnBusinessFurnituresLoad", "i", i);*/
	}

    printf("Business loaded (%d/%d)", Iter_Count(Iter_Business), MAX_BIZS);
	return 1;
}

Business_Save(businessid)
{
    if(Iter_Contains(Iter_Business, businessid)) {
        new query[MAX_STRING];
        MySQLUpdateInit("business", "business_id", businessData[businessid][bID], MYSQL_UPDATE_TYPE_THREAD); 
        MySQLUpdateInt(query, "business_id", businessData[businessid][bID]);
        MySQLUpdateFlo(query, "posX", businessData[businessid][bPosX]);
        MySQLUpdateFlo(query, "posY", businessData[businessid][bPosY]);
        MySQLUpdateFlo(query, "posZ", businessData[businessid][bPosZ]);
        MySQLUpdateInt(query, "posInt", businessData[businessid][bPosInt]);
		MySQLUpdateInt(query, "posWorld", businessData[businessid][bPosWorld]);
        MySQLUpdateFlo(query, "extX", businessData[businessid][bIntX]);
        MySQLUpdateFlo(query, "extY", businessData[businessid][bIntY]);
        MySQLUpdateFlo(query, "extZ", businessData[businessid][bIntZ]);
        MySQLUpdateInt(query, "extInt", businessData[businessid][bIntInt]);
		MySQLUpdateInt(query, "extWorld", businessData[businessid][bIntWorld]);
        MySQLUpdateStr(query, "info", businessData[businessid][bInfo]);
		MySQLUpdateStr(query, "owner", businessData[businessid][bOwner]);
        MySQLUpdateBool(query, "owned", businessData[businessid][bOwned]);
        MySQLUpdateInt(query, "locked", businessData[businessid][bLocked]);
        MySQLUpdateInt(query, "marketPrice", businessData[businessid][bPrice]);
        MySQLUpdateInt(query, "levelBuy", businessData[businessid][bLevelbuy]);
		MySQLUpdateInt(query, "cash", businessData[businessid][bCash]);
        MySQLUpdateInt(query, "entranceCost", businessData[businessid][bEntranceCost]);
        MySQLUpdateInt(query, "type", businessData[businessid][bType]);
		MySQLUpdateFinish(query);
    }
	return 1;
}

hook OP_EnterDynamicArea(playerid, areaid)
{
	new b = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID);
	if(Iter_Contains(Iter_Business, b)) {
		if(areaid == businessData[b][bAreaInt] ||  areaid == businessData[b][bAreaExt]) {
			nearBusiness_var[playerid] = b;
		}
	}
	return 1;
}

hook OP_LeaveDynamicArea(playerid, areaid) {
	new b = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID);
	if(Iter_Contains(Iter_Business, b)) {
		if(areaid == businessData[b][bAreaInt] ||  areaid == businessData[b][bAreaExt]) {
	        nearBusiness_var[playerid] = -1;
		}
	}
	return 1;
}

CMD:businesshelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
	SendClientMessage(playerid, COLOR_WHITE,"*** Business HELP *** �������������Ѻ��������������������");
	SendClientMessage(playerid, COLOR_GRAD3,"*** Business *** /mybusiness");
	SendClientMessage(playerid, COLOR_GRAD3,"*** Business *** /lock");
	// SendClientMessage(playerid, COLOR_GRAD3,"*** Other *** /furniture /grantbuild");
	return 1;
}

CMD:mybusiness(playerid, params[])
{
    new option[10], param2[128];
	new business = nearBusiness_var[playerid] == -1 ? insideBusinessID[playerid] : nearBusiness_var[playerid];

	if (business != -1 && IsBusinessOwner(playerid, business))
	{
		if(sscanf(params, "s[10]S()[128]", option, param2)) {
			SendClientMessage(playerid, COLOR_GRAD1, "�����: /mybusiness [������͡]");
			SendClientMessage(playerid, COLOR_GRAD2, "[������͡] �Թʴ | ������");
			return 1;
		}
    	if(!strcmp(option, "������", true))
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "�����Ÿ�áԨ: ��áԨ�ʹ� - %d �Ҥҵ�Ҵ - $%d", businessData[business][bID], businessData[business][bPrice]);
		}
		else if(!strcmp(option, "�Թʴ", true))
		{
			if (insideBusinessID[playerid] != -1 && insideBusinessID[playerid] == business) {
				new amount;
				if(sscanf(param2, "s[10]d", option, amount))
				{
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /mybusiness �Թʴ [�͹/�ҡ] [�ӹǹ]");
					SendClientMessageEx(playerid, COLOR_GRAD1, "�س�� $%d ����㹡��ͧ�Թʴ", businessData[business][bCash]);
					return 1;
				}

				if(!strcmp(option, "�͹", true))
				{
					if (amount > businessData[business][bCash] || amount < 1) 
						return SendClientMessage(playerid, COLOR_GRAD1, "�س��������ҡ��Ҵ���!");

					playerData[playerid][pCash] += amount;
					businessData[business][bCash] -= amount;

					SendClientMessageEx(playerid, COLOR_GRAD1, "�س�͹ $%d �ҡ���ͧ�Թʴ �ʹ�������: $%d ", amount, businessData[business][bCash]);
				}
				else if(!strcmp(option, "�ҡ", true))
				{
					if (amount > playerData[playerid][pCash] || amount < 1)
						return SendClientMessage(playerid, COLOR_GRAD1, "�س��������ҡ��Ҵ���!");

					playerData[playerid][pCash] -= amount;
					businessData[business][bCash] += amount;
					SendClientMessageEx(playerid, COLOR_GRAD1, "�س���ҧ $%d 㹡��ͧ�Թʴ�ͧ�س �ʹ���������: $%d ", amount, businessData[business][bCash]);
				}
				else {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /mybusiness �Թʴ [�͹/�ҡ] [�ӹǹ]");
				}
			}
			else SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ����㹸�áԨ���س����Ңͧ");
		}
		else {
			SendClientMessage(playerid, COLOR_GRAD1, "�����: /mybusiness [������͡]");
			SendClientMessage(playerid, COLOR_GRAD2, "[������͡] �Թʴ | ������");
		}
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ����㹺���ǳ��áԨ���س����Ңͧ");
	return 1;
}

flags:businesscmds(CMD_MANAGEMENT);
CMD:businesscmds(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GRAD1, "�����: /makebusiness, /businessenter, /businessexit, /gotobusiness, /editbusiness, /viewbusiness");
	return 1;
}

#define	BUSINESS_MAX_TYPE	7

ShowAllBusinessType(playerid) {
	SendClientMessage(playerid, COLOR_GRAD2, "[������] 0: �����, 1: ��ҹ���, 2: ��������ѹ, 3: ��Ҥ��, 4: ��ҹ�������ͼ��, 5: ���᷹��˹���ö¹��, 6: ��ҹ�����, 7: �ɳ�");
}

flags:makebusiness(CMD_MANAGEMENT);
CMD:makebusiness(playerid, params[])
{
	new businessid, buylevel, price, type, hinfo[128];
	if(sscanf(params,"ddds[128]", type, buylevel, price, hinfo)) {
        SendClientMessage(playerid, COLOR_GRAD1, "�����: /makebusiness [������] [�����] [�Ҥ�] [��������´]");
        ShowAllBusinessType(playerid);
		return 1;
	}

	if(type < 0 || type > BUSINESS_MAX_TYPE) {
        SendClientMessageEx(playerid, COLOR_GRAD1, "   ��������ͧ�� 0 �֧ %d ��ҹ�� !!", BUSINESS_MAX_TYPE);
		return 1;
	}

    if((businessid = Iter_Free(Iter_Business)) != -1) {

		new 
			pint=GetPlayerInterior(playerid), 
			pworld=GetPlayerVirtualWorld(playerid);

		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);

		businessData[businessid][bPosX] = x;
		businessData[businessid][bPosY] = y;
		businessData[businessid][bPosZ] = z;
		businessData[businessid][bPosInt] = pint;
		businessData[businessid][bPosWorld] = pworld;
		businessData[businessid][bIntX] = 0.0;
		businessData[businessid][bIntY] = 0.0;
		businessData[businessid][bIntZ] = 0.0;
		businessData[businessid][bIntInt] = 0;
		businessData[businessid][bIntWorld] = 0;
		businessData[businessid][bPrice] = price;
		businessData[businessid][bOwned] = false;
		businessData[businessid][bLocked] = 1;
		businessData[businessid][bCash] = 0;
		businessData[businessid][bLevelbuy] = buylevel;

        businessData[businessid][bType] = type;
	
		format(businessData[businessid][bInfo], 128, hinfo);
		format(businessData[businessid][bOwner], MAX_PLAYER_NAME, "The State");

		if(IsValidDynamicArea(businessData[businessid][bAreaExt]))
			DestroyDynamicArea(businessData[businessid][bAreaExt]);

		businessData[businessid][bAreaExt] = CreateDynamicSphere(businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 3.0, businessData[businessid][bPosWorld], businessData[businessid][bPosInt]); // The business exterior.	
		Streamer_SetIntData(STREAMER_TYPE_AREA, businessData[businessid][bAreaExt], E_STREAMER_EXTRA_ID, businessid);

		businessData[businessid][bPickup] = CreateDynamicPickup(businessData[businessid][bOwned] ? 1239 : 1272, 23, businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 0, 0);
        Streamer_SetIntData(STREAMER_TYPE_PICKUP, businessData[businessid][bPickup], E_STREAMER_EXTRA_ID, businessid);

		new query[256];
		mysql_format(dbCon, query, sizeof query, "INSERT INTO `business` (`levelBuy`,`marketPrice`) VALUES(%d,%d)", buylevel, price);
		mysql_tquery(dbCon, query, "OnBusinessCreated", "ii", playerid, businessid);
    }
	else SendClientMessageEx(playerid, COLOR_LIGHTRED, "�����Դ��Ҵ: "EMBED_WHITE"�������ö���ҧ��áԨ���ҡ���ҹ������ �ӡѴ����� "EMBED_ORANGE"%d", MAX_BIZS);

	return 1;
}

forward OnBusinessCreated(playerid, businessid);
public OnBusinessCreated(playerid, businessid)
{
	new insert_id = cache_insert_id();
	if(insert_id) {

		Iter_Add(Iter_Business, businessid);
		businessData[businessid][bID] = insert_id;
		Business_Save(businessid);

		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s �����ҧ��áԨ�ʹ� %d", ReturnPlayerName(playerid), businessData[businessid][bID]);
	}
	else {
		if(IsValidDynamicArea(businessData[businessid][bAreaExt]))
			DestroyDynamicArea(businessData[businessid][bAreaExt]);
		if(IsValidDynamicPickup(businessData[businessid][bPickup]))
			DestroyDynamicPickup(businessData[businessid][bPickup]);
		SendClientMessage(playerid, COLOR_LIGHTRED, "�����Դ��Ҵ: "EMBED_WHITE"�������ö���������Ÿ�áԨŧ�ҹ�������� �ô�Դ��� DEV");
	}
	return 1;
}

CountPlayerOwnBusiness(playerid)
{
	new hcount;
	foreach(new i : Iter_Business)
	{
		if(businessData[i][bOwned] && IsBusinessOwner(playerid, i)) hcount++;
	}
	return hcount;
}

CMD:buybiz(playerid, params[])
{
	new confirm[8], b = -1;

	if ((b = nearBusiness_var[playerid]) != -1 && !businessData[b][bOwned]) {

		new numbusiness = CountPlayerOwnBusiness(playerid);
		new extra_price = numbusiness * 10;
		new businessprice = businessData[b][bPrice];

		if(extra_price) 
			businessprice *= extra_price;

   		if(!sscanf(params, "s[8]", confirm) && !strcmp(confirm, "yes", true)) {

			if(numbusiness >= MAX_OWN_BIZ) return SendClientMessage(playerid, COLOR_GRAD1, "�س�ո�áԨ����ӹǹ�٧�ش���� �� /sellbusiness ���͢�¸�áԨ�ͧ�س");
			if(playerData[playerid][pLevel] < businessData[b][bLevelbuy]) return SendClientMessage(playerid, COLOR_GRAD1, "�س�������ö������ѧ�������Ѿ������!");
			if(GetPlayerMoneyEx(playerid) < businessprice || businessprice <= 0) return SendClientMessage(playerid, COLOR_GRAD1, "�س�������ö������ѧ�������Ѿ������!");

			playerData[playerid][pBusinessKey] = businessData[b][bID];
			businessData[b][bOwned] = true;
			businessData[b][bLocked] = 1;
			businessData[b][bCash] = 0;
			strmid(businessData[b][bOwner], ReturnPlayerName(playerid), 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
            GivePlayerMoneyEx(playerid, -businessprice);

			SendClientMessage(playerid, COLOR_WHITE, "���ʴ������Թ��㹡����觫�������ͧ�س!");
			SendClientMessage(playerid, COLOR_WHITE, "�� /help ���͡�õ�Ǩ�ͺ�����Ҷ֧����ͧ�س  !");

			Business_Save(b);

			return 1;
		}
	 	else
	 	{
	 	    SendClientMessage(playerid, COLOR_GRAD1, "�����: /buybiz yes");
			SendClientMessageEx(playerid, COLOR_GREY, "��áԨ���س���ѧ�����Ҥ� $%d", businessprice);
	 	}
 	}
	return 1;
}

CMD:sellbusiness(playerid, params[])
{
	new confirm[8], businessid = -1;
	if ((businessid = nearBusiness_var[playerid]) != -1) {
		if(IsBusinessOwner(playerid, businessid))
		{
			new businessprice = businessData[businessid][bPrice];
			new businesstax = floatround(businessprice / 100.0);
			if(!sscanf(params, "s[8]", confirm) && !strcmp(confirm, "yes", true)) {

				new strMSG[128];

				if(businessData[businessid][bCash] > 0)
				{
					playerData[playerid][pCash] += businessData[businessid][bCash];
					SendClientMessageEx(playerid, COLOR_GRAD2, "�س���Ѻ�Թʴ�ҡ��áԨ $%d", businessData[businessid][bCash]);
				}
				businessData[businessid][bLocked] = 1;
				businessData[businessid][bOwned] = false;
				businessData[businessid][bCash] = 0;

				strmid(businessData[businessid][bOwner], "The State", 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);

				playerData[playerid][pCash] += businessprice-businesstax;

				//PlayerPlaySoundEx(playerid, 1052);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				format(strMSG, sizeof(strMSG), "~w~Congratulations~n~ You have sold your property for ~n~~g~$%d", businessprice-businesstax);
				GameTextForPlayer(playerid, strMSG, 10000, 3);
				SendClientMessageEx(playerid, COLOR_GRAD3, "���բͧ�Ѱ: $%d", businesstax);

				Business_Save(businessid);

				playerData[playerid][pBusinessKey] = 0;

				return 1;
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD1, "�����: /sellbusiness yes");
				SendClientMessageEx(playerid, COLOR_GREY, "��áԨ���س���ѧ����Ҥ� $%d ��������� $%d", businessprice, businesstax);
			}
		}
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ����㹸�áԨ�������Ңͧ");
	return 1;
}

Business_GetID(businessid) {
	foreach(new i : Iter_Business) {
		if(businessData[i][bID] == businessid) {
			return i;
		}
	}
	return -1;
}

flags:businessenter(CMD_MANAGEMENT);
CMD:businessenter(playerid,params[])
{
	new hid = -1;
	if(sscanf(params,"d",hid)) {
        return SendClientMessage(playerid, COLOR_GRAD1, "�����: /businessenter [�ʹո�áԨ]");
	}
	new businessid = Business_GetID(hid);
	
	if(!Iter_Contains(Iter_Business, businessid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   �ʹո�áԨ���١��ͧ !!");

	new Float:px,Float:py,Float:pz;
	GetPlayerPos(playerid, px, py, pz);

	new 
		pint=GetPlayerInterior(playerid), 
		pworld=GetPlayerVirtualWorld(playerid);

	businessData[businessid][bPosX] = px;
	businessData[businessid][bPosY] = py;
	businessData[businessid][bPosZ] = pz;
	businessData[businessid][bPosInt] = pint;
	businessData[businessid][bPosWorld] = pworld;

	if(IsValidDynamicArea(businessData[businessid][bAreaExt]))
		DestroyDynamicArea(businessData[businessid][bAreaExt]);

	if(IsValidDynamicPickup(businessData[businessid][bPickup]))
		DestroyDynamicPickup(businessData[businessid][bPickup]);

	BusinessMapIcon(businessid);

	businessData[businessid][bAreaExt] = CreateDynamicSphere(businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 3.0, businessData[businessid][bPosWorld], businessData[businessid][bPosInt]); // The business exterior.	
	Streamer_SetIntData(STREAMER_TYPE_AREA, businessData[businessid][bAreaExt], E_STREAMER_EXTRA_ID, businessid);

	businessData[businessid][bPickup] = CreateDynamicPickup(businessData[businessid][bOwned] ? 1239 : 1272, 23, businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 0, 0);
    Streamer_SetIntData(STREAMER_TYPE_PICKUP, businessData[businessid][bAreaExt], E_STREAMER_EXTRA_ID, businessid);

	Business_Save(businessid);
	SendClientMessageEx(playerid, COLOR_GRAD1, "   ��áԨ�ʹ� %d �١��Ѻ�ҧ����������º�������� !!", businessData[businessid][bID]);
	return 1;
}

flags:businessexit(CMD_MANAGEMENT);
CMD:businessexit(playerid,params[])
{
	new hid = -1;
	if(sscanf(params,"d",hid)) {
        return SendClientMessage(playerid, COLOR_GRAD1, "�����: /businessexit [�ʹո�áԨ]");
	}
	new businessid = Business_GetID(hid);
	
	if(!Iter_Contains(Iter_Business, businessid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   �ʹո�áԨ���١��ͧ !!");

	new Float:px,Float:py,Float:pz;
	GetPlayerPos(playerid, px, py, pz);

	businessData[businessid][bIntX] = px;
	businessData[businessid][bIntY] = py;
	businessData[businessid][bIntZ] = pz;
	businessData[businessid][bIntInt] = GetPlayerInterior(playerid);
	businessData[businessid][bIntWorld] = businessData[businessid][bID] + BIZ_WORLD;
	insideBusinessID[playerid] = businessid;
	SetPlayerVirtualWorld(playerid, businessData[businessid][bIntWorld]);

	if(IsValidDynamicArea(businessData[businessid][bAreaInt]))
		DestroyDynamicArea(businessData[businessid][bAreaInt]);

	businessData[businessid][bAreaInt] = CreateDynamicSphere(businessData[businessid][bIntX], businessData[businessid][bIntY], businessData[businessid][bIntZ], 3.0, businessData[businessid][bIntWorld], businessData[businessid][bIntInt]);
	Streamer_SetIntData(STREAMER_TYPE_AREA, businessData[businessid][bAreaInt], E_STREAMER_EXTRA_ID, businessid);

	Business_Save(businessid);
	SendClientMessageEx(playerid, COLOR_GRAD1, "   ��áԨ�ʹ� %d �١��Ѻ�ҧ�͡�������º�������� !!", businessData[businessid][bID]);

	return 1;
}

IsPlayerInteractiveBusiness(playerid) {
	new id = -1;
	if ((id = insideBusinessID[playerid]) != -1 && Iter_Contains(Iter_Business, id)) return id;
	else {
		foreach(id : Iter_Business)
		{
			if(IsPlayerInRangeOfPoint(playerid, 25.0, businessData[id][bPosX],businessData[id][bPosY],businessData[id][bPosZ]) && businessData[id][bIntX] == 0.0 && businessData[id][bIntY] == 0.0) {
				return id;
			}
		}
	}
	return -1;
}

IsPlayerAtBusinessArea(playerid) {
	new id = nearBusiness_var[playerid];
	if (id != -1 && Iter_Contains(Iter_Business, id) && (IsPlayerInRangeOfPoint(playerid, 3.0, businessData[id][bIntX],businessData[id][bIntY],businessData[id][bIntZ]) || (IsPlayerInRangeOfPoint(playerid, 3.0, businessData[id][bPosX],businessData[id][bPosY],businessData[id][bPosZ]) && businessData[id][bPosX] != 0.0 && businessData[id][bPosY] != 0.0))) return true;	
	else return false;
}

IsPlayerAtBusinessEntrance(playerid) {
	new id = nearBusiness_var[playerid];
	if (id != -1 && Iter_Contains(Iter_Business, id) && IsPlayerInRangeOfPoint(playerid, 3.0, businessData[id][bPosX],businessData[id][bPosY],businessData[id][bPosZ]) && businessData[id][bPosX] != 0.0 && businessData[id][bPosY] != 0.0) return true;
	else return false;
}

IsPlayerAtBusinessExit(playerid) {
	new id = nearBusiness_var[playerid];
	if (id != -1 && Iter_Contains(Iter_Business, id) && IsPlayerInRangeOfPoint(playerid, 3.0, businessData[id][bIntX],businessData[id][bIntY],businessData[id][bIntZ])) return true;
	else return false;
}

Business_DynamicPos(playerid, world, &Float:X, &Float:Y, &Float:Z) {
	new id = insideBusinessID[playerid];
	if (Iter_Contains(Iter_Business, id) && businessData[id][bIntWorld] == world) {
		X = businessData[id][bIntX];
		Y = businessData[id][bIntY];
		Z = businessData[id][bIntZ];
		return id;
	}
	return -1;
}

PlayerLockBusiness(playerid) {
	new id = nearBusiness_var[playerid];
	if (id != -1 && Iter_Contains(Iter_Business, id) && (IsPlayerInRangeOfPoint(playerid, 3.0, businessData[id][bIntX],businessData[id][bIntY],businessData[id][bIntZ]) || (IsPlayerInRangeOfPoint(playerid, 3.0, businessData[id][bPosX],businessData[id][bPosY],businessData[id][bPosZ]) && businessData[id][bPosX] != 0.0 && businessData[id][bPosY] != 0.0)))
	{
		if(businessData[id][bLocked] == 1)
		{
			businessData[id][bLocked] = 0;
			GameTextForPlayer(playerid, "~w~Business ~g~Unlocked", 5000, 6);
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		}
		else {
			businessData[id][bLocked] = 1;
			GameTextForPlayer(playerid, "~w~Business ~r~Locked", 5000, 6);
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		}
		Business_Save(id);
	}
	return 1;
}

PlayerEnterNearestBusiness(playerid) {
	new id = nearBusiness_var[playerid];
	if (id != -1 && Iter_Contains(Iter_Business, id) && businessData[id][bPosX] != 0.0 && businessData[id][bPosY] != 0.0)
	{
		
		if(businessData[id][bLocked] == 1) 
			return GameTextForPlayer(playerid, "~r~Locked", 5000, 1);

		if (businessData[id][bIntX] != 0.0 && businessData[id][bIntY] != 0.0) {
			SetPlayerPos(playerid,businessData[id][bIntX],businessData[id][bIntY],businessData[id][bIntZ]);
			SetPlayerInterior(playerid,businessData[id][bIntInt]);
			SetPlayerVirtualWorld(playerid,businessData[id][bIntWorld]);
			playerData[playerid][pInterior] = businessData[id][bIntInt];
			playerData[playerid][pVWorld] = businessData[id][bIntWorld];
			insideBusinessID[playerid] = id;

			if(playerData[playerid][pBusinessKey] == businessData[id][bID]) return GameTextForPlayer(playerid, sprintf("~w~Welcome to ~n~%s", businessData[id][bInfo]), 5000, 1);
			else {
				ShowBusinessMessage(playerid, businessData[id][bType]);
			}
			return 1;
		}

		if(playerData[playerid][pBusinessKey] == businessData[id][bID]) return GameTextForPlayer(playerid, sprintf("~w~Welcome to ~n~%s", businessData[id][bInfo]), 5000, 1);
		else {
			ShowBusinessMessage(playerid, businessData[id][bType]);
		}
	}
	return 1;
}

ShowBusinessMessage(playerid, biztype) {
	switch(biztype) {
		case BUSINESS_TYPE_STORE: {
			SendClientMessage(playerid, COLOR_GRAD4,"*** ��áԨ��ҹ��� ***  /buy (���ͧ͢)");
		}
		case BUSINESS_TYPE_BANK: {
			SendClientMessage(playerid, COLOR_GRAD4,"*** ��Ҥ�� ***  /bank (���ͧ���ҧ����), /balance (���Թ), /deposit (�ҡ)");
			SendClientMessage(playerid, COLOR_GRAD4,"*** ��Ҥ�� ***  /withdraw (�͹), /transfer (�͹), /savings (�����Ѿ��)");
		}
		case BUSINESS_TYPE_GAS: {
			SendClientMessage(playerid, COLOR_GRAD4,"*** ��áԨ��������ѹ ***  /fill (�������ѹ)");
		}
		case BUSINESS_TYPE_CLOTH: {
			SendClientMessage(playerid, COLOR_GRAD4,"*** ��áԨ����ͼ�� ***  /buy (����¹ʡԹ����Ф� $300)");
		}
		case BUSINESS_TYPE_DEALERSHIP: {
			SendClientMessage(playerid, COLOR_GRAD4,"*** ��áԨ���᷹��˹���ö¹�� ***  /buy");
		}
		case BUSINESS_TYPE_RESTAURANT: {
			SendClientMessage(playerid, COLOR_GRAD4,"*** ��áԨ��ҹ����� ***  /eat");
		}
		case BUSINESS_TYPE_ADVERTISEMENT: {
			SendClientMessage(playerid, COLOR_GRAD4,"*** ��áԨ⦳�� ***  (/ad)vert, (/c)ompany(ad)vert");
		}
	}
	return 1;
}

PlayerExitBusiness(playerid) {
	new id = nearBusiness_var[playerid];
	if (id != -1 && Iter_Contains(Iter_Business, id) && IsPlayerInRangeOfPoint(playerid, 3.0, businessData[id][bIntX],businessData[id][bIntY],businessData[id][bIntZ])) {

		SetCameraBehindPlayer(playerid);
		SetPlayerPos(playerid,businessData[id][bPosX],businessData[id][bPosY],businessData[id][bPosZ]);
		SetPlayerInterior(playerid,businessData[id][bPosInt]);
		SetPlayerVirtualWorld(playerid,businessData[id][bPosWorld]);
		playerData[playerid][pInterior] = businessData[id][bPosInt];
		playerData[playerid][pVWorld] = businessData[id][bPosWorld];
		insideBusinessID[playerid] = -1;
		//grantbuild[playerid]=-1;
	}
	return 1;
}


flags:gotobusiness(CMD_ADM_2);
CMD:gotobusiness(playerid,params[])
{
	new hid = -1;
	if(sscanf(params,"d",hid)) {
        return SendClientMessage(playerid, COLOR_GRAD1, "�����: /gotobusiness [�ʹո�áԨ]");
	}
	new businessid = Business_GetID(hid);
	
	if(!Iter_Contains(Iter_Business, businessid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   �ʹո�áԨ���١��ͧ !!");


	SetPlayerVirtualWorld(playerid, businessData[businessid][bPosWorld]);
	SetPlayerInterior(playerid, businessData[businessid][bPosInt]);
	SetPlayerPos(playerid, businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ]);

	SendClientMessageEx(playerid, COLOR_GRAD1, "   �س��������ѧ��áԨ�ʹ� %d", businessData[businessid][bID]);
	
	return 1;
}

IsBusinessOwner(playerid, businessid)
{
	if(IsPlayerConnected(playerid) && businessid != -1 && Iter_Contains(Iter_Business, businessid)) {
		if (businessData[businessid][bOwned] && !strcmp(ReturnPlayerName(playerid), businessData[businessid][bOwner], true))
			return 1;
	}
	return 0;
}

hook OP_PickUpDynamicPickup(playerid, pickupid)
{
	new bizid = Streamer_GetIntData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_EXTRA_ID);

    if(Iter_Contains(Iter_Business, bizid)) {
            
    	if(businessData[bizid][bPickup] == pickupid) {

            new str[128];
    		if(businessData[bizid][bOwned]) {
                if (businessData[bizid][bIntX] == 0.0 && businessData[bizid][bIntY] == 0.0) {
					switch(businessData[bizid][bType]) {
						case BUSINESS_TYPE_ADVERTISEMENT: {
							format(str, sizeof(str), "~w~%s~w~~n~Owner : %s~n~~w~Level : %d ~n~type /ad or /cad",businessData[bizid][bInfo],businessData[bizid][bOwner]);
						}
						case BUSINESS_TYPE_GAS: {
							format(str, sizeof(str), "~w~%s~w~~n~Owner : %s~n~Entrance Fee : ~g~$%d ~w~Level : %d ~n~type /fill",businessData[bizid][bInfo],businessData[bizid][bOwner],businessData[bizid][bEntranceCost]);
						}					
						default: {
							format(str, sizeof(str), "~w~%s~w~~n~Owner : %s~n~Entrance Fee : ~g~$%d ~w~Level : %d ~n~type /buy",businessData[bizid][bInfo],businessData[bizid][bOwner],businessData[bizid][bEntranceCost]);
						}
					}
				}
				else {
					format(str, sizeof(str), "~w~%s~w~~n~Owner : %s~n~Entrance Fee : ~g~$%d ~w~Level : %d ~n~to enter type /enter",businessData[bizid][bInfo],businessData[bizid][bOwner],businessData[bizid][bEntranceCost]);
				}
            }
            else format(str, sizeof(str), "~w~%s~w~~n~This Business is for sale~n~Cost: ~g~$%d ~w~Level : %d ~n~to buy this Business type /buybiz",businessData[bizid][bInfo],businessData[bizid][bPrice],businessData[bizid][bLevelbuy]);
    		Mobile_GameTextForPlayer(playerid, str, 5000, 3);
    		
    		return 1;
    	}
    }
	return 1;
}

Store_Interactive(playerid, id, const params[]) {

    new itemid;
	if (Iter_Contains(Iter_Business, id)) {

		switch(businessData[id][bType]) {
			case BUSINESS_TYPE_CLOTH: {
				ShowClothingMenu(playerid);
			}
			case BUSINESS_TYPE_DEALERSHIP: {
				ShowPlayerDealershipMenu(playerid);
			}
			case BUSINESS_TYPE_RESTAURANT: {
				ShowPlayerFoodMenu(playerid);
			}
			case BUSINESS_TYPE_STORE: {
				if (sscanf(params, "d", itemid)) {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /buy [�����Ţ�����]");
					SendClientMessage(playerid, COLOR_GREEN, "|_______ ��ҹ��� _______|");
					SendClientMessage(playerid, 0xFDBFFFFF, "| 1. ���� x20 $5000     		2. ����ѹ��л�ͧ $250 (3 ��͹)");
					SendClientMessage(playerid, 0xFDBFFFFF, "| 3. ���ŧ $1500 (���૿)  		4. �Է�� $3000  5. ��⾧ Boombox $20,000");
					SendClientMessage(playerid, 0xFDBFFFFF, "| 6. ��͡ x5 $8,000        		7. ��Ӵ��� x5 $200");
					SendClientMessage(playerid, 0xFDBFFFFF, "| 8. ���ǡ��ͧ���� x5 $2,000        9. ����� x5 $500");
					return 1;
				}

				switch(itemid) {
					case 1: {
						if (GetPlayerMoneyEx(playerid) < 5000)
							return SendClientMessage(playerid, COLOR_GRAD1, "   �س���Թ���ͫ��ͤ��! ($5000)");

						GivePlayerMoneyEx(playerid, -5000);
						playerData[playerid][pItemOOC] += 20;
						SendClientMessage(playerid, COLOR_GRAD4, "�س��������觨ӹǹ 20 ���");
						SendClientMessage(playerid, COLOR_WHITE, "�� /ooc ���;ٴ��·��Ƿ����������� !");
					}
					case 2: {
						if (GetPlayerMoneyEx(playerid) < 250)
							return SendClientMessage(playerid, COLOR_GRAD1, "   �س���Թ���ͫ��ͤ��! ($250)");

						GivePlayerMoneyEx(playerid, -250);
		
						playerData[playerid][pItemGasCan]+=3;
						SendClientMessage(playerid, COLOR_GREEN, "�س����Ͷѧ����ѹ 3 ���͹");
						SendClientMessage(playerid, COLOR_WHITE, "�� /gascan �����������ѹ");
					}
					case 3: {

						if (playerData[playerid][pItemCrowbar]) 
							return SendClientMessage(playerid, COLOR_GRAD1, "   �س�ժ��ŧ����Ѻ�������!");

						if (GetPlayerMoneyEx(playerid) < 1500)
							return SendClientMessage(playerid, COLOR_GRAD1, "   �س���Թ���ͫ��ͤ��! ($1500)");

						GivePlayerMoneyEx(playerid, -1500);
		
						playerData[playerid][pItemCrowbar]=1;
						SendClientMessage(playerid, COLOR_GREEN, "�س����ͪ��ŧ 1 ���");
						SendClientMessage(playerid, COLOR_WHITE, "�� /lock breakin ���ͻŴ��͡ö");
					}
					case 4: {

						if (playerData[playerid][pRadio]) 
							return SendClientMessage(playerid, COLOR_GRAD1, "   �س���Է������ !!");

						if (GetPlayerMoneyEx(playerid) < 3000)
							return SendClientMessage(playerid, COLOR_GRAD1, "   �س���Թ���ͫ��ͤ��! ($3000)");

						GivePlayerMoneyEx(playerid, -3000);
		
						playerData[playerid][pRadio] = 1;

						SendClientMessage(playerid, COLOR_GREEN, "�س������Է�� 1 ����ͧ���§");
						SendClientMessage(playerid, COLOR_WHITE, "�� /radiohelp �����֡�Ҥ���觡����ҹ�Է��");
					}
					case 5: {

						if (playerData[playerid][pBoombox]) 
							return SendClientMessage(playerid, COLOR_GRAD1, "   �س�� Boombox ���� !!");

						if (GetPlayerMoneyEx(playerid) < 20000)
							return SendClientMessage(playerid, COLOR_GRAD1, "   �س���Թ���ͫ��ͤ��! ($20,000)");

						GivePlayerMoneyEx(playerid, -20000);
						playerData[playerid][pBoombox] = 1;
						OnAccountUpdate(playerid);

						SendClientMessage(playerid, COLOR_GREEN, "�س����� Boombox 1 ����ͧ���§");
						SendClientMessage(playerid, COLOR_WHITE, "�� /boombox �����Դ�ŧ��餹�ͺ��ҧ�ѧ !!");
					}
					case 6: {

						if (GetPlayerMoneyEx(playerid) < 10000)
							return SendClientMessage(playerid, COLOR_GRAD1, "   �س���Թ���ͫ��ͤ��! ($10,000)");

						if (playerData[playerid][pPlayingHours] < 50)
							return SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ�ժ�������͹�Ź��ҡ���� 50 �֧������ö������");

						GivePlayerMoneyEx(playerid, -10000);
						playerData[playerid][pTie] += 5;
						OnAccountUpdate(playerid);

						SendClientMessage(playerid, COLOR_GREEN, "�س�������͡�ӹǹ 5 ���");
						SendClientMessage(playerid, COLOR_WHITE, "�� /tie ��������͡�Ѵ�Ѻ�����蹤���� !!");
					}
					case 7: {

						if (GetPlayerMoneyEx(playerid) < 200)
							return SendClientMessage(playerid, COLOR_GRAD1, "   �س���Թ���ͫ��ͤ��! ($200)");

						if (playerData[playerid][pThirst] >= 70)
							return SendClientMessage(playerid, COLOR_GRAD1, "�س�ѧ�������¹�ӵ͹���");

						GivePlayerMoneyEx(playerid, -200);
						playerData[playerid][pThirst] += 30;
						OnAccountUpdate(playerid);

						SendClientMessage(playerid, COLOR_GREEN, "�س����͹�Ӵ���, �����Դ�ҹ�����ʹ������º��������");
						//SendClientMessage(playerid, COLOR_WHITE, "�� /tie ��������͡�Ѵ�Ѻ�����蹤���� !!");
					}
					case 8: {

						if (GetPlayerMoneyEx(playerid) < 2000)
							return SendClientMessage(playerid, COLOR_GRAD1, "   �س���Թ���ͫ��ͤ��! ($2,000)");

						if (playerData[playerid][pPizza] >= 5)
							return SendClientMessage(playerid, COLOR_GRAD1, "	�س�龡�Ң��ǡ��ͧ�٧�ش���س������ö���������� (Max 5)");

						GivePlayerMoneyEx(playerid, -2000);
						playerData[playerid][pPizza] = 5;
						OnAccountUpdate(playerid);

						SendClientMessage(playerid, COLOR_GREEN, "�س����͢��ǡ��ͧ����, �ҡ�س��ͧ��èе�Ǩ�ͺ�ӹǹ���ǡ��ͧ��й���顢ͧ�س����� /inv");
						//SendClientMessage(playerid, COLOR_WHITE, "�� /tie ��������͡�Ѵ�Ѻ�����蹤���� !!");
					}
					case 9: {

						if (GetPlayerMoneyEx(playerid) < 500)
							return SendClientMessage(playerid, COLOR_GRAD1, "   �س���Թ���ͫ��ͤ��! ($500)");

						if (playerData[playerid][pDrink] >= 5)
							return SendClientMessage(playerid, COLOR_GRAD1, "	�س�龡�ҹ�����٧�ش���س������ö���������� (Max 5)");

						GivePlayerMoneyEx(playerid, -500);
						playerData[playerid][pDrink] = 5;
						OnAccountUpdate(playerid);

						SendClientMessage(playerid, COLOR_GREEN, "�س����͹��������, �ҡ�س��ͧ��èе�Ǩ�ͺ�ӹǹ���ǡ��ͧ��й���顢ͧ�س����� /inv");
						//SendClientMessage(playerid, COLOR_WHITE, "�� /tie ��������͡�Ѵ�Ѻ�����蹤���� !!");
					}
					default: {
						SendClientMessage(playerid, COLOR_LIGHTRED, "   ���������������Թ��Ҫ�鹹����!");
					}
				}
			}
			case BUSINESS_TYPE_GAS: {
				if (IsPlayerInAnyVehicle(playerid)) {
					new string[256], vehicleid = GetPlayerVehicleID(playerid);
					new Float:maxfuel = GetVehicleDataFuel(GetVehicleModel(vehicleid));
					new Float:fueladd = maxfuel - vehicleData[vehicleid][vFuel];
					format(string, sizeof(string), ""EMBED_WHITE"������ԧ㹻Ѩ�غѹ:"EMBED_YELLOW"%.6f"EMBED_WHITE"/"EMBED_YELLOW"%.6f"EMBED_WHITE"( �٧�ش )\n\t�ӹǹ�������:"EMBED_YELLOW"%.6f\n\t"EMBED_WHITE"�Ҥ�:"EMBED_YELLOW"%s", vehicleData[vehicleid][vFuel], maxfuel, fueladd, FormatNumber(floatround(fueladd*float(FUEL_PRICE), floatround_ceil)));
					Dialog_Show(playerid, FuelRefill, DIALOG_STYLE_MSGBOX, "���͹���ѹ������ԧ:", string, "����", "¡��ԡ");
				} else SendClientMessage(playerid, COLOR_LIGHTRED, "�س�����������ҹ��˹�");
			}
		}
	}

    return 1;
}

Business_GetInsideID(playerid) {
	return insideBusinessID[playerid];
}

IsPlayerAtGasStation(playerid) {
	
	foreach(new i : Iter_Business)
	{
		if(businessData[i][bType] == BUSINESS_TYPE_GAS) {
			if (IsPlayerInRangeOfPoint(playerid, 2.5, businessData[i][bPosX],businessData[i][bPosY],businessData[i][bPosZ])) {
				return true;
			}
		}
	}
	return false;
}

IsPlayerAtBank(playerid) {
	foreach(new i : Iter_Business)
	{
		if(businessData[i][bType] == BUSINESS_TYPE_BANK) {
			if (IsPlayerInRangeOfPoint(playerid, 25.0, businessData[i][bIntX],businessData[i][bIntY],businessData[i][bIntZ])) {
				return true;
			}
		}
	}
	return false;
}

IsPlayerAtDealership(playerid) {
	
	foreach(new i : Iter_Business)
	{
		if(businessData[i][bType] == BUSINESS_TYPE_DEALERSHIP) {
			if (IsPlayerInRangeOfPoint(playerid, 25.0, businessData[i][bPosX],businessData[i][bPosY],businessData[i][bPosZ])) {
				return i;
			}
		}
	}
	return -1;
}

IsPlayerAtAdvert(playerid) {
	
	foreach(new i : Iter_Business)
	{
		if(businessData[i][bType] == BUSINESS_TYPE_ADVERTISEMENT) {
			if (IsPlayerInRangeOfPoint(playerid, 25.0, businessData[i][bPosX],businessData[i][bPosY],businessData[i][bPosZ])) {
				return i;
			}
		}
	}
	return -1;
}

Business_SetInside(playerid, value) {
	insideBusinessID[playerid] = value;
}

BusinessMapIcon(businessid) {
	if(Iter_Contains(Iter_Business, businessid)) {

		if (IsValidDynamicMapIcon(businessData[businessid][bMapIcon])) {
			DestroyDynamicMapIcon(businessData[businessid][bMapIcon]);
		}

		switch(businessData[businessid][bType]) {
			case BUSINESS_TYPE_STORE: {
				businessData[businessid][bMapIcon] = CreateDynamicMapIcon(businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 17, 0xFFFFFFFF, 0, 0);
			}
			case BUSINESS_TYPE_GAS: {
				businessData[businessid][bMapIcon] = CreateDynamicMapIcon(businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 63, 0xFFFFFFFF, 0, 0);
			}
			case BUSINESS_TYPE_BANK: {
				businessData[businessid][bMapIcon] = CreateDynamicMapIcon(businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 52, 0xFFFFFFFF, 0, 0);
			}
			case BUSINESS_TYPE_CLOTH: {
				businessData[businessid][bMapIcon] = CreateDynamicMapIcon(businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 45, 0xFFFFFFFF, 0, 0);
			}
			case BUSINESS_TYPE_DEALERSHIP: {
				businessData[businessid][bMapIcon] = CreateDynamicMapIcon(businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 11, 0xFFFFFFFF, 0, 0);
			}
			case BUSINESS_TYPE_RESTAURANT: {
				businessData[businessid][bMapIcon] = CreateDynamicMapIcon(businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 50, 0xFFFFFFFF, 0, 0);
			}
			case BUSINESS_TYPE_ADVERTISEMENT: {
				businessData[businessid][bMapIcon] = CreateDynamicMapIcon(businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 56, 0xFFFFFFFF, 0, 0);
			}
		}
	}
}

flags:editbusiness(CMD_MANAGEMENT);
CMD:editbusiness(playerid, params[])
{
	new text[160], type;

	if(sscanf(params,"ds[160]", type, text)) {
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /editbusiness [������͡] [���]");
		SendClientMessage(playerid, COLOR_GRAD2, "������͡�������: 1-����, 2-��Ңͧ, 3-����Ңͧ, 4-��͡, 5-�Ҥ�, 6-����ŷ�������, 7-�Թ㹸�áԨ");
		SendClientMessage(playerid, COLOR_GRAD2, "������͡�������: 8-������, 9-������");
		return 1;
	}

	new business = nearBusiness_var[playerid] == -1 ? insideBusinessID[playerid] : nearBusiness_var[playerid];
	if (business != -1 && Iter_Contains(Iter_Business, business))
	{
		switch(type) {
			case 1: {
				new info[128];
				if(sscanf(text,"s[128]", info)) {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /editbusiness ���� [���͸�áԨ]");
					return 1;
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹���͸�áԨ #%d �ҡ %s �� %s", ReturnPlayerName(playerid), businessData[business][bID], businessData[business][bInfo], info);
				format(businessData[business][bInfo], 128, info);
				Business_Save(business);
			}
			case 2: {
				new name[MAX_PLAYER_NAME];
				if(sscanf(text,"s[24]", name)) {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /editbusiness ��Ңͧ [������Ңͧ]");
					return 1;
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹������Ңͧ��áԨ #%d �ҡ %s �� %s", ReturnPlayerName(playerid), businessData[business][bID], businessData[business][bOwner], name);
				format(businessData[business][bOwner], MAX_PLAYER_NAME, name);
				Business_Save(business);
			}
			case 3: {
				new status;
				if(sscanf(text,"i", status)) {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /editbusiness ����Ңͧ [0-�������Ңͧ, 1-����Ңͧ]");
					return 1;
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹�������Ңͧ��áԨ #%d �� %s", ReturnPlayerName(playerid), businessData[business][bID], (!!status) ? ("����Ңͧ") : ("�������Ңͧ"));
				businessData[business][bOwned] = !!status;

				if(IsValidDynamicPickup(businessData[business][bPickup]))
					DestroyDynamicPickup(businessData[business][bPickup]);

				businessData[business][bPickup] = CreateDynamicPickup(businessData[business][bOwned] ? 1239 : 1272, 23, businessData[business][bPosX], businessData[business][bPosY], businessData[business][bPosZ], 0, 0);
				Streamer_SetIntData(STREAMER_TYPE_PICKUP, businessData[business][bPickup], E_STREAMER_EXTRA_ID, business);

				Business_Save(business);
			}
			case 5: {
				new price;
				if(sscanf(text,"d", price)) {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /editbusiness �Ҥ� [�ӹǹ]");
					return 1;
				}
				if (price <= 0 || price >= 50000000) {
					SendClientMessage(playerid, COLOR_GRAD1, "   �ҤҸ�áԨ��ͧ����ӡ���������ҡѺ 0");
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹�ҤҢͧ��áԨ #%d �ҡ %d �� %d", ReturnPlayerName(playerid), businessData[business][bID], businessData[business][bPrice], price);
				businessData[business][bPrice] = price;
				Business_Save(business);
			}
			case 6: {
				new level;
				if(sscanf(text,"d", level)) {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /editbusiness ����ŷ������� [�����]");
					return 1;
				}
				if (level <= 0 || level >= 50000000) {
					SendClientMessage(playerid, COLOR_GRAD1, "   ����Ţ�鹵��㹡�ë��͸�áԨ��ͧ����ӡ���������ҡѺ 0");
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹����Ţ�鹵��㹡�ë��ͧ͢��áԨ #%d �ҡ %d �� %d", ReturnPlayerName(playerid), businessData[business][bID], businessData[business][bLevelbuy], level);
				businessData[business][bLevelbuy] = level;
				Business_Save(business);
			}
			case 7: {
				new till;
				if(sscanf(text,"d", till)) {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /editbusiness �Թ㹸�áԨ [�ӹǹ]");
					return 1;
				}
				if (till <= 0 || till >= 50000000) {
					SendClientMessage(playerid, COLOR_GRAD1, "   �Թ㹸�áԨ��ͧ����ӡ���������ҡѺ 0");
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹�Թ�ͧ��áԨ #%d �ҡ %d �� %d", ReturnPlayerName(playerid), businessData[business][bID], businessData[business][bCash], till);
				businessData[business][bCash] = till;
				Business_Save(business);
			}
			case 8: {
				new enc;
				if(sscanf(text,"d", enc)) {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /editbusiness ������ [�ӹǹ]");
					return 1;
				}
				if (enc < 0 || enc >= 50000000) {
					SendClientMessage(playerid, COLOR_GRAD1, "   �����ҵ�ͧ����ӡ��� 0");
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹�����Ңͧ��áԨ #%d �ҡ %d �� %d", ReturnPlayerName(playerid), businessData[business][bID], businessData[business][bEntranceCost], enc);
				businessData[business][bEntranceCost] = enc;
				Business_Save(business);
			}
			case 9: {
				new btype;
				if(sscanf(text,"d", btype)) {
					SendClientMessage(playerid, COLOR_GRAD1, "�����: /editbusiness ������ [�����Ţ]");
					ShowAllBusinessType(playerid);
					return 1;
				}
				if(btype < 0 || btype > BUSINESS_MAX_TYPE) {
					SendClientMessageEx(playerid, COLOR_GRAD1, "   ��������ͧ�� 0 �֧ %d ��ҹ�� !!", BUSINESS_MAX_TYPE);
					return 1;
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ������¹�������ͧ��áԨ #%d �ҡ %d �� %d", ReturnPlayerName(playerid), businessData[business][bID], businessData[business][bType], btype);
				businessData[business][bType] = btype;
				BusinessMapIcon(business);
				Business_Save(business);
			}
		}
	}
	else return SendClientMessage(playerid, COLOR_GRAD2, "�س�������������áԨ� �");
	return 1;
}

ShowPlayerFoodMenu(playerid) {
	return Dialog_Show(playerid, DialogFoodMenu, DIALOG_STYLE_LIST, "��¡�������", "�ش���\t�������+15\t$200\n�ش��ҧ\t�������+20\t$350\n�ش�������\t�������+30\t$500", "����", "�͡");
}

Dialog:DialogFoodMenu(playerid, response, listitem, inputtext[]) {
	if (response) {
		new Float:currentHealth;
		GetPlayerHealth(playerid, currentHealth);
		switch(listitem) {
			case 0: {
				/*if(currentHealth < 100.0)
				{
				    if(currentHealth + 30.0 <= 100.0) SetPlayerHealthEx(playerid,(currentHealth + 30.0));
				    else SetPlayerHealthEx(playerid, 100.0);
				}*/
				if (playerData[playerid][pHungry] >= 85)
					return SendClientMessage(playerid, COLOR_GRAD1, "�س�ѧ�����ǵ͹���");

				playerData[playerid][pHungry] += 15;
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s ��������", ReturnRealName(playerid));
				SendClientMessage(playerid, COLOR_WHITE, "�س����� {FF6347}�ش���"EMBED_WHITE" ��Ҥ� {FF6347}$200");
				GivePlayerMoneyEx(playerid, -200);

				SendClientMessage(playerid, COLOR_YELLOW, "�س���Ѻ��Ҿ�ѧ�ҹ�������������� +15");
			}
			case 1: {
				/*if(currentHealth < 100.0)
				{
				    if(currentHealth + 60.0 <= 100.0) SetPlayerHealthEx(playerid,(currentHealth + 60.0));
				    else SetPlayerHealthEx(playerid, 100.0);
				}*/
				if (playerData[playerid][pHungry] >= 80)
					return SendClientMessage(playerid, COLOR_GRAD1, "�س�ѧ�����ǵ͹���");

				playerData[playerid][pHungry] += 20;

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s ��������", ReturnRealName(playerid));
				SendClientMessage(playerid, COLOR_WHITE, "�س����� {FF6347}�ش��ҧ"EMBED_WHITE" ��Ҥ� {FF6347}$350");
				GivePlayerMoneyEx(playerid, -350);

				SendClientMessage(playerid, COLOR_YELLOW, "�س���Ѻ��Ҿ�ѧ�ҹ�������������� +20");
			}
			case 2: {
				if (playerData[playerid][pHungry] >= 70)
					return SendClientMessage(playerid, COLOR_GRAD1, "�س�ѧ�����ǵ͹���");

				playerData[playerid][pHungry] += 30;

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s ��������", ReturnRealName(playerid));
				SendClientMessage(playerid, COLOR_WHITE, "�س����� {FF6347}�ش�������"EMBED_WHITE" ��Ҥ� {FF6347}$500");
				GivePlayerMoneyEx(playerid, -500);

				SendClientMessage(playerid, COLOR_YELLOW, "�س���Ѻ��Ҿ�ѧ�ҹ�������������� +30");
			}
		}
	}
	return 1;
}
