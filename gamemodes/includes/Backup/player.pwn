alias:help("���������");
CMD:help(playerid) {

	SendClientMessage(playerid, COLOR_GREEN, "___________________________����觾�鹰ҹ___________________________");
	SendClientMessage(playerid, COLOR_GRAD1, "�����: /id, /stats (��ʶҹе���Ф�), /changepass (����¹���ʼ�ҹ), /pitem, (/s)pawn(c)hange");
	SendClientMessage(playerid, COLOR_GRAD1, "(/c)hange(o)rigin, /buylevel, /pay (����Թ), /frisk (�鹵��)");

	SendClientMessage(playerid, COLOR_GRAD1, "᪷: (/o)oc (�ٴ��·��Ƿ�����������), /pm (��ЫԺ), /b (�ٴ��¹͡���ҷ), /me (�͡��á�з�)");
	SendClientMessage(playerid, COLOR_GRAD1, "᪷: /do (�ʴ�), /dolow, (/l)ocal ���� /t (�ٴ���㹺��ҷ����͹�����ٴ������������� Animation), /low (�ٴ㹺��ҷ���Թ�������� �)");

	if (playerData[playerid][pLevel] < 3)
		SendClientMessage(playerid, COLOR_GRAD1, "����������: /newspaper, (/n)ewbie (�ٴ��·��Ƿ�����������)");

	SendClientMessage(playerid, COLOR_GRAD1, "��˹�: (/v)ehicle (ö��ǹ���), (/en)gine, /fuel (�礹���ѹ), /fill (�������ѹ)");
	SendClientMessage(playerid, COLOR_GRAD1, "��� �: /househelp, /businesshelp, /factionhelp, /jobhelp, /fishhelp, /animhelp, /planthelp");
	SendClientMessage(playerid, COLOR_GRAD1, "/drughelp, /tog(ooc|pm|hud), /donate (������������������ �����Է�Ծ���ɵ�ҧ �), /party (���ҧ������)");
}

alias:id("�ʹ�");
CMD:id(playerid, params[])
{
	new ids[MAX_PLAYERS], i;

	if (sscanf(params, "?<MATCH_NAME_PARTIAL=1>u[500]", ids))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /id [�ʹռ�����/���ͺҧ��ǹ]");

	for (i = 0; ids[i] != INVALID_PLAYER_ID; ++ i)
	{
	    if (ids[i] == -1) break;

	    SendClientMessageEx(playerid, COLOR_GRAD1, "[�ʹ� %d] %s | �����: %d | ��ṹ: %d | ��蹺�: %s", ids[i], ReturnPlayerName(ids[i]), playerData[ids[i]][pLevel], playerData[ids[i]][pScore], isPlayerAndroid(ids[i]) == 0 ? "PC" : "Android");
	}
	if (i == 0) SendClientMessage(playerid, COLOR_GRAD1, "   ��辺���������ʹռ����蹷���к�");

	return 1;
}

alias:newspaper("ns");
CMD:newspaper(playerid)
{
	if (IsPlayerInRangeOfPoint(playerid, 2.0, -2034.5723,-61.9950,35.3203) || IsPlayerInRangeOfPoint(playerid, 2.0, 1714.9922,-1904.1827,13.5666))
	{
  		Dialog_Show(playerid, DialogNewsPaper, DIALOG_STYLE_LIST, "˹ѧ��;�����ѹ���", "�����ž����ͧ\n��è�ҧ�ҹ��Чҹ���١������", "��ҹ���", "�Դ");
		return 1;
	}
	else SendClientMessage(playerid, COLOR_GREY,"** �س���������ç˹ѧ��;����");

	return 1;
}

CMD:gps(playerid)
{
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "����觹������੾��������׹���躹���");
  	Dialog_Show(playerid, DialogNewsPaper, DIALOG_STYLE_LIST, "Ἱ����Թ�ҧ San Andreas", "�����ž����ͧ\n��è�ҧ�ҹ��Чҹ���١������", "��ҹ���", "�Դ");
	return 1;
}

Dialog:DialogNewsPaper(playerid, response, listitem, inputtext[]) {
	if (response) {
		switch(listitem) {
			case 0: {
				// �����ž����ͧ
				return Dialog_Show(playerid, DialogNewsCitizen, DIALOG_STYLE_LIST, "�����ž����ͧ", "�����硫���ѧ�\n����������˹���ҧ\n��âͤ�����������ͨҡᾷ��\n��âͤ�����������ͨҡ���Ǩ", "��ҹ���", "��Ѻ");
			}
			case 1: {
				// ��è�ҧ�ҹ��Чҹ���١������
				return Dialog_Show(playerid, DialogNewsEmployment, DIALOG_STYLE_LIST, "��è�ҧ�ҹ��Чҹ���١������", "������\n��ѡ�ҹ��Ҵ���\n��ѡ�ҹ�红��\n��ҧ����ö\n���Ѻö��÷ء\n��ǻ����\n��ѡ�ҹ�ش����ͧ���\n��ѡ�ҹ�觾ԫ���\n���Ѻö�硫��", "��ҹ���", "��Ѻ");
			}
		}
	}
	return 1;
}

Dialog:DialogNewsCitizen(playerid, response, listitem, inputtext[]) {
	if (response) {
		switch(listitem) {
			case 0: { // �����硫���ѧ�
			    SendClientMessage(playerid, COLOR_GREEN,"___________�����硫���ѧ�:___________");
				SendClientMessage(playerid, COLOR_WHITE,"(/c)all 544");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
			}
			case 1: { // ����������˹���ҧ
			    SendClientMessage(playerid, COLOR_GREEN,"___________����������˹���ҧ:___________");
				SendClientMessage(playerid, COLOR_WHITE,"- �������������ͧ��ç���");
                SendClientMessage(playerid, COLOR_WHITE,"- �����ͧ����㹺�ҹ�ѡ��ѧ");
                SendClientMessage(playerid, COLOR_WHITE,"- ����������������ç��� Garcia");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
			}
			case 2: { // ��âͤ�����������ͨҡᾷ��
			    SendClientMessage(playerid, COLOR_GREEN,"___________��âͤ�����������ͨҡᾷ��:___________");
				SendClientMessage(playerid, COLOR_WHITE,"(/c)all 911 (��������͡��ԡ��)");
				SendClientMessage(playerid, COLOR_WHITE,"���ͺ�ԡ��������: ᾷ��, ��駤��");
				SendClientMessage(playerid, COLOR_WHITE,"���ͺ�ԡ�������ѧ���: medic, both");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
			}
			case 3: { //��âͤ�����������ͨҡ���Ǩ
			    SendClientMessage(playerid, COLOR_GREEN,"___________��âͤ�����������ͨҡ���Ǩ:___________");
				SendClientMessage(playerid, COLOR_WHITE,"(/c)all 911 (��������͡��ԡ��)");
				SendClientMessage(playerid, COLOR_WHITE,"���ͺ�ԡ��������: ���Ǩ, ��駤��");
				SendClientMessage(playerid, COLOR_WHITE,"���ͺ�ԡ�������ѧ���: police, both");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
			}
		}
	}
	else {
		Dialog_Show(playerid, DialogNewsCitizen, DIALOG_STYLE_LIST, "�����ž����ͧ", "�����硫���ѧ�\n����������˹���ҧ\n��âͤ�����������ͨҡᾷ��\n��âͤ�����������ͨҡ���Ǩ", "��ҹ���", "��Ѻ");
	}
	return 1;
}

Dialog:DialogNewsEmployment(playerid, response, listitem, inputtext[]) {
	if (response) {
		switch(listitem) {
			case 0: { // ������
			    SendClientMessage(playerid, COLOR_GREEN,"___________������:___________");
				SendClientMessage(playerid, COLOR_WHITE,"��������������Ǽż�Ե�����Ңͧ�����");
                SendClientMessage(playerid, COLOR_WHITE,"/harvest (�س���繵�ͧ�� Combine Harvester)");
                SendClientMessage(playerid, COLOR_YELLOW,"> ʶҹ���ͧ�Ҫվ���١������ͧ�������躹Ἱ���");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
				SetPlayerCheckpoint(playerid, -382.5893,-1426.3422,26.2217, 3.5);
				gPlayerCheckpoint{playerid}=true;
			}
			case 1: { // ��ѡ�ҹ��Ҵ���
			    SendClientMessage(playerid, COLOR_GREEN,"___________��ѡ�ҹ��Ҵ���:___________");
				SendClientMessage(playerid, COLOR_WHITE,"��ѡ�ҹ��Ҵ�������纡�Ҵ㹾�鹷���ͧ������ǡ���");
                SendClientMessage(playerid, COLOR_WHITE,"/sweeper (��������)");
                SendClientMessage(playerid, COLOR_YELLOW,"> ʶҹ���ͧ�Ҫվ���١������ͧ�������躹Ἱ���");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
				SetPlayerCheckpoint(playerid, -2211.9644,1056.2740,80.0078, 3.5);
				gPlayerCheckpoint{playerid}=true;
			}
			case 2: { // ��ѡ�ҹ�红��
			    SendClientMessage(playerid, COLOR_GREEN,"___________��ѡ�ҹ�红��:___________");
				SendClientMessage(playerid, COLOR_WHITE,"��ѡ�ҹ�红������ͧ��ʫҹ��");
                SendClientMessage(playerid, COLOR_WHITE,"/collect (��������)");
                SendClientMessage(playerid, COLOR_YELLOW,"> ʶҹ���ͧ�Ҫվ���١������ͧ�������躹Ἱ���");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
				SetPlayerCheckpoint(playerid, 2173.5701,-1982.8094, 13.5513, 3.5);
				gPlayerCheckpoint{playerid}=true;
			}
			case 3: { // ��ҧ����ö
			    SendClientMessage(playerid, COLOR_GREEN,"___________��ҧ����ö:___________");
				SendClientMessage(playerid, COLOR_WHITE,"��ҧ������з���ö����");
				SendClientMessage(playerid, COLOR_WHITE,"�����ǹö¹�����ö�ҡ�٧");
                SendClientMessage(playerid, COLOR_WHITE,"/service (�س���繵�ͧ�� Tow truck)");
                SendClientMessage(playerid, COLOR_YELLOW,"> ʶҹ���ͧ�Ҫվ���١������ͧ�������躹Ἱ���");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
				SetPlayerCheckpoint(playerid, 88.4620,-165.0116,2.5938, 3.5);
				gPlayerCheckpoint{playerid}=true;
			}
	        case 4: // Trucker
	        {
		    	SendClientMessage(playerid, COLOR_GREEN,"___________���Ѻö��÷ء:___________");
				SendClientMessage(playerid, COLOR_WHITE,"ö��÷ء��ʫҹ��; ���������ɰ�Ԩ����ͧ����͹���");
				SendClientMessage(playerid, COLOR_WHITE,"�����㺢Ѻ����������! (/truckerjob)");
                SendClientMessage(playerid, COLOR_YELLOW,"> ʶҹ���ͧ�Ҫվ���١������ͧ�������躹Ἱ���");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
				SetPlayerCheckpoint(playerid, -76.9150,-1136.6500,1.0781, 30.0);
				gPlayerCheckpoint{playerid}=true;
			}
	        case 5: // Fishing
	        {
		    	SendClientMessage(playerid, COLOR_GREEN,"___________��ǻ����:___________");
				SendClientMessage(playerid, COLOR_WHITE,"��ǻ����; ����Ҵ�������, ���ǹӻ��仢�¨����Ѻ�Թ�繤�ҵͺ᷹");
				SendClientMessage(playerid, COLOR_WHITE,"��������������������Ѻ��÷ӧҹ! (/gofishing)");
                SendClientMessage(playerid, COLOR_YELLOW,"> ʶҹ���ͧ�Ҫվ���١������ͧ�������躹Ἱ���");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
				SetPlayerCheckpoint(playerid, -2072.0955,7.8359,182.3791, 20.5);
				gPlayerCheckpoint{playerid}=true;
			}
	        case 6: // Mine
	        {
		    	SendClientMessage(playerid, COLOR_GREEN,"___________��ѡ�ҹ�ش����ͧ���:___________");
				SendClientMessage(playerid, COLOR_WHITE,"��ѡ�ҹ�ش����ͧ���; ���դ���������, ���ǹ��������ٻ��й�仢�� !!");
				SendClientMessage(playerid, COLOR_WHITE,"�س����դ�����ѹ�ҡ��ͧ��÷��Ҫվ���, ����Ҫվ�������ͧ��ö¹��㹡�÷ӧҹ");
                SendClientMessage(playerid, COLOR_YELLOW,"> ʶҹ���ͧ�Ҫվ���١������ͧ�������躹Ἱ���");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
				SetPlayerCheckpoint(playerid, 595.7678, 921.1524, -39.9265, 3.5);
				gPlayerCheckpoint{playerid}=true;
			}
	        case 7: // Pizza
	        {
		    	SendClientMessage(playerid, COLOR_GREEN,"___________��ѡ�ҹ�觾ԫ���:___________");
				SendClientMessage(playerid, COLOR_WHITE,"��ѡ�ҹ�觾ԫ���; �Ӿԫ��ҷ��س���Ѻ��觵����ҹ�ͧ�١���");
				SendClientMessage(playerid, COLOR_WHITE,"�س�����㺢Ѻ������ͷ�����÷ӧҹ�ͧ�س��ʹ�������Һ���");
                SendClientMessage(playerid, COLOR_YELLOW,"> ʶҹ���ͧ�Ҫվ���١������ͧ�������躹Ἱ���");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
				SetPlayerCheckpoint(playerid, 2104.2502, -1806.3750, 13.5547, 3.5);
				gPlayerCheckpoint{playerid}=true;
			}
	        case 8: // Taxi
	        {
		    	SendClientMessage(playerid, COLOR_GREEN,"___________���Ѻö�硫��:___________");
				SendClientMessage(playerid, COLOR_WHITE,"���Ѻö�硫��; �Ѻ�١��Ҽ�ҹ���Ѿ������Ѻ���١�����ѧʶҹ����ͧ���");
				SendClientMessage(playerid, COLOR_WHITE,"�س�����㺢Ѻ������ö�硫����ǹ���, ���ͷ�������ö���Ҫվ�����");
                SendClientMessage(playerid, COLOR_YELLOW,"> ʶҹ���ͧ��÷ӧҹ�硫����ʶҹ������ǡѺ��÷�㺢Ѻ��� (Los Santos)");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
				//SetPlayerCheckpoint(playerid, 2104.2502, -1806.3750, 13.5547, 3.5);
				//gPlayerCheckpoint{playerid}=true;
			}
		}
	}
	else {
		Dialog_Show(playerid, DialogNewsEmployment, DIALOG_STYLE_LIST, "��è�ҧ�ҹ��Чҹ���١������", "������\n��ѡ�ҹ��Ҵ���\n��ѡ�ҹ�红��\n��ҧ����ö\n���Ѻö��÷ء", "��ҹ���", "��Ѻ");
	}
	return 1;
}

alias:leavesidejob("lsj", "�͡�ҹ�����");
CMD:leavesidejob(playerid)
{
	if(playerData[playerid][pSideJob] != 0)
	{
	    playerData[playerid][pSideJob]=0;
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س���͡�ҡ�Ҫվ�����㹻Ѩ�غѹ����");
	}
	else return SendClientMessage(playerid, COLOR_LIGHTRED, "�س������Ҫվ�����㹻Ѩ�غѹ");

}

alias:leavejob("lj", "�͡�ҹ��ѡ");
CMD:leavejob(playerid) {
	if(playerData[playerid][pJob])
	{
		if(!IsSideJob(playerData[playerid][pJob])) {
			if(playerData[playerid][pDonateRank])
			{
				if(playerData[playerid][pContractTime])
				{
					playerData[playerid][pJob] = 0;
					playerData[playerid][pContractTime] = 0;
					return SendClientMessage(playerid, COLOR_LIGHTBLUE, "* �س�黯ԺѵԵ���ѭ�� 1 �����������������͡�ҡ�ҹ");
				}
				else return SendClientMessage(playerid, COLOR_LIGHTBLUE, "* �س�ѧ��������ա 1 ����������л�ԺѵԵ���������ش�ѭ�Ңͧ�س");
			}
			else
			{
				if(playerData[playerid][pDonateRank] > 1 && playerData[playerid][pContractTime] >= 1) {
					playerData[playerid][pJob] = 0;
					playerData[playerid][pContractTime] = 0;
					return SendClientMessage(playerid, COLOR_LIGHTBLUE, "* �س�黯ԺѵԵ���ѭ�� 1 �����������������͡�ҡ�ҹ");
				}
				else if(playerData[playerid][pDonateRank] > 1) {
					return SendClientMessage(playerid, COLOR_LIGHTBLUE, "* �س�ѧ��������ա 1 ����������л�ԺѵԵ���������ش�ѭ�Ңͧ�س");
				}

				if(playerData[playerid][pContractTime] >= 4)
				{
					playerData[playerid][pJob] = 0;
					playerData[playerid][pContractTime] = 0;
					return SendClientMessage(playerid, COLOR_LIGHTBLUE, "* �س�黯ԺѵԵ���ѭ�� 4 �����������������͡�ҡ�ҹ");
				}
				else
				{
					return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* �س�ѧ��������ա %d ����������л�ԺѵԵ���������ش�ѭ�Ңͧ�س", 4 - playerData[playerid][pContractTime]);
				}
			}
		} else {
			playerData[playerid][pJob]=0;
			return SendClientMessage(playerid, COLOR_LIGHTBLUE, "   �س���͡�ҡ�ҹ㹻Ѩ�غѹ����");
		}
	}
	else return SendClientMessage(playerid, COLOR_LIGHTRED, "�س����էҹ㹻Ѩ�غѹ");
}

alias:jobswitch("js", "��Ѻ�ҹ");
CMD:jobswitch(playerid)
{
    if(IsSideJob(playerData[playerid][pJob])) {

        if(playerData[playerid][pJob] != JOB_NONE || playerData[playerid][pSideJob] != JOB_NONE)
        {
            new sidejob = playerData[playerid][pSideJob];

            playerData[playerid][pSideJob] = playerData[playerid][pJob];
            playerData[playerid][pJob] = sidejob;

            if(playerData[playerid][pSideJob] == JOB_NONE) SendClientMessage(playerid, COLOR_LIGHTRED, "�Ҫվ��ѡ�ͧ�س�١������Ҫվ�����");
			else if(playerData[playerid][pJob] == JOB_NONE) SendClientMessage(playerid, COLOR_LIGHTRED, "�Ҫվ��ѡ�ͧ�س�١᷹������Ҫվ�����");
		}
        else
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "�س��ͧ�͡�ҡ�ҹ��͹ (/leavejob ���� /leavesidejob)");
        }
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "�س����ö��Ѻ�ҹ���� ���Ѻ�硫��");
	return 1;
}

IsSideJob(jobid)
{
	if(jobid == JOB_NONE || jobid == JOB_TAXI || jobid == JOB_MECHANIC) return 1;
	return 0;
}

alias:jobhelp("��������ͧҹ", "jh");
CMD:jobhelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
	SendClientMessage(playerid, COLOR_GRAD3,"�Ҫվ㹻Ѩ�غѹ�ͧ�س���:");
	SendClientMessageEx(playerid,COLOR_GRAD3,"%s", ReturnJobName(playerData[playerid][pJob]));

	if(playerData[playerid][pSideJob]) {
		SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
		SendClientMessage(playerid, COLOR_GRAD3,"�Ҫվ�����:");
		SendClientMessageEx(playerid,COLOR_GRAD3,"%s", ReturnJobName(playerData[playerid][pSideJob]));
	}

	if(playerData[playerid][pJob] == JOB_MECHANIC || playerData[playerid][pSideJob] == JOB_MECHANIC) {
		if(playerData[playerid][pSideJob] == JOB_MECHANIC) SendClientMessage(playerid,COLOR_LIGHTRED,"����觪�ҧ����ö [�Ҫվ�����]");
		else SendClientMessage(playerid,COLOR_LIGHTRED,"����觪�ҧ����ö:");
		SendClientMessage(playerid,COLOR_WHITE,"/buycomp (������ʴ�) - /checkcomp (����ʴ�) - /service (��ԡ��) - /paintcar (����¹��) - /colorlist (�Ţ��)");
		// SendClientMessage(playerid,COLOR_WHITE,"/colorlist - /attach - /detach");
	}

	if(playerData[playerid][pJob] == JOB_TAXI || playerData[playerid][pSideJob] == JOB_TAXI) {
	    if(playerData[playerid][pSideJob] == JOB_TAXI) SendClientMessage(playerid,COLOR_LIGHTRED,"����觤��Ѻ�硫�� [�Ҫվ�����]");
		else SendClientMessage(playerid,COLOR_LIGHTRED,"����觤��Ѻ�硫��:");
		SendClientMessage(playerid,COLOR_WHITE,"/taxi [accept / duty / fare / start / stop]");
	}

	if(playerData[playerid][pJob] == JOB_FARMER) {
	    SendClientMessage(playerid,COLOR_LIGHTRED,"����觢ͧ������:");
		SendClientMessage(playerid,COLOR_WHITE,"/harvest");
		SendClientMessage(playerid,COLOR_WHITE,"/stopharvest");
		SendClientMessageEx(playerid,COLOR_GRAD1,"���������÷ӧҹ: %d/25 (⺹�� +10 ��ͪ�������ҹ)", playerData[playerid][pContractTime]);
	}
	else if(playerData[playerid][pJob] == JOB_SWEEPER) {
	    SendClientMessage(playerid,COLOR_LIGHTRED,"����觢ͧ��ѡ�ҹ��Ҵ���:");
		SendClientMessage(playerid,COLOR_WHITE,"/sweeper");
		SendClientMessage(playerid,COLOR_WHITE,"/stopsweeper");
		SendClientMessageEx(playerid,COLOR_GRAD1,"���������÷ӧҹ: %d/25 (⺹�� +5 ��ͪ�������ҹ)", playerData[playerid][pContractTime]);
	}
	else if(playerData[playerid][pJob] == JOB_GARBAGE) {
	    SendClientMessage(playerid,COLOR_LIGHTRED,"����觢ͧ��ѡ�ҹ�红��:");
		SendClientMessage(playerid,COLOR_WHITE,"/collect");
		SendClientMessage(playerid,COLOR_WHITE,"/stopgarbage");
		SendClientMessageEx(playerid,COLOR_GRAD1,"���������÷ӧҹ: %d/25 (⺹�� +20 ��ͪ�������ҹ)", playerData[playerid][pContractTime]);
	}
	else if(playerData[playerid][pJob] == JOB_TRUCKER) {
		SendClientMessage(playerid,COLOR_GRAD1,"��ҹ�͡��ú�������:");
		SendClientMessage(playerid,COLOR_GRAD1,"��������ͼ����� -> 䡴����繷ҧ��� -> ��÷ӧҹ Trucker");
		SendClientMessage(playerid,COLOR_GRAD1,"(http://script-wise.in.th/forum)");
		SendClientMessage(playerid,COLOR_GRAD2,"�س���繵�ͧ��ö��к� ö��� ����ö��÷ء㹡�÷ӧҹ���");
		SendClientMessage(playerid, -1, ""EMBED_YELLOW"Commands:"EMBED_WHITE"��"EMBED_YELLOW" /cargo"EMBED_WHITE" ���ʹ���¡�÷������ö����");
		SendClientMessage(playerid, -1, ""EMBED_YELLOW"Commands:"EMBED_WHITE"��"EMBED_YELLOW" /tpda"EMBED_WHITE" �����Դ PDA �ͧö��÷ء������ʴ�������");
		SendClientMessage(playerid, -1, ""EMBED_YELLOW"Commands:"EMBED_WHITE"��"EMBED_YELLOW" /industry"EMBED_WHITE" �����Դ PDA �ͧö��÷ء������ʴ�������");
		if(playerData[playerid][pContractTime]) SendClientMessageEx(playerid, -1,"�س�� %d �������㹡�û�Сͺ�Ҫվ", playerData[playerid][pContractTime]);
		SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
	}

	return 1;
}

