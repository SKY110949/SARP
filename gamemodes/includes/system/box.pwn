#include <YSI\y_hooks>

hook OnGameModeInit()
{
    CreateDynamicPickup(1239, 2, 364.4595, 173.6485, 1008.3828);
	CreateDynamic3DTextLabel("พิมพ์ "EMBED_YELLOW"/tickets"EMBED_WHITE"\nเพื่อจ่ายค่าปรับ", -1, 364.4595,173.6485,1008.3828, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 2016, 3);
	CreateDynamic3DTextLabel("พิมพ์ "EMBED_YELLOW"/tickets"EMBED_WHITE"\nเพื่อจ่ายค่าปรับ", -1, 364.4595,173.6485,1008.3828, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 2017, 3);

    CreateDynamicPickup(1239, 2, 321.3057, 161.8132, 1014.1797);
    CreateDynamic3DTextLabel("พิมพ์ "EMBED_YELLOW"/healme"EMBED_WHITE"\nเพื่อรักษาตัวเอง ($1,000)", -1, 321.3057,161.8132,1014.1797, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 3);

}

CMD:buybox(playerid, params[])
{
    Dialog_Show(playerid, BuyBox, DIALOG_STYLE_LIST, "กล่อง Donate", "กล่อง Lucky Box (กล่องละ 50 แต้ม)\nกล่อง Staple Box (กล่องละ 50 แต้ม)\nกล่อง Double Staple Box (กล่องละ 90 แต้ม)\n{FF6347}Christmas Box {FFFF00}V.1 (กล่องละ 50 แต้ม) {FF0000}HOT!!\n{FF6347}Christmas Box {FFFF00}V.2 (กล่องละ 90 แต้ม) {FF0000}HOT!!", "ตกลง", "ยกเลิก");
    return 1;
}

