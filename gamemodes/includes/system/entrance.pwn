#include <YSI\y_hooks>

#define MAX_ENTRANCE    			100
#define DEFAULT_ENTRANCE_PICKUP 	1314 	// ไอดีไอคอนเริ่มต้น
#define ENTRANCE_WORLD  			2000

#define ENTRANCE_TYPE_NONE			0
#define ENTRANCE_TYPE_CP			1

new Iterator:Iter_Entrance<MAX_ENTRANCE>;

enum E_ENTRANCE_DATA
{
	eID,
	eName[60],
    Float:extX,
    Float:extY,
    Float:extZ,
    Float:extA,
    extInt,
    extWorld,
    eExtName[60],
	eIntText[60],
    Float:intX,
    Float:intY,
    Float:intZ,
    Float:intA,
    eIntName[60],
	eExtText[60],
    eInt,
    eWorld,
    eIntPickupModel,
    eExtPickupModel,
	eType,
    eIntPickup,
    eExtPickup,
	eFactionID,
	bool:eLocked,
    STREAMER_TAG_3D_TEXT_LABEL:eExtLabel,
    STREAMER_TAG_3D_TEXT_LABEL:eIntLabel,
	eCheckPoint
};

new entranceData[MAX_ENTRANCE][E_ENTRANCE_DATA];

hook OnGameModeInit() {
	mysql_tquery(dbCon, "SELECT * FROM `entrance`", "Entrance_Load", "");
	return 1;
}

forward Entrance_Load();
public Entrance_Load() {

    new
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_ENTRANCE)
	{
        cache_get_value_name_int(i, "id", entranceData[i][eID]);
        cache_get_value_name(i, "name", entranceData[i][eName], 60);
        cache_get_value_name_float(i, "extX", entranceData[i][extX]);
        cache_get_value_name_float(i, "extY", entranceData[i][extY]);
        cache_get_value_name_float(i, "extZ", entranceData[i][extZ]);
        cache_get_value_name_float(i, "extA", entranceData[i][extA]);
        cache_get_value_name(i, "extName", entranceData[i][eExtName], 60);
		cache_get_value_name(i, "extText", entranceData[i][eExtText], 60);
        cache_get_value_name_int(i, "extInterior", entranceData[i][extInt]);
        cache_get_value_name_int(i, "extWorld", entranceData[i][extWorld]);
        cache_get_value_name_float(i, "intX", entranceData[i][intX]);
        cache_get_value_name_float(i, "intY", entranceData[i][intY]);
        cache_get_value_name_float(i, "intZ", entranceData[i][intZ]);
        cache_get_value_name_float(i, "intA", entranceData[i][intA]);
        cache_get_value_name(i, "intName", entranceData[i][eIntName], 60);
		cache_get_value_name(i, "intText", entranceData[i][eIntText], 60);
        cache_get_value_name_int(i, "Interior", entranceData[i][eInt]);
        cache_get_value_name_int(i, "World", entranceData[i][eWorld]);
        cache_get_value_name_int(i, "intPickup", entranceData[i][eIntPickupModel]);
        cache_get_value_name_int(i, "extPickup", entranceData[i][eExtPickupModel]);
		cache_get_value_name_int(i, "type", entranceData[i][eType]);
		cache_get_value_name_int(i, "faction_id", entranceData[i][eFactionID]);

        Entrance_Update(i);

        Iter_Add(Iter_Entrance, i);
	}

    printf("Entrance loaded (%d/%d)", Iter_Count(Iter_Entrance), MAX_ENTRANCE);
	return 1;
}

Entrance_Save(id=-1) {
    if(Iter_Contains(Iter_Entrance, id)) {
        new query[MAX_STRING];
        MySQLUpdateInit("entrance", "id", entranceData[id][eID], MYSQL_UPDATE_TYPE_THREAD); 
        MySQLUpdateStr(query, "name", entranceData[id][eName]);
        MySQLUpdateFlo(query, "extX", entranceData[id][extX]);
        MySQLUpdateFlo(query, "extY", entranceData[id][extY]);
        MySQLUpdateFlo(query, "extZ", entranceData[id][extZ]);
        MySQLUpdateFlo(query, "extA", entranceData[id][extA]);
        MySQLUpdateStr(query, "extName", entranceData[id][eExtName]);
		MySQLUpdateStr(query, "extText", entranceData[id][eExtText]);
        MySQLUpdateInt(query, "extInterior", entranceData[id][extInt]);
        MySQLUpdateInt(query, "extWorld", entranceData[id][extWorld]);
        MySQLUpdateFlo(query, "intX", entranceData[id][intX]);
        MySQLUpdateFlo(query, "intY", entranceData[id][intY]);
        MySQLUpdateFlo(query, "intZ", entranceData[id][intZ]);
        MySQLUpdateFlo(query, "intA", entranceData[id][intA]);
        MySQLUpdateStr(query, "intName", entranceData[id][eIntName]);
		MySQLUpdateStr(query, "intText", entranceData[id][eIntText]);
        MySQLUpdateInt(query, "Interior", entranceData[id][eInt]);
        MySQLUpdateInt(query, "World", entranceData[id][eWorld]);
        MySQLUpdateInt(query, "intPickup", entranceData[id][eIntPickupModel]);
        MySQLUpdateInt(query, "extPickup", entranceData[id][eExtPickupModel]);
		MySQLUpdateInt(query, "type", entranceData[id][eType]);
		MySQLUpdateInt(query, "faction_id", entranceData[id][eFactionID]);
		MySQLUpdateFinish(query);
    }
    return 1;
}

