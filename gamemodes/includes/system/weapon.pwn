#include <YSI\y_hooks>

new bool:deleyNop[MAX_PLAYERS char];
new const g_aWeaponSlots[] = {
	0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 10, 10, 8, 8, 8, 0, 0, 0, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 4, 6, 6, 7, 7, 7, 7, 8, 12, 9, 9, 9, 11, 11, 11, 0, 0
};
new szString[128];
new TazerCount[MAX_PLAYERS];

// WEAPON DROP
#define MAX_DROP_ITEMS 100
//=================//
enum dData
{
	DropID,
    DropGunAmmount[2],//ModelID & Bullets
    Float:DropGunPosX,
    Float:DropGunPosY,
    Float:DropGunPosZ,
    DropLicense,
    DropObj,
    //STREAMER_TAG_3D_TEXT_LABEL:DropLabel,
    DropTimer,
    DropSaving,
};
new GunInfo[MAX_DROP_ITEMS][dData];
//=================//
new GunObjectIDs[200] ={

   1575,  331, 333, 334, 335, 336, 337, 338, 339, 341, 321, 322, 323, 324, 325, 326, 342, 343, 344, -1,  -1 , -1 ,
   346, 347, 348, 349, 350, 351, 352, 353, 355, 356, 372, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367,
   368, 369, 1575
};

hook OnPlayerSpawn(playerid) 
{
	ResetPlayerWeapons(playerid);
	SetPlayerArmedWeapon(playerid, 0);
	SetPlayerWeapons(playerid);
}

// LSRP.in.th

// Dropgun Weapon System

GetGunObjectID(wpid)
{
    if (wpid < 0 || wpid > 64)
    {
        return 1575;
    }
    return GunObjectIDs[wpid];
}

DropGun(playerid, GunID, GunAmmo, license = 0, Float:X, Float:Y, Float:Z, saving = true)
{
    if(GunID != 0 && GunAmmo != 0)
    {
        for(new i = 0; i != sizeof(GunInfo); ++i)
        {
            if(GunInfo[i][DropGunPosX] == 0.0 && GunInfo[i][DropGunPosY] == 0.0 && GunInfo[i][DropGunPosZ] == 0.0)
            {
                GunInfo[i][DropGunAmmount][0] = GunID;
                GunInfo[i][DropGunAmmount][1] = GunAmmo;
                GunInfo[i][DropGunPosX] = X;
                GunInfo[i][DropGunPosY] = Y;
                GunInfo[i][DropGunPosZ] = Z;
                GunInfo[i][DropLicense] = license;
                GunInfo[i][DropID] = i;
                GunInfo[i][DropSaving] = saving;
                //GunInfo[i][DropLabel] = CreateDynamic3DTextLabel(ReturnWeaponName(GunID), 0x2E9AFEFF, X, Y, Z - 0.8, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1);
                GunInfo[i][DropObj] = CreateDynamicObject(GetGunObjectID(GunID), X, Y, Z-1, 80.0, 0.0, 0.0, 0, 0);
				GunInfo[i][DropTimer] = SetTimerEx("ResetDropGun", 600000, 0, "i", i);

				SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, "AdminWawrning: %s ได้ดรอป %s (%d)", ReturnPlayerName(playerid), ReturnWeaponName(GunID), GunAmmo);
                // Log_Write("logs/dropgun.txt", "[%s] %s: %s(%d)", ReturnDate(), ReturnPlayerName(playerid), ReturnWeaponName(GunID), GunAmmo);

                return 1;
            }
        }
        return 1;
    }
    return 1;
}

forward ResetDropGun(gunid);
public ResetDropGun(gunid)
{
 	for(new i = 0; i != sizeof(GunInfo); ++i)
  	{
      	if(GunInfo[i][DropID] == gunid)
     	{
      		GunInfo[i][DropGunAmmount][0] = 0;
          	GunInfo[i][DropGunAmmount][1] = 0;
           	GunInfo[i][DropGunPosX] = 0.0;
          	GunInfo[i][DropGunPosY] = 0.0;
          	GunInfo[i][DropGunPosZ] = 0.0;
          	GunInfo[i][DropLicense] = 0;
          	GunInfo[i][DropID] = -1;
          	KillTimer(GunInfo[i][DropTimer]);
			DestroyDynamicObject(GunInfo[i][DropObj]);

           	return 1;
      	}
 	}
 	return 1;
}

DropGun_Nearest(playerid)
{
    for (new i = 0; i != MAX_DROP_ITEMS; i ++) if (GunInfo[i][DropID] != -1 && IsPlayerInRangeOfPoint(playerid, 1.5, GunInfo[i][DropGunPosX], GunInfo[i][DropGunPosY], GunInfo[i][DropGunPosZ])) return i;

	return -1;
}

// Weapon System

ReturnWeaponName(weaponid)
{
	new
		name[24];

	GetWeaponName(weaponid, name, sizeof(name));

	if (!weaponid)
	    name = "None";

	else if (weaponid == 30)
	    name = "AK-47";

	else if (weaponid == 18)
	    name = "Molotov Cocktail";

	else if (weaponid == 44)
	    name = "Nightvision";

	else if (weaponid == 45)
	    name = "Infrared";

	return name;
}

RemoveWeapon(playerid, weaponid)
{
    deleyNop{ playerid } = true;

	ResetPlayerWeapons(playerid);

	for (new i = 0; i < 13; i ++) {
	    if (playerData[playerid][pGuns][i] != weaponid) {
	        GivePlayerWeapon(playerid, playerData[playerid][pGuns][i], playerData[playerid][pAmmo][i]);
		}
		else {
            playerData[playerid][pGuns][i] = 0;
            playerData[playerid][pAmmo][i] = 0;
	    }
	}

    //cl_DressHoldWeapon(playerid, GetPlayerWeapon(playerid)); for obj

	deleyNop{ playerid } = false;
	return 1;
}

forward SetPlayerWeapons(playerid);
public SetPlayerWeapons(playerid)
{
	if(playerData[playerid][pPlayingHours] >= 50 && playerData[playerid][pJailed] < 1)
	{
		if (playerData[playerid][pGun1] > 0)
		{
			GivePlayerWeaponEx(playerid, playerData[playerid][pGun1], playerData[playerid][pAmmo1]);
		}
		if (playerData[playerid][pGun2] > 0)
		{
			GivePlayerWeaponEx(playerid, playerData[playerid][pGun2], playerData[playerid][pAmmo2]);
		}
		if (playerData[playerid][pGun3] > 0)
		{
			GivePlayerWeaponEx(playerid, playerData[playerid][pGun3], playerData[playerid][pAmmo3]);
		}
		SetPlayerArmedWeapon(playerid, 0);
	}
}

ResetWeapons(playerid)
{
	ResetPlayerWeapons(playerid);

	for (new i = 0; i < 13; i ++) {
    	playerData[playerid][pGuns][i] = 0;
    	playerData[playerid][pAmmo][i] = 0;
	}
	return 1;
}

GivePlayerWeaponEx(playerid, weaponid, ammo)
{
	if (weaponid < 0 || weaponid > 46)
	    return 0;

	playerData[playerid][pGuns][g_aWeaponSlots[weaponid]] = weaponid;
	playerData[playerid][pAmmo][g_aWeaponSlots[weaponid]] = ammo;

	return GivePlayerWeapon(playerid, weaponid, ammo);
}

IsInvalidWeapon(weaponid)
{
	if(weaponid == 34 || weaponid == 35 || weaponid == 16 || weaponid == 18) return 1;
	else return 0;
}

GivePlayerValidWeapon(playerid, weaponid, ammo, license=0)
{
	if (weaponid < 0 || weaponid > 46)
	    return 0;

    RemoveWeapon(playerid, weaponid);

	if(!IsInvalidWeapon(weaponid))
	{
		if(IsMelee(weaponid))
		{
		    playerData[playerid][pGun1] = weaponid;
		    playerData[playerid][pAmmo1] = ammo;
		    SendClientMessageEx(playerid, COLOR_GREEN, "[Melee] คุณจะเกิดด้วย %s", ReturnWeaponName(weaponid));
		}
		else if(IsPrimary(weaponid))
		{
		    playerData[playerid][pGun2] = weaponid;
		    playerData[playerid][pAmmo2] = ammo;
		    SendClientMessageEx(playerid, COLOR_GREEN, "[Primary weapon] คุณจะเกิดด้วย %s", ReturnWeaponName(weaponid));

		    //playerData[playerid][pPLicense] = license;
		}
		else if(IsSecondary(weaponid))
		{
		    playerData[playerid][pGun3] = weaponid;
		    playerData[playerid][pAmmo3] = ammo;
		    SendClientMessageEx(playerid, COLOR_GREEN, "[Secondary weapon] คุณจะเกิดด้วย %s", ReturnWeaponName(weaponid));

		    //playerData[playerid][pSLicense] = license;
		}
	}

	playerData[playerid][pGuns][g_aWeaponSlots[weaponid]] = weaponid;
	playerData[playerid][pAmmo][g_aWeaponSlots[weaponid]] = ammo;

	GivePlayerWeapon(playerid, weaponid, ammo);

	return license;
}

SetWeapons(playerid)
{
	ResetPlayerWeapons(playerid);

	for (new i = 0; i < 13; i ++) if (playerData[playerid][pGuns][i] > 0 && playerData[playerid][pAmmo][i] > 0) {
	    GivePlayerWeapon(playerid, playerData[playerid][pGuns][i], playerData[playerid][pAmmo][i]);
	}
	SetPlayerArmedWeapon(playerid, 0);
	
	return 1;
}

IsMeleeSlotTaken(playerid)
{
	if(playerData[playerid][pGun1]) return true;
	return false;
}

IsPrimarySlotTaken(playerid)
{
	if(playerData[playerid][pGun2]) return true;
	return false;
}

IsSecondarySlotTaken(playerid)
{
	if(playerData[playerid][pGun3]) return true;
	return false;
}

IsMelee(weaponid)
{
    if(weaponid >= 1 && weaponid <= 15) return true;
	//switch(weaponid) { case 1..8,10..13,43: { return 1; } }
	return 0;
}

IsPrimary(weaponid)
{
    if(weaponid >= 25 && weaponid <= 33) return true;
	//switch(weaponid) { case 25,27,29..34: { return 1; } }
	return 0;
}

IsSecondary(weaponid)
{
    if(weaponid >= 22 && weaponid <= 24) return true;
	//switch(weaponid) { case 22..24: { return 1; } }
	return 0;
}

ExistWeaponSlot(playerid, weaponid) {
	if(IsMelee(weaponid) && IsMeleeSlotTaken(playerid)) return playerData[playerid][pGun1];
	else if(IsPrimary(weaponid) && IsPrimarySlotTaken(playerid)) return playerData[playerid][pGun2];
	else if(IsSecondary(weaponid) && IsSecondarySlotTaken(playerid)) return playerData[playerid][pGun3];
	return 0;
}

