
#include <YSI\y_hooks>

new bool:TaxiDuty[MAX_PLAYERS char],
	TaxiFare[MAX_PLAYERS char],
	bool:TaxiStart[MAX_PLAYERS char],
	TaxiMoney[MAX_PLAYERS],
	TaxiMade[MAX_PLAYERS];


hook OnPlayerConnect(playerid) {
	TaxiDuty{playerid} = false; TaxiFare{playerid} = 0; TaxiStart{playerid} = false; TaxiMoney[playerid] = 0; TaxiMade[playerid] = 0;
	return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
	if(TaxiMoney[playerid] > 0 && IsPlayerInAnyVehicle(playerid))
	{
		ChargePerson(playerid);
	}
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
	#if defined SV_DEBUG
		printf("taxi.pwn: OnPlayerStateChange(playerid %d, newstate %d, oldstate %d)", playerid, newstate, oldstate);
	#endif
	if (newstate == PLAYER_STATE_ONFOOT)
	{
		if(TaxiMoney[playerid] > 0)
		{
			ChargePerson(playerid);
		}
	}
	return 1;
}

IsATaxi(vehicleid)
{
	new model = GetVehicleModel(vehicleid);
	return (model == 420 || model == 438);
}

CMD:taxi(playerid, params[])
{
	new option[11], secoption, vehicle = GetPlayerVehicleID(playerid), msg[128];
	if(sscanf(params,"s[11]D(-1)", option, secoption))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /taxi [������͡]");
		SendClientMessage(playerid, COLOR_GREY, "������͡: | duty (������ҹ) | fare (��駤�Һ�ԡ��) | check (�٤�Һ�ԡ��) | accept (�Ѻ) | start (�Դ������) | stop (�Դ������)");
		return 1;
	}
	if(!strcmp(option, "duty", true))
	{
	    if(playerData[playerid][pSideJob] != JOB_TAXI && playerData[playerid][pJob] != JOB_TAXI) return SendClientMessage(playerid, COLOR_WHITE, "�س����� Taxi Driver");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, "�س��ͧ�繤��Ѻö");
		if(!IsATaxi(vehicle)) return SendClientMessage(playerid, COLOR_LIGHTRED, "�س��������躹 Taxi");

		if(TaxiDuty{playerid})
		{
			SendClientMessage(playerid, COLOR_YELLOW, "[TAXI]: �͹���س Off-duty");
			TaxiDuty{playerid} = false;
			TaxiMade[playerid] = 0;
		}
		else
		{
			SendClientMessage(playerid, COLOR_YELLOW, "[TAXI]: �͹���س On duty");
			TaxiDuty{playerid} = true;
			TaxiMade[playerid] = 0;
		}
		// SetPlayerToTeamColor(playerid);
	}
	else if(!strcmp(option, "start", true))
	{
	    if(playerData[playerid][pSideJob] != JOB_TAXI && playerData[playerid][pJob] != JOB_TAXI) return SendClientMessage(playerid, COLOR_WHITE, "�س����� Taxi Driver");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, "�س��ͧ�繤��Ѻö");
		if(!IsATaxi(vehicle)) return SendClientMessage(playerid, COLOR_LIGHTRED, "�س��ͧ����� Taxi/Cabbie");
		if(!TaxiDuty{playerid}) return SendClientMessage(playerid, COLOR_GREY, "�س���繵�ͧ On-Duty ��͹");
		if(TaxiFare{playerid} == 0) return SendClientMessage(playerid, COLOR_GREY, "�س�ѧ������駤�������");
		if(TaxiStart{playerid}) return SendClientMessage(playerid, COLOR_GREY, "�س��������ҹ Taxi �����");
		SendClientMessage(playerid, COLOR_YELLOW, "[TAXI]: �硫��ͧ�س�����������ԡ������ռšѺ�����蹷ء���ö�ͧ�س");
		TaxiStart{playerid} = true;
	}
	else if(!strcmp(option, "fare", true))
	{
	    if(playerData[playerid][pSideJob] != JOB_TAXI && playerData[playerid][pJob] != JOB_TAXI) return SendClientMessage(playerid, COLOR_WHITE, "�س����� Taxi Driver");

		new fare;
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, "�س��ͧ�繤��Ѻö");
		if(!IsATaxi(vehicle)) return SendClientMessage(playerid, COLOR_LIGHTRED, "�س��ͧ����� Taxi/Cabbie");
		if(sscanf(params,"{s[11]}d",fare)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /taxi fare [�ӹǹ]");
		if(!TaxiDuty{playerid}) return SendClientMessage(playerid, COLOR_GREY, "�س���繵�ͧ On-Duty ��͹");
		if(fare < 0 || fare > 25) return SendClientMessage(playerid, COLOR_YELLOW, "�բմ�ӡѴ�������� ($0-$25)");
		if(TaxiStart{playerid}) return SendClientMessage(playerid, COLOR_GREY, "Taxi �ͧ�س��ͧ��ش����ԡ�á�͹��駤�������");
		format(msg, sizeof(msg), "[TAXI]: �س������¹��������ö�硫��ͧ�س�� $%d", fare);
		SendClientMessage(playerid, COLOR_YELLOW, msg);
		TaxiFare{playerid} = fare;
	}
	else if(!strcmp(option, "accept", true))
	{
	    if(playerData[playerid][pSideJob] != JOB_TAXI && playerData[playerid][pJob] != JOB_TAXI) return SendClientMessage(playerid, COLOR_WHITE, "�س����� Taxi Driver");

		new targetid = INVALID_PLAYER_ID;
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, "�س��ͧ�繤��Ѻö");
		if(!IsATaxi(vehicle)) return SendClientMessage(playerid, COLOR_LIGHTRED, "�س��ͧ����� Taxi/Cabbie");
		if(sscanf(params,"{s[11]}u",targetid)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /taxi accept [�ʹ�/���ͺҧ��ǹ]");

		if(!TaxiDuty{playerid}) return SendClientMessage(playerid, COLOR_GREY, "�س���繵�ͧ On-Duty ��͹");
		if(GetPVarInt(targetid, "NeedTaxi") == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "�����蹹������ͧ����硫��㹢�й��");

		SetPVarInt(targetid, "ResponseTaxi", GetPVarInt(targetid, "ResponseTaxi") + 1);

		switch(GetPVarInt(targetid, "ResponseTaxi")) {
			case 1: SendClientMessage(playerid, COLOR_WHITE, "�س��ͺ�Ѻ�繤��á!");
			case 2: SendClientMessage(playerid, COLOR_WHITE, "�س��ͺ�Ѻ�繤�����ͧ!");
			default: SendClientMessage(playerid, COLOR_WHITE, "�س��ͺ�Ѻ�繤������ش");
		}

		GetPVarString(targetid, "CallTaxiLoc", msg, sizeof(msg));

		SendClientMessage(playerid, COLOR_GREEN, "|_________���¡�硫��_________|");
	
		SendClientMessageEx(playerid, COLOR_WHITE, "�����:(ID:%d) %s ����: %d", targetid, ReturnPlayerName(targetid), playerData[targetid][pPnumber]);

		SendClientMessageEx(playerid, COLOR_WHITE, "�ش���»��·ҧ: %s", msg);
	}
	else if(!strcmp(option, "stop", true))
	{
	    if(playerData[playerid][pSideJob] != JOB_TAXI && playerData[playerid][pJob] != JOB_TAXI) return SendClientMessage(playerid, COLOR_WHITE, "�س����� Taxi Driver");

		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, "�س��ͧ�繤��Ѻö");
		if(!IsATaxi(vehicle)) return SendClientMessage(playerid, COLOR_LIGHTRED, "�س��ͧ����� Taxi/Cabbie");
		if(!TaxiDuty{playerid}) return SendClientMessage(playerid, COLOR_GREY, "�س���繵�ͧ On-Duty ��͹");
		if(!TaxiStart{playerid}) return SendClientMessage(playerid, COLOR_GREY, "Taxi �ͧ�س�ѧ��������������ԡ��");
		SendClientMessage(playerid, COLOR_YELLOW, "[TAXI]: Taxi �ͧ�س����ش����ԡ����Ф������ö١¡��ԡ");

		TaxiStart{playerid} = false;
		TaxiMade[playerid] = 0;
		TaxiMoney[playerid] = 0;
	}
	else if(!strcmp(option, "check", true))
	{
		new targetid = INVALID_PLAYER_ID;
		if(sscanf(params,"{s[11]}u",targetid)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /taxi check [�ʹռ�����/���ͺҧ��ǹ]");
		if(playerData[targetid][pSideJob] != JOB_TAXI && playerData[targetid][pJob] != JOB_TAXI) return SendClientMessage(playerid, COLOR_WHITE, "�����蹹������� Taxi Driver");
        if(!TaxiDuty{targetid} || TaxiFare{targetid} == 0) return SendClientMessage(playerid, COLOR_WHITE, "�����蹹���ѧ�����������ҹ");
        SendClientMessageEx(playerid, COLOR_WHITE, "** �������âͧ�硫�� %s ��� $%d ����Թҷ� **", ReturnPlayerName(targetid), TaxiFare{targetid});

	}
	return 1;
}

