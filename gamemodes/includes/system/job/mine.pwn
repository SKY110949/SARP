#include <YSI\y_hooks>

hook OnGameModeInit()
{
    // Mine System
    Create3DTextLabel("{FFFF00}ขุดเหมืองแร่\n{FFFFFF}พิมพ์ {FFFF00}/mine{FFFFFF} เพื่อเริ่มต้นขุดเหมืองแร่",0x008080FF,595.7678,921.1524,-39.9265,30.0,0,1);
    Create3DTextLabel("{FFFF00}สถานที่แปรรูปแร่\n{FFFFFF}พิมพ์ {FFFF00}/ptze{FFFFFF} เพื่อเริ่มต้นการแปรรูป",0x008080FF,2573.5747,-2219.6809,13.5469,30.0,0,1);
    Create3DTextLabel("{FFFF00}โรงรับซื้อแร่\n{FFFFFF}พิมพ์ {FFFF00}/sellore{FFFFFF} เพื่อขายแร่ของคุณ",0x008080FF,2549.5002,-2219.6807,13.5469,30.0,0,1);

    // Weapon System
    Create3DTextLabel("ตลาดมืด\nพิมพ์ /buyweapon เพื่อเลือกซื้ออาวุธผิดกฎหมาย",0xFFFFFFFF,2869.6001, 857.5617, 10.7500,30.0,0,1);

    // Police System
    Create3DTextLabel("{FFFFFF}สำนักงานตำรวจ\nพิมพ์ {0000FF}/duty {FFFFFF}เพื่อเริ่มต้นการปฏิบัติหน้าที่",0xFFFFFFFF, 261.8440, 109.7867, 1004.6172,30.0,0,1);
}

CMD:minejob(playerid, params[])
{
    return SendClientMessage(playerid, COLOR_GRAD1, "คำสั่งสำหรับอาชีพขุดเหมือง : /mine, /sellore, /ore, /ptze , /gotosellore, /gotoptze");
}

CMD:mine(playerid, params[])
{
	if (!IsPlayerInRangeOfPoint(playerid, 6.0, 595.7678, 921.1524, -39.9265))
	    return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ใกล้เหมือง");

	if (BitFlag_Get(gPlayerBitFlag[playerid], PLAYER_MINING))
	{
	    BitFlag_Off(gPlayerBitFlag[playerid], PLAYER_MINING);
	    SendClientMessage(playerid, COLOR_YELLOW, "คุณได้หยุดการทำงานเป็นพนักงานขุดแร่เรียบร้อยแล้ว (/gotopatz) เพื่อไปที่จุดเเปรรูป (/gotosellore) เพื่อไปจุดขาย");
	}
	else
	{
	    BitFlag_On(gPlayerBitFlag[playerid], PLAYER_MINING);
	    SendClientMessage(playerid, COLOR_YELLOW, "คุณได้เริ่มต้นการทำงานเป็นพนักงานขุดแร่เรียบร้อยแล้ว, (โปรดคลิกซ้ายเพื่อขุดแร่)");
	}
	return 1;
}

