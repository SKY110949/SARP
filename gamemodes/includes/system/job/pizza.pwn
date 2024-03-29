
#include <YSI\y_hooks>

#define CHECKPOINTS            24 // Total Houses
#define PAY_PER_CHECKPOINT     10 // 10$ per delivered pizza
#define MAX_TIP                20 // Maximum Random Tip + 10$
#define CHECKPOINT_NONE        0 // No Checkpoint
#define PIZZA_CHECKPOINT       1 // Pizza Checkpoint
#define PIZZA_INDEX            9 // Pizza Index for SetPlayerAttachedObject

// Server Pickups & 3D Texts
//new jobpickup;
new restockpickup;
new Text3D:jobtext;
new Text3D:restocktext;

// Server Vehicles
new pizzabikes[5];
new PizzaBikesPizzas[MAX_VEHICLES];

// Player Variables
new IsInJob[MAX_PLAYERS];
new TipTime[MAX_PLAYERS];
new PlayerTutorialTime[MAX_PLAYERS];
new InfoTimer[MAX_PLAYERS];
new PlayerCustomer[MAX_PLAYERS];
new PlayerCheckpoint[MAX_PLAYERS];
new PlayerTips[MAX_PLAYERS];
new PlayerEarnings[MAX_PLAYERS];
new PlayerSkin[MAX_PLAYERS];

// Textdraws
new PlayerText:Textdraw0[MAX_PLAYERS];
new PlayerText:Textdraw1[MAX_PLAYERS];
new PlayerText:Textdraw2[MAX_PLAYERS];
new PlayerText:PizzasText[MAX_PLAYERS];
new PlayerText:PizzaSymbol[MAX_PLAYERS];
new PlayerText:TipsText[MAX_PLAYERS];
new PlayerText:EarningsText[MAX_PLAYERS];
new PlayerText:TotalEarningsText[MAX_PLAYERS];
new PlayerText:TipTimeText[MAX_PLAYERS];

// Timers
new TutorialTimer;

// Checkpoints for each house
new Float:Houses[CHECKPOINTS][4] = {
{2065.9780,-1703.4775,14.1484,90.8956},
{2068.2600,-1656.4601,13.5469,86.9378},
{2068.8579,-1643.8237,13.5469,90.3844},
{2068.7437,-1628.9187,13.8762,90.3844},
{2065.0508,-1583.8545,13.4814,92.2467},
{2003.0380,-1595.1025,13.5759,39.7419},
{2016.8215,-1629.8384,13.5469,270.7754},
{2015.4512,-1641.6316,13.7824,272.6556},
{2012.0426,-1656.4589,13.5547,268.4961},
{2017.1294,-1703.3452,14.2043,272.0217},
{2014.4487,-1732.6185,14.2353,271.6387},
{2139.1643,-1698.1489,15.0784,4.0066},
{2166.9363,-1672.0193,15.0749,46.6203},
{2244.2312,-1638.2906,15.9074,340.8198},
{2257.1416,-1644.8845,15.5164,353.3532},
{2282.2446,-1641.7231,15.8898,357.1133},
{2307.0203,-1678.1877,14.0012,180.0783},
{2328.2483,-1681.9125,14.8624,90.7775},
{2362.8362,-1644.1184,13.5332,0.849},
{2368.3418,-1674.5013,13.9063,179.1149},
{2393.2185,-1646.7593,13.6432,1.7900},
{2409.0159,-1673.8960,13.6045,180.0550},
{2413.9771,-1647.1270,14.0119,2.4167},
{2452.0852,-1642.3127,13.7357,1.4767}
};

// Forwards
forward ShowPlayerIntroTexts(playerid);
forward HidePlayerIntroTexts(playerid);
forward ShowPlayerInfoTexts(playerid);
forward HidePlayerInfoTexts(playerid);
forward TutorialTime();
forward ShowPlayerPizzaBikeTexts(playerid);
forward HidePlayerPizzaBikeTexts(playerid);
forward ShowTipTimeText(playerid);
forward HideTipTimeText(playerid);


