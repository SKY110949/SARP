

#include <YSI\y_hooks>

new FishingPlace[MAX_PLAYERS];
new FishingCP[MAX_PLAYERS];
new FishingBoat[MAX_PLAYERS];
new FishingCity[MAX_PLAYERS];

new const Float:GoFishingPlace[5][3] = {
    {-3157.8335,564.9799,-1.0573},
    {-3101.4941,756.6334,0.7850},
    {-3179.5203,347.2113,-0.4135},
    {-3077.1270,183.4922,0.3212},
    {-3252.9302,342.7394,-0.0978}
};

new const Float:GoFishingPlace_LS[3][3] = {
	{813.6824,-2248.2407,-0.4488},
	{407.6824,-2318.2407,-0.5752},
	{-25.9471,-1981.9995,-0.6268}
};

new const FishNames[5][20] = {
	"ปลาทูน่า",
	"ปลาแซลมอน",
	"ปลากระโทงดาบ",
	"ปลาไหลมอเรย์",
	"ปลาฉลาม"
};

hook OnPlayerConnect(playerid) {
    FishingCP[playerid] = 0;
    FishingPlace[playerid] = -1;
    FishingBoat[playerid] = 0;
    FishingCity[playerid] = 0;
}

CMD:fishhelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
	SendClientMessage(playerid, COLOR_GRAD3,"/myfish (ปลาที่ตกได้) /gofishing (ไปตกปลา) /fish (เริ่มตกปลา) /stopfishing (หยุดตกปลา) /unloadfish (ขายปลา)");
	return 1;
}

