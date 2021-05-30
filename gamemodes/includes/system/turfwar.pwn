#include <YSI\y_hooks>

#define TAKEOVER_TIME 			300 // how many seconds needed to take over the zone
#define TAKEOVER_NONE         	60

#define TURF_WAR_MIN            4

#define MAX_GZONE               337

enum gzoneinfo
{
	gZoneSID,
	gZoneOwner,
	gZoneAttack,
	gZoneAttackTime,
	gZoneAttackNon,
	gZoneAttackDelay,
	Float:gZoneCroods[4],
	gZoneExist,

	gZoneAtkDeath,
	gZoneDefDeath,
}

new GangZoneInfo[MAX_GZONE][gzoneinfo];
new GangZoneWar[MAX_GZONE];

new CurrentZone[MAX_PLAYERS];

hook OnGameModeInit() {
    mysql_tquery(dbCon, "SELECT * FROM `gangzones`", "Zone_Load");
}

hook OnPlayerConnect(playerid) {
    CurrentZone[playerid] = -1;
    return 1;
}

hook OnPlayerSpawn(playerid) {
	if (playerData[playerid][pFaction] != 0) {
		for(new i=0; i != MAX_GZONE; i++)
		{
			GangZoneShowForPlayer(playerid, GangZoneWar[i], Faction_GetTurfColor(Faction_GetID(GangZoneInfo[i][gZoneOwner])));
			if(GangZoneInfo[i][gZoneAttack] != 0) {
				GangZoneFlashForPlayer(playerid, GangZoneWar[i], Faction_GetTurfColor(Faction_GetID(GangZoneInfo[i][gZoneAttack])));
			}
		}
	}
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
	new i = GetPlayerGZone(playerid);
	if(GangZoneInfo[i][gZoneAttack] != 0 && (playerData[playerid][pFaction] == GangZoneInfo[i][gZoneOwner] || playerData[playerid][pFaction] == GangZoneInfo[i][gZoneAttack])) {

		if (playerData[playerid][pFaction] == GangZoneInfo[i][gZoneOwner]) {
			GangZoneInfo[i][gZoneDefDeath]++;
		}
		else if (playerData[playerid][pFaction] == GangZoneInfo[i][gZoneAttack]) {
			GangZoneInfo[i][gZoneAtkDeath]++;
		}
	}
	return 1;
}

flags:editzone(CMD_ADM_3);
CMD:editzone(playerid, params[])
{
    new
    	ans,
    	i;
    if(sscanf(params, "i", ans))
    {
    	SendClientMessage(playerid, COLOR_GRAD1, "�����: /editzone [�ʹ� (/factionlist)]");
    }
    else
    {
        ans--;
        if(!Iter_Contains(Iter_Faction, ans))
        {
    		i = GetPlayerGZone(playerid);
    		GangZoneStopFlashForAll(GangZoneWar[i]);
    		GangZoneInfo[i][gZoneOwner] = 0;
    		GangZoneInfo[i][gZoneAttackDelay] = 0;
    		GangZoneShowForAll(GangZoneWar[i], Faction_GetTurfColor(0));
    		SaveZone(i);
    	}
    	else
    	{
    	    if (factionData[ans][fType] == FACTION_TYPE_GANG)
    	    {
    			i = GetPlayerGZone(playerid);
    			GangZoneStopFlashForAll(GangZoneWar[i]);
    			GangZoneInfo[i][gZoneOwner] = factionData[ans][fID];
    			GangZoneInfo[i][gZoneAttackDelay] = 0;
    			GangZoneShowForAll(GangZoneWar[i], Faction_GetTurfColor(ans));
    			SaveZone(i);

                SendClientMessageEx(playerid, COLOR_GRAD1, "Turf War: ��鹷�����繢ͧ %s", Faction_GetName(ans));
    		}
    		else SendClientMessage(playerid, COLOR_GRAD1, "�ʹա����/�ꧤ����к�������ꧤ�");
    	}
    }
	return 1;
}

