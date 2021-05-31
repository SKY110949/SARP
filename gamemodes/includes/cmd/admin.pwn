#include <YSI\y_hooks> // pawn-lang/YSI-Includes

hook OnGameModeInit()
{
	SetTimer("GlobalSaving", 3600000, true);
	SetTimer("playerLoop", 1000, true);
//	ConnectNPC("Crazy_Train_Driver","Train");
}




CMD:ptp(playerid, params[])
{
	new Float:posa[3], Float:posb[3], playera, playerb;

	//if(PlayerData[playerid])return true;
//	if(!PlayerData[playerid][pAdmin])return UnAuthMessage(playerid);

//	if(!PlayerData[playerid][pAdmin] && !PlayerData[playerid][pTester])return UnAuthMessage(playerid);
    if (playerData[playerid][pAdmin] >= 1)
	if(sscanf(params, "uu", playera, playerb))return SendClientMessage(playerid, COLOR_GREY, "การใช้:{FFFFFF} /ptp [sending playerid] [playerid]");

	if(!IsPlayerConnected(playera))return SendClientMessage(playerid, COLOR_GREY, "65535 is not an active player.");
	if(!IsPlayerConnected(playerb))return SendClientMessage(playerid, COLOR_GREY, "65535 is not an active player.");
//	if(!playerData[playera] && !playerData[playerb])return SendClientMessage(playerid, COLOR_GREY, "You have specified a player that isn't logged in.");

    GetPlayerInterior(playerb);
	GetPlayerVirtualWorld(playerb);
	GetPlayerPos(playera, posa[0], posa[1], posa[2]);
	GetPlayerPos(playerb, posb[0], posb[1], posb[2]);
	SetPlayerPos(playera, posb[0], posb[1], posb[2]);

	SendClientMessage(playera, COLOR_GREY, "You have been teleported");

/*	format(string, sizeof(string), "%s teleported ID %d to ID %d.", ReturnName(playerid, 1), playera, playerb);
	endAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, str)
  format(str, sizeof(str), "AdmWarn: %s (%d) ได้มอบเงินให้ %s (%d) เป็นจำนวน %d", ReturnRealName(playerid), playerid, ReturnRealName(targetid), targetid, amount);
	SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, str);*/
	return true;
}

flags:acheckint(CMD_ADM_1);
CMD:acheckint(playerid, params[]){

        new string[128];
        format(string, sizeof(string), "You are in interior %i",GetPlayerInterior(playerid));
        SendClientMessage(playerid, 0xFF8000FF, string);
        return 1;
}

flags:acheckworld(CMD_ADM_1);
CMD:acheckworld(playerid, params[])
{
        new string[32];
        format(string, sizeof(string), "Your virtual world: %i", GetPlayerVirtualWorld(playerid));
        SendClientMessage(playerid, 0xFFFFFFFF, string);
        return 1;
}

flags:acheckpos(CMD_ADM_1);
CMD:acheckpos(playerid, params[])
{

        new Float:x, Float:y, Float:z;
	    new str[120];
	    GetPlayerPos(playerid,x, y, z);
	    format(str, sizeof(str), "YOU POSTION: %f, %f, %f",x, y, z);
	    SendClientMessage(playerid, 0xFFFFFFFF, str);
        return 1;
}

flags:adminhelp(CMD_ADM_1);
CMD:adminhelp(playerid, params[])
{
	if (playerData[playerid][pAdmin] >= 1)
	{
	    SendClientMessage(playerid, COLOR_GREEN, "___________________________ASISSTANT COMMANDS___________________________");
	    SendClientMessage(playerid, COLOR_GREEN, "___________________________[LEVEL 1]_____________________________________");
	    SendClientMessage(playerid, COLOR_GRAD1, " /goto, /gotocar , /gotop , /goto(sf/ls), /get, /gotopos, /getcar, /(re)spawn(car),/ptp , /fixveh");
	    SendClientMessage(playerid, COLOR_GRAD1, " /checkstats, /checkmoney, /checkip /checkore");
	    SendClientMessage(playerid, COLOR_GRAD1, " /admins /adminhelp /a [chatadmin],  ");
	    SendClientMessage(playerid, COLOR_GRAD1, " /kick, /oajail, /ajail /aunjail /ban , /banip, /unbanip , /fine , /respawn, /respawncar(s) ,/resetwanted , /acheckint, /acheckworld, /acheckpos");

	}
	if (playerData[playerid][pAdmin] >= 2)
	{
		SendClientMessage(playerid, COLOR_GREEN, "___________________________MODERATOR COMMANDS___________________________");
		SendClientMessage(playerid, COLOR_GREEN, "___________________________[LEVEL 2]_____________________________________");

		SendClientMessage(playerid, COLOR_GRAD1," /sethp, /setarmor, /forcespawn, /gopos, /freeze, /unfreeze, /checkhacker, /resetweapons, /clearweapons, /clearsaveweapons");
		SendClientMessage(playerid, COLOR_GRAD1," /oban, /banip, /checkip, /unbanip, /checkmats, /slap");
	}
	if (playerData[playerid][pAdmin] >= 3)
	{
	    SendClientMessage(playerid, COLOR_GREEN, "___________________________ADMINISTRATOR COMMANDS__________________________");
	    SendClientMessage(playerid, COLOR_GREEN, "___________________________[LEVEL 3]_____________________________________");

		SendClientMessage(playerid, COLOR_GRAD1," /givegun, /unban, /ban, /banip, /unbanip, /editzone, /setstat, /clearwanted, /kickall, /removehouse, /asellhouse, /clearore");
		SendClientMessage(playerid, COLOR_GRAD1," /spawndrug, /removedrug, /warehousecmds, /warn, /clearwarn, /nmutetime, /nmute, /checkore, /closeregis, /openregis, /asetworld");
	}
	if (playerData[playerid][pAdmin] >= 4)
	{
	    SendClientMessage(playerid, COLOR_GREEN, "___________________________LEAD ADMIN COMMANDS___________________________");
	    SendClientMessage(playerid, COLOR_GREEN, "___________________________[LEVEL 4]_____________________________________");

		SendClientMessage(playerid, COLOR_GRAD1," /makeleader, /asetrank, /toggleooc, /saveall");
		SendClientMessage(playerid, COLOR_GRAD1," /setname, /checkhouse, /jetpack /ironman /businesscmds");
	}
	if (playerData[playerid][pAdmin] >= 5)
	{
	    SendClientMessage(playerid, COLOR_GREEN, "___________________________MANAGEMENT COMMANDS___________________________");
	    SendClientMessage(playerid, COLOR_GREEN, "___________________________[LEVEL 5]_____________________________________");
		SendClientMessage(playerid, COLOR_GRAD1," /setexp /entrancecmds /factioncmds /housecmds /vehcmds");
	}
	if (playerData[playerid][pAdmin] >= 6)
	{
	    SendClientMessage(playerid, COLOR_GREEN, "___________________________DEVELOPER COMMANDS___________________________");
	    SendClientMessage(playerid, COLOR_GREEN, "___________________________[LEVEL X]_____________________________________");
		SendClientMessage(playerid, COLOR_GRAD1," /makeadmin, /gmx, /effectzazaza ,/baszazaspawngun , ");
	}
	SendClientMessage(playerid, COLOR_GREEN,"_____________________________________________________________________________");
	return 1;
}
alias:adminhelp("ahelp", "acmds");

