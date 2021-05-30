#include <YSI\y_hooks>

#define SWEEPER_POS_X    -2211.9644
#define SWEEPER_POS_Y    1056.2740
#define SWEEPER_POS_Z    80.0078

new const Float:SweeperPoint[11][3] = {
	{-2042.8412,-70.3079,34.8731},
	{-2087.2881,-26.3482,34.8979},
	{-2107.1741,56.8546,34.8687},
	{-2031.3828,108.6397,27.8573},
	{-2006.8452,40.1451,32.2747},
	{-2256.1877,-41.2845,34.8774},
	{-2146.7112,183.4208,34.8818},
	{-2107.2769,320.4599,34.7203},
	{-2006.0164,247.8904,29.4794},
	{-2167.2407,-125.9886,34.8774},
	{-2255.9507,-140.9203,34.8765}
};

new sweep_start[MAX_PLAYERS char], sweep_veh[MAX_PLAYERS], sweep_step[MAX_PLAYERS], sweep_cp[MAX_PLAYERS], sweep_collect[MAX_PLAYERS];
new SweeperPickup;

hook OnGameModeInit() {
    SweeperPickup = CreateDynamicPickup(1239, 2, SWEEPER_POS_X,SWEEPER_POS_Y,SWEEPER_POS_Z);
	CreateDynamic3DTextLabel("พนักงานกวาดถนน\nพิมพ์ /sweeperjob เพื่อรับงานนี้", -1, SWEEPER_POS_X,SWEEPER_POS_Y,SWEEPER_POS_Z, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
}

hook OnPlayerConnect(playerid) {
    sweep_start{playerid}=false; sweep_collect[playerid]=0; 
    sweep_veh[playerid]=INVALID_VEHICLE_ID; sweep_step[playerid]=0;
    return 1;
}
/*
hook OnPlayerDisconnect(playerid, reason) {
    return 1;
}
*/
hook OP_PickUpDynamicPickup(playerid, pickupid)
{
	if(pickupid == SweeperPickup) {
		Mobile_GameTextForPlayer(playerid, "~w~Type /sweeperjob to be ~n~a Street Sweeper", 5000, 3);

		return 1;
	}
    return 1;
}

CMD:sweeperjob(playerid)
{
    new faction = playerData[playerid][pFaction];

	if (faction != 0 && Faction_GetTypeID(playerData[playerid][pFaction]) != FACTION_TYPE_GANG)
	    return SendClientMessage(playerid, COLOR_WHITE, "ขออภัย อาชีพนี้สำหรับประชาชนเท่านั้น (ใครก็ตามที่ไม่ได้อยู่ในกลุ่มของทางการ)");

	if (IsPlayerInRangeOfPoint(playerid, 2.5, SWEEPER_POS_X,SWEEPER_POS_Y,SWEEPER_POS_Z)) {

	    if(playerData[playerid][pJob] != 0) 
            return SendClientMessage(playerid, COLOR_LIGHTRED, "   คุณมีอาชีพอยู่แล้ว พิมพ์ /leavejob เพื่อออกจากอาชีพ");

        playerData[playerid][pJob] = JOB_SWEEPER;
        GameTextForPlayer(playerid, "~r~Congratulations,~n~~w~You are now a ~y~Street Sweeper.~n~~w~/jobhelp.", 8000, 1);
        SendClientMessage(playerid, COLOR_GRAD1, "ตอนนี้คุณเป็นพนักงานกวาดถนนแล้ว");
		return 1;
	}
	else return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่จุดสมัครงาน");
}

CMD:sweeper(playerid)
{
	if(playerData[playerid][pJob] != JOB_SWEEPER)
	    return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่ใช่พนักงานกวาดถนน!");

	new vehicleid = GetPlayerVehicleID(playerid);

	if (GetVehicleModel(vehicleid) != 574)
		return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้นั่งอยู่บน Sweeper");

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	 	return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้นั่งอยู่ที่นั่งคนขับของยานพาหนะ");

	if (IsPlayerInRangeOfPoint(playerid, 50.0, SWEEPER_POS_X,SWEEPER_POS_Y,SWEEPER_POS_Z)) {

		if(sweep_start{playerid}) 
            return SendClientMessage(playerid, COLOR_GRAD1, "   คุณได้เริ่มกวาดถนนไปแล้ว");

		sweep_collect[playerid]=0;
		sweep_start{playerid}=true;
		sweep_veh[playerid]=vehicleid;
        sweep_step[playerid]=0;

		SendClientMessage(playerid, COLOR_WHITE, "คุณได้เริ่มกวาดถนนในท้องถิ่นนี้แล้ว");

		StartSweeping(playerid);
        return 1;
	}
	else return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่จุดสมัครงานกวาดถนน");
}

CMD:stopsweeper(playerid)
{
	if(sweep_start{playerid})
	{
        /*if(IsValidDynamicCP(sweep_cp[playerid])) {
            DestroyDynamicCP(sweep_cp[playerid]);
        }*/
		DisablePlayerCheckpoint(playerid);
		sweep_cp[playerid]=0;
		sweep_start{playerid}=false; sweep_veh[playerid]=INVALID_VEHICLE_ID;
        sweep_collect[playerid]=0; sweep_step[playerid]=0;
        
		return SendClientMessage(playerid, COLOR_WHITE, "คุณได้หยุดเก็บกวาดถนน");
	}
	else return SendClientMessage(playerid, COLOR_GRAD1, "   คุณยังไม่ได้เริ่มทำการเก็บกวาดถนน");
}

StartSweeping(playerid)
{
	new rand = random(sizeof(SweeperPoint));
	sweep_step[playerid]=0;
	DisablePlayerCheckpoint(playerid);
	SetPlayerCheckpoint(playerid, SweeperPoint[rand][0],SweeperPoint[rand][1],SweeperPoint[rand][2], 10.0);
 	sweep_cp[playerid]= rand + 1;
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid) {
	#if defined SV_DEBUG
		printf("sweeper.pwn: OnPlayerEnterCheckpoint(playerid %d)", playerid);
	#endif
    if (sweep_start{playerid}) {
        switch(sweep_step[playerid]) {
            case 0: {
                new vehicleid = GetPlayerVehicleID(playerid);
                if(sweep_veh[playerid] == vehicleid)
                {
                    new rand = sweep_cp[playerid] - 1;
                    if (rand >= 0) {
						if(IsPlayerInRangeOfPoint(playerid, 10.0, SweeperPoint[rand][0],SweeperPoint[rand][1],SweeperPoint[rand][2])) {
							PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
						
							sweep_collect[playerid]++;
							GameTextForPlayer(playerid, sprintf("~w~Sweeper Collect~n~~g~%d/10", sweep_collect[playerid]), 5000, 1);

							if (sweep_collect[playerid] >= 10) {
								sweep_collect[playerid] = 10;
								sweep_step[playerid]=1;

								SetPlayerCheckpoint(playerid,SWEEPER_POS_X,SWEEPER_POS_Y,SWEEPER_POS_Z, 5.0);
								sweep_cp[playerid]= 0;
							}
							else {
								StartSweeping(playerid);
							}
						}
                    }
                }
            }
            case 1: {
                new vehicleid = GetPlayerVehicleID(playerid);
                if(sweep_veh[playerid] == vehicleid && IsPlayerInRangeOfPoint(playerid, 5.0, SWEEPER_POS_X,SWEEPER_POS_Y,SWEEPER_POS_Z) && sweep_collect[playerid] == 10) {
                    new randmoney = (100 * sweep_collect[playerid]) + random(110 + (playerData[playerid][pContractTime] * 5));
					sweep_collect[playerid] = 0;

					if (gettime() - gLastCheckpointTime[playerid] <= 60) {

						Log(anticheatlog, INFO, "%s ส่ง Sweeper ในเวลา %d", ReturnPlayerName(playerid), gettime() - gLastCheckpointTime[playerid]);

						new IP[60];
						GetPlayerIp(playerid, IP, sizeof(IP));
						SendRconCommand(sprintf("banip %s",IP));
						Kick(playerid);
						return 1;
					}
					gLastCheckpointTime[playerid] = gettime();

		          	Mobile_GameTextForPlayer(playerid, sprintf("~w~Mission ~g~Passed ~n~~y~+%d$", randmoney) ,4000, 4);

                    playerData[playerid][pPayCheck] += randmoney;

					Log(paychecklog, INFO, "%s ได้รับ Paycheck %d จาก Sweeper", ReturnPlayerName(playerid), randmoney);

					PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);


                    StartSweeping(playerid);
                }
            }
        }
        return -2;
    }
    return 1;
}