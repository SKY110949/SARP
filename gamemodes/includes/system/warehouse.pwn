#include <YSI\y_hooks> // pawn-lang/YSI-Includes

#define MAX_WAREHOUSE 10
new Iterator:sv_warehouse<MAX_WAREHOUSE>;

enum warehouseE
{
	whID,
	Float:whX,
	Float:whY,
	Float:whZ,
	whPlayer1[MAX_PLAYER_NAME char],
	whPlayer2[MAX_PLAYER_NAME char],
	whType,
	whStock,
	whMaxstock,
	whPickup,
	STREAMER_TAG_3D_TEXT_LABEL:whLabel,
	whWorld,
	whInt

};
new WareHouseInfo[MAX_WAREHOUSE][warehouseE];

hook OnGameModeInit()
{
    mysql_tquery(dbCon, "SELECT * FROM `faction_warehouse`", "Warehouse_Load", "");
}

Warehouse_Refresh(whid) {
	if (whid != -1)
	{
		if (IsValidDynamicPickup(WareHouseInfo[whid][whPickup]))
		    DestroyDynamicPickup(WareHouseInfo[whid][whPickup]);

		WareHouseInfo[whid][whPickup] = CreateDynamicPickup(1318, 23, WareHouseInfo[whid][whX], WareHouseInfo[whid][whY], WareHouseInfo[whid][whZ], WareHouseInfo[whid][whWorld], WareHouseInfo[whid][whInt]);

		new warehouse_str[56];
		if(!IsValidDynamic3DTextLabel(WareHouseInfo[whid][whLabel])) {

			format(warehouse_str, sizeof(warehouse_str), "["EMBED_ORANGE"Warehouse %s"EMBED_WHITE"]\nความจุโกดัง: %d / %d", WareHouseInfo[whid][whType] == 1 ? ("อาวุธ") : ("ยาเสพติด"), WareHouseInfo[whid][whStock], WareHouseInfo[whid][whMaxstock]);
			WareHouseInfo[whid][whLabel] = CreateDynamic3DTextLabel(warehouse_str, -1, WareHouseInfo[whid][whX], WareHouseInfo[whid][whY], WareHouseInfo[whid][whZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, WareHouseInfo[whid][whWorld], WareHouseInfo[whid][whInt], -1, 100.0);
            return 1;
		}
		format(warehouse_str, sizeof(warehouse_str), "["EMBED_ORANGE"Warehouse %s"EMBED_WHITE"]\nความจุโกดัง: %d / %d", WareHouseInfo[whid][whType] == 1 ? ("อาวุธ") : ("ยาเสพติด"), WareHouseInfo[whid][whStock], WareHouseInfo[whid][whMaxstock]);
        UpdateDynamic3DTextLabelText(WareHouseInfo[whid][whLabel], -1, warehouse_str);
	}
	return 1;
}

Warehouse_Nearest(playerid, Float:radius = 2.5)
{
    foreach(new i : sv_warehouse) if (IsPlayerInRangeOfPoint(playerid, radius, WareHouseInfo[i][whX], WareHouseInfo[i][whY], WareHouseInfo[i][whZ]) && GetPlayerInterior(playerid) == WareHouseInfo[i][whInt] && GetPlayerVirtualWorld(playerid) == WareHouseInfo[i][whWorld])
	{
		return i;
	}
	return -1;
}

WarehouseTime() {

	foreach(new i : sv_warehouse) {

        WareHouseInfo[i][whStock]++;

        if(WareHouseInfo[i][whStock] > WareHouseInfo[i][whMaxstock])
            WareHouseInfo[i][whStock] = WareHouseInfo[i][whMaxstock];

        Warehouse_Refresh(i);
        saveWarehouse(i);
	}
}

forward Warehouse_Load();
public Warehouse_Load()
{
	new
	    str[256],
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_WAREHOUSE)
	{

		cache_get_value_name_int(i, "fw_id",WareHouseInfo[i][whID]);
		cache_get_value_name_float(i, "fw_x", WareHouseInfo[i][whX]);
		cache_get_value_name_float(i, "fw_y", WareHouseInfo[i][whY]);
		cache_get_value_name_float(i, "fw_z", WareHouseInfo[i][whZ]);

		cache_get_value_name(i, "fw_player1", str);
		strpack(WareHouseInfo[i][whPlayer1], str, MAX_PLAYER_NAME char);
		
		cache_get_value_name(i, "fw_player2", str);
		strpack(WareHouseInfo[i][whPlayer2], str, MAX_PLAYER_NAME char);

		cache_get_value_name_int(i, "fw_type",WareHouseInfo[i][whType]);
		cache_get_value_name_int(i, "fw_stock",WareHouseInfo[i][whStock]);
		cache_get_value_name_int(i, "fw_maxstock",WareHouseInfo[i][whMaxstock]);

		cache_get_value_name_int(i, "fw_world",WareHouseInfo[i][whWorld]);
		cache_get_value_name_int(i, "fw_int",WareHouseInfo[i][whInt]);

		Warehouse_Refresh(i);

		Iter_Add(sv_warehouse, i);
	}
	printf("Loaded %d warehouse from MYSQL.", rows);
	return 1;
}

