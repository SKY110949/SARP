
#include <YSI\y_hooks>

#define     MAX_ROBBERIES   	(40)
#define     ATTACH_INDEX        (4)     // required for SetPlayerAttachedObject
#define     PLACE_COOLDOWN      (180)     // a robbery place can't be robbed again for x minutes (Default: 3)
/*
enum    E_ROBBERY_DIALOG
{
	DIALOG_ROBBERY = 10350,

	DIALOG_ADD_ROBBERY_1,
	DIALOG_ADD_ROBBERY_2,
	DIALOG_ADD_ROBBERY_3,
	DIALOG_ADD_ROBBERY_FINAL,
	DIALOG_REMOVE_ROBBERY
}
*/
enum E_ROBBERY
{
	// robbery name
	robName[32],
	// pos data
	Float: robPosX,
	Float: robPosY,
	Float: robPosZ,
	robIntID,
	robVWID,
	// robbery data
	robAmount,
	robReqTime,
	robSafeTime,
	// record
	robRecordAmount,
	robRecordBy[MAX_PLAYER_NAME],
	// temp
	robOccupiedBy,
	robCooldown,
	Timer:robTimer,
	robCheckpoint,
	Text3D: robLabel,
	bool: robExists
}

enum   _:E_ROBBERY_STAGE
{
	STAGE_CRACKING,
	STAGE_OPENING,
	STAGE_ROBBING
}

enum    E_PLAYER_ROBBERY
{
	SafeObject,
	MoneyStolen,
	RobID,
	RobTime,
	RobStage,
	Timer:RobberyTimer
}

new
	RobberyData[MAX_ROBBERIES][E_ROBBERY];

new
	PlayerRobberyData[MAX_PLAYERS][E_PLAYER_ROBBERY];

RandomEx(min, max) //Y_Less
    return random(max - min) + min;

ConvertToMinutes(time)
{
	new str[64];
	format(str, sizeof str, "%02d:%02d", time / 60, time % 60);
    return str;
}

Robbery_FindFreeID()
{
	for(new i; i < MAX_ROBBERIES; i++) if(!RobberyData[i][robExists]) return i;
	return -1;
}

Robbery_Cooldown(id)
{
    RobberyData[id][robCooldown] = PLACE_COOLDOWN * 60;
    //RobberyData[id][robTimer] = SetTimerEx("ResetPlace", 1000, true, "i", id);
	RobberyData[id][robTimer] = repeat ResetPlace(id);

    new string[160];
    format(string, sizeof(string), "โจรกรรม(%d)\n\n{FFFFFF}%s\n{2ECC71}%s - %s {FFFFFF}ทุก ๆ {F1C40F}5 {FFFFFF}วินาที\n{2ECC71}ปล้นได้ในอีก %s", id, RobberyData[id][robName], FormatNumber(floatround(RobberyData[id][robAmount] / 4)), FormatNumber(RobberyData[id][robAmount]), ConvertToMinutes(RobberyData[id][robCooldown]));
    UpdateDynamic3DTextLabelText(RobberyData[id][robLabel], 0xF1C40FFF, string);
	return 1;
}

Robbery_InitPlayer(playerid)
{
	PlayerRobberyData[playerid][RobberyTimer] = Timer:0;
	PlayerRobberyData[playerid][SafeObject] = PlayerRobberyData[playerid][RobID] = -1;
	PlayerRobberyData[playerid][MoneyStolen] = PlayerRobberyData[playerid][RobTime] = PlayerRobberyData[playerid][RobStage] = 0;

	/*RobberyText[playerid] = CreatePlayerTextDraw(playerid, 40.000000, 295.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, RobberyText[playerid], 255);
	PlayerTextDrawFont(playerid, RobberyText[playerid], 1);
	PlayerTextDrawLetterSize(playerid, RobberyText[playerid], 0.240000, 1.100000);
	PlayerTextDrawColor(playerid, RobberyText[playerid], -1);
	PlayerTextDrawSetOutline(playerid, RobberyText[playerid], 1);
	PlayerTextDrawSetProportional(playerid, RobberyText[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, RobberyText[playerid], 0);*/

	SetPVarInt(playerid, "robberyID", -1);

	// preload anims
    ApplyAnimation(playerid, "COP_AMBIENT", "null", 0.0, 0, 0, 0, 0, 0);
    ApplyAnimation(playerid, "ROB_BANK", "null", 0.0, 0, 0, 0, 0, 0);
	return 1;
}

Robbery_ResetPlayer(playerid, check = 0)
{
    new id = PlayerRobberyData[playerid][RobID];
    if(check && id != -1 && PlayerRobberyData[playerid][MoneyStolen] > 0) Robbery_Cooldown(id);
	if(id != -1 && RobberyData[id][robOccupiedBy] == playerid) RobberyData[id][robOccupiedBy] = -1;

	if(IsValidDynamicObject(PlayerRobberyData[playerid][SafeObject])) 
		DestroyDynamicObject(PlayerRobberyData[playerid][SafeObject]);
	//KillTimer(PlayerRobberyData[playerid][RobberyTimer]);
	stop PlayerRobberyData[playerid][RobberyTimer];
	RemovePlayerAttachedObject(playerid, ATTACH_INDEX);
	if(!IsPlayerInAnyVehicle(playerid)) ClearAnimations(playerid);
	//PlayerTextDrawHide(playerid, RobberyText[playerid]);
	Streamer_Update(playerid);

	PlayerRobberyData[playerid][RobberyTimer] = Timer:0;
    PlayerRobberyData[playerid][SafeObject] = -1;
	PlayerRobberyData[playerid][MoneyStolen] = PlayerRobberyData[playerid][RobTime] = PlayerRobberyData[playerid][RobStage] = 0;

	SetPVarInt(playerid, "robberyID", -1);
	return 1;
}