hook OnGameModeInit()
{
	print("\n--------------------------------------");
	print(" Pizzaboy Part-Time Job by Lucky13 Loaded!");
	print("--------------------------------------\n");

	//jobpickup = CreatePickup(1239,1,2104.2502,-1806.3750,13.5547,0);
	restockpickup = CreatePickup(1239,1,2116.4973,-1788.3663,13.1152,0);

	pizzabikes[0] = CreateVehicle(448,2093.9578,-1812.5789,12.9786,89.6835,3,6,60000,0); // Pizzaboy
	pizzabikes[1] = CreateVehicle(448,2093.9387,-1814.8420,12.9820,91.6584,3,6,60000,0); // Pizzaboy
	pizzabikes[2] = CreateVehicle(448,2094.1182,-1816.9015,12.9825,89.0844,3,6,60000,0); // Pizzaboy
	pizzabikes[3] = CreateVehicle(448,2094.1975,-1819.0215,12.9821,88.4043,3,6,60000,0); // Pizzaboy
	pizzabikes[4] = CreateVehicle(448,2094.0500,-1821.4058,12.9817,90.0841,3,6,60000,0); // Pizzaboy

    for(new i = 0; i!=sizeof(pizzabikes); i ++) {
        Vehicle_ResetVehicle(pizzabikes[i]);
    }

	PizzaBikesPizzas[pizzabikes[0]]=5;
	PizzaBikesPizzas[pizzabikes[1]]=5;
	PizzaBikesPizzas[pizzabikes[2]]=5;
	PizzaBikesPizzas[pizzabikes[3]]=5;
	PizzaBikesPizzas[pizzabikes[4]]=5;
	
	jobtext = Create3DTextLabel("{FF0000}Pizzaboy Job\n{FFFFFF}�� {7FFF00}/startjob{FFFFFF} ����������ҹ!",0x008080FF,2104.2502,-1806.3750,13.5547,30.0,0,1);
	restocktext = Create3DTextLabel("{FF0000}Restocking Point\n{FFFFFF}�� {7FFF00}/restock{FFFFFF} �����Ѻ���ͧ�ԫ��������䫵�!",0x008080FF,2116.4973,-1788.3663,13.1152,30.0,0,1);
	
	TutorialTimer =	SetTimer("TutorialTime", 1000,true);
	
	DisableInteriorEnterExits();
	return 1;
}

hook OnGameModeExit()
{
    print("\n--------------------------------------");
	print(" Pizzaboy Part-Time Job by Lucky13 Unloaded!");
	print("--------------------------------------\n");
	
	Delete3DTextLabel(jobtext);
	Delete3DTextLabel(restocktext);
	//DestroyPickup(jobpickup);
	DestroyPickup(restockpickup);
	DestroyVehicle(pizzabikes[0]);
	DestroyVehicle(pizzabikes[1]);
	DestroyVehicle(pizzabikes[2]);
	DestroyVehicle(pizzabikes[3]);
	DestroyVehicle(pizzabikes[4]);
	KillTimer(TutorialTimer);
	return 1;
}

hook OnPlayerConnect(playerid)
{
	IsInJob[playerid]=0;TipTime[playerid]=0;
    KillTimer(InfoTimer[playerid]);
	PlayerTutorialTime[playerid]=0;
	PlayerCheckpoint[playerid]=CHECKPOINT_NONE;
	PlayerTips[playerid]=0;
	PlayerEarnings[playerid]=0;
	PlayerSkin[playerid]=0;
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    IsInJob[playerid]=0;TipTime[playerid]=0;
    KillTimer(InfoTimer[playerid]);
	PlayerTutorialTime[playerid]=0;
	PlayerCheckpoint[playerid]=CHECKPOINT_NONE;
	PlayerTips[playerid]=0;
	PlayerEarnings[playerid]=0;
    if(IsValidActor(PlayerCustomer[playerid])) { DestroyActor(PlayerCustomer[playerid]); }
    PlayerSkin[playerid]=0;
	HidePlayerIntroTexts(playerid);
	HidePlayerInfoTexts(playerid);
	HidePlayerPizzaBikeTexts(playerid);
	HideTipTimeText(playerid);
	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	if(IsInJob[playerid] == 1)
	{
	    IsInJob[playerid]=0;TipTime[playerid]=0;
	    KillTimer(InfoTimer[playerid]);
		PlayerTutorialTime[playerid]=0;
		PlayerCheckpoint[playerid]=CHECKPOINT_NONE;
		PlayerTips[playerid]=0;
		PlayerEarnings[playerid]=0;
	    if(IsValidActor(PlayerCustomer[playerid])) { DestroyActor(PlayerCustomer[playerid]); }
	    PlayerSkin[playerid]=0;
		HidePlayerIntroTexts(playerid);
		HidePlayerInfoTexts(playerid);
		HidePlayerPizzaBikeTexts(playerid);
		HideTipTimeText(playerid);
		SendClientMessage(playerid,-1," �س�����Чҹ part-time �١¡��ԡ!");
	}
	return 1;
}

CMD:pizzahelp(playerid, params[])
{
	SendClientMessage(playerid,-1," ����觾ԫ���: /startjob, /endjob, /restock, /getpizza, /putbackpizza");
	return 1;
}

