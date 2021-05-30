#define MAX_PLAYER_TICKETS 10

CountTickets(playerid)
{
    new szQuery[128];

	format(szQuery, sizeof(szQuery), "SELECT * FROM `fines` WHERE `addressee` = '%s'", ReturnRealName(playerid));
	mysql_query(dbCon, szQuery);
	return cache_num_rows();
}

stock CountTicketsByName(owner[])
{
	new name[MAX_PLAYER_NAME + 1];
	format(name, MAX_PLAYER_NAME, "%s", owner);
	for (new i = 0, len = strlen(name); i < len; i ++) if (name[i] == '_') name[i] = ' ';

	format(szQuery, sizeof(szQuery), "SELECT * FROM `fines` WHERE `addressee` = '%s'", name);
	mysql_query(dbCon, szQuery);
	return cache_num_rows();
}

PlacePlayerFine(playerid, copid, price, const reason[]) {

	new query[512], clean_reason[64];
	//new exp = gettime() + 259200;

	mysql_escape_string(reason,clean_reason);

	format(query, sizeof(query), "INSERT INTO `fines` (`cop`, `addressee`, `agency`, `price`, `reason`, `type`) VALUES ('%s', '%s', '%s', '%d', '%s', '%d')", ReturnRealName(copid), ReturnRealName(playerid), Faction_GetName(copid), price, clean_reason, 0);
	mysql_query(dbCon, query);

	return 1;
}

ViewPlayerFine(playerid, targetid) {

	new str[1024],
        szQuery[128];

	format(szQuery, sizeof(szQuery), "SELECT * FROM `fines` WHERE `addressee` = '%s' AND `type` = 0", ReturnRealName(targetid));
	mysql_query(dbCon, szQuery);

	if(cache_num_rows()) {

		new
			rows,
			fineid,
			fineprice,
			finereason[64],
			menu[10];

		cache_get_row_count(rows);

		for (new i = 0; i < rows; i ++) if(i < MAX_PLAYER_TICKETS)
		{
			cache_get_value_index_int(i, 0, fineid);
			cache_get_value_index_int(i, 5, fineprice);
			cache_get_value_index(i, 6, finereason);

			format(str, sizeof(str), "%s"EMBED_WHITE"Fine #%03d [{7E98B6}$%d"EMBED_WHITE"] ���ͧ�ҡ '%s'\n" ,str, fineid, fineprice, finereason);
			Dialog_Show(playerid,PlayerFines,DIALOG_STYLE_LIST,"Fine List",str,"Details","Close");

			format(menu, 10, "menu%d", i);
			SetPVarInt(playerid, menu, fineid);

			SetPVarInt(playerid, "PlayerFinesID", targetid);
		}
		return 1;
	}
	return 0;
}

CMD:ticket(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]),
        userid,amount,reason[64];

	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   ����Ѻ���˹�ҷ����Ǩ��ҹ�� !");

	if(sscanf(params,"uds[64]",userid, amount, reason)) 
        return SendClientMessage(playerid, COLOR_GRAD2,"�����: /ticket [�ʹռ�����/���ͺҧ��ǹ] [�ӹǹ] [reason]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if(userid == playerid) 
        return SendClientMessage(playerid, COLOR_LIGHTRED,"   �س�������ö��¹��һ�Ѻ������ͧ��");

    if(amount <= 0) 
        return SendClientMessage(playerid, COLOR_GRAD1, "��һ�Ѻ��ͧ�ҡ���� 0");

	if(playerData[playerid][pOnDuty] == 0) 
        return SendClientMessage(playerid, COLOR_GRAD1,"   �س�ѧ������������Ժѵ�˹�ҷ��");

	if(CountTickets(userid) == MAX_PLAYER_TICKETS) 
        return SendClientMessage(playerid, COLOR_LIGHTRED,"�����蹹���դ�һ�Ѻ����ӹǹ���� (10)");

	SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ��¹��һ�Ѻ %s ���Ѻ %s ���ͧ�ҡ '%s'", ReturnRealName(playerid), FormatNumber(amount), ReturnRealName(userid), reason);
    SendClientMessageEx(playerid, COLOR_PURPLE, "[ ! ] �س�١��Ѻ�� %s ���ͧ�ҡ '%s' ������ /tickets", ReturnRealName(playerid), reason);

	PlacePlayerFine(userid, playerid, amount, reason);
	return 1;
}