FullResetPlayerWeapons(playerid) {

	playerData[playerid][pGun1] = 0, playerData[playerid][pAmmo1] = 0;
	playerData[playerid][pGun2] = 0, playerData[playerid][pAmmo2] = 0;
	playerData[playerid][pGun3] = 0, playerData[playerid][pAmmo3] = 0;

	ResetWeapons(playerid);
}

CMD:weapons(playerid, params[])
{
    if(playerData[playerid][pLevel] < 2)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเลเวล 2 ขึ้นไป");

	SendClientMessage(playerid, COLOR_LIGHTRED, "เพื่อทิ้งอาวุธของคุณพิมพ์ /dropgun [weapon ID]");

	for (new i = 0; i < 13; i ++) {
	    if (playerData[playerid][pGuns][i] != 0 && playerData[playerid][pAmmo][i] != 0) {

			if(playerData[playerid][pGun2] == playerData[playerid][pGuns][i]) 
			{
				SendClientMessageEx(playerid, COLOR_GREY, "[ID: %d] Weapon:[%s] - Ammo:[%d]", playerData[playerid][pGuns][i], ReturnWeaponName(playerData[playerid][pGuns][i]), playerData[playerid][pAmmo][i]);
			}
			else if(playerData[playerid][pGun3] == playerData[playerid][pGuns][i]) 
			{
				SendClientMessageEx(playerid, COLOR_GREY, "[ID: %d] Weapon:[%s] - Ammo:[%d]", playerData[playerid][pGuns][i], ReturnWeaponName(playerData[playerid][pGuns][i]), playerData[playerid][pAmmo][i]);
			}
			else {
				SendClientMessageEx(playerid, COLOR_GREY, "[ID: %d] Weapon:[%s] - Ammo:[%d]", playerData[playerid][pGuns][i], ReturnWeaponName(playerData[playerid][pGuns][i]), playerData[playerid][pAmmo][i]);
			}

		}
	}
	return 1;
}

