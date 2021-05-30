#include <YSI\y_hooks>

#define MAX_PLAYER_RACE	20
//#define DIALOG_RACE 1002
//==============================forwards ======================================//
forward OnPlayerFreezed(playerid);
//=============================Varaibles ======================================//

new Float:CP_SIZE = 10.0;
new RACE_STARTED;
new RACE_CP[MAX_PLAYERS];
new PLAYER_IN_RACE[MAX_PLAYERS char];
new CREATING_CHECKPOINTS;
new CP_COUNTER;
new Float:Rx[15] , Float:Ry[15] , Float:Rz[15];
new COUNT_DOWN , Timer:RACE_TIMER;
new RACE_EVENT_ACTIVE;
new Timer:FREEZE_PLAYER[MAX_PLAYERS];
new RACE_CREATED;
new PLAYER_VEHICLE[MAX_PLAYERS];

hook OnGameModeInit()
{
	print("\n--------------------------------------");
	print(" 	ระบบแข่งรถ LOADED				   ");
	print("--------------------------------------\n");
	return 1;
}

hook OnGameModeExit()
{
	stop RACE_TIMER;
	return 1;
}


//================================ CommanDs ============================================//

CMD:rcmds(playerid)
{
	SendClientMessage(playerid,COLOR_YELLOW,"==============| ระบบแข่งรถ |==============");
	SendClientMessage(playerid,-1,"=============| /createrace   |=============");
	SendClientMessage(playerid,-1,"=============| /enableraceevent |=============");
	SendClientMessage(playerid,-1,"=============| /startrace	  |=============");
	SendClientMessage(playerid,-1,"=============| /endrace	  |=============");
	SendClientMessage(playerid,-1,"=============| /joinrace 	  |=============");
	SendClientMessage(playerid,-1,"=============| /leaverace 	  |=============");
	SendClientMessage(playerid,COLOR_YELLOW,"==============| ระบบแข่งรถ |==============");
	return 1;
}

flags:createrace(CMD_ADM_1);
CMD:createrace(playerid)
{
	if(RACE_STARTED == 1)return SendClientMessage(playerid,-1,"You can't make race right now! Please let the race finish first.");
	CREATING_CHECKPOINTS = 1;
	CP_COUNTER = 0;
	SendClientMessage(playerid,-1,"[ระบบแข่งรถ]: You've to press Fire Key to create checkpoints.");
	return 1;
}

flags:enableraceevent(CMD_ADM_1);
CMD:enableraceevent(playerid)
{   new string[128];
	if(RACE_CREATED == 0)return SendClientMessage(playerid,-1,"You need to create all 14 checkpoint to start the race.");
	if(RACE_STARTED == 1)return SendClientMessage(playerid,-1,"Race is already enabled .");
	RACE_STARTED = 1;
	format(string,sizeof(string),"แอดมิน %s ได้เริ่มกิจกรรมแข่งรถ พิมพ์ /joinrace เพื่อเข้าร่วม", GetName(playerid));
	SendClientMessageToAll(COLOR_YELLOW,string);
	SendClientMessage(playerid,-1,"ใช้ /startrace เพื่อเริ่ม");
	return 1;
}

flags:endrace(CMD_ADM_1);
CMD:endrace(playerid)
{
	if(RACE_STARTED == 0) 
		return SendClientMessage(playerid,-1,"There is no race going on at moment.");

	RACE_STARTED = 0;
	RACE_EVENT_ACTIVE = 0;
	foreach(new i : Player)
	{
		if(PLAYER_IN_RACE{i})
		{
			if (PLAYER_VEHICLE[i] != INVALID_VEHICLE_ID) {
				DestroyVehicle(PLAYER_VEHICLE[i]);
				PLAYER_VEHICLE[i] = INVALID_VEHICLE_ID;
			}

            PLAYER_IN_RACE{i} = false;
			DisablePlayerCheckpoint(i);
 			RACE_CP[i] = 0;
			 
			SetPlayerPos(i, playerData[i][pPosX], playerData[i][pPosY], playerData[i][pPosZ]);
		}
	}
 	stop RACE_TIMER;
	SendClientMessage(playerid,-1,"You've successfully stop the race.");
	return 1;
}