CMD:restock(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid,3.0,2116.4973,-1788.3663,13.1152))
	{
	    if(IsInJob[playerid] == 1)
	    {
	        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
	            if(PizzaBikesPizzas[GetPlayerVehicleID(playerid)] == 0)
	            {
	                new string[56];
	                PizzaBikesPizzas[GetPlayerVehicleID(playerid)]=5;
	                SendClientMessage(playerid,-1," �س�Ӿԫ������ö��䫵� {FF0000}5 {FFFFFF}���ͧ!");

    				PlayerTextDrawHide(playerid,PizzasText[playerid]);
    				format(string,sizeof(string),"Pizzas: ~r~%d~w~ /~g~ 5",PizzaBikesPizzas[GetPlayerVehicleID(playerid)]);
    				PlayerTextDrawSetString(playerid,PizzasText[playerid],string);
    				PlayerTextDrawShow(playerid,PizzasText[playerid]);
	            }
	            else return SendClientMessage(playerid,-1," ��䫵�ͧ�س�ѧ�վԫ������������!");
	        }
	        else return SendClientMessage(playerid,-1," �س��ͧ���躹��䫵��觾ԫ���!");
	    }
	    else return SendClientMessage(playerid,-1," �س��ͧ������ҹ part-time ��͹�����觹��!");
	}
	else return SendClientMessage(playerid,-1," �س��ͧ������ Well Stacked Pizza Co. 㹡�÷��������觹��!");
	return 1;
}

CMD:putbackpizza(playerid, params[])
{
	if(IsInJob[playerid] == 1)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid,PIZZA_INDEX))
	    {
	        if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	        {
			    new Float:X,Float:Y,Float:Z;
			    for(new j=0;j<5;j++)
			    {
					GetVehiclePos(pizzabikes[j],X,Y,Z);
					if(IsPlayerInRangeOfPoint(playerid,3.0,X,Y,Z))
					{
					    if(PizzaBikesPizzas[pizzabikes[j]] < 5)
					    {
					    	PizzaBikesPizzas[pizzabikes[j]]++;
					    	ClearAnimations(playerid);
							RemovePlayerAttachedObject(playerid, PIZZA_INDEX);
							SendClientMessage(playerid,-1," �ԫ��Ҷ١���������䫵�!");
							ApplyAnimation(playerid, "INT_HOUSE", "wash_up",4.1,0,0,0,0,0,1);
					    	return 1;
						}
						else
						{
						    SendClientMessage(playerid,-1," ��䫵�ѹ����վԫ��Ҥú 5 ���ͧ����!");
						    return 1;
						}
					}
				}
			}
			else return SendClientMessage(playerid,-1," �س��ͧ�׹���躹���㹢�з��������!");
		}
		else return SendClientMessage(playerid,-1," �س������͡��ͧ�ԫ�������!");
	}
	return 1;
}

CMD:getpizza(playerid, params[])
{
	if(IsInJob[playerid] == 1)
	{
	    if(!IsPlayerAttachedObjectSlotUsed(playerid,PIZZA_INDEX))
	    {
	        if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	        {
			    new Float:X,Float:Y,Float:Z;
			    for(new j=0;j<5;j++)
			    {
					GetVehiclePos(pizzabikes[j],X,Y,Z);
					if(IsPlayerInRangeOfPoint(playerid,3.0,X,Y,Z))
					{
					    if(PizzaBikesPizzas[pizzabikes[j]] >= 1)
					    {
					    	PizzaBikesPizzas[pizzabikes[j]]--;
					    	ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,1,1,1,1,1,1);
							SetPlayerAttachedObject( playerid, PIZZA_INDEX, 1582, 1, 0.002953, 0.469660, -0.009797, 269.851104, 88.443557, 0.000000, 0.804894, 1.000000, 0.822361 );
					    	return 1;
						}
						else
						{
						    SendClientMessage(playerid,-1," ��䫵�ѹ����������͡��ͧ�ԫ�������!");
						    return 1;
						}
					}
				}
			}
			else return SendClientMessage(playerid,-1," �س��ͧ�׹���躹���㹢�з��������!");
		}
		else return SendClientMessage(playerid,-1," �س���ѧ��͡��ͧ�ԫ�������!");
	}
	return 1;
}

