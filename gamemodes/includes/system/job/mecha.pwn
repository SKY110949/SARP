#include <YSI\y_hooks>

// 93.4601,-199.2802,1.5440

new MechaPickup;

new
	serviceComp[MAX_PLAYERS],
	serviced[MAX_PLAYERS],
	serviceTowtruck[MAX_PLAYERS],
	serviceCustomer[MAX_PLAYERS]
;

new Float:mechanicPoints[][] = {
    { 348.2158,-1844.7000,4.5740 },
	{ 348.3769,-1836.9517,4.6240 },
	{ 348.4280,-1830.6210,4.5640 }, 
	{ 331.0227,-1829.5046,4.5040 },
	{ 330.7716,-1836.1095,4.5440},
	{ 330.4677,-1843.4862,4.5040},
	{ 1562.4496,-2170.9438,14.4693},
	{ 1562.7720,-2163.2009,14.4693},
	{ 1578.8933,-2163.5205,14.4693},
	{ 1578.7810,-2171.6331,14.4693},
	{ 1893.4088,-1870.6166,14.4835},
	{ 1898.4497,-1870.5536,14.4835},
	{ 1876.4086,-1871.8593,14.4435},
	{ 1882.4379,-1871.9164,14.4835},

	{ 2065.9790,-1880.5723,13.9411},
	{ 2056.3208,-1880.0804,13.9411},
	{ 2047.1849,-1879.6469,13.9411},
	{ 2037.8246,-1879.4602,13.9411}
};

new Spray_Pickup[4];

