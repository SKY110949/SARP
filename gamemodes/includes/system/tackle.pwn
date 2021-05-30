#include <YSI\y_hooks>

CMD:tackle(playerid, params[]) {
	
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);

	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่ตำรวจเท่านั้น !");
	
	if(GetPVarType(playerid, "TacklingMode")) {
		SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ปิดโหมดการเข้าปะทะ !");
		DeletePVar(playerid, "TacklingMode");
	}
	else {
		SendClientMessage(playerid, COLOR_YELLOW, "คุณได้เปิดโหมดการเข้าปะทะ !");
		SendClientMessage(playerid, COLOR_YELLOW, "เมื่อคุณพยายามที่จะชกใครสักคน มันจะเป็นการเข้าปะทะคน ๆ นั้นแทน");
		SendClientMessage(playerid, COLOR_YELLOW, "ผู้เล่นที่คุณชกจะได้รับข้อความ แสดงให้เห็นการพยายามที่จะเข้าปะทะนี้จากคุณ");
		/*SendClientMessage(playerid, COLOR_LIGHTRED, "อารมณ์จะถูกส่งไปยังแชทผู้เล่นอื่นเพื่อแจ้งเตือนเกี่ยวกับการพยายาม");
		SendClientMessage(playerid, COLOR_LIGHTRED, "คุณจะถูกบังคับให้เล่นอนิเมชั่นกระโดดน้ำเพื่อป้องกันการพิมพ์คำสั่งผิดพลาด");
		SendClientMessage(playerid, COLOR_LIGHTRED, "หากผู้เล่นนั้นไม่เล่นบทการเข้าปะทะ รายงานภายในเกมได้เลย");*/
		SetPVarInt(playerid, "TacklingMode", 1);
	}
	return 1;
}

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{

	if(issuerid != INVALID_PLAYER_ID)
	{
		if(GetPVarType(issuerid, "TacklingMode") && weaponid == 0) {
			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s วิ่งไปที่ %s และพยายามที่จะเข้าปะทะให้ลงไปนอนกับพื้น", ReturnPlayerName(issuerid), ReturnPlayerName(playerid));
			ApplyAnimation(issuerid, "PED", "EV_dive",4.1,0,1,1,1,0);
			ApplyAnimation(playerid, "PED", "FLOOR_hit_f",4.1,0,1,1,1,0);
			playerData[playerid][pAnimation] = 1;
			playerData[issuerid][pAnimation] = 1;
			return 0;
		}
    }
	return 1;
}

stock IsKeyJustDown(key, newkeys, oldkeys)
{
	#pragma unused oldkeys

	return (newkeys & key);
}

stock GetDistancePlayerVeh(playerid, veh) {

	new
	    Float:Floats[7];

	GetPlayerPos(playerid, Floats[0], Floats[1], Floats[2]);
	GetVehiclePos(veh, Floats[3], Floats[4], Floats[5]);
	Floats[6] = floatsqroot((Floats[3]-Floats[0])*(Floats[3]-Floats[0])+(Floats[4]-Floats[1])*(Floats[4]-Floats[1])+(Floats[5]-Floats[2])*(Floats[5]-Floats[2]));

	return floatround(Floats[6]);
}

stock doesVehicleExist(vehicleid) {

    if(GetVehicleModel(vehicleid) >= 400) {
		return 1;
	}
	return 0;
}

stock GetClosestVehicle(playerid, exception = INVALID_VEHICLE_ID) {
    new
		Float:Distance,
		target = -1;

    for(new v; v < MAX_VEHICLES; v++) if(doesVehicleExist(v)) {
        if(v != exception && (target < 0 || Distance > GetDistancePlayerVeh(playerid, v))) {
            target = v;
            Distance = GetDistancePlayerVeh(playerid, v);
        }
    }
    return target;
}

stock IsPlayerInRangeOfPlayer(playerid, playerid2, Float: radius) {

	new
		Float:Floats[3];

	GetPlayerPos(playerid2, Floats[0], Floats[1], Floats[2]);
	return IsPlayerInRangeOfPoint(playerid, radius, Floats[0], Floats[1], Floats[2]);
}

stock checkVehicleSeat(vehicleid, seatid) {
	foreach (new x : Player) {
	    if(GetPlayerVehicleID(x) == vehicleid && GetPlayerVehicleSeat(x) == seatid) return 1;
	}
	return 0;
}

stock IsAPlane(vehicleid) {
	switch(GetVehicleModel(vehicleid)) {
		case 592, 577, 511, 512, 593, 520, 553, 476, 519, 460, 513, 548, 425, 417, 487, 488, 497, 563, 447, 469: return 1;
	}
	return 0;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(IsKeyJustDown(KEY_SUBMISSION, newkeys, oldkeys)) {
	    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 525 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 531) { // For impounding cars.

	        new
				playerTowTruck = GetPlayerVehicleID(playerid);

	        if(!IsTrailerAttachedToVehicle(playerTowTruck)) {
				new
					targetVehicle = GetClosestVehicle(playerid, playerTowTruck); // Exempt the player's own vehicle from the loop.

				if(!IsAPlane(targetVehicle) && IsPlayerInRangeOfVehicle(playerid, targetVehicle, 10.0)) {
					AttachTrailerToVehicle(targetVehicle, playerTowTruck);
				}
	        }
	        else DetachTrailerFromVehicle(playerTowTruck);
	    }
	}
}