//--------------------------------[WRAPPERS.PWN]--------------------------------

stock KickEx(playerid)
{
	defer KickTimer(playerid);
	return 1;
}

timer KickTimer[400](playerid)
{
	if (IsPlayerConnected(playerid)) 
        Kick(playerid);
}

stock randomEx(min, max)
{
    new rand = random(max-min)+min;
    return rand;
}

stock PlayerPlaySoundEx(playerid, sound)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(playerid, x, y, z);

	foreach (new i : Player) if (IsPlayerInRangeOfPoint(i, 20.0, x, y, z)) {
		PlayerPlaySound(i, sound, x, y, z);
	}
	return 1;
}

stock ClearChatBox(playerid) for (new i = 0; i < 100; i ++) SendClientMessage(playerid, -1, "");