CMD:dropgun(playerid, params[])
{
	new weaponid, bool:success, string[128];

	if (sscanf(params, "d", weaponid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /dropgun [weapon ID]");

	for (new i = 0; i < 13; i ++) {
	    if (playerData[playerid][pGuns][i] == weaponid) {

		    if(playerData[playerid][pGuns][i] == playerData[playerid][pGun1]) {
		        Log(dropgunlog, INFO, "[%s] %s: %s(%d)", ReturnDate(), ReturnPlayerName(playerid), ReturnWeaponName(playerData[playerid][pGun1]), playerData[playerid][pAmmo1]);
		        playerData[playerid][pGun1] = 0, playerData[playerid][pAmmo1] = 0;
			}
		    if(playerData[playerid][pGuns][i] == playerData[playerid][pGun2]) {
		        Log(dropgunlog, INFO, "[%s] %s: %s(%d)", ReturnDate(), ReturnPlayerName(playerid), ReturnWeaponName(playerData[playerid][pGun2]), playerData[playerid][pAmmo2]);
		        playerData[playerid][pGun2] = 0, playerData[playerid][pAmmo2] = 0;
			}
		    if(playerData[playerid][pGuns][i] == playerData[playerid][pGun3]) {
		        Log(dropgunlog, INFO, "[%s] %s: %s(%d)", ReturnDate(), ReturnPlayerName(playerid), ReturnWeaponName(playerData[playerid][pGun3]), playerData[playerid][pAmmo3]);
		        playerData[playerid][pGun3] = 0, playerData[playerid][pAmmo3] = 0;
			}
			new temp_holdweapon = GetPlayerWeapon(playerid);
			RemoveWeapon(playerid, weaponid);
			if(temp_holdweapon == weaponid) SetPlayerArmedWeapon(playerid, 0);
			else SetPlayerArmedWeapon(playerid, temp_holdweapon);
			
			format(string, sizeof(string), "* %s ได้ทิ้ง %s", ReturnRealName(playerid), ReturnWeaponName(temp_holdweapon));
			SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 6000);
	    	success = true;
			break;
		}
	}

	if(!success) SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่มีอาวุธนี้");

	return 1;
}

CMD:leavegun(playerid, params[])
{

    if( GetPlayerVirtualWorld(playerid) || GetPlayerInterior(playerid) )
        return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถวางอาวุธไว้ที่นี่ได้");

  	if( GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK && !gIsDeathMode{playerid} && !gIsInjuredMode{playerid})
    	return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ในท่าหมอบ");

	new
	    weaponid,
	    Float:x,
	    Float:y,
	    Float:z
	;

	if (sscanf(params, "d", weaponid))
	    return SendClientMessage(playerid, COLOR_WHITE, "/leavegun weapon_id (รายชื่อไอดีใน /weapons)");

    if(playerData[playerid][pLevel] < 2)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเลเวล 2 ขึ้นไป");

	if (weaponid && playerData[playerid][pGun1] == weaponid || playerData[playerid][pGun2] == weaponid || playerData[playerid][pGun3] == weaponid) {

  		GetPlayerPos(playerid, x, y, z);

		if(playerData[playerid][pGun1] == weaponid)
		{
			DropGun(playerid, playerData[playerid][pGun1], playerData[playerid][pAmmo1], _, x, y, z);
			playerData[playerid][pGun1] = 0, playerData[playerid][pAmmo1] = 0;
		}
		else if(playerData[playerid][pGun2] == weaponid)
		{
        	DropGun(playerid, playerData[playerid][pGun2], playerData[playerid][pAmmo2], _, x, y, z);
         	playerData[playerid][pGun2] = 0, playerData[playerid][pAmmo2] = 0;
		}
		else if(playerData[playerid][pGun3] == weaponid)
		{
			DropGun(playerid, playerData[playerid][pGun3], playerData[playerid][pAmmo3], _, x, y, z);
			playerData[playerid][pGun3] = 0, playerData[playerid][pAmmo3] = 0;
		}

		new temp_holdweapon = GetPlayerWeapon(playerid);
		RemoveWeapon(playerid, weaponid);
		if(temp_holdweapon == weaponid) SetPlayerArmedWeapon(playerid, 0);
		else SetPlayerArmedWeapon(playerid, temp_holdweapon);
			
	 	SendClientMessage(playerid, COLOR_WHITE, "/grabgun เพื่อเก็บกลับมา");
	 	SendClientMessage(playerid, COLOR_LIGHTRED, "[ ! ] "EMBED_WHITE"อาวุธจะหายไปหากไม่เก็บขึ้นมาใน 30 นาที");
		
		format(szString, sizeof(szString), "* %s ได้ทิ้ง %s", ReturnRealName(playerid), ReturnWeaponName(temp_holdweapon));
		SetPlayerChatBubble(playerid, szString, COLOR_PURPLE, 30.0, 6000);
	}
	else SendClientMessage(playerid, COLOR_LIGHTRED, "ขออภัย เฉพาะอาวุธที่อยู่ใน /stats ของคุณเท่านั้น");

	return 1;
}

CMD:grabgun(playerid, params[])
{
    if(playerData[playerid][pLevel] < 2)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเลเวล 2 ขึ้นไป");

	new
	    id;

	if((id = DropGun_Nearest(playerid)) != -1)
	{
	    //SendClientMessageEx(playerid, COLOR_GREY, "คุณได้เก็บ %s", ReturnWeaponName(GunInfo[id][DropGunAmmount][0]));
		//if((IsMelee(GunInfo[id][DropGunAmmount][0]) && IsMeleeSlotTaken(playerid)) || (IsPrimary(GunInfo[id][DropGunAmmount][0]) && IsPrimarySlotTaken(playerid)) || (IsSecondary(GunInfo[id][DropGunAmmount][0]) && IsSecondarySlotTaken(playerid))) return SendClientMessageEx(playerid, -1, "อาวุธไอดี: %d - %s ได้ใช้ช่องอยู่ในปัจจุบัน", GunInfo[id][DropGunAmmount][0], ReturnWeaponName(GunInfo[id][DropGunAmmount][0]));
		/*if(IsPrimary(GunInfo[id][DropGunAmmount][0]) && IsPrimarySlotTaken(playerid)) return SendClientMessage(playerid, -1, "สล็อตอาวุธหลักของคุณถูกใช้แล้ว");
		if(IsSecondary(GunInfo[id][DropGunAmmount][0]) && IsSecondarySlotTaken(playerid)) return SendClientMessage(playerid, -1, "สล็อตอาวุธรองของคุณถูกใช้แล้ว");
*/
		new weapontaken = 0;
		if((weapontaken = ExistWeaponSlot(playerid, GunInfo[id][DropGunAmmount][0])) != 0) {
			SendClientMessageEx(playerid, -1, "อาวุธไอดี: %d - %s ได้ใช้ช่องอยู่ในปัจจุบัน", weapontaken, ReturnWeaponName(weapontaken));
			return 1;
		}
        //if(playerData[playerid][pGuns][g_aWeaponSlots[GunInfo[id][DropGunAmmount][0]]] != 0) return SendClientMessageEx(playerid, -1, "อาวุธไอดี: %d - %s ได้ใช้ช่องอยู่ในปัจจุบัน", GunInfo[id][DropGunAmmount][0], ReturnWeaponName(GunInfo[id][DropGunAmmount][0]));

		GivePlayerValidWeapon(playerid, GunInfo[id][DropGunAmmount][0], GunInfo[id][DropGunAmmount][1], GunInfo[id][DropLicense]);
	    ResetDropGun(id);
	}
	else SendClientMessage(playerid, COLOR_LIGHTRED, " ..ไม่มีอะไรรอบ ๆ ตัวคุณ");

	return 1;
}

CMD:checkhacker(playerid, params[])
{
	if(playerData[playerid][pAdmin] < 1)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");


	new Player_Weapons[13], Player_Ammos[13], bool:success, string[128];

	SendClientMessage(playerid, COLOR_GREEN, "___________________________[Check Weapon&Ammo SYSTEM]___________________________");

	foreach(new i : Player)
	{

		for(new wep = 1;wep <= 12;wep++)
		{
			GetPlayerWeaponData(i,wep,Player_Weapons[wep], Player_Ammos[wep]);

			if((Player_Weapons[wep] != 0 && playerData[i][pGuns][wep] != Player_Weapons[wep]) || playerData[i][pAmmo][wep] != Player_Ammos[wep])
			{
				format(string, sizeof(string), "[ID:%d]%s SERVER: %s(%d) | CLIENT: %s(%d)", i, ReturnRealName(i), ReturnWeaponName(playerData[i][pGuns][wep]), playerData[i][pAmmo][wep], ReturnWeaponName(Player_Weapons[wep]), Player_Ammos[wep]);
				SendClientMessage(playerid, COLOR_LIGHTRED, string);
				success = true;
			}
			//printf("SERVER: %s(%d) | CLIENT: %s(%d)", ReturnWeaponName(playerData[playerid][pGuns][wep]), playerData[playerid][pAmmo][wep], ReturnWeaponName(Player_Weapons[wep]), Player_Ammos[wep]);
			
		}
	}
	if(!success) SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่พบข้อมูลผู้เล่นที่เสกอาวุธหรือกระสุน");
	SendClientMessage(playerid, COLOR_WHITE, "ใช้ /resetweapons เพื่อให้อาวุธทั้งหมดตรงตามระบบ");
	return 1;
}

CMD:resetweapons(playerid, params[])
{
	if(playerData[playerid][pAdmin] < 1)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

	new userid;

	if (sscanf(params, "u", userid))
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /resetweapons [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	ResetPlayerWeapons(userid);
	
	for (new i = 0; i < 13; i ++) GivePlayerValidWeapon(userid, playerData[userid][pGuns][i], playerData[userid][pAmmo][i]);
	return 1;
}

CMD:clearweapons(playerid, params[])
{
	if(playerData[playerid][pAdmin] < 1)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

	new userid;

	if (sscanf(params, "u", userid))
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /clearweapons [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	ResetWeapons(userid);
	return 1;
}

CMD:clearsaveweapons(playerid, params[])
{
	if(playerData[playerid][pAdmin] < 1)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");

	new userid;

	if (sscanf(params, "u", userid))
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /clearsaveweapons [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	FullResetPlayerWeapons(userid);
	//Log_Write("logs/admin_action.txt", "[%s] [/clearsaveweapons] %s clear saving weapon %s", ReturnDate(), ReturnPlayerName(playerid), ReturnPlayerName(userid));
	
	return 1;
}

CMD:baszazaspawngun(playerid, params[])
{
	new playerb, gunid, ammo, license, string[128];

	if(playerData[playerid][pAdmin] < 4) 
		return SendClientMessage(playerid, COLOR_GREY, "คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");
	
	if(sscanf(params, "uiiD(0)", playerb, gunid, ammo, license))
	{
		SendClientMessage(playerid, COLOR_WHITE, "[Usage]: /baszazaspawngun [ไอดีผู้เล่น] [gunid] [กระสุน] [license(0/1)]");
		SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
		SendClientMessage(playerid, COLOR_GREY, "1: Brass Knuckles 2: Golf Club 3: Nite Stick 4: Knife 5: Baseball Bat 6: Shovel 7: Pool Cue 8: Katana 9: Chainsaw");
		SendClientMessage(playerid, COLOR_GREY, "10: Purple Dildo 11: Small White Vibrator 12: Large White Vibrator 13: Silver Vibrator 14: Flowers 15: Cane 16: Frag Grenade");
		SendClientMessage(playerid, COLOR_GREY, "17: Tear Gas 18: Molotov Cocktail 19: Vehicle Missile 20: Hydra Flare 21: Jetpack 22: 9mm 23: Silenced 9mm 24: Desert Eagle 25: Shotgun");
		SendClientMessage(playerid, COLOR_GREY, "26: Sawnoff Shotgun 27: SPAS-12 28: Micro SMG (Mac 10) 29: SMG (MP5) 30: AK-47 31: M4 32: Tec9 33: Rifle");
		SendClientMessage(playerid, COLOR_GREY, "25: Shotgun 34: Sniper Rifle 35: Rocket Launcher 36: HS Rocket Launcher 37: Flamethrower 38: Minigun 39: Satchel Charge");
		SendClientMessage(playerid, COLOR_GREY, "40: Detonator 41: Spraycan 42: Fire Extinguisher 43: Camera 44: Nightvision Goggles 45: Infared Goggles 46: Parachute");
		SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");

		return 1;
	}
	
	if(gunid < 0 || gunid > 46 || gunid == 19 || gunid == 20 || gunid == 21) 
		return SendClientMessage(playerid, COLOR_GREY, "Invalid weapon id.");

	SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdmWarning: %s ได้ทำการเสกอาวุธปืน %s ให้กับ %s โดยมีกระสุน %d นัด [Weapons Saving]", ReturnPlayerName(playerid), ReturnWeaponName(gunid), ReturnPlayerName(playerb), ammo);

	format(string, sizeof(string), " คุณให้ %s(%d) กับ %s", ReturnWeaponName(gunid), ammo,ReturnPlayerName(playerb));
	SendClientMessage(playerid, COLOR_WHITE, string);
	
	format(string, sizeof(string), " ผู้ดูแล %s ได้ให้ %s(%d) กับคุณ", ReturnPlayerName(playerid), ReturnWeaponName(gunid), ammo);
	SendClientMessage(playerb, COLOR_WHITE, string);

	GivePlayerValidWeapon(playerb, gunid, ammo, license ? randomEx(100000,999999) : 0);
	return 1;
}

// *** PLACE COMMAND
CMD:takegun(playerid, params[]) // Gun ID: 29 - MP5. Is currently occupying your Primary slot.
{
    if(playerData[playerid][pLevel] < 2)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเลเวล 2 ขึ้นไป");

	new bool:success;
	new house = insideHouseID[playerid];

	if (IsHouseOwner(playerid, house)) {
		if (IsPlayerInRangeOfPoint(playerid, 1.5, houseData[house][hCheckPosX], houseData[house][hCheckPosY], houseData[house][hCheckPosZ])) {
			
			new slot;
		
			if (sscanf(params, "d", slot))
				return SendClientMessage(playerid, COLOR_WHITE, "/takegun slot_id (ไอดีในรายการ /check)");
		
			slot--;
		
			if(slot >= 0 && slot < MAX_HOUSE_WEAPONS) {
				if(houseData[house][hWeapon][slot]) {
					new weapontaken = 0;			
					if((weapontaken = ExistWeaponSlot(playerid,houseData[house][hWeapon][slot])) != 0) {
						SendClientMessageEx(playerid, -1, "อาวุธไอดี: %d - %s ได้ใช้ช่องอยู่ในปัจจุบัน", weapontaken, ReturnWeaponName(weapontaken));
						return 1;
					}
			
					format(szString, sizeof(szString), "* %s ได้หยิบ %s ออกมาจากตู้เซฟของบ้าน", ReturnRealName(playerid), ReturnWeaponName(houseData[house][hWeapon][slot]));
					SetPlayerChatBubble(playerid, szString, COLOR_PURPLE, 30.0, 6000);
					SendClientMessage(playerid, COLOR_PURPLE, szString);
			
					GivePlayerValidWeapon(playerid, houseData[house][hWeapon][slot], houseData[house][hAmmo][slot], 0);
						
					houseData[house][hWeapon][slot]=0;
					houseData[house][hAmmo][slot]=0;
			
					House_SavePackage(house);
					success = true;
			
					return 1;
				}
				else return SendClientMessage(playerid, COLOR_WHITE, "ไม่มีอะไรอยู่ที่นั้น..");
			}
			else return SendClientMessage(playerid, COLOR_WHITE, "ไม่มีอะไรอยู่ที่นั้น..");
		}
		else return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่ตู้เซฟของบ้าน");
	}
	else
	{
		new vid = GetPlayerVehicleID(playerid);
		if(!vid) for(new i=0;i!=MAX_VEHICLES;i++) if (IsValidVehicle(i) && IsPlayerNearBoot(playerid, i) && (GetTrunkStatus(i) || IsVehicleTrunkBroken(i))) { vid = i; break; }

		/*new vehicle_fid = -1;
		
		if((GetFactionType(playerid) == FACTION_TYPE_POLICE || GetFactionType(playerid) == FACTION_TYPE_SASD) && vid && (vehicle_fid = IsACopCar(vid)) != -1 && (vehicleVariables[vehicle_fid][vVehicleModelID] >= 596 && vehicleVariables[vehicle_fid][vVehicleModelID] <= 599 || vehicleVariables[vehicle_fid][vVehicleModelID] == 427))
		{
			new slot;
			if (sscanf(params, "d", slot) || !slot)
				return SendClientMessage(playerid, COLOR_WHITE, "/takegun [SLOT ID (1/2/3/4/5)]");

			if(slot >= 1 && slot <= 5) {
			    new weaponid,ammo;

			    if(slot >= 4 && !playerData[playerid][pSwat]) return SendClientMessage(playerid, COLOR_LIGHTRED,"อาวุธช่องนี้สำหรับหน่วย SWAT เท่านั้น");

				switch(slot) {
			        case 1: weaponid = 25, ammo = 100;
			        case 2: weaponid = 29, ammo = 500;
			        case 3: weaponid = 31, ammo = 500;
			        case 4: weaponid = 27, ammo = 100;
			        case 5: weaponid = 34, ammo = 50;
			    }
				new weapontaken = 0;
				if((weapontaken = ExistWeaponSlot(playerid,weaponid)) == 0) {
					format(szString, sizeof(szString), "* %s ได้หยิบ %s ออกมาจาก %s", ReturnRealName(playerid), ReturnWeaponName(weaponid), g_arrVehicleNames[GetVehicleModel(vid) - 400]);
				 	SetPlayerChatBubble(playerid, szString, COLOR_PURPLE, 30.0, 6000);
				 	SendClientMessage(playerid, COLOR_PURPLE, szString);

					GivePlayerWeaponEx(playerid, weaponid, ammo);
				    return 1;
				}
				return SendClientMessageEx(playerid, -1, "อาวุธไอดี: %d - %s ได้ใช้ช่องอยู่ในปัจจุบัน", weapontaken, ReturnWeaponName(weapontaken));
			}
			else {
			    return SendClientMessage(playerid, COLOR_LIGHTRED,"ขออภัย ไม่พบอาวุธชนิดนี้");
			}
		}*/
		if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			foreach(new i : Iter_PlayerCar) if (IsPlayerNearBoot(playerid, playerCarData[i][carVehicle])) if(GetTrunkStatus(playerCarData[i][carVehicle]) || IsVehicleTrunkBroken(playerCarData[i][carVehicle]))
			{
				new slot;

				if (sscanf(params, "d", slot))
				    return SendClientMessage(playerid, COLOR_WHITE, "/takegun slot_id (ไอดีในรายการ /check)");

				if (!GetEngineStatus(playerCarData[i][carVehicle]))
				    return SendClientMessage(playerid, COLOR_LIGHTRED, "Error: สตาร์ทเครื่องยนต์");

                slot--;

				if(slot >= 0 && slot < MAX_CAR_WEAPONS && playerCarData[i][carWeapon][slot])
				{
					new weapontaken=0;
					if((weapontaken = ExistWeaponSlot(playerid,playerCarData[i][carWeapon][slot])) != 0) {
						SendClientMessageEx(playerid, -1, "อาวุธไอดี: %d - %s ได้ใช้ช่องอยู่ในปัจจุบัน", weapontaken, ReturnWeaponName(weapontaken));
					    return 1;
					}
					
					//DestroyDynamicObject(CarPlace[i][slot][cPobj]);

					format(szString, sizeof(szString), "* %s ได้หยิบ %s ออกมาจาก %s", ReturnRealName(playerid), ReturnWeaponName(playerCarData[i][carWeapon][slot]), g_arrVehicleNames[playerCarData[i][carModel] - 400]);
					SetPlayerChatBubble(playerid, szString, COLOR_PURPLE, 30.0, 6000);
					SendClientMessage(playerid, COLOR_PURPLE, szString);

					GivePlayerValidWeapon(playerid, playerCarData[i][carWeapon][slot], playerCarData[i][carAmmo][slot], 0);

					playerCarData[i][carWeapon][slot]=0;
					playerCarData[i][carAmmo][slot]=0;
				}
				else return SendClientMessage(playerid, COLOR_LIGHTRED,"ไม่มีอะไรอยู่ที่นั้น..");

				success = true;
				break;
			}
			if(!success)
			{
				SendClientMessage(playerid, COLOR_LIGHTRED,"ไม่มีอะไรอยู่ที่นั้น..");
			}
		}
		else if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new i = -1;

			if((i = PlayerCar_GetID(GetPlayerVehicleID(playerid))) != -1) {

				new slot;

				if (sscanf(params, "d", slot))
				    return SendClientMessage(playerid, COLOR_WHITE, "/takegun slot_id (ไอดีในรายการ /check)");

				if (!GetEngineStatus(playerCarData[i][carVehicle]))
				    return SendClientMessage(playerid, COLOR_LIGHTRED, "Error: สตาร์ทเครื่องยนต์");

                slot--;
				if(slot >= 0 && slot < MAX_CAR_WEAPONS && playerCarData[i][carWeapon][slot])
				{
					if (!IsDoorVehicle(playerCarData[i][carVehicle]))
					{
						new weapontaken=0;
						if((weapontaken = ExistWeaponSlot(playerid,playerCarData[i][carWeapon][slot])) != 0) {
							SendClientMessageEx(playerid, -1, "อาวุธไอดี: %d - %s ได้ใช้ช่องอยู่ในปัจจุบัน", weapontaken, ReturnWeaponName(weapontaken));
						    return 1;
						}
					    //DestroyDynamicObject(CarPlace[i][slot][cPobj]);

						format(szString, sizeof(szString), "* %s ได้หยิบ %s ออกมาจาก %s", ReturnRealName(playerid), ReturnWeaponName(playerCarData[i][carWeapon][slot]), g_arrVehicleNames[playerCarData[i][carModel] - 400]);
					 	SetPlayerChatBubble(playerid, szString, COLOR_PURPLE, 30.0, 6000);
					 	SendClientMessage(playerid, COLOR_PURPLE, szString);
						GivePlayerValidWeapon(playerid, playerCarData[i][carWeapon][slot], playerCarData[i][carAmmo][slot], 0);

						playerCarData[i][carWeapon][slot]=0;
						playerCarData[i][carAmmo][slot]=0;

						//Car_SavePlace(i);
					}
					else return SendClientMessage(playerid, COLOR_LIGHTRED," ..คุณไม่ได้อยู่ใกล้อาวุธ! ต้องใกล้กว่านี้");
				}
				else return SendClientMessage(playerid, COLOR_LIGHTRED,"ไม่มีอะไรอยู่ที่นั้น..");

				success = true;
			}
			if(!success)
			{
				SendClientMessage(playerid, COLOR_LIGHTRED,"ไม่มีอะไรอยู่ที่นั้น..");
			}
		}
	}
	return 1;
}

CMD:place(playerid, params[])
{
    if(playerData[playerid][pLevel] < 2)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเลเวล 2 ขึ้นไป");

	new bool:success;
	new house = insideHouseID[playerid];

	if (IsHouseOwner(playerid, house)) {		
		if (IsPlayerInRangeOfPoint(playerid, 1.5, houseData[house][hCheckPosX], houseData[house][hCheckPosY], houseData[house][hCheckPosZ])) {
	
			new weaponid;
	
			if (sscanf(params, "d", weaponid) || !weaponid)
				return SendClientMessage(playerid, COLOR_WHITE, "/place weapon_id (ไอดีในรายการ /weapons)");
	
	
			if (playerData[playerid][pGun1] == weaponid || playerData[playerid][pGun2] == weaponid || playerData[playerid][pGun3] == weaponid) {
	
				new ammo, slot = -1;
	
				for(new x = 0; x != MAX_HOUSE_WEAPONS; x++) {
					if(!houseData[house][hWeapon][x]) {
					
						if(playerData[playerid][pGun1] == weaponid)
						{
							ammo = playerData[playerid][pAmmo1];
	
							playerData[playerid][pGun1]=0;
							playerData[playerid][pAmmo1]=0;
						}
						else if(playerData[playerid][pGun2] == weaponid)
						{
							ammo = playerData[playerid][pAmmo2];
							//license = playerData[playerid][pPLicense];
							playerData[playerid][pGun2]=0;
							playerData[playerid][pAmmo2]=0;
							//playerData[playerid][pPLicense]=0;
						}
						else
						{
							ammo = playerData[playerid][pAmmo3];
							//license = playerData[playerid][pSLicense];
							playerData[playerid][pGun3]=0;
							playerData[playerid][pAmmo3]=0;
							//playerData[playerid][pSLicense]=0;
						}
						new temp_holdweapon = GetPlayerWeapon(playerid);
						RemoveWeapon(playerid, weaponid);
						if(temp_holdweapon == weaponid) SetPlayerArmedWeapon(playerid, 0);
						else SetPlayerArmedWeapon(playerid, temp_holdweapon);
	
						houseData[house][hWeapon][x] = weaponid;
						houseData[house][hAmmo][x] = ammo;
						//houseData[id][hWeaponLicense][x]=license;
						slot=x;
						break;
					}
				}
				if(slot == -1) return SendClientMessage(playerid, COLOR_LIGHTRED,"ไม่มีที่ว่างเหลือในบ้านหลังนี้");
	
				House_SavePackage(house);
				House_Save(house);

				SendClientMessageEx(playerid, COLOR_YELLOW,"คุณได้เก็บ %s ไว้ในบ้าน", ReturnWeaponName(weaponid));
				SendClientMessage(playerid, COLOR_LIGHTRED,"/takegun เพื่อหยิบปืนจาก รถ/บ้าน");
	
			} else return SendClientMessage(playerid, COLOR_LIGHTRED,"ขออภัย เฉพาะอาวุธที่อยู่ใน /stats ของคุณเท่านั้น");
		} else return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่ตู้เซฟของบ้าน");
		return 1;
	}
	else
	{

		new vid = GetPlayerVehicleID(playerid);
		if(!vid) for(new i=0;i!=MAX_VEHICLES;i++) if(IsValidVehicle(i) && IsPlayerNearBoot(playerid, i) && (GetTrunkStatus(i) || IsVehicleTrunkBroken(i))) { vid = i; break; }

		if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			foreach(new i : Iter_PlayerCar) if (IsPlayerNearBoot(playerid, playerCarData[i][carVehicle])) if(GetTrunkStatus(playerCarData[i][carVehicle]) || IsVehicleTrunkBroken(playerCarData[i][carVehicle]))
			{
				new weaponid;

				if (sscanf(params, "d", weaponid) || !weaponid)
				    return SendClientMessage(playerid, COLOR_WHITE, "/place weapon_id (ไอดีในรายการ /weapons)");

				if (playerData[playerid][pGun1] == weaponid || playerData[playerid][pGun2] == weaponid || playerData[playerid][pGun3] == weaponid) {

					new ammo;


					if(!playerCarData[i][carWeapon][0])
					{
						if(playerData[playerid][pGun1] == weaponid)
						{
						    ammo = playerData[playerid][pAmmo1];
						    playerData[playerid][pGun1]=0;
						    playerData[playerid][pAmmo1]=0;
						}
						else if(playerData[playerid][pGun2] == weaponid)
						{
						    ammo = playerData[playerid][pAmmo2];
						    //license = playerData[playerid][pPLicense];
						    playerData[playerid][pGun2]=0;
						    playerData[playerid][pAmmo2]=0;
						    //playerData[playerid][pPLicense]=0;
						}
						else
						{
						    ammo = playerData[playerid][pAmmo3];
						    //license = playerData[playerid][pSLicense];
						    playerData[playerid][pGun3]=0;
						    playerData[playerid][pAmmo3]=0;
						    //playerData[playerid][pSLicense]=0;
						}
						new temp_holdweapon = GetPlayerWeapon(playerid);
						RemoveWeapon(playerid, weaponid);
						if(temp_holdweapon == weaponid) SetPlayerArmedWeapon(playerid, 0);
						else SetPlayerArmedWeapon(playerid, temp_holdweapon);

					    playerCarData[i][carWeapon][0] = weaponid;
					    playerCarData[i][carAmmo][0] = ammo;
					    //CarData[i][carWeaponLicense][0]=license;
					}
					else if(!playerCarData[i][carWeapon][1])
					{
						if(playerData[playerid][pGun1] == weaponid)
						{
						    ammo = playerData[playerid][pAmmo1];
						    playerData[playerid][pGun1]=0;
						    playerData[playerid][pAmmo1]=0;
						}
						else if(playerData[playerid][pGun2] == weaponid)
						{
						    ammo = playerData[playerid][pAmmo2];
						    //license = playerData[playerid][pPLicense];
						    playerData[playerid][pGun2]=0;
						    playerData[playerid][pAmmo2]=0;
						    //playerData[playerid][pPLicense]=0;
						}
						else
						{
						    ammo = playerData[playerid][pAmmo3];
						    //license = playerData[playerid][pSLicense];
						    playerData[playerid][pGun3]=0;
						    playerData[playerid][pAmmo3]=0;
						    //playerData[playerid][pSLicense]=0;
						}
						new temp_holdweapon = GetPlayerWeapon(playerid);
						RemoveWeapon(playerid, weaponid);
						if(temp_holdweapon == weaponid) SetPlayerArmedWeapon(playerid, 0);
						else SetPlayerArmedWeapon(playerid, temp_holdweapon);
						
					    playerCarData[i][carWeapon][1] = weaponid;
					    playerCarData[i][carAmmo][1] = ammo;
					    //CarData[i][carWeaponLicense][1]=license;
					}
					else if(!playerCarData[i][carWeapon][2])
					{
						if(playerData[playerid][pGun1] == weaponid)
						{
						    ammo = playerData[playerid][pAmmo1];
						    playerData[playerid][pGun1]=0;
						    playerData[playerid][pAmmo1]=0;
						}
						else if(playerData[playerid][pGun2] == weaponid)
						{
						    ammo = playerData[playerid][pAmmo2];
						    //license = playerData[playerid][pPLicense];
						    playerData[playerid][pGun2]=0;
						    playerData[playerid][pAmmo2]=0;
						   // playerData[playerid][pPLicense]=0;
						}
						else
						{
						    ammo = playerData[playerid][pAmmo3];
						    //license = playerData[playerid][pSLicense];
						    playerData[playerid][pGun3]=0;
						    playerData[playerid][pAmmo3]=0;
						    //playerData[playerid][pSLicense]=0;
						}
						new temp_holdweapon = GetPlayerWeapon(playerid);
						RemoveWeapon(playerid, weaponid);
						if(temp_holdweapon == weaponid) SetPlayerArmedWeapon(playerid, 0);
						else SetPlayerArmedWeapon(playerid, temp_holdweapon);
						
					    playerCarData[i][carWeapon][2] = weaponid;
					    playerCarData[i][carAmmo][2] = ammo;
					    //playerCarData[i][carWeaponLicense][2]=license;
					}
					else if(!playerCarData[i][carWeapon][3])
					{
						if(playerData[playerid][pGun1] == weaponid)
						{
						    ammo = playerData[playerid][pAmmo1];
						    playerData[playerid][pGun1]=0;
						    playerData[playerid][pAmmo1]=0;
						}
						else if(playerData[playerid][pGun2] == weaponid)
						{
						    ammo = playerData[playerid][pAmmo2];
						    //license = playerData[playerid][pPLicense];
						    playerData[playerid][pGun2]=0;
						    playerData[playerid][pAmmo2]=0;
						    //playerData[playerid][pPLicense]=0;
						}
						else
						{
						    ammo = playerData[playerid][pAmmo3];
						    //license = playerData[playerid][pSLicense];
						    playerData[playerid][pGun3]=0;
						    playerData[playerid][pAmmo3]=0;
						    //playerData[playerid][pSLicense]=0;
						}
						new temp_holdweapon = GetPlayerWeapon(playerid);
						RemoveWeapon(playerid, weaponid);
						if(temp_holdweapon == weaponid) SetPlayerArmedWeapon(playerid, 0);
						else SetPlayerArmedWeapon(playerid, temp_holdweapon);
						
                        playerCarData[i][carWeapon][3] = weaponid;
                        playerCarData[i][carAmmo][3] = ammo;
                        //playerCarData[i][carWeaponLicense][3]=license;
					}
					else return SendClientMessage(playerid, COLOR_LIGHTRED,"ไม่มีที่ว่างเหลือในรถคันนี้");

                    //SendClientMessage(playerid, COLOR_LIGHTRED,"[ ! ] "EMBED_WHITE"คุณสามารถก{FF6347}ด Spac"EMBED_WHITE"e และเลื่อนกล้องไปรอบ ๆ");
					SendClientMessageEx(playerid, COLOR_YELLOW,"คุณได้เก็บ %s ไว้ใน %s", ReturnWeaponName(weaponid), g_arrVehicleNames[playerCarData[i][carModel] - 400]);
                    SendClientMessage(playerid, COLOR_LIGHTRED,"/takegun เพื่อหยิบปืนจาก รถ/บ้าน");

					/*new
						Float:fX,
						Float:fY,
						Float:fZ,
						Float:vA,
						Float:finalx,
						Float:finaly,
						Float:finalz,
						Float:finalrz;

					GetVehicleBootInside(CarData[i][carVehicle], fX, fY, fZ);
					GetVehicleZAngle(CarData[i][carVehicle], vA);

					CarPlace[i][slot][cPobj] = CreateDynamicObject(GetGunObjectID(weaponid), fX, fY, fZ + 0.1, 90.0, 270, vA+135);

					GetVehicleAttachCroods(CarData[i][carVehicle], fX, fY, fZ + 0.1, vA+135, finalx, finaly, finalz, finalrz);

					CarPlace[i][slot][cPx]=finalx;
					CarPlace[i][slot][cPy]=finaly;
					CarPlace[i][slot][cPz]=finalz;
					CarPlace[i][slot][cPrx]=90.0;
					CarPlace[i][slot][cPry]=270.0;
					CarPlace[i][slot][cPrz]=finalrz;
					CarPlace[i][slot][cPType]=0;

						//TestObject[playerid] = CreateDynamicObject(326, fX, fY, fZ, -100.0, -45, vA+135);
					EditDynamicObject(playerid, CarPlace[i][slot][cPobj]);

					PlayerPlaceSlot[playerid]=slot;
					PlayerPlaceCar[playerid]=i;*/

				} else return SendClientMessage(playerid, COLOR_LIGHTRED,"ขออภัย เฉพาะอาวุธที่อยู่ใน /stats ของคุณเท่านั้น");

				success = true;
				break;
			}
			if(!success) return SendClientMessage(playerid, COLOR_LIGHTRED,"SERVER: คุณยืนด้วยเท้าและไม่ได้อยู่ใกล้จุดเปิดที่จัดเก็บของยานพาหนะ");
		}
		else if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new i = -1;

			if((i = PlayerCar_GetID(GetPlayerVehicleID(playerid))) != -1) {

				new weaponid;

				if (sscanf(params, "d", weaponid) || !weaponid)
				    return SendClientMessage(playerid, COLOR_WHITE, "/place weapon_id (ไอดีในรายการ /weapons)");

				if (playerData[playerid][pGun1] == weaponid || playerData[playerid][pGun2] == weaponid || playerData[playerid][pGun3] == weaponid) {

					new ammo;

					if(!playerCarData[i][carWeapon][0])
					{
						if(playerData[playerid][pGun1] == weaponid)
						{
						    ammo = playerData[playerid][pAmmo1];
						    playerData[playerid][pGun1]=0;
						    playerData[playerid][pAmmo1]=0;
						}
						else if(playerData[playerid][pGun2] == weaponid)
						{
						    ammo = playerData[playerid][pAmmo2];
	                        //license = playerData[playerid][pPLicense];
						    playerData[playerid][pGun2]=0;
						    playerData[playerid][pAmmo2]=0;
						    //playerData[playerid][pPLicense]=0;
						}
						else
						{
						    ammo = playerData[playerid][pAmmo3];
						   // license = playerData[playerid][pSLicense];
						    playerData[playerid][pGun3]=0;
						    playerData[playerid][pAmmo3]=0;
						    //playerData[playerid][pSLicense]=0;
						}
						new temp_holdweapon = GetPlayerWeapon(playerid);
						RemoveWeapon(playerid, weaponid);
						if(temp_holdweapon == weaponid) SetPlayerArmedWeapon(playerid, 0);
						else SetPlayerArmedWeapon(playerid, temp_holdweapon);

					    playerCarData[i][carWeapon][0] = weaponid;
					    playerCarData[i][carAmmo][0] = ammo;
					    //playerCarData[i][carWeaponLicense][0]=license;
					}
					else if(!playerCarData[i][carWeapon][1])
					{
						if(playerData[playerid][pGun1] == weaponid)
						{
						    ammo = playerData[playerid][pAmmo1];
						    playerData[playerid][pGun1]=0;
						    playerData[playerid][pAmmo1]=0;
						}
						else if(playerData[playerid][pGun2] == weaponid)
						{
						    ammo = playerData[playerid][pAmmo2];
	                        //license = playerData[playerid][pPLicense];
						    playerData[playerid][pGun2]=0;
						    playerData[playerid][pAmmo2]=0;
						   // playerData[playerid][pPLicense]=0;
						}
						else
						{
						    ammo = playerData[playerid][pAmmo3];
						    //license = playerData[playerid][pSLicense];
						    playerData[playerid][pGun3]=0;
						    playerData[playerid][pAmmo3]=0;
						    //playerData[playerid][pSLicense]=0;
						}
						new temp_holdweapon = GetPlayerWeapon(playerid);
						RemoveWeapon(playerid, weaponid);
						if(temp_holdweapon == weaponid) SetPlayerArmedWeapon(playerid, 0);
						else SetPlayerArmedWeapon(playerid, temp_holdweapon);
						
					    playerCarData[i][carWeapon][1] = weaponid;
					    playerCarData[i][carAmmo][1] = ammo;
					    //playerCarData[i][carWeaponLicense][1]=license;
					}
					else if(!playerCarData[i][carWeapon][2])
					{
						if(playerData[playerid][pGun1] == weaponid)
						{
						    ammo = playerData[playerid][pAmmo1];
						    playerData[playerid][pGun1]=0;
						    playerData[playerid][pAmmo1]=0;
						}
						else if(playerData[playerid][pGun2] == weaponid)
						{
						    ammo = playerData[playerid][pAmmo2];
	                        //license = playerData[playerid][pPLicense];
						    playerData[playerid][pGun2]=0;
						    playerData[playerid][pAmmo2]=0;
						    //playerData[playerid][pPLicense]=0;
						}
						else
						{
						    ammo = playerData[playerid][pAmmo3];
						    //license = playerData[playerid][pSLicense];
						    playerData[playerid][pGun3]=0;
						    playerData[playerid][pAmmo3]=0;
						    //playerData[playerid][pSLicense]=0;
						}
						new temp_holdweapon = GetPlayerWeapon(playerid);
						RemoveWeapon(playerid, weaponid);
						if(temp_holdweapon == weaponid) SetPlayerArmedWeapon(playerid, 0);
						else SetPlayerArmedWeapon(playerid, temp_holdweapon);
						
					    playerCarData[i][carWeapon][2] = weaponid;
					    playerCarData[i][carAmmo][2] = ammo;
					    //playerCarData[i][carWeaponLicense][2]=license;
					}
					else if(!playerCarData[i][carWeapon][3])
					{
						if(playerData[playerid][pGun1] == weaponid)
						{
						    ammo = playerData[playerid][pAmmo1];
						    playerData[playerid][pGun1]=0;
						    playerData[playerid][pAmmo1]=0;
						}
						else if(playerData[playerid][pGun2] == weaponid)
						{
						    ammo = playerData[playerid][pAmmo2];
	                        //license = playerData[playerid][pPLicense];
						    playerData[playerid][pGun2]=0;
						    playerData[playerid][pAmmo2]=0;
						    //playerData[playerid][pPLicense]=0;
						}
						else
						{
						    ammo = playerData[playerid][pAmmo3];
						    //license = playerData[playerid][pSLicense];
						    playerData[playerid][pGun3]=0;
						    playerData[playerid][pAmmo3]=0;
						    //playerData[playerid][pSLicense]=0;
						}
						new temp_holdweapon = GetPlayerWeapon(playerid);
						RemoveWeapon(playerid, weaponid);
						if(temp_holdweapon == weaponid) SetPlayerArmedWeapon(playerid, 0);
						else SetPlayerArmedWeapon(playerid, temp_holdweapon);
						
                        playerCarData[i][carWeapon][3] = weaponid;
                        playerCarData[i][carAmmo][3] = ammo;
                        //playerCarData[i][carWeaponLicense][3]=license;
					}
					else return SendClientMessage(playerid, COLOR_LIGHTRED,"ไม่มีที่ว่างเหลือในรถคันนี้");

					SendClientMessageEx(playerid, COLOR_YELLOW,"คุณได้เก็บ %s ไว้ใน %s", ReturnWeaponName(weaponid), g_arrVehicleNames[playerCarData[i][carModel] - 400]);
                    SendClientMessage(playerid, COLOR_LIGHTRED,"/takegun เพื่อหยิบปืนจาก รถ/บ้าน");

					TogglePlayerControllable(playerid, 1);

					/*new
						Float:fX,
						Float:fY,
						Float:fZ,
						Float:vA,
						Float:finalx,
						Float:finaly,
						Float:finalz,
						Float:finalrz;

					GetVehicleInside(CarData[i][carVehicle], fX, fY, fZ);
					GetVehicleZAngle(CarData[i][carVehicle], vA);

					CarPlace[i][slot][cPobj] = CreateDynamicObject(GetGunObjectID(weaponid), fX, fY, fZ, -100.0, -45, vA+135);

					GetVehicleAttachCroods(CarData[i][carVehicle], fX, fY, fZ, vA+135, finalx, finaly, finalz, finalrz);

					CarPlace[i][slot][cPx]=finalx;
					CarPlace[i][slot][cPy]=finaly;
					CarPlace[i][slot][cPz]=finalz;
					CarPlace[i][slot][cPrx]=-100.0;
					CarPlace[i][slot][cPry]=-45.0;
					CarPlace[i][slot][cPrz]=finalrz;
					CarPlace[i][slot][cPType]=1;

					EditDynamicObject(playerid, CarPlace[i][slot][cPobj]);

					PlayerPlaceSlot[playerid]=slot;
					PlayerPlaceCar[playerid]=i;*/

				} else return SendClientMessage(playerid, COLOR_LIGHTRED,"ขออภัย เฉพาะอาวุธที่อยู่ใน /stats ของคุณเท่านั้น");

				success = true;
			}
			if(!success)
			{
				SendClientMessage(playerid, COLOR_LIGHTRED,"ไม่พบยานพาหนะที่สามารถเก็บอาวุธได้...");
			}
		}
		else {
		    if(!success) SendClientMessage(playerid, COLOR_LIGHTRED,"ไม่พบยานพาหนะที่สามารถเก็บอาวุธได้...");
		}
	}
	return 1;
}

hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if(!playerData[playerid][pOnDuty])
    {
	    if(playerData[playerid][pGun1] == weaponid)
		{
			if(playerData[playerid][pAmmo][g_aWeaponSlots[weaponid]] <= playerData[playerid][pAmmo1])
				playerData[playerid][pAmmo1]--;

			if(!playerData[playerid][pAmmo1])
			{
			    playerData[playerid][pGun1] = 0;
			    playerData[playerid][pAmmo1] = 0;
			}
		}
	    else if(playerData[playerid][pGun2] == weaponid)
		{
		    if(playerData[playerid][pAmmo][g_aWeaponSlots[weaponid]] <= playerData[playerid][pAmmo2])
				playerData[playerid][pAmmo2]--;

	 		if(!playerData[playerid][pAmmo2])
			{
			    playerData[playerid][pGun2] = 0;
			    playerData[playerid][pAmmo2] = 0;
			    //playerData[playerid][pPLicense] = 0;
			}
		}
	    else if(playerData[playerid][pGun3] == weaponid)
		{
		    if(playerData[playerid][pAmmo][g_aWeaponSlots[weaponid]] <= playerData[playerid][pAmmo3])
				playerData[playerid][pAmmo3]--;

			if(!playerData[playerid][pAmmo3])
			{
			    playerData[playerid][pGun3] = 0;
			    playerData[playerid][pAmmo3] = 0;
			    //playerData[playerid][pSLicense] = 0;
			}
		}
	}

	if((BeanbagActive{playerid} == true && weaponid == 25) || (TazerActive{playerid} == true && weaponid == 23))
	{
		if(weaponid == 23) {
			if( GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK ) ApplyAnimation(playerid, "COLT45", "colt45_reload", 4.0, 0, 0, 0, 0, 0, 1);
			else ApplyAnimation(playerid, "COLT45", "colt45_crouchreload", 4.0, 0, 1, 1, 0, 0, 1);
		}
		else if(weaponid == 25) {
			if( GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK ) ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.0, 0, 0, 0, 0, 0, 1);
			else ApplyAnimation(playerid, "BUDDY", "buddy_crouchreload", 4.0, 0, 1, 1, 0, 0, 1);
		}
	}
	else playerData[playerid][pAmmo][g_aWeaponSlots[weaponid]]--;

    if(!playerData[playerid][pAmmo][g_aWeaponSlots[weaponid]])
    {
        playerData[playerid][pGuns][g_aWeaponSlots[weaponid]] = 0;
        playerData[playerid][pAmmo][g_aWeaponSlots[weaponid]] = 0;

        //cl_DressHoldWeapon(playerid, GetPlayerWeapon(playerid));
    }
	return 1;
}