flags:warehousecmds(CMD_ADM_3);
CMD:warehousecmds(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GRAD3, "[Level 3]: /makewarehouse /removewarehouse /editwarehouse /gotowarehouse");
	return 1;
}

flags:near(CMD_ADM_3);
CMD:near(playerid, params[])
{
	new
	    id = -1;

    if ((id = Warehouse_Nearest(playerid)) != -1)
        SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณกำลังยืนอยู่ใกล้ Warehouse ไอดี: %d", id);

	return 1;
}

stock AddWarehouseToFile(warehouseid) {

    new szQuery[128];

	format(szQuery, sizeof(szQuery), "INSERT INTO `faction_warehouse` (fw_type, fw_x, fw_y, fw_z, fw_world, fw_int) VALUES(%d, %f, %f, %f, %d, %d)", WareHouseInfo[warehouseid][whType], WareHouseInfo[warehouseid][whX], WareHouseInfo[warehouseid][whY], WareHouseInfo[warehouseid][whZ], WareHouseInfo[warehouseid][whWorld], WareHouseInfo[warehouseid][whInt]);

	mysql_tquery(dbCon, szQuery, "OnWarehouseInsert", "d", warehouseid);
}

forward OnWarehouseInsert(warehouseID);
public OnWarehouseInsert(warehouseID)
{
	WareHouseInfo[warehouseID][whID] = cache_insert_id();
	return 1;
}

forward OnWarehouseRemove(warehouseid);
public OnWarehouseRemove(warehouseid)
{
	WareHouseInfo[warehouseid][whX] = 0.0000;
	WareHouseInfo[warehouseid][whY] = 0.0000;
	WareHouseInfo[warehouseid][whZ] = 0.0000;
	WareHouseInfo[warehouseid][whInt] = 0;
	WareHouseInfo[warehouseid][whWorld] = 0;
	WareHouseInfo[warehouseid][whType] = 0;

	/*format(WareHouseInfo[warehouseid][whPlayer1], 24, "");
	format(WareHouseInfo[warehouseid][whPlayer2], 24, "");*/
	strpack(WareHouseInfo[warehouseid][whPlayer1], "", MAX_PLAYER_NAME char);
	strpack(WareHouseInfo[warehouseid][whPlayer2], "", MAX_PLAYER_NAME char);
	/*strpack(WareHouseInfo[i][whPlayer1], '\0');
	strpack(WareHouseInfo[i][whPlayer2], '\0');*/

	Iter_Remove(sv_warehouse, warehouseid);
	return 1;
}

