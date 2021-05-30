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
	CreateDynamic3DTextLabel("��ҧ¹��\n����� /mechanicjob �����Ѻ�ҹ���", -1, 88.4620,-165.0116,2.5938, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

	CreateDynamic3DTextLabel("����෹����\n�س����ö����� /buydrink ���ͫ�������ͧ����", -1, -1851.7897, -137.2997, 11.9051, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
	CreateDynamicPickup(1239, 2, -1851.7897, -137.2997, 11.9051);

	/*CreateDynamic3DTextLabel("������ö\n�س����ö����� /repairengine, /repairbattery ���ͫ���ö", -1, -1968.3574, 102.9266, 28.0264, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
	CreateDynamicPickup(1239, 2, -1968.3574, 102.9266, 28.0264);*/

	for(new i = 0; i < sizeof(mechanicPoints); i ++) {
	    CreateDynamic3DTextLabel("������ö\n�س����ö����� /repairengine, /repairbattery ���ͫ���ö", COLOR_WHITE, mechanicPoints[i][0], mechanicPoints[i][1], mechanicPoints[i][2], 10.0);
	}

	CreateDynamic3DTextLabel("���ͧ����ö\n�س����ö����� /buykit ���ͫ��͡��ͧ����ö", -1, -1978.8680, 106.1160, 27.6875, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
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

        if(playerData[playerid][pSideJob] == JOB_MECHANIC || playerData[playerid][pJob] == JOB_MECHANIC) return SendClientMessage(playerid, COLOR_LIGHTRED, "�س���Ҫվ Mechanic ��������");

		if(playerData[playerid][pJob] == JOB_NONE)
		{
	        playerData[playerid][pJob] = JOB_MECHANIC;
            GameTextForPlayer(playerid, "~r~Congratulations,~n~~w~You are now a ~y~Car Mechanic.~n~~w~/jobhelp.", 8000, 1);

			if(playerData[playerid][pSideJob] == JOB_NONE) 
                SendClientMessage(playerid, COLOR_GRAD6, "/jobswitch ���ͷ�����ѹ��������Ҫվ�����");
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
		        SendClientMessage(playerid, COLOR_LIGHTRED, "�س��ͧ�͡�ҡ�ҹ��͹ (/leavejob ���� /leavesidejob)");
		    }
		}
		return 1;
	}
	else return SendClientMessage(playerid, COLOR_GRAD1, "�س�����������ش��Ѥçҹ");
}

CMD:paintcar(playerid, params[])
{
	if(playerData[playerid][pJob] != JOB_MECHANIC && playerData[playerid][pSideJob] != JOB_MECHANIC)
	    return SendClientMessage(playerid, COLOR_GRAD2, "�س����� Car Mechanic");
	
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_GRAD1, "�س��������躹 Towtruck");

	new carid = -1;
    if((carid = PlayerCar_GetID(GetPlayerVehicleID(playerid))) != -1) {

        if(playerCarData[carid][carModel] != 525)
			return SendClientMessage(playerid, COLOR_GRAD1, "�س��������躹 Towtruck");

        new color1, color2, userid, confirm[16];

		if (sscanf(params, "uddS()[16]", userid, color1, color2, confirm)) 
			return SendClientMessage(playerid, COLOR_GRAD1, "�����: /paintcar [�ʹռ�����/���ͺҧ��ǹ] [�� 1] [�� 2]");

		if(userid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

		if(color1 > 128 || color2 > 128 || color1 < 0 || color2 < 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "�բͧ�ҹ��˹�: 0-128");

		if(tToAccept[userid] != OFFER_TYPE_NONE)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "�����蹹���բ���ʹ�����㹻Ѩ�غѹ!");

		if (!IsPlayerNearPlayer(playerid, userid, 10.0))
		   return SendClientMessage(playerid, COLOR_GRAD1, "�����蹹�鹵Ѵ���������������������������س");

		if (!IsPlayerInAnyVehicle(userid))
		    return SendClientMessage(playerid, COLOR_GRAD1, "�����蹹����������躹ö");

      	if (!strcmp(confirm, "yes", true) && strlen(confirm))
		{
			if(playerCarData[carid][carComp] < 10) return SendClientMessage(playerid, COLOR_LIGHTRED, "�س�� Component �����§������Ѻ�������¹���ҹ��˹�");

			SendClientMessage(playerid, COLOR_YELLOW, "SERVER: ����ʹͶ١��");

			pToAccept[userid] = playerid;
			tToAccept[userid] = OFFER_TYPE_SERVICE;

			SetPVarInt(playerid, "color1", color1);
			SetPVarInt(playerid, "color2", color2);

			serviceComp[playerid] = 10;
			serviceTowtruck[playerid] = carid;
			serviceCustomer[playerid] = GetPlayerVehicleID(userid);
			serviced[playerid] = 2;

			Dialog_Show(userid, DialogMechAccept, DIALOG_STYLE_MSGBOX, "����׹�ѹ", ""EMBED_WHITE"%s ���ʹͷ�������¹�����Ѻ %s �ͧ�س\n����ѡ[{%06x}#%d"EMBED_WHITE"] ���ͧ[{%06x}#%d"EMBED_WHITE"]\n\n���͡������ͧ��ô�ҹ��ҧ���:", "��ͧ���", "����ͧ���", ReturnRealName(playerid), ReturnVehicleModelName(GetVehicleModel(serviceCustomer[playerid])), g_arrCarColors[color1] >>> 8, color1, g_arrCarColors[color2] >>> 8, color2);
		}
		else {
			SendClientMessage(playerid, COLOR_YELLOW, "��ԡ�ù���ͧ�� Component ������ 10 ���");
			SendClientMessageEx(playerid, COLOR_GRAD1, "�����: /paintcar %d %d yes", color1, color2);
		}
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: ����觹������ö����੾���ҹ��˹���ǹ��� ��س������ҹ��˹��Ҹ�ó� (Static)");

	return 1;
}

