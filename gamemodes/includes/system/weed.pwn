#include <YSI\y_timers>  // pawn-lang/YSI-Includes
#include <YSI\y_hooks> // pawn-lang/YSI-Includes

#define MAX_WEED 500

enum WEED_DATA_E
{
	wObject,
	Float:Xw,
	Float:Yw,
	Float:Zw,
	wOwner[32],
	wTimetoGet,
	wWantWater,
	WCreateID,
	wCount,
	Text3D:wLabel
};

new weedData[MAX_WEED][WEED_DATA_E];
new Iterator:Iter_Weed<MAX_WEED>;

new Planting[MAX_PLAYERS char];
new PlantingID[MAX_PLAYERS];
new PlantCount[MAX_PLAYERS];
new Timer:WeedTimer[MAX_PLAYERS];
//new WeedArea; 

hook OnPlayerConnect(playerid) {
    PlantCount[playerid] = 0;
    Planting{playerid} = false;
	PlantingID[playerid] = -1;

	return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (Planting{playerid}) {
		stop WeedTimer[playerid];
		Planting{playerid} = false;
		Iter_Remove(Iter_Weed, PlantingID[playerid]);
	}
	return 1;
}

hook OnGameModeInit() {
	/*WeedArea = CreateDynamicRectangle(-2360.6577,-119.0069, -2312.6870,-81.0840, 0, 0);
	CreateDynamicMapIcon(-2335.9722,-99.0901,35.3203, 16, -1, 0, 0);*/

	mysql_query(dbCon, "SELECT * FROM `weed`");
	new
	    rows, str[256], objId = 2241;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_WEED)
	{
        cache_get_value_name_int(i, "WCreateID", weedData[i][WCreateID]);
		cache_get_value_name(i, "wOwner", weedData[i][wOwner], 24);
		cache_get_value_name_int(i, "wWantWater", weedData[i][wWantWater]);
		cache_get_value_name_int(i, "wTimetoGet", weedData[i][wTimetoGet]);
		cache_get_value_name_float(i, "Xw", weedData[i][Xw]);
		cache_get_value_name_float(i, "Yw", weedData[i][Yw]);
		cache_get_value_name_float(i, "Zw", weedData[i][Zw]);

		if (weedData[i][wTimetoGet] <= 6000) {
			objId = 3409;
			format(str,sizeof(str),"เจ้าของ %s\nความชุ่มชื้น %d%", weedData[i][wOwner], weedData[i][wWantWater]);
		}
		else {
			objId = 2241;
			new sec = weedData[i][wTimetoGet], minutes, hours, days;
			format(str,sizeof(str),"เจ้าของ %s\nโตเต็มที่ในอีก %s\nความชุ่มชื้น %d%", weedData[i][wOwner], ConvertTimeTH(sec, minutes, hours, days), weedData[i][wWantWater]);
		}
		weedData[i][wLabel] = CreateDynamic3DTextLabel(str , -1, weedData[i][Xw], weedData[i][Yw], weedData[i][Zw] + 1, 2.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
		weedData[i][wObject] = CreateDynamicObject(objId, weedData[i][Xw], weedData[i][Yw], weedData[i][Zw] + 0.2, 0, 0, 0);
        Iter_Add(Iter_Weed, i);
	}

    printf("Weed loaded (%d/%d)", Iter_Count(Iter_Weed), MAX_WEED);
}

CMD:saveweed(playerid, params[])
{
	new szQuery[256];
	foreach(new id : Iter_Weed) if(weedData[id][WCreateID])
	{
		mysql_format(dbCon, szQuery, sizeof(szQuery), "UPDATE `weed` SET `wTimetoGet` = %d, `wWantWater` = %d WHERE `wCreateID`", weedData[id][wTimetoGet], weedData[id][wWantWater], weedData[id][WCreateID]);
		mysql_tquery(dbCon, szQuery); 
	}
	SendClientMessageToAll(COLOR_YELLOW, "ระบบได้ทำการบันทึกข้อมูลเกี่ยวกับแปลงกัญชาเรียบร้อยแล้ว ..");
	return 1;
}

