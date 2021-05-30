#include <YSI\y_hooks>

hook OnGameModeInit()
{
    CreateDynamicPickup(1239, 2, 1026.2266, 2279.7322, 10.8203);
    CreateDynamic3DTextLabel("�ç�ҹ��Ե�Թ�׹���͹\n����� /buymats ���ͫ��ʹԹ�׹�ҡ�ç�ҹ", -1, 1026.2266, 2279.7322, 10.8203, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

    CreateDynamicPickup(1239, 2, 1405.7090,-1298.5753,13.5441);
    CreateDynamic3DTextLabel("�ش�觴Թ�׹ Main Street\n����� /dropmats �����Ѻ�Թ�׹�繢ͧ�ͺ᷹", -1, 1405.7090,-1298.5753,13.5441, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

    //CreateDynamicPickup(1239, 2, 2872.1440, 945.7526, 10.7500);
    //CreateDynamic3DTextLabel("ʶҹ����Сͺ���ظ\n����� /createweapon �������ҧ���ظ�׹", COLOR_YELLOW,  2872.1440, 945.7526, 10.7500, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

}

CMD:buymats(playerid, params[])
{
	if (IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧŧ�ҡö!");

    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1026.2266, 2279.7322, 10.8203)) 
        return SendClientMessage(playerid, COLOR_GRAD1, "�س������������ç�ҹ��Ե�Թ�׹");

    if (GetPlayerMoney(playerid) < 1000)
        return SendClientMessage(playerid, COLOR_GRAD1, "   �س��������Թ�ҡ��Ҵ��� ($1,000)");

    if (playerData[playerid][pCPMaterials] != 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "�س���������ҧ��ë��ʹԹ�׹, �ô�ӴԹ�׹���س��������ѧ��ҹ�ҧ������� Los Santos");

    else {

        playerData[playerid][pCPMaterials] = 3;
        GivePlayerMoneyEx(playerid, -3000);

        //playerData[playerid][pMaterials] = 1;

        SendClientMessage(playerid, COLOR_GRAD1, "  �س���Ѻ�Թ�׹�Ҩӹǹ 30 ���, ����ѧ�ش�觴Թ�׹ Main Street �����Ѻ�Թ�׹�ͧ�س (/gotomats)");
        
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** ��ͤ�Ң�´Թ�׹ : ��� Package ����մԹ�׹ 10 �ѹ���Ѻ %s", ReturnRealName(playerid));
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ����Ժ Package �ҡ��ͤ�Ң�´Թ�׹����˹�������Ǣͧ��", ReturnRealName(playerid));
    }    

    return 1;
}

CMD:dropmats(playerid, params[])
{
	if (IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧŧ�ҡö!");

    if (!IsPlayerInRangeOfPoint(playerid, 5.0, 1405.7090,-1298.5753,13.5441)) 
        return SendClientMessage(playerid, COLOR_GRAD1, "�س�����������ش�觴Թ�׹ Main Street");

    if (playerData[playerid][pCPMaterials] == 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "�س������մԹ�׹����㹵��, �ô���ʹԹ�׹��͹���觴Թ�׹�����ش�觴Թ�׹ Main Street");

    if (playerData[playerid][pCPMaterials] == 3)
    {
        //DisablePlayerCheckpoint(playerid);
        SendClientMessage(playerid, COLOR_YELLOW, "  �س���Ѻ�Թ�׹�ӹǹ 30 �ѹ�ҡ��÷ӧҹ�觴Թ�׹���Ѻ�ç�ҹ��Ե�Թ�׹ ..");
        
        //GivePlayerMoneyEx(playerid, 6000);
        playerData[playerid][pMaterials] += 30;
        playerData[playerid][pCPMaterials] = 0;

        DisablePlayerCheckpoint(playerid);
        OnAccountUpdate(playerid);
    }

    return 1;
}

CMD:mymats(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "l__________MATERIALS__________l");
    SendClientMessageEx(playerid, COLOR_WHITE, "�Թ�׹ {33AA33}: %d", playerData[playerid][pMaterials]);
    return 1;
}

CMD:give(playerid, params[]) 
{
	new
	    giveSz[12],
		amount,
		targetID,
		gString[512];

	if(playerData[playerid][pPlayingHours] < 2)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�ժ�������͹�Ź��ҡ���� 2 �������");

	else if (sscanf(params, "us[32]d", targetID, giveSz, amount)) {
	    SendClientMessage(playerid, COLOR_GRAD1, "�����: /give [�ʹռ�����/���ͺҧ��ǹ] [��¡��] [�ӹǹ]");
	    return SendClientMessage(playerid, COLOR_WHITE, "��¡�� : Materials, Ore, Cold, Irons, Diamond");
	}
	else {
	    if (targetID == INVALID_PLAYER_ID) 
            return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�鹵Ѵ�����������");
	    
        if (!IsPlayerNearPlayer(playerid, targetID, 5.0))
            return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������س");

	    if(strcmp(giveSz, "materials", true) == 0) {

	        if (playerData[playerid][pPlayingHours] < 2)
	    		return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�ժ�������͹�Ź��ҡ���� 2 �������");

            if (playerData[playerid][pMaterials] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "   �س������� Materials �ҡ�֧��Ҵ���");

            if (targetID == playerid)
                return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö��� Materials �Ѻ����ͧ��");

            if (amount < 1)
                return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�кبӹǹ�ҡ���� 1");

            if (amount > 400)
            {
                format(gString, sizeof(gString), "AdmWarn: %s ���ͺ Materials ��� %s �繨ӹǹ %d", ReturnRealName(playerid), ReturnRealName(targetID), amount);
                SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, gString);
            }

            playerData[playerid][pMaterials] -= amount;
            playerData[targetID][pMaterials] += amount;

            SendClientMessageEx(playerid, COLOR_YELLOW, "�س����� Materials �ӹǹ %d ���Ѻ %s", amount, ReturnRealName(targetID));
            SendClientMessageEx(targetID, COLOR_YELLOW, "�س���Ѻ Materials �ӹǹ %d �ҡ %s", amount, ReturnRealName(targetID));

		    SendNearbyMessage(playerid, 25.0, COLOR_PURPLE, "> %s ����Ժ�Թ�׹�ӹǹ %d �����ͺ���Ѻ %s", ReturnRealName(playerid), amount, ReturnRealName(targetID));
		    SendNearbyMessage(targetID, 25.0, COLOR_PURPLE, "> %s ���Ѻ�Թ�׹�ҡ��ͧ͢ %s �繨ӹǹ %d", ReturnRealName(targetID), ReturnRealName(playerid), amount);
 		
            return 1; 
        }

	    if(strcmp(giveSz, "Ore", true) == 0) {

	        if (playerData[playerid][pPlayingHours] < 2)
	    		return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�ժ�������͹�Ź��ҡ���� 2 �������");

            if (playerData[playerid][pOre] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "   �س������� Irons �ҡ�֧��Ҵ���");

            if (targetID == playerid)
                return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö��� Irons �Ѻ����ͧ��");

            if (amount < 1)
                return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�кبӹǹ�ҡ���� 1");

            if (amount > 400)
            {
                format(gString, sizeof(gString), "AdmWarn: %s ���ͺ Irons ��� %s �繨ӹǹ %d", ReturnRealName(playerid), ReturnRealName(targetID), amount);
                SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, gString);
            }

            playerData[playerid][pIrons] -= amount;
            playerData[targetID][pIrons] += amount;

            SendClientMessageEx(playerid, COLOR_YELLOW, "�س����� Irons �ӹǹ %d ���Ѻ %s", amount, ReturnRealName(targetID));
            SendClientMessageEx(targetID, COLOR_YELLOW, "�س���Ѻ Irons �ӹǹ %d �ҡ %s", amount, ReturnRealName(targetID));

		    SendNearbyMessage(playerid, 25.0, COLOR_PURPLE, "> %s ����Ժ������硨ӹǹ %d �����ͺ���Ѻ %s", ReturnRealName(playerid), amount, ReturnRealName(targetID));
		    SendNearbyMessage(targetID, 25.0, COLOR_PURPLE, "> %s ���Ѻ������硨ҡ��ͧ͢ %s �繨ӹǹ %d", ReturnRealName(targetID), ReturnRealName(playerid), amount);
 		
            return 1; 
        }

	    if(strcmp(giveSz, "cold", true) == 0) {

	        if (playerData[playerid][pPlayingHours] < 2)
	    		return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�ժ�������͹�Ź��ҡ���� 2 �������");

            if (playerData[playerid][pCold] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "   �س������� Cold �ҡ�֧��Ҵ���");

            if (targetID == playerid)
                return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö��� Cold �Ѻ����ͧ��");

            if (amount < 1)
                return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�кبӹǹ�ҡ���� 1");

            if (amount > 400)
            {
                format(gString, sizeof(gString), "AdmWarn: %s ���ͺ Cold ��� %s �繨ӹǹ %d", ReturnRealName(playerid), ReturnRealName(targetID), amount);
                SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, gString);
            }

            playerData[playerid][pCold] -= amount;
            playerData[targetID][pCold] += amount;

            SendClientMessageEx(playerid, COLOR_YELLOW, "�س����� Cold �ӹǹ %d ���Ѻ %s", amount, ReturnRealName(targetID));
            SendClientMessageEx(targetID, COLOR_YELLOW, "�س���Ѻ Cold �ӹǹ %d �ҡ %s", amount, ReturnRealName(targetID));

		    SendNearbyMessage(playerid, 25.0, COLOR_PURPLE, "> %s ����Ժ����ҹ�ӹǹ %d �����ͺ���Ѻ %s", ReturnRealName(playerid), amount, ReturnRealName(targetID));
		    SendNearbyMessage(targetID, 25.0, COLOR_PURPLE, "> %s ���Ѻ����ҹ�ҡ��ͧ͢ %s �繨ӹǹ %d", ReturnRealName(targetID), ReturnRealName(playerid), amount);
 		
            return 1; 
        }

	    if(strcmp(giveSz, "Irons", true) == 0) {

	        if (playerData[playerid][pPlayingHours] < 2)
	    		return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�ժ�������͹�Ź��ҡ���� 2 �������");

            if (playerData[playerid][pIrons] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "   �س������� Ore �ҡ�֧��Ҵ���");

            if (targetID == playerid)
                return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö��� Ore �Ѻ����ͧ��");

            if (amount < 1)
                return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�кبӹǹ�ҡ���� 1");

            if (amount > 400)
            {
                format(gString, sizeof(gString), "AdmWarn: %s ���ͺ Ore ��� %s �繨ӹǹ %d", ReturnRealName(playerid), ReturnRealName(targetID), amount);
                SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, gString);
            }

            playerData[playerid][pOre] -= amount;
            playerData[targetID][pOre] += amount;

            SendClientMessageEx(playerid, COLOR_YELLOW, "�س����� Ore �ӹǹ %d ���Ѻ %s", amount, ReturnRealName(targetID));
            SendClientMessageEx(targetID, COLOR_YELLOW, "�س���Ѻ Ore �ӹǹ %d �ҡ %s", amount, ReturnRealName(targetID));

		    SendNearbyMessage(playerid, 25.0, COLOR_PURPLE, "> %s ����Ժ������ѧ����ҹ������ٻ�ӹǹ %d �����ͺ���Ѻ %s", ReturnRealName(playerid), amount, ReturnRealName(targetID));
		    SendNearbyMessage(targetID, 25.0, COLOR_PURPLE, "> %s ���Ѻ������ѧ����ҹ������ٻ�ҡ��ͧ͢ %s �繨ӹǹ %d", ReturnRealName(targetID), ReturnRealName(playerid), amount);
 		
            return 1; 
        }

	    if(strcmp(giveSz, "diamond", true) == 0) {

	        if (playerData[playerid][pPlayingHours] < 2)
	    		return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�ժ�������͹�Ź��ҡ���� 2 �������");

            if (playerData[playerid][pDiamond] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "   �س������� Diamond �ҡ�֧��Ҵ���");

            if (targetID == playerid)
                return SendClientMessage(playerid, COLOR_GRAD1, "   �س�������ö��� Diamond �Ѻ����ͧ��");

            if (amount < 1)
                return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�кبӹǹ�ҡ���� 1");

            if (amount > 400)
            {
                format(gString, sizeof(gString), "AdmWarn: %s ���ͺ Diamond ��� %s �繨ӹǹ %d", ReturnRealName(playerid), ReturnRealName(targetID), amount);
                SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, gString);
            }

            playerData[playerid][pDiamond] -= amount;
            playerData[targetID][pDiamond] += amount;

            SendClientMessageEx(playerid, COLOR_YELLOW, "�س����� Diamond �ӹǹ %d ���Ѻ %s", amount, ReturnRealName(targetID));
            SendClientMessageEx(targetID, COLOR_YELLOW, "�س���Ѻ Diamond �ӹǹ %d �ҡ %s", amount, ReturnRealName(targetID));

		    SendNearbyMessage(playerid, 25.0, COLOR_PURPLE, "> %s ����Ժ����ê�ӹǹ %d �����ͺ���Ѻ %s", ReturnRealName(playerid), amount, ReturnRealName(targetID));
		    SendNearbyMessage(targetID, 25.0, COLOR_PURPLE, "> %s ���Ѻ����ê�ҡ��ͧ͢ %s �繨ӹǹ %d", ReturnRealName(targetID), ReturnRealName(playerid), amount);
 		
            return 1; 
        }
        else SendClientMessage(playerid, COLOR_GRAD1, "�س�к���¡�üԴ��Ҵ ..");
    }
    return 1;
}