CMD:ptze(playerid, params[])
{
	new ore = 1 + random(3),amount;

	if (!IsPlayerInRangeOfPoint(playerid, 3.0, 2573.5747,-2219.6809,13.5469))
	    return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่สถานที่แปรรูป");

	if (sscanf(params, "d", amount))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /ptze [จำนวน]");
		return 1;
	}

    if (amount <= 0 || amount > 100)
        return SendClientMessage(playerid, COLOR_GRAD1, "จำนวนต้องไม่น้อยกว่า 0 และมากกว่า 100");

    if (playerData[playerid][pOre] == 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "ขออภัย, คุณมีแร่ไม่เพียงพอต่อการแปรรูป (ต้องมีมากกว่า 1)");
        
    switch(ore)
    {
        case 1: // Ore
        {
            if (playerData[playerid][pIrons] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "คุณมีแร่ที่ยังไม่ผ่านการแปรรูปไม่เพียงพอ");

            playerData[playerid][pIrons] -= amount;
            playerData[playerid][pOre] += amount; // += amount;

            SendClientMessageEx(playerid, COLOR_YELLOW, "ขอแสดงความยินดีด้วย, คุณได้รับ 'แร่เหล็ก' จำนวน '%d' จากการแปรรูป (คุณสูญเสียแร่ที่ยังไม่ผ่านการแปรรูปจำนวน %d)", amount, amount);
        }
        case 2: // Cold
        {
            if (playerData[playerid][pIrons] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "คุณมีแร่ที่ยังไม่ผ่านการแปรรูปไม่เพียงพอ");

            playerData[playerid][pIrons] -= amount; 
            playerData[playerid][pCold] += amount;

            SendClientMessageEx(playerid, COLOR_YELLOW, "ขอแสดงความยินดีด้วย, คุณได้รับ 'แร่ถ่าน' จำนวน '%d' จากการแปรรูป (คุณสูญเสียแร่ที่ยังไม่ผ่านการแปรรูปจำนวน %d)", amount, amount);
        }
        case 3: // Diamond
        {
            if (playerData[playerid][pIrons] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "คุณมีแร่ที่ยังไม่ผ่านการแปรรูปไม่เพียงพอ");

            playerData[playerid][pIrons] -= amount; 
            playerData[playerid][pDiamond] += amount;

            SendClientMessageEx(playerid, COLOR_YELLOW, "ขอแสดงความยินดีด้วย, คุณได้รับ 'แร่เพรช' จำนวน '%d' จากการแปรรูป (คุณสูญเสียแร่ที่ยังไม่ผ่านการแปรรูปจำนวน %d)", amount, amount);
        }
    }

	return 1;
}

CMD:sellore(playerid, params[])
{
    new ore, 
        amount,
        price;

	if (!IsPlayerInRangeOfPoint(playerid, 3.0, 2549.5002,-2219.6807,13.5469))
	    return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่โรงรับซื้อแร่");

	if (sscanf(params, "dd", ore, amount))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /sellore [แร่ที่คุณต้องการขาย] [จำนวน]");
		SendClientMessage(playerid, COLOR_GRAD4, "|1 แร่เหล็ก $40 |2 แร่ถ่าน $20 |3 แร่เพรช $60");
		return 1;
	}

	switch (ore) //1000000000000
	{
		case 1: // แร่เหล็ก
		{
            if (playerData[playerid][pOre] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "คุณมีแร่เหล็กไม่เพียงพอ");

            if (amount <= 0 || amount > 1000)
                return SendClientMessage(playerid, COLOR_GRAD1, "จำนวนต้องไม่น้อยกว่า 0 และมากกว่า 1000");

            else
            {                
                price = amount * 40;

                playerData[playerid][pOre] -= amount;
                GivePlayerMoneyEx(playerid, price);

                SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้รับเงินจำนวน %d จากการขายแร่เหล็ก (จำนวนที่ขาย %d)", price, amount);
                return 1;

                /*foreach(new i : Player) {
                    PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
                }

                SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Bug Money", ReturnPlayerName(playerid));
                Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Bug Money", ReturnPlayerName(playerid));

                new insertLog[256];
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Bug Money', '%e', '%e', 'System')",
                    playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
                
                mysql_tquery(dbCon, insertLog); 
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Bug Money, 'System', '%e')",
                    playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
                    
                mysql_tquery(dbCon, insertLog); 
                KickEx(playerid);    

                return 1;*/            
            }
		}
		case 2: // แร่ถ่าน
		{
            if (playerData[playerid][pCold] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "คุณมีแร่ถ่านไม่เพียงพอ");

            if (amount <= 0 || amount > 1000)
                return SendClientMessage(playerid, COLOR_GRAD1, "จำนวนต้องไม่น้อยกว่า 0 และมากกว่า 1000");

            else
            {
                /*foreach(new i : Player) {
                    PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
                }

                SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Bug Money", ReturnPlayerName(playerid));
                Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Bug Money", ReturnPlayerName(playerid));

                new insertLog[256];
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Bug Money', '%e', '%e', 'System')",
                    playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
                
                mysql_tquery(dbCon, insertLog); 
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Bug Money, 'System', '%e')",
                    playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
                    
                mysql_tquery(dbCon, insertLog); 
                KickEx(playerid);*/

                price = amount * 20;

                playerData[playerid][pCold] -= amount;
                GivePlayerMoneyEx(playerid, price);

                SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้รับเงินจำนวน %d จากการขายแร่ถ่าน (จำนวนที่ขาย %d)", price, amount);

                return 1;            
            }
		}
		case 3: // แร่เพรช
		{
            if (playerData[playerid][pDiamond] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "คุณมีแร่เพรชไม่เพียงพอ");

            if (amount <= 0 || amount > 1000)
                return SendClientMessage(playerid, COLOR_GRAD1, "จำนวนต้องไม่น้อยกว่า 0 และมากกว่า 1000");

            else
            {
                price = amount * 60;

                playerData[playerid][pDiamond] -= amount;
                GivePlayerMoneyEx(playerid, price);

                SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้รับเงินจำนวน %d จากการขายแร่เพรช (จำนวนที่ขาย %d)", price, amount);
                return 1;

                /*foreach(new i : Player) {
                    PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
                }

                SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Bug Money", ReturnPlayerName(playerid));
                Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Bug Money", ReturnPlayerName(playerid));

                new insertLog[256];
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Bug Money', '%e', '%e', 'System')",
                    playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
                
                mysql_tquery(dbCon, insertLog); 
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Bug Money, 'System', '%e')",
                    playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
                    
                mysql_tquery(dbCon, insertLog); 
                KickEx(playerid);    

                return 1;*/            
            }
		}
    }

	return 1;
}