CMD:endjob(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid,3.0,2104.2502,-1806.3750,13.5547))
	{
	    if(IsInJob[playerid] == 1)
	    {
	        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
		        new string[128];
		        GivePlayerMoneyEx(playerid,PlayerEarnings[playerid]+PlayerTips[playerid]);
				format(string,sizeof(string)," �س���Ѻ {7FFF00}%d$ {FFFFFF}����Ѻ�ҹ part-time ���觾ԫ���!",PlayerEarnings[playerid]+PlayerTips[playerid]);
				SendClientMessage(playerid,-1,string);
				PlayerEarnings[playerid]=0;
				PlayerTips[playerid]=0;
				if(IsPlayerAttachedObjectSlotUsed(playerid,PIZZA_INDEX)) { RemovePlayerAttachedObject(playerid,PIZZA_INDEX); }
				PlayerCheckpoint[playerid]=CHECKPOINT_NONE;
				DisablePlayerCheckpoint(playerid);
				IsInJob[playerid]=0;
				PlayerTutorialTime[playerid]=0;
				if(IsValidActor(PlayerCustomer[playerid])) { DestroyActor(PlayerCustomer[playerid]); }
				TipTime[playerid]=0;
		        HidePlayerIntroTexts(playerid);
				HidePlayerInfoTexts(playerid);
				HidePlayerPizzaBikeTexts(playerid);
				HideTipTimeText(playerid);
				PizzaBikesPizzas[GetPlayerVehicleID(playerid)]=5;
		        SetVehicleToRespawn(GetPlayerVehicleID(playerid));
		        RemovePlayerFromVehicle(playerid);
		        SetPlayerSkin(playerid,PlayerSkin[playerid]);
		        PlayerSkin[playerid]=0;
			}
			else return SendClientMessage(playerid,-1," �س��ͧ���躹��䫵��觾ԫ���������ԡ�ҹ���!");
	    }
	    else return SendClientMessage(playerid,-1," �س��ͧ������ӧҹ�觾ԫ��ҡ�͹����ԡ�ҹ!");
	}
	else return SendClientMessage(playerid,-1," �س��ͧ����˹�� Well Stacked Pizza Co. ������ԡ�ҹ!");
	return 1;
}

CMD:startjob(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid,3.0,2104.2502,-1806.3750,13.5547))
	{
	    if(IsInJob[playerid] == 0)
	    {
			SetPlayerCameraPos(playerid,2088.402343, -1790.125854, 16.726133);
			SetPlayerCameraLookAt(playerid,2102.1492,-1806.3496,18.1543);
			ShowPlayerIntroTexts(playerid);
			PlayerTutorialTime[playerid]=30;
			IsInJob[playerid]=1;
			PlayerSkin[playerid]=GetPlayerSkin(playerid);
			SetPlayerSkin(playerid,155);
			TogglePlayerControllable(playerid,0);
	    }
	    else return SendClientMessage(playerid,-1," �س��ӧҹ part-time �����觾ԫ���!");
	}
	else return SendClientMessage(playerid,-1," �س��ͧ����˹�� Well Stacked Pizza Co. ����������ҹ!");
	return 1;
}

public ShowPlayerIntroTexts(playerid)
{
    Textdraw0[playerid] = CreatePlayerTextDraw(playerid,660.000000, 0.000000, "~n~");
  	PlayerTextDrawBackgroundColor(playerid,Textdraw0[playerid], 255);
  	PlayerTextDrawFont(playerid,Textdraw0[playerid], 1);
  	PlayerTextDrawLetterSize(playerid,Textdraw0[playerid], 0.500000, 14.000000);
  	PlayerTextDrawColor(playerid,Textdraw0[playerid], -1);
  	PlayerTextDrawSetOutline(playerid,Textdraw0[playerid], 0);
  	PlayerTextDrawSetProportional(playerid,Textdraw0[playerid], 1);
 	PlayerTextDrawSetShadow(playerid,Textdraw0[playerid], 1);
  	PlayerTextDrawUseBox(playerid,Textdraw0[playerid], 1);
  	PlayerTextDrawBoxColor(playerid,Textdraw0[playerid], 255);
  	PlayerTextDrawTextSize(playerid,Textdraw0[playerid], -20.000000, 0.000000);
  	PlayerTextDrawSetSelectable(playerid,Textdraw0[playerid], 0);

  	Textdraw1[playerid] = CreatePlayerTextDraw(playerid,660.000000, 320.000000, "~n~");
  	PlayerTextDrawBackgroundColor(playerid,Textdraw1[playerid], 255);
  	PlayerTextDrawFont(playerid,Textdraw1[playerid], 1);
  	PlayerTextDrawLetterSize(playerid,Textdraw1[playerid], 0.500000, 19.000000);
  	PlayerTextDrawColor(playerid,Textdraw1[playerid], -1);
  	PlayerTextDrawSetOutline(playerid,Textdraw1[playerid], 0);
  	PlayerTextDrawSetProportional(playerid,Textdraw1[playerid], 1);
  	PlayerTextDrawSetShadow(playerid,Textdraw1[playerid], 1);
  	PlayerTextDrawUseBox(playerid,Textdraw1[playerid], 1);
  	PlayerTextDrawBoxColor(playerid,Textdraw1[playerid], 255);
  	PlayerTextDrawTextSize(playerid,Textdraw1[playerid], -20.000000, 0.000000);
  	PlayerTextDrawSetSelectable(playerid,Textdraw1[playerid], 0);

  	Textdraw2[playerid] = CreatePlayerTextDraw(playerid,40.000000, 350.000000, "This is the Well Stacked Pizza Co. They are hiring part-time people~n~who want to earn a few bucks in their free time.");
  	PlayerTextDrawBackgroundColor(playerid,Textdraw2[playerid], 255);
  	PlayerTextDrawFont(playerid,Textdraw2[playerid], 1);
  	PlayerTextDrawLetterSize(playerid,Textdraw2[playerid], 0.500000, 1.000000);
  	PlayerTextDrawColor(playerid,Textdraw2[playerid], -1);
  	PlayerTextDrawSetOutline(playerid,Textdraw2[playerid], 1);
  	PlayerTextDrawSetProportional(playerid,Textdraw2[playerid], 1);
  	PlayerTextDrawSetSelectable(playerid,Textdraw2[playerid], 0);
  	
  	PlayerTextDrawShow(playerid,Textdraw0[playerid]);
  	PlayerTextDrawShow(playerid,Textdraw1[playerid]);
  	PlayerTextDrawShow(playerid,Textdraw2[playerid]);
  	return 1;
}