hook OnGameModeInit() {
    MechaPickup = CreateDynamicPickup(1239, 2, 88.4620,-165.0116,2.5938);
	CreateDynamic3DTextLabel("ช่างยนต์\nพิมพ์ /mechanicjob เพื่อรับงานนี้", -1, 88.4620,-165.0116,2.5938, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

	CreateDynamic3DTextLabel("บาร์เทนเดอร์\nคุณสามารถพิมพ์ /buydrink เพื่อซื้อเครื่องดื่ม", -1, -1851.7897, -137.2997, 11.9051, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
	CreateDynamicPickup(1239, 2, -1851.7897, -137.2997, 11.9051);

	/*CreateDynamic3DTextLabel("อู่ซ่อมรถ\nคุณสามารถพิมพ์ /repairengine, /repairbattery เพื่อซ่อมรถ", -1, -1968.3574, 102.9266, 28.0264, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
	CreateDynamicPickup(1239, 2, -1968.3574, 102.9266, 28.0264);*/

	for(new i = 0; i < sizeof(mechanicPoints); i ++) {
	    CreateDynamic3DTextLabel("อู่ซ่อมรถ\nคุณสามารถพิมพ์ /repairengine, /repairbattery เพื่อซ่อมรถ", COLOR_WHITE, mechanicPoints[i][0], mechanicPoints[i][1], mechanicPoints[i][2], 10.0);
	}

	CreateDynamic3DTextLabel("กล่องซ่อมรถ\nคุณสามารถพิมพ์ /buykit เพื่อซื้อกล่องซ่อมรถ", -1, -1978.8680, 106.1160, 27.6875, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
	CreateDynamicPickup(1239, 2, -1978.8680, 106.1160, 27.6875);

	// Entrances and exits ends

    Spray_Pickup[0] = CreateDynamicPickup(1239, 14, 2073.2979,-1831.1228,13.5469,0); // Pay & Spray
    Spray_Pickup[1] = CreateDynamicPickup(1239, 14, 1024.9756,-1030.7930,32.0257,0); // Pay & Spray
    Spray_Pickup[2] = CreateDynamicPickup(1239, 14, 488.3819,-1733.0563,11.1752,0); // Pay & Spray
    Spray_Pickup[3] = CreateDynamicPickup(1239, 14, 719.8940,-464.8272,16.3359,0); // Pay & Spray

	// Mechanic San Fierro

	CreateDynamicObject(12943, -1972.23218, 103.13348, 26.62768,   0.00000, 0.00000, 180.11983);
	CreateDynamicObject(19817, -1970.66565, 102.98573, 25.10455,   0.00000, 0.00000, -90.42000);
	CreateDynamicObject(19815, -1964.24573, 102.95554, 28.28944,   0.00000, 0.00000, -90.06001);

	//N Spray Close

	CreateDynamicObject(971,1025.2795,-1029.2299,32.1016,-0.00000,0.000000,0); // Pay & Spray
	CreateDynamicObject(971,488.2341,-1735.4591,11.1416,-0.00000,0.000000,174); // Pay & Spray
	CreateDynamicObject(971,2071.5410,-1831.4143,13.5469,-0.00000,0.000000,90); // Pay & Spray
	CreateDynamicObject(971,719.8199,-462.4768,16.3359,-0.00000,0.000000,0); // Pay & Spray
	CreateDynamicObject(971,-1904.4561,277.8578,41.0469,-0.00000,0.000000,0); // Pay & Spray


}

stock IsPlayerNearMechanicPoint(playerid) {
	for(new x = 0; x < sizeof(mechanicPoints); x ++) {
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, mechanicPoints[x][0], mechanicPoints[x][1], mechanicPoints[x][2])) {
	        return 1;
		}
	}
	return 0;
}

forward AfterSpray(playerid);
public AfterSpray(playerid) {
	if(IsPlayerInAnyVehicle(playerid))
	{
	    new tmpcar = GetPlayerVehicleID(playerid);

		SetVehicleHealthEx(tmpcar, GetVehicleDataHealth(GetVehicleModel(tmpcar)));
		//SetVehicleDamageStatus(tmpcar, 0, 0, 0, 0);
		
		switch(GetPVarInt(playerid,"SprayID"))
		{
		    case 1: SetVehiclePos(tmpcar, 2076.5461,-1832.5647,13.5545);
		    case 2: SetVehiclePos(tmpcar, 1025.4225,-1033.1587,31.8380);
		    case 3: SetVehiclePos(tmpcar, 488.3767,-1731.1235,11.2469);
		    case 4: SetVehiclePos(tmpcar, 720.2908,-467.6113,16.3437);
		}
		TogglePlayerControllable(playerid, 1);
		DeletePVar(playerid,"SprayID");
	}
	return 1;
}

hook OP_PickUpDynamicPickup(playerid, pickupid)
{
	if(pickupid == MechaPickup) {
		Mobile_GameTextForPlayer(playerid, "~w~Type /mechanicjob to be ~n~a Car Mechanic", 5000, 3);
		return 1;
	}

	else if(pickupid == Spray_Pickup[0] || pickupid == Spray_Pickup[1] || pickupid == Spray_Pickup[2] || pickupid == Spray_Pickup[3])
	{
		Mobile_GameTextForPlayer(playerid, "~w~Type /enter to use service", 5000, 3);
		return 1;
	}

	
    return 1;
}

CMD:mechanicjob(playerid)
{
	if (IsPlayerInRangeOfPoint(playerid, 3.0, 88.4620,-165.0116,2.5938)) {

        if(playerData[playerid][pSideJob] == JOB_MECHANIC || playerData[playerid][pJob] == JOB_MECHANIC) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณเป็นอาชีพ Mechanic อยู่แล้ว");

		if(playerData[playerid][pJob] == JOB_NONE)
		{
	        playerData[playerid][pJob] = JOB_MECHANIC;
            GameTextForPlayer(playerid, "~r~Congratulations,~n~~w~You are now a ~y~Car Mechanic.~n~~w~/jobhelp.", 8000, 1);

			if(playerData[playerid][pSideJob] == JOB_NONE) 
                SendClientMessage(playerid, COLOR_GRAD6, "/jobswitch เพื่อทำให้มันย้ายไปเป็นอาชีพเสริม");
		}
		else
		{
		    if(playerData[playerid][pSideJob] == JOB_NONE)
		    {
		        playerData[playerid][pSideJob] = JOB_MECHANIC;
		        ShowPlayerFooter(playerid, "~r~Congratulations,~n~~w~You are now a ~y~Car Mechanic.~n~~w~/jobhelp.", 8000);
		    }
		    else
		    {
		        SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องออกจากงานก่อน (/leavejob หรือ /leavesidejob)");
		    }
		}
		return 1;
	}
	else return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่จุดสมัครงาน");
}

CMD:paintcar(playerid, params[])
{
	if(playerData[playerid][pJob] != JOB_MECHANIC && playerData[playerid][pSideJob] != JOB_MECHANIC)
	    return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่ใช่ Car Mechanic");
	
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่บน Towtruck");

	new carid = -1;
    if((carid = PlayerCar_GetID(GetPlayerVehicleID(playerid))) != -1) {

        if(playerCarData[carid][carModel] != 525)
			return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่บน Towtruck");

        new color1, color2, userid, confirm[16];

		if (sscanf(params, "uddS()[16]", userid, color1, color2, confirm)) 
			return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /paintcar [ไอดีผู้เล่น/ชื่อบางส่วน] [สี 1] [สี 2]");

		if(userid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

		if(color1 > 128 || color2 > 128 || color1 < 0 || color2 < 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "สีของยานพาหนะ: 0-128");

		if(tToAccept[userid] != OFFER_TYPE_NONE)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "ผู้เล่นนั้นมีข้อเสนออยู่ในปัจจุบัน!");

		if (!IsPlayerNearPlayer(playerid, userid, 10.0))
		   return SendClientMessage(playerid, COLOR_GRAD1, "ผู้เล่นนั้นตัดการเชื่อมต่อหรือไม่ได้อยู่ใกล้คุณ");

		if (!IsPlayerInAnyVehicle(userid))
		    return SendClientMessage(playerid, COLOR_GRAD1, "ผู้เล่นนั้นไม่ได้อยู่บนรถ");

      	if (!strcmp(confirm, "yes", true) && strlen(confirm))
		{
			if(playerCarData[carid][carComp] < 10) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมี Component ไม่เพียงพอสำหรับการเปลี่ยนสียานพาหนะ");

			SendClientMessage(playerid, COLOR_YELLOW, "SERVER: ข้อเสนอถูกส่ง");

			pToAccept[userid] = playerid;
			tToAccept[userid] = OFFER_TYPE_SERVICE;

			SetPVarInt(playerid, "color1", color1);
			SetPVarInt(playerid, "color2", color2);

			serviceComp[playerid] = 10;
			serviceTowtruck[playerid] = carid;
			serviceCustomer[playerid] = GetPlayerVehicleID(userid);
			serviced[playerid] = 2;

			Dialog_Show(userid, DialogMechAccept, DIALOG_STYLE_MSGBOX, "การยืนยัน", ""EMBED_WHITE"%s ได้เสนอที่จะเปลี่ยนสีให้กับ %s ของคุณ\nสีหลัก[{%06x}#%d"EMBED_WHITE"] สีรอง[{%06x}#%d"EMBED_WHITE"]\n\nเลือกความต้องการด้านล่างนี้:", "ต้องการ", "ไม่ต้องการ", ReturnRealName(playerid), ReturnVehicleModelName(GetVehicleModel(serviceCustomer[playerid])), g_arrCarColors[color1] >>> 8, color1, g_arrCarColors[color2] >>> 8, color2);
		}
		else {
			SendClientMessage(playerid, COLOR_YELLOW, "บริการนี้ต้องใช้ Component ทั้งหมด 10 ชิ้น");
			SendClientMessageEx(playerid, COLOR_GRAD1, "การใช้: /paintcar %d %d yes", color1, color2);
		}
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: คำสั่งนี้สามารถใช้ได้เฉพาะยานพาหนะส่วนตัว แต่คุณอยู่ในยานพาหนะสาธารณะ (Static)");

	return 1;
}

CMD:colorlist(playerid, params[])
{
	return Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "สีที่ใช้ได้", GetVehicleColorList(), "โอเค", "");
}

CMD:service(playerid, params[])
{
	//new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	
	/*if (factionType != FACTION_TYPE_MECHA)
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับ Faction ช่างซ่อมรถเท่านั้น !");*/

	if(playerData[playerid][pJob] != JOB_MECHANIC && playerData[playerid][pSideJob] != JOB_MECHANIC)
	    return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่ใช่ช่างซ่อมรถ");

	new
		userid, type, confirm[16], carid, pcarid;


    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่บน Towtruck");

    if((carid = PlayerCar_GetID(GetPlayerVehicleID(playerid))) != -1) {

        if(playerCarData[carid][carModel] != 525)
			return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่บน Towtruck");

		if (sscanf(params, "udS()[16]", userid, type, confirm))
		{
			SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /service [ไอดีผู้เล่น/ชื่อบางส่วน] [บริการ]");
			SendClientMessage(playerid, COLOR_GRAD1, "บริการ 1:"EMBED_WHITE" เพิ่มเลือดรถ");
			//SendClientMessage(playerid, COLOR_GRAD1, "บริการ 2:"EMBED_WHITE" ซ่อมตัวถัง (( ความเสียหายที่มองเห็น ))");
			return 1;
		}

		if(userid == INVALID_PLAYER_ID)
            return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

		if(tToAccept[userid] != OFFER_TYPE_NONE)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "ผู้เล่นนั้นมีข้อเสนออยู่ในปัจจุบัน!");

		if (!IsPlayerNearPlayer(playerid, userid, 15.0))
		   return SendClientMessage(playerid, COLOR_GRAD1, "ผู้เล่นนั้นตัดการเชื่อมต่อหรือไม่ได้อยู่ใกล้คุณ");

		if((pcarid = GetPlayerVehicleID(userid)) == 0)
		    return SendClientMessage(playerid, COLOR_GRAD1, "ผู้เล่นนั้นไม่ได้อยู่บนรถ");

		if(type >= 1 && type <= 1)
		{
			new model=GetVehicleModel(pcarid), comp = 0, service_name[20];
			if(model != 0) {
				switch(type) {
					case 1: {
						new Float:maxHealth = GetVehicleDataHealth(model);
						GetVehicleHealth(pcarid, vehicleData[pcarid][vHealth]);
						
						if(maxHealth < vehicleData[pcarid][vHealth]) {
							maxHealth = vehicleData[pcarid][vHealth] - maxHealth;
						}
						else {
							maxHealth = maxHealth - vehicleData[pcarid][vHealth];
						}
						comp = floatround(maxHealth / 50.0 * 2.0);
						format(service_name, sizeof(service_name), "ซ่อมแซมยานพาหนะ");
					}
					/*case 2: {
						comp = floatround(float(GetRepairPrice(pcarid)) / 10.0, floatround_round);
						format(service_name, sizeof(service_name), "ซ่อมแซมตัวถัง");
					}*/
				}
			}
			else return SendClientMessage(playerid, COLOR_GRAD1, "ผู้เล่นนั้นไม่ได้อยู่บนรถ");

			if(comp <= 0) 
                return SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่สามารถให้บริการนี้กับยานพาหนะปัจจุบันได้");

      		if (!strcmp(confirm, "yes", true) && strlen(confirm))
		    {
		        if(playerCarData[carid][carComp] < comp) 
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมี วัสดุ ไม่เพียงสำหรับการให้บริการ");

				pToAccept[userid] = playerid;
				tToAccept[userid] = OFFER_TYPE_SERVICE;

				serviceComp[playerid] = comp;
				serviceTowtruck[playerid] = carid;
				serviceCustomer[playerid] = pcarid;
				serviced[playerid] = type;

				Dialog_Show(userid, DialogMechAccept, DIALOG_STYLE_MSGBOX, "การยืนยัน", "%s ได้เสนอที่จะ %s ให้กับ %s ของคุณ\n\nเลือกความต้องการด้านล่างนี้:", "ต้องการ", "ไม่ต้องการ", ReturnRealName(playerid), service_name, ReturnVehicleModelName(GetVehicleModel(serviceCustomer[playerid])));
                //SendClientMessageEx(userid, COLOR_GRAD1, "%s ได้เสนอที่จะ %s ให้กับ %s พิมพ์ 'Y' เพื่อยอมรับ หรือ 'N' เพื่อปฏิเสธ", ReturnRealName(playerid), service_name, ReturnVehicleModelName(playerCarData[playerData[playerid][pPCarkey]][carModel]));
				/*SendClientMessageEx(userid, COLOR_GRAD1, "%s ได้เสนอที่จะ %s ให้กับ %s พิมพ์ 'Y' เพื่อยอมรับ หรือ 'N' เพื่อปฏิเสธ", ReturnRealName(playerid), service_name, ReturnVehicleModelName(playerCarData[playerData[playerid][pPCarkey]][carModel]));
                SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้เสนอที่จะ %s ให้กับ %s ของ %s", service_name, ReturnVehicleModelName(playerCarData[playerData[playerid][pPCarkey]][carModel]), ReturnRealName(userid));*/
		    }
			else {

				SendClientMessageEx(playerid, COLOR_YELLOW, "บริการนี้ต้องใช้ วัสดุ ทั้งหมด %d ชิ้น", comp);
				SendClientMessageEx(playerid, COLOR_GRAD1, "การใช้: /service [ไอดีผู้เล่น/ชื่อบางส่วน] %d yes", type);
			}
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "บริการที่ใช้ได้ 1 เท่านั้น");
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: คำสั่งนี้สามารถใช้ได้เฉพาะยานพาหนะส่วนตัว แต่คุณอยู่ในยานพาหนะสาธารณะ (Static)");


	return 1;
}

CMD:checkcomp(playerid, params[])
{
	if(playerData[playerid][pJob] != JOB_MECHANIC && playerData[playerid][pSideJob] != JOB_MECHANIC)
	    return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่ใช่ช่างซ่อมรถ");

	new slot = -1, vehicleid = GetPlayerVehicleID(playerid);

	if (GetVehicleModel(vehicleid) != 525)
		return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้นั่งอยู่บน Tow Truck");

    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้นั่งอยู่ที่นั่งคนขับของยานพาหนะ");

    if((slot = PlayerCar_GetID(vehicleid)) != -1) {
		SendClientMessageEx(playerid, COLOR_WHITE, "วัสดุ: %d ชิ้น", playerCarData[slot][carComp]);
	}
	else {
        SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: คำสั่งนี้สามารถใช้ได้เฉพาะยานพาหนะส่วนตัว แต่คุณอยู่ในยานพาหนะสาธารณะ (Static)");
    }
	return 1;
}

CMD:buycomp(playerid, params[])
{

	if(playerData[playerid][pJob] != JOB_MECHANIC && playerData[playerid][pSideJob] != JOB_MECHANIC)
	    return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่ใช่ช่างซ่อมรถ");

	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 93.4601, -199.2802, 1.5440))
	{
		SetPlayerCheckpoint(playerid, 93.4601, -199.2802, 1.5440, 4.0);
		gPlayerCheckpoint{playerid} = true;
		SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ที่โกดังขายชิ้นส่วน เราให้เครื่องหมายไว้ในแผนที่แล้ว");
		return 1;
	}
	else
	{
		new vehicleid = GetPlayerVehicleID(playerid), amount, tmp2[16];

		if (GetVehicleModel(vehicleid) != 525)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้นั่งอยู่บน Tow Truck");

	    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	        return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้นั่งอยู่ที่นั่งคนขับของยานพาหนะ");

		if (sscanf(params, "dS()[16]", amount, tmp2)) {
            SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /buycomp");
		    SendClientMessage(playerid, COLOR_LIGHTRED, "คุณถูกจำกัดไว้ที่ 1-2,000");
		    SendClientMessage(playerid, COLOR_WHITE, "!! ในชิ้นส่วนแต่ละลังจะมีวัสดุอยู่ 25 ชิ้น !!");
		    return 1;
		}

		new string[16], price = amount*250, slot = -1;
		if (!sscanf(tmp2, "s[16]", string)) {

	        if(strcmp(string,"yes",true) == 0)
			{
				if(amount <= 0) {
				    SendClientMessage(playerid, COLOR_LIGHTRED, "จำนวนไม่ถูกต้อง");
				    return 1;
				}

				if(GetPlayerMoney(playerid) <  price)
				    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมีเงินไม่พอที่จะซื้อ");

                if((slot = PlayerCar_GetID(vehicleid)) != -1) {
                    if(playerCarData[slot][carComp]+(amount*25) < 50000)
                    {
                        GivePlayerMoneyEx(playerid, -price);
	                    playerCarData[slot][carComp]+=amount*25;
						SendClientMessageEx(playerid, COLOR_WHITE, "คุณซื้อสินค้า %d (วัสดุ %d ชิ้น) ลังให้กับรถบรรทุกของคุณ", amount, amount*25);
					}
					else SendClientMessage(playerid, COLOR_WHITE, "ไม่สามารถซื้อได้มากกว่านี้แล้ว 1-2,000");
				}
				else SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: คำสั่งนี้สามารถใช้ได้เฉพาะยานพาหนะส่วนตัว แต่คุณอยู่ในยานพาหนะสาธารณะ (Static)");

				return 1;
			}
		}
		SendClientMessageEx(playerid, COLOR_WHITE, "ราคา: {E85050}%s", FormatNumber(price));
		SendClientMessageEx(playerid, COLOR_GRAD1, "การใช้: /buycomp %d yes", amount);
	}
	return 1;
}

