CMD:helpercmds(playerid, params[])
{
    if (playerData[playerid][pHelper] < 1 || playerData[playerid][pAdmin] < 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "�س������Ѻ͹حҵ��������觹��");

    SendClientMessage(playerid, COLOR_YELLOW, "�Թ�յ�͹�Ѻ������ҹ GTA Fun4You (�����س��ҹ������ҡ�س�������, ����ö�ͺ��������ŷ�ҹ�����)");

    SendClientMessage(playerid, COLOR_LIGHTRED, "/hjail {FFFFFF}���������Ѻ����觤ء������");
    SendClientMessage(playerid, COLOR_LIGHTRED, "/hkick {FFFFFF}���������Ѻ�ԭ�������͡�ҡ��������� (��)");
    SendClientMessage(playerid, COLOR_LIGHTRED, "/hban {FFFFFF}���������Ѻ���ẹ�������͡�ҡ���������");
    SendClientMessage(playerid, COLOR_LIGHTRED, "/hunjail {FFFFFF}���������Ѻ��ùӼ������͡�ҡ�ء");
    SendClientMessage(playerid, COLOR_LIGHTRED, "/hfine {FFFFFF}���������Ѻ��û�Ѻ�Թ�����蹷���зӼԴ��");

    SendClientMessage(playerid, COLOR_YELLOW, "�Է�Ծ���� : �س����ö�ͺ Newbie ������� Cooldown ��Ш��դӹ�˹����� Helper �ء����");
    return 1;
}

