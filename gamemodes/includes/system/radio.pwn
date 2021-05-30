#include <YSI\y_hooks>

CMD:radiohelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GREEN,"|_____________________Radio_Help______________________|");
	SendClientMessage(playerid, COLOR_YELLOW,"ข้อแนะ: คุณสามารถซื้อมันได้ที่ร้านค้า 24-7");
	SendClientMessage(playerid, COLOR_WHITE,"/setchannel - ตั้งค่าคลื่นสัญญานของวิทยุที่ต้องการ");
	SendClientMessage(playerid, COLOR_WHITE,"/setslot - ตั้งค่าช่องทางการติดต่อที่ต้องการ");
	SendClientMessage(playerid, COLOR_WHITE,"/r - สนทนาวิทยุสื่อสาร, ในสัญญานที่คุณตั้งค่า");
	SendClientMessage(playerid, COLOR_WHITE,"/cal - เพื่อเช่าวิทยุสื่อสาร!");
	SendClientMessage(playerid, COLOR_WHITE,"/part - เพื่อยกเลิกคลื่นสัญญานวิทยุสื่อสาร");
	SendClientMessage(playerid, COLOR_WHITE,"/kickoffradio - เพื่อยกเลิกสัญญาณออกจากคลื่นสื่อสาร");
	SendClientMessage(playerid, COLOR_GREEN,"|_____________________________________________________|");
	return 1;
}

CMD:r(playerid, params[])
{

	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /r [ข้อความ]");

	if (!playerData[playerid][pRadio])
		return SendClientMessage(playerid, COLOR_WHITE,"คุณสามารถซื้อโทรศัพท์มือถือได้ที่ 24-7");

	if (!playerData[playerid][pRChannel])
	    return SendClientMessage(playerid, COLOR_LIGHTRED,"คุณยังไม่ได้ตั้งค่าช่องวิทยุ");

	new
	    string[128];

	if(playerData[playerid][pRChannel] == 911 && factionType != FACTION_TYPE_POLICE) return SendClientMessage(playerid, COLOR_LIGHTRED,"สำหรับเจ้าหน้าที่ตำรวจเท่านั้น");

	if (strlen(params) > 80)
	{
		format(string, sizeof(string), "**[CH: %d S: %d] %s: %.80s",playerData[playerid][pRChannel], playerData[playerid][pRSlot], ReturnRealName(playerid), params);
		SendRadioMessage(playerid, string);
		format(string, sizeof(string), "...%s **",params[80]);
		SendRadioMessage(playerid, string);
	}
	else {
		format(string, sizeof(string),"**[CH: %d S: %d] %s: %s", playerData[playerid][pRChannel], playerData[playerid][pRSlot], ReturnRealName(playerid), params);
		SendRadioMessage(playerid, string);


	}
	format(string, sizeof(string),"(Radio) %s: %s", ReturnRealName(playerid), params);
	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 20.0, 6000);

	ProxDetector(playerid, 20.0, string);

	return 1;
}

CMD:rlow(playerid, params[])
{

	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "/rlow [ข้อความ]");

	if (!playerData[playerid][pRadio])
		return SendClientMessage(playerid, COLOR_WHITE,"คุณสามารถซื้อโทรศัพท์มือถือได้ที่ 24-7");

	if (!playerData[playerid][pRChannel])
	    return SendClientMessage(playerid, COLOR_LIGHTRED,"คุณยังไม่ได้ตั้งค่าช่องวิทยุ");

	new
	    string[128];

	if(playerData[playerid][pRChannel] == 911 && factionType != FACTION_TYPE_POLICE) return SendClientMessage(playerid, COLOR_LIGHTRED,"สำหรับเจ้าหน้าที่ตำรวจเท่านั้น");

	if (strlen(params) > 80)
	{
		format(string, sizeof(string), "**[CH: %d S: %d] %s: %.80s",playerData[playerid][pRChannel], playerData[playerid][pRSlot], ReturnRealName(playerid), params);
		SendRadioMessage(playerid, string);
		format(string, sizeof(string), "...%s **",params[80]);
		SendRadioMessage(playerid, string);

	}
	else {
		format(string, sizeof(string),"**[CH: %d S: %d] %s: %s", playerData[playerid][pRChannel], playerData[playerid][pRSlot], ReturnRealName(playerid), params);
		SendRadioMessage(playerid, string);


	}
	format(string, sizeof(string),"(Radio) %s: %s", ReturnRealName(playerid), params);
	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 5.0, 6000);
	ProxDetector(playerid, 5.0, string);

	/*format(szQuery, sizeof(szQuery), "[CH: %d S: %d] %s", playerData[playerid][pRChannel], playerData[playerid][pRSlot], params);
   	SQL_LogChat(playerid, "/rlow", szQuery);*/
	return 1;
}