CMD:planthelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GREEN, "___________________________คำสั่งเกี่ยวกับการปลูก___________________________");
   	SendClientMessage(playerid, COLOR_YELLOW, "เมล็ด: {FFFFFF}/plantweed (ปลูกพืช) /harvestweed (เก็บผลผลิต)");
	SendClientMessage(playerid, COLOR_YELLOW, "เมล็ด: {FFFFFF}/watering (รดน้ำ)");
	return 1;
}

CMD:watering(playerid, params[])
{
	new done;

	if(!playerData[playerid][pWatering]) 
		return SendClientMessage(playerid, COLOR_GREY, " คุณไม่มีบัวรดน้ำ");

    if(Planting{playerid}) 
        return SendClientMessage(playerid, COLOR_GREY, "คุณไม่สามารถทำได้ในขณะนี้");
	
	foreach(new f : Iter_Weed) if(weedData[f][WCreateID])
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.0, weedData[f][Xw], weedData[f][Yw], weedData[f][Zw] + 1.0))
		{	
			Planting{playerid} = true;
			PlantingID[playerid] = f;
			PlantCount[playerid] = 0;
			Mobile_GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~Watering weed~n~~r~IIIIIIIIII", 2200, 3);
			WeedTimer[playerid] = repeat WateringWeedTimer(playerid);

			ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0);
			
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s กำลังรดน้ำพืช", ReturnRealName(playerid));
			done = true;
	  		break;
		}
	}
	if(!done) SendClientMessage(playerid, COLOR_GREY, "คุณไม่ได้อยู่ใกล้พืชใด ๆ");
	return 1;
}

CMD:harvestweed(playerid, params[])
{
	new bool:done;

    new factiontype = Faction_GetTypeID(playerid);
	if (factiontype == FACTION_TYPE_POLICE) 
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณเป็นเจ้าหน้าที่รัฐ เราไม่สามารถให้คุณเข้าไปได้");
	
    if(Planting{playerid}) 
        return SendClientMessage(playerid, COLOR_GREY, "คุณไม่สามารถทำได้ในขณะนี้");

	foreach(new f : Iter_Weed) if(weedData[f][WCreateID] && weedData[f][wTimetoGet] <= 1)
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.0, weedData[f][Xw], weedData[f][Yw], weedData[f][Zw] + 1.0))
		{
			Mobile_GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~Harvesting weed~n~~r~IIIIIIIIII", 2200, 3);
			Planting{playerid} = true;
			PlantCount[playerid] = 0;
			PlantingID[playerid] = f;
			WeedTimer[playerid] = repeat HarvestWeedTimer[500 + random(500)](playerid);
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, 1, 0, 0, 0, 0);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s พยายามที่จะเก็บเกี่ยวผลผลิต", ReturnRealName(playerid));
	  		done = true;
	  		break;
		}
	}
	if(!done) SendClientMessage(playerid, COLOR_GREY, "คุณไม่ได้อยู่ใกล้พืชที่สามารถเก็บเกี่ยวได้");
	return 1;
}