CMD:turfinfo(playerid) {
	Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_LIST, "����ࢵᴹ",     "�Ըա������\n\
     ����觷����繵�ͧ��㹡�����\n\
     /takezone (/�ִ��鹷��)\n\
     - ������¤�͡�úء/��ͧ�ѹ��鹷������ࢵ��� ������ѹ�������о�Ժ\n\
     - ���»�ͧ�ѹ��ͧ����Ҫԡ����ӡ��� %d ���͹�Ź����� ��н��ºء��ͧ�׹�����⫹�����ִ %d ��\n\
     - �ҡ���»�ͧ�ѹ�������������⫹���� %d �Թҷ� ������ࢵᴹ�ѹ��\n\
     - �ҡ���ºء�����������������⫹ ����ִ��������Ƿѹ��\n\
     - ����ͤú 5 �ҷչѺ���������������ִ⫹ �ҡ���»�ͧ�ѹ�������ö�ӨѴ���ºء�͡��������ࢵᴹ�ѹ��\n\
    \n\n\
    ���������\n\
     1. ���ºء��ͧ������˹���������������⫹\n\
     2. ���ºء��ͧ������ҹ��˹Т�����������⫹\n\
     3. ������Ҥ�㹢�з�����躹�ҹ��˹� (DB)", "�Դ", "", TURF_WAR_MIN, TURF_WAR_MIN, TAKEOVER_NONE);
}

alias:takezone("�ִ��鹷��");
CMD:takezone(playerid) {

    new factionid = Faction_GetID(playerData[playerid][pFaction]), faction = playerData[playerid][pFaction];

    if(factionid != -1) {
        
    	if(playerData[playerid][pFactionRank] == 1 && factionData[factionid][fType] == FACTION_TYPE_GANG)
    	{
    		new stillzone;

    		if((stillzone = GetPlayerGZone(playerid)) != -1)
    		{
    			new eminem = GangZoneInfo[stillzone][gZoneOwner];
                new eminemid = Faction_GetID(GangZoneInfo[stillzone][gZoneOwner]);

    			if(faction != eminem)
    			{
    			    if(GangZoneInfo[stillzone][gZoneAttackDelay] <= 0)
    			    {
    			        new allfriendly = GangOnlineInSameZone(faction, stillzone);

    			        if(eminem == 0)
    			        {
    			            if(allfriendly >= TURF_WAR_MIN) {

                                SendFactionIDMessage(faction, COLOR_LIGHTGREEN, "Turf War: %s ���ִ⫹����������Ңͧ", ReturnRealName(playerid));

    				      		GangZoneInfo[stillzone][gZoneOwner] = faction;
    				         	GangZoneShowForAll(GangZoneWar[stillzone], Faction_GetTurfColor(factionid));
    				           	GangZoneInfo[stillzone][gZoneAttack] = 0;

    				         	SaveZone(stillzone);
    			         	}
    			         	else {
    			         	    SendClientMessageEx(playerid, COLOR_GREY, " ��ͧ����Ҫԡ�����⫹���ǡѺ�س����� %d ������", TURF_WAR_MIN);
    			         	}
    			        }
    			        else
    			        {
    			            new alleminem = GangOnline(eminem);

    						if(!IsGangAttack(faction) && !IsGangAttack(eminem))
    						{
                                // SendClientMessageToAllEx(-1, "DEBUG: ���·�� (/takezone) �վ�ä�ǡ %d ���Ե����ѵ�١��� %d ���Ե", allfriendly, alleminem);

    						    if(allfriendly >= TURF_WAR_MIN)
    						    {
    								if(alleminem >= TURF_WAR_MIN)
    								{
    									GangZoneInfo[stillzone][gZoneAttack] = faction;
    									GangZoneInfo[stillzone][gZoneAttackTime] = 0;
    									GangZoneInfo[stillzone][gZoneAttackNon] = 0;
    									GangZoneFlashForAll(GangZoneWar[stillzone], Faction_GetTurfColor(factionid));

										GangZoneInfo[stillzone][gZoneDefDeath]=0;
										GangZoneInfo[stillzone][gZoneAtkDeath]=0;

                                        SendFactionIDMessage(faction, COLOR_LIGHTGREEN, "Turf War: ࢵ⫹�ͧ %s ���ѧ�١ %s �ִ��鹷��", Faction_GetName(eminemid), Faction_GetName(factionid));
                                        SendFactionIDMessage(eminem, COLOR_LIGHTGREEN, "Turf War: ࢵ⫹�ͧ %s �����������ִ��鹷��ͧ %s", Faction_GetName(factionid), Faction_GetName(eminemid));
    								}
    			 				    else
    							    {
    							        SendClientMessageEx(playerid, COLOR_GREY, " ��ͧ���ѵ�ٷ������Ңͧ⫹����͹�Ź����� %d ������", TURF_WAR_MIN);
    							    }
    						    }
    						    else
    						    {
    						        SendClientMessageEx(playerid, COLOR_GREY, " ��ͧ����Ҫԡ�����⫹���ǡѺ�س����� %d ������", TURF_WAR_MIN);
    						    }
    						}
    						else
    						{
    						    SendClientMessage(playerid, COLOR_GREY, " ��⫹��蹢ͧ�س���ͧ͢�ѵ�١��ѧ��о�Ժ����");
    						}
    					}
    				}
    				else
    				{
    				    SendClientMessage(playerid, COLOR_GREY, " ⫹�������㹪�ǧ Cooldown");
    				}
    			}
    			else {
    			    SendClientMessage(playerid, COLOR_GREY, " ⫹����繢ͧ�س��������");
    			}
    		}
            else {
                 SendClientMessage(playerid, COLOR_GREY, " �س��������������⫹");
            }
    	}
    	else
    	{
    	    SendClientMessage(playerid, COLOR_GREY, " �س�������ӡ����/�ꧤ�");
    	}
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, " �س�������ǹ˹�觢ͧ�ꧤ�");
    }

    return 1;
}

