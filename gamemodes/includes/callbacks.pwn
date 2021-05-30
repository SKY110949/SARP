//--------------------------------[CALLBACKS.PWN]--------------------------------




new LegDelay[MAX_PLAYERS];
new Indicators_xqz[MAX_VEHICLES][6];
public OnPlayerConnect(playerid) {
    PlayerJump[playerid] = 0;

	//Mongols
	RemoveBuildingForPlayer(playerid, 4976, 1931.0000, -1871.3906, 15.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 1879.9922, -1879.8906, 13.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 1885.2578, -1879.8984, 13.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 1864.1797, -1879.6641, 13.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 1869.4609, -1879.6641, 13.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1874.7344, -1879.6641, 13.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1890.5234, -1879.6641, 13.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 1904.3750, -1879.7344, 13.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 1909.6563, -1879.7344, 13.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1914.9297, -1879.7344, 13.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 1920.1953, -1879.9531, 13.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 1925.4609, -1879.9609, 13.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1930.7188, -1879.7344, 13.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 4848, 1931.0000, -1871.3906, 15.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 4983, 1961.0313, -1871.4063, 23.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1931.8750, -1863.4609, 16.3203, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1915.7422, -1863.4609, 16.3203, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1957.3672, -1867.2891, 16.3203, 0.25);

	/*gPlayerBitFlag[playerid] = PlayerFlags:0;

	playerData[playerid][pModel] = 23;

	for (new i=0;i!=10;i++) {
		playerData[playerid][pDrugAddiction][i]=0;
	}
	playerData[playerid][pDrugAddict] = 0;
	playerData[playerid][pDrugAddictStrength] = 0;

	playerData[playerid][pJobRank] = 
	playerData[playerid][pSeedWeed] = 
	gLastCheckpointTime[playerid] =
	playerData[playerid][pWarrants] = 0;
	playerData[playerid][pArrested] = 
	playerData[playerid][pJailed] = 
	playerData[playerid][pJailTime] = 
	playerData[playerid][pPoint] = 
	playerData[playerid][pFishingPerks] = 
	playerData[playerid][pFishes] = 
	playerData[playerid][pContractTime] = 
	playerData[playerid][pJob] = 
	playerData[playerid][pSideJob] = 
	playerData[playerid][pAnimation] = 
	playerData[playerid][pTimeout] = 
	playerData[playerid][pItemGasCan] = 
	playerData[playerid][pItemCrowbar] = 
    playerData[playerid][pItemOOC] = 
    playerData[playerid][pAccount] = 
    playerData[playerid][pSavingsCollect] = 
    playerData[playerid][pSavings] = 
    playerData[playerid][pPayDayHad] = 
    playerData[playerid][pPayCheck] = 
    playerData[playerid][pPayDay] = 
    playerData[playerid][pPUpgrade] = 
	playerData[playerid][pVehiclePerks] = 
    playerData[playerid][pRespawnPerks] = 
	playerData[playerid][pExp] = 
	playerData[playerid][pBusinessKey] = 
	playerData[playerid][pHouseKey] = 
	playerData[playerid][pWear] = 
    playerData[playerid][pFaction] = 
    playerData[playerid][pFactionRank] = 
	playerData[playerid][pInterior] = 
	playerData[playerid][pVWorld] = 
	playerData[playerid][pAdmin] =
	playerData[playerid][pLevel] =
 	playerData[playerid][pCash] =
	playerData[playerid][pScore] = 
	playerData[playerid][pPlayingHours] = 
	playerData[playerid][pDonateRank] = 
	playerData[playerid][pSpawnType] = 
	playerData[playerid][pSpawnPoint] = 
	playerData[playerid][pAdmin] = 
	playerData[playerid][pOnDuty] = 
	playerData[playerid][pPnumber] = 0;

	playerData[playerid][pWatering] = 
	playerData[playerid][pCarLic] = 
	playerData[playerid][pCreated] =
	playerData[playerid][pMedicBill] = false;

	playerData[playerid][pPDupkey] = 
	playerData[playerid][pPCarkey] = -1;

	gPlayerEscapeTime[playerid] = 0;

	gSyncMobile{playerid}=
	gIsDeathMode{playerid}=
	gIsInjuredMode{playerid}=false;

	playerData[playerid][pHunger] = 
	playerData[playerid][pPosX] = 
	playerData[playerid][pPosY] = 
	playerData[playerid][pPosZ] = 
	playerData[playerid][pPosA] = 
	playerData[playerid][pArmour] = 
	playerData[playerid][pHealth] = 
	playerData[playerid][pSHealth] = 0.0;

	gPlayerCheckpoint{playerid}=false;
	pToAccept[playerid] = INVALID_PLAYER_ID;
	tToAccept[playerid] = OFFER_TYPE_NONE;
	prToAccept[playerid] = 0;

	playerData[playerid][pCannabis] = 0;
	playerData[playerid][pIrons] = 
	playerData[playerid][pAllowMiner] = 0;

	for (new x = 0; x < 13; x ++) {
		playerData[playerid][pWeapons][x] = 0;
		playerData[playerid][pAmmo][x] = 0;
	}

	Damage_Reset(playerid);

	gPlayerDrag[playerid] = 
	playerData[playerid][pSpectating] = INVALID_PLAYER_ID;*/
//	GameTextForPlayer(playerid,"~w~SA-MP: ~r~Bare Script",5000,5);

	ResetStatistics(playerid);

	GetPlayerIp(playerid,playerData[playerid][pIP], 16);
	SetPlayerColor(playerid, PLAYER_COLOR_GREY);
	//ResetPlayerWeapons(playerid);
	DisablePlayerCheckpoint(playerid);
	SetPlayerScore(playerid, 0);

	if(isPlayerAndroid(playerid) != 0)
	{
		SendClientMessage(playerid, COLOR_YELLOW, "SERVER: คุณได้เข้าเล่นผ่านอุปกรณ์ Android");
	}

    return 1;
}