CMD:plantweed(playerid, params[])
{
    new factiontype = Faction_GetTypeID(playerid);
	if (factiontype != FACTION_TYPE_GANG && factiontype != FACTION_TYPE_NONE) 
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณเป็นหน่วยงานรัฐที่ดี ไม่ควรทำแบบนี้!!");

	/*if(!IsPlayerInDynamicArea(playerid, WeedArea))
        return SendClientMessage(playerid, COLOR_GREY, " ไม่สามารถปลูกที่นี่ได้");*/

    if(Planting{playerid}) 
        return SendClientMessage(playerid, COLOR_GREY, "คุณไม่สามารถทำได้ในขณะนี้");
	
    if(playerData[playerid][pSeedWeed] >= 3)
    {
		foreach(new f : Iter_Weed) if(weedData[f][WCreateID])
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, weedData[f][Xw], weedData[f][Yw], weedData[f][Zw] + 1.0))
			{	
				return SendClientMessage(playerid, COLOR_GREY, "พื้นที่นี้ได้ถูกใช้ปลูกแล้ว");
			}
		}
		new id = Iter_Free(Iter_Weed);
		if (id != -1) {
			SendClientMessage(playerid, COLOR_GRAD1, " คุณใช้เมล็ดจำนวนทั้งหมด 3");

			Mobile_GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~Planting weed~n~~r~IIIIIIIIII", 2200, 3);
			Planting{playerid} = true;
			playerData[playerid][pSeedWeed] -= 3;
			PlantCount[playerid] = 0;
			PlantingID[playerid] = id;
			WeedTimer[playerid] = repeat PlantWeedTimer(playerid);
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, 1, 0, 0, 0, 0);
			GetPlayerPos(playerid, weedData[id][Xw], weedData[id][Yw], weedData[id][Zw]);
			GetXYInFrontOfPlayer(playerid, weedData[id][Xw], weedData[id][Yw], 1.0);
			MapAndreas_FindZ_For2DCoord(weedData[id][Xw], weedData[id][Yw], weedData[id][Zw]);

			weedData[id][wObject] = CreateDynamicObject(2203, weedData[id][Xw], weedData[id][Yw], weedData[id][Zw] + 0.15, 0, 0, 0);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s พยายามที่จะปลูกอะไรบางอย่าง", ReturnRealName(playerid));

			Iter_Add(Iter_Weed, id);
		}
		else {
			SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: ไม่สามารถปลูกได้มากกว่านี้แล้ว โปรดลองใหม่ภายหลัง");
			return 1;
		}
    }
    else
    {
    	SendClientMessage(playerid, COLOR_GREY, " คุณมีเมล็ดไม่พอที่จะปลูก (3 เมล็ด)");
    	return 1;
    }

    return 1;
}

