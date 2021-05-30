
stock ShowWarn(playerid) {
    new
		szWarnString[1024];
    format(szWarnString, sizeof(szWarnString), "ชื่อตัวละคร : %s\nชั่วโมงออนไลน์ : %d\nครั้งที่ 1 : %s\nครั้งที่ 2 : %s\nครั้งที่ 3 : %s", ReturnPlayerName(playerid), playerData[playerid][pPlayingHours], playerData[playerid][pWarning1], playerData[playerid][pWarning2], playerData[playerid][pWarning3]);
	return Dialog_Show(playerid, ShowWarn, DIALOG_STYLE_MSGBOX, "รายการตักเตือนของคุณ", szWarnString, "ปิด","");
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
	        SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /warn [ไอดีผู้เล่น/ชื่อบางส่วน] [เหตุผลที่ทำผิด]");
	    }
	    else {
            if(playerWarnID == INVALID_PLAYER_ID)
                SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	        /*if(playerData[playerWarnID][pAdmin] >= playerData[playerid][pAdmin])
				return SendClientMessage(playerid, COLOR_GREY, "คุณไม่สามารถตักเตือนผู้ดูแลระบบที่สูงกว่าได้");*/

	        if(!strcmp(playerData[playerWarnID][pWarning1], "(null)", true)) {
	            format(playerData[playerWarnID][pWarning1], 32, playerWarnReason);

	            format(string, sizeof(string), "คุณถูกตักเตือนโดยผู้ดูแลระบบ %s ด้วยเหตุผล : %s นี่เป็นการตักเตือนครั้งแรก", ReturnPlayerName(playerid), playerWarnReason);
	            SendClientMessage(playerWarnID, COLOR_LIGHTRED, string);

	            format(string, sizeof(string), "คุณได้ตักเตือน %s (ด้วยเหตุผล %s)และนี่เป็นการเตือนครั้งแรก", ReturnPlayerName(playerWarnID), playerWarnReason);
	            SendClientMessage(playerid, COLOR_YELLOW, string);

                OnAccountUpdate(playerWarnID);
	        }
	        else if(!strcmp(playerData[playerWarnID][pWarning2], "(null)", true)) {
	            format(playerData[playerWarnID][pWarning2], 32, playerWarnReason);

	            format(string, sizeof(string), "คุณถูกตักเตือนโดยผู้ดูแลระบบ %s ด้วยเหตุผล : %s นี่เป็นการตักเตือนครั้งที่สอง", ReturnPlayerName(playerid), playerWarnReason);
	            SendClientMessage(playerWarnID, COLOR_LIGHTRED, string);

	            format(string, sizeof(string), "คุณได้ตักเตือน  %s (ด้วยเหตุผล %s) และนี่เป็นการเตือนครั้งที่สอง", ReturnPlayerName(playerWarnID), playerWarnReason);
	            SendClientMessage(playerid, COLOR_YELLOW, string);

                OnAccountUpdate(playerWarnID);
	        }
	        else {
	            format(playerData[playerWarnID][pWarning3], 32, playerWarnReason);

	            format(string, sizeof(string), "คุณถูกตัดเตือนโดยผู้ดูแลระบบ %s ด้วยเหตุผล : %s นี่เป็นการตักเตือนครั้งสุดท้าย", ReturnPlayerName(playerid), playerWarnReason);
	            SendClientMessage(playerWarnID, COLOR_LIGHTRED, string);

	            format(string, sizeof(string), "คุณได้ตักเตือน  %s (ด้วยเหตุผล %s) และนี่เป็นการเตือนครั้งสุดท้าย", ReturnPlayerName(playerWarnID), playerWarnReason);
	            SendClientMessage(playerid, COLOR_YELLOW, string);

                OnAccountUpdate(playerWarnID);

                foreach(new i : Player) {
                    PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
                }

                SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: ครบการตักเตือนครั้งสุดท้าย (WARN 3)", ReturnPlayerName(playerWarnID));
                Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Warn 3", ReturnPlayerName(playerWarnID));

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