flags:removewarehouse(CMD_ADM_3);
CMD:removewarehouse(playerid,params[])
{
	new warehouseid = -1, szQuery[128];

	if((warehouseid = Warehouse_Nearest(playerid)) != -1) {

		format(szQuery, sizeof(szQuery), "DELETE FROM `faction_warehouse` WHERE `fw_id` = %d",WareHouseInfo[warehouseid][whID]);
		mysql_tquery(dbCon, szQuery, "OnWarehouseRemove", "i", warehouseid);

		if (IsValidDynamicPickup(WareHouseInfo[warehouseid][whPickup]))
		    DestroyDynamicPickup(WareHouseInfo[warehouseid][whPickup]);

		if(IsValidDynamic3DTextLabel(WareHouseInfo[warehouseid][whLabel]))
			DestroyDynamic3DTextLabel(WareHouseInfo[warehouseid][whLabel]);

		format(szString,sizeof(szString),"คุณได้ทำลาย Warehouse ไอดี: %d!",warehouseid);
		SendClientMessage(playerid, COLOR_YELLOW, szString);
	}
	return 1;
}

flags:makewarehouse(CMD_ADM_3);
CMD:makewarehouse(playerid, params[]) {

	new id, type, Float:x, Float:y, Float:z;
	if(sscanf(params,"d", type)) {
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /makewarehouse [type]");
		SendClientMessage(playerid, COLOR_GREY, "Available types: 1: Weapon");
		return 1;
	}

	if(type < 1 || type > 2) return SendClientMessage(playerid, COLOR_GRAD1, "ประเภท 1 เท่านั้น");

	if((id = Iter_Free(sv_warehouse)) != -1) {

		GetPlayerPos(playerid, x, y, z);

		WareHouseInfo[id][whX] = x;
		WareHouseInfo[id][whY] = y;
		WareHouseInfo[id][whZ] = z;

		WareHouseInfo[id][whWorld] = GetPlayerVirtualWorld(playerid);
		WareHouseInfo[id][whInt] = GetPlayerInterior(playerid);

		WareHouseInfo[id][whType] = type;

		strpack(WareHouseInfo[id][whPlayer1], "", MAX_PLAYER_NAME char);
		strpack(WareHouseInfo[id][whPlayer2], "", MAX_PLAYER_NAME char);

		Warehouse_Refresh(id);

		//AddWarehouseToFile(id);

		new query[256];
		mysql_format(dbCon, query, sizeof query, "INSERT INTO `faction_warehouse` (fw_type, fw_x, fw_y, fw_z, fw_world, fw_int) VALUES(%d, %f, %f, %f, %d, %d)", WareHouseInfo[id][whType], WareHouseInfo[id][whX], WareHouseInfo[id][whY], WareHouseInfo[id][whZ], WareHouseInfo[id][whWorld], WareHouseInfo[id][whInt]);
		mysql_tquery(dbCon, query, "OnWarehouseInsert", "d", id);
	
		SendClientMessage(playerid, COLOR_GREEN, "Warehouse ถูกสร้างแล้ว !!");

		Iter_Add(sv_warehouse, id);
	}
	return 1;
}