CMD:gofishing(playerid, params[]) {

    new city, place;
	if(sscanf(params,"ii", city, place)) {
        SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /gofishing [เลขเมือง] [1(บนเรือ)/2(จากสะพาน)]");
        SendClientMessage(playerid, COLOR_GRAD1, "เมืองที่ใช้ได้: 1 - LS, 2 - SF");
        return 1;
    }

    if (city < 1 || city > 2) {
        SendClientMessage(playerid, COLOR_GRAD1, "เลขเมืองไม่ถูกต้อง 1 และ 2 เท่านั้น !!");
        return 1;
    }

    if (FishingPlace[playerid] != -1) {
        return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมี เช็คพ้อย/ภารกิจ อยู่");
    }

    FishingCity[playerid] = city;

    if (place == 1) {
        new carid = -1;
		if((carid = PlayerCar_GetID(GetPlayerVehicleID(playerid))) != -1 || (carid = PlayerCar_GetID(IsNearBoatID(playerid))) != -1)
		{
		    if(IsABoat(playerCarData[carid][carModel])) {

		 	    if(playerData[playerid][pFishes] > 5000) {
			        SendClientMessage(playerid, COLOR_GREEN, "คุณตกปลาพอแล้ว");
			        SendClientMessage(playerid, COLOR_GREEN, "/unloadfish หากคุณต้องการขายปลาของคุณ");
                    return 1;
			    }

                new rand = 0;

                if (FishingCity[playerid] == 1) {
                    rand = random(sizeof(GoFishingPlace_LS));
                    if (IsPlayerInRangeOfPoint(playerid, 30.0, GoFishingPlace_LS[rand][0],GoFishingPlace_LS[rand][1],GoFishingPlace_LS[rand][2])) {
                        FishingPlace[playerid] = 1;
                        SendClientMessage(playerid, COLOR_WHITE, "เริ่มตกปลาได้ที่นี่ (/fish) เมื่อเสร็จแล้วให้คุณ /stopfishing และ /unloadfish");
                        DisablePlayerCheckpoint(playerid);
                    }
                    else {
                        SetPlayerCheckpoint(playerid, GoFishingPlace_LS[rand][0],GoFishingPlace_LS[rand][1],GoFishingPlace_LS[rand][2], 30.0);
                        SendClientMessage(playerid, COLOR_GREEN, "ไปที่จุดตกปลาในมหาสมุทรและเริ่มตกปลา (/fish)");
                    }
                }
                else {
                    rand = random(sizeof(GoFishingPlace));
                    if (IsPlayerInRangeOfPoint(playerid, 30.0, GoFishingPlace[rand][0],GoFishingPlace[rand][1],GoFishingPlace[rand][2])) {
                        FishingPlace[playerid] = 1;
                        SendClientMessage(playerid, COLOR_WHITE, "เริ่มตกปลาได้ที่นี่ (/fish) เมื่อเสร็จแล้วให้คุณ /stopfishing และ /unloadfish");
                        DisablePlayerCheckpoint(playerid);
                    }
                    else {
                        SetPlayerCheckpoint(playerid, GoFishingPlace[rand][0],GoFishingPlace[rand][1],GoFishingPlace[rand][2], 30.0);
                        SendClientMessage(playerid, COLOR_GREEN, "ไปที่จุดตกปลาในมหาสมุทรและเริ่มตกปลา (/fish)");
                    }
                }
                FishingCP[playerid] = rand + 1;
			}
			else
			{
			     SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่ ใน/ใกล้ เรือของคุณเพื่อใช้งาน");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่ ใน/ใกล้ เรือของคุณเพื่อใช้งาน");
		}
    }
    else if (place == 2) {

	    if(playerData[playerid][pFishes] > 1000) {
	        SendClientMessage(playerid, COLOR_GREEN, "ตกปลาพอแล้ว");
	        SendClientMessage(playerid, COLOR_GREEN, "/unloadfish หากคุณต้องการขายปลาของคุณ");
            return 1;
	    }

        if (FishingCity[playerid] == 1) {
            if (!IsPlayerInRangeOfPoint(playerid, 30.0, 383.6021,-2061.7881,7.6140))
            {
                SetPlayerCheckpoint(playerid, 383.6021,-2061.7881,7.6140, 30.0);
                SendClientMessage(playerid, COLOR_GREEN, "ไปที่จุดตกปลาในมหาสมุทรและเริ่มตกปลา (/fish)");
            }
            else {
                FishingPlace[playerid] = 2;
                SendClientMessage(playerid, COLOR_WHITE, "เริ่มตกปลาได้ที่นี่ (/fish) เมื่อเสร็จแล้วให้คุณ /stopfishing และ /unloadfish");
            }
            FishingCP[playerid] = sizeof(GoFishingPlace_LS) + 1;
        }
        else {
            if (!IsPlayerInRangeOfPoint(playerid, 30.0, -2962.3938,497.5347,0.6783))
            {
                SetPlayerCheckpoint(playerid, -2962.3938,497.5347,0.6783, 30.0);
                SendClientMessage(playerid, COLOR_GREEN, "ไปที่จุดตกปลาในมหาสมุทรและเริ่มตกปลา (/fish)");
            }
            else {
                FishingPlace[playerid] = 2;
                SendClientMessage(playerid, COLOR_WHITE, "เริ่มตกปลาได้ที่นี่ (/fish) เมื่อเสร็จแล้วให้คุณ /stopfishing และ /unloadfish");
            }
            FishingCP[playerid] = sizeof(GoFishingPlace) + 1;
        }
    }
    else {
        SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /gofishing [1(บนเรือ)/2(จากสะพาน)]");
    }
    return 1;
}

