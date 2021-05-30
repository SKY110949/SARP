#include <YSI\y_hooks>

hook OnPlayerConnect(playerid) {
    
    playerData[playerid][pBoomboxNearby] = INVALID_PLAYER_ID;
}

hook OnPlayerDisconnect(playerid) {
 	
    if(playerData[playerid][pBoomboxPlaced]) ResetBoombox(playerid);
}

stock SetBoomboxURL(playerid, url[]) {
	if(playerData[playerid][pBoomboxPlaced]) {
	    format(playerData[playerid][pBoomboxURL], 128, url);

	    foreach(new i : Player)
        {
	        if(playerData[i][pBoomboxNearby] == playerid) {
	            PlayAudioStreamForPlayer(i, playerData[playerid][pBoomboxURL], playerData[playerid][pBoomboxX], playerData[playerid][pBoomboxY], playerData[playerid][pBoomboxZ], 30.0, true);
			}
		}
	}
}

stock StopBoomboxPlayback(playerid) {
    if(playerData[playerid][pBoomboxPlaced]) {
	    format(playerData[playerid][pBoomboxURL], 128, "None");

	    foreach(new i : Player)
        {
	        if(playerData[i][pBoomboxNearby] == playerid) {
	            StopAudioStreamForPlayer(i);
			}
		}
	}
}

stock GetNearbyBoombox(playerid) {
	foreach(new i : Player) {
		if(playerData[i][pBoomboxPlaced] && IsPlayerInRangeOfPoint(playerid, 30.0, playerData[i][pBoomboxX], playerData[i][pBoomboxY], playerData[i][pBoomboxZ]) && GetPlayerInterior(playerid) == playerData[i][pBoomboxInterior] && GetPlayerVirtualWorld(playerid) == playerData[i][pBoomboxWorld]) {
		    return i;
		}
	}

	return INVALID_PLAYER_ID;
}

stock ResetBoombox(playerid) {
	if(playerData[playerid][pBoomboxPlaced]) {
	    DestroyDynamicObject(playerData[playerid][pBoomboxObject]);
	    DestroyDynamic3DTextLabel(playerData[playerid][pBoomboxText]);
	}
	format(playerData[playerid][pBoomboxURL], 128, "None");

	playerData[playerid][pBoomboxPlaced] = 0;
	playerData[playerid][pBoomboxX] = 0.0;
	playerData[playerid][pBoomboxY] = 0.0;
	playerData[playerid][pBoomboxZ] = 0.0;
	playerData[playerid][pBoomboxInterior] = 0;
	playerData[playerid][pBoomboxWorld] = 0;
	playerData[playerid][pBoomboxText] = Text3D:INVALID_3DTEXT_ID;
}

CMD:boomboxhelp(playerid, params[]) {

    SendClientMessage(playerid, COLOR_WHITE, "คำสั่ง Boombox : /boombox (สำหรับเปิดเพลง), ฉันจะสามารถหาซื้อ Boombox ได้ที่ไหน? คำตอบ : ร้านค้า 24/7");
    return 1;
}

