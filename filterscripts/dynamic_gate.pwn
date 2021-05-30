//###########################################################################
//#################### [ Dyanmic gate By OZANO ] #######################
// วิธีสร้างสำหรับแอดมิน ให้เข้าสู่ระบบ /rcon login [Password] ก่อน
//###########################################################################

//======================================================================//
#include <a_samp>
#include <a_mysql> //mysql-R41-4
#include <Pawn.CMD>
#include <sscanf2> //sscanf-2.8.3
#include <streamer>
#include <easyDialog>
#include <YSI_Data\y_iterate> // pawn-lang/YSI-Includes

//======================================================================//
// MySQL configuration
#define		MYSQL_HOST 			"localhost"
#define		MYSQL_USER 			"root"
#define 	MYSQL_PASSWORD 		""
#define		MYSQL_DATABASE 		"sdasdas"

// MySQL connection handle
new MySQL: g_SQL;
//======================================================================//

#define MAX_GATES (500) // จำนวนที่สร้างได้
#define MAX_GATE_PASSWORD 16 // ความยาวรหัสผ่าน
#define MOVE_SPEED 1.65 // ความเร็วเปิดปิด

enum {
	GATE_STATE_CLOSED,
	GATE_STATE_OPEN
}

enum gateE {
	gGateExists,
	gGateID,
	gGateModel,
	gGateType,
	gGatePassword[MAX_GATE_PASSWORD],
	Float:gGatePos[3],
	Float:gGateRot[3],
	Float:gGateOpenPos[3],
	Float:gGateOpenRot[3],
	gGateState,
	bool:gGateEditing,
	gGateObject
}

new gateVariables[MAX_GATES][gateE],
    gateEditionID[MAX_PLAYERS] = {-1, ...},
	gateEditionType[MAX_PLAYERS] = {-1, ...},
    bool:gateAccess[MAX_PLAYERS][MAX_GATES],
	GateStates[2][16] = {"{E74C3C}Closed", "{2ECC71}Open"},
	szQueryOutput[512];


main(){ }

public OnGameModeInit()
{
	//========== MY SQL CONNECT ====================//
	new MySQLOpt: option_id = mysql_init_options();

	mysql_set_option(option_id, AUTO_RECONNECT, true); // it automatically reconnects when loosing connection to mysql server

	g_SQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE, option_id); // AUTO_RECONNECT is enabled for this connection handle only
	if (g_SQL == MYSQL_INVALID_HANDLE || mysql_errno(g_SQL) != 0)
	{
		print("MySQL connection failed. Server is shutting down.");
		SendRconCommand("exit"); // close the server if there is no connection
		return 1;
	}
	print("[ FS::dynamic_gate ] MySQL connection is successful.");
	//=============================================//

    mysql_tquery(g_SQL, "SELECT * FROM gates", "THREAD_INITIATE_GATES", "i", -1);
	
	return 1;
}

public OnPlayerConnect(playerid) {

    for(new i = 0; i < MAX_GATES; i ++) gateAccess[playerid][i] = false;
    return 1;
}

public OnPlayerDisconnect(playerid, reason){

    if(gateEditionID[playerid] != -1) gateVariables[gateEditionID[playerid]][gGateEditing] = false;
    return 1;
}

