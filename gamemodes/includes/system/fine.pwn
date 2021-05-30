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

			format(str, sizeof(str), "%s"EMBED_WHITE"Fine #%03d [{7E98B6}$%d"EMBED_WHITE"] เนื่องจาก '%s'\n" ,str, fineid, fineprice, finereason);
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
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่ตำรวจเท่านั้น !");

	if(sscanf(params,"uds[64]",userid, amount, reason)) 
        return SendClientMessage(playerid, COLOR_GRAD2,"การใช้: /ticket [ไอดีผู้เล่น/ชื่อบางส่วน] [จำนวน] [reason]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if(userid == playerid) 
        return SendClientMessage(playerid, COLOR_LIGHTRED,"   คุณไม่สามารถเขียนค่าปรับให้ตัวเองได้");

    if(amount <= 0) 
        return SendClientMessage(playerid, COLOR_GRAD1, "ค่าปรับต้องมากกว่า 0");

	if(playerData[playerid][pOnDuty] == 0) 
        return SendClientMessage(playerid, COLOR_GRAD1,"   คุณยังไม่ได้เริ่มปฏิบัติหน้าที่");

	if(CountTickets(userid) == MAX_PLAYER_TICKETS) 
        return SendClientMessage(playerid, COLOR_LIGHTRED,"ผู้เล่นนี้มีค่าปรับเต็มจำนวนแล้ว (10)");

	SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s เขียนค่าปรับ %s ให้กับ %s เนื่องจาก '%s'", ReturnRealName(playerid), FormatNumber(amount), ReturnRealName(userid), reason);
    SendClientMessageEx(playerid, COLOR_PURPLE, "[ ! ] คุณถูกปรับโดย %s เนื่องจาก '%s' ดูได้ที่ /tickets", ReturnRealName(playerid), reason);

	PlacePlayerFine(userid, playerid, amount, reason);
	return 1;
}

CMD:tickets(playerid, params[])
{
    new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);

	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin]) {
		if(!ViewPlayerFine(playerid, playerid)) SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่มีค่าปรับ!");
	}
	else
	{
		new userid;
		if(sscanf(params,"u",userid)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /tickets [ไอดีผู้เล่น/ชื่อบางส่วน]");

        if(userid == playerid) {
			if(!ViewPlayerFine(playerid, playerid)) SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่มีค่าปรับ!");
        }
        else {

            if(!playerData[playerid][pOnDuty]) return SendClientMessage(playerid, COLOR_GRAD1,"   คุณยังไม่ได้เริ่มปฏิบัติหน้าที่");

			if(userid == INVALID_PLAYER_ID) {
				return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");
			}
			if(!ViewPlayerFine(playerid, userid)) SendClientMessage(playerid, COLOR_LIGHTRED, "ผู้เล่นนี้ไม่มีค่าปรับ!");
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
			    format(str, sizeof(str), "หน่วยงาน:\t%s\nผู้รับ:\t\t%s\nผู้ออกบัตร:\t%s\n\nจำนวน:\t\t$%d\nสาเหตุ:\t\t%s\nวันที่:\t\t%s\n\nคุณมีเวลา 72 ชั่วโมงสำหรับการจ่ายค่าปรับ" ,fineagency, fineaddressee, fineissuer, fineprice, finereason, finedate);
				Dialog_Show(playerid,PayFines,DIALOG_STYLE_MSGBOX,"Fine Details",str,"Pay","Close");
			}
			else {
				format(str, sizeof(str), "หน่วยงาน:\t%s\nผู้รับ:\t\t%s\nผู้ออกบัตร:\t%s\n\nจำนวน:\t\t$%d\nสาเหตุ:\t\t%s\nวันที่:\t\t%s" ,fineagency, fineaddressee, fineissuer, fineprice, finereason, finedate);
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
            return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่ City Hall Los Santos");

        new fineid = GetPVarInt(playerid,"PlayerFinesChooseID");
        new price = GetPVarInt(playerid,"PlayerFinesPrice");

		if(playerData[playerid][pCash] < price) return SendClientMessage(playerid,COLOR_GREY,"คุณไม่มีเงินเพียงพอที่จะจ่ายค่าปรับนี้!");

	    playerData[playerid][pCash]-=price;

	    SendClientMessageEx(playerid, COLOR_PURPLE, "[ ! ] คุณได้จ่ายค่าปรับ #%d ในราคา: $%d", fineid, price);

		format(szQuery, sizeof(szQuery), "DELETE FROM `fines` WHERE `id` = %d", fineid);
	    mysql_query(dbCon, szQuery);
    }
	DeletePVar(playerid, "PlayerFinesChooseID");
	DeletePVar(playerid, "PlayerFinesPrice");

	return 1;
}