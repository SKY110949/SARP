#include <YSI\y_hooks>

#define MAX_AD_QUEUE 10

enum eadvert
{
    ad_owner,
    bool:ad_exist,
    ad_time,
    ad_type,
    ad_phone,
	ad_text[128],
}

new AdvertData[MAX_AD_QUEUE][eadvert];

new adTick[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
    adTick[playerid]=0;
    return 1;
}

alias:adverts("ads");
CMD:adverts(playerid, params[]) {
    if (IsPlayerAtAdvert(playerid) != -1)
	{
		if (playerData[playerid][pPlayingHours] <= 10)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องมีชั่วโมงออนไลน์มากกว่า 10 จึงจะโฆษณาได้");
		
		new menu[10], str[512], count = 1;
	
		format(str, sizeof(str), "#\tโฆษณา\tออกอากาศในอีก\n");
        
		for(new i = MAX_AD_QUEUE - 1; i >= 0; --i)
		{
			if(AdvertData[i][ad_exist]) {
				if (strlen(AdvertData[i][ad_text]) > 28) format(str, sizeof(str), "%s%d\t%.28s...\t~%ds\n", str, count+1, AdvertData[i][ad_text], AdvertData[i][ad_time]);
				else format(str, sizeof(str), "%s%d\t%s\t~%ds\n", str, count+1, AdvertData[i][ad_text], AdvertData[i][ad_time]);
				format(menu, 10, "menu%d", count);
				SetPVarInt(playerid, menu, i);
				count++;
			}
		}
	
		Dialog_Show(playerid, AdvertiseDialog, DIALOG_STYLE_LIST, "เรียกดูโฆษณา", str, "โอเค", "ปิด");
	}
	else SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR: "EMBED_WHITE"คุณต้องอยู่ในพื้นที่สำหรับโฆษณาเพื่อทำการโพสต์โฆษณา");

    return 1;
}

alias:advert("ad");
CMD:advert(playerid, params[]) {
    if (!isnull(params)) {
        // new id = -1;
        
		if (playerData[playerid][pPlayingHours] >= 10)
		{
			if (IsPlayerAtAdvert(playerid) != -1)
			{
				if(playerData[playerid][pPnumber]) {
					if(!adTick[playerid]) {

						if(strlen(params) <= 128) {
							new string[256];

							if(GetPlayerMoney(playerid) >= 500) {
								if(Advert_Free() != -1 && (!CountPlayerAdvert(playerid) || playerData[playerid][pDonateRank])) {
									SetPVarString(playerid, "AdvertText", params);
									format(string, sizeof(string), "โฆษณา: %s\n\nค่าโฆษณา: $500", params);
									Dialog_Show(playerid, AdvertPost, DIALOG_STYLE_MSGBOX, "โพสต์โฆษณา", string, "โพสต์", "ยกเลิก");
								}
								else
								{
									SendClientMessage(playerid, COLOR_GRAD1, "คิวเต็มหรือโฆษณาของคุณอยู่ในคิวโปรดลองใหม่ภายหลัง");
								}
							}
							else SendClientMessage(playerid, COLOR_GRAD1, "คุณมีเงินไม่พอที่จะทำสิ่งนี้");
						}
						else SendClientMessage(playerid, COLOR_GRAD1, "ตัวอักษรต้องไม่เกิน 128 ตัวอักษร");
					}
					else {
						return SendClientMessageEx(playerid, COLOR_GRAD1, "คุณต้องรอ %d วินาทีสำหรับการโพสต์โฆษณา", adTick[playerid]);
					}
				}
				else {
					return SendClientMessage(playerid, COLOR_GREY, "คุณไม่มีเบอร์โทรศัพท์มือถือดังนั้นคุณจะไม่สามารถส่งโฆณษาได้");
				}
			}
			else return SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR: "EMBED_WHITE"คุณต้องอยู่ในพื้นที่สำหรับโฆษณาเพื่อทำการโพสต์โฆษณา");
		}
		else return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องมีชั่วโมงออนไลน์มากกว่า 10 จึงจะสามารถโฆษณาได้");
	}
	else {
        SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /ad [ข้อความโฆษณา]");
        SendClientMessageEx(playerid, COLOR_YELLOW3, "การดำเนินการนี้ต้องการ %s", FormatNumber(500));
    }
	return 1;
}

