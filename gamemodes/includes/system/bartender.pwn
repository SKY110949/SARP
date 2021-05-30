#include <YSI\y_hooks> // pawn-lang/YSI-Includes

enum maxitemE {
	iDrink,
	Text3D:iDrinkText,
}

new itemVariables[maxitemE];

#include <YSI\y_hooks> // pawn-lang/YSI-Includes

#define MAX_BARTENDER 10
new Iterator:sv_bartender<MAX_BARTENDER>;

enum bartenderE
{
	bID,
	Float:bX,
	Float:bY,
	Float:bZ,
	bPlayer1[MAX_PLAYER_NAME char],
	//whPlayer2[MAX_PLAYER_NAME char],
	bType,
	bStock,
	bMaxstock,
	bPickup,
	STREAMER_TAG_3D_TEXT_LABEL:bLabel,
	bWorld,
	bInt

};
new BartenderInfo[MAX_BARTENDER][bartenderE];

hook OnGameModeInit()
{
    mysql_tquery(dbCon, "SELECT * FROM `bartender`", "Bartender_Load", "");
}

Bartender_Refresh(bid) {
	if (bid != -1)
	{
		if (IsValidDynamicPickup(BartenderInfo[bid][bPickup]))
		    DestroyDynamicPickup(BartenderInfo[bid][bPickup]);

		BartenderInfo[bid][bPickup] = CreateDynamicPickup(1239, 23, BartenderInfo[bid][bX], BartenderInfo[bid][bY], BartenderInfo[bid][bZ], BartenderInfo[bid][bWorld], BartenderInfo[bid][bInt]);

		new warehouse_str[56];
		if(!IsValidDynamic3DTextLabel(BartenderInfo[bid][bLabel])) {

			format(warehouse_str, sizeof(warehouse_str), "["EMBED_ORANGE"��ѧ���Թ�ͧ Bartender"EMBED_WHITE"]\n�ӹǹ�Թ�������: %d / %d", BartenderInfo[bid][bStock], BartenderInfo[bid][bMaxstock]);
			BartenderInfo[bid][bLabel] = CreateDynamic3DTextLabel(warehouse_str, -1, BartenderInfo[bid][bX], BartenderInfo[bid][bY], BartenderInfo[bid][bZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, BartenderInfo[bid][bWorld], BartenderInfo[bid][bInt], -1, 100.0);
            return 1;
		}
		format(warehouse_str, sizeof(warehouse_str), "["EMBED_ORANGE"��ѧ���Թ�ͧ Bartender"EMBED_WHITE"]\n�ӹǹ�Թ�������: %d / %d", BartenderInfo[bid][bStock], BartenderInfo[bid][bMaxstock]);
        UpdateDynamic3DTextLabelText(BartenderInfo[bid][bLabel], -1, warehouse_str);
	}
	return 1;
}

Bartender_Nearest(playerid, Float:radius = 2.5)
{
    foreach(new i : sv_bartender) if (IsPlayerInRangeOfPoint(playerid, radius, BartenderInfo[i][bX], BartenderInfo[i][bY], BartenderInfo[i][bZ]) && GetPlayerInterior(playerid) == BartenderInfo[i][bInt] && GetPlayerVirtualWorld(playerid) == BartenderInfo[i][bWorld])
	{
		return i;
	}
	return -1;
}

forward Bartender_Load();
public Bartender_Load()
{
	new
	    str[256],
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_BARTENDER)
	{

		cache_get_value_name_int(i, "b_id",BartenderInfo[i][bID]);
		cache_get_value_name_float(i, "b_x", BartenderInfo[i][bX]);
		cache_get_value_name_float(i, "b_y", BartenderInfo[i][bY]);
		cache_get_value_name_float(i, "b_z", BartenderInfo[i][bZ]);

		cache_get_value_name(i, "b_player1", str);
		strpack(BartenderInfo[i][bPlayer1], str, MAX_PLAYER_NAME char);
		
		cache_get_value_name_int(i, "b_type",BartenderInfo[i][bType]);
		cache_get_value_name_int(i, "b_stock",BartenderInfo[i][bStock]);
		cache_get_value_name_int(i, "b_maxstock",BartenderInfo[i][bMaxstock]);

		cache_get_value_name_int(i, "b_world",BartenderInfo[i][bWorld]);
		cache_get_value_name_int(i, "b_int",BartenderInfo[i][bInt]);

		Bartender_Refresh(i);

		Iter_Add(sv_bartender, i);
	}
	printf("Loaded %d Bartender from MYSQL.", rows);
	return 1;
}

