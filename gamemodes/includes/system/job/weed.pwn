#include <YSI\y_hooks>

/*new
    CPCannabis[MAX_PLAYERS];*/

hook OnGameModeInit()
{
    CreateDynamicPickup(1239, 2, 1248.8494, 365.6281, 19.5547);
    CreateDynamic3DTextLabel("แหล่งผลิตกัญชาผิดกฎหมาย\nพิมพ์ /cannabis เพื่อเลือกซื้อกัญชา", -1, 1248.8494, 365.6281, 19.5547, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

    CreateDynamicPickup(1239, 2, -391.3606, 2221.5217, 42.4297);
    CreateDynamic3DTextLabel("หมู่บ้านร้าง\nพิมพ์ /dropweed เพื่อส่งกัญชา", -1, -391.3606, 2221.5217, 42.4297, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
}

CMD:cannabis(playerid, params[])
{
	if (IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องลงจากรถ!");

    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1248.8494, 365.6281, 19.5547)) 
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่ขายกัญชา");

    if (playerData[playerid][pCannabis] != 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณอยู่ระหว่างการส่งมอบกัญชา, โปรดทำภารกิจให้สำเร็จก่อนจะเริ่มงานอีกครั้ง");

    if (playerData[playerid][pCPCannabis] != 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณอยู่ระหว่างการส่งมอบกัญชา, โปรดส่งกัญชาให้ลูกค้าก่อนจะเริ่มงานอีกครั้ง");

    Dialog_Show(playerid, CannabisPickup, DIALOG_STYLE_LIST, "เลือกซื้อกัญชาผิดกฎหมาย", "กัญชา (ฟอยล์ทอง) - $5,000\nกัญชา (ฟอยล์น้ำเงิน) - $9,000\nกัญชา (ฟอยล์เทปใส) - $8,000", "ตกลง", "ยกเลิก");

    return 1;
}

CMD:dropweed(playerid, params[])
{
	if (IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องลงจากรถ!");

    if (!IsPlayerInRangeOfPoint(playerid, 3.0, -391.3606, 2221.5217, 42.4297)) 
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่ขายกัญชา");

    if (playerData[playerid][pCannabis] == 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องเริ่มต้นส่งกัญชาก่อน, จึงจะสามารถส่งกัญชาให้หมู่บ้านร้างได้สำเร็จ");

    if (playerData[playerid][pCPCannabis] == 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องเริ่มต้นส่งกัญชาก่อน, จึงจะสามารถส่งกัญชาให้หมู่บ้านร้างได้สำเร็จ");

    else
    {
        if (playerData[playerid][pCPCannabis] == 1)
        {
            //DisablePlayerCheckpoint(playerid);
            SendClientMessage(playerid, COLOR_YELLOW, "คุณได้รับเงินแดงจำนวน $2,500 จากการส่งกัญชาฟอยล์สีทองให้กับลูกค้า, และได้รับค่าวิ่งงานจำนวน $2,000");
            
            //GivePlayerMoneyEx(playerid, 6000);
            playerData[playerid][pRMoney] += 4500;
            playerData[playerid][pCPCannabis] = 0;
            playerData[playerid][pCannabis] = 0;
        }

        else if (playerData[playerid][pCPCannabis] == 2)
        {
            //DisablePlayerCheckpoint(playerid);
            SendClientMessage(playerid, COLOR_YELLOW, "คุณได้รับเงินแดงจำนวน $4,500 จากการส่งกัญชาฟอยล์น้ำเงินให้กับลูกค้า, และได้รับค่าวิ่งงานจำนวน $2,000");
            
            //GivePlayerMoneyEx(playerid, 10000);
            playerData[playerid][pRMoney] += 6500;
            playerData[playerid][pCPCannabis] = 0;
            playerData[playerid][pCannabis] = 0;

        }

        else if (playerData[playerid][pCPCannabis] == 3)
        {
            //DisablePlayerCheckpoint(playerid);
            SendClientMessage(playerid, COLOR_YELLOW, "คุณได้รับเงินแดงจำนวน $4,000 จากการส่งกัญชาฟอยล์เทปใสให้กับลูกค้า, และได้รับค่าวิ่งงานจำนวน $2,000");
            
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
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้มีเงินมากขนาดนั้น");

                //SetPlayerCheckpoint(playerid, -391.3606, 2221.5217, 42.4297, 4.0);
                playerData[playerid][pCPCannabis] = 1;
                GivePlayerMoneyEx(playerid, -2500);

                playerData[playerid][pCannabis] = 1;
                SendClientMessage(playerid, COLOR_YELLOW, "คุณได้เลือกซื้อกัญชา (ฟอยล์ทอง) เป็นจำนวนเงิน $2,500, มุ่งหน้าไปยังสถานที่นัดหมาย (หมู่บ้านร้าง) เพื่อส่งกัญชา");
                SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s ได้หยิบกัญชา (ฟอยล์ทอง) ออกมาจากโรงงานผลิตกัญชา", ReturnRealName(playerid));
            }
	        case 1:
	        {
                if (GetPlayerMoney(playerid) < 4500)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้มีเงินมากขนาดนั้น");

                //SetPlayerCheckpoint(playerid, -391.3606, 2221.5217, 42.4297, 4.0);
                playerData[playerid][pCPCannabis] = 2;
                GivePlayerMoneyEx(playerid, -4500);

                playerData[playerid][pCannabis] = 2;
                SendClientMessage(playerid, COLOR_YELLOW, "คุณได้เลือกซื้อกัญชา (ฟอยล์น้ำเงิน) เป็นจำนวนเงิน $4,500, มุ่งหน้าไปยังสถานที่นัดหมาย (หมู่บ้านร้าง) เพื่อส่งกัญชา");
                SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s ได้หยิบกัญชา (ฟอยล์น้ำเงิน) ออกมาจากโรงงานผลิตกัญชา", ReturnRealName(playerid));
            }
	        case 2:
	        {
                if (GetPlayerMoney(playerid) < 4000)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้มีเงินมากขนาดนั้น");

                //SetPlayerCheckpoint(playerid, -391.3606, 2221.5217, 42.4297, 4.0);
                playerData[playerid][pCPCannabis] = 3;
                GivePlayerMoneyEx(playerid, -4000);

                playerData[playerid][pCannabis] = 3;
                SendClientMessage(playerid, COLOR_YELLOW, "คุณได้เลือกซื้อกัญชา (ฟอยล์ใส) เป็นจำนวนเงิน $4,000, มุ่งหน้าไปยังสถานที่นัดหมาย (หมู่บ้านร้าง) เพื่อส่งกัญชา");
                SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s ได้หยิบกัญชา (ฟอยล์ใส) ออกมาจากโรงงานผลิตกัญชา", ReturnRealName(playerid));
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
