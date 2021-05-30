new isPlayerCheat[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
    isPlayerCheat[playerid] = 0;
    return 1;
}

forward OnCheatDetected(playerid, const ip_address[], type, code); 
public OnCheatDetected(playerid, const ip_address[], type, code) 
{
    if(type) {
        //Log(anticheatlog, INFO, "[SW-AC]: Suspicion on the IP %s. Reason code: %d", ip_address, code);
        if(!playerData[playerid][pAdmin] && isPlayerAndroid(playerid) != 0)
            BlockIpAddress(ip_address, 0);
    }
    else 
    { 
        //Log(anticheatlog, INFO, "[SW-AC]: Suspicion on %s. Reason code: %d", ReturnPlayerName(playerid), code);
        switch(code) 
        {
            case 5, 6, 11, 22: return 1; 
            case 12: {
                new Float:hp;
                AntiCheatGetHealth(playerid, hp);
                SetPlayerHealth(playerid, hp);
                return 1; 
            }
            case 13: {
                new Float:hp;
                AntiCheatGetArmour(playerid, hp);
                SetPlayerArmour(playerid, hp);
                return 1; 
            }
            case 14: 
            { 
                new a = AntiCheatGetMoney(playerid); 
                ResetPlayerMoney(playerid); 
                GivePlayerMoney(playerid, a); 
                return 1; 
            } 
            case 32: 
            { 
                new Float:x, Float:y, Float:z; 
                AntiCheatGetPos(playerid, x, y, z); 
                SetPlayerPos(playerid, x, y, z); 
                return 1; 
            } 
            case 40: SendClientMessage(playerid, -1, MAX_CONNECTS_MSG); 
            case 41: SendClientMessage(playerid, -1, UNKNOWN_CLIENT_MSG); 
        }

        if(!playerData[playerid][pAdmin] && isPlayerAndroid(playerid) == 0) {
            Log(anticheatlog, INFO, "[SW-AC]: Suspicion on %s. Reason code: %d", ReturnPlayerName(playerid), code);
            SendACMessage(COLOR_YELLOW, CMD_ADM_1, "AdminWarning: %s(%d) ต้องสงสัยใช้โปรแกรมช่วยเล่น %d", ReturnPlayerName(playerid), playerid, code);

            isPlayerCheat[playerid] ++;
            if (isPlayerCheat[playerid] >= 3) {
                KickEx(playerid);
            }
        }

            //AntiCheatKickWithDesync(playerid, code);
    }
    return 1; 
}

ptask CheatTimer[30000](playerid) {
    if (isPlayerCheat[playerid]) {
        isPlayerCheat[playerid]--;
    }
    return 1;
}