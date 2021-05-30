#include <YSI\y_hooks>

// Teamspeak
new TSClientID[MAX_PLAYERS];
new bool:Voip[MAX_PLAYERS char];
new bool:client_found;

hook OnPlayerConnect(playerid)
{
	Voip{playerid}= false;
}

hook OnGameModeInit() {
    TSC_Connect("serveradmin", "UB1ROldj", "server.ls-rp.in.th", 9987);
}

public TSC_OnClientConnect(clientid, nickname[])
{
    new client_ip[22], playerip[22];
    TSC_GetClientIpAddress(clientid, client_ip, sizeof client_ip);

    printf("Client: %d %s", clientid, nickname);

    foreach(new i : Player)
    {
        GetPlayerIp(i, playerip, 22);
        if(isequal(playerip, client_ip))
        {
            TSClientID[i] = clientid;
            client_found = true;
        }
    }

    if(!client_found)
        TSC_SendClientMessage(clientid, "We didn't find you ingame. Connect to the server and reconnect on TS.");

    return 1;
}
CMD:channel(playerid, params[])
{
    if(isnull(params))
        return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /channel (Channel ID)");

    if(strcmp(params, "on", true) && !Voip[playerid])
        return SendClientMessage(playerid, -1, "You have not activated your Voip label. (Hint: /channel on)");

    if(!strcmp(params, "on", true))
    {
        if(!client_found)
			return SendClientMessage(playerid, COLOR_GRAD1, "We did not find you on our Teamspeak, please reconnect.");
    
        //Attach3DTextLabelToPlayer(voiplabel[playerid], playerid, 0.0, 0.0, 0.275);
        SendClientMessage(playerid, COLOR_GRAD1, "You have turned on your VoiP marker, you CANNOT turn this off.");

        Voip[playerid] = true;
    }
    else if(!strcmp(params, "lobby", true))
    {
        //Update3DTextLabelText(voiplabel[playerid], 0xE91616FF, "Channel: Lobby");
        SendNearbyMessage(playerid, 20.0, 0xE91616FF, "**%s Has switched to the channel Lobby.**", ReturnPlayerName(playerid));
        TSC_MoveClient(TSClientID[playerid], 1);
    }
    else
    {
        if(!IsNumeric(params))
            return SendClientMessage(playerid, -1, "[Error]: Invalid paramater.");

        new channel_id;
        channel_id = strval(params);

        switch(channel_id)
        {
            case 1: TSC_MoveClient(TSClientID[playerid], 2);
            case 2: TSC_MoveClient(TSClientID[playerid], 3);
            case 3: TSC_MoveClient(TSClientID[playerid], 4);
            case 4: TSC_MoveClient(TSClientID[playerid], 5);
            case 5: TSC_MoveClient(TSClientID[playerid], 6);
            default: return SendClientMessage(playerid, -1, "[Error:] Invalid channel.");
        }

        /*format(string, sizeof string, "Channel: %i", channel_id);
        Update3DTextLabelText(voiplabel[playerid], 0xE91616FF, string);*/

        SendNearbyMessage(playerid, 20.0, 0xE91616FF, "**%s Has switched to the channel %i.**", ReturnPlayerName(playerid), channel_id);
    }
    return 1;
}

public TSC_OnError(TSC_ERROR_TYPE:error_type, error_id, const error_msg[]) {
    printf("type %d id %d msg %s", _:error_type, error_id, error_msg);
    return 1;
}