hook OnPlayerConnect(playerid)
{
	//SetPlayerMapIcon(playerid, 12, -1851.7897, -137.2997, 11.9051, 27, 0, MAPICON_LOCAL);
	CreateDynamicMapIcon(-1851.7897, -137.2997, 11.9051, 27, 0xFFFFFFFF, 0, 0);
}

/*hook OnGameModeInit()
{
    new szLabelText[256];
    //SetTimer("ResetMoneyBag", 1000, true);

    format(szLabelText, sizeof(szLabelText), "��ѧ���Թ��ҹ����ͧ����\n{FFFFFF}�ӹǹ�Թ������� $%d\n{FFFFFF}����� /getmoney ���Ͷ͹�Թ�͡�ҡ��ѧ", itemVariables[iDrink]);
	itemVariables[iDrinkText] = CreateDynamic3DTextLabel(szLabelText, COLOR_WHITE, 1269.2180, -787.0618, 1084.0149, 10.0);
    CreateDynamicPickup(1239, 23, 1269.2180, -787.0618, 1084.0149);

    format(szLabelText, sizeof(szLabelText), "��ѧ���Թ��ҹ����ͧ����\n{FFFFFF}�ӹǹ�Թ������� $%d\n{FFFFFF}����� /getmoney ���Ͷ͹�Թ�͡�ҡ��ѧ", itemVariables[iDrink]);
    UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);
}*/

flags:bartendercmds(CMD_ADM_3);
CMD:bartendercmds(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GRAD3, "[Level 3]: /makebartender /removebartender /editbartender /gotobartender");
	return 1;
}

stock AddBartenderToFile(bartenderid) {

    new szQuery[128];

	format(szQuery, sizeof(szQuery), "INSERT INTO `bartender` (b_type, b_x, b_y, b_z, b_world, b_int) VALUES(%d, %f, %f, %f, %d, %d)", BartenderInfo[bartenderid][bType], BartenderInfo[bartenderid][bX], BartenderInfo[bartenderid][bY], BartenderInfo[bartenderid][bZ], BartenderInfo[bartenderid][bWorld], BartenderInfo[bartenderid][bInt]);

	mysql_tquery(dbCon, szQuery, "OnBartenderInsert", "d", bartenderid);
}

forward OnBartenderInsert(bartenderid);
public OnBartenderInsert(bartenderid)
{
	BartenderInfo[bartenderid][bID] = cache_insert_id();
	return 1;
}

forward OnBartenderRemove(bartenderid);
public OnBartenderRemove(bartenderid)
{
	BartenderInfo[bartenderid][bX] = 0.0000;
	BartenderInfo[bartenderid][bY] = 0.0000;
	BartenderInfo[bartenderid][bZ] = 0.0000;
	BartenderInfo[bartenderid][bInt] = 0;
	BartenderInfo[bartenderid][bWorld] = 0;
	BartenderInfo[bartenderid][bType] = 0;

	/*format(BartenderInfo[warehouseid][whPlayer1], 24, "");
	format(BartenderInfo[warehouseid][whPlayer2], 24, "");*/
	strpack(BartenderInfo[bartenderid][bPlayer1], "", MAX_PLAYER_NAME char);
	//strpack(BartenderInfo[warehouseid][whPlayer2], "", MAX_PLAYER_NAME char);
	/*strpack(BartenderInfo[i][whPlayer1], '\0');
	strpack(BartenderInfo[i][whPlayer2], '\0');*/

	Iter_Remove(sv_bartender, bartenderid);
	return 1;
}

flags:removebartender(CMD_ADM_3);
CMD:removebartender(playerid,params[])
{
	new warehouseid = -1, szQuery[128];

	if((warehouseid = Bartender_Nearest(playerid)) != -1) {

		format(szQuery, sizeof(szQuery), "DELETE FROM `bartender` WHERE `b_id` = %d",BartenderInfo[warehouseid][bID]);
		mysql_tquery(dbCon, szQuery, "OnBartenderRemove", "i", warehouseid);

		if (IsValidDynamicPickup(BartenderInfo[warehouseid][bPickup]))
		    DestroyDynamicPickup(BartenderInfo[warehouseid][bPickup]);

		if(IsValidDynamic3DTextLabel(BartenderInfo[warehouseid][bLabel]))
			DestroyDynamic3DTextLabel(BartenderInfo[warehouseid][bLabel]);

		format(szString,sizeof(szString),"�س������ Bartender �ʹ�: %d!",warehouseid);
		SendClientMessage(playerid, COLOR_YELLOW, szString);
	}
	return 1;
}