Entrance_Update(id) {

	if(IsValidDynamic3DTextLabel(entranceData[id][eExtLabel])) 
		DestroyDyn3DTextLabelFix(entranceData[id][eExtLabel]);
	if(IsValidDynamic3DTextLabel(entranceData[id][eIntLabel])) 
		DestroyDyn3DTextLabelFix(entranceData[id][eIntLabel]);
	if(IsValidDynamicPickup(entranceData[id][eExtPickup])) 
		DestroyDynamicPickup(entranceData[id][eExtPickup]);
	if(IsValidDynamicPickup(entranceData[id][eIntPickup])) 
		DestroyDynamicPickup(entranceData[id][eIntPickup]);

  	if(IsValidDynamicCP(entranceData[id][eCheckPoint])) 
		DestroyDynamicCP(entranceData[id][eCheckPoint]);      
    // ภายนอก
    if(entranceData[id][eExtPickupModel])
        entranceData[id][eExtPickup] = CreateDynamicPickup(entranceData[id][eExtPickupModel], 23, entranceData[id][extX], entranceData[id][extY], entranceData[id][extZ], entranceData[id][extWorld], entranceData[id][extInt]);

	entranceData[id][eExtLabel] = CreateDynamic3DTextLabel(sprintf("%s", entranceData[id][eExtName]), -1, entranceData[id][extX], entranceData[id][extY], entranceData[id][extZ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, entranceData[id][extWorld], entranceData[id][extInt]);
    // ภายใน
    if(entranceData[id][eIntPickupModel])
        entranceData[id][eIntPickup] = CreateDynamicPickup(entranceData[id][eIntPickupModel], 23, entranceData[id][intX], entranceData[id][intY], entranceData[id][intZ], entranceData[id][eWorld], entranceData[id][eInt]);

	entranceData[id][eIntLabel] = CreateDynamic3DTextLabel(sprintf("%s", entranceData[id][eIntName]), -1, entranceData[id][intX], entranceData[id][intY], entranceData[id][intZ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, entranceData[id][eWorld], entranceData[id][eInt]);

	if(entranceData[id][eType] == ENTRANCE_TYPE_CP) {
		entranceData[id][eCheckPoint] = CreateDynamicCP(entranceData[id][extX], entranceData[id][extY], entranceData[id][extZ], 3.0, entranceData[id][extWorld], entranceData[id][extInt], -1, 3.0);
		//Streamer_SetIntData(STREAMER_TYPE_CP, entranceData[id][eCheckPoint], E_STREAMER_EXTRA_ID, id);
	}
	return 1;
}

forward OnEntranceCreated(playerid, id);
public OnEntranceCreated(playerid, id)
{
	new insert_id = cache_insert_id();
	if(insert_id) {
		entranceData[id][eID] = insert_id;
		Entrance_Update(id);
		Entrance_Save(id);

		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้สร้างทางเข้าไอดี %d", ReturnPlayerName(playerid), entranceData[id][eID]);
	}
	else {
		Iter_Remove(Iter_Entrance, id);
		SendClientMessage(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"ไม่สามารถเพิ่มข้อมูลทางเข้าลงฐานข้อมูลได้ โปรดติดต่อ DEV");
	}

	return 1;
}

forward OnEntranceRemove(playerid, id);
public OnEntranceRemove(playerid, id)
{	
	if(IsValidDynamic3DTextLabel(entranceData[id][eExtLabel]))
		DestroyDyn3DTextLabelFix(entranceData[id][eExtLabel]);

	if(IsValidDynamic3DTextLabel(entranceData[id][eIntLabel]))
		DestroyDyn3DTextLabelFix(entranceData[id][eIntLabel]);

	if(IsValidDynamicPickup(entranceData[id][eExtPickup]))
		DestroyDynamicPickup(entranceData[id][eExtPickup]);

	if(IsValidDynamicPickup(entranceData[id][eIntPickup]))
		DestroyDynamicPickup(entranceData[id][eIntPickup]);

	SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้ทำลายทางเข้าไอดี "EMBED_YELLOW"%d", ReturnPlayerName(playerid), id +1);

	Iter_Remove(Iter_Entrance, id);
	return 1;
}

flags:entrancecmds(CMD_MANAGEMENT);
CMD:entrancecmds(playerid) {
    SendClientMessage(playerid, COLOR_GRAD1, "คำสั่ง: /makeentrance, /entrancelist, /entranceremove, /entrancetp");
    return 1;
}

flags:makeentrance(CMD_MANAGEMENT);
CMD:makeentrance(playerid, params[])
{
	new
        id,
		name[60],
        query[256];

	if (sscanf(params, "s[60]", name))
	{
        SendClientMessage(playerid, COLOR_GRAD1,    "การใช้: /makeentrance [ชื่อ] ");
		return 1;
	}

    if((id = Iter_Free(Iter_Entrance)) != -1) {

	    format(entranceData[id][eName], 60, name);
        GetPlayerPos(playerid, entranceData[id][extX], entranceData[id][extY], entranceData[id][extZ]);
        GetPlayerFacingAngle(playerid, entranceData[id][extA]);
        entranceData[id][extInt] = GetPlayerInterior(playerid);
        entranceData[id][extWorld] = GetPlayerVirtualWorld(playerid);
        entranceData[id][eExtPickupModel] = DEFAULT_ENTRANCE_PICKUP;

        mysql_format(dbCon, query, sizeof query, "INSERT INTO `entrance` (`name`) VALUES('%e')", name);
	    mysql_tquery(dbCon, query, "OnEntranceCreated", "id", playerid, id);

        Iter_Add(Iter_Entrance, id);
    }
    else {
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"ไม่สามารถสร้างทางเข้าได้มากกว่านี้แล้ว จำกัดไว้ที่ %d");
	}
	return 1;
}

flags:entrancelist(CMD_MANAGEMENT);
CMD:entrancelist(playerid) {
    Entrance_List(playerid);
    return 1;
}

flags:entranceremove(CMD_MANAGEMENT);
CMD:entranceremove(playerid, params[]) {
	new string[128], objectid;
	if(sscanf(params,"d",objectid)) {
        SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /entranceremove [ไอดี] ");
		return 1;
	}
    objectid--;
    
	if(Iter_Contains(Iter_Entrance, objectid))
	{
		format(string, sizeof(string), "DELETE FROM `entrance` WHERE `id` = %d", entranceData[objectid][eID]);
		mysql_tquery(dbCon, string, "OnEntranceRemove", "ii", playerid, objectid);
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTRED,"ผิดพลาด: "EMBED_WHITE"ไม่พบทางเข้าไอดีที่ระบุ");
	}
	return 1;
}


Entrance_List(playerid)
{
	new string[2048], menu[20], count;

	format(string, sizeof(string), "%sหน้า 1\n", string);

	SetPVarInt(playerid, "page", 1);

	foreach(new i : Iter_Entrance) {
		if(count == 20)
		{
			format(string, sizeof(string), "%sหน้า 2\n", string);
			break;
		}
		format(menu, 20, "menu%d", ++count);
		SetPVarInt(playerid, menu, i);
		format(string, sizeof(string), "%s(%i) | %s\n", string, i + 1, entranceData[i][eName]);
	}
	if(!count) Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "รายชื่อทางเข้า", "ไม่พบข้อมูลของทางเข้า..", "ปิด", "");
	else Dialog_Show(playerid, EntrancesList, DIALOG_STYLE_LIST, "รายชื่อทางเข้า", string, "แก้ไข", "กลับ");
	return 1;
}

