
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
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /taxi [ตัวเลือก]");
		SendClientMessage(playerid, COLOR_GREY, "ตัวเลือก: | duty (เริ่มงาน) | fare (ตั้งค่าบริการ) | check (ดูค่าบริการ) | accept (รับ) | start (เปิดมิเตอร์) | stop (ปิดมิเตอร์)");
		return 1;
	}
	if(!strcmp(option, "duty", true))
	{
	    if(playerData[playerid][pSideJob] != JOB_TAXI && playerData[playerid][pJob] != JOB_TAXI) return SendClientMessage(playerid, COLOR_WHITE, "คุณไม่ใช่ Taxi Driver");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, "คุณต้องเป็นคนขับรถ");
		if(!IsATaxi(vehicle)) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่บน Taxi");

		if(TaxiDuty{playerid})
		{
			SendClientMessage(playerid, COLOR_YELLOW, "[TAXI]: ตอนนี้คุณ Off-duty");
			TaxiDuty{playerid} = false;
			TaxiMade[playerid] = 0;
		}
		else
		{
			SendClientMessage(playerid, COLOR_YELLOW, "[TAXI]: ตอนนี้คุณ On duty");
			TaxiDuty{playerid} = true;
			TaxiMade[playerid] = 0;
		}
		// SetPlayerToTeamColor(playerid);
	}
	else if(!strcmp(option, "start", true))
	{
	    if(playerData[playerid][pSideJob] != JOB_TAXI && playerData[playerid][pJob] != JOB_TAXI) return SendClientMessage(playerid, COLOR_WHITE, "คุณไม่ใช่ Taxi Driver");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, "คุณต้องเป็นคนขับรถ");
		if(!IsATaxi(vehicle)) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่ใน Taxi/Cabbie");
		if(!TaxiDuty{playerid}) return SendClientMessage(playerid, COLOR_GREY, "คุณจำเป็นต้อง On-Duty ก่อน");
		if(TaxiFare{playerid} == 0) return SendClientMessage(playerid, COLOR_GREY, "คุณยังไม่ได้ตั้งค่าโดยสาร");
		if(TaxiStart{playerid}) return SendClientMessage(playerid, COLOR_GREY, "คุณได้เริ่มงาน Taxi ไปแล้ว");
		SendClientMessage(playerid, COLOR_YELLOW, "[TAXI]: แท็กซี่ของคุณได้เริ่มให้บริการและมีผลกับผู้เล่นทุกคนในรถของคุณ");
		TaxiStart{playerid} = true;
	}
	else if(!strcmp(option, "fare", true))
	{
	    if(playerData[playerid][pSideJob] != JOB_TAXI && playerData[playerid][pJob] != JOB_TAXI) return SendClientMessage(playerid, COLOR_WHITE, "คุณไม่ใช่ Taxi Driver");

		new fare;
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, "คุณต้องเป็นคนขับรถ");
		if(!IsATaxi(vehicle)) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่ใน Taxi/Cabbie");
		if(sscanf(params,"{s[11]}d",fare)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /taxi fare [จำนวน]");
		if(!TaxiDuty{playerid}) return SendClientMessage(playerid, COLOR_GREY, "คุณจำเป็นต้อง On-Duty ก่อน");
		if(fare < 0 || fare > 25) return SendClientMessage(playerid, COLOR_YELLOW, "มีขีดจำกัดค่าโดยสาร ($0-$25)");
		if(TaxiStart{playerid}) return SendClientMessage(playerid, COLOR_GREY, "Taxi ของคุณต้องหยุดให้บริการก่อนตั้งค่าโดยสาร");
		format(msg, sizeof(msg), "[TAXI]: คุณได้เปลี่ยนค่าโดยสารรถแท็กซี่ของคุณเป็น $%d", fare);
		SendClientMessage(playerid, COLOR_YELLOW, msg);
		TaxiFare{playerid} = fare;
	}
	else if(!strcmp(option, "accept", true))
	{
	    if(playerData[playerid][pSideJob] != JOB_TAXI && playerData[playerid][pJob] != JOB_TAXI) return SendClientMessage(playerid, COLOR_WHITE, "คุณไม่ใช่ Taxi Driver");

		new targetid = INVALID_PLAYER_ID;
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, "คุณต้องเป็นคนขับรถ");
		if(!IsATaxi(vehicle)) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่ใน Taxi/Cabbie");
		if(sscanf(params,"{s[11]}u",targetid)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /taxi accept [ไอดี/ชื่อบางส่วน]");

		if(!TaxiDuty{playerid}) return SendClientMessage(playerid, COLOR_GREY, "คุณจำเป็นต้อง On-Duty ก่อน");
		if(GetPVarInt(targetid, "NeedTaxi") == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "ผู้เล่นนี้ไม่ต้องการแท็กซี่ในขณะนี้");

		SetPVarInt(targetid, "ResponseTaxi", GetPVarInt(targetid, "ResponseTaxi") + 1);

		switch(GetPVarInt(targetid, "ResponseTaxi")) {
			case 1: SendClientMessage(playerid, COLOR_WHITE, "คุณได้ตอบรับเป็นคนแรก!");
			case 2: SendClientMessage(playerid, COLOR_WHITE, "คุณได้ตอบรับเป็นคนที่สอง!");
			default: SendClientMessage(playerid, COLOR_WHITE, "คุณได้ตอบรับเป็นคนท้ายสุด");
		}

		GetPVarString(targetid, "CallTaxiLoc", msg, sizeof(msg));

		SendClientMessage(playerid, COLOR_GREEN, "|_________เรียกแท็กซี่_________|");
	
		SendClientMessageEx(playerid, COLOR_WHITE, "ผู้โทร:(ID:%d) %s เบอร์: %d", targetid, ReturnPlayerName(targetid), playerData[targetid][pPnumber]);

		SendClientMessageEx(playerid, COLOR_WHITE, "จุดหมายปลายทาง: %s", msg);
	}
	else if(!strcmp(option, "stop", true))
	{
	    if(playerData[playerid][pSideJob] != JOB_TAXI && playerData[playerid][pJob] != JOB_TAXI) return SendClientMessage(playerid, COLOR_WHITE, "คุณไม่ใช่ Taxi Driver");

		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, "คุณต้องเป็นคนขับรถ");
		if(!IsATaxi(vehicle)) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่ใน Taxi/Cabbie");
		if(!TaxiDuty{playerid}) return SendClientMessage(playerid, COLOR_GREY, "คุณจำเป็นต้อง On-Duty ก่อน");
		if(!TaxiStart{playerid}) return SendClientMessage(playerid, COLOR_GREY, "Taxi ของคุณยังไม่ได้เริ่มให้บริการ");
		SendClientMessage(playerid, COLOR_YELLOW, "[TAXI]: Taxi ของคุณได้หยุดให้บริการและค่าโดยสารถูกยกเลิก");

		TaxiStart{playerid} = false;
		TaxiMade[playerid] = 0;
		TaxiMoney[playerid] = 0;
	}
	else if(!strcmp(option, "check", true))
	{
		new targetid = INVALID_PLAYER_ID;
		if(sscanf(params,"{s[11]}u",targetid)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /taxi check [ไอดีผู้เล่น/ชื่อบางส่วน]");
		if(playerData[targetid][pSideJob] != JOB_TAXI && playerData[targetid][pJob] != JOB_TAXI) return SendClientMessage(playerid, COLOR_WHITE, "ผู้เล่นนั้นไม่ใช่ Taxi Driver");
        if(!TaxiDuty{targetid} || TaxiFare{targetid} == 0) return SendClientMessage(playerid, COLOR_WHITE, "ผู้เล่นนั้นยังไม่ได้เริ่มงาน");
        SendClientMessageEx(playerid, COLOR_WHITE, "** ค่าโดยสารของแท็กซี่ %s คือ $%d ต่อวินาที **", ReturnPlayerName(targetid), TaxiFare{targetid});

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
					SendClientMessageEx(playerid, COLOR_YELLOW, "%s มีเงินไม่พอที่จะจ่ายค่าโดยสาร", ReturnRealName(p));
					SendClientMessage(p, COLOR_YELLOW, "คุณมีเงินไม่พอที่จะจ่ายค่าแท็กซี่");
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
			SendClientMessageEx(driver, COLOR_WHITE, "%s มีเงินไม่พอจ่ายค่าโดยสาร", ReturnRealName(playerid));
			TaxiMade[driver] -= TaxiMoney[playerid];
		}
		TaxiMoney[playerid] = 0;
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "[TAXI]: คุณจ่ายค่าโดยสารทั้งหมด: $%d", TaxiMoney[playerid]);
		GivePlayerMoneyEx(playerid, -TaxiMoney[playerid]);

		if(driver != INVALID_PLAYER_ID) {
			GivePlayerMoneyEx(driver, TaxiMoney[playerid]);
			playerData[driver][pCash]+=TaxiMoney[playerid];
			TaxiMade[driver] -= TaxiMoney[playerid];
		}

		TaxiMoney[playerid] = 0;
	}
}