flags:makebartender(CMD_ADM_3);
CMD:makebartender(playerid, params[]) {

	new id, type, Float:x, Float:y, Float:z;
	if(sscanf(params,"d", type)) {
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /makebartender [type]");
		SendClientMessage(playerid, COLOR_GREY, "Available types: 1: Bartender");
		return 1;
	}

	if(type != 1) return SendClientMessage(playerid, COLOR_GRAD1, "������ 1 ��ҹ��");

	if((id = Iter_Free(sv_bartender)) != -1) {

		GetPlayerPos(playerid, x, y, z);

		BartenderInfo[id][bX] = x;
		BartenderInfo[id][bY] = y;
		BartenderInfo[id][bZ] = z;

		BartenderInfo[id][bWorld] = GetPlayerVirtualWorld(playerid);
		BartenderInfo[id][bInt] = GetPlayerInterior(playerid);

		BartenderInfo[id][bType] = type;

		strpack(BartenderInfo[id][bPlayer1], "", MAX_PLAYER_NAME char);
		//strpack(BartenderInfo[id][whPlayer2], "", MAX_PLAYER_NAME char);

		Bartender_Refresh(id);

		//AddWarehouseToFile(id);

		new query[256];
		mysql_format(dbCon, query, sizeof query, "INSERT INTO `bartender` (b_type, b_x, b_y, b_z, b_world, b_int) VALUES(%d, %f, %f, %f, %d, %d)", BartenderInfo[id][bType], BartenderInfo[id][bX], BartenderInfo[id][bY], BartenderInfo[id][bZ], BartenderInfo[id][bWorld], BartenderInfo[id][bInt]);
		mysql_tquery(dbCon, query, "OnBartenderInsert", "d", id);
	
		SendClientMessage(playerid, COLOR_GREEN, "Bartender �١���ҧ���� !!");

		Iter_Add(sv_bartender, id);
	}
	return 1;
}

