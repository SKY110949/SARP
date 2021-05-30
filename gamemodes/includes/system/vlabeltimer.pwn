#include <YSI\y_timers>  // pawn-lang/YSI-Includes
#include <YSI\y_hooks>

enum vehicleL {
	vLabelType,
	vLabelTime,
	vLabelCount,
	STREAMER_TAG_3D_TEXT_LABEL:vLabel,
}

new VehicleLabel[MAX_VEHICLES][vehicleL];
new Timer:vehicleHorn[MAX_VEHICLES];

hook OnPlayerDisconnect(playerid, reason) {
	for(new i=0;i!=MAX_VEHICLES;i++) {
		if(vehicleData[i][vOwnerID] == playerid)
		{
			if(VehicleLabel[i][vLabelCount] >= VehicleLabel[i][vLabelTime])
			{
				VehicleLabel[i][vLabelCount] = 0;
				VehicleLabel[i][vLabelTime] = 0;
				VehicleLabel[i][vLabelType] = 0;

				DestroyDyn3DTextLabelFix(VehicleLabel[i][vLabel]);
			}
			vehicleData[i][vOwnerID] = INVALID_PLAYER_ID;
			vehicleData[i][vUpgradeID] = 0;
			break;
		}
	}
	return 1;
}

forward SetVehicleLabel(vehicleid, type, time);
public SetVehicleLabel(vehicleid, type, time)
{
    if(!IsValidDynamic3DTextLabel(VehicleLabel[vehicleid][vLabel])) {
		switch(type)
		{
		    case VLT_TYPE_TOWING: VehicleLabel[vehicleid][vLabel] = CreateDynamic3DTextLabel("(( ---------- ))\nกำลังลากยานพาหนะ", COLOR_GREEN, 0, 0, 0, 20, INVALID_PLAYER_ID, vehicleid,  0, 0, 0, -1, 100);
			case VLT_TYPE_VEHICLELOCK: VehicleLabel[vehicleid][vLabel] = CreateDynamic3DTextLabel("คุณไม่ได้รับอนุญาตให้เข้าไปในรถคันนี้ (ยานพาหนะ-ล็อก)", COLOR_WHITE, 0, 0, 0, 20, INVALID_PLAYER_ID, vehicleid,  0, 0, 0, -1, 50);
		    case VLT_TYPE_PERMITFACTION: VehicleLabel[vehicleid][vLabel] = CreateDynamic3DTextLabel("คุณไม่ได้รับอนุญาตให้เข้าไปในรถคันนี้ (ยานพาหนะ-แฟคชั่น)", COLOR_WHITE, 0, 0, 0, 20, INVALID_PLAYER_ID, vehicleid,  0, 0, 0, -1, 50);
		    case VLT_TYPE_LOCK: VehicleLabel[vehicleid][vLabel] = CreateDynamic3DTextLabel("ยานพาหนะคันนี้ล็อก!", COLOR_TOMATO, 0, 0, 0, 20, INVALID_PLAYER_ID, vehicleid,  0, 0, 0, -1, 50);
		    case VLT_TYPE_UNREGISTER: VehicleLabel[vehicleid][vLabel] = CreateDynamic3DTextLabel("(( ---------- ))\nกำลังถอดทะเบียน", COLOR_GREEN, 0, 0, 0, 20, INVALID_PLAYER_ID, vehicleid,  0, 0, 0, -1, 50);
			case VLT_TYPE_REGISTER: VehicleLabel[vehicleid][vLabel] = CreateDynamic3DTextLabel("(( ---------- ))\nกำลังลงทะเบียนยานพาหนะ", COLOR_GREEN, 0, 0, 0, 20, INVALID_PLAYER_ID, vehicleid,  0, 0, 0, -1, 50);
			case VLT_TYPE_OPERAFAILED: VehicleLabel[vehicleid][vLabel] = CreateDynamic3DTextLabel("(( การดำเนินการล้มเหลว ))", COLOR_TOMATO, 0, 0, 0, 20, INVALID_PLAYER_ID, vehicleid,  0, 0, 0, -1, 50);
			case VLT_TYPE_UPGRADELOCK: VehicleLabel[vehicleid][vLabel] = CreateDynamic3DTextLabel("(( ---------- ))\nการอัพเกรดล็อก", COLOR_GREEN, 0, 0, 0, 20, INVALID_PLAYER_ID, vehicleid,  0, 0, 0, -1, 50);
			case VLT_TYPE_UPGRADEIMMOB: VehicleLabel[vehicleid][vLabel] = CreateDynamic3DTextLabel("(( ---------- ))\nการอัพเกรดอิมโมบิไลเซอร์", COLOR_GREEN, 0, 0, 0, 20, INVALID_PLAYER_ID, vehicleid,  0, 0, 0, -1, 50);
			case VLT_TYPE_UPGRADEALARM: VehicleLabel[vehicleid][vLabel] = CreateDynamic3DTextLabel("(( ---------- ))\nการอัพเกรดสัญญาณเตือนภัย", COLOR_GREEN, 0, 0, 0, 20, INVALID_PLAYER_ID, vehicleid,  0, 0, 0, -1, 50);
			case VLT_TYPE_UPGRADEINSURANCE: VehicleLabel[vehicleid][vLabel] = CreateDynamic3DTextLabel("(( ---------- ))\nการอัพเกรดประกัน", COLOR_GREEN, 0, 0, 0, 20, INVALID_PLAYER_ID, vehicleid,  0, 0, 0, -1, 50);
			case VLT_TYPE_ARMOUR: VehicleLabel[vehicleid][vLabel] = CreateDynamic3DTextLabel("(( ---------- ))\nกำลังอัพเกรดเกราะ", COLOR_GREEN, 0, 0, 0, 20, INVALID_PLAYER_ID, vehicleid,  0, 0, 0, -1, 50);
			case VLT_TYPE_OPERAOUTOFRANG: VehicleLabel[vehicleid][vLabel] = CreateDynamic3DTextLabel("(( การดำเนินการอยู่นอกระยะ ))", COLOR_TOMATO, 0, 0, 0, 20, INVALID_PLAYER_ID, vehicleid,  0, 0, 0, -1, 50);
            case VLT_TYPE_REFILL: VehicleLabel[vehicleid][vLabel] = CreateDynamic3DTextLabel("(( ---------- ))\nการเติมเชื้อเพลิง", COLOR_GREEN, 0, 0, 0, 20, INVALID_PLAYER_ID, vehicleid,  0, 0, 0, -1, 100);
			case VLT_TYPE_UPGRADEBATTERY: VehicleLabel[vehicleid][vLabel] = CreateDynamic3DTextLabel("(( ---------- ))\nการเปลี่ยนแบตเตอรี่", COLOR_GREEN, 0, 0, 0, 20, INVALID_PLAYER_ID, vehicleid,  0, 0, 0, -1, 100);
            case VLT_TYPE_UPGRADEENGINE: VehicleLabel[vehicleid][vLabel] = CreateDynamic3DTextLabel("(( ---------- ))\nการเปลี่ยนเครื่องยนต์", COLOR_GREEN, 0, 0, 0, 20, INVALID_PLAYER_ID, vehicleid,  0, 0, 0, -1, 100);
			case VLT_TYPE_BREAKIN: {
		       	vehicleData[vehicleid][vbreaktime]=20;
				VehicleLabel[vehicleid][vLabel] = CreateDynamic3DTextLabel(vehicleData[vehicleid][vbreakin] ? (sprintf("การป้องกัน: %d", vehicleData[vehicleid][vbreakin])) : ("ปลดล็อกแล้ว"), (vehicleData[vehicleid][vbreakin]) ? COLOR_GREY : COLOR_GREEN, -0.9, 0.8, 0, 20, INVALID_PLAYER_ID, vehicleid,  0, 0, 0, -1, 50);
			}
		}
	}
	
	VehicleLabel[vehicleid][vLabelType] = type;
	VehicleLabel[vehicleid][vLabelTime] = time;
	VehicleLabel[vehicleid][vLabelCount] = 0;

}

