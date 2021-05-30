
/*
//--------------------------------[AUTH.PWN]--------------------------------
*/

#include <YSI\y_hooks>

static
    loginAttempt[MAX_PLAYERS], 
    g_MysqlRaceCheck[MAX_PLAYERS];

hook OnPlayerDisconnect(playerid, reason) {

 	static const szDisconnectReason[3][] = {"หลุด","ออกจากเกมส์","ถูกเตะ"};
    ProxDetector(playerid, 20.0, sprintf("*** %s ออกจากเซิร์ฟเวอร์ (%s)", ReturnPlayerName(playerid), szDisconnectReason[reason]));

	if(reason == 0) 
		playerData[playerid][pTimeout] = gettime();

	loginAttempt[playerid]=0;
	g_MysqlRaceCheck[playerid]++;
	OnAccountUpdate(playerid);
}

hook OnGameModeInit()
{
	systemVariables[regisStatus] = 0; //0=open, 1=close	
	systemVariables[PrisonStatus] = 0; //0=open, 1=close
	//ConnectNPC("101ClownTHDriver","Train");
	
/*	SetGameModeText("Armin`s Script");
	ConnectNPC("Crazy_Train_Driver","Train");
	MyFirstNPCVehicle = AddStaticVehicle(538, -1943.0624, 158.9263, 25.7186, 358.2109, 3, 252);
	ShowPlayerMarkers(1);
	ShowNameTags(1);
	AllowAdminTeleport(1);

	AddPlayerClass(265,1958.3783,1343.1572,15.3746,270.1425,0,0,0,0,-1,-1);*/
}

hook OnPlayerRequestClass(playerid, classid)
{
	if (!BitFlag_Get(gPlayerBitFlag[playerid], IS_LOGGED))
	{
		GameTextForPlayer(playerid, "~w~Welcome to~n~~r~San Andreas Roleplay!!", 5000, 1);
		PlayerPlaySound(playerid, 1187, 0.0, 0.0, 0.0);
	    TogglePlayerSpectating(playerid, true);

		new existCheck[129];
		mysql_format(dbCon, existCheck, sizeof(existCheck), "SELECT * FROM bannedlist WHERE IpAddress = '%e'", ReturnIP(playerid));
		mysql_tquery(dbCon, existCheck, "CheckBanList", "i", playerid);
	}
	else {
		SpawnPlayer(playerid);
	}
	return 1;
}

forward CheckBanList(playerid);
public CheckBanList(playerid)
{	
	if(!cache_num_rows())
	{
		defer LoginScreen(playerid);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "ไอพี \"%s\" ของคุณถูกแบนออกจากเซิร์ฟเวอร์", ReturnIP(playerid));
		SendClientMessage(playerid, COLOR_YELLOW, "คุณอาจส่งคำร้องเพื่อขอปลดแบนในฟอรั่มของเรา"); 
		return KickEx(playerid);
	}
	return 1;
}

timer LoginScreen[400](playerid)
{
	if(IsPlayerConnected(playerid)) {

		SetPlayerVirtualWorld(playerid, playerid + 8000);
		InterpolateCameraPos(playerid, 2028.2209,-1838.0173,43.6606, 2101.0833,-1730.2336,45.9187, 200000, CAMERA_MOVE);
		InterpolateCameraLookAt(playerid, 2168.0056,-1707.5989,36.5969, 2092.0496,-1847.0476,29.6490, 200000, CAMERA_MOVE);

		/*InterpolateCameraPos(playerid, -2002.1097,-111.4101,55.7109, -1997.8848,1083.2710,75.5703, 60000, CAMERA_MOVE);
		InterpolateCameraLookAt(playerid, -2007.1011,-20.4438,34.9591, -1978.8986,1118.1587,53.1450, 60000, CAMERA_MOVE);*/

		if (IsRandomName(ReturnPlayerName(playerid)) || !IsValidRpName(ReturnPlayerName(playerid))) {
			ShowChangeUsernameDialog(playerid);
		}
		else {
			new
				query[80];
			mysql_format(dbCon, query, sizeof(query), "SELECT `id` FROM `players` WHERE `Name` = '%e' LIMIT 1", ReturnPlayerName(playerid));
			mysql_pquery(dbCon, query, "isAccountExist", "d", playerid);
		}
	}
}

ShowChangeUsernameDialog(playerid) {
	return Dialog_Show(playerid, DIALOG_CHANGE_NAME, DIALOG_STYLE_INPUT, "เลือกชื่อผู้ใช้ของคุณ:",""EMBED_DIALOG"ชื่อของคุณถูกสุ่มขึ้นมาหรือไม่ถูกต้องตามรูปแบบ ดังนั้นให้กรอก "EMBED_ORANGE"ชื่อตัวละคร"EMBED_DIALOG" ใหม่ที่นี่:\n\nรูปแบบ: "EMBED_ORANGE"Firstname_Lastname"EMBED_DIALOG" (ชื่อและนามสกุลตัวแรกใช้"EMBED_LIGHTRED"พิมพ์ใหญ่"EMBED_DIALOG"\nนอกนั้นใช้ตัวพิมพ์เล็ก และมีขีดเส้นทางระหว่างชื่อและนามสกุล)","เปลี่ยน","ออก");
}

ShowLoginDialog(playerid) {
	return Dialog_Show(playerid, D_AccountLogin, DIALOG_STYLE_PASSWORD, "ยินดีต้อนรับเข้าสู่ San Andreas Roleplay",""EMBED_DIALOG"สวัสดี %s "EMBED_GREENMONEY"(ลงทะเบียนแล้ว)\n\n"EMBED_DIALOG"โปรดกรอกรหัสผ่านของคุณด้านล่างนี้เพื่อเข้าสู่ระบบ:","เข้าสู่ระบบ","กลับ", ReturnPlayerName(playerid));
    //SetPlayerToCameraSV(playerid);
}

ShowRegisterDialog(playerid) {
	return Dialog_Show(playerid, D_AccountRegister, DIALOG_STYLE_INPUT, "ยินดีต้อนรับเข้าสู่ San Andreas Roleplay",""EMBED_DIALOG"สวัสดี %s "EMBED_LIGHTRED"(ยังไม่ได้ลงทะเบียน)\n\n"EMBED_DIALOG"โปรดกรอกรหัสผ่านของคุณด้านล่างนี้เพื่อลงทะเบียน:\n\nรหัสผ่านต้องมีความยาวตั้งแต่ "EMBED_LIGHTRED"6"EMBED_DIALOG" ตัวอักษร","ลงทะเบียน","กลับ", ReturnPlayerName(playerid));
  //  SetPlayerToCameraSV(playerid);
}

