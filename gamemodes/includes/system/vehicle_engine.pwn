
#include <YSI\y_hooks> // pawn-lang/YSI-Includes

// HOTWIRE
new h_vid[MAX_PLAYERS];
new h_times[MAX_PLAYERS];
new h_wid[MAX_PLAYERS];
new h_word[MAX_PLAYERS][16];
new h_score[MAX_PLAYERS];
new h_failed[MAX_PLAYERS];

new const ScrambleWord[][] = {
	"BABY", "BALL", "BANANA", "WALK", "BYE", "BOOK",
	"LOOK", "CAT",
	"COOKIE", "EYE", "DOG", "HAT", "HELLO", "HOT",
	"MILK", "MORE",
	"NO", "NOSE", "SHOE", "YES", "SUNDAY", "GRAPE",
	"HEAD", "ARM", "LEG",
	"BIG", "BOY", "BUT", "CLASS", "CUT", "EAT",
	"FAR", "FIRE", "GET",
	"HER", "LEFT", "LOW", "FIVE", "RAIN"
};

CreateScramble(const s[])
{
	new scam[16];

    strcat(scam, s);

	new tmp[2], num, len = strlen(scam);
	for(new i=0; scam[i] != EOS; ++i)
	{
	    num = random(len);
		tmp[0] = scam[i];
		tmp[1] = scam[num];
		scam[num] = tmp[0];
		scam[i] = tmp[1];
	}
	return scam;
}

hook OnPlayerConnect(playerid) {
	// ================== [ Hotwire ] ==================
	h_vid[playerid]=-1; h_times[playerid]=0; h_wid[playerid]=-1; h_score[playerid]=0; h_failed[playerid]=0;
    h_word[playerid][0]='\0';
}

alias:engine("en");
CMD:engine(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid), Float:vhealth, bool:canstart, id = -1;

	if (!IsEngineVehicle(vehicleid))
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้อยู่ในยานพาหนะ");

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่คนขับ");

	if (!vehicleData[vehicleid][vFuel])
  		return SendClientMessage(playerid, COLOR_LIGHTRED, "ยานพาหนะคันนี้ไม่มีน้ำมัน");

	if(HasCooldown(playerid,COOLDOWN_ENGINE))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่สามารถเริ่มเครื่องยนต์ได้ในขณะนี้ลองใหม่อีกครั้ง");

	if((id = PlayerCar_GetID(vehicleid)) != -1)
    {

		/*if(playerCarData[id][carBatteryL] <= 0.0) {
			return SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่สามารถเริ่มเครื่องยนต์ได้เนื่องจากแบตเตอรี่ หมดอายุการใช้งาน/ได้รับความเสียหาย");
		}
		else if(playerCarData[id][carEngineL] <= 0.0) {
			return SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่สามารถเริ่มเครื่องยนต์ได้เนื่องจากเครื่องยนต์ หมดอายุการใช้งาน/ได้รับความเสียหาย");
		}*/

		if(playerData[playerid][pPCarkey] != id && playerData[playerid][pPDupkey] != playerCarData[id][carDupKey] && !GetEngineStatus(vehicleid)) {

            if(h_vid[playerid] == -1)
            {
	            new string[128];
	            // Hotwire
			 	h_vid[playerid]=id;
				h_times[playerid] = 20 * (6-playerCarData[id][carImmob]);
                h_failed[playerid]=0;
				h_wid[playerid] = random(sizeof(ScrambleWord));
				h_word[playerid] = CreateScramble(ScrambleWord[h_wid[playerid]]);
				CreateScramble(h_word[playerid]);

				format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~/(uns)cramber ~w~<unscrambled word> ~r~to unscramble the word.~n~'~w~%s~r~'.~n~You have ~w~%d ~r~seconds left to finish.", h_word[playerid], h_times[playerid]);
	            Mobile_GameTextForPlayer(playerid, string, 8000, 3);

				SendClientMessage(playerid, COLOR_LIGHTRED, "คุณกำลังต่อสายตรงยานพาหนะคันนี้ ใช้ /uns [ศัพท์]");
				SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องเรียงศัพท์ภาษาอังกฤษให้ถูกต้องให้มากที่สุด เพื่อปลดล็อกยานพาหนะคันนี้");
			}
            return 1;
        }
        else {
			canstart = true;
		}
    }

	if(Vehicle_GetID(vehicleid) != -1 || RentCarKey[playerid] == vehicleid || canstart)
	{
		switch (GetEngineStatus(vehicleid))
		{
			case false:
			{
				GetVehicleHealth(vehicleid,vhealth);

				if(vhealth > 650)
				{
					TogglePlayerControllable(playerid, true);
					SetEngineStatus(vehicleid, true);
					Mobile_GameTextForPlayer(playerid, "~g~Engine On", 2000, 4);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s เริ่มเครื่องยนต์ของ %s", ReturnRealName(playerid), g_arrVehicleNames[GetVehicleModel(vehicleid) - 400]);
				}
				/*else if(vhealth < 390) {
					if(vehicleData[vehicleid][vehicleBadlyDamage] == 0) {

					}
					else {
						GameTextForPlayer(playerid, "~r~ENGINE COULDN'T START DUE TO DAMAGE", 5000, 4);
					}
					return 1;
				}*/
				else
				{
					new owner_delay;
					if(id != -1) owner_delay = floatround((GetVehicleDataEngine(playerCarData[id][carModel]) - playerCarData[id][carEngineL]) / 25);
					new delay = floatround(1300/vhealth) + owner_delay;
					if(delay > 5) { delay = 5; }

					if(delay == 0)
					{
						TogglePlayerControllable(playerid, true);
						SetEngineStatus(vehicleid, true);
						Mobile_GameTextForPlayer(playerid, "~g~Engine On", 2000, 4);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s เริ่มเครื่องยนต์ของ %s", ReturnRealName(playerid), g_arrVehicleNames[GetVehicleModel(vehicleid) - 400]);
					}
					else
					{
						vehicleData[vehicleid][startup_delay] = delay;
						vehicleData[vehicleid][startup_delay_sender] = playerid;
						vehicleData[vehicleid][startup_delay_random] = delay;
					}
				}
				SetCooldown(playerid,COOLDOWN_ENGINE,3);
			}
			case true:
			{
				TogglePlayerControllable(playerid, false);
				SetEngineStatus(vehicleid, false);
				SetLightStatus(vehicleid, false);
				Mobile_GameTextForPlayer(playerid, "~r~Engine Off", 2000, 4);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s หยุดเครื่องยนต์ของ %s", ReturnRealName(playerid), g_arrVehicleNames[GetVehicleModel(vehicleid) - 400]);
				//StopCarBoomBox(vehicleid);
			}
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: คำสั่งนี้สามารถใช้ได้เฉพาะยานพาหนะส่วนตัว แต่คุณอยู่ในยานพาหนะสาธารณะ (Static)");
		return 1;
	}
	return 1;
}

