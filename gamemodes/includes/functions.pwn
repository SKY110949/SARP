//--------------------------------[FUNCTIONS.PWN]--------------------------------

/*
	- Vehicle Function
	- Weapon Function
	- Player Function
	- MATH
	- DATE/TIME
	- Message
	- Regex
	- Main
*/

new safetybelt[MAX_PLAYERS];

RemoveFromVehicle(playerid)
{
	if (IsPlayerInAnyVehicle(playerid))
	{
		new
		    Float:fX,
	    	Float:fY,
	    	Float:fZ;

		GetPlayerPos(playerid, fX, fY, fZ);
		SetPlayerPos(playerid, fX, fY, fZ + 1.5);
	}
	return 1;
}

//=========================== [ Vehicle Function ] ========================

GetAvailableSeat(vehicleid, start = 1)
{
	new seats = GetVehicleMaxSeats(vehicleid);

	for (new i = start; i < seats; i ++) if (!IsVehicleSeatUsed(vehicleid, i)) {
	    return i;
	}
	return -1;
}

GetVehicleMaxSeats(vehicleid)
{
    new const g_arrMaxSeats[] = {
		4, 2, 2, 2, 4, 4, 1, 2, 2, 4, 2, 2, 2, 4, 2, 2, 4, 2, 4, 2, 4, 4, 2, 2, 2, 1, 4, 4, 4, 2,
		1, 7, 1, 2, 2, 0, 2, 7, 4, 2, 4, 1, 2, 2, 2, 4, 1, 2, 1, 0, 0, 2, 1, 1, 1, 2, 2, 2, 4, 4,
		2, 2, 2, 2, 1, 1, 4, 4, 2, 2, 4, 2, 1, 1, 2, 2, 1, 2, 2, 4, 2, 1, 4, 3, 1, 1, 1, 4, 2, 2,
		4, 2, 4, 1, 2, 2, 2, 4, 4, 2, 2, 1, 2, 2, 2, 2, 2, 4, 2, 1, 1, 2, 1, 1, 2, 2, 4, 2, 2, 1,
		1, 2, 2, 2, 2, 2, 2, 2, 2, 4, 1, 1, 1, 2, 2, 2, 2, 7, 7, 1, 4, 2, 2, 2, 2, 2, 4, 4, 2, 2,
		4, 4, 2, 1, 2, 2, 2, 2, 2, 2, 4, 4, 2, 2, 1, 2, 4, 4, 1, 0, 0, 1, 1, 2, 1, 2, 2, 1, 2, 4,
		4, 2, 4, 1, 0, 4, 2, 2, 2, 2, 0, 0, 7, 2, 2, 1, 4, 4, 4, 2, 2, 2, 2, 2, 4, 2, 0, 0, 0, 4,
		0, 0
	};
	new
	    model = GetVehicleModel(vehicleid);

	if (400 <= model <= 611)
	    return g_arrMaxSeats[model - 400];

	return 0;
}

IsVehicleSeatUsed(vehicleid, seat)
{
	foreach (new i : Player) if (IsPlayerInVehicle(i, vehicleid) && GetPlayerVehicleSeat(i) == seat) {
	    return 1;
	}
	return 0;
}

IsPlayerInRangeOfVehicle(playerid, vehicleid, Float: radius) {

	new
		Float:Floats[3];

	GetVehiclePos(vehicleid, Floats[0], Floats[1], Floats[2]);
	return IsPlayerInRangeOfPoint(playerid, radius, Floats[0], Floats[1], Floats[2]);
}

GetVehicleBoot(vehicleid, &Float:x, &Float:y, &Float:z)
{
	if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;

	new
	    Float:pos[7]
	;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
	GetVehicleZAngle(vehicleid, pos[6]);

	x = pos[3] - (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
	y = pos[4] - (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
 	z = pos[5];

	return 1;
}

IsPlayerNearBoot(playerid, vehicleid, Float:dist = 1.5)
{
	new
		Float:fX,
		Float:fY,
		Float:fZ;

	GetVehicleBoot(vehicleid, fX, fY, fZ);

	return (GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehicleid)) && IsPlayerInRangeOfPoint(playerid, dist, fX, fY, fZ);
}

IsNearBoatID(playerid)
{
    if(IsPlayerConnected(playerid))
    {
		for(new c=0;c<MAX_VEHICLES;c++)
		{
			switch (GetVehicleModel(c)) {
				case 430, 446, 452, 453, 454, 472, 473, 484, 493, 595:
				{
				    if(IsPlayerInRangeOfVehicle(playerid, c, 7.0)) return c;
				}
			}
		}
	}
	return -1;
}

forward PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z);
public PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
	new Float:oldposx, Float:oldposy, Float:oldposz;
	new Float:tempposx, Float:tempposy, Float:tempposz;
	GetPlayerPos(playerid, oldposx, oldposy, oldposz);
	tempposx = (oldposx -x);
	tempposy = (oldposy -y);
	tempposz = (oldposz -z);
	if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
	{
		return 1;
	}
	return 0;
}