flags:gotobartender(CMD_ADM_3);
CMD:gotobartender(playerid, params[])
{
	new warehouseid;

	if(sscanf(params,"d",warehouseid)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /gotobartender [bartender id]");
	if(!Iter_Contains(sv_warehouse, warehouseid)) return SendClientMessage(playerid, -1, "Invalid bartender id.");

	SetPlayerPos(playerid, BartenderInfo[warehouseid][bX], BartenderInfo[warehouseid][bY], BartenderInfo[warehouseid][bZ]);

	SetPlayerInterior(playerid, BartenderInfo[warehouseid][bInt]);
	SetPlayerVirtualWorld(playerid, BartenderInfo[warehouseid][bWorld]);
	playerData[playerid][pInterior] = BartenderInfo[warehouseid][bInt];
	playerData[playerid][pVWorld] = BartenderInfo[warehouseid][bWorld];
	//playerData[playerid][pLocal] = 255;
	//HouseEntered[playerid] = -1;
	//BizEntered[playerid] = -1;
	return 1;
}

CMD:editbartender(playerid, params[])
{
	new text[128], type, warehouseid = -1, szQuery[128];

	if(playerData[playerid][pAdmin] < 3)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �س������Ѻ͹حҵ��������觹��");

	if(sscanf(params,"dds[256]",warehouseid,type,text) && type != 6) {
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /editbartender [bartender id] [names] [input]");
		SendClientMessage(playerid, COLOR_GRAD2, "Available names: 1-player1, 2-stock, 3-maxstock, 4-position");

		if(Iter_Contains(sv_bartender, warehouseid)) {
			new warehousetemp[MAX_PLAYER_NAME+1];
			strunpack(warehousetemp, BartenderInfo[warehouseid][bPlayer1]);
			SendClientMessageEx(playerid, COLOR_GRAD2, "Player 1: %s", warehousetemp);
			//strunpack(warehousetemp, BartenderInfo[warehouseid][whPlayer2]);
			//SendClientMessageEx(playerid, COLOR_GRAD2, "Player 2: %s", warehousetemp);
		}
	}

	if(!Iter_Contains(sv_bartender, warehouseid)) return SendClientMessage(playerid, -1, "Invalid bartender id.");

	new input = strval(text);

	if(type == 1)
	{
		new clean_name[24];
		mysql_escape_string(text,clean_name);

		format(szQuery, sizeof(szQuery), "UPDATE `bartender` SET `b_player1` = '%s' WHERE `b_id` = %d", clean_name, BartenderInfo[warehouseid][bID]);
		mysql_query(dbCon, szQuery);

		strpack(BartenderInfo[warehouseid][bPlayer1], text, MAX_PLAYER_NAME char);
	
		SendClientMessageEx(playerid, COLOR_GRAD2, "�س��˹� #1 ��� %s ��ҹ Bartender", text);
	}
	/*else if(type == 2)
	{
		new clean_name[24];
		mysql_escape_string(text,clean_name);

		format(szQuery, sizeof(szQuery), "UPDATE `faction_warehouse` SET `fw_player2` = '%s' WHERE `fw_id` = %d", clean_name, BartenderInfo[warehouseid][whID]);
		mysql_query(dbCon, szQuery);

		strpack(BartenderInfo[warehouseid][whPlayer2], text, MAX_PLAYER_NAME char);
		SendClientMessageEx(playerid, COLOR_GRAD2, "�س��˹� #2 ��� %s ��ҹ Warehouse", text);
	}*/
	else if(type == 2)
	{
		format(szQuery, sizeof(szQuery), "UPDATE `bartender` SET `b_stock` = %d WHERE `b_id` = %d", input, BartenderInfo[warehouseid][bID]);
		mysql_query(dbCon, szQuery);
		BartenderInfo[warehouseid][bStock] = input;
		SendClientMessageEx(playerid, COLOR_GRAD2, "�س��˹��ӹǹ�Թ� Bartender �� %d", BartenderInfo[warehouseid][bStock]);
        Bartender_Refresh(warehouseid);
	}
	else if(type == 3)
	{
		format(szQuery, sizeof(szQuery), "UPDATE `bartender` SET `b_maxstock` = %d WHERE `b_id` = %d", input, BartenderInfo[warehouseid][bID]);
		mysql_query(dbCon, szQuery);
		BartenderInfo[warehouseid][bMaxstock] = input;
		SendClientMessageEx(playerid, COLOR_GRAD2, "�س��˹��ӹǹ�Թ�٧�ش�ͧ�Թ���� Bartender �� %d", BartenderInfo[warehouseid][bMaxstock]);
        Bartender_Refresh(warehouseid);
	}
	else if(type == 4)
	{
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);

		if(IsValidDynamic3DTextLabel(BartenderInfo[warehouseid][bLabel]))
			DestroyDynamic3DTextLabel(BartenderInfo[warehouseid][bLabel]);

		BartenderInfo[warehouseid][bX] = x;
		BartenderInfo[warehouseid][bY] = y;
		BartenderInfo[warehouseid][bZ] = z;

		BartenderInfo[warehouseid][bWorld] = GetPlayerVirtualWorld(playerid);
		BartenderInfo[warehouseid][bInt] = GetPlayerInterior(playerid);

		Bartender_Refresh(warehouseid);

		format(szQuery, sizeof(szQuery), "UPDATE `bartender` SET b_x = %f, b_y = %f, b_z = %f, b_world = %d, b_int = %d WHERE `b_id` = %d", x, y, z, BartenderInfo[warehouseid][bWorld], BartenderInfo[warehouseid][bInt], BartenderInfo[warehouseid][bID]);
		mysql_query(dbCon, szQuery);

		SendClientMessage(playerid, COLOR_GRAD2, "�س��˹����˹�����ͧ Bartender ���º��������");
	}

	return 1;
}

task BartenderTime[1000]() {

	foreach(new i : sv_bartender) {

        //WareHouseInfo[i][bStock]++;

        if(BartenderInfo[i][bStock] > BartenderInfo[i][bMaxstock])
            BartenderInfo[i][bStock] = BartenderInfo[i][bMaxstock];

        Bartender_Refresh(i);
        saveBartender(i);
	}
}