CMD:check(playerid, params[])
{
    if(playerData[playerid][pLevel] < 2)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเลเวล 2 ขึ้นไป");

	new bool:success;

	new house = insideHouseID[playerid];

	if (IsHouseOwner(playerid, house)) {
		if (IsPlayerInRangeOfPoint(playerid, 1.5, houseData[house][hCheckPosX], houseData[house][hCheckPosY], houseData[house][hCheckPosZ])) {
	
			new string[512];
	
			for(new x = 0; x != MAX_HOUSE_WEAPONS; x++) {
				if(houseData[house][hWeapon][x] != 0) {
					if(IsMelee(houseData[house][hWeapon][x])) {
						format(string, sizeof(string), "%s(%d)%s\n", string, x+1, ReturnWeaponName(houseData[house][hWeapon][x]));
					}
					else format(string, sizeof(string), "%s(%d)%s[Ammo:%d]\n", string, x+1, ReturnWeaponName(houseData[house][hWeapon][x]), houseData[house][hAmmo][x]);
				}
				else format(string, sizeof(string), "%s[EMPTY]\n", string);
			}
			Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_LIST, "Weapon Storage", string, "ตกลง", "");
			success = true;
			return 1;
		}
		else return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่ตู้เซฟของบ้าน");
	}
	else
	{
		foreach(new i : Iter_PlayerCar)
		{
			if (IsPlayerNearBoot(playerid, playerCarData[i][carVehicle])) if(GetTrunkStatus(playerCarData[i][carVehicle]) || IsVehicleTrunkBroken(playerCarData[i][carVehicle]))
		    {
		        new string[128];

				for(new x = 0; x != MAX_CAR_WEAPONS; x++) {
				   	if(playerCarData[i][carWeapon][x] != 0) {
				 		if(IsMelee(playerCarData[i][carWeapon][x])) {
							format(string, sizeof(string), "%s(%d)%s\n", string, x+1, ReturnWeaponName(playerCarData[i][carWeapon][x]));
						}
						else format(string, sizeof(string), "%s(%d)%s[Ammo:%d]\n", string, x+1, ReturnWeaponName(playerCarData[i][carWeapon][x]), playerCarData[i][carAmmo][x]);
					}
					else format(string, sizeof(string), "%s[EMPTY]\n", string);
				}
		        Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_LIST, "Weapon Storage", string, "ตกลง", "");
	            success = true;
				return 1;
			}
			else return SendClientMessage(playerid, COLOR_LIGHTRED,"SERVER: คุณไม่ได้อยู่ใกล้ที่จัดเก็บของยานพาหนะ");
		}
	}
	if(!success) SendClientMessage(playerid, COLOR_LIGHTRED,"SERVER: ขออภัย คุณจำเป็นต้องอยู่ตรงจุดสำหรับจัดเก็บของยานพาหนะ");
	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
	
	new szMessage[128];

	if(killerid != INVALID_PLAYER_ID)
	{
		format(szMessage, sizeof(szMessage), "AdmCmd : %s(ID:%d) ถูกฆ่าโดย %s(ID:%d) เป็นการตายด้วย : %s", ReturnPlayerName(playerid), playerid, ReturnPlayerName(killerid), killerid, GetDeathReason(killerid, reason));
		SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, szMessage);
	}
}