//* Gang Zone

stock IsPlayerInGZone(playerid, zoneid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    return (x > GangZoneInfo[zoneid][gZoneCroods][0] && x < GangZoneInfo[zoneid][gZoneCroods][2] && y > GangZoneInfo[zoneid][gZoneCroods][1] && y < GangZoneInfo[zoneid][gZoneCroods][3]);
}

stock GetPlayerGZone(playerid)
{
    for(new i=0; i != MAX_GZONE; i++)
    {
        if(IsPlayerInGZone(playerid, i))
        {
            return i;
        }
    }
    return -1;
}

stock GetPlayersInZone(zoneid, teamid)
{
    new count, type = Faction_GetTypeID(teamid);
    foreach(new i: Player)
    {
        if(IsPlayerConnected(i) && playerData[i][pFaction] == teamid && type == FACTION_TYPE_GANG && IsPlayerInGZone(i, zoneid))
        {
            count++;
        }
    }
    return count;
}

stock CheckIfNonInZone(zoneid, teamid)
{
    new count, type = Faction_GetTypeID(teamid);
    foreach(new i: Player)
    {
        if(IsPlayerInGZone(i, zoneid))
        {
            if(playerData[i][pFaction] == teamid && type == FACTION_TYPE_GANG)
            {
            	count++;
			}
			if(playerData[i][pFaction] != teamid && type == FACTION_TYPE_GANG)
			{
			    count = 0;
			    break;
			}
        }
    }
    return count;
}

stock IsGangAttack(gangid)
{
	for(new i=0; i != MAX_GZONE; i++)
	{
		if(GangZoneInfo[i][gZoneAttack] == gangid)
		{
			return 1;
		}
	}
	return 0;
}

stock GangOnline(gangid)
{
	new member;
	foreach(new x: Player) {
		if(playerData[x][pFaction] == gangid) {
        	member++;
		}
	}
	return member;
}

stock GangOnlineInSameZone(gangid, zoneid)
{
	new member;
	foreach(new x: Player) {
		if(IsPlayerConnected(x) && playerData[x][pFaction] == gangid && IsPlayerInGZone(x, zoneid)) {
        	member++;
		}
	}
	return member;
}

stock ClearGangZone(zoneid)
{
	GangZoneInfo[zoneid][gZoneOwner] = 0;
	GangZoneShowForAll(GangZoneWar[zoneid], Faction_GetTurfColor(-1));
	GangZoneInfo[zoneid][gZoneAttack] = 0;
	SaveZone(zoneid);
	return 1;
}