Dialog:EntrancesList(playerid, response, listitem, inputtext[])
{
	if(response) {

		new menu[20];
		//Navigate
		if(listitem != 0 && listitem != 21) {
			new str_biz[20];
			format(str_biz, 20, "menu%d", listitem);

			SetPVarInt(playerid, "EntranceEditID", GetPVarInt(playerid, str_biz));
			ShowPlayerEditEntrance(playerid);
			return 1;
		}

		new currentPage = GetPVarInt(playerid, "page");
		if(listitem==0) {
			if(currentPage>1) currentPage--;
		}
		else if(listitem == 21) currentPage++;

		new string[2048], count;
		format(string, sizeof(string), "%sหน้า %d\n", string, (currentPage==1) ? 1 : currentPage-1);

		SetPVarInt(playerid, "page", currentPage);

		new skipitem = (currentPage-1) * 20;

		foreach(new i : Iter_Entrance) {

			if(skipitem)
			{
				skipitem--;
				continue;
			}
			if(count == 20)
			{
				format(string, sizeof(string), "%sหน้า 2\n", string);
				break;
			}
			format(menu, 20, "menu%d", ++count);
			SetPVarInt(playerid, menu, i);
			format(string, sizeof(string), "%s(%i) | %s\n", string, i + 1, entranceData[i][eName]);

		}

		Dialog_Show(playerid, EntrancesList, DIALOG_STYLE_LIST, "รายชื่อทางเข้า", string, "แก้ไข", "กลับ");
	}
	return 1;
}


ShowPlayerEditEntrance(playerid)
{
    new id = GetPVarInt(playerid, "EntranceEditID");
	if(Iter_Contains(Iter_Entrance, id))
	{
		new caption[128], dialog_str[1024];
		format(caption, sizeof(caption), "แก้ไขแฟคชั่น: "EMBED_LIGHTGREEN"%s"EMBED_WHITE"", entranceData[id][eName]);
        format(dialog_str, sizeof dialog_str, "ชื่อทางเข้า\nข้อความลอย (3DText)\nไอคอน (Pickup)\nการแจ้งเตือน (Gametext)\nประเภท\nเชื่อมต่อโลกจำลอง (%s)\nตั้งจุดวาร์ป\nวาร์ปไปยังทางเข้านี้", entranceData[id][eWorld] == ENTRANCE_WORLD + entranceData[id][eID] ? ("ค่าเริ่มต้น") : ("เชื่อมต่ออยู่"));
		Dialog_Show(playerid, EntranceEdit, DIALOG_STYLE_LIST, caption, dialog_str, "แก้ไข", "กลับ");
	}
	return 1;
}

Dialog:EntranceEdit(playerid, response, listitem, inputtext[])
{
	if(response) {

		new caption[128];    
        new id = GetPVarInt(playerid, "EntranceEditID");
		switch(listitem)
		{
			case 0: // แก้ไขชื่อ
			{
				format(caption, sizeof(caption), "แก้ไข -> ชื่อ: "EMBED_LIGHTGREEN"%s", entranceData[id][eName]);
				Dialog_Show(playerid, DialogEnt_Name, DIALOG_STYLE_INPUT, caption, ""EMBED_WHITE"ความยาวของชื่อต้องมากกว่า "EMBED_ORANGE"0 "EMBED_WHITE"และไม่เกิน "EMBED_ORANGE"60 "EMBED_WHITE"ตัวอักษร\n\nกรอกชื่อทางเข้าที่ต้องการในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ");
			}
			case 1:
			{
				Dialog_Show(playerid, DialogEnt_3DText, DIALOG_STYLE_TABLIST, "แก้ไข -> ข้อความลอย", "ขาเข้า\t%s\nขาออก\t%s", "เลือก", "กลับ", entranceData[id][eExtName], entranceData[id][eIntName]);
			}
			case 2:
			{
				Dialog_Show(playerid, DialogEnt_Pickup, DIALOG_STYLE_TABLIST, "แก้ไข -> ไอคอน", "ขาเข้า\t%d\nขาออก\t%d", "เลือก", "กลับ", entranceData[id][eExtPickupModel], entranceData[id][eIntPickupModel]);
			}
			case 3: {
				Dialog_Show(playerid, DialogEnt_Notice, DIALOG_STYLE_TABLIST, "แก้ไข -> การแจ้งเตือน", "ขาเข้า\t%s\nขาออก\t%s", "เลือก", "กลับ", entranceData[id][eIntText], entranceData[id][eExtText]);
			}
			case 4: {
				Dialog_Show(playerid, DialogEnt_Type, DIALOG_STYLE_LIST, "แก้ไข -> ประเภท", "ค่าเริ่มต้น\nแฟคชั่น/บ้าน (เช็คพ้อย)", "เลือก", "กลับ", entranceData[id][eIntText], entranceData[id][eExtText]);
			}
			case 5: {
				Dialog_Show(playerid, DialogEnt_Link, DIALOG_STYLE_LIST, "แก้ไข -> เชื่อมต่อโลกจำลอง", "ค่าเริ่มต้น\nทางเข้า", "เลือก", "กลับ", entranceData[id][eIntText], entranceData[id][eExtText]);
			}
			case 6: {
				Dialog_Show(playerid, DialogEnt_Teleport, DIALOG_STYLE_LIST, "แก้ไข -> ตั้งจุดวาร์ป", "ขาเข้า\nขาออก", "เลือก", "กลับ");
			}
			case 7: {
				SetPlayerPos(playerid, entranceData[id][extX], entranceData[id][extY], entranceData[id][extZ]);
				SetPlayerInterior(playerid, entranceData[id][extInt]);
				SetPlayerVirtualWorld(playerid, entranceData[id][extWorld]);
				SetPlayerFacingAngle(playerid, entranceData[id][extA]);

				SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณได้วาร์ปไปยังทางเข้า %s(%d) ", entranceData[id][eName], id+1);
			}
		}
	}
	else
	{
	    DeletePVar(playerid, "EntranceEditID");
        Entrance_List(playerid);
	}
    return 1;
}

Dialog:DialogEnt_Name(playerid, response, listitem, inputtext[])
{
	if(response) {
		new caption[128];
		new id = GetPVarInt(playerid, "EntranceEditID");

		if(isnull(inputtext) || strlen(inputtext) >= 60) {
			format(caption, sizeof(caption), "แก้ไข -> ชื่อ: "EMBED_LIGHTGREEN"%s", entranceData[id][eName]);
			Dialog_Show(playerid, DialogEnt_Name, DIALOG_STYLE_INPUT, caption, ""EMBED_LIGHTRED"พบข้อผิดพลาด:\n"EMBED_WHITE"ความยาวของชื่อต้องมากกว่า "EMBED_YELLOW"0 "EMBED_WHITE"และไม่เกิน "EMBED_YELLOW"60 "EMBED_WHITE"ตัวอักษร", "เปลี่ยน", "กลับ");
			return 1;
		}
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนชื่อทางเข้า %s(%d) เป็น %s", ReturnPlayerName(playerid), entranceData[id][eName], id + 1, inputtext);
		Log(adminactionlog, INFO, "%s: เปลี่ยนชื่อทางเข้า %s(%d) จาก %s เป็น %s", ReturnPlayerName(playerid), entranceData[id][eName], entranceData[id][eID], entranceData[id][eName], inputtext);

		format(entranceData[id][eName], 60, inputtext);
		Entrance_Save(id);
	}
	return ShowPlayerEditEntrance(playerid);
}