GetVehicleDriverDoor(vehicleid, &Float:x, &Float:y, &Float:z)
{
	if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;

	new
	    Float:pos[7]
	;

	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
	GetVehicleZAngle(vehicleid, pos[6]);

	switch(GetVehicleModel(vehicleid))
	{
	    case 431, 407, 408, 437:
	    {
		 	x = pos[3] + ((floatsqroot(pos[1] + pos[1])/(floatsqroot(pos[1]))*floatsqroot(pos[1] + pos[1])/(pos[1]/floatsqroot(pos[1]))) * floatsin(-pos[6]+315.0+floatsqroot(pos[1] + pos[1]), degrees));
			y = pos[4] + ((floatsqroot(pos[1] + pos[1])/(floatsqroot(pos[1]))*floatsqroot(pos[1] + pos[1])/(pos[1]/floatsqroot(pos[1]))) * floatcos(-pos[6]+315.0+floatsqroot(pos[1] + pos[1]), degrees));
	    }
	    default:
	    {
			x = pos[3] + ((floatsqroot(pos[1] + pos[1])/(floatsqroot(pos[1]))*floatsqroot(pos[1] + pos[1])/(pos[1]/floatsqroot(pos[0]))) * floatsin(-pos[6]+300.0+floatsqroot(pos[1] + pos[1]), degrees));
			y = pos[4] + ((floatsqroot(pos[1] + pos[1])/(floatsqroot(pos[1]))*floatsqroot(pos[1] + pos[1])/(pos[1]/floatsqroot(pos[0]))) * floatcos(-pos[6]+300.0+floatsqroot(pos[1] + pos[1]), degrees));
	    }
	}

	z = pos[5];

	return 1;
}

IsPlayerNearDriverDoor(playerid, vehicleid)
{
	new
		Float:fX,
		Float:fY,
		Float:fZ;

	GetVehicleDriverDoor(vehicleid, fX, fY, fZ);

	return (GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehicleid)) && IsPlayerInRangeOfPoint(playerid, 2.0, fX, fY, fZ);
}
GetVehicleDriver(vehicleid) {
	foreach (new i : Player) {
		if (GetPlayerState(i) == PLAYER_STATE_DRIVER && GetPlayerVehicleID(i) == vehicleid) return i;
	}
	return INVALID_PLAYER_ID;
}

Float:GetVehicleSpeed(vehicleid, UseMPH = 0)
{
    new Float:speed_x,Float:speed_y,Float:speed_z,Float:temp_speed;
    GetVehicleVelocity(vehicleid,speed_x,speed_y,speed_z);
    if(UseMPH == 0) temp_speed = floatsqroot(((speed_x*speed_x)+(speed_y*speed_y))+(speed_z*speed_z))*136.666667;
    else temp_speed = floatsqroot(((speed_x*speed_x)+(speed_y*speed_y))+(speed_z*speed_z))*85.4166672;
    floatround(temp_speed,floatround_round);
    return temp_speed;
}

Vehicle_Nearest(playerid, Float: dist = 6.0)
{
	new
	    Float:fDistance = FLOAT_INFINITY,
	    Float:fX,
	    Float:fY,
	    Float:fZ,
	    iIndex = -1
	;
	for(new i=0;i!=MAX_VEHICLES;i++) {

	    GetVehiclePos(i, fX, fY, fZ);

		new
        	Float:temp = GetPlayerDistanceFromPoint(playerid, fX, fY, fZ);

		if (temp < fDistance && temp < dist)
		{
		    fDistance = temp;
		    iIndex = i;
		}
	}
	return iIndex;
}

Vehicle_Near(playerid, Float: dist = 6.0)
{
	new
	    Float:fX,
	    Float:fY,
	    Float:fZ,
	    iIndex = -1
	;
	for(new i=0;i!=MAX_VEHICLES;i++) {

	    GetVehiclePos(i, fX, fY, fZ);
		
		if (IsPlayerInRangeOfPoint(playerid, dist, fX, fY, fZ)) {
			iIndex = i;
			break;
		}
/*
		new
        	Float:temp = GetPlayerDistanceFromPoint(playerid, fX, fY, fZ);

		if (temp < fDistance && temp < dist)
		{
		    fDistance = temp;
		    iIndex = i;
		}*/
	}
	return iIndex;
}

GetLightStatus(vehicleid)
{
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if (lights != 1)
		return 0;

	return 1;
}

SetLightStatus(vehicleid, bool:status)
{
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, engine, status, alarm, doors, bonnet, boot, objective);
}

forward GetEngineStatus(vehicleid);
public GetEngineStatus(vehicleid)
{
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if (engine != 1)
		return false;

	return true;
}

SetEngineStatus(vehicleid, bool:status)
{
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, status, lights, alarm, doors, bonnet, boot, objective);
}

IsEngineVehicle(vehicleid)
{
	static const g_aEngineStatus[] = {
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0
	};
    new modelid = GetVehicleModel(vehicleid);

    if (modelid < 400 || modelid > 611)
        return 0;

    return (g_aEngineStatus[modelid - 400]);
}

forward SetLockStatus(vehicleid, bool:status);
public SetLockStatus(vehicleid, bool:status) {
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	vehicleData[vehicleid][vlocked] = status;

	return SetVehicleParamsEx(vehicleid, engine, lights, alarm, status, bonnet, boot, objective);
}

forward GetLockStatus(vehicleid);
public GetLockStatus(vehicleid)
{
/*	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if (doors != 1)
		return 0;
*/
	return vehicleData[vehicleid][vlocked];
}

ReturnVehicleModelName(model)
{
	new
	    name[32] = "None";

    if (model < 400 || model > 611)
	    return name;

	format(name, sizeof(name), g_arrVehicleNames[model - 400]);
	return name;
}

GetVehicleModelByName(const name[])
{
	if (IsNumeric(name) && (strval(name) >= 400 && strval(name) <= 611))
	    return strval(name);

	for (new i = 0; i < sizeof(g_arrVehicleNames); i ++)
	{
	    if (strfind(g_arrVehicleNames[i], name, true) != -1)
	    {
	        return i + 400;
		}
	}
	return 0;
}

