CMD:takedrug(playerid, params[]) {

	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	
	if (factionType != FACTION_TYPE_POLICE)
	    return SendClientMessage(playerid, COLOR_GRAD2,"   ����Ѻ���˹�ҷ����Ǩ��ҹ�� !");

	new
		targetid, slot;
		
	if(sscanf(params, "u", targetid, slot))
		return SendClientMessage(playerid, COLOR_GRAD2, "�����: /takedrug [�ʹռ�����/���ͺҧ��ǹ] [package_id]");

	if(targetid == playerid)
		return SendClientMessage(playerid, COLOR_GRAD2, "ERROR:"EMBED_WHITE" �س�������ö�ִ���ʾ�Դ����ͧ��!");

	if(targetid == INVALID_PLAYER_ID) {
		return SendClientMessage(playerid, COLOR_GRAD1, "ERROR:"EMBED_WHITE" �����蹹�鹵Ѵ�����������");
	}

	if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "ERROR:"EMBED_WHITE" �����蹹��������������س");

	if(slot < 0 || slot >= MAX_PLAYER_DRUG_PACKAGE)
	    return SendClientMessage(playerid, COLOR_GRAD2, "ERROR:"EMBED_WHITE" �ʹ���ࡨ���١��ͧ");

	if(PlayerDrug[targetid][slot][drugQTY] == 0)
     	return SendClientMessage(playerid, COLOR_GRAD2, "ERROR:"EMBED_WHITE" ��辺��ࡨ����㹪�ͧ���");

	PlayerDrug[targetid][slot][drugQTY] = 0;
	
	SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "* %s ���ִ���ʾ�Դ�ͧ %s �", ReturnRealName(playerid), ReturnRealName(targetid));
	SendClientMessageEx(targetid, COLOR_WHITE, "���ʾ�Դ���س�շ������١�ִ�� %s", ReturnRealName(playerid));

	return 1;
}
