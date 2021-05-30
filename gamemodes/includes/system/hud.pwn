#include <YSI\y_hooks>

#define MAX_HUD     12
#define HUD_ARMOR   0
#define HUD_HEALTH  1
#define HUD_PING    2
#define HUD_PACKET  3
#define HUD_MI      4
#define HUD_FUEL    5
#define HUD_SPEED   6
#define HUD_NOS     7
#define HUD_LOCK    8
#define HUD_ENGINE  9
#define HUD_BATTERY 10
#define HUD_LIGHT   11
/*
                                        Player HUD
*/
new Text:HUDPlayer_Ping;
new Text:HUDPlayer_PacketLoss;
new PlayerText:HUDPlayer_Armor[MAX_PLAYERS];
new PlayerText:HUDPlayer_Health[MAX_PLAYERS];
new PlayerText:HUDPlayer_ArmorRate[MAX_PLAYERS];
new PlayerText:HUDPlayer_HealthRate[MAX_PLAYERS];
new PlayerText:HUDPlayer_PingRate[MAX_PLAYERS];
new PlayerText:HUDPlayer_PacketLossRate[MAX_PLAYERS];
//new PlayerText:HUDPlayer_Clock[MAX_PLAYERS];

/*
                                        Vehicle HUD
*/
new Text:HUDMileage;
new Text:HUDBattery;
new Text:HUDLights;
new PlayerText:HUDFuel[MAX_PLAYERS];
new PlayerText:HUDZone[MAX_PLAYERS];
new PlayerText:HUDSpeedoRate[MAX_PLAYERS];
new PlayerText:HUDNos[MAX_PLAYERS];
new PlayerText:HUDLock[MAX_PLAYERS];
new PlayerText:HUDEngine[MAX_PLAYERS];
new PlayerText:HUDSpeedoMPH[MAX_PLAYERS];
new PlayerText:HUDMileageRate[MAX_PLAYERS];

new displayHUD[MAX_PLAYERS char];
new isHideHUD[MAX_PLAYERS char];
new isVehicleHUD[MAX_PLAYERS char];

new bool:HUDtoggle[MAX_PLAYERS][MAX_HUD];

