#include <YSI\y_hooks>

hook OnGameModeInit()
{
    CreateDynamicPickup(1239, 2, 1026.2266, 2279.7322, 10.8203);
    CreateDynamic3DTextLabel("โรงงานผลิตดินปืนเถื่อน\nพิมพ์ /buymats เพื่อซื้อดินปืนจากโรงงาน", -1, 1026.2266, 2279.7322, 10.8203, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

    CreateDynamicPickup(1239, 2, 1405.7090,-1298.5753,13.5441);
    CreateDynamic3DTextLabel("จุดส่งดินปืน Main Street\nพิมพ์ /dropmats เพื่อรับดินปืนเป็นของตอบแทน", -1, 1405.7090,-1298.5753,13.5441, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

    //CreateDynamicPickup(1239, 2, 2872.1440, 945.7526, 10.7500);
    //CreateDynamic3DTextLabel("สถานที่ประกอบอาวุธ\nพิมพ์ /createweapon เพื่อสร้างอาวุธปืน", COLOR_YELLOW,  2872.1440, 945.7526, 10.7500, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

}

CMD:buymats(playerid, params[])
{
	if (IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องลงจากรถ!");

    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1026.2266, 2279.7322, 10.8203)) 
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่โรงงานผลิตดินปืน");

    if (GetPlayerMoney(playerid) < 1000)
        return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้มีเงินมากขนาดนั้น ($1,000)");

    if (playerData[playerid][pCPMaterials] != 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณอยู่ระหว่างการซื้อดินปืน, โปรดนำดินปืนที่คุณได้มาไปส่งยังบ้านรางริมทะเล Los Santos");

    else {

        playerData[playerid][pCPMaterials] = 3;
        GivePlayerMoneyEx(playerid, -3000);

        //playerData[playerid][pMaterials] = 1;

        SendClientMessage(playerid, COLOR_GRAD1, "  คุณได้รับดินปืนมาจำนวน 30 ชิ้น, นำไปยังจุดส่งดินปืน Main Street เพื่อรับดินปืนของคุณ (/gotomats)");
        
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** พ่อค้าขายดินปืน : ได้นำ Package ที่มีดินปืน 10 อันให้กับ %s", ReturnRealName(playerid));
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้หยิบ Package จากพ่อค้าขายดินปืนและเหน็บไว้ที่ตัวของเขา", ReturnRealName(playerid));
    }    

    return 1;
}

CMD:dropmats(playerid, params[])
{
	if (IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องลงจากรถ!");

    if (!IsPlayerInRangeOfPoint(playerid, 5.0, 1405.7090,-1298.5753,13.5441)) 
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่จุดส่งดินปืน Main Street");

    if (playerData[playerid][pCPMaterials] == 0)
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้มีดินปืนอยู่ในตัว, โปรดซื้อดินปืนก่อนจะส่งดินปืนให้ที่จุดส่งดินปืน Main Street");

    if (playerData[playerid][pCPMaterials] == 3)
    {
        //DisablePlayerCheckpoint(playerid);
        SendClientMessage(playerid, COLOR_YELLOW, "  คุณได้รับดินปืนจำนวน 30 อันจากการทำงานส่งดินปืนให้กับโรงงานผลิตดินปืน ..");
        
        //GivePlayerMoneyEx(playerid, 6000);
        playerData[playerid][pMaterials] += 30;
        playerData[playerid][pCPMaterials] = 0;

        DisablePlayerCheckpoint(playerid);
        OnAccountUpdate(playerid);
    }

    return 1;
}

CMD:mymats(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "l__________MATERIALS__________l");
    SendClientMessageEx(playerid, COLOR_WHITE, "ดินปืน {33AA33}: %d", playerData[playerid][pMaterials]);
    return 1;
}

CMD:give(playerid, params[]) 
{
	new
	    giveSz[12],
		amount,
		targetID,
		gString[512];

	if(playerData[playerid][pPlayingHours] < 2)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีชั่วโมงออนไลน์มากกว่า 2 ชั่วโมง");

	else if (sscanf(params, "us[32]d", targetID, giveSz, amount)) {
	    SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /give [ไอดีผู้เล่น/ชื่อบางส่วน] [รายการ] [จำนวน]");
	    return SendClientMessage(playerid, COLOR_WHITE, "รายการ : Materials, Ore, Cold, Irons, Diamond");
	}
	else {
	    if (targetID == INVALID_PLAYER_ID) 
            return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");
	    
        if (!IsPlayerNearPlayer(playerid, targetID, 5.0))
            return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

	    if(strcmp(giveSz, "materials", true) == 0) {

	        if (playerData[playerid][pPlayingHours] < 2)
	    		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีชั่วโมงออนไลน์มากกว่า 2 ชั่วโมง");

            if (playerData[playerid][pMaterials] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้มี Materials มากถึงขนาดนั้น");

            if (targetID == playerid)
                return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถให้ Materials กับตัวเองได้");

            if (amount < 1)
                return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องระบุจำนวนมากกว่า 1");

            if (amount > 400)
            {
                format(gString, sizeof(gString), "AdmWarn: %s ได้มอบ Materials ให้ %s เป็นจำนวน %d", ReturnRealName(playerid), ReturnRealName(targetID), amount);
                SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, gString);
            }

            playerData[playerid][pMaterials] -= amount;
            playerData[targetID][pMaterials] += amount;

            SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้ให้ Materials จำนวน %d ให้กับ %s", amount, ReturnRealName(targetID));
            SendClientMessageEx(targetID, COLOR_YELLOW, "คุณได้รับ Materials จำนวน %d จาก %s", amount, ReturnRealName(targetID));

		    SendNearbyMessage(playerid, 25.0, COLOR_PURPLE, "> %s ได้หยิบดินปืนจำนวน %d แล้วมอบให้กับ %s", ReturnRealName(playerid), amount, ReturnRealName(targetID));
		    SendNearbyMessage(targetID, 25.0, COLOR_PURPLE, "> %s ได้รับดินปืนจากมือของ %s เป็นจำนวน %d", ReturnRealName(targetID), ReturnRealName(playerid), amount);
 		
            return 1; 
        }

	    if(strcmp(giveSz, "Ore", true) == 0) {

	        if (playerData[playerid][pPlayingHours] < 2)
	    		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีชั่วโมงออนไลน์มากกว่า 2 ชั่วโมง");

            if (playerData[playerid][pOre] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้มี Irons มากถึงขนาดนั้น");

            if (targetID == playerid)
                return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถให้ Irons กับตัวเองได้");

            if (amount < 1)
                return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องระบุจำนวนมากกว่า 1");

            if (amount > 400)
            {
                format(gString, sizeof(gString), "AdmWarn: %s ได้มอบ Irons ให้ %s เป็นจำนวน %d", ReturnRealName(playerid), ReturnRealName(targetID), amount);
                SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, gString);
            }

            playerData[playerid][pIrons] -= amount;
            playerData[targetID][pIrons] += amount;

            SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้ให้ Irons จำนวน %d ให้กับ %s", amount, ReturnRealName(targetID));
            SendClientMessageEx(targetID, COLOR_YELLOW, "คุณได้รับ Irons จำนวน %d จาก %s", amount, ReturnRealName(targetID));

		    SendNearbyMessage(playerid, 25.0, COLOR_PURPLE, "> %s ได้หยิบแร่เหล็กจำนวน %d แล้วมอบให้กับ %s", ReturnRealName(playerid), amount, ReturnRealName(targetID));
		    SendNearbyMessage(targetID, 25.0, COLOR_PURPLE, "> %s ได้รับแร่เหล็กจากมือของ %s เป็นจำนวน %d", ReturnRealName(targetID), ReturnRealName(playerid), amount);
 		
            return 1; 
        }

	    if(strcmp(giveSz, "cold", true) == 0) {

	        if (playerData[playerid][pPlayingHours] < 2)
	    		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีชั่วโมงออนไลน์มากกว่า 2 ชั่วโมง");

            if (playerData[playerid][pCold] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้มี Cold มากถึงขนาดนั้น");

            if (targetID == playerid)
                return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถให้ Cold กับตัวเองได้");

            if (amount < 1)
                return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องระบุจำนวนมากกว่า 1");

            if (amount > 400)
            {
                format(gString, sizeof(gString), "AdmWarn: %s ได้มอบ Cold ให้ %s เป็นจำนวน %d", ReturnRealName(playerid), ReturnRealName(targetID), amount);
                SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, gString);
            }

            playerData[playerid][pCold] -= amount;
            playerData[targetID][pCold] += amount;

            SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้ให้ Cold จำนวน %d ให้กับ %s", amount, ReturnRealName(targetID));
            SendClientMessageEx(targetID, COLOR_YELLOW, "คุณได้รับ Cold จำนวน %d จาก %s", amount, ReturnRealName(targetID));

		    SendNearbyMessage(playerid, 25.0, COLOR_PURPLE, "> %s ได้หยิบแร่ถ่านจำนวน %d แล้วมอบให้กับ %s", ReturnRealName(playerid), amount, ReturnRealName(targetID));
		    SendNearbyMessage(targetID, 25.0, COLOR_PURPLE, "> %s ได้รับแร่ถ่านจากมือของ %s เป็นจำนวน %d", ReturnRealName(targetID), ReturnRealName(playerid), amount);
 		
            return 1; 
        }

	    if(strcmp(giveSz, "Irons", true) == 0) {

	        if (playerData[playerid][pPlayingHours] < 2)
	    		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีชั่วโมงออนไลน์มากกว่า 2 ชั่วโมง");

            if (playerData[playerid][pIrons] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้มี Ore มากถึงขนาดนั้น");

            if (targetID == playerid)
                return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถให้ Ore กับตัวเองได้");

            if (amount < 1)
                return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องระบุจำนวนมากกว่า 1");

            if (amount > 400)
            {
                format(gString, sizeof(gString), "AdmWarn: %s ได้มอบ Ore ให้ %s เป็นจำนวน %d", ReturnRealName(playerid), ReturnRealName(targetID), amount);
                SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, gString);
            }

            playerData[playerid][pOre] -= amount;
            playerData[targetID][pOre] += amount;

            SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้ให้ Ore จำนวน %d ให้กับ %s", amount, ReturnRealName(targetID));
            SendClientMessageEx(targetID, COLOR_YELLOW, "คุณได้รับ Ore จำนวน %d จาก %s", amount, ReturnRealName(targetID));

		    SendNearbyMessage(playerid, 25.0, COLOR_PURPLE, "> %s ได้หยิบแร่ที่ยังไม่ผ่านการแปรรูปจำนวน %d แล้วมอบให้กับ %s", ReturnRealName(playerid), amount, ReturnRealName(targetID));
		    SendNearbyMessage(targetID, 25.0, COLOR_PURPLE, "> %s ได้รับแร่ที่ยังไม่ผ่านการแปรรูปจากมือของ %s เป็นจำนวน %d", ReturnRealName(targetID), ReturnRealName(playerid), amount);
 		
            return 1; 
        }

	    if(strcmp(giveSz, "diamond", true) == 0) {

	        if (playerData[playerid][pPlayingHours] < 2)
	    		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีชั่วโมงออนไลน์มากกว่า 2 ชั่วโมง");

            if (playerData[playerid][pDiamond] < amount)
                return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้มี Diamond มากถึงขนาดนั้น");

            if (targetID == playerid)
                return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถให้ Diamond กับตัวเองได้");

            if (amount < 1)
                return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องระบุจำนวนมากกว่า 1");

            if (amount > 400)
            {
                format(gString, sizeof(gString), "AdmWarn: %s ได้มอบ Diamond ให้ %s เป็นจำนวน %d", ReturnRealName(playerid), ReturnRealName(targetID), amount);
                SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, gString);
            }

            playerData[playerid][pDiamond] -= amount;
            playerData[targetID][pDiamond] += amount;

            SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้ให้ Diamond จำนวน %d ให้กับ %s", amount, ReturnRealName(targetID));
            SendClientMessageEx(targetID, COLOR_YELLOW, "คุณได้รับ Diamond จำนวน %d จาก %s", amount, ReturnRealName(targetID));

		    SendNearbyMessage(playerid, 25.0, COLOR_PURPLE, "> %s ได้หยิบแร่เพรชจำนวน %d แล้วมอบให้กับ %s", ReturnRealName(playerid), amount, ReturnRealName(targetID));
		    SendNearbyMessage(targetID, 25.0, COLOR_PURPLE, "> %s ได้รับแร่เพรชจากมือของ %s เป็นจำนวน %d", ReturnRealName(targetID), ReturnRealName(playerid), amount);
 		
            return 1; 
        }
        else SendClientMessage(playerid, COLOR_GRAD1, "คุณระบุรายการผิดพลาด ..");
    }
    return 1;
}


CMD:gotomats(playerid, params[])
{
    SetPlayerCheckpoint(playerid, 1405.7090,-1298.5753,13.5441, 4.0);
    SendClientMessage(playerid, COLOR_GRAD1, "  จุดพิกัดของที่ส่งดินปืน Main Street");

    return 1;
}

/*CMD:createweapon(playerid, params[])
{
	if (IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องลงจากรถ!");

    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 2872.1440, 945.7526, 10.7500)) 
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่สถานที่ประกอบอาวุธ");

    Dialog_Show(playerid, WeaponPickup, DIALOG_STYLE_LIST, "สถานที่ประกอบอาวุธ", "9mm (ดินปืน 500, เหล็ก 120, ถ่าน 120)\nDesert Eagle (ดินปืน 700, เหล็ก 300, ถ่าน 300)\nShotgun (ดินปืน 700, เหล็ก 300, ถ่าน 300)\nUZI (ดินปืน 1,100, เหล็ก 600, ถ่าน 600, เพรช 400)", "ตกลง", "ยกเลิก");
    return 1;
}

Dialog:WeaponPickup(playerid, response, listitem, inputtext[]) 
{
	if(response)
	{
    	switch (listitem)
	    {
	        case 0: // 9mm
	        {
                if (playerData[playerid][pMaterials] < 500)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีดินปืนมากกว่า 500");

                if (playerData[playerid][pOre] < 120)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเหล็กมากกว่า 120");

                if (playerData[playerid][pCold] < 120)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีถ่านมากกว่า 120");

                GivePlayerValidWeapon(playerid, 22, 100);
                OnAccountUpdate(playerid);

                playerData[playerid][pMaterials] -= 500;
                playerData[playerid][pOre] -= 120;
                playerData[playerid][pCold] -= 120;

                SendClientMessage(playerid, COLOR_YELLOW, "คุณได้รับอาวุธปืน 9mm โดยสูญเสียดินปืน 500, เหล็ก 120, แร่ถ่าน 120, โปรดระวังเจ้าหน้าที่ตำรวจ ..");
                SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้นำอาวุธปืน 9mm ออกจากสถานที่ประกอบอาวุธ", ReturnRealName(playerid));
            }
	        case 1: // Desert Eagle
	        {
                if (playerData[playerid][pMaterials] < 700)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีดินปืนมากกว่า 700");

                if (playerData[playerid][pOre] < 300)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเหล็กมากกว่า 300");

                if (playerData[playerid][pCold] < 300)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีถ่านมากกว่า 300");

                GivePlayerValidWeapon(playerid, 24, 100);
                OnAccountUpdate(playerid);

                playerData[playerid][pMaterials] -= 700;
                playerData[playerid][pOre] -= 300;
                playerData[playerid][pCold] -= 300;

                SendClientMessage(playerid, COLOR_YELLOW, "คุณได้รับอาวุธปืน Desert Eagle โดยสูญเสียดินปืน 700, เหล็ก 300, แร่ถ่าน 300, โปรดระวังเจ้าหน้าที่ตำรวจ ..");
                SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้นำอาวุธปืน Desert Eagle ออกจากสถานที่ประกอบอาวุธ", ReturnRealName(playerid));
            }
	        case 2: // Shotgun
	        {
                if (playerData[playerid][pMaterials] < 700)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีดินปืนมากกว่า 700");

                if (playerData[playerid][pOre] < 300)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเหล็กมากกว่า 300");

                if (playerData[playerid][pCold] < 300)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีถ่านมากกว่า 300");

                GivePlayerValidWeapon(playerid, 25, 100);
                OnAccountUpdate(playerid);

                playerData[playerid][pMaterials] -= 700;
                playerData[playerid][pOre] -= 300;
                playerData[playerid][pCold] -= 300;

                SendClientMessage(playerid, COLOR_YELLOW, "คุณได้รับอาวุธปืน Shotgun โดยสูญเสียดินปืน 700, เหล็ก 300, แร่ถ่าน 300, โปรดระวังเจ้าหน้าที่ตำรวจ ..");
                SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้นำอาวุธปืน Shotgun ออกจากสถานที่ประกอบอาวุธ", ReturnRealName(playerid));
            }
	        case 3: // UZI
	        {
                if (playerData[playerid][pMaterials] < 1100)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีดินปืนมากกว่า 1,100");

                if (playerData[playerid][pOre] < 600)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเหล็กมากกว่า 600");

                if (playerData[playerid][pCold] < 600)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีถ่านมากกว่า 600");

                if (playerData[playerid][pDiamond] < 400)
                    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเพรชมากกว่า 400");

                GivePlayerValidWeapon(playerid, 28, 300);
                OnAccountUpdate(playerid);

                playerData[playerid][pMaterials] -= 1100;
                playerData[playerid][pOre] -= 600;
                playerData[playerid][pCold] -= 600;
                playerData[playerid][pDiamond] -= 400;

                SendClientMessage(playerid, COLOR_YELLOW, "คุณได้รับอาวุธปืน UZI โดยสูญเสียดินปืน 1,100, เหล็ก 600, แร่ถ่าน 600, แร่เพรช 400, โปรดระวังเจ้าหน้าที่ตำรวจ ..");
                SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้นำอาวุธปืน UZI ออกจากสถานที่ประกอบอาวุธ", ReturnRealName(playerid));
            }
        }
    }

    return 1;
}*/