hook OnGameModeInit()
{
    print("  [Robberies] Initializing...");

	foreach(new i : Player) Robbery_InitPlayer(i);
	for(new i; i < MAX_ROBBERIES; i++)
	{
		stop RobberyData[i][robTimer];
		RobberyData[i][robTimer] = Timer:0;

	    RobberyData[i][robOccupiedBy] = RobberyData[i][robCheckpoint] = -1;
	    RobberyData[i][robLabel] = Text3D: -1;
	}

 	mysql_query(dbCon, "SELECT * FROM robberies");

    new
	    rows, loaded;

	cache_get_row_count(rows);

	if (rows) {
	
		for (new id = 0; id < rows; id ++) if (id < MAX_ROBBERIES)
		{
			cache_get_value_name(id, "Name", RobberyData[id][robName], 32);
			cache_get_value_name_float(id, "PosX", RobberyData[id][robPosX]);
			cache_get_value_name_float(id, "PosY", RobberyData[id][robPosY]);
			cache_get_value_name_float(id, "PosZ", RobberyData[id][robPosZ]);
			cache_get_value_name_int(id, "Interior", RobberyData[id][robIntID]);
			cache_get_value_name_int(id, "Virtual", RobberyData[id][robVWID]);
			cache_get_value_name_int(id, "Amount", RobberyData[id][robAmount]);
			cache_get_value_name_int(id, "RequiredTime", RobberyData[id][robReqTime]);
			cache_get_value_name_int(id, "SafeTime", RobberyData[id][robSafeTime]);
			cache_get_value_name_int(id, "RecAmount", RobberyData[id][robRecordAmount]);
			cache_get_value_name(id, "RecBy", RobberyData[id][robRecordBy], MAX_PLAYER_NAME);
			
			RobberyData[id][robCheckpoint] = CreateDynamicCP(RobberyData[id][robPosX], RobberyData[id][robPosY], RobberyData[id][robPosZ], 1.25, RobberyData[id][robVWID], RobberyData[id][robIntID], _, 5.0);
			//format(label, sizeof(label), "โจรกรรม(%d)\n\n{FFFFFF}%s\n{2ECC71}%s - %s {FFFFFF}ทุก ๆ {F1C40F}5 {FFFFFF}วินาที\n{2ECC71}ปล้นได้", id, name, FormatNumber(floatround(amount / 4)), FormatNumber(amount));
			RobberyData[id][robLabel] = CreateDynamic3DTextLabel(sprintf("โจรกรรม(%d)\n\n{FFFFFF}%s\n{2ECC71}%s - %s {FFFFFF}ทุก ๆ {F1C40F}5 {FFFFFF}วินาที\n{2ECC71}ปล้นได้", id, RobberyData[id][robName], FormatNumber(floatround(RobberyData[id][robAmount] / 4)), FormatNumber(RobberyData[id][robAmount])), 0xF1C40FFF, RobberyData[id][robPosX], RobberyData[id][robPosY], RobberyData[id][robPosZ] + 0.25, 10.0, _, _, 1, RobberyData[id][robVWID], RobberyData[id][robIntID]);
			RobberyData[id][robExists] = true;
			loaded++;
		}
	}
	printf("Robberies loaded (%d/%d)", loaded, MAX_ROBBERIES);
	
	return 1;
}

hook OnGameModeExit()
{
    foreach(new i : Player)
	{
		Robbery_ResetPlayer(i);
		//PlayerTextDrawDestroy(i, RobberyText[i]);
	}
	
	// db_close(RobberyDatabase);
	print("  [Robberies] Unloaded.");
	return 1;
}

hook OnPlayerConnect(playerid)
{
	Robbery_InitPlayer(playerid);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    Robbery_ResetPlayer(playerid);
	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	/*if(IsPlayerConnected(killerid) && PlayerRobberyData[playerid][MoneyStolen] > 0)
	{
	    new string[144], name[MAX_PLAYER_NAME];
	    GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	    format(string, sizeof(string), "[การโจรกรรม] {FFFFFF}You killed the robber {F1C40F}%s(%d) {FFFFFF}and took the money they stole. {2ECC71}(%s)", name, playerid, FormatNumber(PlayerRobberyData[playerid][MoneyStolen]));
	    SendClientMessage(killerid, 0x3498DBFF, string);

	    Robbery_Cooldown(PlayerRobberyData[playerid][RobID]);
	}*/
	if (PlayerRobberyData[playerid][MoneyStolen] > 0)
	{
		Robbery_Cooldown(PlayerRobberyData[playerid][RobID]);
	}

	Robbery_ResetPlayer(playerid);
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	#if defined SV_DEBUG
		printf("robber.pwn: OnPlayerStateChange(playerid %d, newstate %d, oldstate %d)", playerid, newstate, oldstate);
	#endif
	if(newstate != PLAYER_STATE_WASTED) Robbery_ResetPlayer(playerid);
	return 1;
}

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_NO) && PlayerRobberyData[playerid][RobberyTimer] != Timer:0) Robbery_ResetPlayer(playerid, 1);
	return 1;
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	#if defined SV_DEBUG
		printf("robber.pwn: EnterDynamicCP(playerid %d, checkpointid %d)", playerid, checkpointid);
	#endif
	if(!IsPlayerInAnyVehicle(playerid))
	{
		for(new i; i < MAX_ROBBERIES; i++)
		{
		    if(!RobberyData[i][robExists]) continue;
		    if(checkpointid == RobberyData[i][robCheckpoint])
		    {
		        SetPVarInt(playerid, "robberyID", i);

				if(!IsPlayerConnected(RobberyData[i][robOccupiedBy]) && RobberyData[i][robTimer] == Timer:0)
				{
					Dialog_Show(playerid, DIALOG_ROBBERY, DIALOG_STYLE_MSGBOX, sprintf("โจรกรรม: %s", RobberyData[i][robName]), "คุณต้องการปล้นที่นี่ใช่ไหม?", "ใช่ ปล้นเลย", "ปิด");
				}

		        break;
		    }
		}
	}
	
	return 1;
}

hook OnPlayerLeaveDynamicCP(playerid, checkpointid)
{
	if(PlayerRobberyData[playerid][RobberyTimer] != Timer:0)
	{
	    if(PlayerRobberyData[playerid][MoneyStolen] > 0)
	    {
	        new id = PlayerRobberyData[playerid][RobID];
	        if(id != -1) Robbery_Cooldown(id);
	        
	        new string[128];
	        format(string, sizeof(string), "~n~~n~~n~~b~~h~~h~Robbery Cancelled~n~~w~Money Stolen: ~g~~h~~h~%s", FormatNumber(PlayerRobberyData[playerid][MoneyStolen]));
    		Mobile_GameTextForPlayer(playerid, string, 3000, 3);
     		GivePlayerMoneyEx(playerid, PlayerRobberyData[playerid][MoneyStolen]);
			Log(paychecklog, INFO, "%s ได้รับ เงินสด %d จาก Robbery Cancelled", ReturnPlayerName(playerid), PlayerRobberyData[playerid][MoneyStolen]);

			SetPlayerCriminalEx(playerid, RobberyData[id][robName], sprintf("ขโมยเงินสดไปทั้งหมด $%d", PlayerRobberyData[playerid][MoneyStolen]));
	    }
	    
		Robbery_ResetPlayer(playerid);
	}
	
	SetPVarInt(playerid, "robberyID", -1);
	return 1;
}