CMD:repairengine(playerid, params[])
{
	// new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	
	/*if (factionType != FACTION_TYPE_MECHA)
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับ Faction ช่างซ่อมรถเท่านั้น !");*/

	//if (!IsPlayerInRangeOfPoint(playerid, 3.0, -1968.3574, 102.9266, 28.0264))
		//return SendClientMessage(playerid, COLOR_GRAD2, "คุณต้องอยู่ที่อู่ในเมือง San Fierro");

	if(!IsPlayerNearMechanicPoint(playerid)) 
		return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่ได้อยู่ที่อู่ซ่อมรถ!");

	if(playerData[playerid][pJob] != JOB_MECHANIC && playerData[playerid][pSideJob] != JOB_MECHANIC)
	    return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่ใช่ช่างซ่อมรถ");

	if(playerData[playerid][pOre] < 100)
		return SendClientMessage(playerid, COLOR_GRAD2, "คุณต้องมีเหล็กมากกว่า 100");

	if(playerData[playerid][pCash] < 2000)
		return SendClientMessage(playerid, COLOR_GRAD2, "คุณต้องมีเงินมากกว่า $2,000");

	new
		carid;

    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่บนรถใด ๆ");

    if((carid = PlayerCar_GetID(GetPlayerVehicleID(playerid))) != -1) 
	{
		playerData[playerid][pOre] -= 100;
		GivePlayerMoneyEx(playerid, -2000);

		playerCarData[carid][carEngineL] = 100;
		SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ทำการซ่อม Engine ของเครื่องยนต์, ทำให้รถของคุณมีประสิทธิภาพที่มากขึ้น");
	}
	return 1;
}