Dialog:DialogEnt_3DText(playerid, response, listitem, inputtext[])
{
	if(response) {

		new caption[128];
		new id = GetPVarInt(playerid, "EntranceEditID");

		switch(listitem) {
			case 0: // ขาเข้า
			{
				format(caption, sizeof(caption), "แก้ไข -> ข้อความลอยขาเข้า: "EMBED_LIGHTGREEN"%s", entranceData[id][eExtName]);
				Dialog_Show(playerid, DialogEnt_EnterName, DIALOG_STYLE_INPUT, caption, ""EMBED_WHITE"ความยาวของชื่อต้องไม่เกิน "EMBED_ORANGE"60 "EMBED_WHITE"ตัวอักษร\n\nกรอกชื่อทางเข้าที่ต้องการในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ");
			}

			case 1: // ขาออก
			{
				format(caption, sizeof(caption), "แก้ไข -> ข้อความลอยขาออก: "EMBED_LIGHTGREEN"%s", entranceData[id][eIntName]);
				Dialog_Show(playerid, DialogEnt_ExitName, DIALOG_STYLE_INPUT, caption, ""EMBED_WHITE"ความยาวของชื่อต้องไม่เกิน "EMBED_ORANGE"60 "EMBED_WHITE"ตัวอักษร\n\nกรอกชื่อทางเข้าที่ต้องการในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ");
			}
		}
		return 1;
	}
	return ShowPlayerEditEntrance(playerid);
}

Dialog:DialogEnt_EnterName(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "EntranceEditID");

	if(response) {
		new caption[128];

		if(strlen(inputtext) >= 60) {
			format(caption, sizeof(caption), "แก้ไข -> ข้อความลอยขาเข้า: "EMBED_LIGHTGREEN"%s", entranceData[id][eExtName]);
			Dialog_Show(playerid, DialogEnt_Name, DIALOG_STYLE_INPUT, caption, ""EMBED_LIGHTRED"พบข้อผิดพลาด:\n"EMBED_WHITE"ความยาวของชื่อต้องไม่เกิน "EMBED_YELLOW"60 "EMBED_WHITE"ตัวอักษร", "เปลี่ยน", "กลับ");
			return 1;
		}

		if(isnull(inputtext)) {
			SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้ลบข้อความขาเข้า %s(%d)", ReturnPlayerName(playerid), entranceData[id][eName], id + 1);
			Log(adminactionlog, INFO, "%s: ลบข้อความขาเข้า %s(%d)", ReturnPlayerName(playerid), entranceData[id][eName], entranceData[id][eID]);

			entranceData[id][eExtName][0] = '\0';
		}
		else {
			SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนข้อความขาเข้า %s(%d) เป็น %s", ReturnPlayerName(playerid), entranceData[id][eName], id + 1, inputtext);
			Log(adminactionlog, INFO, "%s: ข้อความขาเข้า %s(%d) เป็น %s", ReturnPlayerName(playerid), entranceData[id][eName], entranceData[id][eID], inputtext);

			format(entranceData[id][eExtName], 60, inputtext);
		}
		Entrance_Update(id);
		Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);

		Entrance_Save(id);
	}
	return Dialog_Show(playerid, DialogEnt_3DText, DIALOG_STYLE_TABLIST, "แก้ไข -> ข้อความลอย", "ขาเข้า\t%s\nขาออก\t%s", "เลือก", "กลับ", entranceData[id][eExtName], entranceData[id][eIntName]);
}

Dialog:DialogEnt_ExitName(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "EntranceEditID");

	if(response) {
		new caption[128];

		if(strlen(inputtext) >= 60) {
			format(caption, sizeof(caption), "แก้ไข -> ข้อความลอยขาออก: "EMBED_LIGHTGREEN"%s", entranceData[id][eIntName]);
			Dialog_Show(playerid, DialogEnt_Name, DIALOG_STYLE_INPUT, caption, ""EMBED_LIGHTRED"พบข้อผิดพลาด:\n"EMBED_WHITE"ความยาวของชื่อต้องไม่เกิน "EMBED_YELLOW"60 "EMBED_WHITE"ตัวอักษร", "เปลี่ยน", "กลับ");
			return 1;
		}

		if(isnull(inputtext)) {
			SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้ลบข้อความขาออก %s(%d)", ReturnPlayerName(playerid), entranceData[id][eName], id + 1);
			Log(adminactionlog, INFO, "%s: ลบข้อความขาออก %s(%d)", ReturnPlayerName(playerid), entranceData[id][eName], entranceData[id][eID]);

			entranceData[id][eIntName][0] = '\0';
		}
		else {
			SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนข้อความขาออก %s(%d) เป็น %s", ReturnPlayerName(playerid), entranceData[id][eName], id + 1, inputtext);
			Log(adminactionlog, INFO, "%s: ข้อความขาออก %s(%d) เป็น %s", ReturnPlayerName(playerid), entranceData[id][eName], entranceData[id][eID], inputtext);

			format(entranceData[id][eIntName], 60, inputtext);
		}

		Entrance_Update(id);
		Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);

		Entrance_Save(id);
	}
	return Dialog_Show(playerid, DialogEnt_3DText, DIALOG_STYLE_TABLIST, "แก้ไข -> ข้อความลอย", "ขาเข้า\t%s\nขาออก\t%s", "เลือก", "กลับ", entranceData[id][eExtName], entranceData[id][eIntName]);
}

Dialog:DialogEnt_Pickup(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "EntranceEditID");
	if(response) {
		new caption[128];
		switch(listitem) {
			case 0: // ขาเข้า
			{
				format(caption, sizeof(caption), "แก้ไข -> ไอคอนขาเข้า: "EMBED_LIGHTGREEN"%d", entranceData[id][eExtPickupModel]);
				Dialog_Show(playerid, DialogEnt_ExtIcon, DIALOG_STYLE_INPUT, caption, ""EMBED_WHITE"ใช้ "EMBED_ORANGE"0"EMBED_WHITE" เพื่อซ่อนไอคอน\n\nกรอกไอดีไอคอนที่ต้องการในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ");
			}

			case 1: // ขาออก
			{
				format(caption, sizeof(caption), "แก้ไข -> ไอคอนขาออก: "EMBED_LIGHTGREEN"%d", entranceData[id][eIntPickupModel]);
				Dialog_Show(playerid, DialogEnt_IntIcon, DIALOG_STYLE_INPUT, caption, ""EMBED_WHITE"ใช้ "EMBED_ORANGE"0"EMBED_WHITE" เพื่อซ่อนไอคอน\n\nกรอกไอดีไอคอนที่ต้องการในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ");
			}
		}
		return 1;
	}
	return ShowPlayerEditEntrance(playerid);
}

