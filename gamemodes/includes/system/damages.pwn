
#define MAX_DAMAGES 30

enum E_DAMAGE_DATA {
	bool:dExists,
    bool:dArmour,
	dSec,
	dShotType,
	dWeaponid,
	dDamage,
    dIssueName[MAX_PLAYER_NAME]
};
new DamageData[MAX_PLAYERS][MAX_DAMAGES][E_DAMAGE_DATA];

addPlayerDamage(playerid, issuerid, weaponid, Float:damage, bool:armour, bodypart)
{
	for(new i = 0; i != MAX_DAMAGES; ++i)
	{
	    if(!DamageData[playerid][i][dExists])
	    {
	        DamageData[playerid][i][dExists] = true;
	        DamageData[playerid][i][dSec] = gettime();
	        DamageData[playerid][i][dDamage] = floatround(damage);
	        DamageData[playerid][i][dShotType] = bodypart;
	        DamageData[playerid][i][dArmour] = armour;
	        DamageData[playerid][i][dWeaponid] = weaponid;
			format(DamageData[playerid][i][dIssueName], MAX_PLAYER_NAME, ReturnPlayerName(issuerid));
	    	return i;
	    }
	}

	new i = 0, tempDamage[MAX_DAMAGES][E_DAMAGE_DATA];
	DamageData[playerid][i][dExists] = true;
	DamageData[playerid][i][dSec] = gettime();
	DamageData[playerid][i][dDamage] = floatround(damage);
	DamageData[playerid][i][dShotType] = bodypart;
	DamageData[playerid][i][dArmour] = armour;
	DamageData[playerid][i][dWeaponid] = weaponid;
	format(DamageData[playerid][i][dIssueName], MAX_PLAYER_NAME, ReturnPlayerName(issuerid));

	for(new x = 0; x != MAX_DAMAGES; ++x)
	{
		for(new e = 0; e != sizeof(tempDamage); ++e)
	    	tempDamage[x][E_DAMAGE_DATA:e] = DamageData[playerid][x][E_DAMAGE_DATA:e];
	}
	SortDeepArray(tempDamage, dSec);
	for(new x = 0; x != MAX_DAMAGES; ++x)
	{
		for(new e = 0; e != sizeof(tempDamage); ++e)
			DamageData[playerid][x][E_DAMAGE_DATA:e] = tempDamage[x][E_DAMAGE_DATA:e];
	}
	return i;
}

stock countPlayerDamage(playerid)
{
	new count = 0;
	for(new i = 0; i != MAX_DAMAGES; ++i)
	{
	    if(DamageData[playerid][i][dExists])
			count++;
	}
	return count;
}

Damage_Reset(playerid)
{
	for(new i = 0; i != MAX_DAMAGES; ++i)
	{
	    DamageData[playerid][i][dExists]=
		DamageData[playerid][i][dArmour]=false;
		DamageData[playerid][i][dSec]=
		DamageData[playerid][i][dDamage]=
		DamageData[playerid][i][dShotType]=
		DamageData[playerid][i][dWeaponid]=0;
	}
}

CMD:damages(playerid, params[])
{
	new targetid;

	if (sscanf(params, "u", targetid))
		return SendClientMessage(playerid, COLOR_GRAD2, "�����: /damages [�ʹռ�����/��ǹ˹�觢ͧ����]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������͡Ѻ���������");

	if (playerid != targetid && !IsPlayerNearPlayer(playerid, targetid, 3.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹��������������س");
	
	new temp_current_time = gettime(), str[2500];
	for(new i=MAX_DAMAGES-1;i!=0;--i) {
		if(DamageData[targetid][i][dExists])
		{
			if(playerData[playerid][pAdmin] > 0) 
          		format(str, sizeof(str), "%s%s �Ӵ���� %d �ҡ %s ⴹ%s (%s) %d �Թҷշ���ҹ��\n", str, DamageData[targetid][i][dIssueName], DamageData[targetid][i][dDamage], ReturnWeaponNameEx(DamageData[targetid][i][dWeaponid]), GetBodyPartName(DamageData[targetid][i][dShotType]), DamageData[targetid][i][dArmour] ? ("ⴹ����") : ("���ⴹ����"), temp_current_time - DamageData[targetid][i][dSec]);
			else 
				format(str, sizeof(str), "%s����� %d �ҡ %s ⴹ%s (%s) %d �Թҷշ���ҹ��\n", str, DamageData[targetid][i][dDamage], ReturnWeaponNameEx(DamageData[targetid][i][dWeaponid]), GetBodyPartName(DamageData[targetid][i][dShotType]), DamageData[targetid][i][dArmour] ? ("ⴹ����") : ("���ⴹ����"), temp_current_time - DamageData[targetid][i][dSec]);
		}
	}
	return Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_LIST, ReturnRealName(targetid), (isnull(str)) ? ("�ѧ����դ��������������ʴ� ...") : str, "�Դ", "");
}