public HidePlayerIntroTexts(playerid)
{
	PlayerTextDrawHide(playerid,Textdraw0[playerid]);
  	PlayerTextDrawHide(playerid,Textdraw1[playerid]);
  	PlayerTextDrawHide(playerid,Textdraw2[playerid]);
  	
  	PlayerTextDrawDestroy(playerid,Textdraw0[playerid]);
  	PlayerTextDrawDestroy(playerid,Textdraw1[playerid]);
  	PlayerTextDrawDestroy(playerid,Textdraw2[playerid]);
  	return 1;
}

public ShowPlayerInfoTexts(playerid)
{
    Textdraw0[playerid] = CreatePlayerTextDraw(playerid,150.000000, 350.000000, "Hop in one of the free bikes to start your job!");
  	PlayerTextDrawBackgroundColor(playerid,Textdraw0[playerid], 255);
  	PlayerTextDrawFont(playerid,Textdraw0[playerid], 1);
  	PlayerTextDrawLetterSize(playerid,Textdraw0[playerid], 0.400000, 1.000000);
  	PlayerTextDrawColor(playerid,Textdraw0[playerid], -1);
  	PlayerTextDrawSetOutline(playerid,Textdraw0[playerid], 1);
  	PlayerTextDrawSetProportional(playerid,Textdraw0[playerid], 1);
  	PlayerTextDrawSetSelectable(playerid,Textdraw0[playerid], 0);
  	
  	PlayerTextDrawShow(playerid,Textdraw0[playerid]);
	return 1;
}

public HidePlayerInfoTexts(playerid)
{
	if(IsPlayerConnected(playerid))
	{
    	PlayerTextDrawHide(playerid,Textdraw0[playerid]);
    	PlayerTextDrawDestroy(playerid,Textdraw0[playerid]);
    	KillTimer(InfoTimer[playerid]);
	}
	return 1;
}