Dialog:DialogEnt_ExtIcon(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "EntranceEditID");
	if(response) {
		new typeint = strval(inputtext);
		if(typeint < 0) {
            new caption[128];
            format(caption, sizeof(caption), "แก้ไข -> ไอคอนขาเข้า: "EMBED_LIGHTGREEN"%d", entranceData[id][eExtPickupModel]);
			return Dialog_Show(playerid, DialogEnt_ExtIcon, DIALOG_STYLE_INPUT, caption, ""EMBED_LIGHTRED"พบข้อผิดพลาด: "EMBED_WHITE"ไอดีต้องไม่ต่ำกว่า "EMBED_ORANGE"0\n\n"EMBED_WHITE"ใช้ "EMBED_ORANGE"0"EMBED_WHITE" เพื่อซ่อนไอคอน\n\nกรอกไอดีไอคอนที่ต้องการในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ");
		}
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนไอคอนขาเข้า %s(%d) จาก %d เป็น %d", ReturnPlayerName(playerid), entranceData[id][eName], id + 1, entranceData[id][eExtPickupModel], typeint);
		Log(adminactionlog, INFO, "%s: เปลี่ยนไอคอนขาเข้าของ %s(%d) จาก %d เป็น %d", ReturnPlayerName(playerid), entranceData[id][eName], entranceData[id][eID], entranceData[id][eExtPickupModel], typeint);

	    entranceData[id][eExtPickupModel] = typeint;
		Entrance_Update(id);
		Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);
	    Entrance_Save(id);
	}
	return Dialog_Show(playerid, DialogEnt_Pickup, DIALOG_STYLE_TABLIST, "แก้ไข -> ไอคอน", "ขาเข้า\t%d\nขาออก\t%d", "เลือก", "กลับ", entranceData[id][eExtPickupModel], entranceData[id][eIntPickupModel]);
}


Dialog:DialogEnt_IntIcon(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "EntranceEditID");
	if(response) {
		new typeint = strval(inputtext);
		if(typeint < 0) {
            new caption[128];
            format(caption, sizeof(caption), "แก้ไข -> ไอคอนขาออก: "EMBED_LIGHTGREEN"%d", entranceData[id][eIntPickupModel]);
			return Dialog_Show(playerid, DialogEnt_ExtIcon, DIALOG_STYLE_INPUT, caption, ""EMBED_LIGHTRED"พบข้อผิดพลาด: "EMBED_WHITE"ไอดีต้องไม่ต่ำกว่า "EMBED_ORANGE"0\n\n"EMBED_WHITE"ใช้ "EMBED_ORANGE"0"EMBED_WHITE" เพื่อซ่อนไอคอน\n\nกรอกไอดีไอคอนที่ต้องการในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ");
		}
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนไอคอนขาออก %s(%d) จาก %d เป็น %d", ReturnPlayerName(playerid), entranceData[id][eName], id + 1, entranceData[id][eIntPickupModel], typeint);
		Log(adminactionlog, INFO, "%s: เปลี่ยนไอคอนขาออกของ %s(%d) จาก %d เป็น %d", ReturnPlayerName(playerid), entranceData[id][eName], entranceData[id][eID], entranceData[id][eIntPickupModel], typeint);

	    entranceData[id][eIntPickupModel] = typeint;
		Entrance_Update(id);
		Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);
	    Entrance_Save(id);
	}
	return Dialog_Show(playerid, DialogEnt_Pickup, DIALOG_STYLE_TABLIST, "แก้ไข -> ไอคอน", "ขาเข้า\t%d\nขาออก\t%d", "เลือก", "กลับ", entranceData[id][eExtPickupModel], entranceData[id][eIntPickupModel]);
}

Dialog:DialogEnt_Notice(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new caption[128];
		new id = GetPVarInt(playerid, "EntranceEditID");

		switch(listitem) {
			case 0: // ขาเข้า
			{
				format(caption, sizeof(caption), "แก้ไข -> การแจ้งเตือนขาเข้า: "EMBED_LIGHTGREEN"%s", entranceData[id][eIntText]);
				Dialog_Show(playerid, DialogEnt_TextEnter, DIALOG_STYLE_INPUT, caption, ""EMBED_WHITE"ความยาวของชื่อต้องไม่เกิน "EMBED_ORANGE"60 "EMBED_WHITE"ตัวอักษร\n\nกรอกชื่อทางเข้าที่ต้องการในช่องว่างด้านล่างนี้:\n\n"EMBED_LIGHTRED"หมายเหตุ: ใช้ภาษาอังกฤษเท่านั้น", "เปลี่ยน", "กลับ");
			}

			case 1: // ขาออก
			{
				format(caption, sizeof(caption), "แก้ไข -> การแจ้งเตือนขาออก: "EMBED_LIGHTGREEN"%s", entranceData[id][eExtText]);
				Dialog_Show(playerid, DialogEnt_TextExit, DIALOG_STYLE_INPUT, caption, ""EMBED_WHITE"ความยาวของชื่อต้องไม่เกิน "EMBED_ORANGE"60 "EMBED_WHITE"ตัวอักษร\n\nกรอกชื่อทางเข้าที่ต้องการในช่องว่างด้านล่างนี้:\n\n"EMBED_LIGHTRED"หมายเหตุ: ใช้ภาษาอังกฤษเท่านั้น", "เปลี่ยน", "กลับ");
			}
		}
		return 1;
	}
	return ShowPlayerEditEntrance(playerid);
}

Dialog:DialogEnt_TextEnter(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "EntranceEditID");

	if(response) {
		new caption[128];

		if(strlen(inputtext) >= 60) {
			format(caption, sizeof(caption), "แก้ไข -> การแจ้งเตือนขาเข้า: "EMBED_LIGHTGREEN"%s", entranceData[id][eIntText]);
			Dialog_Show(playerid, DialogEnt_TextEnter, DIALOG_STYLE_INPUT, caption, ""EMBED_LIGHTRED"พบข้อผิดพลาด:\n"EMBED_WHITE"ความยาวของชื่อต้องไม่เกิน "EMBED_YELLOW"60 "EMBED_WHITE"ตัวอักษร\n\n"EMBED_LIGHTRED"หมายเหตุ: ใช้ภาษาอังกฤษเท่านั้น", "เปลี่ยน", "กลับ");
			return 1;
		}
		/*if(!IsGameText(inputtext) && !isnull(inputtext)) {
			format(caption, sizeof(caption), "แก้ไข -> ข้อความลอยขาเข้า: "EMBED_LIGHTGREEN"%s", entranceData[id][eIntText]);
			Dialog_Show(playerid, DialogEnt_TextEnter, DIALOG_STYLE_INPUT, caption, ""EMBED_LIGHTRED"พบข้อผิดพลาด:\n"EMBED_WHITE"ใช้ข้อความภาษาอังกฤษเท่านั้น", "เปลี่ยน", "กลับ");
			return 1;
		}*/

		if(isnull(inputtext)) {
			SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้ลบการแจ้งเตือนขาเข้า %s(%d)", ReturnPlayerName(playerid), entranceData[id][eName], id + 1);
			Log(adminactionlog, INFO, "%s: ลบการแจ้งเตือนขาเข้า %s(%d)", ReturnPlayerName(playerid), entranceData[id][eName], entranceData[id][eID]);

			entranceData[id][eIntText][0] = '\0';
		}
		else {
			SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนการแจ้งเตือนขาเข้า %s(%d) เป็น %s", ReturnPlayerName(playerid), entranceData[id][eName], id + 1, inputtext);
			Log(adminactionlog, INFO, "%s: เปลี่ยนการแจ้งเตือนขาเข้า %s(%d) เป็น %s", ReturnPlayerName(playerid), entranceData[id][eName], entranceData[id][eID], inputtext);

			format(entranceData[id][eIntText], 60, inputtext);
		}
		Entrance_Update(id);
		Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);

		Entrance_Save(id);
	}
	return Dialog_Show(playerid, DialogEnt_Notice, DIALOG_STYLE_TABLIST, "แก้ไข -> การแจ้งเตือน", "ขาเข้า\t%s\nขาออก\t%s", "เลือก", "กลับ", entranceData[id][eIntText], entranceData[id][eExtText]);
}