timer HarvestWeedTimer[1000](playerid) {

	new newDisplay[128];
	PlantCount[playerid]++;
	if(PlantCount[playerid] == 1) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Harvesting weed~n~~b~I~r~IIIIIIIII"; 
	if(PlantCount[playerid] == 2) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Harvesting weed~n~~b~II~r~IIIIIIII"; 
	if(PlantCount[playerid] == 3) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Harvesting weed~n~~b~III~r~IIIIIII"; 
	if(PlantCount[playerid] == 4) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Harvesting weed~n~~b~IIII~r~IIIIII"; 
	if(PlantCount[playerid] == 5) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Harvesting weed~n~~b~IIIII~r~IIIII"; 
	if(PlantCount[playerid] == 6) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Harvesting weed~n~~b~IIIIII~r~IIII"; 
	if(PlantCount[playerid] == 7) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Harvesting weed~n~~b~IIIIIII~r~III"; 
	if(PlantCount[playerid] == 8) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Harvesting weed~n~~b~IIIIIIII~r~II"; 
    if(PlantCount[playerid] == 9) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Harvesting weed~n~~b~IIIIIIIII~r~I"; 
    
    Mobile_GameTextForPlayer(playerid, newDisplay, 2200, 3);

	if(Planting{playerid} && PlantCount[playerid] >= 9)
	{
        stop WeedTimer[playerid];
		new h = PlantingID[playerid];

		if (Iter_Contains(Iter_Weed, h)) {

			new bool:can_take;

			for(new x = 0; x != MAX_PLAYER_DRUG_PACKAGE; x++)
			{
				if(PlayerDrug[playerid][x][drugQTY]==0) {

					can_take=true;

					new packageid = 0;
					switch(random(3)) {
						case 0: packageid = 0;
						case 1: packageid = 3;
						case 2: packageid = 6;
					}
					new szQuery[128];

					new drugid = 1, Float:transfer_amount = float(random(5)) + (float(1 + random(5)) / 10.0), strength = 10 + random(50); // Cannabis
					format(szQuery, sizeof(szQuery), "INSERT INTO `drugs_char` (`drugType`,`drugQTY`,`drugStrength`,`drugPackage`,`charID`) VALUES(%d,%f,%d,%d,%d)", drugid, transfer_amount, strength, packageid, playerData[playerid][pSID]);
					mysql_tquery(dbCon, szQuery, "OnHarvestWeed", "dddfdd", playerid, x, drugid, transfer_amount, strength, packageid);	
		
					format(szQuery, sizeof(szQuery), "DELETE FROM `weed` WHERE `WCreateID` = %d", weedData[h][WCreateID]);
					mysql_query(dbCon, szQuery);
				
					weedData[h][WCreateID] = 0;
					weedData[h][Xw] = 0.0;
					weedData[h][Yw] = 0.0;
					weedData[h][Zw] = 0.0;
					weedData[h][wTimetoGet] = 0;
					weedData[h][wWantWater] = 0;
					
					if(IsValidDynamic3DTextLabel(weedData[h][wLabel]))
						DestroyDynamic3DTextLabel(weedData[h][wLabel]);

					if(IsValidDynamicObject(weedData[h][wObject])) 
						DestroyDynamicObject(weedData[h][wObject]);

					Iter_Remove(Iter_Weed, h);

					break;
				}
			}
			if(!can_take) {
				SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" คุณไม่มีช่องว่างให้กับสิ่งเสพติดนี้ (/dropdrug เพื่อทิ้ง)");
			}
		}
		else {
			Mobile_GameTextForPlayer(playerid, "~r~Failed to harvest weed", 1000, 3);
		}
		ApplyAnimation(playerid, "FAT", "IDLE_tired", 4.0, 0, 0, 0, 0, 0, 1);

        Planting{playerid} = false;
		PlantingID[playerid] = -1;
	}
	return 1;
}

timer WateringWeedTimer[1000](playerid)
{
    new newDisplay[128];
	PlantCount[playerid]++;
	if(PlantCount[playerid] == 1) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Watering weed~n~~b~I~r~IIIIIIIII"; 
	if(PlantCount[playerid] == 2) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Watering weed~n~~b~II~r~IIIIIIII"; 
	if(PlantCount[playerid] == 3) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Watering weed~n~~b~III~r~IIIIIII"; 
	if(PlantCount[playerid] == 4) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Watering weed~n~~b~IIII~r~IIIIII"; 
	if(PlantCount[playerid] == 5) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Watering weed~n~~b~IIIII~r~IIIII"; 
	if(PlantCount[playerid] == 6) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Watering weed~n~~b~IIIIII~r~IIII"; 
	if(PlantCount[playerid] == 7) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Watering weed~n~~b~IIIIIII~r~III"; 
	if(PlantCount[playerid] == 8) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Watering weed~n~~b~IIIIIIII~r~II"; 
    if(PlantCount[playerid] == 9) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Watering weed~n~~b~IIIIIIIII~r~I"; 
    
    Mobile_GameTextForPlayer(playerid, newDisplay, 2200, 3);

	if(Planting{playerid} && PlantCount[playerid] >= 9)
	{
        stop WeedTimer[playerid];
		new id = PlantingID[playerid];

		if (Iter_Contains(Iter_Weed, id)) {

			weedData[id][wWantWater] += 30;
			if (weedData[id][wWantWater] >= 100) {
				weedData[id][wWantWater] = 100;
			}

			new szQuery[256];
			mysql_format(dbCon, szQuery, sizeof(szQuery), "UPDATE `weed` SET `wTimetoGet` = %d, `wWantWater` = %d WHERE `wCreateID`", weedData[id][wTimetoGet], weedData[id][wWantWater], weedData[id][WCreateID]);
			mysql_tquery(dbCon, szQuery); 

			Mobile_GameTextForPlayer(playerid, "~g~Watering Successfully", 1000, 3);
		}
		else {
			Mobile_GameTextForPlayer(playerid, "~r~Watering Failed", 1000, 3);
		}
		ApplyAnimation(playerid, "FAT", "IDLE_tired", 4.0, 0, 0, 0, 0, 0, 1);

        Planting{playerid} = false;
		PlantingID[playerid] = -1;
	}
	return 1;
}