hook OnPlayerEnterCheckpoint(playerid) {
    #if defined SV_DEBUG
		printf("fishing.pwn: OnPlayerEnterCheckpoint(playerid %d)", playerid);
	#endif
    if (FishingCP[playerid] != 0) {

        if (FishingCity[playerid] == 1) {

            if (FishingCP[playerid] <= sizeof(GoFishingPlace_LS)) { // เรือ
                new rand = FishingCP[playerid]-1;
                if (IsPlayerInRangeOfPoint(playerid, 30.0, GoFishingPlace_LS[rand][0],GoFishingPlace_LS[rand][1],GoFishingPlace_LS[rand][2])) {
                    FishingPlace[playerid] = 1;

                    SendClientMessage(playerid, COLOR_WHITE, "เริ่มตกปลาได้ที่นี่ (/fish) เมื่อเสร็จแล้วให้คุณ /stopfishing และ /unloadfish");
                    DisablePlayerCheckpoint(playerid);
                }
            }
            else {
                if (IsPlayerInRangeOfPoint(playerid, 30.0, 383.6021,-2061.7881,7.6140)) { // สะพาน LS
                    FishingPlace[playerid] = 2;

                    SendClientMessage(playerid, COLOR_WHITE, "เริ่มตกปลาได้ที่นี่ (/fish) เมื่อเสร็จแล้วให้คุณ /stopfishing และ /unloadfish");
                    DisablePlayerCheckpoint(playerid);
                }
                else if (IsPlayerInRangeOfPoint(playerid, 2.5, 2475.2932,-2710.7759,3.1963) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) { // ขายปลา LS
                    new earn = playerData[playerid][pFishes] + random(floatround(playerData[playerid][pFishes]/5));

                
                    if (gettime() - gLastCheckpointTime[playerid] <= 60) {

                        Log(anticheatlog, INFO, "%s ส่ง Fish ในเวลา %d", ReturnPlayerName(playerid), gettime() - gLastCheckpointTime[playerid]);

                        new IP[60];
                        GetPlayerIp(playerid, IP, sizeof(IP));
                        SendRconCommand(sprintf("banip %s",IP));
                        Kick(playerid);
                        return 1;
                    }
  
                    GivePlayerMoneyEx(playerid, earn);
                    GameTextForPlayer(playerid, sprintf("~p~SOLD FISHES WEIGHT ~w~%d FOR %d", playerData[playerid][pFishes], earn), 8000, 4);

                    Log(paychecklog, INFO, "%s ได้รับ เงินสด %d จาก Fishing", ReturnPlayerName(playerid), earn);

                    playerData[playerid][pFishes] = 0;
                    FishingCP[playerid] = 0;
                    DisablePlayerCheckpoint(playerid);
                }
            }
        }
        else {

        // SF
            if (FishingCP[playerid] <= sizeof(GoFishingPlace)) { // เรือ
                new rand = FishingCP[playerid]-1;
                if (IsPlayerInRangeOfPoint(playerid, 30.0, GoFishingPlace[rand][0],GoFishingPlace[rand][1],GoFishingPlace[rand][2])) {
                    FishingPlace[playerid] = 1;

                    SendClientMessage(playerid, COLOR_WHITE, "เริ่มตกปลาได้ที่นี่ (/fish) เมื่อเสร็จแล้วให้คุณ /stopfishing และ /unloadfish");
                    DisablePlayerCheckpoint(playerid);
                }
            }
            else {
                if (IsPlayerInRangeOfPoint(playerid, 30.0, -2962.3938,497.5347,0.6783)) { // สะพาน
                    FishingPlace[playerid] = 2;

                    SendClientMessage(playerid, COLOR_WHITE, "เริ่มตกปลาได้ที่นี่ (/fish) เมื่อเสร็จแล้วให้คุณ /stopfishing และ /unloadfish");
                    DisablePlayerCheckpoint(playerid);
                } // ขายปลา
                else if (IsPlayerInRangeOfPoint(playerid, 2.5, -1714.2390,-62.8139,3.5547) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
		    	    new earn = playerData[playerid][pFishes] + random(floatround(playerData[playerid][pFishes]/4));

                    if (gettime() - gLastCheckpointTime[playerid] <= 60) {

                        Log(anticheatlog, INFO, "%s ส่ง Fish ในเวลา %d", ReturnPlayerName(playerid), gettime() - gLastCheckpointTime[playerid]);

                        new IP[60];
                        GetPlayerIp(playerid, IP, sizeof(IP));
                        SendRconCommand(sprintf("banip %s",IP));
                        Kick(playerid);
                        return 1;
                    }
                    
                    GivePlayerMoneyEx(playerid, earn);
		    	    GameTextForPlayer(playerid, sprintf("~p~SOLD FISHES WEIGHT ~w~%d FOR %d", playerData[playerid][pFishes], earn), 8000, 4);

                    Log(paychecklog, INFO, "%s ได้รับ เงินสด %d จาก Fishing", ReturnPlayerName(playerid), earn);

		    	    playerData[playerid][pFishes] = 0;
                    FishingCP[playerid] = 0;
		    		DisablePlayerCheckpoint(playerid);
                }
            }
        }
        return -2;
    }
    return 1;
}