CMD:gotomats(playerid, params[])
{
    SetPlayerCheckpoint(playerid, 1405.7090,-1298.5753,13.5441, 4.0);
    SendClientMessage(playerid, COLOR_GRAD1, "  �ش�ԡѴ�ͧ����觴Թ�׹ Main Street");

    return 1;
}

/*CMD:createweapon(playerid, params[])
{
	if (IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧŧ�ҡö!");

    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 2872.1440, 945.7526, 10.7500)) 
        return SendClientMessage(playerid, COLOR_GRAD1, "�س�����������ʶҹ����Сͺ���ظ");

    Dialog_Show(playerid, WeaponPickup, DIALOG_STYLE_LIST, "ʶҹ����Сͺ���ظ", "9mm (�Թ�׹ 500, ���� 120, ��ҹ 120)\nDesert Eagle (�Թ�׹ 700, ���� 300, ��ҹ 300)\nShotgun (�Թ�׹ 700, ���� 300, ��ҹ 300)\nUZI (�Թ�׹ 1,100, ���� 600, ��ҹ 600, �ê 400)", "��ŧ", "¡��ԡ");
    return 1;
}

Dialog:WeaponPickup(playerid, response, listitem, inputtext[]) 
{
	if(response)
	{
    	switch (listitem)
	    {
	        case 0: // 9mm
	        {
                if (playerData[playerid][pMaterials] < 500)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�մԹ�׹�ҡ���� 500");

                if (playerData[playerid][pOre] < 120)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�������ҡ���� 120");

                if (playerData[playerid][pCold] < 120)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�ն�ҹ�ҡ���� 120");

                GivePlayerValidWeapon(playerid, 22, 100);
                OnAccountUpdate(playerid);

                playerData[playerid][pMaterials] -= 500;
                playerData[playerid][pOre] -= 120;
                playerData[playerid][pCold] -= 120;

                SendClientMessage(playerid, COLOR_YELLOW, "�س���Ѻ���ظ�׹ 9mm ���٭���´Թ�׹ 500, ���� 120, ����ҹ 120, �ô���ѧ���˹�ҷ����Ǩ ..");
                SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ������ظ�׹ 9mm �͡�ҡʶҹ����Сͺ���ظ", ReturnRealName(playerid));
            }
	        case 1: // Desert Eagle
	        {
                if (playerData[playerid][pMaterials] < 700)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�մԹ�׹�ҡ���� 700");

                if (playerData[playerid][pOre] < 300)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�������ҡ���� 300");

                if (playerData[playerid][pCold] < 300)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�ն�ҹ�ҡ���� 300");

                GivePlayerValidWeapon(playerid, 24, 100);
                OnAccountUpdate(playerid);

                playerData[playerid][pMaterials] -= 700;
                playerData[playerid][pOre] -= 300;
                playerData[playerid][pCold] -= 300;

                SendClientMessage(playerid, COLOR_YELLOW, "�س���Ѻ���ظ�׹ Desert Eagle ���٭���´Թ�׹ 700, ���� 300, ����ҹ 300, �ô���ѧ���˹�ҷ����Ǩ ..");
                SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ������ظ�׹ Desert Eagle �͡�ҡʶҹ����Сͺ���ظ", ReturnRealName(playerid));
            }
	        case 2: // Shotgun
	        {
                if (playerData[playerid][pMaterials] < 700)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�մԹ�׹�ҡ���� 700");

                if (playerData[playerid][pOre] < 300)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�������ҡ���� 300");

                if (playerData[playerid][pCold] < 300)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�ն�ҹ�ҡ���� 300");

                GivePlayerValidWeapon(playerid, 25, 100);
                OnAccountUpdate(playerid);

                playerData[playerid][pMaterials] -= 700;
                playerData[playerid][pOre] -= 300;
                playerData[playerid][pCold] -= 300;

                SendClientMessage(playerid, COLOR_YELLOW, "�س���Ѻ���ظ�׹ Shotgun ���٭���´Թ�׹ 700, ���� 300, ����ҹ 300, �ô���ѧ���˹�ҷ����Ǩ ..");
                SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ������ظ�׹ Shotgun �͡�ҡʶҹ����Сͺ���ظ", ReturnRealName(playerid));
            }
	        case 3: // UZI
	        {
                if (playerData[playerid][pMaterials] < 1100)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�մԹ�׹�ҡ���� 1,100");

                if (playerData[playerid][pOre] < 600)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�������ҡ���� 600");

                if (playerData[playerid][pCold] < 600)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ�ն�ҹ�ҡ���� 600");

                if (playerData[playerid][pDiamond] < 400)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧ���ê�ҡ���� 400");

                GivePlayerValidWeapon(playerid, 28, 300);
                OnAccountUpdate(playerid);

                playerData[playerid][pMaterials] -= 1100;
                playerData[playerid][pOre] -= 600;
                playerData[playerid][pCold] -= 600;
                playerData[playerid][pDiamond] -= 400;

                SendClientMessage(playerid, COLOR_YELLOW, "�س���Ѻ���ظ�׹ UZI ���٭���´Թ�׹ 1,100, ���� 600, ����ҹ 600, ����ê 400, �ô���ѧ���˹�ҷ����Ǩ ..");
                SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ������ظ�׹ UZI �͡�ҡʶҹ����Сͺ���ظ", ReturnRealName(playerid));
            }
        }
    }

    return 1;
}*/