task ZoneTimer[1000]()
{
    for(new i=0; i != MAX_GZONE; i++)
    {
		if(GangZoneInfo[i][gZoneAttackDelay] > 0)
       		GangZoneInfo[i][gZoneAttackDelay]--;

      	if(GangZoneInfo[i][gZoneAttack] != 0)
        {
            new fAttack = Faction_GetID(GangZoneInfo[i][gZoneAttack]), fOwner = Faction_GetID(GangZoneInfo[i][gZoneOwner]);

	      	if(GetPlayersInZone(i, GangZoneInfo[i][gZoneAttack]) >= 1)
	      	{
	            GangZoneInfo[i][gZoneAttackTime]++;
	            if(GangZoneInfo[i][gZoneAttackTime] == TAKEOVER_TIME)
	            {
					// Check death
					if (GangZoneInfo[i][gZoneDefDeath] < GangZoneInfo[i][gZoneAtkDeath]) {

						SendFactionIDMessage(GangZoneInfo[i][gZoneAttack], COLOR_LIGHTGREEN, "Turf War: %s �������ִ��鹷��ͧ %s ���������", Faction_GetName(fAttack), Faction_GetName(fOwner));
						SendFactionIDMessage(GangZoneInfo[i][gZoneOwner], COLOR_LIGHTGREEN, "Turf War: %s �������ִ��鹷��ͧ %s ���������", Faction_GetName(fAttack), Faction_GetName(fOwner));
						
						SendFactionIDMessage(GangZoneInfo[i][gZoneAttack], COLOR_LIGHTGREEN, "Turf War: ������� %d : ��Ҷ�� %d", GangZoneInfo[i][gZoneDefDeath], GangZoneInfo[i][gZoneAtkDeath]);
						SendFactionIDMessage(GangZoneInfo[i][gZoneOwner], COLOR_LIGHTGREEN, "Turf War: ������� %d : ��Ҷ�� %d", GangZoneInfo[i][gZoneDefDeath], GangZoneInfo[i][gZoneAtkDeath]);

						GangZoneStopFlashForAll(GangZoneWar[i]);
						GangZoneInfo[i][gZoneAttack] = 0;
						GangZoneInfo[i][gZoneAttackDelay] = 7200;

						SaveZone(i);
					}
					else {
						GangZoneStopFlashForAll(GangZoneWar[i]);

						SendFactionIDMessage(GangZoneInfo[i][gZoneAttack], COLOR_LIGHTGREEN, "Turf War: %s ���ִ��鹷��ͧ %s �����", Faction_GetName(fAttack), Faction_GetName(fOwner));
						SendFactionIDMessage(GangZoneInfo[i][gZoneOwner], COLOR_LIGHTGREEN, "Turf War: %s ����ࢵ��鹷�����Ѻ %s", Faction_GetName(fOwner), Faction_GetName(fAttack));

						SendFactionIDMessage(GangZoneInfo[i][gZoneAttack], COLOR_LIGHTGREEN, "Turf War: ������� %d : ��Ҷ�� %d", GangZoneInfo[i][gZoneDefDeath], GangZoneInfo[i][gZoneAtkDeath]);
						SendFactionIDMessage(GangZoneInfo[i][gZoneOwner], COLOR_LIGHTGREEN, "Turf War: ������� %d : ��Ҷ�� %d", GangZoneInfo[i][gZoneDefDeath], GangZoneInfo[i][gZoneAtkDeath]);

						GangZoneInfo[i][gZoneOwner] = GangZoneInfo[i][gZoneAttack];
						GangZoneShowForAll(GangZoneWar[i], Faction_GetTurfColor(fAttack)); // update the zone color for new team
						GangZoneInfo[i][gZoneAttack] = 0;
						GangZoneInfo[i][gZoneAttackDelay] = 7200;

						SaveZone(i);
					}
	            }
			    else
			    {
			        GangZoneInfo[i][gZoneAttackNon]++;
			    	if(CheckIfNonInZone(i, GangZoneInfo[i][gZoneAttack]) == 0 && GangZoneInfo[i][gZoneAttackNon] == TAKEOVER_NONE)
			    	{
			         	GangZoneStopFlashForAll(GangZoneWar[i]);

	                 	SendFactionIDMessage(GangZoneInfo[i][gZoneAttack], COLOR_LIGHTGREEN, "Turf War: %s ���ִ��鹷��ͧ %s �����", Faction_GetName(fAttack), Faction_GetName(fOwner));
	                 	SendFactionIDMessage(GangZoneInfo[i][gZoneOwner], COLOR_LIGHTGREEN, "Turf War: %s ����ࢵ��鹷�����Ѻ %s", Faction_GetName(fOwner), Faction_GetName(fAttack));

		                GangZoneInfo[i][gZoneOwner] = GangZoneInfo[i][gZoneAttack];
		                GangZoneShowForAll(GangZoneWar[i], Faction_GetTurfColor(fAttack)); // update the zone color for new team
		                GangZoneInfo[i][gZoneAttack] = 0;
		                GangZoneInfo[i][gZoneAttackDelay] = 7200;

		                SaveZone(i);
			    	}
			    	else
			    	{
			    	    GangZoneInfo[i][gZoneAttackNon] = 0;
			    	}
			    }
	      	}
	      	else // attackers failed to take over the zone
	      	{
	          	SendFactionIDMessage(GangZoneInfo[i][gZoneAttack], COLOR_LIGHTGREEN, "Turf War: %s �������ִ��鹷��ͧ %s ���������", Faction_GetName(fAttack), Faction_GetName(fOwner));
				SendFactionIDMessage(GangZoneInfo[i][gZoneOwner], COLOR_LIGHTGREEN, "Turf War: %s �������ִ��鹷��ͧ %s ���������", Faction_GetName(fAttack), Faction_GetName(fOwner));
						
	          	GangZoneStopFlashForAll(GangZoneWar[i]);
	           	GangZoneInfo[i][gZoneAttack] = 0;
	           	GangZoneInfo[i][gZoneAttackDelay] = 7200;

	           	SaveZone(i);
	      	}
        }
    }


    return 1;
}