CMD:stopfishing(playerid, params[]) {
	if(FishingPlace[playerid] != -1)
	{
	    SendClientMessage(playerid, COLOR_GREEN, "คุณหยุดตกปลาแล้ว");

	    if(playerData[playerid][pFishes]) 
            SendClientMessage(playerid, COLOR_GREEN, "/unloadfish หากคุณต้องการขายปลาของคุณ");

	    FishingPlace[playerid]=-1;
        FishingCP[playerid] = 0;
	}
	else SendClientMessage(playerid, COLOR_WHITE, "คุณยังไม่ได้ตกปลา");
	return 1;
}

CMD:unloadfish(playerid, params[]) {

    if(FishingPlace[playerid] != -1)
		return SendClientMessage(playerid, COLOR_LIGHTRED, "หยุดตกปลาก่อนเป็นอันดับแรก /stopfishing");

    new city;
	if(sscanf(params,"i", city)) {
        SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /unloadfish [เลขเมือง]");
        SendClientMessage(playerid, COLOR_GRAD1, "เมืองที่ใช้ได้: 1 - LS, 2 - SF");
        return 1;
    }

    if (city < 1 || city > 2) {
        SendClientMessage(playerid, COLOR_GRAD1, "เลขเมืองไม่ถูกต้อง 1 และ 2 เท่านั้น !!");
        return 1;
    }

	if(playerData[playerid][pFishes])
	{
	    SendClientMessage(playerid, COLOR_GREEN, "สถานที่สำหรับขนส่งปลาและรับเงินถูกทำเครื่องหมายไว้บนแผนที่");
        if (city == 1) {
            SetPlayerCheckpoint(playerid, 2475.2932,-2710.7759,3.1963, 2.0);
            FishingCP[playerid] = sizeof(GoFishingPlace_LS) + 1;
        }
        else {
            SetPlayerCheckpoint(playerid, -1714.2390,-62.8139,3.5547, 2.0);
            FishingCP[playerid] = sizeof(GoFishingPlace) + 1;
        }

	} else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่มีปลา");
	
    return 1;
}

CMD:myfish(playerid, params[]) {
	if(playerData[playerid][pFishes])
	{
	    SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
	    SendClientMessageEx(playerid, COLOR_GREEN, "น้ำหนักปลา [%d] ปอนด์", playerData[playerid][pFishes]);
	} else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่มีปลา");
	
    return 1;
}

