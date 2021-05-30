#include <YSI\y_timers>  // pawn-lang/YSI-Includes
#include <YSI\y_hooks> // pawn-lang/YSI-Includes

#define MAX_CAR_RENT	80

enum E_RENTCAR_DATA {
	rent_id,
	rent_carid,
	Float:rent_x,
	Float:rent_y,
	Float:rent_z,
	Float:rent_a,
	rent_model,
	rent_price,
};

new carRentData[MAX_CAR_RENT][E_RENTCAR_DATA];

new Iterator:Iter_CarRent<MAX_CAR_RENT>;

new RentCarKey[MAX_PLAYERS];

hook OnGameModeInit() {
	mysql_tquery(dbCon, "SELECT * FROM `carrent`", "CarRent_Load", "");
	return 1;
}

IsVehicleRented(vehicleid)
{
	foreach (new i : Player)
	{
		if(RentCarKey[i] == vehicleid) return true;
	}
	return false;
}

IsVehicleRental(vehicleid)
{
	foreach(new i : Iter_CarRent) {
		if(carRentData[i][rent_carid] == vehicleid) return i;
	}
	return -1;
}

carRent_GetPrice(id) {
	if(Iter_Contains(Iter_CarRent, id)) {
		return carRentData[id][rent_price];
	}
	return 0;
}

hook OnPlayerConnect(playerid) {
    RentCarKey[playerid]=0;
    return 1;
}

task RentCarTimer[300000]() {
	new bool:done;
	foreach(new c : Iter_CarRent) {
        done = false;
		foreach (new i : Player) if(gLastCar[i] == carRentData[c][rent_carid] || RentCarKey[i] == carRentData[c][rent_carid] || GetPlayerVehicleID(i) == carRentData[c][rent_carid]) done = true;
		if(!done) {
			new vehicleid = carRentData[c][rent_carid];
			vehicleData[vehicleid][vFuel] = GetVehicleDataFuel(carRentData[c][rent_model]);
			SetVehicleToRespawn(vehicleid);
		}
	}
}

RentCar_Save(id) {
	if(Iter_Contains(Iter_CarRent, id)) {
        new largeQuery[256];
	    GetVehiclePos(carRentData[id][rent_carid], carRentData[id][rent_x], carRentData[id][rent_y], carRentData[id][rent_z]);
	    GetVehicleZAngle(carRentData[id][rent_carid], carRentData[id][rent_a]);

	    format(largeQuery, sizeof(largeQuery), "UPDATE carrent SET rentModel=%d, rentX='%.4f', rentY='%.4f', rentZ='%.4f', rentA='%.4f', rentPrice=%d WHERE rentID=%d", carRentData[id][rent_model], carRentData[id][rent_x],
		carRentData[id][rent_y], carRentData[id][rent_z], carRentData[id][rent_a], carRentData[id][rent_price], carRentData[id][rent_id]);
		mysql_query(dbCon,largeQuery);
	}
	return 1;
}


CMD:rentcar(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid), id = -1;
    if((id=IsVehicleRental(vehicleid)) != -1)
    {
        if(RentCarKey[playerid] != vehicleid && !IsVehicleRented(vehicleid))
        {
			new cost = carRent_GetPrice(id);
			if(GetPlayerMoneyEx(playerid) >= cost && cost > 0)
			{
			    RentCarKey[playerid] = vehicleid;

				GivePlayerMoneyEx(playerid, -cost);

				SendClientMessage(playerid,COLOR_GREEN,"คุณได้เช่ายานพาหนะ (/unrentcar เพื่อเลิกเช่า) ");
                SendClientMessage(playerid,COLOR_WHITE,"ข้อแนะ: คุณสามารถล็อกยานพาหนะที่เช่าด้วย /lock ");

				if(!IsABike(GetVehicleModel(vehicleid))) {
					SendClientMessage(playerid,COLOR_WHITE,"(/en)gine เพื่อสตาร์ท ");
				}
                else {
					SetEngineStatus(vehicleid, true);
					TogglePlayerControllable(playerid, true);
				}

				/*new
					engine,
					lights,
					alarm,
					doors,
					bonnet,
					boot,
					objective;
				GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(vehicleid, engine, lights, alarm, 1, bonnet, boot, objective);
				PlayerPlaySoundEx(playerid, 24600);

*/
				return 1;
			}
			else return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอ !");
        }
        else return SendClientMessage(playerid, COLOR_LIGHTRED,"ยานพาหนะคันนี้ถูกเช่าแล้ว");
    }
    else return SendClientMessage(playerid, COLOR_LIGHTRED,"ยานพาหนะคันนี้ไม่ได้มีไว้สำหรับเช่า");
}