flags:setname(CMD_ADM_3);
CMD:setname(playerid, params[]) {

	new
		newName[MAX_PLAYER_NAME],
		targetid;

	if(sscanf(params, "us[24]", targetid, newName)) {
		return SendClientMessage(playerid, COLOR_GRAD2, "การใช้: /setname [ไอดีผู้เล่น/ชื่อบางส่วน] [ชื่อที่ตั้งใหม่]");
	}

	new rows;
	cache_get_row_count(rows);
	
	if (rows) {
		SendClientMessage(playerid, COLOR_GRAD1, "ชื่อผู้ใช้นี้มีในฐานข้อมูลแล้ว");
		return 1;
	}

	else {
		if(targetid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

		SendClientMessageEx(targetid, COLOR_YELLOW, "คุณได้ถูกเปลี่ยนชื่อของคุณจาก %s เป็นชื่อ %s", ReturnPlayerName(targetid), newName);
		Log(namechangelog, INFO, "%s ได้ถูกเปลี่ยนชื่อเป็น %s", ReturnPlayerName(targetid), newName);
		
		SetPlayerName(targetid, newName);
		
		new query[128];
		mysql_format(dbCon, query, sizeof query, "UPDATE `players` SET `Name` = '%e' WHERE `ID` = %d", newName, playerData[targetid][pSID]);
		mysql_tquery(dbCon, query);
		
		OnAccountUpdate(targetid);
		ResyncSkin(targetid);
	}
	return 1;
}

//flags:asetworld(CMD_AMD_3)
CMD:asetworld(playerid, params[])
{
	if(playerData[playerid][pAdmin] < 3)
		return SendClientMessage(playerid, -1, "คุณไม่ใช่ผู้ดูแลระบบ");
    new tagetid, worldid;

    if(sscanf(params, "ud", tagetid, worldid))
        return SendClientMessage(playerid, -1, "/asetworld <ชื่อบางส่วน/ไอดี> <worldid>");

    if(!IsPlayerConnected(tagetid))
        return SendClientMessage(playerid, -1, "ผู้เล่นไม่อยู่ในเซิฟเวอร์");


    SetPlayerVirtualWorld(tagetid, worldid);
    return 1;
}

flags:gmx(CMD_DEV);
CMD:gmx(playerid, params[])
{
	new time;

	if (sscanf(params, "d", time)) {
        SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /gmx [วินาที]");
        SendClientMessage(playerid, COLOR_GRAD1, "คำแนะนำ: ยกเลิกได้โดยใช้ 0 หรือใช้ตัวเลขอื่นเพื่อเลื่อนเวลา");
        return 1;
    }

    if (time == 0) {
        if(!gServerRestart) return SendClientMessage(playerid, COLOR_LIGHTRED, "เซิร์ฟเวอร์ยังไม่ได้เริ่มนับเวลาถอยหลัง");
	    TextDrawHideForAll(gServerRestartCount);
	    gServerRestart = false;
	    gRestartTime = 0;
		Log(systemlog, INFO, "Server cancel restart.");
	    return SendClientMessageToAllEx(COLOR_LIGHTRED, "SERVER:"EMBED_WHITE" %s ได้ยกเลิกการรีสตาร์ทเซิร์ฟเวอร์", ReturnPlayerName(playerid));
	}
    else if (time < 3 || time > 600) return SendClientMessage(playerid, COLOR_LIGHTRED, "วินาทีที่ระบุไม่ควรต่ำกว่า 3 หรือมากกว่า 600");

    TextDrawShowForAll(gServerRestartCount);
    
	Log(systemlog, INFO, "The %s %d sec.", gServerRestart ? ("server restart change time to"):("server will restart in"), time);
    SendClientMessageToAllEx(COLOR_LIGHTRED, "SERVER:"EMBED_WHITE" %s %sในอีก %d วินาที", ReturnPlayerName(playerid), gServerRestart ? ("ได้เลื่อนเวลารีสตาร์ทเซิร์ฟเวอร์เป็นเวลา"):("ได้เริ่มรีสตาร์ทเซิฟเวอร์"), time);

	gServerRestart = true;
	gRestartTime = time;
	return 1;
}


flags:tod(CMD_ADM_1);
CMD:tod(playerid, params[])
{
	new time, msg[128];
	
	if(sscanf(params, "d", time)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /tod [time] (0-23)");

	SetWorldTime(time);

	format(msg, sizeof(msg), "เวลาถูกเปลี่ยนเป็น %d:00", time);
	SendClientMessageToAll(COLOR_GRAD1, msg);

	return 1;
}

flags:weather(CMD_ADM_1);
CMD:weather(playerid, params[])
{
	new weather;

	if(playerData[playerid][pAdmin] < 3) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

	if(sscanf(params, "d", weather)) 
		return SendClientMessage(playerid,  COLOR_GRAD1, "การใช้: /weather [weatherid]");

	if(weather < 0||weather > 45) { SendClientMessage(playerid, COLOR_GREY, "   Weather ID can't be below 0 or above 45!"); return 1; }
	SetPlayerWeather(playerid, weather);
	SendClientMessage(playerid, COLOR_GREY, "สภาพอากาศถูกเปลี่ยน!");
	return 1;
}

flags:weatherall(CMD_ADM_1);
CMD:weatherall(playerid, params[])
{
	new weather;
	if(playerData[playerid][pAdmin] < 3) return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");
	if(sscanf(params, "d", weather)) return SendClientMessage(playerid,  COLOR_GRAD1, "การใช้: /weather [weatherid]");
	if(weather < 0||weather > 45) { SendClientMessage(playerid, COLOR_GREY, "   Weather ID can't be below 0 or above 45!"); return 1; }
	SetWeather(weather);
	SendClientMessage(playerid, COLOR_GREY, "สภาพอากาศถูกเปลี่ยนให้กับทุกคน!");
	return 1;
}

flags:setskin(CMD_ADM_1);
CMD:setskin(playerid, params[])
{
	new targetid;
	new skin;

	if (sscanf(params, "ud", targetid, skin))
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /setskin [ไอดีผู้เล่น/ชื่อบางส่วน] [ไอดีสกิน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	SetPlayerSkin(targetid, skin);

	return 1;
}

flags:checkore(CMD_ADM_3);
CMD:checkore(playerid, params[])
{
	new targetid;

	if(sscanf(params,"u",targetid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /checkore [ไอดีผู้เล่น/ชื่อบางส่วน]");

    SendClientMessage(playerid, COLOR_GREEN, "l__________ORE__________l");
    SendClientMessageEx(playerid, COLOR_WHITE, "แร่ที่ยังไม่ผ่านการแปรรูป {33AA33}: %d", playerData[targetid][pIrons]);
    SendClientMessageEx(playerid, COLOR_WHITE, "แร่เหล็ก {33AA33}: %d", playerData[targetid][pOre]);
    SendClientMessageEx(playerid, COLOR_WHITE, "แร่ถ่าน {33AA33}: %d", playerData[targetid][pCold]);
    SendClientMessageEx(playerid, COLOR_WHITE, "แร่เพรช {33AA33}: %d", playerData[targetid][pDiamond]);

    return 1;
}

flags:checkstats(CMD_ADM_1);
CMD:checkstats(playerid, params[])
{
	new targetid;

	if(sscanf(params,"u",targetid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /checkstats [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	ShowStats(playerid,targetid);

	return 1;
}

flags:nmute(CMD_ADM_1);
CMD:nmute(playerid, params[]) {

	new
	    ID;

	if(sscanf(params, "u", ID))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /nmute [ไอดีผู้เล่น/ชื่อบางส่วน]");

    if(ID == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

    new
       	string[88];

	switch(playerData[ID][pNMuted]) {
		case 0: {
			format(string, sizeof(string), "ผู้ดูแล %s ได้ระงับการใช้ช่องทางสนทนา Newbie ของคุณ", playerData[playerid][pAdminName]);
			SendClientMessage(ID, COLOR_LIGHTRED, string);

			format(string, sizeof(string), "คุณได้ระงับการใช้ช่องทางสนทนา Newbie ของ %s", ReturnPlayerName(ID));
			SendClientMessage(playerid, COLOR_LIGHTRED, string);

			playerData[ID][pNMuted] = 1;
		}
		default: {
			format(string, sizeof(string), "ผู้ดูแล %s ได้ยกเลิกการระงับการใช้ช่องทางสนทนา Newbie ของคุณ", playerData[playerid][pAdminName]);
			SendClientMessage(ID, COLOR_LIGHTRED, string);

			format(string, sizeof(string), "คุณได้ยกเลิกการระงับการใช้ช่องทางสนทนา Newbie ของ %s", ReturnPlayerName(ID));
			SendClientMessage(playerid, COLOR_WHITE, string);

			playerData[ID][pNMuted] = 0;
		}
	}
	return 1;
}

CMD:fly(playerid, params[])
{
	if (playerData[playerid][pAdmin] >= 1)
		return false;

	new
		Float:px, Float:py, Float:pz, Float:pa;

	GetPlayerFacingAngle(playerid,pa);

    if(pa >= 0.0 && pa <= 22.5)
    {
    	GetPlayerPos(playerid, px, py, pz);
		if(GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, px, py+30, pz+5);
		}
		else
		{
			SetPlayerPos(playerid, px, py+30, pz+5);
		}
    }
    if(pa >= 332.5 && pa < 0.0)
    {
        GetPlayerPos(playerid, px, py, pz);
		if(GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, px, py+30, pz+5);
		}
		else
		{
			SetPlayerPos(playerid, px, py+30, pz+5);
		}
    }
    if(pa >= 22.5 && pa <= 67.5)
    {
        GetPlayerPos(playerid, px, py, pz);
		if (GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, px-15, py+15, pz+5);
		}
		else
		{
			SetPlayerPos(playerid, px-15, py+15, pz+5);
		}
    }
    if(pa >= 67.5 && pa <= 112.5)
    {
        GetPlayerPos(playerid, px, py, pz);
		if (GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, px-30, py, pz+5);
		}
		else
		{
			SetPlayerPos(playerid, px-30, py, pz+5);
		}
    }
    if(pa >= 112.5 && pa <= 157.5)
    {
        GetPlayerPos(playerid, px, py, pz);
		if(GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, px-15, py-15, pz+5);
		}
		else
		{
			SetPlayerPos(playerid, px-15, py-15, pz+5);
		}
    }
    if(pa >= 157.5 && pa <= 202.5)
    {
        GetPlayerPos(playerid, px, py, pz);
		if (GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, px, py-30, pz+5);
		}
		else
		{
			SetPlayerPos(playerid, px, py-30, pz+5);
		}
    }
    if(pa >= 202.5 && pa <= 247.5)
    {
        GetPlayerPos(playerid, px, py, pz);
		if(GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, px+15, py-15, pz+5);
		}
		else
		{
			SetPlayerPos(playerid, px+15, py-15, pz+5);
		}
    }
    if(pa >= 247.5 && pa <= 292.5)
    {
        GetPlayerPos(playerid, px, py, pz);
		if (GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, px+30, py, pz+5);
		}
		else
		{
			SetPlayerPos(playerid, px+30, py, pz+5);
		}
    }
    if(pa >= 292.5 && pa <= 332.5)
    {
        GetPlayerPos(playerid, px, py, pz);
		if(GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, px+15, py+15, pz+5);
		}
		else
		{
			SetPlayerPos(playerid, px+15, py+15, pz+5);
		}
    }
    return true;
}