public OnPlayerDisconnect(playerid, reason) {

	//ฆ่าตัวแปรผู้เล่นอื่นที่ใช้เชื่อมต่อกับผู้เล่นนี้
	if(gPlayerDrag[playerid] != INVALID_PLAYER_ID) {
		// playerVariables[gPlayerDrag[playerid]][pDrag] = INVALID_PLAYER_ID; // Kills off any disconnections.
		gPlayerDrag[playerid] = INVALID_PLAYER_ID;
	}

	ResetStatistics(playerid);
		
	foreach (new i : Player)
	{
		if(playerData[i][pSpectating] == playerid) {
			TogglePlayerSpectating(i, false);
			SendClientMessage(i, COLOR_GREY, "ผู้เล่นนั้นตัดขาดการเชื่อมต่อจากเซิร์ฟเวอร์");
		}
	}

	if(gLastCar[playerid] != 0)
	{
		if(PlayerCar_GetID(gLastCar[playerid]) == -1 && IsVehicleRental(gLastCar[playerid]) == -1)
		{
		 	new
			    engine,
			    lights,
			    alarm,
			    doors,
			    bonnet,
			    boot,
			    objective;

			GetVehicleParamsEx(gLastCar[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
			SetVehicleParamsEx(gLastCar[playerid], engine, lights, alarm, 0, bonnet, boot, objective);
		}
		gLastCar[playerid] = 0;
	}

	/*if(IsValidDynamic3DTextLabel(gDeathLabel[playerid])) 
		DestroyDyn3DTextLabelFix(gDeathLabel[playerid]);*/
	return 1;
}

public OnPlayerSpawn(playerid) {

	if (!BitFlag_Get(gPlayerBitFlag[playerid], IS_LOGGED))
		Kick(playerid);
	
	TogglePlayerSpectating(playerid, false);
	Streamer_ToggleIdleUpdate(playerid, true);

	if(playerData[playerid][pSpectating] != INVALID_PLAYER_ID || gSyncMobile{playerid}) {
		if (playerData[playerid][pSpectating] != INVALID_PLAYER_ID) {
			playerData[playerid][pSpectating] = INVALID_PLAYER_ID;
			SetCameraBehindPlayer(playerid);
		}
		
   /*	if(IsPlayerNPC(playerid))
	{
		new npcname[MAX_PLAYER_NAME];
		GetPlayerName(playerid, npcname, sizeof(npcname));

	    if(!strcmp(npcname, "Crazy_Train_Driver", true))
   		  {
       		SetPlayerColor(playerid, 0xFFFFFF00);
			//PutPlayerInVehicle(playerid, NPCBlueBus, 0);-
        	SetPlayerSkin(playerid, 255);
        	ResetPlayerWeapons(playerid);
	      	PutPlayerInVehicle(playerid, MyFirstNPCVehicle, 538);
	    }

	    return 1;
	}

		SetPlayerInterior(playerid,0);
		TogglePlayerClock(playerid,0);
		*/
		
	 /*  	if(IsPlayerNPC(playerid))
		{
			new npcname[MAX_PLAYER_NAME];
			GetPlayerName(playerid, npcname, sizeof(npcname));

		    if(!strcmp(npcname, "Crazy_Train_Driver", true))
		    {
		      	PutPlayerInVehicle(playerid, MyFirstNPCVehicle, 538);
		    }

		    return 1;
		}

		SetPlayerInterior(playerid,0);
		TogglePlayerClock(playerid,0);*/

		SetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
		SetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
		SetPlayerInterior(playerid, playerData[playerid][pInterior]);
		SetPlayerVirtualWorld(playerid, playerData[playerid][pVWorld]);
		gSyncMobile{playerid} = false;
		return 1;
	}

///////////////////////////////////////////////////////////////////
   /* if(IsPlayerNPC(playerid))
    {
        new npcname[MAX_PLAYER_NAME];
        GetPlayerName(playerid, npcname, sizeof(npcname));
        if(!strcmp(npcname, "Crazy_Train_Driver", true))
        {
            SetPlayerColor(playerid, 0xFFFFFF00);
            //TOL_AC_PutPlayerInVehicle(playerid, NPCBlueBus, 0);//ไม่เปลี่ยนก็ได้
			//PutPlayerInVehicle(playerid, NPCBlueBus, 0);-
        	SetPlayerSkin(playerid, 255);
        	ResetPlayerWeapons(playerid);
        	//Attach3DTextLabelToVehicle(NPCTextBlue, NPCBlueBus, 0.0, 0.0, 0.0);
        }
        return 1;
	}
*/

////////////////////////////////////////////////////////////////

	if(playerData[playerid][pMedicBill])
	{
		new cut = 500 + playerData[playerid][pLevel] * 50;
		GivePlayerMoneyEx(playerid, -cut);
			
		SendClientMessageEx(playerid, COLOR_PINK, "EMT: ค่ารักษาพยาบาลของคุณมาถึงแล้ว $%d ขอให้โชคดี", cut);
		playerData[playerid][pMedicBill] = false;

		// ตั้งค่าเลือดและเกราะเป็นพื้นฐานเมื่อตัวละครเกิดใหม่
		playerData[playerid][pArmour] = 0.0;
		if(playerData[playerid][pDonateRank] > 0) playerData[playerid][pHealth] = 100.0 + playerData[playerid][pSHealth];
		else playerData[playerid][pHealth] = 50.0 + playerData[playerid][pSHealth];
	}

	if(playerData[playerid][pJailed] == 1)
	{
	    SetPlayerPos(playerid,  2576.7861,2712.2004,22.9507);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, playerData[playerid][pSID]);

		if (!BitFlag_Get(gPlayerBitFlag[playerid], IS_SPAWNED)) {
			SetPlayerSkin(playerid, 268);
			SendClientMessage(playerid, COLOR_YELLOW, "คุณยังอยู่ในคุกแอดมิน");
			ResyncSkin(playerid);
		}

		if(playerData[playerid][pHealth] > 0.0) SetPlayerHealth(playerid, playerData[playerid][pHealth]);
		else {
			if(playerData[playerid][pDonateRank] > 0) playerData[playerid][pHealth] = 100.0 + playerData[playerid][pSHealth];
			else playerData[playerid][pHealth] = 50.0 + playerData[playerid][pSHealth];
		}
		if(playerData[playerid][pArmour]) SetPlayerArmour(playerid, playerData[playerid][pArmour]);
		BitFlag_On(gPlayerBitFlag[playerid], IS_SPAWNED);
		return 1;
	}
	
	if(playerData[playerid][pJailed] == 2)
	{
		SetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
		SetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
		SetPlayerInterior(playerid, playerData[playerid][pInterior]);
		SetPlayerVirtualWorld(playerid, playerData[playerid][pVWorld]);

		if (!BitFlag_Get(gPlayerBitFlag[playerid], IS_SPAWNED)) {
			SetPlayerSkin(playerid, 268);
			SendClientMessage(playerid, COLOR_YELLOW, "คุณยังอยู่ในคุก");
			ResyncSkin(playerid);
		}

		TurnOffPhone(playerid);

		if(playerData[playerid][pHealth] > 0.0) SetPlayerHealth(playerid, playerData[playerid][pHealth]);
		else {
			if(playerData[playerid][pDonateRank] > 0) playerData[playerid][pHealth] = 100.0 + playerData[playerid][pSHealth];
			else playerData[playerid][pHealth] = 50.0 + playerData[playerid][pSHealth];
		}
		if(playerData[playerid][pArmour]) SetPlayerArmour(playerid, playerData[playerid][pArmour]);
		BitFlag_On(gPlayerBitFlag[playerid], IS_SPAWNED);
		return 1;
	}

	if(playerData[playerid][pTimeout] || gIsInjuredMode{playerid} || gIsDeathMode{playerid})
	{
		SetPlayerToTeamColor(playerid);
		SetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
		SetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
		SetPlayerInterior(playerid, playerData[playerid][pInterior]);
		SetPlayerVirtualWorld(playerid, playerData[playerid][pVWorld]);
		playerData[playerid][pTimeout] = 0;

		// Mobile_GameTextForPlayer(playerid, "~r~Welcome back~n~You're Crash", 5000, 1);

        if(gIsDeathMode{playerid} || gIsInjuredMode{playerid})
        {	
            SetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
            SetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
            SetPlayerInterior(playerid, playerData[playerid][pInterior]);
            SetPlayerVirtualWorld(playerid, playerData[playerid][pVWorld]);
            
            SetPlayerHealth(playerid, 25.0);
            
            TogglePlayerControllable(playerid, false);
            ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 0, 0, 0, 1, 0, 1);
        
            if(!gIsDeathMode{playerid}) {
                gInjuredTime[playerid] = 300;
                SendClientMessage(playerid, COLOR_LIGHTRED, "คุณได้รับบาดเจ็บอย่างรุนแรงตอนนี้ถ้าหากแพทย์ หรือใครก็ตามไม่สามารถช่วยคุณได้ คุณก็จะตาย");
                SendClientMessage(playerid, COLOR_LIGHTRED, "เพื่อยอมรับการตายพิมพ์ (/a)ccep(td)eath");	
				SendClientMessage(playerid, COLOR_LIGHTRED, "อาวุธที่คุณมีได้สูญหายไปเนื่องจากคุณได้รับบาดเจ็บอย่างรุนแรง");	
                GameTextForPlayer(playerid, "~b~brutally wounded", 5000, 4);

				//validResetPlayerWeapons(playerid);
				ResetPlayerWeapons(playerid);
				for (new i = 0; i < 13; i ++) {
					if (playerData[playerid][pGuns][i] != 0 && (playerData[playerid][pGuns][i] == playerData[playerid][pGun1] || playerData[playerid][pGuns][i] == playerData[playerid][pGun2] || playerData[playerid][pGuns][i] == playerData[playerid][pGun3])) {
						//new ammo;
						if(playerData[playerid][pGun1] == playerData[playerid][pGuns][i])
						{
						//	ammo = playerData[playerid][pAmmo1];
			
							playerData[playerid][pGun1]=0;
							playerData[playerid][pAmmo1]=0;
						}
						else if(playerData[playerid][pGun2] == playerData[playerid][pGuns][i])
						{
						//	ammo = playerData[playerid][pAmmo2];
							//license = playerData[playerid][pPLicense];
							playerData[playerid][pGun2]=0;
							playerData[playerid][pAmmo2]=0;
							//playerData[playerid][pPLicense]=0;
						}
						else
						{
						//	ammo = playerData[playerid][pAmmo3];
							//license = playerData[playerid][pSLicense];
							playerData[playerid][pGun3]=0;
							playerData[playerid][pAmmo3]=0;
							//playerData[playerid][pSLicense]=0;
						}
					}

					ResetWeapons(playerid);
					playerData[playerid][pGuns][i] = 0;
					playerData[playerid][pAmmo][i] = 0;

					OnAccountUpdate(playerid);
				}
            }
            else {
                gInjuredTime[playerid] = Main_GetRespawnTime(playerid);
                SendClientMessageEx(playerid, COLOR_YELLOW, "-> คุณตายแล้วในขณะนี้ คุณจำเป็นต้องรอ %d วินาทีและหลังจากนั้นคุณถึงจะสามารถ /respawnme", gInjuredTime[playerid]);
			}
            BitFlag_On(gPlayerBitFlag[playerid], IS_SPAWNED);
        }
		return 1;
	}
	switch(playerData[playerid][pSpawnType])
	{
		case SPAWN_TYPE_DEFAULT: // Airport
		{
			//SetPlayerToTeamColor(playerid);

			/*SetPlayerPos(playerid, 1643.0010,-2331.7056,-2.6797);
			SetPlayerFacingAngle(playerid,359.8919);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);

			playerData[playerid][pInterior] = 0;
			playerData[playerid][pVWorld] = 0;*/

			Main_SetPlayerDefaultSpawn(playerid);

			//playerData[playerid][pLocal] = 255;

			//ResetPlayerWeapons(playerid);
			//for (new i = 0; i < 13; i ++) GivePlayerValidWeapon(playerid, playerData[playerid][pGuns][i], playerData[playerid][pAmmo][i]);
		}
		case SPAWN_TYPE_FACTION: {
			SetPlayerFactionSpawn(playerid, playerData[playerid][pFaction]);
			//ResetPlayerWeapons(playerid);
			//for (new i = 0; i < 13; i ++) GivePlayerValidWeapon(playerid, playerData[playerid][pGuns][i], playerData[playerid][pAmmo][i]);
		}
		case SPAWN_TYPE_PROPERTY:
		{
			SetPlayerHouseSpawn(playerid, playerData[playerid][pHouseKey]);		
		}
		case SPAWN_TYPE_LASTPOS:
		{
			SetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
			SetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
			SetPlayerInterior(playerid, playerData[playerid][pInterior]);
			SetPlayerVirtualWorld(playerid, playerData[playerid][pVWorld]);
			//gSyncMobile{playerid} = false;
			//ResetPlayerWeapons(playerid);
			//for (new i = 0; i < 13; i ++) GivePlayerValidWeapon(playerid, playerData[playerid][pGuns][i], playerData[playerid][pAmmo][i]);
		}
		default: {
			SetPlayerToTeamColor(playerid);
			SetPlayerPos(playerid, 1643.0010,-2331.7056,-2.6797);
			SetPlayerFacingAngle(playerid,359.8919);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);

			playerData[playerid][pInterior] = 0;
			playerData[playerid][pVWorld] = 0;
			//playerData[playerid][pLocal] = 255;
			playerData[playerid][pSpawnType] = SPAWN_TYPE_DEFAULT;
			
			//ResetPlayerWeapons(playerid);
			//for (new i = 0; i < 13; i ++) GivePlayerValidWeapon(playerid, playerData[playerid][pGuns][i], playerData[playerid][pAmmo][i]);

		}
	}
	SetPlayerWantedLevel(playerid, playerData[playerid][pWarrants]);
	SetPlayerSkin(playerid, playerData[playerid][pWear] ? playerData[playerid][pWear] : playerData[playerid][pModel]);
	SetPlayerToTeamColor(playerid);
	// ตัวละครยังไม่เกิดใหม่ ให้ตั้งค่าเลือดและเกราะเดิม
	if(playerData[playerid][pHealth] > 0.0) SetPlayerHealth(playerid, playerData[playerid][pHealth]);
	else {
		// ป้องกันบัคตาย
		if(playerData[playerid][pDonateRank] > 0) playerData[playerid][pHealth] = 100.0 + playerData[playerid][pSHealth];
		else playerData[playerid][pHealth] = 50.0 + playerData[playerid][pSHealth];
	}
	if(playerData[playerid][pArmour]) SetPlayerArmour(playerid, playerData[playerid][pArmour]);
	BitFlag_On(gPlayerBitFlag[playerid], IS_SPAWNED);
	SetCameraBehindPlayer(playerid);

	ResetPlayerWeapons(playerid);
    SetPlayerWeapons(playerid);

	SetPlayerArmour(playerid, 0); // Reset Armour

	return 1;
}