forward isAccountExist(playerid);
public isAccountExist(playerid)
{
	new rows;
	cache_get_row_count(rows);
	GetPlayerIp(playerid, playerData[playerid][pIP], 16);

	if (rows) {
		cache_get_value_name_int(0, "id", playerData[playerid][pSID]);

		new
			logQuery[256]
		;
		mysql_format(dbCon, logQuery, sizeof(logQuery), "SELECT * FROM bannedlist WHERE CharacterDBID = %i", playerData[playerid][pSID]);
		mysql_tquery(dbCon, logQuery, "Query_CheckBannedAccount", "i", playerid); 
		return 1;
	}
	else
	{
		if (systemVariables[regisStatus] == 0) //0=open, 1=close
		{
			ShowRegisterDialog(playerid);
		}
		else if (systemVariables[regisStatus] == 1) //0=open, 1=close
		{
			SendClientMessage(playerid, COLOR_YELLOW, "ขณะนี้ระบบปิดการสมัครสมาชิกภายในเซิร์ฟเวอร์, โปรดรอจนกว่าเซิร์ฟเวอร์จะเปิดรับสมัครผู้เล่นใหม่");
			KickEx(playerid);
		}
	}
	return 1;
}

forward Query_CheckBannedAccount(playerid);
public Query_CheckBannedAccount(playerid)
{
	if(!cache_num_rows())
	{
		ShowLoginDialog(playerid);
	}
	else
	{
		new rows;
		cache_get_row_count(rows); 
		
		new banDate[90], banner[32], reason[128], str[128];
		
		cache_get_value_name(0, "Date", banDate, 90);
		cache_get_value_name(0, "BannedBy", banner, 32);
		cache_get_value_name(0, "Reason", reason, 128);
	
		SendClientMessageEx(playerid, COLOR_YELLOW, "บัญชี \"%s\" ของคุณถูกแบนออกจากเซิร์ฟเวอร์", ReturnPlayerName(playerid));
		SendClientMessage(playerid, COLOR_YELLOW, "คุณอาจส่งคำร้องเพื่อขอปลดแบนในฟอรั่มของเรา"); 

		format(str, sizeof(str), "วันที่: %s\nแบนโดย: %s\nสาเหตุ: %s", banDate, banner, reason);
		Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "รายละเอียดการแบน", str, "ทราบ", "");
		return KickEx(playerid);
	}
	return 1;
}


Dialog:DIALOG_CHANGE_NAME(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return Kick(playerid);

	if (IsValidRpName(inputtext)) {

		switch (SetPlayerName(playerid, inputtext)) {
			case -1: {
				SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR: "EMBED_WHITE"ชื่อผู้ใช้นี้ถูกใช้แล้ว");
				ShowChangeUsernameDialog(playerid);
			}
			default: {
				new
					query[80];
				mysql_format(dbCon, query, sizeof(query), "SELECT `id` FROM `players` WHERE `Name` = '%e' LIMIT 1", ReturnPlayerName(playerid));
				mysql_pquery(dbCon, query, "isAccountExist", "d", playerid);
			}
		}
	}
	else {
		ShowChangeUsernameDialog(playerid);
	}
	return 1;
}

Dialog:D_AccountLogin(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return ShowChangeUsernameDialog(playerid);

	else if (isnull(inputtext))
	    return ShowLoginDialog(playerid);

	else
	{
		new
			query[256],
			buffer[129];

		WP_Hash(buffer, sizeof(buffer), inputtext);

		mysql_format(dbCon, query, sizeof(query), "SELECT * FROM `players` WHERE `id` = %d AND `Password` = '%e'", playerData[playerid][pSID], buffer);
		mysql_tquery(dbCon, query, "loginAccount", "i", playerid);
	}
	return 1;
}

forward loginAccount(playerid);
public loginAccount(playerid)
{
    new rows;
    cache_get_row_count(rows);
    if (!rows) {
        if(loginAttempt[playerid]==5) {
            SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR: "EMBED_WHITE"คุณกรอกรหัสผ่านผิดมากเกินไป");
            KickEx(playerid);
            return 1;
        }
        loginAttempt[playerid]++;
		Dialog_Show(playerid, D_AccountLogin, DIALOG_STYLE_PASSWORD, "ยินดีต้อนรับเข้าสู่ San Andreas Roleplay",""EMBED_RED"ERROR:"EMBED_DIALOG" รหัสผ่านไม่ถูกต้อง\n\n"EMBED_DIALOG"โปรดกรอกรหัสผ่านของคุณด้านล่างนี้เพื่อเข้าสู่ระบบ:\n\n"EMBED_RED"Failed to login please try again (%d/%d)","เข้าสู่ระบบ","กลับ", 5 - loginAttempt[playerid], 5);
	}
    else
    {
		g_MysqlRaceCheck[playerid]++;
		new str[256];
		format(str, 256, "SELECT *,(CASE WHEN DonateExp = '00-00-00 00:00:00' OR DATEDIFF(NOW(),DonateExp) >= 0 THEN 0 ELSE DonateRank END) as DonateRank FROM players WHERE id = %d", playerData[playerid][pSID]);
		mysql_tquery(dbCon, str, "OnPlayerLogin", "id", playerid, g_MysqlRaceCheck[playerid]);
    }
	return 1;
}

Dialog:D_AccountRegister(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return ShowChangeUsernameDialog(playerid);

	else if (isnull(inputtext) || strlen(inputtext) < 6)
	    return ShowRegisterDialog(playerid);

	else
	{

		new
			query[256],
			buffer[129];

		WP_Hash(buffer, sizeof(buffer), inputtext);

		mysql_format(dbCon, query, sizeof(query), "INSERT INTO `players`(`Name`, `Password`) VALUES('%e', '%e')", ReturnPlayerName(playerid), buffer);
		mysql_tquery(dbCon, query, "registerAccount", "i", playerid);
	}
	return 1;
}

forward registerAccount(playerid);
public registerAccount(playerid) {
	if (cache_affected_rows()) {
		playerData[playerid][pSID]=cache_insert_id();
		ShowLoginDialog(playerid);
	}
	return 1;
}