CMD:openbox(playerid, params[])
{
    new giveSz[12];

	if (sscanf(params, "s[32]", giveSz)) {
	    SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /openbox [ไอดีกล่อง]");
	    return SendClientMessage(playerid, COLOR_GREEN, "รายการ :{FFFFFF} 1.LuckyBox, 2.StapleBox, 3.DoubleStapleBox, 4.Christmas Box V.1, 5.Christmas Box V.2");
	}

	if(strcmp(giveSz, "1", true) == 0) {
    
        if (playerData[playerid][pLuckyBox] >= 1)
        { 
            new randprize = random(100);
            switch(randprize)
            {
                case 0:
                { 
                    if (playerData[playerid][pLuckyBox] < 0)
                        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่มีกล่อง Lucky Box (/buybox เพื่อซื้อ)");

                    playerData[playerid][pLuckyBox] -= 1;

                    GivePlayerMoneyEx(playerid, 50000);
                    SendClientMessage(playerid, COLOR_WHITE, "คุณได้รับเงินจำนวน {FF8000}$50,000 จากการเปิดกล่อง {FF8000}Lucky Box");
                }
                case 1..15:
                {
                    if (playerData[playerid][pLuckyBox] < 0)
                        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่มีกล่อง Lucky Box (/buybox เพื่อซื้อ)");

                    playerData[playerid][pLuckyBox] -= 1;

                    playerData[playerid][pRMoney] += 70000;
                    SendClientMessage(playerid, COLOR_WHITE, "คุณได้รับเงินแดง {FF8000}$70,000 จากการเปิดกล่อง {FF8000}Lucky Box");
                }
                case 16..40:
                {
                    if (playerData[playerid][pLuckyBox] < 0)
                        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่มีกล่อง Lucky Box (/buybox เพื่อซื้อ)");

                    playerData[playerid][pLuckyBox] -= 1;

                    playerData[playerid][pIrons] += 1500;
                    SendClientMessage(playerid, COLOR_WHITE, "คุณได้รับแร่ที่ยังไม่ผ่านการแปรรูป {FF8000}1,500 ชิ้น จากการเปิดกล่อง {FF8000}Lucky Box");
                }
                default:
                {
                    if (playerData[playerid][pLuckyBox] < 0)
                        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่มีกล่อง Lucky Box (/buybox เพื่อซื้อ)");

                    playerData[playerid][pLuckyBox] -= 1;

                    GivePlayerMoneyEx(playerid, 30000);
                    SendClientMessage(playerid, COLOR_WHITE, "คุณได้รับเงินจำนวน {FF8000}$30,000 จากการเปิดกล่อง {FF8000}Lucky Box");
                }
            }
        }
        else return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่มีกล่อง Lucky Box (/buybox เพื่อซื้อ)");
    }

	if(strcmp(giveSz, "2", true) == 0) {
    
        if (playerData[playerid][pBox] >= 1)
        {
            playerData[playerid][pBox] -= 1;

            playerData[playerid][pMaterials] += 100;
            playerData[playerid][pIrons] += 150;
            playerData[playerid][pCold] += 150;
            playerData[playerid][pOre] += 150;
            playerData[playerid][pDiamond] += 100;

            SendClientMessage(playerid, COLOR_GREEN, "คุณได้รับ Materials จำนวน 100 ชิ้น, แร่เหล็ก จำนวน 150 ชิ้น, แร่ถ่าน จำนวน 150 ชิ้น, แร่ยังไม่ผ่านการแปรรูป จำนวน 150 ชิ้น, เพรช 100 ชิ้น");
            return 1;
        }
        else return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่มีกล่อง Staple Box (/buybox เพื่อซื้อ)");
    }

	if(strcmp(giveSz, "3", true) == 0) {
    
        if (playerData[playerid][pDBox] >= 1)
        {
            playerData[playerid][pDBox] -= 1;

            playerData[playerid][pMaterials] += 160;
            playerData[playerid][pIrons] += 200;
            playerData[playerid][pCold] += 200;
            playerData[playerid][pOre] += 200;
            playerData[playerid][pDiamond] += 160;

            SendClientMessage(playerid, COLOR_GREEN, "คุณได้รับ Materials จำนวน 160 ชิ้น, แร่เหล็ก จำนวน 200 ชิ้น, แร่ถ่าน จำนวน 200 ชิ้น, แร่ยังไม่ผ่านการแปรรูป จำนวน 200 ชิ้น, เพรช 160 ชิ้น");
            return 1;
        }
        else return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่มีกล่อง Double Staple Box (/buybox เพื่อซื้อ)");
    }

	if(strcmp(giveSz, "4", true) == 0) {
    
        if (playerData[playerid][pChristmas] >= 1)
        { 
            new randprize = random(4); // 25 Percent
            switch(randprize)
            {
                case 0: // Hair
                { 
                    if (playerData[playerid][pChristmas] < 0)
                        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่มีกล่อง Christmas Box V.1 (/buybox เพื่อซื้อ)");

                    playerData[playerid][pChristmas] -= 1;
                    playerData[playerid][pHair] = 1;

                    OnAccountUpdate(playerid);
                    //OnAccountUpdate(playerid);
                    SendClientMessage(playerid, COLOR_YELLOW, "[ChirstmasV.1]: {FFFFFF}ขอแสดงความยินดีด้วย, คุณได้รับสิทธิพิเศษในการจัดแต่งทรงผมที่ร้านตัดผม Los Santos ถาวร (/hair)");
                }
                case 1: // Name
                { 
                    if (playerData[playerid][pChristmas] < 0)
                        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่มีกล่อง Christmas Box V.1 (/buybox เพื่อซื้อ)");

                    playerData[playerid][pChristmas] -= 1;
                    playerData[playerid][pChangeName] += 1;

                    OnAccountUpdate(playerid);
                    SendClientMessage(playerid, COLOR_YELLOW, "[ChirstmasV.1]: {FFFFFF}ขอแสดงความยินดีด้วย, คุณได้รับบัตรเปลี่ยนชื่อ 1 ใบ (/changename)");
                }
                case 2: // Score
                {
                    new randomnumber = randomEx(50,100);

                    if (playerData[playerid][pChristmas] < 0)
                        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่มีกล่อง Christmas Box V.1 (/buybox เพื่อซื้อ)");

                    playerData[playerid][pChristmas] -= 1;
                    playerData[playerid][pScore] += randomnumber;

                    OnAccountUpdate(playerid);
                    //OnAccountUpdate(playerid);
                    SendClientMessageEx(playerid, COLOR_YELLOW, "[ChirstmasV.1]: {FFFFFF}ขอแสดงความยินดีด้วย, คุณได้รับ Score จำนวน %d จากการเปิดกล่อง", randomnumber);
                }
                default:
                {
                    new randomnumber = randomEx(1,2);

                    if (playerData[playerid][pChristmas] < 0)
                        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่มีกล่อง Christmas Box V.1 (/buybox เพื่อซื้อ)");

                    playerData[playerid][pChristmas] -= 1;
                    playerData[playerid][pKeyBox] += randomnumber;

                    OnAccountUpdate(playerid);
                    //OnAccountUpdate(playerid);
                    SendClientMessageEx(playerid, COLOR_YELLOW, "[ChirstmasV.1]: {FFFFFF}ขอแสดงความยินดีด้วย, คุณได้รับกุญแจหิมะ จำนวน %d จากการเปิดกล่อง", randomnumber);
                }
            }
        }
        else return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่มีกล่อง Christmas Box V.1 (/buybox เพื่อซื้อ)");
    }

	if(strcmp(giveSz, "5", true) == 0) 
    {
        new randomnumber = randomEx(3,5);

        if (playerData[playerid][pChristmasx] >= 1)
        { 
            playerData[playerid][pChristmasx] -= 1;
            playerData[playerid][pHair] = 1;
            playerData[playerid][pChangeName] += 1;
            playerData[playerid][pScore] += 200;
            playerData[playerid][pKeyBox] += randomnumber;

            OnAccountUpdate(playerid);
            //OnAccountUpdate(playerid);

            SendClientMessage(playerid, COLOR_LIGHTRED, "[ChirstmasV.2]: {FFFFFF}ขอแสดงความยินดีด้วย, คุณได้รับบัตรเปลี่ยนชื่อ 1 ใบ (/changename)");
            SendClientMessage(playerid, COLOR_YELLOW, "[ChirstmasV.2]: {FFFFFF}ขอแสดงความยินดีด้วย, คุณได้รับสิทธิพิเศษในการจัดแต่งทรงผมที่ร้านตัดผม Los Santos ถาวร (/hair)");
            SendClientMessageEx(playerid, COLOR_LIGHTRED, "[ChirstmasV.2]: {FFFFFF}ขอแสดงความยินดีด้วย, คุณได้รับกุญแจหิมะ จำนวน %d จากการเปิดกล่อง", randomnumber);
            SendClientMessage(playerid, COLOR_YELLOW, "[ChirstmasV.2]: {FFFFFF}ขอแสดงความยินดีด้วย, คุณได้รับ Score จำนวน 200 จากการเปิดกล่อง");
        }
        else return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่มีกล่อง Christmas Box V.2 (/buybox เพื่อซื้อ)");
    }

    return 1;
}

