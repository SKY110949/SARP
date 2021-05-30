#include <YSI\y_hooks>

new CarDMV_LS[2], CarDMV_SF[4], CarDMV_TAXI_LS[2];

new 
	driveTestType[MAX_PLAYERS], 
	bool:lessionStart[MAX_PLAYERS char], 
	lessionStep[MAX_PLAYERS], 
	lessionTime[MAX_PLAYERS],
	Float:driveHealth[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
	driveHealth[playerid]=0.0;
	driveTestType[playerid]=
	lessionStep[playerid]=
	lessionTime[playerid]=0;
	lessionStart{playerid}=false;
}

hook OnGameModeInit() {
	CarDMV_LS[0] = AddStaticVehicle(516,1274.8179,-1551.0402,13.2833,270.4145,1,1); //  Nebula
	CarDMV_LS[1] = AddStaticVehicle(516,1274.6558,-1560.1385,13.2891,269.5308,1,1); //  Nebula

	CarDMV_TAXI_LS[0] = AddStaticVehicle(438,1286.9663,-1529.9735,13.5456,270.5405,1,1); //  Taxi
	CarDMV_TAXI_LS[1] = AddStaticVehicle(438,1272.5927,-1534.6504,13.5632,269.5325,1,1); //  Taxi

	CarDMV_SF[0] = AddStaticVehicle(516,-2076.9021,-84.0612,34.9982,359.8814,1,1);
	CarDMV_SF[1] = AddStaticVehicle(516,-2068.4810,-83.9512,34.9980,0.5004,1,1);
	CarDMV_SF[2] = AddStaticVehicle(516,-2073.3521,-83.9560,34.9980,0.2087,1,1);
	CarDMV_SF[3] = AddStaticVehicle(516,-2064.1887,-84.0597,34.9981,358.9423,1,1);

    for(new c=0;c<sizeof(CarDMV_LS);c++)
    {
		Vehicle_ResetVehicle(CarDMV_LS[c]);
		SetVehicleNumberPlate(CarDMV_LS[c], "LS DMV");
		SetVehicleHealthEx(CarDMV_LS[c], GetVehicleDataHealth(GetVehicleModel(CarDMV_LS[c])));
    }

    for(new c=0;c<sizeof(CarDMV_TAXI_LS);c++)
    {
		Vehicle_ResetVehicle(CarDMV_TAXI_LS[c]);
		SetVehicleNumberPlate(CarDMV_TAXI_LS[c], "LS DMV");
		SetVehicleHealthEx(CarDMV_TAXI_LS[c], GetVehicleDataHealth(GetVehicleModel(CarDMV_TAXI_LS[c])));
    }

    for(new c=0;c<sizeof(CarDMV_SF);c++)
    {
		Vehicle_ResetVehicle(CarDMV_SF[c]);
		SetVehicleNumberPlate(CarDMV_SF[c], "SF DMV");
		SetVehicleHealthEx(CarDMV_SF[c], GetVehicleDataHealth(GetVehicleModel(CarDMV_SF[c])));
    }
}

hook OP_StateChange(playerid, newstate, oldstate)
{
	#if defined SV_DEBUG
		printf("dmv.pwn: OnPlayerStateChange(playerid %d, newstate %d, oldstate %d)", playerid, newstate, oldstate);
	#endif
	if (newstate == PLAYER_STATE_DRIVER)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

	    if(IsVehicleDMV(vehicleid)) {
            new model = GetVehicleModel(vehicleid);
            TogglePlayerControllable(playerid, false);
			if (model == 438) {
				SendClientMessage(playerid, COLOR_WHITE,"Taxi exam: ���ͧ�ͺ�硫������ҹ /licenseexam �ҡ����稨��դ������� $5000");
			}
	        else SendClientMessage(playerid, COLOR_WHITE,"License exam: ���ͧ�ͺ�͹حҵ����ҹ /licenseexam �ҡ����稨��դ������� $5000");
            // return -1;
	    }
    }
    return 1;
}