CMD:ore(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "l__________ORE__________l");
    SendClientMessageEx(playerid, COLOR_WHITE, "แร่ที่ยังไม่ผ่านการแปรรูป {33AA33}: %d", playerData[playerid][pIrons]);
    SendClientMessageEx(playerid, COLOR_WHITE, "แร่เหล็ก {33AA33}: %d", playerData[playerid][pOre]);
    SendClientMessageEx(playerid, COLOR_WHITE, "แร่ถ่าน {33AA33}: %d", playerData[playerid][pCold]);
    SendClientMessageEx(playerid, COLOR_WHITE, "แร่เพรช {33AA33}: %d", playerData[playerid][pDiamond]);
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (newkeys & KEY_FIRE && BitFlag_Get(gPlayerBitFlag[playerid], PLAYER_MINING))
	{
        if (IsPlayerInRangeOfPoint(playerid, 6.0, 595.7678, 921.1524, -39.9265))
        {
            if (playerData[playerid][pAllowMiner] == 0)
            {
                SendClientMessage(playerid, COLOR_YELLOW, "กรุณารอสักครู่ ... คุณกำลังขุดเหมืองแร่ ...");
                SetTimerEx("MineTime", 5000, false, "d", playerid);

                ApplyAnimation(playerid, "BASEBALL", "null", 4.0, 0, 1, 1, 0, 0, 1);
                ApplyAnimation(playerid, "BASEBALL", "BAT_4", 4.0, 0, 1, 1, 0, 0, 1);

                playerData[playerid][pAllowMiner] = 1;
            }
            else return SendClientMessage(playerid, COLOR_GRAD1, "คุณอยู่ระหว่างการขุดแร่, กรุณารอหลังจากการขุดแร่เสร็จสิ้นแล้วลองใหม่อีกครั้งในภายหลัง");
        }
    }
    return 1;
}