Dialog:BuyBox(playerid, response, listitem, inputtext[]) 
{
	if(response)
	{
    	switch (listitem)
	    {
	        case 0:
	        {
                if (playerData[playerid][pPoint] < 50)
                    return SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องมี Point มากกว่า 50 แต้ม (โปรดเติมเงินผ่านทางเพจ)");
            
                playerData[playerid][pLuckyBox] += 1;
                playerData[playerid][pPoint] -= 50;
                SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ซื้อกล่อง Lucky Box ในราคา 50 แต้ม (/openbox เพื่อเปิดกล่องสุ่ม)");
            }

	        case 1:
	        {
                if (playerData[playerid][pPoint] < 50)
                    return SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องมี Point มากกว่า 50 แต้ม (โปรดเติมเงินผ่านทางเพจ)");
            
                playerData[playerid][pBox] += 1;
                playerData[playerid][pPoint] -= 50;
                SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ซื้อกล่อง Staple Box ในราคา 50 แต้ม (/openbox เพื่อเปิดกล่องสุ่ม)");
            }

	        case 2:
	        {
                if (playerData[playerid][pPoint] < 90)
                    return SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องมี Point มากกว่า 90 แต้ม (โปรดเติมเงินผ่านทางเพจ)");
            
                playerData[playerid][pDBox] += 1;
                playerData[playerid][pPoint] -= 90;
                SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ซื้อกล่อง Double Staple Box ในราคา 90 แต้ม (/openbox เพื่อเปิดกล่องสุ่ม)");
            }

	        case 3:
	        {
                if (playerData[playerid][pPoint] < 50)
                    return SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องมี Point มากกว่า 50 แต้ม (โปรดเติมเงินผ่านทางเพจ)");
            
                playerData[playerid][pChristmas] += 1;
                playerData[playerid][pPoint] -= 50;
                SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ซื้อกล่อง Christmas Box V.1 ในราคา 50 แต้ม (/openbox เพื่อเปิดกล่องสุ่ม)");
            }

	        case 4:
	        {
                if (playerData[playerid][pPoint] < 90)
                    return SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องมี Point มากกว่า 90 แต้ม (โปรดเติมเงินผ่านทางเพจ)");
            
                playerData[playerid][pChristmasx] += 1;
                playerData[playerid][pPoint] -= 90;
                SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ซื้อกล่อง Christmas Box V.2 ในราคา 90 แต้ม (/openbox เพื่อเปิดกล่องสุ่ม)");
            }
        }
    }
    return 1;
}

