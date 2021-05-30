//--------------------------------[TIMERS.PWN]--------------------------------

ptask PlayerTimer[1000](playerid) {

	if(BitFlag_Get(gPlayerBitFlag[playerid], IS_SPAWNED)) {
		//print("PlayerTimer");	
		/*if(gIsDeathMode{playerid}) {
			SetPlayerChatBubble(playerid, "(( ผู้เล่นนี้ตายแล้ว ))", 0xFF6347FF, 20.0, 1500);
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
				SendClientMessageEx(playerid, COLOR_YELLOW, "-> คุณตายแล้วในขณะนี้ คุณจำเป็นต้องรอ %d วินาทีและหลังจากนั้นคุณถึงจะสามารถ /respawnme", gInjuredTime[playerid]);

				// Fix Mobile
				//SetPlayerChatBubble(playerid, "(( ผู้เล่นนี้ตายแล้ว ))", COLOR_LIGHTRED, 20.0, 1000);
				/*if (IsValidDynamic3DTextLabel(gDeathLabel[playerid])) {
					DestroyDyn3DTextLabelFix(gDeathLabel[playerid]);
				}
				gDeathLabel[playerid] = CreateDynamic3DTextLabel("(( ผู้เล่นนี้ตายแล้ว ))", COLOR_LIGHTRED, 0.0, 0.0, 0.7, 25.0, playerid, _, 1);*/
			}
			else {
				SendClientMessage(playerid, COLOR_YELLOW, "-> เวลาตายของคุณหมดลงแล้ว คุณสามารถ /respawnme ได้ในขณะนี้");
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
		// gPlayerDrag[playerid] id คนลาก
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
						SendClientMessage(gPlayerDrag[playerid], COLOR_GREY, "คุณไม่สามารถขึ้นรถได้หากกำลังลากใครบางคน (ใช้ /putincar)");
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
						/*SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: เครื่องยนต์เสียหายอย่างหนัก");
						SendClientMessage(playerid, COLOR_YELLOW, "ข้อแนะ: กดปุ่ม "EMBED_WHITE"W"EMBED_YELLOW" เพื่อติดเครื่องยนต์");
						SendClientMessage(playerid, COLOR_YELLOW, "ข้อแนะ: คุณมีเวลา "EMBED_WHITE"10"EMBED_YELLOW" วินาที เพื่อติดเครื่องยนต์");
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
		SendNearbyMessage(playerid, 25.0, COLOR_PURPLE, "* เสียงท้องร้องเริ่มดังขึ้นด้วยความหิว (( %s ))", ReturnRealName(playerid));
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
            SendClientMessageToAll(COLOR_BLUE, "    เซิร์ฟเวอร์นี้ถูกสร้างขึ้นมาใหม่ตั้งแต่ต้น เป็นโหมด Light Roleplay");
            SendClientMessageToAll(COLOR_BLUE, "    ทุกคนสามารถแสดงความคิดเห็นได้อย่างอิสระเพื่อให้เกมส์โหมดนี้ดำเนินไปในทางที่ดีขึ้น");
            SendClientMessageToAll(COLOR_BLUE, " ");
            SendClientMessageToAll(COLOR_BLUE, " ");
            SendClientMessageToAll(COLOR_BLUE, " ");
            SendClientMessageToAll(COLOR_BLUE, "-------------------------------------------------------------------------------------------------------------------------");
            SendClientMessageToAll(COLOR_YELLOW, " >  เซิร์ฟเวอร์กำลังรีสตาร์ท โปรดรอสักครู่...");
            SendClientMessageToAll(COLOR_BLUE, "-------------------------------------------------------------------------------------------------------------------------");
		}
	}
	return 1;
}

task autoMSG[420000]()
{

    new RandomMSG[][] =
    {
	    "[SA Bot] : เกมส์โหมดนี้ถูกพัฒนาขึ้นมาใหม่ตั้งแต่ต้น ระบบต่าง ๆ กำลังทยอยเพิ่มเข้ามานะครับติดตามรอได้เลย",
		"[SA Bot] : เงินเหลือ ๆ ใช่ไหม? ลอง /draw หน่อยเป็นไง",
		"[SA Bot] : พิมพ์ /help เพื่อดูคำสั่งพื้นฐานต่าง ๆ",
		"[SA Bot] : ออกล่าสมบัติกันเถอะ (/hunt)",
		"[SA Bot] : พิมพ์ /donate เพื่อบริจาคช่วยเหลือเซิร์ฟเวอร์ มีไอเท็มตอบแทนมากมาย",
		"[SA Bot] : ซื้อรถส่วนตัวด้วยแต้มบริจาคได้แล้ววันนี้ (/donate)",
		"[SA Bot] : คำสั่ง (/o)oc สามารถใช้พูดคุยทั่วทั้งเซิร์ฟเวอร์ได้ แต่คุณจำเป็นต้องมีโทรโข่งนะ (ปกติแอดมินไม่เปิดให้คุยหรอก)",
		"[SA Bot] : นี่คือกลุ่ม Facebook ของเรา "EMBED_RED"San Andreas Roleplay"EMBED_YELLOW2" เข้ามาร่วมพูดคุยได้นะครับ"
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
