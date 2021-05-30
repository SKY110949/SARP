#include <YSI\y_hooks>

hook OnGameModeInit()
{
    CreateDynamicPickup(1239, 2, 364.4595, 173.6485, 1008.3828);
	CreateDynamic3DTextLabel("����� "EMBED_YELLOW"/tickets"EMBED_WHITE"\n���ͨ��¤�һ�Ѻ", -1, 364.4595,173.6485,1008.3828, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 2016, 3);
	CreateDynamic3DTextLabel("����� "EMBED_YELLOW"/tickets"EMBED_WHITE"\n���ͨ��¤�һ�Ѻ", -1, 364.4595,173.6485,1008.3828, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 2017, 3);

    CreateDynamicPickup(1239, 2, 321.3057, 161.8132, 1014.1797);
    CreateDynamic3DTextLabel("����� "EMBED_YELLOW"/healme"EMBED_WHITE"\n�����ѡ�ҵ���ͧ ($1,000)", -1, 321.3057,161.8132,1014.1797, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 3);

}

CMD:buybox(playerid, params[])
{
    Dialog_Show(playerid, BuyBox, DIALOG_STYLE_LIST, "���ͧ Donate", "���ͧ Lucky Box (���ͧ�� 50 ���)\n���ͧ Staple Box (���ͧ�� 50 ���)\n���ͧ Double Staple Box (���ͧ�� 90 ���)\n{FF6347}Christmas Box {FFFF00}V.1 (���ͧ�� 50 ���) {FF0000}HOT!!\n{FF6347}Christmas Box {FFFF00}V.2 (���ͧ�� 90 ���) {FF0000}HOT!!", "��ŧ", "¡��ԡ");
    return 1;
}

