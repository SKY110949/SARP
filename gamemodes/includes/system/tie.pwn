#include <YSI\y_hooks>

hook OnGameModeInit()
{
	SetTimer("playerLoopTie", 1000, true);
}

hook OnPlayerDisconnect(playerid, reason) {

	if(playerData[playerid][pDrag] != -1) {
		SendClientMessage(playerData[playerid][pDrag], COLOR_WHITE, "�����س�١�ҡ��Ѵ�����������");
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
    	return SendClientMessage(playerid, COLOR_GRAD2, "�����: /tie [�ʹռ�����/���ͺҧ��ǹ]");
    }
    else {
		if(targetID == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GRAD2, "ID �����蹷���к������������������������Ѻ����Ѻ�ͧ�����١��ͧ");

		/*if(targetID == playerid)
			return SendClientMessage(playerid, COLOR_GRAD2, "�س�������ö�Ѵ����ͧ��");*/

		/*if(playerVariables[playerid][pPrisonTime] >= 1)
			return SendClientMessage(playerid, COLOR_GRAD2, "�س�������ö���Թ��ù����㹢����������͹��");*/


		if(IsPlayerNearPlayer(playerid, targetID, 2.0)) {

			/*new
				playerName[2][MAX_PLAYER_NAME],
				msgSz[128];

			GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
			GetPlayerName(targetID, playerName[1], MAX_PLAYER_NAME);*/

			if(playerData[playerid][pTie] >= 1) {
				if(random(6) < 3) {
					if(playerData[targetID][pFreezeType] > 0 && playerData[targetID][pFreezeType] < 5) {
						return SendClientMessage(playerid, COLOR_GRAD2, "���������������� �����蹹��١���������������");
					}
					else {
						//GiveItemToPlayer(playerid, "Rope", -1);
                        playerData[playerid][pTie] -= 1;

						/*format(msgSz, sizeof(msgSz), "* %s ���Ѵ %s �������", playerName[0], playerName[1]);
						nearByMessage(playerid, COLOR_PURPLE, msgSz);*/

                        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ����Ժ��͡�͡�������Ѵ %s ����� !!", ReturnRealName(playerid), ReturnRealName(targetID));
						TogglePlayerControllable(targetID, false);

						playerData[targetID][pFreezeType] = 4;
						playerData[targetID][pFreezeTime] = 180;

						return SendClientMessage(playerid, COLOR_YELLOW, "������������������º�������� !");
					}
				}
				else {
                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ����Ժ��͡�͡�������Ѵ %s ���������� !!", ReturnRealName(playerid), ReturnRealName(targetID));
					TogglePlayerControllable(targetID, false);

					return SendClientMessage(playerid, COLOR_YELLOW, "��������������������º�������� !");
				}
			}
			else {
				return SendClientMessage(playerid, COLOR_GRAD2, "�س�������͡������");
			}
		}
		else SendClientMessage(playerid, COLOR_GRAD2, "�س������ҧ�Թ�");
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

			format(string, sizeof(string), "�س����ش�ҡ %s", ReturnRealName(targetID));
			SendClientMessage(playerid, COLOR_WHITE, string);

			//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ������ %s �ҡ����ҡ", ReturnRealName(playerid), ReturnRealName(targetID));
			return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ������ %s �ҡ����ҡ", ReturnRealName(playerid), ReturnRealName(targetID));
		}
	}

	if(sscanf(params, "u", targetID))
		return SendClientMessage(playerid, COLOR_GRAD2, "�����: /usedrag [�ʹռ�����/���ͺҧ��ǹ]");

	if(playerData[targetID][pFreezeType] != 4)
		return SendClientMessage(playerid, COLOR_GRAD2, "�����蹹�鹵�ͧ�١��͡�Ѵ�֧������ö�ҡ��");

	else if(playerData[targetID][pFreezeType] == 2 || playerData[targetID][pFreezeType] == 4) {
		if(IsPlayerNearPlayer(playerid, targetID, 2.0)) {
			if(!IsPlayerInAnyVehicle(targetID) && !IsPlayerInAnyVehicle(playerid)) {

				/*GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
				GetPlayerName(targetID, playerName[1], MAX_PLAYER_NAME);*/

				playerData[targetID][pDrag] = playerid;
				format(string, sizeof(string), "�س���ҡ %s", ReturnRealName(targetID));
				SendClientMessage(playerid, COLOR_YELLOW, string);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ���ҡ��� %s", ReturnRealName(playerid), ReturnRealName(targetID));
			}
			else SendClientMessage(playerid, COLOR_GRAD2, "�س��Ф����س�ҡ�����ö����");
		}
		else SendClientMessage(playerid, COLOR_GRAD2, "�س�������Թ�");
	}
	else SendClientMessage(playerid, COLOR_GRAD2, "�����س��ͧ��÷����ҡ�е�ͧ����ź˹� (���͵�ͧ�١���ح���������Ѵ�������)");
	return 1;
}

CMD:untie(playerid, params[]) {
	
	new iTarget;
	
	if(sscanf(params, "u", iTarget)) {
    	return SendClientMessage(playerid, COLOR_GRAD2, "�����: /untie [�ʹռ�����/���ͺҧ��ǹ]");
    }
    else {
		if(iTarget == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GREY, "ID �����蹷���к������������������������Ѻ����Ѻ�ͧ�����١��ͧ");

		if(iTarget == playerid)
			return SendClientMessage(playerid, COLOR_GREY, "�س�������ö���Ѵ����ͧ��");

		if(IsPlayerNearPlayer(playerid, iTarget, 2.0)) {
			
			/*new
				playerName[2][MAX_PLAYER_NAME];

			GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
			GetPlayerName(iTarget, playerName[1], MAX_PLAYER_NAME);*/

			if(random(6) < 3) {
				if(playerData[iTarget][pFreezeType] != 4) {
					return SendClientMessage(playerid, COLOR_GREY, "�����蹹�������١�Ѵ����");
				}
				else {

					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s �����Ѵ��� %s �������", ReturnRealName(playerid), ReturnRealName(iTarget));

					playerData[iTarget][pFreezeType] = 0;
					playerData[iTarget][pFreezeTime] = 0;

					TogglePlayerControllable(iTarget, true);

					return SendClientMessage(playerid, COLOR_YELLOW, "�������������ʺ���������!");
				}
			}
			else {

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s �����Ѵ��� %s ����ѹ�������", ReturnRealName(playerid), ReturnRealName(iTarget));
				return SendClientMessage(playerid, COLOR_YELLOW, "�����������������!");
			}
		}
		else SendClientMessage(playerid, COLOR_GREY, "�س������ҧ�Թ�");
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
						SendClientMessage(playerData[x][pDrag], COLOR_GRAD2, "�س�������ö�����ö㹢�з���ҡ�úҧ�� (�� /detain)");
						RemovePlayerFromVehicle(playerData[x][pDrag]);
					}
					case 7: { // Death
						SendClientMessage(x, COLOR_WHITE, "�������ѧ�ҡ�س����");
						playerData[x][pDrag] = -1;
					}
				}
			}
			else {

				SendClientMessage(x, COLOR_WHITE, "�������ѧ�ҡ�س��Ѵ�����������");
				playerData[x][pDrag] = -1; // Kills off any disconnections.
			}
		}
	}
}