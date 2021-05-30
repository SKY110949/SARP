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
    	SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /editzone [ไอดี (/factionlist)]");
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

                SendClientMessageEx(playerid, COLOR_GRAD1, "Turf War: พื้นที่นี้เป็นของ %s", Faction_GetName(ans));
    		}
    		else SendClientMessage(playerid, COLOR_GRAD1, "ไอดีกลุ่ม/แก๊งค์ที่ระบุไม่ใช่แก๊งค์");
    	}
    }
	return 1;
}

CMD:turfinfo(playerid) {
	Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_LIST, "วอร์เขตแดน",     "วิธีการวอร์\n\
     คำสั่งที่จำเป็นต้องใช้ในการวอ์\n\
     /takezone (/ยึดพื้นที่)\n\
     - เป้าหมายคือการบุก/ป้องกันพื้นที่ภายในเขตนั้น เมื่อมันเริ่มกระพริบ\n\
     - ฝ่ายป้องกันต้องมีสมาชิกไม่ต่ำกว่า %d คนออนไลน์อยู่ และฝ่ายบุกต้องยืนอยู่ในโซนที่จะยึด %d คน\n\
     - หากฝ่ายป้องกันไม่เข้ามาอยู่ในโซนภายใน %d วินาที จะเสียเขตแดนทันที\n\
     - หากฝ่ายบุกไม่เหลืออยู่ในวอร์โซน การยึดจะล้มเหลวทันที\n\
     - เมื่อครบ 5 นาทีนับตั้งแต่เริ่มวอร์ยึดโซน หากฝ่ายป้องกันไม่สามารถกำจัดฝ่ายบุกออกไปได้จะเสียเขตแดนทันที\n\
    \n\n\
    กฎการวอร์\n\
     1. ฝ่ายบุกต้องไม่วิ่งหนีเมื่ออยู่ในวอร์โซน\n\
     2. ฝ่ายบุกต้องไม่ใช้ยานพาหนะขณะอยู่ในวอร์โซน\n\
     3. ห้ามฆ่าคนในขณะที่อยู่บนยานพาหนะ (DB)", "ปิด", "", TURF_WAR_MIN, TURF_WAR_MIN, TAKEOVER_NONE);
}