public ShowPlayerPizzaBikeTexts(playerid)
{
	new string[56];
	format(string,sizeof(string),"Pizzas: ~r~%d~w~ /~g~ 5",PizzaBikesPizzas[GetPlayerVehicleID(playerid)]);
    PizzasText[playerid] = CreatePlayerTextDraw(playerid,510.000000, 170.000000, string);
  	PlayerTextDrawBackgroundColor(playerid,PizzasText[playerid], 255);
  	PlayerTextDrawFont(playerid,PizzasText[playerid], 1);
  	PlayerTextDrawLetterSize(playerid,PizzasText[playerid], 0.300000, 1.000000);
  	PlayerTextDrawColor(playerid,PizzasText[playerid], -1);
  	PlayerTextDrawSetOutline(playerid,PizzasText[playerid], 1);
  	PlayerTextDrawSetProportional(playerid,PizzasText[playerid], 1);
  	PlayerTextDrawSetSelectable(playerid,PizzasText[playerid], 0);

  	PizzaSymbol[playerid] = CreatePlayerTextDraw(playerid,477.000000, 156.000000, "Pizzaboy");
  	PlayerTextDrawBackgroundColor(playerid,PizzaSymbol[playerid], 0);
  	PlayerTextDrawFont(playerid,PizzaSymbol[playerid], 5);
  	PlayerTextDrawLetterSize(playerid,PizzaSymbol[playerid], 0.500000, 1.000000);
  	PlayerTextDrawColor(playerid,PizzaSymbol[playerid], -1);
  	PlayerTextDrawSetOutline(playerid,PizzaSymbol[playerid], 0);
  	PlayerTextDrawSetProportional(playerid,PizzaSymbol[playerid], 1);
 	PlayerTextDrawSetShadow(playerid,PizzaSymbol[playerid], 1);
 	PlayerTextDrawUseBox(playerid,PizzaSymbol[playerid], 1);
  	PlayerTextDrawBoxColor(playerid,PizzaSymbol[playerid], 0);
  	PlayerTextDrawTextSize(playerid,PizzaSymbol[playerid], 30.000000, 30.000000);
  	PlayerTextDrawSetSelectable(playerid,PizzaSymbol[playerid], 0);
  	PlayerTextDrawSetPreviewModel(playerid,PizzaSymbol[playerid],1582);
  	PlayerTextDrawSetPreviewRot(playerid,PizzaSymbol[playerid],120.0,0.0,0.0,1.0);

    format(string,sizeof(string),"Tips: ~g~+%d$",PlayerTips[playerid]);
  	TipsText[playerid] = CreatePlayerTextDraw(playerid,510.000000, 218.000000, string);
  	PlayerTextDrawBackgroundColor(playerid,TipsText[playerid], 255);
  	PlayerTextDrawFont(playerid,TipsText[playerid], 1);
  	PlayerTextDrawLetterSize(playerid,TipsText[playerid], 0.300000, 1.000000);
  	PlayerTextDrawColor(playerid,TipsText[playerid], -1);
  	PlayerTextDrawSetOutline(playerid,TipsText[playerid], 1);
  	PlayerTextDrawSetProportional(playerid,TipsText[playerid], 1);
  	PlayerTextDrawSetSelectable(playerid,TipsText[playerid], 0);

    format(string,sizeof(string),"Earnings: ~g~%d$",PlayerEarnings[playerid]);
  	EarningsText[playerid] = CreatePlayerTextDraw(playerid,510.000000, 208.000000, string);
  	PlayerTextDrawBackgroundColor(playerid,EarningsText[playerid], 255);
  	PlayerTextDrawFont(playerid,EarningsText[playerid], 1);
  	PlayerTextDrawLetterSize(playerid,EarningsText[playerid], 0.300000, 1.000000);
  	PlayerTextDrawColor(playerid,EarningsText[playerid], -1);
  	PlayerTextDrawSetOutline(playerid,EarningsText[playerid], 1);
  	PlayerTextDrawSetProportional(playerid,EarningsText[playerid], 1);
  	PlayerTextDrawSetSelectable(playerid,EarningsText[playerid], 0);

    format(string,sizeof(string),"Total Earnings: ~g~%d$",PlayerEarnings[playerid]+PlayerTips[playerid]);
  	TotalEarningsText[playerid] = CreatePlayerTextDraw(playerid,510.000000, 228.000000, string);
  	PlayerTextDrawBackgroundColor(playerid,TotalEarningsText[playerid], 255);
  	PlayerTextDrawFont(playerid,TotalEarningsText[playerid], 1);
  	PlayerTextDrawLetterSize(playerid,TotalEarningsText[playerid], 0.300000, 1.000000);
  	PlayerTextDrawColor(playerid,TotalEarningsText[playerid], -1);
  	PlayerTextDrawSetOutline(playerid,TotalEarningsText[playerid], 1);
  	PlayerTextDrawSetProportional(playerid,TotalEarningsText[playerid], 1);
  	PlayerTextDrawSetSelectable(playerid,TotalEarningsText[playerid], 0);
  	
  	PlayerTextDrawShow(playerid,PizzasText[playerid]);
  	PlayerTextDrawShow(playerid,PizzaSymbol[playerid]);
  	PlayerTextDrawShow(playerid,EarningsText[playerid]);
  	PlayerTextDrawShow(playerid,TotalEarningsText[playerid]);
  	PlayerTextDrawShow(playerid,TipsText[playerid]);
	return 1;
}

public HidePlayerPizzaBikeTexts(playerid)
{
    PlayerTextDrawHide(playerid,PizzasText[playerid]);
  	PlayerTextDrawHide(playerid,PizzaSymbol[playerid]);
  	PlayerTextDrawHide(playerid,EarningsText[playerid]);
  	PlayerTextDrawHide(playerid,TotalEarningsText[playerid]);
  	PlayerTextDrawHide(playerid,TipsText[playerid]);
  	
  	PlayerTextDrawDestroy(playerid,PizzasText[playerid]);
  	PlayerTextDrawDestroy(playerid,PizzaSymbol[playerid]);
  	PlayerTextDrawDestroy(playerid,EarningsText[playerid]);
  	PlayerTextDrawDestroy(playerid,TotalEarningsText[playerid]);
  	PlayerTextDrawDestroy(playerid,TipsText[playerid]);
	return 1;
}

