#include <YSI\y_hooks>

CMD:draw(playerid, params[])
{
	new
	    amount,draw;

	if (sscanf(params, "dd", draw, amount))
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: /draw [����Ţ�٧�ش 2 ��ѡ] [�ӹǹ�Թ]");

    if (draw < 0  || draw > 99)
	    return SendClientMessage(playerid, COLOR_GRAD1, "�����: ����Ţ����� 0-99");
        
    if(playerData[playerid][pLevel] < 5)
		return SendClientMessage(playerid, COLOR_GRAD1, " �س��ͧ������ҡ����������ҡѺ 5!");

	if (amount < 3000 || amount < 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �ô�кبӹǹ���ŧ��ѹ����ӡ��� $0 �����ҡ���� $3000");

	if (amount > GetPlayerMoney(playerid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �س��������Թ�ҡ��Ҵ���");

    new ran_draw = random(99); 
	SendClientMessageEx(playerid, COLOR_GRAD1, "�س���͡�Ţ %d ���������ѹ������Թ $%d", draw,amount);

    if(draw==ran_draw){
        new total_ture=amount*5;
        GivePlayerMoneyEx(playerid, total_ture);  
        Mobile_GameTextForPlayer(playerid, sprintf("~w~Number issued is ~n~~y~%d~n~~g~You Win !", ran_draw) ,4000, 4);
		SendClientMessageEx(playerid, COLOR_GRAD1, "�س��С������ѹ�����Ѻ�Թ $%d", total_ture);

		Log(paychecklog, INFO, "%s ���Ѻ�Թʴ %d �ҡ /draw", ReturnPlayerName(playerid), total_ture);
    }else{
        GivePlayerMoneyEx(playerid, -amount);
        Mobile_GameTextForPlayer(playerid, sprintf("~w~Number issued is ~n~~y~%d~n~~r~You Lose !", ran_draw) ,4000, 4);
    }

	return 1;
}