CMD:boombox(playerid, params[]) {
	new
	    Float:angle,
        string[128];

    if(playerData[playerid][pJailed] != 0)
		return SendClientMessage(playerid, COLOR_GRAD1, "คุณยังติดคุกอยู่จึงไม่สามารถใช้งาน Boombox ได้");

	if(playerData[playerid][pBoombox] == 0)
		return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่มี Boombox");

	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
	    return SendClientMessage(playerid, COLOR_GRAD1, "คุณสามารถใช้คำสั่งนี้ได้เมื่ออยู่บนพื้นเท่านั้น");

	if(playerData[playerid][pBoomboxPlaced]) {
	    if(!IsPlayerInRangeOfPoint(playerid, 5.0, playerData[playerid][pBoomboxX], playerData[playerid][pBoomboxY], playerData[playerid][pBoomboxZ]))
	        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ใกล้กับ Boombox ของคุณ");

		//ShowPlayerDialog(playerid, DIALOG_BOOMBOX, DIALOG_STYLE_LIST, "ตั้งค่า Boombox", "รายการเพลง\nLegend Radio Ch.12\nCOOL 93 Fahrenheit\nWink Radio\nกำหนด URL\nหยุดเพลง\nเก็บ Boombox", "เลือก", "ยกเลิก");
        Dialog_Show(playerid, Boombox, DIALOG_STYLE_LIST, "การตั้งค่า Boombox", "???? Boombox ???????? MP3 URL \nหยุดเพลง\n �� Boombox", "ตกลง", "ยกเลิก");
    }
	else {
	    if(GetNearbyBoombox(playerid) != INVALID_PLAYER_ID)
	        return SendClientMessage(playerid, COLOR_GRAD1, "มี Boombox ในบริเวณใกล้เคียงอยู่แล้ว");

	    GetPlayerPos(playerid, playerData[playerid][pBoomboxX], playerData[playerid][pBoomboxY], playerData[playerid][pBoomboxZ]);
	    GetPlayerFacingAngle(playerid, angle);

	    format(string, sizeof(string), "{33AA33}Boombox �ͧ�س� %s\n {FFFFFF}พิมพ์คำสั่ง /boombox เพื่อเปิดเพลง", ReturnPlayerName(playerid));

        playerData[playerid][pBoomboxPlaced] = 1;
        playerData[playerid][pBoomboxInterior] = GetPlayerInterior(playerid);
        playerData[playerid][pBoomboxWorld] = GetPlayerVirtualWorld(playerid);
        playerData[playerid][pBoomboxObject] = CreateDynamicObject(2102, playerData[playerid][pBoomboxX], playerData[playerid][pBoomboxY], playerData[playerid][pBoomboxZ] - 1.1, 0.0, 0.0, angle - 180, playerData[playerid][pBoomboxWorld], playerData[playerid][pBoomboxInterior]);
        playerData[playerid][pBoomboxText] = CreateDynamic3DTextLabel(string, COLOR_WHITE, playerData[playerid][pBoomboxX], playerData[playerid][pBoomboxY], playerData[playerid][pBoomboxZ] - 0.8, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, playerData[playerid][pBoomboxWorld], playerData[playerid][pBoomboxInterior]);

        ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
		SendClientMessage(playerid, COLOR_YELLOW, "boombox ���ҧ��������º��������� /boombox ���ͨѴ��áѺ�ѹ");
	}

	return 1;
}

Dialog:Boombox(playerid, response, listitem, inputtext[]) {
	
    if(response)
	{
        switch (listitem)
        {
			case 0: {
	            //ShowPlayerDialog(playerid, DIALOG_BOOMBOX_URL, DIALOG_STYLE_INPUT, "ตั้งค่า URL", "กรุณาใส่ URL เพลงที่ต้องการ\nรูปแบบ URL ต้องรองรับการสตรีมมิ่ง", "เล่น", "ยกเลิก");
                Dialog_Show(playerid, BoomboxURL, DIALOG_STYLE_INPUT, "การตั้งค่า URL Music", "คุณสามารถใส่ลิ้งค์ URL ของเพลงเพื่อเปิดให้คนรอบข้างฟังได้", "เล่นเพลง", "ยกเลิก");
            }
			case 1: {
			    StopBoomboxPlayback(playerid);
			    SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ทำการปิดเพลง Boombox");
			}
	        case 2: {
				foreach(new i : Player)
                {
					if(playerData[i][pBoomboxNearby] == playerid) {
					    StopAudioStreamForPlayer(i);
	                }
	            }

	            ResetBoombox(playerid);

	            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
	            SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ก้มตัวลงแล้วเก็บ Boombox ของคุณขึ้นมาใส่กระเป๋า");
	        }
        }

    }
    return 1;
}

Dialog:BoomboxURL(playerid, response, listitem, inputtext[]) {
	
    if(response)
	{
	    if (isnull(inputtext))
	        return Dialog_Show(playerid, BoomboxURL, DIALOG_STYLE_INPUT, "การตั้งค่า URL Music", "คุณสามารถใส่ลิ้งค์ URL ของเพลงเพื่อเปิดให้คนรอบข้างฟังได้", "เล่นเพลง", "ยกเลิก");

		SetBoomboxURL(playerid, inputtext);
    }
    return 1;
}

task BoomboxTimer[1000]() 
{
    foreach(new i : Player)
    {
        new boomboxid = GetNearbyBoombox(i);

        if(playerData[i][pBoomboxNearby] != boomboxid) {
            playerData[i][pBoomboxNearby] = boomboxid;

            if(boomboxid == INVALID_PLAYER_ID) {
                StopAudioStreamForPlayer(i);
            } else if(strcmp(playerData[boomboxid][pBoomboxURL], "None") != 0) {
                PlayAudioStreamForPlayer(i, playerData[boomboxid][pBoomboxURL], playerData[boomboxid][pBoomboxX], playerData[boomboxid][pBoomboxY], playerData[boomboxid][pBoomboxZ], 30.0, true);
            }
        }
    }
}