public ShowTipTimeText(playerid)
{
    TipTimeText[playerid] = CreatePlayerTextDraw(playerid,508.000000, 191.000000, "Tip Time: 00:30");
  	PlayerTextDrawBackgroundColor(playerid,TipTimeText[playerid], 255);
  	PlayerTextDrawFont(playerid,TipTimeText[playerid], 2);
  	PlayerTextDrawLetterSize(playerid,TipTimeText[playerid], 0.280000, 1.000000);
  	PlayerTextDrawColor(playerid,TipTimeText[playerid], -1);
  	PlayerTextDrawSetOutline(playerid,TipTimeText[playerid], 1);
  	PlayerTextDrawSetProportional(playerid,TipTimeText[playerid], 1);
  	PlayerTextDrawSetSelectable(playerid,TipTimeText[playerid], 0);

  	PlayerTextDrawShow(playerid,TipTimeText[playerid]);
  	return 1;
}

public HideTipTimeText(playerid)
{
    PlayerTextDrawHide(playerid,TipTimeText[playerid]);

    PlayerTextDrawDestroy(playerid,TipTimeText[playerid]);
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid,PIZZA_INDEX))
		{
	    	RemovePlayerFromVehicle(playerid);
			SetPlayerArmedWeapon(playerid,0);
			ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,1,1,1,1,1,1);
		}
		new vehid = GetPlayerVehicleID(playerid);
		if(vehid == pizzabikes[0] || vehid == pizzabikes[1] || vehid == pizzabikes[2] || vehid == pizzabikes[3] || vehid == pizzabikes[4])
		{
		    if(IsInJob[playerid] == 1)
			{
		    	ShowPlayerPizzaBikeTexts(playerid);
		    	if(PlayerCheckpoint[playerid] == CHECKPOINT_NONE)
	    		{
	    		    ShowPlayerInfoTexts(playerid);
					PlayerTextDrawHide(playerid,Textdraw0[playerid]);
					PlayerTextDrawSetString(playerid,Textdraw0[playerid],"Looks like you have a ~r~customer~w~! Head right to their place~n~                   with a fresh ~r~pizza~w~!");
					PlayerTextDrawShow(playerid,Textdraw0[playerid]);
					InfoTimer[playerid] = SetTimerEx("HidePlayerInfoTexts",5000,false,"d",playerid);
					new rand = random(sizeof(Houses));
					new skin = random(311)+1;
					if(skin == 74) return skin=75;
					SetPlayerCheckpoint(playerid,Houses[rand][0],Houses[rand][1],Houses[rand][2],2.0);
					PlayerCustomer[playerid] = CreateActor(skin,Houses[rand][0],Houses[rand][1],Houses[rand][2]+0.5,Houses[rand][3]-180.0);
					ApplyActorAnimation(PlayerCustomer[playerid],"DEALER","DEALER_IDLE",4.1,1,0,0,0,0);
					PlayerCheckpoint[playerid]=PIZZA_CHECKPOINT;
					TipTime[playerid]=30;
					ShowTipTimeText(playerid);
			    }
				SetEngineStatus(vehid, true);
			}
			else
			{
				SendClientMessage(playerid,-1," �س��ͧ������ҹ��͹���ТѺ��䫵��觾ԫ���!");
				RemovePlayerFromVehicle(playerid);
			}
		}
	}
	else if(newstate == PLAYER_STATE_ONFOOT && oldstate == PLAYER_STATE_DRIVER) { HidePlayerPizzaBikeTexts(playerid); }
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	if(PlayerCheckpoint[playerid] == PIZZA_CHECKPOINT)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid,PIZZA_INDEX))
	    {
	        new string[128];
			PlayerEarnings[playerid]+=PAY_PER_CHECKPOINT;
			format(string,sizeof(string)," �س���Ѻ {7FFF00}%d$ {FFFFFF}����Ѻ����觾ԫ���!",PAY_PER_CHECKPOINT);
			SendClientMessage(playerid,-1,string);
			RemovePlayerAttachedObject(playerid,PIZZA_INDEX);
			PlayerCheckpoint[playerid]=CHECKPOINT_NONE;
			DisablePlayerCheckpoint(playerid);
			DestroyActor(PlayerCustomer[playerid]);
			ClearAnimations(playerid);
			if(TipTime[playerid] > 0)
	        {
	            TipTime[playerid]=0;
	            new tip=random(MAX_TIP)+5;
	            PlayerTips[playerid]+=tip;
	            format(string,sizeof(string)," �Թ�մ���! �س���Ѻ�Ի {7FFF00}%d$ {FFFFFF}����Ѻ��������ҧ�Ǵ����!",tip);
	            SendClientMessage(playerid,-1,string);
	            PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
	            HideTipTimeText(playerid);
			}
	    }
	    else return SendClientMessage(playerid,-1," �س��ͧ��͡��ͧ�ԫ��ҡ�͹�Թ��Ҩش {FF0000}checkpoint{FFFFFF}!");
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(PRESSED(KEY_FIRE))
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid,PIZZA_INDEX))
		{
		    SetPlayerArmedWeapon(playerid,0);
		 	ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,1,1,1,1,1,1);
		}
	}
	return 1;
}

