#include <YSI\y_hooks>

new 
	PlayerText:playerTDFooter[MAX_PLAYERS],
	showFooter[MAX_PLAYERS char],
	Timer:timerFooter[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
    playerTDFooter[playerid] = CreatePlayerTextDraw(playerid,118.000000, 283.000000, "_");
	PlayerTextDrawBackgroundColor(playerid,playerTDFooter[playerid], 255);
	PlayerTextDrawFont(playerid,playerTDFooter[playerid], 2);
	PlayerTextDrawLetterSize(playerid,playerTDFooter[playerid], 0.220000, 1.199999);
	PlayerTextDrawColor(playerid,playerTDFooter[playerid], -1);
	PlayerTextDrawSetOutline(playerid,playerTDFooter[playerid], 1);
	PlayerTextDrawSetProportional(playerid,playerTDFooter[playerid], 1);
}

hook OnPlayerDisconnect(playerid, reason) {
	if (showFooter{playerid}) {
        stop timerFooter[playerid];
		showFooter{playerid} = false;
	}
	return 1;
}

ShowPlayerFooter(playerid, string[], time = 5000) {

	if (showFooter{playerid}) {
	    PlayerTextDrawSetString(playerid, playerTDFooter[playerid], "_");
	    PlayerTextDrawHide(playerid, playerTDFooter[playerid]);
        stop timerFooter[playerid];
		showFooter{playerid} = false;
	}

 	PlayerTextDrawSetString(playerid, playerTDFooter[playerid], string);
	PlayerTextDrawShow(playerid, playerTDFooter[playerid]);

    if(time != -1) 
        timerFooter[playerid] = defer HidePlayerFooter[time](playerid);

    showFooter{playerid} = true;
}

timer HidePlayerFooter[5000](playerid) {

	if(!IsPlayerConnected(playerid)) {
        return 0;
    }
    stop timerFooter[playerid];
	showFooter{playerid} = false;
	return PlayerTextDrawHide(playerid, playerTDFooter[playerid]);
}