CMD:hget(playerid, params[])
{
	new targetid;
	if(sscanf(params,"u",targetid))
		return SendClientMessage(playerid, COLOR_GRAD1, "�����: /gethere [�ʹռ�����/���ͺҧ��ǹ]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

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

 	SendClientMessageEx(targetid, COLOR_WHITE, "�س���Ѻ�������͹�����¼����� %s", ReturnPlayerName(playerid));
	return 1;
}

CMD:hgoto(playerid, params[])
{
	new targetid;

	if(sscanf(params,"u",targetid))
		return SendClientMessage(playerid, COLOR_GRAD1, "�����: /goto [�ʹռ�����/���ͺҧ��ǹ]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

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

 	SendClientMessageEx(playerid, COLOR_GRAD1, "�س����͹������� %s �����", ReturnPlayerName(targetid));
	return 1;
}




CMD:hjail(playerid, params[])
{
    if (playerData[playerid][pHelper] < 1 || playerData[playerid][pAdmin] < 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "�س������Ѻ͹حҵ��������觹��");

	new targetid, time, reason[128];
	if(sscanf(params,"uds[128]",targetid, time, reason)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "�����: /hjail [�ʹռ�����/���ͺҧ��ǹ] [time] [reason]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if(time <= 0) return SendClientMessage(playerid, COLOR_GRAD1, "���ҵ�ͧ�ҡ���� 0!");

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s �١�觤ء�� Helper %s ������ %d �ҷ� ���˵�: %s", ReturnPlayerName(targetid), ReturnPlayerName(playerid), time, reason);

	playerData[targetid][pJailed] = 1;
	playerData[targetid][pJailTime] = time*60;

	SendClientMessage(targetid, COLOR_YELLOW, "�س�١�ѧ����㹤ء�ʹ�Թ���ͧ�ҡ�����þ����ҧ �");

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
        return SendClientMessage(playerid, COLOR_GRAD1, "�س������Ѻ͹حҵ��������觹��");

	if (sscanf(params, "us[128]", userid, reason))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /hkick [�ʹռ�����/���ͺҧ��ǹ] [���˵�]");

	if (userid == INVALID_PLAYER_ID || !IsPlayerConnected(userid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������͡Ѻ���������");

	foreach(new i : Player) {
		PlayerPlaySound(i, 1148, 0.0, 0.0, 0.0);
	}

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ��١���� Helper %s ���˵�: %s", ReturnPlayerName(userid), ReturnPlayerName(playerid), reason);
	Log(adminactionlog, INFO, "%s �١���� Helper %s ���˵� %s", ReturnPlayerName(userid), ReturnPlayerName(playerid), reason);
	
	KickEx(userid);
	return 1;
}

CMD:hban(playerid, params[])
{
	new
	    playerb,
	    reason[128];
    
    if (playerData[playerid][pHelper] < 1 || playerData[playerid][pAdmin] < 1)
        return SendClientMessage(playerid, COLOR_GRAD1, "�س������Ѻ͹حҵ��������觹��");

	if (sscanf(params, "us[128]", playerb, reason))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /hban [�ʹռ�����/���ͺҧ��ǹ] [���˵�]");

	if (playerb == INVALID_PLAYER_ID || !IsPlayerConnected(playerb))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������͡Ѻ���������");

	foreach(new i : Player) {
		PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
	}

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s �١ẹ�� Helper %s ���˵�: %s", ReturnPlayerName(playerb), ReturnPlayerName(playerid), reason);
	Log(adminactionlog, INFO, "%s �١ẹ�� Helper %s ���˵� %s", ReturnPlayerName(playerb), ReturnPlayerName(playerid), reason);

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
        return SendClientMessage(playerid, COLOR_GRAD1, "�س������Ѻ͹حҵ��������觹��");

	if(sscanf(params,"u",targetid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "�����: /hunjail [�ʹռ�����/���ͺҧ��ǹ]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");


	playerData[targetid][pJailed] = 0;
	playerData[targetid][pJailTime] = 0;
	SetPlayerSkin(targetid, playerData[targetid][pWear] ? playerData[targetid][pWear] : playerData[targetid][pModel]);

	SendClientMessage(targetid, COLOR_YELLOW, "�س�١������͡�ҡ�ء�ʹ�Թ !");

	SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, "AdmWarning: %s ��١������͡�ҡ�ء/���͹���� Helper %s", ReturnPlayerName(targetid), ReturnRealName(playerid));

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
        return SendClientMessage(playerid, COLOR_GRAD1, "�س������Ѻ͹حҵ��������觹��");

	if (sscanf(params, "uds[64]", ID, amount, reason))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /hfine [�ʹռ�����/���ͺҧ��ǹ] [��һ�Ѻ] [�˵ؼ�]");

 	if (ID == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if (amount <= 0)
		return SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ�кبӹǹ�ҡ���� 0");

    new
       	playerFined[MAX_PLAYER_NAME],
       	string[128];

	GetPlayerName(ID, playerFined, MAX_PLAYER_NAME);

    format(string, sizeof(string), "��Ѻ�Թ : %s �١��Ѻ�Թ�ӹǹ $%d �� Helper %s �����˵ؼ� : %s", playerFined, amount, ReturnPlayerName(playerid), reason);
    SendClientMessageToAll(COLOR_YELLOW, string);

	GivePlayerMoneyEx(ID, -amount);
	
	return 1;
}

/*flags:hspec(CMD_ADM_1);
CMD:hspec(playerid, params[]) {
    new
        userID;

    if (playerData[playerid][pHelper] < 0 || playerData[playerid][pAdmin] < 0) 
        return SendClientMessage(playerid, COLOR_GRAD1, "�س������Ѻ͹حҵ��������觹��");

    if(sscanf(params, "u", userID)) {
        return SendClientMessage(playerid, COLOR_GRAD1, "�����: /hspec [�ʹռ�����/���ͺҧ��ǹ]");
    }

	if (userID == INVALID_PLAYER_ID || !IsPlayerConnected(userID))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������͡Ѻ���������");

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
		return SendClientMessage(playerid, COLOR_GRAD1, "�����: /makehelper [�ʹռ�����/���ͺҧ��ǹ] [�����]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if (level <= 0) {
	    SendClientMessageEx(playerid, COLOR_YELLOW, "�س��Ŵ���˹� Helper �ͧ %s", ReturnRealName(userid));
	    SendClientMessageEx(userid, COLOR_YELLOW, "%s ��Ŵ���˹� Helper �ͧ�س", ReturnRealName(playerid));
	}
	else if (level > playerData[userid][pHelper])
	{
	    SendClientMessageEx(playerid, COLOR_YELLOW, "�س������͹���˹� %s ���������дѺ����٧��� (%d)", ReturnRealName(userid), level);
	    SendClientMessageEx(userid, COLOR_YELLOW, "%s ������͹���˹����س������дѺ����٧��� (%d)", ReturnRealName(playerid), level);
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_YELLOW, "�س��Ŵ�дѺ %s ���������дѺ����ӡ��һ��� (%d)", ReturnRealName(userid), level);
	    SendClientMessageEx(userid, COLOR_YELLOW, "%s ��Ŵ�дѺ�س������дѺ����ӡ��һ��� (%d)", ReturnRealName(playerid), level);
	}

	playerData[userid][pHelper] = level;
	SendAdminMessage(COLOR_YELLOW, CMD_DEV, "AdminWarning: %s ���Ѻ�� Helper %s ������� %d", ReturnPlayerName(playerid), ReturnPlayerName(userid), level);
	
	return 1;
}