flags:nmutetime(CMD_ADM_1);
CMD:nmutetime(playerid, params[]) {
        
	new
        minutes,
        userID,
        reason[64],
		string[512];

    if(sscanf(params, "uds[64]", userID, minutes, reason)) {
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /nmutetime [ไอดีผู้เล่น/ชื่อบางส่วน] [เวลา/นาที] [เหตุผล]");
	}
	else
	{
		if(userID == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

		if(playerData[playerid][pAdmin] > 0)
		{
		 	format(string, sizeof(string), "ช่องสนทนา : %s ถูกระงับใช้ช่องทางสอบถามโดย %s สาเหตุ: %s (%d นาที)", ReturnPlayerName(userID), playerData[playerid][pAdminName], reason, minutes);
		}

		SendClientMessageToAll(COLOR_LIGHTBLUE, string);
		playerData[userID][pNewbieTimeout] = minutes*60;
	}
	return 1;
}

flags:gotocar(CMD_ADM_1);
CMD:gotocar(playerid, params[])
{
	new vehicleid;
	if (sscanf(params, "d", vehicleid))
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /gotocar [ไอดียานพาหนะ]");

	if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))
		return SendClientMessage(playerid, COLOR_GRAD2, "   ไอดียานพาหนะไม่ถูกต้อง");

	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetVehiclePos(vehicleid, x, y, z);
	SetPlayerPos(playerid, x, y - 2, z + 2);

	return 1;
}