CMD:colorlist(playerid, params[])
{
	return Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "�շ������", GetVehicleColorList(), "���", "");
}

CMD:service(playerid, params[])
{
	//new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	
	/*if (factionType != FACTION_TYPE_MECHA)
	    return SendClientMessage(playerid, COLOR_GRAD2,"   ����Ѻ Faction ��ҧ����ö��ҹ�� !");*/

	if(playerData[playerid][pJob] != JOB_MECHANIC && playerData[playerid][pSideJob] != JOB_MECHANIC)
	    return SendClientMessage(playerid, COLOR_GRAD2, "�س������ҧ����ö");

	new
		userid, type, confirm[16], carid, pcarid;


    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_GRAD1, "�س��������躹 Towtruck");

    if((carid = PlayerCar_GetID(GetPlayerVehicleID(playerid))) != -1) {

        if(playerCarData[carid][carModel] != 525)
			return SendClientMessage(playerid, COLOR_GRAD1, "�س��������躹 Towtruck");

		if (sscanf(params, "udS()[16]", userid, type, confirm))
		{
			SendClientMessage(playerid, COLOR_GRAD1, "�����: /service [�ʹռ�����/���ͺҧ��ǹ] [��ԡ��]");
			SendClientMessage(playerid, COLOR_GRAD1, "��ԡ�� 1:"EMBED_WHITE" �������ʹö");
			//SendClientMessage(playerid, COLOR_GRAD1, "��ԡ�� 2:"EMBED_WHITE" ������Ƕѧ (( ����������·���ͧ��� ))");
			return 1;
		}

		if(userid == INVALID_PLAYER_ID)
            return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

		if(tToAccept[userid] != OFFER_TYPE_NONE)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "�����蹹���բ���ʹ�����㹻Ѩ�غѹ!");

		if (!IsPlayerNearPlayer(playerid, userid, 15.0))
		   return SendClientMessage(playerid, COLOR_GRAD1, "�����蹹�鹵Ѵ���������������������������س");

		if((pcarid = GetPlayerVehicleID(userid)) == 0)
		    return SendClientMessage(playerid, COLOR_GRAD1, "�����蹹����������躹ö");

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
						format(service_name, sizeof(service_name), "�������ҹ��˹�");
					}
					/*case 2: {
						comp = floatround(float(GetRepairPrice(pcarid)) / 10.0, floatround_round);
						format(service_name, sizeof(service_name), "��������Ƕѧ");
					}*/
				}
			}
			else return SendClientMessage(playerid, COLOR_GRAD1, "�����蹹����������躹ö");

			if(comp <= 0) 
                return SendClientMessage(playerid, COLOR_LIGHTRED, "�������ö����ԡ�ù��Ѻ�ҹ��˹лѨ�غѹ��");

      		if (!strcmp(confirm, "yes", true) && strlen(confirm))
		    {
		        if(playerCarData[carid][carComp] < comp) 
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "�س�� ��ʴ� �����§����Ѻ�������ԡ��");

				pToAccept[userid] = playerid;
				tToAccept[userid] = OFFER_TYPE_SERVICE;

				serviceComp[playerid] = comp;
				serviceTowtruck[playerid] = carid;
				serviceCustomer[playerid] = pcarid;
				serviced[playerid] = type;

				Dialog_Show(userid, DialogMechAccept, DIALOG_STYLE_MSGBOX, "����׹�ѹ", "%s ���ʹͷ��� %s ���Ѻ %s �ͧ�س\n\n���͡������ͧ��ô�ҹ��ҧ���:", "��ͧ���", "����ͧ���", ReturnRealName(playerid), service_name, ReturnVehicleModelName(GetVehicleModel(serviceCustomer[playerid])));
                //SendClientMessageEx(userid, COLOR_GRAD1, "%s ���ʹͷ��� %s ���Ѻ %s ����� 'Y' ��������Ѻ ���� 'N' ���ͻ���ʸ", ReturnRealName(playerid), service_name, ReturnVehicleModelName(playerCarData[playerData[playerid][pPCarkey]][carModel]));
				/*SendClientMessageEx(userid, COLOR_GRAD1, "%s ���ʹͷ��� %s ���Ѻ %s ����� 'Y' ��������Ѻ ���� 'N' ���ͻ���ʸ", ReturnRealName(playerid), service_name, ReturnVehicleModelName(playerCarData[playerData[playerid][pPCarkey]][carModel]));
                SendClientMessageEx(playerid, COLOR_GRAD1, "�س���ʹͷ��� %s ���Ѻ %s �ͧ %s", service_name, ReturnVehicleModelName(playerCarData[playerData[playerid][pPCarkey]][carModel]), ReturnRealName(userid));*/
		    }
			else {

				SendClientMessageEx(playerid, COLOR_YELLOW, "��ԡ�ù���ͧ�� ��ʴ� ������ %d ���", comp);
				SendClientMessageEx(playerid, COLOR_GRAD1, "�����: /service [�ʹռ�����/���ͺҧ��ǹ] %d yes", type);
			}
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "��ԡ�÷������ 1 ��ҹ��");
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: ����觹������ö����੾���ҹ��˹���ǹ��� ��س������ҹ��˹��Ҹ�ó� (Static)");


	return 1;
}