flags:gotowarehouse(CMD_ADM_3);
CMD:gotowarehouse(playerid, params[])
{
	new warehouseid;

	if(sscanf(params,"d",warehouseid)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /gotowarehouse [warehouse id]");
	if(!Iter_Contains(sv_warehouse, warehouseid)) return SendClientMessage(playerid, -1, "Invalid warehouse id.");

	SetPlayerPos(playerid, WareHouseInfo[warehouseid][whX], WareHouseInfo[warehouseid][whY], WareHouseInfo[warehouseid][whZ]);

	SetPlayerInterior(playerid, WareHouseInfo[warehouseid][whInt]);
	SetPlayerVirtualWorld(playerid, WareHouseInfo[warehouseid][whWorld]);
	playerData[playerid][pInterior] = WareHouseInfo[warehouseid][whInt];
	playerData[playerid][pVWorld] = WareHouseInfo[warehouseid][whWorld];
	//playerData[playerid][pLocal] = 255;
	//HouseEntered[playerid] = -1;
	//BizEntered[playerid] = -1;
	return 1;
}

CMD:editwarehouse(playerid, params[])
{
	new text[128], type, warehouseid = -1, szQuery[128];

	if(playerData[playerid][pAdmin] < 3)
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

	if(sscanf(params,"dds[256]",warehouseid,type,text) && type != 6) {
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /editwarehouse [warehouse id] [names] [input]");
		SendClientMessage(playerid, COLOR_GRAD2, "Available names: 1-player1, 2-player2, 3-stock, 4-maxstock, 5-type, 6-position");

		if(Iter_Contains(sv_warehouse, warehouseid)) {
			new warehousetemp[MAX_PLAYER_NAME+1];
			strunpack(warehousetemp, WareHouseInfo[warehouseid][whPlayer1]);
			SendClientMessageEx(playerid, COLOR_GRAD2, "Player 1: %s", warehousetemp);
			strunpack(warehousetemp, WareHouseInfo[warehouseid][whPlayer2]);
			SendClientMessageEx(playerid, COLOR_GRAD2, "Player 2: %s", warehousetemp);
		}
	}

	if(!Iter_Contains(sv_warehouse, warehouseid)) return SendClientMessage(playerid, -1, "Invalid warehouse id.");

	new input = strval(text);

	if(type == 1)
	{
		new clean_name[24];
		mysql_escape_string(text,clean_name);

		format(szQuery, sizeof(szQuery), "UPDATE `faction_warehouse` SET `fw_player1` = '%s' WHERE `fw_id` = %d", clean_name, WareHouseInfo[warehouseid][whID]);
		mysql_query(dbCon, szQuery);

		strpack(WareHouseInfo[warehouseid][whPlayer1], text, MAX_PLAYER_NAME char);
	
		SendClientMessageEx(playerid, COLOR_GRAD2, "คุณกำหนด #1 ให้ %s ใช้งาน Warehouse", text);
	}
	else if(type == 2)
	{
		new clean_name[24];
		mysql_escape_string(text,clean_name);

		format(szQuery, sizeof(szQuery), "UPDATE `faction_warehouse` SET `fw_player2` = '%s' WHERE `fw_id` = %d", clean_name, WareHouseInfo[warehouseid][whID]);
		mysql_query(dbCon, szQuery);

		strpack(WareHouseInfo[warehouseid][whPlayer2], text, MAX_PLAYER_NAME char);
		SendClientMessageEx(playerid, COLOR_GRAD2, "คุณกำหนด #2 ให้ %s ใช้งาน Warehouse", text);
	}
	else if(type == 3)
	{
		format(szQuery, sizeof(szQuery), "UPDATE `faction_warehouse` SET `fw_stock` = %d WHERE `fw_id` = %d", input, WareHouseInfo[warehouseid][whID]);
		mysql_query(dbCon, szQuery);
		WareHouseInfo[warehouseid][whStock] = input;
		SendClientMessageEx(playerid, COLOR_GRAD2, "คุณกำหนดจำนวนสินค้าใน Warehouse เป็น %d", WareHouseInfo[warehouseid][whStock]);
        Warehouse_Refresh(warehouseid);
	}
	else if(type == 4)
	{
		format(szQuery, sizeof(szQuery), "UPDATE `faction_warehouse` SET `fw_maxstock` = %d WHERE `fw_id` = %d", input, WareHouseInfo[warehouseid][whID]);
		mysql_query(dbCon, szQuery);
		WareHouseInfo[warehouseid][whMaxstock] = input;
		SendClientMessageEx(playerid, COLOR_GRAD2, "คุณกำหนดจำนวนสูงสุดของสินค้าใน Warehouse เป็น %d", WareHouseInfo[warehouseid][whMaxstock]);
        Warehouse_Refresh(warehouseid);
	}
	else if(type == 5)
	{
		if(input < 1 || input > 2) return SendClientMessage(playerid, COLOR_GRAD2, "จำนวน 1-2 เท่านั้น");
		format(szQuery, sizeof(szQuery), "UPDATE `faction_warehouse` SET `fw_type` = %d WHERE `fw_id` = %d", input, WareHouseInfo[warehouseid][whID]);
		mysql_query(dbCon, szQuery);
		WareHouseInfo[warehouseid][whType] = input;
        Warehouse_Refresh(warehouseid);
		SendClientMessageEx(playerid, COLOR_GRAD2, "คุณกำหนดประเภทของ Warehouse เป็น %s", WareHouseInfo[warehouseid][whType] == 1 ? ("Weapon") : ("Drug"));
	}
	else if(type == 6)
	{
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);

		if(IsValidDynamic3DTextLabel(WareHouseInfo[warehouseid][whLabel]))
			DestroyDynamic3DTextLabel(WareHouseInfo[warehouseid][whLabel]);

		WareHouseInfo[warehouseid][whX] = x;
		WareHouseInfo[warehouseid][whY] = y;
		WareHouseInfo[warehouseid][whZ] = z;

		WareHouseInfo[warehouseid][whWorld] = GetPlayerVirtualWorld(playerid);
		WareHouseInfo[warehouseid][whInt] = GetPlayerInterior(playerid);

		Warehouse_Refresh(warehouseid);

		format(szQuery, sizeof(szQuery), "UPDATE `faction_warehouse` SET fw_x = %f, fw_y = %f, fw_z = %f, fw_world = %d, fw_int = %d WHERE `fw_id` = %d", x, y, z, WareHouseInfo[warehouseid][whWorld], WareHouseInfo[warehouseid][whInt], WareHouseInfo[warehouseid][whID]);
		mysql_query(dbCon, szQuery);

		SendClientMessage(playerid, COLOR_GRAD2, "คุณกำหนดตำแหน่งใหม่ของ Warehouse เรียบร้อยแล้ว");
	}

	return 1;
}