TimeConvert(seconds)
{
	new tmp[256];
	new minutes = floatround(seconds/60);
	seconds -= minutes*60;
	format(tmp, sizeof(tmp), "%d:%02d", minutes, seconds);
	return tmp;
}

public TutorialTime()
{
	foreach(new i : Player)
	{
	    if(PlayerTutorialTime[i] > 0)
	    {
	        PlayerTutorialTime[i]--;
	        if(PlayerTutorialTime[i] == 24)
	        {
	            InterpolateCameraPos(i, 2088.402343, -1790.125854, 16.726133, 2088.853027, -1812.807495, 14.554449, 3000);
				InterpolateCameraLookAt(i, 2092.098144, -1793.486572, 16.940910, 2093.178466, -1815.248168, 13.977611, 3000);
				PlayerTextDrawHide(i,Textdraw2[i]);
				PlayerTextDrawSetString(i,Textdraw2[i],"To start this part-time job, all you have to do is to hop in one of~n~those pizzaboy bikes.");
				PlayerTextDrawShow(i,Textdraw2[i]);
	        }
	        else if(PlayerTutorialTime[i] == 18)
	        {
	            InterpolateCameraPos(i, 2088.853027, -1812.807495, 14.554449, 2046.698730, -1616.230712, 49.785942, 3000);
				InterpolateCameraLookAt(i, 2093.144042, -1815.167358, 13.545793, 2048.481201, -1620.497070, 47.883228, 3000);
				PlayerTextDrawHide(i,Textdraw2[i]);
				PlayerTextDrawSetString(i,Textdraw2[i],"People around Idlewood and Ganton will always call when they need~n~a pizza, so you must do your best to arrive in time with~n~their hot pizza!");
				PlayerTextDrawShow(i,Textdraw2[i]);
	        }
	        else if(PlayerTutorialTime[i] == 12)
	        {
	            new skin = random(311)+1;
				if(skin == 74) return skin=75;
				PlayerCustomer[i] = CreateActor(skin,2067.2793,-1703.4181,14.1484,271.5973);
				ApplyActorAnimation(PlayerCustomer[i],"DEALER","DEALER_IDLE",4.1,1,0,0,0,0);
				
	            InterpolateCameraPos(i, 2046.698852, -1616.231201, 49.785850, 2077.879638, -1698.481567, 16.811132, 3000);
				InterpolateCameraLookAt(i, 2047.768066, -1620.363891, 47.182411, 2073.304199, -1700.195068, 15.748975, 3000);
	            PlayerTextDrawHide(i,Textdraw2[i]);
				PlayerTextDrawSetString(i,Textdraw2[i],"Doing it in the right and fastest possible time, this will earn you~n~an extra tip alongside your paycheck!");
				PlayerTextDrawShow(i,Textdraw2[i]);
	        }
	        else if(PlayerTutorialTime[i] == 6)
	        {
	            InterpolateCameraPos(i, 2077.879150, -1698.480346, 16.811641, 2119.111328, -1780.575683, 15.841483, 3000);
				InterpolateCameraLookAt(i, 2079.523681, -1703.201416, 16.725708, 2116.954589, -1784.953247, 14.752622, 3000);
	            PlayerTextDrawHide(i,Textdraw2[i]);
				PlayerTextDrawSetString(i,Textdraw2[i],"Each bike can only have ~r~5~w~ pizzas. Make sure to restock it regulary!");
				PlayerTextDrawShow(i,Textdraw2[i]);
				DestroyActor(PlayerCustomer[i]);
	        }
	        else if(PlayerTutorialTime[i] <= 0)
	        {
	            TogglePlayerSpectating(i,0);
	            HidePlayerIntroTexts(i);
            	ShowPlayerInfoTexts(i);
            	InfoTimer[i] = SetTimerEx("HidePlayerInfoTexts",1000,false,"d",i);
            	SetCameraBehindPlayer(i);
            	TogglePlayerControllable(i,1);
	        }
		}
		if(TipTime[i] > 0)
		{
		    new string[26];
			TipTime[i]--;
			PlayerTextDrawHide(i,TipTimeText[i]);
			format(string,sizeof(string),"Tip Time: %s",TimeConvert(TipTime[i]));
			PlayerTextDrawSetString(i,TipTimeText[i],string);
			PlayerTextDrawShow(i,TipTimeText[i]);

            if(isPlayerAndroid(i) != 0)
            {
                Mobile_GameTextForPlayer(i, string, 3000, 6);
            }
			if(TipTime[i] == 0) { HideTipTimeText(i); }
		}
	}
	return 1;
}