CMD:checkcomp(playerid, params[])
{
	if(playerData[playerid][pJob] != JOB_MECHANIC && playerData[playerid][pSideJob] != JOB_MECHANIC)
	    return SendClientMessage(playerid, COLOR_GRAD2, "�س������ҧ����ö");

	new slot = -1, vehicleid = GetPlayerVehicleID(playerid);

	if (GetVehicleModel(vehicleid) != 525)
		return SendClientMessage(playerid, COLOR_LIGHTRED, "�س����������躹 Tow Truck");

    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return SendClientMessage(playerid, COLOR_LIGHTRED, "�س��������������觤��Ѻ�ͧ�ҹ��˹�");

    if((slot = PlayerCar_GetID(vehicleid)) != -1) {
		SendClientMessageEx(playerid, COLOR_WHITE, "��ʴ�: %d ���", playerCarData[slot][carComp]);
	}
	else {
        SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: ����觹������ö����੾���ҹ��˹���ǹ��� ��س������ҹ��˹��Ҹ�ó� (Static)");
    }
	return 1;
}

CMD:buycomp(playerid, params[])
{

	if(playerData[playerid][pJob] != JOB_MECHANIC && playerData[playerid][pSideJob] != JOB_MECHANIC)
	    return SendClientMessage(playerid, COLOR_GRAD2, "�س������ҧ����ö");

	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 93.4601, -199.2802, 1.5440))
	{
		SetPlayerCheckpoint(playerid, 93.4601, -199.2802, 1.5440, 4.0);
		gPlayerCheckpoint{playerid} = true;
		SendClientMessage(playerid, COLOR_LIGHTRED, "�س�����������⡴ѧ��ª����ǹ ����������ͧ��������Ἱ�������");
		return 1;
	}
	else
	{
		new vehicleid = GetPlayerVehicleID(playerid), amount, tmp2[16];

		if (GetVehicleModel(vehicleid) != 525)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "�س����������躹 Tow Truck");

	    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	        return SendClientMessage(playerid, COLOR_LIGHTRED, "�س��������������觤��Ѻ�ͧ�ҹ��˹�");

		if (sscanf(params, "dS()[16]", amount, tmp2)) {
            SendClientMessage(playerid, COLOR_GRAD1, "�����: /buycomp");
		    SendClientMessage(playerid, COLOR_LIGHTRED, "�س�١�ӡѴ����� 1-2,000");
		    SendClientMessage(playerid, COLOR_WHITE, "!! 㹪����ǹ�����ѧ������ʴ����� 25 ��� !!");
		    return 1;
		}

		new string[16], price = amount*250, slot = -1;
		if (!sscanf(tmp2, "s[16]", string)) {

	        if(strcmp(string,"yes",true) == 0)
			{
				if(amount <= 0) {
				    SendClientMessage(playerid, COLOR_LIGHTRED, "�ӹǹ���١��ͧ");
				    return 1;
				}

				if(GetPlayerMoney(playerid) <  price)
				    return SendClientMessage(playerid, COLOR_LIGHTRED, "�س���Թ���ͷ��Ы���");

                if((slot = PlayerCar_GetID(vehicleid)) != -1) {
                    if(playerCarData[slot][carComp]+(amount*25) < 50000)
                    {
                        GivePlayerMoneyEx(playerid, -price);
	                    playerCarData[slot][carComp]+=amount*25;
						SendClientMessageEx(playerid, COLOR_WHITE, "�س�����Թ��� %d (��ʴ� %d ���) �ѧ���Ѻö��÷ء�ͧ�س", amount, amount*25);
					}
					else SendClientMessage(playerid, COLOR_WHITE, "�������ö�������ҡ���ҹ������ 1-2,000");
				}
				else SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: ����觹������ö����੾���ҹ��˹���ǹ��� ��س������ҹ��˹��Ҹ�ó� (Static)");

				return 1;
			}
		}
		SendClientMessageEx(playerid, COLOR_WHITE, "�Ҥ�: {E85050}%s", FormatNumber(price));
		SendClientMessageEx(playerid, COLOR_GRAD1, "�����: /buycomp %d yes", amount);
	}
	return 1;
}