Dialog:DialogEnt_TextExit(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "EntranceEditID");

	if(response) {
		new caption[128];

		if(strlen(inputtext) >= 60) {
			format(caption, sizeof(caption), "แก้ไข -> การแจ้งเตือนขาออก: "EMBED_LIGHTGREEN"%s", entranceData[id][eExtText]);
			Dialog_Show(playerid, DialogEnt_TextEnter, DIALOG_STYLE_INPUT, caption, ""EMBED_LIGHTRED"พบข้อผิดพลาด:\n"EMBED_WHITE"ความยาวของชื่อต้องไม่เกิน "EMBED_YELLOW"60 "EMBED_WHITE"ตัวอักษร\n\n"EMBED_LIGHTRED"หมายเหตุ: ใช้ภาษาอังกฤษเท่านั้น", "เปลี่ยน", "กลับ");
			return 1;
		}
		/*if(!IsGameText(inputtext) && !isnull(inputtext)) {
			format(caption, sizeof(caption), "แก้ไข -> ข้อความลอยขาออก: "EMBED_LIGHTGREEN"%s", entranceData[id][eExtText]);
			Dialog_Show(playerid, DialogEnt_TextEnter, DIALOG_STYLE_INPUT, caption, ""EMBED_LIGHTRED"พบข้อผิดพลาด:\n"EMBED_WHITE"ใช้ข้อความภาษาอังกฤษเท่านั้น", "เปลี่ยน", "กลับ");
			return 1;
		}*/

		if(isnull(inputtext)) {
			SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้ลบการแจ้งเตือนขาออก %s(%d)", ReturnPlayerName(playerid), entranceData[id][eName], id + 1);
			Log(adminactionlog, INFO, "%s: ลบการแจ้งเตือนขาออก %s(%d)", ReturnPlayerName(playerid), entranceData[id][eName], entranceData[id][eID]);

			entranceData[id][eExtText][0] = '\0';
		}
		else {
			SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนการแจ้งเตือนขาออก %s(%d) เป็น %s", ReturnPlayerName(playerid), entranceData[id][eName], id + 1, inputtext);
			Log(adminactionlog, INFO, "%s: เปลี่ยนการแจ้งเตือนขาออก %s(%d) เป็น %s", ReturnPlayerName(playerid), entranceData[id][eName], entranceData[id][eID], inputtext);

			format(entranceData[id][eExtText], 60, inputtext);
		}
		Entrance_Update(id);
		Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);

		Entrance_Save(id);
	}
	return Dialog_Show(playerid, DialogEnt_Notice, DIALOG_STYLE_TABLIST, "แก้ไข -> การแจ้งเตือน", "ขาเข้า\t%s\nขาออก\t%s", "เลือก", "กลับ", entranceData[id][eIntText], entranceData[id][eExtText]);
}

Dialog:DialogEnt_Type(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = GetPVarInt(playerid, "EntranceEditID");
		entranceData[id][eType] = listitem;

		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนประเภททางเข้า %s(%d) เป็น %d", ReturnPlayerName(playerid), entranceData[id][eName], id + 1, listitem);
		Log(adminactionlog, INFO, "%s: เปลี่ยนประเภททางเข้า %s(%d) เป็น %d", ReturnPlayerName(playerid), entranceData[id][eName], entranceData[id][eID], listitem);

		Entrance_Update(id);
	}
	return ShowPlayerEditEntrance(playerid);
}

Dialog:DialogEnt_Link(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = GetPVarInt(playerid, "EntranceEditID");
		switch(listitem) {
			case 0: {
				entranceData[id][eWorld] = ENTRANCE_WORLD + entranceData[id][eID];
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้กำหนดโลกจำลองทางเข้า %s(%d) เป็นค่าเริ่มต้น", ReturnPlayerName(playerid), entranceData[id][eName], id + 1);
				Log(adminactionlog, INFO, "%s: กำหนดโลกจำลองทางเข้า %s(%d) เป็นค่าเริ่มต้น", ReturnPlayerName(playerid), entranceData[id][eName], entranceData[id][eID]);
			}
			case 1: {
				Dialog_Show(playerid, DialogEnt_LinkEntrance, DIALOG_STYLE_INPUT, "แก้ไข -> เชื่อมต่อโลกจำลอง", "ไอดีทางเข้า: 1-%d\nกรอกไอดีทางเข้าที่ต้องการเชื่อมต่อในช่องว่างด้านล่างนี้:", "เชื่อมต่อ", "กลับ", MAX_ENTRANCE);
				return 1;
			}
		}
		Entrance_Save(id);
	}
	return ShowPlayerEditEntrance(playerid);
}

Dialog:DialogEnt_LinkEntrance(playerid, response, listitem, inputtext[]) {

	if (response)
	{
		new id = GetPVarInt(playerid, "EntranceEditID");
		new targetid = strval(inputtext);

		if(targetid <= 0 || targetid > MAX_ENTRANCE) {
			return Dialog_Show(playerid, DialogEnt_LinkEntrance, DIALOG_STYLE_INPUT, "แก้ไข -> เชื่อมต่อโลกจำลอง", ""EMBED_LIGHTRED"พบข้อผิดพลาด:\n"EMBED_WHITE"ไอดีต้องไม่ต่ำกว่า "EMBED_YELLOW"1"EMBED_WHITE" หรือมากกว่า "EMBED_YELLOW"%d"EMBED_WHITE"\nกรอกไอดีทางเข้าที่ต้องการเชื่อมต่อในช่องว่างด้านล่างนี้:", "เชื่อมต่อ", "กลับ", MAX_ENTRANCE);
		}

		targetid--;

		if(!Iter_Contains(Iter_Entrance, targetid)) {
			return Dialog_Show(playerid, DialogEnt_LinkEntrance, DIALOG_STYLE_INPUT, "แก้ไข -> เชื่อมต่อโลกจำลอง", ""EMBED_LIGHTRED"พบข้อผิดพลาด:\n"EMBED_WHITE"ไอดีทางเข้า "EMBED_YELLOW"%d"EMBED_WHITE" ไม่มีอยู่ในระบบ"EMBED_WHITE"\nกรอกไอดีทางเข้าที่ต้องการเชื่อมต่อในช่องว่างด้านล่างนี้:", "เชื่อมต่อ", "กลับ", targetid);
		}

		entranceData[id][eWorld] = entranceData[targetid][eWorld];
		SetPlayerVirtualWorld(playerid, entranceData[id][eWorld]);

		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้กำหนดโลกจำลองทางเข้า %s(%d) ให้เชื่อมต่อกับทางเข้า %s(%d)", ReturnPlayerName(playerid), entranceData[id][eName], id + 1, entranceData[targetid][eName], targetid + 1);
		Log(adminactionlog, INFO, "%s: กำหนดโลกจำลองทางเข้า %s(%d) ให้เชื่อมต่อกับทางเข้า %s(%d)", ReturnPlayerName(playerid), entranceData[id][eName], entranceData[id][eID], entranceData[targetid][eName], entranceData[targetid][eID]);

		Entrance_Save(id);
	}
	return ShowPlayerEditEntrance(playerid);
}