ResetStatistics(playerid)
{
		gPlayerBitFlag[playerid] = PlayerFlags:0;

		for (new i=0;i!=10;i++) {
			playerData[playerid][pDrugAddiction][i]=0;
		}
		playerData[playerid][pDrugAddict] = 0;
		playerData[playerid][pDrugAddictStrength] = 0;

		playerData[playerid][pSID] = -1;
		playerData[playerid][pPnumber] = 0;
		playerData[playerid][pCreated] = false;
		playerData[playerid][pMedicBill] = false;
		playerData[playerid][pLevel] = 0;
 	    playerData[playerid][pModel] = 1;
		playerData[playerid][pWear] = 0;
 	    playerData[playerid][pCash] = 0;
		playerData[playerid][pScore] = 0;
		playerData[playerid][pPlayingHours] = 0;
		playerData[playerid][pDonateRank] = 0;
		playerData[playerid][pSpawnType] = 0;
		playerData[playerid][pSpawnPoint] = 0;
		playerData[playerid][pSHealth] = 100; 
		playerData[playerid][pAdmin] = 0;
		playerData[playerid][pTalkStyle] = 0;
		playerData[playerid][pFaction] = -1;
		playerData[playerid][pFactionRank] = 0;
		playerData[playerid][pHouseKey] = -1;
		playerData[playerid][pBusinessKey] = -1;
		playerData[playerid][pExp] = 0;
		playerData[playerid][pAccount] = 0;
		playerData[playerid][pSavingsCollect] = 0;
		playerData[playerid][pSavings] = 0;
		playerData[playerid][pPayDayHad] = 0;
		playerData[playerid][pPayCheck] = 0;
		playerData[playerid][pPayDay] = 0;
		playerData[playerid][pPUpgrade] = 0;
		playerData[playerid][pRespawnPerks] = 0;
		playerData[playerid][pItemOOC] = 0;
		playerData[playerid][pItemGasCan] = 0;
		playerData[playerid][pTimeout] = 0;
		playerData[playerid][pCarLic] = false;
		playerData[playerid][pVehiclePerks] = 0;
		playerData[playerid][pJob] = 0;
		playerData[playerid][pSideJob] = 0;
		playerData[playerid][pContractTime] = 0;
		playerData[playerid][pFishes] = 0;
		playerData[playerid][pFishingPerks] = 0;
		playerData[playerid][pPoint] = 0;
		playerData[playerid][pJailed] = 0;
		playerData[playerid][pJailTime] = 0;
		playerData[playerid][pArrested] = 0;
		playerData[playerid][pWarrants] = 0;
		playerData[playerid][pHunger] = 0;

		playerData[playerid][pSeedWeed] = 0;
		playerData[playerid][pWatering] = false;

		playerData[playerid][pJobRank] = 0;

		playerData[playerid][pRadio] = 0;
		playerData[playerid][pRChannel] = 0;
		playerData[playerid][pRSlot] = 0;
		playerData[playerid][pRAuth] = 0;

		playerData[playerid][pATM] = 0; 
		playerData[playerid][pNameChangeFree] = 0;
		playerData[playerid][pRMoney] = 0;

		playerData[playerid][pIrons] = 0;
		playerData[playerid][pOre] = 0;
		playerData[playerid][pCold] = 0;
		playerData[playerid][pDiamond] = 0;

		playerData[playerid][pLuckyBox] = 0;
		playerData[playerid][pTurismo] = 0;
		playerData[playerid][pCannabis] = 0;
		playerData[playerid][pCPCannabis] = 0;

		playerData[playerid][pGuns][0] = 0;
		playerData[playerid][pGuns][1] = 0;
		playerData[playerid][pGuns][2] = 0;
		playerData[playerid][pGuns][3] = 0;
		playerData[playerid][pGuns][4] = 0;
		playerData[playerid][pGuns][5] = 0;
		playerData[playerid][pGuns][6] = 0;
		playerData[playerid][pGuns][7] = 0;
		playerData[playerid][pGuns][8] = 0;
		playerData[playerid][pGuns][9] = 0;
		playerData[playerid][pGuns][10] = 0;
		playerData[playerid][pGuns][11] = 0;
		playerData[playerid][pGuns][12] = 0;

		playerData[playerid][pAmmo][0] = 0;
		playerData[playerid][pAmmo][1] = 0;
		playerData[playerid][pAmmo][2] = 0;
		playerData[playerid][pAmmo][3] = 0;
		playerData[playerid][pAmmo][4] = 0;
		playerData[playerid][pAmmo][5] = 0;
		playerData[playerid][pAmmo][6] = 0;
		playerData[playerid][pAmmo][7] = 0;
		playerData[playerid][pAmmo][8] = 0;
		playerData[playerid][pAmmo][9] = 0;
		playerData[playerid][pAmmo][10] = 0;
		playerData[playerid][pAmmo][11] = 0;
		playerData[playerid][pAmmo][12] = 0;

		playerData[playerid][pGun1] = 0;
		playerData[playerid][pGun2] = 0;
		playerData[playerid][pGun3] = 0;

		playerData[playerid][pAmmo1] = 0;
		playerData[playerid][pAmmo2] = 0;
		playerData[playerid][pAmmo3] = 0;

		playerData[playerid][pBoombox] = 0;
		playerData[playerid][pPCarkey] = 9999;
		playerData[playerid][pPDupkey] = 9999;

		gPlayerEscapeTime[playerid] = 0;

		gSyncMobile{playerid} = false;
		gIsDeathMode{playerid} = false;
		gIsInjuredMode{playerid} = false;

		gPlayerCheckpoint{playerid} = false;
		pToAccept[playerid] = INVALID_PLAYER_ID;
		tToAccept[playerid] = OFFER_TYPE_NONE;
		prToAccept[playerid] = 0;

		Damage_Reset(playerid);

		gPlayerDrag[playerid] = INVALID_PLAYER_ID;
		playerData[playerid][pSpectating] = INVALID_PLAYER_ID;

		playerData[playerid][pFirstAid] = 0;

		playerData[playerid][pMaterials] = 0;
		playerData[playerid][pCPMaterials] = 0;

		playerData[playerid][pBox] = 0;
		playerData[playerid][pDBox] = 0;

		format(playerData[playerid][pWarning1], 32, "(null)");
		format(playerData[playerid][pWarning2], 32, "(null)");
		format(playerData[playerid][pWarning3], 32, "(null)");

		playerData[playerid][pNMuted] = 0;
		playerData[playerid][pNewbieEnabled] = 0;
		playerData[playerid][pNewbieTimeout] = 0;

		playerData[playerid][pMechanicBox] = 0;

		playerData[playerid][pHelper] = 0;
		format(playerData[playerid][pAdminName], MAX_PLAYER_NAME, "(null)");

		playerData[playerid][pStock] = 0;
		playerData[playerid][pTie] = 0;
		playerData[playerid][pFreezeType] = 0;

		playerData[playerid][pDrag] = -1;

		playerData[playerid][pHungry] = 100;
		playerData[playerid][pThirst] = 100;

		playerData[playerid][pPizza] = 0;
		playerData[playerid][pDrink] = 0;

		playerData[playerid][pChristmas] = 0;
		playerData[playerid][pKeyBox] = 0;
		playerData[playerid][pHair] = 0;
		playerData[playerid][pChristmasx] = 0;

		playerData[playerid][pChangeName] = 0;
}


