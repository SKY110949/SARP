#include <YSI\y_hooks>

#define FARMER_POS_X    -382.5893
#define FARMER_POS_Y    -1426.3422
#define FARMER_POS_Z    26.2217

#define BLUEBERRY_FARM  1
#define FLINT_FARM      2

new const Float:FlintFarm[5][3] = {
	{-207.9474,-1327.1185,9.8555},
	{-569.3899,-1302.7570,22.4331},
	{-511.1070,-1376.0288,19.4673},
	{-309.0976,-1539.4039,11.7151},
	{-222.2049,-1520.7129,7.0026}
};

new const Float:BlueFarm[5][3] = {
	{69.6013,-3.1608,1.8764},
	{-25.4396,-56.4816,4.0989},
	{-148.9333,41.2588,4.0932},
	{-190.1118,138.5946,5.8175},
	{15.3321,-104.6317,1.9983}
};

// FARMER
new far_start[MAX_PLAYERS char];
new far_veh[MAX_PLAYERS];
new far_place[MAX_PLAYERS]; // 1 - Blueberry, 2 - Flint County
new far_step[MAX_PLAYERS];
new far_cp[MAX_PLAYERS];

new FarmerPickup;

hook OnGameModeInit() {
    FarmerPickup = CreateDynamicPickup(1239, 2, FARMER_POS_X,FARMER_POS_Y,FARMER_POS_Z);
}

hook OnPlayerConnect(playerid) {
    far_start{playerid}=false; far_place[playerid]=0;
    far_veh[playerid]=INVALID_VEHICLE_ID; far_step[playerid]=0;
    return 1;
}
/*
hook OnPlayerDisconnect(playerid, reason) {
    if(IsValidDynamicCP(far_cp[playerid])) {
        DestroyDynamicCP(far_cp[playerid]);
    }
    return 1;
}*/