stock saveBartender(warehouseid) {

    new szQuery[128];

	format(szQuery, sizeof(szQuery), "UPDATE `bartender` SET `b_stock` = '%d' WHERE `b_id` = %d", BartenderInfo[warehouseid][bStock], BartenderInfo[warehouseid][bID]);
	mysql_query(dbCon, szQuery);
}

/*CMD:getmoney(playerid, params[])
{
    new amount;

    if (playerData[playerid][pSID] != 39343)
        return SendClientMessage(playerid, COLOR_GRAD, "����Ѻ Rifhan Khalifa ��ҹ��");

	if (!IsPlayerInRangeOfPoint(playerid, 3, 1269.2180, -787.0618, 1084.0149))
		return SendClientMessage(playerid, COLOR_GRAD1, "�س������������ѧ���Թ");

	if (sscanf(params,"d", amount)) {
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /getmoney [�ӹǹ]");
		return 1;
	}

	if (itemVariables[iDrink] <= 0) 
        return SendClientMessage(playerid, COLOR_GRAD1, "�Թ㹤�ѧ�ͧ�س�������");

    if (itemVariables[iDrink] < amount)
        return SendClientMessage(playerid, COLOR_GRAD1, "�ӹǹ�Թ���س��ͧ���㹤�ѧ������ҡ��");

    else
    {
        itemVariables[iDrink] -= amount;
        playerData[playerid][pStock] -= amount;

		GivePlayerMoneyEx(playerid, amount);

        new szLabelText[128];
        format(szLabelText, sizeof(szLabelText), "��ѧ���Թ��ҹ����ͧ����\n{FFFFFF}�ӹǹ�Թ������� $%d\n{FFFFFF}����� /getmoney ���Ͷ͹�Թ�͡�ҡ��ѧ", itemVariables[iDrink]);
        UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);

        SendClientMessageEx(playerid, COLOR_LIGHTRED, "�س��ӡ�ö͹�Թ�ӹǹ %d �ӹǹ�Թ������� %d", amount, itemVariables[iDrink]);
    }

    return 1;
}*/

