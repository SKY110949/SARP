
alias:vcontrol("vc");
CMD:vcontrol(playerid) {
    if(!IsPlayerInAnyVehicle(playerid))
    {
    	SendClientMessage(playerid, 0xCC0000FF, "ERROR : �س��ͧ���躹�ҹ��˹����ͷ���������");
    }
    else
    {
    	Dialog_Show(playerid, DIALOG_AVCSystem, DIALOG_STYLE_LIST, "Control", "Lighting ( On/Off )\nBonnect ( Open/Close )\nBoot/Trunk ( Open/Close )\nDoors ( Open/Close )\nEngine ( On/Off )", "Select", "Cancel");
    }
    return 1;
}

Dialog:DIALOG_AVCSystem(playerid, response, listitem, inputtext[]) {
    if(!response) return 1;

	new veh = GetPlayerVehicleID(playerid);
	new engine,lights,alarm,doors,bonnet,boot,objective;

    switch(listitem)
    {
        case 0:
        {
    		if(!GetLightStatus(veh))
    		{
    			SetLightStatus(veh, true);
    		}
    		else
    		{
    			SetLightStatus(veh, false);
    		}
    	}
    	case 1:
    	{
    		if(GetPVarInt(playerid, "Bonnet") == 0)
    		{
    			GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
    			SetVehicleParamsEx(veh,engine,lights,alarm,doors,VEHICLE_PARAMS_ON,boot,objective);
    			SetPVarInt(playerid, "Bonnet", 1);
    		}
    		else if(GetPVarInt(playerid, "Bonnet") == 1)
    		{
    			GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
    			SetVehicleParamsEx(veh,engine,lights,alarm,doors,VEHICLE_PARAMS_OFF,boot,objective);
    			SetPVarInt(playerid, "Bonnet", 0);
    		}
    	}
    	case 2:
    	{
    		if(GetPVarInt(playerid, "Boot") == 0)
    		{
    			GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
    			SetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,VEHICLE_PARAMS_ON,objective);
    			SetPVarInt(playerid, "Boot", 1);
    		}
    		else if(GetPVarInt(playerid, "Boot") == 1)
    		{
    			GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
    			SetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,VEHICLE_PARAMS_OFF,objective);
    			SetPVarInt(playerid, "Boot", 0);
    		}
    	}
    	case 3:
    	{
    		if(GetPVarInt(playerid, "Doors") == 0)
    		{
    			GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
    			SetVehicleParamsEx(veh,engine,lights,alarm,VEHICLE_PARAMS_ON,bonnet,boot,objective);
    			SetPVarInt(playerid, "Doors", 1);
    		}
    		else if(GetPVarInt(playerid, "Doors") == 1)
    		{
    			GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
    			SetVehicleParamsEx(veh,engine,lights,alarm,VEHICLE_PARAMS_OFF,bonnet,boot,objective);
    			SetPVarInt(playerid, "Doors", 0);
    		}
    	}
    	case 4:
    	{
            new vehicleid = GetPlayerVehicleID(playerid), Float:vhealth, bool:canstart, id = -1;

            if (!IsEngineVehicle(vehicleid))
                return SendClientMessage(playerid, COLOR_GRAD1, "   �س�����������ҹ��˹�");

            if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
                return SendClientMessage(playerid, COLOR_GRAD1, "   �س����褹�Ѻ");

            if (!vehicleData[vehicleid][vFuel])
                return SendClientMessage(playerid, COLOR_LIGHTRED, "�ҹ��˹Фѹ�������չ���ѹ");

            if(HasCooldown(playerid,COOLDOWN_ENGINE))
                return SendClientMessage(playerid, COLOR_LIGHTRED, "�������ö���������ͧ¹����㹢�й���ͧ�����ա����");

            if((id = PlayerCar_GetID(vehicleid)) != -1)
            {

                if(playerCarData[id][carBatteryL] <= 0.0) {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "�������ö���������ͧ¹�������ͧ�ҡẵ����� ������ء����ҹ/���Ѻ�����������");
                }
                else if(playerCarData[id][carEngineL] <= 0.0) {
                    return SendClientMessage(playerid, COLOR_LIGHTRED, "�������ö���������ͧ¹�������ͧ�ҡ����ͧ¹�� ������ء����ҹ/���Ѻ�����������");
                }

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

                        SendClientMessage(playerid, COLOR_LIGHTRED, "�س���ѧ�����µç�ҹ��˹Фѹ��� �� /uns [�Ѿ��]");
                        SendClientMessage(playerid, COLOR_LIGHTRED, "�س��ͧ���§�Ѿ�������ѧ������١��ͧ����ҡ����ش ���ͻŴ��͡�ҹ��˹Фѹ���");
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
                            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ���������ͧ¹��ͧ %s", ReturnRealName(playerid), g_arrVehicleNames[GetVehicleModel(vehicleid) - 400]);
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
                                SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ���������ͧ¹��ͧ %s", ReturnRealName(playerid), g_arrVehicleNames[GetVehicleModel(vehicleid) - 400]);
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
                        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ��ش����ͧ¹��ͧ %s", ReturnRealName(playerid), g_arrVehicleNames[GetVehicleModel(vehicleid) - 400]);
                        //StopCarBoomBox(vehicleid);
                    }
                }
            }
            else
            {
                SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: ����觹������ö����੾���ҹ��˹���ǹ��� ��س������ҹ��˹��Ҹ�ó� (Static)");
                return 1;
            }
    	}
    }
    return 1;
}
