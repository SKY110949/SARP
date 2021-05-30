#include <YSI\y_hooks>

static bool:BuxReady = false, BuxMoney = 0, BuxOffer = INVALID_PLAYER_ID;

CMD:bux(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
		if(BuxReady)
		{
			SendClientMessage(playerid, 0xFF000000, "[BUX] �ô���ѡ����֧�� /bux ��!");
			return 1;
		}
		if(BuxMoney > 0)
		{
		    format(string, sizeof(string), "[BUX] %s ��ŧ�Թ��Ҵ��������� $%d (�ҡ��ͧ������ /takebux ���ͷ�Ҫԧ)", ReturnPlayerName(BuxOffer), BuxMoney);
		    SendClientMessage(playerid, 0xFF000000, string);
		    return 1;
		}
		if(playerData[playerid][pLevel] < 3)
		{
			SendClientMessage(playerid, COLOR_GRAD1, " �س��ͧ������ҡ����������ҡѺ 3!");
			return 1;
		}

        new amount;
        if (sscanf(params, "d", amount)) {
			SendClientMessage(playerid, COLOR_GRAD1, "[USAGE] /bux [�ӹǹ�Թ]");
			return 1;
        }

		if(amount < 1000 || amount > 20000) 
            return SendClientMessage(playerid, COLOR_GRAD1, " �������¡��� $1000 ���� �����ҡ���� $20000 !");

		if (GetPlayerMoney(playerid) < amount)
		{
			SendClientMessage(playerid, COLOR_GRAD1, " �س���Թ����!");
			return 1;
		}

		BuxMoney = amount;
		BuxOffer = playerid;
		BuxReady = true;
        GivePlayerMoneyEx(playerid, -amount);
		SetTimerEx("ResetBux", 7000, 0, "d", 2);

		SendClientMessage(playerid, COLOR_LIGHTBLUE, sprintf("* �سŧ�Թ��Ҵ�� $%d ���º��������!", BuxMoney));
	}
	return 1;
}

if(strcmp(cmd, "/takebux", true) == 0)
{
	if(IsPlayerConnected(playerid))
	{
	    if(BuxOffer == 999)
	    {
			SendClientMessage(playerid, 0xFF000000, "[BUX] �ô���ѡ����֧�� /takebux ��!");
			return 1;
	    }
	    if(BuxOffer == playerid)
	    {
			return 1;
	    }
		if(BuxReady == 1)
		{
			SendClientMessage(playerid, 0xFF000000, "[BUX] �ô���ѡ����֧�� /takebux ��!");
			return 1;
		}
		if(playerData[playerid][pLevel] < 3)
		{
			SendClientMessage(playerid, COLOR_GRAD1, " �س��ͧ������ҡ���� 3!");
			return 1;
		}
		if (ScriptMoney[playerid] < BuxMoney)
		{
			SendClientMessage(playerid, COLOR_GRAD1, " �س���Թ����!");
			return 1;
		}
		GetPlayerName(BuxOffer, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
		new rand = random(100);
		if(rand > 49)
		{
			format(string, sizeof(string), "[BUX-LOSE] ������ \" %s \" ����������Թ�繨ӹǹ $%d ���Ѻ \" %s \" ����㨴��¹�!", sendername, BuxMoney, giveplayer);
			OOCBux(0xFF000000, string);
			SafeGivePlayerMoney(playerid, -BuxMoney);
			format(string, sizeof(string), "* �س�����Թ $%d �ҡ������ Bux", BuxMoney);
			SendClientMessage(playerid, 0xFF000000, string);
		    new Percent = (BuxMoney / 100) * 3;
		    BuxMoney = BuxMoney * 2;
		    BuxMoney = BuxMoney - Percent;
			SafeGivePlayerMoney(BuxOffer, BuxMoney);
			format(string, sizeof(string), "* �س���Ѻ�Թ $%d �ҡ������ Bux (���� 3 �����繵�)", BuxMoney);
			SendClientMessage(BuxOffer, COLOR_GREEN, string);
		}
		else
		{
			format(string, sizeof(string), "[BUX-WIN] ������ \" %s \" �������Ѻ�Թ�繨ӹǹ $%d �ҡ \" %s \" ��㨴��¹�!", sendername, BuxMoney, giveplayer);
			OOCBux(COLOR_GREEN, string);
		    new Percent = (BuxMoney / 100) * 3;
		    BuxMoney = BuxMoney - Percent;
			SafeGivePlayerMoney(playerid, BuxMoney);
			format(string, sizeof(string), "* �س���Ѻ�Թ $%d �ҡ������ Bux (���� 3 �����繵�)", BuxMoney);
			SendClientMessage(playerid, COLOR_GREEN, string);
		}
		BuxMoney = 0;
		BuxOffer = 999;
		BuxReady = 1;
		SetTimerEx("ResetBux", 15000, 0, "d", 1);
		return 1;
	}
	return 1;
}

public ResetBux(bool:status)
{
	if(status)
	{
		OOCBux(COLOR_YELLOW2, "[BUX] ��й������ö�ӡ�� /bux [�ӹǹ�Թ������] ���ͷ�Ҵ�� �Ѵ�!~*");
	}
	else
	{
		format(string, sizeof(string), "[BUX] ������ %s ��ӡ��ŧ�Թ��Ҵ�� $%d (�ҡ�س��ͧ������ /takebux ���ͷ�Ҫԧ)", ReturnPlayerName(BuxOffer), BuxMoney);
		OOCBux(COLOR_LIGHTBLUE, string);
	}
    BuxReady = false;
	return 1;
}