forward THREAD_INITIATE_GATES();
public THREAD_INITIATE_GATES(){

    new
	    rows, loaded;

	cache_get_row_count(rows);

    if (rows) {
        for(new x = 0; x < rows; x ++) if (x < MAX_GATES){
            cache_get_value_name(x, "password", gateVariables[x][gGatePassword], MAX_GATE_PASSWORD);

            gateVariables[x][gGateExists] = 1;
            cache_get_value_name_int(x, "id", gateVariables[x][gGateID]);
			cache_get_value_name_int(x, "model", gateVariables[x][gGateModel]);
			cache_get_value_name_int(x, "type", gateVariables[x][gGateType]);
            cache_get_value_name_float(x, "def_posx", gateVariables[x][gGatePos][0]);
			cache_get_value_name_float(x, "def_posy", gateVariables[x][gGatePos][1]);
			cache_get_value_name_float(x, "def_posz", gateVariables[x][gGatePos][2]);
            cache_get_value_name_float(x, "def_rotx", gateVariables[x][gGateRot][0]);
			cache_get_value_name_float(x, "def_roty", gateVariables[x][gGateRot][1]);
			cache_get_value_name_float(x, "def_rotz", gateVariables[x][gGateRot][2]);
            cache_get_value_name_float(x, "open_posx", gateVariables[x][gGateOpenPos][0]);
			cache_get_value_name_float(x, "open_posy", gateVariables[x][gGateOpenPos][1]);
			cache_get_value_name_float(x, "open_posz", gateVariables[x][gGateOpenPos][2]);
            cache_get_value_name_float(x, "open_rotx", gateVariables[x][gGateOpenRot][0]);
			cache_get_value_name_float(x, "open_roty", gateVariables[x][gGateOpenRot][1]);
			cache_get_value_name_float(x, "open_rotz", gateVariables[x][gGateOpenRot][2]);
            gateVariables[x][gGateObject] = CreateDynamicObject(gateVariables[x][gGateModel], gateVariables[x][gGatePos][0], gateVariables[x][gGatePos][1], gateVariables[x][gGatePos][2], gateVariables[x][gGateRot][0], gateVariables[x][gGateRot][1], gateVariables[x][gGateRot][2]);
            loaded ++;
        }
    }
    printf("[ FS::dynamic_gate ] Gates loaded (%d)", loaded);
    return 1;
}