CMD:openbox(playerid, params[])
{
    new giveSz[12];

	if (sscanf(params, "s[32]", giveSz)) {
	    SendClientMessage(playerid, COLOR_GRAD1, "�����: /openbox [�ʹա��ͧ]");
	    return SendClientMessage(playerid, COLOR_GREEN, "��¡�� :{FFFFFF} 1.LuckyBox, 2.StapleBox, 3.DoubleStapleBox, 4.Christmas Box V.1, 5.Christmas Box V.2");
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
                        return SendClientMessage(playerid, COLOR_GRAD1, "�س����ա��ͧ Lucky Box (/buybox ���ͫ���)");

                    playerData[playerid][pLuckyBox] -= 1;

                    GivePlayerMoneyEx(playerid, 50000);
                    SendClientMessage(playerid, COLOR_WHITE, "�س���Ѻ�Թ�ӹǹ {FF8000}$50,000 �ҡ����Դ���ͧ {FF8000}Lucky Box");
                }
                case 1..15:
                {
                    if (playerData[playerid][pLuckyBox] < 0)
                        return SendClientMessage(playerid, COLOR_GRAD1, "�س����ա��ͧ Lucky Box (/buybox ���ͫ���)");

                    playerData[playerid][pLuckyBox] -= 1;

                    playerData[playerid][pRMoney] += 70000;
                    SendClientMessage(playerid, COLOR_WHITE, "�س���Ѻ�Թᴧ {FF8000}$70,000 �ҡ����Դ���ͧ {FF8000}Lucky Box");
                }
                case 16..40:
                {
                    if (playerData[playerid][pLuckyBox] < 0)
                        return SendClientMessage(playerid, COLOR_GRAD1, "�س����ա��ͧ Lucky Box (/buybox ���ͫ���)");

                    playerData[playerid][pLuckyBox] -= 1;

                    playerData[playerid][pIrons] += 1500;
                    SendClientMessage(playerid, COLOR_WHITE, "�س���Ѻ������ѧ����ҹ������ٻ {FF8000}1,500 ��� �ҡ����Դ���ͧ {FF8000}Lucky Box");
                }
                default:
                {
                    if (playerData[playerid][pLuckyBox] < 0)
                        return SendClientMessage(playerid, COLOR_GRAD1, "�س����ա��ͧ Lucky Box (/buybox ���ͫ���)");

                    playerData[playerid][pLuckyBox] -= 1;

                    GivePlayerMoneyEx(playerid, 30000);
                    SendClientMessage(playerid, COLOR_WHITE, "�س���Ѻ�Թ�ӹǹ {FF8000}$30,000 �ҡ����Դ���ͧ {FF8000}Lucky Box");
                }
            }
        }
        else return SendClientMessage(playerid, COLOR_GRAD1, "�س����ա��ͧ Lucky Box (/buybox ���ͫ���)");
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

            SendClientMessage(playerid, COLOR_GREEN, "�س���Ѻ Materials �ӹǹ 100 ���, ������� �ӹǹ 150 ���, ����ҹ �ӹǹ 150 ���, ����ѧ����ҹ������ٻ �ӹǹ 150 ���, �ê 100 ���");
            return 1;
        }
        else return SendClientMessage(playerid, COLOR_GRAD1, "�س����ա��ͧ Staple Box (/buybox ���ͫ���)");
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

            SendClientMessage(playerid, COLOR_GREEN, "�س���Ѻ Materials �ӹǹ 160 ���, ������� �ӹǹ 200 ���, ����ҹ �ӹǹ 200 ���, ����ѧ����ҹ������ٻ �ӹǹ 200 ���, �ê 160 ���");
            return 1;
        }
        else return SendClientMessage(playerid, COLOR_GRAD1, "�س����ա��ͧ Double Staple Box (/buybox ���ͫ���)");
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
                        return SendClientMessage(playerid, COLOR_GRAD1, "�س����ա��ͧ Christmas Box V.1 (/buybox ���ͫ���)");

                    playerData[playerid][pChristmas] -= 1;
                    playerData[playerid][pHair] = 1;

                    OnAccountUpdate(playerid);
                    //OnAccountUpdate(playerid);
                    SendClientMessage(playerid, COLOR_YELLOW, "[ChirstmasV.1]: {FFFFFF}���ʴ������Թ�մ���, �س���Ѻ�Է�Ծ����㹡�èѴ�觷ç�������ҹ�Ѵ�� Los Santos ���� (/hair)");
                }
                case 1: // Name
                { 
                    if (playerData[playerid][pChristmas] < 0)
                        return SendClientMessage(playerid, COLOR_GRAD1, "�س����ա��ͧ Christmas Box V.1 (/buybox ���ͫ���)");

                    playerData[playerid][pChristmas] -= 1;
                    playerData[playerid][pChangeName] += 1;

                    OnAccountUpdate(playerid);
                    SendClientMessage(playerid, COLOR_YELLOW, "[ChirstmasV.1]: {FFFFFF}���ʴ������Թ�մ���, �س���Ѻ�ѵ�����¹���� 1 � (/changename)");
                }
                case 2: // Score
                {
                    new randomnumber = randomEx(50,100);

                    if (playerData[playerid][pChristmas] < 0)
                        return SendClientMessage(playerid, COLOR_GRAD1, "�س����ա��ͧ Christmas Box V.1 (/buybox ���ͫ���)");

                    playerData[playerid][pChristmas] -= 1;
                    playerData[playerid][pScore] += randomnumber;

                    OnAccountUpdate(playerid);
                    //OnAccountUpdate(playerid);
                    SendClientMessageEx(playerid, COLOR_YELLOW, "[ChirstmasV.1]: {FFFFFF}���ʴ������Թ�մ���, �س���Ѻ Score �ӹǹ %d �ҡ����Դ���ͧ", randomnumber);
                }
                default:
                {
                    new randomnumber = randomEx(1,2);

                    if (playerData[playerid][pChristmas] < 0)
                        return SendClientMessage(playerid, COLOR_GRAD1, "�س����ա��ͧ Christmas Box V.1 (/buybox ���ͫ���)");

                    playerData[playerid][pChristmas] -= 1;
                    playerData[playerid][pKeyBox] += randomnumber;

                    OnAccountUpdate(playerid);
                    //OnAccountUpdate(playerid);
                    SendClientMessageEx(playerid, COLOR_YELLOW, "[ChirstmasV.1]: {FFFFFF}���ʴ������Թ�մ���, �س���Ѻ�ح����� �ӹǹ %d �ҡ����Դ���ͧ", randomnumber);
                }
            }
        }
        else return SendClientMessage(playerid, COLOR_GRAD1, "�س����ա��ͧ Christmas Box V.1 (/buybox ���ͫ���)");
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

            SendClientMessage(playerid, COLOR_LIGHTRED, "[ChirstmasV.2]: {FFFFFF}���ʴ������Թ�մ���, �س���Ѻ�ѵ�����¹���� 1 � (/changename)");
            SendClientMessage(playerid, COLOR_YELLOW, "[ChirstmasV.2]: {FFFFFF}���ʴ������Թ�մ���, �س���Ѻ�Է�Ծ����㹡�èѴ�觷ç�������ҹ�Ѵ�� Los Santos ���� (/hair)");
            SendClientMessageEx(playerid, COLOR_LIGHTRED, "[ChirstmasV.2]: {FFFFFF}���ʴ������Թ�մ���, �س���Ѻ�ح����� �ӹǹ %d �ҡ����Դ���ͧ", randomnumber);
            SendClientMessage(playerid, COLOR_YELLOW, "[ChirstmasV.2]: {FFFFFF}���ʴ������Թ�մ���, �س���Ѻ Score �ӹǹ 200 �ҡ����Դ���ͧ");
        }
        else return SendClientMessage(playerid, COLOR_GRAD1, "�س����ա��ͧ Christmas Box V.2 (/buybox ���ͫ���)");
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
                    return SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ�� Point �ҡ���� 50 ��� (�ô����Թ��ҹ�ҧྨ)");
            
                playerData[playerid][pLuckyBox] += 1;
                playerData[playerid][pPoint] -= 50;
                SendClientMessage(playerid, COLOR_YELLOW, "�س����͡��ͧ Lucky Box ��Ҥ� 50 ��� (/openbox �����Դ���ͧ����)");
            }

	        case 1:
	        {
                if (playerData[playerid][pPoint] < 50)
                    return SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ�� Point �ҡ���� 50 ��� (�ô����Թ��ҹ�ҧྨ)");
            
                playerData[playerid][pBox] += 1;
                playerData[playerid][pPoint] -= 50;
                SendClientMessage(playerid, COLOR_YELLOW, "�س����͡��ͧ Staple Box ��Ҥ� 50 ��� (/openbox �����Դ���ͧ����)");
            }

	        case 2:
	        {
                if (playerData[playerid][pPoint] < 90)
                    return SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ�� Point �ҡ���� 90 ��� (�ô����Թ��ҹ�ҧྨ)");
            
                playerData[playerid][pDBox] += 1;
                playerData[playerid][pPoint] -= 90;
                SendClientMessage(playerid, COLOR_YELLOW, "�س����͡��ͧ Double Staple Box ��Ҥ� 90 ��� (/openbox �����Դ���ͧ����)");
            }

	        case 3:
	        {
                if (playerData[playerid][pPoint] < 50)
                    return SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ�� Point �ҡ���� 50 ��� (�ô����Թ��ҹ�ҧྨ)");
            
                playerData[playerid][pChristmas] += 1;
                playerData[playerid][pPoint] -= 50;
                SendClientMessage(playerid, COLOR_YELLOW, "�س����͡��ͧ Christmas Box V.1 ��Ҥ� 50 ��� (/openbox �����Դ���ͧ����)");
            }

	        case 4:
	        {
                if (playerData[playerid][pPoint] < 90)
                    return SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ�� Point �ҡ���� 90 ��� (�ô����Թ��ҹ�ҧྨ)");
            
                playerData[playerid][pChristmasx] += 1;
                playerData[playerid][pPoint] -= 90;
                SendClientMessage(playerid, COLOR_YELLOW, "�س����͡��ͧ Christmas Box V.2 ��Ҥ� 90 ��� (/openbox �����Դ���ͧ����)");
            }
        }
    }
    return 1;
}