OnAccountUpdate(playerid, force = false, thread = MYSQL_UPDATE_TYPE_THREAD)
{
	if(BitFlag_Get(gPlayerBitFlag[playerid], IS_LOGGED) || force)
	{
		new query[MAX_STRING];

		MySQLUpdateInit("players", "id", playerData[playerid][pSID], thread); 

		if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING && playerData[playerid][pTimeout] || gIsInjuredMode{playerid})
		{
			GetPlayerHealth(playerid, playerData[playerid][pHealth]);
			playerData[playerid][pInterior] = GetPlayerInterior(playerid);
			playerData[playerid][pVWorld] = GetPlayerVirtualWorld(playerid);

			GetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
			GetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);

			MySQLUpdateFlo(query, "Pos_x", playerData[playerid][pPosX]);
			MySQLUpdateFlo(query, "Pos_y", playerData[playerid][pPosY]);
			MySQLUpdateFlo(query, "Pos_z", playerData[playerid][pPosZ]);
			MySQLUpdateFlo(query, "Pos_a", playerData[playerid][pPosA]);
			MySQLUpdateInt(query, "Inte", playerData[playerid][pInterior]);
			MySQLUpdateFlo(query, "Health",playerData[playerid][pHealth]);
			MySQLUpdateInt(query, "VirtualWorld", playerData[playerid][pVWorld]);
			MySQLUpdateInt(query, "insideHouse", House_GetInsideID(playerid));
			MySQLUpdateInt(query, "insideBiz", Business_GetInsideID(playerid));
		}

		MySQLUpdateBool(query, "Registered",playerData[playerid][pCreated]);
		MySQLUpdateBool(query, "MedicBill",playerData[playerid][pMedicBill]);
		MySQLUpdateInt(query, "Level",playerData[playerid][pLevel]);
 	    MySQLUpdateInt(query, "Model",playerData[playerid][pModel]);
		MySQLUpdateInt(query, "Wear",playerData[playerid][pWear]);
 	    MySQLUpdateInt(query, "Money",playerData[playerid][pCash]);
		MySQLUpdateInt(query, "Score",playerData[playerid][pScore]);
		MySQLUpdateInt(query, "ConnectedTime",playerData[playerid][pPlayingHours]);
		MySQLUpdateInt(query, "DonateRank",playerData[playerid][pDonateRank]);
		MySQLUpdateInt(query, "SpawnType",playerData[playerid][pSpawnType]);
		MySQLUpdateInt(query, "SpawnPoint",playerData[playerid][pSpawnPoint]);
		MySQLUpdateFlo(query, "SHealth",playerData[playerid][pSHealth]);
		MySQLUpdateInt(query, "AdminLevel",playerData[playerid][pAdmin]);
		MySQLUpdateInt(query, "PhoneNr",playerData[playerid][pPnumber]);
		MySQLUpdateInt(query, "TalkStyle",playerData[playerid][pTalkStyle]);
		MySQLUpdateInt(query, "faction_id",playerData[playerid][pFaction]);
		MySQLUpdateInt(query, "faction_rank",playerData[playerid][pFactionRank]);
		MySQLUpdateInt(query, "House",playerData[playerid][pHouseKey]);
		MySQLUpdateInt(query, "Bizz",playerData[playerid][pBusinessKey]);
		MySQLUpdateInt(query, "Respect",playerData[playerid][pExp]);
		MySQLUpdateInt(query, "Bank",playerData[playerid][pAccount]);
		MySQLUpdateInt(query, "SavingsCollect",playerData[playerid][pSavingsCollect]);
		MySQLUpdateInt(query, "Savings",playerData[playerid][pSavings]);
		MySQLUpdateInt(query, "PayDayHad",playerData[playerid][pPayDayHad]);
		MySQLUpdateInt(query, "Paycheck",playerData[playerid][pPayCheck]);
		MySQLUpdateInt(query, "PayDay",playerData[playerid][pPayDay]);
		MySQLUpdateInt(query, "UpgradePoints",playerData[playerid][pPUpgrade]);
		MySQLUpdateInt(query, "RespawnPerks",playerData[playerid][pRespawnPerks]);
		MySQLUpdateInt(query, "ItemOOC",playerData[playerid][pItemOOC]);
		MySQLUpdateInt(query, "ItemGasCan",playerData[playerid][pItemGasCan]);
		MySQLUpdateInt(query, "Timeout",playerData[playerid][pTimeout]);
		MySQLUpdateBool(query, "CarLicense",playerData[playerid][pCarLic]);
		MySQLUpdateInt(query, "VehiclePerks",playerData[playerid][pVehiclePerks]);
		MySQLUpdateInt(query, "Job",playerData[playerid][pJob]);
		MySQLUpdateInt(query, "SideJob",playerData[playerid][pSideJob]);
		MySQLUpdateInt(query, "ContractTime",playerData[playerid][pContractTime]);
		MySQLUpdateInt(query, "Fishes",playerData[playerid][pFishes]);
		MySQLUpdateInt(query, "FishingPerks",playerData[playerid][pFishingPerks]);
		MySQLUpdateInt(query, "Point", playerData[playerid][pPoint]);
		MySQLUpdateInt(query, "Jailed", playerData[playerid][pJailed]);
		MySQLUpdateInt(query, "JailTime", playerData[playerid][pJailTime]);
		MySQLUpdateInt(query, "Arrested", playerData[playerid][pArrested]);
		MySQLUpdateInt(query, "WantedLevel", playerData[playerid][pWarrants]);
		MySQLUpdateFlo(query, "Hunger", playerData[playerid][pHunger]);

		MySQLUpdateInt(query, "SeedWeed", playerData[playerid][pSeedWeed]);
		MySQLUpdateBool(query, "Watering", playerData[playerid][pWatering]);

		MySQLUpdateStr(query, "DrugAddiction", FormatDrugAddiction(playerid));

		MySQLUpdateInt(query, "JobRank", playerData[playerid][pJobRank]);

		MySQLUpdateInt(query, "Radio", playerData[playerid][pRadio]);
		MySQLUpdateInt(query, "RadioChannel", playerData[playerid][pRChannel]);
		MySQLUpdateInt(query, "RadioSlot", playerData[playerid][pRSlot]);
		MySQLUpdateInt(query, "RadioAuth", playerData[playerid][pRAuth]);

		MySQLUpdateInt(query, "ATM", playerData[playerid][pATM]);
		MySQLUpdateInt(query, "NameFree", playerData[playerid][pNameChangeFree]);
		MySQLUpdateInt(query, "RedMoney", playerData[playerid][pRMoney]);

		MySQLUpdateInt(query, "Irons", playerData[playerid][pIrons]);
		MySQLUpdateInt(query, "Ore", playerData[playerid][pOre]);
		MySQLUpdateInt(query, "Cold", playerData[playerid][pCold]);
		MySQLUpdateInt(query, "Diamond", playerData[playerid][pDiamond]);

		MySQLUpdateInt(query, "LuckyBox", playerData[playerid][pLuckyBox]);
		MySQLUpdateInt(query, "Turismo", playerData[playerid][pTurismo]);
		MySQLUpdateInt(query, "Cannabis", playerData[playerid][pCannabis]);
		MySQLUpdateInt(query, "CPCannabis", playerData[playerid][pCPCannabis]);

		MySQLUpdateInt(query, "playerWeapon0", playerData[playerid][pGuns][0]);
		MySQLUpdateInt(query, "playerWeapon1", playerData[playerid][pGuns][1]);
		MySQLUpdateInt(query, "playerWeapon2", playerData[playerid][pGuns][2]);
		MySQLUpdateInt(query, "playerWeapon3", playerData[playerid][pGuns][3]);
		MySQLUpdateInt(query, "playerWeapon4", playerData[playerid][pGuns][4]);
		MySQLUpdateInt(query, "playerWeapon5", playerData[playerid][pGuns][5]);
		MySQLUpdateInt(query, "playerWeapon6", playerData[playerid][pGuns][6]);
		MySQLUpdateInt(query, "playerWeapon7", playerData[playerid][pGuns][7]);
		MySQLUpdateInt(query, "playerWeapon8", playerData[playerid][pGuns][8]);
		MySQLUpdateInt(query, "playerWeapon9", playerData[playerid][pGuns][9]);
		MySQLUpdateInt(query, "playerWeapon10", playerData[playerid][pGuns][10]);
		MySQLUpdateInt(query, "playerWeapon11", playerData[playerid][pGuns][11]);
		MySQLUpdateInt(query, "playerWeapon12", playerData[playerid][pGuns][12]);

		MySQLUpdateInt(query, "playerAmmo0", playerData[playerid][pAmmo][0]);
		MySQLUpdateInt(query, "playerAmmo1", playerData[playerid][pAmmo][1]);
		MySQLUpdateInt(query, "playerAmmo2", playerData[playerid][pAmmo][2]);
		MySQLUpdateInt(query, "playerAmmo3", playerData[playerid][pAmmo][3]);
		MySQLUpdateInt(query, "playerAmmo4", playerData[playerid][pAmmo][4]);
		MySQLUpdateInt(query, "playerAmmo5", playerData[playerid][pAmmo][5]);
		MySQLUpdateInt(query, "playerAmmo6", playerData[playerid][pAmmo][6]);
		MySQLUpdateInt(query, "playerAmmo7", playerData[playerid][pAmmo][7]);
		MySQLUpdateInt(query, "playerAmmo8", playerData[playerid][pAmmo][8]);
		MySQLUpdateInt(query, "playerAmmo9", playerData[playerid][pAmmo][9]);
		MySQLUpdateInt(query, "playerAmmo10", playerData[playerid][pAmmo][10]);
		MySQLUpdateInt(query, "playerAmmo11", playerData[playerid][pAmmo][11]);
		MySQLUpdateInt(query, "playerAmmo12", playerData[playerid][pAmmo][12]);

		MySQLUpdateInt(query, "Gun1", playerData[playerid][pGun1]);
		MySQLUpdateInt(query, "Gun2", playerData[playerid][pGun2]);
		MySQLUpdateInt(query, "Gun3", playerData[playerid][pGun3]);

		MySQLUpdateInt(query, "Ammo1", playerData[playerid][pAmmo1]);
		MySQLUpdateInt(query, "Ammo2", playerData[playerid][pAmmo2]);
		MySQLUpdateInt(query, "Ammo3", playerData[playerid][pAmmo3]);

		MySQLUpdateInt(query, "Boombox", playerData[playerid][pBoombox]);
	
		MySQLUpdateInt(query, "Mats", playerData[playerid][pMaterials]);
		MySQLUpdateInt(query, "CPMats", playerData[playerid][pCPMaterials]);

		MySQLUpdateInt(query, "Box", playerData[playerid][pBox]);
		MySQLUpdateInt(query, "DoubleBox", playerData[playerid][pDBox]);

		MySQLUpdateStr(query, "playerWarning1", playerData[playerid][pWarning1]);
		MySQLUpdateStr(query, "playerWarning2", playerData[playerid][pWarning2]);
		MySQLUpdateStr(query, "playerWarning3", playerData[playerid][pWarning3]);

		MySQLUpdateInt(query, "MechanicBox", playerData[playerid][pMechanicBox]);

		MySQLUpdateInt(query, "Helper", playerData[playerid][pHelper]);
		MySQLUpdateStr(query, "AdminName", playerData[playerid][pAdminName]);

		MySQLUpdateInt(query, "Stock", playerData[playerid][pStock]);
		MySQLUpdateInt(query, "Tie", playerData[playerid][pTie]);

		MySQLUpdateFlo(query, "Hungry", playerData[playerid][pHungry]);
		MySQLUpdateFlo(query, "Thirst", playerData[playerid][pThirst]);

		MySQLUpdateInt(query, "Pizza", playerData[playerid][pPizza]);
		MySQLUpdateInt(query, "Drink", playerData[playerid][pDrink]);

		MySQLUpdateInt(query, "ChristmasBox1", playerData[playerid][pChristmas]);
		MySQLUpdateInt(query, "KeyBoxSnow", playerData[playerid][pKeyBox]);
		MySQLUpdateInt(query, "HairAccess", playerData[playerid][pHair]);
		MySQLUpdateInt(query, "ChristmasBox2", playerData[playerid][pChristmasx]);

		MySQLUpdateInt(query, "ChangeName", playerData[playerid][pChangeName]);

		MySQLUpdateFinish(query);
		SaveClothing(playerid);
	}
	return 1;
}