CMD:repairbattery(playerid, params[])
{
	// new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	
	/*if (factionType != FACTION_TYPE_MECHA)
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับ Faction ช่างซ่อมรถเท่านั้น !");*/

	if(!IsPlayerNearMechanicPoint(playerid)) 
		return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่ได้อยู่ที่อู่ซ่อมรถ!");

	if(playerData[playerid][pJob] != JOB_MECHANIC && playerData[playerid][pSideJob] != JOB_MECHANIC)
	    return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่ใช่ช่างซ่อมรถ");

	if(playerData[playerid][pOre] < 100)
		return SendClientMessage(playerid, COLOR_GRAD2, "คุณต้องมีเหล็กมากกว่า 100");

	if(playerData[playerid][pCash] < 2000)
		return SendClientMessage(playerid, COLOR_GRAD2, "คุณต้องมีเงินมากกว่า $2,000");

	new
		carid;

    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่บนรถใด ๆ");

    if((carid = PlayerCar_GetID(GetPlayerVehicleID(playerid))) != -1) 
	{
		playerData[playerid][pOre] -= 100;
		GivePlayerMoneyEx(playerid, -2000);

		playerCarData[carid][carBatteryL] = 100;
		SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ทำการซ่อม Battery ของรถยนต์, ทำให้รถของคุณมีประสิทธิภาพที่มากขึ้น");
	}
	return 1;
}