IsABike(modelid)
{
	switch(modelid) {
		case 481, 509, 510: return true;
	}
	return false;
}

IsABoat(modelid)
{
	switch(modelid) {
		case 430, 446, 452, 453, 454, 472, 473, 484, 493, 595: return true;
	}
	return false;
}

IsAPlaneModel(model)
{
	switch (model) {
		case 417, 425, 447, 460, 469, 476, 487, 488, 497, 511..513, 519, 520, 548, 553, 563, 577, 592, 593: return true;
	}
	return false;
}

GetVehicleHood(vehicleid, &Float:x, &Float:y, &Float:z)
{
    if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;

	new
	    Float:pos[7]
	;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
	GetVehicleZAngle(vehicleid, pos[6]);

	x = pos[3] + (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
	y = pos[4] + (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
 	z = pos[5];

	return 1;
}
//=========================== [ Weapon Function ] ========================
/*
IsBulletWeapon(weaponid)
{
	return (WEAPON_COLT45 <= weaponid <= WEAPON_SNIPER) || weaponid == WEAPON_MINIGUN;
}

IsMeleeWeapon(weaponid)
{
	return (WEAPON_UNARMED <= weaponid <= WEAPON_KATANA) || (WEAPON_DILDO <= weaponid <= WEAPON_CANE) || weaponid == WEAPON_PISTOLWHIP;
}*/

ReturnWeaponNameEx(weaponid)
{
	new
		name[24];
		
	switch(weaponid) {
		case 0: name = "Punch";
		case 30: name = "AK-47";
		default: {
			GetWeaponName(weaponid, name, sizeof(name));	
		}
	}
	return name;
}

//=========================== [ Player Function ] ========================

stock DoesPlayerExist(name[])
{
	new checkQuery[128];
	
	mysql_format(dbCon, checkQuery, sizeof(checkQuery), "SELECT Name FROM players WHERE Name = '%e'", name); 
	new Cache:cache = mysql_query(dbCon, checkQuery); 
	
	if(cache_num_rows())
	{
		cache_delete(cache); 
		return 1; 
	}
	
	cache_delete(cache);
	return 0;	
}


stock ReturnDBIDFromName(name[])
{
	new checkQuery[128], dbid;
	
	mysql_format(dbCon, checkQuery, sizeof(checkQuery), "SELECT id FROM players WHERE Name = '%e'", name);
	new Cache:cache = mysql_query(dbCon, checkQuery); 
	
	
	if(!cache_num_rows())
	{
		cache_delete(cache);
		return 0;
	}
	
	cache_get_value_name_int(0, "id", 	dbid); 
	cache_delete(cache);
	return dbid; 
}

ReturnIP(playerid)
{
	new
		ipAddress[20];

	GetPlayerIp(playerid, ipAddress, sizeof(ipAddress));
	return ipAddress; 
}

IsCharacterOnline(character)//Returns user ID
{
	if (!character) return -1;

	foreach(new i : Player)
	{
		if(playerData[i][pSID] == character)
		{
	    	return i;
	 	}
	}
	return -1;
}

IsInLowRider(playerid) {
	new pveh = GetPlayerVehicleID(playerid);
	switch(GetVehicleModel(pveh)) {
		case 536, 575, 567: return 1;
	}
	return 0;
}

SetPlayerFacePlayer(playerid, giveplayerid) {
    new
        Float: pX,
        Float: pY,
        Float: pZ,
        Float: gX,
        Float: gY,
        Float: gZ
    ;
    if(GetPlayerPos(playerid, pX, pY, pZ) && GetPlayerPos(giveplayerid, gX, gY, gZ)) {
        SetPlayerFacingAngle(playerid, (pX = -atan2((gX - pX), (gY - pY))));
        return SetPlayerFacingAngle(giveplayerid, (pX + 180.0));
    }
    return false;
}

Donate_GetName(rank) {
	new drank[20];
	switch(rank) {
		case 1: drank = "รุกกี้";
		case 2: drank = "ดาวเด่น";
		case 3: drank = "หอแห่งเกียรติยศ";
		default: drank = "สะเก็ดดาว";
	}
	return drank;
}

PlayerPlayMusic(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		defer StopMusic(playerid);
		PlayerPlaySound(playerid, 1068, 0.0, 0.0, 0.0);
	}
}

timer StopMusic[5000](playerid)
{
	if(IsPlayerConnected(playerid))
	{
		PlayerPlaySound(playerid, 1069, 0.0, 0.0, 0.0);
	}
}

ReturnRealName(playerid)
{
    new pname[MAX_PLAYER_NAME];
    GetPlayerName(playerid, pname, MAX_PLAYER_NAME);

    if(BitFlag_Get(gPlayerBitFlag[playerid], IS_MASKED)) {
 	    new mname[30];
	    GetPVarString(playerid, "MaskedName", mname, sizeof mname);
        format(pname, sizeof(pname), "[Mask %s]", mname);
    }
    else {
    	for (new i = 0, len = strlen(pname); i < len; i ++) if (pname[i] == '_') pname[i] = ' ';
    }
    return pname;
}

GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance = 5.0)
{
	// Created by Y_Less

	new Float:a;

	GetPlayerPos(playerid, x, y, a);

	if (GetPlayerVehicleID(playerid)) {
	    GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}
	else GetPlayerFacingAngle(playerid, a);

	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}

