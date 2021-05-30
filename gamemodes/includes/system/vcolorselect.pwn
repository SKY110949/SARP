#include <YSI\y_hooks>

// Color Selection
new const ColorMenuSelect[][]={
{1,0},{0,0},{8,0},{11,0},{13,0},{14,0},{15,0},{19,0},{23,0},{24,0},{25,0},{26,0},{27,0},{29,0},{33,0},{34,0},{35,0},{38,0},{39,0},{49,0},{50,0},{52,0},{56,0},{60,0},{63,0},{64,0},{67,0},{71,0},{90,0},{96,0},{109,0},{111,0},{118,0},{122,0},{138,0},{140,0},{148,0},{157,0},{192,0},{193,0},{196,0},{213,0},{250,0},{251,0},{252,0},{253,0},{255,0},{3,1},{17,1},{42,1},{43,1},{45,1},{58,1},{70,1},{82,1},{117,1},{121,1},{124,1},{2,2},{7,2},{10,2},{12,2},{20,2},{28,2},{32,2},
{53,2},{54,2},{59,2},{79,2},{87,2},{93,2},{94,2},{95,2},{100,2},{101,2},{103,2},{106,2},{108,2},{109,2},{112,2},{116,2},{125,2},{130,2},{135,2},{139,2},{152,2},{166,2},{198,2},{201,2},{205,2},{208,2},{209,2},{210,2},{223,2},{246,2},{16,3},{28,3},{44,3},{51,3},{83,3},{86,3},{114,3},{137,3},{145,3},{151,3},{153,3},{154,3},{160,3},{186,3},{187,3},{188,3},{189,3},{191,3},{202,3},{215,3},{226,3},{227,3},{229,3},{234,3},{235,3},{241,3},{243,3},{245,3},{6,4},{65,4},{142,4},
{194,4},{195,4},{197,4},{221,4},{228,4},{6,5},{158,5},{175,5},{181,5},{182,5},{183,5},{219,5},{222,5},{239,5},{30,6},{31,6},{40,6},{41,6},{58,6},{62,6},{66,6},{74,6},{78,6},{84,6},{88,6},{113,6},{119,6},{123,6},{129,6},{131,6},{149,6},{159,6},{168,6},{173,6},{174,6},{180,6},{212,6},{224,6},{230,6},{238,6},{244,6},{254,6},{147,7},{167,7},{171,7},{179,7},{190,7},{211,7},{232,7},{233,7},{237,7},{5,8},{126,8},{146,8},{176,8},{177,8},{178,8},{46,9},{47,9},{48,9},{55,9},
{58,9},{61,9},{68,9},{69,9},{73,9},{76,9},{77,9},{81,9},{89,9},{99,9},{102,9},{104,9},{107,9},{110,9},{120,9},{138,9},{140,9},{141,9},{157,9},{192,9},{193,9},{196,9},{213,9},{250,9},{253,9}
};

new const ColorMenuInfo[][] = {
{1, "Basic"},
{3, "Red"},
{2, "Blue"},
{16, "Green"},
{6, "Yellow"},
{158, "Orange"},
{30, "Brown"},
{179, "Purple"},
{190, "Pink"},
{110, "Tan"}
};

new
	PlayerText:ColorSelectText[MAX_PLAYERS],
	PlayerText:ColorSelectLeft[MAX_PLAYERS],
	PlayerText:ColorSelectRight[MAX_PLAYERS],
	PlayerText:ColorSelection[MAX_PLAYERS][8];

new
	PlayerText:ColorSelectText2[MAX_PLAYERS],
	PlayerText:ColorSelectLeft2[MAX_PLAYERS],
	PlayerText:ColorSelectRight2[MAX_PLAYERS],
	PlayerText:ColorSelection2[MAX_PLAYERS][8];

new bool:ColorSelectShow[MAX_PLAYERS char],
    ColorSelectItem[MAX_PLAYERS],
	ColorSelectPage[MAX_PLAYERS],
	ColorSelectPages[MAX_PLAYERS],
	ColorSelect[MAX_PLAYERS] = -1,
	ColorSelectListener[MAX_PLAYERS][8];