CMD:tazer2(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);

	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่ตำรวจเท่านั้น !");
	
	if(playerData[playerid][pOnDuty] == 0) 
		return SendClientMessage(playerid, COLOR_GRAD1,"   คุณยังไม่ได้เริ่มปฏิบัติหน้าที่");

	if(TazerActive{playerid})
	{
		TazerActive{playerid} = false;
		RemoveWeapon(playerid, 23);
		if(GetPVarInt(playerid, "WeaponSlot2")) GivePlayerWeaponEx(playerid, 24, GetPVarInt(playerid, "WeaponSlot2"));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "** %s เก็บปืนไฟฟ้าเทเซอร์ของเขาเข้าไปในซองหนัง", ReturnPlayerName(playerid));
		DeletePVar(playerid, "WeaponSlot2");
	}
	else
	{
		TazerActive{playerid} = true;
		if(playerData[playerid][pAmmo][2]) {
			SetPVarInt(playerid, "WeaponSlot2", playerData[playerid][pAmmo][2]);
		}
		GivePlayerWeaponEx(playerid, 23, 999999);
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "** %s คว้าปืนไฟฟ้าเทเซอร์ออกมาจากซองหนัง", ReturnPlayerName(playerid));
	}
	return 1;
}

CMD:rubberbullets(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);

	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่ตำรวจเท่านั้น !");
	
	if(playerData[playerid][pOnDuty] == 0) 
		return SendClientMessage(playerid, COLOR_GRAD1,"   คุณยังไม่ได้เริ่มปฏิบัติหน้าที่");

	if(BeanbagActive{playerid})
	{
		BeanbagActive{playerid} = false;
		SetPlayerArmedWeapon(playerid, 0);
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "** %s เก็บเรมิงตันไว้ด้านหลังของเขา", ReturnPlayerName(playerid));
	}
	else if(GetPlayerWeapon(playerid) == 25)
	{
		BeanbagActive{playerid} = true;
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "** %s คว้าเรมิงตัน 870 พร้อมบรรจุกระสุนยาง", ReturnPlayerName(playerid));
		SendClientMessage(playerid, COLOR_YELLOW,"SERVER: คุณเปลี่ยนเป็นกระสุนยางแล้ว");
	}
	else return SendClientMessage(playerid, COLOR_GREY, "คุณจำเป็นต้องมี Remington 870 ในมือเพื่อให้ได้ใช้กระสุนยาง");

	return 1;
}