alias:pitem("�����");
CMD:pitem(playerid, params[]) {
	SendClientMessage(playerid, COLOR_GREEN, "|_______________������ͧ�س_______________|");
	SendClientMessageEx(playerid, COLOR_LIGHTCYAN, "����: %d ���     ����ѹ��л�ͧ: %d ���", playerData[playerid][pItemOOC], playerData[playerid][pItemGasCan]);
	SendClientMessageEx(playerid, COLOR_LIGHTCYAN, "���ŧ: %s     ���紾ת: %d     ���ô���: %s", (playerData[playerid][pItemCrowbar] ? ("��") : ("�����")), playerData[playerid][pSeedWeed], (playerData[playerid][pWatering] ? ("��") : ("�����")));
	SendClientMessageEx(playerid, COLOR_GRAD1, "/myitems ����觢ͧ�Դ������");
	return 1;
}

alias:licenses("lic", "�");
CMD:licenses(playerid, params[])
{
	new targetid = INVALID_PLAYER_ID;

	if (sscanf(params, "u", targetid)) {
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /licenses [�ʹռ�����/���ͺҧ��ǹ]");
		SendClientMessage(playerid, COLOR_GRAD1, "�����˵�: �������͵�ͧ����ʴ���餹��蹴��͹حҵ�ͧ���");
	}

	if(targetid == playerid || targetid == INVALID_PLAYER_ID) {

		SendClientMessage(playerid, COLOR_GREEN, "______�ѵû�Шӵ�� San Andreas______");
		SendClientMessageEx(playerid, COLOR_WHITE, "���� : %s", ReturnPlayerName(playerid));
		SendClientMessageEx(playerid, COLOR_WHITE, "�͹حҵ�Ѻ���: %s", playerData[playerid][pCarLic] ? ("��ҹ") : ("�ѧ����ҹ"));
		SendClientMessage(playerid, COLOR_GREEN, "_________________________");
		SendNearbyMessage(playerid, 25.0, COLOR_PURPLE, "* %s �ͧ��价��ѵû�Шӵ�Ǣͧ��", ReturnRealName(playerid));
	
		return 1;
	}

	if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������س");

	SendClientMessage(targetid, COLOR_GREEN, "______�ѵû�Шӵ�� San Andreas______");
	SendClientMessageEx(targetid, COLOR_WHITE, "���� : %s", ReturnPlayerName(playerid));
	SendClientMessageEx(targetid, COLOR_WHITE, "�͹حҵ�Ѻ���: %s", playerData[playerid][pCarLic] ? ("��ҹ") : ("�ѧ����ҹ"));
	SendClientMessage(targetid, COLOR_GREEN, "_________________________");
	SendNearbyMessage(playerid, 25.0, COLOR_PURPLE, "* %s ����蹺ѵû�Шӵ�Ǣͧ�����Ѻ %s", ReturnRealName(playerid), ReturnRealName(targetid));
	return 1;
}

alias:togooc("�Դ�����š");
CMD:togooc(playerid,params[])
{
	if(!BitFlag_Get(gPlayerBitFlag[playerid], TOGGLE_OOC))
	{
		BitFlag_On(gPlayerBitFlag[playerid], TOGGLE_OOC);
 		SendClientMessage(playerid,COLOR_GREEN,"�Դ����к�᪷ Global OOC");
	}
	else
	{
		BitFlag_Off(gPlayerBitFlag[playerid], TOGGLE_OOC);
		SendClientMessage(playerid,COLOR_GREEN,"¡��ԡ��ú��͡�к�᪷ Global OOC ����");
	}
	return 1;
}

CMD:toghud(playerid,params[])
{
	if(!BitFlag_Get(gPlayerBitFlag[playerid], TOGGLE_HUD))
	{
		BitFlag_On(gPlayerBitFlag[playerid], TOGGLE_HUD);
 		SendClientMessage(playerid,COLOR_GREEN,"�Դ����к� HUD");
	}
	else
	{
		BitFlag_Off(gPlayerBitFlag[playerid], TOGGLE_HUD);
		SendClientMessage(playerid,COLOR_GREEN,"¡��ԡ��ú��͡�к� HUD");
	}
	return 1;
}

alias:spawnchange("sc");
CMD:spawnchange(playerid, params[]) {

	new type, tmp2[16];
	if(sscanf(params,"dS()[16]",type, tmp2)) {
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /spawnchange [������͡]");
		SendClientMessage(playerid, COLOR_GRAD1, "������͡: 0 - �ش�Դ�������, 1 - ῤ���, 2 - ��ҹ, 3 - �ش����ش����͡��");
		return 1;
	}

	if(type == 0)
 	{
 		SendClientMessage(playerid, COLOR_GRAD1, " �ش�Դ�ͧ�س�١����¹��: �ش�Դ�������");
 		playerData[playerid][pSpawnType] = SPAWN_TYPE_DEFAULT;
	}
	else if(type == 1)
	{
		if(playerData[playerid][pFaction] != 0) {
			SendClientMessage(playerid, COLOR_GRAD1, " �ش�Դ�ͧ�س�١����¹��: ῤ���");
			playerData[playerid][pSpawnType] = SPAWN_TYPE_FACTION;
		} else SendClientMessage(playerid, COLOR_GREY, "�س�������ǹ˹�觢ͧῤ���� �");
		return 1;
	}
	else if(type == 2)
	{
		new houseid;

		if(sscanf(tmp2,"d", houseid)) {

			new hcount;

			SendClientMessage(playerid, COLOR_YELLOW, "|_______________��ҹ�ͧ�س_______________|");

			foreach(new i : Iter_House)
			{
				if(houseData[i][hOwned] == 1 && ((playerData[playerid][pHouseKey] == houseData[i][hID]) || isequal(houseData[i][hOwner], ReturnPlayerName(playerid))))
				{
				    SendClientMessageEx(playerid, COLOR_GRAD2, "#%d: %s", i, houseData[i][hAddress]);
		      		hcount++;
				}
			}

			if(hcount) {
				SendClientMessage(playerid, COLOR_GRAD1, "�����: /spawnchange 2 [�ʹպ�ҹ]");
			}
			else {
			    SendClientMessage(playerid, COLOR_GREY, "�س����պ�ҹ");
			}
			return 1;
		}

		if(Iter_Contains(Iter_House, houseid)) {
			if(houseData[houseid][hOwned] == 1 && ((playerData[playerid][pHouseKey] == houseData[houseid][hID]) || isequal(houseData[houseid][hOwner], ReturnPlayerName(playerid))))
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "�س������¹�ŧ�ش�Դ: ��ҹ #%d", houseid);
				playerData[playerid][pSpawnType] = SPAWN_TYPE_PROPERTY;
				playerData[playerid][pHouseKey] = houseData[houseid][hID];
			}
			else SendClientMessage(playerid, COLOR_GREY, "�س����պ�ҹ");
		}
	}
	if(type == 3)
 	{
 		SendClientMessage(playerid, COLOR_GRAD1, " �ش�Դ�ͧ�س�١����¹��: �ش����ش���س�͡��");
 		playerData[playerid][pSpawnType] = SPAWN_TYPE_LASTPOS;
	}
	else {
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /spawnchange [������͡]");
		SendClientMessage(playerid, COLOR_GRAD1, "������͡: 0 - ������, 1 - ῤ���, 2 - ��ҹ, 3 - �ش����ش����͡��");
	}
	return 1;
}

/*CMD:sethouse(playerid, params[])
{
	new
		amount;

	if (sscanf(params, "d", amount))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /sethouse [�ʹպ�ҹ�ͧ�س] (���ʹպ�ҹ��ҡ����� /sc)");

	if (playerData[playerid][pHouseKey] != amount)
		return SendClientMessage(playerid, COLOR_GRAD1, "�س���������ʹպ�ҹ�ͧ�س !");

	SendClientMessageEx(playerid, COLOR_YELLOW, "�س������¹�ŧ�ش�Դ: ��ҹ #%d", amount);
	playerData[playerid][pSpawnType] = SPAWN_TYPE_PROPERTY;
	playerData[playerid][pHouseKey] = houseData[amount][hID];

	return 1;
}*/

CMD:inv(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_LIGHTRED, "- My Inventory -");
	SendClientMessageEx(playerid, COLOR_WHITE, "�ӹǹ���ǡ��ͧ㹵�Ǥس : [%d]", playerData[playerid][pPizza]);
	SendClientMessageEx(playerid, COLOR_WHITE, "�ӹǹ�����㹵�Ǥس : [%d]", playerData[playerid][pDrink]);
	SendClientMessageEx(playerid, COLOR_YELLOW, "�س����ö�Ѻ��зҹ����÷��س�����Ҵ��¡�þ�������� /eatfood");
	SendClientMessageEx(playerid, COLOR_YELLOW, "�س����ô�����ӷ��س�����Ҵ��¡�þ�������� /drinkwater");
	SendClientMessageEx(playerid, COLOR_LIGHTRED, "__________________");
	
	
	return 1;
}

CMD:eatfood(playerid, params[])
{
	if (playerData[playerid][pPizza] <= 0)
		return SendClientMessage(playerid , COLOR_GRAD2, "�س�������������㹵�Ǣͧ�س");
	
	if (playerData[playerid][pHungry] >= 70)
		return SendClientMessage(playerid, COLOR_GRAD2, "�س�ѧ�����ǵ͹���");

	playerData[playerid][pHungry] += 30;
	playerData[playerid][pPizza] -= 1;

	SendClientMessageEx(playerid, COLOR_YELLOW, "�س��ӡ���Ѻ��зҹ����÷��س����, �����س���Ѻ��Ҿ�ѧ�ҹ���� +30");
	return 1;
}

CMD:drinkwater(playerid, params[])
{
	if (playerData[playerid][pDrink] <= 0)
		return SendClientMessage(playerid , COLOR_GRAD2, "�س����չ�Ӵ������㹵�Ǣͧ�س");
	
	if (playerData[playerid][pThirst] >= 70)
		return SendClientMessage(playerid, COLOR_GRAD2, "�س�ѧ�������¹�ӵ͹���");

	playerData[playerid][pThirst] += 30;
	playerData[playerid][pDrink] -= 1;	

	SendClientMessageEx(playerid, COLOR_YELLOW, "�س��ӡ�ô�������顷��س����, �����س���Ѻ��Ҿ�ѧ�ҹ���� +30");
	return 1;
}

CMD:stats(playerid, params[])
{
	ShowStats(playerid,playerid);
	return 1;
}

ShowStats(playerid,targetid)
{
	new string[256];
	format(string, sizeof string, "|____________________%s [%s]____________________|", ReturnRealName(targetid), ReturnDateTime());
	SendClientMessage(playerid, COLOR_GREEN,   string);
	new factionid = Faction_GetID(playerData[targetid][pFaction]);
	new Float:health;
	GetPlayerHealth(playerid, health);

	new nxtlevel = playerData[playerid][pLevel]+1;
	// new costlevel = nxtlevel*45000;//10k for testing purposes
	new expamount = nxtlevel*MULTIPLE_EXP;

	SendClientMessageEx(playerid, COLOR_LIGHTCYAN, "| ����Ф� | �����:[%d][%s] ���˹�:[%s] �Ҫվ:[%s] �������Ѿ��:[%d]", playerData[targetid][pFaction], Faction_GetName(factionid), Faction_GetRankName(factionid, playerData[targetid][pFactionRank]), ReturnJobName(playerData[targetid][pJob], playerData[targetid][pJobRank]), playerData[targetid][pPnumber]);
	SendClientMessageEx(playerid, COLOR_LIGHTCYAN2,"| ����� | ����ż�����:[%d] ���ʺ��ó�:[%d/%d] �дѺ��ԨҤ:[%s]", playerData[targetid][pLevel], playerData[targetid][pExp], expamount, Donate_GetName(playerData[targetid][pDonateRank]));

	SendClientMessageEx(playerid, COLOR_LIGHTCYAN, "| ���ظ | ���ظ��ѡ:[%s] ����ع:[%d] ���ظ�ͧ:[%s] ����ع:[%d]",
	(!playerData[targetid][pGun2] && playerData[targetid][pGun3]) ? ReturnWeaponName(playerData[targetid][pGun3]) : ReturnWeaponName(playerData[targetid][pGun2]),
	(!playerData[targetid][pGun2] && playerData[targetid][pGun3]) ? playerData[targetid][pAmmo3] : playerData[targetid][pAmmo2],
	(!playerData[targetid][pGun2] && playerData[targetid][pGun3]) ? ("�����") : ReturnWeaponName(playerData[targetid][pGun3]),
	(!playerData[targetid][pGun2] && playerData[targetid][pGun3]) ? 0 : playerData[targetid][pAmmo3]);

	SendClientMessageEx(playerid, COLOR_LIGHTCYAN2, "| �ѡ�� | ���ʹ:[%.1f/%.1f] �س�Ҿ:[%.0f] �����������͹�Ź�:[%d]", health, 100.0 + playerData[targetid][pSHealth], playerData[targetid][pSHealth], playerData[targetid][pPlayingHours]);
	SendClientMessageEx(playerid, COLOR_LIGHTCYAN,"| �Թ | �Թʴ:[%s] �Թ㹸�Ҥ��:[%s] �ѭ�������Ѿ��:[%s] �Թ��Ҩ�ҧ:[%s]", FormatNumber(GetPlayerMoneyEx(targetid)), FormatNumber(playerData[targetid][pAccount]), FormatNumber(playerData[targetid][pSavingsCollect]), FormatNumber(playerData[targetid][pPayCheck]));
	SendClientMessageEx(playerid, COLOR_LIGHTCYAN2, "| ��� � | �ح��ҹ��˹�:[%s] ���ӧҹ:[%s] �Ҫվ�����:[%s] ��ṹ:[%d]", (playerData[targetid][pPCarkey] == -1 ? ("�����") : sprintf("%d", playerCarData[playerData[targetid][pPCarkey]][carVehicle])), "�����", ReturnJobName(playerData[targetid][pSideJob]), playerData[targetid][pScore]);
	SendClientMessageEx(playerid, COLOR_LIGHTCYAN,"| �Է�� | Channel:[%d] Slot:[%d] �Է��:[%s] ��͡:[%d]", playerData[targetid][pRChannel], playerData[targetid][pRSlot], (playerData[targetid][pRadio]) ? ("��") : ("�����"), playerData[targetid][pTie]);
	SendClientMessageEx(playerid, COLOR_LIGHTCYAN2, "| ��Ҿ�ѧ�ҹ | �������:[%d] ���������¹��:[%d]", playerData[targetid][pHungry], playerData[targetid][pThirst]);
	
	SendClientMessageEx(playerid, COLOR_GRAD1, "�������: /perks, (/lic)enses");

	SendClientMessage(playerid, COLOR_GREEN, string);
}

CMD:perks(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_GRAD1, "��������ö�����: "EMBED_YELLOW"/upgrade"EMBED_GRAD1" (����Ѿ�ô㹻Ѩ�غѹ %d)", playerData[playerid][pPUpgrade]);
	SendClientMessageEx(playerid, COLOR_GRAD1, "- �س�Ҿ +%.0f", playerData[playerid][pSHealth]);
	SendClientMessageEx(playerid, COLOR_GRAD1, "- ���Ǣ��������纻Ǵ ����� %d", playerData[playerid][pRespawnPerks]);
	SendClientMessageEx(playerid, COLOR_GRAD1, "- �Ŵ��͡�մ�ӡѴ��˹� +%d �ѹ", playerData[playerid][pVehiclePerks]);
	SendClientMessageEx(playerid, COLOR_GRAD1, "- ��������ͻ�Ҥس�Ҿ ����� %d", playerData[playerid][pFishingPerks]);
	return 1;
}

CMD:buylevel(playerid, params[])
{
	if(playerData[playerid][pLevel])
	{
		new nxtlevel = playerData[playerid][pLevel]+1;
		new costlevel = nxtlevel*4500;//10k for testing purposes
		new expamount = nxtlevel*MULTIPLE_EXP, confirm[8];

		if (sscanf(params, "s[8]", confirm)) {
	 	    SendClientMessage(playerid, COLOR_GRAD1, "�����: /buylevel yes");
			SendClientMessageEx(playerid, COLOR_GREY, "����ŷ��س���ѧ�����Ҥ� $%d", costlevel);
			return 1;
		}

		if(isequal(confirm, "yes")) {
			if(playerData[playerid][pCash] < costlevel)
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "   �س���Թ���� ($%d) !",costlevel);
				return 1;
			}
			else if (playerData[playerid][pExp] < expamount)
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "   �س��ͧ�դ���Ѿ�ô %d Point ��㹻Ѩ�غѹ�س����§ [%d] !",expamount,playerData[playerid][pExp]);
				return 1;
			}
			else
			{
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				PlayerPlayMusic(playerid);
				playerData[playerid][pCash] -= costlevel;
				playerData[playerid][pLevel]++;
				SetPlayerScore(playerid, playerData[playerid][pLevel]);
				if(playerData[playerid][pDonateRank] > 0)
				{
					playerData[playerid][pExp] -= expamount;
					new total = playerData[playerid][pExp];
					if(total > 0)
					{
						playerData[playerid][pExp] = total;
					}
					else
					{
						playerData[playerid][pExp] = 0;
					}
				}
				else
				{
					playerData[playerid][pExp] = 0;
				}
				playerData[playerid][pPUpgrade] = playerData[playerid][pPUpgrade]+2;
				GameTextForPlayer(playerid, sprintf("~g~LEVEL UP~n~~w~You Are Now Level %d", nxtlevel), 5000, 1);
				SendClientMessageEx(playerid, COLOR_GRAD1, "   �س��������� %d ��Ҥ� ($%d) �� /upgrade", nxtlevel, costlevel);
				SendClientMessageEx(playerid, COLOR_GRAD2, "   �س�դ���Ѿ�ô���� %d �ش (����� /upgrade �����Ѿ�ô)",playerData[playerid][pPUpgrade]);
			}
		}
		else {
			SendClientMessage(playerid, COLOR_GRAD1, "�����: /buylevel yes");
			SendClientMessageEx(playerid, COLOR_GREY, "����ŷ��س���ѧ�����Ҥ� $%d", costlevel);
		}
	}
	return 1;
}

CMD:upgrade(playerid, params[]) {
	new options[64];
	if (sscanf(params, "s[64]", options)) {
	    SendClientMessage(playerid, COLOR_WHITE,"*** UPGRADES ***");
		SendClientMessageEx(playerid, COLOR_GRAD1, "�����: /upgrade [�����Ѿ�ô] (�س�դ���Ѿ�ô���� %d �ش)",playerData[playerid][pPUpgrade]);
		SendClientMessage(playerid, COLOR_GRAD2, "����� 1-5: ���Ǣ��������纻Ǵ, ��������ͻ�Ҥس�Ҿ (-1 �ش)");
		SendClientMessage(playerid, COLOR_GRAD2, "����� 10,15,20,25,30: �Ŵ��͡�մ�ӡѴ��˹� (-5 �ش)");
		SendClientMessage(playerid, COLOR_GRAD2, "�ء�����: �س�Ҿ (-1 �ش)");
		SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
		return 1;
	}
	if (isequal(options, "�س�Ҿ"))
	{
		if (playerData[playerid][pPUpgrade] > 1)
		{
			if (playerData[playerid][pSHealth] < 50)
			{
				playerData[playerid][pSHealth] = playerData[playerid][pSHealth]+5.0;
				SendClientMessageEx(playerid, COLOR_GRAD6, "�Ѿ�ô����: �س���Դ�������ʹ %.2f (+5)",playerData[playerid][pSHealth]+50);
				playerData[playerid][pPUpgrade]--;
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD6, "   �س�����ʹ�͹�Դ�٧�ش����");
				return 1;
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GRAD6, "   �س�դ���Ѿ�ô 0 �ش");
			return 1;
		}
	}
	else if (isequal(options, "���Ǣ��������纻Ǵ"))
	{
		if (playerData[playerid][pPUpgrade] > 1)
		{
			if (playerData[playerid][pRespawnPerks] < 5)
			{
				if (playerData[playerid][pRespawnPerks] < playerData[playerid][pLevel]) {
					playerData[playerid][pRespawnPerks]++;
					SendClientMessageEx(playerid, COLOR_GRAD6, "�Ѿ�ôʶҹо��������: ���Ǣ��������纻Ǵ �ͧ�س����� %d ����", playerData[playerid][pRespawnPerks]);
					playerData[playerid][pPUpgrade]--;
					GameTextForPlayer(playerid, "~g~New Perk Upgraded", 5000, 1);
					return 1;
				}
				else {
					SendClientMessage(playerid, COLOR_GRAD6, "   ����Ţͧ�س�ѧ����٧�ͷ����Ѿ�ôʶҹо���ɹ�� !");
					return 1;
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD6, "   �س������� ���Ǣ��������纻Ǵ ������� !");
				return 1;
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GRAD6, "   �س�դ���Ѿ�ô 0 �ش");
			return 1;
		}
	}
	else if (isequal(options, "��������ͻ�Ҥس�Ҿ"))
	{
		if (playerData[playerid][pPUpgrade] > 1)
		{
			if (playerData[playerid][pFishingPerks] < 5)
			{
				if (playerData[playerid][pFishingPerks] < playerData[playerid][pLevel]) {
					playerData[playerid][pFishingPerks]++;
					SendClientMessageEx(playerid, COLOR_GRAD6, "�Ѿ�ôʶҹо��������: ��������ͻ�Ҥس�Ҿ �ͧ�س����� %d ����", playerData[playerid][pFishingPerks]);
					playerData[playerid][pPUpgrade]--;
					GameTextForPlayer(playerid, "~g~New Perk Upgraded", 5000, 1);
					return 1;
				}
				else {
					SendClientMessage(playerid, COLOR_GRAD6, "   ����Ţͧ�س�ѧ����٧�ͷ����Ѿ�ôʶҹо���ɹ�� !");
					return 1;
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD6, "   �س������� ��������ͻ�Ҥس�Ҿ ������� !");
				return 1;
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GRAD6, "   �س�դ���Ѿ�ô 0 �ش");
			return 1;
		}
	}
	else if (isequal(options, "�Ŵ��͡�մ�ӡѴ��˹�"))
	{
		if (playerData[playerid][pPUpgrade] > 4)
		{
			if (playerData[playerid][pVehiclePerks] < 5)
			{
				/*(playerData[playerid][pVehiclePerks] == 0 && playerData[playerid][pLevel] >= 10) ||
				(playerData[playerid][pVehiclePerks] == 1 && playerData[playerid][pLevel] >= 15) ||
				(playerData[playerid][pVehiclePerks] == 2 && playerData[playerid][pLevel] >= 20) ||
				(playerData[playerid][pVehiclePerks] == 3 && playerData[playerid][pLevel] >= 25) ||
				(playerData[playerid][pVehiclePerks] == 4 && playerData[playerid][pLevel] >= 30)*/

				if (playerData[playerid][pLevel] >= (playerData[playerid][pVehiclePerks] * 5) + 10) {
					playerData[playerid][pVehiclePerks] += 1;
					SendClientMessageEx(playerid, COLOR_GRAD6, "�Ѿ�ôʶҹо��������: �Ŵ��͡�մ�ӡѴ��˹� �ͧ�س����� %d ����", playerData[playerid][pVehiclePerks]);
					playerData[playerid][pPUpgrade]-= 5;
					GameTextForPlayer(playerid, "~g~New Perk Upgraded", 5000, 1);
					return 1;
				}
				else {
					SendClientMessage(playerid, COLOR_GRAD6, "   ����Ţͧ�س�ѧ����٧�ͷ����Ѿ�ôʶҹо���ɹ�� !");
					return 1;
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD6, "   �س������� ���Ǣ��������纻Ǵ ������� !");
				return 1;
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GRAD6, "   �س�դ���Ѿ�ô���� (�� 5 �ش)");
			return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD6, "   ����Ѿ�ô���������ѡ");
		return 1;
	}
	return 1;
}