alias:companyadvert("cad");
CMD:companyadvert(playerid, params[]) {

    if (!isnull(params)) {
        // new id = -1;
        if (IsPlayerAtAdvert(playerid) != -1)
		{
			if(playerData[playerid][pPnumber]) {
			    if(!adTick[playerid]) {

					if(strlen(params) <= 128) {

						new string[256];

                        if(GetPlayerMoney(playerid) >= 750) {
							if(Advert_Free() != -1 && (!CountPlayerAdvert(playerid) || playerData[playerid][pDonateRank])) {
								SetPVarString(playerid, "AdvertText", params);
								format(string, sizeof(string), "โฆษณา: %s\n\nค่าโฆษณา: $750", params);
								Dialog_Show(playerid, CompanyAdvertPost, DIALOG_STYLE_MSGBOX, "โพสต์โฆณษา", string, "โพสต์", "ยกเลิก");
							}
							else
							{
								SendClientMessage(playerid, COLOR_GRAD1, "คิวเต็มหรือโฆษณาของคุณอยู่ในคิวโปรดลองใหม่ภายหลัง");
							}
						} else SendClientMessage(playerid, COLOR_GRAD1, "คุณมีเงินไม่พอที่จะทำสิ่งนี้");
					} else SendClientMessage(playerid, COLOR_LIGHTRED, "ตัวอักษรต้องไม่เกิน 128 ตัวอักษร");
			    } else SendClientMessageEx(playerid, COLOR_GRAD1, "คุณต้องรอ %d วินาทีสำหรับการโพสต์โฆษณา", adTick[playerid]);
			} else SendClientMessage(playerid, COLOR_GREY, "คุณไม่มีเบอร์โทรศัพท์มือถือดังนั้นคุณจะไม่สามารถส่งโฆณษาได้");
		} else return SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR: "EMBED_WHITE"คุณต้องอยู่ในพื้นที่สำหรับโฆษณาเพื่อทำการโพสต์โฆษณา");
	} else {
        SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /cad [ข้อความโฆษณาสำหรับบริษัท]");
        SendClientMessageEx(playerid, COLOR_YELLOW3, "การดำเนินการนี้ต้องการ %s", FormatNumber(750));
    }
	return 1;
}

Dialog:AdvertiseDialog(playerid, response, listitem, inputtext[])
{
	if(response) {

        if (listitem == 0) {
            new menu[10], str[256], count = 1;
        
            format(str, sizeof(str), "#\tโฆษณา\tออกอากาศในอีก\n");
            
            for(new i = MAX_AD_QUEUE - 1; i >= 0; --i)
            {
                if(AdvertData[i][ad_exist]) {
                    if (strlen(AdvertData[i][ad_text]) > 28) format(str, sizeof(str), "%s%d\t%.28s...\t~%ds\n", str, count+1, AdvertData[i][ad_text], AdvertData[i][ad_time]);
                    else format(str, sizeof(str), "%s%d\t%s\t~%ds\n", str, count+1, AdvertData[i][ad_text], AdvertData[i][ad_time]);
                    format(menu, 10, "menu%d", count);
                    SetPVarInt(playerid, menu, i);
                    count++;
                }
            }
        
            Dialog_Show(playerid, AdvertiseDialog, DIALOG_STYLE_LIST, "เรียกดูโฆษณา", str, "โอเค", "ปิด");
            return 1;
        }
		new menu[10], str[512];

		format(menu, 10, "menu%d", listitem);
		new i = GetPVarInt(playerid, menu);

		if(AdvertData[i][ad_exist]) {
			format(str, sizeof(str), "ไอดี: %d\nโฆษณา: %s", i + 1, AdvertData[i][ad_text]);
			SetPVarInt(playerid, "contactAD", i);
			SetPVarInt(playerid, "contactID", AdvertData[i][ad_owner]);
		
			if(AdvertData[i][ad_type]) Dialog_Show(playerid, AdvertiseContact, DIALOG_STYLE_MSGBOX, "เรียกดูโฆษณา", str, "กลับ", "");
			else Dialog_Show(playerid, AdvertiseContact, DIALOG_STYLE_MSGBOX, "เรียกดูโฆษณา", str, "กลับ", "ติดต่อ");
		}
	}
	return 1;
}

