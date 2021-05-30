//--------------------------------[TIMERS.PWN]--------------------------------

ptask PlayerTimer[1000](playerid) {

	if(BitFlag_Get(gPlayerBitFlag[playerid], IS_SPAWNED)) {
		//print("PlayerTimer");	
		/*if(gIsDeathMode{playerid}) {
			SetPlayerChatBubble(playerid, "(( �����蹹�������� ))", 0xFF6347FF, 20.0, 1500);
		}*/

		if(gInjuredTime[playerid] > 0) {
			gInjuredTime[playerid]--;

			// ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 0, 0, 0, 1, 0, 1);
		}
		
		if(gIsInjuredMode{playerid} && gInjuredTime[playerid] == 0) {
		
			if(!gIsDeathMode{playerid})
			{
				gIsDeathMode{playerid} = true;
				gInjuredTime[playerid] = Main_GetRespawnTime(playerid);

				if (!IsPlayerInAnyVehicle(playerid)) {
					ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 0, 0, 0, 1, 0, 1);
				}
				SendClientMessageEx(playerid, COLOR_YELLOW, "-> �س�������㹢�й�� �س���繵�ͧ�� %d �Թҷ������ѧ�ҡ��鹤س�֧������ö /respawnme", gInjuredTime[playerid]);

				// Fix Mobile
				//SetPlayerChatBubble(playerid, "(( �����蹹�������� ))", COLOR_LIGHTRED, 20.0, 1000);
				/*if (IsValidDynamic3DTextLabel(gDeathLabel[playerid])) {
					DestroyDyn3DTextLabelFix(gDeathLabel[playerid]);
				}
				gDeathLabel[playerid] = CreateDynamic3DTextLabel("(( �����蹹�������� ))", COLOR_LIGHTRED, 0.0, 0.0, 0.7, 25.0, playerid, _, 1);*/
			}
			else {
				SendClientMessage(playerid, COLOR_YELLOW, "-> ���ҵ�¢ͧ�س���ŧ���� �س����ö /respawnme ��㹢�й��");
				gInjuredTime[playerid]=-1;
			}
		}

		if (playerData[playerid][pJailed]) {
			if(playerData[playerid][pJailTime] > 1)
			{
				playerData[playerid][pJailTime]--;
				
				if (!gRestartTime) 
					GameTextForPlayer(playerid,sprintf("~p~Jail time remaining: ~w~%d second", playerData[playerid][pJailTime]),1200,3);
			}
			else
			{
				playerData[playerid][pJailTime] = 0;
				playerData[playerid][pJailed] = 0;
				SetPlayerSkin(playerid, playerData[playerid][pWear] ? playerData[playerid][pWear] : playerData[playerid][pModel]);
				SpawnPlayer(playerid);
				GameTextForPlayer(playerid,"~g~You were released",5000,1);
			}
		}
		// gPlayerDrag[playerid] id ���ҡ
		if(gPlayerDrag[playerid] != INVALID_PLAYER_ID) {
			if(IsPlayerConnected(gPlayerDrag[playerid])) {
				switch(GetPlayerState(gPlayerDrag[playerid])) {
					case 1: { // on foot
						GetPlayerPos(gPlayerDrag[playerid], playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
						SetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);

						SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(gPlayerDrag[playerid]));
						SetPlayerInterior(playerid, GetPlayerInterior(gPlayerDrag[playerid]));
					}
					case 2, 3: {
						SendClientMessage(gPlayerDrag[playerid], COLOR_GREY, "�س�������ö���ö���ҡ���ѧ�ҡ�úҧ�� (�� /putincar)");
						RemovePlayerFromVehicle(gPlayerDrag[playerid]);
					}
					case 7: { // Death
						gPlayerDrag[playerid] = INVALID_PLAYER_ID;
					}
				}
			}
			else {
				gPlayerDrag[playerid] = INVALID_PLAYER_ID;
			}
		}

		// Vehicle Crash
		if(IsPlayerInAnyVehicle(playerid))
		{
			new
				Float:hp, vehicleid = GetPlayerVehicleID(playerid), vdamage[4]
			;
			
			if(vehicleid != 0) {
			
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && (!GetEngineStatus(vehicleid) && IsEngineVehicle(vehicleid))) {
					TogglePlayerControllable(playerid, false);
				}


				GetVehicleHealth(vehicleid, hp);
				
				GetVehicleDamageStatus(vehicleid, vdamage[0], vdamage[1], vdamage[2], vdamage[3]);
				
				if(hp < vehicleData[vehicleid][vHealth])
				{
					new carid = -1, Float:vehicle_health_loss = vehicleData[vehicleid][vHealth] - hp;
					vehicleData[vehicleid][vHealth] = hp;
					
					if((carid = PlayerCar_GetID(vehicleid)) != -1) {

						/*if(playerCarData[carid][carArmour]) {

							SetVehicleDamageStatus(vehicleid, vehicleData[vehicleid][vehDamage][0], vehicleData[vehicleid][vehDamage][1], vehicleData[vehicleid][vehDamage][2], vehicleData[vehicleid][vehDamage][3]);
				
							if(playerCarData[carid][carArmour] >= vehicle_health_loss)
							{
								//SetVehicleHealthEx(vehicleid, vehicle_health_loss + hp);
								playerCarData[carid][carArmour]-=vehicle_health_loss;
							}
							else
							{
								//SetVehicleHealthEx(vehicleid, hp + vehicle_health_loss - playerCarData[carid][carArmour]);
								playerCarData[carid][carArmour]=0;
							}
						}*/

						switch(hp)
						{
							case 550..649:
							{
								PlayerCar_DecreaseEngine(carid, (vehicle_health_loss/125.0));
								if(hp < 650) PlayerCar_DecreaseBattery(carid, (vehicle_health_loss/150.0));
							}
							case 390..549:
							{
								PlayerCar_DecreaseEngine(carid, (vehicle_health_loss/100.0));
								if(hp < 650) PlayerCar_DecreaseBattery(carid, (vehicle_health_loss/125.0));
							}
							case 250..389:
							{
								PlayerCar_DecreaseEngine(carid, (vehicle_health_loss/75.0));
								if(hp < 650) PlayerCar_DecreaseBattery(carid, (vehicle_health_loss/100.0));
							}
						}
					}
					
					if(hp < 390.0 && vehicle_health_loss > 15 && vehicleData[vehicleid][vehicleBadlyDamage] == 0) {
						SetEngineStatus(vehicleid, false);
						TogglePlayerControllable(playerid, false);
						/*SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: ����ͧ¹������������ҧ˹ѡ");
						SendClientMessage(playerid, COLOR_YELLOW, "�����: ������ "EMBED_WHITE"W"EMBED_YELLOW" ���͵Դ����ͧ¹��");
						SendClientMessage(playerid, COLOR_YELLOW, "�����: �س������ "EMBED_WHITE"10"EMBED_YELLOW" �Թҷ� ���͵Դ����ͧ¹��");
						vehicleData[vehicleid][vehicleBadlyDamage] = 10;*/
						//GameTextForPlayer(playerid, "~r~ENGINE COULDN'T START DUE TO DAMAGE", 4000, 4);
					}
				
					new Float:phploss = floatround((vehicle_health_loss / 100));
				
					if(phploss>0.0) {
						//new Float:php;
						foreach (new x : Player) {
							if(IsPlayerInVehicle(x, vehicleid)) {
								SetPlayerHealthEx(x,(playerData[x][pHealth] - phploss));
							}
						}
					}
				}

			}
		}
	}
	return 1;
}