/*
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
	    case DIALOG_ROBBERY:
	    {
	    	if(!response) return 1;
	    	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You can't do this in a vehicle.");
	    	new id = GetPVarInt(playerid, "robberyID");
	    	if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not in a robbery checkpoint.");
	    	if(IsPlayerConnected(RobberyData[id][robOccupiedBy])) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}This robbery place is occupied.");
	    	if(!IsPlayerInDynamicCP(playerid, RobberyData[id][robCheckpoint])) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not in the robbery checkpoint.");
	    	new Float: x, Float: y, Float: z, Float: a;
		 	GetPlayerPos(playerid, x, y, z);
			GetPlayerFacingAngle(playerid, a);
			
		 	x += (1.25 * floatsin(-a, degrees));
			y += (1.25 * floatcos(-a, degrees));
			PlayerRobberyData[playerid][SafeObject][0] = CreateDynamicObject(19618, x, y, z-0.55, 0.0, 0.0, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

            a += 90.0;
			x += (0.42 * floatsin(-a, degrees)) + (-0.22 * floatsin(-(a - 90.0), degrees));
			y += (0.42 * floatcos(-a, degrees)) + (-0.22 * floatcos(-(a - 90.0), degrees));
			PlayerRobberyData[playerid][SafeObject][1] = CreateDynamicObject(19619, x, y, z-0.55, 0.0, 0.0, a + 270.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			
		 	PlayerRobberyData[playerid][MoneyStolen] = 0;
		 	PlayerRobberyData[playerid][RobID] = id;
			PlayerRobberyData[playerid][RobTime] = RobberyData[id][robSafeTime];
			PlayerRobberyData[playerid][RobStage] = STAGE_CRACKING;
			PlayerRobberyData[playerid][RobberyTimer] = SetTimerEx("Robbery", 1000, true, "ii", playerid, id);
			RobberyData[id][robOccupiedBy] = playerid;
			
			SetPlayerAttachedObject(playerid, ATTACH_INDEX, 18634, 6, 0.054000, 0.013999, -0.087999, -94.399963, -25.899974, 175.799911);
			ApplyAnimation(playerid, "COP_AMBIENT", "COPBROWSE_LOOP", 4.0, 1, 0, 0, 0, 0);
			
			new string[128];
			format(string, sizeof(string), "~b~~h~Robbery~n~~n~~w~Cracking safe...~n~Complete in ~r~%s", ConvertToMinutes(RobberyData[id][robSafeTime]));
			PlayerTextDrawSetString(playerid, RobberyText[playerid], string);
			PlayerTextDrawShow(playerid, RobberyText[playerid]);
			
			if(RobberyData[id][robRecordAmount] > 0)
			{
				format(string, sizeof(string), "[การโจรกรรม] {F1C40F}%s {FFFFFF}holds the record for this place with {2ECC71}%s {FFFFFF}stolen.", RobberyData[id][robRecordBy], FormatNumber(RobberyData[id][robRecordAmount]));
   				SendClientMessage(playerid, 0x3498DBFF, string);
			}
			
			SendClientMessage(playerid, 0x3498DBFF, "[การโจรกรรม] {FFFFFF}You can press {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}to cancel the robbery.");
			Streamer_Update(playerid);
			return 1;
	    }

	    case DIALOG_ADD_ROBBERY_1:
	    {
	        if(!IsPlayerAdmin(playerid) || !response) return 1;
			if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_ADD_ROBBERY_1, DIALOG_STYLE_INPUT, "{F1C40F}Robbery: {FFFFFF}Add (step 1)", "{E74C3C}Input can't be empty.\n\n{FFFFFF}Write a name for the robbery:", "Next", "Close");
			SetPVarString(playerid, "robberyName", inputtext);
			ShowPlayerDialog(playerid, DIALOG_ADD_ROBBERY_2, DIALOG_STYLE_INPUT, "{F1C40F}Robbery: {FFFFFF}Add (step 2)", "Safe cracking duration (in seconds):", "Next", "Back");
			return 1;
	    }

	    case DIALOG_ADD_ROBBERY_2:
	    {
	        if(!IsPlayerAdmin(playerid)) return 1;
	        if(!response) return ShowPlayerDialog(playerid, DIALOG_ADD_ROBBERY_1, DIALOG_STYLE_INPUT, "{F1C40F}Robbery: {FFFFFF}Add (step 1)", "Write a name for the robbery:", "Next", "Close");
			if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_ADD_ROBBERY_2, DIALOG_STYLE_INPUT, "{F1C40F}Robbery: {FFFFFF}Add (step 2)", "{E74C3C}Input can't be empty.\n\n{FFFFFF}Safe cracking duration (in seconds):", "Next", "Back");
			SetPVarInt(playerid, "robberySafeDur", strval(inputtext));
			ShowPlayerDialog(playerid, DIALOG_ADD_ROBBERY_3, DIALOG_STYLE_INPUT, "{F1C40F}Robbery: {FFFFFF}Add (step 3)", "Robbery duration (in seconds - must be multiples of 5):", "Next", "Back");
			return 1;
	    }

	    case DIALOG_ADD_ROBBERY_3:
	    {
	        if(!IsPlayerAdmin(playerid)) return 1;
	        if(!response) return ShowPlayerDialog(playerid, DIALOG_ADD_ROBBERY_2, DIALOG_STYLE_INPUT, "{F1C40F}Robbery: {FFFFFF}Add (step 2)", "Safe cracking duration (in seconds):", "Next", "Back");
			if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_ADD_ROBBERY_3, DIALOG_STYLE_INPUT, "{F1C40F}Robbery: {FFFFFF}Add (step 3)", "{E74C3C}Input can't be empty.\n\n{FFFFFF}Robbery duration (in seconds - must be multiples of 5):", "Next", "Back");
			new dur = strval(inputtext);
			if(dur < 1 || (dur % 5) != 0) return ShowPlayerDialog(playerid, DIALOG_ADD_ROBBERY_3, DIALOG_STYLE_INPUT, "{F1C40F}Robbery: {FFFFFF}Add (step 3)", "{E74C3C}Invalid duration.\n\n{FFFFFF}Robbery duration (in seconds - must be multiples of 5):", "Next", "Back");
			SetPVarInt(playerid, "robberyDur", dur);
			ShowPlayerDialog(playerid, DIALOG_ADD_ROBBERY_FINAL, DIALOG_STYLE_INPUT, "{F1C40F}Robbery: {FFFFFF}Add (step 4)", "Money amount:", "Finish", "Back");
			return 1;
	    }

	    case DIALOG_ADD_ROBBERY_FINAL:
	    {
	        if(!IsPlayerAdmin(playerid)) return 1;
	        if(!response) return ShowPlayerDialog(playerid, DIALOG_ADD_ROBBERY_3, DIALOG_STYLE_INPUT, "{F1C40F}Robbery: {FFFFFF}Add (step 3)", "Robbery duration (in seconds - must be multiples of 5):", "Next", "Back");
			if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_ADD_ROBBERY_FINAL, DIALOG_STYLE_INPUT, "{F1C40F}Robbery: {FFFFFF}Add (step 4)", "{E74C3C}Input can't be empty.\n\n{FFFFFF}Money amount:", "Finish", "Back");
            if(strval(inputtext) < 1) return ShowPlayerDialog(playerid, DIALOG_ADD_ROBBERY_FINAL, DIALOG_STYLE_INPUT, "{F1C40F}Robbery: {FFFFFF}Add (step 4)", "{E74C3C}Invalid amount.\n\n{FFFFFF}Money amount:", "Finish", "Back");

			new id = Robbery_FindFreeID();
			if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Can't create any more robberies.");
		    new Float: x, Float: y, Float: z, vwid = GetPlayerVirtualWorld(playerid), intid = GetPlayerInterior(playerid), string[160];
			GetPlayerPos(playerid, x, y, z);

			GetPVarString(playerid, "robberyName", RobberyData[id][robName], 32);
			RobberyData[id][robPosX] = x;
			RobberyData[id][robPosY] = y;
			RobberyData[id][robPosZ] = z;
			RobberyData[id][robIntID] = intid;
			RobberyData[id][robVWID] = vwid;
			RobberyData[id][robAmount] = strval(inputtext);
			RobberyData[id][robReqTime] = GetPVarInt(playerid, "robberyDur");
			RobberyData[id][robSafeTime] = GetPVarInt(playerid, "robberySafeDur");
			RobberyData[id][robRecordAmount] = 0;
			RobberyData[id][robRecordBy][0] = EOS;
			
		    RobberyData[id][robOccupiedBy] = -1;
		    RobberyData[id][robCooldown] = 0;
			RobberyData[id][robTimer] = -1;
			
			RobberyData[id][robCheckpoint] = CreateDynamicCP(x, y, z, 1.25, vwid, intid, .streamdistance = 5.0);

		    format(string, sizeof(string), "โจรกรรม(%d)\n\n{FFFFFF}%s\n{2ECC71}%s - %s {FFFFFF}ทุก ๆ {F1C40F}5 {FFFFFF}วินาที\n{2ECC71}ปล้นได้", id, RobberyData[id][robName], FormatNumber(floatround(RobberyData[id][robAmount] / 4)), FormatNumber(RobberyData[id][robAmount]));
		    RobberyData[id][robLabel] = CreateDynamic3DTextLabel(string, 0xF1C40FFF, x, y, z + 0.25, 10.0, _, _, 1, vwid, intid);
			
		    RobberyData[id][robExists] = true;

		    stmt_bind_value(AddRobbery, 0, DB::TYPE_INTEGER, id);
		    stmt_bind_value(AddRobbery, 1, DB::TYPE_STRING, RobberyData[id][robName], 32);
		    stmt_bind_value(AddRobbery, 2, DB::TYPE_FLOAT, x);
		    stmt_bind_value(AddRobbery, 3, DB::TYPE_FLOAT, y);
		    stmt_bind_value(AddRobbery, 4, DB::TYPE_FLOAT, z);
		    stmt_bind_value(AddRobbery, 5, DB::TYPE_INTEGER, intid);
		    stmt_bind_value(AddRobbery, 6, DB::TYPE_INTEGER, vwid);
		    stmt_bind_value(AddRobbery, 7, DB::TYPE_INTEGER, RobberyData[id][robAmount]);
		    stmt_bind_value(AddRobbery, 8, DB::TYPE_INTEGER, RobberyData[id][robReqTime]);
		    stmt_bind_value(AddRobbery, 9, DB::TYPE_INTEGER, RobberyData[id][robSafeTime]);
			if(stmt_execute(AddRobbery)) SendClientMessage(playerid, 0x3498DBFF, "[การโจรกรรม] {FFFFFF}Robbery created.");
			return 1;
	    }
	    case DIALOG_REMOVE_ROBBERY:
	    {
	        if(!IsPlayerAdmin(playerid) || !response) return 1;
	        new id = strval(inputtext);
	        if(!RobberyData[id][robExists]) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Robbery doesn't exist.");
	        for(new i, mp = GetPlayerPoolSize(); i <= mp; i++)
	        {
	            if(!IsPlayerConnected(i)) continue;
	            if(PlayerRobberyData[i][RobID] == id) Robbery_ResetPlayer(i);
	        }
	        
	        if(RobberyData[id][robTimer] != -1) KillTimer(RobberyData[id][robTimer]);
	        DestroyDynamicCP(RobberyData[id][robCheckpoint]);
	        DestroyDynamic3DTextLabel(RobberyData[id][robLabel]);
	        
	        RobberyData[id][robOccupiedBy] = RobberyData[id][robTimer] = RobberyData[id][robCheckpoint] = -1;
	    	RobberyData[id][robLabel] = Text3D: -1;
	    	RobberyData[id][robExists] = false;
	    	
            stmt_bind_value(RemoveRobbery, 0, DB::TYPE_INTEGER, id);
	    	if(stmt_execute(RemoveRobbery)) SendClientMessage(playerid, 0x3498DBFF, "[การโจรกรรม] {FFFFFF}Robbery removed.");
	        return 1;
	    }
	}
	
	return 0;
}*/

