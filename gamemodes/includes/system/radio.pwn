#include <YSI\y_hooks>

CMD:radiohelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GREEN,"|_____________________Radio_Help______________________|");
	SendClientMessage(playerid, COLOR_YELLOW,"�����: �س����ö�����ѹ������ҹ��� 24-7");
	SendClientMessage(playerid, COLOR_WHITE,"/setchannel - ��駤�Ҥ����ѭ�ҹ�ͧ�Է�ط���ͧ���");
	SendClientMessage(playerid, COLOR_WHITE,"/setslot - ��駤�Ҫ�ͧ�ҧ��õԴ��ͷ���ͧ���");
	SendClientMessage(playerid, COLOR_WHITE,"/r - ʹ����Է���������, ��ѭ�ҹ���س��駤��");
	SendClientMessage(playerid, COLOR_WHITE,"/cal - ��������Է���������!");
	SendClientMessage(playerid, COLOR_WHITE,"/part - ����¡��ԡ�����ѭ�ҹ�Է���������");
	SendClientMessage(playerid, COLOR_WHITE,"/kickoffradio - ����¡��ԡ�ѭ�ҳ�͡�ҡ�����������");
	SendClientMessage(playerid, COLOR_GREEN,"|_____________________________________________________|");
	return 1;
}

CMD:r(playerid, params[])
{

	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /r [��ͤ���]");

	if (!playerData[playerid][pRadio])
		return SendClientMessage(playerid, COLOR_WHITE,"�س����ö�������Ѿ����Ͷ������ 24-7");

	if (!playerData[playerid][pRChannel])
	    return SendClientMessage(playerid, COLOR_LIGHTRED,"�س�ѧ������駤�Ҫ�ͧ�Է��");

	new
	    string[128];

	if(playerData[playerid][pRChannel] == 911 && factionType != FACTION_TYPE_POLICE) return SendClientMessage(playerid, COLOR_LIGHTRED,"����Ѻ���˹�ҷ����Ǩ��ҹ��");

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
	    return SendClientMessage(playerid, COLOR_GRAD1, "/rlow [��ͤ���]");

	if (!playerData[playerid][pRadio])
		return SendClientMessage(playerid, COLOR_WHITE,"�س����ö�������Ѿ����Ͷ������ 24-7");

	if (!playerData[playerid][pRChannel])
	    return SendClientMessage(playerid, COLOR_LIGHTRED,"�س�ѧ������駤�Ҫ�ͧ�Է��");

	new
	    string[128];

	if(playerData[playerid][pRChannel] == 911 && factionType != FACTION_TYPE_POLICE) return SendClientMessage(playerid, COLOR_LIGHTRED,"����Ѻ���˹�ҷ����Ǩ��ҹ��");

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
		return SendClientMessage(playerid, COLOR_GRAD1,"   �س������Է��");

	if (sscanf(params, "d", slot)) 
		return SendClientMessageEx(playerid, COLOR_GRAD1, "�����: /setslot [1-%d]", playerData[playerid][pRadio]);

	if(slot < 1 && slot > playerData[playerid][pRadio]) return SendClientMessageEx(playerid, COLOR_GRAD1,"   ���͵��ͧ����ӡ��� 1 �����ҡ���� %d", playerData[playerid][pRadio]);

	if(playerData[playerid][pRadio] >= slot) ConnectRadio(playerid, slot, playerData[playerid][pRChannel]);
	else SendClientMessage(playerid, COLOR_GRAD1,"   �Է�آͧ�س����ͧ�Ѻ���͵���");

	return 1;
}

CMD:setchannel(playerid, params[])
{
	new
	    slot, ch;

	if (!playerData[playerid][pRadio])
		return SendClientMessage(playerid, COLOR_GRAD1,"   �س������Է��");

	if (sscanf(params, "dd", slot, ch)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "�����: /setchannel [slot ID] [channel #]");

	if(playerData[playerid][pRadio] >= slot) ConnectRadio(playerid, slot, ch);
	else SendClientMessage(playerid, COLOR_GRAD1, "   �Է�آͧ�س����ͧ�Ѻ���͵���");

	return 1;
}

CMD:part(playerid, params[])
{
	if (!playerData[playerid][pRadio])
		return SendClientMessage(playerid, COLOR_GRAD1,"   �س������Է��");

	if(playerData[playerid][pRChannel])
	{
	    playerData[playerid][pRChannel] = 0;
	    SendClientMessage(playerid, COLOR_WHITE, "   �س���͡�ҡ��ͧ�Է��㹻Ѩ�غѹ����");
	}
	else SendClientMessage(playerid, COLOR_LIGHTRED, "�س���������㹪�ͧ�Է��� �");

	return 1;
}

CMD:auth(playerid, params[])
{
    new password[24], esc_password[24];

	if (!playerData[playerid][pRadio])
		return SendClientMessage(playerid, COLOR_GRAD1,"   �س������Է��");

	if (sscanf(params, "s[24]", password))
	   	return SendClientMessage(playerid, COLOR_GRAD1, "�����: /auth [password]");

	if(strlen(password) > 16)
		return SendClientMessage(playerid, COLOR_WHITE, "   ���ʼ�ҹ��ͧ����Թ 16 ����ѡ��");

	mysql_escape_string(password,esc_password);
	format(playerData[playerid][pRAuth], 16, esc_password);
	SendClientMessage(playerid, COLOR_WHITE, "   �س�������ʼ�ҹ�Է������");

	return 1;
}

CMD:cal(playerid, params[])
{
	if(playerData[playerid][pCash] >= 5000)
	{
		new channel, password[24], query[128];
		if (sscanf(params, "dS(None)[24]", channel, password))
			return SendClientMessage(playerid, COLOR_GRAD1, "�����: /cal [channel] [password]");

		if(channel == 911) return SendClientMessage(playerid, COLOR_LIGHTRED, "��ͧ�������Ѻ˹��§ҹ�Ѱ");

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

				SendClientMessageEx(playerid, COLOR_WHITE, "�س�������ʼ�ҹ���Ѻ�Է�ت�ͧ #%d", channel);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "��ͧ�Է�ع������Ңͧ���� ");
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

			SendClientMessageEx(playerid, COLOR_WHITE, "�س������Է�ت�ͧ #%d ��Ҥ� $5,000",channel);
		}
	}
	else
	{

		SendClientMessage(playerid, COLOR_GRAD1, "   �س���Թ���� ($5,000) !");
		return 1;

	}
	return 1;
}

CMD:kickoffradio(playerid, params[])
{
	new targetid, query[128];

	if (sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_GRAD1, "/kickoffradio [ID]");

    if(playerid == targetid) return SendClientMessage(playerid, COLOR_GRAD1, "   �������ö��Ѻ����ͧ��!!");

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
					SendClientMessageEx(playerid, COLOR_GRAD1, "�س���� %s �͡�ҡ��ͧ�Է�آͧ�س", ReturnRealName(targetid));
					SendClientMessageEx(targetid, COLOR_GRAD1, "�س�١ %s ���͡�ҡ��ͧ�Է�آͧ��", ReturnRealName(playerid));
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTRED, "�س�������Ңͧ�Է�ت�ͧ���");
					return 1;
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "�س�������Ңͧ�Է�ت�ͧ���");
				return 1;
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "�س�������Ңͧ�Է�ت�ͧ���");
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
                // ���ʵç, ����Ңͧ,
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
				    SendClientMessage(playerid, COLOR_YELLOW2, "* Connection Error: ���ʼ�ҹ���١��ͧ (/auth)");
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