CMD:pay(playerid, params[])
{
	new
	    targetid, 
		amount,
		str[128];

	if (sscanf(params, "ud", targetid, amount))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /pay [�ʹռ�����/���ͺҧ��ǹ] [�ӹǹ]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������س");

	if (targetid == playerid)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö����Թ����ͧ��");

	if (amount < 1)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �ô�кبӹǹ����ҡ���� 1 ������");

	if (amount > 5 && playerData[playerid][pPlayingHours] < 2)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö�������ҡ���� $5 㹢�з�������������蹵�ӡ��� 2 �������");

	if (amount > GetPlayerMoney(playerid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��������Թ�ҡ��Ҵ���");

	if (amount >= 100000)
	{
		format(str, sizeof(str), "AdmWarn: %s (%d) ���ͺ�Թ��� %s (%d) �繨ӹǹ %d", ReturnRealName(playerid), playerid, ReturnRealName(targetid), targetid, amount);
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, str);
	}

	GivePlayerMoneyEx(playerid, -amount);
	GivePlayerMoneyEx(targetid, amount);

	SendClientMessageEx(playerid, COLOR_GRAD1, "   �س������Թ %d �Ѻ %s", amount, ReturnRealName(targetid));
	SendClientMessageEx(targetid, COLOR_GRAD1, "   �س���Ѻ�Թ %d �ҡ %s", amount, ReturnRealName(playerid));

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s ��ѡ�Թ�͡�Һҧ��ǹ������������ͧ͢ %s", ReturnRealName(playerid), ReturnRealName(targetid));

	Log(transferlog, INFO, "%s ����Թ���Ѻ %s �ӹǹ %d", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount);
	
	return 1;
}

CMD:rpay(playerid, params[])
{
	new
	    targetid, 
		amount,
		str[128];

	if (sscanf(params, "ud", targetid, amount))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /rpay [�ʹռ�����/���ͺҧ��ǹ] [�ӹǹ]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������س");

	if (targetid == playerid)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö����Թ����ͧ��");

	if (amount < 1)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �ô�кبӹǹ����ҡ���� 1 ������");

	if (amount > 5 && playerData[playerid][pPlayingHours] < 2)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö�������ҡ���� $5 㹢�з�������������蹵�ӡ��� 2 �������");

	if (amount > playerData[playerid][pRMoney])
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��������Թ�ҡ��Ҵ���");

	if (amount >= 100000)
	{
		format(str, sizeof(str), "AdmWarn: %s (%d) ���ͺ�Թᴧ��� %s (%d) �繨ӹǹ %d", ReturnRealName(playerid), playerid, ReturnRealName(targetid), targetid, amount);
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, str);
	}

	playerData[playerid][pRMoney] -= amount;
	playerData[targetid][pRMoney] += amount;

	SendClientMessageEx(playerid, COLOR_GRAD1, "   �س������Թᴧ %d �Ѻ %s", amount, ReturnRealName(targetid));
	SendClientMessageEx(targetid, COLOR_GRAD1, "   �س���Ѻ�Թᴧ %d �ҡ %s", amount, ReturnRealName(playerid));

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s ��ѡ�Թᴧ�͡�Һҧ��ǹ������������ͧ͢ %s", ReturnRealName(playerid), ReturnRealName(targetid));

	Log(transferlog, INFO, "%s ����Թᴧ���Ѻ %s �ӹǹ %d", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount);
	
	return 1;
}

CMD:givescore(playerid, params[])
{
	new
	    targetid, 
		amount,
		str[128];

	if (sscanf(params, "ud", targetid, amount))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /givescore [�ʹռ�����/���ͺҧ��ǹ] [�ӹǹ]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������س");

	if (targetid == playerid)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö��� Score ����ͧ��");

	if (amount < 1)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �ô�кبӹǹ����ҡ���� 1 Score");

	if (amount > playerData[playerid][pScore])
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س������� Score �ҡ��Ҵ���");

	if (amount > 50)
	{
		format(str, sizeof(str), "AdmWarn: %s (%d) ���ͺ Score ��� %s (%d) �繨ӹǹ %d", ReturnRealName(playerid), playerid, ReturnRealName(targetid), targetid, amount);
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, str);
	}

	playerData[playerid][pScore] -= amount;
	playerData[targetid][pScore] += amount;

	SendClientMessageEx(playerid, COLOR_GRAD1, "   �س����� Score %d �Ѻ %s", amount, ReturnRealName(targetid));
	SendClientMessageEx(targetid, COLOR_GRAD1, "   �س���Ѻ Score %d �ҡ %s", amount, ReturnRealName(playerid));

	//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s ��ѡ Point �͡�Һҧ��ǹ������������ͧ͢ %s", ReturnRealName(playerid), ReturnRealName(targetid));
	Log(transferlog, INFO, "%s ��� Score ���Ѻ %s �ӹǹ %d", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount);
	
	return 1;
}

CMD:givepoint(playerid, params[])
{
	new
	    targetid, 
		amount,
		str[128];

	if (sscanf(params, "ud", targetid, amount))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /givepoint [�ʹռ�����/���ͺҧ��ǹ] [�ӹǹ]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������س");

	if (targetid == playerid)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö��� Point ����ͧ��");

	if (amount < 1)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �ô�кبӹǹ����ҡ���� 1 Point");

	if (amount > playerData[playerid][pPoint])
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س������� Point �ҡ��Ҵ���");

	if (amount > 100)
	{
		format(str, sizeof(str), "AdmWarn: %s (%d) ���ͺ Point ��� %s (%d) �繨ӹǹ %d", ReturnRealName(playerid), playerid, ReturnRealName(targetid), targetid, amount);
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, str);
	}

	playerData[playerid][pPoint] -= amount;
	playerData[targetid][pPoint] += amount;

	SendClientMessageEx(playerid, COLOR_GRAD1, "   �س����� Point %d �Ѻ %s", amount, ReturnRealName(targetid));
	SendClientMessageEx(targetid, COLOR_GRAD1, "   �س���Ѻ Point %d �ҡ %s", amount, ReturnRealName(playerid));

	//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s ��ѡ Point �͡�Һҧ��ǹ������������ͧ͢ %s", ReturnRealName(playerid), ReturnRealName(targetid));
	Log(transferlog, INFO, "%s ��� Point ���Ѻ %s �ӹǹ %d", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount);
	
	return 1;
}

// Copy from LS:RP

CMD:coin(playerid, params[])
{
	new str[128];
	format(str, sizeof(str), "** %s ��ԡ����­ŧ�������ѹ�͡%s", ReturnRealName(playerid), (random(2)) ? ("���") : ("����"));
    SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, str);
	return 1;
}

CMD:dice(playerid, params[])
{
	new str[128];
	format(str, sizeof(str), "** %s ����١�������ѹ�͡ %d", ReturnRealName(playerid), random(6)+1);
    SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, str);
	return 1;
}

CMD:rnumber(playerid, params[])
{
	new
	    rmin,
	    rmax,
		emote[128],
		str[128];

	if (sscanf(params, "dds[128]", rmin, rmax, emote))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /rnumber [min] [max] [��á�з�]");

	if(rmin >= rmax) {
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "����Ţ����ش��ͧ���¡��ҵ���Ţ�٧�ش");
	}

	format(str, sizeof(str), "** %s %s %d (( %d �֧ %d ))", ReturnRealName(playerid), emote, randomEx(rmin, rmax), rmin, rmax);
    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, str);
	return 1;
}

CMD:b(playerid, params[])
{
	new str[128];

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /b [��ͤ���]");

	if (strlen(params) > 80) {

		format(str, sizeof(str), "(( [%d] %s: %.80s ))", playerid, ReturnRealName(playerid), params);
        ProxDetectorOOC(playerid, 20.0, str);

	    format(str, sizeof(str), "... %s", params[80]);
        ProxDetectorOOC(playerid, 20.0, str);
	}
	else {

		format(str, sizeof(str), "(( [%d] %s: %s ))", playerid, ReturnRealName(playerid), params);
		ProxDetectorOOC(playerid, 20.0, str);
	}
	return 1;
}

CMD:ass(playerid, params[])
{
	if (playerData[playerid][pAdmin] < 1)
		return SendClientMessage(playerid, COLOR_GRAD1, "�س�����������к�");

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /(as)administrator [��ͤ���]");

	if (strlen(params) > 80) {
	    if(playerData[playerid][pAdmin]) {
			SendOOCMessage(COLOR_GRAD1, "(( [{FF8300}Administrator{B4B5B7}] {%06x}%s"EMBED_GRAD1"(%d): %.80s ))", GetPlayerColor(playerid) >>> 8, playerData[playerid][pAdminName], playerid, params);
			SendOOCMessage(COLOR_GRAD1, "... %s", params[80]);
		}
	}
	else {
	    if(playerData[playerid][pAdmin]) {
			SendOOCMessage(COLOR_GRAD1, "(( [{FF8300}Administrator{B4B5B7}] {%06x}%s"EMBED_GRAD1"(%d): %s ))", GetPlayerColor(playerid) >>> 8, playerData[playerid][pAdminName], playerid, params);
		}
	}

	return 1;
}


alias:administrator("as");
CMD:administrator(playerid, params[])
{
	if (playerData[playerid][pAdmin] < 1)
		return SendClientMessage(playerid, COLOR_GRAD1, "�س�����������к�");

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /(as)administrator [��ͤ���]");

	if (strlen(params) > 80) {
	    if(playerData[playerid][pAdmin]) {
			SendOOCMessage(COLOR_GRAD1, "(( [{FF8300}Administrator{B4B5B7}] {%06x}%s"EMBED_GRAD1"(%d): %.80s ))", GetPlayerColor(playerid) >>> 8, ReturnPlayerName(playerid), playerid, params);
			SendOOCMessage(COLOR_GRAD1, "... %s", params[80]);
		}
	}
	else {
	    if(playerData[playerid][pAdmin]) {
			SendOOCMessage(COLOR_GRAD1, "(( [{FF8300}Administrator{B4B5B7}] {%06x}%s"EMBED_GRAD1"(%d): %s ))", GetPlayerColor(playerid) >>> 8, ReturnPlayerName(playerid), playerid, params);
		} 
	}

	return 1;
}

alias:ooc("o");
CMD:ooc(playerid, params[])
{
    if(systemVariables[OOCStatus] == 1 && !playerData[playerid][pAdmin])
		return SendClientMessage(playerid, COLOR_GREY, "��ͧ�ҧ᪷ OOC �١�Դ㹻Ѩ�غѹ");

	if(playerData[playerid][pItemOOC] <= 0 && !playerData[playerid][pAdmin])
		return SendClientMessage(playerid, COLOR_GRAD1, "�س���������!");

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /(o)oc [��ͤ���]");

	if (strlen(params) > 80) {
	    if(playerData[playerid][pAdmin]) {
			SendOOCMessage(COLOR_GRAD1, "(( [{ED3CCA}�����š{B4B5B7}] {%06x}%s"EMBED_GRAD1"(%d): %.80s ))", GetPlayerColor(playerid) >>> 8, ReturnPlayerName(playerid), playerid, params);
			SendOOCMessage(COLOR_GRAD1, "... %s", params[80]);
		}
	    else if(playerData[playerid][pDonateRank]) {
			SendOOCMessage(COLOR_GRAD1, "(( [�����š] {7535FF}%s{B4B5B7} {%06x}%s"EMBED_GRAD1"(%d): %.80s ))", Donate_GetName(playerData[playerid][pDonateRank]), GetPlayerColor(playerid) >>> 8, ReturnPlayerName(playerid), playerid, params);
			SendOOCMessage(COLOR_GRAD1, "... %s", params[80]);
		}
		else {
			SendOOCMessage(COLOR_GRAD1, "(( [�����š] %s(%d): %.80s ))", ReturnPlayerName(playerid), playerid, params);
			SendOOCMessage(COLOR_GRAD1, "... %s", params[80]);
		}
	}
	else {
	    if(playerData[playerid][pAdmin]) {
			SendOOCMessage(COLOR_GRAD1, "(( [{ED3CCA}�����š{B4B5B7}] {%06x}%s"EMBED_GRAD1"(%d): %s ))", GetPlayerColor(playerid) >>> 8, ReturnPlayerName(playerid), playerid, params);
		} 
	    else if(playerData[playerid][pDonateRank]) {
			SendOOCMessage(COLOR_GRAD1, "(( [�����š] {7535FF}%s{B4B5B7} {%06x}%s"EMBED_GRAD1"(%d): %s ))", Donate_GetName(playerData[playerid][pDonateRank]), GetPlayerColor(playerid) >>> 8, ReturnPlayerName(playerid), playerid, params);
		}
		else SendOOCMessage(COLOR_GRAD1, "(( [�����š] %s(%d): %s ))", ReturnPlayerName(playerid), playerid, params);
	}

	if (!playerData[playerid][pAdmin]) 
		playerData[playerid][pItemOOC]--;

	return 1;
}

alias:newbie("n");
CMD:newbie(playerid, params[]) {

	new szMessage[128];

	if(HasCooldown(playerid,COOLDOWN_NEWBIE))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "��ͧ�ҧ Newbie OOC ���� 60 �Թҷ�/����");

	if(playerData[playerid][pNMuted] == 1)
		return SendClientMessage(playerid, COLOR_LIGHTRED, "�س������Ѻ͹حҵ������ͧ�ҧʹ��� Newbie ���Ǥ���");

	if(!isnull(params)) {

		if(playerData[playerid][pAdmin] >= 1) {
			format(szMessage, sizeof(szMessage), "** (��ͧ�ҧ����ͺ���) �������к� %s : %s", playerData[playerid][pAdminName], params);
		}
		else if (playerData[playerid][pHelper] >= 1)
		{
			format(szMessage, sizeof(szMessage), "** (��ͧ�ҧ����ͺ���) Helper %s : %s", ReturnPlayerName(playerid), params);
		}
		else if(playerData[playerid][pPlayingHours] >= 50) {
			format(szMessage, sizeof(szMessage), "** (��ͧ�ҧ����ͺ���) ������ %s (%d): %s", ReturnPlayerName(playerid), playerid , params);
			SetCooldown(playerid,COOLDOWN_NEWBIE, 60);
		}
		else {
			format(szMessage, sizeof(szMessage), "** (��ͧ�ҧ����ͺ���) ���������� %s (%d): %s", ReturnPlayerName(playerid), playerid, params);
			SetCooldown(playerid,COOLDOWN_NEWBIE, 60);
		}
		foreach (new x : Player) 
		{
			if(playerData[x][pNewbieEnabled] == 1) {
				SendClientMessage(x, COLOR_LIGHTBLUE, szMessage);
			}
		}
	}
	else {
	    return SendClientMessage(playerid, COLOR_GREY, "�����: /(n)ewbie [�Ӷ��]");
	}
	return 1;
}

CMD:tognewbie(playerid, params[]) 
{
	if(playerData[playerid][pNewbieEnabled] == 1) {
	    playerData[playerid][pNewbieEnabled] = 0;
	    SendClientMessage(playerid, COLOR_WHITE, "�س��ӡ�ûԴ����ͧ��繪�ͧ�ҧʹ��� Newbie");
	}
	else {
	    playerData[playerid][pNewbieEnabled] = 1;
	    SendClientMessage(playerid, COLOR_WHITE, "�س��ӡ���Դ����ͧ��繪�ͧ�ҧʹ��� Newbie");
	}
	return 1;
}

CMD:walk(playerid, params[])
{
	new styleID;

	if(sscanf(params, "i", styleID)) {
	    //format(szMessage, sizeof(szMessage), SYNTAX_MESSAGE"/walkstyle (0-%i)", sizeof(walkAnimations));
	    return SendClientMessage(playerid, COLOR_GREY, "�����: /walk (1-18)");
	}

	switch(styleID)
	{
		case 1: ApplyAnimation(playerid,"PED","WALK_gang1",4.1,1,1,1,1,1);
		case 2: ApplyAnimation(playerid,"PED","WOMAN_walksexy",4.1,1,1,1,1,1);
		case 3: ApplyAnimation(playerid,"PED","WALK_armed",4.1,1,1,1,1,1);
		case 4: ApplyAnimation(playerid,"PED","WALK_civi",4.1,1,1,1,1,1);
		case 5: ApplyAnimation(playerid,"PED","WALK_csaw",4.1,1,1,1,1,1);
		case 6: ApplyAnimation(playerid,"PED","WALK_gang2",4.1,1,1,1,1,1);
		case 7: ApplyAnimation(playerid,"PED","WALK_drunk",4.1,1,1,1,1,1);
		case 8: ApplyAnimation(playerid,"PED","WALK_fat",4.1,1,1,1,1,1);
		case 9: ApplyAnimation(playerid,"PED","WALK_fatold",4.1,1,1,1,1,1);
		case 10: ApplyAnimation(playerid,"PED","WALK_old",4.1,1,1,1,1,1);
		case 11: ApplyAnimation(playerid,"PED","WALK_player",4.1,1,1,1,1,1);
		case 12: ApplyAnimation(playerid,"PED","WALK_rocket",4.1,1,1,1,1,1);
		case 13: ApplyAnimation(playerid,"PED","WALK_shuffle",4.1,1,1,1,1,1);
		case 14: ApplyAnimation(playerid,"PED","WOMAN_walknorm",4.1,1,1,1,1,1);
		case 15: ApplyAnimation(playerid,"PED","WOMAN_walkpro",4.1,1,1,1,1,1);
		case 16: ApplyAnimation(playerid,"PED","WOMAN_walkbusy",4.1,1,1,1,1,1);
		case 17: ApplyAnimation(playerid,"PED","WOMAN_walknorm",4.1,1,1,1,1,1);
		case 18: ApplyAnimation(playerid,"PED","Walk_Wuzi",4.1,1,1,1,1,1);
		default: ApplyAnimation(playerid,"PED","WALK_player",4.1,1,1,1,1,1);
	}
	playerData[playerid][pAnimation] = 1;
	return 1;
}

CMD:resetweed(playerid, params[])
{
	if (playerData[playerid][pLuckyBox] > 100) {
		playerData[playerid][pLuckyBox] = 0;
	}

	playerData[playerid][pCPCannabis] = 0;
	playerData[playerid][pCannabis] = 0;
	playerData[playerid][pTurismo] = 0;

	OnAccountUpdate(playerid);
	SendClientMessage(playerid, COLOR_GRAD1, "�س��ӡ�����絤���Ҫվ���觡ѭ��, �س����ö�ӧҹ���觡ѭ����������");

	return 1;
}

//=====================================[ BWMode ]============================================
CMD:respawnme(playerid)
{
	if(!gIsDeathMode{playerid})
		return SendClientMessage(playerid, COLOR_GRAD1, "   �س�ѧ�����");
		
	if(gInjuredTime[playerid] <= 0)
	{
		BitFlag_Off(gPlayerBitFlag[playerid], IS_SPAWNED);
		
		gInjuredTime[playerid] = 0;
		gIsDeathMode{playerid} = false;
		gIsInjuredMode{playerid}=false;
		playerData[playerid][pMedicBill] = true;
		Damage_Reset(playerid);

		/*if(IsValidDynamic3DTextLabel(gDeathLabel[playerid])) 
			DestroyDyn3DTextLabelFix(gDeathLabel[playerid]);*/

		SpawnPlayer(playerid);
		GivePlayerMoneyEx(playerid, -5000);
		SendClientMessage(playerid, COLOR_YELLOW, "�س�������Թ�����ӹǹ $5,000 ���繤���ѡ�Ңͧ�ç��Һ�� All Saints General Hospital");
	}
	else SendClientMessageEx(playerid, COLOR_LIGHTRED, "�������ա %d �Թҷ�", gInjuredTime[playerid]);
	
	return 1;
}