hook OnPlayerConnect(playerid) {
    displayHUD{ playerid } = false;
    isHideHUD{ playerid } = false;
    isVehicleHUD { playerid } = false;

    for (new i=0; i!=MAX_HUD; i++) {
        HUDtoggle[playerid][i] = false;
    }

    HUDPlayer_Armor[playerid] = CreatePlayerTextDraw(playerid, 612.000000, 20.000000, "mdl-2004:Armor-0");
    PlayerTextDrawFont(playerid, HUDPlayer_Armor[playerid], 4);
    PlayerTextDrawLetterSize(playerid, HUDPlayer_Armor[playerid], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, HUDPlayer_Armor[playerid], 25.000000, 32.500000);
    PlayerTextDrawSetOutline(playerid, HUDPlayer_Armor[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDPlayer_Armor[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDPlayer_Armor[playerid], 1);
    PlayerTextDrawColor(playerid, HUDPlayer_Armor[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDPlayer_Armor[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDPlayer_Armor[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDPlayer_Armor[playerid], 1);
    PlayerTextDrawSetProportional(playerid, HUDPlayer_Armor[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDPlayer_Armor[playerid], 0);

    HUDPlayer_Health[playerid] = CreatePlayerTextDraw(playerid, 612.000000, 50.000000, "mdl-2004:Health-0");
    PlayerTextDrawFont(playerid, HUDPlayer_Health[playerid], 4);
    PlayerTextDrawLetterSize(playerid, HUDPlayer_Health[playerid], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, HUDPlayer_Health[playerid], 25.000000, 32.500000);
    PlayerTextDrawSetOutline(playerid, HUDPlayer_Health[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDPlayer_Health[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDPlayer_Health[playerid], 1);
    PlayerTextDrawColor(playerid, HUDPlayer_Health[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDPlayer_Health[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDPlayer_Health[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDPlayer_Health[playerid], 1);
    PlayerTextDrawSetProportional(playerid, HUDPlayer_Health[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDPlayer_Health[playerid], 0);

    HUDPlayer_ArmorRate[playerid] = CreatePlayerTextDraw(playerid, 625.000000, 42.000000, "0");
    PlayerTextDrawFont(playerid, HUDPlayer_ArmorRate[playerid], 1);
    PlayerTextDrawLetterSize(playerid, HUDPlayer_ArmorRate[playerid], 0.208333, 1.100000);
    PlayerTextDrawTextSize(playerid, HUDPlayer_ArmorRate[playerid], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, HUDPlayer_ArmorRate[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDPlayer_ArmorRate[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDPlayer_ArmorRate[playerid], 2);
    PlayerTextDrawColor(playerid, HUDPlayer_ArmorRate[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDPlayer_ArmorRate[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDPlayer_ArmorRate[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDPlayer_ArmorRate[playerid], 0);
    PlayerTextDrawSetProportional(playerid, HUDPlayer_ArmorRate[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDPlayer_ArmorRate[playerid], 0);

    HUDPlayer_HealthRate[playerid] = CreatePlayerTextDraw(playerid, 625.000000, 72.000000, "0");
    PlayerTextDrawFont(playerid, HUDPlayer_HealthRate[playerid], 1);
    PlayerTextDrawLetterSize(playerid, HUDPlayer_HealthRate[playerid], 0.208333, 1.100000);
    PlayerTextDrawTextSize(playerid, HUDPlayer_HealthRate[playerid], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, HUDPlayer_HealthRate[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDPlayer_HealthRate[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDPlayer_HealthRate[playerid], 2);
    PlayerTextDrawColor(playerid, HUDPlayer_HealthRate[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDPlayer_HealthRate[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDPlayer_HealthRate[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDPlayer_HealthRate[playerid], 0);
    PlayerTextDrawSetProportional(playerid, HUDPlayer_HealthRate[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDPlayer_HealthRate[playerid], 0);

    HUDPlayer_PingRate[playerid] = CreatePlayerTextDraw(playerid, 625.000000, 99.000000, "0");
    PlayerTextDrawFont(playerid, HUDPlayer_PingRate[playerid], 1);
    PlayerTextDrawLetterSize(playerid, HUDPlayer_PingRate[playerid], 0.208333, 1.100000);
    PlayerTextDrawTextSize(playerid, HUDPlayer_PingRate[playerid], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, HUDPlayer_PingRate[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDPlayer_PingRate[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDPlayer_PingRate[playerid], 2);
    PlayerTextDrawColor(playerid, HUDPlayer_PingRate[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDPlayer_PingRate[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDPlayer_PingRate[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDPlayer_PingRate[playerid], 0);
    PlayerTextDrawSetProportional(playerid, HUDPlayer_PingRate[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDPlayer_PingRate[playerid], 0);

    HUDPlayer_PacketLossRate[playerid] = CreatePlayerTextDraw(playerid, 625.000000, 129.000000, "0.0");
    PlayerTextDrawFont(playerid, HUDPlayer_PacketLossRate[playerid], 1);
    PlayerTextDrawLetterSize(playerid, HUDPlayer_PacketLossRate[playerid], 0.208333, 1.100000);
    PlayerTextDrawTextSize(playerid, HUDPlayer_PacketLossRate[playerid], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, HUDPlayer_PacketLossRate[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDPlayer_PacketLossRate[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDPlayer_PacketLossRate[playerid], 2);
    PlayerTextDrawColor(playerid, HUDPlayer_PacketLossRate[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDPlayer_PacketLossRate[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDPlayer_PacketLossRate[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDPlayer_PacketLossRate[playerid], 0);
    PlayerTextDrawSetProportional(playerid, HUDPlayer_PacketLossRate[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDPlayer_PacketLossRate[playerid], 0);

    /*HUDPlayer_Clock[playerid] = CreatePlayerTextDraw(playerid, 547.000000, 27.000000, "00:00:00 AM");
    PlayerTextDrawFont(playerid, HUDPlayer_Clock[playerid], 2);
    PlayerTextDrawLetterSize(playerid, HUDPlayer_Clock[playerid], 0.216664, 1.749999);
    PlayerTextDrawTextSize(playerid, HUDPlayer_Clock[playerid], 605.500000, 17.000000);
    PlayerTextDrawSetOutline(playerid, HUDPlayer_Clock[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDPlayer_Clock[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDPlayer_Clock[playerid], 1);
    PlayerTextDrawColor(playerid, HUDPlayer_Clock[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDPlayer_Clock[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDPlayer_Clock[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDPlayer_Clock[playerid], 0);
    PlayerTextDrawSetProportional(playerid, HUDPlayer_Clock[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDPlayer_Clock[playerid], 0);*/


    // Vehicle

    HUDFuel[playerid] = CreatePlayerTextDraw(playerid, 589.000000, 366.000000, "mdl-2004:Fuel-0");
    PlayerTextDrawFont(playerid, HUDFuel[playerid], 4);
    PlayerTextDrawLetterSize(playerid, HUDFuel[playerid], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, HUDFuel[playerid], 60.000000, 65.000000);
    PlayerTextDrawSetOutline(playerid, HUDFuel[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDFuel[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDFuel[playerid], 1);
    PlayerTextDrawColor(playerid, HUDFuel[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDFuel[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDFuel[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDFuel[playerid], 1);
    PlayerTextDrawSetProportional(playerid, HUDFuel[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDFuel[playerid], 0);

    HUDZone[playerid] = CreatePlayerTextDraw(playerid, 635.000000, 428.000000, "San Andreas");
    PlayerTextDrawFont(playerid, HUDZone[playerid], 2);
    PlayerTextDrawLetterSize(playerid, HUDZone[playerid], 0.258329, 1.499994);
    PlayerTextDrawTextSize(playerid, HUDZone[playerid], 431.500000, 0.500000);
    PlayerTextDrawSetOutline(playerid, HUDZone[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDZone[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDZone[playerid], 3);
    PlayerTextDrawColor(playerid, HUDZone[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDZone[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDZone[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDZone[playerid], 0);
    PlayerTextDrawSetProportional(playerid, HUDZone[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDZone[playerid], 0);

    HUDSpeedoRate[playerid] = CreatePlayerTextDraw(playerid, 543.000000, 361.000000, "mdl-2004:Speedo-0");
    PlayerTextDrawFont(playerid, HUDSpeedoRate[playerid], 4);
    PlayerTextDrawLetterSize(playerid, HUDSpeedoRate[playerid], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, HUDSpeedoRate[playerid], 65.000000, 75.000000);
    PlayerTextDrawSetOutline(playerid, HUDSpeedoRate[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDSpeedoRate[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDSpeedoRate[playerid], 1);
    PlayerTextDrawColor(playerid, HUDSpeedoRate[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDSpeedoRate[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDSpeedoRate[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDSpeedoRate[playerid], 1);
    PlayerTextDrawSetProportional(playerid, HUDSpeedoRate[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDSpeedoRate[playerid], 0);

    HUDNos[playerid] = CreatePlayerTextDraw(playerid, 539.000000, 358.000000, "mdl-2004:NOS-0");
    PlayerTextDrawFont(playerid, HUDNos[playerid], 4);
    PlayerTextDrawLetterSize(playerid, HUDNos[playerid], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, HUDNos[playerid], 65.000000, 75.000000);
    PlayerTextDrawSetOutline(playerid, HUDNos[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDNos[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDNos[playerid], 1);
    PlayerTextDrawColor(playerid, HUDNos[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDNos[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDNos[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDNos[playerid], 1);
    PlayerTextDrawSetProportional(playerid, HUDNos[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDNos[playerid], 0);

    HUDLock[playerid] = CreatePlayerTextDraw(playerid, 557.000000, 350.000000, "mdl-2004:Locks-Unlocked");
    PlayerTextDrawFont(playerid, HUDLock[playerid], 4);
    PlayerTextDrawLetterSize(playerid, HUDLock[playerid], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, HUDLock[playerid], 15.000000, 15.500000);
    PlayerTextDrawSetOutline(playerid, HUDLock[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDLock[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDLock[playerid], 1);
    PlayerTextDrawColor(playerid, HUDLock[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDLock[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDLock[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDLock[playerid], 1);
    PlayerTextDrawSetProportional(playerid, HUDLock[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDLock[playerid], 0);

    HUDEngine[playerid] = CreatePlayerTextDraw(playerid, 540.000000, 358.000000, "mdl-2004:Engine-Broken");
    PlayerTextDrawFont(playerid, HUDEngine[playerid], 4);
    PlayerTextDrawLetterSize(playerid, HUDEngine[playerid], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, HUDEngine[playerid], 15.000000, 15.000000);
    PlayerTextDrawSetOutline(playerid, HUDEngine[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDEngine[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDEngine[playerid], 1);
    PlayerTextDrawColor(playerid, HUDEngine[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDEngine[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDEngine[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDEngine[playerid], 1);
    PlayerTextDrawSetProportional(playerid, HUDEngine[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDEngine[playerid], 0);


    HUDSpeedoMPH[playerid] = CreatePlayerTextDraw(playerid, 575.000000, 409.000000, "0 MPH");
    PlayerTextDrawFont(playerid, HUDSpeedoMPH[playerid], 2);
    PlayerTextDrawLetterSize(playerid, HUDSpeedoMPH[playerid], 0.262497, 1.349997);
    PlayerTextDrawTextSize(playerid, HUDSpeedoMPH[playerid], 405.000000, 94.500000);
    PlayerTextDrawSetOutline(playerid, HUDSpeedoMPH[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDSpeedoMPH[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDSpeedoMPH[playerid], 2);
    PlayerTextDrawColor(playerid, HUDSpeedoMPH[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDSpeedoMPH[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDSpeedoMPH[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDSpeedoMPH[playerid], 0);
    PlayerTextDrawSetProportional(playerid, HUDSpeedoMPH[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDSpeedoMPH[playerid], 0);

    HUDMileageRate[playerid] = CreatePlayerTextDraw(playerid, 611.000000, 347.000000, "0 MI");
    PlayerTextDrawFont(playerid, HUDMileageRate[playerid], 2);
    PlayerTextDrawLetterSize(playerid, HUDMileageRate[playerid], 0.204162, 1.349995);
    PlayerTextDrawTextSize(playerid, HUDMileageRate[playerid], 400.500000, 94.500000);
    PlayerTextDrawSetOutline(playerid, HUDMileageRate[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDMileageRate[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDMileageRate[playerid], 2);
    PlayerTextDrawColor(playerid, HUDMileageRate[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDMileageRate[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDMileageRate[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDMileageRate[playerid], 0);
    PlayerTextDrawSetProportional(playerid, HUDMileageRate[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDMileageRate[playerid], 0);
    /*HUDZone[playerid] = CreatePlayerTextDraw(playerid, 635.000000, 424.000000, "San Andreas");
    PlayerTextDrawFont(playerid, HUDZone[playerid], 2);
    PlayerTextDrawLetterSize(playerid, HUDZone[playerid], 0.549996, 2.149996);
    PlayerTextDrawTextSize(playerid, HUDZone[playerid], 434.000000, 0.000000);
    PlayerTextDrawSetOutline(playerid, HUDZone[playerid], 2);
    PlayerTextDrawSetShadow(playerid, HUDZone[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDZone[playerid], 3);
    PlayerTextDrawColor(playerid, HUDZone[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDZone[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDZone[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDZone[playerid], 0);
    PlayerTextDrawSetProportional(playerid, HUDZone[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDZone[playerid], 0);

    HUDFuel[playerid] = CreatePlayerTextDraw(playerid, 541.000000, 309.000000, "mdl-2004:Fuel-0");
    PlayerTextDrawFont(playerid, HUDFuel[playerid], 4);
    PlayerTextDrawLetterSize(playerid, HUDFuel[playerid], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, HUDFuel[playerid], 120.000000, 120.000000);
    PlayerTextDrawSetOutline(playerid, HUDFuel[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDFuel[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDFuel[playerid], 1);
    PlayerTextDrawColor(playerid, HUDFuel[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDFuel[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDFuel[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDFuel[playerid], 1);
    PlayerTextDrawSetProportional(playerid, HUDFuel[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDFuel[playerid], 0);

    HUDSpeedoRate[playerid] = CreatePlayerTextDraw(playerid, 456.000000, 310.000000, "mdl-2004:Speedo-0");
    PlayerTextDrawFont(playerid, HUDSpeedoRate[playerid], 4);
    PlayerTextDrawLetterSize(playerid, HUDSpeedoRate[playerid], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, HUDSpeedoRate[playerid], 120.000000, 120.000000);
    PlayerTextDrawSetOutline(playerid, HUDSpeedoRate[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDSpeedoRate[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDSpeedoRate[playerid], 1);
    PlayerTextDrawColor(playerid, HUDSpeedoRate[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDSpeedoRate[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDSpeedoRate[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDSpeedoRate[playerid], 1);
    PlayerTextDrawSetProportional(playerid, HUDSpeedoRate[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDSpeedoRate[playerid], 0);


    HUDNos[playerid] = CreatePlayerTextDraw(playerid, 448.000000, 305.000000, "mdl-2004:NOS-0");
    PlayerTextDrawFont(playerid, HUDNos[playerid], 4);
    PlayerTextDrawLetterSize(playerid, HUDNos[playerid], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, HUDNos[playerid], 120.000000, 120.000000);
    PlayerTextDrawSetOutline(playerid, HUDNos[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDNos[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDNos[playerid], 1);
    PlayerTextDrawColor(playerid, HUDNos[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDNos[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDNos[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDNos[playerid], 1);
    PlayerTextDrawSetProportional(playerid, HUDNos[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDNos[playerid], 0);

    HUDLock[playerid] = CreatePlayerTextDraw(playerid, 490.000000, 301.000000, "mdl-2004:Locks-Locked");
    PlayerTextDrawFont(playerid, HUDLock[playerid], 4);
    PlayerTextDrawLetterSize(playerid, HUDLock[playerid], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, HUDLock[playerid], 20.000000, 20.000000);
    PlayerTextDrawSetOutline(playerid, HUDLock[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDLock[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDLock[playerid], 1);
    PlayerTextDrawColor(playerid, HUDLock[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDLock[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDLock[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDLock[playerid], 1);
    PlayerTextDrawSetProportional(playerid, HUDLock[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDLock[playerid], 0);

    HUDEngine[playerid] = CreatePlayerTextDraw(playerid, 463.000000, 310.000000, "mdl-2004:Engine-Damaged");
    PlayerTextDrawFont(playerid, HUDEngine[playerid], 4);
    PlayerTextDrawLetterSize(playerid, HUDEngine[playerid], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, HUDEngine[playerid], 20.000000, 20.000000);
    PlayerTextDrawSetOutline(playerid, HUDEngine[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HUDEngine[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDEngine[playerid], 1);
    PlayerTextDrawColor(playerid, HUDEngine[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDEngine[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDEngine[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDEngine[playerid], 1);
    PlayerTextDrawSetProportional(playerid, HUDEngine[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDEngine[playerid], 0);

    HUDSpeedoMPH[playerid] = CreatePlayerTextDraw(playerid, 515.000000, 387.000000, "0 MPH");
    PlayerTextDrawFont(playerid, HUDSpeedoMPH[playerid], 2);
    PlayerTextDrawLetterSize(playerid, HUDSpeedoMPH[playerid], 0.512498, 2.399996);
    PlayerTextDrawTextSize(playerid, HUDSpeedoMPH[playerid], 405.000000, 94.500000);
    PlayerTextDrawSetOutline(playerid, HUDSpeedoMPH[playerid], 2);
    PlayerTextDrawSetShadow(playerid, HUDSpeedoMPH[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDSpeedoMPH[playerid], 2);
    PlayerTextDrawColor(playerid, HUDSpeedoMPH[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDSpeedoMPH[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDSpeedoMPH[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDSpeedoMPH[playerid], 0);
    PlayerTextDrawSetProportional(playerid, HUDSpeedoMPH[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDSpeedoMPH[playerid], 0);

    HUDMileageRate[playerid] = CreatePlayerTextDraw(playerid, 584.000000, 274.000000, "000 MI");
    PlayerTextDrawFont(playerid, HUDMileageRate[playerid], 2);
    PlayerTextDrawLetterSize(playerid, HUDMileageRate[playerid], 0.429165, 2.149996);
    PlayerTextDrawTextSize(playerid, HUDMileageRate[playerid], 400.500000, 94.500000);
    PlayerTextDrawSetOutline(playerid, HUDMileageRate[playerid], 2);
    PlayerTextDrawSetShadow(playerid, HUDMileageRate[playerid], 0);
    PlayerTextDrawAlignment(playerid, HUDMileageRate[playerid], 2);
    PlayerTextDrawColor(playerid, HUDMileageRate[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HUDMileageRate[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HUDMileageRate[playerid], 50);
    PlayerTextDrawUseBox(playerid, HUDMileageRate[playerid], 0);
    PlayerTextDrawSetProportional(playerid, HUDMileageRate[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HUDMileageRate[playerid], 0);*/
    return 1;
}

hook OnGameModeInit() {
    HUDPlayer_Ping = TextDrawCreate(612.000000, 80.000000, "mdl-2004:Ping");
    TextDrawFont(HUDPlayer_Ping, 4);
    TextDrawLetterSize(HUDPlayer_Ping, 0.600000, 2.000000);
    TextDrawTextSize(HUDPlayer_Ping, 25.000000, 32.500000);
    TextDrawSetOutline(HUDPlayer_Ping, 1);
    TextDrawSetShadow(HUDPlayer_Ping, 0);
    TextDrawAlignment(HUDPlayer_Ping, 1);
    TextDrawColor(HUDPlayer_Ping, -1);
    TextDrawBackgroundColor(HUDPlayer_Ping, 255);
    TextDrawBoxColor(HUDPlayer_Ping, 50);
    TextDrawUseBox(HUDPlayer_Ping, 1);
    TextDrawSetProportional(HUDPlayer_Ping, 1);
    TextDrawSetSelectable(HUDPlayer_Ping, 0);

    HUDPlayer_PacketLoss = TextDrawCreate(612.000000, 110.000000, "mdl-2004:Packet Loss");
    TextDrawFont(HUDPlayer_PacketLoss, 4);
    TextDrawLetterSize(HUDPlayer_PacketLoss, 0.600000, 2.000000);
    TextDrawTextSize(HUDPlayer_PacketLoss, 25.000000, 32.500000);
    TextDrawSetOutline(HUDPlayer_PacketLoss, 1);
    TextDrawSetShadow(HUDPlayer_PacketLoss, 0);
    TextDrawAlignment(HUDPlayer_PacketLoss, 1);
    TextDrawColor(HUDPlayer_PacketLoss, -1);
    TextDrawBackgroundColor(HUDPlayer_PacketLoss, 255);
    TextDrawBoxColor(HUDPlayer_PacketLoss, 50);
    TextDrawUseBox(HUDPlayer_PacketLoss, 1);
    TextDrawSetProportional(HUDPlayer_PacketLoss, 1);
    TextDrawSetSelectable(HUDPlayer_PacketLoss, 0);

    // Vehicle
    /*HUDMileage = TextDrawCreate(524.000000, 223.000000, "mdl-2004:Mileage");
    TextDrawFont(HUDMileage, 4);
    TextDrawLetterSize(HUDMileage, 0.600000, 2.000000);
    TextDrawTextSize(HUDMileage, 120.000000, 120.000000);
    TextDrawSetOutline(HUDMileage, 1);
    TextDrawSetShadow(HUDMileage, 0);
    TextDrawAlignment(HUDMileage, 1);
    TextDrawColor(HUDMileage, -1);
    TextDrawBackgroundColor(HUDMileage, 255);
    TextDrawBoxColor(HUDMileage, 50);
    TextDrawUseBox(HUDMileage, 1);
    TextDrawSetProportional(HUDMileage, 1);
    TextDrawSetSelectable(HUDMileage, 0);

    HUDBattery = TextDrawCreate(439.000000, 330.000000, "mdl-2004:Battery");
    TextDrawFont(HUDBattery, 4);
    TextDrawLetterSize(HUDBattery, 0.600000, 2.000000);
    TextDrawTextSize(HUDBattery, 20.000000, 20.000000);
    TextDrawSetOutline(HUDBattery, 1);
    TextDrawSetShadow(HUDBattery, 0);
    TextDrawAlignment(HUDBattery, 1);
    TextDrawColor(HUDBattery, -1);
    TextDrawBackgroundColor(HUDBattery, 255);
    TextDrawBoxColor(HUDBattery, 50);
    TextDrawUseBox(HUDBattery, 1);
    TextDrawSetProportional(HUDBattery, 1);
    TextDrawSetSelectable(HUDBattery, 0);

    HUDLights = TextDrawCreate(430.000000, 363.000000, "mdl-2004:Lights");
    TextDrawFont(HUDLights, 4);
    TextDrawLetterSize(HUDLights, 0.600000, 2.000000);
    TextDrawTextSize(HUDLights, 20.000000, 20.000000);
    TextDrawSetOutline(HUDLights, 1);
    TextDrawSetShadow(HUDLights, 0);
    TextDrawAlignment(HUDLights, 1);
    TextDrawColor(HUDLights, -1);
    TextDrawBackgroundColor(HUDLights, 255);
    TextDrawBoxColor(HUDLights, 50);
    TextDrawUseBox(HUDLights, 1);
    TextDrawSetProportional(HUDLights, 1);
    TextDrawSetSelectable(HUDLights, 0);*/
    HUDMileage = TextDrawCreate(583.000000, 319.000000, "mdl-2004:Mileage");
    TextDrawFont(HUDMileage, 4);
    TextDrawLetterSize(HUDMileage, 0.600000, 2.000000);
    TextDrawTextSize(HUDMileage, 54.000000, 65.000000);
    TextDrawSetOutline(HUDMileage, 1);
    TextDrawSetShadow(HUDMileage, 0);
    TextDrawAlignment(HUDMileage, 1);
    TextDrawColor(HUDMileage, -1);
    TextDrawBackgroundColor(HUDMileage, 255);
    TextDrawBoxColor(HUDMileage, 50);
    TextDrawUseBox(HUDMileage, 1);
    TextDrawSetProportional(HUDMileage, 1);
    TextDrawSetSelectable(HUDMileage, 0);

    HUDBattery = TextDrawCreate(527.000000, 374.000000, "mdl-2004:Battery");
    TextDrawFont(HUDBattery, 4);
    TextDrawLetterSize(HUDBattery, 0.600000, 2.000000);
    TextDrawTextSize(HUDBattery, 15.000000, 15.000000);
    TextDrawSetOutline(HUDBattery, 1);
    TextDrawSetShadow(HUDBattery, 0);
    TextDrawAlignment(HUDBattery, 1);
    TextDrawColor(HUDBattery, -1);
    TextDrawBackgroundColor(HUDBattery, 255);
    TextDrawBoxColor(HUDBattery, 50);
    TextDrawUseBox(HUDBattery, 1);
    TextDrawSetProportional(HUDBattery, 1);
    TextDrawSetSelectable(HUDBattery, 0);

    HUDLights = TextDrawCreate(524.000000, 392.000000, "mdl-2004:Lights");
    TextDrawFont(HUDLights, 4);
    TextDrawLetterSize(HUDLights, 0.600000, 2.000000);
    TextDrawTextSize(HUDLights, 15.000000, 15.000000);
    TextDrawSetOutline(HUDLights, 1);
    TextDrawSetShadow(HUDLights, 0);
    TextDrawAlignment(HUDLights, 1);
    TextDrawColor(HUDLights, -1);
    TextDrawBackgroundColor(HUDLights, 255);
    TextDrawBoxColor(HUDLights, 50);
    TextDrawUseBox(HUDLights, 1);
    TextDrawSetProportional(HUDLights, 1);
    TextDrawSetSelectable(HUDLights, 0);
    return 1;
}

stock showPlayerHUD(playerid) {
    if (!HUDtoggle[playerid][HUD_PING]) {
        PlayerTextDrawShow(playerid, HUDPlayer_PingRate[playerid]);
        TextDrawShowForPlayer(playerid, HUDPlayer_Ping);
    }

    if (!HUDtoggle[playerid][HUD_PACKET]) {
        PlayerTextDrawShow(playerid, HUDPlayer_PacketLossRate[playerid]);
        TextDrawShowForPlayer(playerid, HUDPlayer_PacketLoss);
    }

    if (!HUDtoggle[playerid][HUD_ARMOR]) {
        PlayerTextDrawShow(playerid, HUDPlayer_Armor[playerid]);
        PlayerTextDrawShow(playerid, HUDPlayer_ArmorRate[playerid]);
    }

    if (!HUDtoggle[playerid][HUD_HEALTH]) {
        PlayerTextDrawShow(playerid, HUDPlayer_Health[playerid]);
        PlayerTextDrawShow(playerid, HUDPlayer_HealthRate[playerid]);
    }
    
    //PlayerTextDrawShow(playerid, HUDPlayer_Clock[playerid]);

    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
        isVehicleHUD { playerid } = true;
        showVehicleHUD(playerid);
    }

    isHideHUD{ playerid } = false;
}

stock hidePlayerHUD(playerid) {
    TextDrawHideForPlayer(playerid, HUDPlayer_Ping);
    TextDrawHideForPlayer(playerid, HUDPlayer_PacketLoss);
    PlayerTextDrawHide(playerid, HUDPlayer_Armor[playerid]);
    PlayerTextDrawHide(playerid, HUDPlayer_Health[playerid]);
    PlayerTextDrawHide(playerid, HUDPlayer_ArmorRate[playerid]);
    PlayerTextDrawHide(playerid, HUDPlayer_HealthRate[playerid]);
    PlayerTextDrawHide(playerid, HUDPlayer_PingRate[playerid]);
    PlayerTextDrawHide(playerid, HUDPlayer_PacketLossRate[playerid]);
    //PlayerTextDrawHide(playerid, HUDPlayer_Clock[playerid]);
    hideVehicleHUD(playerid);
    isHideHUD{ playerid } = true;
}

hook OnPlayerSpawn(playerid) {
    displayHUD{playerid} = true;
    showPlayerHUD(playerid);
    return 1;
}

ptask HUDUpdate[1000](playerid) {
    if(bf_get(player_bf[playerid], IS_LOGGED) && displayHUD{playerid} && !isHideHUD{ playerid } ) {

        /*new hHours, hMins, hSecs;
        GetRealTime(hHours, hMins, hSecs);
        PlayerTextDrawSetString(playerid, HUDPlayer_Clock[playerid], sprintf("%02d:%02d:%02d %s", hHours > 12 ? (hHours - 12) : hHours, hMins,  hSecs, hHours > 12 ? ("PM") : ("AM")));
        */
        /*if (!HUDtoggle[playerid][HUD_PACKET]) {
            new Float:packetloss = NetStats_PacketLossPercent(playerid);
            PlayerTextDrawSetString(playerid, HUDPlayer_PacketLossRate[playerid], sprintf("%.1f", packetloss));
        }

        if (!HUDtoggle[playerid][HUD_PING]) {
            new ping = GetPlayerPing(playerid);
            PlayerTextDrawSetString(playerid, HUDPlayer_PingRate[playerid], sprintf("%d", ping));
        }

        if (!HUDtoggle[playerid][HUD_HEALTH]) {
            new Float:hp;
            GetPlayerHealth(playerid, hp);
            PlayerTextDrawSetString(playerid, HUDPlayer_HealthRate[playerid], sprintf("%.0f", hp));
            if (hp >= 100.0) PlayerTextDrawSetString(playerid, HUDPlayer_Health[playerid], "mdl-2004:Health-100");
            else if (hp >= 75.0) PlayerTextDrawSetString(playerid, HUDPlayer_Health[playerid], "mdl-2004:Health-75");
            else if (hp >= 50.0) PlayerTextDrawSetString(playerid, HUDPlayer_Health[playerid], "mdl-2004:Health-50");
            else if (hp >= 25.0) PlayerTextDrawSetString(playerid, HUDPlayer_Health[playerid], "mdl-2004:Health-25");
            else PlayerTextDrawSetString(playerid, HUDPlayer_Health[playerid], "mdl-2004:Health-0");
        }

        if (!HUDtoggle[playerid][HUD_ARMOR]) {
            new Float:armor;
            GetPlayerArmour(playerid, armor);
            PlayerTextDrawSetString(playerid, HUDPlayer_ArmorRate[playerid], sprintf("%.0f", armor));
            if (armor >= 100.0) PlayerTextDrawSetString(playerid, HUDPlayer_Armor[playerid], "mdl-2004:Armor-100");
            else if (armor >= 75.0) PlayerTextDrawSetString(playerid, HUDPlayer_Armor[playerid], "mdl-2004:Armor-75");
            else if (armor >= 50.0) PlayerTextDrawSetString(playerid, HUDPlayer_Armor[playerid], "mdl-2004:Armor-50");
            else if (armor >= 25.0) PlayerTextDrawSetString(playerid, HUDPlayer_Armor[playerid], "mdl-2004:Armor-25");
            else PlayerTextDrawSetString(playerid, HUDPlayer_Armor[playerid], "mdl-2004:Armor-0");
        }*/

        if (isVehicleHUD { playerid }) {
            if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
                new vehicleid = GetPlayerVehicleID(playerid);
                new model = GetVehicleModel(vehicleid);
                new miles = 0, id = -1;
                if((id = Car_GetID(vehicleid)) != -1) {
                    miles = floatround(CarData[id][carMileage]);

                    new life;
                    if (!HUDtoggle[playerid][HUD_ENGINE]) {
                        life = floatround(CarData[id][carEngineL] / VehicleData[model - 400][c_engine]) * 100;
                        if (life < 10) {
                            PlayerTextDrawSetString(playerid, HUDEngine[playerid], "mdl-2004:Engine-Broken");
                            PlayerTextDrawShow(playerid, HUDEngine[playerid]);
                        }
                        else if (life < 30) {
                            PlayerTextDrawSetString(playerid, HUDEngine[playerid], "mdl-2004:Engine-Damaged");
                            PlayerTextDrawShow(playerid, HUDEngine[playerid]);
                        }
                        else {
                            PlayerTextDrawHide(playerid, HUDEngine[playerid]);
                        }
                    }

                    if (!HUDtoggle[playerid][HUD_BATTERY]) {
                        life = floatround(CarData[id][carBatteryL] / VehicleData[model - 400][c_battery]) * 100;
                        if (life < 20) {
                            TextDrawShowForPlayer(playerid, HUDBattery);
                        }
                        else {
                            TextDrawHideForPlayer(playerid, HUDBattery);
                        }
                    }
                }

                if (!HUDtoggle[playerid][HUD_MI]) {
                    PlayerTextDrawSetString(playerid, HUDMileageRate[playerid], sprintf("%03d MI", miles));
                }

                if (!HUDtoggle[playerid][HUD_FUEL]) {
                    new fuel = floatround(floatdiv(CoreVehicles[vehicleid][vehFuel], GetVehicleDataFuel(model))*100);
                    if (fuel >= 100) PlayerTextDrawSetString(playerid, HUDFuel[playerid], "mdl-2004:Fuel-100");
                    else if (fuel >= 87) PlayerTextDrawSetString(playerid, HUDFuel[playerid], "mdl-2004:Fuel-87");
                    else if (fuel >= 75) PlayerTextDrawSetString(playerid, HUDFuel[playerid], "mdl-2004:Fuel-75");
                    else if (fuel >= 65) PlayerTextDrawSetString(playerid, HUDFuel[playerid], "mdl-2004:Fuel-65");
                    else if (fuel >= 50) PlayerTextDrawSetString(playerid, HUDFuel[playerid], "mdl-2004:Fuel-50");
                    else if (fuel >= 37) PlayerTextDrawSetString(playerid, HUDFuel[playerid], "mdl-2004:Fuel-37");
                    else if (fuel >= 25) PlayerTextDrawSetString(playerid, HUDFuel[playerid], "mdl-2004:Fuel-25");
                    else if (fuel >= 12) PlayerTextDrawSetString(playerid, HUDFuel[playerid], "mdl-2004:Fuel-12");
                    else PlayerTextDrawSetString(playerid, HUDFuel[playerid], "mdl-2004:Fuel-0");
                }

                if (!HUDtoggle[playerid][HUD_LOCK]) {
                    if (GetLockStatus(vehicleid)) PlayerTextDrawSetString(playerid, HUDLock[playerid], "mdl-2004:Locks-Locked");
                    else PlayerTextDrawSetString(playerid, HUDLock[playerid], "mdl-2004:Locks-Unlocked");
                }

                if (!HUDtoggle[playerid][HUD_LIGHT]) {
                    if (GetLightStatus(vehicleid)) TextDrawShowForPlayer(playerid, HUDLights);
                    else TextDrawHideForPlayer(playerid, HUDLights);
                }

                new sZone[MAX_ZONE_NAME];
                GetPlayer3DZone(playerid, sZone, sizeof(sZone));
                PlayerTextDrawSetString(playerid, HUDZone[playerid], sZone);
            }
        }
    }
    return 1;
}

/*hook OnPlayerUpdate(playerid) {
    if(displayHUD{playerid} && !isHideHUD{ playerid } && isVehicleHUD { playerid }) {
        if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
            new vehicleid = GetPlayerVehicleID(playerid), id = -1;

            if (!HUDtoggle[playerid][HUD_SPEED]) {
                new mph_speed = floatround(GetVehicleSpeed(vehicleid));
                PlayerTextDrawSetString(playerid, HUDSpeedoMPH[playerid], sprintf("%d MPH", mph_speed));
                if (mph_speed % 10 == 0 && mph_speed >= 0 && mph_speed <= 90) {
                    PlayerTextDrawSetString(playerid, HUDSpeedoRate[playerid], sprintf("mdl-2004:Speedo-%d", mph_speed));
                }
            }

            if (!HUDtoggle[playerid][HUD_NOS]) {
                if((id = Car_GetID(vehicleid)) != -1) {
                    new nos = CarData[id][carNos];
                    if (nos >= 100) PlayerTextDrawSetString(playerid, HUDNos[playerid], "mdl-2004:NOS-100");
                    else if (nos >= 87) PlayerTextDrawSetString(playerid, HUDNos[playerid], "mdl-2004:NOS-87");
                    else if (nos >= 75) PlayerTextDrawSetString(playerid, HUDNos[playerid], "mdl-2004:NOS-75");
                    else if (nos >= 62) PlayerTextDrawSetString(playerid, HUDNos[playerid], "mdl-2004:NOS-62");
                    else if (nos >= 50) PlayerTextDrawSetString(playerid, HUDNos[playerid], "mdl-2004:NOS-50");
                    else if (nos >= 37) PlayerTextDrawSetString(playerid, HUDNos[playerid], "mdl-2004:NOS-37");
                    else if (nos >= 25) PlayerTextDrawSetString(playerid, HUDNos[playerid], "mdl-2004:NOS-25");
                    else if (nos >= 12) PlayerTextDrawSetString(playerid, HUDNos[playerid], "mdl-2004:NOS-12");
                    else PlayerTextDrawSetString(playerid, HUDNos[playerid], "mdl-2004:NOS-0");
                }
            }
        }
    }
    return 1;
}*/



hook OnPlayerStateChange(playerid, newstate, oldstate)
{
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
    if (!HUDtoggle[playerid][HUD_MI]) {
        TextDrawShowForPlayer(playerid, HUDMileage);
        PlayerTextDrawShow(playerid, HUDMileageRate[playerid]);
    }

    if (!HUDtoggle[playerid][HUD_FUEL])
        PlayerTextDrawShow(playerid, HUDFuel[playerid]);

    PlayerTextDrawShow(playerid, HUDZone[playerid]);
    
    if (!HUDtoggle[playerid][HUD_SPEED]) {
        PlayerTextDrawShow(playerid, HUDSpeedoRate[playerid]);
        PlayerTextDrawShow(playerid, HUDSpeedoMPH[playerid]);
    }

    if (!HUDtoggle[playerid][HUD_NOS])
        PlayerTextDrawShow(playerid, HUDNos[playerid]);

    if (!HUDtoggle[playerid][HUD_LOCK])
        PlayerTextDrawShow(playerid, HUDLock[playerid]);

}

hideVehicleHUD(playerid) {

    TextDrawHideForPlayer(playerid, HUDMileage);
    TextDrawHideForPlayer(playerid, HUDBattery);
    TextDrawHideForPlayer(playerid, HUDLights);

    PlayerTextDrawHide(playerid, HUDFuel[playerid]);
    PlayerTextDrawHide(playerid, HUDZone[playerid]);
    PlayerTextDrawHide(playerid, HUDSpeedoRate[playerid]);
    PlayerTextDrawHide(playerid, HUDNos[playerid]);

    PlayerTextDrawHide(playerid, HUDLock[playerid]);
    PlayerTextDrawHide(playerid, HUDEngine[playerid]);
    PlayerTextDrawHide(playerid, HUDSpeedoMPH[playerid]);
    PlayerTextDrawHide(playerid, HUDMileageRate[playerid]);
}

CMD:toghud(playerid, params[])
{
    ShowDialogTogHUD(playerid);
	return 1;
}

ShowDialogTogHUD(playerid) {
    new str[1024];
    format(str, 1024, \
    "{%06x}ไอคอนเกราะ\n\
     {%06x}ไอคอนเลือด\n\
     {%06x}ไอคอนปิง\n\
     {%06x}ไอคอนความสูญเสีย\n\
     {%06x}ไมล์\n\
     {%06x}น้ำมันเชื้อเพลิง\n\
     {%06x}วัดความเร็ว\n\
     {%06x}ไนตรัส\n\
     {%06x}ไอคอนล็อก\n\
     {%06x}ไอคอนเครื่องยนต์\n\
     {%06x}ไอคอนแบตเตอร์รี่\n\
     {%06x}ไอคอนไฟ", 
     HUDtoggle[playerid][HUD_ARMOR] ? (0xFF0000FF >>> 8) : (0x33AA33FF >>> 8),
     HUDtoggle[playerid][HUD_HEALTH] ? (0xFF0000FF >>> 8) : (0x33AA33FF >>> 8),
     HUDtoggle[playerid][HUD_PING] ? (0xFF0000FF >>> 8) : (0x33AA33FF >>> 8),
     HUDtoggle[playerid][HUD_PACKET] ? (0xFF0000FF >>> 8) : (0x33AA33FF >>> 8),
     HUDtoggle[playerid][HUD_MI] ? (0xFF0000FF >>> 8) : (0x33AA33FF >>> 8),
     HUDtoggle[playerid][HUD_FUEL] ? (0xFF0000FF >>> 8) : (0x33AA33FF >>> 8),
     HUDtoggle[playerid][HUD_SPEED] ? (0xFF0000FF >>> 8) : (0x33AA33FF >>> 8),
     HUDtoggle[playerid][HUD_NOS] ? (0xFF0000FF >>> 8) : (0x33AA33FF >>> 8),
     HUDtoggle[playerid][HUD_LOCK] ? (0xFF0000FF >>> 8) : (0x33AA33FF >>> 8),
     HUDtoggle[playerid][HUD_ENGINE] ? (0xFF0000FF >>> 8) : (0x33AA33FF >>> 8),
     HUDtoggle[playerid][HUD_BATTERY] ? (0xFF0000FF >>> 8) : (0x33AA33FF >>> 8),
     HUDtoggle[playerid][HUD_LIGHT] ? (0xFF0000FF >>> 8) : (0x33AA33FF >>> 8));
    return Dialog_Show(playerid, DialogTogHUD, DIALOG_STYLE_LIST, ""EMBED_WHITE"เลือกองค์ประกอบ ("EMBED_GREENMONEY"เปิดใช้"EMBED_WHITE" | "EMBED_RED"ปิด"EMBED_WHITE")", str, "สลับ", "ออก");
}

Dialog:DialogTogHUD(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        HUDtoggle[playerid][listitem] = !HUDtoggle[playerid][listitem];
        hidePlayerHUD(playerid);
        showPlayerHUD(playerid);
        ShowDialogTogHUD(playerid);
	}
	return 1;
}

CMD:toghuds(playerid, params[])
{
	if(!bf_get(player_bf[playerid], TOGGLE_HUD))
	{
		bf_on(player_bf[playerid], TOGGLE_HUD);
		hidePlayerHUD(playerid);
 		GameTextForPlayer(playerid, "~r~HUD OFF", 2000, 4);
	}
	else
	{
		bf_off(player_bf[playerid], TOGGLE_HUD);
		showPlayerHUD(playerid);
		GameTextForPlayer(playerid, "~g~HUD ON", 2000, 4);
	}
	return 1;
}

FormatHUDSettings(playerid)
{
	new wstr[256];
	new tmp[64];
	for(new a = 0; a != MAX_HUD; a++)
	{
		if(a == 0) format(tmp,sizeof(tmp),"%d",HUDtoggle[playerid][a] ? 1 : 0);
		else format(tmp,sizeof(tmp),"|%d",HUDtoggle[playerid][a] ? 1 : 0);
		strins(wstr,tmp,strlen(wstr));
	}
	return wstr;
}

AssignHUDSettings(playerid, const str[])
{
	new wtmp[MAX_HUD][64];
	strexplode(wtmp,str,"|");
	for(new z = 0; z != MAX_HUD; z++)
	{
		HUDtoggle[playerid][z] = strval(wtmp[z]) ? true : false;
	}
}