CMD:unrentcar(playerid)
{
	if(RentCarKey[playerid] != 0)
 	{
		new vehicleid = RentCarKey[playerid];
		vehicleData[vehicleid][vFuel] = GetVehicleDataFuel(GetVehicleModel(vehicleid));
 	    SetVehicleToRespawn(RentCarKey[playerid]);
        RentCarKey[playerid] = 0;
        return SendClientMessage(playerid,COLOR_GREEN,"คุณได้คืนรถเช่า");
 	}
 	else return SendClientMessage(playerid, COLOR_GRAD1,"   คุณไม่ได้เช่ายานพาหนะใด ๆ");
}

forward CarRent_Load();
public CarRent_Load()
{
    new
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_CAR_RENT)
	{
	    cache_get_value_name_int(i, "rentID", carRentData[i][rent_id]);
	    cache_get_value_name_int(i, "rentModel", carRentData[i][rent_model]);
	    cache_get_value_name_float(i, "rentX", carRentData[i][rent_x]);
	    cache_get_value_name_float(i, "rentY", carRentData[i][rent_y]);
	    cache_get_value_name_float(i, "rentZ", carRentData[i][rent_z]);
	    cache_get_value_name_float(i, "rentA", carRentData[i][rent_a]);
	    cache_get_value_name_int(i, "rentPrice", carRentData[i][rent_price]);
	    
	    carRentData[i][rent_carid] = CreateVehicle(carRentData[i][rent_model], carRentData[i][rent_x], carRentData[i][rent_y], carRentData[i][rent_z], carRentData[i][rent_a], -1, -1, 60000);
	 	vehicleData[carRentData[i][rent_carid]][vFuel] = GetVehicleDataFuel(carRentData[i][rent_model]);
		SetVehicleNumberPlate(carRentData[i][rent_carid], "รถเช่า");
		SetLockStatus(carRentData[i][rent_carid], false);

        Iter_Add(Iter_CarRent, i);
	}
    printf("Car Rent loaded (%d/%d)", Iter_Count(Iter_CarRent), MAX_CAR_RENT);
	return 1;
}