flags:revive(CMD_ADM_1);
CMD:revive(playerid, params[])
{
    new targetid;
    
	if(sscanf(params,"u",targetid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /revive [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(targetid == INVALID_PLAYER_ID) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");
	
	BitFlag_Off(gPlayerBitFlag[targetid], IS_SPAWNED);
		
	gInjuredTime[targetid] = 0;
	gIsDeathMode{targetid} = false;
	gIsInjuredMode{targetid}=false;

	Damage_Reset(targetid);
	SpawnPlayer(targetid);

	return 1;
}

flags:getcar(CMD_ADM_1);
CMD:getcar(playerid, params[])
{

//	if (playerData[playerid][pAdmin] >= 1)
	new vehicleid;
	if (sscanf(params, "d", vehicleid))
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /getcar [ไอดียานพาหนะ]");

	if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))
		return SendClientMessage(playerid, COLOR_GRAD2, "   ไอดียานพาหนะไม่ถูกต้อง");

	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(playerid, x, y, z);
	SetVehiclePos(vehicleid, x, y - 2, z + 2);
 	LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
 	SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
	return 1;
}

flags:checkip(CMD_ADM_1);
CMD:checkip(playerid, params[])
{
	new ip[16],
	    targetid;
		
	if (sscanf(params, "u", targetid))
	    return 	SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /checkip [ไอดีผู้เล่น/ชื่อบางส่วน]");
		
	if (targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");
	    
 	GetPlayerIp(targetid, ip, sizeof(ip));
	SendClientMessageEx(playerid, COLOR_WHITE, "ผู้เล่น {FFFF00}%s {FFFFFF}IP : {FFFF00}%s", ReturnPlayerName(targetid), ip);
	return 1;
}

flags:checkredmoney(CMD_ADM_1);
CMD:checkredmoney(playerid, params[])
{
	new
	    targetid;

	if (sscanf(params, "u", targetid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /checkredmoney [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	SendClientMessageEx(playerid, COLOR_WHITE, "ผู้เล่น {FF0000}%s {FFFFFF}มีเงินแดงจำนวน : {FF0000}%d", ReturnPlayerName(targetid), playerData[targetid][pRMoney]);
	return 1;
}

flags:checkmats(CMD_ADM_1);
CMD:checkmats(playerid, params[])
{
	new
	    targetid;

	if (sscanf(params, "u", targetid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /checkmats [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	SendClientMessageEx(playerid, COLOR_WHITE, "ผู้เล่น {FF0000}%s {FFFFFF}มีดินปืนอยู่ในตัว : {FF0000}%d", ReturnPlayerName(targetid), playerData[targetid][pMaterials]);
	return 1;
}

flags:fine(CMD_ADM_1);
CMD:fine(playerid, params[]) 
{
	new
	    ID,
		amount,
	    reason[64];

	if (sscanf(params, "uds[64]", ID, amount, reason))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /fine [ไอดีผู้เล่น/ชื่อบางส่วน] [ค่าปรับ] [เหตุผล]");

 	if (ID == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (amount <= 0)
		return SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องระบุจำนวนมากกว่า 0");

    new
       	playerFined[MAX_PLAYER_NAME],
       	string[128];

	GetPlayerName(ID, playerFined, MAX_PLAYER_NAME);

    format(string, sizeof(string), "ปรับเงิน : %s ถูกปรับเงินจำนวน $%d โดย %s ด้วยเหตุผล : %s", playerFined, amount, playerData[playerid][pAdminName], reason);
    SendClientMessageToAll(COLOR_YELLOW, string);

	GivePlayerMoneyEx(ID, -amount);
	
	return 1;
}

flags:respawn(CMD_ADM_1);
CMD:respawn(playerid, params[])
{
	new
	    targetid;

	if (sscanf(params, "u", targetid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /respawn [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	Main_SetPlayerDefaultSpawn(targetid);
	SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้ส่งตัว %s กลับจุดเกิด", ReturnPlayerName(targetid));
	SendClientMessageEx(targetid, COLOR_GRAD1, "คุณถูกส่งตัวกลับจุดเกิดโดย %s", ReturnPlayerName(playerid));	
	return 1;
}

flags:kickall(CMD_ADM_3);
CMD:kickall(playerid, params[])
{
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		Kick(i);
		PlayerPlaySound(i, 1148, 0.0, 0.0, 0.0);
	}

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ได้เชิญผู้เล่นทุกคนออกจากเซิร์ฟเวอร์, สาเหตุ: รีเซิร์ฟเวอร์ (ป้องกันข้อมูลผู้เล่นสูญหาย)", ReturnPlayerName(playerid));
	return 1;
}

flags:resetwanted(CMD_ADM_1);
CMD:resetwanted(playerid, params[])
{
	new
	    targetid;

	if (sscanf(params, "u", targetid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /resetwanted [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	playerData[targetid][pWarrants] = 0;
	SetPlayerWantedLevel(targetid, 0);
	ClearCrime(targetid);

	playerData[targetid][pCPCannabis] = 0;
	playerData[targetid][pCannabis] = 0;
	playerData[targetid][pTurismo] = 0;

	OnAccountUpdate(targetid);

	SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้ทำการแก้บัคดาวและขนส่งกัญชาให้กับผู้เล่น %s", ReturnPlayerName(targetid));
	SendClientMessageEx(targetid, COLOR_GRAD1, "คุณถูกแก้บัคดาวและขนส่งกัญชาโดย %s", ReturnPlayerName(playerid));

	return 1;
}

flags:admins(CMD_ADM_1);
CMD:admins(playerid, params[])
{
	new count = 0;

    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");

    foreach (new i : Player) if (playerData[i][pAdmin] > 0)
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "* %s {33CC33}(Level: %d)", ReturnPlayerName(i), playerData[i][pAdmin]);
        count++;
	}
	if (!count) {
	    SendClientMessage(playerid, COLOR_WHITE, "No Admin Online");
	}
	SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	return 1;
}

flags:gotopos(CMD_ADM_1);
CMD:gotopos(playerid, params[]) 
{
    new 
		Float:Pos[3], 
		int;

	if(sscanf(params, "fffi", Pos[0], Pos[1], Pos[2], int)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /gotopos [x] [y] [z] [int]");

	SetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	SetPlayerInterior(playerid, int);
	
	return 1;
}

flags:goto(CMD_ADM_1);
CMD:goto(playerid, params[])
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

flags:gethere(CMD_ADM_1);
CMD:gethere(playerid, params[])
{
  //  if (playerData[playerid][pAdmin] >= 1)
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

alias:respawncar("recar");
flags:respawncar(CMD_ADM_1);
CMD:respawncar(playerid, params[]) {

	new id;
	if (sscanf(params, "d", id))
	{
	 	if (IsPlayerInAnyVehicle(playerid))
		 	id = GetPlayerVehicleID(playerid);

		else return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /respawncar [ไอดียานพาหนะ]");
	}
	SetVehicleToRespawn(id);

	return 1;
}

alias:respawncars("recars");
flags:respawncars(CMD_ADM_1);
CMD:respawncars(playerid, params[]) {

	foreach(new i : Iter_PlayerCar) {
		if (GetVehicleDriver(i) == INVALID_PLAYER_ID) {
			SetVehicleToRespawn(i);
		}
	}

	for (new i = 1; i != MAX_VEHICLES; i ++)
	{
	    if (GetVehicleDriver(i) == INVALID_PLAYER_ID)
	    {
	        SetVehicleToRespawn(i);
			//count++;
		}
	}

	SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ทำการรียานพาหนะส่วนตัวของผู้เล่นทั้งเซิร์ฟเวอร์");

	return 1;
}

flags:toggleooc(CMD_LEAD_ADMIN);
CMD:toggleooc(playerid,params[])
{
 	if(systemVariables[OOCStatus] == 1)
 	{
		systemVariables[OOCStatus] = 0;
	    SendClientMessageToAllEx(COLOR_GREEN, "%s ได้เปิดการใช้งานแชท Global OOC", playerData[playerid][pAdminName]);
	}
	else
	{
		systemVariables[OOCStatus] = 1;
 	    SendClientMessageToAllEx(COLOR_GREEN, "%s ได้ปิดให้ใช้งานแชท Global OOC", playerData[playerid][pAdminName]);
	}
	return 1;
}


flags:sethp(CMD_ADM_2);
CMD:sethp(playerid, params[])
{
	new userid, health;

	if (sscanf(params, "ud", userid, health))
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /sethp [ไอดี/ชื่อบางส่วน] [จำนวนเลือด]");
	
	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้เชื่อมต่อกับเซิร์ฟเวอร์");

	if(userid != playerid) { 
		SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้ปรับเลือด %s เป็น %d !", ReturnPlayerName(userid), health);
		SendClientMessageEx(userid, COLOR_GRAD1, "เลือดของคุณถูกปรับเป็น %d โดยผู้ดูแลระบบ %s", health, ReturnPlayerName(playerid));
	}
	else {
		SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้ปรับเลือดของตัวเองเป็น %d !", health);
	}
	SetPlayerHealth(userid, health);

	return 1;
}

flags:setarmor(CMD_ADM_2);
CMD:setarmor(playerid, params[])
{
	new userid, health;

	if (sscanf(params, "ud", userid, health))
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /setarmor [ไอดี/ชื่อบางส่วน] [จำนวนเกราะ]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้เชื่อมต่อกับเซิร์ฟเวอร์");

	if(userid != playerid) { 
		SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณได้ปรับเกราะ %s เป็น %d", ReturnPlayerName(userid), health);
		SendClientMessageEx(userid, COLOR_YELLOW, "เกราะของคุณถูกปรับเป็น %d โดยผู้ดูแลระบบ %s", health, ReturnPlayerName(playerid));
	}
	else {
		SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้ปรับเกราะของตัวเองเป็น %d", health);
	}
	SetPlayerArmour(userid, health);
	return 1;
}

flags:givegun(CMD_ADM_3);
CMD:givegun(playerid, params[])
{
	new userid, gunid, ammo;

	if(sscanf(params, "uii", userid, gunid, ammo))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /givegun [ไอดี/ชื่อบางส่วน] [ไอดีอาวุธ] [จำนวน]");
		SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
		SendClientMessage(playerid, COLOR_GREY, "1: Brass Knuckles 2: Golf Club 3: Nite Stick 4: Knife 5: Baseball Bat 6: Shovel 7: Pool Cue 8: Katana 9: Chainsaw");
		SendClientMessage(playerid, COLOR_GREY, "10: Purple Dildo 11: Small White Vibrator 12: Large White Vibrator 13: Silver Vibrator 14: Flowers 15: Cane 16: Frag Grenade");
		SendClientMessage(playerid, COLOR_GREY, "17: Tear Gas 18: Molotov Cocktail 19: Vehicle Missile 20: Hydra Flare 21: Jetpack 22: 9mm 23: Silenced 9mm 24: Desert Eagle 25: Shotgun");
		SendClientMessage(playerid, COLOR_GREY, "26: Sawnoff Shotgun 27: SPAS-12 28: Micro SMG (Mac 10) 29: SMG (MP5) 30: AK-47 31: M4 32: Tec9 33: Rifle");
		SendClientMessage(playerid, COLOR_GREY, "25: Shotgun 34: Sniper Rifle 35: Rocket Launcher 36: HS Rocket Launcher 37: Flamethrower 38: Minigun 39: Satchel Charge");
		SendClientMessage(playerid, COLOR_GREY, "40: Detonator 41: Spraycan 42: Fire Extinguisher 43: Camera 44: Nightvision Goggles 45: Infared Goggles 46: Parachute");
		SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");

		return 1;
	}

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้เชื่อมต่อกับเซิร์ฟเวอร์");

	if(gunid < 0 || gunid > 46 || gunid == 19 || gunid == 20 || gunid == 21) return SendClientMessage(playerid, COLOR_GREY, "Invalid weapon id.");

	if(userid != playerid) { 
		SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณได้ให้ %s จำนวน %d กับ %s", ReturnWeaponNameEx(gunid), ammo, ReturnPlayerName(userid));
		SendClientMessageEx(userid, COLOR_YELLOW, "คุณได้รับ %s จำนวน %d จากผู้ดูแลระบบ %s", ReturnWeaponNameEx(gunid), ammo, ReturnPlayerName(playerid));
	}
	else {
		SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณได้รับ %s จำนวน %d", ReturnWeaponNameEx(gunid), ammo);
	}

	GivePlayerWeapon(userid, gunid, ammo);
	
	return 1;
}

flags:gotols(CMD_ADM_1);
CMD:gotols(playerid)
{
	SetPlayerPos(playerid, 1529.6,-1691.2,13.3);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	
	playerData[playerid][pInterior] = 0;
	playerData[playerid][pVWorld] = 0;
					
	SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง Los Santos!");
	return 1;
}

flags:gotosf(CMD_ADM_1);
CMD:gotosf(playerid)
{
	SetPlayerPos(playerid, -1973.3322,138.0420,27.6875);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	
	playerData[playerid][pInterior] = 0;
	playerData[playerid][pVWorld] = 0;

	SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง San Fierro!");
	return 1;
}

flags:gopos(CMD_ADM_2);
CMD:gopos(playerid, params[]) {

    new Float:PosX, Float:PosY, Float:PosZ, int, vworld;
	if(sscanf(params, "fffI(0)I(0)", PosX, PosY, PosZ, int, vworld)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /gopos [x] [y] [z] [int] [vw]");

	SetPlayerPos(playerid, PosX, PosY, PosZ);

	SetPlayerInterior(playerid, int);
	playerData[playerid][pInterior] = int;

	SetPlayerVirtualWorld(playerid, vworld);
	playerData[playerid][pVWorld] = vworld;
	return 1;
}

flags:forcespawn(CMD_ADM_2);
CMD:forcespawn(playerid, params[])
{
    new targetid;
    
	if(sscanf(params,"u",targetid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /forcespawn [ไอดี/ชื่อบางส่วน]");

	if(targetid == INVALID_PLAYER_ID)
		SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	gInjuredTime[targetid] = 0;
	gIsInjuredMode{targetid} = 
	playerData[targetid][pMedicBill] = 
	gIsDeathMode{targetid} = false;
	playerData[targetid][pHealth]=100;
	Damage_Reset(targetid);
	BitFlag_Off(gPlayerBitFlag[targetid], IS_SPAWNED);
	SpawnPlayer(targetid);

	return 1;
}

// Mobile
flags:setrespawn(CMD_DEV);
CMD:setrespawn(playerid, params[])
{
    new targetid;
    
	if(sscanf(params,"u",targetid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /setrespawn [ไอดี/ชื่อบางส่วน]");

	if(targetid == INVALID_PLAYER_ID)
		SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	ResyncSkin(targetid);
	return 1;
}

ResyncSkin(playerid) {
	if (isPlayerAndroid(playerid) == 0)
		return 1;

	gSyncMobile{playerid}=true;
	playerData[playerid][pInterior] = GetPlayerInterior(playerid);
	playerData[playerid][pVWorld] = GetPlayerVirtualWorld(playerid);
	GetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
	GetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
	GetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
	SpawnPlayer(playerid);
	return 1;
}

flags:freeze(CMD_ADM_2);
CMD:freeze(playerid, params[])
{
    new targetid;
    
	if(sscanf(params,"u",targetid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /freeze [ไอดี/ชื่อบางส่วน]");

	if(targetid == INVALID_PLAYER_ID)
		SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	TogglePlayerControllable(targetid, false);
	return 1;
}

flags:unfreeze(CMD_ADM_2);
CMD:unfreeze(playerid, params[])
{
    new targetid;
    
	if(sscanf(params,"u",targetid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /unfreeze [ไอดี/ชื่อบางส่วน]");

	if(targetid == INVALID_PLAYER_ID)
		SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	TogglePlayerControllable(targetid, true);
	return 1;
}

flags:kick(CMD_ADM_1);
CMD:kick(playerid, params[])
{
	new
	    userid,
	    reason[128];

	if (sscanf(params, "us[128]", userid, reason))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /kick [ไอดีผู้เล่น/ชื่อบางส่วน] [สาเหตุ]");

	if (userid == INVALID_PLAYER_ID || !IsPlayerConnected(userid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้เชื่อมต่อกับเซิร์ฟเวอร์");

    if (playerData[userid][pAdmin] > playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่สามารถใช้กับผู้เล่นที่มีอำนาจสูงกว่าได้");

	foreach(new i : Player) {
		PlayerPlaySound(i, 1148, 0.0, 0.0, 0.0);
	}

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ได้ถูกเตะโดย %s สาเหตุ: %s", ReturnPlayerName(userid), playerData[playerid][pAdminName], reason);
	Log(adminactionlog, INFO, "%s ถูกเตะโดย %s สาเหตุ %s", ReturnPlayerName(userid), playerData[playerid][pAdminName], reason);
	
	KickEx(userid);
	return 1;
}

flags:oban(CMD_ADM_1);
CMD:oban(playerid, params[])
{
	new
	    playerb,
	    reason[128];

	if (sscanf(params, "us[128]", playerb, reason))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /oban [ไอดีผู้เล่น/ชื่อบางส่วน] [สาเหตุ]");

	/*if (playerb == INVALID_PLAYER_ID || !IsPlayerConnected(playerb))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้เชื่อมต่อกับเซิร์ฟเวอร์");*/

    if (playerData[playerb][pAdmin] > playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่สามารถใช้กับผู้เล่นที่มีอำนาจสูงกว่าได้");

	/*foreach(new i : Player) {
		PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
	}*/

	//SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย %s สาเหตุ: %s", ReturnPlayerName(playerb), playerData[playerid][pAdminName], reason);
	Log(adminactionlog, INFO, "%s ถูกแบนโดย %s สาเหตุ %s", ReturnPlayerName(playerb), playerData[playerid][pAdminName], reason);
	
	new insertLog[256];
	
	mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', '%e', '%e', '%e', '%e')",
		playerData[playerb][pSID], ReturnPlayerName(playerb), reason, ReturnDate(), ReturnPlayerName(playerid), ReturnIP(playerb));
	
	mysql_tquery(dbCon, insertLog); 
	
	mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', '%e', '%e', '%e')",
		playerData[playerb][pSID], ReturnPlayerName(playerb), reason, ReturnPlayerName(playerid), ReturnDate());
		
	mysql_tquery(dbCon, insertLog); 
	
	KickEx(playerb);
	SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ทำการแบนผู้เล่น %s ย้อนหลัง, ผู้เล่นนั้นถูกแบนเรียบร้อยแล้ว");
	return 1;
}

flags:ban(CMD_ADM_1);
CMD:ban(playerid, params[])
{
	new
	    playerb,
	    reason[128];

	if (sscanf(params, "us[128]", playerb, reason))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /ban [ไอดีผู้เล่น/ชื่อบางส่วน] [สาเหตุ]");

	if (playerb == INVALID_PLAYER_ID || !IsPlayerConnected(playerb))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้เชื่อมต่อกับเซิร์ฟเวอร์");

    if (playerData[playerb][pAdmin] > playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่สามารถใช้กับผู้เล่นที่มีอำนาจสูงกว่าได้");

	foreach(new i : Player) {
		PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
	}

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย %s สาเหตุ: %s", ReturnPlayerName(playerb), playerData[playerid][pAdminName], reason);
	Log(adminactionlog, INFO, "%s ถูกแบนโดย %s สาเหตุ %s", ReturnPlayerName(playerb), playerData[playerid][pAdminName], reason);

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

flags:unban(CMD_ADM_3);
CMD:unban(playerid, params[])
{
	new name[MAX_PLAYER_NAME],
		insertLog[256];

	if(sscanf(params,"s[24]", name)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /unban [ชื่อผู้เล่น]");

	SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, "AdmCmd: %s ได้ปลดแบนผู้เล่น %s", ReturnPlayerName(playerid), name);
	
	mysql_format(dbCon, insertLog, sizeof(insertLog), "DELETE FROM `bannedlist` WHERE `CharacterName` = '%s'", name);	
	mysql_tquery(dbCon, insertLog); 

	mysql_format(dbCon, insertLog, sizeof(insertLog), "DELETE FROM `ban_logs` WHERE `CharacterName` = '%s'", name);	
	mysql_tquery(dbCon, insertLog); 

	SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้ปลดแบนผู้เล่น {FFFF00}%s {FFFFFF}เรียบร้อยแล้ว, ขอให้การตัดสินใจของคุณถูกต้อง", name);
	return 1;
}

flags:jetpack(CMD_ADM_3);
CMD:jetpack(playerid, params[])
{
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK); 	
	return 1;
}

flags:banip(CMD_ADM_1);
CMD:banip(playerid, params[])
{
	new
	    userid;

	if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /banip [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if (userid == INVALID_PLAYER_ID || !IsPlayerConnected(userid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้เชื่อมต่อกับเซิร์ฟเวอร์");

	foreach(new i : Player) {
		PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
	}

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนไอพีโดย %s", ReturnPlayerName(userid), ReturnPlayerName(playerid));
	Log(adminactionlog, INFO, "%s ถูกแบนไอพีโดย %s", ReturnPlayerName(userid), ReturnPlayerName(playerid));

	new IP[256];
	GetPlayerIp(userid, IP, sizeof(IP));
	SendRconCommand(sprintf("banip %s",IP));

	SendRconCommand("reloadbans");

	KickEx(userid);
	return 1;
}

flags:closeregis(CMD_ADM_3);
CMD:closeregis(playerid, params[]) {

    if(systemVariables[regisStatus] == 0) {
	    systemVariables[regisStatus] = 1;
	    SendClientMessageToAll(COLOR_LIGHTRED, "ประกาศ : ขณะนี้เซิร์ฟเวอร์ได้ทำการปิดรับสมัครสมาชิกชั่วคราวแล้ว");
    }
    else {
		return SendClientMessage(playerid, COLOR_GRAD1, "ระบบรับสมัครสมาชิกใหม่ถูกปิดใช้งานแล้ว");
	}
    
	return 1;
}

flags:openregis(CMD_ADM_3);
CMD:openregis(playerid, params[]) {
    
    if(systemVariables[regisStatus] == 1) {
	    systemVariables[regisStatus] = 0;
	    SendClientMessageToAll(COLOR_LIGHTRED, "ประกาศ : ขณะนี้เซิร์ฟเวอร์ได้ทำการเปิดรับสมัครสมาชิกแล้ว, ขอให้ผู้เล่นใหม่ทุกท่านสนุกกับเซิร์ฟเวอร์ของเรา");
    }
    else {
		return SendClientMessage(playerid, COLOR_GRAD1, "ระบบรับสมัครสมาชิกใหม่ถูกเปิดใช้งานแล้ว");
	}
    
	return 1;
}


flags:unbanip(CMD_ADM_1);
CMD:unbanip(playerid, params[])
{
	new
	    IP[16];

	if (sscanf(params, "s[16]", IP))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /unbanip [ที่อยู่ไอพี]");

	if (!IsIPAddress(IP))
		return SendClientMessage(playerid, COLOR_GRAD1, "   ที่อยู่ไอพีไม่ถูกต้อง!");

	SendRconCommand(sprintf("unbanip %s", IP));
	SendRconCommand("reloadbans");
	SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdmWarning: %s ได้ปลดแบนไอพี %s", ReturnPlayerName(playerid), IP);
	return 1;
}


flags:spec(CMD_ADM_1);
CMD:spec(playerid, params[]) {
    new
        userID;
    if(sscanf(params, "u", userID)) {
        return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /spec [ไอดีผู้เล่น/ชื่อบางส่วน]");
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
}

flags:makeadmin(CMD_DEV);
CMD:makeadmin(playerid, params[])
{
	new
		userid,
	    level;

	if (sscanf(params, "ud", userid, level))
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /makeadmin [ไอดีผู้เล่น/ชื่อบางส่วน] [เลเวล]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (level <= 0) {
	    SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้ปลดตำแหน่งผู้ดูแลระบบของ %s", ReturnRealName(userid));
	    SendClientMessageEx(userid, COLOR_YELLOW, "%s ได้ปลดตำแหน่งผู้ดูแลระบบของคุณ", ReturnRealName(playerid));
	}
	else if (level > playerData[userid][pAdmin])
	{
	    SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้เลื่อนตำแหน่ง %s ให้อยู่ในระดับที่สูงขึ้น (%d)", ReturnRealName(userid), level);
	    SendClientMessageEx(userid, COLOR_YELLOW, "%s ได้เลื่อนตำแหน่งให้คุณอยู่ในระดับที่สูงขึ้น (%d)", ReturnRealName(playerid), level);
	}
	else
	{
	    SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้ลดระดับ %s ให้อยู่ในระดับที่ต่ำกว่าปกติ (%d)", ReturnRealName(userid), level);
	    SendClientMessageEx(userid, COLOR_YELLOW, "%s ได้ลดระดับคุณอยู่ในระดับที่ต่ำกว่าปกติ (%d)", ReturnRealName(playerid), level);
	}

	playerData[userid][pAdmin] = level;
	SendAdminMessage(COLOR_YELLOW, CMD_DEV, "AdminWarning: %s ได้ปรับยศแอดมิน %s เป็นเลเวล %d", ReturnPlayerName(playerid), ReturnPlayerName(userid), level);
	
	switch(playerData[userid][pAdmin]) {
		case 1: {
			playerData[userid][pCMDPermission] = CMD_TESTER | CMD_ADM_1;
		}
		case 2: {
			playerData[userid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2;
		}
		case 3: {
			playerData[userid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3;
		}
		case 4: {
			playerData[userid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3 | CMD_LEAD_ADMIN;
		}
		case 5: {
			playerData[userid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3 | CMD_LEAD_ADMIN | CMD_MANAGEMENT;
		}
		case 6: {
			playerData[userid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3 | CMD_LEAD_ADMIN | CMD_MANAGEMENT | CMD_DEV;
		}
		default: {
			playerData[userid][pCMDPermission] = CMD_PLAYER;
		}
	}
	return 1;
}

flags:adminname(CMD_ADM_3);
CMD:adminname(playerid, params[]) {
    if(playerData[playerid][pAdmin] >= 3) {
        new
            userID,
            playerNameString[MAX_PLAYER_NAME],
			clean_admin[MAX_PLAYER_NAME],
			szQuery[128];

        if(sscanf(params, "us[24]", userID, playerNameString)) {
            return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /adminname [ไอดีผู้เล่น/ชื่อบางส่วน] [adminname]");
        }
        else {
            if(!IsPlayerConnected(userID))
				return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");

            if(playerData[userID][pAdmin]) {
                if(playerData[userID][pAdmin] > playerData[playerid][pAdmin]) {
                    return SendClientMessage(playerid, COLOR_GREY, "คุณไม่สามารถเปลี่ยนชื่อผู้ดูแลระบบที่มียศสูงกว่าได้");
                }
                else {
                    new
                        messageString[128];

                    format(messageString, sizeof(messageString), "คุณได้เปลี่ยนชื่อผู้ดูแล %s เป็น %s", ReturnRealName(userID), playerNameString);
                    SendClientMessage(playerid, COLOR_WHITE, messageString);

                    format(messageString, sizeof(messageString), "%s ได้เปลี่ยนชื่อผู้ดูแลของคุณเป็น %s", ReturnRealName(playerid), playerNameString);
                    SendClientMessage(userID, COLOR_WHITE, messageString);

					mysql_escape_string(playerNameString,clean_admin);
				    format(playerData[userID][pAdminName], MAX_PLAYER_NAME, clean_admin);
					format(szQuery, sizeof(szQuery), "UPDATE `players` SET `AdminName` = '%s' WHERE `ID` = %d", clean_admin, playerData[userID][pSID]);
					mysql_query(dbCon, szQuery);

                    return 1;
                }
            }
            else {
                return SendClientMessage(playerid, COLOR_GREY, "คุณไม่สามารถเปลี่ยนชื่อผู้ดูแลกับผู้เล่นได้");
            }
        }
	}
	return 1;
}

flags:setplayer(CMD_ADM_3);
CMD:setplayer(playerid, params[])
{
	new targetid, statcode, amount;

	if(sscanf(params, "udd", targetid, statcode, amount))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /setstat [ไอดีผู้เล่น/ชื่อบางส่วน] [statcode] [จำนวน]");
		SendClientMessage(playerid, COLOR_GRAD4, "|1 Level |2 Skin |3 RespectPoints |4 Bank");
		SendClientMessage(playerid, COLOR_GRAD4, "|6 Hours |7 Cash |8 Donate |9 Upgrade |10 Phone Number ");
		SendClientMessage(playerid, COLOR_GRAD4, "|11 Saving |12 Score");
		SendClientMessage(playerid, COLOR_GRAD4, "|18 Job |19 Side Job");
		SendClientMessage(playerid, COLOR_GRAD4, "|23 Car License");
        SendClientMessage(playerid, COLOR_GRAD4, "|26 Wear Skin |27 SavingsCollect");
		return 1;
	}

	if (targetid == INVALID_PLAYER_ID) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นยังไม่ได้เข้าสู่ระบบ !");
	
	switch (statcode)
	{
		case 1:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับเลเวลของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pLevel]);
			playerData[targetid][pLevel] = amount;
		}
		case 2:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับสกินของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, GetPlayerSkin(targetid));
			SetPlayerSkin(targetid, amount);
			playerData[targetid][pModel] = amount;
			ResyncSkin(targetid);
		}
		case 3:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับ Exp ของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pExp]);
			playerData[targetid][pExp] = amount;
		}
		case 4:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับเงินในธนาคารของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pAccount]);
			playerData[targetid][pAccount] = amount;
		}
		case 6:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับชั่วโมงการเล่นของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pPlayingHours]);
			playerData[targetid][pPlayingHours] = amount;
		}
		case 7:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับเงินของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pCash]);
			playerData[targetid][pCash] = amount;
			ResetPlayerMoney(targetid);
			GivePlayerMoney(targetid, amount);
		}
		case 8:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับระดับผู้บริจาคของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pDonateRank]);
			playerData[targetid][pDonateRank] = amount;
		}
		case 9:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับค่าอัพเกรดของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pPUpgrade]);
			playerData[targetid][pPUpgrade] = amount;
		}
		case 10:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับเบอร์โทรศัพท์ของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pPnumber]);
			playerData[targetid][pPnumber] = amount;
		}
		case 11:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับเงินฝากเริ่มต้นของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pSavings]);
			playerData[targetid][pSavings] = amount;
		}
		case 12:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับ Score ของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pScore]);
			playerData[targetid][pScore] = amount;
		}
		case 18:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับอาชีพของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pJob]);
			playerData[targetid][pJob] = amount;
		}
		case 19:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับอาชีพเสริมของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pSideJob]);
			playerData[targetid][pSideJob] = amount;
		}
		case 23:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับใบขับขี่ของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), !!amount, playerData[targetid][pCarLic]);
			playerData[targetid][pCarLic] = !!amount;
		}
		case 26:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับสกินของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pWear]);
            playerData[targetid][pWear] = amount;
            SetPlayerSkin(targetid, playerData[targetid][pWear] ? playerData[targetid][pWear] : playerData[targetid][pModel]);
			ResyncSkin(targetid);
		}
		case 27:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับเงินฝากสะสมของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pSavingsCollect]);
            playerData[targetid][pSavingsCollect] = amount;
		}
	}
	OnAccountUpdate(targetid);
	return 1;
}

