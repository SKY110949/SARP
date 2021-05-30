
CMD:gotop(playerid, params[])
{
	new spots;

	if (playerData[playerid][pAdmin] >= 1)
	if(sscanf(params, "n", spots))
 	{
	 	SendClientMessage(playerid, COLOR_GREY, 	"การใช้{FFFFFF} /gotop [number of location]");
	 	SendClientMessage(playerid, COLOR_GREY, "|1. Los Santos |2. Las Venturas |3. San Fierro |4. Market Ammunation |5. Market DMV |6. LSLV Highway |7. Montgomery");
	 	SendClientMessage(playerid, COLOR_GREY, "|8. Palomino |9. Dillimore |10. Fort Carson |11. Breach Center |12. Idlewood |13. El Corona |14. Idlegas |15. Ganton");
	 	SendClientMessage(playerid, COLOR_GREY, "|16. Grove Circle |17. Willowfield |18. Seville |19. Los Flores |20. East Los |21. Jefferson |22. Glen Park");
	 	SendClientMessage(playerid, COLOR_GREY, "|23. Downtown |24. Market |25. LS Runway |26. LV Runway |27. SF Runway |28. Mall |29. Trucker Trailers");
	}
	else
	{
	    switch(spots)
	    { //SetPlayerPos
	        case 1:
	        {
	            SetPlayerPos(playerid, 1514.1836, -1677.8027, 14.0469);
            	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยังจุดที่ต้องการ `!");
			}
			case 2:
			{
			    SetPlayerPos(playerid, 1721.1599, 1444.5464, 10.5450);
	           	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 3:
			{
	            SetPlayerPos(playerid, -1751.6312, -607.6387, 16.2367);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 4:
			{
	            SetPlayerPos(playerid, 1364.0856, -1276.8530, 13.5469);
            	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 5:
			{
	            SetPlayerPos(playerid, 1286.8722, -1540.2163, 13.4944);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 6:
			{
	           // SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, 1622.8391,158.6248,34.8305);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 7:
			{
	           // SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, 1348.9205,231.8964,19.2818);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 8:
			{
	         //   SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, 2284.1912, 26.9898, 26.2115);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 9:
			{
	           // SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, 656.5389, -586.2031, 16.0592);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 10:
			{
	           // SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, -58.4578,1168.8517,19.3818);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 11:
			{
	           // SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
           		SetPlayerPos(playerid, 2776.4807, 2416.5981, 11.0702);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 12:
			{
	           // SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, 2098.6453,-1760.2810,13.5625);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 13:
			{
	           // SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, 1882.9041,-2016.5022, 13.5469);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 14:
			{
	          //  SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, 1949.9351, -1769.6365, 13.5469);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 15:
			{
	          //  SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, 2225.5811, -1742.8641, 13.5634);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 16:
			{
	         //   SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, 2499.9521,-1686.2581,13.4776);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 17:
			{
	           // SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
             	SetPlayerPos(playerid, 2489.4878,-1941.6466,12.9567);
              	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 18:
			{
	        //    SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, 2767.3303, -1944.2482, 12.8437);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 19:
			{
	           // SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
             	SetPlayerPos(playerid, 2628.9937, -1250.3225, 49.2440);
              	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 20:
			{
	           // SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, 2363.8564, -1290.3566, 23.4254);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 21:
			{
	          //  SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, 2188.8093,-1294.6794,23.4828);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 22:
			{
	        //    SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, 2002.3489,-1277.4027,23.3324);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 23:
			{
	          //  SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, 1567.7167, -1311.5303, 16.7319);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 24:
			{
	         //   SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, 1102.7339, -1387.4949, 13.2131);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 25:
			{
	          //  SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, 1974.6187, -2459.8467, 13.5469);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 26:
			{
	          //  SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, 1512.8564, 1487.1121, 10.8273);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 27:
			{
	           // SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
	            SetPlayerPos(playerid, -1453.3241, -46.0731, 14.5469);
             	SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 28:
			{
				//SendClientMessage(playerid, COLOR_GREY, "You have been teleported");
				SetPlayerPos(playerid, 1121.2642, -1412.9189, 13.5747);
    			SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
			case 29:
			{
				SetPlayerPos(playerid, 104.6114, -272.4609, 1.5781);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);

				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;

				SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เคลื่อนย้ายไปยัง จุดที่ต้องการ!");
			}
		}
	}
	return 1;
}