CMD:gate(playerid, params[]) {

	new
		id = GetClosestGate(playerid);

	if(id != -1) {
        if(gateVariables[id][gGateEditing]) return SendClientMessage(playerid, 0xE74C3CFF, "เกิดข้อผิดพลาด : ประตูนี้อยู่ระหว่างการแก้ไข คุณยังไม่สามารถใช้งานได้!");
		if(gateVariables[id][gGateOpenPos][0] == 0.0 && gateVariables[id][gGateOpenRot][0] == 0.0) return SendClientMessage(playerid, 0xE74C3CFF, "เกิดข้อผิดพลาด : ประตูนี้ยังไม้ได่ถูกแก้ไขตำแหน่งการเปิดประตู จึงยังไม่สามารถใช้งานได้!");
		if(gateVariables[id][gGateType] == 1) return SendClientMessage(playerid, 0xE74C3CFF, "เกิดข้อผิดพลาด : You are not authorized to open this gate.");
		if(!strlen(gateVariables[id][gGatePassword])) {
		    ToggleGateState(id);
		}else{
		    if(gateAccess[playerid][id]) {
		        ToggleGateState(id);
			}else{
			    Dialog_Show(playerid, DIALOG_GATE_PASSWORD, DIALOG_STYLE_PASSWORD, "รหัสผ่านประตู", "ประตูนี้ได้ถูกป้องกันด้วยรหัสผ่าน\nกรุณาป้อนรหัสผ่านที่ถูกต้อง:", "ตกลง", "ยกเลิก");
			}
		}
	}

    return 1;
}
CMD:creategate(playerid, params[]) {
    new
		model,
		password[MAX_GATE_PASSWORD];

	if (IsPlayerAdmin(playerid)) {
		if(gateEditionID[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "เกิดข้อผิดพลาด : คุณยังไม่สามารถสร้างประตูได้ในระหว่างที่กำลังแก้ไขประตูอื่นอยู่!");
		if(sscanf(params, "iS()["#MAX_GATE_PASSWORD"]", model, password)) return SendClientMessage(playerid, 0xF39C12FF, "USAGE: /creategate [model id] [password (optional)]");

		for(new i = 0; i < MAX_GATES; i ++) {
		    if(!gateVariables[i][gGateExists]) {
		        new
					Float:x,
					Float:y,
					Float:z;

				GetPlayerPos(playerid, x, y, z);
				GetXYInFrontOfPlayer(playerid, x, y, 3.0);

		        format(gateVariables[i][gGatePassword], MAX_GATE_PASSWORD, password);

		        gateVariables[i][gGateExists] = 1;
				gateVariables[i][gGateModel] = model;
				gateVariables[i][gGateType] = 0;
				gateVariables[i][gGatePos][0] = x;
				gateVariables[i][gGatePos][1] = y;
				gateVariables[i][gGatePos][2] = z;
				gateVariables[i][gGateRot][0] = gateVariables[i][gGateRot][1] = gateVariables[i][gGateRot][2] = 0.0;
				gateVariables[i][gGateOpenPos][0] = gateVariables[i][gGateOpenPos][1] = gateVariables[i][gGateOpenPos][2] = 0.0;
				gateVariables[i][gGateOpenRot][0] = gateVariables[i][gGateOpenRot][1] = gateVariables[i][gGateOpenRot][2] = 0.0;
				gateVariables[i][gGateState] = GATE_STATE_CLOSED;
				gateVariables[i][gGateEditing] = true;
				gateVariables[i][gGateObject] = CreateDynamicObject(model, x, y, z, 0.0, 0.0, 0.0);

				mysql_tquery(g_SQL, "INSERT INTO gates (id) VALUES(null)", "OnGateAdded", "i", i);

				gateEditionID[playerid] = i;
				gateEditionType[playerid] = GATE_STATE_CLOSED;
				EditDynamicObject(playerid, gateVariables[i][gGateObject]);
				SendClientMessage(playerid, 0x2ECC71FF, "แจ้งเตือน : ประตูได้ทำการสร้างขึ้นเรียบร้อย กรุณาแก้ไขมันให้สมบูรณ์!");
				return 1;
			}
		}
	}else { return SendClientMessage(playerid, 0x696969FF,"คุณต้อง Login RCON ก่อน (/rcon login [Password])"); }

	return 1;
}

CMD:editgate(playerid, params[])
{
    if(IsPlayerAdmin(playerid)) {
		if(gateEditionID[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "เกิดข้อผิดพล{FFFFFF}าด : คุณกำลังแก้ไขประตูอื่นอยู่!");
		new id;
		sscanf(params, "I(-2)", id);
		if(id == -2) id = GetClosestGate(playerid);
		if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "เกิดข้อผิดพล{FFFFFF}าด : คุณไม่ได้อยู่ใกล้กับประตูที่จะแก้ไข");
		if(gateVariables[id][gGateEditing]) return SendClientMessage(playerid, 0xE74C3CFF, "เกิดข้อผิดพล{FFFFFF}าด : คุณกำลังเริ่มต้นการแก้ไขประตู");
		if(!IsPlayerInRangeOfPoint(playerid, 20.0, gateVariables[id][gGatePos][0], gateVariables[id][gGatePos][1], gateVariables[id][gGatePos][2])) return SendClientMessage(playerid, 0xE74C3CFF, "เกิดข้อผิดพล{FFFFFF}าด : คุณไม่ได้อยู่ใกล้กับประตูที่คุณจะทำการแก้ไขมัน!!");
		gateVariables[id][gGateEditing] = true;
		gateEditionID[playerid] = id;
		ShowEditMenu(playerid, id);
	}else { return SendClientMessage(playerid, 0x696969FF,"คุณต้อง Login RCON ก่อน (/rcon login [Password])"); }
	return 1;
}

stock ShowEditMenu(playerid, id)
{
    new string[128];
	format(string, sizeof(string), "ตำแหน่งประตู\t%s\nรหัสผ่านประตู\t%s\nGate Type\t(%i)\nแก้ไขตำแหน่งปิดประตู\nแก้ไขตำแหน่งเปิดประตู\nลบประตูนี้ออก", GateStates[ gateVariables[id][gGateState] ], gateVariables[id][gGatePassword], gateVariables[id][gGateType]);
	Dialog_Show(playerid, DIALOG_GATE_EDITMENU, DIALOG_STYLE_TABLIST, "การก้ไขประตู", string, "เลือก", "ยกเลิก");
	return 1;
}

forward OnGateAdded(slotID);
public OnGateAdded(slotID)
{
    gateVariables[slotID][gGateID] = cache_insert_id();
    SaveGate(slotID);

    return 1;
}

stock SaveGate(id)
{
    mysql_format(g_SQL, szQueryOutput, sizeof(szQueryOutput), "UPDATE gates SET `model` = %i, `type` = %i, `password` = '%e', `def_posx` = '%f', `def_posy` = '%f', `def_posz` = '%f', `def_rotx` = '%f', `def_roty` = '%f', `def_rotz` = '%f', `open_posx` = '%f', `open_posy` = '%f', `open_posz` = '%f', `open_rotx` = '%f', `open_roty` = '%f', `open_rotz` = '%f' WHERE `id` = %i",
        gateVariables[id][gGateModel],
        gateVariables[id][gGateType],
        gateVariables[id][gGatePassword],
        gateVariables[id][gGatePos][0],
        gateVariables[id][gGatePos][1],
        gateVariables[id][gGatePos][2],
        gateVariables[id][gGateRot][0],
        gateVariables[id][gGateRot][1],
        gateVariables[id][gGateRot][2],
        gateVariables[id][gGateOpenPos][0],
        gateVariables[id][gGateOpenPos][1],
        gateVariables[id][gGateOpenPos][2],
        gateVariables[id][gGateOpenRot][0],
        gateVariables[id][gGateOpenRot][1],
        gateVariables[id][gGateOpenRot][2],
        gateVariables[id][gGateID]
	);

	mysql_tquery(g_SQL, szQueryOutput);

	return 1;
}

stock GetClosestGate(playerid, Float: range = 10.0)
{
	new id = -1, Float: playerdist, Float: tempdist = 9999.0;
	for(new i = 0; i < MAX_GATES; i ++)
	{
        playerdist = GetPlayerDistanceFromPoint(playerid, gateVariables[i][gGatePos][0], gateVariables[i][gGatePos][1], gateVariables[i][gGatePos][2]); //IC-L1U02
        if(playerdist > range) continue;
	    if(playerdist <= tempdist)
	    {
	        tempdist = playerdist;
	        id = i;
	    }
	}

	return id;
}

stock SetGateState(id, gate_state, move = 1)
{
	gateVariables[id][gGateState] = gate_state;

	switch(move)
	{
	    case 1:
	    {
	        if(gate_state == GATE_STATE_CLOSED) {
	        	MoveDynamicObject(gateVariables[id][gGateObject], gateVariables[id][gGatePos][0], gateVariables[id][gGatePos][1], gateVariables[id][gGatePos][2], MOVE_SPEED, gateVariables[id][gGateRot][0], gateVariables[id][gGateRot][1], gateVariables[id][gGateRot][2]);
			}else{
                MoveDynamicObject(gateVariables[id][gGateObject], gateVariables[id][gGateOpenPos][0], gateVariables[id][gGateOpenPos][1], gateVariables[id][gGateOpenPos][2], MOVE_SPEED, gateVariables[id][gGateOpenRot][0], gateVariables[id][gGateOpenRot][1], gateVariables[id][gGateOpenRot][2]);
			}
		}

		case 2:
		{
		    if(gate_state == GATE_STATE_CLOSED) {
	        	SetDynamicObjectPos(gateVariables[id][gGateObject], gateVariables[id][gGatePos][0], gateVariables[id][gGatePos][1], gateVariables[id][gGatePos][2]);
				SetDynamicObjectRot(gateVariables[id][gGateObject], gateVariables[id][gGateRot][0], gateVariables[id][gGateRot][1], gateVariables[id][gGateRot][2]);
			}else{
                SetDynamicObjectPos(gateVariables[id][gGateObject], gateVariables[id][gGateOpenPos][0], gateVariables[id][gGateOpenPos][1], gateVariables[id][gGateOpenPos][2]);
				SetDynamicObjectRot(gateVariables[id][gGateObject], gateVariables[id][gGateOpenRot][0], gateVariables[id][gGateOpenRot][1], gateVariables[id][gGateOpenRot][2]);
			}
		}
	}

	return 1;
}

stock ToggleGateState(id, move = 1)
{
	if(gateVariables[id][gGateState] == GATE_STATE_CLOSED) {
	    SetGateState(id, GATE_STATE_OPEN, move);
	}else{
	    SetGateState(id, GATE_STATE_CLOSED, move);
	}

	return 1;
}
public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    switch (response) {
		case EDIT_RESPONSE_CANCEL: {
            if(gateEditionID[playerid] >= 0) {
			    new id = gateEditionID[playerid];
	            gateVariables[id][gGateEditing] = false;

			    switch(gateEditionType[playerid])
			    {
					case GATE_STATE_CLOSED:
					{
					    SetDynamicObjectPos(objectid, gateVariables[id][gGatePos][0], gateVariables[id][gGatePos][1], gateVariables[id][gGatePos][2]);
					    SetDynamicObjectRot(objectid, gateVariables[id][gGateRot][0], gateVariables[id][gGateRot][1], gateVariables[id][gGateRot][2]);
					    gateVariables[id][gGatePos][0] = x;
						gateVariables[id][gGatePos][1] = y;
						gateVariables[id][gGatePos][2] = z;
						gateVariables[id][gGateRot][0] = rx;
						gateVariables[id][gGateRot][1] = ry;
						gateVariables[id][gGateRot][2] = rz;
						SendClientMessage(playerid, 0x2ECC71FF, "แจ้งเตือน : ยกเลิกการแก้ไขตำแหน่งปิดประตู");
					}

					case GATE_STATE_OPEN:
					{
					    SendClientMessage(playerid, 0x2ECC71FF, "แจ้งเตือน : ยกเลิกการแก้ไขตำแหน่งประตูเปิด");

					    if(gateVariables[id][gGateOpenPos][0] == 0.0 && gateVariables[id][gGateOpenRot][0] == 0.0)
						{
					        SendClientMessage(playerid, 0xF39C12FF, "คำเตือน : ประตูไม่สามารถเปิดไปยังตำแหน่งนั้นได้");
					        SendClientMessage(playerid, 0xF39C12FF, "คำเตือน : จะไม่สามารถเปิดประตูนี้ได้ จนกว่าคุณจำกำหนดตำแหน่งเปิดประตู");
					    }

					    SetGateState(id, GATE_STATE_CLOSED, 2);
					    gateEditionID[playerid] = -1;
			    		gateEditionType[playerid] = -1;
					}
				}
			}
		}
        case EDIT_RESPONSE_FINAL: {
		    if(gateEditionID[playerid] >= 0) {
			    new id = gateEditionID[playerid];
			    gateVariables[id][gGateEditing] = false;

			    switch(gateEditionType[playerid])
			    {
					case GATE_STATE_CLOSED:
					{
					    SetDynamicObjectPos(objectid, x, y, z);
					    SetDynamicObjectRot(objectid, rx, ry, rz);
					    gateVariables[id][gGatePos][0] = x;
						gateVariables[id][gGatePos][1] = y;
						gateVariables[id][gGatePos][2] = z;
						gateVariables[id][gGateRot][0] = rx;
						gateVariables[id][gGateRot][1] = ry;
						gateVariables[id][gGateRot][2] = rz;
						SendClientMessage(playerid, 0x2ECC71FF, "แจ้งเตือน : แก้การแก้ไขตำแหน่งพื้นฐานของประตูเสร็จสิ้น!");

						if(gateVariables[id][gGateOpenPos][0] == 0.0 && gateVariables[id][gGateOpenRot][0] == 0.0) {
					        gateVariables[id][gGateEditing] = true;
			    			gateEditionType[playerid] = GATE_STATE_OPEN;
					        EditDynamicObject(playerid, objectid);

					        SendClientMessage(playerid, 0xF39C12FF, "คำเตือน : ประตูนี้ไม่สารมารเปิดไปยังตำแหน่งนั้นได้");
					        SendClientMessage(playerid, 0xF39C12FF, "คำเตือน : คุณสามารถกำหนดตำแหน่งเปิดได้ในขณะนี้ หรือ คุณสามารถที่จะกำหนดมันภายหลังได้เช่นกัน");
					        SendClientMessage(playerid, 0xF39C12FF, "คำเตือน : ประตูจะไม่สามารถเปิดได้ จนกว่าคุณจะกำหนดตำแหน่งที่ประตูจะทำการเปิดออก");
					    }else{
					        gateEditionID[playerid] = -1;
			    			gateEditionType[playerid] = -1;
					    }

					    SaveGate(id);
					}

					case GATE_STATE_OPEN:
					{
					    SendClientMessage(playerid, 0x2ECC71FF, "แจ้งเตือน : ดำเนินการแก้ไขตำแหน่งเปิดประตูเสร็จสิ้น");
					    SetGateState(id, GATE_STATE_CLOSED, 2);
					    gateVariables[id][gGateOpenPos][0] = x;
						gateVariables[id][gGateOpenPos][1] = y;
						gateVariables[id][gGateOpenPos][2] = z;
						gateVariables[id][gGateOpenRot][0] = rx;
						gateVariables[id][gGateOpenRot][1] = ry;
						gateVariables[id][gGateOpenRot][2] = rz;

					    gateEditionID[playerid] = -1;
			    		gateEditionType[playerid] = -1;
			    		SaveGate(id);
					}
				}
			}
		}
	}
    return 1;
}
// dialog
Dialog:DIALOG_GATE_PASSWORD(playerid, response, listitem, inputtext[]) {
    if(response) {
        if(isnull(inputtext)) return Dialog_Show(playerid, DIALOG_GATE_PASSWORD, DIALOG_STYLE_PASSWORD, "รหัสผ่านประตู", "คุณยังไมไ่ด้กำหนดรหัสผ่าน\n{FFFFFF}กรุณากำหนดรหัสผ่านของประตู:", "ตกลง", "ยกเลิก");
        new id = GetClosestGate(playerid);
        if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "เกิดข้อผิดพลาด : คุณไม่ได้อยู่ใกล้ประตูที่จะดำเนินการแก้ไข");
        if(strcmp(gateVariables[id][gGatePassword], inputtext)) return Dialog_Show(playerid, DIALOG_GATE_PASSWORD, DIALOG_STYLE_PASSWORD, "รหัสผ่านประตู", "รหัสผ่านไม่ถูกต้อง\n{FFFFFF}กรุณากำหนดรหัสผ่านของประตู:", "ตกลง", "ยกเลิก");
        gateAccess[playerid][id] = true;
        ToggleGateState(id);
        return 1;
    }
    return 1;
}

Dialog:DIALOG_GATE_EDITMENU(playerid, response, listitem, inputtext[]) {
    if(!response) {
        if(gateEditionID[playerid] != -1) {
            gateVariables[gateEditionID[playerid]][gGateEditing] = false;
            gateEditionID[playerid] = -1;
        }
    }
    else {
        new id = gateEditionID[playerid];
        if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "เกิดข้อผิดพลาด : คุณไม่สามารถแก้ไขประตูได้");
        switch(listitem) {
            case 0: {
                ToggleGateState(id);
                ShowEditMenu(playerid, id);
            }
            case 1: {
                Dialog_Show(playerid, DIALOG_GATE_NEWPASSWORD, DIALOG_STYLE_INPUT, "เปลี่ยนแปลงรหัสผ่านประตู", "กรุณาระบุรหัสผ่านสำหรับประตูนี้:\nหากคุณไม่ต้องการกำหนดรหัสผ่าน ให้คุณปล่อยว่างไว้", "อัพเดท", "ยกเลิก");
            }
            case 2: {
                Dialog_Show(playerid, DIALOG_GATE_TYPE, DIALOG_STYLE_TABLIST_HEADERS, "Gate Type", "Type\tDescription\n(0)\tAll players with password can open this gate.\n(1)\tPlayer must have password and be in group type 1.", "Select", "Cancel");
            }
            case 3: {
                SetGateState(id, GATE_STATE_CLOSED, 2);
                gateEditionType[playerid] = GATE_STATE_CLOSED;
                EditDynamicObject(playerid, gateVariables[id][gGateObject]);
                SendClientMessage(playerid, 0x2ECC71FF, "แจ้งเตือน : ทำการแก้ไขตำแหน่งเริ่มต้นประตูแล้ว!");
            }
            case 4: {
                SetGateState(id, GATE_STATE_OPEN, 2);
                gateEditionType[playerid] = GATE_STATE_OPEN;
                EditDynamicObject(playerid, gateVariables[id][gGateObject]);
                SendClientMessage(playerid, 0x2ECC71FF, "แจ้งเตือน : ทำการแก้ไขตำแหน่งเปิดประตูแล้ว!");
            }
            case 5: {
                gateVariables[id][gGateEditing] = false;
                gateVariables[id][gGatePos][0] = gateVariables[id][gGatePos][1] = gateVariables[id][gGatePos][2] = 0.0;
                gateVariables[id][gGateRot][0] = gateVariables[id][gGateRot][1] = gateVariables[id][gGateRot][2] = 0.0;
                gateVariables[id][gGateOpenPos][0] = gateVariables[id][gGateOpenPos][1] = gateVariables[id][gGateOpenPos][2] = 0.0;
                gateVariables[id][gGateOpenRot][0] = gateVariables[id][gGateOpenRot][1] = gateVariables[id][gGateOpenRot][2] = 0.0;
                gateVariables[id][gGateExists] = 0;
                DestroyDynamicObject(gateVariables[id][gGateObject]);

                mysql_format(g_SQL, szQueryOutput, sizeof(szQueryOutput), "DELETE FROM gates WHERE `id` = %i", gateVariables[id][gGateID]);
                mysql_tquery(g_SQL, szQueryOutput);

                foreach(new i : Player) if(gateEditionID[i] == id) gateEditionID[i] = -1;
                SendClientMessage(playerid, 0x2ECC71FF, "แจ้งเตือน : ทำการลบประตูเสร็จสิ้น");
            }
        }
    }
    return 1;
}
Dialog:DIALOG_GATE_TYPE(playerid, response, listitem, inputtext[]) {
    new id = gateEditionID[playerid], szMessage[126];
    if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "เกิดข้อผิดพลาด : คุณไม่ได้แก้ไขจัดการประตู");
    if(!response) return ShowEditMenu(playerid, id);
    gateVariables[id][gGateType] = listitem;
    format(szMessage, sizeof(szMessage), "แจ้งเตือน : Gate type set to: %i.", listitem);
    SendClientMessage(playerid, 0x2ECC71FF, szMessage);
    SaveGate(id);
    ShowEditMenu(playerid, id);
    return 1;
}
Dialog:DIALOG_GATE_NEWPASSWORD(playerid, response, listitem, inputtext[]) {
    new id = gateEditionID[playerid];
    if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "เกิดข้อผิดพลาด : คุณไม่ได้แก้ไขจัดการประตู");
    if(!response) return ShowEditMenu(playerid, id);
    format(gateVariables[id][gGatePassword], MAX_GATE_PASSWORD, "%s", inputtext);
    foreach(new i : Player) gateAccess[i][id] = false;
    SendClientMessage(playerid, 0x2ECC71FF, "แจ้งเตือน : รหัสผ่านได้ถูกเปลี่ยนแปลงเรียบร้อยแล้ว!");
    SaveGate(id);
    ShowEditMenu(playerid, id);
    return 1;
}

stock GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance) { // And this'll keep the players close.

	new Float: a;

	GetPlayerPos(playerid, x, y, a);
	GetPlayerFacingAngle(playerid, a);

	if (GetPlayerVehicleID(playerid)) {
 		GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}

	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}


//