task ServerVehicleTimer[1000]() {
	for(new i=0;i!=MAX_VEHICLES;i++) if(IsValidVehicle(i))
	{
		GetVehicleHealth(i, vehicleData[i][vHealth]);
		if (vehicleData[i][vHealth] < 250.0) {
			SetVehicleHealthEx(i, 250.0);
		}

		if(IsEngineVehicle(i) && GetEngineStatus(i) && vehicleData[i][vFuel]) {
			vehicleData[i][vFuel] -= GetVehicleConsumptionPerSecond(i);
			// printf("GetVehicleConsumptionPerSecond(i) %f", GetVehicleConsumptionPerSecond(i));

			if (vehicleData[i][vFuel] <= 0.0) {
				vehicleData[i][vFuel] = 0.0;
				SetEngineStatus(i, false);

				new driverid = GetVehicleDriver(i);
				if (driverid != INVALID_PLAYER_ID) {
					Mobile_GameTextForPlayer(driverid, "~r~Fuel is exhausted", 5000, 3);
					TogglePlayerControllable(driverid, false);
					SetEngineStatus(driverid, false);
				}
			}	
		}

		if(vehicleData[i][vbreaktime])
		{
		    vehicleData[i][vbreaktime]--;

		    if(vehicleData[i][vbreakdelay]) 
				vehicleData[i][vbreakdelay]--;

			if(vehicleData[i][vbreaktime] <= 0)
			{
				stop vehicleHorn[i];
			    vehicleData[i][vbreakin] = 0;
			    vehicleData[i][vbreaktime] = 0;

				new
					engine,
					lights,
					alarm,
					doors,
					bonnet,
					boot,
					objective;

				GetVehicleParamsEx(i, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(i, engine, lights, 0, doors, bonnet, boot, 0);
			}
		}

		if(vehicleData[i][startup_delay] > 0 && vehicleData[i][startup_delay_sender] != INVALID_PLAYER_ID)
		{
			vehicleData[i][startup_delay] -= 5;
			if(vehicleData[i][startup_delay] <= 0 && GetVehicleDriver(i) == vehicleData[i][startup_delay_sender])
			{
				if(random(9) < vehicleData[i][startup_delay_random]) {
					Mobile_GameTextForPlayer(vehicleData[i][startup_delay_sender], "~r~Engine Refuse", 2000, 4);
				}
				else
				{
					TogglePlayerControllable(vehicleData[i][startup_delay_sender], true);
					SetEngineStatus(i, true);
					Mobile_GameTextForPlayer(vehicleData[i][startup_delay_sender], "~g~Engine On", 2000, 4);
					SendNearbyMessage(vehicleData[i][startup_delay_sender], 30.0, COLOR_PURPLE, "** %s เริ่มเครื่องยนต์ของ %s", ReturnRealName(vehicleData[i][startup_delay_sender]), g_arrVehicleNames[GetVehicleModel(i) - 400]);
				}
				vehicleData[i][startup_delay_sender] = INVALID_PLAYER_ID;
			}
			else if(vehicleData[i][startup_delay] <= 0) { vehicleData[i][startup_delay_sender] = INVALID_PLAYER_ID; }

		}

		if(VehicleLabel[i][vLabelTime])
		{
		    VehicleLabel[i][vLabelCount]++;

			switch(VehicleLabel[i][vLabelType])
			{
				case VLT_TYPE_PERMITFACTION, VLT_TYPE_VEHICLELOCK, VLT_TYPE_LOCK, VLT_TYPE_OPERAFAILED, VLT_TYPE_BREAKIN, VLT_TYPE_OPERAOUTOFRANG:
				{
				    if(VehicleLabel[i][vLabelCount] >= VehicleLabel[i][vLabelTime])
				    {
				        VehicleLabel[i][vLabelCount] = 0;
				        VehicleLabel[i][vLabelTime] = 0;
				        VehicleLabel[i][vLabelType] = 0;

		        		DestroyDyn3DTextLabelFix(VehicleLabel[i][vLabel]);
				    }
				}
				case VLT_TYPE_TOWING: {

				    new labelstring[11], first = VehicleLabel[i][vLabelCount], second = VehicleLabel[i][vLabelTime], Float:percent = (float(second-first)/float(second))*float(10);
					for(new x = 10; x > 0; --x)
					{
					    if(x-floatround(percent) > 0) format(labelstring, sizeof(labelstring), "%s|", labelstring);
					    else format(labelstring, sizeof(labelstring), "%s-", labelstring);
     				}

		            UpdateDynamic3DTextLabelText(VehicleLabel[i][vLabel], COLOR_GREEN, sprintf("(( %s ))\nกำลังลากยานพาหนะ", labelstring));
	
				    if(VehicleLabel[i][vLabelCount] >= VehicleLabel[i][vLabelTime]) {

						new
							engine,
							lights,
							alarm,
							doors,
							bonnet,
							boot,
							objective;

						GetVehicleParamsEx(i, engine, lights, alarm, doors, bonnet, boot, objective);
						SetVehicleParamsEx(i, engine, lights, alarm, 1, bonnet, boot, objective);

			            new carid = INVALID_PLAYER_ID;
						if(IsPlayerConnected(vehicleData[i][vOwnerID])) {
						    carid = playerData[vehicleData[i][vOwnerID]][pPCarkey];
							playerData[vehicleData[i][vOwnerID]][pPCarkey] = -1;
							SendClientMessage(vehicleData[i][vOwnerID], COLOR_LIGHTRED, "ยานพาหนะถูกลากสำเร็จแล้ว พิมพ์ /v get เพื่อเรียกมันออกมาอีกครั้ง");
						}
						else {
						    carid = PlayerCar_GetID(i);
						}

						SaveVehicleDamage(carid);
						PlayerCar_SaveID(carid, MYSQL_UPDATE_TYPE_SINGLE);
						PlayerCar_DespawnEx(carid);

				        VehicleLabel[i][vLabelCount] = 0;
				        VehicleLabel[i][vLabelTime] = 0;
				        VehicleLabel[i][vLabelType] = 0;

				        DestroyDyn3DTextLabelFix(VehicleLabel[i][vLabel]);
					}
				}
				case VLT_TYPE_UPGRADELOCK, VLT_TYPE_UPGRADEALARM, VLT_TYPE_UPGRADEIMMOB, VLT_TYPE_UPGRADEINSURANCE: {
					
					new targetid = vehicleData[i][vOwnerID];
					if (IsPlayerAtDealership(targetid) != -1 && IsPlayerConnected(targetid))
					{
						new labelstring[11], first = VehicleLabel[i][vLabelCount], second = VehicleLabel[i][vLabelTime], Float:percent = (float(second-first)/float(second))*float(10);

						for(new x = 10; x > 0; --x)
						{
						    if(x-floatround(percent) > 0) format(labelstring, sizeof(labelstring), "%s|", labelstring);
						    else format(labelstring, sizeof(labelstring), "%s-", labelstring);
	     				}

	     				switch(VehicleLabel[i][vLabelType])
	     				{
							case VLT_TYPE_UPGRADELOCK: UpdateDynamic3DTextLabelText(VehicleLabel[i][vLabel], COLOR_GREEN, sprintf("(( %s ))\nการอัปเกรดล็อก", labelstring));
							case VLT_TYPE_UPGRADEIMMOB: UpdateDynamic3DTextLabelText(VehicleLabel[i][vLabel], COLOR_GREEN, sprintf("(( %s ))\nการอัปเกรดอิมโมบิไลเซอร์", labelstring));
							case VLT_TYPE_UPGRADEALARM: UpdateDynamic3DTextLabelText(VehicleLabel[i][vLabel], COLOR_GREEN, sprintf("(( %s ))\nการอัปเกรดสัญญาณเตือนภัย", labelstring));
							case VLT_TYPE_UPGRADEINSURANCE: UpdateDynamic3DTextLabelText(VehicleLabel[i][vLabel], COLOR_GREEN, sprintf("(( %s ))\nการอัปเกรดประกัน", labelstring));
						}

					    if(VehicleLabel[i][vLabelCount] >= VehicleLabel[i][vLabelTime]) {

							new uplevel = vehicleData[i][vUpgradeID];
                            new vid = playerData[targetid][pPCarkey];
							new model = GetVehicleModel(i);

                            if(vid != -1) {
			     				switch(VehicleLabel[i][vLabelType])
			     				{
									case VLT_TYPE_UPGRADELOCK:
									{
										new uprice = floatround(GetVehiclePrice(model) / VehicleUpgradeLock[uplevel-1][u_rate]) + VehicleUpgradeLock[uplevel-1][u_price];
                                        SendClientMessageEx(targetid, COLOR_YELLOW3, "การดำเนินการนี้ต้องการ %s", FormatNumber(uprice));

										if(GetPlayerMoney(targetid) >= uprice) {
											GivePlayerMoneyEx(targetid, -uprice);
	
					                     	playerCarData[vid][carLock] = uplevel;

					                     	switch(uplevel)
					                     	{
					                     	    case 1: Mobile_GameTextForPlayer(targetid, "~g~LOCK Level 1~n~+~w~500 second wait time protection against prying break-in method.~n~~g~+~w~Stronger armor- better defense against physical attack breaching. -Fist & melee.", 10000, 3);
					                     	    case 2: Mobile_GameTextForPlayer(targetid, "~g~LOCK Level 2~n~+~w~750 second wait time protection against prying break-in method.~n~~g~+~w~Special armor- better defense x2 against melee attack breaching.", 10000, 3);
					                     	    case 3: Mobile_GameTextForPlayer(targetid, "~g~LOCK Level 3~n~+~w~750 second wait time protection against prying break-in method.~n~~g~+~w~Special armor- better defense x3 against melee attack breaching.~n~~g~+~w~Special armor protection blocks physical attack breaching. -Fist", 10000, 3);
					                     	    case 4: Mobile_GameTextForPlayer(targetid, "~g~LOCK Level 4~n~+~w~1,250 second wait time protection against prying break-in method.~n~~g~+~w~Special armor protection blocks all types of physical attack breaching.", 10000, 3);
					                     	}
									   	}
									}
									case VLT_TYPE_UPGRADEIMMOB:
									{
										new uprice = floatround(GetVehiclePrice(model) / VehicleUpgradeImmob[uplevel-1][u_rate]) + VehicleUpgradeImmob[uplevel-1][u_price];
                                        SendClientMessageEx(targetid, COLOR_YELLOW3, "การดำเนินการนี้ต้องการ %s", FormatNumber(uprice));

										if(GetPlayerMoney(targetid) >= uprice) {
											GivePlayerMoneyEx(targetid, -uprice);
					                     	playerCarData[vid][carImmob] = uplevel;

					                     	switch(uplevel)
					                     	{
					                     	    case 1: Mobile_GameTextForPlayer(targetid, "~y~IMMOBILSER Level 1~n~+~w~The Engine Immobiliser will help prevent your ~n~vehicle from running without an authorized key.", 10000, 3);
					                     	    case 2: Mobile_GameTextForPlayer(targetid, "~y~IMMOBILSER Level 2~n~+~w~The Engine Immobiliser will help prevent your ~n~vehicle from running without an authorized key.", 10000, 3);
					                     	    case 3: Mobile_GameTextForPlayer(targetid, "~y~IMMOBILSER Level 3~n~+~w~The Engine Immobiliser will help prevent your ~n~vehicle from running without an authorized key.", 10000, 3);
					                     	    case 4: Mobile_GameTextForPlayer(targetid, "~y~IMMOBILSER Level 4~n~+~w~The Engine Immobiliser will help prevent your ~n~vehicle from running without an authorized key.", 10000, 3);
					                     	}
									   	}
									}
									case VLT_TYPE_UPGRADEALARM:
									{
										new uprice = floatround(GetVehiclePrice(model) / VehicleUpgradeAlarm[uplevel-1][u_rate]) + VehicleUpgradeAlarm[uplevel-1][u_price];

                                        SendClientMessageEx(targetid, COLOR_YELLOW3, "การดำเนินการนี้ต้องการ %s", FormatNumber(uprice));

										if(GetPlayerMoney(targetid) >= uprice) {
											GivePlayerMoneyEx(targetid, -uprice);
					                     	playerCarData[vid][carAlarm] = uplevel;

					                     	switch(uplevel)
					                     	{
					                     	    case 1: Mobile_GameTextForPlayer(targetid, "~r~ALARM Level 1~n~+~w~Loud vehicle alarm.", 10000, 3);
					                     	    case 2: Mobile_GameTextForPlayer(targetid, "~r~ALARM Level 2~n~+~w~Loud vehicle alarm.~n~~r~+~w~Vehicle alerts the owner of a possible breach.", 10000, 3);
					                     	    case 3: Mobile_GameTextForPlayer(targetid, "~r~ALARM Level 3~n~+~w~Loud vehicle alarm.~n~~r~+~w~Vehicle alerts the owner of a possible breach.~n~~r~+~w~Vehicle alerts the local police department of a possible breach.", 10000, 3);
					                     	    case 4: Mobile_GameTextForPlayer(targetid, "~r~ALARM Level 4~n~+~w~Loud vehicle alarm.~n~~r~+~w~Vehicle alerts the owner of a possible breach.~n~~r~+~w~Vehicle alerts the local police department of a possible breach.~n~~r~+~w~Vehicle blip will appear on the law enforcement's radar.", 10000, 3);
					                     	}
									   	}
									}
									case VLT_TYPE_UPGRADEINSURANCE:
									{
										new uprice = (IsABike(i)) ? (1000) : (2500) * uplevel;

                                        SendClientMessageEx(targetid, COLOR_YELLOW3, "การดำเนินการนี้ต้องการ %s", FormatNumber(uprice));

										if(GetPlayerMoney(targetid) >= uprice) {
											GivePlayerMoneyEx(targetid, -uprice);

					                     	playerCarData[vid][carInsurance] = uplevel;

					                     	switch(uplevel)
					                     	{
					                     	    case 1: Mobile_GameTextForPlayer(targetid, "~b~INSURANCE Level 1~n~+~w~Vehicle will always respawn with its max health.", 10000, 3);
					                     	    case 2: Mobile_GameTextForPlayer(targetid, "~b~INSURANCE Level 2~n~+~w~Vehicle will always respawn with its max health.~n~~b~+~w~Protection against cosmetic vehicle damage. Vehicle will re-spawn good as new.", 10000, 3);
					                     	    case 3: Mobile_GameTextForPlayer(targetid, "~b~INSURANCE Level 3~n~+~w~Vehicle will always respawn with its max health.~n~~b~+~w~Protection against cosmetic vehicle damage. Vehicle will re-spawn good as new.~n~~b~+~w~Vehicle Edittion coverage!", 10000, 3);
					                     	}
									   	}
									}
								}
								PlayerCar_SaveID(vid);
							}
							vehicleData[i][vOwnerID] = INVALID_PLAYER_ID;
							vehicleData[i][vUpgradeID] = 0;

							VehicleLabel[i][vLabelCount] = 0;
							VehicleLabel[i][vLabelTime] = 0;
							VehicleLabel[i][vLabelType] = 0;

							DestroyDyn3DTextLabelFix(VehicleLabel[i][vLabel]);

							/*if(playerData[targetid][pCash] >= 100)

								new vid = playerData[targetid][pPCarkey];
								if(vid != 9999)
								{
									new plate[8];
									format(plate, 8, "%s", RandomVehiclePlate());
									mysql_format(dbCon, str,sizeof(str),"SELECT * FROM cars WHERE carPlate = '%s'", plate);
									mysql_tquery(dbCon, str, "RegisterPlates", "iis", targetid, vid, plate);


		                            vehicleData[i][vOwnerID] = INVALID_PLAYER_ID;

							        VehicleLabel[i][vLabelCount] = 0;
							        VehicleLabel[i][vLabelTime] = 0;
							        VehicleLabel[i][vLabelType] = 0;

							        DestroyDyn3DTextLabelFix(VehicleLabel[i][vLabel]);
						        }
						   	}
						   	else SendClientMessage(targetid, COLOR_YELLOW3, "การดำเนินการนี้ต้องการ $100");*/
						}
					}
					else {

				        VehicleLabel[i][vLabelCount] = 0;
				        VehicleLabel[i][vLabelTime] = 0;
				        VehicleLabel[i][vLabelType] = 0;
				        DestroyDyn3DTextLabelFix(VehicleLabel[i][vLabel]);

					    SetVehicleLabel(i, VLT_TYPE_OPERAFAILED, 5);
					}
				}
				case VLT_TYPE_REFILL: {
					new targetid = vehicleData[i][vOwnerID];
					if (IsPlayerAtGasStation(targetid) && IsPlayerConnected(targetid))
					{
						new labelstring[11], first = VehicleLabel[i][vLabelCount], second = VehicleLabel[i][vLabelTime], Float:percent = (float(second-first)/float(second))*float(10);

						for(new x = 10; x > 0; --x)
						{
							if(x-floatround(percent) > 0) format(labelstring, sizeof(labelstring), "%s|", labelstring);
							else format(labelstring, sizeof(labelstring), "%s-", labelstring);
						}
						UpdateDynamic3DTextLabelText(VehicleLabel[i][vLabel], COLOR_GREEN, sprintf("(( %s ))\nการเติมเชื้อเพลิง", labelstring));

						// GameTextForPlayer(targetid, sprintf("(( %s ))\nFilling Fuel", labelstring), 1000, 3);
						//printf(str);

						if(VehicleLabel[i][vLabelCount] >= VehicleLabel[i][vLabelTime]) {

							new Float:maxfuel = GetVehicleDataFuel(GetVehicleModel(i));
							new Float:fueladd = maxfuel - vehicleData[i][vFuel];
							new uprice = floatround(fueladd*float(FUEL_PRICE), floatround_ceil);
							
							SendClientMessageEx(targetid, COLOR_YELLOW3, "การดำเนินการนี้ต้องการ %s", FormatNumber(uprice));

							if(GetPlayerMoneyEx(targetid) >= uprice) {
								GivePlayerMoneyEx(targetid, -uprice);
								vehicleData[i][vFuel]=GetVehicleDataFuel(GetVehicleModel(i));
							}

							VehicleLabel[i][vLabelCount] = 0;
							VehicleLabel[i][vLabelTime] = 0;
							VehicleLabel[i][vLabelType] = 0;

							DestroyDyn3DTextLabelFix(VehicleLabel[i][vLabel]);

						}
					}
					else {
						VehicleLabel[i][vLabelCount] = 0;
						VehicleLabel[i][vLabelTime] = 0;
						VehicleLabel[i][vLabelType] = 0;
						DestroyDyn3DTextLabelFix(VehicleLabel[i][vLabel]);

						SetVehicleLabel(i, VLT_TYPE_OPERAOUTOFRANG, 5);
					}
				}
			}
		}

	}
}


hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if(PRESSED(KEY_FIRE)) {
        // playershottick[playerid] = GetTickCount();
        new vehicleid = Vehicle_Nearest(playerid);
        if(vehicleid != -1 && vehicleData[vehicleid][vbreakin] && !vehicleData[vehicleid][vbreakdelay])
        {
            if(IsPlayerNearDriverDoor(playerid, vehicleid) || IsABoat(GetVehicleModel(vehicleid))) {

                new id = PlayerCar_GetID(vehicleid), carlock = PlayerCar_GetLocked(id), caralarm = PlayerCar_GetAlarm(id), ownerid = PlayerCar_GetOwnerSID(id);
				new model = GetVehicleModel(vehicleid);
	
                if(carlock == 5) return 1;
                else if(carlock > 1) {
                    SendClientMessage(playerid, COLOR_LIGHTRED, "ยานพาหนะคันนี้จำเป็นต้องใช้ชะแลงในการพังประตู");
                    return 1;
                }

                if(vehicleData[vehicleid][vbreakin] == 50 + floatround(carlock*25))
                {
                    new
                        engine,
                        lights,
                        alarm,
                        doors,
                        bonnet,
                        boot,
                        objective;

                    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

                    if(caralarm == 2)
                    {
                        alarm = 1;
                        new other = IsCharacterOnline(ownerid);
                        if(other != -1) SendClientMessageEx(other, COLOR_YELLOW, "ข้อความ: สัญญาณกันขโมย %s ของคุณดังขึ้น, ผู้ส่ง: สัญญาณเตือนภัยของยานพาหนะ (Unknown)",ReturnVehicleModelName(model));
                    }
                    else if(caralarm == 3)
                    {
                        SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_RADIO, "สัญญาณเตือนภัยของยานพาหนะ: %s", GetPlayerLocation(playerid));
                        SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_RADIO, "รายละเอียด: ระบบความปลอดภัยของ %s ดังขึ้น",ReturnVehicleModelName(model));
                        new other = IsCharacterOnline(ownerid);
                        if(other != -1) SendClientMessageEx(other, COLOR_YELLOW, "ข้อความ: สัญญาณกันขโมย %s ของคุณดังขึ้น ผู้ส่ง: สัญญาณเตือนภัยของยานพาหนะ (Unknown)",ReturnVehicleModelName(model));
                    }
                    else if(caralarm == 4)
                    {
                        alarm = 1;
                        objective = 1;
                        SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_RADIO, "สัญญาณเตือนภัยของยานพาหนะ: %s", GetPlayerLocation(playerid));
                        SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_RADIO, "รายละเอียด: ระบบความปลอดภัยของ %s ดังขึ้น", ReturnVehicleModelName(model));

                        new other = IsCharacterOnline(ownerid);
                        if(other != -1) SendClientMessageEx(other, COLOR_YELLOW, "ข้อความ: สัญญาณกันขโมย %s ของคุณดังขึ้น ผู้ส่ง: สัญญาณเตือนภัยของยานพาหนะ (Unknown)",ReturnVehicleModelName(model));
                    }
                    else
                    {
                        alarm = 1;
                    }

                    if (alarm) {
                        vehicleHorn[vehicleid] = repeat HornUpdate(vehicleid);
                    }
                    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
                }

                if(IsValidDynamic3DTextLabel(VehicleLabel[vehicleid][vLabel])) 
                    DestroyDyn3DTextLabelFix(VehicleLabel[vehicleid][vLabel]);

				if (vehicleData[vehicleid][vbreakdelay] <= 0) {
					switch(carlock) {
						case 2: {
							vehicleData[vehicleid][vbreakdelay]=1;
							vehicleData[vehicleid][vbreakin] -= 1 + random(4);
						}
						case 3: {
							vehicleData[vehicleid][vbreakdelay]=2;
							vehicleData[vehicleid][vbreakin] -= 1 + random(3);
						}
						case 4: {
							vehicleData[vehicleid][vbreakdelay]=4;
							vehicleData[vehicleid][vbreakin]--;
						}
						default: {
							vehicleData[vehicleid][vbreakdelay]=0;
							vehicleData[vehicleid][vbreakin] -= 1 + random(5);
						}
					}
				}

                if(vehicleData[vehicleid][vbreakin] <= 0)
                {
                    stop vehicleHorn[vehicleid];
                    vehicleData[vehicleid][vbreakin] = 0;
                    vehicleData[vehicleid][vbreaktime] = 0;

                    new
                        engine,
                        lights,
                        alarm,
                        doors,
                        bonnet,
                        boot,
                        objective;

                    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
                    SetVehicleParamsEx(vehicleid, engine, lights, 0, 0, bonnet, boot, 0);

                    PlayerCar_SetLocked(id, false);
                    // PlayerCar_SaveID(id);
                }
                SetVehicleLabel(vehicleid, VLT_TYPE_BREAKIN, 3);
            }
        }
    }
    return 1;
}

timer HornUpdate[1000](vehicleid) {
    if (vehicleData[vehicleid][vbreakin]) {
        foreach(new i : Player) {
            if (Vehicle_Near(i, 25.0) == vehicleid) {
				PlayerPlaySound(i, 1147, 0.0, 0.0, 0.0);
            }
        }
    }
    else {
        stop vehicleHorn[vehicleid];
    }
}

VehicleLabel_GetTime(vehicleid) {
	return VehicleLabel[vehicleid][vLabelTime];
}