CMD:setslot(playerid, params[])
{
	new
	    slot;

	if (!playerData[playerid][pRadio])
		return SendClientMessage(playerid, COLOR_GRAD1,"   คุณไม่มีวิทยุ");

	if (sscanf(params, "d", slot)) 
		return SendClientMessageEx(playerid, COLOR_GRAD1, "การใช้: /setslot [1-%d]", playerData[playerid][pRadio]);

	if(slot < 1 && slot > playerData[playerid][pRadio]) return SendClientMessageEx(playerid, COLOR_GRAD1,"   สล็อตต้องไม่ต่ำกว่า 1 หรือมากกว่า %d", playerData[playerid][pRadio]);

	if(playerData[playerid][pRadio] >= slot) ConnectRadio(playerid, slot, playerData[playerid][pRChannel]);
	else SendClientMessage(playerid, COLOR_GRAD1,"   วิทยุของคุณไม่รองรับสล็อตนี้");

	return 1;
}

CMD:setchannel(playerid, params[])
{
	new
	    slot, ch;

	if (!playerData[playerid][pRadio])
		return SendClientMessage(playerid, COLOR_GRAD1,"   คุณไม่มีวิทยุ");

	if (sscanf(params, "dd", slot, ch)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /setchannel [slot ID] [channel #]");

	if(playerData[playerid][pRadio] >= slot) ConnectRadio(playerid, slot, ch);
	else SendClientMessage(playerid, COLOR_GRAD1, "   วิทยุของคุณไม่รองรับสล็อตนี้");

	return 1;
}

CMD:part(playerid, params[])
{
	if (!playerData[playerid][pRadio])
		return SendClientMessage(playerid, COLOR_GRAD1,"   คุณไม่มีวิทยุ");

	if(playerData[playerid][pRChannel])
	{
	    playerData[playerid][pRChannel] = 0;
	    SendClientMessage(playerid, COLOR_WHITE, "   คุณได้ออกจากช่องวิทยุในปัจจุบันแล้ว");
	}
	else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ในช่องวิทยุใด ๆ");

	return 1;
}

CMD:auth(playerid, params[])
{
    new password[24], esc_password[24];

	if (!playerData[playerid][pRadio])
		return SendClientMessage(playerid, COLOR_GRAD1,"   คุณไม่มีวิทยุ");

	if (sscanf(params, "s[24]", password))
	   	return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /auth [password]");

	if(strlen(password) > 16)
		return SendClientMessage(playerid, COLOR_WHITE, "   รหัสผ่านต้องไม่เกิน 16 ตัวอักษร");

	mysql_escape_string(password,esc_password);
	format(playerData[playerid][pRAuth], 16, esc_password);
	SendClientMessage(playerid, COLOR_WHITE, "   คุณได้ตั้งรหัสผ่านวิทยุแล้ว");

	return 1;
}

CMD:cal(playerid, params[])
{
	if(playerData[playerid][pCash] >= 5000)
	{
		new channel, password[24], query[128];
		if (sscanf(params, "dS(None)[24]", channel, password))
			return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /cal [channel] [password]");

		if(channel == 911) return SendClientMessage(playerid, COLOR_LIGHTRED, "ช่องนี้สำหรับหน่วยงานรัฐ");

        mysql_escape_string(password, password);

		format(query, sizeof(query), "SELECT * FROM `radio` WHERE `channel` = %d", channel);
		mysql_query(dbCon, query);

		if(cache_num_rows()) {

			new owning_id;
			cache_get_value_name_int(0, "owning_character", owning_id);

			if(playerData[playerid][pSID] == owning_id)
			{
			    //Update Password

				format(query, sizeof(query), "UPDATE `radio` SET `password` = '%s' WHERE `channel` = %d;", password, channel);
				mysql_query(dbCon, query);

				SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้ตั้งรหัสผ่านให้กับวิทยุช่อง #%d", channel);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "ช่องวิทยุนี้มีเจ้าของแล้ว ");
				return 1;
			}
		}
		else
		{
			format(query,sizeof(query),"INSERT INTO `radio` (channel,owning_character,password) VALUES ('%d','%d','%s')", channel, playerData[playerid][pSID], password);
			mysql_query(dbCon, query);

			GivePlayerMoneyEx(playerid, -5000);


			format(query, sizeof(query), "UPDATE `characters` SET `Cash` = %d WHERE `ID` = %d", playerData[playerid][pCash], playerData[playerid][pSID]);
			mysql_query(dbCon, query);
			//SQL_SaveCharacter(playerid);

			SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้เช่าวิทยุช่อง #%d ในราคา $5,000",channel);
		}
	}
	else
	{

		SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอ ($5,000) !");
		return 1;

	}
	return 1;
}

CMD:kickoffradio(playerid, params[])
{
	new targetid, query[128];

	if (sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_GRAD1, "/kickoffradio [ID]");

    if(playerid == targetid) return SendClientMessage(playerid, COLOR_GRAD1, "   ไม่สามารถใช้กับตัวเองได้!!");

	if(IsPlayerConnected(targetid))
	{
	    if(playerData[playerid][pRChannel] == playerData[targetid][pRChannel] && playerData[playerid][pRChannel] != 0)
	    {
			format(query, sizeof(query), "SELECT * FROM `radio` WHERE `channel` = %d", playerData[playerid][pRChannel]);
			mysql_query(dbCon, query);

			if(cache_num_rows()) {

				new owning_id;
				cache_get_value_name_int(0, "owning_character", owning_id);

				if(playerData[playerid][pSID] == owning_id)
				{
				    playerData[targetid][pRChannel] = 0;
					SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้เตะ %s ออกจากช่องวิทยุของคุณ", ReturnRealName(targetid));
					SendClientMessageEx(targetid, COLOR_GRAD1, "คุณถูก %s เตะออกจากช่องวิทยุของเขา", ReturnRealName(playerid));
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ใช่เจ้าของวิทยุช่องนี้");
					return 1;
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ใช่เจ้าของวิทยุช่องนี้");
				return 1;
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ใช่เจ้าของวิทยุช่องนี้");
			return 1;
		}
	}
	return 1;
}

forward ConnectRadio(playerid, slot, channel);
public ConnectRadio(playerid, slot, channel)
{
    if (playerData[playerid][pRadio])
	{
		new done = 0, query[128], pass[16];

		format(query, sizeof(query), "SELECT * FROM `radio` WHERE `channel` = %d", channel);
		mysql_query(dbCon, query);

		if(cache_num_rows()) {

			cache_get_value_name(0, "password", pass, 16);

            if(strcmp(pass, "None", false))
            {
                // รหัสตรง, เป็นเจ้าของ,
                new owning_id;
                cache_get_value_name_int(0, "owning_character", owning_id);
				if(!strcmp(playerData[playerid][pRAuth], pass, false) || playerData[playerid][pSID] == owning_id)
				{
				 	playerData[playerid][pRChannel] = channel;
					playerData[playerid][pRSlot] = slot;
					done = 1;
				}
				else
				{
				    SendClientMessage(playerid, COLOR_YELLOW2, "* Connection Error: รหัสผ่านไม่ถูกต้อง (/auth)");
					playerData[playerid][pRChannel] = 0;
					playerData[playerid][pRSlot] = slot;
					done = 1;
				}
			}
		}

		if(!done)
		{
			playerData[playerid][pRChannel] = channel;
			playerData[playerid][pRSlot] = slot;
		}
	}
	else
	{
 	    playerData[playerid][pRSlot] = 1;
	    playerData[playerid][pRChannel] = 0;
	    format(playerData[playerid][pRAuth], 16,"None");

	}

}

SendRadioMessage(playerid, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string
		#emit PUSH.C args

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		foreach (new i : Player) {

			if (playerData[i][pRChannel] == playerData[playerid][pRChannel] && playerData[i][pRSlot] == playerData[playerid][pRSlot])
				SendClientMessage(i, 0xEED77BFF, string);
		}
		return 1;
	}
	foreach (new i : Player) {

	    if (playerData[i][pRChannel] == playerData[playerid][pRChannel] && playerData[i][pRSlot] == playerData[playerid][pRSlot])
 			SendClientMessage(i, 0xEED77BFF, str);
	}
	return 1;
}