flags:startrace(CMD_ADM_1);
CMD:startrace(playerid)
{
	RACE_EVENT_ACTIVE = 1;
	COUNT_DOWN = 15;
	SendClientMessage(playerid,-1,"You've successfully started the race event.");

	RACE_TIMER = repeat OnPlayerRaceCountDown();
	return 1;
}

CMD:joinrace(playerid,params[])
{
	if(RACE_EVENT_ACTIVE == 1) 
		return SendClientMessage(playerid,-1,"คุณมาช้าไป ไว้เจอกันรอบหน้า");

	new string[128];
	if(RACE_STARTED == 1)
	{
		PLAYER_IN_RACE{playerid} = true;
		new total = TOTAL_PLAYER_IN_RACE();
		RACE_CP[playerid] = 0;
		ResetPlayerWeapons(playerid);

		GetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);

		new Float:RdX, Float:RdY;

		RdX = Rx[0];
		RdY = Ry[0];
		
		GetAroundPosition(RdX,RdY, 10);

		SetPlayerPos(playerid,RdX,RdY,Rz[0]);
		SetPlayerCheckpoint(playerid,Rx[0],Ry[0],Rz[0], CP_SIZE);
		Dialog_Show(playerid,RacingDialog,DIALOG_STYLE_LIST, "Race Cars Menu", "Bullet\nTurismo\nSultan\nAlpha\nHotring\nSandking\nSentinel","เลือก" ,"ปิด");
		SendClientMessage(playerid,-1,"คุณได้เข้าร่วมกิจกรรมแข่งรถสำเร็จแล้ว");
		SendClientMessage(playerid,-1,"โปรดรอผู้เล่นอื่นคนอื่น ๆ เข้าร่วมกิจกรรมนี้สักครู่");

		format(string,sizeof(string),"[ระบบแข่งรถ]: จำนวนผู้เข้าแข่งขันทั้งหมด %d/%d (/joinrace)",total, MAX_PLAYER_RACE);
		SendClientMessageToAll(-1,string);

		if (total >= MAX_PLAYER_RACE) {
			RACE_EVENT_ACTIVE = 1;
			COUNT_DOWN = 15;

			RACE_TIMER = repeat OnPlayerRaceCountDown();
		}
	}
	return 1;
}

CMD:leaverace(playerid,params[])
{
	if(!PLAYER_IN_RACE{playerid}) 
		return SendClientMessage(playerid,-1,"คุณไม่ได้เข้าร่วมการแข่งขันใด ๆ");

	PLAYER_IN_RACE{playerid} = false;
	RACE_CP[playerid] = 1;
	DisablePlayerCheckpoint(playerid);
	SendClientMessage(playerid,-1,"คุณได้ออกจากการแข่งขันเรียบร้อยแล้ว");

	if (PLAYER_VEHICLE[playerid] != INVALID_VEHICLE_ID) {
		DestroyVehicle(PLAYER_VEHICLE[playerid]);
		PLAYER_VEHICLE[playerid] = INVALID_VEHICLE_ID;
	}
	SetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
	return 1;
}

//================================ Functions && Callbacks ============================================//
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_FIRE) && CREATING_CHECKPOINTS == 1 && playerData[playerid][pAdmin] && CP_COUNTER <= 14)
    {
        new Float: X , Float: Y , Float: Z;
		GetPlayerPos(playerid,X,Y,Z);
		Rx[CP_COUNTER]= X , Ry[CP_COUNTER] = Y , Rz[CP_COUNTER] = Z;

		new string[128];
		format(string,sizeof(string),"You've successfully created checkpoint [%d / 14]",CP_COUNTER);
		SendClientMessage(playerid,-1,string);

		if (CP_COUNTER == 14) {
			CREATING_CHECKPOINTS = 0;
			RACE_CREATED = 1;
			SendClientMessage(playerid,-1,"Congratz You've successfully created Race checkpoints.");
		}
		else {
			CP_COUNTER++;
		}
	}
	return 1;
}