new bool:ColorSelectShow2[MAX_PLAYERS char],
    ColorSelectItem2[MAX_PLAYERS],
	ColorSelectPage2[MAX_PLAYERS],
	ColorSelectPages2[MAX_PLAYERS],
	ColorSelect2[MAX_PLAYERS] = -1,
	ColorSelectListener2[MAX_PLAYERS][8];

new 
	TempColor[MAX_PLAYERS], 
	TempColor2[MAX_PLAYERS];

hook OP_Connect(playerid) {
	new
	    Float:x = 160.0,
	    Float:y = 280.0;

	for (new i = 0; i < 8; i ++)
	{
		if (i > 0 && (i == 4))
		{
		    x = 160.0;
			y = 280.0+14.0;
		}
		else if(i > 0)
		{
			x += 13;
		}
 		ColorSelection[playerid][i] = CreatePlayerTextDraw(playerid, x, y, "_");
		PlayerTextDrawBackgroundColor(playerid, ColorSelection[playerid][i], 0);
		PlayerTextDrawFont(playerid, ColorSelection[playerid][i], 5);
		PlayerTextDrawLetterSize(playerid, ColorSelection[playerid][i], 13, 14);
		PlayerTextDrawColor(playerid, ColorSelection[playerid][i], -1);
		PlayerTextDrawSetOutline(playerid, ColorSelection[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, ColorSelection[playerid][i], 1);
		PlayerTextDrawUseBox(playerid, ColorSelection[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, ColorSelection[playerid][i], 0);
		PlayerTextDrawTextSize(playerid, ColorSelection[playerid][i], 13.0000, 14.000000);
		PlayerTextDrawSetSelectable(playerid, ColorSelection[playerid][i], 1);
		PlayerTextDrawSetPreviewModel(playerid, ColorSelection[playerid][i], 19300);

		ColorSelection2[playerid][i] = CreatePlayerTextDraw(playerid, 260+x, y, "_");
		PlayerTextDrawBackgroundColor(playerid, ColorSelection2[playerid][i], 0);
		PlayerTextDrawFont(playerid, ColorSelection2[playerid][i], 5);
		PlayerTextDrawLetterSize(playerid, ColorSelection2[playerid][i], 13, 14);
		PlayerTextDrawColor(playerid, ColorSelection2[playerid][i], -1);
		PlayerTextDrawSetOutline(playerid, ColorSelection2[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, ColorSelection2[playerid][i], 1);
		PlayerTextDrawUseBox(playerid, ColorSelection2[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, ColorSelection2[playerid][i], 0);
		PlayerTextDrawTextSize(playerid, ColorSelection2[playerid][i], 13.0000, 14.000000);
		PlayerTextDrawSetSelectable(playerid, ColorSelection2[playerid][i], 1);
		PlayerTextDrawSetPreviewModel(playerid, ColorSelection2[playerid][i], 19300);
	}
	ColorSelectText[playerid] = CreatePlayerTextDraw(playerid, 185.599990, 311.795379, "Primary Colors");
	PlayerTextDrawAlignment(playerid,ColorSelectText[playerid], 2);
	PlayerTextDrawBackgroundColor(playerid,ColorSelectText[playerid], 255);
	PlayerTextDrawFont(playerid,ColorSelectText[playerid], 1);
	PlayerTextDrawLetterSize(playerid,ColorSelectText[playerid], 0.389999, 1.699998);
	PlayerTextDrawColor(playerid,ColorSelectText[playerid], -1);
	PlayerTextDrawSetOutline(playerid,ColorSelectText[playerid], 0);
	PlayerTextDrawSetProportional(playerid,ColorSelectText[playerid], 1);
	PlayerTextDrawSetShadow(playerid,ColorSelectText[playerid], 1);
	PlayerTextDrawUseBox(playerid,ColorSelectText[playerid], 1);
	PlayerTextDrawBoxColor(playerid,ColorSelectText[playerid], 0);
	PlayerTextDrawTextSize(playerid,ColorSelectText[playerid], 190.000000, 128.000000);
	PlayerTextDrawSetSelectable(playerid,ColorSelectText[playerid], 1);


	ColorSelectLeft[playerid] = CreatePlayerTextDraw(playerid, 145.599945, 287.422149, "ld_beat:left");
	PlayerTextDrawLetterSize(playerid, ColorSelectLeft[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ColorSelectLeft[playerid], 14.399991, 14.933345);
	PlayerTextDrawAlignment(playerid, ColorSelectLeft[playerid], 1);
	PlayerTextDrawColor(playerid, ColorSelectLeft[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ColorSelectLeft[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ColorSelectLeft[playerid], 0);
	PlayerTextDrawFont(playerid, ColorSelectLeft[playerid], 4);
	PlayerTextDrawSetSelectable(playerid, ColorSelectLeft[playerid], true);


	ColorSelectRight[playerid] = CreatePlayerTextDraw(playerid, 212.200164, 287.422149, "ld_beat:right");
	PlayerTextDrawLetterSize(playerid, ColorSelectRight[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ColorSelectRight[playerid], 14.399991, 14.933345);
	PlayerTextDrawAlignment(playerid, ColorSelectRight[playerid], 1);
	PlayerTextDrawColor(playerid, ColorSelectRight[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ColorSelectRight[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ColorSelectRight[playerid], 0);
	PlayerTextDrawFont(playerid, ColorSelectRight[playerid], 4);
	PlayerTextDrawSetProportional(playerid, ColorSelectRight[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ColorSelectRight[playerid], true);

	ColorSelectText2[playerid] = CreatePlayerTextDraw(playerid, 260+185.599990, 311.795379, "Secondary Colors");
	PlayerTextDrawAlignment(playerid,ColorSelectText2[playerid], 2);
	PlayerTextDrawBackgroundColor(playerid,ColorSelectText2[playerid], 255);
	PlayerTextDrawFont(playerid,ColorSelectText2[playerid], 1);
	PlayerTextDrawLetterSize(playerid,ColorSelectText2[playerid], 0.389999, 1.699998);
	PlayerTextDrawColor(playerid,ColorSelectText2[playerid], -1);
	PlayerTextDrawSetOutline(playerid,ColorSelectText2[playerid], 0);
	PlayerTextDrawSetProportional(playerid,ColorSelectText2[playerid], 1);
	PlayerTextDrawSetShadow(playerid,ColorSelectText2[playerid], 1);
	PlayerTextDrawUseBox(playerid,ColorSelectText2[playerid], 1);
	PlayerTextDrawBoxColor(playerid,ColorSelectText2[playerid], 0);
	PlayerTextDrawTextSize(playerid,ColorSelectText2[playerid], 190.000000, 128.000000);
	PlayerTextDrawSetSelectable(playerid,ColorSelectText2[playerid], 1);

	ColorSelectLeft2[playerid] = CreatePlayerTextDraw(playerid, 260+145.599945, 287.422149, "ld_beat:left");
	PlayerTextDrawLetterSize(playerid, ColorSelectLeft2[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ColorSelectLeft2[playerid], 14.399991, 14.933345);
	PlayerTextDrawAlignment(playerid, ColorSelectLeft2[playerid], 1);
	PlayerTextDrawColor(playerid, ColorSelectLeft2[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ColorSelectLeft2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ColorSelectLeft2[playerid], 0);
	PlayerTextDrawFont(playerid, ColorSelectLeft2[playerid], 4);
	PlayerTextDrawSetSelectable(playerid, ColorSelectLeft2[playerid], true);

	ColorSelectRight2[playerid] = CreatePlayerTextDraw(playerid, 260+212.200164, 287.422149, "ld_beat:right");
	PlayerTextDrawLetterSize(playerid, ColorSelectRight2[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ColorSelectRight2[playerid], 14.399991, 14.933345);
	PlayerTextDrawAlignment(playerid, ColorSelectRight2[playerid], 1);
	PlayerTextDrawColor(playerid, ColorSelectRight2[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ColorSelectRight2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ColorSelectRight2[playerid], 0);
	PlayerTextDrawFont(playerid, ColorSelectRight2[playerid], 4);
	PlayerTextDrawSetProportional(playerid, ColorSelectRight2[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ColorSelectRight2[playerid], true);    
    return 1;
}


hook OP_ClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == Text:INVALID_TEXT_DRAW)
	{
		if (ColorSelectShow{playerid} || ColorSelectShow2{playerid})
		{
			ClearColorSelect(playerid);
		}
    }
    return 1;
}

hook OP_ClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(ColorSelectShow{playerid})
	{
		if(playertextid == PlayerText:INVALID_TEXT_DRAW)
		{
			ClearColorSelect(playerid);
		}
		else if(playertextid == ColorSelectText[playerid])
		{
			ColorSelect[playerid] = -1;
			ShowPlayerColorSelection(playerid, 1, TempColor[playerid]);
			return 1;
		}

		else if(playertextid == ColorSelectLeft[playerid])
		{
			if (ColorSelectPage[playerid] < 2)
				return 0;

			else
				ShowPlayerColorSelection(playerid, ColorSelectPage[playerid] - 1, TempColor[playerid]);
		}

		else if(playertextid == ColorSelectRight[playerid])
		{
			if (ColorSelectPage[playerid] == ColorSelectPages[playerid])
				return 0;

			else
				ShowPlayerColorSelection(playerid, ColorSelectPage[playerid] + 1, TempColor[playerid]);
		}

		for(new i = 0; i < 8; i++)
		{
			if(playertextid == ColorSelection[playerid][i])
			{
				if(ColorSelect[playerid] == -1)
				{
					ColorSelect[playerid] = ColorSelectListener[playerid][i];
					ShowPlayerColorSelection(playerid, 1, TempColor[playerid]);

				}
				else
				{
                    if(GetPVarType(playerid, "vcolorselectID")) {
                        new vid=GetPVarInt(playerid, "vcolorselectID");
						TempColor[playerid] = ColorSelectListener[playerid][i];
                        ChangeVehicleColor(vid, TempColor[playerid], TempColor2[playerid]);
                    }          
				}
				break;
			}
		}
	}
	if(ColorSelectShow2{playerid})
	{
		if(playertextid == PlayerText:INVALID_TEXT_DRAW)
		{
			ClearColorSelect(playerid);
		}
		else if(playertextid == ColorSelectText2[playerid])
		{
			ColorSelect2[playerid] = -1;
			ShowPlayerColorSelection2(playerid, 1, TempColor2[playerid]);
			return 1;
		}

		else if(playertextid == ColorSelectLeft2[playerid])
		{
			if (ColorSelectPage2[playerid] < 2)
				return 0;

			else
				ShowPlayerColorSelection2(playerid, ColorSelectPage2[playerid] - 1, TempColor2[playerid]);
		}

		else if(playertextid == ColorSelectRight2[playerid])
		{
			if (ColorSelectPage2[playerid] == ColorSelectPages2[playerid])
				return 0;

			else
				ShowPlayerColorSelection2(playerid, ColorSelectPage2[playerid] + 1, TempColor2[playerid]);
		}

		for(new i = 0; i < 8; i++)
		{
			if(playertextid == ColorSelection2[playerid][i])
			{
				if(ColorSelect2[playerid] == -1)
				{
					ColorSelect2[playerid] = ColorSelectListener2[playerid][i];
					ShowPlayerColorSelection2(playerid, 1, TempColor2[playerid]);

				}
				else
				{
                    if(GetPVarType(playerid, "vcolorselectID")) {
                        new vid=GetPVarInt(playerid, "vcolorselectID");
						TempColor2[playerid] = ColorSelectListener2[playerid][i];
                        ChangeVehicleColor(vid, TempColor[playerid], TempColor2[playerid]);
                    }
				}
				break;
			}
		}
	}
    return 1;
}

ShowPlayerColorSelection(playerid, page, temp_color=0)
{
	new string[64], selecttype, selectstart;

    ColorSelectPage[playerid] = page;
	TempColor[playerid]=temp_color;

	if(ColorSelect[playerid] >= 0)
	{
        for (new i = 0; i != sizeof(ColorMenuSelect); i ++)
        {
			if(ColorMenuSelect[i][1] == ColorSelect[playerid])
			{
			    if(!selectstart)
			    {
			        selectstart = i + (8 * (page-1));
			    }
				selecttype++;
			}
		}

		ColorSelectItem[playerid] = selecttype;
		ColorSelectPages[playerid] = floatround(floatdiv(ColorSelectItem[playerid], 8), floatround_ceil);

	}
	else
	{
        selectstart = 8 * (page-1);
		ColorSelectItem[playerid] = sizeof(ColorMenuInfo);
		ColorSelectPages[playerid] = floatround(floatdiv(ColorSelectItem[playerid], 8), floatround_ceil);
    }

	for(new i = 0 ; i < 8 ; i++ )
	{
		PlayerTextDrawHide(playerid, ColorSelection[playerid][i]);
	}
	PlayerTextDrawHide(playerid, ColorSelectText[playerid]);
	PlayerTextDrawHide(playerid, ColorSelectLeft[playerid]);
	PlayerTextDrawHide(playerid, ColorSelectRight[playerid]);

	new start = (8 * (page-1));

	for (new i = start; i != start + 8 && i < ColorSelectItem[playerid]; i ++)
	{
	    if(ColorSelect[playerid] >= 0)
	    {
			PlayerTextDrawBackgroundColor(playerid, ColorSelection[playerid][i-start], g_arrCarColors[ColorMenuSelect[selectstart+i-start][0]]);
	    	ColorSelectListener[playerid][i-start] = ColorMenuSelect[selectstart+i-start][0];

	    }
	    else
	    {
			PlayerTextDrawBackgroundColor(playerid, ColorSelection[playerid][i-start], g_arrCarColors[ColorMenuInfo[selectstart+i-start][0]]);
		    ColorSelectListener[playerid][i-start] = i;

	    }
	    PlayerTextDrawShow(playerid, ColorSelection[playerid][i-start]);
	}

	if(ColorSelect[playerid] >= 0)
	{
		format(string, sizeof(string),"%s (%d/%d)", ColorMenuInfo[ColorSelect[playerid]][1], page, ColorSelectPages[playerid]);
		PlayerTextDrawColor(playerid,ColorSelectText[playerid], g_arrCarColors[ColorMenuInfo[ColorSelect[playerid]][0]]);
		PlayerTextDrawSetString(playerid, ColorSelectText[playerid], string);
	}
	else
	{
	    PlayerTextDrawColor(playerid,ColorSelectText[playerid], -1);
		PlayerTextDrawSetString(playerid, ColorSelectText[playerid], "Primary Colors");
	}
	PlayerTextDrawShow(playerid, ColorSelectText[playerid]);


	if(page-1 != 0)
	{
		PlayerTextDrawShow(playerid, ColorSelectLeft[playerid]);
	}
	if(page+1 <= ColorSelectPages[playerid])
	{
		PlayerTextDrawShow(playerid, ColorSelectRight[playerid]);
	}

	ColorSelectShow{playerid} = true;

	SelectTextDraw(playerid, 0x585858FF);
	return 1;
}


ShowPlayerColorSelection2(playerid, page, temp_color=0)
{
	new string[64], selecttype, selectstart;

    ColorSelectPage2[playerid] = page;
	TempColor2[playerid]=temp_color;

	if(ColorSelect2[playerid] >= 0)
	{
        for (new i = 0; i != sizeof(ColorMenuSelect); i ++)
        {
			if(ColorMenuSelect[i][1] == ColorSelect2[playerid])
			{
			    if(!selectstart)
			    {
			        selectstart = i + (8 * (page-1));
			    }
				selecttype++;
			}
		}

		ColorSelectItem2[playerid] = selecttype;
		ColorSelectPages2[playerid] = floatround(floatdiv(ColorSelectItem2[playerid], 8), floatround_ceil);

	}
	else
	{
        selectstart = 8 * (page-1);
		ColorSelectItem2[playerid] = sizeof(ColorMenuInfo);
		ColorSelectPages2[playerid] = floatround(floatdiv(ColorSelectItem2[playerid], 8), floatround_ceil);
    }

	for(new i = 0 ; i < 8 ; i++ )
	{
		PlayerTextDrawHide(playerid, ColorSelection2[playerid][i]);
	}
	PlayerTextDrawHide(playerid, ColorSelectText2[playerid]);
	PlayerTextDrawHide(playerid, ColorSelectLeft2[playerid]);
	PlayerTextDrawHide(playerid, ColorSelectRight2[playerid]);

	new start = (8 * (page-1));

	for (new i = start; i != start + 8 && i < ColorSelectItem2[playerid]; i ++)
	{
	    if(ColorSelect2[playerid] >= 0)
	    {
			PlayerTextDrawBackgroundColor(playerid, ColorSelection2[playerid][i-start], g_arrCarColors[ColorMenuSelect[selectstart+i-start][0]]);
	    	ColorSelectListener2[playerid][i-start] = ColorMenuSelect[selectstart+i-start][0];

	    }
	    else
	    {
			PlayerTextDrawBackgroundColor(playerid, ColorSelection2[playerid][i-start], g_arrCarColors[ColorMenuInfo[selectstart+i-start][0]]);
		    ColorSelectListener2[playerid][i-start] = i;

	    }
	    PlayerTextDrawShow(playerid, ColorSelection2[playerid][i-start]);
	}

	if(ColorSelect2[playerid] >= 0)
	{
		format(string, sizeof(string),"%s (%d/%d)", ColorMenuInfo[ColorSelect2[playerid]][1], page, ColorSelectPages2[playerid]);
		PlayerTextDrawColor(playerid,ColorSelectText2[playerid], g_arrCarColors[ColorMenuInfo[ColorSelect2[playerid]][0]]);
		PlayerTextDrawSetString(playerid, ColorSelectText2[playerid], string);
	}
	else
	{
	    PlayerTextDrawColor(playerid,ColorSelectText2[playerid], -1);
		PlayerTextDrawSetString(playerid, ColorSelectText2[playerid], "Secondary Colors");
	}
	PlayerTextDrawShow(playerid, ColorSelectText2[playerid]);


	if(page-1 != 0)
	{
		PlayerTextDrawShow(playerid, ColorSelectLeft2[playerid]);
	}
	if(page+1 <= ColorSelectPages2[playerid])
	{
		PlayerTextDrawShow(playerid, ColorSelectRight2[playerid]);
	}

	ColorSelectShow2{playerid} = true;

	SelectTextDraw(playerid, 0x585858FF);
	return 1;
}

ClearColorSelect(playerid)
{
	if(ColorSelectShow{playerid} || ColorSelectShow2{playerid})
	{
		for(new i = 0 ; i < 8 ; i++ )
		{
			PlayerTextDrawHide(playerid, ColorSelection[playerid][i]);
			PlayerTextDrawHide(playerid, ColorSelection2[playerid][i]);
		}
		PlayerTextDrawHide(playerid, ColorSelectText[playerid]);
		PlayerTextDrawHide(playerid, ColorSelectLeft[playerid]);
		PlayerTextDrawHide(playerid, ColorSelectRight[playerid]);
		PlayerTextDrawHide(playerid, ColorSelectText2[playerid]);
		PlayerTextDrawHide(playerid, ColorSelectLeft2[playerid]);
		PlayerTextDrawHide(playerid, ColorSelectRight2[playerid]);

		ColorSelectPage[playerid]=
		ColorSelectPage2[playerid]=
		ColorSelect[playerid]=
		ColorSelect2[playerid]=-1;

		ColorSelectShow{playerid} = false;
		ColorSelectShow2{playerid} = false;

		if(GetPVarType(playerid, "vcolorselectID"))
		{
			new id = GetPVarInt(playerid, "VehicleDynamicID");
			if(id != -1) {
				vehicleVariables[id][vVehicleColour][0] = TempColor[playerid];
				vehicleVariables[id][vVehicleColour][1] = TempColor2[playerid];

				Log(adminactionlog, INFO, "%s: เปลี่ยนสีของยานพาหนะ %s(%d) เป็น %d/%d", ReturnPlayerName(playerid), ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), vehicleVariables[id][vVehicleID], TempColor[playerid], TempColor2[playerid]);

				Vehicle_Save(id);
			}
	        EditVehicleMenu(playerid);
		}

		TempColor[playerid]=
		TempColor2[playerid]=0;
	}
	return 1;
}