Dialog:AdvertiseContact(playerid, response, listitem, inputtext[])
{
    if(response) {
		PC_EmulateCommand(playerid, "/ads");
    }
    else
    {
        new i = GetPVarInt(playerid, "contactAD");
        if(AdvertData[i][ad_exist]) {
            if(IsPlayerConnected(AdvertData[i][ad_owner]) && AdvertData[i][ad_owner] != INVALID_PLAYER_ID && AdvertData[i][ad_owner] == GetPVarInt(playerid, "contactAD"))
            {
            	SendClientMessageEx(AdvertData[i][ad_owner], COLOR_GREEN, "%s สนใจโฆษณาของคุณ [เบอร์: %d]", ReturnRealName(playerid), playerData[playerid][pPnumber]);
            }
        }
    }
    DeletePVar(playerid, "contactAD");
    DeletePVar(playerid, "contactID");
    return 1;
}

ptask PlayerADTimer[1000](playerid) {
    if(adTick[playerid])
	    adTick[playerid]--;
}
task AdTimer[1000]() {
    for(new i=0;i!=MAX_AD_QUEUE;i++) {
		if(AdvertData[i][ad_exist]) {
			AdvertData[i][ad_time]--;
			if(AdvertData[i][ad_time] <= 0) {

			    if(AdvertData[i][ad_type]) {
					if(strlen(AdvertData[i][ad_text]) > 80)
					{
						SendClientMessageToAllEx(COLOR_GREEN, "[โฆษณาโดยบริษัท] %.80s ...", AdvertData[i][ad_text]);
						SendClientMessageToAllEx(COLOR_GREEN, "[โฆษณาโดยบริษัท] ... %s", AdvertData[i][ad_text][80]);
					}
					else
					{
						SendClientMessageToAllEx(COLOR_GREEN, "[โฆษณาโดยบริษัท] %s", AdvertData[i][ad_text]);
					}
			    }
			    else {
					if(strlen(AdvertData[i][ad_text]) > 80)
					{
						SendClientMessageToAllEx(COLOR_GREEN, "[โฆษณา] %.80s ...", AdvertData[i][ad_text]);
						SendClientMessageToAllEx(COLOR_GREEN, "[โฆษณา] ... %s [โทร: %d]", AdvertData[i][ad_text][80], AdvertData[i][ad_phone]);
					}
					else
					{
						SendClientMessageToAllEx(COLOR_GREEN, "[โฆษณา] %s [โทร: %d]", AdvertData[i][ad_text], AdvertData[i][ad_phone]);
					}
			    }
			    AdvertData[i][ad_exist]=false;
			    AdvertData[i][ad_time]=0;
			    AdvertData[i][ad_owner]=INVALID_PLAYER_ID;
			}
		}
	}
    return 1;
}


Dialog:AdvertPost(playerid, response, listitem, inputtext[])
{
    if(response) {

        if (IsPlayerAtAdvert(playerid) != -1) {

			if(playerData[playerid][pPnumber]) {
				if(!adTick[playerid]) {

					if(GetPlayerMoney(playerid) >= 500) {

						new exists = -1;

						for(new i=0;i!=MAX_AD_QUEUE;i++) {
							if(!AdvertData[i][ad_exist]) {
								exists = i;
								break;
							}
						}

						if(exists != -1 && (!CountPlayerAdvert(playerid) || playerData[playerid][pDonateRank])) {

							AdvertData[exists][ad_time] = 60 * (CountAdvert() + 1);

                            GetPVarString(playerid, "AdvertText", AdvertData[exists][ad_text], 128);

							AdvertData[exists][ad_exist] = true;
							AdvertData[exists][ad_owner] = playerid;
							AdvertData[exists][ad_type] = 0;
                            AdvertData[exists][ad_phone] = playerData[playerid][pPnumber];

							SendClientMessage(playerid, COLOR_WHITE, "โฆษณาของคุณอยู่ในคิวแล้ว (/ads)");

							SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, "AdmAction: %s ได้โฆษณาว่า %s", ReturnPlayerName(playerid), AdvertData[exists][ad_text]);

							GivePlayerMoneyEx(playerid, -500);

							if(playerData[playerid][pDonateRank]>1) adTick[playerid] = 30;
							else adTick[playerid] = 60;

						} else SendClientMessage(playerid, COLOR_GRAD1, "คิวเต็มหรือโฆษณาของคุณอยู่ในคิวโปรดลองใหม่ภายหลัง");
					} else SendClientMessage(playerid, COLOR_GRAD1, "คุณมีเงินไม่พอที่จะทำสิ่งนี้");
				} else SendClientMessageEx(playerid, COLOR_GRAD1, "คุณต้องรอ %d วินาทีสำหรับการโพสต์โฆษณา", adTick[playerid]);
			} else SendClientMessage(playerid, COLOR_GREY, "คุณไม่มีเบอร์โทรศัพท์มือถือดังนั้นคุณจะไม่สามารถส่งโฆณษาได้");
		} else SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR: "EMBED_WHITE"คุณต้องอยู่ในพื้นที่สำหรับโฆษณาเพื่อทำการโพสต์โฆษณา");
    }
    DeletePVar(playerid, "AdvertPost");
    return 1;
}

