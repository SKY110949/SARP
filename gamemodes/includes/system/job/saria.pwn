
/*
#define MAX_ALGAE_OBJECT 19 // MAX Object ของสาหร่าย
#define SELL_ALGAE 1 // Define Dialog
new AlgaeObject[MAX_ALGAE_OBJECT]; // ตัวแปร Object

new AlgaeNormal[MAX_PLAYERS]; // สาหร่ายธรรมดา (ตัวแปร)
new AlgePack[MAX_PLAYERS]; // สาหร่ายแปรรูป (ตัวแปร)
new AmountSell[MAX_PLAYERS]; // สรุปยอดรวมผลลัพธ์

public OnGameModeInit() // เอาโค๊ดด้านล่างใส่ใน Function OnGamemodeInit
{
	// Loading Object

	AlgaeObject[0] = CreateObject(823, -2730.61670, -463.31393, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[1] = CreateObject(823, -2731.10547, -457.66888, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[2] = CreateObject(823, -2717.01270, -455.24844, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[3] = CreateObject(823, -2717.25952, -449.57349, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[4] = CreateObject(823, -2722.27808, -449.88675, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[5] = CreateObject(823, -2705.97437, -460.36893, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[6] = CreateObject(823, -2705.08911, -464.29196, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[7] = CreateObject(823, -2704.49463, -468.25790, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[8] = CreateObject(823, -2717.45532, -467.93979, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[9] = CreateObject(823, -2722.72461, -469.08231, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[10] = CreateObject(823, -2727.65210, -469.71756, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[11] = CreateObject(823, -2727.65210, -469.71756, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[12] = CreateObject(823, -2716.26001, -473.25650, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[13] = CreateObject(823, -2721.09009, -474.11401, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[14] = CreateObject(823, -2725.18481, -475.04831, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[15] = CreateObject(823, -2740.16089, -474.83746, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[16] = CreateObject(823, -2736.37109, -478.08548, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[17] = CreateObject(823, -2718.73975, -487.84564, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[18] = CreateObject(823, -2705.20728, -494.82217, 2.73710,   0.00000, 0.00000, 0.00000);

	CreatePickup(1318, 2, 405.7456, -1728.7709, 9.2161, -1);
	Create3DTextLabel("{FFFF00}[การแปรรูปสาหร่าย]\n{FFFFFF}/กรุณาพิมพ์ /pack", 0x008080FF, 05.7456, -1728.7709, 9.2161, 40.0, 0, 0);

	CreatePickup(1318, 2, 411.8524,-1728.7625,9.2138, -1);
	Create3DTextLabel("{FFFF00}[การขายสาหร่าย]\n{FFFFFF}/กรุณาพิมพ์ /sellalgae", 0x008080FF, 411.8524,-1728.7625,9.2138, 40.0, 0, 0);

	SetTimer("RespawnAlgae", 600000, 1); // 1000 = 1 Seconds , 60000 = 60 Seconds ,
}


CMD:sarai(playerid) {

	SendClientMessage(playerid, COLOR_GREEN, "___________________________คำสั่งพื้นฐาน___________________________");
	SendClientMessage(playerid, COLOR_GRAD1, "/algae, /packtaoka, /sellalgae ");


}

//if(strcmp(cmd, "/algae", true) == 0 || strcmp(cmd, "/ฟเเ", true) == 0)
CMD:algae(playerid, params[])
	{
		if(IsPlayerConnected(playerid))
	    {
			if (IsPlayerNearObject(playerid, AlgaeObject[0], 3.0)) return PickAlgae(playerid, 0);
			if (IsPlayerNearObject(playerid, AlgaeObject[1], 3.0)) return PickAlgae(playerid, 1);
			if (IsPlayerNearObject(playerid, AlgaeObject[2], 3.0)) return PickAlgae(playerid, 2);
			if (IsPlayerNearObject(playerid, AlgaeObject[3], 3.0)) return PickAlgae(playerid, 3);
			if (IsPlayerNearObject(playerid, AlgaeObject[4], 3.0)) return PickAlgae(playerid, 4);
			if (IsPlayerNearObject(playerid, AlgaeObject[5], 3.0)) return PickAlgae(playerid, 5);
			if (IsPlayerNearObject(playerid, AlgaeObject[6], 3.0)) return PickAlgae(playerid, 6);
			if (IsPlayerNearObject(playerid, AlgaeObject[7], 3.0)) return PickAlgae(playerid, 7);
			if (IsPlayerNearObject(playerid, AlgaeObject[8], 3.0)) return PickAlgae(playerid, 8);
			if (IsPlayerNearObject(playerid, AlgaeObject[9], 3.0)) return PickAlgae(playerid, 9);
			if (IsPlayerNearObject(playerid, AlgaeObject[10], 3.0)) return PickAlgae(playerid, 10);
			if (IsPlayerNearObject(playerid, AlgaeObject[11], 3.0)) return PickAlgae(playerid, 11);
			if (IsPlayerNearObject(playerid, AlgaeObject[12], 3.0)) return PickAlgae(playerid, 12);
			if (IsPlayerNearObject(playerid, AlgaeObject[13], 3.0)) return PickAlgae(playerid, 13);
			if (IsPlayerNearObject(playerid, AlgaeObject[14], 3.0)) return PickAlgae(playerid, 14);
			if (IsPlayerNearObject(playerid, AlgaeObject[15], 3.0)) return PickAlgae(playerid, 15);
			if (IsPlayerNearObject(playerid, AlgaeObject[16], 3.0)) return PickAlgae(playerid, 16);
			if (IsPlayerNearObject(playerid, AlgaeObject[17], 3.0)) return PickAlgae(playerid, 17);
			if (IsPlayerNearObject(playerid, AlgaeObject[18], 3.0)) return PickAlgae(playerid, 18);
		}
		else return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ใกล้กับสาหร่ายใด ๆ");
		return 1;
	}

//if(strcmp(cmd, "/packtaoka", true) == 0 || strcmp(cmd, "/dwadaเ", true) == 0)
CMD:packtaoka(playerid, params[])
    {
		if(IsPlayerConnected(playerid))
	    {
			if (!IsPlayerInRangeOfPoint(playerid, 7.0, 405.7456, -1728.7709, 9.2161))
				return SendClientMessage(playerid, COLOR_GRAD2, "คุณต้องอยู่ที่จุดแปรรูปสาหร่าย");

			if (AlgaeNormal[playerid] < 1)
				return SendClientMessage(playerid, COLOR_GRAD2, "คุณต้องมีสาหร่ายธรรมดามากกว่า 1");

			//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s ได้หยิบสาหร่ายใส่เครื่องผลิตสาหร่ายแปรรูป", ReturnRealName(playerid), params);
			SendClientMessage(playerid, COLOR_YELLOW, "-1 สาหร่าย");
			SendClientMessage(playerid, COLOR_YELLOW, "+1 สาหร่ายแปรรูป");

			AlgaeNormal[playerid] -= 1;
			AlgePack[playerid] += 1;
		}
		return 1;
	}

//if(strcmp(cmd, "/sellalgae", true) == 0 || strcmp(cmd, "/sellalgaed", true) == 0)
CMD:sellalgae(playerid, params[])
	{
		if(IsPlayerConnected(playerid))
	    {
			if (!IsPlayerInRangeOfPoint(playerid, 7.0, 411.8524,-1728.7625,9.2138))
				return SendClientMessage(playerid, COLOR_GRAD2, "คุณต้องอยู่ที่จุดขายสาหร่าย");

			new string[128];

			AmountSell[playerid] = AlgePack[playerid] * 350;
			
			

			format(string, sizeof(string), "คุณมีสาหร่าย %d กิโลกรัม\nขายได้กิโลละ 500\nคุณจะได้รับเงิน $%d", AlgePack[playerid], AmountSell[playerid]);
			ShowPlayerDialog(playerid, SELL_ALGAE, DIALOG_STYLE_MSGBOX, "กระเป๋าเก็บสาหร่าย", string, "ขาย", "ยกเลิก");
		}
		return 1;
	}

forward RespawnAlgae(); // ใส่ด้านล่างสุดของ Gamemode
public RespawnAlgae() // มีหน้าที่ในการ RespawnObject สาหร่ายทุก ๆ 10 นาที
{
    for(new i = 0; i < sizeof(AlgaeObject); i ++)
    {
        DestroyObject(AlgaeObject[i]);
    }

	AlgaeObject[0] = CreateObject(823, -2730.61670, -463.31393, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[1] = CreateObject(823, -2731.10547, -457.66888, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[2] = CreateObject(823, -2717.01270, -455.24844, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[3] = CreateObject(823, -2717.25952, -449.57349, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[4] = CreateObject(823, -2722.27808, -449.88675, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[5] = CreateObject(823, -2705.97437, -460.36893, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[6] = CreateObject(823, -2705.08911, -464.29196, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[7] = CreateObject(823, -2704.49463, -468.25790, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[8] = CreateObject(823, -2717.45532, -467.93979, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[9] = CreateObject(823, -2722.72461, -469.08231, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[10] = CreateObject(823, -2727.65210, -469.71756, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[11] = CreateObject(823, -2727.65210, -469.71756, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[12] = CreateObject(823, -2716.26001, -473.25650, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[13] = CreateObject(823, -2721.09009, -474.11401, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[14] = CreateObject(823, -2725.18481, -475.04831, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[15] = CreateObject(823, -2740.16089, -474.83746, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[16] = CreateObject(823, -2736.37109, -478.08548, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[17] = CreateObject(823, -2718.73975, -487.84564, 2.73710,   0.00000, 0.00000, 0.00000);
	AlgaeObject[18] = CreateObject(823, -2705.20728, -494.82217, 2.73710,   0.00000, 0.00000, 0.00000);

	SendClientMessageToAll(COLOR_YELLOW, "ระบบ : ระบบได้ทำการรี Object ของอาชีพสาหร่ายเรียบร้อยแล้ว!");

	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) // ค้นหา Function OnDialogResponse แล้วเอาไปใส่ใน Function
{
	new string[128];

	if(dialogid == SELL_ALGAE)
	{
        if(response) // If they clicked 'Yes' or pressed enter
        {
			AmountSell[playerid] = AlgePack[playerid] * 350;

			format(string, sizeof(string), "คุณได้รับเงินจำนวน $%d จากการขายสาหร่าย", AmountSell[playerid]);
			SendClientMessage(playerid, COLOR_YELLOW, string);

			GivePlayerMoneyEx(playerid, AmountSell[playerid]);

			AlgePack[playerid] = 0;
        }
        else // Pressed ESC or clicked cancel
        {
            return 1;
        }

	}
	return 1;
}

stock PickAlgae(playerid, algae) // ใส่ด้านล่าง Stock
{
	if (algae == 0)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[0], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[0]);

			AlgaeNormal[playerid] += 1;
		}
	}

	if (algae == 1)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[1], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[1]);

			AlgaeNormal[playerid] += 1;
		}
	}

	if (algae == 2)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[2], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[2]);

			AlgaeNormal[playerid] += 1;
		}
	}

	if (algae == 3)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[3], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[3]);

			AlgaeNormal[playerid] += 1;
		}
	}

	if (algae == 4)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[4], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[4]);

			AlgaeNormal[playerid] += 1;
		}
	}

	if (algae == 5)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[5], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[5]);

			AlgaeNormal[playerid] += 1;
		}
	}

	if (algae == 6)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[6], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[6]);

			AlgaeNormal[playerid] += 1;
		}
	}

	if (algae == 7)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[7], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[7]);

			AlgaeNormal[playerid] += 1;
		}
	}

	if (algae == 8)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[8], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[8]);

			AlgaeNormal[playerid] += 1;
		}
	}

	if (algae == 9)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[9], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[9]);

			AlgaeNormal[playerid] += 1;
		}
	}

	if (algae == 10)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[10], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[10]);

			AlgaeNormal[playerid] += 1;
		}
	}

	if (algae == 11)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[11], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[11]);

			AlgaeNormal[playerid] += 1;
		}
	}

	if (algae == 12)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[12], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[12]);

			AlgaeNormal[playerid] += 1;
		}
	}

	if (algae == 13)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[13], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[13]);

			AlgaeNormal[playerid] += 1;
		}
	}

	if (algae == 14)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[14], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[14]);

			AlgaeNormal[playerid] += 1;
		}
	}

	if (algae == 15)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[15], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[15]);

			AlgaeNormal[playerid] += 1;
		}
	}

	if (algae == 16)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[16], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[16]);

			AlgaeNormal[playerid] += 1;
		}
	}

	if (algae == 17)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[17], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[17]);

			AlgaeNormal[playerid] += 1;
		}
	}

	if (algae == 18)
	{
		if(IsPlayerNearObject(playerid, AlgaeObject[18], 3.0))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "สาหร่าย +1");
			DestroyObject(AlgaeObject[18]);

			AlgaeNormal[playerid] += 1;
		}
	}

	return 1;
}*/

stock IsPlayerNearObject(playerid, objectid, Float:range) // ใส่ด้านล่าง Stock
{
    new Float:X, Float:Y, Float:Z;
    GetObjectPos(objectid, X, Y, Z);
    return (IsPlayerInRangeOfPoint(playerid, range, X, Y, Z));
}


// หา Stock สุดท้ายใน Gamemode แล้วเอา Stock ของด้านบนไปใส่ทั้งสองอันต่อเลยครับ