CMD:buykit(playerid, params[])
{
	//new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	
	if (!IsPlayerInRangeOfPoint(playerid, 3.0, -1978.8680,106.1160,27.6875))
		return SendClientMessage(playerid, COLOR_GRAD2, "คุณต้องอยู่ที่อู่ในเมือง San Fierro");

	if(playerData[playerid][pJob] != JOB_MECHANIC && playerData[playerid][pSideJob] != JOB_MECHANIC)
	    return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่ใช่ช่างซ่อมรถ");

	if (playerData[playerid][pCash] < 10000)
		return SendClientMessage(playerid, COLOR_GRAD2, "คุณต้องมีเงินมากกว่า $10,000");

    new mecs = MecOnline();

	if(mecs != 0) 
		return SendClientMessage(playerid, COLOR_GRAD2, "คุณจะสามารถซื้อกล่องซ่อมรถได้ก็ต่อเมื่อไม่มีช่างซ่อมรถออนไลน์");

	playerData[playerid][pMechanicBox] += 1;
	GivePlayerMoneyEx(playerid, -10000);
	SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ทำการซื้อกล่องซ่อมรถยนต์ฉุกเฉิน, คุณสามารถใช้งานด้วยการพิมพ์ /repair บนยานพาหนะของคุณ");

	return 1;
}