alias:takezone("ยึดพื้นที่");
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

                                SendFactionIDMessage(faction, COLOR_LIGHTGREEN, "Turf War: %s ได้ยึดโซนที่ไม่มีเจ้าของ", ReturnRealName(playerid));

    				      		GangZoneInfo[stillzone][gZoneOwner] = faction;
    				         	GangZoneShowForAll(GangZoneWar[stillzone], Faction_GetTurfColor(factionid));
    				           	GangZoneInfo[stillzone][gZoneAttack] = 0;

    				         	SaveZone(stillzone);
    			         	}
    			         	else {
    			         	    SendClientMessageEx(playerid, COLOR_GREY, " ต้องมีสมาชิกอยู่ในโซนเดียวกับคุณตั้งแต่ %d คนขึ้นไป", TURF_WAR_MIN);
    			         	}
    			        }
    			        else
    			        {
    			            new alleminem = GangOnline(eminem);

    						if(!IsGangAttack(faction) && !IsGangAttack(eminem))
    						{
                                // SendClientMessageToAllEx(-1, "DEBUG: ฝ่ายท้า (/takezone) มีพรรคพวก %d ชีวิตและศัตรูกว่า %d ชีวิต", allfriendly, alleminem);

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

                                        SendFactionIDMessage(faction, COLOR_LIGHTGREEN, "Turf War: เขตโซนของ %s กำลังถูก %s ยึดพื้นที่", Faction_GetName(eminemid), Faction_GetName(factionid));
                                        SendFactionIDMessage(eminem, COLOR_LIGHTGREEN, "Turf War: เขตโซนของ %s พยายามที่จะยึดพื้นที่ของ %s", Faction_GetName(factionid), Faction_GetName(eminemid));
    								}
    			 				    else
    							    {
    							        SendClientMessageEx(playerid, COLOR_GREY, " ต้องมีศัตรูที่เป็นเจ้าของโซนนี้ออนไลน์ตั้งแต่ %d คนขึ้นไป", TURF_WAR_MIN);
    							    }
    						    }
    						    else
    						    {
    						        SendClientMessageEx(playerid, COLOR_GREY, " ต้องมีสมาชิกอยู่ในโซนเดียวกับคุณตั้งแต่ %d คนขึ้นไป", TURF_WAR_MIN);
    						    }
    						}
    						else
    						{
    						    SendClientMessage(playerid, COLOR_GREY, " มีโซนอื่นของคุณหรือของศัตรูกำลังกระพริบอยู่");
    						}
    					}
    				}
    				else
    				{
    				    SendClientMessage(playerid, COLOR_GREY, " โซนนี้อยู่ในช่วง Cooldown");
    				}
    			}
    			else {
    			    SendClientMessage(playerid, COLOR_GREY, " โซนนี้เป็นของคุณอยู่แล้ว");
    			}
    		}
            else {
                 SendClientMessage(playerid, COLOR_GREY, " คุณไม่ได้อยู่ในวอร์โซน");
            }
    	}
    	else
    	{
    	    SendClientMessage(playerid, COLOR_GREY, " คุณไม่ใช่ผู้นำกลุ่ม/แก๊งค์");
    	}
    }
    else
    {
        SendClientMessage(playerid, COLOR_GREY, " คุณไม่ใช่ส่วนหนึ่งของแก๊งค์");
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

						SendFactionIDMessage(GangZoneInfo[i][gZoneAttack], COLOR_LIGHTGREEN, "Turf War: %s พยายามยึดพื้นที่ของ %s แต่ล้มเหลว", Faction_GetName(fAttack), Faction_GetName(fOwner));
						SendFactionIDMessage(GangZoneInfo[i][gZoneOwner], COLOR_LIGHTGREEN, "Turf War: %s พยายามยึดพื้นที่ของ %s แต่ล้มเหลว", Faction_GetName(fAttack), Faction_GetName(fOwner));
						
						SendFactionIDMessage(GangZoneInfo[i][gZoneAttack], COLOR_LIGHTGREEN, "Turf War: ผู้โจมตี %d : เจ้าถิ่น %d", GangZoneInfo[i][gZoneDefDeath], GangZoneInfo[i][gZoneAtkDeath]);
						SendFactionIDMessage(GangZoneInfo[i][gZoneOwner], COLOR_LIGHTGREEN, "Turf War: ผู้โจมตี %d : เจ้าถิ่น %d", GangZoneInfo[i][gZoneDefDeath], GangZoneInfo[i][gZoneAtkDeath]);

						GangZoneStopFlashForAll(GangZoneWar[i]);
						GangZoneInfo[i][gZoneAttack] = 0;
						GangZoneInfo[i][gZoneAttackDelay] = 7200;

						SaveZone(i);
					}
					else {
						GangZoneStopFlashForAll(GangZoneWar[i]);

						SendFactionIDMessage(GangZoneInfo[i][gZoneAttack], COLOR_LIGHTGREEN, "Turf War: %s ได้ยึดพื้นที่ของ %s สำเร็จ", Faction_GetName(fAttack), Faction_GetName(fOwner));
						SendFactionIDMessage(GangZoneInfo[i][gZoneOwner], COLOR_LIGHTGREEN, "Turf War: %s เสียเขตพื้นที่ให้กับ %s", Faction_GetName(fOwner), Faction_GetName(fAttack));

						SendFactionIDMessage(GangZoneInfo[i][gZoneAttack], COLOR_LIGHTGREEN, "Turf War: ผู้โจมตี %d : เจ้าถิ่น %d", GangZoneInfo[i][gZoneDefDeath], GangZoneInfo[i][gZoneAtkDeath]);
						SendFactionIDMessage(GangZoneInfo[i][gZoneOwner], COLOR_LIGHTGREEN, "Turf War: ผู้โจมตี %d : เจ้าถิ่น %d", GangZoneInfo[i][gZoneDefDeath], GangZoneInfo[i][gZoneAtkDeath]);

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

	                 	SendFactionIDMessage(GangZoneInfo[i][gZoneAttack], COLOR_LIGHTGREEN, "Turf War: %s ได้ยึดพื้นที่ของ %s สำเร็จ", Faction_GetName(fAttack), Faction_GetName(fOwner));
	                 	SendFactionIDMessage(GangZoneInfo[i][gZoneOwner], COLOR_LIGHTGREEN, "Turf War: %s เสียเขตพื้นที่ให้กับ %s", Faction_GetName(fOwner), Faction_GetName(fAttack));

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
	          	SendFactionIDMessage(GangZoneInfo[i][gZoneAttack], COLOR_LIGHTGREEN, "Turf War: %s พยายามยึดพื้นที่ของ %s แต่ล้มเหลว", Faction_GetName(fAttack), Faction_GetName(fOwner));
				SendFactionIDMessage(GangZoneInfo[i][gZoneOwner], COLOR_LIGHTGREEN, "Turf War: %s พยายามยึดพื้นที่ของ %s แต่ล้มเหลว", Faction_GetName(fAttack), Faction_GetName(fOwner));
						
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


