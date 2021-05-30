#include <YSI\y_hooks>

hook OnGameModeInit()
{
    // Mine System
    Create3DTextLabel("{FFFF00}�ش����ͧ���\n{FFFFFF}����� {FFFF00}/mine{FFFFFF} ����������鹢ش����ͧ���",0x008080FF,595.7678,921.1524,-39.9265,30.0,0,1);
    Create3DTextLabel("{FFFF00}ʶҹ������ٻ���\n{FFFFFF}����� {FFFF00}/ptze{FFFFFF} ����������鹡�����ٻ",0x008080FF,2573.5747,-2219.6809,13.5469,30.0,0,1);
    Create3DTextLabel("{FFFF00}�ç�Ѻ�������\n{FFFFFF}����� {FFFF00}/sellore{FFFFFF} ���͢�����ͧ�س",0x008080FF,2549.5002,-2219.6807,13.5469,30.0,0,1);

    // Weapon System
    Create3DTextLabel("��Ҵ�״\n����� /buyweapon �������͡�������ظ�Դ������",0xFFFFFFFF,2869.6001, 857.5617, 10.7500,30.0,0,1);

    // Police System
    Create3DTextLabel("{FFFFFF}�ӹѡ�ҹ���Ǩ\n����� {0000FF}/duty {FFFFFF}����������鹡�û�Ժѵ�˹�ҷ��",0xFFFFFFFF, 261.8440, 109.7867, 1004.6172,30.0,0,1);
}

CMD:minejob(playerid, params[])
{
    return SendClientMessage(playerid, COLOR_GRAD1, "���������Ѻ�Ҫվ�ش����ͧ : /mine, /sellore, /ore, /ptze , /gotosellore, /gotoptze");
}

CMD:mine(playerid, params[])
{
	if (!IsPlayerInRangeOfPoint(playerid, 6.0, 595.7678, 921.1524, -39.9265))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�س����������������ͧ");

	if (BitFlag_Get(gPlayerBitFlag[playerid], PLAYER_MINING))
	{
	    BitFlag_Off(gPlayerBitFlag[playerid], PLAYER_MINING);
	    SendClientMessage(playerid, COLOR_YELLOW, "�س����ش��÷ӧҹ�繾�ѡ�ҹ�ش������º�������� (/gotopatz) ����价��ش����ٻ (/gotosellore) ����仨ش���");
	}
	else
	{
	    BitFlag_On(gPlayerBitFlag[playerid], PLAYER_MINING);
	    SendClientMessage(playerid, COLOR_YELLOW, "�س��������鹡�÷ӧҹ�繾�ѡ�ҹ�ش������º��������, (�ô��ԡ�������͢ش���)");
	}
	return 1;
}

