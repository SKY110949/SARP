#include <YSI\y_hooks>

#define GARBAGE_POS_X    2173.5701
#define GARBAGE_POS_Y    -1982.8094
#define GARBAGE_POS_Z    13.5513
#define	GARBAGE_POINT	25

new const Float:GarbagePoint[GARBAGE_POINT][3] = {
{2760.1665,-2021.9512,14.0909},
{2809.9192,-1400.0964,21.1130},
{2581.0342,-1121.5947,66.5081},
{2546.6274,-1037.3792,70.1306},
{2458.8818,-1025.6437,60.5647},
{2375.4229,-1475.1908,24.3951},
{2172.4016,-1500.3853,24.5125},
{1782.3671,-1146.7101,24.4606},
{1826.4471,-1096.7596,24.5268},
{1668.9601, -999.4952,24.6067},
{1656.6670,-1063.5583,24.4464},
{1524.0806,-1018.5102,24.4797},
{1593.5724,-1204.7850,20.4357},
{1659.9188,-1203.7831,20.3449},
{1611.2029,-1511.3585,14.1155},
{1339.3513,-1841.2356,14.0996},
{1340.6304,-1772.5665,14.0631},
{1343.0662,-1647.2557,14.1295},
{1326.3815,-1237.8480,14.0949},
{1086.6097,-1210.3739,18.3506},
{436.7822, -1751.4803,9.3643},
{569.9404,-1767.0322,14.9355},
{1115.5330,-1878.9436,14.1012},
{1460.4562,-2249.2422,14.0950},
{2010.4264,-2053.2222,14.0931}
};

new 
    bool:garbage_start[MAX_PLAYERS char], 
    garbage_veh[MAX_PLAYERS], 
    garbage_step[MAX_PLAYERS],
	bool:garbage_hold[MAX_PLAYERS char],
	garbage_object[MAX_PLAYERS];

new GarbagePickup;

