/*
//--------------------------------[TUTORIAL.PWN]--------------------------------
*/

#include <YSI\y_hooks> 


hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetPVarInt(playerid, "TutorialStep"))
	{
	    if(RELEASED(KEY_SPRINT)) // �����¹仢�ҧ˹��
	    {
			NextTutorial(playerid);
	    }
	    else if(RELEASED(KEY_JUMP)) // �����¹�����ѧ
	    {
	        PreviewTutorial(playerid);
	    }
    }
	return 1;
}


initiateTutorial(playerid)
{
    ClearChatBox(playerid);
	SetPVarInt(playerid, "TutorialStep", 1);
    SendClientMessage(playerid, -1, "� �Թ�յ�͹�Ѻ������ SA:RP");
    SendClientMessageEx(playerid, COLOR_GRAD, "�����¹�մԷ�ȹ�����йӤس����Ѻ�����á�� %s", playerData[playerid][pSpawnPoint] == 2 ? ("Los Santos") : ("San Fierro"));
    SendClientMessage(playerid, COLOR_GRAD, "��Ң��й����س��������ҹ�ѹ");
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);

	if (playerData[playerid][pSpawnPoint] == 2) {
		SetPlayerCameraPos(playerid, 1541.1512,-2287.1345,91.9661);
		SetPlayerCameraLookAt(playerid, 1623.3582,-2288.0413,77.9914);
	}
	else {
		SetPlayerCameraPos(playerid, -2564.2397,-816.2410,229.4705);
		SetPlayerCameraLookAt(playerid, -2506.4133,-704.2995,192.9581);
	}

	Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
	return 1;
}

Dialog:DialogTutorial(playerid, response, listitem, inputtext[]) {
	if (!response) {
		NextTutorial(playerid);
	}
	else {
		PreviewTutorial(playerid);
	}
	return 1;
}
/*
hook OnPlayerText(playerid, text[]) {
	if(GetPVarInt(playerid, "TutorialStep"))
	{
	    if(isequal(text, ">")) // �����¹仢�ҧ˹��
	    {
			NextTutorial(playerid);
	    }
	    else if(isequal(text, "<")) // �����¹�����ѧ
	    {
	        PreviewTutorial(playerid);
	    }
		return -1;
    }
	return 0;
}*/