/*forward Robbery(playerid, id);
public Robbery(playerid, id)*/
timer Robbery[1000](playerid, id)
{
	if(PlayerRobberyData[playerid][RobTime] > 1) {
	    PlayerRobberyData[playerid][RobTime]--;

		// SendClientMessageEx(playerid, -1, "Robbing Time %d", PlayerRobberyData[playerid][RobTime]);

	    switch(PlayerRobberyData[playerid][RobStage])
	    {
	        case STAGE_CRACKING:
	        {
				Mobile_GameTextForPlayer(playerid, sprintf("~b~~h~Robbery~n~~n~~w~Cracking safe...~n~Complete in ~r~%s", ConvertToMinutes(PlayerRobberyData[playerid][RobTime])), 1200, 3);
	        }
	        
	        case STAGE_OPENING:
	        {
				Mobile_GameTextForPlayer(playerid, sprintf("~b~~h~Robbery~n~~n~~w~Opening safe door...~n~Complete in ~r~%s", ConvertToMinutes(PlayerRobberyData[playerid][RobTime])), 1200, 3);
	        }

	        case STAGE_ROBBING:
	        {
	            if(PlayerRobberyData[playerid][RobTime] % 5 == 0)
				{
					PlayerRobberyData[playerid][MoneyStolen] += RandomEx(floatround(RobberyData[id][robAmount] / 4), RobberyData[id][robAmount]);
                    PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
				}
				
				Mobile_GameTextForPlayer(playerid, sprintf("~b~~h~Robbery~n~~n~~w~Money Stolen: ~g~~h~~h~%s~n~Complete in ~r~%s", FormatNumber(PlayerRobberyData[playerid][MoneyStolen]), ConvertToMinutes(PlayerRobberyData[playerid][RobTime])), 1200, 3);
	        }
	    }
	}else if(PlayerRobberyData[playerid][RobTime] == 1) {
	    switch(PlayerRobberyData[playerid][RobStage])
	    {
	        case STAGE_CRACKING:
	        {
				if(IsValidDynamicObject(PlayerRobberyData[playerid][SafeObject])) 
					DestroyDynamicObject(PlayerRobberyData[playerid][SafeObject]);
					
				new Float: x, Float: y, Float: z, Float: a;
				GetPlayerPos(playerid, x, y, z);
				GetPlayerFacingAngle(playerid, a);
							
				x += (1.25 * floatsin(-a, degrees));
				y += (1.25 * floatcos(-a, degrees));
				PlayerRobberyData[playerid][SafeObject] = CreateDynamicObject(1829, x, y, z-0.55, 0.0, 0.0, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				Streamer_Update(playerid);
				
	            PlayerRobberyData[playerid][RobTime] = 4;
				PlayerRobberyData[playerid][RobStage] = STAGE_OPENING;

				Mobile_GameTextForPlayer(playerid, "~b~~h~Robbery~n~~n~~w~Opening safe door...~n~Complete in ~r~00:04", 1200, 3);

				RemovePlayerAttachedObject(playerid, ATTACH_INDEX);
				ApplyAnimation(playerid, "ROB_BANK", "CAT_Safe_Open", 4.0, 0, 0, 0, 0, 0, 1);
				PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
			}
			
	        case STAGE_OPENING:
	        {
	            PlayerRobberyData[playerid][RobTime] = RobberyData[id][robReqTime];
	            PlayerRobberyData[playerid][RobStage] = STAGE_ROBBING;
				SetPlayerAttachedObject(playerid, ATTACH_INDEX, 1550, 1, 0.029999, -0.265000, 0.017000, 6.199993, 88.800003, 0.0);

				Mobile_GameTextForPlayer(playerid, sprintf("~b~~h~Robbery~n~~n~~w~Money Stolen: ~g~~h~~h~$0~n~Complete in ~r~%s", ConvertToMinutes(RobberyData[id][robReqTime])), 1200, 3);

				ApplyAnimation(playerid, "ROB_BANK", "CAT_Safe_Rob", 4.0, 1, 0, 0, 0, 0, 1);
				PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
			}

	        case STAGE_ROBBING:
	        {
             	Robbery_Cooldown(id);

	    		Mobile_GameTextForPlayer(playerid, sprintf("~n~~n~~n~~b~~h~~h~Robbery Complete~n~~w~Money Stolen: ~g~~h~~h~%s", FormatNumber(PlayerRobberyData[playerid][MoneyStolen])), 3000, 3);
         		GivePlayerMoneyEx(playerid, PlayerRobberyData[playerid][MoneyStolen]);

				Log(paychecklog, INFO, "%s ได้รับ เงินสด %d จาก Robbery Complete", ReturnPlayerName(playerid), PlayerRobberyData[playerid][MoneyStolen]);

         		PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);

         		new name[MAX_PLAYER_NAME];
         		GetPlayerName(playerid, name, MAX_PLAYER_NAME);
         		SendClientMessageToAllEx(0x3498DBFF, "[การโจรกรรม] {FFFFFF}%s(%d) ได้ขโมยเงิน {2ECC71}%s {FFFFFF}จาก {F1C40F}%s", name, playerid, FormatNumber(PlayerRobberyData[playerid][MoneyStolen]), RobberyData[id][robName]);

         		if(PlayerRobberyData[playerid][MoneyStolen] > RobberyData[id][robRecordAmount])
         		{
         		    RobberyData[id][robRecordAmount] = PlayerRobberyData[playerid][MoneyStolen];
         		    RobberyData[id][robRecordBy] = name;
         		    
         		    SendClientMessage(playerid, 0x3498DBFF, "[การโจรกรรม] {FFFFFF}คุณทำลายสถิติการปล้นของที่นี่!");
         		    
                    SendClientMessageEx(playerid, 0x3498DBFF, "[การโจรกรรม] {FFFFFF}เพระแบบนี้คุณจึงได้รับโบนัสเพิ่มขึ้นอีก 15 เปอร์เซ็นต์ {2ECC71}(%s)", FormatNumber(floatround(PlayerRobberyData[playerid][MoneyStolen] * 0.15)));
                    
                    GivePlayerMoneyEx(playerid, floatround(PlayerRobberyData[playerid][MoneyStolen] * 0.15));

					Log(paychecklog, INFO, "%s ได้รับ เงินสด %d จาก Robbery Complete Bonus", ReturnPlayerName(playerid), floatround(PlayerRobberyData[playerid][MoneyStolen] * 0.15));
                    
					new str[128];
					mysql_format(dbCon, str, sizeof str, "UPDATE robberies SET RecAmount = %d, RecordBy = '%e' WHERE ID = %d", RobberyData[id][robRecordAmount], RobberyData[id][robRecordBy], id);
					mysql_tquery(dbCon, str);
         		}

				SetPlayerCriminalEx(playerid, RobberyData[id][robName], sprintf("ขโมยเงินสดไปทั้งหมด $%d", PlayerRobberyData[playerid][MoneyStolen]));
         		
		    	Robbery_ResetPlayer(playerid);
	        }
	    }
	}
	
	return 1;
}