flags:saverentcar(CMD_MANAGEMENT);
CMD:saverentcar(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))
    	return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่บนยานพาหนะเพื่อบันทึกมัน ");

    if(GetPVarInt(playerid, "sCc") == GetPlayerVehicleID(playerid)) {
    	new i = Iter_Free(Iter_CarRent);
        if(i != -1)
    	{
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

                    format(queryString, sizeof(queryString), "INSERT INTO carrent (rentModel, rentX, rentY, rentZ, rentA) VALUES('%d', '%f', '%f', '%f', '%f')", GetVehicleModel(vehicleid), vPos[0], vPos[1], vPos[2], vPos[3]);
                    mysql_query(dbCon,queryString);

                    new insertid = cache_insert_id();

                    carRentData[i][rent_id] = insertid;
                    carRentData[i][rent_model] = GetVehicleModel(vehicleid);
                    carRentData[i][rent_x] = vPos[0];
                    carRentData[i][rent_y] = vPos[1];
                    carRentData[i][rent_z] = vPos[2];
                    carRentData[i][rent_a] = vPos[3];

					DestroyVehicle(vehicleid);

					carRentData[i][rent_carid] = CreateVehicle(carRentData[i][rent_model], carRentData[i][rent_x], carRentData[i][rent_y], carRentData[i][rent_z], carRentData[i][rent_a], -1, -1, 60000);
					SetVehicleNumberPlate(carRentData[i][rent_carid], "รถเช่า");
					PutPlayerInVehicle(playerid, carRentData[i][rent_carid], 0);

                    Iter_Add(Iter_CarRent, i);

                    DeletePVar(playerid, "sCc");

					vehicleData[carRentData[i][rent_carid]][vFuel] = GetVehicleDataFuel(carRentData[i][rent_model]);

					SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เพิ่มรถเช่า %s ไอดี %d เข้าระบบ", ReturnPlayerName(playerid), ReturnVehicleModelName(carRentData[i][rent_model]), vehicleid);
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

CarRent_GetID(id)
{
	foreach(new i : Iter_CarRent) if (carRentData[i][rent_carid] == id) {
		return i;
	}
	return -1;
}

CMD:rentcarcmds(playerid) {
	SendClientMessage(playerid, COLOR_GRAD1, "คำสั่ง: /saverentcar (ใช้กับ /veh เท่านั้น), /editrentcar, /removerentcar");
	return 1;
}

flags:editrentcar(CMD_MANAGEMENT);
CMD:editrentcar(playerid, params[])
{
	new
	    id,
		index,
	    type[24],
	    string[128],
		str[128];

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /editrentcar [ไอดี (/dl)] [ตั้งค่า]");
	    SendClientMessage(playerid, COLOR_GREY, "ตั้งค่าที่ใช้ได้: ตำแหน่ง, ค่าเช่า");
		return 1;
	}
	if((index = CarRent_GetID(id)) != -1)
	{
		if (!strcmp(type, "ตำแหน่ง", true))
		{
        	new vehicleid = carRentData[index][rent_carid];
        	GetVehiclePos(vehicleid, carRentData[index][rent_x], carRentData[index][rent_y], carRentData[index][rent_z]);
        	GetVehicleZAngle(vehicleid, carRentData[index][rent_a]);
        	RentCar_Save(index);
        	DestroyVehicle(vehicleid);
        	carRentData[index][rent_carid] = CreateVehicle(carRentData[index][rent_model], carRentData[index][rent_x], carRentData[index][rent_y], carRentData[index][rent_z], carRentData[index][rent_a], -1, -1, 60000);
        	SetVehicleNumberPlate(carRentData[index][rent_carid], "รถเช่า");
        	PutPlayerInVehicle(playerid, carRentData[index][rent_carid], 0);
        	SendClientMessageEx(playerid, COLOR_GRAD, "   จุดเกิดรถเช่าของ "EMBED_WHITE"%s"EMBED_GRAD" ถูกเปลี่ยนมายังที่อยู่ปัจจุบันของคุณแล้ว", ReturnVehicleModelName(carRentData[index][rent_model]));
        	Log(adminactionlog, INFO, "%s: เปลี่ยนจุดเกิดรถเช่าของ %s(%d)", ReturnPlayerName(playerid), ReturnVehicleModelName(carRentData[index][rent_model]), carRentData[index][rent_id]);
		}
		else if (!strcmp(type, "ค่าเช่า", true))
		{
		    new price;

		    if (sscanf(string, "d", price))
		 	{
				format(str, sizeof str, "การใช้: /editrentcar %d ค่าเช่า [จำนวน]", id);
				SendClientMessage(playerid, COLOR_GRAD1, str);
			 	return 1;
			}

			if(price > 0) {

				carRentData[index][rent_price] = price;
				RentCar_Save(index);	

				SendClientMessageEx(playerid, COLOR_GRAD, "   ค่าเช่าของ "EMBED_WHITE"%s"EMBED_GRAD" ถูกปรับเป็น %d", ReturnVehicleModelName(carRentData[index][rent_model]), price);
				Log(adminactionlog, INFO, "%s: ปรับค่าเช่ารถ %s(%d) เป็น %d", ReturnPlayerName(playerid), ReturnVehicleModelName(carRentData[index][rent_model]), carRentData[index][rent_id], price);

			}
			else SendClientMessage(playerid, COLOR_GRAD1, "   ค่าเช่าต้องไม่ต่ำกว่า 0 ");

		}
		else
		{
			SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /editrentcar [ไอดี (/dl)] [ตั้งค่า]");
			SendClientMessage(playerid, COLOR_GREY, "ตั้งค่าที่ใช้ได้: ตำแหน่ง, ค่าเช่า");
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_GRAD2, "   ไอดีรถเช่าไม่ถูกต้อง");
	}
	return 1;
}

flags:removerentcar(CMD_MANAGEMENT);
CMD:removerentcar(playerid, params[])
{
	new
	    id = 0,
		index = -1;

	if (sscanf(params, "d", id))
 	{
	 	if (IsPlayerInAnyVehicle(playerid))
		 	id = GetPlayerVehicleID(playerid);

		else {
			SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /removerentcar [ไอดี (/dl)] ");
			return 1;
		}
	}
	if((index = CarRent_GetID(id)) != -1)
	{
		new
	        string[64];

		format(string, sizeof(string), "DELETE FROM `carrent` WHERE `rentID` = '%d'", carRentData[index][rent_id]);
		mysql_tquery(dbCon, string);

		Log(adminactionlog, INFO, "%s: ลบรถเช่า %s(SQLID %d)", ReturnPlayerName(playerid), ReturnVehicleModelName(carRentData[index][rent_model]), carRentData[index][rent_id]);

		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้ลบรถเช่า %s ไอดี %d ออกจากระบบ ", ReturnPlayerName(playerid), ReturnVehicleModelName(carRentData[index][rent_model]), carRentData[index][rent_id]);
		
		DestroyVehicle(carRentData[index][rent_carid]);
		Iter_Remove(Iter_CarRent, index);
	}
	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "ต้องเป็นรถเช่าเท่านั้น ");
	}
	return 1;
}

