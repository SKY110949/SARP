//Punnawit Phimpha ทำให้ IRMZ
//Punnawit Phimpha ทำให้ IRMZ
//Punnawit Phimpha ทำให้ IRMZ
//Punnawit Phimpha ทำให้ IRMZ
//Punnawit Phimpha ทำให้ IRMZ
//Punnawit Phimpha ทำให้ IRMZ
//มีบัค ขออภัยด้วยครับ
//มีบัค ขออภัยด้วยครับ
//มีบัค ขออภัยด้วยครับ
//มีบัค ขออภัยด้วยครับ
//มีบัค ขออภัยด้วยครับ
//มีบัค ขออภัยด้วยครับ

enum pinfo
{
    pLek,
    pLekPasom,
    pTon1,
    pTon2,
    pTon3,
    pTon4,
    pTon5,
}

public OnGameModeInit()
{
	Create3DTextLabel("•กด Y \n ๐เพื่อตัดเหล็ก๐•", 0xFFFFFFFF, -1823.1781,-73.1573,15.1094, 40.0, 0, 0);
    CreatePickup(1239, 2, -1823.1781,-73.1573,15.1094, -1);

    Create3DTextLabel("•กด Y \n๐เพื่อตัดเหล็ก๐•", 0xFFFFFFFF, -1831.0210,-77.7475,15.1094, 40.0, 0, 0);
    CreatePickup(1239, 2, -1831.0210,-77.7475,15.1094, -1);

    Create3DTextLabel("•กด Y \n๐เพื่อตัดเหล็ก๐•", 0xFFFFFFFF, -1828.2411,-92.3073,15.1094, 40.0, 0, 0);
    CreatePickup(1239, 2, -1828.2411,-92.3073,15.1094, -1);

    Create3DTextLabel("•กด Y \n๐เพื่อตัดเหล็ก๐•", 0xFFFFFFFF, -1834.9916,-91.0103,15.1094, 40.0, 0, 0);
    CreatePickup(1239, 2, -1834.9916,-91.0103,15.1094, -1);

    Create3DTextLabel("•กด Y \n๐เพื่อผสม๐•", 0xFFFFFFFF, -1821.5107,-182.4378,9.3984, 40.0, 0, 0);
    CreatePickup(1239, 2, -1821.5107,-182.4378,9.3984, -1);

    Create3DTextLabel("•กด Y \n๐เพื่อขาย๐•", 0xFFFFFFFF, -1856.9851,-169.7926,9.1453, 40.0, 0, 0);
    CreatePickup(1239, 2, -1856.9851,-169.7926,9.1453, -1);

    Create3DTextLabel("•กด Y \n๐เพื่อตัดเหล็ก๐•", 0xFFFFFFFF, -1824.2830,-87.1512,15.1094, 40.0, 0, 0);
    CreatePickup(1239, 2, -1824.2830,-87.1512,15.1094, -1);

    CreateObject(3594, -1836.74292, -90.91970, 14.55380,   0.00000, 0.00000, 0.00000);
	CreateObject(3594, -1836.60071, -91.91531, 15.42190,   0.00000, 0.00000, 35.00000);
	CreateObject(3594, -1825.93933, -91.41500, 14.34810,   0.00000, 0.00000, 0.00000);
	CreateObject(3594, -1826.17639, -92.39750, 15.03740,   0.00000, 0.00000, 35.00000);
	CreateObject(3594, -1832.58093, -77.79550, 14.54550,   0.00000, 0.00000, 0.00000);
	CreateObject(3594, -1821.47961, -73.27600, 14.42580,   0.00000, 0.00000, 0.00000);
	CreateObject(952, -1821.22986, -183.76109, 9.61040,   0.00000, 0.00000, 450.00000);
	CreateObject(854, -1819.51575, -182.38611, 8.63550,   0.00000, 0.00000, 0.00000);
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    new	string[128];
    if(newkeys == KEY_YES)
	{
	    if (IsPlayerInRangeOfPoint(playerid, 3.0,-1823.1781,-73.1573,15.1094))
		{
			if(PlayerInfo[playerid][pLek] >= 50)
   			{
		         SendClientMessage(playerid, -1, " คุณมีเหล็กอยู่ในตัวเต็ม 50 แล้วกรุณานำไปผสม");
			}
			else if(PlayerInfo[playerid][pTon1] >= 1)
   			{
		         SendClientMessage(playerid, -1, "[แอดปอ] ตัด เหล็ก ตรงนี้แล้ว ไปตัดที่ใหม่นะครับ");
			}
			else
			{
			     SetPlayerAttachedObject(playerid, 0, 19835, 1, 0.000000, -0.185999, 0.000000, 1.200002, 89.700012, -84.900001, 2.171000, 2.316998, 1.964000);
				 SetPlayerAttachedObject(playerid, 1, 19801, 1, 0.131000, -0.190000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		         SendClientMessage(playerid, COLOR_YELLOW, " คุณได้รับเหล็ก  +10");
       			 ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0 ,0,0,0,0,1);
		         SetTimerEx("Gebkuncah", 2000, 0, "d", playerid);
		         PlayerInfo[playerid][pTon1] = 1;
		         PlayerInfo[playerid][pLek] += 10;
	         }

		}
		else if (IsPlayerInRangeOfPoint(playerid, 3.0,-1831.0210,-77.7475,15.1094))
		{
			if(PlayerInfo[playerid][pLek] >= 50)
   			{
		         SendClientMessage(playerid, -1, " คุณมีเหล็กอยู่ในตัวเต็ม 50 แล้วกรุณานำไปผสม");
			}
			else if(PlayerInfo[playerid][pTon2] >= 1)
   			{
		         SendClientMessage(playerid, -1, "[แอดปอ] ตัด เหล็ก ตรงนี้แล้ว ไปตัดที่ใหม่นะครับ");
			}
			else
			{
			     SetPlayerAttachedObject(playerid, 0, 19835, 1, 0.000000, -0.185999, 0.000000, 1.200002, 89.700012, -84.900001, 2.171000, 2.316998, 1.964000);
				 SetPlayerAttachedObject(playerid, 1, 19801, 1, 0.131000, -0.190000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		         SendClientMessage(playerid, COLOR_YELLOW, " คุณได้รับเหล็ก  +10");
		         ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0 ,0,0,0,0,1);
		         SetTimerEx("Gebkuncah", 2000, 0, "d", playerid);
		         PlayerInfo[playerid][pTon2] = 1;
		         PlayerInfo[playerid][pLek] += 10;
	         }

		}
		else if (IsPlayerInRangeOfPoint(playerid, 3.0,-1828.2411,-92.3073,15.1094))
		{
			if(PlayerInfo[playerid][pLek] >= 50)
   			{
		         SendClientMessage(playerid, -1, " คุณมีเหล็กอยู่ในตัวเต็ม 50 แล้วกรุณานำไปผสม");
			}
			else if(PlayerInfo[playerid][pTon3] >= 1)
   			{
		         SendClientMessage(playerid, -1, "[แอดปอ] ตัด เหล็ก ตรงนี้แล้ว ไปตัดที่ใหม่นะครับ");
			}
			else
			{
			     SetPlayerAttachedObject(playerid, 0, 19835, 1, 0.000000, -0.185999, 0.000000, 1.200002, 89.700012, -84.900001, 2.171000, 2.316998, 1.964000);
				 SetPlayerAttachedObject(playerid, 1, 19801, 1, 0.131000, -0.190000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		         SendClientMessage(playerid, COLOR_YELLOW, " คุณได้รับเหล็ก  +10");
		         ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0 ,0,0,0,0,1);
		         SetTimerEx("Gebkuncah", 2000, 0, "d", playerid);
		         PlayerInfo[playerid][pTon3] = 1;
		         PlayerInfo[playerid][pLek] += 10;
	         }

		}
		else if (IsPlayerInRangeOfPoint(playerid, 3.0,-1834.9916,-91.0103,15.1094))
		{
			if(PlayerInfo[playerid][pLek] >= 50)
   			{
		         SendClientMessage(playerid, -1, " คุณมีเหล็กอยู่ในตัวเต็ม 50 แล้วกรุณานำไปผสม");
			}
			else if(PlayerInfo[playerid][pTon4] >= 1)
   			{
		         SendClientMessage(playerid, -1, "[แอดปอ] ตัด เหล็ก ตรงนี้แล้ว ไปตัดที่ใหม่นะครับ");
			}
			else
			{
			     SetPlayerAttachedObject(playerid, 0, 19835, 1, 0.000000, -0.185999, 0.000000, 1.200002, 89.700012, -84.900001, 2.171000, 2.316998, 1.964000);
				 SetPlayerAttachedObject(playerid, 1, 19801, 1, 0.131000, -0.190000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		         SendClientMessage(playerid, COLOR_YELLOW, " คุณได้รับเหล็ก  +10");
		         ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0 ,0,0,0,0,1);
		         SetTimerEx("Gebkuncah", 2000, 0, "d", playerid);
		         PlayerInfo[playerid][pTon4] = 1;
		         PlayerInfo[playerid][pLek] += 10;
	         }

		}
		else if (IsPlayerInRangeOfPoint(playerid, 3.0,-1824.2830,-87.1512,15.1094))
		{
			if(PlayerInfo[playerid][pLek] >= 50)
   			{
		         SendClientMessage(playerid, -1, " คุณมีเหล็กอยู่ในตัวเต็ม 50 แล้วกรุณานำไปผสมกรุณานำไปผสม");
			}
			else if(PlayerInfo[playerid][pTon5] >= 1)
   			{
		         SendClientMessage(playerid, -1, "{FF3366}[แอดปอ] {FF3300}ตัด เหล็ก ตรงนี้แล้ว ไปตัดที่ใหม่นะครับ");
			}
			else
			{
			     SetPlayerAttachedObject(playerid, 0, 19835, 1, 0.000000, -0.185999, 0.000000, 1.200002, 89.700012, -84.900001, 2.171000, 2.316998, 1.964000);
				 SetPlayerAttachedObject(playerid, 1, 19801, 1, 0.131000, -0.190000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		         SendClientMessage(playerid, COLOR_YELLOW, " คุณได้รับเหล็ก  +10");
		         ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0 ,0,0,0,0,1);
		         SetTimerEx("Gebkuncah", 2000, 0, "d", playerid);
		         PlayerInfo[playerid][pTon5] = 1;
		         PlayerInfo[playerid][pLek] += 10;
	         }

		}
		else if (IsPlayerInRangeOfPoint(playerid, 3.0,-1821.5107,-182.4378,9.3984))
		{
			if(PlayerInfo[playerid][pLek] <= 9)
   			{
		         SendClientMessage(playerid, -1, "ต้องมีเหล็ก 10ก้อน ในการผสม 1 ครั้ง");
			}
			else
			{
		         SendClientMessage(playerid, COLOR_YELLOW, " [ผสม][เหล็ก -10] [เหล็กผสม +5]");
		         ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0 ,0,0,0,0,1);
		         SetTimerEx("Gebkuncah", 2000, 0, "d", playerid);
		         PlayerInfo[playerid][pTon1] = 0;
		         PlayerInfo[playerid][pTon2] = 0;
		         PlayerInfo[playerid][pTon3] = 0;
		         PlayerInfo[playerid][pTon4] = 0;
		         PlayerInfo[playerid][pTon5] = 0;
		         PlayerInfo[playerid][pLek] -= 10;
		         PlayerInfo[playerid][pLekPasom] += 5;

	         }

		}
		else if (IsPlayerInRangeOfPoint(playerid, 3.0,-1856.9851,-169.7926,9.1453))
		{
			if(PlayerInfo[playerid][pLekPasom] <= 24)
   			{
		         SendClientMessage(playerid, -1, "ต้องมีเหล็กผสม 25 ก้อนถึงจะขายได้");
			}
			else
			{

		         SendClientMessage(playerid, COLOR_YELLOW, " [SELL][เหล็กผสม -25] [MONEY + 2500]");
		         SafeGivePlayerMoney(playerid,2500);
		         PlayerInfo[playerid][pLekPasom] = 0;

	         }

		}
	}
}