saveWarehouse(warehouseid) {

    new szQuery[128];

	format(szQuery, sizeof(szQuery), "UPDATE `faction_warehouse` SET `fw_stock` = '%d' WHERE `fw_id` = %d", WareHouseInfo[warehouseid][whStock], WareHouseInfo[warehouseid][whID]);
	mysql_query(dbCon, szQuery);
}

CMD:listcraft(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "รายละเอียดการสร้างอาวุธ");
    SendClientMessageEx(playerid, -1, "Knife: เหล็ก 150, ดินปืน, 180, ถ่าน, 100, เงินสด $25,000");
    SendClientMessageEx(playerid, -1, "Katana: เหล็ก 170, ดินปืน, 280, ถ่าน, 150, เงินสด $40,000");
	SendClientMessageEx(playerid, -1, "Colt: เหล็ก 200, ดินปืน, 300, ถ่าน, 170, เงินสด $52,000 ");
    SendClientMessageEx(playerid, -1, "Deagle: เหล็ก 270, ดินปืน 350, ถ่าน 200, เพรช 300 เงินสด $70,000");

    SendClientMessageEx(playerid, -1, "Shotgun: เหล็ก 350, ดินปืน 400, ถ่าน 250, เพรช 500 เงินสด $90,000, เงินผิดกฏหมาย $50,000");
	SendClientMessageEx(playerid, -1, "Tec9: เหล็ก 450, ดินปืน, 500, ถ่าน, 300, เงินสด $100,000, เงินผิดกฏหมาย $70,000");
    SendClientMessageEx(playerid, -1, "Uzi: เหล็ก 600, ดินปืน, 700, ถ่าน, 450, เงินสด $150,000, เงินผิดกฏหมาย $100,000");
    return 1;
}