Dialog:DialogEnt_Teleport(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		switch(listitem) {
			case 0:
			{
				Dialog_Show(playerid, DialogEnt_Enter, DIALOG_STYLE_MSGBOX, "แก้ไข -> ตั้งจุดวาร์ปทางเข้า", ""EMBED_WHITE"คุณแน่ใจหรือที่จะปรับ"EMBED_YELLOW"ทางเข้า"EMBED_WHITE"นี้มายังตำแหน่งปัจจุบันของคุณ", "ยืนยัน", "กลับ");
			}
			case 1:
			{
				Dialog_Show(playerid, DialogEnt_Exit, DIALOG_STYLE_MSGBOX, "แก้ไข -> ตั้งจุดวาร์ปทางออก", ""EMBED_WHITE"คุณแน่ใจหรือที่จะปรับ"EMBED_YELLOW"ทางออก"EMBED_WHITE"มายังตำแหน่งปัจจุบันของคุณ", "ยืนยัน", "กลับ");
			}
		}
		return 1;
	}
	return ShowPlayerEditEntrance(playerid);
}

Dialog:DialogEnt_Enter(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = GetPVarInt(playerid, "EntranceEditID");
		new Float:px, Float:py, Float:pz, Float:pa, pint = GetPlayerInterior(playerid), pworld = GetPlayerVirtualWorld(playerid);
		GetPlayerPos(playerid, px, py, pz);
		GetPlayerFacingAngle(playerid, pa);

		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนจุดวาร์ปขาเข้า %s(%d) เป็นตำแหน่งปัจจุบันของเขา", ReturnPlayerName(playerid), entranceData[id][eName], id + 1);
		Log(adminactionlog, INFO, "%s: เปลี่ยนจุดวาร์ปขาเข้าของ %s(%d) จาก %f,%f,%f (int:%d|world:%d) เป็น %f,%f,%f (int:%d|world:%d)", ReturnPlayerName(playerid), entranceData[id][eName], entranceData[id][eID], entranceData[id][extX], entranceData[id][extY], entranceData[id][extZ], entranceData[id][extInt], entranceData[id][extWorld], px, py, pz, pint, pworld);

        entranceData[id][extX]=px;
        entranceData[id][extY]=py;
        entranceData[id][extZ]=pz;
		entranceData[id][extA]=pa;
        entranceData[id][extInt]=pint;
        entranceData[id][extWorld]=pworld;

		Entrance_Update(id);
		Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);
	   	Entrance_Save(id);
	}
	return Dialog_Show(playerid, DialogEnt_Teleport, DIALOG_STYLE_LIST, "แก้ไข -> ตั้งจุดวาร์ป", "ขาเข้า\nขาออก", "เลือก", "กลับ");
}

Dialog:DialogEnt_Exit(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = GetPVarInt(playerid, "EntranceEditID");
		new Float:px, Float:py, Float:pz, Float:pa, pint = GetPlayerInterior(playerid), pworld = ENTRANCE_WORLD + entranceData[id][eID];
		GetPlayerPos(playerid, px, py, pz);
		GetPlayerFacingAngle(playerid, pa);

		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนจุดวาร์ปขาออก %s(%d) เป็นตำแหน่งปัจจุบันของเขา", ReturnPlayerName(playerid), entranceData[id][eName], id + 1);
		Log(adminactionlog, INFO, "%s: เปลี่ยนจุดวาร์ปขาออกของ %s(%d) จาก %f,%f,%f (int:%d) เป็น %f,%f,%f (int:%d)", ReturnPlayerName(playerid), entranceData[id][eName], entranceData[id][eID], entranceData[id][extX], entranceData[id][extY], entranceData[id][extZ], entranceData[id][extInt], px, py, pz, pint);

        entranceData[id][intX]=px;
        entranceData[id][intY]=py;
        entranceData[id][intZ]=pz;
		entranceData[id][intA]=pa;
        entranceData[id][eInt]=pint;

		if(entranceData[id][eWorld]==0)
			entranceData[id][eWorld]=pworld;

		Entrance_Update(id);
		Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);
	   	Entrance_Save(id);

        SetPlayerVirtualWorld(playerid, pworld);
	}
	return Dialog_Show(playerid, DialogEnt_Teleport, DIALOG_STYLE_LIST, "แก้ไข -> ตั้งจุดวาร์ป", "ขาเข้า\nขาออก", "เลือก", "กลับ");
}

flags:entrancetp(CMD_MANAGEMENT);
CMD:entrancetp(playerid, params[]) {

	new id;
	if (sscanf(params, "d", id))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /entrancetp [ไอดี] ");
		return 1;
	}

	if(id <= 0 || id > MAX_ENTRANCE) {
		return SendClientMessageEx(playerid, COLOR_GREY, "   ไอดีต้องไม่ต่ำกว่า 1 หรือมากกว่า %d ! ", MAX_ENTRANCE);
	}

	id--;

	if(Iter_Contains(Iter_Entrance, id)) {
		SetPlayerPos(playerid, entranceData[id][extX], entranceData[id][extY], entranceData[id][extZ]);
		SetPlayerInterior(playerid, entranceData[id][extInt]);
		SetPlayerVirtualWorld(playerid, entranceData[id][extWorld]);
  		SetPlayerFacingAngle(playerid, entranceData[id][extA]);

		SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณได้วาร์ปไปยังทางเข้า %s(%d) ", entranceData[id][eName], id+1);
	}
	return 1;
}

Entrance_DynamicPos(world, &Float:X, &Float:Y, &Float:Z) {
	foreach(new id : Iter_Entrance)
	{
	    if (entranceData[id][eWorld] == world) {
			X = entranceData[id][extX];
			Y = entranceData[id][extY];
			Z = entranceData[id][extZ];
			return id;
		}
	}
	return -1;
}