flags:setstat(CMD_ADM_3);
CMD:setstat(playerid, params[])
{
	new targetid, statcode, amount;

	if(sscanf(params, "udd", targetid, statcode, amount))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /setstat [ไอดีผู้เล่น/ชื่อบางส่วน] [statcode] [จำนวน]");
		SendClientMessage(playerid, COLOR_GRAD4, "|1 Level |2 Skin |3 RespectPoints");
		SendClientMessage(playerid, COLOR_GRAD4, "|4 Hours |5 Upgrade |6 Phone Number ");
		SendClientMessage(playerid, COLOR_GRAD4, "|7 Score |8 Job |9 Side Job |10 Car License");
        SendClientMessage(playerid, COLOR_GRAD4, "|11 Wear Skin ");
		return 1;
	}

	if (targetid == INVALID_PLAYER_ID) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นยังไม่ได้เข้าสู่ระบบ !");
	
	switch (statcode)
	{
		case 1:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับเลเวลของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pLevel]);
			playerData[targetid][pLevel] = amount;
		}
		case 2:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับสกินของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, GetPlayerSkin(targetid));
			SetPlayerSkin(targetid, amount);
			playerData[targetid][pModel] = amount;
			ResyncSkin(targetid);
		}
		case 3:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับ Exp ของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pExp]);
			playerData[targetid][pExp] = amount;
		}
		/*case 4:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับเงินในธนาคารของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pAccount]);
			playerData[targetid][pAccount] = amount;
		}*/
		case 4:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับชั่วโมงการเล่นของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pPlayingHours]);
			playerData[targetid][pPlayingHours] = amount;
		}
		/*case 7:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับเงินของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pCash]);
			playerData[targetid][pCash] = amount;
			ResetPlayerMoney(targetid);
			GivePlayerMoney(targetid, amount);
		}
		case 8:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับระดับผู้บริจาคของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pDonateRank]);
			playerData[targetid][pDonateRank] = amount;
		}*/
		case 5:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับค่าอัพเกรดของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pPUpgrade]);
			playerData[targetid][pPUpgrade] = amount;
		}
		case 6:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับเบอร์โทรศัพท์ของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pPnumber]);
			playerData[targetid][pPnumber] = amount;
		}
		/*case 11:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับเงินฝากเริ่มต้นของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pSavings]);
			playerData[targetid][pSavings] = amount;
		}*/
		case 7:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับ Score ของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pScore]);
			playerData[targetid][pScore] = amount;
		}
		case 8:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับอาชีพของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pJob]);
			playerData[targetid][pJob] = amount;
		}
		case 9:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับอาชีพเสริมของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pSideJob]);
			playerData[targetid][pSideJob] = amount;
		}
		case 10:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับใบขับขี่ของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), !!amount, playerData[targetid][pCarLic]);
			playerData[targetid][pCarLic] = !!amount;
		}
		case 11:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับสกินของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pWear]);
            playerData[targetid][pWear] = amount;
            SetPlayerSkin(targetid, playerData[targetid][pWear] ? playerData[targetid][pWear] : playerData[targetid][pModel]);
			ResyncSkin(targetid);
		}
		/*case 27:
		{
			SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdminWarning: %s ได้ปรับเงินฝากสะสมของ %s เป็น %d (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount, playerData[targetid][pSavingsCollect]);
            playerData[targetid][pSavingsCollect] = amount;
		}*/
	}
	OnAccountUpdate(targetid);
	return 1;
}