public OnPlayerDeath(playerid, killerid, reason) {

	printf("DEBUG: OnPlayerDeath %d %d %d", playerid, killerid, reason);

	BitFlag_Off(gPlayerBitFlag[playerid], IS_SPAWNED);

	playerData[playerid][pInterior] = GetPlayerInterior(playerid);
	playerData[playerid][pVWorld] = GetPlayerVirtualWorld(playerid);
	GetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
	GetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
		
	if(!gIsInjuredMode{playerid}) gIsInjuredMode{playerid}=true;
	else gIsDeathMode{playerid} = true;

	ResetWeapons(playerid);
	
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	#if defined SV_DEBUG
		printf("callbacks.pwn: OnPlayerStateChange(playerid %d, newstate %d, oldstate %d)", playerid, newstate, oldstate);
	#endif
	if (newstate == PLAYER_STATE_WASTED)
	{
		BitFlag_Off(gPlayerBitFlag[playerid], IS_SPAWNED);
	}

	if (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) {
		if (gIsInjuredMode{playerid} && newstate != PLAYER_STATE_DRIVER) 
			return RemoveFromVehicle(playerid);
			
        gPassengerCar[playerid] = GetPlayerVehicleID(playerid);
	}

	if (newstate == PLAYER_STATE_DRIVER)
	{
		if(!playerData[playerid][pCarLic])
      		SendClientMessage(playerid, COLOR_LIGHTRED,"คุณไม่มีใบอนุณาตขับขี่! ต้องผ่านการทดสอบการขับรถเพื่อให้ได้มัน");

	    new vid = GetPlayerVehicleID(playerid), oldcar = gLastCar[playerid];

		if(oldcar != 0)
		{
			if(PlayerCar_GetID(oldcar) == -1 && IsVehicleRental(oldcar) == -1)
			{
				if(oldcar != vid)
				{
			 		new
					    engine,
					    lights,
					    alarm,
					    doors,
					    bonnet,
					    boot,
					    objective;

					GetVehicleParamsEx(oldcar, engine, lights, alarm, doors, bonnet, boot, objective);
					SetVehicleParamsEx(oldcar, engine, lights, alarm, 0, bonnet, boot, objective);
				}
			}
		}

        gLastCar[playerid] = vid;
	}

    if (oldstate == PLAYER_STATE_DRIVER) {
		// ExitSettingVehicle(playerid);

		if (!BitFlag_Get(gPlayerBitFlag[playerid], IS_TAZERED))
			TogglePlayerControllable(playerid, true);
    }
    return 1;
}