CMD:buydrink(playerid, params[])
{
	new type[24];

	if (!IsPlayerInRangeOfPoint(playerid, 3, -1851.7897, -137.2997, 11.9051))
		return SendClientMessage(playerid, COLOR_GRAD1, "�س��������������");

	if (sscanf(params,"s[24]D(0)S()[16]", type)) {
		SendClientMessage(playerid, COLOR_LIGHTRED, "�����: "EMBED_WHITE"/buydrink [����ͧ�������س��ͧ���]");
        SendClientMessage(playerid, COLOR_WHITE, "�س����ö����� /listdrink ���ʹ�����ͧ��������բ��,����Ҥҷ��س��ͧ����");
		return 1;
	}

	if(!strcmp(type, "Water", true))
	{
        if (playerData[playerid][pCash] < 10)
            return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ���Թ�ҡ���� $10");
 
        GivePlayerMoneyEx(playerid, -10);
		//ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ���������ͧ���� Water �ҡ��ѡ�ҹ����෹���������Ѻ�����Թ $10", ReturnRealName(playerid));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* ��ѡ�ҹ����෹���� : �������ͧ���� Water ����������������Ѻ %s", ReturnRealName(playerid));

		//itemVariables[iDrink] += 10;
        //playerData[userid][pStock] += 10;

		new szLabelText[256];
 		format(szLabelText, sizeof(szLabelText), "��ѧ���Թ��ҹ����ͧ����\n{FFFFFF}�ӹǹ�Թ������� $%d\n{FFFFFF}����� /getmoney ���Ͷ͹�Թ�͡�ҡ��ѧ", itemVariables[iDrink]);
		UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);

		return 1;
	}

	if(!strcmp(type, "Hongthong", true))
	{
        if (playerData[playerid][pCash] < 300)
            return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ���Թ�ҡ���� $300");
 
        GivePlayerMoneyEx(playerid, -300);
		ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ���������ͧ���� Hongthong �ҡ��ѡ�ҹ����෹���������Ѻ�����Թ $300", ReturnRealName(playerid));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* ��ѡ�ҹ����෹���� : �������ͧ���� Hongthong ����������������Ѻ %s", ReturnRealName(playerid));

		//itemVariables[iDrink] += 300;
        //playerData[userid][pStock] += 300;

		new szLabelText[256];
 		format(szLabelText, sizeof(szLabelText), "��ѧ���Թ��ҹ����ͧ����\n{FFFFFF}�ӹǹ�Թ������� $%d\n{FFFFFF}����� /getmoney ���Ͷ͹�Թ�͡�ҡ��ѧ", itemVariables[iDrink]);
		UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);
		return 1;
	}

	if(!strcmp(type, "Sangasom", true))
	{
        if (playerData[playerid][pCash] < 800)
            return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ���Թ�ҡ���� $800");
 
        GivePlayerMoneyEx(playerid, -800);
		ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ���������ͧ���� Sangasom �ҡ��ѡ�ҹ����෹���������Ѻ�����Թ $800", ReturnRealName(playerid));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* ��ѡ�ҹ����෹���� : �������ͧ���� Sangasom ����������������Ѻ %s", ReturnRealName(playerid));

		//itemVariables[iDrink] += 800;
        //playerData[userid][pStock] += 800;

		new szLabelText[256];
 		format(szLabelText, sizeof(szLabelText), "��ѧ���Թ��ҹ����ͧ����\n{FFFFFF}�ӹǹ�Թ������� $%d\n{FFFFFF}����� /getmoney ���Ͷ͹�Թ�͡�ҡ��ѧ", itemVariables[iDrink]);
		UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);

		return 1;
	}

	if(!strcmp(type, "Redlabel", true))
	{
        if (playerData[playerid][pCash] < 1200)
            return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ���Թ�ҡ���� $1200");
 
        GivePlayerMoneyEx(playerid, -1200);
		ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ���������ͧ���� Red Label �ҡ��ѡ�ҹ����෹���������Ѻ�����Թ $1200", ReturnRealName(playerid));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* ��ѡ�ҹ����෹���� : �������ͧ���� Red Label ����������������Ѻ %s", ReturnRealName(playerid));

		//itemVariables[iDrink] += 1200;
        //playerData[userid][pStock] += 1200;

		new szLabelText[256];
 		format(szLabelText, sizeof(szLabelText), "��ѧ���Թ��ҹ����ͧ����\n{FFFFFF}�ӹǹ�Թ������� $%d\n{FFFFFF}����� /getmoney ���Ͷ͹�Թ�͡�ҡ��ѧ", itemVariables[iDrink]);
		UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);

		return 1;
	}

	if(!strcmp(type, "Blacklabel", true))
	{
        if (playerData[playerid][pCash] < 2000)
            return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ���Թ�ҡ���� $2000");
 
        GivePlayerMoneyEx(playerid, -2000);
		ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ���������ͧ���� Black Label �ҡ��ѡ�ҹ����෹���������Ѻ�����Թ $2000", ReturnRealName(playerid));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* ��ѡ�ҹ����෹���� : �������ͧ���� Black Label ����������������Ѻ %s", ReturnRealName(playerid));

		//itemVariables[iDrink] += 2000;
        //playerData[userid][pStock] += 2000;

		new szLabelText[256];
 		format(szLabelText, sizeof(szLabelText), "��ѧ���Թ��ҹ����ͧ����\n{FFFFFF}�ӹǹ�Թ������� $%d\n{FFFFFF}����� /getmoney ���Ͷ͹�Թ�͡�ҡ��ѧ", itemVariables[iDrink]);
		UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);

		return 1;
	}

	if(!strcmp(type, "JackDaniel", true))
	{
        if (playerData[playerid][pCash] < 3500)
            return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ���Թ�ҡ���� $3500");
 
        GivePlayerMoneyEx(playerid, -3500);
		ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ���������ͧ���� Jack Daniel �ҡ��ѡ�ҹ����෹���������Ѻ�����Թ $3500", ReturnRealName(playerid));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* ��ѡ�ҹ����෹���� : �������ͧ���� Jack Daniel ����������������Ѻ %s", ReturnRealName(playerid));

		//itemVariables[iDrink] += 3500;
        //playerData[userid][pStock] += 3500;

		new szLabelText[256];
 		format(szLabelText, sizeof(szLabelText), "��ѧ���Թ��ҹ����ͧ����\n{FFFFFF}�ӹǹ�Թ������� $%d\n{FFFFFF}����� /getmoney ���Ͷ͹�Թ�͡�ҡ��ѧ", itemVariables[iDrink]);
		UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);

		return 1;
	}
	return 1;
}