CreateRaceVehicle(playerid,vehicleid)
{
	new Float:pX,Float:pY,Float:pZ,Float:pw;
	GetPlayerPos(playerid, pX,pY,pZ);
	GetPlayerFacingAngle(playerid, pw);
	
	PLAYER_VEHICLE[playerid] = CreateVehicle(vehicleid, pX, pY, pZ, pw, 0, 0, 0);
	SetEngineStatus(PLAYER_VEHICLE[playerid], true);
	SetLockStatus(PLAYER_VEHICLE[playerid], false);

	PutPlayerInVehicle(playerid, PLAYER_VEHICLE[playerid], 0);
	FREEZE_PLAYER[playerid] = defer OnPlayerFreezed(playerid);

	SendClientMessage(playerid,-1,"[ระบบแข่งรถ]: คุณมีเวลา 10 วินาทีในการเตรียมตำแหน่งสำหรับออกตัว");
	return 1;
}

timer OnPlayerFreezed[10000](playerid)
{
	SendClientMessage(playerid,-1,"[ระบบแข่งรถ]: คุณถูกแช่แข็งในขณะนี้! โปรดรอสมาชิกท่านอื่นเข้าร่วมการแข่งขันสักครู่");
	stop FREEZE_PLAYER[playerid];
	TogglePlayerControllable(playerid, 0);
	return 1;
}
//new Cash[] = {5000,10000,8000,9000,7000};
hook OnPlayerEnterCheckpoint(playerid)
{
	if(PLAYER_IN_RACE{playerid} && RACE_STARTED == 1  && RACE_EVENT_ACTIVE == 1 && IsPlayerInAnyVehicle(playerid))
	{
		if(RACE_CP[playerid] == 14 )
		{
			new race_score = 10 + random(20);
			new string[128];
			DisablePlayerCheckpoint(playerid);
		    format(string,sizeof(string),"[ระบบแข่งรถ]: ขอแสดงความยินดีกับ %s ได้เข้าเส้นชัยเป็นคนแรกและได้รับชัยชนะ และได้รับ %d Score",GetName(playerid), race_score);
			SendClientMessageToAll(COLOR_YELLOW,string);
			playerData[playerid][pScore] += race_score;
		    RACE_STARTED = 0;
			RACE_EVENT_ACTIVE = 0;
			PlayerPlaySound(playerid, 4203, 0.0, 0.0, 0.0);

			foreach(new i : Player)
			{
				if(PLAYER_IN_RACE{i})
				{
					if (PLAYER_VEHICLE[i] != INVALID_VEHICLE_ID) {
						DestroyVehicle(PLAYER_VEHICLE[i]);
						PLAYER_VEHICLE[i] = INVALID_VEHICLE_ID;
					}

					PLAYER_IN_RACE{i} = false;
					DisablePlayerCheckpoint(i);
					RACE_CP[i] = 0;

					SetPlayerPos(i, playerData[i][pPosX], playerData[i][pPosY], playerData[i][pPosZ]);
				}
			}
		}
		else
		{
			PlayerPlaySound(playerid, 4203, 0.0, 0.0, 0.0);
		    RACE_CP[playerid]++;
			new string[128];
			format(string,sizeof(string),"~y~You've successfully ~n~~r~captured %d checkpoints ~n~~b~Total CP (%d | 14) ",RACE_CP[playerid],RACE_CP[playerid]);
	    	GameTextForPlayer(playerid,string,1000,5);
	    	OnPlayerEnterCP(playerid);
		}
	}
	return 1;
}

OnPlayerEnterCP(playerid)
{
	if(PLAYER_IN_RACE{playerid} && RACE_STARTED == 1)
	{
		if (RACE_CP[playerid] < 15) {
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, Rx[RACE_CP[playerid]],Ry[RACE_CP[playerid]],Rz[RACE_CP[playerid]], CP_SIZE);
		}
	}
	return 1;
}

GetName(playerid)
{
	new JName[MAX_PLAYER_NAME];
	GetPlayerName(playerid,JName,MAX_PLAYER_NAME);
	return JName;
}