ptask ProductionTimer[300000](playerid) {
	if(playerData[playerid][pPayDay] < 6) playerData[playerid][pPayDay] += 1; //+ 5 min to PayDay anti-abuse
}

ptask CheckHungry[1000](playerid) {
	if(playerData[playerid][pHungry] > 0) playerData[playerid][pHungry] = 0.0;
}

ptask CheckThirst[1000](playerid) {
	if(playerData[playerid][pThirst] > 0) playerData[playerid][pThirst] = 0.0;
}

ptask HungerTimer[600000](playerid) {
	if(playerData[playerid][pHunger] > 9.0)
	{
		SendNearbyMessage(playerid, 25.0, COLOR_PURPLE, "* ���§��ͧ��ͧ������ѧ��鹴��¤������ (( %s ))", ReturnRealName(playerid));
	}
}


task RestartCheck[1000]()
{
	if (gServerRestart)
	{	
		//print("RestartCheck");

		if(gRestartTime) {
			GameTextForAll(sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Server Restart:~w~ %02d:%02d", gRestartTime / 60, gRestartTime % 60), 1100, 3);
			/*TextDrawSetString(gServerRestartCount, string);
			TextDrawShowForAll(gServerRestartCount);*/
			gRestartTime--;

			if (gRestartTime == 2) {
				foreach(new i : Player) OnAccountUpdate(i, false, 0);
				SaveAllWeed();
			}
			else if (gRestartTime == 3) {
				foreach(new i : Iter_PlayerCar) PlayerCar_SaveID(i);
			}
		}
		else {
			/*foreach (new i : Player) {
				OnAccountUpdate(i, false, 0);
			}*/
			SendRconCommand("gmx");

            SendClientMessageToAll(COLOR_BLUE, " ");
            SendClientMessageToAll(COLOR_DARKGREEN, "Fun 4 You");
            SendClientMessageToAll(COLOR_BLUE, "    Copyright (C) 2018 Ak-kawit \"Aktah\" Tahae");
            SendClientMessageToAll(COLOR_BLUE, "    �����������١���ҧ�������������� ������ Light Roleplay");
            SendClientMessageToAll(COLOR_BLUE, "    �ء������ö�ʴ������Դ��������ҧ�������������������������Թ�㹷ҧ���բ��");
            SendClientMessageToAll(COLOR_BLUE, " ");
            SendClientMessageToAll(COLOR_BLUE, " ");
            SendClientMessageToAll(COLOR_BLUE, " ");
            SendClientMessageToAll(COLOR_BLUE, "-------------------------------------------------------------------------------------------------------------------------");
            SendClientMessageToAll(COLOR_YELLOW, " >  �����������ѧ��ʵ��� �ô���ѡ����...");
            SendClientMessageToAll(COLOR_BLUE, "-------------------------------------------------------------------------------------------------------------------------");
		}
	}
	return 1;
}

task autoMSG[420000]()
{

    new RandomMSG[][] =
    {
	    "[SA Bot] : �����������١�Ѳ�Ң������������� �к���ҧ � ���ѧ������������ҹФ�Ѻ�Դ����������",
		"[SA Bot] : �Թ����� � �����? �ͧ /draw ˹������",
		"[SA Bot] : ����� /help ���ʹ٤���觾�鹰ҹ��ҧ �",
		"[SA Bot] : �͡������ѵԡѹ��� (/hunt)",
		"[SA Bot] : ����� /donate ���ͺ�ԨҤ������������������ ��������ͺ᷹�ҡ���",
		"[SA Bot] : ����ö��ǹ��Ǵ��������ԨҤ�������ѹ��� (/donate)",
		"[SA Bot] : ����� (/o)oc ����ö��ٴ��·��Ƿ������������� ��س���繵�ͧ�����觹� (�����ʹ�Թ����Դ�������͡)",
		"[SA Bot] : ����͡���� Facebook �ͧ��� "EMBED_RED"San Andreas Roleplay"EMBED_YELLOW2" ����������ٴ�����Ф�Ѻ"
	};
    new randMSG = random(sizeof(RandomMSG));
    SendClientMessageToAll(COLOR_YELLOW4, RandomMSG[randMSG]);
}

ptask SpectatorTimer[2000](playerid) {
	if(playerData[playerid][pSpectating] != INVALID_PLAYER_ID) {
		//print("SpectatorTimer");
		if(GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(playerData[playerid][pSpectating]) || GetPlayerInterior(playerid) != GetPlayerInterior(playerData[playerid][pSpectating])){
			
			SetPlayerInterior(playerid, GetPlayerInterior(playerData[playerid][pSpectating]));
			SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(playerData[playerid][pSpectating]));

			if(IsPlayerInAnyVehicle(playerData[playerid][pSpectating])) {
				PlayerSpectateVehicle(playerid, GetPlayerVehicleID(playerData[playerid][pSpectating]));
			}
			else {
				PlayerSpectatePlayer(playerid, playerData[playerid][pSpectating]);
			}
		}
	}
	return 1;
}