CMD:changename(playerid, params[])
{
    if (playerData[playerid][pChangeName] < 1)
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่มีบัตรเปลี่ยนชื่อ");

    Dialog_Show(playerid, DialogNameChangeEvent, DIALOG_STYLE_INPUT, "เลือกชื่อผู้ใช้ของคุณ:","รูปแบบ: "EMBED_ORANGE"Firstname_Lastname"EMBED_DIALOG" (ชื่อและนามสกุลตัวแรกใช้"EMBED_LIGHTRED"พิมพ์ใหญ่"EMBED_DIALOG"\nนอกนั้นใช้ตัวพิมพ์เล็ก และมีขีดเส้นทางระหว่างชื่อและนามสกุล)","เปลี่ยน","ออก");
    return 1;
}

/*CMD:givekey(playerid, params[])
{
	new
	    targetid, 
		amount,
		str[128];

	if (sscanf(params, "ud", targetid, amount))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /givekey [ไอดีผู้เล่น/ชื่อบางส่วน] [จำนวน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

	if (targetid == playerid)
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถให้กุญแจกับตัวเองได้");

	if (amount < 1)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   โปรดระบุจำนวนที่มากกว่า 1 กุญแจ");

	if (amount > playerData[playerid][pKeyBox])
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้มีกุญแจหิมะมากขนาดนั้น");

	if (amount > 5)
	{
		format(str, sizeof(str), "AdmWarn: %s (%d) ได้มอบกุญแจหิมะ ให้ %s (%d) เป็นจำนวน %d", ReturnRealName(playerid), playerid, ReturnRealName(targetid), targetid, amount);
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, str);
	}

	playerData[playerid][pKeyBox] -= amount;
	playerData[targetid][pKeyBox] += amount;

	SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณได้ให้กุญแจหิมะจำนวน %d กับ %s", amount, ReturnRealName(targetid));
	SendClientMessageEx(targetid, COLOR_GRAD1, "   คุณได้รับกุญแจหิมจำนวน %d จาก %s", amount, ReturnRealName(playerid));

	//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s ควัก Point ออกมาบางส่วนและใส่ไว้ในมือของ %s", ReturnRealName(playerid), ReturnRealName(targetid));
	Log(transferlog, INFO, "%s ให้กุญแจหิมะให้กับ %s จำนวน %d", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount);
	
	return 1;
}*/