CMD:tickets(playerid, params[])
{
    new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);

	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin]) {
		if(!ViewPlayerFine(playerid, playerid)) SendClientMessage(playerid, COLOR_LIGHTRED, "�س����դ�һ�Ѻ!");
	}
	else
	{
		new userid;
		if(sscanf(params,"u",userid)) return SendClientMessage(playerid, COLOR_GRAD1, "�����: /tickets [�ʹռ�����/���ͺҧ��ǹ]");

        if(userid == playerid) {
			if(!ViewPlayerFine(playerid, playerid)) SendClientMessage(playerid, COLOR_LIGHTRED, "�س����դ�һ�Ѻ!");
        }
        else {

            if(!playerData[playerid][pOnDuty]) return SendClientMessage(playerid, COLOR_GRAD1,"   �س�ѧ������������Ժѵ�˹�ҷ��");

			if(userid == INVALID_PLAYER_ID) {
				return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");
			}
			if(!ViewPlayerFine(playerid, userid)) SendClientMessage(playerid, COLOR_LIGHTRED, "�����蹹������դ�һ�Ѻ!");
		}
	}
	return 1;
}


Dialog:PlayerFines(playerid, response, listitem, inputtext[])
{
    new szQuery[128];

	if(response) {
	    new menu[10], str[512], targetid = GetPVarInt(playerid, "PlayerFinesID");
	    format(menu, 10, "menu%d", listitem);
	    new rows = GetPVarInt(playerid, menu);

		format(szQuery, sizeof(szQuery), "SELECT * FROM `fines` WHERE `addressee` = '%s' AND `id` = %d AND `type` = 0", ReturnRealName(targetid), rows);
		mysql_query(dbCon, szQuery);

		if(cache_num_rows()) {

			new
				fineid,
				fineagency[64],
				fineaddressee[24],
				fineissuer[24],
				fineprice,
				finedate[64],
				finereason[64];

			cache_get_value_index_int(0, 0, fineid);
			cache_get_value_index(0, 1, fineissuer);
			cache_get_value_index(0, 2, fineaddressee);
			cache_get_value_index(0, 3, fineagency);
			cache_get_value_index(0, 4, finedate);
			cache_get_value_index_int(0, 5, fineprice);
			cache_get_value_index(0, 6, finereason);

			if(targetid == playerid) {
			    SetPVarInt(playerid, "PlayerFinesChooseID", fineid);
			    SetPVarInt(playerid, "PlayerFinesPrice", fineprice);
			    format(str, sizeof(str), "˹��§ҹ:\t%s\n����Ѻ:\t\t%s\n����͡�ѵ�:\t%s\n\n�ӹǹ:\t\t$%d\n���˵�:\t\t%s\n�ѹ���:\t\t%s\n\n�س������ 72 �����������Ѻ��è��¤�һ�Ѻ" ,fineagency, fineaddressee, fineissuer, fineprice, finereason, finedate);
				Dialog_Show(playerid,PayFines,DIALOG_STYLE_MSGBOX,"Fine Details",str,"Pay","Close");
			}
			else {
				format(str, sizeof(str), "˹��§ҹ:\t%s\n����Ѻ:\t\t%s\n����͡�ѵ�:\t%s\n\n�ӹǹ:\t\t$%d\n���˵�:\t\t%s\n�ѹ���:\t\t%s" ,fineagency, fineaddressee, fineissuer, fineprice, finereason, finedate);
				Dialog_Show(playerid,ShowOnly,DIALOG_STYLE_MSGBOX,"Fine Details",str,"Close","");
			}
			return 1;
		}
	}
	return 1;
}

Dialog:PayFines(playerid, response, listitem, inputtext[])
{
    new szQuery[128];

    if(response) {

        if (!IsPlayerInRangeOfPoint(playerid, 3.0, 364.4595,173.6485,1008.3828)) 
            return SendClientMessage(playerid, COLOR_GRAD1, "�س����������� City Hall Los Santos");

        new fineid = GetPVarInt(playerid,"PlayerFinesChooseID");
        new price = GetPVarInt(playerid,"PlayerFinesPrice");

		if(playerData[playerid][pCash] < price) return SendClientMessage(playerid,COLOR_GREY,"�س������Թ��§�ͷ��Ш��¤�һ�Ѻ���!");

	    playerData[playerid][pCash]-=price;

	    SendClientMessageEx(playerid, COLOR_PURPLE, "[ ! ] �س����¤�һ�Ѻ #%d ��Ҥ�: $%d", fineid, price);

		format(szQuery, sizeof(szQuery), "DELETE FROM `fines` WHERE `id` = %d", fineid);
	    mysql_query(dbCon, szQuery);
    }
	DeletePVar(playerid, "PlayerFinesChooseID");
	DeletePVar(playerid, "PlayerFinesPrice");

	return 1;
}