CMD:licenseexam(playerid, params[])
{
    if(GetPlayerMoney(playerid) >= 5000) {

    	new vehicleid = GetPlayerVehicleID(playerid);
    	if(( driveTestType[playerid] = IsVehicleDMV(vehicleid)) != 0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {

     		new model = GetVehicleModel(vehicleid);

            // if(playerData[playerid][pCarLic]) return SendClientMessage(playerid, COLOR_LIGHTRED, "�س���͹سҵ�Ѻ�����������");

         	if (model == 438) {
             	if(playerData[playerid][pJob] == JOB_TAXI || playerData[playerid][pSideJob] == JOB_TAXI) return SendClientMessage(playerid, COLOR_LIGHTRED, "�س���� Taxi Driver �������� !");
              	if(playerData[playerid][pJob] != JOB_NONE && playerData[playerid][pSideJob] != JOB_NONE) return SendClientMessage(playerid, COLOR_LIGHTRED, "�س��ͧ�͡�ҡ�ҹ��͹ (/leavejob ���� /leavesidejob)");
    		}
        	else {
             	if(playerData[playerid][pCarLic]) return SendClientMessage(playerid, COLOR_LIGHTRED, "�س���͹سҵ�Ѻ�����������");
         	}
	
            TogglePlayerControllable(playerid, true);
    		SetEngineStatus(vehicleid, true);
    		SendClientMessage(playerid, COLOR_LIGHTRED,"______________��ѡࡳ���âѺ���______________");
          	SendClientMessage(playerid, COLOR_LIGHTRED,"1) �Ѻ价ҧ��ҹ��Ңͧ���");
          	SendClientMessage(playerid, COLOR_LIGHTRED,"2) ���ҢѺö�����Թ�");
         	SendClientMessage(playerid, COLOR_LIGHTRED,"3) ��þ���Ѻö����� � ����ͧ���");
           	SendClientMessage(playerid, COLOR_WHITE,"������������Ҩش��Ǩ�ͺ��о��Ҷ֧�ش�ش��������ҷ���˹����ѹ����÷��ͺ");
           	SendClientMessage(playerid, COLOR_WHITE,"���ҢѺ�����Թ� �س�Ҩ���ʺ�ѭ�Һ���ͧ����ҡ�س��");
			lessionTime[playerid] = 75;
			lessionStep[playerid] = 1;
			lessionStart{playerid} = false;

			switch(driveTestType[playerid]) {
				case 1: SetPlayerCheckpoint(playerid, 1219.1036,-1569.8324,13.0955, 4.0);
				case 2: SetPlayerCheckpoint(playerid, -2070.5547,-68.0406,35.0059, 4.0);
				case 3: SetPlayerCheckpoint(playerid, 1219.1036,-1569.8324,13.0955, 4.0);
			}
    	}
    	else SendClientMessage(playerid, COLOR_LIGHTRED, "�س��������躹�ҹ��˹�����Ѻ�ͺ�͹سҵ�Ѻ���");
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "�س���Թ���ͷ��Ш����ѹ");


    return 1;
}

hook OnPlayerEnterCheckpoint(playerid) {
	#if defined SV_DEBUG
		printf("dmv.pwn: OnPlayerEnterCheckpoint(playerid %d)", playerid);
	#endif
	if (lessionStep[playerid]) {
		new vehicleid = GetPlayerVehicleID(playerid);
		switch(driveTestType[playerid]) {
			case 1: { // LS
				if(IsVehicleDMV(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
				{
					PlayerPlaySound(playerid, 1138, 0.0, 0.0, 0.0);
					if(lessionStep[playerid] == 1)
					{
						GetVehicleHealth(vehicleid, driveHealth[playerid]);

						Mobile_GameTextForPlayer(playerid, "~w~75", 1200, 3);
						lessionStart{playerid} = true;
						DisablePlayerCheckpoint(playerid);
						SendClientMessage(playerid, COLOR_GREEN, "价ҧ����ͧ������ᴧ �ô�����������Ѻ�Ź��Ңͧ���");
						SetPlayerCheckpoint(playerid, 1142.9375,-1569.5576,12.9785, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 2)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1040.8793,-1569.6158,13.0935, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 3)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1048.6573,-1492.2428,13.0935, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 4)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 930.3591,-1486.9060,13.0795, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 5)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 915.2392,-1524.6128,13.0875, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 6)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 915.0828,-1574.5353,13.0882, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 7)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 907.6953,-1769.6998,13.0873, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 8)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 813.3115,-1764.1138,13.1047, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 9)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 876.8595,-1580.0282,13.0877, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 10)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1012.6880,-1574.8156,13.0875, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 11)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1249.2765,-1574.5369,13.0878, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 12)
					{
						DisablePlayerCheckpoint(playerid);

						if(lessionTime[playerid] <= 10)
						{
							playerData[playerid][pCarLic] = true;
							GameTextForPlayer(playerid, "~w~Congratulations! here is your license!", 5000, 1);
							GivePlayerMoneyEx(playerid, -5000);
						} else SendClientMessage(playerid, COLOR_GREEN, "��âѺö�����Թ�����繷������Ѻ");
						driveHealth[playerid]=0.0;
						driveTestType[playerid]=
						lessionStep[playerid]=
						lessionTime[playerid]=0;
						lessionStart{playerid}=false;
						SetVehicleToRespawn(vehicleid);
					}
				}
			}
			case 2: { // SF
				if(IsVehicleDMV(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
				{
					PlayerPlaySound(playerid, 1138, 0.0, 0.0, 0.0);
					if(lessionStep[playerid] == 1)
					{
						GetVehicleHealth(vehicleid, driveHealth[playerid]);

						Mobile_GameTextForPlayer(playerid, "~w~75", 1200, 3);
						lessionStart{playerid} = true;
						DisablePlayerCheckpoint(playerid);
						SendClientMessage(playerid, COLOR_GREEN, "价ҧ����ͧ������ᴧ �ô�����������Ѻ�Ź��Ңͧ���");
						SetPlayerCheckpoint(playerid, -2070.5547,-68.0406,35.0059, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 2)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, -2084.5796,15.1153,35.0056, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 3)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, -2151.2891,33.1400,35.0058, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 4)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, -2169.8293,-55.3741,35.0082, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 5)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, -2353.2297,-67.7443,34.9982, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 6)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, -2374.1777,-147.9185,35.0058, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 7)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, -2232.9866,-192.4917,35.0098, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 8)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, -2169.0776,-295.5234,35.2501, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 9)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, -2003.5806,-269.8704,35.1669, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 10)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, -2003.5341,14.2524,32.9226, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 11)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, -2075.3550,33.5458,35.0058, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 12)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, -2089.8508,-51.8440,35.0376, 4.0);
						lessionStep[playerid]++;
					}
					else if(lessionStep[playerid] == 13)
					{
						DisablePlayerCheckpoint(playerid);

						if(lessionTime[playerid] <= 10)
						{
							playerData[playerid][pCarLic] = true;
							GameTextForPlayer(playerid, "~w~Congratulations! here is your license!", 5000, 1);
							GivePlayerMoneyEx(playerid, -5000);
						} else SendClientMessage(playerid, COLOR_GREEN, "��âѺö�����Թ�����繷������Ѻ");
						driveHealth[playerid]=0.0;
						driveTestType[playerid]=
						lessionStep[playerid]=
						lessionTime[playerid]=0;
						lessionStart{playerid}=false;
						SetVehicleToRespawn(vehicleid);
					}
				}
			}
			case 3: { // TAXI LS
				if(IsVehicleDMV(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
				{
					PlayerPlaySound(playerid, 1138, 0.0, 0.0, 0.0);

					if(lessionStep[playerid] == 1)
					{
						GetVehicleHealth(vehicleid, driveHealth[playerid]);

						Mobile_GameTextForPlayer(playerid, "~w~75", 1200, 3);
						lessionStart{playerid} = true;
						DisablePlayerCheckpoint(playerid);
						SendClientMessage(playerid, COLOR_GREEN, "价ҧ����ͧ������ᴧ �ô�����������Ѻ�Ź��Ңͧ���");
						SetPlayerCheckpoint(playerid, 1288.9124,-1573.6912,13.3828, 4.0);
						lessionStep[playerid]++;

						SendClientMessage(playerid, COLOR_WHITE, "�Թ�յ�͹�Ѻ�������÷��ͺ�硫��! �ô���㨡Ѻ��ͤ���");
						SendClientMessage(playerid, COLOR_WHITE, "�����ѧ���Դ���");
					}
					else if(lessionStep[playerid] == 2) // 2
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1359.0680,-1419.6614,13.3828, 4.0);
						lessionStep[playerid]++;


						SendClientMessage(playerid, COLOR_WHITE, "����鹷ҧ����ҡ�ѡ��ʹ����Թö���س��");
						SendClientMessage(playerid, COLOR_WHITE, "���Ѻ�ҹ�硫������ͷӡ�÷��ͺ�������");
					}
					else if(lessionStep[playerid] == 3)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1333.9957,-1398.6868,13.3542, 4.0);
						lessionStep[playerid]++;


						SendClientMessage(playerid, COLOR_WHITE, "������µ�ʹ��鹷ҧ����͡�âѺö�ͧ�س�ҡ�ش");
						SendClientMessage(playerid, COLOR_WHITE, "A ��ѧ�ش B �ѹ�����س���������ǡѺ��鹷ҧ�ͺ � ���ͧ Los Santos!");
					}
					else if(lessionStep[playerid] == 4)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1211.2808,-1322.8888,13.5589, 4.0);
						lessionStep[playerid]++;


						SendClientMessage(playerid, COLOR_YELLOW, "|_________Taxi Call_________|");
						SendClientMessage(playerid, COLOR_YELLOW, "�����: Taxi_Instructor ����: 90210");
						SendClientMessage(playerid, COLOR_YELLOW, "���˹�: ��ҧ˹���ç��Һ�� All Saint !");
						SendClientMessage(playerid, COLOR_WHITE, "�����: �Ѻ���ҧ���Ѵ���ѧ��з���������������ʹ��鹷ҧ����Թö");
					}
					else if(lessionStep[playerid] == 5)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1072.5366,-1278.2339,13.3828, 4.0);
						lessionStep[playerid]++;

						SendClientMessage(playerid, COLOR_WHITE, "��������: �ô�ҩѹ价��ʵٴ����Ҿ¹��");
					}
					else if(lessionStep[playerid] == 6)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 952.7286,-1218.6337,16.7341, 4.0);
						lessionStep[playerid]++;

					}
					else if(lessionStep[playerid] == 7)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 937.3082,-1281.0801,14.9837, 4.0);
						lessionStep[playerid]++;

						SendClientMessage(playerid, COLOR_WHITE, "��������: �ͺ�س�������!");
					}
					else if(lessionStep[playerid] == 8)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1132.1293,-1411.0457,13.6248, 4.0);
						lessionStep[playerid]++;

						lessionTime[playerid] += 50;
						SendClientMessage(playerid, COLOR_YELLOW, "|_________Taxi Call_________|");
						SendClientMessage(playerid, COLOR_YELLOW, "�����: Taxi_Instructor ����: 90210");
						SendClientMessage(playerid, COLOR_YELLOW, "���˹�: ����������� !");

					}
					else if(lessionStep[playerid] == 9)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1193.5734,-1561.8549,13.3828, 4.0);
						lessionStep[playerid]++;


						SendClientMessage(playerid, 0xF8E0ECFF, "��������: �ô价���Ҵ!");
					}
					else if(lessionStep[playerid] == 10)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1206.1475,-1717.4045,13.5469, 4.0);
						lessionStep[playerid]++;

					}
					else if(lessionStep[playerid] == 11)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1534.5322,-1657.3186,13.3828, 4.0);
						lessionStep[playerid]++;


						SendClientMessage(playerid, 0xF8E0ECFF, "��������: �ͺ�س�������!");
						lessionTime[playerid] += 100;
						SendClientMessage(playerid, COLOR_YELLOW, "|_________Taxi Call_________|");
						SendClientMessage(playerid, COLOR_YELLOW, "�����: Taxi_Instructor ����: 90210");
						SendClientMessage(playerid, COLOR_YELLOW, "���˹�: ʶҹյ��Ǩ! ���ҧ��觴�ǹ");
					}
					else if(lessionStep[playerid] == 12)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1437.5542,-1553.3374,13.5469, 4.0);
						lessionStep[playerid]++;

						SendClientMessage(playerid, COLOR_LIGHTCYAN2, "��������: �ѹ�й�����絾������� � ����");
					}
					else if(lessionStep[playerid] == 13)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1457.3812,-1314.1404,13.3828, 4.0);
						lessionStep[playerid]++;


					}
					else if(lessionStep[playerid] == 14)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1703.0131,-1304.3083,13.4166, 4.0);
						lessionStep[playerid]++;

						SendClientMessage(playerid, COLOR_LIGHTCYAN2, "��������: ������ѹ�����ѹ!");
						SendClientMessage(playerid, COLOR_LIGHTRED, "[������������������-���Ҷ١�ѡ]");
						lessionTime[playerid] -= 10;

					}
					else if(lessionStep[playerid] == 15)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1655.6829,-1456.3467,13.3837, 4.0);
						lessionStep[playerid]++;


						SendClientMessage(playerid, COLOR_LIGHTCYAN2, "��������: �ҩѹ��Ѻ价��ʶҹյ��Ǩ");

					}
					else if(lessionStep[playerid] == 16)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1524.3076,-1663.1096,13.5469, 4.0);
						lessionStep[playerid]++;


						lessionTime[playerid] += 5;
						SendClientMessage(playerid, COLOR_LIGHTRED, "[�س�����Թ�����Ҵ����](��������)");

					}
					else if(lessionStep[playerid] == 17)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1827.0012,-1680.2316,13.5469, 4.0);
						lessionStep[playerid]++;


						lessionTime[playerid] += 100;

						SendClientMessage(playerid, COLOR_YELLOW, "|_________Taxi Call_________|");
						SendClientMessage(playerid, COLOR_YELLOW, "�����: Taxi_Instructor ����: 90210");
						SendClientMessage(playerid, COLOR_YELLOW, "���˹�: �����������");
					}
					else if(lessionStep[playerid] == 18)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1968.9856,-1622.3890,15.9688, 4.0);
						lessionStep[playerid]++;


						SendClientMessage(playerid, COLOR_WHITE, "��������: �ԫ������ IDLEWOOD");

					}
					else if(lessionStep[playerid] == 19)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 2079.0129,-1658.8647,13.3906, 4.0);
						lessionStep[playerid]++;


						SendClientMessage(playerid, COLOR_WHITE, "��������: �ѹ��Ǩ�ԧ � ...");
						SendClientMessage(playerid, COLOR_LIGHTRED, "[������������������-���Ҷ١�ѡ]");
						lessionTime[playerid] -= 15;
					}
					else if(lessionStep[playerid] == 20)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 2115.4177,-1778.2894,13.3903, 4.0);
						lessionStep[playerid]++;


						lessionTime[playerid] += 5;
						SendClientMessage(playerid, COLOR_LIGHTRED, "[�س�����Թ�����Ҵ����](��������)");


					}
					else if(lessionStep[playerid] == 21)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 2648.0222,-1676.4285,10.8086, 4.0);
						lessionStep[playerid]++;



						SendClientMessage(playerid, COLOR_WHITE, "��������: �ͺ�س��������ҷ��ѹ��");
						lessionTime[playerid] += 50;
						SendClientMessage(playerid, COLOR_YELLOW, "|_________Taxi Call_________|");
						SendClientMessage(playerid, COLOR_YELLOW, "�����: Taxi_Instructor ����: 90210");
						SendClientMessage(playerid, COLOR_YELLOW, "���˹�: ���ʹ������ ���͹�ͧ�ѹ��Щѹ��ͧ���ö�����!");

					}
					else if(lessionStep[playerid] == 22)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 2645.4697,-1234.8927,49.8451, 4.0);
						lessionStep[playerid]++;


						SendClientMessage(playerid, 0xF8E0ECFF, "��������: �ѹ��ͧ��ù��仺�ҹ ���͹��Ңͧ�ѹ�ѹ��������ա���ҧ�ͤ����ͧ��");
					}
					else if(lessionStep[playerid] == 23)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 2607.1348,-1037.3793,69.6366, 4.0);
						lessionStep[playerid]++;


						SendClientMessage(playerid, 0xF8E0ECFF, "��������: �ѹ�����ѹ�ø���ҩѹ�Դ�֧�ͤԴ�����");
						SendClientMessage(playerid, COLOR_LIGHTRED, "[������������������-���Ҷ١�ѡ]");
						lessionTime[playerid] -= 40;
					}
					else if(lessionStep[playerid] == 24)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 2501.7471,-972.1787,82.2425, 4.0);
						lessionStep[playerid]++;

					}
					else if(lessionStep[playerid] == 25)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 2647.6921,-1672.7454,10.7948, 4.0);
						lessionStep[playerid]++;


						SendClientMessage(playerid, 0xF8E0ECFF, "��������: �س������Ѻ������� �ѹ�ѧ��������Թ...");
						lessionTime[playerid] += 200;
					}
					else if(lessionStep[playerid] == 26)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 2229.6445,-1729.9596,13.3828, 4.0);
						lessionStep[playerid]++;

						SendClientMessage(playerid, 0xF8E0ECFF, "�������� 2: �ô价����������!");
					}
					else if(lessionStep[playerid] == 27)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1962.4601,-1749.5858,13.3828, 4.0);
						lessionStep[playerid]++;

					}
					else if(lessionStep[playerid] == 28)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1936.6576,-1772.4995,13.3828, 4.0);
						lessionStep[playerid]++;

					}
					else if(lessionStep[playerid] == 29)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1762.6610,-1729.7421,13.3828, 4.0);
						lessionStep[playerid]++;


						SendClientMessage(playerid, 0xF8E0ECFF, "�������� 2: �ҡ�س���������� ���价ҧ�������������?");
					}
					else if(lessionStep[playerid] == 30)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1762.2166,-1606.8145,13.3797, 4.0);
						lessionStep[playerid]++;

					}
					else if(lessionStep[playerid] == 31)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1816.7012,-1682.6655,13.3828, 4.0);
						lessionStep[playerid]++;

					}
					else if(lessionStep[playerid] == 32)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1279.2948,-1398.0652,13.0750, 4.0);
						lessionStep[playerid]++;

						SendClientMessage(playerid, COLOR_LIGHTCYAN2, "�������� 2: *�͹����* �ô�ҩѹ价������������");
						SendClientMessage(playerid, COLOR_LIGHTRED, "[������������������-���Ҷ١�ѡ]");
						lessionTime[playerid] -= 10;
					}
					else if(lessionStep[playerid] == 33)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1120.0308,-1390.4103,13.4627, 4.0);
						lessionStep[playerid]++;

						lessionTime[playerid] += 10;
						SendClientMessage(playerid, COLOR_LIGHTRED, "[�س�����Թ�����Ҵ����](��������)");
					}
					else if(lessionStep[playerid] == 34)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 642.6805,-1355.8063,13.5621, 4.0);
						lessionStep[playerid]++;

						SendClientMessage(playerid, COLOR_LIGHTCYAN2, "�������� 2: �ͺ�س");
						SendClientMessage(playerid, COLOR_YELLOW, "|_________Taxi Call_________|");
						SendClientMessage(playerid, COLOR_YELLOW, "�����: Taxi_Instructor ����: 90210");
						SendClientMessage(playerid, COLOR_YELLOW, "���˹�: ���ʵٴ����Ҿ¹��");

						lessionTime[playerid] += 145;
					}
					else if(lessionStep[playerid] == 35)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1375.0747,-2287.1389,13.3530, 4.0);
						lessionStep[playerid]++;

						SendClientMessage(playerid, COLOR_LIGHTCYAN2, "��������: ʹ���Թ ���� � ���¡�͹���ѹ�е�����ͧ !");
						SendClientMessage(playerid, COLOR_LIGHTRED, "[������������������-���Ҷ١�ѡ]");
						lessionTime[playerid] -= 15;
					}
					else if(lessionStep[playerid] == 36)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1540.4331,-2287.9326,13.3828, 4.0);
						lessionStep[playerid]++;

						lessionTime[playerid] += 5;
						SendClientMessage(playerid, COLOR_LIGHTRED, "[�س�����Թ�����Ҵ����](��������)");
					}
					else if(lessionStep[playerid] == 37)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1683.5861,-2248.6130,-2.6732, 4.0);
						lessionStep[playerid]++;


					}
					else if(lessionStep[playerid] == 38)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1680.6915,-2324.1389,-2.8516, 4.0);
						lessionStep[playerid]++;


						SendClientMessage(playerid, COLOR_LIGHTCYAN2, "��������: �ͺ�س�ҡ�� !");

						SendClientMessage(playerid, COLOR_YELLOW, "|_________Taxi Call_________|");
						SendClientMessage(playerid, COLOR_YELLOW, "�����: Taxi_Instructor ����: 90210");
						SendClientMessage(playerid, COLOR_YELLOW, "���˹�: ���ʹ���Թ");

						lessionTime[playerid] += 100;

					}
					else if(lessionStep[playerid] == 39)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1556.8877,-2284.6323,13.3828, 4.0);
						lessionStep[playerid]++;


						SendClientMessage(playerid, COLOR_LIGHTCYAN2, "��������: �ô价���ç���¹�͹�Ѻö..");

					}
					else if(lessionStep[playerid] == 40)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1383.1172,-2285.7288,13.3110, 4.0);
						lessionStep[playerid]++;


					}
					else if(lessionStep[playerid] == 41)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1837.4260,-1558.3635,13.3704, 4.0);
						lessionStep[playerid]++;



					}
					else if(lessionStep[playerid] == 42)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1441.3636,-1590.0765,13.3828, 4.0);
						lessionStep[playerid]++;


					}
					else if(lessionStep[playerid] == 43)
					{
						DisablePlayerCheckpoint(playerid);
						SetPlayerCheckpoint(playerid, 1280.8734,-1567.3806,13.3828, 4.0);
						lessionStep[playerid]++;



					}
					else if(lessionStep[playerid] == 44)
					{
						DisablePlayerCheckpoint(playerid);

						SendClientMessage(playerid, COLOR_LIGHTCYAN2, "��������: �ͺ�س!");

						if(playerData[playerid][pJob] == JOB_NONE)
						{
							playerData[playerid][pJob] = JOB_TAXI;

							if(playerData[playerid][pSideJob] == JOB_NONE) 
								SendClientMessage(playerid, COLOR_GRAD6, "/jobswitch ���ͷ�����ѹ��������Ҫվ�����");
						}
						else
						{
							if(playerData[playerid][pSideJob] == JOB_NONE)
							{
								playerData[playerid][pSideJob] = JOB_TAXI;
							}
							else
							{
								SendClientMessage(playerid, COLOR_LIGHTRED, "�س��ͧ�͡�ҡ�ҹ��͹ (/leavejob ���� /leavesidejob)");
							}
						}
						GivePlayerMoneyEx(playerid, -5000);
						GameTextForPlayer(playerid, "~w~Congratulations! you are now a taxi driver!", 5000, 1);

						driveHealth[playerid]=0.0;
						driveTestType[playerid]=
						lessionStep[playerid]=
						lessionTime[playerid]=0;
						lessionStart{playerid}=false;
						SetVehicleToRespawn(vehicleid);

					}
				}
			}
		}
		return -2;
	}
    return 1;
}