CMD:changename(playerid, params[])
{
    if (playerData[playerid][pChangeName] < 1)
        return SendClientMessage(playerid, COLOR_GRAD1, "�س����պѵ�����¹����");

    Dialog_Show(playerid, DialogNameChangeEvent, DIALOG_STYLE_INPUT, "���͡���ͼ����ͧ�س:","�ٻẺ: "EMBED_ORANGE"Firstname_Lastname"EMBED_DIALOG" (������й��ʡ�ŵ���á��"EMBED_LIGHTRED"������˭�"EMBED_DIALOG"\n�͡������Ǿ������� ����բմ��鹷ҧ�����ҧ������й��ʡ��)","����¹","�͡");
    return 1;
}

/*CMD:givekey(playerid, params[])
{
	new
	    targetid, 
		amount,
		str[128];

	if (sscanf(params, "ud", targetid, amount))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /givekey [�ʹռ�����/���ͺҧ��ǹ] [�ӹǹ]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");

	if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������س");

	if (targetid == playerid)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö���حᨡѺ����ͧ��");

	if (amount < 1)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �ô�кبӹǹ����ҡ���� 1 �ح�");

	if (amount > playerData[playerid][pKeyBox])
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س������աح������ҡ��Ҵ���");

	if (amount > 5)
	{
		format(str, sizeof(str), "AdmWarn: %s (%d) ���ͺ�ح����� ��� %s (%d) �繨ӹǹ %d", ReturnRealName(playerid), playerid, ReturnRealName(targetid), targetid, amount);
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, str);
	}

	playerData[playerid][pKeyBox] -= amount;
	playerData[targetid][pKeyBox] += amount;

	SendClientMessageEx(playerid, COLOR_GRAD1, "   �س�����ح����Шӹǹ %d �Ѻ %s", amount, ReturnRealName(targetid));
	SendClientMessageEx(targetid, COLOR_GRAD1, "   �س���Ѻ�ح�����ӹǹ %d �ҡ %s", amount, ReturnRealName(playerid));

	//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s ��ѡ Point �͡�Һҧ��ǹ������������ͧ͢ %s", ReturnRealName(playerid), ReturnRealName(targetid));
	Log(transferlog, INFO, "%s ���ح��������Ѻ %s �ӹǹ %d", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount);
	
	return 1;
}*/