hook OP_StateChange(playerid, newstate, oldstate)
{
	#if defined SV_DEBUG
		printf("vehicle_engine.pwn: OnPlayerStateChange(playerid %d, newstate %d, oldstate %d)", playerid, newstate, oldstate);
	#endif
	if (oldstate == PLAYER_STATE_DRIVER)
	{
		if(h_vid[playerid] != -1) {
			Mobile_GameTextForPlayer(playerid, "~r~You're left the vehicle.~n~~w~Hotwiring process ended.", 5000, 3);
			h_vid[playerid]=-1; h_times[playerid]=0; h_wid[playerid]=-1; h_score[playerid]=0; h_failed[playerid]=0;
			h_word[playerid][0]='\0';
		}
	}

	if (newstate == PLAYER_STATE_DRIVER)
	{
	    new vehicleid, id = -1;
		vehicleid = GetPlayerVehicleID(playerid);

		if (!IsEngineVehicle(vehicleid) && IsVehicleRental(vehicleid) == -1) {
			SetEngineStatus(vehicleid, true);
		}

		if (GetLockStatus(vehicleid)) {
			if (!VDealerSetting{playerid} && !(IsVehicleRental(vehicleid) != -1 && RentCarKey[playerid] == vehicleid) && !((id = PlayerCar_GetID(vehicleid)) != -1 && playerCarData[id][carOwner] == playerData[playerid][pSID]) || (IsAdminVehicle(vehicleid) && !playerData[playerid][pAdmin])) {
				SendClientMessage(playerid, COLOR_GRAD1, "   รถคันนี้ล็อกอยู่");
				Mobile_GameTextForPlayer(playerid, "~r~This vehicle Locked", 4000, 4);
				RemovePlayerFromVehicle(playerid);

				//TogglePlayerControllable(playerid, false);
				/*RemovePlayerFromVehicle(playerid);
				
				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);
				SetPlayerPos(playerid, x, y, z+2);

				PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);*/

				return 1;
			}
		}

		if(!GetEngineStatus(vehicleid) && IsEngineVehicle(vehicleid)) {
			if(Vehicle_GetID(vehicleid) != -1 || RentCarKey[playerid] == vehicleid || ((id = PlayerCar_GetID(vehicleid)) != -1))
				SendClientMessage(playerid, COLOR_GREEN, "เครื่องยนต์ดับอยู่ (/en)gine");

			TogglePlayerControllable(playerid, false);

			return 1;
		}
	}
    return 1;
}