NextTutorial(playerid) {

	SetPVarInt(playerid, "TutorialStep", GetPVarInt(playerid, "TutorialStep")+1);
	ClearChatBox(playerid);

	if (playerData[playerid][pSpawnPoint] == 2) {
		switch(GetPVarInt(playerid, "TutorialStep"))
    	{
    	    case 2: {

			    SendClientMessage(playerid, COLOR_GRAD3, "���˹ѧ��;����������Դ�Ѻ El Corona Motel �ش�Դ㹻Ѩ�غѹ�ͧ�س");
			    SendClientMessage(playerid, COLOR_GRAD3, "价������ͧ���� 'i' ��о���� /newspaper ������ҹ");

			    SendClientMessage(playerid, COLOR_WHITE, "");
			    SendClientMessage(playerid, COLOR_WHITE, "");
			    SendClientMessage(playerid, COLOR_WHITE, "");
			    SendClientMessage(playerid, COLOR_WHITE, "");

			    SendClientMessage(playerid, COLOR_WHITE, "� �����á����ͧ���᫹��");
			    SendClientMessage(playerid, COLOR_GRAD3, "�Թ�յ�͹�Ѻ���������ͧ���᫹�� ���ͧ����˭����ش��Ѱ�ҹ�͹�����");
			    SendClientMessage(playerid, COLOR_GRAD3, "��й��س����������� El Corona Motel �����Ҥس����ʶҹ�����ա��Ҵ��µ�Ǥس�ͧ");
			    SendClientMessage(playerid, COLOR_GRAD3, "�س�Ҩ��ͧ��÷���������鹴��¡����ҹ˹ѧ��;����ͧ�ѹ��� ���س����ö�Ң����źҧ���ҧ����繻���ª��");

    	        InterpolateCameraPos(playerid, 1541.1512,-2287.1345,91.9661, 1715.7267,-1932.2345,20.3447, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 1623.3582,-2288.0413,77.9914, 1731.9973,-1912.0378,13.5624, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 1715.7267,-1932.2345,20.3447, 1731.9973,-1912.0378,13.5624);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
    	    case 3: {

			    SendClientMessage(playerid, COLOR_WHITE, "� ��â���");
			    SendClientMessage(playerid, COLOR_GRAD3, "��������͹�����ͺ � ���ͧ �س�е�ͧ�ҵ���ͧ���ö");
			    SendClientMessage(playerid, COLOR_GRAD3, "�س����ö��ö������¡�硫���������ö ������Թ�ӹǹ˹��");
			    SendClientMessage(playerid, COLOR_GRAD3, "�� 544 �������ԡ���硫��������ö��ʵ���ٸ ö¹������������ö�����ͺ � ���ͧ");

    	        GameTextForPlayer(playerid, "~p~/call 544 ~w~to call~n~~y~los santos & san fierro public transportation service", 20000, 3);

    	        InterpolateCameraPos(playerid, 1715.7267,-1932.2345,20.3447, 1807.2902,-1939.7085,67.2748, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 1731.9973,-1912.0378,13.5624, 1773.8251,-1902.2825,13.5502, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 1807.2902,-1939.7085,67.2748, 1773.8251,-1902.2825,13.5502);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
    	    case 4: {

			    SendClientMessage(playerid, COLOR_WHITE, "� ��������µ���ͧ");
			    SendClientMessage(playerid, COLOR_GRAD3, "����ͤس����֡����ѹ�֧���ҷ��������͡�ҡ El Corona Motel ��ѧʶҹ���ͧ�س�ͧ �س���������ͧ�Һ�ҹ������������ŷ�����");
			    SendClientMessage(playerid, COLOR_GRAD3, "�պ�ҹ�ҡ������������ͺ � ���ͧ���᫹�� �������ö�������������ء���¡���š����¹�Թ�ҧ��ǹ��ҹ��");
			    SendClientMessage(playerid, COLOR_GRAD3, "�͡�ҡ����ѧ��������ç������������ͺ � ���ͧ���س����ö�����ͧ�ѡ����ҧ��ǧ");

    	        GameTextForPlayer(playerid, "~y~Idlewood motel~n~~w~(~p~/rent~w~) or (~p~/rentroom~w~)", 20000, 3);

    	        InterpolateCameraPos(playerid, 1807.2902,-1939.7085,67.2748, 2119.4541,-1751.1744,21.5524, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 1773.8251,-1902.2825,13.5502, 2155.6519,-1776.4888,18.5486, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 2119.4541,-1751.1744,21.5524, 2155.6519,-1776.4888,18.5486);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
    	    case 5: {

			    SendClientMessage(playerid, COLOR_WHITE, "� �ѡ���آ�Ҿ");
			    SendClientMessage(playerid, COLOR_GRAD3, "���������������Ե�ͧ�س���آ�Ҿ������СԹ���ç���� �س��������٭���� HP ���ҧ������ͧ����͵���Фâͧ�س���");
			    SendClientMessage(playerid, COLOR_GRAD3, "��������ʾ�Դ�ѹ�Ҩ��Ŵ HP �ͧ�س �����дѺ������Ǣͧ�س ����ѧ�з����س�����������ª��Ե");
			    SendClientMessage(playerid, COLOR_GRAD3, "����ҹ�����������觷������ͧ���س����ö�Թ�������� HP �ͧ�س���Ŵ�дѺ������Ǣͧ�س");

    	        GameTextForPlayer(playerid, "~y~Idlewood pizza stack~n~~w~(~p~/eat~w~)", 20000, 3);

    	        InterpolateCameraPos(playerid, 2119.4541,-1751.1744,21.5524, 2070.5469,-1834.5552,30.9983, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 2155.6519,-1776.4888,18.5486, 2108.1138,-1779.3624,13.3898, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 2070.5469,-1834.5552,30.9983, 2108.1138,-1779.3624,13.3898);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
    	    case 6: {

			    SendClientMessage(playerid, COLOR_WHITE, "� ��ԡ���Ҹ�ó�");
				SendClientMessage(playerid, COLOR_GRAD, "�ҹ��ԡ���Ҹ�ó�������ͧ���᫹�ʡ礧����ԡ������ �����������س��ͧ�������ԡ�þǡ��");
    	        SendClientMessage(playerid, COLOR_GRAD, "��鹡��� {8D8DFF}Los Santos & San Fierro Police Department");
				SendClientMessage(playerid, COLOR_GRAD, "{FF8282}Los Santos & San Fierro Fire Department"EMBED_GRAD" ��˹��㹡���Ѻ�Դ�ͺ��ҹ�ѡ���آ�Ҿ��Ъ�������ͻ����Һ�ż���纻��� ");
    	        SendClientMessage(playerid, COLOR_GRAD, "�ǡ�һ���ҹ�ҹ�Ѻ�ç��Һ�����˹��¡����·�駤��");
				SendClientMessage(playerid, COLOR_GRAD, "��Ҥس��ͧ���˹��§ҹ��ѧ�����㹵�����͹����������ѧ�š�س������͵Դ���价�� 911 ������¡�ǡ����������Ҫ�������ͤس");

    	        GameTextForPlayer(playerid, "~w~San Andreas~n~Department", 4000, 3);

    	        InterpolateCameraPos(playerid, 1744.5216,-1693.8655,52.5560, 667.7610,-608.4394,38.1223, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 1774.4377,-1658.4363,30.9402, 618.0063,-574.8521,26.1432, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 667.7610,-608.4394,38.1223, 618.0063,-574.8521,26.1432);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
    	    case 7: {
			    SendClientMessage(playerid, COLOR_WHITE, "� �����ػ:");
			    SendClientMessage(playerid, COLOR_GRAD3, "��ͧ�������������Ҥس��ͧ��ԺѵԵ�����ͧ���������ء�����������þ�������õ�������蹷ء����пѧ���йӨҡ���������������");
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 8: { // End Tutorial
				DeletePVar(playerid, "TutorialStep");
				SendClientMessage(playerid, COLOR_GRAD, "�س���Ѻ�����¹�մԷ�ȹ����º��������");
				Dialog_Close(playerid);
				Dialog_Show(playerid, StarterModel, DIALOG_STYLE_LIST, "�ô���͡ʡԹ������鹢ͧ�س", "����Ф��Ȫ��\n����Ф���˭ԧ", "���͡", "");
			}
    	}
	}
	else {
		switch(GetPVarInt(playerid, "TutorialStep"))
		{
			case 2: {

				SendClientMessage(playerid, COLOR_GRAD, "���˹ѧ��;����������Դ�Ѻ Doherty Motel �ش�Դ㹻Ѩ�غѹ�ͧ�س");
				SendClientMessage(playerid, COLOR_GRAD, "价������ͧ���� 'i' ��о���� /newspaper ������ҹ");

				SendClientMessage(playerid, -1, "");
				SendClientMessage(playerid, -1, "");
				SendClientMessage(playerid, -1, "");
				SendClientMessage(playerid, -1, "");


				SendClientMessage(playerid, -1, "� �����á����ͧ San Fierro");
				SendClientMessage(playerid, COLOR_GRAD, "�Թ�յ�͹�Ѻ���������ͧ᫹������ ���ͧ�����硷���ش��Ѱ�ҹ�͹�����");
				SendClientMessage(playerid, COLOR_GRAD, "��й��س����������� Doherty Motel �����Ҥس����ʶҹ�����ա��Ҵ��µ�Ǥس�ͧ");
				SendClientMessage(playerid, COLOR_GRAD, "�س�Ҩ��ͧ��÷���������鹴��¡����ҹ˹ѧ��;����ͧ�ѹ��� ���س����ö�Ң����źҧ���ҧ����繻���ª��");

				InterpolateCameraPos(playerid, -2564.2397,-816.2410,229.4705, -2012.8434,-73.1334,48.6836, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -2506.4133,-704.2995,192.9581, -2027.7747,-41.3567,38.8047, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -2012.8434,-73.1334,48.6836, -2027.7747,-41.3567,38.8047);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 3: {

				SendClientMessage(playerid, -1, "� ��â���");
				SendClientMessage(playerid, COLOR_GRAD, "��������͹�����ͺ � ���ͧ �س�е�ͧ�ҵ���ͧ���ö");
				SendClientMessage(playerid, COLOR_GRAD, "�س����ö��ö������¡�硫���������ö ������Թ�ӹǹ˹��");
				SendClientMessage(playerid, COLOR_GRAD, "�� 544 �������ԡ���硫��������ö��ʵ���ٸ ö¹������������ö�����ͺ � ���ͧ");

				GameTextForPlayer(playerid, "~p~/call 544 ~w~to call~n~~y~san fierro public transportation service", 20000, 3);

				InterpolateCameraPos(playerid, -2012.8434,-73.1334,48.6836, -2078.0098,32.5450,45.9552, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -2027.7747,-41.3567,38.8047, -2055.3335,8.0542,35.3281, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -2078.0098,32.5450,45.9552, -2055.3335,8.0542,35.3281);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 4: {

				SendClientMessage(playerid, -1, "� ��������µ���ͧ");
				SendClientMessage(playerid, COLOR_GRAD, "����ͤس����֡����ѹ�֧���ҷ��������͡�ҡ Doherty Motel ��ѧʶҹ���ͧ�س�ͧ �س���������ͧ�Һ�ҹ������������ŷ�����");
				SendClientMessage(playerid, COLOR_GRAD, "�պ�ҹ�ҡ������������ͺ � ���ͧ᫹������ �������ö�������������ء���¡���š����¹�Թ�ҧ��ǹ��ҹ��");
				SendClientMessage(playerid, COLOR_GRAD, "�͡�ҡ����ѧ��������ç������������ͺ � ���ͧ���س����ö�����ͧ�ѡ����ҧ��ǧ");

				GameTextForPlayer(playerid, "~y~Garcia Motel~n~~w~(~p~/rent~w~) or (~p~/rentroom~w~)", 20000, 3);

				InterpolateCameraPos(playerid, -2078.0098,32.5450,45.9552, -2154.9983,-65.2416,45.5149, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -2055.3335,8.0542,35.3281, -2176.3682,-42.3011,35.3125, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -2154.9983,-65.2416,45.5149, -2176.3682,-42.3011,35.3125);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 5: {

				SendClientMessage(playerid, -1, "� �ѡ���آ�Ҿ");
				SendClientMessage(playerid, COLOR_GRAD, "���������������Ե�ͧ�س���آ�Ҿ������СԹ���ç���� �س��������٭���� HP ���ҧ������ͧ����͵���Фâͧ�س���");
				SendClientMessage(playerid, COLOR_GRAD, "��������ʾ�Դ�ѹ�Ҩ��Ŵ HP �ͧ�س �����дѺ������Ǣͧ�س ����ѧ�з����س�����������ª��Ե");
				SendClientMessage(playerid, COLOR_GRAD, "����ҹ�����������觷������ͧ���س����ö�Թ�������� HP �ͧ�س���Ŵ�дѺ������Ǣͧ�س");

				GameTextForPlayer(playerid, "~y~Garcia Burger Shot~n~~w~(~p~/eat~w~)", 20000, 3);

				InterpolateCameraPos(playerid, -2154.9983,-65.2416,45.5149, -2292.7346,-197.3345,55.2711, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -2176.3682,-42.3011,35.3125, -2336.6841,-166.7888,35.5547, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -2292.7346,-197.3345,55.2711, -2336.6841,-166.7888,35.5547);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 6: {

				SendClientMessage(playerid, -1, "� ����Թ");
				SendClientMessage(playerid, COLOR_GRAD, "�ѧ���ͧ���ͧ᫹������ ��ҧ����ҧ���͡����Ե���������ҡ����ҧἹ����Թ����");
				SendClientMessage(playerid, COLOR_GRAD, "�س������й��Թ��͹�ҽҡ�Ѻ��Ҥ�������Ѻ�͡���·���ҡ���������? ���ͨй����ع㹪��Ե��Ш��ѹ��͹");
				SendClientMessage(playerid, COLOR_GRAD, "");

				GameTextForPlayer(playerid, "~w~Central Bank of San Fierro", 4000, 3);

				InterpolateCameraPos(playerid, -2292.7346,-197.3345,55.2711, -1597.3508,848.2234,17.7428, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -2336.6841,-166.7888,35.5547, -1619.1672,865.4321,7.6953, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -1597.3508,848.2234,17.7428, -1619.1672,865.4321,7.6953);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 7: {
				SendClientMessage(playerid, -1, "� �����ػ:");
				SendClientMessage(playerid, COLOR_GRAD, "��ͧ�������������Ҥس��ͧ��ԺѵԵ�����ͧ���������ء�����������þ�������õ�������蹷ء����пѧ���йӨҡ���������������");

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", "���մԷ�ȹ�", GetPVarInt(playerid, "TutorialStep"));
			}
			case 8: { // End Tutorial

				DeletePVar(playerid, "TutorialStep");
				SendClientMessage(playerid, COLOR_GRAD, "�س���Ѻ�����¹�մԷ�ȹ����º��������");
				Dialog_Close(playerid);
				Dialog_Show(playerid, StarterModel, DIALOG_STYLE_LIST, "�ô���͡ʡԹ������鹢ͧ�س", "����Ф��Ȫ��\n����Ф���˭ԧ", "���͡", "");
			}
		}
	}
	return 1;
}

PreviewTutorial(playerid) {
	if(GetPVarInt(playerid, "TutorialStep") == 1)
	{
	    PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
	    return 1;
	}

	SetPVarInt(playerid, "TutorialStep", GetPVarInt(playerid, "TutorialStep")-1);
 	ClearChatBox(playerid);

	if (playerData[playerid][pSpawnPoint] == 2) {
		switch(GetPVarInt(playerid, "TutorialStep"))
    	{
    	    case 1: {
			    SendClientMessage(playerid, COLOR_WHITE, "");
			    SendClientMessage(playerid, COLOR_GRAD3, "�����¹�մԷ�ȹ�����йӤس����Ѻ�����á�� Los Santos");
			    SendClientMessage(playerid, COLOR_GRAD3, "��Ң��й����س��������ҹ�ѹ");

    	        InterpolateCameraPos(playerid, 1715.7267,-1932.2345,20.3447, 1541.1512,-2287.1345,91.9661, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 1731.9973,-1912.0378,13.5624, 1623.3582,-2288.0413,77.9914, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 1541.1512,-2287.1345,91.9661, 1623.3582,-2288.0413,77.9914);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
    	    case 2: {
			
			    SendClientMessage(playerid, COLOR_GRAD3, "���˹ѧ��;����������Դ�Ѻ El Corona Motel �ش�Դ㹻Ѩ�غѹ�ͧ�س");
			    SendClientMessage(playerid, COLOR_GRAD3, "价������ͧ���� 'i' ��о���� /newspaper ������ҹ");

			    SendClientMessage(playerid, COLOR_WHITE, "");
			    SendClientMessage(playerid, COLOR_WHITE, "");
			    SendClientMessage(playerid, COLOR_WHITE, "");
			    SendClientMessage(playerid, COLOR_WHITE, "");

			    SendClientMessage(playerid, COLOR_WHITE, "� �����á����ͧ���᫹��");
			    SendClientMessage(playerid, COLOR_GRAD3, "�Թ�յ�͹�Ѻ���������ͧ���᫹�� ���ͧ����˭����ش��Ѱ�ҹ�͹�����");
			    SendClientMessage(playerid, COLOR_GRAD3, "��й��س����������� El Corona Motel �����Ҥس����ʶҹ�����ա��Ҵ��µ�Ǥس�ͧ");
			    SendClientMessage(playerid, COLOR_GRAD3, "�س�Ҩ��ͧ��÷���������鹴��¡����ҹ˹ѧ��;����ͧ�ѹ��� ���س����ö�Ң����źҧ���ҧ����繻���ª��");

    	        InterpolateCameraPos(playerid, 1807.2902,-1939.7085,67.2748, 1715.7267,-1932.2345,20.3447, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 1773.8251,-1902.2825,13.5502, 1731.9973,-1912.0378,13.5624, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 1715.7267,-1932.2345,20.3447, 1731.9973,-1912.0378,13.5624);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));

			}
    	    case 3: {

			    SendClientMessage(playerid, COLOR_WHITE, "� ��â���");
			    SendClientMessage(playerid, COLOR_GRAD3, "��������͹�����ͺ � ���ͧ �س�е�ͧ�ҵ���ͧ���ö");
			    SendClientMessage(playerid, COLOR_GRAD3, "�س����ö��ö������¡�硫���������ö ������Թ�ӹǹ˹��");
			    SendClientMessage(playerid, COLOR_GRAD3, "�� 544 �������ԡ���硫��������ö��ʵ���ٸ ö¹������������ö�����ͺ � ���ͧ");

    	        GameTextForPlayer(playerid, "~p~/call 544 ~w~to call~n~~y~los santos & san fieror public transportation service", 20000, 3);

    	        InterpolateCameraPos(playerid, 2119.4541,-1751.1744,21.5524, 1807.2902,-1939.7085,67.2748, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 2155.6519,-1776.4888,18.5486, 1773.8251,-1902.2825,13.5502, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 1807.2902,-1939.7085,67.2748, 1773.8251,-1902.2825,13.5502);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
    	    case 4: {

			    SendClientMessage(playerid, COLOR_WHITE, "� ��������µ���ͧ");
			    SendClientMessage(playerid, COLOR_GRAD3, "����ͤس����֡����ѹ�֧���ҷ��������͡�ҡ El Corona Motel ��ѧʶҹ���ͧ�س�ͧ �س���������ͧ�Һ�ҹ������������ŷ�����");
			    SendClientMessage(playerid, COLOR_GRAD3, "�պ�ҹ�ҡ������������ͺ � ���ͧ���᫹�� �������ö�������������ء���¡���š����¹�Թ�ҧ��ǹ��ҹ��");
			    SendClientMessage(playerid, COLOR_GRAD3, "�͡�ҡ����ѧ��������ç������������ͺ � ���ͧ���س����ö�����ͧ�ѡ����ҧ��ǧ");

    	        GameTextForPlayer(playerid, "~y~Idlewood motel~n~~w~(~p~/rent~w~) or (~p~/rentroom~w~)", 20000, 3);

    	        InterpolateCameraPos(playerid, 2070.5469,-1834.5552,30.9983, 2119.4541,-1751.1744,21.5524, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 2108.1138,-1779.3624,13.3898, 2155.6519,-1776.4888,18.5486, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 2119.4541,-1751.1744,21.5524, 2155.6519,-1776.4888,18.5486);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
    	    case 5: {

			    SendClientMessage(playerid, COLOR_WHITE, "� �ѡ���آ�Ҿ");
			    SendClientMessage(playerid, COLOR_GRAD3, "���������������Ե�ͧ�س���آ�Ҿ������СԹ���ç���� �س��������٭���� HP ���ҧ������ͧ����͵���Фâͧ�س���");
			    SendClientMessage(playerid, COLOR_GRAD3, "��������ʾ�Դ�ѹ�Ҩ��Ŵ HP �ͧ�س �����дѺ������Ǣͧ�س ����ѧ�з����س�����������ª��Ե");
			    SendClientMessage(playerid, COLOR_GRAD3, "����ҹ�����������觷������ͧ���س����ö�Թ�������� HP �ͧ�س���Ŵ�дѺ������Ǣͧ�س");

				GameTextForPlayer(playerid, "~y~Idlewood pizza stack~n~~w~(~p~/eat~w~)", 20000, 3);

    	        InterpolateCameraPos(playerid, 1129.1364,-1359.0806,60.4063, 2070.5469,-1834.5552,30.9983, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 1129.1011,-1488.4135,22.7614, 2108.1138,-1779.3624,13.3898, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 2070.5469,-1834.5552,30.9983, 2108.1138,-1779.3624,13.3898);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
    	    case 6: {
			    SendClientMessage(playerid, COLOR_WHITE, "� ��ԡ���Ҹ�ó�");
				SendClientMessage(playerid, COLOR_GRAD, "�ҹ��ԡ���Ҹ�ó�������ͧ���᫹�ʡ礧����ԡ������ �����������س��ͧ�������ԡ�þǡ��");
    	        SendClientMessage(playerid, COLOR_GRAD, "��鹡��� {8D8DFF}Los Santos & San Fierro Police Department");
				SendClientMessage(playerid, COLOR_GRAD, "{FF8282}Los Santos & San Fierro Fire Department"EMBED_GRAD" ��˹��㹡���Ѻ�Դ�ͺ��ҹ�ѡ���آ�Ҿ��Ъ�������ͻ����Һ�ż���纻��� ");
    	        SendClientMessage(playerid, COLOR_GRAD, "�ǡ�һ���ҹ�ҹ�Ѻ�ç��Һ�����˹��¡����·�駤��");
				SendClientMessage(playerid, COLOR_GRAD, "��Ҥس��ͧ���˹��§ҹ��ѧ�����㹵�����͹����������ѧ�š�س������͵Դ���价�� 911 ������¡�ǡ����������Ҫ�������ͤس");

    	        GameTextForPlayer(playerid, "~w~San Andreas~n~Department", 4000, 3);

    	        InterpolateCameraPos(playerid, 1474.6232,-1723.1591,42.9895, 667.7610,-608.4394,38.1223, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 1480.6512,-1771.0350,31.6094, 618.0063,-574.8521,26.1432, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 667.7610,-608.4394,38.1223, 618.0063,-574.8521,26.1432);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
		}
	}
	else {
		switch(GetPVarInt(playerid, "TutorialStep"))
		{
			case 1: {
				SendClientMessage(playerid, -1, "� �Թ�յ�͹�Ѻ������ SA:RP");
				SendClientMessage(playerid, COLOR_GRAD, "�����¹�մԷ�ȹ�����йӤس����Ѻ�����á�� San Fierro");
				SendClientMessage(playerid, COLOR_GRAD, "��Ң��й����س��������ҹ�ѹ");

				InterpolateCameraPos(playerid, -2012.8434,-73.1334,48.6836, -2564.2397,-816.2410,229.4705, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -2027.7747,-41.3567,38.8047, -2506.4133,-704.2995,192.9581, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -2564.2397,-816.2410,229.4705, -2506.4133,-704.2995,192.9581);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 2: {

				SendClientMessage(playerid, COLOR_GRAD, "���˹ѧ��;����������Դ�Ѻ Doherty Motel �ش�Դ㹻Ѩ�غѹ�ͧ�س");
				SendClientMessage(playerid, COLOR_GRAD, "价������ͧ���� 'i' ��о���� /newspaper ������ҹ");

				SendClientMessage(playerid, -1, "");
				SendClientMessage(playerid, -1, "");
				SendClientMessage(playerid, -1, "");
				SendClientMessage(playerid, -1, "");


				SendClientMessage(playerid, -1, "� �����á����ͧ San Fierro");
				SendClientMessage(playerid, COLOR_GRAD, "�Թ�յ�͹�Ѻ���������ͧ᫹������ ���ͧ�����硷���ش��Ѱ�ҹ�͹�����");
				SendClientMessage(playerid, COLOR_GRAD, "��й��س����������� Doherty Motel �����Ҥس����ʶҹ�����ա��Ҵ��µ�Ǥس�ͧ");
				SendClientMessage(playerid, COLOR_GRAD, "�س�Ҩ��ͧ��÷���������鹴��¡����ҹ˹ѧ��;����ͧ�ѹ��� ���س����ö�Ң����źҧ���ҧ����繻���ª��");

				InterpolateCameraPos(playerid, -2078.0098,32.5450,45.9552, -2012.8434,-73.1334,48.6836, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -2055.3335,8.0542,35.3281, -2027.7747,-41.3567,38.8047, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -2012.8434,-73.1334,48.6836, -2027.7747,-41.3567,38.8047);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 3: {

				SendClientMessage(playerid, -1, "� ��â���");
				SendClientMessage(playerid, COLOR_GRAD, "��������͹�����ͺ � ���ͧ �س�е�ͧ�ҵ���ͧ���ö");
				SendClientMessage(playerid, COLOR_GRAD, "�س����ö��ö������¡�硫���������ö ������Թ�ӹǹ˹��");
				SendClientMessage(playerid, COLOR_GRAD, "�� 544 �������ԡ���硫��������ö��ʵ���ٸ ö¹������������ö�����ͺ � ���ͧ");

				GameTextForPlayer(playerid, "~p~/call 544 ~w~to call~n~~y~san fierro public transportation service", 20000, 3);

				InterpolateCameraPos(playerid, -2154.9983,-65.2416,45.5149, -2078.0098,32.5450,45.9552, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -2176.3682,-42.3011,35.3125, -2055.3335,8.0542,35.3281, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -2078.0098,32.5450,45.9552, -2055.3335,8.0542,35.3281);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 4: {

				SendClientMessage(playerid, -1, "� ��������µ���ͧ");
				SendClientMessage(playerid, COLOR_GRAD, "����ͤس����֡����ѹ�֧���ҷ��������͡�ҡ Doherty Motel ��ѧʶҹ���ͧ�س�ͧ �س���������ͧ�Һ�ҹ������������ŷ�����");
				SendClientMessage(playerid, COLOR_GRAD, "�պ�ҹ�ҡ������������ͺ � ���ͧ᫹������ �������ö�������������ء���¡���š����¹�Թ�ҧ��ǹ��ҹ��");
				SendClientMessage(playerid, COLOR_GRAD, "�͡�ҡ����ѧ��������ç������������ͺ � ���ͧ���س����ö�����ͧ�ѡ����ҧ��ǧ");

				GameTextForPlayer(playerid, "~y~Garcia Motel~n~~w~(~p~/rent~w~) or (~p~/rentroom~w~)", 20000, 3);

				InterpolateCameraPos(playerid, -2292.7346,-197.3345,55.2711, -2154.9983,-65.2416,45.5149, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -2336.6841,-166.7888,35.5547, -2176.3682,-42.3011,35.3125, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -2154.9983,-65.2416,45.5149, -2176.3682,-42.3011,35.3125);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 5: {

				SendClientMessage(playerid, -1, "� �ѡ���آ�Ҿ");
				SendClientMessage(playerid, COLOR_GRAD, "���������������Ե�ͧ�س���آ�Ҿ������СԹ���ç���� �س��������٭���� HP ���ҧ������ͧ����͵���Фâͧ�س���");
				SendClientMessage(playerid, COLOR_GRAD, "��������ʾ�Դ�ѹ�Ҩ��Ŵ HP �ͧ�س �����дѺ������Ǣͧ�س ����ѧ�з����س�����������ª��Ե");
				SendClientMessage(playerid, COLOR_GRAD, "����ҹ�����������觷������ͧ���س����ö�Թ�������� HP �ͧ�س���Ŵ�дѺ������Ǣͧ�س");

				GameTextForPlayer(playerid, "~y~Garcia Burger Shot~n~~w~(~p~/eat~w~)", 20000, 3);

				InterpolateCameraPos(playerid, -1597.3508,848.2234,17.7428, -2292.7346,-197.3345,55.2711, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -1619.1672,865.4321,7.6953, -2336.6841,-166.7888,35.5547, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -2292.7346,-197.3345,55.2711, -2336.6841,-166.7888,35.5547);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 6: {

				SendClientMessage(playerid, -1, "� ����Թ");
				SendClientMessage(playerid, COLOR_GRAD, "�ѧ���ͧ���ͧ᫹������ ��ҧ����ҧ���͡����Ե���������ҡ����ҧἹ����Թ����");
				SendClientMessage(playerid, COLOR_GRAD, "�س������й��Թ��͹�ҽҡ�Ѻ��Ҥ�������Ѻ�͡���·���ҡ���������? ���ͨй����ع㹪��Ե��Ш��ѹ��͹");
				SendClientMessage(playerid, COLOR_GRAD, "");

				GameTextForPlayer(playerid, "~w~Central Bank of San Fierro", 4000, 3);

				InterpolateCameraPos(playerid, 1697.8542,-1308.5330,60.4948, -1597.3508,848.2234,17.7428, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, 1736.1309,-1267.8335,13.5431, -1619.1672,865.4321,7.6953, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -1597.3508,848.2234,17.7428, -1619.1672,865.4321,7.6953);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "�����¹�մԷ�ȹ�", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
		}
	}
	return 1;
}


Dialog:StarterModel(playerid, response, listitem, inputtext[]) {
	if (response) {
		SendClientMessage(playerid, COLOR_GRAD, ""EMBED_LIGHTRED"� �Թ�յ�͹�Ѻ������ SA:RP");
		GameTextForPlayer(playerid, sprintf("~w~Welcome ~n~~y~   %s", ReturnPlayerName(playerid)), 5000, 1);
		ResetPlayerMoney(playerid);
		GivePlayerMoneyEx(playerid, playerData[playerid][pCash]);

		switch(playerData[playerid][pAdmin]) {
			case 1: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1;
			}
			case 2: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2;
			}
			case 3: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3;
			}
			case 4: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3 | CMD_LEAD_ADMIN;
			}
			case 5: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3 | CMD_LEAD_ADMIN | CMD_MANAGEMENT;
			}
			case 6: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3 | CMD_LEAD_ADMIN | CMD_MANAGEMENT | CMD_DEV;
			}
			default: {
				playerData[playerid][pCMDPermission] = CMD_PLAYER;
			}
		}
		playerData[playerid][pLevel]=1;
		playerData[playerid][pCreated]=true;
		playerData[playerid][pPnumber] = 100000 + random(999999);

		if (listitem==0) playerData[playerid][pModel] = 60; 
		else playerData[playerid][pModel] = 56;

		TogglePlayerControllable(playerid, true);
		BitFlag_On(gPlayerBitFlag[playerid], IS_LOGGED);
		SetPlayerScore(playerid, playerData[playerid][pScore]);
		SetPlayerTeam(playerid, NO_TEAM);
		SetSpawnInfo(playerid, NO_TEAM, (playerData[playerid][pWear] ? playerData[playerid][pWear] : playerData[playerid][pModel]), 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
		SpawnPlayer(playerid);

		OnAccountUpdate(playerid);
	}
	return 1;
}
