#include <YSI\y_hooks>

hook OnGameModeInit()
{
	SetTimer("playerLoopTie", 1000, true);
}

hook OnPlayerDisconnect(playerid, reason) {

	if(playerData[playerid][pDrag] != -1) {
		SendClientMessage(playerData[playerid][pDrag], COLOR_WHITE, "คนที่คุณถูกลากได้ตัดการเชื่อมต่อ");
		playerData[playerData[playerid][pDrag]][pDrag] = -1; 
	}	

	if(reason == 0)
	{
		OnAccountUpdate(playerid);
	}

	OnAccountUpdate(playerid);
}

CMD:tie(playerid, params[])
{	
	new
	    targetID;

	if(sscanf(params, "u", targetID)) { // Using sscanf instead of isnull because we're handling a playerid/name.
    	return SendClientMessage(playerid, COLOR_GRAD2, "การใช้: /tie [ไอดีผู้เล่น/ชื่อบางส่วน]");
    }
    else {
		if(targetID == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GRAD2, "ID ผู้เล่นที่ระบุไม่ได้เชื่อมต่อหรือไม่ได้รับการรับรองความถูกต้อง");

		/*if(targetID == playerid)
			return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่สามารถมัดตัวเองได้");*/

		/*if(playerVariables[playerid][pPrisonTime] >= 1)
			return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่สามารถดำเนินการนี้ได้ในขณะอยู่ในเรือนจำ");*/


		if(IsPlayerNearPlayer(playerid, targetID, 2.0)) {

			/*new
				playerName[2][MAX_PLAYER_NAME],
				msgSz[128];

			GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
			GetPlayerName(targetID, playerName[1], MAX_PLAYER_NAME);*/

			if(playerData[playerid][pTie] >= 1) {
				if(random(6) < 3) {
					if(playerData[targetID][pFreezeType] > 0 && playerData[targetID][pFreezeType] < 5) {
						return SendClientMessage(playerid, COLOR_GRAD2, "พยายามที่ล้มเหลว ผู้เล่นนี้ถูกทำให้นิ่งอยู่แล้ว");
					}
					else {
						//GiveItemToPlayer(playerid, "Rope", -1);
                        playerData[playerid][pTie] -= 1;

						/*format(msgSz, sizeof(msgSz), "* %s ได้มัด %s ไว้แล้ว", playerName[0], playerName[1]);
						nearByMessage(playerid, COLOR_PURPLE, msgSz);*/

                        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้หยิบเชือกออกมาแล้วมัด %s สำเร็จ !!", ReturnRealName(playerid), ReturnRealName(targetID));
						TogglePlayerControllable(targetID, false);

						playerData[targetID][pFreezeType] = 4;
						playerData[targetID][pFreezeTime] = 180;

						return SendClientMessage(playerid, COLOR_YELLOW, "ความพยายามสำเร็จเรียบร้อยแล้ว !");
					}
				}
				else {
                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้หยิบเชือกออกมาแล้วมัด %s แต่ไม่สำเร็จ !!", ReturnRealName(playerid), ReturnRealName(targetID));
					TogglePlayerControllable(targetID, false);

					return SendClientMessage(playerid, COLOR_YELLOW, "ความพยายามล้มเหลวเรียบร้อยแล้ว !");
				}
			}
			else {
				return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่มีเชือกที่จะใช้");
			}
		}
		else SendClientMessage(playerid, COLOR_GRAD2, "คุณอยู่ห่างเกินไป");
	}
	return 1;
}