//forward ResetPlace(id);
//public ResetPlace(id)

timer ResetPlace[1000](id)
{
	new string[160];
	if(RobberyData[id][robCooldown] > 1) {
	    RobberyData[id][robCooldown]--;

	    format(string, sizeof(string), "โจรกรรม(%d)\n\n{FFFFFF}%s\n{2ECC71}%s - %s {FFFFFF}ทุก ๆ {F1C40F}5 {FFFFFF}วินาที\n{2ECC71}ปล้นได้ในอีก %s", id, RobberyData[id][robName], FormatNumber(floatround(RobberyData[id][robAmount] / 4)), FormatNumber(RobberyData[id][robAmount]), ConvertToMinutes(RobberyData[id][robCooldown]));
    	UpdateDynamic3DTextLabelText(RobberyData[id][robLabel], 0xF1C40FFF, string);
	}else if(RobberyData[id][robCooldown] == 1) {

		stop RobberyData[id][robTimer];
		RobberyData[id][robTimer] = Timer:0;

	    RobberyData[id][robCooldown] = 0;
		
		format(string, sizeof(string), "โจรกรรม(%d)\n\n{FFFFFF}%s\n{2ECC71}%s - %s {FFFFFF}ทุก ๆ {F1C40F}5 {FFFFFF}วินาที\n{2ECC71}ปล้นได้", id, RobberyData[id][robName], FormatNumber(floatround(RobberyData[id][robAmount] / 4)), FormatNumber(RobberyData[id][robAmount]));
	    UpdateDynamic3DTextLabelText(RobberyData[id][robLabel], 0xF1C40FFF, string);
	}
	
	return 1;
}

