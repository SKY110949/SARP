// ATM System

#include <YSI\y_hooks>

#define MAX_ATM_MACHINES (50)
new ATMData[MAX_ATM_MACHINES][atmData];

stock ATM_Delete(atmid)
{
	if (atmid != -1 && ATMData[atmid][atmExists])
	{
	    new
	        string[64];

		format(string, sizeof(string), "DELETE FROM `atm` WHERE `atmID` = '%d'", ATMData[atmid][atmID]);
		mysql_tquery(dbCon, string);

        if (IsValidDynamicObject(ATMData[atmid][atmObject]))
	        DestroyDynamicObject(ATMData[atmid][atmObject]);

	    if (IsValidDynamic3DTextLabel(ATMData[atmid][atmText3D]))
	        DestroyDynamic3DTextLabel(ATMData[atmid][atmText3D]);

	    ATMData[atmid][atmExists] = false;
	    ATMData[atmid][atmID] = 0;
	}
	return 1;
}

ATM_Nearest(playerid)
{
    for (new i = 0; i != MAX_ATM_MACHINES; i ++) if (ATMData[i][atmExists] && IsPlayerInRangeOfPoint(playerid, 2.5, ATMData[i][atmPos][0], ATMData[i][atmPos][1], ATMData[i][atmPos][2]))
	{
		if (GetPlayerInterior(playerid) == ATMData[i][atmInterior] && GetPlayerVirtualWorld(playerid) == ATMData[i][atmWorld])
			return i;
	}
	return -1;
}

stock ATM_Create(playerid)
{
    new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_ATM_MACHINES; i ++) if (!ATMData[i][atmExists])
		{
		    ATMData[i][atmExists] = true;

		    x += 1.0 * floatsin(-angle, degrees);
			y += 1.0 * floatcos(-angle, degrees);

            ATMData[i][atmPos][0] = x;
            ATMData[i][atmPos][1] = y;
            ATMData[i][atmPos][2] = z;
            ATMData[i][atmPos][3] = angle;

            ATMData[i][atmInterior] = GetPlayerInterior(playerid);
            ATMData[i][atmWorld] = GetPlayerVirtualWorld(playerid);

			ATM_Refresh(i);
			mysql_tquery(dbCon, "INSERT INTO `atm` (`atmInterior`) VALUES(0)", "OnATMCreated", "d", i);

			return i;
		}
	}
	return -1;
}

stock ATM_Refresh(atmid)
{
	if (atmid != -1 && ATMData[atmid][atmExists])
	{
	    if (IsValidDynamicObject(ATMData[atmid][atmObject]))
	        DestroyDynamicObject(ATMData[atmid][atmObject]);

	    if (IsValidDynamic3DTextLabel(ATMData[atmid][atmText3D]))
	        DestroyDynamic3DTextLabel(ATMData[atmid][atmText3D]);

		new
	        string[64];

		format(string, sizeof(string), "[ATM %d]\n{FFFFFF}/atm เพื่อถอนเงินจากบัญชีของคุณ", atmid);

		ATMData[atmid][atmObject] = CreateDynamicObject(2754, ATMData[atmid][atmPos][0], ATMData[atmid][atmPos][1], ATMData[atmid][atmPos][2] - 0.4, 0.0, 0.0, ATMData[atmid][atmPos][3], ATMData[atmid][atmWorld], ATMData[atmid][atmInterior]);
        ATMData[atmid][atmText3D] = CreateDynamic3DTextLabel(string, -1, ATMData[atmid][atmPos][0], ATMData[atmid][atmPos][1], ATMData[atmid][atmPos][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, ATMData[atmid][atmWorld], ATMData[atmid][atmInterior]);

		return 1;
	}
	return 0;
}

stock ATM_Save(atmid)
{
	new
	    query[200];

	format(query, sizeof(query), "UPDATE `atm` SET `atmX` = '%.4f', `atmY` = '%.4f', `atmZ` = '%.4f', `atmA` = '%.4f', `atmInterior` = '%d', `atmWorld` = '%d' WHERE `atmID` = '%d'",
	    ATMData[atmid][atmPos][0],
	    ATMData[atmid][atmPos][1],
	    ATMData[atmid][atmPos][2],
	    ATMData[atmid][atmPos][3],
	    ATMData[atmid][atmInterior],
	    ATMData[atmid][atmWorld],
	    ATMData[atmid][atmID]
	);
	return mysql_tquery(dbCon, query);
}

forward OnATMCreated(atmid);
public OnATMCreated(atmid)
{
    if (atmid == -1 || !ATMData[atmid][atmExists])
		return 0;

	ATMData[atmid][atmID] = cache_insert_id();
 	ATM_Save(atmid);

	return 1;
}

hook OnGameModeInit() {

	mysql_tquery(dbCon, "SELECT * FROM `atm`", "ATM_Load", "");
	return 1;
}

forward ATM_Load();
public ATM_Load()
{
    new
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_ATM_MACHINES)
	{
		ATMData[i][atmExists] = true;
		cache_get_value_name_int(i, "atmID", ATMData[i][atmID]);
		cache_get_value_name_float(i, "atmX", ATMData[i][atmPos][0]);
		cache_get_value_name_float(i, "atmY", ATMData[i][atmPos][1]);
		cache_get_value_name_float(i, "atmZ", ATMData[i][atmPos][2]);
		cache_get_value_name_float(i, "atmA", ATMData[i][atmPos][3]);
		cache_get_value_name_int(i, "atmInterior", ATMData[i][atmInterior]);
		cache_get_value_name_int(i, "atmWorld", ATMData[i][atmInterior]);

		ATM_Refresh(i);
	}
	return 1;
}