hook OnGameModeInit() {
    GarbagePickup = CreateDynamicPickup(1239, 2, GARBAGE_POS_X,GARBAGE_POS_Y,GARBAGE_POS_Z);
	CreateDynamic3DTextLabel("พนักงานเก็บขยะ\nพิมพ์ /garbagejob เพื่อรับงานนี้", -1, GARBAGE_POS_X,GARBAGE_POS_Y,GARBAGE_POS_Z, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
}

hook OnPlayerConnect(playerid) {
    garbage_start{playerid}=false;
	garbage_hold{playerid}=false;
    garbage_veh[playerid]=INVALID_VEHICLE_ID; 
	garbage_step[playerid]=0;
    return 1;
}

hook OP_PickUpDynamicPickup(playerid, pickupid)
{
	if(pickupid == GarbagePickup) {
		Mobile_GameTextForPlayer(playerid, "~w~Type /garbagejob to be ~n~a Garbage Man", 5000, 3);
		return 1;
	}
    return 1;
}

CMD:garbagejob(playerid)
{
    new faction = playerData[playerid][pFaction];

	if (faction != 0 && Faction_GetTypeID(playerData[playerid][pFaction]) != FACTION_TYPE_GANG)
	    return SendClientMessage(playerid, COLOR_WHITE, "ขออภัย อาชีพนี้สำหรับประชาชนเท่านั้น (ใครก็ตามที่ไม่ได้อยู่ในกลุ่มของทางการ)");

	if (IsPlayerInRangeOfPoint(playerid, 2.5, GARBAGE_POS_X,GARBAGE_POS_Y,GARBAGE_POS_Z)) {

	    if(playerData[playerid][pJob] != 0) 
            return SendClientMessage(playerid, COLOR_LIGHTRED, "   คุณมีอาชีพอยู่แล้ว พิมพ์ /leavejob เพื่อออกจากอาชีพ");

        playerData[playerid][pJob] = JOB_GARBAGE;
        GameTextForPlayer(playerid, "~r~Congratulations,~n~~w~You are now a ~y~Garbage Man.~n~~w~/jobhelp.", 8000, 1);
        SendClientMessage(playerid, COLOR_GRAD1, "ตอนนี้คุณเป็นพนักงานเก็บขยะแล้ว");
		return 1;
	}
	else return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่จุดสมัครงาน");
}

CMD:collect(playerid)
{
	if(playerData[playerid][pJob] != JOB_GARBAGE)
	    return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่ใช่พนักงานเก็บขยะ!");

	new vehicleid = GetPlayerVehicleID(playerid);

	if (GetVehicleModel(vehicleid) != 408)
		return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้นั่งอยู่บน Trashmaster");

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	 	return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้นั่งอยู่ที่นั่งคนขับของยานพาหนะ");

	if (IsPlayerInRangeOfPoint(playerid, 50.0, GARBAGE_POS_X,GARBAGE_POS_Y,GARBAGE_POS_Z)) {

		if(garbage_start{playerid}) 
            return SendClientMessage(playerid, COLOR_GRAD1, "   คุณได้เริ่มเก็บขยะไปแล้ว");

		garbage_start{playerid}=true;
		garbage_hold{playerid}=false;
		garbage_veh[playerid]=vehicleid;
        garbage_step[playerid]=0;

		SendClientMessage(playerid, COLOR_WHITE, "คุณได้เริ่มเก็บขยะในท้องถิ่นนี้แล้ว");

		// SetPVarInt(playerid, "DoJob", gettime());

		StartGarbageMan(playerid);
        return 1;
	}
	else return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่จุดสมัครงานเก็บขยะ");
}

CMD:stopgarbage(playerid)
{
	if(garbage_start{playerid})
	{
		DisablePlayerCheckpoint(playerid);
		garbage_start{playerid}=false;
		garbage_hold{playerid}=false; 
		garbage_veh[playerid]=INVALID_VEHICLE_ID;
        garbage_step[playerid]=0;
        
		return SendClientMessage(playerid, COLOR_WHITE, "คุณได้หยุดเก็บเก็บขยะ");
	}
	else return SendClientMessage(playerid, COLOR_GRAD1, "   คุณยังไม่ได้เริ่มทำการเก็บเก็บขยะ");
}

StartGarbageMan(playerid)
{
	DisablePlayerCheckpoint(playerid);
	new Float:findZ;
	MapAndreas_FindZ_For2DCoord(GarbagePoint[garbage_step[playerid]][0],GarbagePoint[garbage_step[playerid]][1], findZ);
	if (findZ - GarbagePoint[garbage_step[playerid]][2] > 10.0) {
		findZ = GarbagePoint[garbage_step[playerid]][2] - 1.2;
	}
	SetPlayerGarbage(playerid,GarbagePoint[garbage_step[playerid]][0],GarbagePoint[garbage_step[playerid]][1],findZ, 3.0);
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid) {
	#if defined SV_DEBUG
		printf("garbage.pwn: OnPlayerEnterCheckpoint(playerid %d)", playerid);
	#endif
    if (garbage_start{playerid}) {


		new Float:findZ;
		if (garbage_step[playerid] < GARBAGE_POINT) {
			MapAndreas_FindZ_For2DCoord(GarbagePoint[garbage_step[playerid]][0],GarbagePoint[garbage_step[playerid]][1], findZ);
			if (findZ - GarbagePoint[garbage_step[playerid]][2] > 10.0) {
				findZ = GarbagePoint[garbage_step[playerid]][2] - 1.2;
			}
		}
		
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !garbage_hold{playerid} && garbage_step[playerid] < GARBAGE_POINT && IsPlayerInRangeOfPoint(playerid, 5.0, GarbagePoint[garbage_step[playerid]][0],GarbagePoint[garbage_step[playerid]][1],findZ)) {
			new Float:vX, Float:vY, Float:vZ;
			GetVehicleBoot(garbage_veh[playerid], vX, vY, vZ);

			MapAndreas_FindZ_For2DCoord(vX, vY, findZ);
			findZ += 1.0;
			if (findZ - vZ > 10.0) {
				findZ = vZ;
			}

			SetPlayerCheckpoint(playerid,vX,vY,findZ,1.0);
			garbage_hold{playerid}=true;

			if(IsValidPlayerObject(playerid, garbage_object[playerid])) 
				DestroyPlayerObject(playerid, garbage_object[playerid]);

			SetPlayerLookAt(playerid, GarbagePoint[garbage_step[playerid]][0],GarbagePoint[garbage_step[playerid]][1]);
			ApplyAnimation(playerid, "CARRY","liftup", 4.1, 0, 0, 0, 0, 0, 1);	
		}
		else if (garbage_step[playerid] >= GARBAGE_POINT && IsPlayerInRangeOfPoint(playerid, 5.0, GARBAGE_POS_X,GARBAGE_POS_Y,GARBAGE_POS_Z)) {

			new randmoney = 4000 + random(500 + (playerData[playerid][pContractTime] * 20));
			Mobile_GameTextForPlayer(playerid, sprintf("~w~Mission ~g~Passed ~n~~y~+%d$", randmoney) ,4000, 4);
			playerData[playerid][pPayCheck] += randmoney;
			Log(paychecklog, INFO, "%s ได้รับ Paycheck %d จาก Garbage", ReturnPlayerName(playerid), randmoney);

			DisablePlayerCheckpoint(playerid);
			garbage_start{playerid}=false; 
			garbage_veh[playerid]=INVALID_VEHICLE_ID;
			garbage_step[playerid]=0;
		}
		else if(garbage_hold{playerid} && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
			garbage_step[playerid]++;
			garbage_hold{playerid} = false;

			//Mobile_GameTextForPlayer(playerid, "Garbage loading...",4000, 4);

			new Float:vX, Float:vY, Float:vZ;
			GetVehiclePos(garbage_veh[playerid], vX, vY, vZ);
			SetPlayerLookAt(playerid, vX, vY);
			ApplyAnimation(playerid, "CARRY","putdwn", 4.1, 0, 0, 0, 0, 0, 1);

			GameTextForPlayer(playerid, sprintf("~w~Trash Collect~n~~g~%d/25", garbage_step[playerid]), 5000, 1);

			if (garbage_step[playerid] < GARBAGE_POINT) {
				PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
				StartGarbageMan(playerid);
			}
			else {
				SetPlayerCheckpoint(playerid,GARBAGE_POS_X,GARBAGE_POS_Y,GARBAGE_POS_Z,3.0);
			}
		}
        /*switch(garbage_step[playerid]) {
            case 0: {
                new vehicleid = GetPlayerVehicleID(playerid);
                if(garbage_veh[playerid] == vehicleid)
                {
                    new rand = garbage_cp[playerid] - 1;
                    if (rand >= 0) {
						if(IsPlayerInRangeOfPoint(playerid, 10.0, SweeperPoint[rand][0],SweeperPoint[rand][1],SweeperPoint[rand][2])) {
							PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);

							garbage_collect[playerid]++;
							GameTextForPlayer(playerid, sprintf("~w~Sweeper Collect~n~~g~%d/10", garbage_collect[playerid]), 5000, 1);

							if (garbage_collect[playerid] >= 10) {
								garbage_step[playerid]=1;

								SetPlayerCheckpoint(playerid,GARBAGE_POS_X,GARBAGE_POS_Y,GARBAGE_POS_Z, 5.0);
								garbage_cp[playerid]= 0;
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
                if(garbage_veh[playerid] == vehicleid && IsPlayerInRangeOfPoint(playerid, 5.0, GARBAGE_POS_X,GARBAGE_POS_Y,GARBAGE_POS_Z)) {
                    new randmoney = (100 * garbage_collect[playerid]) + random(110 + (playerData[playerid][pContractTime] * 5));
					garbage_collect[playerid] = 0;

                    GameTextForPlayer(playerid, sprintf("~w~You have swept the road and sold collect~n~~y~for %d$", randmoney), 5000, 1);

                    playerData[playerid][pPayCheck] += randmoney;

					Log(paychecklog, INFO, "%s ได้รับ Paycheck %d จาก Sweeper", ReturnPlayerName(playerid), randmoney);

					PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);

                    //Next Harvesting
                    StartSweeping(playerid);
                }
            }
        }*/
        return -2;
    }
    return 1;
}

SetPlayerGarbage(playerid,Float:x,Float:y,Float:z,Float:radi)
{
    SetPlayerCheckpoint(playerid,x,y,z,radi);
    garbage_object[playerid] = CreatePlayerObject(playerid,1264,x,y,z,0.0,0.0,0.0);
    return 1;
}