flags:fixveh(CMD_ADM_1);
CMD:fixveh(playerid, params[])
{
	new vehicleid;
	
	if(IsPlayerInAnyVehicle(playerid) && (vehicleid = GetPlayerVehicleID(playerid)))
	{
		SetVehicleHealthEx(vehicleid, GetVehicleDataHealth(GetVehicleModel(vehicleid)));
		// SetVehicleDamageStatus(vehicleid, 0, 0, 0, 0);
		UpdateVehicleDamageStatus(vehicleid, 0, 0, 0, 0);
		SendClientMessage(playerid, COLOR_GREY, "   ยานพาหนะถูกซ่อม !");
	}
	return 1;
}

flags:slap(CMD_ADM_1);
CMD:slap(playerid, params[])
{
	new targetid,Float:slx, Float:sly, Float:slz;
	
	if(sscanf(params,"u",targetid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /slap [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	GetPlayerPos(targetid, slx, sly, slz);
	SetPlayerPos(targetid, slx, sly, slz+5);
	PlayerPlaySound(targetid, 1130, slx, sly, slz+5);

	return 1;
}


flags:ajail(CMD_ADM_1);
CMD:ajail(playerid, params[])
{
	new targetid, time, reason[128];
	if(sscanf(params,"uds[128]",targetid, time, reason)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /ajail [ไอดีผู้เล่น/ชื่อบางส่วน] [time] [reason]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if(time <= 0) return SendClientMessage(playerid, COLOR_GRAD1, "เวลาต้องมากกว่า 0!");

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกส่งคุกโดย %s เป็นเวลา %d นาที สาเหตุ: %s", ReturnPlayerName(targetid), playerData[playerid][pAdminName], time, reason);

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

	SetPlayerPos(targetid, 2576.7861, 2712.2004, 22.9507);

	return 1;
}

flags:oajail(CMD_ADM_1);
CMD:oajail(playerid, params[])
{

	new insertQuery[256], playerb[32], length, reason[128]; 
	
	if(sscanf(params, "s[32]ds[128]", playerb, length, reason))
		return SendClientMessage(playerid, COLOR_GRAD1, "/oajail [ชื่อเต็ม] [time in minutes] [reason]"); 
		
	foreach(new i : Player)
	{
		if(!strcmp(ReturnPlayerName(i), playerb))
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "%s ได้อยู่ในเซิร์ฟเวอร์ (ID: %i)", playerb, i);
			return 1;
		}
	}
	
	if(!DoesPlayerExist(playerb))
		return SendClientMessageEx(playerid, COLOR_LIGHTRED, "%s ไม่มีอยู่ในฐานข้อมูล", playerb); 
		
	mysql_format(dbCon, insertQuery, sizeof(insertQuery), "UPDATE players SET Jailed = 1, JailTime = %i WHERE Name = '%e'", length * 60, playerb);
	mysql_tquery(dbCon, insertQuery, "OnOfflineAjail", "issi", playerid, playerb, reason, length); 

	return 1;
}

forward OnOfflineAjail(playerid, jailing[], reason[], length);
public OnOfflineAjail(playerid, jailing[], reason[], length)
{
	SendClientMessageEx(playerid, COLOR_GRAD1, "%s ถูกส่งคุกแอดมินเรียบร้อยแล้ว", jailing); 
	
	new
		logQuery[256]
	;
	
	mysql_format(dbCon, logQuery, sizeof(logQuery), "INSERT INTO ajail_logs (JailedDBID, JailedName, Reason, Date, JailedBy) VALUES(%i, '%e', '%e', '%e', '%e')", ReturnDBIDFromName(jailing), jailing, reason, ReturnDate(), ReturnPlayerName(playerid));
	mysql_tquery(dbCon, logQuery); 
	return 1;
}

flags:aunjail(CMD_ADM_1);
CMD:aunjail(playerid, params[])
{
	new targetid;
	if(sscanf(params,"u",targetid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /aunjail [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");


	playerData[targetid][pJailed] = 0;
	playerData[targetid][pJailTime] = 0;
	SetPlayerSkin(targetid, playerData[targetid][pWear] ? playerData[targetid][pWear] : playerData[targetid][pModel]);

	SendClientMessage(targetid, COLOR_YELLOW, "คุณถูกปล่อยออกจากคุกแอดมิน !");

	SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, "AdmWarning: %s ได้ถูกปล่อยออกจากคุก/เรือนจำโดยผู้ดูแลระบบ %s", ReturnPlayerName(targetid), ReturnRealName(playerid));

	SpawnPlayer(targetid);
	return 1;
}

flags:setexp(CMD_MANAGEMENT);
CMD:setexp(playerid, params[])
{
	new multiplyexp;
	if(sscanf(params,"i",multiplyexp)) 
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /setexp [(ปกติ 1)]");
		return 1;
	}
	gMultipleEXP = multiplyexp;

	if(multiplyexp == 1)
	{
		SendClientMessageToAllEx(COLOR_LIGHTRED,"%s ได้ปรับค่าประสบการณ์ให้เป็นปกติ", ReturnPlayerName(playerid));
	}
	else
	{
		SendClientMessageToAllEx(COLOR_LIGHTRED, "%s ได้ปรับค่าประสบการณ์คูณ %d", ReturnPlayerName(playerid), gMultipleEXP);
	}
	return 1;
}

flags:togac(CMD_ADM_1);
CMD:togac(playerid,params[])
{
	if(!BitFlag_Get(gPlayerBitFlag[playerid], TOGGLE_AC))
	{
		BitFlag_On(gPlayerBitFlag[playerid], TOGGLE_AC);
	    SendClientMessage(playerid,COLOR_GREEN,"ปิดกั้นระบบแชท AntiCheat");
	    return 1;
	}
	else
	{
		BitFlag_Off(gPlayerBitFlag[playerid], TOGGLE_AC);
	    SendClientMessage(playerid,COLOR_GREEN,"ยกเลิกการบล็อกระบบแชท AntiCheat แล้ว");
	    return 1;
	}
}

/*flags:clearwanted(CMD_ADM_3);
CMD:clearwanted(playerid, params[]) {
	new
	    userID;

	if(sscanf(params, "u", userID)) {
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /clearwanted [ไอดีผู้เล่น/ชื่อบางส่วน]");
	}
	else {

		if(userID == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

		SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdmWarning: %s ได้ลบล้างความผิดทั้งหมดของ %s", ReturnPlayerName(playerid), ReturnPlayerName(userID));
		playerData[userID][pWarrants] = 0;
		SetPlayerWantedLevel(userID, 0);
		ClearCrime(userID);
	}
    return 1;
}*/

flags:setscore(CMD_ADM_3);
CMD:setscore(playerid, params[])
{
	new
	    targetid, score;

	if (sscanf(params, "ud", targetid, score))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /setscore [ไอดีผู้เล่น/ชื่อบางส่วน] [คะแนน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

	if (score < 1)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   โปรดระบุคะแนนมากกว่า 1 คะแนน");

	playerData[targetid][pScore] += score;

	SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "คุณได้%sคะแนนของ %s จำนวน %d Score", score ? ("เพิ่ม") : ("ลด"), ReturnRealName(targetid), score);
	SendClientMessageEx(targetid, COLOR_LIGHTGREEN, "%s ได้%sคะแนนของคุณ จำนวน %d Score", ReturnRealName(playerid), score ? ("เพิ่ม") : ("ลด"), score);

	Log(adminactionlog, INFO, "%s %s Score ของ %s จำนวน %d", ReturnPlayerName(playerid), score ? ("เพิ่ม") : ("ลด"), ReturnPlayerName(targetid), score);
	
	SetPlayerScore(targetid, playerData[targetid][pScore]);
	return 1;
}

flags:clearore(CMD_ADM_3);
CMD:clearore(playerid, params[])
{
	new
	    targetid;

	if (sscanf(params, "u", targetid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /clearore [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if (targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	playerData[targetid][pOre] = 0;
	playerData[targetid][pIrons] = 0;
	playerData[targetid][pCold] = 0;
	playerData[targetid][pDiamond] = 0;

	SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "คุณได้ทำการล้างแร่ภายในตัวของ %s ทั้งหมด", ReturnRealName(targetid));
	SendClientMessageEx(targetid, COLOR_LIGHTGREEN, "%s ได้ทำการล้างแร่ภายในตัวของคุณทั้งหมด", ReturnRealName(playerid));

	return 1;
}

flags:checkhouse(CMD_ADM_3);
CMD:checkhouse(playerid, params[])
{
	new
	    amount;

	if (sscanf(params, "d", amount))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /checkhouse [จำนวนเงินขั้นต่ำภายในบ้าน]");

   	foreach(new i : Iter_House)
    {
        if (houseData[i][hCash] >= amount)
        {
            SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdmCmd: บ้าน ID %d มีเงินเก็บในบ้านมากกว่าจำนวน %s", houseData[i][hID], FormatNumber(houseData[i][hCash]));
        }
    }

	return 1;
}

/* // NOT LIKE THIS
flags:minusscore(CMD_ADM_3);
CMD:minusscore(playerid, params[])
{
	new
	    targetid, score;

	if (sscanf(params, "ud", targetid, score))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /minusscore [ไอดีผู้เล่น/ชื่อบางส่วน] [คะแนน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

	if (score < 1)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   โปรดระบุคะแนนที่ลบมากกว่า 1 คะแนน");

	playerData[targetid][pScore] -= score;

	SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณได้ลบคะแนน %d กับ %s", score, ReturnRealName(targetid));
	Log(adminactionlog, INFO, "%s ให้ลบคะแนนให้ %s จำนวน %d", ReturnPlayerName(playerid), ReturnPlayerName(targetid), score);
	SetPlayerScore(targetid, playerData[targetid][pScore]);
	return 1;
}*/

forward GlobalSaving();
public GlobalSaving()
{
	//-------------------------------------------------
	foreach(new i : Player)
	{
		OnAccountUpdate(i);
	}
	//-------------------------------------------------
	foreach(new i : Iter_House) House_Save(i);
	foreach(new i : Iter_Business) Business_Save(i);
	foreach(new i : Iter_PlayerCar) PlayerCar_SaveID(i);
	foreach(new i : Iter_ServerCar) Vehicle_Save(i); 
	
	return 1;
}

forward playerLoop();
public playerLoop()
{
	foreach (new x : Player) 
	{
        if(playerData[x][pNewbieTimeout] > 0) {
            playerData[x][pNewbieTimeout]--;
            if(playerData[x][pNewbieTimeout] == 0) SendClientMessage(x, COLOR_LIGHTBLUE, "ขณะนี้คุณสามารถใช้งานช่องทางสนทนา Newbie ได้อีกครั้ง");
        }

		if(LegDelay[x] > 0) LegDelay[x]--;
	}
}

CMD:saveall(playerid)
{
	if(playerData[playerid][pAdmin] < 4)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

    GlobalSaving();
    SendClientMessageToAll(COLOR_YELLOW, "ระบบได้ทำการบันทึกข้อมูลผู้เล่นทุกคนภายในเซิร์ฟเวอร์เรียบร้อยแล้ว, รวมถึงรถ,ธุรกิจ,บ้าน");

	return 1;
}



