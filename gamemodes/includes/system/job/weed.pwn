#include <YSI\y_hooks>

/*new
    CPCannabis[MAX_PLAYERS];*/

hook OnGameModeInit()
{
    CreateDynamicPickup(1239, 2, 1248.8494, 365.6281, 19.5547);
    CreateDynamic3DTextLabel("���觼�Ե�ѭ�ҼԴ������\n����� /cannabis �������͡���͡ѭ��", -1, 1248.8494, 365.6281, 19.5547, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

    CreateDynamicPickup(1239, 2, -391.3606, 2221.5217, 42.4297);
    CreateDynamic3DTextLabel("�����ҹ��ҧ\n����� /dropweed �����觡ѭ��", -1, -391.3606, 2221.5217, 42.4297, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
}

CMD:cannabis(playerid, params[])
{
	if (IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧŧ�ҡö!");

    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1248.8494, 365.6281, 19.5547)) 
        return SendClientMessage(playerid, COLOR_GRAD1, "�س������������¡ѭ��");

    if (playerData[playerid][pCannabis] != 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "�س���������ҧ������ͺ�ѭ��, �ô����áԨ�������稡�͹��������ҹ�ա����");

    if (playerData[playerid][pCPCannabis] != 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "�س���������ҧ������ͺ�ѭ��, �ô�觡ѭ������١��ҡ�͹��������ҹ�ա����");

    Dialog_Show(playerid, CannabisPickup, DIALOG_STYLE_LIST, "���͡���͡ѭ�ҼԴ������", "�ѭ�� (�����ͧ) - $5,000\n�ѭ�� (��������Թ) - $9,000\n�ѭ�� (�����෻��) - $8,000", "��ŧ", "¡��ԡ");

    return 1;
}

CMD:dropweed(playerid, params[])
{
	if (IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_GRAD1, "   �س��ͧŧ�ҡö!");

    if (!IsPlayerInRangeOfPoint(playerid, 3.0, -391.3606, 2221.5217, 42.4297)) 
        return SendClientMessage(playerid, COLOR_GRAD1, "�س������������¡ѭ��");

    if (playerData[playerid][pCannabis] == 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ��������觡ѭ�ҡ�͹, �֧������ö�觡ѭ����������ҹ��ҧ�������");

    if (playerData[playerid][pCPCannabis] == 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ��������觡ѭ�ҡ�͹, �֧������ö�觡ѭ����������ҹ��ҧ�������");

    else
    {
        if (playerData[playerid][pCPCannabis] == 1)
        {
            //DisablePlayerCheckpoint(playerid);
            SendClientMessage(playerid, COLOR_YELLOW, "�س���Ѻ�Թᴧ�ӹǹ $2,500 �ҡ����觡ѭ�ҿ�����շͧ���Ѻ�١���, ������Ѻ�����觧ҹ�ӹǹ $2,000");
            
            //GivePlayerMoneyEx(playerid, 6000);
            playerData[playerid][pRMoney] += 4500;
            playerData[playerid][pCPCannabis] = 0;
            playerData[playerid][pCannabis] = 0;
        }

        else if (playerData[playerid][pCPCannabis] == 2)
        {
            //DisablePlayerCheckpoint(playerid);
            SendClientMessage(playerid, COLOR_YELLOW, "�س���Ѻ�Թᴧ�ӹǹ $4,500 �ҡ����觡ѭ�ҿ�������Թ���Ѻ�١���, ������Ѻ�����觧ҹ�ӹǹ $2,000");
            
            //GivePlayerMoneyEx(playerid, 10000);
            playerData[playerid][pRMoney] += 6500;
            playerData[playerid][pCPCannabis] = 0;
            playerData[playerid][pCannabis] = 0;

        }

        else if (playerData[playerid][pCPCannabis] == 3)
        {
            //DisablePlayerCheckpoint(playerid);
            SendClientMessage(playerid, COLOR_YELLOW, "�س���Ѻ�Թᴧ�ӹǹ $4,000 �ҡ����觡ѭ�ҿ����෻�����Ѻ�١���, ������Ѻ�����觧ҹ�ӹǹ $2,000");
            
            //GivePlayerMoneyEx(playerid, 9000);
            playerData[playerid][pRMoney] += 6000;
            playerData[playerid][pCPCannabis] = 0;
            playerData[playerid][pCannabis] = 0;
        }
    }

    return 1;
}

Dialog:CannabisPickup(playerid, response, listitem, inputtext[]) 
{
	if(response)
	{
    	switch (listitem)
	    {
	        case 0:
	        {
                if (GetPlayerMoney(playerid) < 2500)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��������Թ�ҡ��Ҵ���");

                //SetPlayerCheckpoint(playerid, -391.3606, 2221.5217, 42.4297, 4.0);
                playerData[playerid][pCPCannabis] = 1;
                GivePlayerMoneyEx(playerid, -2500);

                playerData[playerid][pCannabis] = 1;
                SendClientMessage(playerid, COLOR_YELLOW, "�س�����͡���͡ѭ�� (�����ͧ) �繨ӹǹ�Թ $2,500, ���˹����ѧʶҹ���Ѵ���� (�����ҹ��ҧ) �����觡ѭ��");
                SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s ����Ժ�ѭ�� (�����ͧ) �͡�Ҩҡ�ç�ҹ��Ե�ѭ��", ReturnRealName(playerid));
            }
	        case 1:
	        {
                if (GetPlayerMoney(playerid) < 4500)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��������Թ�ҡ��Ҵ���");

                //SetPlayerCheckpoint(playerid, -391.3606, 2221.5217, 42.4297, 4.0);
                playerData[playerid][pCPCannabis] = 2;
                GivePlayerMoneyEx(playerid, -4500);

                playerData[playerid][pCannabis] = 2;
                SendClientMessage(playerid, COLOR_YELLOW, "�س�����͡���͡ѭ�� (��������Թ) �繨ӹǹ�Թ $4,500, ���˹����ѧʶҹ���Ѵ���� (�����ҹ��ҧ) �����觡ѭ��");
                SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s ����Ժ�ѭ�� (��������Թ) �͡�Ҩҡ�ç�ҹ��Ե�ѭ��", ReturnRealName(playerid));
            }
	        case 2:
	        {
                if (GetPlayerMoney(playerid) < 4000)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��������Թ�ҡ��Ҵ���");

                //SetPlayerCheckpoint(playerid, -391.3606, 2221.5217, 42.4297, 4.0);
                playerData[playerid][pCPCannabis] = 3;
                GivePlayerMoneyEx(playerid, -4000);

                playerData[playerid][pCannabis] = 3;
                SendClientMessage(playerid, COLOR_YELLOW, "�س�����͡���͡ѭ�� (�������) �繨ӹǹ�Թ $4,000, ���˹����ѧʶҹ���Ѵ���� (�����ҹ��ҧ) �����觡ѭ��");
                SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s ����Ժ�ѭ�� (�������) �͡�Ҩҡ�ç�ҹ��Ե�ѭ��", ReturnRealName(playerid));
            }
        }
    }

    return 1;
}

ptask CannabisTimer[1000](playerid) 
{
    if (playerData[playerid][pCannabis] >= 4)
    {
        playerData[playerid][pCannabis] = 0;
        playerData[playerid][pCPCannabis] = 0;
    }

    if (playerData[playerid][pCPCannabis] >= 4)
    {
        playerData[playerid][pCannabis] = 0;
        playerData[playerid][pCPCannabis] = 0;       
    }
}