flags:createrobbery(CMD_MANAGEMENT);
CMD:createrobbery(playerid, params[])
{
	new id = Robbery_FindFreeID();
	if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}ไม่สามารถสร้างพื้นที่โจรกรรมได้มากกว่านี้แล้ว");
	Dialog_Show(playerid, DIALOG_ADD_ROBBERY_1, DIALOG_STYLE_INPUT, "{F1C40F}การโจรกรรม: {FFFFFF}เพิ่ม (ขั้น 1)", "ป้อนชื่อการโจรกรรม:", "ถัดไป", "ปิด");
	return 1;
}

flags:removerobbery(CMD_MANAGEMENT);
CMD:removerobbery(playerid, params[])
{
	new string[1024], total;

	for(new i; i < MAX_ROBBERIES; i++)
	{
	    if(!RobberyData[i][robExists]) continue;
	    format(string, sizeof(string), "%s%d\t%s\n", string, i, RobberyData[i][robName]);
	    total++;
	}
	
	if(total == 0) {
 		SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}ยังไม่มีพื้นที่การโจรกรรมที่ถูกสร้างขึ้น");
	}else{
	    Dialog_Show(playerid, DIALOG_REMOVE_ROBBERY, DIALOG_STYLE_LIST, "{F1C40F}การโจรกรรม: {FFFFFF}ลบ", string, "ลบ", "ปิด");
	}
	
	return 1;
}

Dialog:DIALOG_ROBBERY(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;

	if(playerData[playerid][pLevel] < 5) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}คุณต้องมีเลเวลตั้งแต่ 5 ขึ้นไป");
	if(Faction_OnlineCount(FACTION_TYPE_POLICE) < 5) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}ต้องมีเจ้าหน้าที่ออนไลน์ตั้งแต่ 5 คนขึ้นไป");

	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}คุณไม่สามารถกระทำสิ่งนี้ในขณะที่อยู่บนรถยนต์ได้");
	new id = GetPVarInt(playerid, "robberyID");
	if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}คุณไม่ได้อยู่ที่จุดแดงสำหรับการปล้น");
	if(IsPlayerConnected(RobberyData[id][robOccupiedBy])) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}ที่สำหรับปล้นตรงนี้ไม่ว่าง");
	if(!IsPlayerInDynamicCP(playerid, RobberyData[id][robCheckpoint])) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}คุณไม่ได้อยู่ที่จุดแดงสำหรับการปล้น");
	new Float: x, Float: y, Float: z, Float: a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
				
	x += (1.25 * floatsin(-a, degrees));
	y += (1.25 * floatcos(-a, degrees));
	PlayerRobberyData[playerid][SafeObject] = CreateDynamicObject(2332, x, y, z-0.55, 0.0, 0.0, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

 	/*a += 90.0;
	x += (0.42 * floatsin(-a, degrees)) + (-0.22 * floatsin(-(a - 90.0), degrees));
	y += (0.42 * floatcos(-a, degrees)) + (-0.22 * floatcos(-(a - 90.0), degrees));
	PlayerRobberyData[playerid][SafeObject][1] = CreateDynamicObject(19619, x, y, z-0.55, 0.0, 0.0, a + 270.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));*/
				
	PlayerRobberyData[playerid][MoneyStolen] = 0;
	PlayerRobberyData[playerid][RobID] = id;
	PlayerRobberyData[playerid][RobTime] = RobberyData[id][robSafeTime];
	PlayerRobberyData[playerid][RobStage] = STAGE_CRACKING;
	//PlayerRobberyData[playerid][RobberyTimer] = SetTimerEx("Robbery", 1000, true, "ii", playerid, id);
	PlayerRobberyData[playerid][RobberyTimer] = repeat Robbery(playerid, id);
	RobberyData[id][robOccupiedBy] = playerid;
				
	SetPlayerAttachedObject(playerid, ATTACH_INDEX, 18634, 6, 0.054000, 0.013999, -0.087999, -94.399963, -25.899974, 175.799911);
	ApplyAnimation(playerid, "COP_AMBIENT", "COPBROWSE_LOOP", 4.0, 1, 0, 0, 0, 0);
				
	Mobile_GameTextForPlayer(playerid, sprintf("~b~~h~Robbery~n~~w~Cracking safe...~n~Complete in ~r~%s", ConvertToMinutes(RobberyData[id][robSafeTime])), 1200, 3);

	if(RobberyData[id][robRecordAmount] > 0)
	{
 		SendClientMessageEx(playerid, 0x3498DBFF, "[การโจรกรรม] {FFFFFF}มีบันทึกว่า {F1C40F}%s {FFFFFF}ขโมยเงินจากที่นี่ไปทั้งสิ้น {2ECC71}%s {FFFFFF} ดอลล่า", RobberyData[id][robRecordBy], FormatNumber(RobberyData[id][robRecordAmount]));
	}

	SetPlayerCriminalEx(playerid, "กล้องวงจรปิด", sprintf("พยายามปล้น %s", RobberyData[id][robName]));
				
	SendClientMessage(playerid, 0x3498DBFF, "[การโจรกรรม] {FFFFFF}คุณสามารถพิมพ์ {F1C40F}N{FFFFFF} เพื่อยกเลิกการปล้น");
	Streamer_Update(playerid);
	return 1;
}

hook OnPlayerText(playerid, text[]) {
	if (PlayerRobberyData[playerid][RobberyTimer] != Timer:0) {
		if (isequal(text, "N", true)) {
			Robbery_ResetPlayer(playerid, 1);
			return -1;
		}
	}
	return 0;
}

Dialog:DIALOG_ADD_ROBBERY_1(playerid, response, listitem, inputtext[])
{
	if(isnull(inputtext)) 
		return Dialog_Show(playerid, DIALOG_ADD_ROBBERY_1, DIALOG_STYLE_INPUT, "โจรกรรม: เพิ่ม (ขั้น 1)", "{E74C3C}ต้องไม่ป้อนค่าว่าง\n\n{FFFFFF}ป้อนชื่อการโจรกรรม:", "ถัดไป", "ปิด");
	
	SetPVarString(playerid, "robberyName", inputtext);
	Dialog_Show(playerid, DIALOG_ADD_ROBBERY_2, DIALOG_STYLE_INPUT, "โจรกรรม: เพิ่ม (ขั้น 2)", "ตั้งเวลาแงะตู้เซฟ (เป็นวินาที):", "ถัดไป", "กลับ");
	return 1;
}


Dialog:DIALOG_ADD_ROBBERY_2(playerid, response, listitem, inputtext[])
{
	if(!response) 
		return  Dialog_Show(playerid, DIALOG_ADD_ROBBERY_1, DIALOG_STYLE_INPUT, "โจรกรรม: เพิ่ม (ขั้น 1)", "{E74C3C}ต้องไม่ป้อนค่าว่าง\n\n{FFFFFF}ป้อนชื่อการโจรกรรม:", "ถัดไป", "ปิด");
	
	if(isnull(inputtext)) 
		return Dialog_Show(playerid, DIALOG_ADD_ROBBERY_2, DIALOG_STYLE_INPUT, "โจรกรรม: เพิ่ม (ขั้น 2)", "{E74C3C}ต้องไม่ป้อนค่าว่าง\n\n{FFFFFF}ตั้งเวลาแงะตู้เซฟ (เป็นวินาที):", "ถัดไป", "กลับ");
	
	SetPVarInt(playerid, "robberySafeDur", strval(inputtext));
	Dialog_Show(playerid, DIALOG_ADD_ROBBERY_3, DIALOG_STYLE_INPUT, "โจรกรรม: เพิ่ม (ขั้น 3)", "ระยะเวลาการปล้น (เป็นวินาที - ต้องเอาไปคูณด้วย 5):", "ถัดไป", "ปิด");
	return 1;
}