IsPlayerAtEntranceEntrance(playerid) {
	foreach(new id : Iter_Entrance)
	{
	    if (entranceData[id][intX] != 0.0 && entranceData[id][intY] != 0.0 && IsPlayerInRangeOfPoint(playerid, 2.5, entranceData[id][extX], entranceData[id][extY], entranceData[id][extZ]))
		return true;
	}
	return false;
}

IsPlayerAtEntranceExit(playerid) {
	foreach(new id : Iter_Entrance)
	{
	    if (IsPlayerInRangeOfPoint(playerid, 2.5, entranceData[id][intX], entranceData[id][intY], entranceData[id][intZ]) && entranceData[id][eWorld] == GetPlayerVirtualWorld(playerid))
		return true;
	}
	return false;
}

IsPlayerNearestEntrance(playerid) {
	foreach(new id : Iter_Entrance)
	{
	    if (IsPlayerInRangeOfPoint(playerid, 2.5, entranceData[id][intX], entranceData[id][intY], entranceData[id][intZ]) && entranceData[id][eWorld] == GetPlayerVirtualWorld(playerid) || entranceData[id][intX] != 0.0 && entranceData[id][intY] != 0.0 && IsPlayerInRangeOfPoint(playerid, 2.5, entranceData[id][extX], entranceData[id][extY], entranceData[id][extZ]))
		return id;
	}
	return -1;
}

PlayerEnterNearestEntrance(playerid) {
	foreach(new id : Iter_Entrance)
	{
	    if (entranceData[id][intX] != 0.0 && entranceData[id][intY] != 0.0 && IsPlayerInRangeOfPoint(playerid, 2.5, entranceData[id][extX], entranceData[id][extY], entranceData[id][extZ])) {
			if (entranceData[id][eLocked]) {
				GameTextForPlayer(playerid, "~r~Locked", 5000, 1);
				return 1;
			}
	    	SetPlayerPos(playerid, entranceData[id][intX], entranceData[id][intY], entranceData[id][intZ]);
	    	SetPlayerInterior(playerid, entranceData[id][eInt]);
			playerData[playerid][pInterior] = entranceData[id][extInt];
	    	SetPlayerVirtualWorld(playerid, entranceData[id][eWorld]);
			playerData[playerid][pVWorld] = entranceData[id][extWorld];
  	        SetPlayerFacingAngle(playerid, entranceData[id][intA]);

			if(!isnull(entranceData[id][eIntText])) {
				GameTextForPlayer(playerid, entranceData[id][eIntText], 5000, 1);
			}
			if(!isnull(entranceData[id][eIntText])) {
				GameTextForPlayer(playerid, entranceData[id][eIntText], 5000, 1);
			}
			return 1;
	    }
	}
	return 0;
}

PlayerExitEntrance(playerid) {
	foreach(new id : Iter_Entrance)
	{
	    if (IsPlayerInRangeOfPoint(playerid, 2.5, entranceData[id][intX], entranceData[id][intY], entranceData[id][intZ]) && entranceData[id][eWorld] == GetPlayerVirtualWorld(playerid)) {
	    	SetPlayerPos(playerid, entranceData[id][extX], entranceData[id][extY], entranceData[id][extZ]);
	    	SetPlayerInterior(playerid, entranceData[id][extInt]);
			playerData[playerid][pInterior] = entranceData[id][extInt];
	    	SetPlayerVirtualWorld(playerid, entranceData[id][extWorld]);
			playerData[playerid][pVWorld] = entranceData[id][extWorld];
  	        SetPlayerFacingAngle(playerid, entranceData[id][extA]);

			if(!isnull(entranceData[id][eExtText])) {
				GameTextForPlayer(playerid, entranceData[id][eExtText], 5000, 1);
			}
			return 1;
	    }
	}
	return 0;
}

ToggleEntranceLockStatus(playerid, id) {
	if (Iter_Contains(Iter_Entrance, id)) {
		if (playerData[playerid][pFaction] == entranceData[id][eFactionID]) {
			entranceData[id][eLocked] = !entranceData[id][eLocked];
			GameTextForPlayer(playerid, entranceData[id][eLocked] ? ("~r~Door Locked") : ("~g~Door Unlocked"), 5000, 1);
		}
		else {
			GameTextForPlayer(playerid, "~r~You are not allowed.", 3000, 1);
		}
	}
	return 1;
}
/*
CMD:enter_entrance(playerid) {
	foreach(new id : Iter_Entrance)
	{
	    if (entranceData[id][intX] != 0.0 && entranceData[id][intY] != 0.0 && IsPlayerInRangeOfPoint(playerid, 2.5, entranceData[id][extX], entranceData[id][extY], entranceData[id][extZ])) {
	    	SetPlayerPos(playerid, entranceData[id][intX], entranceData[id][intY], entranceData[id][intZ]);
	    	SetPlayerInterior(playerid, entranceData[id][eInt]);
	    	SetPlayerVirtualWorld(playerid, entranceData[id][eWorld]);
  	        SetPlayerFacingAngle(playerid, entranceData[id][intA]);

			if(!isnull(entranceData[id][eIntText])) {
				GameTextForPlayer(playerid, entranceData[id][eIntText], 5000, 1);
			}
	    }
	}
	return 1;
}

CMD:exit_entrance(playerid) {
	foreach(new id : Iter_Entrance)
	{
	    if (IsPlayerInRangeOfPoint(playerid, 2.5, entranceData[id][intX], entranceData[id][intY], entranceData[id][intZ]) && entranceData[id][eWorld] == GetPlayerVirtualWorld(playerid)) {
	    	SetPlayerPos(playerid, entranceData[id][extX], entranceData[id][extY], entranceData[id][extZ]);
	    	SetPlayerInterior(playerid, entranceData[id][extInt]);
	    	SetPlayerVirtualWorld(playerid, entranceData[id][extWorld]);
  	        SetPlayerFacingAngle(playerid, entranceData[id][extA]);

			if(!isnull(entranceData[id][eExtText])) {
				GameTextForPlayer(playerid, entranceData[id][eExtText], 5000, 1);
			}
	    }
	}
	return 1;
}*/

hook OP_EnterDynamicCP(playerid, checkpointid) {
	#if defined SV_DEBUG
		printf("entrance.pwn: EnterDynamicCP(playerid %d, checkpointid %d)", playerid, checkpointid);
	#endif

	gPlayerCheckpoint{playerid} = false;
	/*new id = Streamer_GetIntData(STREAMER_TYPE_CP, checkpointid, E_STREAMER_EXTRA_ID);
	if (Iter_Contains(Iter_Entrance, id)) {
		if (IsPlayerInRangeOfPoint(playerid, 3.5, entranceData[id][extX], entranceData[id][extY], entranceData[id][extZ])) {
			return -2;
		}
	}*/
	return 1;
}