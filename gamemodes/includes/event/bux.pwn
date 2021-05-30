#include <YSI\y_hooks>

static bool:BuxReady = false, BuxMoney = 0, BuxOffer = INVALID_PLAYER_ID;

CMD:bux(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
		if(BuxReady)
		{
			SendClientMessage(playerid, 0xFF000000, "[BUX] โปรดรอสักครู่ถึงจะ /bux ได้!");
			return 1;
		}
		if(BuxMoney > 0)
		{
		    format(string, sizeof(string), "[BUX] %s ได้ลงเงินท้าดวลไว้แล้ว $%d (หากต้องการสู้ /takebux เพื่อท้าชิง)", ReturnPlayerName(BuxOffer), BuxMoney);
		    SendClientMessage(playerid, 0xFF000000, string);
		    return 1;
		}
		if(playerData[playerid][pLevel] < 3)
		{
			SendClientMessage(playerid, COLOR_GRAD1, " คุณต้องเลเวลมากกว่าหรือเท่ากับ 3!");
			return 1;
		}

        new amount;
        if (sscanf(params, "d", amount)) {
			SendClientMessage(playerid, COLOR_GRAD1, "[USAGE] /bux [จำนวนเงิน]");
			return 1;
        }

		if(amount < 1000 || amount > 20000) 
            return SendClientMessage(playerid, COLOR_GRAD1, " ห้ามน้อยกว่า $1000 หรือ ห้ามมากกว่า $20000 !");

		if (GetPlayerMoney(playerid) < amount)
		{
			SendClientMessage(playerid, COLOR_GRAD1, " คุณมีเงินไม่พอ!");
			return 1;
		}

		BuxMoney = amount;
		BuxOffer = playerid;
		BuxReady = true;
        GivePlayerMoneyEx(playerid, -amount);
		SetTimerEx("ResetBux", 7000, 0, "d", 2);

		SendClientMessage(playerid, COLOR_LIGHTBLUE, sprintf("* คุณลงเงินท้าดวล $%d เรียบร้อยแล้ว!", BuxMoney));
	}
	return 1;
}

if(strcmp(cmd, "/takebux", true) == 0)
{
	if(IsPlayerConnected(playerid))
	{
	    if(BuxOffer == 999)
	    {
			SendClientMessage(playerid, 0xFF000000, "[BUX] โปรดรอสักครู่ถึงจะ /takebux ได้!");
			return 1;
	    }
	    if(BuxOffer == playerid)
	    {
			return 1;
	    }
		if(BuxReady == 1)
		{
			SendClientMessage(playerid, 0xFF000000, "[BUX] โปรดรอสักครู่ถึงจะ /takebux ได้!");
			return 1;
		}
		if(playerData[playerid][pLevel] < 3)
		{
			SendClientMessage(playerid, COLOR_GRAD1, " คุณต้องเลเวลมากกว่า 3!");
			return 1;
		}
		if (ScriptMoney[playerid] < BuxMoney)
		{
			SendClientMessage(playerid, COLOR_GRAD1, " คุณมีเงินไม่พอ!");
			return 1;
		}
		GetPlayerName(BuxOffer, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
		new rand = random(100);
		if(rand > 49)
		{
			format(string, sizeof(string), "[BUX-LOSE] ผู้เล่น \" %s \" แพ้และเสียเงินเป็นจำนวน $%d ให้กับ \" %s \" เสียใจด้วยนะ!", sendername, BuxMoney, giveplayer);
			OOCBux(0xFF000000, string);
			SafeGivePlayerMoney(playerid, -BuxMoney);
			format(string, sizeof(string), "* คุณเสียเงิน $%d จากการเล่น Bux", BuxMoney);
			SendClientMessage(playerid, 0xFF000000, string);
		    new Percent = (BuxMoney / 100) * 3;
		    BuxMoney = BuxMoney * 2;
		    BuxMoney = BuxMoney - Percent;
			SafeGivePlayerMoney(BuxOffer, BuxMoney);
			format(string, sizeof(string), "* คุณได้รับเงิน $%d จากการเล่น Bux (ภาษี 3 เปอร์เซ็นต์)", BuxMoney);
			SendClientMessage(BuxOffer, COLOR_GREEN, string);
		}
		else
		{
			format(string, sizeof(string), "[BUX-WIN] ผู้เล่น \" %s \" ชนะและรับเงินเป็นจำนวน $%d จาก \" %s \" ดีใจด้วยนะ!", sendername, BuxMoney, giveplayer);
			OOCBux(COLOR_GREEN, string);
		    new Percent = (BuxMoney / 100) * 3;
		    BuxMoney = BuxMoney - Percent;
			SafeGivePlayerMoney(playerid, BuxMoney);
			format(string, sizeof(string), "* คุณได้รับเงิน $%d จากการเล่น Bux (ภาษี 3 เปอร์เซ็นต์)", BuxMoney);
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
		OOCBux(COLOR_YELLOW2, "[BUX] ขณะนี้สามารถทำการ /bux [จำนวนเงินได้แล้ว] เพื่อท้าดวล วัดใจ!~*");
	}
	else
	{
		format(string, sizeof(string), "[BUX] ผู้เล่น %s ได้ทำการลงเงินท้าดวล $%d (หากคุณต้องการสู้ /takebux เพื่อท้าชิง)", ReturnPlayerName(BuxOffer), BuxMoney);
		OOCBux(COLOR_LIGHTBLUE, string);
	}
    BuxReady = false;
	return 1;
}