flags:atmcmds(CMD_MANAGEMENT);
CMD:atmcmds(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GRAD1, "คำสั่ง: /makeatm, /removeatm,`` [Player]/atm, /passatm, /changepassatm, ");
	return 1;
}

// Commands ATM

CMD:atm(playerid, params[])
{
	if (ATM_Nearest(playerid) == -1)
	    return SendClientMessage(playerid, COLOR_GREY, "คุณไม่ได้อยู่ใกล้ตู้ ATM");

	Dialog_Show(playerid, CheckPassWord, DIALOG_STYLE_INPUT, "การถอนเงินบัญชีธนาคาร", "กรุณาระบุรหัสผ่านของ ATM คุณเพื่อเข้าสู่ขั้นตอนการถอนเงิน", "ตกลง", "ยกเลิก");
	return 1;
}

CMD:passatm(playerid, params[])
{
	if (ATM_Nearest(playerid) == -1)
	    return SendClientMessage(playerid, COLOR_GREY, "คุณไม่ได้อยู่ใกล้ตู้ ATM");

	if (playerData[playerid][pATM] != 0)
		return SendClientMessage(playerid, COLOR_GREY, "คุณได้มีการกำหนดรหัสผ่านบัตร ATM ครั้งแรกแล้ว, โปรดเปลี่ยนรหัสผ่านบัตรที่ตู้ ATM ทั่วไป");

	Dialog_Show(playerid, PasswordATM, DIALOG_STYLE_INPUT, "การตั้งรหัสผ่าน ATM", "กรุณากำหนดรหัสผ่าน ATM ที่คุณต้องการ\nHINT: โปรดจดจำรหัสผ่านของคุณให้ดีหลังจากการกำหนดรหัสผ่านของ ATM คุณ", "ตกลง", "ยกเลิก");
	return 1;
}

CMD:makeatm(playerid, params[])
{
	new
	    id = -1;

    if (playerData[playerid][pAdmin] < 4)
	    return SendClientMessage(playerid, COLOR_GREY, "คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

	id = ATM_Create(playerid);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_GREY, "เซิฟเวอร์นี้ได้สร้างเครื่อง ATM เกินขีดจำกัดแล้ว");

	SendClientMessageEx(playerid, COLOR_GREY, "คุณประสบความสำเร็จในการสร้างเครื่อง ATM ไอดี: %d", id);
	return 1;
}

