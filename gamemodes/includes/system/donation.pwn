

ShowDonateMenu(playerid) {
    return Dialog_Show(playerid, DialogDonateMenu, DIALOG_STYLE_LIST, "การบริจาคช่วยเหลือเซิร์ฟเวอร์", "ประวัติการเติมเงิน\nโอนเงินแลกแต้ม\nซื้อไอเท็มพิเศษ "EMBED_ORANGE"[%d แต้ม]\nรายละเอียด VIP", "เลือก", "ยกเลิก", playerData[playerid][pPoint]);
}

alias:donate("เติมเงิน", "vip", "โดเนท", "โด", "บริจาค");
CMD:donate(playerid, params[]) {
    /*new tid[15];
    if(sscanf(params, "s[15]", tid)) {
        SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /donate [หมายเลขอ้างอิง]");
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
            Dialog_Show(index, DialogDonateMenu, DIALOG_STYLE_MSGBOX, "การแจ้งโอน", "สำเร็จแล้ว\nคุณได้รับ %d แต้ม !", "ปิด", "", amount);
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
            Dialog_Show(index, DialogDonateMenu, DIALOG_STYLE_MSGBOX, "การแจ้งโอน", "ไม่พบหมายเลขอ้างอิงนี้", "ปิด", "");
        }
    }
}

forward TruewalletHistory(playerid, amount);
public TruewalletHistory(playerid, amount) {
	if (cache_affected_rows()) {
		// playerData[playerid][pSID]=cache_insert_id();
        Dialog_Show(playerid, DialogDonateMenu, DIALOG_STYLE_MSGBOX, "การแจ้งโอน", "สำเร็จแล้ว\nคุณได้รับ %d แต้ม !", "ปิด", "", amount);
        playerData[playerid][pPoint] += amount;
        OnAccountUpdate(playerid);
	}
    else {
        Dialog_Show(playerid, DialogDonateMenu, DIALOG_STYLE_MSGBOX, "การแจ้งโอน", "หมายเลขอ้างอิงนี้ถูกใช้ไปแล้ว", "ปิด", "");
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
                Dialog_Show(playerid, DialogDonateRef, DIALOG_STYLE_INPUT, "การบริจาคช่วยเหลือเซิร์ฟเวอร์", ""EMBED_ORANGE"True Wallet"EMBED_DIALOG": 0659235784[ณัฐพล ชาญชัย]\n\nเมื่อท่านโอนเงินเรียบร้อยแล้ว ให้เปิดรายการโอนนั้นขึ้นมาจากนั้น\nนำหมายเลขอ้างอิง "EMBED_ORANGE"14"EMBED_DIALOG" หลักมาป้อนในช่องด้านล่างนี้:\n\nอัตราแลกเปลี่ยนในปัจจุบัน: 1 บาท = 1 แต้ม", "แจ้งชำระ", "กลับ");
            }
            case 2:
            {
                Dialog_Show(playerid, DialogDonationPurchase, DIALOG_STYLE_LIST, "การบริจาคช่วยเหลือเซิร์ฟเวอร์", "30 วัน - รุกกี้ [90 แต้ม]\n30 วัน - ดาวเด่น [150 แต้ม]\n30 วัน - หอแห่งเกียรติยศ [300 แต้ม]\n+15 Exp - เงินสด $25,000 [100 แต้ม]\nเปลี่ยนชื่อตัวละคร [90 แต้ม]\nแลกซื้อรถส่วนตัว (ขายให้คนอื่นไม่ได้ / scrap แล้วไม่ได้เงินคืน)", "ซื้อ", "กลับ");
            }
            case 3:
            {
                Dialog_Show(playerid, DialogDonateMenu, DIALOG_STYLE_MSGBOX, "การบริจาคช่วยเหลือเซิร์ฟเวอร์", 
                "ระดับการบริจาค\n\
                1. รุกกี้\n\
                2. ดาวเด่น\n\
                - ออกอาชีพได้ใน 1 ชั่วโมงจากเดิม 4\n\
                3. หอแห่งเกียรติยศ\n\
                - ออกอาชีพได้ใน 1 ชั่วโมงจากเดิม 4\n\
                \n\nมาก-น้อยขึ้นอยู่กับระดับการบริจาค\t\t- ยอมรับความตายได้ทันที (/acceptdeath)\n- เลือดเต็มตอนเกิด (หลังจาก /respawnme)\t\t- ระดับบริจาคแสดงอยู่ใน /ooc\n- ได้รับ Exp เพิ่มขึ้น\t\t- เลเวลขึ้นอัตโนมัติ\n- ดอกเบี้ยในธนาคารสูงขึ้น\t\t- ปลดล็อกยานพาหนะส่วนตัวที่ซื้อไม่ได้\n- /togpm ปิดกั้นข้อความส่วนตัว",
                "ปิด", "");
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
        Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "การบริจาคช่วยเหลือเซิร์ฟเวอร์", "รอสักครู่...", "ปิด", "");
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
		return Dialog_Show(playerid, DialogDonateMenu, DIALOG_STYLE_MSGBOX, "การแจ้งโอน", "หมายเลขอ้างอิง %s นี้ถูกใช้ไปแล้ว", "ปิด", "", refid);
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
            format(str, sizeof str, "%s\n%s\tหมายเลขอ้างอิง: %s\t%d บาท", str, datetime, refid, cash);
        }
	}
    else {
        format(str, sizeof str, "ไม่พบรายการแจ้งโอนของคุณ..");
    }
    Dialog_Show(playerid, DialogDonateMenu, DIALOG_STYLE_MSGBOX, "5 รายการล่าสุด", str, "ปิด", "");
}

Dialog:DialogDonationPurchase(playerid, response, listitem, inputtext[])
{
    if (response) {
        switch(listitem) {
            case 0: {

                if (playerData[playerid][pDonateRank]) {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมี VIP อยู่แล้ว");
                }
                if (playerData[playerid][pPoint] < 90) {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมีแต้มไม่พอ ! (90 แต้ม)");
                }
                playerData[playerid][pPoint] -= 90;
                playerData[playerid][pDonateRank] = 1;
                mysql_query(dbCon, sprintf("UPDATE `players` SET `DonateExp` = DATE_ADD(NOW(), INTERVAL 1 MONTH) WHERE `id` = %d", playerData[playerid][pSID]));
                OnAccountUpdate(playerid);

                SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ใช้แต้มแลกซื้อ VIP ขั้น 1 จำนวน 30 วัน เรียบร้อยแล้ว");
                Log(donatelog, INFO, "%s บริจาค 90 แต้มและรับ VIP ขั้น 1 จำนวน 30 วัน", ReturnPlayerName(playerid));
            }
            case 1: {

                if (playerData[playerid][pDonateRank]) {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมี VIP อยู่แล้ว");
                }
                if (playerData[playerid][pPoint] < 150) {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมีแต้มไม่พอ ! (150 แต้ม)");
                }
                playerData[playerid][pPoint] -= 150;
                playerData[playerid][pDonateRank] = 2;
                mysql_query(dbCon, sprintf("UPDATE `players` SET `DonateExp` = DATE_ADD(NOW(), INTERVAL 1 MONTH) WHERE `id` = %d", playerData[playerid][pSID]));
                OnAccountUpdate(playerid);

                SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ใช้แต้มแลกซื้อ VIP ขั้น 2 จำนวน 30 วัน เรียบร้อยแล้ว");
                Log(donatelog, INFO, "%s บริจาค 150 แต้มและรับ VIP ขั้น 2 จำนวน 30 วัน", ReturnPlayerName(playerid));
            }
            case 2: {

                if (playerData[playerid][pDonateRank]) {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมี VIP อยู่แล้ว");
                }
                if (playerData[playerid][pPoint] < 300) {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมีแต้มไม่พอ ! (300 แต้ม)");
                }
                playerData[playerid][pPoint] -= 300;
                playerData[playerid][pDonateRank] = 3;
                mysql_query(dbCon, sprintf("UPDATE `players` SET `DonateExp` = DATE_ADD(NOW(), INTERVAL 1 MONTH) WHERE `id` = %d", playerData[playerid][pSID]));
                OnAccountUpdate(playerid);

                SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ใช้แต้มแลกซื้อ VIP ขั้น 3 จำนวน 30 วัน เรียบร้อยแล้ว");
                Log(donatelog, INFO, "%s บริจาค 300 แต้มและรับ VIP ขั้น 3 จำนวน 30 วัน", ReturnPlayerName(playerid));
            }
            case 3: {

                if (playerData[playerid][pPoint] < 100) {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมีแต้มไม่พอ ! (100 แต้ม)");
                }
                playerData[playerid][pPoint] -= 100;
                playerData[playerid][pExp] += 15;
                GivePlayerMoneyEx(playerid, 25000);
                OnAccountUpdate(playerid);

                SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ใช้แต้มแลกซื้อ +15 Exp และเงินสด $25,000 เรียบร้อยแล้ว");
                Log(donatelog, INFO, "%s บริจาค 100 แต้มและรับ +15 Exp $25,000", ReturnPlayerName(playerid));
            }
            case 4: {

                if (playerData[playerid][pPoint] < 90) {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมีแต้มไม่พอ ! (90 แต้ม)");
                }

                return Dialog_Show(playerid, DialogNameChange, DIALOG_STYLE_INPUT, "เลือกชื่อผู้ใช้ของคุณ:","รูปแบบ: "EMBED_ORANGE"Firstname_Lastname"EMBED_DIALOG" (ชื่อและนามสกุลตัวแรกใช้"EMBED_LIGHTRED"พิมพ์ใหญ่"EMBED_DIALOG"\nนอกนั้นใช้ตัวพิมพ์เล็ก และมีขีดเส้นทางระหว่างชื่อและนามสกุล)","เปลี่ยน","ออก");
            }
            case 5: {
                if (IsPlayerAtDealership(playerid) != -1)
				{
                    ShowPlayerDoDealershipMenu(playerid);
                    return 1;
                }
                else {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ที่ตัวแทนจำหน่ายรถยนต์");
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
		Dialog_Show(playerid, DialogNameChange, DIALOG_STYLE_INPUT, "เลือกชื่อผู้ใช้ของคุณ:",""EMBED_DIALOG"ตรวจพบข้อผิดพลาด: "EMBED_LIGHTRED"ชื่อนี้ไม่สามารถใช้งานได้"EMBED_DIALOG"\n\nรูปแบบ: "EMBED_ORANGE"Firstname_Lastname"EMBED_DIALOG" (ชื่อและนามสกุลตัวแรกใช้"EMBED_LIGHTRED"พิมพ์ใหญ่"EMBED_DIALOG"\nนอกนั้นใช้ตัวพิมพ์เล็ก และมีขีดเส้นทางระหว่างชื่อและนามสกุล)","เปลี่ยน","ออก");
	}
	return 1;
}

forward isExistUsername(playerid, const name[]);
public isExistUsername(playerid, const name[])
{
	new rows;
	cache_get_row_count(rows);
	if (rows) {
		Dialog_Show(playerid, DialogNameChange, DIALOG_STYLE_INPUT, "เลือกชื่อผู้ใช้ของคุณ:",""EMBED_DIALOG"ตรวจพบข้อผิดพลาด: "EMBED_LIGHTRED"ชื่อผู้ใช้นี้ได้ถูกใช้แล้ว"EMBED_DIALOG"\n\nรูปแบบ: "EMBED_ORANGE"Firstname_Lastname"EMBED_DIALOG" (ชื่อและนามสกุลตัวแรกใช้"EMBED_LIGHTRED"พิมพ์ใหญ่"EMBED_DIALOG"\nนอกนั้นใช้ตัวพิมพ์เล็ก และมีขีดเส้นทางระหว่างชื่อและนามสกุล)","เปลี่ยน","ออก");
	}
	else {
        if (playerData[playerid][pPoint] < 90) {
            return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมีแต้มไม่พอ ! (90 แต้ม)");
        }
        playerData[playerid][pPoint] -= 90;
        SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้ใช้แต้มเปลี่ยนชื่อของคุณจาก %s ไปเป็น %s", ReturnPlayerName(playerid), name);
        Log(donatelog, INFO, "%s บริจาค 90 แต้มเพื่อเปลี่ยนชื่อ", ReturnPlayerName(playerid));
        Log(namechangelog, INFO, "%s ได้เปลี่ยนชื่อเป็น %s", ReturnPlayerName(playerid), name);
        SetPlayerName(playerid, name);
        new query[128];
        mysql_format(dbCon, query, sizeof query, "UPDATE `players` SET `Name` = '%e' WHERE `ID` = %d", name, playerData[playerid][pSID]);
        mysql_tquery(dbCon, query);
        OnAccountUpdate(playerid);

        ResyncSkin(playerid);
    }
    return true;
}