CMD:fish(playerid, params[]) {

	if(FishingPlace[playerid] != -1) {
		if(!HasCooldown(playerid,COOLDOWN_FISHING))
		{
            new Fishcaught, Fishlbs;
            SetCooldown(playerid,COOLDOWN_FISHING, 6);

            if (FishingCP[playerid] != 0) {

                if (FishingCity[playerid] == 1) {
                    if (FishingCP[playerid] <= sizeof(GoFishingPlace_LS)) { // เรือ
                        new rand = FishingCP[playerid]-1;
                        if (IsPlayerInRangeOfPoint(playerid, 30.0, GoFishingPlace_LS[rand][0],GoFishingPlace_LS[rand][1],GoFishingPlace_LS[rand][2])) {
                            new id = -1;
                            if((id = PlayerCar_GetID(GetPlayerVehicleID(playerid))) != -1)
                            {
                                if(playerCarData[id][carOwner] != playerData[playerid][pSID])
                                    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่ ใน/ใกล้ เรือของคุณเพื่อใช้มัน");
                            }
                            else if((id = PlayerCar_GetID(IsNearBoatID(playerid))) != -1)
                            {
                                if(playerCarData[id][carOwner] != playerData[playerid][pSID])
                                    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่ ใน/ใกล้ เรือของคุณเพื่อใช้มัน");
                            }

                            if(random(6) >= 5)
                                return SendClientMessageEx(playerid, COLOR_LIGHTRED, "คุณจับอะไรไม่ได้เลย");
    
                            Fishcaught = random(5);
                            Fishlbs = ((Fishcaught+1)*(20 + playerData[playerid][pFishingPerks])) + (1 + random(10));

                            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s ม้วนสายคันขึ้นมาและพบว่าพวกเขาจับ%sได้", ReturnRealName(playerid), FishNames[Fishcaught]);
                            SendClientMessageEx(playerid, COLOR_GREEN, "คุณจับ%s %d ปอนด์", FishNames[Fishcaught], Fishlbs);
        
                            playerData[playerid][pFishes]+=Fishlbs;

                            gLastCheckpointTime[playerid] = gettime();

                            if(playerData[playerid][pFishes] > 5000)
                            {
                                FishingPlace[playerid]=-1;

                                SendClientMessage(playerid, COLOR_GREEN, "ตกปลาพอแล้ว");
                                SendClientMessage(playerid, COLOR_GREEN, "/unloadfish หากคุณต้องการขายปลาของคุณ");
                                return 1;
                            }

                            FishingBoat[playerid]+=Fishlbs;

                            if(FishingBoat[playerid] > 1000) {
                                rand = random(sizeof(GoFishingPlace_LS));
                                SetPlayerCheckpoint(playerid, GoFishingPlace_LS[rand][0],GoFishingPlace_LS[rand][1],GoFishingPlace_LS[rand][2], 30.0);
                                FishingCP[playerid] = rand + 1;
                                FishingBoat[playerid]=0;
                                FishingPlace[playerid]=-1;
                                SendClientMessage(playerid, COLOR_GREEN, "ไปตกปลาในสถานที่อื่น");
                            }
                        }
                        else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณตกปลาที่นี่ไม่ได้");
                    }
                    else {
                        if (IsPlayerInRangeOfPoint(playerid, 30.0, 383.6021,-2061.7881,7.6140)) { // สะพาน
                            if(random(7) >= 5)
                                return SendClientMessageEx(playerid, COLOR_LIGHTRED, "คุณจับอะไรไม่ได้เลย");
    
                            Fishcaught = random(5);
                            Fishlbs = ((Fishcaught+1)*(20 + playerData[playerid][pFishingPerks])) + (1 + random(10));
                            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s ม้วนสายคันขึ้นมาและพบว่าพวกเขาจับ%sได้", ReturnRealName(playerid), FishNames[Fishcaught]);
                            SendClientMessageEx(playerid, COLOR_GREEN, "คุณจับ%s %d ปอนด์", FishNames[Fishcaught], Fishlbs);

                            playerData[playerid][pFishes]+=Fishlbs;

                            gLastCheckpointTime[playerid] = gettime();

                            if(playerData[playerid][pFishes] > 1000)
                            {
                                FishingPlace[playerid]=-1;
                                SendClientMessage(playerid, COLOR_GREEN, "ตกปลาพอแล้ว");
                                SendClientMessage(playerid, COLOR_GREEN, "/unloadfish หากคุณต้องการขายปลาของคุณ");
                                return 1;
                            }
                        }
                        else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณตกปลาที่นี่ไม่ได้");

                    }
                }
                else {
                    if (FishingCP[playerid] <= sizeof(GoFishingPlace)) { // เรือ
                        new rand = FishingCP[playerid]-1;
                        if (IsPlayerInRangeOfPoint(playerid, 30.0, GoFishingPlace[rand][0],GoFishingPlace[rand][1],GoFishingPlace[rand][2])) {
                            new id = -1;
                            if((id = PlayerCar_GetID(GetPlayerVehicleID(playerid))) != -1)
                            {
                                if(playerCarData[id][carOwner] != playerData[playerid][pSID])
                                    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่ ใน/ใกล้ เรือของคุณเพื่อใช้มัน");
                            }
                            else if((id = PlayerCar_GetID(IsNearBoatID(playerid))) != -1)
                            {
                                if(playerCarData[id][carOwner] != playerData[playerid][pSID])
                                    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่ ใน/ใกล้ เรือของคุณเพื่อใช้มัน");
                            }

                            if(random(6) >= 5)
                                return SendClientMessageEx(playerid, COLOR_LIGHTRED, "คุณจับอะไรไม่ได้เลย");
    
                            Fishcaught = random(5);
                            Fishlbs = ((Fishcaught+1)*(20 + playerData[playerid][pFishingPerks])) + (1 + random(10));

                            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s ม้วนสายคันขึ้นมาและพบว่าพวกเขาจับ%sได้", ReturnRealName(playerid), FishNames[Fishcaught]);
                            SendClientMessageEx(playerid, COLOR_GREEN, "คุณจับ%s %d ปอนด์", FishNames[Fishcaught], Fishlbs);
        
                            playerData[playerid][pFishes]+=Fishlbs;

                            gLastCheckpointTime[playerid] = gettime();

                            if(playerData[playerid][pFishes] > 5000)
                            {
                                FishingPlace[playerid]=-1;

                                SendClientMessage(playerid, COLOR_GREEN, "ตกปลาพอแล้ว");
                                SendClientMessage(playerid, COLOR_GREEN, "/unloadfish หากคุณต้องการขายปลาของคุณ");
                                return 1;
                            }

                            FishingBoat[playerid]+=Fishlbs;

                            if(FishingBoat[playerid] > 1000) {
                                rand = random(sizeof(GoFishingPlace));
                                SetPlayerCheckpoint(playerid, GoFishingPlace[rand][0],GoFishingPlace[rand][1],GoFishingPlace[rand][2], 30.0);
                                FishingCP[playerid] = rand + 1;
                                FishingBoat[playerid]=0;
                                FishingPlace[playerid]=-1;
                                SendClientMessage(playerid, COLOR_GREEN, "ไปตกปลาในสถานที่อื่น");
                            }
                        }
                        else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณตกปลาที่นี่ไม่ได้");
                    }
                    else {
                        if (IsPlayerInRangeOfPoint(playerid, 30.0, -2962.3938,497.5347,0.6783)) { // สะพาน
                            if(random(7) >= 5)
                                return SendClientMessageEx(playerid, COLOR_LIGHTRED, "คุณจับอะไรไม่ได้เลย");
    
                            Fishcaught = random(5);
                            Fishlbs = ((Fishcaught+1)*(20 + playerData[playerid][pFishingPerks])) + (1 + random(10));
                            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s ม้วนสายคันขึ้นมาและพบว่าพวกเขาจับ%sได้", ReturnRealName(playerid), FishNames[Fishcaught]);
                            SendClientMessageEx(playerid, COLOR_GREEN, "คุณจับ%s %d ปอนด์", FishNames[Fishcaught], Fishlbs);

                            playerData[playerid][pFishes]+=Fishlbs;

                            gLastCheckpointTime[playerid] = gettime();

                            if(playerData[playerid][pFishes] > 1000)
                            {
                                FishingPlace[playerid]=-1;
                                SendClientMessage(playerid, COLOR_GREEN, "ตกปลาพอแล้ว");
                                SendClientMessage(playerid, COLOR_GREEN, "/unloadfish หากคุณต้องการขายปลาของคุณ");
                                return 1;
                            }
                        }
                        else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณตกปลาที่นี่ไม่ได้");

                    }
                }

            }
		}
		else {
			SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่มีปลารอบ ๆ");
			SendClientMessage(playerid, COLOR_WHITE, "((โปรดรอ 6 วินาทีในแต่ละ /fish))");
		}
	}
	else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "คุณยังไม่ได้ตกปลา");
	}
	return 1;
}