CMD:fuel(playerid, params[]) {

	if (IsPlayerInAnyVehicle(playerid))
	{
	    new str[64], vehicleid = GetPlayerVehicleID(playerid);

		if (!IsEngineVehicle(vehicleid))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "�ҹ��˹Фѹ�������չ���ѹ");

		format(str, sizeof(str), "~w~Fuel: ~p~%.2f gallon", vehicleData[vehicleid][vFuel]);
		GameTextForPlayer(playerid, str, 5000, 1);
	}
	else SendClientMessage(playerid, COLOR_LIGHTRED, "�س�����������ҹ��˹�");
	return 1;
}

Dialog:FuelRefill(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if (IsPlayerInAnyVehicle(playerid)) {
			new vehicleid = GetPlayerVehicleID(playerid);
			if (IsPlayerAtGasStation(playerid)) {
				if(!VehicleLabel[vehicleid][vLabelTime]) {
				    new Float:maxfuel = GetVehicleDataFuel(GetVehicleModel(vehicleid));
				    new Float:fueladd = maxfuel - vehicleData[vehicleid][vFuel];
					new price = floatround(fueladd*float(FUEL_PRICE), floatround_ceil);
				    if(GetPlayerMoneyEx(playerid) >= price) {
					    new time = 10, timecal = floatround(fueladd, floatround_ceil);

						if(timecal >= 10) time = (timecal*2) - (5 * (timecal/5));
						SetVehicleLabel(vehicleid, VLT_TYPE_REFILL, time);
						vehicleData[vehicleid][vOwnerID] = playerid;
						SendClientMessageEx(playerid, COLOR_GREEN, "SERVER: ��ô��Թ��ù��е�ͧ������ %d �Թҷ� ����ҳ:%.6f", time, fueladd);

					} else SendClientMessage(playerid, COLOR_LIGHTRED, "�س���Թ����!");
				} else SendClientMessage(playerid, COLOR_LIGHTRED, "�ҹ��˹лѨ�غѹ����������Թ�������");
			} else SendClientMessage(playerid, COLOR_LIGHTRED, "�س������������������ѹ!");
		} else SendClientMessage(playerid, COLOR_LIGHTRED, "�س������������������ѹ!");
	}
	return 1;
} // GameTextForPlayer(playerid,"~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~Re-Fueling Vehicle, please wait",2000,3);

CMD:gascan(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) 
		return SendClientMessage(playerid, COLOR_GREY, "�س��ͧ���躹���");
	
	new vehicleid = -1;
	if((vehicleid = Vehicle_Nearest(playerid)) != -1) {
		if(playerData[playerid][pItemGasCan]) {
	        if (!GetLockStatus(vehicleid)) {
				new Float:maxfuel = GetVehicleDataFuel(GetVehicleModel(vehicleid));
				if(vehicleData[vehicleid][vFuel] < maxfuel) {

				    vehicleData[vehicleid][vFuel] += 3.0;
				    if(vehicleData[vehicleid][vFuel] > maxfuel) {
				        vehicleData[vehicleid][vFuel] = maxfuel;
				    }
				} else SendClientMessage(playerid, COLOR_LIGHTRED, "�������ö�������ѹ���ҡ���ҹ������");
		    } else SendClientMessage(playerid, COLOR_LIGHTRED, "Error: "EMBED_WHITE"�ҹ��˹���͡");
		} else SendClientMessage(playerid, COLOR_LIGHTRED, "�س����� Gas Can");
	} else SendClientMessage(playerid, COLOR_LIGHTRED, " ..������ҹ��˹��������س");
	return 1;
}