CMD:repair(playerid, params[])
{
	if (playerData[playerid][pMechanicBox] < 0)
		return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่มีกล่องซ่อมรถ");

    if (!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่บนรถใด ๆ");

	if (GetEngineStatus(GetPlayerVehicleID(playerid)))
	    return SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องดับเครื่องยนต์ก่อนจึงจะสามารถซ่อมรถได้ !");

	RepairVehicle(GetPlayerVehicleID(playerid));
	playerData[playerid][pMechanicBox] -= 1;

	SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ทำการซ่อมยานพาหนะของคุณด้วยกล่องซ่อม, มันจะดีขึ้นมากกว่านี้หากคุณซ่อมที่อู่ซ่อมรถ");

	return 1;
}

stock MecOnline()
{
	new mec;
	foreach(new x: Player) {

		new factionType = Faction_GetTypeID(playerData[x][pFaction]);

		if(IsPlayerConnected(x) && factionType == FACTION_TYPE_MECHA) {
        	mec++;
		}
	}
	return mec;
}

Dialog:DialogMechAccept(playerid, response, listitem, inputtext[]) {

	new offerid = pToAccept[playerid];

	if (tToAccept[playerid] == OFFER_TYPE_SERVICE && IsPlayerNearPlayer(playerid, offerid, 15.0)) {

		new comp = serviceComp[offerid], towtruck = serviceTowtruck[offerid], type = serviced[offerid], target_car = serviceCustomer[offerid];

		if (response) {
			Mobile_GameTextForPlayer(offerid, sprintf("~n~~n~~n~~y~%s ~g~has accepted your offer!", ReturnRealName(playerid)), 3000, 5);
			Mobile_GameTextForPlayer(playerid, sprintf("~n~~n~~n~~g~You have accepted ~y~%s~g~ offer!", ReturnRealName(offerid)), 3000, 5);

			if (Iter_Contains(Iter_PlayerCar, towtruck)) {
				switch(type) {
					case 1: {
						RepairVehicle(target_car);
						SetVehicleHealthEx(target_car, GetVehicleDataHealth(GetVehicleModel(target_car)));
						playerCarData[towtruck][carComp] -= comp;
						PlayerPlaySoundEx(offerid, 1133);
						SendClientMessage(offerid, COLOR_YELLOW, "SERVER: ข้อเสนอสมบูรณ์แล้ว");
						SendClientMessage(playerid, COLOR_YELLOW, "SERVER: ข้อเสนอสมบูรณ์แล้ว");
					}
					case 2: {
						new color1 = GetPVarInt(offerid, "color1");
						new color2 = GetPVarInt(offerid, "color2");
						SetVehicleColor(target_car, color1, color2);

						playerCarData[towtruck][carComp] -= comp;
						PlayerPlaySoundEx(offerid, 1133);
						SendClientMessage(offerid, COLOR_YELLOW, "SERVER: ข้อเสนอสมบูรณ์แล้ว");
						SendClientMessage(playerid, COLOR_YELLOW, "SERVER: ข้อเสนอสมบูรณ์แล้ว");

						if (isPlayerAndroid(playerid) != 0) {
							new id = PlayerCar_GetID(target_car);
							if (id != -1) {

								new Float:Vx, Float:Vy, Float:Vz, Float:Va;
								new
									engine,
									lights,
									alarm,
									doors,
									bonnet,
									boot,
									objective;

								GetVehicleParamsEx(target_car, engine, lights, alarm, doors, bonnet, boot, objective);
								GetVehiclePos(target_car, Vx,Vy,Vz);
								GetVehicleZAngle(target_car, Va);
								GetVehicleHealth(target_car, playerCarData[id][carHealth]);

								DestroyVehicle(playerCarData[id][carVehicle]);

								playerCarData[id][carVehicle] = CreateVehicle(playerCarData[id][carModel], Vx,Vy,Vz,Va, color1, color2, -1);
								SetVehicleNumberPlate(playerCarData[id][carVehicle], playerCarData[id][carPlate]);

								LinkVehicleToInterior(playerCarData[id][carVehicle], GetPlayerInterior(playerid));
								SetVehicleVirtualWorld(playerCarData[id][carVehicle], GetPlayerVirtualWorld(playerid));
									
								SetVehicleParamsEx(playerCarData[id][carVehicle], engine, lights, alarm, doors, bonnet, boot, objective);

								SetVehicleHealthEx(playerCarData[id][carVehicle], playerCarData[id][carHealth]);
								
								PutPlayerInVehicle(playerid, playerCarData[id][carVehicle], 0);
							}
						}
					}
				}
			}
			else {
				SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" เกิดข้อผิดพลาดกับยานพาหนะของช่าง");
			}
		}
		else {
			Mobile_GameTextForPlayer(offerid, sprintf("~n~~n~~n~~y~%s ~r~has denied your offer!", ReturnRealName(playerid)), 3000, 5);
			Mobile_GameTextForPlayer(playerid, sprintf("~n~~n~~n~~r~You have denied ~y~%s~r~ offer!", ReturnRealName(offerid)), 3000, 5);
		}

		serviceComp[offerid] = 0;
		serviceTowtruck[offerid] = -1;
		serviced[offerid] = 0;
		tToAccept[playerid] = OFFER_TYPE_NONE;
	}
	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" ข้อเสนอไม่ถูกต้อง/ช่างไม่ได้อยู่ใกล้คุณ");
	}

    return 1;
}