Dialog:DIALOG_ADD_ROBBERY_3(playerid, response, listitem, inputtext[])
{
	if(!response) 
		return Dialog_Show(playerid, DIALOG_ADD_ROBBERY_2, DIALOG_STYLE_INPUT, "โจรกรรม: เพิ่ม (ขั้น 2)", "ตั้งเวลาแงะตู้เซฟ (เป็นวินาที):", "ถัดไป", "กลับ");
	
	if(isnull(inputtext)) 
		return Dialog_Show(playerid, DIALOG_ADD_ROBBERY_3, DIALOG_STYLE_INPUT, "โจรกรรม: เพิ่ม (ขั้น 3)", "{E74C3C}ต้องไม่ป้อนค่าว่าง\n\n{FFFFFF}ระยะเวลาการปล้น (เป็นวินาที - ต้องเอาไปคูณด้วย 5):", "ถัดไป", "กลับ");
	
	new dur = strval(inputtext);
	if(dur < 1 || (dur % 5) != 0) return Dialog_Show(playerid, DIALOG_ADD_ROBBERY_3, DIALOG_STYLE_INPUT, "โจรกรรม: เพิ่ม (ขั้น 3)", "{E74C3C}ระยะเวลาไม่ถูกต้อง\n\n{FFFFFF}ระยะเวลาการปล้น (เป็นวินาที - ต้องเอาไปคูณด้วย 5):", "ถัดไป", "กลับ");
	SetPVarInt(playerid, "robberyDur", dur);
	Dialog_Show(playerid, DIALOG_ADD_ROBBERY_FINAL, DIALOG_STYLE_INPUT, "โจรกรรม: เพิ่ม (step 4)", "ป้อนจำนวนเงิน:", "เสร็จ", "กลับ");

	return 1;
}

Dialog:DIALOG_ADD_ROBBERY_FINAL(playerid, response, listitem, inputtext[])
{
	if(!response) 
		return Dialog_Show(playerid, DIALOG_ADD_ROBBERY_3, DIALOG_STYLE_INPUT, "{F1C40F}การโจรกรรม: {FFFFFF}เพิ่ม (ขั้น 3)", "ระยะเวลาการปล้น (เป็นวินาที - ต้องเอาไปคูณด้วย 5):", "ถัดไป", "กลับ");
	
	if(isnull(inputtext)) 
		return Dialog_Show(playerid, DIALOG_ADD_ROBBERY_FINAL, DIALOG_STYLE_INPUT, "{F1C40F}การโจรกรรม: {FFFFFF}เพิ่ม (ขั้น 4)", "{E74C3C}ต้องไม่ป้อนค่าว่าง\n\n{FFFFFF}ป้อนจำนวนเงิน:", "เสร็จ", "กลับ");
	
	if(strval(inputtext) < 1) 
		return Dialog_Show(playerid, DIALOG_ADD_ROBBERY_FINAL, DIALOG_STYLE_INPUT, "{F1C40F}การโจรกรรม: {FFFFFF}เพิ่ม (ขั้น 4)", "{E74C3C}Invalid amount.\n\n{FFFFFF}ป้อนจำนวนเงิน:", "เสร็จ", "กลับ");

	new id = Robbery_FindFreeID();
	if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}ไม่สามารถสร้างพื้นที่โจรกรรมได้มากกว่านี้แล้ว");
	new Float: x, Float: y, Float: z, vwid = GetPlayerVirtualWorld(playerid), intid = GetPlayerInterior(playerid), string[160];
	GetPlayerPos(playerid, x, y, z);

	GetPVarString(playerid, "robberyName", RobberyData[id][robName], 32);
	RobberyData[id][robPosX] = x;
	RobberyData[id][robPosY] = y;
	RobberyData[id][robPosZ] = z;
	RobberyData[id][robIntID] = intid;
	RobberyData[id][robVWID] = vwid;
	RobberyData[id][robAmount] = strval(inputtext);
	RobberyData[id][robReqTime] = GetPVarInt(playerid, "robberyDur");
	RobberyData[id][robSafeTime] = GetPVarInt(playerid, "robberySafeDur");
	RobberyData[id][robRecordAmount] = 0;
	RobberyData[id][robRecordBy][0] = EOS;
				
	RobberyData[id][robOccupiedBy] = -1;
	RobberyData[id][robCooldown] = 0;
	RobberyData[id][robTimer] = Timer:0;
				
	RobberyData[id][robCheckpoint] = CreateDynamicCP(x, y, z, 1.25, vwid, intid, .streamdistance = 5.0);

	format(string, sizeof(string), "โจรกรรม(%d)\n\n{FFFFFF}%s\n{2ECC71}%s - %s {FFFFFF}ทุก ๆ {F1C40F}5 {FFFFFF}วินาที\n{2ECC71}ปล้นได้", id, RobberyData[id][robName], FormatNumber(floatround(RobberyData[id][robAmount] / 4)), FormatNumber(RobberyData[id][robAmount]));
	RobberyData[id][robLabel] = CreateDynamic3DTextLabel(string, 0xF1C40FFF, x, y, z + 0.25, 10.0, _, _, 1, vwid, intid);
				
	RobberyData[id][robExists] = true;

	new str[256];
	mysql_format(dbCon, str, sizeof str, "INSERT INTO `robberies` (`ID`, `Name`, `PosX`, `PosY`, `PosZ`, `Interior`, `Virtual`, `Amount`, `RequiredTime`, `SafeTime`) VALUES (%d, '%e', %f, %f, %f, %d, %d, %d, %d, %d)", 
	id, RobberyData[id][robName], x, y, z, intid, vwid, RobberyData[id][robAmount], RobberyData[id][robReqTime], RobberyData[id][robSafeTime]);
	mysql_tquery(dbCon, str);	

	/*stmt_bind_value(AddRobbery, 0, DB::TYPE_INTEGER, id);
	stmt_bind_value(AddRobbery, 1, DB::TYPE_STRING, RobberyData[id][robName], 32);
	stmt_bind_value(AddRobbery, 2, DB::TYPE_FLOAT, x);
	stmt_bind_value(AddRobbery, 3, DB::TYPE_FLOAT, y);
	stmt_bind_value(AddRobbery, 4, DB::TYPE_FLOAT, z);
	stmt_bind_value(AddRobbery, 5, DB::TYPE_INTEGER, intid);
	stmt_bind_value(AddRobbery, 6, DB::TYPE_INTEGER, vwid);
	stmt_bind_value(AddRobbery, 7, DB::TYPE_INTEGER, RobberyData[id][robAmount]);
	stmt_bind_value(AddRobbery, 8, DB::TYPE_INTEGER, RobberyData[id][robReqTime]);
	stmt_bind_value(AddRobbery, 9, DB::TYPE_INTEGER, RobberyData[id][robSafeTime]);

	if(stmt_execute(AddRobbery)) SendClientMessage(playerid, 0x3498DBFF, "[การโจรกรรม] {FFFFFF}Robbery created.");*/
	return 1;
}


