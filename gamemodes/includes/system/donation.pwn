

ShowDonateMenu(playerid) {
    return Dialog_Show(playerid, DialogDonateMenu, DIALOG_STYLE_LIST, "��ú�ԨҤ������������������", "����ѵԡ������Թ\n�͹�Թ�š���\n�������������� "EMBED_ORANGE"[%d ���]\n��������´ VIP", "���͡", "¡��ԡ", playerData[playerid][pPoint]);
}

alias:donate("����Թ", "vip", "�๷", "�", "��ԨҤ");
CMD:donate(playerid, params[]) {
    /*new tid[15];
    if(sscanf(params, "s[15]", tid)) {
        SendClientMessage(playerid, COLOR_GRAD1, "�����: /donate [�����Ţ��ҧ�ԧ]");
        return 1;
    }
    HTTP(playerid,HTTP_POST,"localhost/api/wallet/donation_ig.php",sprintf("tid=%s", tid),"HttpTransferRequest");*/
    ShowDonateMenu(playerid);
    return 1;
}

forward HttpTransferRequest(index, response_code, data[]);
public HttpTransferRequest(index, response_code, data[])
{
    // printf("index %d response %d data %s", index, response_code, data);
    if (IsPlayerConnected(index) && BitFlag_Get(gPlayerBitFlag[index], IS_LOGGED)) {
        if(response_code == 200)
        {
           /* new amount = strval(data);
            Dialog_Show(index, DialogDonateMenu, DIALOG_STYLE_MSGBOX, "������͹", "���������\n�س���Ѻ %d ��� !", "�Դ", "", amount);
            playerData[index][pPoint] += amount;
            OnAccountUpdate(index);*/
            new result[2][64];
            strexplode(result, data, "-");
            new 
                amount = strval(result[0]);

            mysql_tquery(dbCon, sprintf("INSERT INTO `truewallet`(`players_id`, `refid`, `cash`,`datetime`) VALUES(%d, '%s', %d, NOW())", playerData[index][pSID], result[1], amount), "TruewalletHistory", "id", index, amount);
        }
        else
        {
            Dialog_Show(index, DialogDonateMenu, DIALOG_STYLE_MSGBOX, "������͹", "��辺�����Ţ��ҧ�ԧ���", "�Դ", "");
        }
    }
}

forward TruewalletHistory(playerid, amount);
public TruewalletHistory(playerid, amount) {
	if (cache_affected_rows()) {
		// playerData[playerid][pSID]=cache_insert_id();
        Dialog_Show(playerid, DialogDonateMenu, DIALOG_STYLE_MSGBOX, "������͹", "���������\n�س���Ѻ %d ��� !", "�Դ", "", amount);
        playerData[playerid][pPoint] += amount;
        OnAccountUpdate(playerid);
	}
    else {
        Dialog_Show(playerid, DialogDonateMenu, DIALOG_STYLE_MSGBOX, "������͹", "�����Ţ��ҧ�ԧ���١�������", "�Դ", "");
    }
	return 1;
}

Dialog:DialogDonateMenu(playerid, response, listitem, inputtext[])
{
    if (response) {
        switch(listitem) {
            case 0: {
                mysql_tquery(dbCon, sprintf("SELECT * FROM `truewallet` WHERE `players_id` = %d ORDER BY datetime DESC LIMIT 5", playerData[playerid][pSID]), "RefHistory", "i", playerid);
            }
            case 1: {
                Dialog_Show(playerid, DialogDonateRef, DIALOG_STYLE_INPUT, "��ú�ԨҤ������������������", ""EMBED_ORANGE"True Wallet"EMBED_DIALOG": 0659235784[�Ѱ�� �ҭ���]\n\n����ͷ�ҹ�͹�Թ���º�������� ����Դ��¡���͹��鹢���Ҩҡ���\n�������Ţ��ҧ�ԧ "EMBED_ORANGE"14"EMBED_DIALOG" ��ѡ�һ�͹㹪�ͧ��ҹ��ҧ���:\n\n�ѵ���š����¹㹻Ѩ�غѹ: 1 �ҷ = 1 ���", "�駪���", "��Ѻ");
            }
            case 2:
            {
                Dialog_Show(playerid, DialogDonationPurchase, DIALOG_STYLE_LIST, "��ú�ԨҤ������������������", "30 �ѹ - �ء��� [90 ���]\n30 �ѹ - ����� [150 ���]\n30 �ѹ - ��������õ��� [300 ���]\n+15 Exp - �Թʴ $25,000 [100 ���]\n����¹���͵���Ф� [90 ���]\n�š����ö��ǹ��� (�����餹�������� / scrap ����������Թ�׹)", "����", "��Ѻ");
            }
            case 3:
            {
                Dialog_Show(playerid, DialogDonateMenu, DIALOG_STYLE_MSGBOX, "��ú�ԨҤ������������������", 
                "�дѺ��ú�ԨҤ\n\
                1. �ء���\n\
                2. �����\n\
                - �͡�Ҫվ��� 1 ��������ҡ��� 4\n\
                3. ��������õ���\n\
                - �͡�Ҫվ��� 1 ��������ҡ��� 4\n\
                \n\n�ҡ-���¢������Ѻ�дѺ��ú�ԨҤ\t\t- ����Ѻ���������ѹ�� (/acceptdeath)\n- ���ʹ����͹�Դ (��ѧ�ҡ /respawnme)\t\t- �дѺ��ԨҤ�ʴ������ /ooc\n- ���Ѻ Exp �������\t\t- ����Ţ���ѵ��ѵ�\n- �͡����㹸�Ҥ���٧���\t\t- �Ŵ��͡�ҹ��˹���ǹ��Ƿ����������\n- /togpm �Դ��鹢�ͤ�����ǹ���",
                "�Դ", "");
            }
            default: {
                ShowDonateMenu(playerid);
            }
        }
    }
    return 1;
}