Float:AngleBetweenPoints(Float:x1, Float:y1, Float:x2, Float:y2)
{
	return -(90.0 - atan2(y1 - y2, x1 - x2));
}

IsPlayerBehindPlayer(playerid, targetid, Float:diff = 90.0)
{
	new Float:x1, Float:y1, Float:z1;
	new Float:x2, Float:y2, Float:z2;
	new Float:ang, Float:angdiff;

	GetPlayerPos(playerid, x1, y1, z1);
	GetPlayerPos(targetid, x2, y2, z2);
	GetPlayerFacingAngle(targetid, ang);

	angdiff = AngleBetweenPoints(x1, y1, x2, y2);

	if (angdiff < 0.0) angdiff += 360.0;
	if (angdiff > 360.0) angdiff -= 360.0;

	ang = ang - angdiff;

	if (ang > 180.0) ang -= 360.0;
	if (ang < -180.0) ang += 360.0;

	return floatabs(ang) > diff;
}

MakePlayerFacePlayer(playerid, targetid, opposite = false)
{
	new Float:x1, Float:y1, Float:z1;
	new Float:x2, Float:y2, Float:z2;

	GetPlayerPos(playerid, x1, y1, z1);
	GetPlayerPos(targetid, x2, y2, z2);
	new Float:angle = AngleBetweenPoints(x2, y2, x1, y1);

	if (opposite) {
		angle += 180.0;
		if (angle > 360.0) angle -= 360.0;
	}

	if (angle < 0.0) angle += 360.0;
	if (angle > 360.0) angle -= 360.0;

	SetPlayerFacingAngle(playerid, angle);
}

IsPlayerNearPlayer(playerid, targetid, Float:radius)
{
	static
		Float:fX,
		Float:fY,
		Float:fZ;

	GetPlayerPos(targetid, fX, fY, fZ);

	return (GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid) && playerData[targetid][pSpectating] == INVALID_PLAYER_ID) && IsPlayerInRangeOfPoint(playerid, radius, fX, fY, fZ);
}

ChatAnimation(playerid, length)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !playingAnimation{playerid})
	{
		if(playerData[playerid][pAnimation] || gIsDeathMode{playerid} || gIsInjuredMode{playerid} || IsPlayerInAnyVehicle(playerid) || GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_NONE) return 1;

		new chatstyle = playerData[playerid][pTalkStyle];
		playingAnimation{playerid}=true;
		if(chatstyle == 0) { ApplyAnimation(playerid,"PED","IDLE_CHAT",4.1,1,0,0,1,1); }
		else if(chatstyle == 1) { ApplyAnimation(playerid,"GANGS","prtial_gngtlkA",4.1,1,0,0,1,1); }
		else if(chatstyle == 2) { ApplyAnimation(playerid,"GANGS","prtial_gngtlkB",4.1,1,0,0,1,1); }
		else if(chatstyle == 3) { ApplyAnimation(playerid,"GANGS","prtial_gngtlkC",4.1,1,0,0,1,1);}
		else if(chatstyle == 4) { ApplyAnimation(playerid,"GANGS","prtial_gngtlkD",4.1,1,0,0,1,1);}
		else if(chatstyle == 5) { ApplyAnimation(playerid,"GANGS","prtial_gngtlkE",4.1,1,0,0,1,1);}
		else if(chatstyle == 6) { ApplyAnimation(playerid,"GANGS","prtial_gngtlkF",4.1,1,0,0,1,1);}
		else if(chatstyle == 7) { ApplyAnimation(playerid,"GANGS","prtial_gngtlkG",4.1,1,0,0,1,1);}
		else if(chatstyle == 8) { ApplyAnimation(playerid,"GANGS","prtial_gngtlkH",4.1,1,0,0,1,1);}
		SetTimerEx("StopChatting", floatround(length)*100, 0, "i", playerid);
	}
	return 1;
}

stock SetPlayerLookAt(playerid, Float:X, Float:Y)
{
    new Float:Px, Float:Py, Float: Pa;
    GetPlayerPos(playerid, Px, Py, Pa);
    Pa = floatabs(atan((Y-Py)/(X-Px)));
    if (X <= Px && Y >= Py) Pa = floatsub(180, Pa);
    else if (X < Px && Y < Py) Pa = floatadd(Pa, 180);
    else if (X >= Px && Y <= Py) Pa = floatsub(360.0, Pa);
    Pa = floatsub(Pa, 90.0);
    if (Pa >= 360.0) Pa = floatsub(Pa, 360.0);
    SetPlayerFacingAngle(playerid, Pa);
}

