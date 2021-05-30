
#include <YSI\y_hooks> // pawn-lang/YSI-Includes

//--------------------------------------------------

// Used to override the time in this script
new worldtime_override = 0;
new worldtime_overridehour = 9;
new worldtime_overridemin  = 0;

new rt_hour, rt_minute;

//--------------------------------------------------
new fine_weather_ids[] = {2,3,11,13,14};
/* new foggy_weather_ids[] = {9,19,20};
new wet_weather_ids[] = {8}; */

stock UpdateWorldWeather()
{
	// new next_weather_prob = random(100);
	/*if(next_weather_prob < 70) 		SetWeather(fine_weather_ids[random(sizeof(fine_weather_ids))]);
	else if(next_weather_prob < 95) SetWeather(foggy_weather_ids[random(sizeof(foggy_weather_ids))]);
	else							SetWeather(wet_weather_ids[random(sizeof(wet_weather_ids))]);*/
	SetWeather(fine_weather_ids[random(sizeof(fine_weather_ids))]);
}

//--------------------------------------------------
new last_weather_update=0;

task UpdateTime[60000]()
{
	// Update time
	gettime(rt_hour, rt_minute);

	SetWorldTime(rt_hour);
	/*if(worldtime_override) {
		SetWorldTime(worldtime_overridehour);
	}
	else {
		SetWorldTime(rt_hour);
	}*/

	new x=0;
	while(x!=MAX_PLAYERS) {
	 	if(IsPlayerConnected(x) && GetPlayerState(x) != PLAYER_STATE_NONE) {
	  		// SetPlayerTime(x,rt_hour,rt_minute);

			if(worldtime_override) {
				SetPlayerTime(x,worldtime_overridehour,worldtime_overridemin);
			}
			else {
				SetPlayerTime(x,rt_hour,rt_minute);
			}

		}
		x++;
	}

	/* Update weather every hour */
	if(last_weather_update == 0) {
	    UpdateWorldWeather();
	}
	last_weather_update++;
	if(last_weather_update == 600) {
	    last_weather_update = 0;
	}
}

//--------------------------------------------------

hook OnGameModeInit()
{
	UpdateTime();
	return 1;
}

//--------------------------------------------------

hook OnPlayerSpawn(playerid)
{
	// Update time
	if(!worldtime_override) {
    	gettime(rt_hour, rt_minute);
	} else {
		rt_hour = worldtime_overridehour;
		rt_minute = worldtime_overridemin;
	}
	
	SetPlayerTime(playerid,rt_hour,rt_minute);
	
	return 1;
}

//--------------------------------------------------

hook OnPlayerConnect(playerid)
{
    gettime(rt_hour, rt_minute);
    SetPlayerTime(playerid,rt_hour,rt_minute);
    return 1;
}

//--------------------------------------------------

CMD:sethour(playerid, params[])
{
	new id;
	if(playerData[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_GRAD1, "   �س������Ѻ͹حҵ��������觹��");
	if (sscanf(params, "d", id)) {
        SendClientMessage(playerid, COLOR_GRAD1, "�����: /sethour [�����Ţ]");
        SendClientMessage(playerid, COLOR_GRAD1, "���й�: �� -1 ���͵���繤���������");
        return 1;
    }
    worldtime_override = (id == -1) ? 0 : 1;
    worldtime_overridehour = id;
    UpdateTime();
	return 1;
}

CMD:setminute(playerid, params[])
{
	new id;
	if(playerData[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_GRAD1, "   �س������Ѻ͹حҵ��������觹��");
	if (sscanf(params, "d", id)) {
        SendClientMessage(playerid, COLOR_GRAD1, "�����: /setminute [�����Ţ]");
        return 1;
    }
    worldtime_override = 1;
    worldtime_overridemin = id;
    UpdateTime();
	return 1;
}

CMD:setweather(playerid, params[])
{
	new weather;
	if(playerData[playerid][pAdmin] < 3) return SendClientMessage(playerid, COLOR_GRAD1, "   �س������Ѻ͹حҵ��������觹��");
	if(sscanf(params, "d", weather)) 
        return SendClientMessage(playerid, COLOR_GRAD1, "�����: /weather [�ʹ���Ҿ�ҡ��]");
	if(weather < 0||weather > 45) return SendClientMessage(playerid, COLOR_GREY, "   �ʹ���Ҿ�ҡ�ȵ�ͧ����ӡ��� 0 �����ҡ���� 45!");

	SetWeather(weather);
	return 1;
}