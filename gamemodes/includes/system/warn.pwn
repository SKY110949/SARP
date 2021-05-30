
stock ShowWarn(playerid) {
    new
		szWarnString[1024];
    format(szWarnString, sizeof(szWarnString), "���͵���Ф� : %s\n��������͹�Ź� : %d\n���駷�� 1 : %s\n���駷�� 2 : %s\n���駷�� 3 : %s", ReturnPlayerName(playerid), playerData[playerid][pPlayingHours], playerData[playerid][pWarning1], playerData[playerid][pWarning2], playerData[playerid][pWarning3]);
	return Dialog_Show(playerid, ShowWarn, DIALOG_STYLE_MSGBOX, "��¡�õѡ��͹�ͧ�س", szWarnString, "�Դ","");
}

CMD:mywarn(playerid,param[])
{
	return ShowWarn(playerid);
}

CMD:warn(playerid, params[]) {
    if(playerData[playerid][pAdmin] >= 3) {
	    new
	        playerWarnID,
	        playerWarnReason[32],
            string[128];

	    if(sscanf(params, "us[32]", playerWarnID, playerWarnReason)) {
	        SendClientMessage(playerid, COLOR_GRAD1, "�����: /warn [�ʹռ�����/���ͺҧ��ǹ] [�˵ؼŷ��ӼԴ]");
	    }
	    else {
            if(playerWarnID == INVALID_PLAYER_ID)
                SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	        /*if(playerData[playerWarnID][pAdmin] >= playerData[playerid][pAdmin])
				return SendClientMessage(playerid, COLOR_GREY, "�س�������ö�ѡ��͹�������к�����٧������");*/

	        if(!strcmp(playerData[playerWarnID][pWarning1], "(null)", true)) {
	            format(playerData[playerWarnID][pWarning1], 32, playerWarnReason);

	            format(string, sizeof(string), "�س�١�ѡ��͹�¼������к� %s �����˵ؼ� : %s ����繡�õѡ��͹�����á", ReturnPlayerName(playerid), playerWarnReason);
	            SendClientMessage(playerWarnID, COLOR_LIGHTRED, string);

	            format(string, sizeof(string), "�س��ѡ��͹ %s (�����˵ؼ� %s)��й���繡����͹�����á", ReturnPlayerName(playerWarnID), playerWarnReason);
	            SendClientMessage(playerid, COLOR_YELLOW, string);

                OnAccountUpdate(playerWarnID);
	        }
	        else if(!strcmp(playerData[playerWarnID][pWarning2], "(null)", true)) {
	            format(playerData[playerWarnID][pWarning2], 32, playerWarnReason);

	            format(string, sizeof(string), "�س�١�ѡ��͹�¼������к� %s �����˵ؼ� : %s ����繡�õѡ��͹���駷���ͧ", ReturnPlayerName(playerid), playerWarnReason);
	            SendClientMessage(playerWarnID, COLOR_LIGHTRED, string);

	            format(string, sizeof(string), "�س��ѡ��͹  %s (�����˵ؼ� %s) ��й���繡����͹���駷���ͧ", ReturnPlayerName(playerWarnID), playerWarnReason);
	            SendClientMessage(playerid, COLOR_YELLOW, string);

                OnAccountUpdate(playerWarnID);
	        }
	        else {
	            format(playerData[playerWarnID][pWarning3], 32, playerWarnReason);

	            format(string, sizeof(string), "�س�١�Ѵ��͹�¼������к� %s �����˵ؼ� : %s ����繡�õѡ��͹�����ش����", ReturnPlayerName(playerid), playerWarnReason);
	            SendClientMessage(playerWarnID, COLOR_LIGHTRED, string);

	            format(string, sizeof(string), "�س��ѡ��͹  %s (�����˵ؼ� %s) ��й���繡����͹�����ش����", ReturnPlayerName(playerWarnID), playerWarnReason);
	            SendClientMessage(playerid, COLOR_YELLOW, string);

                OnAccountUpdate(playerWarnID);

                foreach(new i : Player) {
                    PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
                }

                SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s �١ẹ�� System ���˵�: �ú��õѡ��͹�����ش���� (WARN 3)", ReturnPlayerName(playerWarnID));
                Log(adminactionlog, INFO, "%s �١ẹ�� System ���˵� Warn 3", ReturnPlayerName(playerWarnID));

                new insertLog[256];
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Warn 3', '%e', '%e', 'System')",
                    playerData[playerWarnID][pSID], ReturnPlayerName(playerWarnID), ReturnDate(), ReturnIP(playerWarnID));
                
                mysql_tquery(dbCon, insertLog); 
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Warn 3, 'System', '%e')",
                    playerData[playerWarnID][pSID], ReturnPlayerName(playerWarnID), ReturnDate());
                    
                mysql_tquery(dbCon, insertLog); 
                KickEx(playerWarnID);
	        }
	    }
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if(PRESSED(KEY_SPRINT) || PRESSED(KEY_JUMP))
	{
	    if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !gIsDeathMode{playerid} && !gIsInjuredMode{playerid})
	    {
	    	for(new i = 0; i != MAX_DAMAGES; ++i)
			{
			    if(DamageData[playerid][i][dShotType] == 7 || DamageData[playerid][i][dShotType] == 8)
				{
			        if(random(10) <= 1 && PRESSED(KEY_SPRINT)) return 1;
					
			        ClearAnimations(playerid);
		    		ApplyAnimationEx(playerid, "PED", "FALL_COLLAPSE", 4.1, 0, 1, 1, 0, 0, 1);
		    		LegDelay[playerid] = 5;
				}
			}
		}
	}
	return 1;
}