ProxDetectorOOC(playerid, Float:radius, const str[])
{
	new Float:posx, Float:posy, Float:posz;
	new Float:oldposx, Float:oldposy, Float:oldposz;
	new Float:tempposx, Float:tempposy, Float:tempposz;

	GetPlayerPos(playerid, oldposx, oldposy, oldposz);

	foreach (new i : Player)
	{
		if(GetPlayerInterior(playerid) == GetPlayerInterior(i) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i) && !BitFlag_Get(gPlayerBitFlag[i], TOGGLE_OOC))
		{
			GetPlayerPos(i, posx, posy, posz);
			tempposx = (oldposx -posx);
			tempposy = (oldposy -posy);
			tempposz = (oldposz -posz);

			if (((tempposx < radius/16) && (tempposx > -radius/16)) && ((tempposy < radius/16) && (tempposy > -radius/16)) && ((tempposz < radius/16) && (tempposz > -radius/16)))
			{
				SendClientMessage(i, COLOR_FADE1, str);
			}
			else if (((tempposx < radius/8) && (tempposx > -radius/8)) && ((tempposy < radius/8) && (tempposy > -radius/8)) && ((tempposz < radius/8) && (tempposz > -radius/8)))
			{
				SendClientMessage(i, COLOR_FADE2, str);
			}
			else if (((tempposx < radius/4) && (tempposx > -radius/4)) && ((tempposy < radius/4) && (tempposy > -radius/4)) && ((tempposz < radius/4) && (tempposz > -radius/4)))
			{
				SendClientMessage(i, COLOR_FADE3, str);
			}
			else if (((tempposx < radius/2) && (tempposx > -radius/2)) && ((tempposy < radius/2) && (tempposy > -radius/2)) && ((tempposz < radius/2) && (tempposz > -radius/2)))
			{
				SendClientMessage(i, COLOR_FADE4, str);
			}
			else if (((tempposx < radius) && (tempposx > -radius)) && ((tempposy < radius) && (tempposy > -radius)) && ((tempposz < radius) && (tempposz > -radius)))
			{
				SendClientMessage(i, COLOR_FADE5, str);
			}
		}
	}
	return 1;
}

ProxDetector(playerid, Float:radius, const str[])
{
	new Float:posx, Float:posy, Float:posz;
	new Float:oldposx, Float:oldposy, Float:oldposz;
	new Float:tempposx, Float:tempposy, Float:tempposz;

	GetPlayerPos(playerid, oldposx, oldposy, oldposz);

	foreach (new i : Player)
	{
		if(GetPlayerInterior(playerid) == GetPlayerInterior(i) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
		{
			GetPlayerPos(i, posx, posy, posz);
			tempposx = (oldposx -posx);
			tempposy = (oldposy -posy);
			tempposz = (oldposz -posz);

			if (((tempposx < radius/16) && (tempposx > -radius/16)) && ((tempposy < radius/16) && (tempposy > -radius/16)) && ((tempposz < radius/16) && (tempposz > -radius/16)))
			{
				SendClientMessage(i, COLOR_GRAD1, str);
			}
			else if (((tempposx < radius/8) && (tempposx > -radius/8)) && ((tempposy < radius/8) && (tempposy > -radius/8)) && ((tempposz < radius/8) && (tempposz > -radius/8)))
			{
				SendClientMessage(i, COLOR_GRAD2, str);
			}
			else if (((tempposx < radius/4) && (tempposx > -radius/4)) && ((tempposy < radius/4) && (tempposy > -radius/4)) && ((tempposz < radius/4) && (tempposz > -radius/4)))
			{
				SendClientMessage(i, COLOR_GRAD3, str);
			}
			else if (((tempposx < radius/2) && (tempposx > -radius/2)) && ((tempposy < radius/2) && (tempposy > -radius/2)) && ((tempposz < radius/2) && (tempposz > -radius/2)))
			{
				SendClientMessage(i, COLOR_GRAD4, str);
			}
			else if (((tempposx < radius) && (tempposx > -radius)) && ((tempposy < radius) && (tempposy > -radius)) && ((tempposz < radius) && (tempposz > -radius)))
			{
				SendClientMessage(i, COLOR_GRAD5, str);
			}
		}
	}
	return 1;
}

forward StopChatting(playerid);
public StopChatting(playerid) ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0), playingAnimation{playerid}=false;


GetPlayerLocation(playerid)
{
	new
	    Float:fX,
	    Float:fY,
		Float:fZ;

    GetDynamicPlayerPos(playerid, fX, fY, fZ);

	new zones[MAX_ZONE_NAME];
	strcat(zones, GetCoordsZone(fX, fY));

	return zones;
}

GetBodyPartName(bodypart)
{
	new part[11];
	switch(bodypart)
	{
		case BODY_PART_TORSO: part = "ลำตัว";
		case BODY_PART_GROIN: part = "ขาหนีบ";
		case BODY_PART_LEFT_ARM: part = "แขนซ้าย";
		case BODY_PART_RIGHT_ARM: part = "แขนขวา";
		case BODY_PART_LEFT_LEG: part = "ขาซ้าย";
		case BODY_PART_RIGHT_LEG: part = "ขาขวา";
		case BODY_PART_HEAD: part = "หัว";
		default: part = "ไม่ทราบ";
	}
	return part;
}

GetDynamicPlayerPos(playerid, &Float:x, &Float:y, &Float:z)
{
	new world = GetPlayerVirtualWorld(playerid);
	if(world == 0)
	{
	    GetPlayerPos(playerid, x, y, z);
	}
	else
	{
		/* House & Business, HQ Faction... */
		if (world >= 2000 && world < 4000 && Entrance_DynamicPos(world,x,y,z) != -1) { }
		else if (world >= 4000 && House_DynamicPos(playerid,world,x,y,z) != -1) { }
		else if (world >= 10000 && Business_DynamicPos(playerid,world,x,y,z) != -1) { }
		else GetPlayerPos(playerid, x, y, z);
	}
	return 1;
}

IsBulletWeapon(weaponid)
{
	return (WEAPON_COLT45 <= weaponid <= WEAPON_SNIPER) || weaponid == WEAPON_MINIGUN;
}

IsMeleeWeapon(weaponid)
{
	return (WEAPON_UNARMED <= weaponid <= WEAPON_KATANA) || (WEAPON_DILDO <= weaponid <= WEAPON_CANE) || weaponid == WEAPON_PISTOLWHIP;
}