IsVehicleDMV(vehicleid)
{
	// LS DMV
	for(new c=0;c<sizeof(CarDMV_LS);c++) if(vehicleid == CarDMV_LS[c]) return 1;

	// SF DMV
	for(new c=0;c<sizeof(CarDMV_SF);c++) if(vehicleid == CarDMV_SF[c]) return 2;

	// SF DMV
	for(new c=0;c<sizeof(CarDMV_TAXI_LS);c++) if(vehicleid == CarDMV_TAXI_LS[c]) return 3;
	return 0;
}

ptask DMVTimer[1000](playerid) {
	if (driveTestType[playerid]) {
		if(lessionStart{playerid}) {
			if(lessionTime[playerid] != 0 && lessionStart{playerid})
			{
				new Float:hp, vehicleid = GetPlayerVehicleID(playerid);
				GetVehicleHealth(vehicleid, hp);
				if(hp < driveHealth[playerid] && driveHealth[playerid] - hp > 5.0)
				{
					driveHealth[playerid]=0.0;
					driveTestType[playerid]=
					lessionStep[playerid]=
					lessionTime[playerid]=0;
					lessionStart{playerid}=false;
					
					SendClientMessage(playerid, COLOR_GREEN, "�ҹ��˹�������¡�÷��ͺ�֧�������");
					DisablePlayerCheckpoint(playerid);
					SetVehicleToRespawn(vehicleid);
				}
			}

			if(lessionTime[playerid])
			{
				Mobile_GameTextForPlayer(playerid, sprintf("~w~%d", lessionTime[playerid]), 1200, 3);
				lessionTime[playerid]--;
			}
			else
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				driveHealth[playerid]=0.0;
				driveTestType[playerid]=
				lessionStep[playerid]=
				lessionTime[playerid]=0;
				lessionStart{playerid}=false;
				SendClientMessage(playerid, COLOR_GREEN, "�������.. ��÷��ͺ�֧�������");

				DisablePlayerCheckpoint(playerid);
				SetVehicleToRespawn(vehicleid);
			}
		}
	}
}

hook OnPlayerExitVehicle(playerid, vehicleid) {
	if(driveTestType[playerid]) {
		driveHealth[playerid]=0.0;
		driveTestType[playerid]=
		lessionStep[playerid]=
		lessionTime[playerid]=0;
		lessionStart{playerid}=false;

		SendClientMessage(playerid, COLOR_GREEN, "�س�͡�ҡ�ҹ��˹С�÷��ͺ�֧�������");
		DisablePlayerCheckpoint(playerid);
		SetVehicleToRespawn(vehicleid);
	}
	return 1;
}