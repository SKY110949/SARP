CMD:helpercmds(playerid, params[])
{
    if (playerData[playerid][pHelper] < 1 || playerData[playerid][pAdmin] < 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

    SendClientMessage(playerid, COLOR_YELLOW, "ยินดีต้อนรับสู่ทีมงาน GTA Fun4You (ขอให้คุณอ่านคำสั่งหากคุณไม่เข้าใจ, สามารถสอบถามผู้ดูแลท่านอื่นได้)");

    SendClientMessage(playerid, COLOR_LIGHTRED, "/hjail {FFFFFF}คำสั่งสำหรับการส่งคุกผู้เล่น");
    SendClientMessage(playerid, COLOR_LIGHTRED, "/hkick {FFFFFF}คำสั่งสำหรับเชิญผู้เล่นออกจากเซิร์ฟเวอร์ (เตะ)");
    SendClientMessage(playerid, COLOR_LIGHTRED, "/hban {FFFFFF}คำสั่งสำหรับการแบนผู้เล่นออกจากเซิร์ฟเวอร์");
    SendClientMessage(playerid, COLOR_LIGHTRED, "/hunjail {FFFFFF}คำสั่งสำหรับการนำผู้เล่นออกจากคุก");
    SendClientMessage(playerid, COLOR_LIGHTRED, "/hfine {FFFFFF}คำสั่งสำหรับการปรับเงินผู้เล่นที่กระทำผิดกฎ");

    SendClientMessage(playerid, COLOR_YELLOW, "สิทธิพิเศษ : คุณสามารถตอบ Newbie โดยไม่มี Cooldown และจะมีคำนำหน้าว่า Helper ทุกครั้ง");
    return 1;
}

CMD:hget(playerid, params[])
{
	new targetid;
	if(sscanf(params,"u",targetid))
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /gethere [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	if(GetPlayerState(targetid) == PLAYER_STATE_DRIVER) SetVehiclePos(GetPlayerVehicleID(targetid), x, y, z);
	else {
		SetPlayerPos(targetid, x, y ,z);
	}
    playerData[targetid][pInterior] = GetPlayerInterior(playerid);
    SetPlayerInterior(targetid, playerData[targetid][pInterior]);

    playerData[targetid][pVWorld] = GetPlayerVirtualWorld(playerid);
    SetPlayerVirtualWorld(targetid, playerData[targetid][pVWorld]);

    insideHouseID[targetid] = insideHouseID[playerid];

 	SendClientMessageEx(targetid, COLOR_WHITE, "คุณได้รับการเคลื่อนย้ายโดยผู้ดูแล %s", ReturnPlayerName(playerid));
	return 1;
}

CMD:hgoto(playerid, params[])
{
	new targetid;

	if(sscanf(params,"u",targetid))
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /goto [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	new Float:x, Float:y, Float:z;

	GetPlayerPos(targetid, x, y, z);
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) SetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
	else {
		SetPlayerPos(playerid, x, y ,z);
	}
    playerData[playerid][pInterior] = GetPlayerInterior(targetid);
    SetPlayerInterior(playerid, playerData[playerid][pInterior]);

    playerData[playerid][pVWorld] = GetPlayerVirtualWorld(targetid);
    SetPlayerVirtualWorld(playerid, playerData[playerid][pVWorld]);

    insideHouseID[playerid] = insideHouseID[targetid];

 	SendClientMessageEx(playerid, COLOR_GRAD1, "คุณเคลื่อนย้ายไปหา %s สำเร็จ", ReturnPlayerName(targetid));
	return 1;
}




CMD:hjail(playerid, params[])
{
    if (playerData[playerid][pHelper] < 1 || playerData[playerid][pAdmin] < 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

	new targetid, time, reason[128];
	if(sscanf(params,"uds[128]",targetid, time, reason)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /hjail [ไอดีผู้เล่น/ชื่อบางส่วน] [time] [reason]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if(time <= 0) return SendClientMessage(playerid, COLOR_GRAD1, "เวลาต้องมากกว่า 0!");

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกส่งคุกโดย Helper %s เป็นเวลา %d นาที สาเหตุ: %s", ReturnPlayerName(targetid), ReturnPlayerName(playerid), time, reason);

	playerData[targetid][pJailed] = 1;
	playerData[targetid][pJailTime] = time*60;

	SendClientMessage(targetid, COLOR_YELLOW, "คุณถูกขังอยู่ในคุกแอดมินเนื่องจากไม่เคารพกฏต่าง ๆ");

	SetPlayerSkin(targetid, 268);
	playerData[targetid][pInterior] = 0;
	playerData[targetid][pVWorld] = playerData[targetid][pSID];
	playerData[targetid][pPosX] = 2576.7861;
	playerData[targetid][pPosY] = 2712.2004;
	playerData[targetid][pPosZ] = 22.9507;

	FullResetPlayerWeapons(targetid);
	SpawnPlayer(targetid);

	return 1;
}

CMD:hkick(playerid, params[])
{
	new
	    userid,
	    reason[128];

    if (playerData[playerid][pHelper] < 1 || playerData[playerid][pAdmin] < 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

	if (sscanf(params, "us[128]", userid, reason))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /hkick [ไอดีผู้เล่น/ชื่อบางส่วน] [สาเหตุ]");

	if (userid == INVALID_PLAYER_ID || !IsPlayerConnected(userid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้เชื่อมต่อกับเซิร์ฟเวอร์");

	foreach(new i : Player) {
		PlayerPlaySound(i, 1148, 0.0, 0.0, 0.0);
	}

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ได้ถูกเตะโดย Helper %s สาเหตุ: %s", ReturnPlayerName(userid), ReturnPlayerName(playerid), reason);
	Log(adminactionlog, INFO, "%s ถูกเตะโดย Helper %s สาเหตุ %s", ReturnPlayerName(userid), ReturnPlayerName(playerid), reason);
	
	KickEx(userid);
	return 1;
}

CMD:hban(playerid, params[])
{
	new
	    playerb,
	    reason[128];
    
    if (playerData[playerid][pHelper] < 1 || playerData[playerid][pAdmin] < 1)
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

	if (sscanf(params, "us[128]", playerb, reason))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /hban [ไอดีผู้เล่น/ชื่อบางส่วน] [สาเหตุ]");

	if (playerb == INVALID_PLAYER_ID || !IsPlayerConnected(playerb))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้เชื่อมต่อกับเซิร์ฟเวอร์");

	foreach(new i : Player) {
		PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
	}

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย Helper %s สาเหตุ: %s", ReturnPlayerName(playerb), ReturnPlayerName(playerid), reason);
	Log(adminactionlog, INFO, "%s ถูกแบนโดย Helper %s สาเหตุ %s", ReturnPlayerName(playerb), ReturnPlayerName(playerid), reason);

	new insertLog[256];
	
	mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', '%e', '%e', '%e', '%e')",
		playerData[playerb][pSID], ReturnPlayerName(playerb), reason, ReturnDate(), ReturnPlayerName(playerid), ReturnIP(playerb));
	
	mysql_tquery(dbCon, insertLog); 
	
	mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', '%e', '%e', '%e')",
		playerData[playerb][pSID], ReturnPlayerName(playerb), reason, ReturnPlayerName(playerid), ReturnDate());
		
	mysql_tquery(dbCon, insertLog); 
	
	KickEx(playerb);
	return 1;
}

CMD:hunjail(playerid, params[])
{
	new targetid;

    if (playerData[playerid][pHelper] < 1 || playerData[playerid][pAdmin] < 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

	if(sscanf(params,"u",targetid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /hunjail [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");


	playerData[targetid][pJailed] = 0;
	playerData[targetid][pJailTime] = 0;
	SetPlayerSkin(targetid, playerData[targetid][pWear] ? playerData[targetid][pWear] : playerData[targetid][pModel]);

	SendClientMessage(targetid, COLOR_YELLOW, "คุณถูกปล่อยออกจากคุกแอดมิน !");

	SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, "AdmWarning: %s ได้ถูกปล่อยออกจากคุก/เรือนจำโดย Helper %s", ReturnPlayerName(targetid), ReturnRealName(playerid));

	SpawnPlayer(targetid);
	return 1;
}

CMD:hfine(playerid, params[]) 
{
	new
	    ID,
		amount,
	    reason[64];

    if (playerData[playerid][pHelper] < 1 || playerData[playerid][pAdmin] < 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

	if (sscanf(params, "uds[64]", ID, amount, reason))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /hfine [ไอดีผู้เล่น/ชื่อบางส่วน] [ค่าปรับ] [เหตุผล]");

 	if (ID == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (amount <= 0)
		return SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องระบุจำนวนมากกว่า 0");

    new
       	playerFined[MAX_PLAYER_NAME],
       	string[128];

	GetPlayerName(ID, playerFined, MAX_PLAYER_NAME);

    format(string, sizeof(string), "ปรับเงิน : %s ถูกปรับเงินจำนวน $%d โดย Helper %s ด้วยเหตุผล : %s", playerFined, amount, ReturnPlayerName(playerid), reason);
    SendClientMessageToAll(COLOR_YELLOW, string);

	GivePlayerMoneyEx(ID, -amount);
	
	return 1;
}

/*flags:hspec(CMD_ADM_1);
CMD:hspec(playerid, params[]) {
    new
        userID;

    if (playerData[playerid][pHelper] < 0 || playerData[playerid][pAdmin] < 0) 
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

    if(sscanf(params, "u", userID)) {
        return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /hspec [ไอดีผู้เล่น/ชื่อบางส่วน]");
    }

	if (userID == INVALID_PLAYER_ID || !IsPlayerConnected(userID))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้เชื่อมต่อกับเซิร์ฟเวอร์");

	if(playerData[playerid][pSpectating] == INVALID_PLAYER_ID) {
		GetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
		playerData[playerid][pInterior] = GetPlayerInterior(playerid);
		playerData[playerid][pVWorld] = GetPlayerVirtualWorld(playerid);
	}
	playerData[playerid][pSpectating] = userID;
	TogglePlayerSpectating(playerid, true);

	SetPlayerInterior(playerid, GetPlayerInterior(userID));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(userID));

	if(IsPlayerInAnyVehicle(userID)) {
	    PlayerSpectateVehicle(playerid, GetPlayerVehicleID(userID));
	}
	else {
		PlayerSpectatePlayer(playerid, userID);
	}
	return 1;
}*/

flags:makehelper(CMD_DEV);
CMD:makehelper(playerid, params[])
{
	new
		userid,
	    level;

	if (sscanf(params, "ud", userid, level))
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /makehelper [ไอดีผู้เล่น/ชื่อบางส่วน] [เลเวล]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (level <= 0) {
	    SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้ปลดตำแหน่ง Helper ของ %s", ReturnRealName(userid));
	    SendClientMessageEx(userid, COLOR_YELLOW, "%s ได้ปลดตำแหน่ง Helper ของคุณ", ReturnRealName(playerid));
	}
	else if (level > playerData[userid][pHelper])
	{
	    SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้เลื่อนตำแหน่ง %s ให้อยู่ในระดับที่สูงขึ้น (%d)", ReturnRealName(userid), level);
	    SendClientMessageEx(userid, COLOR_YELLOW, "%s ได้เลื่อนตำแหน่งให้คุณอยู่ในระดับที่สูงขึ้น (%d)", ReturnRealName(playerid), level);
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้ลดระดับ %s ให้อยู่ในระดับที่ต่ำกว่าปกติ (%d)", ReturnRealName(userid), level);
	    SendClientMessageEx(userid, COLOR_YELLOW, "%s ได้ลดระดับคุณอยู่ในระดับที่ต่ำกว่าปกติ (%d)", ReturnRealName(playerid), level);
	}

	playerData[userid][pHelper] = level;
	SendAdminMessage(COLOR_YELLOW, CMD_DEV, "AdminWarning: %s ได้ปรับยศ Helper %s เป็นเลเวล %d", ReturnPlayerName(playerid), ReturnPlayerName(userid), level);
	
	return 1;
}
