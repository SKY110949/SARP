#include <YSI\y_hooks>

new displayHUD[MAX_PLAYERS char];
new isHideHUD[MAX_PLAYERS char];
new isVehicleHUD[MAX_PLAYERS char];

new Text:ui_bgVHP;
new Text:ui_bgBarVHP;
new Text:ui_bgLocks;
new Text:ui_bgFuel;
new Text:ui_bgBarFuel;
new Text:ui_bgMPH;
new Text:ui_bgStatus;
new Text:ui_iconFuel;
new Text:ui_iconVeh;
new Text:ui_iconLights;
new Text:ui_iconVehFire;
new Text:ui_textMPH;
new Text:ui_textFuel;

new Text:ui_website;
new Text:ui_clock;
new PlayerText:ui_progressBarVHP[MAX_PLAYERS];
new PlayerText:ui_speedMPH[MAX_PLAYERS];
new PlayerText:ui_progressBarGas[MAX_PLAYERS];
new PlayerText:ui_lockStatus[MAX_PLAYERS];
new PlayerText:ui_milesStatus[MAX_PLAYERS];
new PlayerText:ui_zone[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {

    displayHUD{ playerid } = false;
    isHideHUD{ playerid } = false;
    isVehicleHUD { playerid } = false;

    // On Foot
    ui_zone[playerid] = CreatePlayerTextDraw(playerid, 635.000000, 428.000000, "San Andreas");
    PlayerTextDrawFont(playerid, ui_zone[playerid], 2);
    PlayerTextDrawLetterSize(playerid, ui_zone[playerid], 0.258329, 1.499994);
    PlayerTextDrawTextSize(playerid, ui_zone[playerid], 431.500000, 0.500000);
    PlayerTextDrawSetOutline(playerid, ui_zone[playerid], 1);
    PlayerTextDrawSetShadow(playerid, ui_zone[playerid], 0);
    PlayerTextDrawAlignment(playerid, ui_zone[playerid], 3);
    PlayerTextDrawColor(playerid, ui_zone[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, ui_zone[playerid], 255);
    PlayerTextDrawBoxColor(playerid, ui_zone[playerid], 50);
    PlayerTextDrawUseBox(playerid, ui_zone[playerid], 0);
    PlayerTextDrawSetProportional(playerid, ui_zone[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, ui_zone[playerid], 0);

    // On Vehicle
    ui_progressBarVHP[playerid] = CreatePlayerTextDraw(playerid, 558.000000, 417.000000, "_");
    PlayerTextDrawFont(playerid, ui_progressBarVHP[playerid], 1);
    PlayerTextDrawLetterSize(playerid, ui_progressBarVHP[playerid], 0.508328, -0.049995);
    PlayerTextDrawTextSize(playerid, ui_progressBarVHP[playerid], 615.000000, 26.000000);
    PlayerTextDrawSetOutline(playerid, ui_progressBarVHP[playerid], 1);
    PlayerTextDrawSetShadow(playerid, ui_progressBarVHP[playerid], 0);
    PlayerTextDrawAlignment(playerid, ui_progressBarVHP[playerid], 1);
    PlayerTextDrawColor(playerid, ui_progressBarVHP[playerid], -1138283009);
    PlayerTextDrawBackgroundColor(playerid, ui_progressBarVHP[playerid], 255);
    PlayerTextDrawBoxColor(playerid, ui_progressBarVHP[playerid], -1138283009);
    PlayerTextDrawUseBox(playerid, ui_progressBarVHP[playerid], 1);
    PlayerTextDrawSetProportional(playerid, ui_progressBarVHP[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, ui_progressBarVHP[playerid], 0);

    ui_lockStatus[playerid] = CreatePlayerTextDraw(playerid, 526.000000, 411.000000, "mdl-2002:Locks-Unlocked");
    PlayerTextDrawFont(playerid, ui_lockStatus[playerid], 4);
    PlayerTextDrawLetterSize(playerid, ui_lockStatus[playerid], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, ui_lockStatus[playerid], 10.000000, 10.000000);
    PlayerTextDrawSetOutline(playerid, ui_lockStatus[playerid], 1);
    PlayerTextDrawSetShadow(playerid, ui_lockStatus[playerid], 0);
    PlayerTextDrawAlignment(playerid, ui_lockStatus[playerid], 1);
    PlayerTextDrawColor(playerid, ui_lockStatus[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, ui_lockStatus[playerid], 255);
    PlayerTextDrawBoxColor(playerid, ui_lockStatus[playerid], 50);
    PlayerTextDrawUseBox(playerid, ui_lockStatus[playerid], 1);
    PlayerTextDrawSetProportional(playerid, ui_lockStatus[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, ui_lockStatus[playerid], 0);

    ui_progressBarGas[playerid] = CreatePlayerTextDraw(playerid, 564.000000, 390.000000, "_");
    PlayerTextDrawFont(playerid, ui_progressBarGas[playerid], 1);
    PlayerTextDrawLetterSize(playerid, ui_progressBarGas[playerid], 0.508328, -0.049995);
    PlayerTextDrawTextSize(playerid, ui_progressBarGas[playerid], 631.500000, 26.000000);
    PlayerTextDrawSetOutline(playerid, ui_progressBarGas[playerid], 1);
    PlayerTextDrawSetShadow(playerid, ui_progressBarGas[playerid], 0);
    PlayerTextDrawAlignment(playerid, ui_progressBarGas[playerid], 1);
    PlayerTextDrawColor(playerid, ui_progressBarGas[playerid], -1138283009);
    PlayerTextDrawBackgroundColor(playerid, ui_progressBarGas[playerid], 255);
    PlayerTextDrawBoxColor(playerid, ui_progressBarGas[playerid], 1168161535);
    PlayerTextDrawUseBox(playerid, ui_progressBarGas[playerid], 1);
    PlayerTextDrawSetProportional(playerid, ui_progressBarGas[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, ui_progressBarGas[playerid], 0);

    ui_milesStatus[playerid] = CreatePlayerTextDraw(playerid, 630.000000, 373.000000, "619 MI");
    PlayerTextDrawFont(playerid, ui_milesStatus[playerid], 2);
    PlayerTextDrawLetterSize(playerid, ui_milesStatus[playerid], 0.204162, 1.250000);
    PlayerTextDrawTextSize(playerid, ui_milesStatus[playerid], 618.000000, 15.000000);
    PlayerTextDrawSetOutline(playerid, ui_milesStatus[playerid], 0);
    PlayerTextDrawSetShadow(playerid, ui_milesStatus[playerid], 0);
    PlayerTextDrawAlignment(playerid, ui_milesStatus[playerid], 3);
    PlayerTextDrawColor(playerid, ui_milesStatus[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, ui_milesStatus[playerid], 255);
    PlayerTextDrawBoxColor(playerid, ui_milesStatus[playerid], 50);
    PlayerTextDrawUseBox(playerid, ui_milesStatus[playerid], 0);
    PlayerTextDrawSetProportional(playerid, ui_milesStatus[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, ui_milesStatus[playerid], 0);

    ui_speedMPH[playerid] = CreatePlayerTextDraw(playerid, 542.000000, 373.000000, "0");
    PlayerTextDrawFont(playerid, ui_speedMPH[playerid], 2);
    PlayerTextDrawLetterSize(playerid, ui_speedMPH[playerid], 0.345831, 1.899996);
    PlayerTextDrawTextSize(playerid, ui_speedMPH[playerid], 618.000000, 15.000000);
    PlayerTextDrawSetOutline(playerid, ui_speedMPH[playerid], 0);
    PlayerTextDrawSetShadow(playerid, ui_speedMPH[playerid], 1);
    PlayerTextDrawAlignment(playerid, ui_speedMPH[playerid], 2);
    PlayerTextDrawColor(playerid, ui_speedMPH[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, ui_speedMPH[playerid], 255);
    PlayerTextDrawBoxColor(playerid, ui_speedMPH[playerid], 50);
    PlayerTextDrawUseBox(playerid, ui_speedMPH[playerid], 0);
    PlayerTextDrawSetProportional(playerid, ui_speedMPH[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, ui_speedMPH[playerid], 0);  
    return 1;
}

hook OnGameModeInit() {
    ui_bgVHP = TextDrawCreate(542.000000, 410.000000, "_");
    TextDrawFont(ui_bgVHP, 1);
    TextDrawLetterSize(ui_bgVHP, 0.600000, 1.550004);
    TextDrawTextSize(ui_bgVHP, 631.000000, 60.000000);
    TextDrawSetOutline(ui_bgVHP, 1);
    TextDrawSetShadow(ui_bgVHP, 0);
    TextDrawAlignment(ui_bgVHP, 1);
    TextDrawColor(ui_bgVHP, 255);
    TextDrawBackgroundColor(ui_bgVHP, 255);
    TextDrawBoxColor(ui_bgVHP, 421075455);
    TextDrawUseBox(ui_bgVHP, 1);
    TextDrawSetProportional(ui_bgVHP, 1);
    TextDrawSetSelectable(ui_bgVHP, 0);

    ui_bgBarVHP = TextDrawCreate(558.000000, 417.000000, "_");
    TextDrawFont(ui_bgBarVHP, 1);
    TextDrawLetterSize(ui_bgBarVHP, 0.508328, -0.049995);
    TextDrawTextSize(ui_bgBarVHP, 615.000000, 26.000000);
    TextDrawSetOutline(ui_bgBarVHP, 1);
    TextDrawSetShadow(ui_bgBarVHP, 0);
    TextDrawAlignment(ui_bgBarVHP, 1);
    TextDrawColor(ui_bgBarVHP, -1138283009);
    TextDrawBackgroundColor(ui_bgBarVHP, 255);
    TextDrawBoxColor(ui_bgBarVHP, 252645375);
    TextDrawUseBox(ui_bgBarVHP, 1);
    TextDrawSetProportional(ui_bgBarVHP, 1);
    TextDrawSetSelectable(ui_bgBarVHP, 0);

    ui_bgLocks = TextDrawCreate(525.000000, 410.000000, "_");
    TextDrawFont(ui_bgLocks, 1);
    TextDrawLetterSize(ui_bgLocks, 0.600000, 1.550004);
    TextDrawTextSize(ui_bgLocks, 537.000000, 60.000000);
    TextDrawSetOutline(ui_bgLocks, 1);
    TextDrawSetShadow(ui_bgLocks, 0);
    TextDrawAlignment(ui_bgLocks, 1);
    TextDrawColor(ui_bgLocks, 255);
    TextDrawBackgroundColor(ui_bgLocks, 255);
    TextDrawBoxColor(ui_bgLocks, 421075455);
    TextDrawUseBox(ui_bgLocks, 1);
    TextDrawSetProportional(ui_bgLocks, 1);
    TextDrawSetSelectable(ui_bgLocks, 0);

    ui_textMPH = TextDrawCreate(532.000000, 390.000000, "MPH");
    TextDrawFont(ui_textMPH, 2);
    TextDrawLetterSize(ui_textMPH, 0.204162, 1.250000);
    TextDrawTextSize(ui_textMPH, 618.000000, 15.000000);
    TextDrawSetOutline(ui_textMPH, 0);
    TextDrawSetShadow(ui_textMPH, 1);
    TextDrawAlignment(ui_textMPH, 1);
    TextDrawColor(ui_textMPH, -1);
    TextDrawBackgroundColor(ui_textMPH, 255);
    TextDrawBoxColor(ui_textMPH, 50);
    TextDrawUseBox(ui_textMPH, 0);
    TextDrawSetProportional(ui_textMPH, 1);
    TextDrawSetSelectable(ui_textMPH, 0);

    ui_iconVeh = TextDrawCreate(620.000000, 412.000000, "mdl-2002:Fire-Off");
    TextDrawFont(ui_iconVeh, 4);
    TextDrawLetterSize(ui_iconVeh, 0.600000, 2.000000);
    TextDrawTextSize(ui_iconVeh, 10.000000, 10.000000);
    TextDrawSetOutline(ui_iconVeh, 1);
    TextDrawSetShadow(ui_iconVeh, 0);
    TextDrawAlignment(ui_iconVeh, 1);
    TextDrawColor(ui_iconVeh, -1);
    TextDrawBackgroundColor(ui_iconVeh, 255);
    TextDrawBoxColor(ui_iconVeh, 50);
    TextDrawUseBox(ui_iconVeh, 1);
    TextDrawSetProportional(ui_iconVeh, 1);
    TextDrawSetSelectable(ui_iconVeh, 0);

    ui_bgMPH = TextDrawCreate(525.000000, 374.000000, "_");
    TextDrawFont(ui_bgMPH, 1);
    TextDrawLetterSize(ui_bgMPH, 0.600000, 3.299998);
    TextDrawTextSize(ui_bgMPH, 559.000000, 60.000000);
    TextDrawSetOutline(ui_bgMPH, 1);
    TextDrawSetShadow(ui_bgMPH, 0);
    TextDrawAlignment(ui_bgMPH, 1);
    TextDrawColor(ui_bgMPH, 255);
    TextDrawBackgroundColor(ui_bgMPH, 255);
    TextDrawBoxColor(ui_bgMPH, 421075455);
    TextDrawUseBox(ui_bgMPH, 1);
    TextDrawSetProportional(ui_bgMPH, 1);
    TextDrawSetSelectable(ui_bgMPH, 0);

    ui_bgFuel = TextDrawCreate(564.000000, 390.000000, "_");
    TextDrawFont(ui_bgFuel, 1);
    TextDrawLetterSize(ui_bgFuel, 0.600000, 1.550004);
    TextDrawTextSize(ui_bgFuel, 631.000000, 60.000000);
    TextDrawSetOutline(ui_bgFuel, 1);
    TextDrawSetShadow(ui_bgFuel, 0);
    TextDrawAlignment(ui_bgFuel, 1);
    TextDrawColor(ui_bgFuel, 255);
    TextDrawBackgroundColor(ui_bgFuel, 255);
    TextDrawBoxColor(ui_bgFuel, 421075455);
    TextDrawUseBox(ui_bgFuel, 1);
    TextDrawSetProportional(ui_bgFuel, 1);
    TextDrawSetSelectable(ui_bgFuel, 0);

    ui_bgBarFuel = TextDrawCreate(564.000000, 390.000000, "_");
    TextDrawFont(ui_bgBarFuel, 1);
    TextDrawLetterSize(ui_bgBarFuel, 0.508328, -0.049995);
    TextDrawTextSize(ui_bgBarFuel, 631.000000, 26.000000);
    TextDrawSetOutline(ui_bgBarFuel, 1);
    TextDrawSetShadow(ui_bgBarFuel, 0);
    TextDrawAlignment(ui_bgBarFuel, 1);
    TextDrawColor(ui_bgBarFuel, -1138283009);
    TextDrawBackgroundColor(ui_bgBarFuel, 255);
    TextDrawBoxColor(ui_bgBarFuel, 252645375);
    TextDrawUseBox(ui_bgBarFuel, 1);
    TextDrawSetProportional(ui_bgBarFuel, 1);
    TextDrawSetSelectable(ui_bgBarFuel, 0);

    ui_iconFuel = TextDrawCreate(580.000000, 394.000000, "mdl-2002:Fuel");
    TextDrawFont(ui_iconFuel, 4);
    TextDrawLetterSize(ui_iconFuel, 0.600000, 2.000000);
    TextDrawTextSize(ui_iconFuel, 10.000000, 10.000000);
    TextDrawSetOutline(ui_iconFuel, 1);
    TextDrawSetShadow(ui_iconFuel, 0);
    TextDrawAlignment(ui_iconFuel, 1);
    TextDrawColor(ui_iconFuel, -1);
    TextDrawBackgroundColor(ui_iconFuel, 255);
    TextDrawBoxColor(ui_iconFuel, 50);
    TextDrawUseBox(ui_iconFuel, 1);
    TextDrawSetProportional(ui_iconFuel, 1);
    TextDrawSetSelectable(ui_iconFuel, 0);

    ui_bgStatus = TextDrawCreate(564.000000, 374.000000, "_");
    TextDrawFont(ui_bgStatus, 1);
    TextDrawLetterSize(ui_bgStatus, 0.600000, 1.150004);
    TextDrawTextSize(ui_bgStatus, 631.000000, 60.000000);
    TextDrawSetOutline(ui_bgStatus, 1);
    TextDrawSetShadow(ui_bgStatus, 0);
    TextDrawAlignment(ui_bgStatus, 1);
    TextDrawColor(ui_bgStatus, 255);
    TextDrawBackgroundColor(ui_bgStatus, 255);
    TextDrawBoxColor(ui_bgStatus, 421075455);
    TextDrawUseBox(ui_bgStatus, 1);
    TextDrawSetProportional(ui_bgStatus, 1);
    TextDrawSetSelectable(ui_bgStatus, 0);

    ui_iconLights = TextDrawCreate(565.000000, 375.000000, "mdl-2002:Lights");
    TextDrawFont(ui_iconLights, 4);
    TextDrawLetterSize(ui_iconLights, 0.600000, 2.000000);
    TextDrawTextSize(ui_iconLights, 10.000000, 10.000000);
    TextDrawSetOutline(ui_iconLights, 1);
    TextDrawSetShadow(ui_iconLights, 0);
    TextDrawAlignment(ui_iconLights, 1);
    TextDrawColor(ui_iconLights, -1);
    TextDrawBackgroundColor(ui_iconLights, 255);
    TextDrawBoxColor(ui_iconLights, 50);
    TextDrawUseBox(ui_iconLights, 1);
    TextDrawSetProportional(ui_iconLights, 1);
    TextDrawSetSelectable(ui_iconLights, 0);

    ui_iconVehFire = TextDrawCreate(543.000000, 412.000000, "mdl-2002:Fire-On");
    TextDrawFont(ui_iconVehFire, 4);
    TextDrawLetterSize(ui_iconVehFire, 0.600000, 2.000000);
    TextDrawTextSize(ui_iconVehFire, 10.000000, 10.000000);
    TextDrawSetOutline(ui_iconVehFire, 1);
    TextDrawSetShadow(ui_iconVehFire, 0);
    TextDrawAlignment(ui_iconVehFire, 1);
    TextDrawColor(ui_iconVehFire, -1);
    TextDrawBackgroundColor(ui_iconVehFire, 255);
    TextDrawBoxColor(ui_iconVehFire, 50);
    TextDrawUseBox(ui_iconVehFire, 1);
    TextDrawSetProportional(ui_iconVehFire, 1);
    TextDrawSetSelectable(ui_iconVehFire, 0);

    ui_textFuel = TextDrawCreate(592.000000, 393.000000, "Fuel");
    TextDrawFont(ui_textFuel, 2);
    TextDrawLetterSize(ui_textFuel, 0.204162, 1.250000);
    TextDrawTextSize(ui_textFuel, 618.000000, 15.000000);
    TextDrawSetOutline(ui_textFuel, 0);
    TextDrawSetShadow(ui_textFuel, 0);
    TextDrawAlignment(ui_textFuel, 1);
    TextDrawColor(ui_textFuel, -1);
    TextDrawBackgroundColor(ui_textFuel, 255);
    TextDrawBoxColor(ui_textFuel, 50);
    TextDrawUseBox(ui_textFuel, 0);
    TextDrawSetProportional(ui_textFuel, 1);
    TextDrawSetSelectable(ui_textFuel, 0);

   /* ui_website = TextDrawCreate(70.000000, 428.000000, "www.open-tp.net");
    TextDrawFont(ui_website, 2);
    TextDrawLetterSize(ui_website, 0.174998, 1.100000);
    TextDrawTextSize(ui_website, 400.000000, 18.500000);
    TextDrawSetOutline(ui_website, 1);
    TextDrawSetShadow(ui_website, 0);
    TextDrawAlignment(ui_website, 2);
    TextDrawColor(ui_website, -1);
    TextDrawBackgroundColor(ui_website, 255);
    TextDrawBoxColor(ui_website, 50);
    TextDrawUseBox(ui_website, 0);
    TextDrawSetProportional(ui_website, 1);
    TextDrawSetSelectable(ui_website, 0);*/

    ui_clock = TextDrawCreate(618.000000, 6.000000, "~y~6 May ~w~18:50:07");
    TextDrawFont(ui_clock, 3);
    TextDrawLetterSize(ui_clock, 0.487497, 1.349997);
    TextDrawTextSize(ui_clock, 400.000000, 18.500000);
    TextDrawSetOutline(ui_clock, 2);
    TextDrawSetShadow(ui_clock, 0);
    TextDrawAlignment(ui_clock, 3);
    TextDrawColor(ui_clock, -1);
    TextDrawBackgroundColor(ui_clock, 255);
    TextDrawBoxColor(ui_clock, 50);
    TextDrawUseBox(ui_clock, 0);
    TextDrawSetProportional(ui_clock, 1);
    TextDrawSetSelectable(ui_clock, 0);
    return 1;
}

hook OnPlayerSpawn(playerid) {
    displayHUD{playerid} = true;
    showPlayerHUD(playerid);
    return 1;
}

stock showPlayerHUD(playerid) {

    PlayerTextDrawShow(playerid, ui_zone[playerid]);
    TextDrawShowForPlayer(playerid, ui_website);
    TextDrawShowForPlayer(playerid, ui_clock);

    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
        isVehicleHUD { playerid } = true;
        //showVehicleHUD(playerid);
    }

    isHideHUD{ playerid } = false;
}

stock hidePlayerHUD(playerid) {
    PlayerTextDrawHide(playerid, ui_zone[playerid]);
    TextDrawHideForPlayer(playerid, ui_website);
    TextDrawHideForPlayer(playerid, ui_clock);

    hideVehicleHUD(playerid);
    isHideHUD{ playerid } = true;
}

ptask UI_UpdateTimer[1000](playerid) {

    new hHours, hMins, hSecs;
    new year, month,day;
    getdate(year, month, day);
    GetRealTime(hHours, hMins, hSecs);
    TextDrawSetString(ui_clock, sprintf("~y~%d %s ~w~%02d:%02d:%02d", day, MONTH_DAY_SHORT[month-1], hHours, hMins,  hSecs));

    if(BitFlag_Get(gPlayerBitFlag[playerid], IS_SPAWNED) && displayHUD{playerid} && !isHideHUD{ playerid }  && !BitFlag_Get(gPlayerBitFlag[playerid], TOGGLE_HUD) && !playerData[playerid][pJailed]) {

        new Float:x, Float:y, Float:z;
        GetDynamicPlayerPos(playerid, x, y, z);
        PlayerTextDrawSetString(playerid, ui_zone[playerid], GetCoordsZone(x, y));

        //
        new vehicleid = GetPlayerVehicleID(playerid);
        if (isVehicleHUD { playerid } && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {

                new modelid = GetVehicleModel(vehicleid);
                //

                new Float:speedMPH = GetVehicleSpeed(vehicleid, true); // MPH
                new Float:MPS = speedMPH / 3600.0;

                vehicleData[vehicleid][vMiles] += MPS; 
                // vehicleData[vehicleid][vFuel] -= (((speedMPH <= 5.0 ? 0.00138888 : MPS) * MPG) / 24.32);

                new Float:vhp;
                GetVehicleHealth(vehicleid, vhp);
                vhp = (GetVehicleDataHealth(modelid) - vhp) / ((GetVehicleDataHealth(modelid) - 250.0) / 60.0);
                if (vhp > 60.0) vhp = 60.0;
                else if (vhp < 0.0) vhp = 0.0;
                PlayerTextDrawTextSize(playerid, ui_progressBarVHP[playerid], 615.0 - vhp, 26.000000);
                PlayerTextDrawShow(playerid, ui_progressBarVHP[playerid]);
                PlayerTextDrawSetString(playerid, ui_speedMPH[playerid], sprintf("%d", floatround(speedMPH)));

                new Float:vfuel = (GetVehicleDataFuel(modelid) - vehicleData[vehicleid][vFuel]) / (GetVehicleDataFuel(modelid) / 70.0); // 100.0 / 70.0
                if (vfuel > 70.0) vfuel = 70.0;
                else if (vfuel < 0.0) vfuel = 0.0;
                PlayerTextDrawTextSize(playerid, ui_progressBarGas[playerid], 631.0 - vfuel, 26.000000);
                PlayerTextDrawShow(playerid, ui_progressBarGas[playerid]);
            
                if (GetLockStatus(vehicleid)) PlayerTextDrawSetString(playerid, ui_lockStatus[playerid], "mdl-2002:Locks-Locked");
                else PlayerTextDrawSetString(playerid, ui_lockStatus[playerid], "mdl-2002:Locks-Unlocked");

                if (GetLightStatus(vehicleid)) TextDrawShowForPlayer(playerid, ui_iconLights);
                else TextDrawHideForPlayer(playerid, ui_iconLights);
    
                PlayerTextDrawSetString(playerid, ui_milesStatus[playerid], sprintf("%d MI", floatround(vehicleData[vehicleid][vMiles])));


//
                if (!Mobile_IsGameTextShow(playerid) && !gRestartTime && isPlayerAndroid(playerid) != 0) {
                    new Float:fuel = GetVehicleDataFuel(modelid);
                    //new Float:speedMPH = GetVehicleSpeed(vehicleid, true);

                    if (!IsEngineVehicle(vehicleid)) {
                        GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~%s", ReturnVehicleModelName(modelid)), 2000, 3);
                    }
                    else GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~%s~n~~g~MPH:~w~ %d ~r~Fuel:~w~ %d %%", ReturnVehicleModelName(modelid), floatround(speedMPH), floatround((vehicleData[vehicleid][vFuel] / fuel) * 100.0)), 2000, 3);
                }
 //
        }
        else {
                if (!Mobile_IsGameTextShow(playerid) && !gRestartTime && isPlayerAndroid(playerid) != 0) {
                    new expamount = (playerData[playerid][pLevel]+1)*MULTIPLE_EXP;
                    GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~ID:~w~ %d  ~g~Score:~w~ %d  ~r~Level:~w~ %d (%d/%d)", playerid, playerData[playerid][pScore], playerData[playerid][pLevel], playerData[playerid][pExp], expamount), 2000, 3);
                }
        }
    }
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	#if defined SV_DEBUG
		printf("baseUI.pwn: OnPlayerStateChange(playerid %d, newstate %d, oldstate %d)", playerid, newstate, oldstate);
	#endif
    if (newstate == PLAYER_STATE_DRIVER) {
        isVehicleHUD { playerid } = true;
        showVehicleHUD(playerid);
    }
    else {
        isVehicleHUD { playerid } = false;
        hideVehicleHUD(playerid);
    }
}

showVehicleHUD(playerid) {
    PlayerTextDrawShow(playerid, ui_progressBarVHP[playerid]);
    PlayerTextDrawShow(playerid, ui_speedMPH[playerid]);
    PlayerTextDrawShow(playerid, ui_progressBarGas[playerid]);
    PlayerTextDrawShow(playerid, ui_lockStatus[playerid]);
    PlayerTextDrawShow(playerid, ui_milesStatus[playerid]);

    TextDrawShowForPlayer(playerid, ui_bgVHP);
    TextDrawShowForPlayer(playerid, ui_bgBarVHP);
    TextDrawShowForPlayer(playerid, ui_bgLocks);
    TextDrawShowForPlayer(playerid, ui_bgMPH);
    TextDrawShowForPlayer(playerid, ui_bgFuel);
    TextDrawShowForPlayer(playerid, ui_bgBarFuel);
    TextDrawShowForPlayer(playerid, ui_bgStatus);
    TextDrawShowForPlayer(playerid, ui_iconVeh);
    TextDrawShowForPlayer(playerid, ui_iconVehFire);
    TextDrawShowForPlayer(playerid, ui_iconFuel);
    TextDrawShowForPlayer(playerid, ui_iconLights);
    TextDrawShowForPlayer(playerid, ui_textMPH);
    TextDrawShowForPlayer(playerid, ui_textFuel);
}

hideVehicleHUD(playerid) {
    PlayerTextDrawHide(playerid, ui_progressBarVHP[playerid]);
    PlayerTextDrawHide(playerid, ui_speedMPH[playerid]);
    PlayerTextDrawHide(playerid, ui_progressBarGas[playerid]);
    PlayerTextDrawHide(playerid, ui_lockStatus[playerid]);
    PlayerTextDrawHide(playerid, ui_milesStatus[playerid]);

    TextDrawHideForPlayer(playerid, ui_bgVHP);
    TextDrawHideForPlayer(playerid, ui_bgBarVHP);
    TextDrawHideForPlayer(playerid, ui_bgLocks);
    TextDrawHideForPlayer(playerid, ui_bgMPH);
    TextDrawHideForPlayer(playerid, ui_bgFuel);
    TextDrawHideForPlayer(playerid, ui_bgBarFuel);
    TextDrawHideForPlayer(playerid, ui_bgStatus);
    TextDrawHideForPlayer(playerid, ui_iconVeh);
    TextDrawHideForPlayer(playerid, ui_iconVehFire);
    TextDrawHideForPlayer(playerid, ui_iconFuel);
    TextDrawHideForPlayer(playerid, ui_iconLights);
    TextDrawHideForPlayer(playerid, ui_textMPH);
    TextDrawHideForPlayer(playerid, ui_textFuel);
}
