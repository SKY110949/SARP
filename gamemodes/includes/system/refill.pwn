CMD:fuel(playerid, params[]) {

	if (IsPlayerInAnyVehicle(playerid))
	{
	    new str[64], vehicleid = GetPlayerVehicleID(playerid);

		if (!IsEngineVehicle(vehicleid))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "ยานพาหนะคันนี้ไม่มีน้ำมัน");

		format(str, sizeof(str), "~w~Fuel: ~p~%.2f gallon", vehicleData[vehicleid][vFuel]);
		GameTextForPlayer(playerid, str, 5000, 1);
	}
	else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ในยานพาหนะ");
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
						SendClientMessageEx(playerid, COLOR_GREEN, "SERVER: การดำเนินการนี้จะต้องใช้เวลา %d วินาที ปริมาณ:%.6f", time, fueladd);

					} else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมีเงินไม่พอ!");
				} else SendClientMessage(playerid, COLOR_LIGHTRED, "ยานพาหนะปัจจุบันได้เริ่มดำเนินการแล้ว");
			} else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ที่ปั้มน้ำมัน!");
		} else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ที่ปั้มน้ำมัน!");
	}
	return 1;
} // GameTextForPlayer(playerid,"~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~Re-Fueling Vehicle, please wait",2000,3);

CMD:gascan(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) 
		return SendClientMessage(playerid, COLOR_GREY, "คุณต้องอยู่บนพื้น");
	
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
				} else SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่สามารถเติมน้ำมันได้มากกว่านี้แล้ว");
		    } else SendClientMessage(playerid, COLOR_LIGHTRED, "Error: "EMBED_WHITE"ยานพาหนะล็อก");
		} else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่มี Gas Can");
	} else SendClientMessage(playerid, COLOR_LIGHTRED, " ..ไม่มียานพาหนะอยู่ใกล้คุณ");
	return 1;
}