forward MineTime(playerid);
public MineTime(playerid)
{
    new A = randomEx(1,3);
    
    SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้ขุดเหมืองแร่ ... และได้รับ {FF6347}'แร่ที่ยังไม่ผ่านขั้นตอน' {FFFFFF}จำนวน {FFFF00}'%d', {FFFFFF}โปรดนำแร่ที่คุณได้รับไปสู่ขั้นตอนถัดไป !!", A);

    playerData[playerid][pIrons] += A;

	ApplyAnimation(playerid, "BSKTBALL", "null", 4.0, 0, 1, 1, 0, 0, 1);
    ApplyAnimation(playerid, "BSKTBALL", "BBALL_pickup", 4.0, 0, 1, 1, 0, 0, 1);

    playerData[playerid][pAllowMiner] = 0;

    SendClientMessage(playerid, COLOR_GRAD1, "ปัจจุบันคุณสามารถขุดแร่ได้อีกครั้งด้วยการกดคลิกซ้าย");

    return 1;
}

ptask CheckMoneyHack[1000](playerid) 
{
    if (playerData[playerid][pAdmin] < 1)
    {
        if (playerData[playerid][pPlayingHours] < 100)
        {
            if (GetPlayerMoney(playerid) >= 10000000)
            {
                foreach(new i : Player) {
                    PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
                }

                SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: อธิบายที่มาเงินของคุณ", ReturnPlayerName(playerid));
                Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ อธิบายที่มาเงินของคุณ", ReturnPlayerName(playerid));

                new insertLog[256];
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'อธิบายที่มาเงินของคุณ', '%e', '%e', 'System')",
                    playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
                
                mysql_tquery(dbCon, insertLog); 
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'อธิบายที่มาเงินของคุณ, 'System', '%e')",
                    playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
                    
                mysql_tquery(dbCon, insertLog); 
                KickEx(playerid);        
            }

            if (playerData[playerid][pAccount] >= 10000000)
            {
                foreach(new i : Player) {
                    PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
                }

                SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: อธิบายที่มาเงินของคุณ", ReturnPlayerName(playerid));
                Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ อธิบายที่มาเงินของคุณ", ReturnPlayerName(playerid));

                new insertLog[256];
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'อธิบายที่มาเงินของคุณ', '%e', '%e', 'System')",
                    playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
                
                mysql_tquery(dbCon, insertLog); 
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'อธิบายที่มาเงินของคุณ, 'System', '%e')",
                    playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
                    
                mysql_tquery(dbCon, insertLog); 
                KickEx(playerid);        
            }

            if (playerData[playerid][pSavingsCollect] >= 10000000)
            {
                foreach(new i : Player) {
                    PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
                }

                SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: อธิบายที่มาเงินของคุณ", ReturnPlayerName(playerid));
                Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ อธิบายที่มาเงินของคุณ", ReturnPlayerName(playerid));

                new insertLog[256];
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'อธิบายที่มาเงินของคุณ', '%e', '%e', 'System')",
                    playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
                
                mysql_tquery(dbCon, insertLog); 
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'อธิบายที่มาเงินของคุณ, 'System', '%e')",
                    playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
                    
                mysql_tquery(dbCon, insertLog); 
                KickEx(playerid);        
            }
        }
    }
}

CMD:gotopatz(playerid, params[])
{
    SetPlayerCheckpoint(playerid, 2549.5002,-2219.6807,13.5469, 4.0);
    SendClientMessage(playerid, COLOR_GRAD1, " พิกัดจุดเเปรรูปเเร่ Los Santos");

    return 1;
}    

CMD:gotosellore(playerid, params[])
{
    SetPlayerCheckpoint(playerid, 2573.5747,-2219.6809,13.5469, 4.0);
    SendClientMessage(playerid, COLOR_GRAD1, " พิกัดจุดขายเเร่ Los Santos");

    return 1;
}    