CMD:event(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "============================================================================================");
    SendClientMessage(playerid, COLOR_YELLOW, ":: Christmas Event :: (กิจกรรมเริ่มต้นตั้งแต่ 18/12/2019 ถึงวันที่ 5/01/2020");
    SendClientMessageEx(playerid, COLOR_WHITE, "จำนวนกุญแจหิมะที่คุณมี : {FFFF00}%d ดอก", playerData[playerid][pKeyBox]);
    SendClientMessageEx(playerid, COLOR_YELLOW, "- ของรางวัล NRG-500 : {FFFF00}%d/60 ดอก", playerData[playerid][pKeyBox]);
    SendClientMessageEx(playerid, COLOR_YELLOW, "- ของรางวัล Bullet : {FFFF00}%d/50 ดอก", playerData[playerid][pKeyBox]);

    SendClientMessage(playerid, COLOR_LIGHTRED, "หมายเหตุ : หากคุณเก็บกุญแจหิมะครบจำนวนที่ระบบต้องการแล้ว, ให้คุณทำการติดต่อเพจเพื่อแลกของรางวัล");
    SendClientMessage(playerid, COLOR_GREEN, "============================================================================================");

    return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, "AdmCmd: %s ต้องสงสัยว่ากำลังใช้โปรแกรมช่วยเล่น (Teleport Hack)", ReturnPlayerName(playerid));
    return 1;
}

Dialog:DialogNameChangeEvent(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return 1;

	if (IsValidRpName(inputtext)) {
	    new
	    	query[80];
	    mysql_format(dbCon, query, sizeof(query), "SELECT `id` FROM `players` WHERE `Name` = '%e' LIMIT 1", inputtext);
	    mysql_pquery(dbCon, query, "isExistUsernameEvent", "is", playerid, inputtext);
	}
	else {
		Dialog_Show(playerid, DialogNameChangeEvent, DIALOG_STYLE_INPUT, "เลือกชื่อผู้ใช้ของคุณ:",""EMBED_DIALOG"ตรวจพบข้อผิดพลาด: "EMBED_LIGHTRED"ชื่อนี้ไม่สามารถใช้งานได้"EMBED_DIALOG"\n\nรูปแบบ: "EMBED_ORANGE"Firstname_Lastname"EMBED_DIALOG" (ชื่อและนามสกุลตัวแรกใช้"EMBED_LIGHTRED"พิมพ์ใหญ่"EMBED_DIALOG"\nนอกนั้นใช้ตัวพิมพ์เล็ก และมีขีดเส้นทางระหว่างชื่อและนามสกุล)","เปลี่ยน","ออก");
	}
	return 1;
}

forward isExistUsernameEvent(playerid, const name[]);
public isExistUsernameEvent(playerid, const name[])
{
	new rows;
	cache_get_row_count(rows);
	if (rows) {
		Dialog_Show(playerid, DialogNameChangeEvent, DIALOG_STYLE_INPUT, "เลือกชื่อผู้ใช้ของคุณ:",""EMBED_DIALOG"ตรวจพบข้อผิดพลาด: "EMBED_LIGHTRED"ชื่อผู้ใช้นี้ได้ถูกใช้แล้ว"EMBED_DIALOG"\n\nรูปแบบ: "EMBED_ORANGE"Firstname_Lastname"EMBED_DIALOG" (ชื่อและนามสกุลตัวแรกใช้"EMBED_LIGHTRED"พิมพ์ใหญ่"EMBED_DIALOG"\nนอกนั้นใช้ตัวพิมพ์เล็ก และมีขีดเส้นทางระหว่างชื่อและนามสกุล)","เปลี่ยน","ออก");
	}
	else {
        if (playerData[playerid][pChangeName] < 1) {
            return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่มีบัตรเปลี่ยนชื่อ (/donate)");
        }
        playerData[playerid][pChangeName] -= 1;
        SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้ใช้แต้มเปลี่ยนชื่อของคุณจาก %s ไปเป็น %s", ReturnPlayerName(playerid), name);
        Log(donatelog, INFO, "%s ได้เข้าร่วม Event เปลี่ยนชื่อปีใหม่", ReturnPlayerName(playerid));
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
