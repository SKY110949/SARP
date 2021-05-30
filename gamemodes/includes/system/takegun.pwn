IsAPolicei(vehicleid)
{
	new model = GetVehicleModel(vehicleid);
	return (model == 596 || model == 597 || model == 427 || model == 528 || model == 528);
}

CMD:cartakegun(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
        //factionid = Faction_GetID(playerData[playerid][pFaction]);

 	new idcar = GetPlayerVehicleID(playerid);
	if (!IsAPolicei(idcar)) return SendClientMessage(playerid, COLOR_GREY, "คุณไม่ได้อยู่ในยานพาหนะของ CVPI");
   // if(!IsAPolicei(vehicle)) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่บน CVPI");

	if (factionType == FACTION_TYPE_POLICE)
	{
	//	if (IsPlayerInRangeOfPoint(playerid, 3.0, 355.0871, 161.7024, 1019.9844))
		{
		//	if (playerData[playerid][pOnDuty] == 0) // Duty
		//	{
			//	playerData[playerid][pOnDuty] = 1;
				//givePlayerValidWeapon(playerid, 3, 1);

			//	ResetWeapons(playerid);
				GivePlayerWeaponEx(playerid, 24, 5000);
			 	GivePlayerWeaponEx(playerid, 41, 5000);
			 	GivePlayerWeaponEx(playerid, 3, 1);
				//GivePlayerWeaponEx(playerid, 45, 1);

		//		SetPlayerColor(playerid, 0x00FFFFAA);
				//SetPlayerToTeamColor(playerid);

		//		SetPlayerHealth(playerid, 100);
		//		SetPlayerArmour(playerid, 100);

			//	SendFactionTypeMessage(FACTION_TYPE_NEWS, 0x8D8DFFFF, "** HQ: %s %s ได้้หยิบเครื่องมือติดรถออกมา! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s หยิบอุปกรณ์เสริมออกจาก CVPI", ReturnRealName(playerid));
				return 1;
		
			}
  		
	}

    return 1;
}
CMD:takem4(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]),
        factionid = Faction_GetID(playerData[playerid][pFaction]);

 	new idcar = GetPlayerVehicleID(playerid);
	if (!IsAPolicei(idcar)) return SendClientMessage(playerid, COLOR_GREY, "คุณไม่ได้อยู่ในยานพาหนะของ CVPI");
   // if(!IsAPolicei(vehicle)) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่บน CVPI");

	//new type[13];

	if (factionType == FACTION_TYPE_POLICE)
	{
	//	if (IsPlayerInRangeOfPoint(playerid, 3.0, 355.0871, 161.7024, 1019.9844))
		{
		//	if (playerData[playerid][pOnDuty] == 0) // Duty
		//	{
			//	playerData[playerid][pOnDuty] = 1;
				//givePlayerValidWeapon(playerid, 3, 1);

			//	ResetWeapons(playerid);
				GivePlayerWeaponEx(playerid, 31, 250);
				//GivePlayerWeaponEx(playerid, 45, 1);

		//		SetPlayerColor(playerid, 0x00FFFFAA);
				//SetPlayerToTeamColor(playerid);

		//		SetPlayerHealth(playerid, 100);

			//	SendFactionTypeMessage(FACTION_TYPE_NEWS, 0x8D8DFFFF, "** HQ: %s %s ได้้หยิบเครื่องมือติดรถออกมา! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s หยิบ M4 ออกมาจาก gunrack", ReturnRealName(playerid));
                SendFactionTypeMessage(FACTION_TYPE_MEDIC, 0x8D8DFFFF, "** HQ: %s %s ได้หยิบอาวุธ M4 ออกมาจาก Gunrack **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
				return 1;

			}

	}

    return 1;
}
CMD:takeshotgun(playerid, params[])
{
	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
        //factionid = Faction_GetID(playerData[playerid][pFaction]);

 	new idcar = GetPlayerVehicleID(playerid);
	if (!IsAPolicei(idcar)) return SendClientMessage(playerid, COLOR_GREY, "คุณไม่ได้อยู่ในยานพาหนะของ CVPI");
   // if(!IsAPolicei(vehicle)) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่บน CVPI");

	//new type[13];

	if (factionType == FACTION_TYPE_POLICE)
	{
	//	if (IsPlayerInRangeOfPoint(playerid, 3.0, 355.0871, 161.7024, 1019.9844))
		{
		//	if (playerData[playerid][pOnDuty] == 0) // Duty
		//	{
			//	playerData[playerid][pOnDuty] = 1;
				//givePlayerValidWeapon(playerid, 3, 1);

			//	ResetWeapons(playerid);
				GivePlayerWeaponEx(playerid, 25, 50);
				//GivePlayerWeaponEx(playerid, 45, 1);

		//		SetPlayerColor(playerid, 0x00FFFFAA);
				//SetPlayerToTeamColor(playerid);

		//		SetPlayerHealth(playerid, 100);

			//	SendFactionTypeMessage(FACTION_TYPE_NEWS, 0x8D8DFFFF, "** HQ: %s %s ได้้หยิบเครื่องมือติดรถออกมา! **", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid));
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s หยิบ Shotgun ออกมาจาก gunrack", ReturnRealName(playerid));
				return 1;

			}

	}

    return 1;
}