/*

hook OnPlayerText(playerid, text[]) {
	if (tToAccept[playerid] == OFFER_TYPE_SERVICE) {
        
		new offerid = pToAccept[playerid], comp = serviceComp[offerid], towtruck = serviceTowtruck[offerid], type = serviced[offerid], target_car = serviceCustomer[offerid];
		
		if (isequal(text, "Y", true)) {

			Mobile_GameTextForPlayer(offerid, sprintf("~n~~n~~n~~y~%s ~g~has accepted your offer!", ReturnRealName(playerid)), 3000, 5);
			Mobile_GameTextForPlayer(playerid, sprintf("~n~~n~~n~~g~You have accepted ~y~%s~g~ offer!", ReturnRealName(offerid)), 3000, 5);

            if (Iter_Contains(Iter_PlayerCar, towtruck)) {
                switch(type) {
                    case 1: {
				        SetVehicleHealthEx(target_car, GetVehicleDataHealth(GetVehicleModel(target_car)));
                        playerCarData[towtruck][carComp] -= comp;
                        PlayerPlaySoundEx(offerid, 1133);
                        SendClientMessage(playerid, COLOR_YELLOW, "SERVER: ยานพาหนะของคุณถูกซ่อมเรียบร้อยแล้ว");
                    }
                }
            }
            serviceCustomer[offerid] = 0;
            serviceComp[offerid] = 0;
            serviceTowtruck[offerid] = -1;
            serviced[offerid] = 0;
            tToAccept[playerid] = OFFER_TYPE_NONE;

            return -1;
		}
		else if (isequal(text, "N", true)) {

			Mobile_GameTextForPlayer(offerid, sprintf("~n~~n~~n~~y~%s ~r~has denied your offer!", ReturnRealName(playerid)), 3000, 5);
			Mobile_GameTextForPlayer(playerid, sprintf("~n~~n~~n~~r~You have denied ~y~%s~r~ offer!", ReturnRealName(offerid)), 3000, 5);

            serviceComp[offerid] = 0;
            serviceTowtruck[offerid] = -1;
            serviced[offerid] = 0;
            tToAccept[playerid] = OFFER_TYPE_NONE;
            return -1;
		}
	}


	return 0;
}
*/