CMD:repairengine(playerid, params[])
{
	// new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	
	/*if (factionType != FACTION_TYPE_MECHA)
	    return SendClientMessage(playerid, COLOR_GRAD2,"   ����Ѻ Faction ��ҧ����ö��ҹ�� !");*/

	//if (!IsPlayerInRangeOfPoint(playerid, 3.0, -1968.3574, 102.9266, 28.0264))
		//return SendClientMessage(playerid, COLOR_GRAD2, "�س��ͧ�������������ͧ San Fierro");

	if(!IsPlayerNearMechanicPoint(playerid)) 
		return SendClientMessage(playerid, COLOR_GRAD2, "�س�����������������ö!");

	if(playerData[playerid][pJob] != JOB_MECHANIC && playerData[playerid][pSideJob] != JOB_MECHANIC)
	    return SendClientMessage(playerid, COLOR_GRAD2, "�س������ҧ����ö");

	if(playerData[playerid][pOre] < 100)
		return SendClientMessage(playerid, COLOR_GRAD2, "�س��ͧ�������ҡ���� 100");

	if(playerData[playerid][pCash] < 2000)
		return SendClientMessage(playerid, COLOR_GRAD2, "�س��ͧ���Թ�ҡ���� $2,000");

	new
		carid;

    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_GRAD1, "�س��������躹ö� �");

    if((carid = PlayerCar_GetID(GetPlayerVehicleID(playerid))) != -1) 
	{
		playerData[playerid][pOre] -= 100;
		GivePlayerMoneyEx(playerid, -2000);

		playerCarData[carid][carEngineL] = 100;
		SendClientMessage(playerid, COLOR_YELLOW, "�س��ӡ�ë��� Engine �ͧ����ͧ¹��, �����ö�ͧ�س�ջ���Է���Ҿ����ҡ���");
	}
	return 1;
}