alias:acceptdeath("atd");
CMD:acceptdeath(playerid, params[])
{
    if(!gIsInjuredMode{playerid} || gIsDeathMode{playerid})
 		return SendClientMessage(playerid, COLOR_GRAD1, "   �س������Ѻ�Ҵ��");

	if(gInjuredTime[playerid] > 120 - Main_GetRespawnPerks(playerid) && playerData[playerid][pDonateRank] == 0)
		return SendClientMessageEx(playerid, COLOR_GRAD1, "   �س��ͧ�����һ���ҳ %d �Թҷ����ͷ�������Ѻ�������", gInjuredTime[playerid] - 120 - Main_GetRespawnPerks(playerid));

	gIsDeathMode{playerid} = true;
	gInjuredTime[playerid] = Main_GetRespawnTime(playerid);

	SendClientMessageEx(playerid, COLOR_YELLOW, "-> �س�������㹢�й�� �س���繵�ͧ�� %d �Թҷ������ѧ�ҡ��鹤س�֧������ö /respawnme", gInjuredTime[playerid]);

    if (!IsPlayerInAnyVehicle(playerid)) {
		ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}
//=====================================[ BWMode ]============================================



CMD:lock(playerid, params[])
{
	new id = -1, vehicleid;

	if( (IsPlayerInAnyVehicle(playerid) ? ((vehicleid = GetPlayerVehicleID(playerid)) != 0) : ((vehicleid = Vehicle_Nearest(playerid)) != -1))) {

		/*new
			engine,
			lights,
			alarm,
			doors,
			bonnet,
			boot,
			objective;*/

		if((id = PlayerCar_GetID(vehicleid)) == -1)
		{
			if((IsVehicleRental(vehicleid) == -1 && gLastCar[playerid] == vehicleid)) {

				// GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

				if(!GetLockStatus(vehicleid))
				{
					GameTextForPlayer(playerid, sprintf("~r~%s Locked", ReturnVehicleModelName(GetVehicleModel(vehicleid))), 2000, 4);
					// SetVehicleParamsEx(vehicleid, engine, lights, alarm, 1, bonnet, boot, objective);
					SetLockStatus(vehicleid, true);
					PlayerPlaySoundEx(playerid, 24600);
				}
				else
				{
					GameTextForPlayer(playerid, sprintf("~g~%s Unlocked", ReturnVehicleModelName(GetVehicleModel(vehicleid))), 2000, 4);
					// SetVehicleParamsEx(vehicleid, engine, lights, alarm, 0, bonnet, boot, objective);
					SetLockStatus(vehicleid, false);
					PlayerPlaySoundEx(playerid, 24600);
				}
			} 
			else if(IsVehicleRental(vehicleid) != -1  && RentCarKey[playerid] == vehicleid) {

				// GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

				if(!GetLockStatus(vehicleid))
				{
					GameTextForPlayer(playerid, sprintf("~r~%s Locked", ReturnVehicleModelName(GetVehicleModel(vehicleid))), 2000, 4);
					//SetVehicleParamsEx(vehicleid, engine, lights, alarm, 1, bonnet, boot, objective);
					SetLockStatus(vehicleid, true);
					PlayerPlaySoundEx(playerid, 24600);
				}
				else
				{
					GameTextForPlayer(playerid, sprintf("~g~%s Unlocked", ReturnVehicleModelName(GetVehicleModel(vehicleid))), 2000, 4);
					//SetVehicleParamsEx(vehicleid, engine, lights, alarm, 0, bonnet, boot, objective);
					SetLockStatus(vehicleid, false);
					PlayerPlaySoundEx(playerid, 24600);
				}
			}
		}
		else
		{
			if(playerData[playerid][pPCarkey] != id && playerData[playerid][pPDupkey] != playerCarData[id][carDupKey]) {

				SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: �س�������ö��Ҷ֧�ҹ��˹й����");

				//id = PlayerCar_GetID(vehicleid);
				if (GetLockStatus(vehicleid)) {
					if (isequal(params, "breakin")) {
						if(playerCarData[id][carProtect] == 0) {
							SendClientMessage(playerid, COLOR_WHITE, "�س����ö������ѧ��е���㹢�й��! �Ը�㹡�þѧ:");
							SendClientMessage(playerid, COLOR_WHITE, "-�ӻ��");
							SendClientMessage(playerid, COLOR_WHITE, "-���ظ���л�ЪԴ");

							vehicleData[vehicleid][vbreakin] = 50 + floatround(playerCarData[id][carLock]*25);
							vehicleData[vehicleid][vbreaktime] = 20;
						}
						else SendClientMessage(playerid, COLOR_LIGHTRED, "�ҹ��˹Фѹ����ѧ�����������ͧ�ѹ����ͧ �ô�ͧ���������ѧ");
					}
					else SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: �ҡ�س���������оѧ����: "EMBED_YELLOW"\"/lock "EMBED_WHITE"breakin"EMBED_YELLOW"\"");
				}
			}
			else {
				// GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

				if(!GetLockStatus(vehicleid))
				{
					GameTextForPlayer(playerid, sprintf("~r~%s Locked", ReturnVehicleModelName(GetVehicleModel(vehicleid))), 2000, 4);
					//SetVehicleParamsEx(vehicleid, engine, lights, alarm, 1, bonnet, boot, objective);
					SetLockStatus(vehicleid, true);
					PlayerPlaySoundEx(playerid, 24600);
				}
				else
				{
					GameTextForPlayer(playerid, sprintf("~g~%s Unlocked", ReturnVehicleModelName(GetVehicleModel(vehicleid))), 2000, 4);
					//SetVehicleParamsEx(vehicleid, engine, lights, alarm, 0, bonnet, boot, objective);
					SetLockStatus(vehicleid, false);
					PlayerPlaySoundEx(playerid, 24600);
				}	
			}
		}
	}
	else if (IsPlayerAtHouseArea(playerid)) {
		PlayerLockHouse(playerid);
	}
	else if (IsPlayerAtBusinessArea(playerid)) {
		PlayerLockBusiness(playerid);
	}
	else if ((id = IsPlayerNearestEntrance(playerid) != -1)) {
		ToggleEntranceLockStatus(playerid, id);
	}
	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, " ..����������ͺ � ��Ǥس�������ö��͡��");
	}
	return 1;
}


CMD:enter(playerid)
{
	if (IsPlayerAtHouseEntrance(playerid)) {
		PlayerEnterNearestHouse(playerid);
	}
	else if (IsPlayerAtBusinessEntrance(playerid)) {
		PlayerEnterNearestBusiness(playerid);
	}
	else if (IsPlayerAtEntranceEntrance(playerid)) {
		PlayerEnterNearestEntrance(playerid);
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4,2073.2979,-1831.1228,13.5469))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
			new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
			if (factionType == FACTION_TYPE_POLICE)
	        {
	            if(playerData[playerid][pOnDuty])
	            {
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, 2062.1294,-1831.5498,13.5469);
	        		SetVehicleZAngle(tmpcar, 90);
					SetPVarInt(playerid, "SprayID", 1);
					TogglePlayerControllable(playerid, 0);
	        		SetTimerEx("AfterSpray", 7500, 0, "i", playerid);
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTRED, "�س���繵�ͧ��Ժѵ�˹�ҷ��! (OnDuty)");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_GRAD1, "   �س��������˹�ҷ����Ǩ");
			}
	    }
	}
	else if (IsPlayerInRangeOfPoint(playerid, 4,1024.9756,-1030.7930,32.0257))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
			new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
			if (factionType == FACTION_TYPE_POLICE)
	        {
	            if(playerData[playerid][pOnDuty])
	            {
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, 1024.9763,-1021.8850,32.1016);
	        		SetVehicleZAngle(tmpcar, 0);
	        		SetPVarInt(playerid, "SprayID", 2);
	        		TogglePlayerControllable(playerid, 0);
	        		SetTimerEx("AfterSpray", 7500, 0, "i", playerid);
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTRED, "�س���繵�ͧ��Ժѵ�˹�ҷ��! (OnDuty)");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_GRAD1, "   �س��������˹�ҷ����Ǩ");
			}
	    }
	}
	else if (IsPlayerInRangeOfPoint(playerid, 4,488.3819,-1733.0563,11.1752))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
			new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
			if (factionType == FACTION_TYPE_POLICE)
	        {
	            if(playerData[playerid][pOnDuty])
	            {
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, 487.4099,-1741.4585,11.1330);
	        		SetVehicleZAngle(tmpcar, 180);
	        		SetPVarInt(playerid, "SprayID", 3);
	        		TogglePlayerControllable(playerid, 0);
	        		SetTimerEx("AfterSpray", 7500, 0, "i", playerid);
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTRED, "�س���繵�ͧ��Ժѵ�˹�ҷ��! (OnDuty)");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_GRAD1, "   �س��������˹�ҷ����Ǩ");
			}
	    }
	}
	
	////////////////////

	else if (IsPlayerInRangeOfPoint(playerid, 4,719.8940,-464.8272,16.3359))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
			new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
			if (factionType == FACTION_TYPE_POLICE)
	        {
	            if(playerData[playerid][pOnDuty])
	            {
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, 720.3924,-456.0286,16.3359);
	        		SetVehicleZAngle(tmpcar, 0);
	        		SetPVarInt(playerid, "SprayID", 4);
	        		TogglePlayerControllable(playerid, 0);
	        		SetTimerEx("AfterSpray", 7500, 0, "i", playerid);
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTRED, "�س���繵�ͧ��Ժѵ�˹�ҷ��! (OnDuty)");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_GRAD1, "   �س��������˹�ҷ����Ǩ");
			}
	    }
	}
	//////////////////////////////////////////////////////////////////////////////
  else if (IsPlayerInRangeOfPoint(playerid, 4,-1904.5464,275.1555,40.3010))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
			new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
			if (factionType == FACTION_TYPE_POLICE)
	        {
	            if(playerData[playerid][pOnDuty])
	            {
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, -1904.1996,284.1657,40.2974);
	        		SetVehicleZAngle(tmpcar, 180);
	        		SetPVarInt(playerid, "SprayID", 5);
	        		TogglePlayerControllable(playerid, 0);
	        		SetTimerEx("AfterSpray", 7500, 0, "i", playerid);
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTRED, "�س���繵�ͧ��Ժѵ�˹�ҷ��! (OnDuty)");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_GRAD1, "   �س��������˹�ҷ����Ǩ");
			}
	    }
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 630.8229,-3058.3379,10.4870)) // Prison #1
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
	        if(playerData[playerid][pOnDuty])
	        {
				SetPlayerPos(playerid, 632.8108,-3063.8755,10.3060);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTRED, "�س���繵�ͧ��Ժѵ�˹�ҷ��! (OnDuty)");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   �س��������˹�ҷ����Ǩ");
		}
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 604.3121,-3136.1377,10.1333)) // Prison #2
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
	        if(playerData[playerid][pOnDuty])
	        {
				SetPlayerPos(playerid, 605.4823,-3140.5581,10.1325);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTRED, "�س���繵�ͧ��Ժѵ�˹�ҷ��! (OnDuty)");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   �س��������˹�ҷ����Ǩ");
		}
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 645.8768,-3115.1067,11.0019)) // Prison #3
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
	        if(playerData[playerid][pOnDuty])
	        {
				SetPlayerPos(playerid, 1765.1758,-1568.9832,1742.4930);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTRED, "�س���繵�ͧ��Ժѵ�˹�ҷ��! (OnDuty)");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   �س��������˹�ҷ����Ǩ");
		}
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 1779.7113,-1580.5214,1742.4500)) // Prison #4
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
	        if(playerData[playerid][pOnDuty])
	        {
				SetPlayerPos(playerid, 1779.7740,-1577.9274,1741.9115);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTRED, "�س���繵�ͧ��Ժѵ�˹�ҷ��! (OnDuty)");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   �س��������˹�ҷ����Ǩ");
		}
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 1780.2192,-1576.5327,1734.9430)) // Prison #5
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
			if(systemVariables[PrisonStatus] == 0)
			{
				if(playerData[playerid][pOnDuty])
				{
					SetPlayerPos(playerid, 624.5247,-3146.2415,10.3016);
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTRED, "�س���繵�ͧ��Ժѵ�˹�ҷ��! (OnDuty)");
				}
			}
			else return SendClientMessage(playerid, COLOR_GRAD2, "��е������١�Դ��ҹ, ��س��͡���Դ��ҹ�ҡ��������͹��");
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   �س��������˹�ҷ����Ǩ");
		}
	}

	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "�س������������ҧ���� �");
	}
	return 1;
}

CMD:exit(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid) && IsVehicleRental(vehicleid) != -1 || (!GetEngineStatus(vehicleid) && IsEngineVehicle(vehicleid)))
	{
		RemovePlayerFromVehicle(playerid);
		TogglePlayerControllable(playerid, true);
	}
	else if (IsPlayerAtHouseExit(playerid)) {
		PlayerExitHouse(playerid);
	}
	else if (IsPlayerAtBusinessExit(playerid)) {
		PlayerExitBusiness(playerid);
	}
	else if (IsPlayerAtEntranceExit(playerid)) {
		PlayerExitEntrance(playerid);
	}
	else if(VDealerSetting{playerid})
	{
		ExitSettingVehicle(playerid);
	}
	else if (IsPlayerInRangeOfPoint(playerid, 4,2062.1294,-1831.5498,13.5469))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
	        new tmpcar = GetPlayerVehicleID(playerid);
			DeletePVar(playerid, "SprayID");
			TogglePlayerControllable(playerid, 1);
			SetVehiclePos(tmpcar, 2073.2979,-1831.1228,13.5469);
			SetVehicleZAngle(tmpcar, 0);
	    }
	}
	else if (IsPlayerInRangeOfPoint(playerid, 4,1024.9763,-1021.8850,32.1016))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
	        new tmpcar = GetPlayerVehicleID(playerid);
			DeletePVar(playerid, "SprayID");
			TogglePlayerControllable(playerid, 1);
			SetVehiclePos(tmpcar, 1024.9756,-1030.7930,32.0257);
			SetVehicleZAngle(tmpcar, 90);
	    }
	}
	else if (IsPlayerInRangeOfPoint(playerid, 4,487.4099,-1741.4585,11.1330))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
	        new tmpcar = GetPlayerVehicleID(playerid);
			DeletePVar(playerid, "SprayID");
			TogglePlayerControllable(playerid, 1);
			SetVehiclePos(tmpcar, 488.3819,-1733.0563,11.1752);
			SetVehicleZAngle(tmpcar, 90);
	    }
	}
	
	else if (IsPlayerInRangeOfPoint(playerid, 4,720.3924,-456.0286,16.3359))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
	        new tmpcar = GetPlayerVehicleID(playerid);
			DeletePVar(playerid, "SprayID");
			TogglePlayerControllable(playerid, 1);
			SetVehiclePos(tmpcar, 719.8940,-464.8272,16.3359);
			SetVehicleZAngle(tmpcar, 90);
	    }
	}
	
 	else if (IsPlayerInRangeOfPoint(playerid, 4,-1904.1996,284.1657,40.2974))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
	        new tmpcar = GetPlayerVehicleID(playerid);
			DeletePVar(playerid, "SprayID");
			TogglePlayerControllable(playerid, 1);
			SetVehiclePos(tmpcar, -1904.5464,275.1555,40.3010);
			SetVehicleZAngle(tmpcar, 90);
	    }
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 632.8108,-3063.8755,10.3060)) // Prison #1
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
	        if(playerData[playerid][pOnDuty])
	        {
				SetPlayerPos(playerid, 630.8229,-3058.3379,10.4870);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTRED, "�س���繵�ͧ��Ժѵ�˹�ҷ��! (OnDuty)");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   �س��������˹�ҷ����Ǩ");
		}
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 605.4823,-3140.5581,10.1325)) // Prison #2
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
	        if(playerData[playerid][pOnDuty])
	        {
				SetPlayerPos(playerid, 604.3121,-3136.1377,10.1333);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTRED, "�س���繵�ͧ��Ժѵ�˹�ҷ��! (OnDuty)");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   �س��������˹�ҷ����Ǩ");
		}
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 1765.1758,-1568.9832,1742.4930)) // Prison #3
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
	        if(playerData[playerid][pOnDuty])
	        {
				SetPlayerPos(playerid, 645.8768,-3115.1067,11.0019);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTRED, "�س���繵�ͧ��Ժѵ�˹�ҷ��! (OnDuty)");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   �س��������˹�ҷ����Ǩ");
		}
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 1779.7740,-1577.9274,1741.9115)) // Prison #4
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
	        if(playerData[playerid][pOnDuty])
	        {
				SetPlayerPos(playerid, 1779.7113,-1580.5214,1742.4500);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTRED, "�س���繵�ͧ��Ժѵ�˹�ҷ��! (OnDuty)");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   �س��������˹�ҷ����Ǩ");
		}
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 624.5247,-3146.2415,10.3016)) // Prison #5
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
			if(systemVariables[PrisonStatus] == 0)
			{
				if(playerData[playerid][pOnDuty])
				{
					SetPlayerPos(playerid, 1780.2192,-1576.5327,1734.9430);
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTRED, "�س���繵�ͧ��Ժѵ�˹�ҷ��! (OnDuty)");
				}
			}
			else return SendClientMessage(playerid, COLOR_GRAD2, "��е������١�Դ��ҹ, ��س��͡���Դ��ҹ�ҡ��������͹��");
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   �س��������˹�ҷ����Ǩ");
		}
	}

	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "�س������������ҧ�͡� �");
	}
	return 1;
}

alias:buy("fill", "eat");
CMD:buy(playerid, params[])
{
	new id = -1;
	if ((id = IsPlayerInteractiveBusiness(playerid)) != -1) {
		Store_Interactive(playerid, id, params);
	}
	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "�س��������������ҹ���� �");
	}
    return 1;
}

//----------------------------------[Bank System]-----------------------------------------------

CMD:bank(playerid, params[]) {
	if (IsPlayerAtBank(playerid)) {
		ShowBankMenu(playerid);
	}
	else SendClientMessage(playerid, COLOR_GREY, "   �س����������踹Ҥ�� !");
	return 1;
}

ShowBankMenu(playerid) {
	return Dialog_Show(playerid,BankDialogMenu,DIALOG_STYLE_LIST,"��Ҥ��","�ҡ�Թ\n�͹�Թ\n���ʹ�Թ\n�͹�Թ","���͡","¡��ԡ");
}