CMD:event(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "============================================================================================");
    SendClientMessage(playerid, COLOR_YELLOW, ":: Christmas Event :: (�Ԩ����������鹵���� 18/12/2019 �֧�ѹ��� 5/01/2020");
    SendClientMessageEx(playerid, COLOR_WHITE, "�ӹǹ�ح����з��س�� : {FFFF00}%d �͡", playerData[playerid][pKeyBox]);
    SendClientMessageEx(playerid, COLOR_YELLOW, "- �ͧ�ҧ��� NRG-500 : {FFFF00}%d/60 �͡", playerData[playerid][pKeyBox]);
    SendClientMessageEx(playerid, COLOR_YELLOW, "- �ͧ�ҧ��� Bullet : {FFFF00}%d/50 �͡", playerData[playerid][pKeyBox]);

    SendClientMessage(playerid, COLOR_LIGHTRED, "�����˵� : �ҡ�س�纡ح����Фú�ӹǹ����к���ͧ�������, ���س�ӡ�õԴ���ྨ�����š�ͧ�ҧ���");
    SendClientMessage(playerid, COLOR_GREEN, "============================================================================================");

    return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, "AdmCmd: %s ��ͧʧ�����ҡ��ѧ�������������� (Teleport Hack)", ReturnPlayerName(playerid));
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
		Dialog_Show(playerid, DialogNameChangeEvent, DIALOG_STYLE_INPUT, "���͡���ͼ����ͧ�س:",""EMBED_DIALOG"��Ǩ����ͼԴ��Ҵ: "EMBED_LIGHTRED"���͹���������ö��ҹ��"EMBED_DIALOG"\n\n�ٻẺ: "EMBED_ORANGE"Firstname_Lastname"EMBED_DIALOG" (������й��ʡ�ŵ���á��"EMBED_LIGHTRED"������˭�"EMBED_DIALOG"\n�͡������Ǿ������� ����բմ��鹷ҧ�����ҧ������й��ʡ��)","����¹","�͡");
	}
	return 1;
}

forward isExistUsernameEvent(playerid, const name[]);
public isExistUsernameEvent(playerid, const name[])
{
	new rows;
	cache_get_row_count(rows);
	if (rows) {
		Dialog_Show(playerid, DialogNameChangeEvent, DIALOG_STYLE_INPUT, "���͡���ͼ����ͧ�س:",""EMBED_DIALOG"��Ǩ����ͼԴ��Ҵ: "EMBED_LIGHTRED"���ͼ��������١������"EMBED_DIALOG"\n\n�ٻẺ: "EMBED_ORANGE"Firstname_Lastname"EMBED_DIALOG" (������й��ʡ�ŵ���á��"EMBED_LIGHTRED"������˭�"EMBED_DIALOG"\n�͡������Ǿ������� ����բմ��鹷ҧ�����ҧ������й��ʡ��)","����¹","�͡");
	}
	else {
        if (playerData[playerid][pChangeName] < 1) {
            return SendClientMessage(playerid, COLOR_LIGHTRED, "�س����պѵ�����¹���� (/donate)");
        }
        playerData[playerid][pChangeName] -= 1;
        SendClientMessageEx(playerid, COLOR_YELLOW, "�س�����������¹���ͧ͢�س�ҡ %s ��� %s", ReturnPlayerName(playerid), name);
        Log(donatelog, INFO, "%s ��������� Event ����¹���ͻ�����", ReturnPlayerName(playerid));
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