CMD:repairbattery(playerid, params[])
{
	// new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	
	/*if (factionType != FACTION_TYPE_MECHA)
	    return SendClientMessage(playerid, COLOR_GRAD2,"   ����Ѻ Faction ��ҧ����ö��ҹ�� !");*/

	if(!IsPlayerNearMechanicPoint(playerid)) 
		return SendClientMessage(playerid, COLOR_GRAD2, "�س�����������������ö!");

	if(playerData[playerid][pJob] != JOB_MECHANIC && playerData[playerid][pSideJob] != JOB_MECHANIC)
	    return SendClientMessage(playerid, COLOR_GRAD2, "�س������ҧ����ö");

	if(playerData[playerid][pOre] < 100)
		return SendClientMessage(playerid, COLOR_GRAD2, "�س��ͧ�������ҡ���� 100");

	if(playerData[playerid][pCash] < 2000)
		return SendClientMessage(playerid, COLOR_GRAD2, "�س��ͧ���Թ�ҡ���� $2,000");

	new
		carid;

    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_GRAD1, "�س��������躹ö� �");

    if((carid = PlayerCar_GetID(GetPlayerVehicleID(playerid))) != -1) 
	{
		playerData[playerid][pOre] -= 100;
		GivePlayerMoneyEx(playerid, -2000);

		playerCarData[carid][carBatteryL] = 100;
		SendClientMessage(playerid, COLOR_YELLOW, "�س��ӡ�ë��� Battery �ͧö¹��, �����ö�ͧ�س�ջ���Է���Ҿ����ҡ���");
	}
	return 1;
}

CMD:buykit(playerid, params[])
{
	//new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	
	if (!IsPlayerInRangeOfPoint(playerid, 3.0, -1978.8680,106.1160,27.6875))
		return SendClientMessage(playerid, COLOR_GRAD2, "�س��ͧ�������������ͧ San Fierro");

	if(playerData[playerid][pJob] != JOB_MECHANIC && playerData[playerid][pSideJob] != JOB_MECHANIC)
	    return SendClientMessage(playerid, COLOR_GRAD2, "�س������ҧ����ö");

	if (playerData[playerid][pCash] < 10000)
		return SendClientMessage(playerid, COLOR_GRAD2, "�س��ͧ���Թ�ҡ���� $10,000");

    new mecs = MecOnline();

	if(mecs != 0) 
		return SendClientMessage(playerid, COLOR_GRAD2, "�س������ö���͡��ͧ����ö��������������ժ�ҧ����ö�͹�Ź�");

	playerData[playerid][pMechanicBox] += 1;
	GivePlayerMoneyEx(playerid, -10000);
	SendClientMessage(playerid, COLOR_YELLOW, "�س��ӡ�ë��͡��ͧ����ö¹��ء�Թ, �س����ö��ҹ���¡�þ���� /repair ���ҹ��˹Тͧ�س");

	return 1;
}

CMD:repair(playerid, params[])
{
	if (playerData[playerid][pMechanicBox] < 0)
		return SendClientMessage(playerid, COLOR_GRAD2, "�س����ա��ͧ����ö");

    if (!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_GRAD1, "�س��������躹ö� �");

	if (GetEngineStatus(GetPlayerVehicleID(playerid)))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ�Ѻ����ͧ¹���͹�֧������ö����ö�� !");

	RepairVehicle(GetPlayerVehicleID(playerid));
	playerData[playerid][pMechanicBox] -= 1;

	SendClientMessage(playerid, COLOR_YELLOW, "�س��ӡ�ë����ҹ��˹Тͧ�س���¡��ͧ����, �ѹ�дբ���ҡ���ҹ���ҡ�س�������������ö");

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
						SendClientMessage(offerid, COLOR_YELLOW, "SERVER: ����ʹ�����ó�����");
						SendClientMessage(playerid, COLOR_YELLOW, "SERVER: ����ʹ�����ó�����");
					}
					case 2: {
						new color1 = GetPVarInt(offerid, "color1");
						new color2 = GetPVarInt(offerid, "color2");
						SetVehicleColor(target_car, color1, color2);

						playerCarData[towtruck][carComp] -= comp;
						PlayerPlaySoundEx(offerid, 1133);
						SendClientMessage(offerid, COLOR_YELLOW, "SERVER: ����ʹ�����ó�����");
						SendClientMessage(playerid, COLOR_YELLOW, "SERVER: ����ʹ�����ó�����");

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
				SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" �Դ��ͼԴ��Ҵ�Ѻ�ҹ��˹Тͧ��ҧ");
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
		SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" ����ʹ����١��ͧ/��ҧ������������س");
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
                        SendClientMessage(playerid, COLOR_YELLOW, "SERVER: �ҹ��˹Тͧ�س�١�������º��������");
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