hook OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
	// Carjack damage
	if (weaponid == 54 && _:amount == _:0.0) {
		return 0;
	}

	if(issuerid != INVALID_PLAYER_ID)
	{
		if((TazerActive{issuerid} == true && weaponid == 23) || (BeanbagActive{issuerid} == true && weaponid == 25)) {

			if(weaponid == 23)
			{
				if(!BitFlag_Get(gPlayerBitFlag[playerid], IS_PLAYER_TAZER))
				{
					ApplyAnimation(playerid, "CRACK", "crckidle2", 4.0, 0, 0, 1, 1, 0, 1);
					SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "** %s ถูกยิงโดยปืนไฟฟ้าและล้มลงกับพื้น", ReturnRealName(playerid));
					TogglePlayerControllable(playerid, false);
					BitFlag_On(gPlayerBitFlag[playerid], IS_PLAYER_TAZER);
					TazerCount[playerid]=10;
					SetTimerEx("SetUnTazed", 10000, 0, "i", playerid);
					SetPlayerDrunkLevel(playerid, 4000);

					GivePlayerHealth(playerid, amount);
				}
				else
				{
					SendClientMessage(issuerid, COLOR_GREY, "ผู้เล่นนี้ได้ถูกไฟฟ้าดูดแล้ว");
				}
			}

		    if(weaponid == 25)
			{
				if(!BitFlag_Get(gPlayerBitFlag[playerid], IS_PLAYER_TAZER))
				{
					ApplyAnimation(playerid, "CRACK", "crckidle2", 4.0, 0, 0, 1, 1, 0, 1);
					SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "** %s ถูกยิงโดยเรมิงตันและล้มลงกับพื้น", ReturnRealName(playerid));
		      		SendClientMessageEx(issuerid, COLOR_YELLOW, "SERVER: คุณยิง %s ด้วยกระสุนยาง", ReturnRealName(playerid));
					TogglePlayerControllable(playerid, false);
					BitFlag_On(gPlayerBitFlag[playerid], IS_PLAYER_TAZER);
					TazerCount[playerid]=10;
					SetTimerEx("SetUnTazed", 10000, 0, "i", playerid);
					SetPlayerDrunkLevel(playerid, 4000);

					GivePlayerHealth(playerid, amount);
				}
				else
				{
					SendClientMessage(issuerid, COLOR_GREY, "ผู้เล่นนี้ได้ถูกไฟฟ้าดูดแล้ว");
				}
			}
			return 0;
		}
	}
	return 1;
}

ptask PlayerTimers[1000](playerid) {
	if(TazerCount[playerid]) {
		TazerCount[playerid]--;
		if(TazerCount[playerid] <= 0) {
			TazerCount[playerid]=0;
			ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
			BitFlag_Off(gPlayerBitFlag[playerid], IS_PLAYER_TAZER);
			TogglePlayerControllable(playerid, true);
		}
	}
}


stock GetDeathReason(killerid, reason)
{
	new Message[32];
	if(killerid != INVALID_PLAYER_ID)
	{
		switch(reason)
		{
			case 0: Message = "มือ";

			case 1:
   			{
				/*if(playerData[killerid][pAdmin] < 5 && playerData[killerid][pPlayingHours] < 10) 
				{
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "สนับมือ";
			}

			case 2:
			{
				/*if(playerData[killerid][pAdmin] < 5 && playerData[killerid][pPlayingHours] < 10) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "ไม้กอล์ฟ";
			}

			case 3:
			{
				/*if(playerData[killerid][pAdmin] < 5 && playerData[killerid][pPlayingHours] < 10) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "กระบอง";
			}

			case 4:
			{
				/*if(playerData[killerid][pAdmin] < 5 && playerData[killerid][pPlayingHours] < 10) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "มีด";
			}

			case 5:
			{
				/*if(playerData[killerid][pAdmin] < 5 && playerData[killerid][pPlayingHours] < 10) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "ไม้เบสบอล";
			}

			case 6:
			{
				/*if(playerData[killerid][pAdmin] < 5 && playerData[killerid][pPlayingHours] < 10) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "พลั่ว";
			}

			case 8:
			{
				/*if(playerData[killerid][pAdmin] < 5 && playerData[killerid][pPlayingHours] < 10) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "ดาบคาตะนะ";
			}

			case 9:
			{
				/*if(playerData[killerid][pAdmin] < 5 && playerData[killerid][pPlayingHours] < 10) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "เลื่อยยนต์";
			}

			case 10: Message = "ดิลโด้";
			case 11: Message = "ดิลโด้";
			case 12: Message = "Vibrator";
			case 13: Message = "Vibrator";
			case 14: Message = "ดอกไม้";

			case 15:
			{
				/*if(playerData[killerid][pAdmin] < 5 && playerData[killerid][pPlayingHours] < 10) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "ตะขอเหล็ก";
			}

			case 22:
			{
				/*if(playerData[killerid][pAdmin] < 5 && playerData[killerid][pPlayingHours] < 10) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "ปืนสั้น 9มม.";
			}

			case 23:
			{
				/*if(playerData[killerid][pAdmin] < 5 && playerData[killerid][pPlayingHours] < 10) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "ปืนสั้นเก็บเสียง";
			}

			case 24:
			{
				/*if(playerData[killerid][pAdmin] < 5 && playerData[killerid][pPlayingHours] < 10) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "ปืนดีเสิร์ทอีเกิล";
			}

			case 25:
			{
				/*if(playerData[killerid][pAdmin] < 5 && playerData[killerid][pPlayingHours] < 10) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "ปืนลูกซอง";
			}

			/*case 26:
			{
				if(playerData[killerid][pAdmin] < 5) {
    				scriptBan(killerid, "Weapon Hacking (Sawnoff Shotgun)");
				}
				Message = "ปืนลูกซองคู่";
			}
			case 27:
			{
				if(playerData[killerid][pAdmin] < 5) {
					if(groupVariables[playerData[killerid][pGroup]][gGroupType] != 1) {
						scriptBan(killerid, "Weapon Hacking (Combat Shotgun)");
    				}
				}
				Message = "ปืนลูกซองคอมแบท";
			}*/

			case 28:
			{
				/*if(playerData[killerid][pAdmin] < 5) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "UZI";
			}
			case 29:
			{
				/*if(playerData[killerid][pAdmin] < 5) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "MP5";
			}
			case 30:
			{
				/*if(playerData[killerid][pAdmin] < 5 && playerData[killerid][pPlayingHours] < 10) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "AK-47";
			}
			case 31:
			{
				if(GetPlayerState(killerid) == PLAYER_STATE_DRIVER)
				{
					switch(GetVehicleModel(GetPlayerVehicleID(killerid)))
					{
						case 447: Message = "ปืนกลจากเฮลิคอปเตอร์";
						default:
						{
							/*if(playerData[killerid][pAdmin] < 5) {
								foreach(new i : Player) {
									PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
								}

								SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
								Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

								new insertLog[256];
								
								mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
									playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
								
								mysql_tquery(dbCon, insertLog); 
								
								mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
									playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
									
								mysql_tquery(dbCon, insertLog); 
								KickEx(killerid);
							}*/
		    				Message = "M4";
						}
					}
				}
				else
				{
				    /*if(playerData[killerid][pAdmin] < 5) {
						foreach(new i : Player) {
							PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
						}

						SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
						Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

						new insertLog[256];
						
						mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
							playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
						
						mysql_tquery(dbCon, insertLog); 
						
						mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
							playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
							
						mysql_tquery(dbCon, insertLog); 
						KickEx(killerid);
					}*/
					Message = "M4";
				}
			}
			case 32:
			{
				/*if(playerData[killerid][pAdmin] < 5 && playerData[killerid][pPlayingHours] < 10) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "TEC-9";
			}

			case 33:
			{
			    /*if(playerData[killerid][pAdmin] < 5 && playerData[killerid][pPlayingHours] < 10) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}	*/			
				Message = "ปืนไรเฟิล";
			}
			case 34:
			{
			    /*if(playerData[killerid][pAdmin] < 5) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "ปืนสไนท์เปอร์ไรเฟิล";
			}

			case 37:
			{
				Message = "เครื่องพ่นไฟ";
			}

			case 38:
			{
				/*if(playerData[killerid][pAdmin] < 5) {
					foreach(new i : Player) {
						PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
					}

					SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking", ReturnPlayerName(killerid));
					Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking", ReturnPlayerName(killerid));

					new insertLog[256];
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking', '%e', '%e', 'System')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate(), ReturnIP(killerid));
					
					mysql_tquery(dbCon, insertLog); 
					
					mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking, 'System', '%e')",
						playerData[killerid][pSID], ReturnPlayerName(killerid), ReturnDate());
						
					mysql_tquery(dbCon, insertLog); 
					KickEx(killerid);
				}*/
				Message = "Minigun";		
			}

			case 41: Message = "กระป๋องสเปรย์";
			case 42: Message = "ถังดับเพลิง";
			case 49: Message = "ยานพานะชน";

			case 50:
			{
				if(GetPlayerState(killerid) == PLAYER_STATE_DRIVER)
				{
					switch(GetVehicleModel(GetPlayerVehicleID(killerid)))
					{
						case 417, 425, 447, 465, 469, 487, 488, 497, 501, 548, 563: Message = "ใบพัดเฮลิคอปเตอร์ตัด";
						default: Message = "ยานพานะชน";
					}
				}
				else Message = "ยานพานะชน";
			}
			case 255: Message = "รถระเบิด";
			default: Message = "ไม่ทราบสาเหตุที่แน่ชัด";
		}
	}
	if(killerid == INVALID_PLAYER_ID)
	{
		switch (reason)
		{
			case 53: Message = "จมน้ำ";
			case 54: Message = "เสียชีวิตเอง";
			default: Message = "เสียชีวิตเอง";
		}
	}
	return Message;
}

forward SetUnTazer(playerid);
public SetUnTazer(playerid)
{
	TazerCount[playerid]=0;
    ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
    BitFlag_Off(gPlayerBitFlag[playerid], IS_PLAYER_TAZER);
	SetPlayerDrunkLevel(playerid, 1000);
	TogglePlayerControllable(playerid, true);
	return 1;
}