hook OP_StateChange(playerid, newstate, oldstate)
{
	#if defined SV_DEBUG
		printf("rentcar.pwn: OnPlayerStateChange(playerid %d, newstate %d, oldstate %d)", playerid, newstate, oldstate);
	#endif
	if (newstate == PLAYER_STATE_DRIVER)
	{
	    new vehicleid, id = -1, model;
		vehicleid = GetPlayerVehicleID(playerid);
		model = GetVehicleModel(vehicleid);

		if((id = IsVehicleRental(vehicleid)) != -1 && !IsVehicleRented(vehicleid))
		{
			new string[128];
			format(string, sizeof(string), "~w~You can Rent this car~n~Cost:~g~$%d~n~~w~To rent type ~g~/rentcar~n~~r~/exit to get off the car", carRent_GetPrice(id));
			Mobile_GameTextForPlayer(playerid, string, 5000, 3);

            SendClientMessageEx(playerid, COLOR_WHITE, "บริการเช่ายานพาหนะ: เช่า %s ในราคา %s (/rentcar)", g_arrVehicleNames[model - 400], FormatNumber(carRent_GetPrice(id)));
            SendClientMessage(playerid, COLOR_GREEN, "การเช่ายานพาหนะคุณจะสามารถ /lock มันได้, พิมพ์ /exit เพื่อลงจากรถ");

			TogglePlayerControllable(playerid, false);
		}
	}
    return 1;
}

hook OnVehicleSpawn(vehicleid) {
	if(IsVehicleRental(vehicleid) != -1) {
		SetLockStatus(vehicleid, false);
	}
	return 1;
}