Dialog:DialogDonateRef(playerid, response, listitem, inputtext[])
{
    if (response) {
	    mysql_tquery(dbCon, sprintf("SELECT * FROM `truewallet` WHERE `refid` = '%s'", inputtext), "RefCheck", "is", playerid, inputtext);
        Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "��ú�ԨҤ������������������", "���ѡ����...", "�Դ", "");
        return 1;
    }
    return ShowDonateMenu(playerid);
}

forward RefCheck(playerid, const refid[]);
public RefCheck(playerid, const refid[])
{
	new rows;
	cache_get_row_count(rows);

	if (rows) {
		return Dialog_Show(playerid, DialogDonateMenu, DIALOG_STYLE_MSGBOX, "������͹", "�����Ţ��ҧ�ԧ %s ���١�������", "�Դ", "", refid);
	}
    else {
        return HTTP(playerid,HTTP_POST,"localhost/api/wallet/donation_ig.php",sprintf("tid=%s", refid),"HttpTransferRequest");
    }
}

forward RefHistory(playerid);
public RefHistory(playerid)
{
	new rows, str[300];
	cache_get_row_count(rows);

	if (rows) {
        new cash, datetime[20], refid[14];
        for(new i=0; i != rows; i++) {
            cache_get_value_name_int(i, "cash", cash);
            cache_get_value_name(i, "refid", refid, 14);
            cache_get_value_name(i, "datetime", datetime, 20);
            format(str, sizeof str, "%s\n%s\t�����Ţ��ҧ�ԧ: %s\t%d �ҷ", str, datetime, refid, cash);
        }
	}
    else {
        format(str, sizeof str, "��辺��¡�����͹�ͧ�س..");
    }
    Dialog_Show(playerid, DialogDonateMenu, DIALOG_STYLE_MSGBOX, "5 ��¡������ش", str, "�Դ", "");
}

Dialog:DialogDonationPurchase(playerid, response, listitem, inputtext[])
{
    if (response) {
        switch(listitem) {
            case 0: {

                if (playerData[playerid][pDonateRank]) {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "�س�� VIP ��������");
                }
                if (playerData[playerid][pPoint] < 90) {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "�س��������� ! (90 ���)");
                }
                playerData[playerid][pPoint] -= 90;
                playerData[playerid][pDonateRank] = 1;
                mysql_query(dbCon, sprintf("UPDATE `players` SET `DonateExp` = DATE_ADD(NOW(), INTERVAL 1 MONTH) WHERE `id` = %d", playerData[playerid][pSID]));
                OnAccountUpdate(playerid);

                SendClientMessage(playerid, COLOR_YELLOW, "�س��������š���� VIP ��� 1 �ӹǹ 30 �ѹ ���º��������");
                Log(donatelog, INFO, "%s ��ԨҤ 90 �������Ѻ VIP ��� 1 �ӹǹ 30 �ѹ", ReturnPlayerName(playerid));
            }
            case 1: {

                if (playerData[playerid][pDonateRank]) {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "�س�� VIP ��������");
                }
                if (playerData[playerid][pPoint] < 150) {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "�س��������� ! (150 ���)");
                }
                playerData[playerid][pPoint] -= 150;
                playerData[playerid][pDonateRank] = 2;
                mysql_query(dbCon, sprintf("UPDATE `players` SET `DonateExp` = DATE_ADD(NOW(), INTERVAL 1 MONTH) WHERE `id` = %d", playerData[playerid][pSID]));
                OnAccountUpdate(playerid);

                SendClientMessage(playerid, COLOR_YELLOW, "�س��������š���� VIP ��� 2 �ӹǹ 30 �ѹ ���º��������");
                Log(donatelog, INFO, "%s ��ԨҤ 150 �������Ѻ VIP ��� 2 �ӹǹ 30 �ѹ", ReturnPlayerName(playerid));
            }
            case 2: {

                if (playerData[playerid][pDonateRank]) {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "�س�� VIP ��������");
                }
                if (playerData[playerid][pPoint] < 300) {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "�س��������� ! (300 ���)");
                }
                playerData[playerid][pPoint] -= 300;
                playerData[playerid][pDonateRank] = 3;
                mysql_query(dbCon, sprintf("UPDATE `players` SET `DonateExp` = DATE_ADD(NOW(), INTERVAL 1 MONTH) WHERE `id` = %d", playerData[playerid][pSID]));
                OnAccountUpdate(playerid);

                SendClientMessage(playerid, COLOR_YELLOW, "�س��������š���� VIP ��� 3 �ӹǹ 30 �ѹ ���º��������");
                Log(donatelog, INFO, "%s ��ԨҤ 300 �������Ѻ VIP ��� 3 �ӹǹ 30 �ѹ", ReturnPlayerName(playerid));
            }
            case 3: {

                if (playerData[playerid][pPoint] < 100) {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "�س��������� ! (100 ���)");
                }
                playerData[playerid][pPoint] -= 100;
                playerData[playerid][pExp] += 15;
                GivePlayerMoneyEx(playerid, 25000);
                OnAccountUpdate(playerid);

                SendClientMessage(playerid, COLOR_YELLOW, "�س��������š���� +15 Exp ����Թʴ $25,000 ���º��������");
                Log(donatelog, INFO, "%s ��ԨҤ 100 �������Ѻ +15 Exp $25,000", ReturnPlayerName(playerid));
            }
            case 4: {

                if (playerData[playerid][pPoint] < 90) {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "�س��������� ! (90 ���)");
                }

                return Dialog_Show(playerid, DialogNameChange, DIALOG_STYLE_INPUT, "���͡���ͼ����ͧ�س:","�ٻẺ: "EMBED_ORANGE"Firstname_Lastname"EMBED_DIALOG" (������й��ʡ�ŵ���á��"EMBED_LIGHTRED"������˭�"EMBED_DIALOG"\n�͡������Ǿ������� ����բմ��鹷ҧ�����ҧ������й��ʡ��)","����¹","�͡");
            }
            case 5: {
                if (IsPlayerAtDealership(playerid) != -1)
				{
                    ShowPlayerDoDealershipMenu(playerid);
                    return 1;
                }
                else {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "�س�������������᷹��˹���ö¹��");
                }
            }
        }
    }
    return ShowDonateMenu(playerid);
}

