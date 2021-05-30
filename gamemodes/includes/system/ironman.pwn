new bool:flying[MAX_PLAYERS];
forward IronMan(playerid);
forward DestroyMe(objectid);
forward Float:SetPlayerToFacePos(playerid, Float:X, Float:Y);

CMD:ironman(playerid, params[])
	{
	    if (playerData[playerid][pAdmin] >= 1)
	    {
			if(playerData[playerid][pAdmin] >= 1) // PAdmin แต่ละสคริปไม่เหมือนกัน ไปเช็คดูก่อน !
			{
				if((flying[playerid] = !flying[playerid]))
				{
				    new Float:x, Float:y, Float:z;
				    GetPlayerPos(playerid, x, y, z);
				    SetPlayerHealth(playerid, 1000000000.0);
				    SetTimerEx("IronMan", 100, 0, "d", playerid);
				    SetTimerEx("DestroyMe", 500, 0, "d",     CreateDynamicObject(2780, x, y, z - 3.0, 0.0, 0.0, 0.0));
				}
				else
                 SetPlayerHealth(playerid, 100.0);
				return 1;
			}
			else
	        {
	            SendClientMessage(playerid, COLOR_GREY, " คุณไม่สามารถใช้คำสั่งนี้ได้ !");
	            return 1;
	        }
		}
		return 1;
	}
	
	public IronMan(playerid)
{
	if(!IsPlayerConnected(playerid))
		return flying[playerid] = false;

	if(flying[playerid])
	{
	    if(!IsPlayerInAnyVehicle(playerid))
	    {
			new
			    i,
			    keys,
				ud,
				lr,
				Float:x[2],
				Float:y[2],
				Float:z,
				Float:a;

			GetPlayerKeys(playerid, keys, ud, lr);
			GetPlayerVelocity(playerid, x[0], y[0], z);

			if(!GetPlayerWeapon(playerid))
			{
				if((keys & KEY_FIRE) == (KEY_FIRE))
				{
				    i = 0;
				    while(i < MAX_PLAYERS)
				    {
				        if(i != playerid)
				        {
						    GetPlayerPos(i, x[0], y[0], z);
						    if(IsPlayerInRangeOfPoint(playerid, 3.0, x[0], y[0], z))
					        	if(IsPlayerFacingPlayer(playerid, i, 15.0))
					        	    SetPlayerVelocity(i, floatsin(-a, degrees), floatcos(-a, degrees), 0.05);
				        }
						++i;
				    }
				}

	   		}

			if(ud == KEY_UP)
			{
				GetPlayerCameraPos(playerid, x[0], y[0], z);
				GetPlayerCameraFrontVector(playerid, x[1], y[1], z);

				a = SetPlayerToFacePos(playerid, x[0] + x[1], y[0] + y[1]);

		    	ApplyAnimation(playerid, "PARACHUTE", "FALL_SkyDive_Accel", 4.1, 0, 0, 0, 0, 0);
				SetPlayerVelocity(playerid, x[1], y[1], z);
			}
			else
				SetPlayerVelocity(playerid, 0.0, 0.0, 0.01);
		}

		SetTimerEx("IronMan", 100, 0, "d", playerid);
	}

	return 0;
}

public Float:SetPlayerToFacePos(playerid, Float:X, Float:Y)
{
	new
		Float:pX,
		Float:pY,
		Float:pZ,
		Float:ang;

	if(!IsPlayerConnected(playerid)) return 0.0;

	GetPlayerPos(playerid, pX, pY, pZ);

	if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
	else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);

	if(X > pX) ang = (floatabs(floatabs(ang) + 180.0));
	else ang = (floatabs(ang) - 180.0);

	ang += 180.0;

	SetPlayerFacingAngle(playerid, ang);

 	return ang;
}

public DestroyMe(objectid)
{
	return DestroyDynamicObject(objectid);
}

stock IsPlayerFacingPlayer(playerid, targetid, Float:dOffset)
{
	new
		Float:pX,
		Float:pY,
		Float:pZ,
		Float:pA,
		Float:X,
		Float:Y,
		Float:Z,
		Float:ang;

	if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;

	GetPlayerPos(targetid, pX, pY, pZ);
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, pA);

	if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
	else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);

	return AngleInRangeOfAngle(-ang, pA, dOffset);
}
stock AngleInRangeOfAngle(Float:a1, Float:a2, Float:range)
{
	a1 -= a2;
	if((a1 < range) && (a1 > -range)) return true;

	return false;
}