forward OnPlayerLogin(playerid, race_check);
public OnPlayerLogin(playerid, race_check) {

	if (race_check != g_MysqlRaceCheck[playerid]) 
		return Kick(playerid);

	cache_get_value_name_bool(0, "Registered",playerData[playerid][pCreated]);
	cache_get_value_name_int(0, "Level",playerData[playerid][pLevel]);
	cache_get_value_name_int(0, "Model",playerData[playerid][pModel]);
	cache_get_value_name_int(0, "Wear",playerData[playerid][pWear]);
	cache_get_value_name_int(0, "Money",playerData[playerid][pCash]);
	cache_get_value_name_int(0, "Score",playerData[playerid][pScore]);
	cache_get_value_name_int(0, "ConnectedTime",playerData[playerid][pPlayingHours]);
	cache_get_value_name_int(0, "DonateRank",playerData[playerid][pDonateRank]);
	cache_get_value_name_int(0, "SpawnType",playerData[playerid][pSpawnType]);
	cache_get_value_name_int(0, "SpawnPoint",playerData[playerid][pSpawnPoint]);
	cache_get_value_name_float(0, "Health",playerData[playerid][pHealth]);
	cache_get_value_name_float(0, "SHealth",playerData[playerid][pSHealth]);
	cache_get_value_name_int(0, "AdminLevel",playerData[playerid][pAdmin]);
	cache_get_value_name_int(0, "PhoneNr",playerData[playerid][pPnumber]);
	cache_get_value_name_bool(0, "MedicBill",playerData[playerid][pMedicBill]);
	cache_get_value_name_int(0, "VirtualWorld",playerData[playerid][pVWorld]);
	cache_get_value_name_int(0, "Inte",playerData[playerid][pInterior]);
	cache_get_value_name_float(0, "Pos_x",playerData[playerid][pPosX]);
	cache_get_value_name_float(0, "Pos_y",playerData[playerid][pPosY]);
	cache_get_value_name_float(0, "Pos_z",playerData[playerid][pPosZ]);
	cache_get_value_name_float(0, "Pos_a",playerData[playerid][pPosA]);
	cache_get_value_name_int(0, "TalkStyle",playerData[playerid][pTalkStyle]);
	cache_get_value_name_int(0, "faction_id",playerData[playerid][pFaction]);
	cache_get_value_name_int(0, "faction_rank",playerData[playerid][pFactionRank]);
	cache_get_value_name_int(0, "House",playerData[playerid][pHouseKey]);
	cache_get_value_name_int(0, "Bizz",playerData[playerid][pBusinessKey]);
	cache_get_value_name_int(0, "Respect",playerData[playerid][pExp]);
	cache_get_value_name_int(0, "Bank",playerData[playerid][pAccount]);
	cache_get_value_name_int(0, "SavingsCollect",playerData[playerid][pSavingsCollect]);
	cache_get_value_name_int(0, "Savings",playerData[playerid][pSavings]);
	cache_get_value_name_int(0, "PayDayHad",playerData[playerid][pPayDayHad]);
	cache_get_value_name_int(0, "Paycheck",playerData[playerid][pPayCheck]);
	cache_get_value_name_int(0, "PayDay",playerData[playerid][pPayDay]);
	cache_get_value_name_int(0, "UpgradePoints",playerData[playerid][pPUpgrade]);
	cache_get_value_name_int(0, "RespawnPerks",playerData[playerid][pRespawnPerks]);
	cache_get_value_name_int(0, "ItemOOC",playerData[playerid][pItemOOC]);
	cache_get_value_name_int(0, "ItemGasCan",playerData[playerid][pItemGasCan]);
	cache_get_value_name_int(0, "Timeout",playerData[playerid][pTimeout]);
	cache_get_value_name_int(0, "Job",playerData[playerid][pJob]);
	cache_get_value_name_int(0, "SideJob",playerData[playerid][pSideJob]);
	cache_get_value_name_int(0, "ContractTime",playerData[playerid][pContractTime]);
	cache_get_value_name_int(0, "Fishes",playerData[playerid][pFishes]);
	cache_get_value_name_int(0, "WantedLevel", playerData[playerid][pWarrants]);

	cache_get_value_name_int(0, "Jailed", playerData[playerid][pJailed]);
	cache_get_value_name_int(0, "JailTime", playerData[playerid][pJailTime]);

	new query[256];

	cache_get_value_name(0, "DrugAddiction", query, 256);
	AssignPlayerDrugAddictions(playerid, query);

	format(query, sizeof(query), "SELECT * FROM `drugs_char` WHERE `charID` = '%d'", playerData[playerid][pSID]);
	mysql_tquery(dbCon, query, "OnLoadDrug", "d", playerid);

	format(query, sizeof(query), "SELECT * FROM `clothing` WHERE `owner` = %d", playerData[playerid][pSID]);
	mysql_tquery(dbCon, query, "OnLoadClothing", "d", playerid);

	if(gettime() - playerData[playerid][pTimeout] < 1200) {
		new temp;
		cache_get_value_name_int(0, "insideHouse", temp);
		Business_SetInside(playerid, temp);

		cache_get_value_name_int(0, "insideBiz", temp);
		House_SetInside(playerid, temp);
	} else {
		playerData[playerid][pTimeout] = 0;

		if (playerData[playerid][pWarrants] > 0) {
			playerData[playerid][pJailed] = 1;
			playerData[playerid][pJailTime] = playerData[playerid][pWarrants]*60*20;

			SendClientMessage(playerid, COLOR_YELLOW, "คุณถูกขังอยู่ในคุกแอดมินเนื่องจากออกจากเกมส์ในระหว่างหลบหนี้และไม่เข้ามาภายในเวลา");
			SendClientMessageEx(playerid, COLOR_YELLOW, "หากคุณต้องการต่อบทบาทติดต่อให้ผู้ดูแลที่ออนไลน์อยู่: %d ดาว %d วินาที", playerData[playerid][pWarrants], playerData[playerid][pJailTime]);
			SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ถูกส่งเข้าคุกแอดมินเนื่องจากทำผิดกฎ QG โดยอัตโนมัติ (%d ดาว %d วินาที)", ReturnPlayerName(playerid), playerData[playerid][pWarrants], playerData[playerid][pJailTime]);
			Log(systemlog, INFO, "[Admin Jail]: %s ถูกส่งเข้าคุกแอดมินเนื่องจากทำผิดกฎ QG โดยอัตโนมัติ (%d ดาว %d วินาที)", ReturnPlayerName(playerid), playerData[playerid][pWarrants], playerData[playerid][pJailTime]);

			playerData[playerid][pWarrants] = 0;
			playerData[playerid][pInterior] = 0;
			playerData[playerid][pVWorld] = playerData[playerid][pSID];
			playerData[playerid][pPosX] = 2576.7861;
			playerData[playerid][pPosY] = 2712.2004;
			playerData[playerid][pPosZ] = 22.9507;
		}
	}

	cache_get_value_name_bool(0, "CarLicense",playerData[playerid][pCarLic]);
	cache_get_value_name_int(0, "VehiclePerks",playerData[playerid][pVehiclePerks]);
	cache_get_value_name_int(0, "FishingPerks",playerData[playerid][pFishingPerks]);	

	new rtcall, rttext, bool:mairplane, bool:msilent;
	cache_get_value_name_int(0, "ringtoneCall", rtcall);
	cache_get_value_name_int(0, "ringtoneText", rttext);
	cache_get_value_name_bool(0, "phoneAirplane", mairplane);
	cache_get_value_name_bool(0, "phoneSilent", msilent);
	PhoneLoad(playerid, rtcall, rttext, mairplane, msilent);

	cache_get_value_name_int(0, "Point", playerData[playerid][pPoint]);
	cache_get_value_name_int(0, "Arrested", playerData[playerid][pArrested]);
	cache_get_value_name_float(0, "Hunger", playerData[playerid][pHunger]);

	cache_get_value_name_int(0, "SeedWeed", playerData[playerid][pSeedWeed]);
	cache_get_value_name_bool(0, "Watering", playerData[playerid][pWatering]);
	cache_get_value_name_int(0, "JobRank", playerData[playerid][pJobRank]);

	cache_get_value_name_int(0, "Radio", playerData[playerid][pRadio]);
	cache_get_value_name_int(0, "RadioChannel", playerData[playerid][pRChannel]);
	cache_get_value_name_int(0, "RadioSlot", playerData[playerid][pRSlot]);
	cache_get_value_name_int(0, "RadioAuth", playerData[playerid][pRAuth]);

	cache_get_value_name_int(0, "ATM", playerData[playerid][pATM]);
	cache_get_value_name_int(0, "NameFree", playerData[playerid][pNameChangeFree]);
	cache_get_value_name_int(0, "RedMoney", playerData[playerid][pRMoney]);
	
	cache_get_value_name_int(0, "Irons", playerData[playerid][pIrons]);
	cache_get_value_name_int(0, "Ore", playerData[playerid][pOre]);
	cache_get_value_name_int(0, "Cold", playerData[playerid][pCold]);
	cache_get_value_name_int(0, "Diamond", playerData[playerid][pDiamond]);

	cache_get_value_name_int(0, "LuckyBox", playerData[playerid][pLuckyBox]);
	cache_get_value_name_int(0, "Turismo", playerData[playerid][pTurismo]);

	cache_get_value_name_int(0, "Cannabis", playerData[playerid][pCannabis]);
	cache_get_value_name_int(0, "CPCannabis", playerData[playerid][pCPCannabis]);

	cache_get_value_name_int(0, "playerWeapon0", playerData[playerid][pGuns][0]);
	cache_get_value_name_int(0, "playerWeapon1", playerData[playerid][pGuns][1]);
	cache_get_value_name_int(0, "playerWeapon2", playerData[playerid][pGuns][2]);
	cache_get_value_name_int(0, "playerWeapon3", playerData[playerid][pGuns][3]);
	cache_get_value_name_int(0, "playerWeapon4", playerData[playerid][pGuns][4]);
	cache_get_value_name_int(0, "playerWeapon5", playerData[playerid][pGuns][5]);
	cache_get_value_name_int(0, "playerWeapon6", playerData[playerid][pGuns][6]);
	cache_get_value_name_int(0, "playerWeapon7", playerData[playerid][pGuns][7]);
	cache_get_value_name_int(0, "playerWeapon8", playerData[playerid][pGuns][8]);
	cache_get_value_name_int(0, "playerWeapon9", playerData[playerid][pGuns][9]);
	cache_get_value_name_int(0, "playerWeapon10", playerData[playerid][pGuns][10]);
	cache_get_value_name_int(0, "playerWeapon11", playerData[playerid][pGuns][11]);
	cache_get_value_name_int(0, "playerWeapon12", playerData[playerid][pGuns][12]);

	cache_get_value_name_int(0, "playerAmmo0", playerData[playerid][pAmmo][0]);
	cache_get_value_name_int(0, "playerAmmo1", playerData[playerid][pAmmo][1]);
	cache_get_value_name_int(0, "playerAmmo2", playerData[playerid][pAmmo][2]);
	cache_get_value_name_int(0, "playerAmmo3", playerData[playerid][pAmmo][3]);
	cache_get_value_name_int(0, "playerAmmo4", playerData[playerid][pAmmo][4]);
	cache_get_value_name_int(0, "playerAmmo5", playerData[playerid][pAmmo][5]);
	cache_get_value_name_int(0, "playerAmmo6", playerData[playerid][pAmmo][6]);
	cache_get_value_name_int(0, "playerAmmo7", playerData[playerid][pAmmo][7]);
	cache_get_value_name_int(0, "playerAmmo8", playerData[playerid][pAmmo][8]);
	cache_get_value_name_int(0, "playerAmmo9", playerData[playerid][pAmmo][9]);
	cache_get_value_name_int(0, "playerAmmo10", playerData[playerid][pAmmo][10]);
	cache_get_value_name_int(0, "playerAmmo11", playerData[playerid][pAmmo][11]);
	cache_get_value_name_int(0, "playerAmmo12", playerData[playerid][pAmmo][12]);

	cache_get_value_name_int(0, "Gun1", playerData[playerid][pGun1]);
	cache_get_value_name_int(0, "Gun2", playerData[playerid][pGun2]);
	cache_get_value_name_int(0, "Gun3", playerData[playerid][pGun3]);
	cache_get_value_name_int(0, "Ammo1", playerData[playerid][pAmmo1]);
	cache_get_value_name_int(0, "Ammo2", playerData[playerid][pAmmo2]);
	cache_get_value_name_int(0, "Ammo3", playerData[playerid][pAmmo3]);

	cache_get_value_name_int(0, "Boombox", playerData[playerid][pBoombox]);
	cache_get_value_name_int(0, "FirstAid", playerData[playerid][pFirstAid]);

	cache_get_value_name_int(0, "Mats", playerData[playerid][pMaterials]);
	cache_get_value_name_int(0, "CPMats", playerData[playerid][pCPMaterials]);

	cache_get_value_name_int(0, "Box", playerData[playerid][pBox]);
	cache_get_value_name_int(0, "DoubleBox", playerData[playerid][pDBox]);

	cache_get_value_name(0, "playerWarning1", playerData[playerid][pWarning1]);
	cache_get_value_name(0, "playerWarning2", playerData[playerid][pWarning2]);
	cache_get_value_name(0, "playerWarning3", playerData[playerid][pWarning3]);

	cache_get_value_name_int(0, "MechanicBox", playerData[playerid][pMechanicBox]);

	cache_get_value_name(0, "AdminName", playerData[playerid][pAdminName]);
	cache_get_value_name_int(0, "Helper", playerData[playerid][pHelper]);

	cache_get_value_name_int(0, "Stock", playerData[playerid][pStock]);
	cache_get_value_name_int(0, "Tie", playerData[playerid][pTie]);

	cache_get_value_name_float(0, "Hungry", playerData[playerid][pHungry]);
	cache_get_value_name_float(0, "Thirst", playerData[playerid][pThirst]);

	cache_get_value_name_int(0, "Pizza", playerData[playerid][pPizza]);
	cache_get_value_name_int(0, "Drink", playerData[playerid][pDrink]);

	cache_get_value_name_int(0, "ChristmasBox1", playerData[playerid][pChristmas]);
	cache_get_value_name_int(0, "KeyBoxSnow", playerData[playerid][pKeyBox]);
	cache_get_value_name_int(0, "HairAccess", playerData[playerid][pHair]);
	cache_get_value_name_int(0, "ChristmasBox2", playerData[playerid][pChristmasx]);

	cache_get_value_name_int(0, "ChangeName", playerData[playerid][pChangeName]);

	PlayerCar_Load(playerid);
	PlayerPlaySound(playerid, 1098 , 0.0, 0.0, 0.0);

	if (playerData[playerid][pSpawnPoint]==0 && playerData[playerid][pSpawnType] == SPAWN_TYPE_DEFAULT) {
		
		SetPlayerCameraLookAt(playerid, 587.5616,-1772.3320,14.3899);
		SetPlayerCameraPos(playerid, 1158.7341,-2036.1029,93.2742);
		Dialog_Show(playerid, DialogSpawnCity, DIALOG_STYLE_LIST, "เลือกเมืองเริ่มต้นของคุณ", "Train Station(สถานีรถไฟ)\nAirport Station(สนามบิน)", "เลือก", "สุ่ม");
		return 1;
	}

	if(!playerData[playerid][pCreated]) {
		playerData[playerid][pLevel] = 1;
		playerData[playerid][pCash] = 500;
		playerData[playerid][pAccount] = 5000;
		playerData[playerid][pHealth] = 50.0;
		playerData[playerid][pSHealth] = 0.0;
		playerData[playerid][pItemOOC] = 10;

		for (new x = 0; x < 13; x ++) {
			playerData[playerid][pGuns][x] = 0;
			playerData[playerid][pAmmo][x] = 0;
		}

		playerData[playerid][pBoombox] = 0;
		ResetBoombox(playerid);

		initiateTutorial(playerid);

		return 1;
	}
	BitFlag_On(gPlayerBitFlag[playerid], IS_LOGGED);
	SendClientMessageEx(playerid, -1, "ยินดีต้อนรับ %s (ผู้เล่นออนไลน์อยู่ทั้งหมด %d/%d คน)", ReturnPlayerName(playerid), Iter_Count(Player), MAX_PLAYERS);
	GameTextForPlayer(playerid, sprintf("~w~Welcome ~n~~y~   %s", ReturnPlayerName(playerid)), 5000, 1);

	ResetPlayerWeapons(playerid);
	for (new i = 0; i < 13; i ++) GivePlayerWeapon(playerid, playerData[playerid][pGuns][i], playerData[playerid][pAmmo][i]);
	SetWeapons(playerid);

	if (gMultipleEXP && gMultipleEXP > 1) {
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "ขณะนี้ค่าประสบการณ์ของเซิร์ฟเวอร์คูณด้วย %d", gMultipleEXP);
	}

	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, playerData[playerid][pCash]);

	switch(playerData[playerid][pAdmin]) {
		case 1: {
			playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1;
		}
		case 2: {
			playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2;
		}
		case 3: {
			playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3;
		}
		case 4: {
			playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3 | CMD_LEAD_ADMIN;
		}
		case 5: {
			playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3 | CMD_LEAD_ADMIN | CMD_MANAGEMENT;
		}
		case 6: {
			playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3 | CMD_LEAD_ADMIN | CMD_MANAGEMENT | CMD_DEV;
		}
		default: {
			playerData[playerid][pCMDPermission] = CMD_PLAYER;
		}
	}
	SetPlayerScore(playerid, playerData[playerid][pScore]);
	SetPlayerTeam(playerid, NO_TEAM);
	SetSpawnInfo(playerid, NO_TEAM, (playerData[playerid][pWear] ? playerData[playerid][pWear] : playerData[playerid][pModel]), 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	return 1;
}

