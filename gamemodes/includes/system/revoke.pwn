CMD:takedrug(playerid, params[]) {

	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	
	if (factionType != FACTION_TYPE_POLICE)
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่ตำรวจเท่านั้น !");

	new
		targetid, slot;
		
	if(sscanf(params, "u", targetid, slot))
		return SendClientMessage(playerid, COLOR_GRAD2, "การใช้: /takedrug [ไอดีผู้เล่น/ชื่อบางส่วน] [package_id]");

	if(targetid == playerid)
		return SendClientMessage(playerid, COLOR_GRAD2, "ERROR:"EMBED_WHITE" คุณไม่สามารถยึดยาเสพติดตัวเองได้!");

	if(targetid == INVALID_PLAYER_ID) {
		return SendClientMessage(playerid, COLOR_GRAD1, "ERROR:"EMBED_WHITE" ผู้เล่นนั้นตัดการเชื่อมต่อ");
	}

	if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "ERROR:"EMBED_WHITE" ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

	if(slot < 0 || slot >= MAX_PLAYER_DRUG_PACKAGE)
	    return SendClientMessage(playerid, COLOR_GRAD2, "ERROR:"EMBED_WHITE" ไอดีแพ็กเกจไม่ถูกต้อง");

	if(PlayerDrug[targetid][slot][drugQTY] == 0)
     	return SendClientMessage(playerid, COLOR_GRAD2, "ERROR:"EMBED_WHITE" ไม่พบแพ็กเกจอยู่ในช่องนี้");

	PlayerDrug[targetid][slot][drugQTY] = 0;
	
	SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "* %s ได้ยึดยาเสพติดของ %s ไป", ReturnRealName(playerid), ReturnRealName(targetid));
	SendClientMessageEx(targetid, COLOR_WHITE, "ยาเสพติดที่คุณมีทั้งหมดถูกยึดโดย %s", ReturnRealName(playerid));

	return 1;
}
