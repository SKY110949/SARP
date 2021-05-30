#include <YSI\y_hooks>

/*new
	PlayerText:TD_FiveM[MAX_PLAYERS][5];*/

hook OnGameModeInit(playerid)
{
    Create3DTextLabel("{FFFF00}จุดฟอกเงิน Los Santos\n{FFFFFF}ใช้ {7FFF00}/launder{FFFFFF} เพื่อเริ่มต้นฟอกเงิน",0xFFFF00FF,2770.6602, -1628.7228, 12.1775,30.0,0,1);
	Create3DTextLabel("{FFFF00}ตลาดมืดขายอาวุธ\n{FFFFFF}พิมพ์ {7FFF00}/buywp{FFFFFF} เพื่อเลือกซื้ออาวุธ",0xFFFF00FF,2442.5444,-1981.0731,13.5469,30.0,0,1);

//	  Create3DTextLabel("{FFFF00}/healme เพื่อเพิ่มเลีอด",0xFFFF00FF,1954.3954,1160.3157,-4.6479);
//    Create3DTextLabel("{FFFF00}/healme เพื่อเพิ่มเลีอด",0xFFFF00FF,1953.9636,1166.2401,-4.6479);
//    Create3DTextLabel("{FFFF00}/healme เพื่อเพิ่มเลีอด",0xFFFF00FF,1954.3228,1172.2252,-4.6479);
}

/*hook OnPlayerConnect(playerid)
{
	// FiveM Textdraws

	TD_FiveM[playerid][0] = CreatePlayerTextDraw(playerid, 502.500000, 95.375000, "New Textdraw");
	PlayerTextDrawLetterSize(playerid, TD_FiveM[playerid][0], 0.449999, 1.600000);
	PlayerTextDrawTextSize(playerid, TD_FiveM[playerid][0], 48.500000, 35.437500);
	PlayerTextDrawAlignment(playerid, TD_FiveM[playerid][0], 1);
	PlayerTextDrawColor(playerid, TD_FiveM[playerid][0], 16711935);
	PlayerTextDrawUseBox(playerid, TD_FiveM[playerid][0], true);
	PlayerTextDrawBoxColor(playerid, TD_FiveM[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, TD_FiveM[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, TD_FiveM[playerid][0], 1);
	PlayerTextDrawFont(playerid, TD_FiveM[playerid][0], 5);
	PlayerTextDrawSetProportional(playerid, TD_FiveM[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, TD_FiveM[playerid][0], 0x0000000);
 	PlayerTextDrawSetPreviewModel(playerid, TD_FiveM[playerid][0], 1212);
  	PlayerTextDrawSetPreviewRot(playerid, TD_FiveM[playerid][0], 88.000000, 0.000000, 0.000000, 1.000000);

	TD_FiveM[playerid][1] = CreatePlayerTextDraw(playerid, 503.000000, 108.937500, "New Textdraw");
	PlayerTextDrawLetterSize(playerid, TD_FiveM[playerid][1], 0.449999, 1.600000);
	PlayerTextDrawTextSize(playerid, TD_FiveM[playerid][1], 48.500000, 37.625000);
	PlayerTextDrawAlignment(playerid, TD_FiveM[playerid][1], 1);
	PlayerTextDrawColor(playerid, TD_FiveM[playerid][1], -16776961);
	PlayerTextDrawUseBox(playerid, TD_FiveM[playerid][1], true);
	PlayerTextDrawBoxColor(playerid, TD_FiveM[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, TD_FiveM[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, TD_FiveM[playerid][1], 1);
	PlayerTextDrawFont(playerid, TD_FiveM[playerid][1], 5);
	PlayerTextDrawSetProportional(playerid, TD_FiveM[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, TD_FiveM[playerid][1], 0x0000000);
 	PlayerTextDrawSetPreviewModel(playerid, TD_FiveM[playerid][1], 1212);
  	PlayerTextDrawSetPreviewRot(playerid, TD_FiveM[playerid][1], 88.000000, 0.000000, 0.000000, 1.000000);

	TD_FiveM[playerid][2] = CreatePlayerTextDraw(playerid, 554.500000, 110.250000, "$1");
	PlayerTextDrawLetterSize(playerid, TD_FiveM[playerid][2], 0.331000, 1.149375);
	PlayerTextDrawAlignment(playerid, TD_FiveM[playerid][2], 1);
	PlayerTextDrawColor(playerid, TD_FiveM[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, TD_FiveM[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, TD_FiveM[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, TD_FiveM[playerid][2], 51);
	PlayerTextDrawFont(playerid, TD_FiveM[playerid][2], 3);
	PlayerTextDrawSetProportional(playerid, TD_FiveM[playerid][2], 1);

	TD_FiveM[playerid][3] = CreatePlayerTextDraw(playerid, 555.500000, 125.125000, "$2");
	PlayerTextDrawLetterSize(playerid, TD_FiveM[playerid][3], 0.290000, 1.031249);
	PlayerTextDrawAlignment(playerid, TD_FiveM[playerid][3], 1);
	PlayerTextDrawColor(playerid, TD_FiveM[playerid][3], -1);
	PlayerTextDrawUseBox(playerid, TD_FiveM[playerid][3], true);
	PlayerTextDrawBoxColor(playerid, TD_FiveM[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, TD_FiveM[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, TD_FiveM[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, TD_FiveM[playerid][3], 51);
	PlayerTextDrawFont(playerid, TD_FiveM[playerid][3], 3);
	PlayerTextDrawSetProportional(playerid, TD_FiveM[playerid][3], 1);

	// Textdraws FiveM
	
	PlayerTextDrawShow(playerid, TD_FiveM[playerid][0]);
	PlayerTextDrawShow(playerid, TD_FiveM[playerid][1]);
	PlayerTextDrawShow(playerid, TD_FiveM[playerid][2]);
	PlayerTextDrawShow(playerid, TD_FiveM[playerid][3]);
	PlayerTextDrawShow(playerid, TD_FiveM[playerid][4]);
}

ptask PlayerUpdateMoney[1000](playerid) {
	new
	    string[128];

	// Setting Red & Green Cash

	format(string, sizeof(string), "~g~$~w~%d", playerData[playerid][pCash]);
	PlayerTextDrawSetString(playerid,TD_FiveM[playerid][2], string);

	format(string, sizeof(string), "~g~$~w~%d", playerData[playerid][pRMoney]);
	PlayerTextDrawSetString(playerid,TD_FiveM[playerid][3], string);
}*/