CMD:ptze(playerid, params[])
{
	new ore = 1 + random(3),amount;

	if (!IsPlayerInRangeOfPoint(playerid, 3.0, 2573.5747,-2219.6809,13.5469))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�س���������ʶҹ������ٻ");

	if (sscanf(params, "d", amount))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /ptze [�ӹǹ]");
		return 1;
	}

    if (amount <= 0 || amount > 100)
        return SendClientMessage(playerid, COLOR_GRAD1, "�ӹǹ��ͧ�����¡��� 0 ����ҡ���� 100");

    if (playerData[playerid][pOre] == 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "������, �س����������§�͵�͡�����ٻ (��ͧ���ҡ���� 1)");
        
    switch(ore)
    {
        case 1: // Ore
        {
            if (playerData[playerid][pIrons] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "�س��������ѧ����ҹ������ٻ�����§��");

            playerData[playerid][pIrons] -= amount;
            playerData[playerid][pOre] += amount; // += amount;

            SendClientMessageEx(playerid, COLOR_YELLOW, "���ʴ������Թ�մ���, �س���Ѻ '�������' �ӹǹ '%d' �ҡ������ٻ (�س�٭����������ѧ����ҹ������ٻ�ӹǹ %d)", amount, amount);
        }
        case 2: // Cold
        {
            if (playerData[playerid][pIrons] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "�س��������ѧ����ҹ������ٻ�����§��");

            playerData[playerid][pIrons] -= amount; 
            playerData[playerid][pCold] += amount;

            SendClientMessageEx(playerid, COLOR_YELLOW, "���ʴ������Թ�մ���, �س���Ѻ '����ҹ' �ӹǹ '%d' �ҡ������ٻ (�س�٭����������ѧ����ҹ������ٻ�ӹǹ %d)", amount, amount);
        }
        case 3: // Diamond
        {
            if (playerData[playerid][pIrons] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "�س��������ѧ����ҹ������ٻ�����§��");

            playerData[playerid][pIrons] -= amount; 
            playerData[playerid][pDiamond] += amount;

            SendClientMessageEx(playerid, COLOR_YELLOW, "���ʴ������Թ�մ���, �س���Ѻ '����ê' �ӹǹ '%d' �ҡ������ٻ (�س�٭����������ѧ����ҹ������ٻ�ӹǹ %d)", amount, amount);
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
	    return SendClientMessage(playerid, COLOR_GRAD1, "�س����������ç�Ѻ�������");

	if (sscanf(params, "dd", ore, amount))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "�����: /sellore [�����س��ͧ��â��] [�ӹǹ]");
		SendClientMessage(playerid, COLOR_GRAD4, "|1 ������� $40 |2 ����ҹ $20 |3 ����ê $60");
		return 1;
	}

	switch (ore) //1000000000000
	{
		case 1: // �������
		{
            if (playerData[playerid][pOre] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "�س��������������§��");

            if (amount <= 0 || amount > 1000)
                return SendClientMessage(playerid, COLOR_GRAD1, "�ӹǹ��ͧ�����¡��� 0 ����ҡ���� 1000");

            else
            {                
                price = amount * 40;

                playerData[playerid][pOre] -= amount;
                GivePlayerMoneyEx(playerid, price);

                SendClientMessageEx(playerid, COLOR_YELLOW, "�س���Ѻ�Թ�ӹǹ %d �ҡ��â��������� (�ӹǹ����� %d)", price, amount);
                return 1;

                /*foreach(new i : Player) {
                    PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
                }

                SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s �١ẹ�� System ���˵�: Bug Money", ReturnPlayerName(playerid));
                Log(adminactionlog, INFO, "%s �١ẹ�� System ���˵� Bug Money", ReturnPlayerName(playerid));

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
		case 2: // ����ҹ
		{
            if (playerData[playerid][pCold] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "�س������ҹ�����§��");

            if (amount <= 0 || amount > 1000)
                return SendClientMessage(playerid, COLOR_GRAD1, "�ӹǹ��ͧ�����¡��� 0 ����ҡ���� 1000");

            else
            {
                /*foreach(new i : Player) {
                    PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
                }

                SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s �١ẹ�� System ���˵�: Bug Money", ReturnPlayerName(playerid));
                Log(adminactionlog, INFO, "%s �١ẹ�� System ���˵� Bug Money", ReturnPlayerName(playerid));

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

                SendClientMessageEx(playerid, COLOR_YELLOW, "�س���Ѻ�Թ�ӹǹ %d �ҡ��â������ҹ (�ӹǹ����� %d)", price, amount);

                return 1;            
            }
		}
		case 3: // ����ê
		{
            if (playerData[playerid][pDiamond] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "�س������ê�����§��");

            if (amount <= 0 || amount > 1000)
                return SendClientMessage(playerid, COLOR_GRAD1, "�ӹǹ��ͧ�����¡��� 0 ����ҡ���� 1000");

            else
            {
                price = amount * 60;

                playerData[playerid][pDiamond] -= amount;
                GivePlayerMoneyEx(playerid, price);

                SendClientMessageEx(playerid, COLOR_YELLOW, "�س���Ѻ�Թ�ӹǹ %d �ҡ��â������ê (�ӹǹ����� %d)", price, amount);
                return 1;

                /*foreach(new i : Player) {
                    PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
                }

                SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s �١ẹ�� System ���˵�: Bug Money", ReturnPlayerName(playerid));
                Log(adminactionlog, INFO, "%s �١ẹ�� System ���˵� Bug Money", ReturnPlayerName(playerid));

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
    SendClientMessageEx(playerid, COLOR_WHITE, "������ѧ����ҹ������ٻ {33AA33}: %d", playerData[playerid][pIrons]);
    SendClientMessageEx(playerid, COLOR_WHITE, "������� {33AA33}: %d", playerData[playerid][pOre]);
    SendClientMessageEx(playerid, COLOR_WHITE, "����ҹ {33AA33}: %d", playerData[playerid][pCold]);
    SendClientMessageEx(playerid, COLOR_WHITE, "����ê {33AA33}: %d", playerData[playerid][pDiamond]);
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (newkeys & KEY_FIRE && BitFlag_Get(gPlayerBitFlag[playerid], PLAYER_MINING))
	{
        if (IsPlayerInRangeOfPoint(playerid, 6.0, 595.7678, 921.1524, -39.9265))
        {
            if (playerData[playerid][pAllowMiner] == 0)
            {
                SendClientMessage(playerid, COLOR_YELLOW, "��س����ѡ���� ... �س���ѧ�ش����ͧ��� ...");
                SetTimerEx("MineTime", 5000, false, "d", playerid);

                ApplyAnimation(playerid, "BASEBALL", "null", 4.0, 0, 1, 1, 0, 0, 1);
                ApplyAnimation(playerid, "BASEBALL", "BAT_4", 4.0, 0, 1, 1, 0, 0, 1);

                playerData[playerid][pAllowMiner] = 1;
            }
            else return SendClientMessage(playerid, COLOR_GRAD1, "�س���������ҧ��âش���, ��س�����ѧ�ҡ��âش���������������ͧ�����ա����������ѧ");
        }
    }
    return 1;
}

forward MineTime(playerid);
public MineTime(playerid)
{
    new A = randomEx(1,3);
    
    SendClientMessageEx(playerid, COLOR_WHITE, "�س��ش����ͧ��� ... ������Ѻ {FF6347}'������ѧ����ҹ��鹵͹' {FFFFFF}�ӹǹ {FFFF00}'%d', {FFFFFF}�ô�������س���Ѻ�����鹵͹�Ѵ� !!", A);

    playerData[playerid][pIrons] += A;

	ApplyAnimation(playerid, "BSKTBALL", "null", 4.0, 0, 1, 1, 0, 0, 1);
    ApplyAnimation(playerid, "BSKTBALL", "BBALL_pickup", 4.0, 0, 1, 1, 0, 0, 1);

    playerData[playerid][pAllowMiner] = 0;

    SendClientMessage(playerid, COLOR_GRAD1, "�Ѩ�غѹ�س����ö�ش������ա���駴��¡�á���ԡ����");

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

                SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s �١ẹ�� System ���˵�: ͸Ժ�·�����Թ�ͧ�س", ReturnPlayerName(playerid));
                Log(adminactionlog, INFO, "%s �١ẹ�� System ���˵� ͸Ժ�·�����Թ�ͧ�س", ReturnPlayerName(playerid));

                new insertLog[256];
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', '͸Ժ�·�����Թ�ͧ�س', '%e', '%e', 'System')",
                    playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
                
                mysql_tquery(dbCon, insertLog); 
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', '͸Ժ�·�����Թ�ͧ�س, 'System', '%e')",
                    playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
                    
                mysql_tquery(dbCon, insertLog); 
                KickEx(playerid);        
            }

            if (playerData[playerid][pAccount] >= 10000000)
            {
                foreach(new i : Player) {
                    PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
                }

                SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s �١ẹ�� System ���˵�: ͸Ժ�·�����Թ�ͧ�س", ReturnPlayerName(playerid));
                Log(adminactionlog, INFO, "%s �١ẹ�� System ���˵� ͸Ժ�·�����Թ�ͧ�س", ReturnPlayerName(playerid));

                new insertLog[256];
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', '͸Ժ�·�����Թ�ͧ�س', '%e', '%e', 'System')",
                    playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
                
                mysql_tquery(dbCon, insertLog); 
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', '͸Ժ�·�����Թ�ͧ�س, 'System', '%e')",
                    playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
                    
                mysql_tquery(dbCon, insertLog); 
                KickEx(playerid);        
            }

            if (playerData[playerid][pSavingsCollect] >= 10000000)
            {
                foreach(new i : Player) {
                    PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
                }

                SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s �١ẹ�� System ���˵�: ͸Ժ�·�����Թ�ͧ�س", ReturnPlayerName(playerid));
                Log(adminactionlog, INFO, "%s �١ẹ�� System ���˵� ͸Ժ�·�����Թ�ͧ�س", ReturnPlayerName(playerid));

                new insertLog[256];
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', '͸Ժ�·�����Թ�ͧ�س', '%e', '%e', 'System')",
                    playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
                
                mysql_tquery(dbCon, insertLog); 
                
                mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', '͸Ժ�·�����Թ�ͧ�س, 'System', '%e')",
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
    SendClientMessage(playerid, COLOR_GRAD1, " �ԡѴ�ش����ٻ���� Los Santos");

    return 1;
}    

CMD:gotosellore(playerid, params[])
{
    SetPlayerCheckpoint(playerid, 2573.5747,-2219.6809,13.5469, 4.0);
    SendClientMessage(playerid, COLOR_GRAD1, " �ԡѴ�ش������� Los Santos");

    return 1;
}    