Dialog:BankDialogMenu(playerid, response, listitem, inputtext[])
{
	if(response) {
		switch(listitem) {
			case 0: { // �ҡ�Թ
	        	Dialog_Show(playerid,BankDialog_Deposit,DIALOG_STYLE_INPUT,"�ҡ�Թ",""EMBED_DIALOG"�ʹ�Թ������ͧ͢�س : %s"EMBED_DIALOG"\n��͡�ӹǹ���س��ͧ��ýҡ��ҹ��ҧ���:","�ҡ","��Ѻ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));
			}
			case 1: { // �͹�Թ
	        	Dialog_Show(playerid,BankDialog_Withdraw,DIALOG_STYLE_INPUT,"�͹�Թ",""EMBED_DIALOG"�ʹ�Թ������ͧ͢�س : %s"EMBED_DIALOG"\n��͡�ӹǹ���س��ͧ��ö͹��ҹ��ҧ���:","�͹","��Ѻ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));
			}
			case 2: {
				PC_EmulateCommand(playerid, "/balance");
				ShowBankMenu(playerid);
			}
			case 3: { // �͹
				if (playerData[playerid][pPlayingHours] < 2)
					return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö�͹�Թ㹢�з�������������蹵�ӡ��� 2 �������");

	        	Dialog_Show(playerid,BankDialog_Transfer,DIALOG_STYLE_INPUT,"�͹�Թ",""EMBED_DIALOG"�ʹ�Թ������ͧ͢�س : %s"EMBED_DIALOG"\n��͡ �ʹ�/���ͺҧ��ǹ ���س��ͧ����͹��ҹ��ҧ���:","�Ѵ�","��Ѻ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));
			}
		}
	}
	return 1;
}

Dialog:BankDialog_Deposit(playerid, response, listitem, inputtext[])
{
	if(response) {
		new cashdeposit = strval(inputtext);

		if(playerData[playerid][pSavingsCollect]) 
			return Dialog_Show(playerid,BankDialog_Deposit,DIALOG_STYLE_INPUT,"�ҡ�Թ",""EMBED_DIALOG"�ʹ�Թ������ͧ͢�س : %s"EMBED_DIALOG"\n��͡�ӹǹ���س��ͧ��ýҡ��ҹ��ҧ���:\n\n"EMBED_LIGHTRED"�Դ��ͼԴ��Ҵ: "EMBED_WHITE"�س�������ö�����觹����㹢�з���Դ�ѭ�������Ѿ��","�ҡ","��Ѻ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));

		if (cashdeposit > playerData[playerid][pCash] || cashdeposit < 1)
			return Dialog_Show(playerid,BankDialog_Deposit,DIALOG_STYLE_INPUT,"�ҡ�Թ",""EMBED_DIALOG"�ʹ�Թ������ͧ͢�س : %s"EMBED_DIALOG"\n��͡�ӹǹ���س��ͧ��ýҡ��ҹ��ҧ���:\n\n"EMBED_LIGHTRED"�Դ��ͼԴ��Ҵ: "EMBED_WHITE"�س��������Թ�ҡ��Ҵ���","�ҡ","��Ѻ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));

		GivePlayerMoneyEx(playerid, -cashdeposit);
		//playerData[playerid][pCash] -= cashdeposit;
		new curfunds = playerData[playerid][pAccount];
		playerData[playerid][pAccount]=cashdeposit+playerData[playerid][pAccount];

		return Dialog_Show(playerid,BankDialog_ReturnMenu,DIALOG_STYLE_MSGBOX,"��¡���Թ�ҡ�͹㹺ѭ���Թ�ҡ","|___ BANK STATEMENT ___|\n  �ʹ�Թ���: $%d\n  �Թ�ҡ: $%d\n|-----------------------------------------|\n  �ʹ�Թ����: $%d","��Ѻ","", curfunds, cashdeposit, playerData[playerid][pAccount]);
	}
    return ShowBankMenu(playerid);
}

Dialog:BankDialog_Withdraw(playerid, response, listitem, inputtext[])
{
	if(response) {
		new cashwithdraw = strval(inputtext);
		if(cashwithdraw < 250) 
			return Dialog_Show(playerid,BankDialog_Withdraw,DIALOG_STYLE_INPUT,"�͹�Թ",""EMBED_DIALOG"�ʹ�Թ������ͧ͢�س : %s"EMBED_DIALOG"\n��͡�ӹǹ���س��ͧ��ö͹��ҹ��ҧ���:\n\n"EMBED_LIGHTRED"�Դ��ͼԴ��Ҵ: "EMBED_WHITE"�͹������ $250 ����","�͹","��Ѻ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));
	    
		if(playerData[playerid][pSavingsCollect]) 
			return Dialog_Show(playerid,BankDialog_Withdraw,DIALOG_STYLE_INPUT,"�͹�Թ",""EMBED_DIALOG"�ʹ�Թ������ͧ͢�س : %s"EMBED_DIALOG"\n��͡�ӹǹ���س��ͧ��ö͹��ҹ��ҧ���:\n\n"EMBED_LIGHTRED"�Դ��ͼԴ��Ҵ: "EMBED_WHITE"�س�������ö�����觹����㹢�з���Դ�ѭ�������Ѿ��","�͹","��Ѻ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));

        new tax = floatround(cashwithdraw * 0.002, floatround_round);
		if (cashwithdraw+tax > playerData[playerid][pAccount] || cashwithdraw < 1) 
			return Dialog_Show(playerid,BankDialog_Withdraw,DIALOG_STYLE_INPUT,"�͹�Թ",""EMBED_DIALOG"�ʹ�Թ������ͧ͢�س : %s"EMBED_DIALOG"\n��͡�ӹǹ���س��ͧ��ö͹��ҹ��ҧ���:\n\n"EMBED_LIGHTRED"�Դ��ͼԴ��Ҵ: "EMBED_WHITE"�س��������Թ�ҡ��Ҵ���","�͹","��Ѻ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));

	    cashwithdraw = cashwithdraw - tax;
		// playerData[playerid][pCash] += cashwithdraw;
		GivePlayerMoneyEx(playerid, cashwithdraw);
		playerData[playerid][pAccount] -= cashwithdraw + tax;

		return Dialog_Show(playerid,BankDialog_ReturnMenu,DIALOG_STYLE_MSGBOX, "�͹�Թ","�س�͹ $%d �ҡ�ѭ�բͧ�س �������: $%d ���� $%d","��Ѻ","", cashwithdraw, playerData[playerid][pAccount], cashwithdraw + tax, playerData[playerid][pAccount], tax);
	}
    return ShowBankMenu(playerid);
}

Dialog:BankDialog_ReturnMenu(playerid) {
	return ShowBankMenu(playerid);
}

Dialog:BankDialog_Transfer(playerid, response, listitem, inputtext[])
{
	if(response) {
		new targetid = INVALID_PLAYER_ID;
		if(sscanf(inputtext,"u", targetid)) {
			Dialog_Show(playerid,BankDialog_Transfer,DIALOG_STYLE_INPUT,"�͹�Թ",""EMBED_DIALOG"�ʹ�Թ������ͧ͢�س : %s"EMBED_DIALOG"\n��͡ �ʹ�/���ͺҧ��ǹ ���س��ͧ����͹��ҹ��ҧ���:","�Ѵ�","��Ѻ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));
			return 1;
		}
		SetPVarInt(playerid, "TransferID", targetid);
		Dialog_Show(playerid,BankDialog_Confirm,DIALOG_STYLE_INPUT,"�͹�Թ",""EMBED_DIALOG"�ʹ�Թ������ͧ͢�س : %s"EMBED_DIALOG"\n�����蹷���ͧ����͹: (%d) %s\n�͹����͡�ӹǹ���س��ͧ����͹��ҹ��ҧ���:","�Ѵ�","��Ѻ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""), targetid, ReturnRealName(targetid));
		return 1;
	}
    return ShowBankMenu(playerid);
}

Dialog:BankDialog_Confirm(playerid, response, listitem, inputtext[])
{
	if(response) {
		PC_EmulateCommand(playerid, sprintf("/transfer %d %s", GetPVarInt(playerid, "TransferID"), inputtext));
		DeletePVar(playerid, "TransferID");
		return ShowBankMenu(playerid);
	}
    return Dialog_Show(playerid,BankDialog_Transfer,DIALOG_STYLE_INPUT,"�͹�Թ",""EMBED_DIALOG"�ʹ�Թ������ͧ͢�س : %s"EMBED_DIALOG"\n��͡ �ʹ�/���ͺҧ��ǹ ���س��ͧ����͹��ҹ��ҧ���:","�Ѵ�","��Ѻ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));
}

CMD:deposit(playerid, params[])
{
	if (IsPlayerAtBank(playerid)) {
		new cashdeposit;
		if (sscanf(params, "d", cashdeposit))
		{
			SendClientMessage(playerid, COLOR_GRAD1, "�����: /deposit [�ӹǹ]");
			SendClientMessageEx(playerid, COLOR_GRAD3, "  �س�� $%d ����㹺ѭ��", playerData[playerid][pAccount]);
			return 1;
		}

		if(playerData[playerid][pSavingsCollect]) return SendClientMessage(playerid, COLOR_LIGHTRED, "�س�������ö�����觹����㹢�з���Դ�ѭ�������Ѿ��");
		if (cashdeposit > playerData[playerid][pCash] || cashdeposit < 1) return SendClientMessage(playerid, COLOR_GRAD2, "   �س��������ҡ��Ҵ���");

		//playerData[playerid][pCash] -= cashdeposit;
		GivePlayerMoneyEx(playerid, -cashdeposit);
		new curfunds = playerData[playerid][pAccount];
		playerData[playerid][pAccount]=cashdeposit+playerData[playerid][pAccount];

		SendClientMessage(playerid, COLOR_WHITE, "|___ BANK STATEMENT ___|");
		SendClientMessageEx(playerid, COLOR_FADE1, "  �ʹ�Թ���: $%d", curfunds);
		SendClientMessageEx(playerid, COLOR_FADE1, "  �Թ�ҡ: $%d", cashdeposit);
		SendClientMessage(playerid, COLOR_WHITE, "|-----------------------------------------|");
		SendClientMessageEx(playerid, COLOR_WHITE, "  �ʹ�Թ����: $%d", playerData[playerid][pAccount]);
	}
	else SendClientMessage(playerid, COLOR_GREY, "   �س����������踹Ҥ�� !");
	return 1;
}


CMD:withdraw(playerid, params[])
{
	new cashdeposit, tax;

    if(IsPlayerAtBank(playerid)) {

		if (sscanf(params, "d", cashdeposit))
		{
			SendClientMessage(playerid, COLOR_GRAD1, "�����: /withdraw [�ӹǹ]");
			SendClientMessageEx(playerid, COLOR_GRAD3, "  �س�� $%d ����㹺ѭ��", playerData[playerid][pAccount]);
			return 1;
		}
		if(cashdeposit < 250) return SendClientMessage(playerid, COLOR_LIGHTRED, "�͹������ $250 ����");
	    if(playerData[playerid][pSavingsCollect]) return SendClientMessage(playerid, COLOR_LIGHTRED, "�س�������ö�����觹����㹢�з���Դ�ѭ�������Ѿ��");

        tax = floatround(cashdeposit * 0.002, floatround_round);
		if (cashdeposit+tax > playerData[playerid][pAccount] || cashdeposit < 1) return SendClientMessage(playerid, COLOR_GRAD2, "   �س��������ҡ��Ҵ��� !");

	    cashdeposit = cashdeposit - tax;
		GivePlayerMoneyEx(playerid, cashdeposit);
		//playerData[playerid][pCash] += cashdeposit;
		playerData[playerid][pAccount] -= cashdeposit + tax;
	 	SendClientMessageEx(playerid, COLOR_YELLOW, "  �س�͹ $%d �ҡ�ѭ�բͧ�س �������: $%d ���� $%d", cashdeposit + tax, playerData[playerid][pAccount], tax);

	}
	else SendClientMessage(playerid, COLOR_GREY, "   �س����������踹Ҥ�� !");

	return 1;
}

CMD:balance(playerid, params[])
{
	if(IsPlayerAtBank(playerid)) {
		SendClientMessageEx(playerid, COLOR_YELLOW, "  �س�� $%d ����㹺ѭ��", playerData[playerid][pAccount]);
	} else SendClientMessage(playerid, COLOR_GREY, "   �س����������踹Ҥ�� !");
	return 1;
}

CMD:transfer(playerid, params[])
{
	if (IsPlayerAtBank(playerid)) {

        new targetid, amount, str[128];
        
		if (playerData[playerid][pPlayingHours] < 2)
	    	return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö�͹�Թ㹢�з�������������蹵�ӡ��� 2 �������");

		if(playerData[playerid][pSavingsCollect]) return SendClientMessage(playerid, COLOR_LIGHTRED, "�س�������ö�����觹����㹢�з���Դ�ѭ�������Ѿ��");

		if(sscanf(params,"ud", targetid, amount)) {
			SendClientMessage(playerid, COLOR_GRAD1, "�����: /transfer [�ʹ�/���ͺҧ��ǹ] [�ӹǹ]");
			SendClientMessageEx(playerid, COLOR_GRAD3, "  �س�� $%d ����㹺ѭ��", playerData[playerid][pAccount]);
			return 1;
		}

        if(playerData[playerid][pAccount] < amount || amount < 1) return SendClientMessage(playerid, COLOR_GRAD2, "  �س��������ҡ��Ҵ���");
		if(playerid == targetid) return SendClientMessage(playerid, COLOR_LIGHTRED, "�س�������ö�͹�Թ������ͧ��");

		if (amount > 10000)
		{
			format(str, sizeof(str), "AdmWarn: %s (%d) ���͹�Թ��� %s (%d) �繨ӹǹ %d", ReturnRealName(playerid), playerid, ReturnRealName(targetid), targetid, amount);
			SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, str);
		}

		if(IsPlayerConnected(targetid)) {

			playerData[playerid][pAccount] -= amount;
			playerData[targetid][pAccount] += amount;

			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "�س���͹�Թ $%d ��Һѭ�բͧ %d", amount, ReturnRealName(targetid));
			SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "�س���Ѻ $%d ��Ҹ�Ҥ�èҡ�ѭ�բͧ %s", amount, ReturnRealName(playerid));

			Log(transferlog, INFO, "%s �͹�Թ���Ѻ %s �ӹǹ %d", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount);
		}
		else {
		    SendClientMessage(playerid, COLOR_GREY, "   ��辺�����źѭ�������Ţ��� !");
		}
		
	} else SendClientMessage(playerid, COLOR_GREY, "   �س����������踹Ҥ�� !");
	return 1;
}


Dialog:WithdrawSavings(playerid, response, listitem, inputtext[])
{
	if(response) {
		SendClientMessage(playerid, COLOR_WHITE, "�س�Դ�ѭ�������Ѿ�����º��������");
		GivePlayerMoneyEx(playerid, playerData[playerid][pSavingsCollect]);
		playerData[playerid][pSavings] = 0;
		playerData[playerid][pSavingsCollect] = 0;
	}
	return 1;
}

CMD:savings(playerid, params[])
{
	if(IsPlayerAtBank(playerid)) {

		if(isequal(params, "withdraw"))
		{
			if (playerData[playerid][pSavings]) {
				Dialog_Show(playerid, WithdrawSavings, DIALOG_STYLE_MSGBOX, "�׹�ѹ���ж͹�Թ", ""EMBED_DIALOG"�س������ͷ��ж͹�Թ�ҡ"EMBED_RED"�ѭ�������Ѿ��"EMBED_DIALOG" ?\n�ѹ�������ö����¹��Ѻ����Фس�е�ͧ�����������!", "��ŧ", "���");
			}
			else SendClientMessage(playerid, COLOR_LIGHTBLUE, "�س����պѭ�������Ѿ��");
		}
		else
		{
			if(playerData[playerid][pSavings])
			{
				SendClientMessage(playerid, COLOR_WHITE, "|_______ BANK STATEMENT _______|");
				SendClientMessageEx(playerid, COLOR_GRAD1, "�ʹ�Թ㹺ѭ���Թ�ҡ�����Ѿ��: %s", FormatNumber(playerData[playerid][pSavingsCollect]));
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "[ ! ] "EMBED_WHITE"�س�� %s ����㹺ѭ�սҡ�����Ѿ��", FormatNumber(playerData[playerid][pSavingsCollect]));

				new paycheck = 0, maximum = 20000000;
				new i = playerData[playerid][pSavings], currently;

				while(i < maximum)
				{
					i += floatround((i/100.0)*(0.5), floatround_round);
					paycheck++;

					if(playerData[playerid][pSavingsCollect] > i) currently = 2 + paycheck;
				}


				SendClientMessageEx(playerid, COLOR_LIGHTRED, "[ ! ] "EMBED_WHITE"�Թ�ҡ�����Ѿ��ͧ�س������ա %d/%d paydays (%d%s)", currently, paycheck, floatround(float(currently) / float(paycheck) * 100), "%%");
				SendClientMessage(playerid, COLOR_LIGHTRED, "�����: "EMBED_WHITE" ���Ͷ͹�Թ��{FF6347}� �� /savings withdraw");
			}
			else
			{
				new savings = strval(params);

				if (!savings)
					return SendClientMessage(playerid, COLOR_LIGHTRED, "�����:"EMBED_WHITE" �������ҧ�ѭ�������Ѿ�� /savings [�ӹǹ]");

				if(savings == 50000 || savings == 100000)
				{
					if(playerData[playerid][pCash] > savings)
					{
						playerData[playerid][pSavings] = savings;
						playerData[playerid][pSavingsCollect] = savings;
						playerData[playerid][pCash] -= savings;

						SendClientMessage(playerid, COLOR_WHITE, "|_______ BANK STATEMENT _______|");
						SendClientMessageEx(playerid, COLOR_GRAD1, "�ʹ�Թ㹺ѭ���Թ�ҡ�����Ѿ��: %s", FormatNumber(savings));
						SendClientMessageEx(playerid, COLOR_LIGHTRED, "[ ! ] "EMBED_WHITE"�س�� %s ����㹺ѭ�սҡ�����Ѿ��", FormatNumber(savings));


						new paycheck = 0, maximum = 20000000;
						new i = playerData[playerid][pSavings], currently;

						while(i < maximum)
						{
							i += floatround((i/float(100))*(0.5), floatround_round);
							paycheck++;
							if(playerData[playerid][pSavingsCollect] > i) currently = 2 + paycheck;
						}


						SendClientMessageEx(playerid, COLOR_LIGHTRED, "[ ! ] "EMBED_WHITE"�Թ�ҡ�����Ѿ��ͧ�س������ա %d/%d paydays (%d%s)", currently, paycheck, floatround(currently / float(paycheck) * 100), "%%");
						SendClientMessage(playerid, COLOR_LIGHTRED, "�����: "EMBED_WHITE" ���Ͷ͹�Թ��{FF6347}� �� /savings withdraw");
					}
					else SendClientMessage(playerid, COLOR_GRAD1, "   �س���Թ���� !");
				}
				else SendClientMessage(playerid, COLOR_LIGHTRED, "�Թ�ҡ�����Ѿ���ͧ���������ҧ $50,000 ��� $100,000 ��ҹ��");
			}
		}
	}
	else SendClientMessage(playerid, COLOR_GREY, "   �س����������踹Ҥ�� !");
	return 1;
}

// 

CMD:accept(playerid, params[])
{
	if (isnull(params))
 	{
	 	SendClientMessage(playerid, COLOR_GRAD1, "�����: /accept [����]");
		SendClientMessage(playerid, COLOR_GREY, "���ͷ������: invite");
		return 1;
	}
	if (!strcmp(params, "invite", true) && GetPVarType(playerid, "OfferID"))
	{
	    new
	        targetid = GetPVarInt(playerid, "OfferID"),
	        factionSID = GetPVarInt(playerid, "OfferFactionID"); // sid

		if (IsPlayerConnected(targetid)) {

			new factionid = Faction_GetID(factionSID); // index

			if (playerData[targetid][pFactionRank] > 1)
				return SendClientMessage(playerid, COLOR_GRAD1, "   ����ʹͽ������͡�����������ö��ҹ��");

			playerData[playerid][pFaction] = factionSID;
			playerData[playerid][pFactionRank] = factionData[factionid][fMaxRanks];

			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "   �س������Ѻ����ʹ� %s ����������� \"%s\"", ReturnRealName(targetid), Faction_GetName(factionid));
			SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "   %s ������Ѻ����ʹͧ͢�س����������� \"%s\"", ReturnRealName(playerid), Faction_GetName(factionid));

			DeletePVar(playerid, "OfferID");
			DeletePVar(playerid, "OfferFactionID");
		}
		else {
			return SendClientMessage(playerid, COLOR_GRAD1, "   ����ʹͽ������͡�����������ö��ҹ��");
		}
	}
	return 1;
}

/* Anim  */
alias:animhelp("anim");
CMD:animhelp(playerid, params[])
{
    if(gIsDeathMode{playerid} || gIsInjuredMode{playerid} || BitFlag_Get(gPlayerBitFlag[playerid],IS_CUFFED))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "�س�������ö��������㹢�й��");

    SendClientMessage(playerid, COLOR_GREEN,"____________͹�����蹵���Ф�____________");
	SendClientMessage(playerid, COLOR_WHITE,"[���/�͹] /sit /chairsit /groundsit /seat /sleep /lean");
	SendClientMessage(playerid, COLOR_WHITE,"[�ѭ�ҳ���] /gsign /salute");
	SendClientMessage(playerid, COLOR_WHITE,"[����������] /greet /taxiL /taxiR");
    SendClientMessage(playerid, COLOR_WHITE,"[����������] /fuckyou /wave /kiss /no");
    SendClientMessage(playerid, COLOR_WHITE,"[����ҷҧ����Ҿ] /bat /punch /taunt /facepalm /aim /slapass");
    SendClientMessage(playerid, COLOR_WHITE,"[����ҷҧ����Ҿ] /hide /crawl /crack /think /sipdrink /sipdrink2");
    SendClientMessage(playerid, COLOR_WHITE,"[������] /cry /injured /panic");
    SendClientMessage(playerid, COLOR_GREEN,"_____________________________________________");

    GameTextForPlayer(playerid, "TO STOP ANIMATION TYPE ~r~/STOPANIM OR PRESS ~r~ENTER.", 3000, 4);

	new str[3500];
    strcat(str, "/fall | /fallback | /injured | /akick | /push | /lowbodypush | /handsup | /bomb | /drunk | /getarrested | /laugh | /sup\n");
    strcat(str, "/basket | /headbutt | /medic | /spray | /robman | /taichi | /lookout | /kiss | /cellin | /cellout | /crossarms | /lay\n");
	strcat(str, "/deal | /crack | /groundsit | /chat  | /dance | /fucku | /strip | /hide | /vomit | /chairsit | /reload\n");
    strcat(str, "/koface | /kostomach | /rollfall | /bat | /die | /joint | /bed | /lranim | /fixcar | /fixcarout\n");
    strcat(str, "/lifejump | /exhaust | /leftslap | /carlock | /hoodfrisked | /lightcig | /tapcig | /box | /lay2 | /chant | /fuckyou| /fuckyou2\n");
    strcat(str, "/shouting | /knife | /cop | /elbow | /kneekick | /airkick | /gkick | /punch | /gpunch | /fstance | /lowthrow | /highthrow | /aim\n");
    strcat(str, "/pee | /lean | /run | /poli | /surrender | /sit | /breathless | /seat | /rap | /cross | /jiggy | /gsign\n");
    strcat(str, "/sleep | /smoke | /pee | /chora | /relax | /crabs | /stop | /wash | /mourn | /fuck | /tosteal | /crawl\n");
    strcat(str, "/followme | /greet | /still | /hitch | /palmbitch | /cpranim | /giftgiving | /slap2 | /pump | /cheer\n");
    strcat(str, "/dj | /foodeat | /wave | /slapass | /dealer | /dealstance | /inbedright | /inbedleft\n");
	strcat(str, "/wank | /bj | /getup | /follow | /stand | /slapped | /yes | /celebrate | /win | /checkout\n");
	strcat(str, "/thankyou | /invite1 | /scratch | /nod | /cry | /carsmoke | /benddown | /facepalm | /angry\n");
	strcat(str, "/cockgun | /bar | /liftup | /putdown | /camera | /think | /handstand | /panicjump\n");
    Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "��ҷҧ��� �", str, "���", "");
	return 1;
}

AnimationCheck(playerid)
{
	return (gIsDeathMode{playerid} || BitFlag_Get(gPlayerBitFlag[playerid], IS_CUFFED));
}

ApplyAnimationEx(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
{
	if(gIsInjuredMode{playerid})
	    return 0;

	ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
	return 1;
}

CMD:greet(playerid, params[])
{
	new targetid, type;
	if(sscanf(params,"ud",targetid,type)) {
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /greet [�ʹռ�����/���ͺҧ��ǹ] [style]");
		SendClientMessage(playerid, COLOR_YELLOW3, "[1] Kiss [2] Handshake [3] Handshake [4] Handshake [5] Handshake");
		SendClientMessage(playerid, COLOR_YELLOW3, "[6] Handshake [7] Handshake [8] Handshake [9] Handshake [10] Handshake");
		return 1;
	}

	if(targetid == INVALID_PLAYER_ID)
		SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if(targetid == playerid) 
		return SendClientMessage(playerid, COLOR_GREY, "�س�������ö�ѡ��µ���ͧ��");

	if(type > 10 || type < 1) 
		return SendClientMessage(playerid, COLOR_WHITE, "���� 1-10!");

	if (!IsPlayerNearPlayer(playerid, targetid, 2.0)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������س");

	SetPVarInt(playerid, "SentGreet", 1);
	SetPVarInt(playerid, "GreetType", type);
	SetPVarInt(targetid, "GreetFrom", playerid);
	SetPVarInt(targetid, "GettingGreet", 1);

	SendClientMessageEx(playerid, COLOR_WHITE, "* �س��ͧ��÷ѡ��� %s", ReturnRealName(targetid));
	SendClientMessageEx(targetid, COLOR_WHITE, "(ID: %d)%s ��ҡ��������ѡ��¡Ѻ�س(/acceptshake playerID)", playerid,ReturnRealName(playerid));
	return 1;
}

CMD:acceptshake(playerid, params[])
{
	new targetid;
	if(sscanf(params,"d",targetid)) return SendClientMessage(playerid, COLOR_GREY, "{FF6142}USAGE:"EMBED_WHITE" /acceptshake [�ʹռ�����/���ͺҧ��ǹ]");
	if(GetPVarInt(playerid, "GettingGreet") == 0) return SendClientMessage(playerid, COLOR_GREY, "������õ�ͧ��÷ѡ��¤س");
	if(GetPVarInt(playerid, "GreetFrom") != targetid) return SendClientMessage(playerid, COLOR_GREY, "�س�����١��ͧ�͡�÷ѡ��¨ҡ�����蹹��");

	if(targetid == INVALID_PLAYER_ID) {
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");
	}

	if(targetid == playerid) return SendClientMessage(playerid, COLOR_GREY, "�س�������ö�ѡ��µ���ͧ��");


	if (!IsPlayerNearPlayer(playerid, targetid, 1.0)) return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������س");

    if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö�ѡ�����㹢�й��");
    if (AnimationCheck(targetid)) return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹���������ö�ѡ��¤س��㹢�й��");

	new type = GetPVarInt(targetid, "GreetType");

	ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	playerData[playerid][pAnimation] = 0;

	ApplyAnimationEx(targetid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
	SetPlayerSpecialAction(targetid, SPECIAL_ACTION_NONE);
	playerData[targetid][pAnimation] = 0;

	SetPlayerFacePlayer(playerid, targetid);
	SetPlayerFacePlayer(targetid, playerid);


	if(type == 1)
	{
		ApplyAnimation(playerid, "KISSING", "Playa_Kiss_02", 2.0, 0, 0, 1, 0, 0);
		ApplyAnimation(targetid, "KISSING", "Playa_Kiss_02", 2.0, 0, 0, 1, 0, 0);
	}
	else if(type == 2)
	{
		ApplyAnimation(playerid,"GANGS","hndshkfa_swt", 2.0, 0, 0, 0, 0, 0);
		ApplyAnimation(targetid,"GANGS","hndshkfa_swt", 2.0, 0, 0, 0, 0, 0);
	}
	else if(type == 3)
	{
		ApplyAnimation(playerid,"GANGS","hndshkba", 2.0, 0, 0, 0, 0, 0);
		ApplyAnimation(targetid,"GANGS","hndshkba", 2.0, 0, 0, 0, 0, 0);
	}
	else if(type == 4)
	{
		ApplyAnimation(playerid,"GANGS","hndshkca", 2.0, 0, 0, 0, 0, 0);
		ApplyAnimation(targetid,"GANGS","hndshkca", 2.0, 0, 0, 0, 0, 0);
	}
	else if(type == 5)
	{
		ApplyAnimation(playerid,"GANGS","hndshkcb", 2.0, 0, 0, 0, 0, 0);
		ApplyAnimation(targetid,"GANGS","hndshkcb", 2.0, 0, 0, 0, 0, 0);
	}
	else if(type == 6)
	{
		ApplyAnimation(playerid,"GANGS","hndshkda", 2.0, 0, 0, 0, 0, 0);
		ApplyAnimation(targetid,"GANGS","hndshkda", 2.0, 0, 0, 0, 0, 0);
	}
	else if(type == 7)
	{
		ApplyAnimation(playerid,"GANGS","hndshkea", 2.0, 0, 0, 0, 0, 0);
		ApplyAnimation(targetid,"GANGS","hndshkea", 2.0, 0, 0, 0, 0, 0);
	}
	else if(type == 8)
	{
		ApplyAnimation(playerid,"GANGS","hndshkfa", 2.0, 0, 0, 0, 0, 0);
		ApplyAnimation(targetid,"GANGS","hndshkfa", 2.0, 0, 0, 0, 0, 0);
	}
	else if(type == 9)
	{
		ApplyAnimation(playerid,"GANGS","hndshkaa", 2.0, 0, 0, 0, 0, 0);
		ApplyAnimation(targetid,"GANGS","hndshkaa", 2.0, 0, 0, 0, 0, 0);
	}
	else if(type == 10)
	{
		ApplyAnimation(playerid,"GANGS","prtial_hndshk_biz_01", 2.0, 0, 0, 0, 0, 0);
		ApplyAnimation(targetid,"GANGS","prtial_hndshk_biz_01", 2.0, 0, 0, 0, 0, 0);
	}
	DeletePVar(GetPVarInt(playerid, "GreetFrom"), "SentGreet");
	DeletePVar(GetPVarInt(playerid, "GreetFrom"), "GreetType");
	DeletePVar(playerid, "GreetFrom");
	DeletePVar(playerid, "GettingGreet");
	return 1;
}

CMD:stopanim(playerid)
{
	if(BitFlag_Get(gPlayerBitFlag[playerid], IS_CUFFED)) {
		ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
    	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CUFFED);
    	return 1;
    }
    
    if (AnimationCheck(playerid))
        return SendClientMessage(playerid, COLOR_GRAD1, "�������ö��ش Animation ��㹢�й��");

	if ((playerData[playerid][pAnimation] || GetPlayerCameraMode(playerid) == 55) && GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) {
		playerData[playerid][pAnimation] = 0;
		ClearAnimations(playerid);
		return 1;
	}

	if(playerData[playerid][pAnimation]) {
		ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		playerData[playerid][pAnimation] = 0;
	}
	return 1;
}
alias:stopanim("sa");

CMD:no(playerid, params[])
{
    if (AnimationCheck(playerid))
        return SendClientMessage(playerid, COLOR_GRAD1, "�������ö��� Animation ��㹢�й��");

    ApplyAnimation(playerid, "PED","endchat_02", 4.1, 0, 0, 0, 0, 0);
   	return 1;
}
alias:no("���");

CMD:punch(playerid, params[])
{
    if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "�������ö��� Animation ��㹢�й��");
    ApplyAnimation(playerid, "RIOT", "RIOT_PUNCHES", 4.1, 0, 1, 1, 0, 0, 0);
    return 1;
}
alias:punch("����", "��");

CMD:crawl(playerid, params[])
{
    if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "�������ö��� Animation ��㹢�й��");
    ApplyAnimation(playerid, "PED", "CAR_CRAWLOUTRHS", 4.1, 0, 0, 0, 0, 0, 0);
    return 1;
}
alias:crawl("��ҹ");

CMD:sipdrink(playerid, params[])
{
    if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "�������ö��� Animation ��㹢�й��");
    ApplyAnimation(playerid, "BAR", "DNK_STNDM_LOOP", 4.1, 0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:sipdrink2(playerid, params[])
{
    if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "�������ö��� Animation ��㹢�й��");
    ApplyAnimation(playerid, "BAR", "DNK_STNDF_LOOP", 4.1, 0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:surrender(playerid,params[])
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !AnimationCheck(playerid))
	{
		playerData[playerid][pAnimation] = 1;
	    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
  		return 1;
	}
	else return SendClientMessage(playerid, COLOR_GRAD2, "�������ö��� Animation ��㹢�й��");
}
alias:surrender("���", "�ͺ���");
	
CMD:sit(playerid,params[])
{
    new anim;
    if(sscanf(params, "d", anim)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /sit [1-5]");

	playerData[playerid][pAnimation] = 1;

    switch(anim){
		case 1: ApplyAnimation(playerid,"BEACH","bather",4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid,"BEACH","Lay_Bac_Loop",4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid,"BEACH","ParkSit_W_loop",4.1, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimation(playerid,"BEACH","SitnWait_loop_W",4.1, 0, 1, 1, 1, 1, 1);
		case 5: ApplyAnimation(playerid,"BEACH","SitnWait_loop_W",4.1, 0, 1, 1, 1, 1, 1);
		case 6: ApplyAnimation(playerid,"BEACH", "ParkSit_M_loop", 4.1, 0, 1, 1, 1, 1, 1);
		default: {
			return SendClientMessage(playerid, COLOR_GRAD1, "�����: /sit [1-5]");
		}
	}
	return 1;
}
alias:sit("���");

CMD:sleep(playerid,params[])
{
	new anim;
	
	if(sscanf(params, "d", anim)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /sleep [1-2]");
	playerData[playerid][pAnimation] = 1;
	switch(anim){
		case 1: ApplyAnimation(playerid,"CRACK","crckdeth4",4.1, 0, 1, 1, 1, 1, 1); 
		case 2: ApplyAnimation(playerid,"CRACK","crckidle2",4.1, 0, 1, 1, 1, 1, 1); 
		default: {
			return SendClientMessage(playerid, COLOR_GRAD1, "�����: /sleep [1-2]");
		}
	}
	return 1;
}

CMD:salute(playerid, params[])
{
    if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "�������ö��� Animation ��㹢�й��");
    playerData[playerid][pAnimation] = 1;

    ApplyAnimation(playerid, "GHANDS", "GSIGN5LH", 4.1, false, false, false, false, 0, false);
    return 1;
}

CMD:cheer(playerid,params[])
{
	new anim;

	if(sscanf(params, "d", anim)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /cheer [1-8]");
	playerData[playerid][pAnimation] = 1;
	switch(anim){
		case 1: ApplyAnimation(playerid,"ON_LOOKERS","shout_01",4.1, 0, 1, 1, 1, 1, 1); 
		case 2: ApplyAnimation(playerid,"ON_LOOKERS","shout_02",4.1, 0, 1, 1, 1, 1, 1); 
		case 3: ApplyAnimation(playerid,"ON_LOOKERS","shout_in",4.1, 0, 1, 1, 1, 1, 1); 
		case 4: ApplyAnimation(playerid,"RIOT","RIOT_ANGRY_B",4.1, 0, 1, 1, 1, 1, 1); 
		case 5: ApplyAnimation(playerid,"RIOT","RIOT_CHANT",4.1, 0, 1, 1, 1, 1, 1); 
		case 6: ApplyAnimation(playerid,"RIOT","RIOT_shout",4.1, 0, 1, 1, 1, 1, 1); 
		case 7: ApplyAnimation(playerid,"STRIP","PUN_HOLLER",4.1, 0, 1, 1, 1, 1, 1); 
		case 8: ApplyAnimation(playerid,"OTB","wtchrace_win",4.1, 0, 1, 1, 1, 1, 1); 
		default: {
			return SendClientMessage(playerid, COLOR_GRAD1, "�����: /cheer [1-8]");
		}
	}
	return 1;
}	
alias:cheer("�����");
	
CMD:dj(playerid,params[]){
    new anim;
    if(sscanf(params, "d", anim)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /dj [1-4]");
	playerData[playerid][pAnimation] = 1;
    switch(anim){
		case 1: ApplyAnimation(playerid,"SCRATCHING","scdldlp",4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid,"SCRATCHING","scdlulp",4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid,"SCRATCHING","scdrdlp",4.1, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimation(playerid,"SCRATCHING","scdrulp",4.1, 0, 1, 1, 1, 1, 1);
		default: {
			return SendClientMessage(playerid, COLOR_GRAD1, "�����: /dj [1-4]");
		}
	}
	return 1;
}
	
CMD:breathless(playerid,params[]){
    new anim;
    if(sscanf(params, "d", anim)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /breathless [1-2]");
	playerData[playerid][pAnimation] = 1;
    switch(anim){
		case 1: ApplyAnimation(playerid,"PED","IDLE_tired",4.1, 1, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid,"FAT","IDLE_tired",4.1, 1, 1, 1, 1, 1, 1);
        default: {
			return SendClientMessage(playerid, COLOR_GRAD1, "�����: /breathless [1-2]");
		}
	}
	return 1;
}
	
CMD:poli(playerid,params[]){
    new anim;
    if(sscanf(params, "d", anim)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /poli [1-2]");
	playerData[playerid][pAnimation] = 1;
	switch(anim){
		case 1:ApplyAnimation(playerid,"POLICE","CopTraf_Come",4.1, 0, 1, 1, 1, 1, 1);
		case 2:ApplyAnimation(playerid,"POLICE","CopTraf_Stop",4.1, 0, 1, 1, 1, 1, 1);
		default: {
			return SendClientMessage(playerid, COLOR_GRAD1, "�����: /poli [1-2]");
		}
	}
	return 1;
}
	
CMD:seat(playerid,params[]){
    new anim;
    if(sscanf(params, "d", anim)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /seat [1-7]");
	if(anim < 1 || anim > 7) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /seat [1-7]");
	playerData[playerid][pAnimation] = 1;
	switch(anim){
		case 1: ApplyAnimation(playerid,"Attractors","Stepsit_in",4.1, 0, 0, 0, 1, 0, 0);
		case 2: ApplyAnimation(playerid,"CRIB","PED_Console_Loop",4.1, 0, 0, 0, 1, 0, 0);
		case 3: ApplyAnimation(playerid,"INT_HOUSE","LOU_In",4.1, 0, 0, 0, 1, 0, 0);
		case 4: ApplyAnimation(playerid,"MISC","SEAT_LR",4.1, 0, 0, 0, 1, 0, 0);
		case 5: ApplyAnimation(playerid,"MISC","Seat_talk_01",4.1, 0, 0, 0, 1, 0, 0);
		case 6: ApplyAnimation(playerid,"MISC","Seat_talk_02",4.1, 0, 0, 0, 1, 0, 0);
		case 7: ApplyAnimation(playerid,"ped","SEAT_down",4.1, 0, 0, 0, 1, 0, 0);
	}
	return 1;
}
	
CMD:dance(playerid,params[]){
    new dancestyle;
    if(sscanf(params, "d", dancestyle)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /dance [1-3]");
	playerData[playerid][pAnimation] = 1;
	switch(dancestyle){
		case 1: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
		case 2: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
		case 3: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
		case 4: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
	}
   	return 1;
}
	
CMD:cross(playerid,params[]){
    new anim;
    if(sscanf(params, "d", anim)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /cross [1-5]");
	playerData[playerid][pAnimation] = 1;
	switch(anim){
		case 1: ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE", 4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_01", 4.1, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimation(playerid,"GRAVEYARD","mrnM_loop",4.1, 0, 1, 1, 1, 1, 1);
		case 5: ApplyAnimation(playerid,"GRAVEYARD","prst_loopa",4.1, 0, 1, 1, 1, 1, 1);
		default: return SendClientMessage(playerid, COLOR_GRAD1, "�����: /cross [1-5]");
	}
	return 1;
}
	
CMD:jiggy(playerid,params[])
{
    new anim;
    if(sscanf(params, "d", anim)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /jiggy [1-10]");
	playerData[playerid][pAnimation] = 1;
	switch(anim){
		case 1: ApplyAnimation(playerid,"DANCING","DAN_Down_A",4.1, 1, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid,"DANCING","DAN_Left_A",4.1, 1, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid,"DANCING","DAN_Loop_A",4.1, 1, 1, 1, 1, 1, 1);
		case 4: ApplyAnimation(playerid,"DANCING","DAN_Right_A",4.1, 1, 1, 1, 1, 1, 1);
		case 5: ApplyAnimation(playerid,"DANCING","DAN_Up_A",4.1, 1, 1, 1, 1, 1, 1);
		case 6: ApplyAnimation(playerid,"DANCING","dnce_M_a",4.1, 1, 1, 1, 1, 1, 1);
		case 7: ApplyAnimation(playerid,"DANCING","dnce_M_b",4.1, 1, 1, 1, 1, 1, 1);
		case 8: ApplyAnimation(playerid,"DANCING","dnce_M_c",4.1, 1, 1, 1, 1, 1, 1);
		case 9: ApplyAnimation(playerid,"DANCING","dnce_M_c",4.1, 1, 1, 1, 1, 1, 1);
		case 10: ApplyAnimation(playerid,"DANCING","dnce_M_d",4.1, 1, 1, 1, 1, 1, 1);
		default: return SendClientMessage(playerid, COLOR_GRAD1, "�����: /jiggy [1-10]");
	}
	return 1;
}
	
CMD:rap(playerid,params[]){
    new rapstyle;
    if(sscanf(params, "d", rapstyle)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /rap [1-3]");
	playerData[playerid][pAnimation] = 1;
	switch(rapstyle){
		case 1: ApplyAnimation(playerid,"RAPPING","RAP_A_Loop",4.1, 1, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid,"RAPPING","RAP_B_Loop",4.1, 1, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid,"RAPPING","RAP_C_Loop",4.1, 1, 1, 1, 1, 1, 1);
		default: return SendClientMessage(playerid, COLOR_GRAD1, "�����: /rap [1-3]");
	}
   	return 1;
}
	
CMD:gsign(playerid,params[]){
    new gesture;
    if(sscanf(params, "d", gesture)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /gsign [1-15]");
	playerData[playerid][pAnimation] = 1;
	switch(gesture){
		case 1: ApplyAnimation(playerid,"GHANDS","gsign1",4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid,"GHANDS","gsign1LH",4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid,"GHANDS","gsign2",4.1, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimation(playerid,"GHANDS","gsign2LH",4.1, 0, 1, 1, 1, 1, 1);
		case 5: ApplyAnimation(playerid,"GHANDS","gsign3",4.1, 0, 1, 1, 1, 1, 1);
		case 6: ApplyAnimation(playerid,"GHANDS","gsign3LH",4.1, 0, 1, 1, 1, 1, 1);
		case 7: ApplyAnimation(playerid,"GHANDS","gsign4",4.1, 0, 1, 1, 1, 1, 1);
		case 8: ApplyAnimation(playerid,"GHANDS","gsign4LH",4.1, 0, 1, 1, 1, 1, 1);
		case 9: ApplyAnimation(playerid,"GHANDS","gsign5",4.1, 0, 1, 1, 1, 1, 1);
		case 10: ApplyAnimation(playerid,"GHANDS","gsign5",4.1, 0, 1, 1, 1, 1, 1);
		case 11: ApplyAnimation(playerid,"GHANDS","gsign5LH",4.1, 0, 1, 1, 1, 1, 1);
		case 12: ApplyAnimation(playerid,"GANGS","Invite_No",4.1, 0, 1, 1, 1, 1, 1);
		case 13: ApplyAnimation(playerid,"GANGS","Invite_Yes",4.1, 0, 1, 1, 1, 1, 1);
		case 14: ApplyAnimation(playerid,"GANGS","prtial_gngtlkD",4.1, 0, 1, 1, 1, 1, 1);
		case 15: ApplyAnimation(playerid,"GANGS","smkcig_prtl",4.1, 0, 1, 1, 1, 1, 1);
		default: return SendClientMessage(playerid, COLOR_GRAD1, "�����: /gsign [1-15]");
	}
	return 1;
}
	
CMD:smoke(playerid,params[]){
    new gesture;
    if(sscanf(params, "d", gesture)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /smoke [1-2]");
	playerData[playerid][pAnimation] = 1;
	switch(gesture){
		case 1: ApplyAnimation(playerid,"SMOKING","M_smk_in",4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid,"SMOKING","M_smklean_loop",4.1, 0, 1, 1, 1, 1, 1);
		default: return SendClientMessage(playerid, COLOR_GRAD1, "�����: /smoke [1-2]");
	}
	return 1;
}
	
CMD:chora(playerid,params[]) { ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_watch",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:relax(playerid,params[]) { ApplyAnimation(playerid, "CRACK", "crckidle1",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:crabs(playerid,params[]) { ApplyAnimation(playerid,"MISC","Scratchballs_01",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:stop(playerid,params[]) { ApplyAnimation(playerid,"PED","endchat_01",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:wash(playerid,params[]) { ApplyAnimation(playerid,"BD_FIRE","wash_up",4.1, 0, 0, 0, 0, 0, 0); return 1; }
CMD:mourn(playerid,params[]) { ApplyAnimation(playerid,"GRAVEYARD","mrnF_loop",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:followme(playerid,params[]) { ApplyAnimation(playerid,"WUZI","Wuzi_follow",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:still(playerid,params[]) { ApplyAnimation(playerid,"WUZI","Wuzi_stand_loop", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:hitch(playerid,params[]) { ApplyAnimation(playerid,"MISC","Hiker_Pose", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:palmbitch(playerid,params[]) { ApplyAnimation(playerid,"MISC","bitchslap",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:cpranim(playerid,params[]) { ApplyAnimation(playerid,"MEDIC","CPR",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:giftgiving(playerid,params[]) { ApplyAnimation(playerid,"KISSING","gift_give",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:slap2(playerid,params[]) { ApplyAnimation(playerid,"SWEET","sweet_ass_slap",4.1, 0, 1, 1, 0, 0, 1); return 1; }

CMD:taxiL(playerid) {
	ApplyAnimation(playerid,"MISC","Hiker_Pose_L",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}

CMD:taxiR(playerid) {
	ApplyAnimation(playerid,"MISC","Hiker_Pose",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}


CMD:handstand(playerid) {
	ApplyAnimation(playerid,"DAM_JUMP","DAM_Dive_Loop",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}

CMD:panicjump(playerid) {
	ApplyAnimation(playerid,"DODGE","Crush_Jump",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}

CMD:drunk(playerid,params[]) { 
	ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1; 
}
CMD:pump(playerid,params[]) { ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 1, 1, 0, 1, 1); return 1; }
CMD:tosteal(playerid,params[]) { ApplyAnimation(playerid,"ped", "ARRESTgun", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:laugh(playerid,params[]) { ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:lookout(playerid,params[])  { 
	ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.1, 0, 1, 1, 0, 0, 1); 
	return 1; 
}
CMD:robman(playerid,params[]) { ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:hide(playerid,params[]) { 
	ApplyAnimation(playerid, "ped", "cower",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1; 
}
CMD:vomit(playerid,params[]) { ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:crack(playerid,params[]) { 
	new choice;
	if(sscanf(params, "d", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /crack [1-3]");
		return 1;
	}
	playerData[playerid][pAnimation] = 1;
	switch(choice) {
		case 1: ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid, "CRACK","crckidle3", 4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid, "CRACK","crckidle4", 4.1, 0, 1, 1, 1, 1, 1);
	}
	return 1;
}
CMD:fuck(playerid,params[]) { ApplyAnimation(playerid,"PED","fucku",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:taichi(playerid,params[]) { 
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"PARK","Tai_Chi_Loop", 4.1, 1, 1, 1, 1, 1, 1); 
	return 1; 
}
CMD:kiss(playerid,params[]) { ApplyAnimation(playerid,"KISSING","Playa_Kiss_01",4.1, 0, 1, 1, 0, 1, 1); return 1; }

CMD:handsup(playerid, params[])//19 1:00 pm , 4/27/2012
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid, "ROB_BANK","SHP_HandsUp_Scr",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}
CMD:cellin(playerid, params[])// 20 1:01 pm, 4/27/2012
{
	if(AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, "�������ö��� Animation ��㹢�й��");
	playerData[playerid][pAnimation] = 1;
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
	return 1;
}
CMD:cellout(playerid, params[])//21 1:02 pm , 4/27/2012
{
	if(AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, "�������ö��� Animation ��㹢�й��");
	playerData[playerid][pAnimation] = 1;
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
	return 1;
}
CMD:bomb(playerid, params[])//23 4/27/2012
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 1, 1, 1, 1, 1); // Place Bomb
	return 1;
}
CMD:getarrested(playerid, params[])//24 4/27/2012
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"ped", "ARRESTgun", 4.1, 0, 1, 1, 1, 1, 1); // Gun Arrest
	return 1;
}
CMD:crossarms(playerid, params[])//28
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 0, 1, 1, 1, 1, 1); // Arms crossed
	return 1;
}

CMD:lay(playerid, params[])//29
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"BEACH", "bather",4.1, 0, 1, 1, 1, 1, 1); // Lay down
	return 1;
}

CMD:foodeat(playerid, params[])//32
{
	ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 1, 1, 1, 1, 1); // Eat Burger
	return 1;
}

CMD:wave(playerid, params[])//33
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.1, 1, 1, 1, 1, 1, 1); // Wave
	return 1;
}

CMD:slapass(playerid, params[])//34
{
	ApplyAnimation(playerid, "SWEET", "sweet_ass_slap", 4.1, 0, 1, 1, 0, 0, 1); // Ass Slapping
 	return 1;
}

CMD:dealer(playerid, params[])//35
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.1, 0, 1, 1, 1, 1, 1); // Deal Drugs
	return 1;
}

CMD:groundsit(playerid, params[])//38
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"BEACH", "ParkSit_M_loop", 4.1, 0, 1, 1, 1, 1, 1); // Sit
	return 1;
}

CMD:chat(playerid, params[])//39
{
	new num;
	if(sscanf(params, "i", num)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /chat [1-2]");
	if(num > 2 || num < 1) { SendClientMessage(playerid, COLOR_GRAD1, "�����: /chat [1-2]"); }
	playerData[playerid][pAnimation] = 1;
	if(num == 1) { ApplyAnimation(playerid,"PED","IDLE_CHAT",4.1, 1, 1, 1, 1, 1, 1); }
	else { ApplyAnimation(playerid,"MISC","Idle_Chat_02",4.1, 1, 1, 1, 1, 1, 1); }
    return 1;
}

CMD:fucku(playerid, params[])//40
{
	ApplyAnimation(playerid,"PED","fucku",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:chairsit(playerid, params[])//42
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"PED","SEAT_idle",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:fall(playerid, params[])//43
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"PED","KO_skid_front",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:fallback(playerid, params[])//44
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid, "PED","FLOOR_hit_f", 4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:injured(playerid, params[])//46
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:sup(playerid, params[])//47
{
	new number;
	if(sscanf(params, "i", number)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /sup [1-3]");
	if(number < 1 || number > 3) { SendClientMessage(playerid, COLOR_GRAD1, "�����: /sup [1-3]"); }
	playerData[playerid][pAnimation] = 1;
	if(number == 1) { ApplyAnimation(playerid,"GANGS","hndshkba",4.1, 0, 1, 1, 1, 1, 1); }
	if(number == 2) { ApplyAnimation(playerid,"GANGS","hndshkda",4.1, 0, 1, 1, 1, 1, 1); }
    if(number == 3) { ApplyAnimation(playerid,"GANGS","hndshkfa_swt",4.1, 0, 1, 1, 1, 1, 1); }
   	return 1;
}

CMD:push(playerid, params[])// 49
{
	ApplyAnimation(playerid,"GANGS","shake_cara",4.1, 0, 1, 1, 0, 1, 1);
    return 1;
}

CMD:akick(playerid, params)// 50
{
	ApplyAnimation(playerid,"POLICE","Door_Kick",4.1, 0, 1, 1, 0, 1, 1);
    return 1;
}

CMD:lowbodypush(playerid, params[])// 51
{
	ApplyAnimation(playerid,"GANGS","shake_carSH",4.1, 0, 1, 1, 0, 0, 1);
    return 1;
}

CMD:spray(playerid, params[])// 52
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"SPRAYCAN","spraycan_full",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:headbutt(playerid, params[])//53
{
	ApplyAnimation(playerid,"WAYFARER","WF_Fwd",4.1, 0, 1, 1, 0, 0, 1);
	return 1;
}

CMD:medic(playerid, params[])//54
{
	ApplyAnimation(playerid,"MEDIC","CPR",4.1, 0, 1, 1, 0, 0, 1);
    return 1;
}

CMD:koface(playerid, params[])//55
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"PED","KO_shot_face",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:kostomach(playerid, params[])//56
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"PED","KO_shot_stom",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:lifejump(playerid, params[])//57
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"PED","EV_dive",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:exhaust(playerid, params[])//58
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"PED","IDLE_tired",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:leftslap(playerid, params[])//59
{
	ApplyAnimation(playerid,"PED","BIKE_elbowL",4.1, 0, 1, 1, 0, 0, 1);
    return 1;
}

CMD:rollfall(playerid, params[])//60
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"PED","BIKE_fallR",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:carlock(playerid, params[])//61
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"PED","CAR_doorlocked_LHS",4.1, 0, 1, 1, 0, 0, 1);
	return 1;
}

CMD:hoodfrisked(playerid, params[])//66
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"POLICE","crm_drgbst_01",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:lightcig(playerid, params[])//67
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"SMOKING","M_smk_in",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:tapcig(playerid, params[])//68
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"SMOKING","M_smk_tap",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:bat(playerid, params[])//69
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"BASEBALL","Bat_IDLE",4.1, 1, 1, 1, 1, 1, 1);
    return 1;
}

CMD:box(playerid, params[])//70
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"GYMNASIUM","GYMshadowbox",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:lay2(playerid, params[])//71
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"SUNBATHE","Lay_Bac_in",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:chant(playerid, params[])//72
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"RIOT","RIOT_CHANT",4.1, 0, 1, 1, 0, 0, 1);
    return 1;
}

CMD:fuckyou(playerid, params[])//73
{
	if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "�������ö��� Animation ��㹢�й��");
    playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"RIOT","RIOT_FUKU",4.1, 0, 1, 1, 0, 0, 1);
    return 1;
}

CMD:fuckyou2(playerid, params[])
{
    if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "�������ö��� Animation ��㹢�й��");
    playerData[playerid][pAnimation] = 1;
    ApplyAnimation(playerid, "RIOT", "RIOT_FUKU", 4.0, 0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:fixcar(playerid, params[])
{
    if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "�������ö��� Animation ��㹢�й��");
    playerData[playerid][pAnimation] = 1;
    ApplyAnimation(playerid, "CAR", "FIXN_CAR_LOOP", 4.1, 0, 0, 0, 1, 0, 0);
    return 1;
}

CMD:fixcarout(playerid, params[])
{
    if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "�������ö��� Animation ��㹢�й��");
    playerData[playerid][pAnimation] = 1;
    ApplyAnimation(playerid, "CAR", "FIXN_CAR_OUT", 4.1, 0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:shouting(playerid, params[])//74
{
	ApplyAnimation(playerid,"RIOT","RIOT_shout",4.1, 0, 1, 1, 0, 0, 1);
    return 1;
}

CMD:cop(playerid,params[])//75
{
	ApplyAnimation(playerid,"SWORD","sword_block",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:elbow(playerid, params[])//76
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"FIGHT_D","FightD_3",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:kneekick(playerid, params[])//77
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"FIGHT_D","FightD_2",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:fstance(playerid, params[])//78
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"FIGHT_D","FightD_IDLE",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:gpunch(playerid, params[])//79
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"FIGHT_B","FightB_G",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:airkick(playerid, params[])//80
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"FIGHT_C","FightC_M",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:gkick(playerid, params[])//81
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"FIGHT_D","FightD_G",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:lowthrow(playerid, params[])//82
{
	ApplyAnimation(playerid,"GRENADE","WEAPON_throwu",4.1, 0, 1, 1, 0, 0, 1);
    return 1;
}

CMD:highthrow(playerid, params[])//83
{
	ApplyAnimation(playerid,"GRENADE","WEAPON_throw",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:dealstance(playerid, params[])//84
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"DEALER","DEALER_IDLE",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:pee(playerid, params[])//85
{
	if(AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, "�������ö��� Animation ��㹢�й��");
	playerData[playerid][pAnimation] = 1;
	SetPlayerSpecialAction(playerid, 68);
    return 1;
}

CMD:knife(playerid, params[])//86
{
	new nbr;
	if(sscanf(params, "i", nbr)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /knife [1-4]");
    if(nbr < 1 || nbr > 4) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /knife [1-4]"); 
	playerData[playerid][pAnimation] = 1;
	switch(nbr)
	{ 
		case 1: { ApplyAnimation(playerid,"KNIFE","KILL_Knife_Ped_Damage",4.1, 0, 1, 1, 1, 1, 1); }
		case 2: { ApplyAnimation(playerid,"KNIFE","KILL_Knife_Ped_Die",4.1, 0, 1, 1, 1, 1, 1); }
		case 3: { ApplyAnimation(playerid,"KNIFE","KILL_Knife_Player",4.1, 0, 1, 1, 1, 1, 1); }
		case 4: { ApplyAnimation(playerid,"KNIFE","KILL_Partial",4.1, 0, 1, 1, 1, 1, 1); }
	}
	return 1;
}

CMD:basket(playerid, params[])//87
{
	new ddr;
	if (sscanf(params, "i", ddr)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /basket [1-6]");
    if(ddr < 1 || ddr > 6) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /basket [1-6]"); 
    playerData[playerid][pAnimation] = 1;
	switch(ddr)
	{
		case 1: { ApplyAnimation(playerid,"BSKTBALL","BBALL_idleloop",4.1, 0, 1, 1, 1, 1, 1); }
		case 2: { ApplyAnimation(playerid,"BSKTBALL","BBALL_Jump_Shot",4.1, 0, 1, 1, 1, 1, 1); }
		case 3: { ApplyAnimation(playerid,"BSKTBALL","BBALL_pickup",4.1, 0, 1, 1, 1, 1, 1); }
		case 4: { ApplyAnimation(playerid,"BSKTBALL","BBALL_run",4.1, 0, 1, 1, 1, 1, 1); }
		case 5: { ApplyAnimation(playerid,"BSKTBALL","BBALL_def_loop",4.1, 1, 1, 1, 1, 1, 1); }
		case 6: { ApplyAnimation(playerid,"BSKTBALL","BBALL_Dnk",4.1, 0, 1, 1, 0, 1, 1); }
	}
   	return 1;
}

CMD:reload(playerid, params[])//88
{
	new result[128];
	if(sscanf(params, "s[24]", result)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /reload [deagle/smg/ak/m4]");
    if(strcmp(result,"deagle", true) == 0)
	{
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"COLT45","colt45_reload",4.1, 0, 1, 1, 1, 1, 1);
    }
    else if(strcmp(result,"smg", true) == 0)
    {
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"UZI","UZI_reload",4.1, 0, 1, 1, 1, 1, 1);
    }
	else if(strcmp(result,"ak", true) == 0)
	{
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"UZI","UZI_reload",4.1, 0, 1, 1, 1, 1, 1);
    }
	else if(strcmp(result,"m4", true) == 0)
	{
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"UZI","UZI_reload",4.1, 0, 1, 1, 1, 1, 1);
    }
   	else { SendClientMessage(playerid, COLOR_GRAD1, "�����: /reload [deagle/smg/ak/m4]"); }
   	return 1;
}

CMD:aim(playerid, params[])//90
{
	new lmb;
	if(sscanf(params, "i", lmb)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /aim [1-3]");
	playerData[playerid][pAnimation] = 1;
	if(lmb == 1) { ApplyAnimation(playerid,"PED","gang_gunstand",4.1, 0, 1, 1, 1, 1, 1); }
    if(lmb == 2) { ApplyAnimation(playerid,"PED","Driveby_L",4.1, 0, 1, 1, 1, 1, 1); }
    if(lmb == 3) { ApplyAnimation(playerid,"PED","Driveby_R",4.1, 0, 1, 1, 1, 1, 1); }
    else { SendClientMessage(playerid, COLOR_GRAD1, "�����: /aim [1-3]"); }
    return 1;
}

CMD:lean(playerid, params[])//91
{
	new mj;
	if(sscanf(params, "i", mj)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /lean [1-2]");
	if(mj < 1 || mj > 2) { SendClientMessage(playerid, COLOR_GRAD1, "�����: /lean [1-2]"); }
    playerData[playerid][pAnimation] = 1;
	if(mj == 1) { ApplyAnimation(playerid,"GANGS","leanIDLE",4.1, 0, 1, 1, 1, 1, 1); }
	if(mj == 2) { ApplyAnimation(playerid,"MISC","Plyrlean_loop",4.1, 0, 1, 1, 1, 1, 1); }
   	return 1;
}

CMD:strip(playerid, params[])//93
{
	new kj;
    if(sscanf(params, "i", kj)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /strip [1-7]");
	if(kj < 1 || kj > 7) { SendClientMessage(playerid, COLOR_GRAD1, "�����: /strip [1-7]"); }
	playerData[playerid][pAnimation] = 1;
	if(kj == 1) { ApplyAnimation(playerid,"STRIP", "strip_A", 4.1, 1, 1, 1, 1, 1, 1 ); }
	if(kj == 2) { ApplyAnimation(playerid,"STRIP", "strip_B", 4.1, 1, 1, 1, 1, 1, 1 ); }
    if(kj == 3) { ApplyAnimation(playerid,"STRIP", "strip_C", 4.1, 1, 1, 1, 1, 1, 1 ); }
    if(kj == 4) { ApplyAnimation(playerid,"STRIP", "strip_D", 4.1, 1, 1, 1, 1, 1, 1 ); }
    if(kj == 5) { ApplyAnimation(playerid,"STRIP", "strip_E", 4.1, 1, 1, 1, 1, 1, 1 ); }
    if(kj == 6) { ApplyAnimation(playerid,"STRIP", "strip_F", 4.1, 1, 1, 1, 1, 1, 1 ); }
    if(kj == 7) { ApplyAnimation(playerid,"STRIP", "strip_G", 4.1, 1, 1, 1, 1, 1, 1 ); }
 	return 1;
}

CMD:inbedright(playerid, params[])//94
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"INT_HOUSE","BED_Loop_R",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:inbedleft(playerid, params[])//95
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"INT_HOUSE","BED_Loop_L",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:wank(playerid, params[])
{
	new choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /wank [1-2]");
		return 1;
	}
	if(strcmp(choice, "1", true) == 0)
	{
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"PAULNMAC","wank_in",4.1, 0, 1, 1, 1, 1, 1);
	}
	if(strcmp(choice, "2", true) == 0)
	{
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"PAULNMAC","wank_loop",4.1, 1, 1, 1, 1, 1, 1);
	}
	return 1;
}

CMD:bj(playerid, params[])
{
	new choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /bj [1-4]");
		return 1;
	}
	if(strcmp(choice, "1", true) == 0)
	{
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_START_P",4.1, 0, 1, 1, 1, 1, 1);
	}
	if(strcmp(choice, "2", true) == 0)
	{
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_START_W",4.1, 0, 1, 1, 1, 1, 1);
	}
	if(strcmp(choice, "3", true) == 0)
	{
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_LOOP_P",4.1, 0, 1, 1, 1, 1, 1);
	}
	if(strcmp(choice, "4", true) == 0)
	{
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_LOOP_W",4.1, 1, 0, 0, 1, 1, 1);

	}
	return 1;
}

CMD:stand(playerid, params[])
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"WUZI","Wuzi_stand_loop", 4.1, 0, 1, 1, 1, 1, 1);
	return 1;
}

CMD:follow(playerid, params[])
{
	ApplyAnimation(playerid,"WUZI","Wuzi_follow",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
    return 1;
}

CMD:getup(playerid, params[])
{
	ApplyAnimation(playerid,"PED","getup",4.1, 0, 1, 1, 0, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}
CMD:slapped(playerid, params[])
{
	ApplyAnimation(playerid,"SWEET","ho_ass_slapped",4.1, 0, 1, 1, 0, 0, 1);
	playerData[playerid][pAnimation] = 1;
    return 1;
}

CMD:win(playerid, params[])
{
	new choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /win [1-2]");
		return 1;
	}
	if(strcmp(choice, "1", true) == 0)
	{
		ApplyAnimation(playerid,"CASINO","cards_win", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	if(strcmp(choice, "2", true) == 0)
	{
		ApplyAnimation(playerid,"CASINO","Roulette_win", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	return 1;
}

CMD:celebrate(playerid, params[])
{
	new choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /celebrate [1-2]");
		return 1;
	}
	if(strcmp(choice, "1", true) == 0)
	{
		ApplyAnimation(playerid,"benchpress","gym_bp_celebrate", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	if(strcmp(choice, "2", true) == 0)
	{
		ApplyAnimation(playerid,"GYMNASIUM","gym_tread_celebrate", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	return 1;
}

CMD:yes(playerid, params[])
{
	ApplyAnimation(playerid,"CLOTHES","CLO_Buy", 4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}

CMD:deal(playerid, params[])
{
	new choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /deal [1-2]");
		return 1;
	}
	if(strcmp(choice, "1", true) == 0)
	{
		ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	if(strcmp(choice, "2", true) == 0)
	{
		ApplyAnimation(playerid,"DEALER","DRUGS_BUY", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	return 1;
}

CMD:thankyou(playerid, params[])
{
	ApplyAnimation(playerid,"FOOD","SHP_Thank", 4.1, 0, 1, 1, 0, 0, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}

CMD:invite1(playerid, params[])
{
	new choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /invite1 [1-2]");
		return 1;
	}
	if(strcmp(choice, "1", true) == 0)
	{
		ApplyAnimation(playerid,"GANGS","Invite_Yes",4.1, 0, 1, 1, 0, 0, 1);
		playerData[playerid][pAnimation] = 1;
	}
	if(strcmp(choice, "2", true) == 0)
	{
		ApplyAnimation(playerid,"GANGS","Invite_No",4.1, 0, 1, 1, 0, 0, 1);
		playerData[playerid][pAnimation] = 1;
	}
	return 1;
}

CMD:scratch(playerid, params[])
{
	ApplyAnimation(playerid,"MISC","Scratchballs_01", 4.1, 0, 1, 1, 0, 0, 1);
	playerData[playerid][pAnimation] = 1;
    return 1;
}
CMD:checkout(playerid, params[])
{
	ApplyAnimation(playerid, "GRAFFITI", "graffiti_Chkout", 4.1, 0, 1, 1, 0, 0, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}
CMD:nod(playerid, params[])
{
	ApplyAnimation(playerid,"COP_AMBIENT","Coplook_nod",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}
CMD:think(playerid, params[])
{
	ApplyAnimation(playerid,"COP_AMBIENT","Coplook_think",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}
CMD:cry(playerid, params[])
{
	new choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /cry [1-2]");
		return 1;
	}
	if(strcmp(choice, "1", true) == 0)
	{
		ApplyAnimation(playerid,"GRAVEYARD","mrnF_loop", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	if(strcmp(choice, "2", true) == 0)
	{
		ApplyAnimation(playerid,"GRAVEYARD","mrnM_loop", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	return 1;
}
CMD:bed(playerid, params[])
{
	new choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /bed [1-2]");
		return 1;
	}
	if(strcmp(choice, "1", true) == 0)
	{
		ApplyAnimation(playerid,"INT_HOUSE","BED_In_L",4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	if(strcmp(choice, "2", true) == 0)
	{
		ApplyAnimation(playerid,"INT_HOUSE","BED_In_R",4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	if(strcmp(choice, "3", true) == 0)
	{
		ApplyAnimation(playerid,"INT_HOUSE","BED_Loop_L", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	if(strcmp(choice, "4", true) == 0)
	{
		ApplyAnimation(playerid,"INT_HOUSE","BED_Loop_R", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	return 1;
}
CMD:carsmoke(playerid, params[])
{
	ApplyAnimation(playerid,"PED","Smoke_in_car", 4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}

CMD:angry(playerid, params[])
{
	ApplyAnimation(playerid,"RIOT","RIOT_ANGRY",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}
CMD:benddown(playerid, params[])
{
	ApplyAnimation(playerid, "BAR", "Barserve_bottle", 4.1, 0, 1, 1, 0, 0, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}
CMD:facepalm(playerid, params[])
{
	ApplyAnimation(playerid, "MISC", "plyr_shkhead", 4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}
CMD:cockgun(playerid, params[])
{
	ApplyAnimation(playerid, "SILENCED", "Silence_reload", 4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}
CMD:bar(playerid, params[])
{
	new choice;
	if(sscanf(params, "d", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /bar [1-12]");
		return 1;
	}
	playerData[playerid][pAnimation] = 1;
	switch(choice) {
		case 1: ApplyAnimation(playerid, "BAR", "Barcustom_get", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid, "BAR","Barcustom_loop", 4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid, "BAR","Barcustom_order", 4.1, 0, 1, 1, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "BAR","BARman_idle", 4.1, 0, 1, 1, 1, 1, 1);
		case 5: ApplyAnimation(playerid, "BAR","Barserve_bottle", 4.1, 0, 1, 1, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "BAR","Barserve_give", 4.1, 0, 1, 1, 0, 0, 1);
		case 7: ApplyAnimation(playerid, "BAR","Barserve_glass", 4.1, 0, 1, 1, 0, 0, 1);
		case 8: ApplyAnimation(playerid, "BAR","Barserve_in", 4.1, 0, 1, 1, 1, 1, 1);
		case 9: ApplyAnimation(playerid, "BAR","Barserve_loop", 4.1, 1, 1, 1, 1, 1, 1);
		case 10: ApplyAnimation(playerid, "BAR","Barserve_order", 4.1, 0, 1, 1, 0, 0, 1);
		case 11: ApplyAnimation(playerid, "BAR","dnk_stndF_loop", 4.1, 0, 1, 1, 1, 1, 1);
		case 12: ApplyAnimation(playerid, "BAR","dnk_stndM_loop", 4.1, 0, 1, 1, 1, 1, 1);
	}
	return 1;
}
CMD:camera(playerid, params[])
{
	new choice;
	if(sscanf(params, "d", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /camera [1-10]");
		return 1;
	}
	playerData[playerid][pAnimation] = 1;
	switch(choice) {
		case 1: ApplyAnimation(playerid,  "CAMERA","camcrch_cmon", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid,  "CAMERA","camcrch_to_camstnd", 4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid,  "CAMERA","camstnd_cmon", 4.1, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimation(playerid,  "CAMERA","camstnd_idleloop", 4.1, 1, 0, 0, 1, 1, 1);
		case 5: ApplyAnimation(playerid,  "CAMERA","camstnd_lkabt", 4.1, 0, 1, 1, 1, 1, 1);
		case 6: ApplyAnimation(playerid,  "CAMERA","piccrch_in", 4.1, 0, 1, 1, 1, 1, 1);
		case 7: ApplyAnimation(playerid,  "CAMERA","piccrch_take", 4.1, 0, 1, 1, 1, 1, 1);
		case 8: ApplyAnimation(playerid,  "CAMERA","picstnd_in", 4.1, 0, 1, 1, 1, 1, 1);
		case 9: ApplyAnimation(playerid, "CAMERA","picstnd_out", 4.1, 0, 1, 1, 1, 1, 1);
		case 10: ApplyAnimation(playerid, "CAMERA","picstnd_take", 4.1, 0, 1, 1, 1, 1, 1);
	}
	return 1;
}

CMD:panic(playerid, params[])
{
	new choice;
	if(sscanf(params, "d", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /panic [1-4]");
		return 1;
	}
	playerData[playerid][pAnimation] = 1;
	switch(choice) {
		case 1: ApplyAnimation(playerid,"ON_LOOKERS","panic_cower", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid,"ON_LOOKERS","panic_hide", 4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid,"ON_LOOKERS","panic_in", 4.1, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimation(playerid,"ON_LOOKERS","panic_loop", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:liftup(playerid, params[])
{
	ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}

CMD:putdown(playerid, params[])
{
	ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}

CMD:joint(playerid, params[])
{
	ApplyAnimation(playerid,"GANGS","smkcig_prtl",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}
CMD:die(playerid, params[])
{
	new choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /die [1-2]");
		return 1;
	}
	if(strcmp(choice, "1", true) == 0)
	{
		ApplyAnimation(playerid,"KNIFE","KILL_Knife_Ped_Die",4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	if(strcmp(choice, "2", true) == 0)
	{
		ApplyAnimation(playerid, "PARACHUTE", "FALL_skyDive_DIE", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	return 1;
}

CMD:lranim(playerid, params[])
{
	if(IsInLowRider(playerid))
	{
		new choice;
		if(sscanf(params, "i", choice))
		{
			SendClientMessage(playerid, COLOR_GRAD1, "�����: /lranim");
			SendClientMessage(playerid, COLOR_GRAD2, "������͡�����: 0-36");
			return 1;
		}
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
		    SendClientMessage(playerid, COLOR_GRAD2, "  �س��ͧ����褹�Ѻö!");
		    return 1;
		}
		playerData[playerid][pAnimation] = 1;
		switch(choice)
		{
		    case 0:
		    {
				ApplyAnimation(playerid, "LOWRIDER", "F_smklean_loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 1:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_bdbnce", 4.0, 0, 0, 0, 1, 0, 1);
		    }
		    case 2:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_hair", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 3:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_hurry", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 4:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_idleloop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 5:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_idle_to_l0", 4.0, 0, 0, 0, 1, 0, 1);
		    }
		    case 6:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l0_bnce", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 7:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l0_loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 8:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l0_to_l1", 4.0, 0, 0, 0, 1, 0, 1);
		    }
		    case 9:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l12_to_l0", 4.0, 0, 0, 0, 1, 0, 1);
		    }
		    case 10:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l1_bnce", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 11:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l1_loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 12:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l1_to_l2", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 13:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l2_bnce", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 14:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l2_loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 15:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l2_to_l3", 4.0, 0, 0, 0, 1, 0, 1);
		    }
		    case 16:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l345_to_l1", 4.0, 0, 0, 0, 1, 0, 1);
		    }
		    case 17:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l3_bnce", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 18:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l3_loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 19:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l3_to_l4", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 20:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l4_bnce", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 21:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l4_loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 22:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l4_to_l5", 4.0, 0, 0, 0, 1, 0, 1);
		    }
		    case 23:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l5_bnce", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 24:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l5_loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 25:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 26:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkB", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 27:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkC", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 28:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkD", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 29:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkF", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 30:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkG", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 31:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkH", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 32:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "RAP_A_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 33:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "RAP_B_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 34:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "RAP_C_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 35:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "Sit_relaxed", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 36:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "Tap_hand", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD2, " �س��ͧ�����ö¹������� Lowrider ���������觹��!");
	}
	return 1;
}

//=====================================[ Roleplay ]============================================

CMD:do(playerid, params[])
{

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD2, "�����: /do [�ʴ�]");

	if (strlen(params) > 80) {
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %.80s", params);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "... %s (( %s ))", params[80], ReturnRealName(playerid));
	}
	else SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s (( %s ))", params, ReturnRealName(playerid));

	return 1;
}

CMD:dolow(playerid, params[])
{

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD2, "�����: /dolow [�ʴ�]");

	if (strlen(params) > 80) {
	    SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %.80s", params);
	    SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "... %s (( %s ))", params[80], ReturnRealName(playerid));
	}
	else SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s (( %s ))", params, ReturnRealName(playerid));

	return 1;
}

alias:local("l", "t");
CMD:local(playerid, params[])
{
    if(gIsDeathMode{playerid} || gIsInjuredMode{playerid})
        return SendClientMessage(playerid, COLOR_GRAD1, "   �س�ź����������ö�ٴ��");

	new str[128];

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD2, "�����: /(l)ocal [��ͤ���]");

	if (strlen(params) > 80) {

	    format(str, sizeof(str), "%s �ٴ���: %.80s", ReturnRealName(playerid), params);
	    ProxDetector(playerid, 20.0, str);

	    format(str, sizeof(str), "... %s", params[80]);
	    ProxDetector(playerid, 20.0, str);
	}
	else format(str, sizeof(str), "%s �ٴ���: %s", ReturnRealName(playerid), params), ProxDetector(playerid, 20.0, str);

    ChatAnimation(playerid, strlen(params));

	return 1;
}

CMD:low(playerid, params[])
{
    if(gIsDeathMode{playerid} || gIsInjuredMode{playerid})
        return SendClientMessage(playerid, COLOR_GRAD1, "   �س�ź����������ö�ٴ��");

	new str[128];

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD2, "�����: /low [��ͤ���]");

	if (strlen(params) > 80) {
	    format(str, sizeof(str), "%s �ٴ��� [��]: %.80s", ReturnRealName(playerid), params);
	    ProxDetector(playerid, 5.0, str);

	    format(str, sizeof(str), "... %s", params[80]);
	    ProxDetector(playerid, 5.0, str);
	}
	else format(str, sizeof(str), "%s �ٴ��� [��]: %s", ReturnRealName(playerid), params), ProxDetector(playerid, 5.0, str);

    ChatAnimation(playerid, strlen(params));

	return 1;
}

alias:shout("s");
CMD:shout(playerid, params[])
{
    if(gIsDeathMode{playerid} || gIsInjuredMode{playerid})
        return SendClientMessage(playerid, COLOR_GRAD1, "   �س�ź����������ö�ٴ��");

    new str[128];

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD2, "�����: /(s)hout [��ͤ���]");

	if (strlen(params) > 80) {
	    format(str, sizeof(str), "%s ��⡹: %.80s", ReturnRealName(playerid), params);
	    ProxDetector(playerid, 30.0, str);

	    format(str, sizeof(str), "... %s!", params[80]);
	    ProxDetector(playerid, 30.0, str);
	}
	else format(str, sizeof(str), "%s ��⡹: %s!", ReturnRealName(playerid), params),ProxDetector(playerid, 30.0, str);

	return 1;
}

CMD:me(playerid, params[])
{
    if(gIsInjuredMode{playerid} || gIsDeathMode{playerid})
		return SendClientMessage(playerid, COLOR_LIGHTRED, "����� /me ��������������������Ҵ��");

	if (isnull(params)) 
		return SendClientMessage(playerid, COLOR_GRAD2, "�����: /me [������]");

	if (strlen(params) > 80) {
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s %.80s", ReturnRealName(playerid), params);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "... %s", params[80]);
	}
	else {
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s %s", ReturnRealName(playerid), params);
	}
	return 1;
}

CMD:ame(playerid, params[])
{
    if(gIsInjuredMode{playerid} || gIsDeathMode{playerid})
		return SendClientMessage(playerid, COLOR_LIGHTRED, "����� /me ��������������������Ҵ��");

	if (isnull(params)) 
		return SendClientMessage(playerid, COLOR_GRAD2, "�����: /ame [������]");
			
	new string[128];
	format(string, sizeof(string), "* %s %s", ReturnRealName(playerid), params);
 	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 6000);
 	SendClientMessage(playerid, COLOR_PURPLE, string);
	
	return 1;
}

CMD:pm(playerid, params[])
{
	new userid, text[128];

    if (sscanf(params, "us[128]", userid, text))
	    return SendClientMessage(playerid, COLOR_GRAD2, "�����: /pm [�ʹռ�����/���ͺҧ��ǹ] [��ͤ���]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if (userid == playerid)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö�觢�ͤ�����ǹ������Ѻ����ͧ��");

	if (BitFlag_Get(gPlayerBitFlag[userid], TOGGLE_PMS) && !playerData[playerid][pAdmin])
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹻Դ��� PMs");

    if (strlen(text) > 80) {
	    SendClientMessageEx(userid, COLOR_PMF, "(( PM �ҡ %s (%d): %.80s", ReturnRealName(playerid), playerid, text);
	    SendClientMessageEx(userid, COLOR_PMF, "... %s ))", text[80]);

	    SendClientMessageEx(playerid, COLOR_PMS, "(( PM �觶֧ %s (%d): %.80s", ReturnRealName(userid), userid, text);
	    SendClientMessageEx(playerid, COLOR_PMS, "... %s ))", text[80]);
	}
	else {
  		SendClientMessageEx(userid, COLOR_PMF, "(( PM �ҡ %s (%d): %s ))", ReturnRealName(playerid), playerid, text);
	    SendClientMessageEx(playerid, COLOR_PMS, "(( PM �觶֧ %s (%d): %s ))", ReturnRealName(userid), userid, text);
	}
	return 1;
}

CMD:togpm(playerid,params[])
{
    if(playerData[playerid][pAdmin] || playerData[playerid][pDonateRank])
    {
        if(!BitFlag_Get(gPlayerBitFlag[playerid], TOGGLE_PMS))
        {
			BitFlag_On(gPlayerBitFlag[playerid], TOGGLE_PMS);
	        SendClientMessage(playerid,COLOR_GREEN,"�Դ����к� PMs");
	        return 1;
		}
		else
		{
			BitFlag_Off(gPlayerBitFlag[playerid], TOGGLE_PMS);
		    SendClientMessage(playerid,COLOR_GREEN,"¡��ԡ��ú��͡�к� PMs ����");
		    return 1;
		}
    }
    else
    {
		SendClientMessage(playerid, COLOR_GRAD1, "   �س������Ѻ͹حҵ��������觹�� (����Ѻ�����蹵�����дѺ�ء������)");
    }
	return 1;
}

CMD:eject(playerid, params[]) {
	new
		targetID;

	if(sscanf(params, "u", targetID))
		return SendClientMessage(playerid, COLOR_GRAD2, "�����: /eject [�ʹռ�����/���ͺҧ��ǹ]");

	if(targetID == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if(targetID == playerid) 
		return SendClientMessage(playerid, COLOR_GRAD2, "�س�������ö������ͧ��");
	    
	if(GetPlayerState(playerid) == 2) {
		if(GetPlayerVehicleID(playerid) == GetPlayerVehicleID(targetID)) {
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ���ѡ %s �͡�ҡ��˹�", ReturnRealName(playerid), ReturnRealName(targetID));
			RemovePlayerFromVehicle(targetID);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "�����蹹��������������㹾�˹�");
	}
	else SendClientMessage(playerid, COLOR_LIGHTRED, "�س��ͧ�����ʶҹм��Ѻö");

	return 1;
}

alias:changeorigin("co");
CMD:changeorigin(playerid, params[]) {
	if (IsPlayerInRangeOfPoint(playerid, 3, 358.7115,178.6364,1008.3828) && (GetPlayerVirtualWorld(playerid) == 2016 || GetPlayerVirtualWorld(playerid) == 2017)) {
		Dialog_Show(playerid, DialogChangeOrigin, DIALOG_STYLE_LIST, "�������ͧ��ѡ (��Һ�ԡ�� $2,500)", "������ѧ���ͧ Los Santos\n������ѧ���ͧ San Fierro", "����", "¡��ԡ");
	}
	else {
		SendClientMessage(playerid, COLOR_GRAD1, "�س��������������ҡ�ҧ�ѧ��Ѵ");
	}
	return 1;
}

Dialog:DialogChangeOrigin(playerid, response, listitem, inputtext[]) {
	if (response) {

		if (GetPlayerMoney(playerid) < 2500) {
			return SendClientMessage(playerid, COLOR_GRAD1, "��ѡ�ҹ �ٴ���: ��ͧ�� $2,500 㹡�ô��Թ�������ͧ���");
		}

		if (listitem == 1) { // 1
			if (playerData[playerid][pSpawnPoint] == 1)
				return SendClientMessage(playerid, COLOR_GRAD1, "��ѡ�ҹ �ٴ���: �س������ͤ�? �س��������������ͧ����������Ǥ��");

			playerData[playerid][pSpawnPoint] = 1;
		}
		else { // 0
			if (playerData[playerid][pSpawnPoint] == 2)
				return SendClientMessage(playerid, COLOR_GRAD1, "��ѡ�ҹ �ٴ���: �س������ͤ�? �س��������������ͧ����������Ǥ��");

			playerData[playerid][pSpawnPoint] = 2;
		}
		GivePlayerMoneyEx(playerid, -2500);
		SendClientMessage(playerid, COLOR_GRAD1, "��ѡ�ҹ �ٴ���: ���Թ������º�������Ǥ��!");
		SendClientMessageEx(playerid, COLOR_YELLOW, "�س��������ѧ���ͧ %s ���º��������������¤�Ҵ��Թ��÷����� $2,500", playerData[playerid][pSpawnPoint] == 2 ? ("Los Santos") : ("San Fierro"));
	}
	return 1;
}


CMD:changepass(playerid, params[])
{
	if (!BitFlag_Get(gPlayerBitFlag[playerid], IS_LOGGED))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "   �س�ѧ������������к�!");
		return 1;
	}

	new newpassword[64];
	if (sscanf(params, "s[64]", newpassword)) {
		return SendClientMessage(playerid, COLOR_GRAD1, "�����: /changepass [���ʼ�ҹ����]");
	}
	else if (strlen(newpassword) > 12) {
		return SendClientMessage(playerid, COLOR_GRAD1, "���ʼ�ҹ��ͧ�դ����������Թ���� 12 ����ѡ��");
	}

	SendClientMessageEx(playerid, COLOR_YELLOW, "���ʼ�ҹ����ͧ�س��� %s ������������", newpassword);

	new
		query[256],
		buffer[129];

	WP_Hash(buffer, sizeof(buffer), newpassword);

	mysql_format(dbCon, query, sizeof(query), "UPDATE `players` SET `Password` = '%e' WHERE `ID` = %d", buffer, playerData[playerid][pSID]);
	mysql_tquery(dbCon, query);

	Log(playerlog, INFO, "%s ������¹���ʼ�ҹ", ReturnPlayerName(playerid));

	return 1;
}

CMD:frisk(playerid, params[])
{
	new userid;

	if(sscanf(params,"u",userid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "�����: /frisk [�ʹռ�����/���ͺҧ��ǹ]");

	if(userid == playerid) return SendClientMessage(playerid, COLOR_LIGHTRED, "�س�������ö�鹵���ͧ��");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if (!IsPlayerNearPlayer(playerid, userid, 3.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������س");


	if (!BitFlag_Get(gPlayerBitFlag[userid], FRISKAPPROVE))
	{
	    SendClientMessageEx(playerid, COLOR_YELLOW,"�س���觤Ӣ͡�ä鹵�� %s", ReturnRealName(userid));
	    SendClientMessage(playerid,COLOR_LIGHTRED,"SERVER: �����蹹���ͧ͹��ѵԡ�ä��Ңͧ�س (/friskapprove)");
	    SendClientMessageEx(userid, COLOR_YELLOW,"%s ��ͧ��ä��Ҥس (/friskapprove)", ReturnRealName(playerid));
	}
	else
	{
	    SendClientMessage(playerid, COLOR_LIGHTBLUE, "___________��觢ͧ�Դ������___________");
	    SendClientMessageEx(playerid, COLOR_WHITE, "����: %s", ReturnRealName(userid));
	    SendClientMessageEx(playerid, COLOR_WHITE, "�Թ����: %s", playerData[userid][pCash] > 500 ? ("���ҡ���� $500") : ("�յ�ӡ��� $500"));
	    SendClientMessageEx(playerid, COLOR_WHITE, "�Թᴧ: %s", FormatNumber(playerData[userid][pRMoney]));
	 	SendClientMessageEx(playerid, COLOR_WHITE, "�Թ�׹: %d", playerData[userid][pMaterials]);

		new Player_Weapons[13], Player_Ammos[13], str_weapons[500];
		for(new i = 1;i <= 12;i++)
		{
			GetPlayerWeaponData(userid,i,Player_Weapons[i],Player_Ammos[i]);

			if(Player_Weapons[i] != 0)
			{
			    if(i == 1) format(str_weapons, 500, "%s%s", str_weapons, ReturnWeaponNameEx(Player_Weapons[i]));
				else format(str_weapons, 500, "%s,%s", str_weapons, ReturnWeaponNameEx(Player_Weapons[i]));
			}
		}
	 	SendClientMessageEx(playerid, COLOR_WHITE, "���ظ: [%s]", strlen(str_weapons) ? str_weapons : "�����");
		
		SendClientMessageEx(playerid, COLOR_WHITE, "���ʾ�Դ: %s", IsHaveDrug(userid) ? ("��") : ("�����"));
		
        SendClientMessage(playerid, COLOR_LIGHTBLUE, "___________________________________");
		BitFlag_Off(gPlayerBitFlag[userid], FRISKAPPROVE);
	}
	return 1;
}


CMD:friskapprove(playerid, params[])
{
	new userid;

	if(sscanf(params,"u",userid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "�����: /friskapprove [�ʹռ�����/���ͺҧ��ǹ]");

	if(userid == playerid) return SendClientMessage(playerid, COLOR_LIGHTRED, "�س�������ö�鹵���ͧ��");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if (!IsPlayerNearPlayer(playerid, userid, 3.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������س");

  	BitFlag_On(gPlayerBitFlag[playerid], FRISKAPPROVE);

    SendClientMessageEx(userid,COLOR_LIGHTRED,"SERVER: ������ %s ����Է���鹵�ǡѺ�س ����� /frisk ������㹢�й��", ReturnRealName(playerid));
    SendClientMessageEx(playerid,COLOR_YELLOW,"�س͹حҵ��� %s �鹵�Ǥس", ReturnRealName(userid));
    return 1;
}

// Event Free Change Name 

CMD:openfreename(playerid, params[])
{
	if (playerData[playerid][pAdmin] < 5)
		return SendClientMessage(playerid, COLOR_GRAD1, "�س����� Development");

 	if(playerData[playerid][pAdmin] >= 5)
	{
		if(systemVariables[EventSystem] == 0)
		{
			systemVariables[EventSystem] = 1;
			SendClientMessage(playerid, COLOR_WHITE, "�س��¡��ԡ�Ԩ��������¹���Ϳ������Ѻ�����蹷���駪��ͼԴ�ٻẺ Firstname_Lastname");
			SendClientMessageToAll(COLOR_YELLOW, "Event ����¹���Ϳ�� (�١¡��ԡ)");
		}
		else
		{
			systemVariables[EventSystem] = 0;
			SendClientMessage(playerid, COLOR_WHITE, "�س���Դ�Ԩ��������¹���Ϳ������Ѻ�����蹷���駪��ͼԴ�ٻẺ Firstname_Lastname");
			SendClientMessageToAll(COLOR_YELLOW, "Event ����¹���Ϳ�� (�١�Դ��ҹ�ա����)");
		}
	}
	else
	{
		return SendClientMessage(playerid, COLOR_GREY, "�س��ͧ������дѺ Lead Administrator �����ҡ����������ѧ��蹹��");
	}

	return 1;
}

CMD:freename(playerid, params[]) // Event Name Change
{
	if (playerData[playerid][pNameChangeFree] != 0)
		return SendClientMessage(playerid, COLOR_GRAD1, "�س����������Ԩ��������¹���Ϳ�����º��������, ��س�����Թ�ҡ�س��ͧ�������¹���� (/donate)");

	if(systemVariables[EventSystem] == 0)
	{
		Dialog_Show(playerid, DialogNameChangeF, DIALOG_STYLE_INPUT, "���͡���ͼ����ͧ�س:","�ٻẺ: "EMBED_ORANGE"Firstname_Lastname"EMBED_DIALOG" (������й��ʡ�ŵ���á��"EMBED_LIGHTRED"������˭�"EMBED_DIALOG"\n�͡������Ǿ������� ����բմ��鹷ҧ�����ҧ������й��ʡ��)","����¹","�͡");
	}
	else return SendClientMessage(playerid, COLOR_GRAD1, "��й��Ԩ�����Դ����, �������ࢵ�ͧ�Ԩ��������¹�������� !!");
	return 1;
}

Dialog:DialogNameChangeF(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return 0;

	if (IsValidRpName(inputtext)) {
	    new
	    	query[80];
	    mysql_format(dbCon, query, sizeof(query), "SELECT `id` FROM `players` WHERE `Name` = '%e' LIMIT 1", inputtext);
	    mysql_pquery(dbCon, query, "isExistUsername", "is", playerid, inputtext);

		playerData[playerid][pNameChangeFree] = 1;
	}
	else {
		Dialog_Show(playerid, DialogNameChangeF, DIALOG_STYLE_INPUT, "���͡���ͼ����ͧ�س:",""EMBED_DIALOG"��Ǩ����ͼԴ��Ҵ: "EMBED_LIGHTRED"���͹���������ö��ҹ��"EMBED_DIALOG"\n\n�ٻẺ: "EMBED_ORANGE"Firstname_Lastname"EMBED_DIALOG" (������й��ʡ�ŵ���á��"EMBED_LIGHTRED"������˭�"EMBED_DIALOG"\n�͡������Ǿ������� ����բմ��鹷ҧ�����ҧ������й��ʡ��)","����¹","�͡");
	}
	return 1;
}

// Bartender System ::
CMD:listdrink(playerid, params[])
{
	SendClientMessage(playerid, COLOR_LIGHTRED, "����ͧ�����ͧ Bartender");

	SendClientMessage(playerid, COLOR_WHITE, "Water - $10");
	SendClientMessage(playerid, COLOR_WHITE, "Hongthong - $300");
	SendClientMessage(playerid, COLOR_WHITE, "Sangasom - $800");
	SendClientMessage(playerid, COLOR_WHITE, "Redlabel - $1,200");
	SendClientMessage(playerid, COLOR_WHITE, "Blacklabel - $2,000");
	SendClientMessage(playerid, COLOR_WHITE, "JackDaniel - $3,500");

	return 1;
}

/*CMD:buydrink(playerid, params[])
{
	new type[24];

	if (!IsPlayerInRangeOfPoint(playerid, 3, -1851.7897, -137.2997, 11.9051))
		return SendClientMessage(playerid, COLOR_GRAD1, "�س��������������");

	if (sscanf(params,"s[24]D(0)S()[16]", type)) {
		SendClientMessage(playerid, COLOR_LIGHTRED, "�����: "EMBED_WHITE"/buydrink [����ͧ�������س��ͧ���]");
        SendClientMessage(playerid, COLOR_WHITE, "�س����ö����� /listdrink ���ʹ�����ͧ��������բ��,����Ҥҷ��س��ͧ����");
		return 1;
	}

	if(!strcmp(type, "Water", true))
	{
        if (playerData[playerid][pCash] < 10)
            return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ���Թ�ҡ���� $10");
 
        GivePlayerMoneyEx(playerid, -10);
		//ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ���������ͧ���� Water �ҡ��ѡ�ҹ����෹���������Ѻ�����Թ $10", ReturnRealName(playerid));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* ��ѡ�ҹ����෹���� : �������ͧ���� Water ����������������Ѻ %s", ReturnRealName(playerid));

		itemVariables[iDrink] += 10;

		new szLabelText[128];
 		format(szLabelText, sizeof(szLabelText), "��ѧ���Թ��ҹ����ͧ����\n�ӹǹ�Թ������� %d", itemVariables[iDrink]);
		UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);

		return 1;
	}

	if(!strcmp(type, "Hongthong", true))
	{
        if (playerData[playerid][pCash] < 300)
            return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ���Թ�ҡ���� $300");
 
        GivePlayerMoneyEx(playerid, -300);
		ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ���������ͧ���� Hongthong �ҡ��ѡ�ҹ����෹���������Ѻ�����Թ $300", ReturnRealName(playerid));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* ��ѡ�ҹ����෹���� : �������ͧ���� Hongthong ����������������Ѻ %s", ReturnRealName(playerid));

		itemVariables[iDrink] += 300;

		new szLabelText[128];
 		format(szLabelText, sizeof(szLabelText), "��ѧ���Թ��ҹ����ͧ����\n�ӹǹ�Թ������� %d", itemVariables[iDrink]);
		UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);

		return 1;
	}

	if(!strcmp(type, "Sangasom", true))
	{
        if (playerData[playerid][pCash] < 800)
            return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ���Թ�ҡ���� $800");
 
        GivePlayerMoneyEx(playerid, -800);
		ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ���������ͧ���� Sangasom �ҡ��ѡ�ҹ����෹���������Ѻ�����Թ $800", ReturnRealName(playerid));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* ��ѡ�ҹ����෹���� : �������ͧ���� Sangasom ����������������Ѻ %s", ReturnRealName(playerid));

		itemVariables[iDrink] += 800;

		new szLabelText[128];
 		format(szLabelText, sizeof(szLabelText), "��ѧ���Թ��ҹ����ͧ����\n�ӹǹ�Թ������� %d", itemVariables[iDrink]);
		UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);


		return 1;
	}

	if(!strcmp(type, "Redlabel", true))
	{
        if (playerData[playerid][pCash] < 1200)
            return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ���Թ�ҡ���� $1200");
 
        GivePlayerMoneyEx(playerid, -1200);
		ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ���������ͧ���� Red Label �ҡ��ѡ�ҹ����෹���������Ѻ�����Թ $1200", ReturnRealName(playerid));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* ��ѡ�ҹ����෹���� : �������ͧ���� Red Label ����������������Ѻ %s", ReturnRealName(playerid));

		itemVariables[iDrink] += 1200;

		new szLabelText[128];
 		format(szLabelText, sizeof(szLabelText), "��ѧ���Թ��ҹ����ͧ����\n�ӹǹ�Թ������� %d", itemVariables[iDrink]);
		UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);


		return 1;
	}

	if(!strcmp(type, "Blacklabel", true))
	{
        if (playerData[playerid][pCash] < 2000)
            return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ���Թ�ҡ���� $2000");
 
        GivePlayerMoneyEx(playerid, -2000);
		ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ���������ͧ���� Black Label �ҡ��ѡ�ҹ����෹���������Ѻ�����Թ $2000", ReturnRealName(playerid));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* ��ѡ�ҹ����෹���� : �������ͧ���� Black Label ����������������Ѻ %s", ReturnRealName(playerid));

		itemVariables[iDrink] += 2000;

		new szLabelText[128];
 		format(szLabelText, sizeof(szLabelText), "��ѧ���Թ��ҹ����ͧ����\n�ӹǹ�Թ������� %d", itemVariables[iDrink]);
		UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);


		return 1;
	}

	if(!strcmp(type, "JackDaniel", true))
	{
        if (playerData[playerid][pCash] < 3500)
            return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ���Թ�ҡ���� $3500");
 
        GivePlayerMoneyEx(playerid, -3500);
		ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ���������ͧ���� Jack Daniel �ҡ��ѡ�ҹ����෹���������Ѻ�����Թ $3500", ReturnRealName(playerid));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* ��ѡ�ҹ����෹���� : �������ͧ���� Jack Daniel ����������������Ѻ %s", ReturnRealName(playerid));

		itemVariables[iDrink] += 3500;

		new szLabelText[128];
 		format(szLabelText, sizeof(szLabelText), "��ѧ���Թ��ҹ����ͧ����\n�ӹǹ�Թ������� %d", itemVariables[iDrink]);
		UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);

		return 1;
	}
	return 1;
}*/

CMD:detain(playerid, params[]) {
	new
		seat,
		targetID;

	if(sscanf(params, "ud", targetID, seat))
		return SendClientMessage(playerid, COLOR_GRAD1, "�����: /detain [playerid] [����� (1-3)]");

	if(playerData[targetID][pFreezeType] == 4) {
		if(seat > 0 && seat < 4) {
			if(IsPlayerInRangeOfPlayer(playerid, targetID, 5.0) && IsPlayerInRangeOfVehicle(playerid, GetClosestVehicle(playerid), 5.0)) {

				new
					detaintarget = GetClosestVehicle(playerid);

				if(checkVehicleSeat(detaintarget, seat) != 0) SendClientMessage(playerid, COLOR_GREY, "�����Ţ ID ����������ҧ");

				else {

					SendNearbyMessage(playerid, 25.0, COLOR_PURPLE, "* %s �١���¡���ö���� %s", ReturnRealName(targetID), ReturnRealName(playerid));
					PutPlayerInVehicle(targetID, detaintarget, seat);
				}
			}
			else SendClientMessage(playerid, COLOR_GRAD1, "�س���ö��ͧ�������Ѻ�����س�ФǺ�����Ǣ��ö");
	    }
	}
	return 1;
}