CMD:buywp(playerid, params[])
{
    new weapon;

	if (!IsPlayerInRangeOfPoint(playerid, 3.0, 2442.4063,-1980.9146,13.5469))
	    return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ตลาดมืด");

	if (sscanf(params, "d", weapon))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /buywp [อาวุธที่คุณต้องการซื้อ]");
		SendClientMessage(playerid, COLOR_GRAD4, "|1 Brass Knuckles $150,000 |2 Golf Club $180,000 |3 Knife $400,000 |4 Baseball Bat $200,000 |5 Shovel $200,000");
		SendClientMessage(playerid, COLOR_GRAD4, "|6 Pool Cue $200,000 |7 Katana $500,000 |8 Purple Dildo $50,000 |9 Dildo $50,000 |10 Vibrator $50,000");
		SendClientMessage(playerid, COLOR_GRAD4, "|11 Silver Vibrator $50,000 |12 Flowers $50,000 |13 Cane $200,000");
		return 1;
	}

	switch (weapon)
	{
		case 1: 
		{
			if (playerData[playerid][pRMoney] < 150000)
				return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่เพียงพอ");

			GivePlayerValidWeapon(playerid, 1, 1);
			playerData[playerid][pRMoney] -= 150000;
            //GivePlayerMoneyEx(playerid, -5000);
			OnAccountUpdate(playerid);

            SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้ซื้ออาวุธ Brass Knuckles จากตลาดมืด, เป็นจำนวนเงิน $200,000");
		}
		case 2: 
		{
			if (playerData[playerid][pRMoney] < 180000)
				return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่เพียงพอ");

            GivePlayerValidWeapon(playerid, 2, 1);
			playerData[playerid][pRMoney] -= 180000;
            //GivePlayerMoneyEx(playerid, -6000);
			OnAccountUpdate(playerid);

            SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้ซื้ออาวุธ Golf Club จากตลาดมืด, เป็นจำนวนเงิน $200,000");
		}
		case 3: 
		{
			if (playerData[playerid][pRMoney] < 400000)
				return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่เพียงพอ");

            GivePlayerValidWeapon(playerid, 4, 1);
			playerData[playerid][pRMoney] -= 400000;
            //GivePlayerMoneyEx(playerid, -50000);
			OnAccountUpdate(playerid);

            SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้ซื้ออาวุธ Knife จากตลาดมืด, เป็นจำนวนเงิน $200,000");
		}
		case 4: 
		{
			if (playerData[playerid][pRMoney] < 200000)
				return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่เพียงพอ");

            GivePlayerValidWeapon(playerid, 5, 1);
			playerData[playerid][pRMoney] -= 200000;
            //GivePlayerMoneyEx(playerid, -20000);
			OnAccountUpdate(playerid);

            SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้ซื้ออาวุธ Baseball Bat จากตลาดมืด, เป็นจำนวนเงิน $200,000");
		}
		case 5: 
		{
			if (playerData[playerid][pRMoney] < 200000)
				return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่เพียงพอ");

            GivePlayerValidWeapon(playerid, 6, 1);
			playerData[playerid][pRMoney] -= 200000;
            //GivePlayerMoneyEx(playerid, -10000);
			OnAccountUpdate(playerid);

            SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้ซื้ออาวุธ Shovel จากตลาดมืด, เป็นจำนวนเงิน $200,000");
		}
		case 6: 
		{
			if (playerData[playerid][pRMoney] < 200000)
				return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่เพียงพอ");

            GivePlayerValidWeapon(playerid, 7, 1);
			playerData[playerid][pRMoney] -= 200000;
            //GivePlayerMoneyEx(playerid, -15000);
			OnAccountUpdate(playerid);

            SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้ซื้ออาวุธ Pool Cue จากตลาดมืด, เป็นจำนวนเงิน $200,000");
		}
		case 7:
		{
			if (playerData[playerid][pRMoney] < 500000)
				return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่เพียงพอ");

            GivePlayerValidWeapon(playerid, 8, 1);
			playerData[playerid][pRMoney] -= 500000;
            //GivePlayerMoneyEx(playerid, -80000);
			OnAccountUpdate(playerid);

            SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้ซื้ออาวุธ Katana จากตลาดมืด, เป็นจำนวนเงิน $500,000");
		}
		case 8: 
		{
			if (playerData[playerid][pRMoney] < 50000)
				return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่เพียงพอ");

            GivePlayerValidWeapon(playerid, 10, 1);
            //GivePlayerMoneyEx(playerid, -8000);
			playerData[playerid][pRMoney] -= 50000;
			OnAccountUpdate(playerid);

            SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้ซื้ออาวุธ Purple Dildo จากตลาดมืด, เป็นจำนวนเงิน $50,000");
		}
		case 9: 
		{
			if (playerData[playerid][pRMoney] < 50000)
				return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่เพียงพอ");

            GivePlayerValidWeapon(playerid, 11, 1);
            //GivePlayerMoneyEx(playerid, -8000);
			playerData[playerid][pRMoney] -= 50000;
			OnAccountUpdate(playerid);

            SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้ซื้ออาวุธ Dildo จากตลาดมืด, เป็นจำนวนเงิน $50,000");
		}
		case 10: 
		{
			if (playerData[playerid][pRMoney] < 50000)
				return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่เพียงพอ");

            GivePlayerValidWeapon(playerid, 12, 1);
            //GivePlayerMoneyEx(playerid, -8000);
			playerData[playerid][pRMoney] -= 50000;
			OnAccountUpdate(playerid);

            SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้ซื้ออาวุธ Vibrator จากตลาดมืด, เป็นจำนวนเงิน $50,000");
		}
		case 11: 
		{
			if (playerData[playerid][pRMoney] < 50000)
				return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่เพียงพอ");

            GivePlayerValidWeapon(playerid, 13, 1);
            //GivePlayerMoneyEx(playerid, -8000);
			playerData[playerid][pRMoney] -= 50000;
			OnAccountUpdate(playerid);

            SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้ซื้ออาวุธ Silver Vibrator จากตลาดมืด, เป็นจำนวนเงิน $50,000");
		}
		case 12: 
		{
			if (playerData[playerid][pRMoney] < 50000)
				return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่เพียงพอ");

            GivePlayerValidWeapon(playerid, 14, 1);
            //GivePlayerMoneyEx(playerid, -8000);
			playerData[playerid][pRMoney] -= 50000;
			OnAccountUpdate(playerid);

            SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้ซื้ออาวุธ Flowers จากตลาดมืด, เป็นจำนวนเงิน $50,000");
		}
		case 13: 
		{
			if (playerData[playerid][pRMoney] < 200000)
				return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่เพียงพอ");

            GivePlayerValidWeapon(playerid, 15, 1);
            //GivePlayerMoneyEx(playerid, -8000);
			playerData[playerid][pRMoney] -= 200000;
			OnAccountUpdate(playerid);

            SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้ซื้ออาวุธ Cane จากตลาดมืด, เป็นจำนวนเงิน $200,000");
		}
    }

	return 1;
}

ptask CheckWeaponHack[1000](playerid) 
{
	if (playerData[playerid][pPlayingHours] < 15) 
	{
		if(GetPlayerWeapon(playerid) == 1)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 2)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 3)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 4)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 5)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 6)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 7)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 8)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 9)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 10)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 11)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 12)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 13)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 14)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 15)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (อาวุธระยะประชิด)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (อาวุธระยะประชิด), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}
	}

	if (playerData[playerid][pPlayingHours] < 10) 
	{
		if(GetPlayerWeapon(playerid) == 16)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (Grenade)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (Grenade)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (Grenade)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (Grenade), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 18)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (Molotov Cocktail)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (Molotov Cocktail)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (Molotov Cocktail)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (Molotov Cocktail), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 22)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (9mm)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (9mm)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (9mm)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (9mm), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 23)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (Silenced 9mm)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (Silenced 9mm)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (Silenced 9mm)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (Silenced 9mm), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 24)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (Desert Eagle)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (Desert Eagle)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (Desert Eagle)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (Desert Eagle), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 25)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (Shotgun)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (Shotgun)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (Shotgun)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (Shotgun), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 26)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (Sawnoff Shotgun)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (Sawnoff Shotgun)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (Sawnoff Shotgun)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (Sawnoff Shotgun), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 27)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (Combat Shotgun)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (Combat Shotgun)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (Combat Shotgun)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (Combat Shotgun), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 28)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (Micro SMG/Uzi)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (Micro SMG/Uzi)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (Micro SMG/Uzi)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (Micro SMG/Uzi), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 29)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (MP5)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (MP5)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (MP5)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (MP5), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 30)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (AK-47)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (AK-47)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (AK-47)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (AK-47), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 31)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (M4)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (M4)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (M4)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (M4), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 32)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (Tec-9)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (Tec-9)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (Tec-9)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (Tec-9), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 33)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (Country Rifle)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (Country Rifle)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (Country Rifle)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (Country Rifle), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 34)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (Sniper Rifle)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (Sniper Rifle)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (Sniper Rifle)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (Sniper Rifle), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 35)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (RPG)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (RPG)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (RPG)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (RPG), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 36)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (HS Rocket)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (HS Rocket)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (HS Rocket)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (HS Rocket), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 37)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (Flamethrower)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (Flamethrower)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (Flamethrower)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (Flamethrower), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 38)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (Minigun)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (Minigun)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (Minigun)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (Minigun), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if(GetPlayerWeapon(playerid) == 39)
		{
			foreach(new i : Player) {
				PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
			}

			SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: Weapon Hacking (Satchel Charge)", ReturnPlayerName(playerid));
			Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ Weapon Hacking (Satchel Charge)", ReturnPlayerName(playerid));

			new insertLog[256];
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'Weapon Hacking (Satchel Charge)', '%e', '%e', 'System')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
			
			mysql_tquery(dbCon, insertLog); 
			
			mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'Weapon Hacking (Satchel Charge), 'System', '%e')",
				playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
				
			mysql_tquery(dbCon, insertLog); 
			KickEx(playerid);
		}

		if (playerData[playerid][pAdmin] > 7)
		{
			playerData[playerid][pAdmin] = 0;
		}
	}
	return 1;
}

CMD:whack(playerid, params[])
{
	foreach(new i : Player) {
		PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
	}

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: ใช้งานโปรแกรมช่วยเล่น", ReturnPlayerName(playerid));
	Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ ใช้งานโปรแกรมช่วยเล่น", ReturnPlayerName(playerid));

	new insertLog[256];
	
	mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'ใช้งานโปรแกรมช่วยเล่น', '%e', '%e', 'System')",
		playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
	
	mysql_tquery(dbCon, insertLog); 
	
	mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'ใช้งานโปรแกรมช่วยเล่น', 'System', '%e')",
		playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
		
	mysql_tquery(dbCon, insertLog); 
	KickEx(playerid);

	return 1;
}

CMD:dgun(playerid, params[])
{
	foreach(new i : Player) {
		PlayerPlaySound(i, 1009, 0.0, 0.0, 0.0);
	}

	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s ถูกแบนโดย System สาเหตุ: ใช้งานโปรแกรมช่วยเล่น", ReturnPlayerName(playerid));
	Log(adminactionlog, INFO, "%s ถูกแบนโดย System สาเหตุ ใช้งานโปรแกรมช่วยเล่น", ReturnPlayerName(playerid));

	new insertLog[256];
	
	mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, '%e', 'ใช้งานโปรแกรมช่วยเล่น', '%e', '%e', 'System')",
		playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate(), ReturnIP(playerid));
	
	mysql_tquery(dbCon, insertLog); 
	
	mysql_format(dbCon, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, '%e', 'ใช้งานโปรแกรมช่วยเล่น', 'System', '%e')",
		playerData[playerid][pSID], ReturnPlayerName(playerid), ReturnDate());
		
	mysql_tquery(dbCon, insertLog); 
	KickEx(playerid);

	return 1;
}