SetPlayerWeaponSkill(playerid, skill) {
	switch(skill) {
	    case NORMAL_SKILL: {
            for(new i = 0; i != 11;++i) SetPlayerSkillLevel(playerid, i, 200);
            SetPlayerSkillLevel(playerid, 0, 40);
            SetPlayerSkillLevel(playerid, 6, 50);
	    }
	    case MEDIUM_SKILL: {
            for(new i = 0; i != 11;++i) SetPlayerSkillLevel(playerid, i, 500);
            SetPlayerSkillLevel(playerid, 0, 500);
            SetPlayerSkillLevel(playerid, 6, 500);
	    }
	    case FULL_SKILL: {
            for(new i = 0; i != 11;++i) SetPlayerSkillLevel(playerid, i, 999);
            SetPlayerSkillLevel(playerid, 0, 998);
            SetPlayerSkillLevel(playerid, 6, 998);
	    }
	}
}

//================================= [ MATH ] =============================

IsNumeric(const str[])
{
	for (new i = 0, l = strlen(str); i != l; i ++)
	{
	    if (i == 0 && str[0] == '-')
			continue;

	    else if (str[i] < '0' || str[i] > '9')
			return 0;
	}
	return 1;
}

Float:GetPointDistanceToPoint(Float:x1,Float:y1,Float:x2,Float:y2)
{
  new Float:x, Float:y;
  x = x1-x2;
  y = y1-y2;
  return floatsqroot(x*x+y*y);
}

FormatTextSignal(const text[], signal = 0)
{
	new str[128];
	format(str, 128, text);

	new
		nosignal,
		signallen = strlen(str);

	signal = 5 - signal;
	nosignal = (signallen * signal) / (10 + (random(10) * 10));

	for(new i = 0, j = nosignal; i != j; ++i)
	{
	    if(nosignal > signallen)
			break;

		if(random(signal + 1)==0) {
			continue;
		}
		strreplace(str, substr(str, nosignal, 2), "..");
		nosignal += random(signallen+1) + (signal * (random(2) + 1));
	}
	return str;
}

stock substr(const sSource[], iStart, iLength = sizeof sSource)
{
	new
		sReturn[256];

	if(iLength < 0)
	{
		strmid(sReturn, sSource, iStart, strlen(sSource) + iLength);
		return sReturn;
	}
	else
	{
		strmid(sReturn, sSource, iStart, (iStart + iLength));
		return sReturn;
	}
}

//=============================== [ DATE/TIME ] ==========================
stock ReturnDate()
{
	new sendString[90], MonthStr[40], month, day, year;
	new hour, minute, second;
	
	gettime(hour, minute, second);
	getdate(year, month, day);
	switch(month)
	{
	    case 1:  MonthStr = "January";
	    case 2:  MonthStr = "February";
	    case 3:  MonthStr = "March";
	    case 4:  MonthStr = "April";
	    case 5:  MonthStr = "May";
	    case 6:  MonthStr = "June";
	    case 7:  MonthStr = "July";
	    case 8:  MonthStr = "August";
	    case 9:  MonthStr = "September";
	    case 10: MonthStr = "October";
	    case 11: MonthStr = "November";
	    case 12: MonthStr = "December";
	}
	
	format(sendString, 90, "%s %d, %d %02d:%02d:%02d", MonthStr, day, year, hour, minute, second);
	return sendString;
}

stock ReturnDateTH()
{
	new sendString[90], MonthStr[40], month, day, year;
	new hour, minute, second;
	
	gettime(hour, minute, second);
	getdate(year, month, day);
	switch(month)
	{
	    case 1:  MonthStr = "มกราคม";
	    case 2:  MonthStr = "กุมภาพันธ์";
	    case 3:  MonthStr = "มีนาคม";
	    case 4:  MonthStr = "เมษายน";
	    case 5:  MonthStr = "พฤษภาคม";
	    case 6:  MonthStr = "มิถุนายน";
	    case 7:  MonthStr = "กรกฎาคม";
	    case 8:  MonthStr = "สิงหาคม";
	    case 9:  MonthStr = "กันยายน";
	    case 10: MonthStr = "ตุลาคม";
	    case 11: MonthStr = "พฤศจิกายน";
	    case 12: MonthStr = "ธันวาคม";
	}
	
	format(sendString, 90, "%s %d, %d %02d:%02d:%02d", MonthStr, day, year, hour, minute, second);
	return sendString;
}

ReturnDateTime(type = 0)
{
 	new
	    szDay[64],
		date[6];

	getdate(date[2], date[1], date[0]);
	gettime(date[3], date[4], date[5]);

	switch(type) {
		case 0: format(szDay, sizeof(szDay), "%d%s %s %d, %02d:%02d:%02d", date[0], returnOrdinal(date[0]), MONTH_DAY[date[1] - 1], date[2], date[3], date[4], date[5]);
		case 1: format(szDay, sizeof(szDay), "%02d-%02d-%d %02d:%02d", date[0], date[1], date[2], date[3], date[4]);
		case 2: format(szDay, sizeof(szDay), "%s %d %d, %02d:%02d", MONTH_DAY_SHORT[date[1] - 1], date[0], date[2], date[3], date[4]);
	}

	return szDay;
}

returnOrdinal(number)
{
	new
	    ordinal[4][3] = { "st", "nd", "rd", "th" }
	;
	number = number < 0 ? -number : number;
	return (((10 < (number % 100) < 14)) ? ordinal[3] : (0 < (number % 10) < 4) ? ordinal[((number % 10) - 1)] : ordinal[3]);
}