hook OP_PickUpDynamicPickup(playerid, pickupid)
{
	if(pickupid == FarmerPickup) {
		Mobile_GameTextForPlayer(playerid, "~w~Type /farmerjob to be ~n~a farmer", 5000, 3);
        CreateDynamic3DTextLabel("�����ª�����\n����� /farmerjob �����Ѻ�ҹ���", -1, FARMER_POS_X,FARMER_POS_Y,FARMER_POS_Z, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
		return 1;
	}
    return 1;
}

CMD:farmerjob(playerid)
{
    new faction = playerData[playerid][pFaction];

	if (faction != 0 && Faction_GetTypeID(playerData[playerid][pFaction]) != FACTION_TYPE_GANG)
	    return SendClientMessage(playerid, COLOR_WHITE, "������ �Ҫվ�������Ѻ��ЪҪ���ҹ�� (�á���������������㹡�����ͧ�ҧ���)");

	if (IsPlayerInRangeOfPoint(playerid, 2.5, FARMER_POS_X,FARMER_POS_Y,FARMER_POS_Z)) {

	    if(playerData[playerid][pJob] != 0)
            return SendClientMessage(playerid, COLOR_LIGHTRED, "   �س���Ҫվ�������� ����� /leavejob �����͡�ҡ�Ҫվ");

        playerData[playerid][pJob] = JOB_FARMER;
        GameTextForPlayer(playerid, "~r~Congratulations,~n~~w~You are now a ~y~Farmer.~n~~w~/jobhelp.", 8000, 1);
        SendClientMessage(playerid, COLOR_GRAD1, "�͹���س�繪���������");
		return 1;
	}
	else return SendClientMessage(playerid, COLOR_GRAD1, "�س�����������ش��Ѥçҹ");
}

CMD:harvest(playerid)
{
	if(playerData[playerid][pJob] != JOB_FARMER)
	    return SendClientMessage(playerid, COLOR_GRAD2, "˹�������ͧ�������ö��Ẻ�����!");

	new vehicleid = GetPlayerVehicleID(playerid);

	if (GetVehicleModel(vehicleid) != 532)
		return SendClientMessage(playerid, COLOR_LIGHTRED, "�س����������躹 Combine Harvester");

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	 	return SendClientMessage(playerid, COLOR_LIGHTRED, "�س��������������觤��Ѻ�ͧ�ҹ��˹�");

	if (IsPlayerInRangeOfPoint(playerid, 100.0, -377.8374,-1433.8853,25.7266)) {

		if(far_start{playerid})
            return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������������������");

		far_place[playerid]=FLINT_FARM;
		far_start{playerid}=true;
		far_veh[playerid]=vehicleid;
        far_step[playerid]=0;

		SendClientMessage(playerid, COLOR_WHITE, "�س�������������Ǽż�Ե�����Ңͧ�����");

		StartHarvesting(playerid);
        return 1;
	}
	else if (IsPlayerInRangeOfPoint(playerid, 100.0, -53.5525,70.3079,4.0933)) {

		if(far_start[playerid]) return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������������������");

		far_place[playerid]=BLUEBERRY_FARM;
		far_start{playerid}=true;
		far_veh[playerid]=vehicleid;
        far_step[playerid]=0;

		SendClientMessage(playerid, COLOR_WHITE, "�س�������������Ǽż�Ե�����Ңͧ�����");

		StartHarvesting(playerid);
        return 1;
	}
	else return SendClientMessage(playerid, COLOR_GRAD1, "�س���������������");
}

CMD:stopharvest(playerid)
{
	if(far_start{playerid})
	{
       /* if(IsValidDynamicCP(far_cp[playerid])) {
            DestroyDynamicCP(far_cp[playerid]);
        }*/
        far_cp[playerid]=0;
		far_start{playerid}=false; far_veh[playerid]=INVALID_VEHICLE_ID;
        far_place[playerid]=0; far_step[playerid]=0;
        
		return SendClientMessage(playerid, COLOR_WHITE, "�س����ش������Ǽż�Ե�ҡ�����");
	}
	else return SendClientMessage(playerid, COLOR_GRAD1, "   �س�ѧ�����������ӡ��������Ǽż�Ե");
}

StartHarvesting(playerid)
{
    new rand;
    far_step[playerid]=0;
    DisablePlayerCheckpoint(playerid);
	if(far_place[playerid] == BLUEBERRY_FARM)
	{
		rand = random(sizeof(BlueFarm));
        SetPlayerCheckpoint(playerid, BlueFarm[rand][0],BlueFarm[rand][1],BlueFarm[rand][2], 5.0);
        far_cp[playerid] = rand + 1;
	}
	else if(far_place[playerid] == FLINT_FARM)
	{
		rand = random(sizeof(FlintFarm));
        SetPlayerCheckpoint(playerid, FlintFarm[rand][0],FlintFarm[rand][1],FlintFarm[rand][2], 5.0);
        far_cp[playerid] = rand + 1;
	}
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid, checkpointid) {
	#if defined SV_DEBUG
		printf("farmer.pwn: OnPlayerEnterCheckpoint(playerid %d)", playerid);
	#endif
    if (far_start{playerid}) {
        switch(far_step[playerid]) {
            case 0: { // �������
                new vehicleid = GetPlayerVehicleID(playerid);
                if(far_veh[playerid] == vehicleid)
                {
                    //new data = Streamer_GetIntData(STREAMER_TYPE_CP, checkpointid, E_STREAMER_EXTRA_ID);
                    if (far_cp[playerid]) {
                        new rand = far_cp[playerid] - 1;
                        //printf("rand %d", rand);
                        if(far_place[playerid] == BLUEBERRY_FARM && IsPlayerInRangeOfPoint(playerid, 10.0, BlueFarm[rand][0],BlueFarm[rand][1],BlueFarm[rand][2]))
                        {
                            //printf("BLUEBERRY_FARM %f", BlueFarm[rand][0]);
                            PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);

                            /*if(IsValidDynamicCP(far_cp[playerid]))
                                DestroyDynamicCP(far_cp[playerid]);

                            far_cp[playerid] = CreateDynamicCP(-53.5525,70.3079,4.0933, 5.0, 0, 0, playerid);*/
                            DisablePlayerCheckpoint(playerid);
                            SetPlayerCheckpoint(playerid, -53.5525,70.3079,4.0933, 5.0);
                            far_step[playerid]=1;
                        }
                        else if(far_place[playerid] == FLINT_FARM && IsPlayerInRangeOfPoint(playerid, 10.0, FlintFarm[rand][0],FlintFarm[rand][1],FlintFarm[rand][2]))
                        {
                            //printf("FLINT_FARM %f", FlintFarm[rand][0]);
                            PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);

                            /*if(IsValidDynamicCP(far_cp[playerid]))
                                DestroyDynamicCP(far_cp[playerid]);

                            far_cp[playerid] = CreateDynamicCP(-377.8374,-1433.8853,25.7266, 5.0, 0, 0, playerid);*/
                            DisablePlayerCheckpoint(playerid);
                            SetPlayerCheckpoint(playerid, -377.8374,-1433.8853,25.7266, 5.0);
                            far_step[playerid]=1;
                        }
                        far_cp[playerid]= 0;
                    }
                }
            }
            case 1: { // ���������
                new vehicleid = GetPlayerVehicleID(playerid);
                if(far_veh[playerid] == vehicleid) {
                    if (IsPlayerInRangeOfPoint(playerid, 5.0, -53.5525,70.3079,4.0933) || IsPlayerInRangeOfPoint(playerid, 5.0, -377.8374,-1433.8853,25.7266)) {
                        new randmoney = 50 + random(150 + (playerData[playerid][pContractTime] * 10));

                        if (gettime() - gLastCheckpointTime[playerid] <= 5) {

                            Log(anticheatlog, INFO, "%s �� Farmer ����� %d", ReturnPlayerName(playerid), gettime() - gLastCheckpointTime[playerid]);

                            new IP[60];
                            GetPlayerIp(playerid, IP, sizeof(IP));
                            SendRconCommand(sprintf("banip %s",IP));
                            Kick(playerid);
                            return 1;
                        }
                        gLastCheckpointTime[playerid] = gettime();
                        // GameTextForPlayer(playerid, sprintf("~w~you got some wheat and sold it~n~~y~for %d$", randmoney), 5000, 1);

                        Mobile_GameTextForPlayer(playerid, sprintf("~w~Mission ~g~Passed ~n~~y~+%d$", randmoney) ,4000, 4);


                        playerData[playerid][pPayCheck] += randmoney;

                        Log(paychecklog, INFO, "%s ���Ѻ Paycheck %d �ҡ Farmer", ReturnPlayerName(playerid), randmoney);

                        PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);

                        //Next Harvesting
                        StartHarvesting(playerid);
                    }
                }
            }
        }
        return -2;
    }
    return 1;
}