CMD:money(playerid)
{
    new
        string[128];

    format(string, sizeof(string), "เงินเขียว : {33AA33}${FFFFFF}%d    l   เงินผิดกฏหมาย : {FF0000}${FFFFFF}%d", playerData[playerid][pCash], playerData[playerid][pRMoney]);
    SendClientMessage(playerid, COLOR_YELLOW, string);

	return 1;
}

/*CMD:healme(playerid)
{
    if (IsPlayerInRangeOfPoint(playerid, 3.0, 1954.3954,1160.3157,-4.6479))
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่โรงพยาบาล");

	if (playerData[playerid][pCash] < 500)
		return SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องมีเงินมากกว่า $250");

	SetPlayerHealth(playerid, 100);
	GivePlayerMoneyEx(playerid, -250);
	SendClientMessage(playerid, COLOR_WHITE, "คุณได้ทำการรักษาตัวเองที่โรงพยาบาล, โดยเสียค่าใช้จ่าย $250");

	return 1;
}
*/
CMD:launder(playerid)
{
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 2770.6602, -1628.7228, 12.1775)) 
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่จุดฟอกเงิน");

    /*GivePlayerMoneyEx(playerid, amount); 
    playerData[playerid][pRMoney] = 0; 

    format(string, sizeof(string), "คุณได้รับเงินเขียวจำนวน {33AA33}${FFFFFF}%d", playerData[playerid][pCash]);
    SendClientMessage(playerid, COLOR_YELLOW, string);*/

    SendClientMessage(playerid, COLOR_YELLOW, "กรุณารอสักครู่ ... คุณกำลังแลกเปลี่ยนเงินแดงเป็นเงินเขียว ... (กรุณารอ 8 วินาที)");
    SetTimerEx("MoneyTime", 8000, false, "d", playerid);

	return 1;
}

forward MoneyTime(playerid);
public MoneyTime(playerid)
{
	new amount = playerData[playerid][pRMoney], string[128];

   	GivePlayerMoneyEx(playerid, amount); 
    playerData[playerid][pRMoney] = 0; 

    format(string, sizeof(string), "คุณได้รับเงินเขียวจำนวน {33AA33}${FFFFFF}%d", playerData[playerid][pCash]);
    SendClientMessage(playerid, COLOR_YELLOW, string);

    return 1;
}