GetRealTime(&hours, &minutes, &seconds, timezone_offset = 0) {
    gettime(hours, minutes, seconds);
    hours += timezone_offset;
    hours = hours < 0 ? (hours + 24) : hours;
    hours = hours > 23 ? (hours - 24) : hours;
}

ConvertTime(&cts, &ctm=-1,&cth=-1,&ctd=-1,&ctw=-1,&ctmo=-1,&cty=-1)
{
    #define PLUR(%0,%1,%2) (%0),((%0) == 1)?((#%1)):((#%2))

    #define CTM_cty 31536000
    #define CTM_ctmo 2628000
    #define CTM_ctw 604800
    #define CTM_ctd 86400
    #define CTM_cth 3600
    #define CTM_ctm 60

    #define CT(%0) %0 = cts / CTM_%0; cts %= CTM_%0

    new strii[128];

    if(cty != -1 && (cts/CTM_cty))
    {
        CT(cty); CT(ctmo); CT(ctw); CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, %d %s, %d %s, %d %s, and %d %s",PLUR(cty,"year","years"),PLUR(ctmo,"month","months"),PLUR(ctw,"week","weeks"),PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctmo != -1 && (cts/CTM_ctmo))
    {
        cty = 0; CT(ctmo); CT(ctw); CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, %d %s, %d %s, and %d %s",PLUR(ctmo,"month","months"),PLUR(ctw,"week","weeks"),PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctw != -1 && (cts/CTM_ctw))
    {
        cty = 0; ctmo = 0; CT(ctw); CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, %d %s, and %d %s",PLUR(ctw,"week","weeks"),PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctd != -1 && (cts/CTM_ctd))
    {
        cty = 0; ctmo = 0; ctw = 0; CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, %d %s, and %d %s",PLUR(ctd,"day","days"),PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(cth != -1 && (cts/CTM_cth))
    {
        cty = 0; ctmo = 0; ctw = 0; ctd = 0; CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s, %d %s, and %d %s",PLUR(cth,"hour","hours"),PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    if(ctm != -1 && (cts/CTM_ctm))
    {
        cty = 0; ctmo = 0; ctw = 0; ctd = 0; cth = 0; CT(ctm);
        format(strii, sizeof(strii), "%d %s, and %d %s",PLUR(ctm,"minute","minutes"),PLUR(cts,"second","seconds"));
        return strii;
    }
    cty = 0; ctmo = 0; ctw = 0; ctd = 0; cth = 0; ctm = 0;
    format(strii, sizeof(strii), "%d %s", PLUR(cts,"second","seconds"));
    return strii;
}

ConvertTimeTH(&cts, &ctm=-1,&cth=-1,&ctd=-1,&ctw=-1,&ctmo=-1,&cty=-1)
{
    #define PLUR(%0,%1,%2) (%0),((%0) == 1)?((#%1)):((#%2))

    #define CTM_cty 31536000
    #define CTM_ctmo 2628000
    #define CTM_ctw 604800
    #define CTM_ctd 86400
    #define CTM_cth 3600
    #define CTM_ctm 60

    #define CT(%0) %0 = cts / CTM_%0; cts %= CTM_%0

    new strii[128];

    if(cty != -1 && (cts/CTM_cty))
    {
        CT(cty); CT(ctmo); CT(ctw); CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s %d %s %d %s %d %s %d %s %d %s %d %s",PLUR(cty,"ปี","ปี"),PLUR(ctmo,"เดือน","เดือน"),PLUR(ctw,"สัปดาห์","สัปดาห์"),PLUR(ctd,"วัน","วัน"),PLUR(cth,"ชั่วโมง","ชั่วโมง"),PLUR(ctm,"นาที","นาที"),PLUR(cts,"วินาที","วินาที"));
        return strii;
    }
    if(ctmo != -1 && (cts/CTM_ctmo))
    {
        cty = 0; CT(ctmo); CT(ctw); CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s %d %s %d %s %d %s %d %s %d %s",PLUR(ctmo,"เดือน","เดือน"),PLUR(ctw,"สัปดาห์","สัปดาห์"),PLUR(ctd,"วัน","วัน"),PLUR(cth,"ชั่วโมง","ชั่วโมง"),PLUR(ctm,"นาที","นาที"),PLUR(cts,"วินาที","วินาที"));
        return strii;
    }
    if(ctw != -1 && (cts/CTM_ctw))
    {
        cty = 0; ctmo = 0; CT(ctw); CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s %d %s %d %s %d %s %d %s",PLUR(ctw,"สัปดาห์","สัปดาห์"),PLUR(ctd,"วัน","วัน"),PLUR(cth,"ชั่วโมง","ชั่วโมง"),PLUR(ctm,"นาที","นาที"),PLUR(cts,"วินาที","วินาที"));
        return strii;
    }
    if(ctd != -1 && (cts/CTM_ctd))
    {
        cty = 0; ctmo = 0; ctw = 0; CT(ctd); CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s %d %s %d %s %d %s",PLUR(ctd,"วัน","วัน"),PLUR(cth,"ชั่วโมง","ชั่วโมง"),PLUR(ctm,"นาที","นาที"),PLUR(cts,"วินาที","วินาที"));
        return strii;
    }
    if(cth != -1 && (cts/CTM_cth))
    {
        cty = 0; ctmo = 0; ctw = 0; ctd = 0; CT(cth); CT(ctm);
        format(strii, sizeof(strii), "%d %s %d %s %d %s",PLUR(cth,"ชั่วโมง","ชั่วโมง"),PLUR(ctm,"นาที","นาที"),PLUR(cts,"วินาที","วินาที"));
        return strii;
    }
    if(ctm != -1 && (cts/CTM_ctm))
    {
        cty = 0; ctmo = 0; ctw = 0; ctd = 0; cth = 0; CT(ctm);
        format(strii, sizeof(strii), "%d %s %d %s",PLUR(ctm,"นาที","นาที"),PLUR(cts,"วินาที","วินาที"));
        return strii;
    }
    cty = 0; ctmo = 0; ctw = 0; ctd = 0; cth = 0; ctm = 0;
    format(strii, sizeof(strii), "%d %s", PLUR(cts,"วินาที","วินาที"));
    return strii;
}

//================================ [ Message ] ===========================
FormatNumber(number, const prefix[] = "$")
{
	new
		value[32],
		length;

	format(value, sizeof(value), "%d", (number < 0) ? (-number) : (number));

	if ((length = strlen(value)) > 3)
	{
		for (new i = length, l = 0; --i >= 0; l ++) {
		    if ((l > 0) && (l % 3 == 0)) strins(value, ",", i + 1);
		}
	}
	if (prefix[0] != 0)
	    strins(value, prefix, 0);

	if (number < 0)
		strins(value, "-", 0);

	return value;
}

SendOOCMessage(color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
				if (!BitFlag_Get(gPlayerBitFlag[i], TOGGLE_OOC)) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (!BitFlag_Get(gPlayerBitFlag[i], TOGGLE_OOC)) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}

stock SendACMessage(color, flags, const text[], {Float, _}:...)
{
	static
	    args,
	    str[144];

	if ((args = numargs()) == 3)
	{
		foreach(new i : Player) {
			if ((flags & playerData[i][pCMDPermission]) && flags && !BitFlag_Get(gPlayerBitFlag[i], TOGGLE_AC)) {
				SendClientMessage(i, color, text);
			}
		}
	}
	else
	{
		while (--args >= 3)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S text
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit PUSH.S 8
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		foreach(new i : Player) {
			if ((flags & playerData[i][pCMDPermission]) && flags && !BitFlag_Get(gPlayerBitFlag[i], TOGGLE_AC)) {
				SendClientMessage(i, color, str);
			}
		}
		#emit RETN
	}
	return 1;
}

SendAdminMessage(color, flags, const text[], {Float, _}:...)
{
	static
	    args,
	    str[144];

	if ((args = numargs()) == 3)
	{
		foreach(new i : Player) {
			if ((flags & playerData[i][pCMDPermission]) && flags) {
				SendClientMessage(i, color, text);
			}
		}
	}
	else
	{
		while (--args >= 3)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S text
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit PUSH.S 8
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		foreach(new i : Player) {
			if ((flags & playerData[i][pCMDPermission]) && flags) {
				SendClientMessage(i, color, str);
			}
		}
		#emit RETN
	}
	return 1;
}

SendNearbyMessage(playerid, Float:radius, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 16)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 16); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit CONST.alt 4
		#emit SUB
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
			if (IsPlayerNearPlayer(i, playerid, radius)) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (IsPlayerNearPlayer(i, playerid, radius)) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}

SendClientMessageEx(playerid, color, const text[], {Float, _}:...)
{
	static
	    args,
	    str[144];

	if ((args = numargs()) == 3)
	{
	    SendClientMessage(playerid, color, text);
	}
	else
	{
		while (--args >= 3)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S text
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit PUSH.S 8
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		SendClientMessage(playerid, color, str);

		#emit RETN
	}
	return 1;
}

SendClientMessageToAllEx(color, const text[], {Float, _}:...)
{
	static
	    args,
	    str[144];

	if ((args = numargs()) == 2)
	{
	    SendClientMessageToAll(color, text);
	}
	else
	{
		while (--args >= 2)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S text
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		SendClientMessageToAll(color, str);

		#emit RETN
	}
	return 1;
}

//================================= [ Regex ] ============================

IsValidRpName(const nickname[])
{
    new Regex:r = Regex_New("([A-Z]{1,1})[a-z]{2,10}_([A-Z]{1,1})[a-z]{2,10}");

    new check = Regex_Check(nickname, r);

    Regex_Delete(r);

    return check;
}

IsRandomName(const nickname[])
{
    new Regex:r = Regex_New("(_{2,2})android([_]+[0-9]{0,8})");

    new check = Regex_Check(nickname, r);

    Regex_Delete(r);

    return check;
}

IsEnglishAndNumber(const nickname[])
{
    new Regex:r = Regex_New("[a-zA-Z0-9 _]+");

    new check = Regex_Check(nickname, r);

    Regex_Delete(r);

    return check;
}
/*
IsGameText(const nickname[])
{
    new Regex:r = Regex_New("[a-zA-Z0-9 _]+");

    new check = Regex_Check(nickname, r);

    Regex_Delete(r);

    return check;
}*/

IsIPAddress(const ip_address[]) {
    new Regex:r = Regex_New(".*\\d{1,3}\\.+\\d{1,3}\\.+\\d{1,3}\\.+\\d{1,3}.*");

    new check = Regex_Check(ip_address, r);

    Regex_Delete(r);

    return check;
}
/*
IsValidName(nickname[])
{
    new Regex:r = Regex_New("^[A-Za-z0-9\\._\\$@=\\(\\)\\[\\]]+$");

    new check = Regex_Check(nickname, r);

    Regex_Delete(r);

    return check;
}*/