Dialog:DialogNameChange(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return ShowDonateMenu(playerid);

	if (IsValidRpName(inputtext)) {
	    new
	    	query[80];
	    mysql_format(dbCon, query, sizeof(query), "SELECT `id` FROM `players` WHERE `Name` = '%e' LIMIT 1", inputtext);
	    mysql_pquery(dbCon, query, "isExistUsername", "is", playerid, inputtext);
	}
	else {
		Dialog_Show(playerid, DialogNameChange, DIALOG_STYLE_INPUT, "���͡���ͼ����ͧ�س:",""EMBED_DIALOG"��Ǩ����ͼԴ��Ҵ: "EMBED_LIGHTRED"���͹���������ö��ҹ��"EMBED_DIALOG"\n\n�ٻẺ: "EMBED_ORANGE"Firstname_Lastname"EMBED_DIALOG" (������й��ʡ�ŵ���á��"EMBED_LIGHTRED"������˭�"EMBED_DIALOG"\n�͡������Ǿ������� ����բմ��鹷ҧ�����ҧ������й��ʡ��)","����¹","�͡");
	}
	return 1;
}

forward isExistUsername(playerid, const name[]);
public isExistUsername(playerid, const name[])
{
	new rows;
	cache_get_row_count(rows);
	if (rows) {
		Dialog_Show(playerid, DialogNameChange, DIALOG_STYLE_INPUT, "���͡���ͼ����ͧ�س:",""EMBED_DIALOG"��Ǩ����ͼԴ��Ҵ: "EMBED_LIGHTRED"���ͼ��������١������"EMBED_DIALOG"\n\n�ٻẺ: "EMBED_ORANGE"Firstname_Lastname"EMBED_DIALOG" (������й��ʡ�ŵ���á��"EMBED_LIGHTRED"������˭�"EMBED_DIALOG"\n�͡������Ǿ������� ����բմ��鹷ҧ�����ҧ������й��ʡ��)","����¹","�͡");
	}
	else {
        if (playerData[playerid][pPoint] < 90) {
            return SendClientMessage(playerid, COLOR_LIGHTRED, "�س��������� ! (90 ���)");
        }
        playerData[playerid][pPoint] -= 90;
        SendClientMessageEx(playerid, COLOR_YELLOW, "�س�����������¹���ͧ͢�س�ҡ %s ��� %s", ReturnPlayerName(playerid), name);
        Log(donatelog, INFO, "%s ��ԨҤ 90 �����������¹����", ReturnPlayerName(playerid));
        Log(namechangelog, INFO, "%s ������¹������ %s", ReturnPlayerName(playerid), name);
        SetPlayerName(playerid, name);
        new query[128];
        mysql_format(dbCon, query, sizeof query, "UPDATE `players` SET `Name` = '%e' WHERE `ID` = %d", name, playerData[playerid][pSID]);
        mysql_tquery(dbCon, query);
        OnAccountUpdate(playerid);

        ResyncSkin(playerid);
    }
    return true;
}