// HOTWIRE
ptask HotwireTimer[1000](playerid) {
	if(h_times[playerid] > 0)
	{
		new str[145];
		format(str, sizeof(str), "~y~/(uns)cramber ~w~<unscrambled word> ~r~to unscramble the word.~n~'~w~%s~r~'.~n~You have ~w~%d ~r~seconds left to finish.", h_word[playerid], h_times[playerid]);
		Mobile_GameTextForPlayer(playerid, str, 8000, 3);
			
		h_times[playerid]--;
		if(h_times[playerid] <= 0)
		{
			// TAZER
			new
				Float:x,
				Float:y,
				Float:z;

			GetPlayerPos(playerid, x, y, z);
			SetPlayerPos(playerid, x, y, z+2);
			ApplyAnimation(playerid, "PED", "KO_skid_front", 4.1, 0, 0, 1, 1, 0, 1);
			BitFlag_On(gPlayerBitFlag[playerid], IS_TAZERED);
			TogglePlayerControllable(playerid, false);
			SetPlayerDrunkLevel(playerid, 4000);
			// SetTimerEx("SetUnTazed", 10000, 0, "i", playerid);
			defer SetUnTazed(playerid);
			Mobile_GameTextForPlayer(playerid, "YOU ARE TAZER", 5000, 5);
			h_vid[playerid]=-1; h_times[playerid]=0; h_wid[playerid]=-1; h_failed[playerid]=0;
			h_word[playerid][0]='\0';
		}
	}
	return 1;
}

timer SetUnTazed[10000](playerid)
{
    ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
    BitFlag_Off(gPlayerBitFlag[playerid], IS_TAZERED);
	SetPlayerDrunkLevel(playerid, 1000);
	TogglePlayerControllable(playerid, true);
	return 1;
}

alias:unscramble("uns");
CMD:unscramble(playerid, params[])
{
    new string[128], vehicleid, Float:vhealth;

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: /(uns)cramble <unscrambled word>");

	if(IsPlayerInAnyVehicle(playerid) && h_vid[playerid] != -1)
	{
	    vehicleid = playerCarData[h_vid[playerid]][carVehicle];

		if(GetPlayerVehicleID(playerid) == vehicleid)
		{
		    if(isequal(params, ScrambleWord[h_wid[playerid]], true))
		    {
		        h_score[playerid]++;
		        if(h_score[playerid] >= 10)
		        {
		            vehicleid = playerCarData[h_vid[playerid]][carVehicle];
			    	GetVehicleHealth(vehicleid, vhealth);
	                PlayerPlaySound(playerid, 21002, 0.0, 0.0, 0.0);

	                h_vid[playerid]=-1; h_times[playerid]=0; h_wid[playerid]=-1; h_score[playerid]=0; h_failed[playerid]=0;
	                h_word[playerid][0]='\0';

				    if(vhealth > 650)
				    {
						TogglePlayerControllable(playerid, true);
						SetEngineStatus(vehicleid, true);
					 	Mobile_GameTextForPlayer(playerid, "~g~Engine On", 2000, 4);
					  	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s เริ่มเครื่องยนต์ของ %s", ReturnRealName(playerid), g_arrVehicleNames[GetVehicleModel(vehicleid) - 400]);
					}
					else
					{
				 	    new delay = floatround(900/vhealth);
					    if(delay > 3) { delay = 3; }

						if(delay == 0)
						{
							TogglePlayerControllable(playerid, true);
							SetEngineStatus(vehicleid, true);
						}
						else
						{
		    	 			vehicleData[vehicleid][startup_delay] = delay;
							vehicleData[vehicleid][startup_delay_sender] = playerid;
							vehicleData[vehicleid][startup_delay_random] = delay;
						}
						Mobile_GameTextForPlayer(playerid, "~g~Engine On", 2000, 4);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s เริ่มเครื่องยนต์ของ %s", ReturnRealName(playerid), g_arrVehicleNames[GetVehicleModel(vehicleid) - 400]);
					}
					return 1;
			 	}
				else PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
		    }
		    else {

				PlayerPlaySound(playerid, 21001, 0.0, 0.0, 0.0);

				h_failed[playerid]++;

	            if(h_failed[playerid] >= 6)
	            {
	                // TAZER
					new
					    Float:x,
					    Float:y,
					    Float:z;

					GetPlayerPos(playerid, x, y, z);
					SetPlayerPos(playerid, x, y, z+2);
					ApplyAnimation(playerid, "PED", "KO_skid_front", 4.1, 0, 0, 1, 1, 0, 1);
					//ApplyAnimation(playerid, "CRACK", "crckdeth4", 4.0, 0, 0, 0, 1, 0, 1);
					BitFlag_On(gPlayerBitFlag[playerid], IS_TAZERED);
					TogglePlayerControllable(playerid, false);
					defer SetUnTazed(playerid);
		         	h_vid[playerid]=-1; h_times[playerid]=0; h_wid[playerid]=-1; h_score[playerid]=0; h_failed[playerid]=0;
		          	h_word[playerid][0]='\0';

	                Mobile_GameTextForPlayer(playerid, "YOU ARE TAZER", 5000, 5);
	                return 1;
	            }
			}
			h_wid[playerid] = random(sizeof(ScrambleWord));
			h_word[playerid] = CreateScramble(ScrambleWord[h_wid[playerid]]);

			format(string, sizeof(string), "~y~/(uns)cramber ~w~<unscrambled word> ~r~to unscramble the word.~n~'~w~%s~r~'.", h_word[playerid]);
		 	Mobile_GameTextForPlayer(playerid, string, 8000, 3);
		}
	}
	return 1;
}