ptask TaxiTimer[1000](playerid) 
{
	if(TaxiStart{playerid} && TaxiDuty{playerid})
	{
		new vehicleid=GetPlayerVehicleID(playerid);
		
		Mobile_GameTextForPlayer(playerid, sprintf("~y~TAXIMETER: $%d", TaxiMade[playerid]), 1000, 6);
		
		foreach(new p : Player)
		{
			if(IsPlayerInAnyVehicle(p) && GetPlayerState(p) != PLAYER_STATE_DRIVER && GetPlayerVehicleID(p) == vehicleid)
			{
				GameTextForPlayer(p, sprintf("~y~TAXIMETER: $%d", TaxiMoney[p]), 1000, 6);

				if(GetPlayerMoney(p) - (TaxiMoney[p] + TaxiFare{playerid}) > 0) {
					TaxiMoney[p] += TaxiFare{playerid};
					TaxiMade[playerid] += TaxiFare{playerid};
				}
				else {
					SendClientMessageEx(playerid, COLOR_YELLOW, "%s ���Թ���ͷ��Ш��¤�������", ReturnRealName(p));
					SendClientMessage(p, COLOR_YELLOW, "�س���Թ���ͷ��Ш��¤���硫��");
					RemovePlayerFromVehicle(p);
				}
			}
		}
	}
}
/*
IsTaxiStart(playerid) {
	return (TaxiStart{playerid} && TaxiDuty{playerid});
}
*/
ChargePerson(playerid)
{
	new driver = GetVehicleDriver(gPassengerCar[playerid]);
	if(GetPlayerMoney(playerid) < TaxiMoney[playerid])
	{
		if(driver != INVALID_PLAYER_ID) {
			SendClientMessageEx(driver, COLOR_WHITE, "%s ���Թ���ͨ��¤�������", ReturnRealName(playerid));
			TaxiMade[driver] -= TaxiMoney[playerid];
		}
		TaxiMoney[playerid] = 0;
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "[TAXI]: �س���¤������÷�����: $%d", TaxiMoney[playerid]);
		GivePlayerMoneyEx(playerid, -TaxiMoney[playerid]);

		if(driver != INVALID_PLAYER_ID) {
			GivePlayerMoneyEx(driver, TaxiMoney[playerid]);
			playerData[driver][pCash]+=TaxiMoney[playerid];
			TaxiMade[driver] -= TaxiMoney[playerid];
		}

		TaxiMoney[playerid] = 0;
	}
}