stock GivePlayerHealth(playerid,Float:Health)
{
	new Float:health; 
	
	GetPlayerHealth(playerid, health);
	SetPlayerHealth(playerid, health+Health);
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
	new Float:health, Float:armour;
	GetPlayerHealth(playerid, health);

	// printf("playerid %d, issuerid %d, Float: amount %f, weaponid %d, bodypart %d", playerid, issuerid, amount, weaponid, bodypart);

	if(issuerid != INVALID_PLAYER_ID)
	{
	  	GetPlayerArmour(playerid, armour);

		/*if((BeanbagActive{issuerid} == true && weaponid == 25) || (TazerActive{issuerid} == true && weaponid == 23))
		{
			GivePlayerHealth(playerid, amount);
			return 0;
		}*/

		if(LegDelay[playerid]==0 && !gIsDeathMode{playerid} && !gIsInjuredMode{playerid})
		{
			switch(bodypart)
			{
				case 7,8:
				{
			  	 	SendClientMessage(playerid, COLOR_LIGHTRED, "-> คุุณได้ถูกยิงที่ขา คุณจะลำบากในการวิ่งและกระโดด");
			  	 	ApplyAnimation(playerid, "PED", "FALL_COLLAPSE", 4.1, 0, 1, 1, 0, 0, 1);
			  	  	LegDelay[playerid] = 10;
			  	}
			}
		}

		if(!gIsDeathMode{playerid}) {
			if(gIsInjuredMode{playerid})
			{
				if(gInjuredTime[playerid] <= 297)
				{
					if (IsPlayerInAnyVehicle(playerid)) 
						RemovePlayerFromVehicle(playerid);

					gIsDeathMode{playerid} = true;
					gInjuredTime[playerid] = Main_GetRespawnTime(playerid);
					SendClientMessageEx(playerid, COLOR_YELLOW, "-> คุณตายแล้วในขณะนี้ คุณจำเป็นต้องรอ %d วินาทีและหลังจากนั้นคุณถึงจะสามารถ /respawnme", gInjuredTime[playerid]);
					SetPlayerChatBubble(playerid, "(( ผู้เล่นนี้ตายแล้ว ))", COLOR_LIGHTRED, 20.0, 1000);
					/*if (IsValidDynamic3DTextLabel(gDeathLabel[playerid])) {
						DestroyDyn3DTextLabelFix(gDeathLabel[playerid]);
					}
					gDeathLabel[playerid] = CreateDynamic3DTextLabel("(( ผู้เล่นนี้ตายแล้ว ))", COLOR_LIGHTRED, 0.0, 0.0, 0.7, 25.0, playerid, _, 1);*/

					ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 0, 0, 0, 1, 0, 1);
				}
			}
			else
			{
				switch(weaponid)
				{
					case 4: amount = 30.0;
					case 8: amount = 35.0;
					case 5, 7: amount = 10.0;
					case 2, 3, 6, 1: amount = 15.0;
					case 22: amount = 20.0;
					case 23: amount = 25.0;
					case 28: amount = 15.0;
					case 30: amount = 40.0;
					case 31: amount = 35.0;
					case 24: amount = 45.0;
					// The spas shotguns shoot 8 bullets, each inflicting 4.95 damage
					case 27: 
					{
						new Float:bullets = amount / 4.950000286102294921875;
						if (8.0 - bullets < -0.05) {
							return 0;
						}
						amount = bullets * 9.95;
					}
					// Shotguns and sawed-off shotguns shoot 15 bullets, each inflicting 3.3 damage
					case 25, 26: 
					{
						new Float: bullets = amount / 3.30000019073486328125;
						if (15.0 - bullets < -0.05) {
							return 0;
						}
						amount = bullets * 8.3;
					}
					case 33: amount = 70.0;
					case 29: amount = 28.0;
					case 32: amount = 15.0;
					case 34: amount = 100.0;
				}
					
				switch(bodypart)
				{
					case 5,6,7,8: amount *= 0.8;
					case 9: amount *= 1.5;
				}

				new bool:nohp;
				if(armour > 0.0 && (bodypart == 3 || (GetPlayerSkin(playerid) == 285 && bodypart == 9)))
				{
					new Float:totalarmour;
					totalarmour = armour - amount;

					if(totalarmour > 0.0) SetPlayerArmour(playerid, totalarmour);
					else {
						SetPlayerArmour(playerid, 0.0);
						if((health+=totalarmour) > 0.0) {
							SetPlayerHealth(playerid,health);
						}
						else nohp = true;
					}
				}
				else {
					if((health-=amount) > 0.0) SetPlayerHealth(playerid,health);
					else nohp = true;
				}

				addPlayerDamage(playerid, issuerid, weaponid, amount, (armour > 0 && (bodypart == 3 || (GetPlayerSkin(playerid) == 285 && bodypart == 9))) ? true : false, bodypart); // S.W.A.T suit armour hit

				if(nohp) {

					FullResetPlayerWeapons(playerid);
					ResetPlayerWeapons(playerid);
					for (new i = 0; i < 13; i ++) {
						if (playerData[playerid][pGuns][i] != 0 && (playerData[playerid][pGuns][i] == playerData[playerid][pGun1] || playerData[playerid][pGuns][i] == playerData[playerid][pGun2] || playerData[playerid][pGuns][i] == playerData[playerid][pGun3])) {
							//new ammo;
							if(playerData[playerid][pGun1] == playerData[playerid][pGuns][i])
							{
								//ammo = playerData[playerid][pAmmo1];
				
								playerData[playerid][pGun1]=0;
								playerData[playerid][pAmmo1]=0;
							}
							else if(playerData[playerid][pGun2] == playerData[playerid][pGuns][i])
							{
								//ammo = playerData[playerid][pAmmo2];
								//license = playerData[playerid][pPLicense];
								playerData[playerid][pGun2]=0;
								playerData[playerid][pAmmo2]=0;
								//playerData[playerid][pPLicense]=0;
							}
							else
							{
								//ammo = playerData[playerid][pAmmo3];
								//license = playerData[playerid][pSLicense];
								playerData[playerid][pGun3]=0;
								playerData[playerid][pAmmo3]=0;
								//playerData[playerid][pSLicense]=0;
							}
							//if(license) Log_Write("logs/license_weapon.txt", "[%s] %s (%s) %s(%d) drop on bw mode (%d)", ReturnDate(), ReturnPlayerName(playerid), playerData[playerid][pIP], ReturnWeaponName(playerData[playerid][pGuns][i]), ammo, license);
							//else Log_Write("logs/weapon.txt", "[%s] %s (%s) %s(%d) drop on death", ReturnDate(), ReturnPlayerName(playerid), playerData[playerid][pIP], ReturnWeaponName(playerData[playerid][pGuns][i]), ammo);
						}
						playerData[playerid][pGuns][i] = 0;
						playerData[playerid][pAmmo][i] = 0;
						OnAccountUpdate(playerid);
					}

					//ResetPlayerWeapons(playerid);

					gInjuredTime[playerid] = 300;
					gIsInjuredMode{playerid} = true;
					SetPlayerHealth(playerid, 25.0);

					TogglePlayerControllable(playerid, false);
					SendClientMessage(playerid, COLOR_LIGHTRED, "คุณได้รับบาดเจ็บอย่างรุนแรงตอนนี้ถ้าหากแพทย์ หรือใครก็ตามไม่สามารถช่วยคุณได้ คุณก็จะตาย");
					SendClientMessage(playerid, COLOR_LIGHTRED, "เพื่อยอมรับการตายพิมพ์ (/a)ccep(td)eath");		

					SendClientMessage(playerid, COLOR_LIGHTRED, "อาวุธที่คุณมีได้สูญหายไปเนื่องจากคุณได้รับบาดเจ็บอย่างรุนแรง");	
					//validResetPlayerWeapons(playerid);
					ResetWeapons(playerid);

					/*new countdamage;
					if((countdamage = countPlayerDamage(playerid)) != 0)
					{
						new str[64];
						format(str, sizeof(str), "(( ได้รับความบาดเจ็บ %d ครั้ง /damages %d เพื่อดูรายละเอียด ))", countdamage, playerid);
						SendClientMessage(playerid, COLOR_LIGHTRED, str);
		
						if (IsValidDynamic3DTextLabel(gDeathLabel[playerid])) {
							DestroyDyn3DTextLabelFix(gDeathLabel[playerid]);
						}
						gDeathLabel[playerid] = CreateDynamic3DTextLabel(str, COLOR_LIGHTRED, 0.0, 0.0, 0.7, 25.0, playerid, _, 1);
					}*/
					// Fix Mobile
					/*if (IsValidDynamic3DTextLabel(gDeathLabel[playerid])) {
						DestroyDyn3DTextLabelFix(gDeathLabel[playerid]);
					}
					gDeathLabel[playerid] = CreateDynamic3DTextLabel("(( ได้รับความบาดเจ็บ ))", COLOR_LIGHTRED, 0.0, 0.0, 0.7, 25.0, playerid, _, 1);
*/
					GameTextForPlayer(playerid, "~b~brutally wounded", 5000, 4);
					
					playerData[playerid][pInterior] = GetPlayerInterior(playerid);
					playerData[playerid][pVWorld] = GetPlayerVirtualWorld(playerid);
					GetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
					GetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
					
					new vehicleid = GetPlayerVehicleID(playerid);

					if (vehicleid) {
						new modelid = GetVehicleModel(vehicleid);
						new seat = GetPlayerVehicleSeat(playerid);

						TogglePlayerControllable(playerid, false);

						switch (modelid) {
							case 509, 481, 510, 462, 448, 581, 522,
								461, 521, 523, 463, 586, 468, 471: {
								new Float:vx, Float:vy, Float:vz;
								GetVehicleVelocity(vehicleid, vx, vy, vz);

								if (vx*vx + vy*vy + vz*vz >= 0.4) {
									ApplyAnimation(playerid, "PED", "BIKE_fallR", 4.1, 1, 1, 0, 1, 0, 1);
								} else {
									ApplyAnimation(playerid, "PED", "BIKE_fall_off", 4.1, 1, 1, 0, 1, 0, 1);
								}
							}

							default: {
								if (seat & 1) {
									ApplyAnimation(playerid, "PED", "CAR_dead_LHS", 4.1, 0, 0, 0, 1, 0, 1);
								} else {
									ApplyAnimation(playerid, "PED", "CAR_dead_RHS", 4.1, 0, 0, 0, 1, 0, 1);
								}
							}
						}
					} else {
			
						new anim = GetPlayerAnimationIndex(playerid);

						if (anim == 1250 || (1538 <= anim <= 1544) || weaponid == WEAPON_DROWN) {
							// In water
							ApplyAnimation(playerid, "PED", "Drown", 4.1, 0, 0, 0, 1, 0, 1);
							
						} else if (1195 <= anim <= 1198) {
							// Jumping animation
							ApplyAnimation(playerid, "PED", "KO_skid_back", 4.1, 0, 0, 0, 1, 0, 1);
						} else if (WEAPON_SHOTGUN <= weaponid <= WEAPON_SHOTGSPA) {
							if (IsPlayerBehindPlayer(issuerid, playerid)) {
								MakePlayerFacePlayer(playerid, issuerid, true);
								ApplyAnimation(playerid, "PED", "KO_shot_front", 4.1, 0, 0, 0, 1, 0, 1);
							} else {
								MakePlayerFacePlayer(playerid, issuerid);
								ApplyAnimation(playerid, "PED", "BIKE_fall_off", 4.1, 0, 0, 0, 1, 0, 1);
							}
						} else if (WEAPON_RIFLE <= weaponid <= WEAPON_SNIPER) {
							if (bodypart == 9) {
								ApplyAnimation(playerid, "PED", "KO_shot_face", 4.1, 0, 0, 0, 1, 0, 1);
							} else if (IsPlayerBehindPlayer(issuerid, playerid)) {
								ApplyAnimation(playerid, "PED", "KO_shot_front", 4.1, 0, 0, 0, 1, 0, 1);
							} else {
								ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.1, 0, 0, 0, 1, 0, 1);
							}
						} else if (IsBulletWeapon(weaponid)) {
							if (bodypart == 9) {
								ApplyAnimation(playerid, "PED", "KO_shot_face", 4.1, 0, 0, 0, 1, 0, 1);
							} else {
								ApplyAnimation(playerid, "PED", "KO_shot_front", 4.1, 0, 0, 0, 1, 0, 1);
							}
						} else if (weaponid == WEAPON_PISTOLWHIP) {
							ApplyAnimation(playerid, "PED", "KO_spin_R", 4.1, 0, 0, 0, 1, 0, 1);
						} else if (IsMeleeWeapon(weaponid) || weaponid == WEAPON_CARPARK) {
							ApplyAnimation(playerid, "PED", "KO_skid_front", 4.1, 0, 0, 0, 1, 0, 1);
						} else if (weaponid == WEAPON_SPRAYCAN || weaponid == WEAPON_FIREEXTINGUISHER) {
							ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.1, 0, 0, 0, 1, 0, 1);
						} else {
							ApplyAnimation(playerid, "PED", "KO_skid_back", 4.1, 0, 0, 0, 1, 0, 1);
						}
					}
				}
				else {
					if(IsBulletWeapon(weaponid)) {
						if(health <= 30.0)
						{
							SetPlayerWeaponSkill(playerid, NORMAL_SKILL);
							SendClientMessage(playerid, COLOR_LIGHTRED, "-> วิกฤตเลือดเหลือน้อย ทักษะการยิงอยู่ในระดับต่ำ");
						}
						else if(health <= 40.0)
						{
							SetPlayerWeaponSkill(playerid, MEDIUM_SKILL);
							SendClientMessage(playerid, COLOR_LIGHTRED, "-> วิกฤตเลือดเหลือน้อย ทักษะการยิงอยู่ในระดับปานกลาง");
						}
					}
				}
			}
			return 0;
		}
		else {
			return 0;
		}
	}

	if(health > 0.0 && amount > 0.0 && health-amount <= 0.0) {
		if(gIsInjuredMode{playerid}) gIsDeathMode{playerid}=true;
		else gIsInjuredMode{playerid}=true;
	}

	return 1;
}
public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
    if(!BitFlag_Get(gPlayerBitFlag[playerid], IS_LOGGED)) {
		SendClientMessage(playerid, COLOR_LIGHTRED, "ACCESS DENIED: {FFFFFF}คุณต้องเข้าสู่ระบบก่อนที่จะใช้คำสั่ง");
		return 0;
	}
    else if (!(flags & playerData[playerid][pCMDPermission]) && flags)
    {
        SendClientMessage(playerid, COLOR_LIGHTRED, "ACCESS DENIED: {FFFFFF}คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");
        return 0;
    }

	printf("[CMD LOG] [%d] %s: /%s %s", playerid, ReturnPlayerName(playerid), cmd, params);

    return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if(result == -1)
    {
        SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR: {FFFFFF}เกิดข้อผิดพลาดในการใช้คำสั่ง");
        return 0;
    }

	if(flags) { // Permission CMD
		if (flags & playerData[playerid][pCMDPermission])
		{
			Log(adminactionlog, INFO, "%s: /%s %s", ReturnPlayerName(playerid), cmd, params);
		}
	}
    return 1;
}
stock IsWindowedVehicle(vehicleid)
{
	static const g_aWindowStatus[] = {
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1,
	    1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1,
	    1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1,
		1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0
	};
	new modelid = GetVehicleModel(vehicleid);

    if (modelid < 400 || modelid > 611)
        return 0;

    return (g_aWindowStatus[modelid - 400]);
}
forward SendClientMessageA(playerid,color,text[]);
public SendClientMessageA(playerid,color,text[])
{
	new safetxt[128];
	format(safetxt,sizeof(safetxt),"%s",text);
	if(strlen(safetxt) <= 88) { SendClientMessage(playerid,color,text); }
	else {

	    new texts[128];
	    strmid(texts,safetxt,88,256);
   		strins(safetxt, "...", 88, 1);
		strdel(safetxt, 89, strlen(safetxt));
		SendClientMessage(playerid,color,safetxt);
		SendClientMessage(playerid,color,texts);

	}
}
forward SendVehicleICMessage(playerid, vehicleid, str[]);
public SendVehicleICMessage(playerid, vehicleid, str[])
{
	new pos = strfind(str,":");
	new lang[128];
	new name[64];
	format(lang,128,"",name);
	strins(str,lang,(pos + 1),256);
	foreach (new i : Player) if (GetPlayerVehicleID(i) == vehicleid)
	{

		SendClientMessageA(i,0xFFFFFFFF,str);

	}

}
stock IsWindowsOpen(vehicleid)
{
	new wdriver, wpassenger, wbackleft, wbackright;
	GetVehicleParamsCarWindows(vehicleid, wdriver, wpassenger, wbackleft, wbackright);
	if(wdriver == 0 || wpassenger== 0 || wbackleft== 0 || wbackright == 0) return 1;
	if(IsABike(vehicleid)) return 1;
	return 0;
}
public OnPlayerText(playerid, text[]) {
	if(!BitFlag_Get(gPlayerBitFlag[playerid], IS_LOGGED))
		return 0;

	if(gIsDeathMode{playerid} || gIsInjuredMode{playerid})
	{
	    SendClientMessage(playerid, COLOR_GRAD1, " คุณสลบและไม่สามารถพูดได้");
		return 0;
	}

	if(!BitFlag_Get(gPlayerBitFlag[playerid], IS_LOGGED))
		return 0;

	if(gIsDeathMode{playerid} || gIsInjuredMode{playerid})
	{
	    SendClientMessage(playerid, COLOR_GRAD1, " คุณสลบและไม่สามารถพูดได้");
		return 0;
	}
	//NORMAL TALK
	/*static str[128];
	format(str, sizeof(str), "%s พูดว่า: %s", ReturnPlayerName(playerid), text);
	ProxDetector(playerid, 20.0, str);*/
	SetPlayerChatBubble(playerid,sprintf("\" %s \"", text), 0xE57178AA,20.0,10000);
	new str[128];
    if (IsPlayerInAnyVehicle(playerid) && IsWindowedVehicle(GetPlayerVehicleID(playerid)) && !IsWindowsOpen(GetPlayerVehicleID(playerid)))
    {

		format(str,sizeof(str),"{FFFFFF}[ภายใน] %s พูดว่า: %s", ReturnRealName(playerid), text);
		SendVehicleICMessage(playerid,GetPlayerVehicleID(playerid), str);
	}
	else
	{
	    ProxDetector(playerid, 20.0, sprintf("%s พูดว่า: %s", ReturnRealName(playerid), text));
	}
	/*SendNearbyMessage(playerid, 20.0, -1, "{%06x}[%d] %s"EMBED_WHITE": %s", GetPlayerColor(playerid) >>> 8, playerid, ReturnRealName(playerid), text);
	ChatAnimation(playerid, strlen(text));*/


	ChatAnimation(playerid, strlen(text));
	return 0;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if( PRESSED(KEY_FIRE)) {
		if (IsPlayerAtEntranceEntrance(playerid)) {
			PlayerEnterNearestEntrance(playerid);
		}
		else if (IsPlayerAtEntranceExit(playerid)) {
			PlayerExitEntrance(playerid);
		}
		else if (IsPlayerAtHouseEntrance(playerid)) {
			PlayerEnterNearestHouse(playerid);
		}
		else if (IsPlayerAtHouseExit(playerid)) {
			PlayerExitHouse(playerid);
		}
		else if (IsPlayerAtBusinessEntrance(playerid)) {
			PlayerEnterNearestBusiness(playerid);
		}
		else if (IsPlayerAtBusinessExit(playerid)) {
			PlayerExitBusiness(playerid);
		}
		// Weed Farm
		else if (IsPlayerInRangeOfPoint(playerid, 2.5, -2315.3125,-122.0207,35.3125)) {
			SetPlayerPos(playerid, -2315.4067,-118.4732,35.3203);
		}
		else if (IsPlayerInRangeOfPoint(playerid, 2.5, -2315.4067,-118.4732,35.3203)) {
			SetPlayerPos(playerid, -2315.3125,-122.0207,35.3125);
		}
		// Black Market
		
		/*else if (IsPlayerInRangeOfPoint(playerid, 2.5, 2256.0554,-2387.9089,17.4219)) {
	
			new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
			if (factionType == 1)
				return SendClientMessage(playerid, COLOR_GRAD2,"   เจ้าหน้าที่ตำรวจไม่สามารถเข้าไปในตลาดมืดได้ !");

			if (playerData[playerid][pWarrants])
				return SendClientMessage(playerid, COLOR_GRAD2,"   คุณมีคดีความอยู่ไม่สามารถเข้าไปในตลาดมืดได้ !");

			if (playerData[playerid][pLevel] < 7)
				return SendClientMessage(playerid, COLOR_GRAD1, "คุณมีประสบการณ์ไม่พอที่จะเข้าสู่โลกใต้ดิน (เลเวลตั้งแต่ 7 ขึ้นไปเท่านั้น)");

			SetPlayerPos(playerid, -2540.4724,64.3077,-20.9953);
		}
		else if (IsPlayerInRangeOfPoint(playerid, 2.5, -2540.4724,64.3077,-20.9953)) {
			SetPlayerPos(playerid, 2256.0554,-2387.9089,17.4219);
		}*/
		

	}
	
	if((oldkeys & KEY_SPRINT && newkeys & KEY_JUMP) && !IsPlayerInAnyVehicle(playerid))
    {
        PlayerJump[playerid] ++;
        SetTimerEx("JumpReset", 4000, false, "i", playerid);
        if(PlayerJump[playerid] == 3)
        {
            ApplyAnimation(playerid, "GYMNASIUM", "gym_jog_falloff",4.1, 0, 1, 1, 0, 0);
            SendClientMessage(playerid, 0xE9967A, "{E9967A}[ERROR]{FFFFFF}:ขาพริกเนื่องจากกระโดดมากเกินไป !");
            SetTimerEx("Jump", 4000, false, "i", playerid);
        }
    }
	


	/*	if((oldkeys & KEY_SPRINT && newkeys & KEY_JUMP) && !IsPlayerInAnyVehicle(playerid)) //bunnyhop
   	 {
        PlayerJump[playerid] ++;
        SetTimerEx("JumpReset", 4000, false, "i", playerid);
        if(PlayerJump[playerid] == 3)
        {
            ApplyAnimation(playerid, "GYMNASIUM", "gym_jog_falloff",4.1, 0, 1, 1, 0, 0);
            SendClientMessage(playerid, 0xE9967A, "{E9967A}[ERROR]{FFFFFF}: ขาพริกเนื่องจากกระโดดมากเกินไป !");
            SetTimerEx("Jump", 4000, false, "i", playerid);
       		 }
    	}

       return 1;
	}
*/
    
    if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == 2)
	{
	   	if(!IsAPlane(GetPlayerVehicleID(playerid)) && !IsABoat(GetPlayerVehicleID(playerid)))
	   	{
	      	new vid = GetPlayerVehicleID(playerid);
			if(newkeys & ( KEY_LOOK_LEFT ) && newkeys & ( KEY_LOOK_RIGHT ))
			{
		    	if(Indicators_xqz[vid][2] /*|| Indicators_xqz[vid][5]*/) DestroyObject(Indicators_xqz[vid][5]),DestroyObject(Indicators_xqz[vid][2]), DestroyObject(Indicators_xqz[vid][3]),Indicators_xqz[vid][2]=0;
            	else if(Indicators_xqz[vid][0] /*|| Indicators_xqz[vid][4]*/) DestroyObject(Indicators_xqz[vid][4]),DestroyObject(Indicators_xqz[vid][0]), DestroyObject(Indicators_xqz[vid][1]),Indicators_xqz[vid][0]=0;
				else
				SetVehicleIndicator(vid,1,1);
				return 1;
			}
			if(newkeys & KEY_LOOK_RIGHT)
			{
	  		  	if(Indicators_xqz[vid][0] /*|| Indicators_xqz[vid][4]*/) DestroyObject(Indicators_xqz[vid][4]), DestroyObject(Indicators_xqz[vid][0]), DestroyObject(Indicators_xqz[vid][1]),Indicators_xqz[vid][0]=0;
      	      	else if(Indicators_xqz[vid][2]/*|| Indicators_xqz[vid][5]*/) DestroyObject(Indicators_xqz[vid][5]), DestroyObject(Indicators_xqz[vid][2]), DestroyObject(Indicators_xqz[vid][3]),Indicators_xqz[vid][2]=0;
				else
				SetVehicleIndicator(vid,0,1);
				SetTimerEx("rTimer", 4000, false, "d", playerid);
			}
			if(newkeys & KEY_LOOK_LEFT)
			{
			    if(Indicators_xqz[vid][2]/*|| Indicators_xqz[vid][5]*/) DestroyObject(Indicators_xqz[vid][5]),DestroyObject(Indicators_xqz[vid][2]), DestroyObject(Indicators_xqz[vid][3]),Indicators_xqz[vid][2]=0;
      	      	else if(Indicators_xqz[vid][0] /*|| Indicators_xqz[vid][4]*/) DestroyObject(Indicators_xqz[vid][4]),DestroyObject(Indicators_xqz[vid][0]), DestroyObject(Indicators_xqz[vid][1]),Indicators_xqz[vid][0]=0;
				else
				SetVehicleIndicator(vid,1,0);
				SetTimerEx("lTimer", 4000, false, "d", playerid);
			}
		}
	}
	/*if(PRESSED(KEY_SPRINT) || PRESSED(KEY_JUMP))
	{
	    if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !gIsDeathMode{playerid} && !gIsInjuredMode{playerid})
	    {
	    	for(new i = 0; i != MAX_DAMAGES; ++i)
			{
			    if(DamageData[playerid][i][dShotType] == 7 || DamageData[playerid][i][dShotType] == 8)
				{
			        if(random(10) <= 1 && PRESSED(KEY_SPRINT)) return 1;
					
			        ClearAnimations(playerid);
		    		ApplyAnimationEx(playerid, "PED", "FALL_COLLAPSE", 4.1, 0, 1, 1, 0, 0, 1);
		    		LegDelay[playerid] = 5;
				}
			}
		}
	}*/

    else if(PRESSED(KEY_WALK)) {
		if(playerData[playerid][pSpectating] != INVALID_PLAYER_ID && (playerData[playerid][pAdmin] >= 1)) {
		    TogglePlayerSpectating(playerid, false);
			return 1;
		}
    }
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(playerData[playerid][pAdmin] >= 3) {
		if(playerData[playerid][pSpectating] == INVALID_PLAYER_ID) {
			GetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
			playerData[playerid][pInterior] = GetPlayerInterior(playerid);
			playerData[playerid][pVWorld] = GetPlayerVirtualWorld(playerid);
		}
		playerData[playerid][pSpectating] = clickedplayerid;
		TogglePlayerSpectating(playerid, true);
		
		SetPlayerInterior(playerid, GetPlayerInterior(clickedplayerid));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(clickedplayerid));

		if(IsPlayerInAnyVehicle(clickedplayerid)) {
			PlayerSpectateVehicle(playerid, GetPlayerVehicleID(clickedplayerid));
		}
		else {
			PlayerSpectatePlayer(playerid, clickedplayerid);
		}
	}
	return 1;
}
stock SetVehicleIndicator(vehicleid, leftindicator=0, rightindicator=0)
{
	if(!leftindicator & !rightindicator) return false;
	new Float:_vX[2], Float:_vY[2], Float:_vZ[2];
	if(rightindicator)
	{
	    if(IsTrailerAttachedToVehicle(vehicleid))
	    {
	        new omg = GetVehicleModel(GetVehicleTrailer(vehicleid));
            GetVehicleModelInfo(omg, VEHICLE_MODEL_INFO_SIZE, _vX[0], _vY[0], _vZ[0]);
 			Indicators_xqz[vehicleid][4] = CreateObject(19294, 0, 0, 0,0,0,0);
			AttachObjectToVehicle(Indicators_xqz[vehicleid][4], GetVehicleTrailer(vehicleid),  _vX[0]/2.4, -_vY[0]/3.35, -1.0 ,0,0,0);
		}
	    GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, _vX[0], _vY[0], _vZ[0]);
 		Indicators_xqz[vehicleid][0] = CreateObject(19294, 0, 0, 0,0,0,0);
		AttachObjectToVehicle(Indicators_xqz[vehicleid][0], vehicleid,  _vX[0]/2.23, _vY[0]/2.23, 0.1 ,0,0,0);
 		Indicators_xqz[vehicleid][1] = CreateObject(19294, 0, 0, 0,0,0,0);
		AttachObjectToVehicle(Indicators_xqz[vehicleid][1], vehicleid,  _vX[0]/2.23, -_vY[0]/2.23, 0.1 ,0,0,0);
	}
	if(leftindicator)
	{
	    if(IsTrailerAttachedToVehicle(vehicleid))
	    {
	    	new omg = GetVehicleModel(GetVehicleTrailer(vehicleid));
            GetVehicleModelInfo(omg, VEHICLE_MODEL_INFO_SIZE, _vX[0], _vY[0], _vZ[0]);
 			Indicators_xqz[vehicleid][5] = CreateObject(19294, 0, 0, 0,0,0,0);
			AttachObjectToVehicle(Indicators_xqz[vehicleid][5], GetVehicleTrailer(vehicleid),  -_vX[0]/2.4, -_vY[0]/3.35, -1.0 ,0,0,0);
		}
	    GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, _vX[0], _vY[0], _vZ[0]);
 		Indicators_xqz[vehicleid][2] = CreateObject(19294, 0, 0, 0,0,0,0);
		AttachObjectToVehicle(Indicators_xqz[vehicleid][2], vehicleid,  -_vX[0]/2.23, _vY[0]/2.23, 0.1 ,0,0,0);
 		Indicators_xqz[vehicleid][3] = CreateObject(19294, 0, 0, 0,0,0,0);
		AttachObjectToVehicle(Indicators_xqz[vehicleid][3], vehicleid,  -_vX[0]/2.23, -_vY[0]/2.23, 0.1 ,0,0,0);
	}
	return 1;
}
forward lTimer(playerid);
public lTimer(playerid)
{
    new vid = GetPlayerVehicleID(playerid);
    if(Indicators_xqz[vid][2]/*|| Indicators_xqz[vid][5]*/) DestroyObject(Indicators_xqz[vid][5]),DestroyObject(Indicators_xqz[vid][2]), DestroyObject(Indicators_xqz[vid][3]),Indicators_xqz[vid][2]=0;
   	else if(Indicators_xqz[vid][0] /*|| Indicators_xqz[vid][4]*/) DestroyObject(Indicators_xqz[vid][4]),DestroyObject(Indicators_xqz[vid][0]), DestroyObject(Indicators_xqz[vid][1]),Indicators_xqz[vid][0]=0;
	return 1;
}
forward rTimer(playerid);
public rTimer(playerid)
{
    new vid = GetPlayerVehicleID(playerid);
    if(Indicators_xqz[vid][0] /*|| Indicators_xqz[vid][4]*/) DestroyObject(Indicators_xqz[vid][4]), DestroyObject(Indicators_xqz[vid][0]), DestroyObject(Indicators_xqz[vid][1]),Indicators_xqz[vid][0]=0;
   	else if(Indicators_xqz[vid][2]/*|| Indicators_xqz[vid][5]*/) DestroyObject(Indicators_xqz[vid][5]), DestroyObject(Indicators_xqz[vid][2]), DestroyObject(Indicators_xqz[vid][3]),Indicators_xqz[vid][2]=0;
	return 1;
}
Dialog:ShowOnly(playerid, response, listitem, inputtext[]) {
	playerid = INVALID_PLAYER_ID;
	response = 0;
	listitem = 0;
	inputtext[0] = '\0';
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid) {

	if(pickupid == SFCityChangePickup || pickupid == LSCityChangePickup) {
		Mobile_GameTextForPlayer(playerid, "~n~~w~/changeorigin", 8000, 4);
		return 1;
	}
	if(pickupid == SFNewsPickup || pickupid == LSNewsPickup) {
		Mobile_GameTextForPlayer(playerid, "~n~~w~/newspaper", 8000, 4);
		return 1;
	}
	else {
		for (new i = 0; i != 2; i ++) if (DollaPickup[i] == pickupid)
		{
			if(playerData[playerid][pPayCheck] > 0)
			{
				new tmp2[128];
				format(tmp2, sizeof(tmp2), "~w~You have just received~n~Your Paycheck: ~g~$%d%d", playerData[playerid][pPayCheck]);
				Mobile_GameTextForPlayer(playerid, tmp2, 5000, 4);
				GivePlayerMoneyEx(playerid, playerData[playerid][pPayCheck]);
				playerData[playerid][pPayCheck] = 0;
				PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
			}
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid) {
	// DisablePlayerCheckpoint(playerid);
	#if defined SV_DEBUG
		printf("callbacks.pwn: OnPlayerEnterCheckpoint(playerid %d)", playerid);
	#endif

	if (gPlayerCheckpoint{playerid} && !PLAYER_IN_RACE{playerid}) {
		DisablePlayerCheckpoint(playerid);
		gPlayerCheckpoint{playerid} = false;
	}
	return 1;
}


Main_SetPlayerDefaultSpawn(playerid) {
	if (playerData[playerid][pSpawnPoint] == 2) {
		SetPlayerPos(playerid, 1642.2277,-2332.5630,13.5469); //LS
		SetPlayerFacingAngle(playerid, 90.6993);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		playerData[playerid][pInterior] = 0;
		playerData[playerid][pVWorld] = 0;
	}
	else {
		SetPlayerPos(playerid, 850.0825,-1384.1646,-0.5015);//SF
		SetPlayerFacingAngle(playerid, 267.0031);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		playerData[playerid][pInterior] = 0;
		playerData[playerid][pVWorld] = 0;
	}
}

/*forward CuTrue(playerid);
public CuTrue(playerid)
{
	new query[256];
 	format(query, sizeof(query), "SELECT refill FROM cutrue WHERE account_id=%d and refill='NO'", PlayerInfo[playerid][pSQLID]);
	mysql_query(query);
	mysql_store_result();
	if (mysql_num_rows()!=0)
	{
		format(query, sizeof(query), "SELECT SUM(refill_amount) as sumamount FROM cutrue WHERE account_id=%d and refill='NO'", PlayerInfo[playerid][pSQLID]);
		mysql_query(query);
		new CuTrueRow[256];
		new CuTruePoint;
		mysql_store_result();
		mysql_fetch_row(CuTrueRow);
		printf("%s",CuTrueRow);
		CuTruePoint = strval(CuTrueRow);
		if(CuTruePoint != 0)
		{
	 		PlayerInfo[playerid][pPoint] += CuTruePoint; // pPoint ???????????????????????????
	 		CuTruePoint = 0;
	 		MySQLCheckConnection();
			format(query, MAX_STRING, "UPDATE players SET ");
			MySQLUpdatePlayerInt(query, PlayerInfo[playerid][pSQLID], "Point", PlayerInfo[playerid][pPoint]); // Points ?????????? Field / pPoint ?????????? ?????????????????
			MySQLUpdateFinish(query, PlayerInfo[playerid][pSQLID]);
			format(query, sizeof(query), "UPDATE cutrue set refill='YES' WHERE account_id=%d", PlayerInfo[playerid][pSQLID]);
			mysql_query(query);
		}
	}
	return 1;
}*/

forward Jump(playerid);
public Jump(playerid)
{
    PlayerJump[playerid] = 0;
    ClearAnimations(playerid);
    return 1;
}

forward JumpReset(playerid);
public JumpReset(playerid)
{
    PlayerJump[playerid] = 0;
    return 1;
}