Dialog:DIALOG_REMOVE_ROBBERY(playerid, response, listitem, inputtext[])
{		
	if (response) {
		new id = strval(inputtext);
	
		if(!RobberyData[id][robExists]) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}ไม่พบการโจรกรรมที่ระบุ");
		foreach(new i : Player)
		{
			if(PlayerRobberyData[i][RobID] == id) 
				Robbery_ResetPlayer(i);
		}
					
		if(RobberyData[id][robTimer] != Timer:0) {
			stop RobberyData[id][robTimer];
		}
		DestroyDynamicCP(RobberyData[id][robCheckpoint]);
		DestroyDynamic3DTextLabel(RobberyData[id][robLabel]);
					
		RobberyData[id][robTimer] = Timer:0;
		RobberyData[id][robOccupiedBy] = RobberyData[id][robCheckpoint] = -1;
		RobberyData[id][robLabel] = Text3D: -1;
		RobberyData[id][robExists] = false;

		new str[128];
		mysql_format(dbCon, str, sizeof str, "DELETE FROM robberies WHERE ID = %d", id);
		mysql_tquery(dbCon, str);	
		/*stmt_bind_value(RemoveRobbery, 0, DB::TYPE_INTEGER, id);
		if(stmt_execute(RemoveRobbery)) SendClientMessage(playerid, 0x3498DBFF, "[การโจรกรรม] {FFFFFF}การโจรกรรมถูกลบ");*/
	}
	return 1;
}

stock SetPlayerCriminal(playerid, declare, const reason[])
{
	if(IsPlayerConnected(playerid))
	{
	    new points = ++playerData[playerid][pWarrants];
		new turner[MAX_PLAYER_NAME];
		new string[144];

		if(declare == INVALID_PLAYER_ID) format(turner, sizeof(turner), "ไม่ทราบ");
		else
		{
		    if(IsPlayerConnected(declare))
		    {
				GetPlayerName(declare, turner, sizeof(turner));
			}
		}
		format(string, sizeof(string), "คุณได้พยายามก่ออาชญากรรม ( %s ) ผู้รายงาน: %s",reason, turner);
		SendClientMessage(playerid, COLOR_LIGHTRED, string);
		SetPlayerWantedLevel(playerid, points);

		PlayerPlaySound(playerid,1054,0.0,0.0,0.0);

		format(string, sizeof(string), "ระดับความต้องการตัว: %d", points);
		SendClientMessage(playerid, COLOR_YELLOW, string);

		SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_LIGHTBLUE, "Warrant Placed - ผู้รายงาน: %s",turner);
		SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_LIGHTBLUE, "ความผิด: %s, ผู้ต้องหา: %s",reason,ReturnRealName(playerid));

		
	}
}

SetPlayerCriminalEx(playerid, const turner[], const reason[])
{
	if(IsPlayerConnected(playerid))
	{
	    new points = ++playerData[playerid][pWarrants];
		new string[144];

		format(string, sizeof(string), "คุณได้พยายามก่ออาชญากรรม ( %s ) ผู้รายงาน: %s",reason, turner);
		SendClientMessage(playerid, COLOR_LIGHTRED, string);
		SetPlayerWantedLevel(playerid, points);

		PlayerPlaySound(playerid,1054,0.0,0.0,0.0);

		format(string, sizeof(string), "ระดับความต้องการตัว: %d", points);
		SendClientMessage(playerid, COLOR_YELLOW, string);

		SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_LIGHTBLUE, "Warrant Placed - ผู้รายงาน: %s",turner);
		SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_LIGHTBLUE, "ความผิด: %s, ผู้ต้องหา: %s",reason,ReturnRealName(playerid));
	}
}

ClearCrime(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		RemoveOtherMarkers(playerid);
	}
	return 1;
}

ptask WantedTimer[1000](playerid) 
{
    if(playerData[playerid][pWarrants] && BitFlag_Get(gPlayerBitFlag[playerid], IS_LOGGED)) {
		
		new factionType, bool:ispolice;
        foreach(new i : Player)
        {
			factionType = Faction_GetTypeID(playerData[i][pFaction]);
            if (i != playerid && factionType == FACTION_TYPE_POLICE && BitFlag_Get(gPlayerBitFlag[i], IS_LOGGED) && playerData[playerid][pVWorld] == playerData[i][pVWorld] && playerData[playerid][pInterior] == playerData[i][pInterior]) {
				SetPlayerMarkerForPlayer(i, playerid, RGBAToHex(255, 0, 0, 0xFF)); // Fix Radar
				ispolice = true;
            }
        }

		if (playerData[playerid][pWarrants] >= 7) {
			playerData[playerid][pWarrants] = 0;
			SetPlayerWantedLevel(playerid, 0);
			ClearCrime(playerid);

			playerData[playerid][pCPCannabis] = 0;
			playerData[playerid][pCannabis] = 0;

			OnAccountUpdate(playerid);

			SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, "AdminWarning: %s ถูกต้องสงสัยว่าบัคดาว (/resetwanted) เพื่อช่วยเหลือ", ReturnPlayerName(playerid));
		}

		if (playerData[playerid][pWarrants] && PlayerRobberyData[playerid][RobberyTimer] == Timer:0) {
			if (ispolice) {
				gPlayerEscapeTime[playerid]++;
				if (gPlayerEscapeTime[playerid] >= (900 * playerData[playerid][pWarrants])) {

					playerData[playerid][pWarrants]--;

					if (playerData[playerid][pWarrants] <= 0) {
						playerData[playerid][pWarrants] = 0;
						SetPlayerWantedLevel(playerid, 0);
						ClearCrime(playerid);
						Mobile_GameTextForPlayer(playerid, "You're safe, maybe", 1100, 3);
					}
				}
				else {
					Mobile_GameTextForPlayer(playerid, sprintf("Escape time: %s", ConvertToMinutes((900 * playerData[playerid][pWarrants]) - gPlayerEscapeTime[playerid])), 1100, 3);
				}
			}
			else {
				Mobile_GameTextForPlayer(playerid, "Escape time: TIME STOP", 1100, 3);
			}
		}
    }
}