CMD:removeatm(playerid, params[])
{
	new
	    id = 0;

    if (playerData[playerid][pAdmin] < 5)
	    return SendClientMessage(playerid, COLOR_GREY, "คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_GREY, "การใช้: /destroyatm [atm id]");

	if ((id < 0 || id >= MAX_ATM_MACHINES) || !ATMData[id][atmExists])
	    return SendClientMessage(playerid, COLOR_GREY,"คุณระบุไอดีเครื่อง ATM ไม่ถูกต้อง");

	ATM_Delete(id);
	SendClientMessageEx(playerid, COLOR_GREY,"คุณประสบความสำเร็จในการทำลายเครื่อง ATM ไอดี: %d", id);
	return 1;
}

CMD:changepassatm(playerid, params[])
{
	new
		pPass[7];

	if (sscanf(params, "s", pPass))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /changepassatm [รหัสผ่านใหม่]");

    if (strlen(pPass) < 3 || strlen(pPass) > 6) 
		return SendClientMessage(playerid, COLOR_GRAD1, "รหัสผ่านใหม่ของคุณต้องเป็นตัวเลขจำนวน 6 ตัว"); 

	playerData[playerid][pATM] = strval(pPass);
	OnAccountUpdate(playerid);

	SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้ทำการเปลี่ยนรหัสผ่าน ATM เป็น : %d", strval(pPass));
	return 1;
}

Dialog:CheckPassWord(playerid, response, listitem, inputtext[])
{
	if(response) 
    {
        if(strval(inputtext) == playerData[playerid][pATM]) // Password Correct
        {
            //SendClientMessageEx(playerid, COLOR_YELLOW, "ยินดีต้อนรับสู่ธนาคารของคุณ %s, (หากพบปัญหาระหว่างการใช้งานกรุณาติดต่อผู้พัฒนาเซิร์ฟเวอร์)");
			Dialog_Show(playerid, Bank, DIALOG_STYLE_LIST, "ATM Withdraw", "ยอดเงินในธนาคาร : %s\nเปลี่ยนรหัสบัตร ATM", "ตกลง", "ยกเลิก", FormatNumber(playerData[playerid][pAccount]));
        }

        else // Password Not Correct
        {
	        Dialog_Show(playerid, CheckPassWord, DIALOG_STYLE_INPUT, "การถอนเงินบัญชีธนาคาร", "กรุณาระบุรหัสผ่านของ ATM คุณเพื่อเข้าสู่ขั้นตอนการถอนเงิน\nHINT: คุณระบุรหัสผ่านผิดพลาด !! กรุณาใส่รหัสผ่านอีกครั้ง", "ตกลง", "ยกเลิก");
        }
    }
    return 1;
}

Dialog:PasswordATM(playerid, response, listitem, inputtext[])
{
	if(response) 
    {
        if(strlen(inputtext) != 6) 
        {
 	        Dialog_Show(playerid, PasswordATM, DIALOG_STYLE_INPUT, "การตั้งรหัสผ่าน ATM", "กรุณากำหนดรหัสผ่าน ATM ที่คุณต้องการ\nHINT: รหัสผ่านต้องมี 6 ตัว (เป็นตัวเลขเท่านั้น)", "ตกลง", "ยกเลิก");
        }

        else // Password Not Correct
        {
	        playerData[playerid][pATM] = strval(inputtext);
            SendClientMessageEx(playerid, COLOR_YELLOW, "รหัสผ่าน ATM ของคุณคือ : '%d' โปรดจดจำรหัสผ่าน ATM ของคุณให้ดี, เนืองจากไม่สามารถเปลี่ยนแปลงได้", strval(inputtext));
        }
    }
    return 1;
}

Dialog:Bank(playerid, response, listitem, inputtext[])
{
	if (ATM_Nearest(playerid) == -1)
	    return 0;

	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	        {
				Dialog_Show(playerid, BankAccount, DIALOG_STYLE_LIST, "ATM Withdraw", "ถอนเงิน", "ตกลง", "ย้อนกลับ");
			}
			case 1: // Change Password ATM
			{
				Dialog_Show(playerid, PasswordATM, DIALOG_STYLE_INPUT, "การตั้งรหัสผ่าน ATM", "กรุณากำหนดรหัสผ่าน ATM ที่คุณต้องการ\nHINT: โปรดจดจำรหัสผ่านของคุณให้ดีหลังจากการกำหนดรหัสผ่านของ ATM คุณ", "ตกลง", "ยกเลิก");
			}
		}
	}
	return 1;
}

Dialog:BankAccount(playerid, response, listitem, inputtext[])
{
	if (ATM_Nearest(playerid) == -1)
	    return 0;

	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	        {
				Dialog_Show(playerid, Withdraw, DIALOG_STYLE_INPUT, "ATM Withdraw", "ยอดเงินในบัญชีธนาคารของคุณ : %s\n\nโปรดป้อนจำนวนเงินที่คุณต้องการถอน :", "ถอนเงิน", "ย้อนกลับ", FormatNumber(playerData[playerid][pAccount]));
			}
	    }
	}

	return 1;
}

Dialog:Withdraw(playerid, response, listitem, inputtext[])
{
	if (ATM_Nearest(playerid) == -1)
	    return 0;

	if (response)
	{
	    new amount = strval(inputtext);

	    if (isnull(inputtext))
	        return Dialog_Show(playerid, Withdraw, DIALOG_STYLE_INPUT, "ATM Withdraw", "ยอดเงินในบัญชีธนาคารของคุณ : %s\n\nโปรดป้อนจำนวนเงินที่คุณต้องการถอน :", "ถอนเงิน", "ย้อนกลับ", FormatNumber(playerData[playerid][pAccount]));

		if (amount < 1 || amount > playerData[playerid][pAccount])
			return Dialog_Show(playerid, Withdraw, DIALOG_STYLE_INPUT, "ATM Withdraw", "ข้อผิดพลาด: มีเงินไม่พอ!\n\nยอดเงินในบัญชีธนาคารของคุณ : %s\n\nโปรดป้อนจำนวนเงินที่คุณต้องการถอน :", "ถอนเงิน", "ย้อนกลับ", FormatNumber(playerData[playerid][pAccount]));

		playerData[playerid][pAccount] -= amount;
		GivePlayerMoneyEx(playerid, amount);

	    SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้ถอนเงินจำนวน %s ออกจากบัญชีธนาคารของคุณ", FormatNumber(amount));
        Dialog_Show(playerid, Withdraw, DIALOG_STYLE_INPUT, "ATM Withdraw", "ยอดเงินในบัญชีธนาคารของคุณ : %s\n\nโปรดป้อนจำนวนเงินที่คุณต้องการถอน :", "ถอนเงิน", "ย้อนกลับ", FormatNumber(playerData[playerid][pAccount]));
	}
	else {
	    Dialog_Show(playerid, BankAccount, DIALOG_STYLE_LIST, "ATM Withdraw", "ถอนเงิน", "ตกลง", "ย้อนกลับ");
	}
	return 1;
}