CMD:buyweapon(playerid, params[])
{
	/*new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);

	if (factionType == FACTION_TYPE_GANG) {*/

	new id;
	if((id = Warehouse_Nearest(playerid)) != -1 && WareHouseInfo[id][whType] == 1)
	{
//	    new warehousetemp1[MAX_PLAYER_NAME+1];
//	    new warehousetemp2[MAX_PLAYER_NAME+1];
	    
//	    strunpack(warehousetemp1, WareHouseInfo[id][whPlayer1]);
//	    strunpack(warehousetemp2, WareHouseInfo[id][whPlayer2]);
	    
//        if((strlen(warehousetemp1) && !strcmp(ReturnPlayerName(playerid), warehousetemp1, true)) || (strlen(warehousetemp2) && !strcmp(ReturnPlayerName(playerid), warehousetemp2, true)))
{

			if(WareHouseInfo[id][whStock] == 0)
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "ขออภัย, สินค้าของคุณหมดแล้ว");
				return 1;
			}

			new type[24];

			if(sscanf(params,"s[24]D(0)S()[16]", type)) {
				SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: "EMBED_WHITE"/buyweapon [อาวุธ]");
                SendClientMessage(playerid, COLOR_WHITE, "คุณสามารถพิมพ์ /listcraft เพื่อดูรายละเอียดในการสร้างอาวุธจาก Warehouse");
				return 1;
			}

			if(!strcmp(type, "Knife", true))
			{
                if (playerData[playerid][pCash] < 25000)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเงินมากกว่า $25,000");

                if (playerData[playerid][pMaterials] < 180)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีดินปืนมากกว่า 180");

                if (playerData[playerid][pIrons] < 150)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเหล็กมากกว่า 150");

                if (playerData[playerid][pCold] < 100)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีถ่านมากกว่า 100");

                GivePlayerValidWeapon(playerid, 4, 1);
                OnAccountUpdate(playerid);

                playerData[playerid][pMaterials] -= 180;
                playerData[playerid][pIrons] -= 150;
                playerData[playerid][pCold] -= 100;

                GivePlayerMoneyEx(playerid, -250000);

				WareHouseInfo[id][whStock]--;
				Warehouse_Refresh(id);

				return 1;
			}

			if(!strcmp(type, "Katana", true))
			{
                if (playerData[playerid][pCash] < 40000)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเงินมากกว่า $40,000");

                if (playerData[playerid][pMaterials] < 280)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีดินปืนมากกว่า 280");

                if (playerData[playerid][pIrons] < 170)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเหล็กมากกว่า 170");

                if (playerData[playerid][pCold] < 150)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีถ่านมากกว่า 150");

                GivePlayerValidWeapon(playerid, 8, 1);
                OnAccountUpdate(playerid);

                playerData[playerid][pMaterials] -= 280;
                playerData[playerid][pIrons] -= 170;
                playerData[playerid][pCold] -= 150;

                GivePlayerMoneyEx(playerid, -40000);

				WareHouseInfo[id][whStock]--;
				Warehouse_Refresh(id);

				return 1;
			}

			if(!strcmp(type, "Colt", true))
			{
                if (playerData[playerid][pCash] < 52000)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเงินมากกว่า $52,000");

                if (playerData[playerid][pMaterials] < 300)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีดินปืนมากกว่า 300");

                if (playerData[playerid][pIrons] < 200)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเหล็กมากกว่า 200");

                if (playerData[playerid][pCold] < 170)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีถ่านมากกว่า 170");

                GivePlayerValidWeapon(playerid, 22, 100);
                OnAccountUpdate(playerid);

                playerData[playerid][pMaterials] -= 300;
                playerData[playerid][pIrons] -= 200;
                playerData[playerid][pCold] -= 170;

                GivePlayerMoneyEx(playerid, -42000);

				WareHouseInfo[id][whStock]--;
				Warehouse_Refresh(id);

				return 1;
			}

			if(!strcmp(type, "Deagle", true))
			{
                if (playerData[playerid][pCash] < 70000)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเงินมากกว่า $70,000");

                if (playerData[playerid][pMaterials] < 350)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีดินปืนมากกว่า 350");

                if (playerData[playerid][pIrons] < 270)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเหล็กมากกว่า 270");

                if (playerData[playerid][pCold] < 200)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีถ่านมากกว่า 200");

                if (playerData[playerid][pDiamond] < 300)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเพรชมากกว่า 300");

                GivePlayerValidWeapon(playerid, 24, 100);
                OnAccountUpdate(playerid);

                playerData[playerid][pMaterials] -= 350;
                playerData[playerid][pIrons] -= 270;
                playerData[playerid][pCold] -= 200;
				playerData[playerid][pDiamond] -= 300;

                GivePlayerMoneyEx(playerid, -70000);

				WareHouseInfo[id][whStock]--;
				Warehouse_Refresh(id);

				return 1;
			}

			if(!strcmp(type, "Shotgun", true))
			{
			
                if (playerData[playerid][pCash] < 90000)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเงินมากกว่า $90,000");

                if (playerData[playerid][pMaterials] < 400)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีดินปืนมากกว่า 400");

                if (playerData[playerid][pIrons] < 350)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเหล็กมากกว่า 350");

                if (playerData[playerid][pCold] < 250)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีถ่านมากกว่า 250");

                if (playerData[playerid][pDiamond] < 500)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเพรชมากกว่า 500");

                GivePlayerValidWeapon(playerid, 25, 70);
                OnAccountUpdate(playerid);

                playerData[playerid][pMaterials] -= 400;
                playerData[playerid][pIrons] -= 350;
                playerData[playerid][pCold] -= 130;
				playerData[playerid][pDiamond] -= 500;

                GivePlayerMoneyEx(playerid, -90000);
                playerData[playerid][pRMoney] += -50000;

				WareHouseInfo[id][whStock]--;
				Warehouse_Refresh(id);

				return 1;
			}
            
			if(!strcmp(type, "Tec9", true))
			{
			
                if (playerData[playerid][pCash] < 100000)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเงินมากกว่า $100,000");

                if (playerData[playerid][pMaterials] < 500)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีดินปืนมากกว่า 500");

                if (playerData[playerid][pIrons] < 450)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเหล็กมากกว่า 450");

                if (playerData[playerid][pCold] < 300)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีถ่านมากกว่า 300");

                GivePlayerValidWeapon(playerid, 32, 100);
                OnAccountUpdate(playerid);

                playerData[playerid][pMaterials] -= 500;
                playerData[playerid][pIrons] -= 450;
                playerData[playerid][pCold] -= 300;

                GivePlayerMoneyEx(playerid, -100000);
                playerData[playerid][pRMoney] += -70000;

				WareHouseInfo[id][whStock]--;
				Warehouse_Refresh(id);

				return 1;
			}

			if(!strcmp(type, "Uzi", true))
			{
			
                if (playerData[playerid][pCash] < 150000)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเงินมากกว่า $150,000");

                if (playerData[playerid][pMaterials] < 700)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีดินปืนมากกว่า 700");

                if (playerData[playerid][pIrons] < 600)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเหล็กมากกว่า 600");

                if (playerData[playerid][pCold] < 450)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีถ่านมากกว่า 450");

                GivePlayerValidWeapon(playerid, 32, 150);
                OnAccountUpdate(playerid);

                playerData[playerid][pMaterials] -= 700;
                playerData[playerid][pIrons] -= 600;
                playerData[playerid][pCold] -= 450;

                GivePlayerMoneyEx(playerid, -150000);
                playerData[playerid][pRMoney] += -100000;
                
				WareHouseInfo[id][whStock]--;
				Warehouse_Refresh(id);

				return 1;
			}

        }
//		else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้รับอนุณาตให้ใช้คำสั่งนี้");
	}
	else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ที่ Warehouse");

    return 1;
}