timer OnPlayerRaceCountDown[1000]()
{
	new string[128];
	COUNT_DOWN -- ;

	//printf("DEBUG: Countdown: %d", COUNT_DOWN);
	if(COUNT_DOWN <= 1)
	{
 		format(string, sizeof(string), "~r~RACE IS~n~~b~STARTED.");
	    stop RACE_TIMER;

		foreach(new i : Player)
		{
			if(PLAYER_IN_RACE{i})
			{
	  			TogglePlayerControllable(i, 1);
		    	GameTextForPlayer(i,string,2000,3);
				PlayerPlaySound(i, 4203, 0.0, 0.0, 0.0);
			}
		}
	}
    format(string, sizeof(string), "~r~RACE IS GOING~n~~n~~y~TO~n~Start In~n~~r~%d ~y~~n~seconds.",COUNT_DOWN);
	foreach(new i : Player)
	{
		if(PLAYER_IN_RACE{i})
		{
	    	GameTextForPlayer(i,string,2000,3);
			PlayerPlaySound(i, 4203, 0.0, 0.0, 0.0);
		}
	}
	return 1;
}

TOTAL_PLAYER_IN_RACE()
{
	new count;
	foreach(new i : Player)
	{
		if(PLAYER_IN_RACE{i})
		{
			count++;
		}
	}
	return count;
}

hook OnPlayerConnect(playerid)
{
	PLAYER_VEHICLE[playerid] = INVALID_VEHICLE_ID;
	PLAYER_IN_RACE{playerid} = false;
	RACE_CP[playerid] = 0;
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if(PLAYER_IN_RACE{playerid})
	{
		if (PLAYER_VEHICLE[playerid] != INVALID_VEHICLE_ID) {
			DestroyVehicle(PLAYER_VEHICLE[playerid]);
			PLAYER_VEHICLE[playerid] = INVALID_VEHICLE_ID;
		}

		PLAYER_IN_RACE{playerid} = false;
		RACE_CP[playerid] = 0;
		stop FREEZE_PLAYER[playerid];
		DisablePlayerCheckpoint(playerid);

		SetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
	}
	return 1;
}

GetAroundPosition(&Float:x, &Float:y, distance = 5)
{
	// Created by Y_Less
	if (random(2) == 0) {
		x += ( float(1 + random(distance)) * floatsin(-float(random(90)), degrees));
	}
	else {
		x -= ( float(1 + random(distance)) * floatsin(-float(random(90)), degrees));
	}
	if (random(2) == 0) {
		y += ( float(1 + random(distance)) * floatcos(-float(random(90)), degrees));
	}
	else {
		y += ( float(1 + random(distance)) * floatcos(-float(random(90)), degrees));
	}
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
	if (oldstate == PLAYER_STATE_DRIVER) {
		if(PLAYER_IN_RACE{playerid}) {
			PLAYER_IN_RACE{playerid} = false;
			RACE_CP[playerid] = 1;
			DisablePlayerCheckpoint(playerid);
			SendClientMessage(playerid,-1,"คุณได้ออกจากการแข่งขันเรียบร้อยแล้ว");
			
			if (PLAYER_VEHICLE[playerid] != INVALID_VEHICLE_ID) {
				DestroyVehicle(PLAYER_VEHICLE[playerid]);
				PLAYER_VEHICLE[playerid] = INVALID_VEHICLE_ID;
			}

			SetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
			return -2;
		}
	}
	return 1;
}

Dialog:RacingDialog(playerid, response, listitem, inputtext[])
{
	switch(listitem)
	{
		case 0:
		{
			CreateRaceVehicle(playerid,541);
		}
		case 1:
		{
			CreateRaceVehicle(playerid,451);
		}
		case 2:
		{
			CreateRaceVehicle(playerid,560);
		}
		case 3:
		{
			CreateRaceVehicle(playerid,602);
		}
		case 4:
		{
			CreateRaceVehicle(playerid,494);
		}
		case 5:
		{
			CreateRaceVehicle(playerid,495);
		}
		case 6:
		{
			CreateRaceVehicle(playerid,405);
		}
		default: {
			CreateRaceVehicle(playerid,494);
		}
	}
}