SaveZone(id)
{
	new
	    query[256];

	format(query, sizeof(query), "UPDATE `gangzones` SET `zoneOwnerID` = '%d', `gZoneAttackDelay` = '%d' WHERE `zoneindex` = '%d'",
	    GangZoneInfo[id][gZoneOwner],
	    GangZoneInfo[id][gZoneAttackDelay],
	    GangZoneInfo[id][gZoneSID]
	);

	return mysql_tquery(dbCon, query);
}

forward Zone_Load();
public Zone_Load()
{
	new
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_GZONE)
	{
	    cache_get_value_name_int(i, "zoneindex", GangZoneInfo[i][gZoneSID]);
	    cache_get_value_name_int(i, "zoneOwnerID", GangZoneInfo[i][gZoneOwner]);
	    cache_get_value_name_int(i, "gZoneAttackDelay", GangZoneInfo[i][gZoneAttackDelay]);
	    cache_get_value_name_float(i, "gZoneMinX", GangZoneInfo[i][gZoneCroods][0]);
	    cache_get_value_name_float(i, "gZoneMinY", GangZoneInfo[i][gZoneCroods][1]);
	    cache_get_value_name_float(i, "gZoneMaxX", GangZoneInfo[i][gZoneCroods][2]);
	    cache_get_value_name_float(i, "gZoneMaxY", GangZoneInfo[i][gZoneCroods][3]);
		GangZoneInfo[i][gZoneExist] = 1;

	    GangZoneWar[i] = GangZoneCreate(GangZoneInfo[i][gZoneCroods][0],GangZoneInfo[i][gZoneCroods][1],GangZoneInfo[i][gZoneCroods][2],GangZoneInfo[i][gZoneCroods][3]);
	    GangZoneInfo[i][gZoneAttack] = 0;
	}
    printf("Turfwar loaded (%d/%d)", rows, MAX_GZONE);
	return 1;
}