Dialog:DialogSpawnCity(playerid, response, listitem, inputtext[]) {

	if (response) playerData[playerid][pSpawnPoint] = 1 + listitem;
	else playerData[playerid][pSpawnPoint] = 1 + random(2);

	if(!playerData[playerid][pCreated]) {
		playerData[playerid][pLevel] = 1;
		playerData[playerid][pCash] = 500;
		playerData[playerid][pAccount] = 5000;
		playerData[playerid][pHealth] = 50.0;
		playerData[playerid][pSHealth] = 0.0;
		playerData[playerid][pItemOOC] = 10;
		playerData[playerid][pRMoney] = 0;
		playerData[playerid][pIrons] = 0;
		playerData[playerid][pBoombox] = 0;

		for (new x = 0; x < 13; x ++) {
			playerData[playerid][pGuns][x] = 0;
			playerData[playerid][pAmmo][x] = 0;
		}

		ResetBoombox(playerid);

		initiateTutorial(playerid);
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmCmd: %s (%d) ได้สมัครสมาชิกใหม่ภายในเซิร์ฟเวอร์", ReturnPlayerName(playerid), playerid);
	}
	else {
		BitFlag_On(gPlayerBitFlag[playerid], IS_LOGGED);
		SendClientMessageEx(playerid, -1, "ยินดีต้อนรับ %s (ผู้เล่นออนไลน์อยู่ทั้งหมด %d/%d คน)", ReturnPlayerName(playerid), Iter_Count(Player), MAX_PLAYERS);
		GameTextForPlayer(playerid, sprintf("~w~Welcome ~n~~y~   %s", ReturnPlayerName(playerid)), 5000, 1);
		
		if (gMultipleEXP && gMultipleEXP > 1) {
			SendClientMessageEx(playerid, COLOR_LIGHTRED, "ขณะนี้ค่าประสบการณ์ของเซิร์ฟเวอร์คูณด้วย %d", gMultipleEXP);
		}

		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, playerData[playerid][pCash]);

		ResetPlayerWeapons(playerid);
		for (new i = 0; i < 13; i ++) GivePlayerWeapon(playerid, playerData[playerid][pGuns][i], playerData[playerid][pAmmo][i]);
		SetWeapons(playerid);

		switch(playerData[playerid][pAdmin]) {
			case 1: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1;
			}
			case 2: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2;
			}
			case 3: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3;
			}
			case 4: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3 | CMD_LEAD_ADMIN;
			}
			case 5: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3 | CMD_LEAD_ADMIN | CMD_MANAGEMENT;
			}
			case 6: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3 | CMD_LEAD_ADMIN | CMD_MANAGEMENT | CMD_DEV;
			}
			default: {
				playerData[playerid][pCMDPermission] = CMD_PLAYER;
			}
		}
		SetPlayerScore(playerid, playerData[playerid][pScore]);
		SetPlayerTeam(playerid, NO_TEAM);
		SetSpawnInfo(playerid, NO_TEAM, (playerData[playerid][pWear] ? playerData[playerid][pWear] : playerData[playerid][pModel]), 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
		SpawnPlayer(playerid);
	}
//	CuTrue(playerid);
	return 1;
}
