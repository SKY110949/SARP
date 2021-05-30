
#include <YSI\y_hooks> 

new Timer:fixCameraTimer[MAX_PLAYERS], gPlayerGameText[MAX_PLAYERS char];

hook OnPlayerConnect(playerid) {
    stop fixCameraTimer[playerid];
    gPlayerGameText{playerid} = false;
    return 1;
}

timer FixMobileCamera[1300](playerid, Float:X, Float:Y, Float:Z, Float:vX, Float:vY, Float:vZ) {
    SetPlayerCameraPos(playerid, X, Y, Z);
    SetPlayerCameraLookAt(playerid, vX,vY,vZ);
    TogglePlayerControllable(playerid, false);
    return 1;
}

DestroyDyn3DTextLabelFix(STREAMER_TAG_3D_TEXT_LABEL:id) {
    UpdateDynamic3DTextLabelText(id, -1, "");
    return DestroyDynamic3DTextLabel(id);
}

new Timer:gameTextTimer[MAX_PLAYERS];
Mobile_GameTextForPlayer(playerid, const str[], time, type) {
    if(isPlayerAndroid(playerid) != 0) {
        stop gameTextTimer[playerid];
        if (type >= 3 && type <= 6) {
            gPlayerGameText{playerid} = true;
            gameTextTimer[playerid] = defer GametextTimer[time](playerid);
        }
    }
    return GameTextForPlayer(playerid, str, time, type);
}

Mobile_IsGameTextShow(playerid) 
    return gPlayerGameText{playerid};

timer GametextTimer[1000](playerid) {
    gPlayerGameText{playerid} = false;
}