Dialog:CompanyAdvertPost(playerid, response, listitem, inputtext[])
{
    if(response) {

        if (IsPlayerAtAdvert(playerid) != -1) {

			if(playerData[playerid][pPnumber]) {
				if(!adTick[playerid]) {

					if(GetPlayerMoney(playerid) >= 750) {

						new exists = -1;

						for(new i=0;i!=MAX_AD_QUEUE;i++) {
							if(!AdvertData[i][ad_exist]) {
								exists = i;
								break;
							}
						}

						if(exists != -1 && (!CountPlayerAdvert(playerid) || playerData[playerid][pDonateRank])) {

							AdvertData[exists][ad_time] = 60 * (CountAdvert() + 1);

							GetPVarString(playerid, "AdvertText", AdvertData[exists][ad_text], 128);

							AdvertData[exists][ad_exist] = true;
							AdvertData[exists][ad_owner] = playerid;
							AdvertData[exists][ad_type] = 1;
                            AdvertData[exists][ad_phone] = playerData[playerid][pPnumber];

							SendClientMessage(playerid, COLOR_WHITE, "โฆษณาของคุณอยู่ในคิวแล้ว (/ads)");

							SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, "AdmAction: %s ได้โฆษณาว่า %s", ReturnPlayerName(playerid), AdvertData[exists][ad_text]);

							GivePlayerMoneyEx(playerid, -750);

							if(playerData[playerid][pDonateRank]>1) adTick[playerid] = 30;
							else adTick[playerid] = 60;

						} else SendClientMessage(playerid, COLOR_GRAD1, "คิวเต็มหรือโฆษณาของคุณอยู่ในคิวโปรดลองใหม่ภายหลัง");
					} else SendClientMessage(playerid, COLOR_GRAD1, "คุณมีเงินไม่พอที่จะทำสิ่งนี้");
				} else SendClientMessageEx(playerid, COLOR_GRAD1, "คุณต้องรอ %d วินาทีสำหรับการโพสต์โฆษณา", adTick[playerid]);
			} else SendClientMessage(playerid, COLOR_GREY, "คุณไม่มีเบอร์โทรศัพท์มือถือดังนั้นคุณจะไม่สามารถส่งโฆณษาได้");
		} else SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR: "EMBED_WHITE"คุณต้องอยู่ในพื้นที่สำหรับโฆษณาเพื่อทำการโพสต์โฆษณา");
    }
    DeletePVar(playerid, "AdvertText");
    return 1;
}

CountAdvert() {
    new num = 0;
	for(new i=0;i!=MAX_AD_QUEUE;i++) if(AdvertData[i][ad_exist]) num++;
	return num;
}

CountPlayerAdvert(playerid) {
    new num = 0;
	for(new i=0;i!=MAX_AD_QUEUE;i++) if(AdvertData[i][ad_exist] && AdvertData[i][ad_owner] == playerid) num++;
	return num;
}

Advert_Free() {
	new exists = -1;
	for(new i=0;i!=MAX_AD_QUEUE;i++) {
		if(!AdvertData[i][ad_exist]) {
			exists = i;
			break;
		}
	}
	return exists;
}
