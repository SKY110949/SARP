#include <YSI\y_hooks>

#define TREASURE_POS_X   -811.3617
#define TREASURE_POS_Y    1823.8716
#define TREASURE_POS_Z    7.0000

new const Float:huntpoint[11][3] = {
	{-516.6533,1606.9426,9.9813},
	{-655.3689,1447.3785,13.6172},
	{-438.6311,1439.0095,21.1749},
	{-395.1041,1245.0658,6.6465},
	{-454.8536,614.3163,16.7466},
	{-1346.0809,354.0954,-0.5024},
	{-1393.9648,492.0572,3.0391},
	{-1478.4500,1489.7678,8.2578},
	{-2706.8289,2150.9138,-0.6422},
	{-1505.2070,1371.0403,3.3211},
	{-2078.5601,1437.5604,-0.4361}
};

new treasure_start[MAX_PLAYERS char], treasure_step[MAX_PLAYERS], treasure_cp[MAX_PLAYERS], treasure_collect[MAX_PLAYERS];
new huntPickup;

hook OnGameModeInit() {
    huntPickup = CreateDynamicPickup(1239, 2, TREASURE_POS_X,TREASURE_POS_Y,TREASURE_POS_Z);
	CreateDynamic3DTextLabel("ล่าสมบัติ\nพิมพ์ /hunt", -1, TREASURE_POS_X,TREASURE_POS_Y,TREASURE_POS_Z, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
}

hook OnPlayerConnect(playerid) {
    treasure_start{playerid}=false; treasure_collect[playerid]=0; 
	treasure_step[playerid]=0;
    return 1;
}

hook OP_PickUpDynamicPickup(playerid, pickupid)
{
	if(pickupid == huntPickup) {
		Mobile_GameTextForPlayer(playerid, "~w~Type /Treasurehunt to start hunt", 5000, 3);

		return 1;
	}
    return 1;
}
CMD:hunt(playerid)
{
	if(treasure_start{playerid}) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณได้เริ่มล่าสมบัติไปแล้ว");

	treasure_collect[playerid]=0;
	treasure_start{playerid}=true;
	treasure_step[playerid]=0;

	SendClientMessage(playerid, COLOR_WHITE, "คุณได้เริ่มล่าสมบัติในโลกแล้ว");

	Starthunt(playerid);
	return 1;
}
CMD:stophunt(playerid)
{
	if(treasure_start{playerid})
	{
		DisablePlayerCheckpoint(playerid);
		treasure_cp[playerid]=0;
		treasure_start{playerid}=false;
        treasure_collect[playerid]=0; treasure_step[playerid]=0;
		gLastCheckpointTime[playerid]=0;
        
		return SendClientMessage(playerid, COLOR_WHITE, "คุณได้หยุดการล่าสมบัติ");
	}
	else return SendClientMessage(playerid, COLOR_GRAD1, "   คุณยังไม่ได้เริ่มล่าสมบัติ");
}

Starthunt(playerid)
{
	new rand = random(sizeof(huntpoint));
	treasure_step[playerid]=0;
	DisablePlayerCheckpoint(playerid);
	SetPlayerCheckpoint(playerid, huntpoint[rand][0],huntpoint[rand][1],huntpoint[rand][2], 10.0);
 	treasure_cp[playerid]= rand + 1;
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid) {
	#if defined SV_DEBUG
		printf("Treasurehunt.pwn: OnPlayerEnterCheckpoint(playerid %d)", playerid);
	#endif
    if (treasure_start{playerid}) {
		new rand = treasure_cp[playerid] - 1;
		if (rand >= 0) {
			if(IsPlayerInRangeOfPoint(playerid, 10.0, huntpoint[rand][0],huntpoint[rand][1],huntpoint[rand][2])) {
				PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);

				treasure_collect[playerid]++;
				GameTextForPlayer(playerid, sprintf("~y~Treasure hunt collect~n~~g~%d/10", treasure_collect[playerid]), 5000, 1);

				if (treasure_collect[playerid] >= 10) {
					
					treasure_start{playerid}=false; 
					treasure_collect[playerid]=0; 

					new randmoney = 100 + random(4000);
					treasure_collect[playerid] = 0;

					if (gettime() - gLastCheckpointTime[playerid] <= 60) {

						Log(anticheatlog, INFO, "%s ส่ง Treasure ในเวลา %d", ReturnPlayerName(playerid), gettime() - gLastCheckpointTime[playerid]);

						new IP[60];
						GetPlayerIp(playerid, IP, sizeof(IP));
						SendRconCommand(sprintf("banip %s",IP));
						Kick(playerid);
						return 1;
					}
					gLastCheckpointTime[playerid] = gettime();

					Mobile_GameTextForPlayer(playerid, sprintf("~w~Mission ~g~Passed ~n~~y~+%d$", randmoney) ,4000, 4);

					GivePlayerMoneyEx(playerid, randmoney);

					Log(paychecklog, INFO, "%s ได้รับเงินสด %d จาก Treasure", ReturnPlayerName(playerid), randmoney);

					PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
				}
				else {
					Starthunt(playerid);
				}
			}           
     	}
		return -2;
    }
	return 1;
}