#include <YSI\y_hooks>

CMD:draw(playerid, params[])
{
	new
	    amount,draw;

	if (sscanf(params, "dd", draw, amount))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /draw [ตัวเลขสูงสุด 2 หลัก] [จำนวนเงิน]");

    if (draw < 0  || draw > 99)
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: ใส่เลขตั้งแต่ 0-99");
        
    if(playerData[playerid][pLevel] < 5)
		return SendClientMessage(playerid, COLOR_GRAD1, " คุณต้องเลเวลมากกว่าหรือเท่ากับ 5!");

	if (amount < 3000 || amount < 0)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   โปรดระบุจำนวนที่ลงพนันไม่ต่ำกว่า $0 หรือมากกว่า $3000");

	if (amount > GetPlayerMoney(playerid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้มีเงินมากขนาดนั้น");

    new ran_draw = random(99); 
	SendClientMessageEx(playerid, COLOR_GRAD1, "คุณเลือกเลข %d พร้อมเดิมพันธ์ด้วยเงิน $%d", draw,amount);

    if(draw==ran_draw){
        new total_ture=amount*5;
        GivePlayerMoneyEx(playerid, total_ture);  
        Mobile_GameTextForPlayer(playerid, sprintf("~w~Number issued is ~n~~y~%d~n~~g~You Win !", ran_draw) ,4000, 4);
		SendClientMessageEx(playerid, COLOR_GRAD1, "คุณชนะการเดิมพันธ์ได้รับเงิน $%d", total_ture);

		Log(paychecklog, INFO, "%s ได้รับเงินสด %d จาก /draw", ReturnPlayerName(playerid), total_ture);
    }else{
        GivePlayerMoneyEx(playerid, -amount);
        Mobile_GameTextForPlayer(playerid, sprintf("~w~Number issued is ~n~~y~%d~n~~r~You Lose !", ran_draw) ,4000, 4);
    }

	return 1;
}