CMD:usedrag(playerid, params[]) {

	new
		targetID,
		string[99];

	foreach (new x : Player) {
		if(playerData[x][pDrag] == playerid) {

			/*GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
			GetPlayerName(x, playerName[1], MAX_PLAYER_NAME);*/

			playerData[x][pDrag] = -1;

			format(string, sizeof(string), "คุณได้หยุดลาก %s", ReturnRealName(targetID));
			SendClientMessage(playerid, COLOR_WHITE, string);

			//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้ปล่อย %s จากการลาก", ReturnRealName(playerid), ReturnRealName(targetID));
			return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้ปล่อย %s จากการลาก", ReturnRealName(playerid), ReturnRealName(targetID));
		}
	}

	if(sscanf(params, "u", targetID))
		return SendClientMessage(playerid, COLOR_GRAD2, "การใช้: /usedrag [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(playerData[targetID][pFreezeType] != 4)
		return SendClientMessage(playerid, COLOR_GRAD2, "ผู้เล่นนั้นต้องถูกเชือกมัดจึงจะสามารถลากได้");

	else if(playerData[targetID][pFreezeType] == 2 || playerData[targetID][pFreezeType] == 4) {
		if(IsPlayerNearPlayer(playerid, targetID, 2.0)) {
			if(!IsPlayerInAnyVehicle(targetID) && !IsPlayerInAnyVehicle(playerid)) {

				/*GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
				GetPlayerName(targetID, playerName[1], MAX_PLAYER_NAME);*/

				playerData[targetID][pDrag] = playerid;
				format(string, sizeof(string), "คุณได้ลาก %s", ReturnRealName(targetID));
				SendClientMessage(playerid, COLOR_YELLOW, string);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้ลากตัว %s", ReturnRealName(playerid), ReturnRealName(targetID));
			}
			else SendClientMessage(playerid, COLOR_GRAD2, "คุณและคนที่คุณลากอยู่ในรถแล้ว");
		}
		else SendClientMessage(playerid, COLOR_GRAD2, "คุณอยู่ไกลเกินไป");
	}
	else SendClientMessage(playerid, COLOR_GRAD2, "คนที่คุณต้องการที่จะลากจะต้องไม่หลบหนี (หรือต้องถูกใส่กุญแจมือหรือมัดไว้แล้ว)");
	return 1;
}

CMD:untie(playerid, params[]) {
	
	new iTarget;
	
	if(sscanf(params, "u", iTarget)) {
    	return SendClientMessage(playerid, COLOR_GRAD2, "การใช้: /untie [ไอดีผู้เล่น/ชื่อบางส่วน]");
    }
    else {
		if(iTarget == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GREY, "ID ผู้เล่นที่ระบุไม่ได้เชื่อมต่อหรือไม่ได้รับการรับรองความถูกต้อง");

		if(iTarget == playerid)
			return SendClientMessage(playerid, COLOR_GREY, "คุณไม่สามารถแก้มัดตัวเองได้");

		if(IsPlayerNearPlayer(playerid, iTarget, 2.0)) {
			
			/*new
				playerName[2][MAX_PLAYER_NAME];

			GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
			GetPlayerName(iTarget, playerName[1], MAX_PLAYER_NAME);*/

			if(random(6) < 3) {
				if(playerData[iTarget][pFreezeType] != 4) {
					return SendClientMessage(playerid, COLOR_GREY, "ผู้เล่นนี้ไม่ได้ถูกมัดอยู่");
				}
				else {

					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้แก้มัดให้ %s เสร็จสิ้น", ReturnRealName(playerid), ReturnRealName(iTarget));

					playerData[iTarget][pFreezeType] = 0;
					playerData[iTarget][pFreezeTime] = 0;

					TogglePlayerControllable(iTarget, true);

					return SendClientMessage(playerid, COLOR_YELLOW, "ความพยายามประสบความสำเร็จ!");
				}
			}
			else {

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้แก้มัดให้ %s และมันล้มเหลว", ReturnRealName(playerid), ReturnRealName(iTarget));
				return SendClientMessage(playerid, COLOR_YELLOW, "ความพยายามล้มเหลว!");
			}
		}
		else SendClientMessage(playerid, COLOR_GREY, "คุณอยู่ห่างเกินไป");
	}
	return 1;
}

forward playerLoopTie();
public playerLoopTie() 
{
	foreach (new x : Player)
	{
		if(playerData[x][pFreezeTime] != 0) {
			if(playerData[x][pFreezeType] != 2) {
				TogglePlayerControllable(x, 0);
			}

			if(playerData[x][pFreezeTime] > 0) {
				playerData[x][pFreezeTime]--;

				if(playerData[x][pFreezeTime] == 0) {

					playerData[x][pFreezeType] = 0;
					TogglePlayerControllable(x, true);
				}
			}
		}

		if(playerData[x][pDrag] != -1) {
			if(IsPlayerConnected(playerData[x][pDrag])) {
				switch(GetPlayerState(playerData[x][pDrag])) { 
					case 1: { // on foot
						GetPlayerPos(playerData[x][pDrag], playerData[x][pPosX], playerData[x][pPosY], playerData[x][pPosZ]);
						SetPlayerPos(x, playerData[x][pPosX], playerData[x][pPosY], playerData[x][pPosZ]);

						SetPlayerVirtualWorld(x, GetPlayerVirtualWorld(playerData[x][pDrag]));
						SetPlayerInterior(x, GetPlayerInterior(playerData[x][pDrag]));
					}
					case 2, 3: {
						SendClientMessage(playerData[x][pDrag], COLOR_GRAD2, "คุณไม่สามารถเข้าไปในรถในขณะที่ลากใครบางคน (ใช้ /detain)");
						RemovePlayerFromVehicle(playerData[x][pDrag]);
					}
					case 7: { // Death
						SendClientMessage(x, COLOR_WHITE, "คนที่กำลังลากคุณหายไป");
						playerData[x][pDrag] = -1;
					}
				}
			}
			else {

				SendClientMessage(x, COLOR_WHITE, "คนที่กำลังลากคุณได้ตัดการเชื่อมต่อ");
				playerData[x][pDrag] = -1; // Kills off any disconnections.
			}
		}
	}
}