timer PlantWeedTimer[2000](playerid)
{
    new newDisplay[256];
	PlantCount[playerid]++;
	if(PlantCount[playerid] == 1) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Planting weed~n~~b~I~r~IIIIIIIII"; 
	if(PlantCount[playerid] == 2) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Planting weed~n~~b~II~r~IIIIIIII"; 
	if(PlantCount[playerid] == 3) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Planting weed~n~~b~III~r~IIIIIII"; 
	if(PlantCount[playerid] == 4) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Planting weed~n~~b~IIII~r~IIIIII"; 
	if(PlantCount[playerid] == 5) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Planting weed~n~~b~IIIII~r~IIIII"; 
	if(PlantCount[playerid] == 6) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Planting weed~n~~b~IIIIII~r~IIII"; 
	if(PlantCount[playerid] == 7) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Planting weed~n~~b~IIIIIII~r~III"; 
	if(PlantCount[playerid] == 8) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Planting weed~n~~b~IIIIIIII~r~II"; 
    if(PlantCount[playerid] == 9) newDisplay = "~n~~n~~n~~n~~n~~n~~n~~n~~n~Planting weed~n~~b~IIIIIIIII~r~I"; 
    
    Mobile_GameTextForPlayer(playerid, newDisplay, 2200, 3);

	if(Planting{playerid} && PlantCount[playerid] >= 9)
	{
        stop WeedTimer[playerid];
		new id = PlantingID[playerid];
		if (random(5)) {

			weedData[id][wTimetoGet] = random(84600)+random(84600);
			weedData[id][wWantWater] = 100 - random(50);
			format(weedData[id][wOwner], 24, ReturnPlayerName(playerid));

			new sec = weedData[id][wTimetoGet], minutes, hours, days;
			format(newDisplay,sizeof(newDisplay),"เจ้าของ %s\nโตเต็มที่ในอีก: %s\nความชุ่มชื้น %d%", ReturnPlayerName(playerid), ConvertTimeTH(sec, minutes, hours, days), weedData[id][wWantWater]);
			weedData[id][wLabel] = CreateDynamic3DTextLabel(newDisplay , 0x01DF01FF, weedData[id][Xw], weedData[id][Yw], weedData[id][Zw] + 1, 2.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

			if (IsValidDynamicObject(weedData[id][wObject]))
				DestroyDynamicObject(weedData[id][wObject]);

			weedData[id][wObject] = CreateDynamicObject(2241, weedData[id][Xw], weedData[id][Yw], weedData[id][Zw] + 0.2, 0, 0, 0);

			new szQuery[256];
			mysql_format(dbCon, szQuery, sizeof(szQuery), "INSERT INTO `weed` (`Xw`,`Yw`,`Zw`,`wOwner`,`wTimetoGet`,`wWantWater`) VALUES(%f,%f,%f,'%e',%d,%d)", weedData[id][Xw], weedData[id][Yw], weedData[id][Zw], weedData[id][wOwner], weedData[id][wTimetoGet], weedData[id][wWantWater]);
			new Cache:cache = mysql_query(dbCon, szQuery); 
			
			if(cache_affected_rows()) {

				weedData[id][WCreateID] = cache_insert_id();
			}
			else {
				weedData[id][WCreateID] = 0;
				weedData[id][Xw] = 0.0;
				weedData[id][Yw] = 0.0;
				weedData[id][Zw] = 0.0;
				weedData[id][wTimetoGet] = 0;
				weedData[id][wWantWater] = 0;
				
				if(IsValidDynamic3DTextLabel(weedData[id][wLabel]))
					DestroyDynamic3DTextLabel(weedData[id][wLabel]);

				if(IsValidDynamicObject(weedData[id][wObject])) 
					DestroyDynamicObject(weedData[id][wObject]);

				Iter_Remove(Iter_Weed, id);
				SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: ไม่สามารถปลูกได้ โปรดลองใหม่ภายหลัง");
				return 1;
			}
		
			cache_delete(cache);

			Mobile_GameTextForPlayer(playerid, "~g~Planting Successfully", 1000, 3);
		}
		else {
			if (IsValidDynamicObject(weedData[id][wObject]))
				DestroyDynamicObject(weedData[id][wObject]);

			Iter_Remove(Iter_Weed, PlantingID[playerid]);
			Mobile_GameTextForPlayer(playerid, "~r~Planting failure", 1000, 3);
		}
		ApplyAnimation(playerid, "FAT", "IDLE_tired", 4.0, 0, 0, 0, 0, 0, 1);

        Planting{playerid} = false;
		PlantingID[playerid] = -1;
	}
	return 1;
}



CMD:blackmarket(playerid, params[]) {
    if (!IsPlayerInRangeOfPoint(playerid, 2.5, 2256.0554,-2387.9089,17.4219))
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่ตลาดมืด");

    new factiontype = Faction_GetTypeID(playerid);
	if (factiontype == FACTION_TYPE_POLICE) 
        return SendClientMessage(playerid, COLOR_GRAD1, "คุณเป็นเจ้าหน้าที่รัฐ เราไม่สามารถให้คุณเข้าไปได้");

	if (playerData[playerid][pWarrants] > 0)
		return SendClientMessage(playerid, COLOR_GRAD1, "คุณมีคดีความอยู่ ดังนั้นเราไม่สามารถให้คุณเข้าไปได้");

	if (playerData[playerid][pLevel] < 7)
		return SendClientMessage(playerid, COLOR_GRAD1, "คุณมีประสบการณ์ไม่พอที่จะเข้าสู่โลกใต้ดิน (เลเวลตั้งแต่ 7 ขึ้นไปเท่านั้น)");

    Dialog_Show(playerid, BlackMarketDialog, DIALOG_STYLE_LIST, "ตลาดมืด", "เมล็ดกัญชา(x8) $10,000\nบัวรดน้ำ $5,000", "ซื้อ", "ปิด");
    return 1;    
}

Dialog:BlackMarketDialog(playerid, response, listitem, inputtext[]) {
	if (response) {
		switch(listitem) {
			case 0: {
				if (GetPlayerMoney(playerid) < 10000) {
					return SendClientMessage(playerid, COLOR_GRAD1, "คุณมีเงินไม่พอที่จะซื้อ");
				}
				GivePlayerMoneyEx(playerid, -10000);
				playerData[playerid][pSeedWeed]+=8;

				SendClientMessage(playerid, COLOR_GREEN, "คุณได้ซื้อแพคเมล็ดกัญชาจากตลาดมืด");
			}
			case 1: {
				if (GetPlayerMoney(playerid) < 5000) {
					return SendClientMessage(playerid, COLOR_GRAD1, "คุณมีเงินไม่พอที่จะซื้อ");
				}

				if (playerData[playerid][pWatering]) {
					return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมีบัวรดน้ำอยู่แล้ว");
				}
				GivePlayerMoneyEx(playerid, -5000);
				playerData[playerid][pWatering] = true;

				SendClientMessage(playerid, COLOR_GREEN, "คุณได้ซื้อบัวรดน้ำ 1 ชิ้นจากตลาดมืด");
			}
		}
	}
	return 1;
}

ptask ViewWeedTimer[1000](playerid) {
	new szMessage[128];
	foreach(new h : Iter_Weed) if(weedData[h][WCreateID]) {
		if(IsPlayerInRangeOfPoint(playerid, 1.0, weedData[h][Xw], weedData[h][Yw], weedData[h][Zw] + 1.0)) {

			if(weedData[h][wTimetoGet] > 1) {
				new sec = weedData[h][wTimetoGet], minutes, hours, days;
				if(weedData[h][wWantWater] >= 50) {
					format(szMessage,sizeof(szMessage),"~n~~n~~n~~n~~n~~n~~n~~n~~w~Owner: ~y~%s~n~~w~%s~n~~g~Moisture: %d%", weedData[h][wOwner], ConvertTime(sec, minutes, hours, days), weedData[h][wWantWater]);
				}
				else {
					format(szMessage,sizeof(szMessage),"~n~~n~~n~~n~~n~~n~~n~~n~~w~Owner: ~y~%s~n~~w~%s~n~~r~Moisture: %d%", weedData[h][wOwner], ConvertTime(sec, minutes, hours, days), weedData[h][wWantWater]);
				}
				
			}
			else {

				if(weedData[h][wWantWater] >= 50)
				{
					format(szMessage,sizeof(szMessage),"~n~~n~~n~~n~~n~~n~~n~~n~~w~Owner: ~y~%s~g~Moisture %d%", weedData[h][wOwner], weedData[h][wWantWater]);
				}
				else {
					format(szMessage,sizeof(szMessage),"~n~~n~~n~~n~~n~~n~~n~~n~~w~Owner: ~y~%s~r~Moisture %d%", weedData[h][wOwner], weedData[h][wWantWater]);
				}
			
			}
			Mobile_GameTextForPlayer(playerid, szMessage, 1200, 3);
		}
	}
	
}

task WeedGlobalTimer[1000]() {

	new szMessage[256];

	foreach(new h : Iter_Weed) if(weedData[h][WCreateID]) {

		if(weedData[h][wWantWater] > 1)
		{
		    weedData[h][wCount] ++;
		    if(weedData[h][wCount] >= 600)
		    {
				if (weedData[h][wTimetoGet] <= 1) {
					weedData[h][wWantWater] -= 1+random(3);
				}
				weedData[h][wWantWater] -= 1+random(3);
				weedData[h][wCount] = 0;
			}

			if(weedData[h][wTimetoGet] > 1)
			{
				weedData[h][wTimetoGet]-= 1;

				new sec = weedData[h][wTimetoGet], minutes, hours, days;
				format(szMessage,sizeof(szMessage),"เจ้าของ %s\nโตเต็มที่ในอีก %s\nความชุ่มชื้น %d%", weedData[h][wOwner], ConvertTimeTH(sec, minutes, hours, days), weedData[h][wWantWater]);
				
				if(weedData[h][wWantWater] >= 80)
				{
					UpdateDynamic3DTextLabelText(weedData[h][wLabel], 0x2EFE2EFF, szMessage);
				}
				else if(weedData[h][wWantWater] >= 60)
				{
					UpdateDynamic3DTextLabelText(weedData[h][wLabel], 0xF7FE2EFF, szMessage);
				}
				else if(weedData[h][wWantWater] >= 40)
				{
					UpdateDynamic3DTextLabelText(weedData[h][wLabel], 0xFE9A2EFF, szMessage);
				}
				else UpdateDynamic3DTextLabelText(weedData[h][wLabel], 0xFE2E2EFF, szMessage);

				if(weedData[h][wTimetoGet] <= 1) {
					if(IsValidDynamicObject(weedData[h][wObject])) {
						DestroyDynamicObject(weedData[h][wObject]);
					}
					weedData[h][wObject] = CreateDynamicObject(3409, weedData[h][Xw], weedData[h][Yw], weedData[h][Zw] - 0.2, 0, 0, 0);
						
					new szQuery[256];
					mysql_format(dbCon, szQuery, sizeof(szQuery), "UPDATE `weed` SET `wTimetoGet` = %d, `wWantWater` = %d WHERE `wCreateID`", weedData[h][wTimetoGet], weedData[h][wWantWater], weedData[h][WCreateID]);
					mysql_tquery(dbCon, szQuery); 
				}
			}
			else
			{
				format(szMessage,sizeof(szMessage),"เจ้าของ %s\nความชุ่มชื้น %d%", weedData[h][wOwner], weedData[h][wWantWater]);
				
				if(weedData[h][wWantWater] >= 80)
				{
					UpdateDynamic3DTextLabelText(weedData[h][wLabel], 0x2ECCFAFF, szMessage);
				}
				else if(weedData[h][wWantWater] >= 60)
				{
					UpdateDynamic3DTextLabelText(weedData[h][wLabel], 0x01A9DBFF, szMessage);
				}
				else if(weedData[h][wWantWater] >= 40)
				{
					UpdateDynamic3DTextLabelText(weedData[h][wLabel], 0x086A87FF, szMessage);
				}
				else UpdateDynamic3DTextLabelText(weedData[h][wLabel], 0x0B2F3AFF, szMessage);
			}
		}
		else if(weedData[h][wWantWater] <= 0)
		{
			new 
				current_weed_loop = h;

			format(szMessage, sizeof(szMessage), "DELETE FROM `weed` WHERE `WCreateID` = %d", weedData[h][WCreateID]);
			mysql_query(dbCon,szMessage);
		
			weedData[h][WCreateID] = 0;
			weedData[h][Xw] = 0.0;
			weedData[h][Yw] = 0.0;
			weedData[h][Zw] = 0.0;
			weedData[h][wTimetoGet] = 0;
			weedData[h][wWantWater] = 0;
			
			if(IsValidDynamic3DTextLabel(weedData[h][wLabel]))
				DestroyDynamic3DTextLabel(weedData[h][wLabel]);

			if(IsValidDynamicObject(weedData[h][wObject])) 
				DestroyDynamicObject(weedData[h][wObject]);

			Iter_SafeRemove(Iter_Weed, current_weed_loop, h);
		}
	}
	return 1;
}


forward OnHarvestWeed(playerid, slot, drugid, Float:transfer_amount, strength, packageid);
public OnHarvestWeed(playerid, slot, drugid, Float:transfer_amount, strength, packageid)
{
	if(PlayerDrug[playerid][slot][drugQTY] == 0) {
		PlayerDrug[playerid][slot][drugID] = cache_insert_id(); // MYSQL NUMBER
		PlayerDrug[playerid][slot][drugType] = drugid;
		PlayerDrug[playerid][slot][drugQTY] = transfer_amount;
		PlayerDrug[playerid][slot][drugStrength] = strength;
		PlayerDrug[playerid][slot][drugPackage] = packageid;
		
		SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้รับ %s จำนวน %.1fg ใส่ไว้ในแพ็กเกจ %s", DrugData[PlayerDrug[playerid][slot][drugType]][DRUGDATA_NAME], transfer_amount, DrugPackageName[PlayerDrug[playerid][slot][drugPackage]]);	
	}
}

SaveAllWeed() {
	new szQuery[256];
	foreach(new id : Iter_Weed) if(weedData[id][WCreateID])
	{
		mysql_format(dbCon, szQuery, sizeof(szQuery), "UPDATE `weed` SET `wTimetoGet` = %d, `wWantWater` = %d WHERE `wCreateID`", weedData[id][wTimetoGet], weedData[id][wWantWater], weedData[id][WCreateID]);
		mysql_tquery(dbCon, szQuery); 
	}
}