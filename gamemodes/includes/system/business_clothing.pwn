#include <YSI\y_hooks>

#define CLOTHING_PRICE	300

static
	Float:skinChangPosX[MAX_PLAYERS],
	Float:skinChangPosY[MAX_PLAYERS],
	SkinSet[311];

static const CLOTHING_MALE[] = { 
  1,2,3,4,5,6,7,8,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,32,33,34,35,36,37,38, 
  42,43,44,45,46,47,48,49,50,51,52,57,58,59,60,61,62,66,67,68,72,73,78,79,80,81,82,83,84,86, 
  94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117, 
  118,119,120,121,122,123,124,125,126,127,128,132,133,134,135,136,137,142,143,144,146,147,149, 
  153,154,156,158,159,160,161,162,163,164,165,166,167,168,170,171,173,174,175,176,177,179,180, 
  181,182,183,184,185,186,187,188,189,200,202,203,204,206,208,209,210,212,213,217,220,221,222, 
  223,227,228,229,230,234,235,236,239,240,241,242,247,248,249,250,253,254,255,258,259,260,261,262, 
  268,269,270,271,272,273,289,290,291,292,293,294,295,296,297,299 
};

static const CLOTHING_FEMALE[] = { 
  9,10,11,12,13,31,39,40,41,53,54,55,56,63,64,65,69,75,76,77,85,87,88,89,90,91,93,129,130,131, 
  138,139,140,141,145,148,150,151,152,157,169,172,178,190,191,192,193,194,195,196,197,198,199,201, 
  205,207,211,214,215,216,218,219,224,225,226,231,232,233,237,238,243,244,245,246,251,256,257,263,298, 
}; 

ChooseSkin(playerid, type) {

	if (GetPVarType(playerid, "ClothingSelection"))
	return SendClientMessage(playerid, COLOR_GRAD1, "   คุณกำลังเลือกตัวละครอยู่...");

	SkinSet = type ? CLOTHING_FEMALE : CLOTHING_MALE;
	// type: 1 ชาย, 2 หญิง
	GetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
	GetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
	GetXYInFrontOfPlayer(playerid,skinChangPosX[playerid], skinChangPosY[playerid], 3.5);
	SetPlayerSkin(playerid, playerData[playerid][pModel]);

	ResyncSkin(playerid);
	TogglePlayerControllable(playerid, false);
	SetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
	SetPlayerCameraPos(playerid, skinChangPosX[playerid], skinChangPosY[playerid], playerData[playerid][pPosZ] + 0.8);
	SetPlayerCameraLookAt(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ] + 0.2);

	SendClientMessage(playerid, COLOR_GRAD1, "* กดปุ่ม "EMBED_YELLOW"NUM4"EMBED_GRAD1" หรือ "EMBED_YELLOW"NUM6"EMBED_GRAD1" เพื่อเปลี่ยนตัวละครเป็นตัวถัดไป");
	SendClientMessage(playerid, COLOR_GRAD1, "* ถ้าคุณต้องการใช้สกินตัวละครนั้นให้กดปุ่ม "EMBED_YELLOW"Y"EMBED_GRAD1" และหรือ "EMBED_YELLOW"N"EMBED_GRAD1" เพื่อยกเลิก");
	SendClientMessage(playerid, COLOR_GRAD2, "คำแนะนำ: คุณสามารถพิมพ์ <, >, Y, N แทนการกดปุ่มได้");

	SetPVarInt(playerid, "ClothingType", type);
	SetPVarInt(playerid, "ClothingSelection", -1);

	OnAccountUpdate(playerid);

	return 1;
}

hook OnPlayerText(playerid, const text[]) {
	if (GetPVarType(playerid, "ClothingSelection")) {

		if (isequal(text, ">", true)) {

			new skinid = GetPVarInt(playerid, "ClothingSelection"), change = skinid;
			Clothing_GetNextSkin(change);
			if (change != -1 && skinid != change) {
				GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Skin~n~(ID:%d)", SkinSet[change]), 8000, 3);
				SetPlayerSkin(playerid, SkinSet[change]);
				playerData[playerid][pModel] = SkinSet[change];
			}
			else {
				GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Base skin~n~(ID:%d)", playerData[playerid][pModel]), 8000, 3);
				SetPlayerSkin(playerid, playerData[playerid][pModel]);
				playerData[playerid][pModel] = SkinSet[change];
			}
			SetPVarInt(playerid, "ClothingSelection", change);
			ResyncSkin(playerid);
			TogglePlayerControllable(playerid, false);
			SetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
			SetPlayerCameraPos(playerid, skinChangPosX[playerid], skinChangPosY[playerid], playerData[playerid][pPosZ] + 0.8);
			SetPlayerCameraLookAt(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ] + 0.2);
			OnAccountUpdate(playerid);
		}
		else if (isequal(text, "<", true)) {
			new skinid = GetPVarInt(playerid, "ClothingSelection"), change = skinid;
			Clothing_PreviousSkin(change);
			if (change != -1 && skinid != change) {
				GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Skin~n~(ID:%d)", SkinSet[change]), 8000, 3);
				SetPlayerSkin(playerid, SkinSet[change]);
				playerData[playerid][pModel] = SkinSet[change];
			}
			else {
				GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Base skin~n~(ID:%d)", playerData[playerid][pModel]), 8000, 3);
				SetPlayerSkin(playerid, playerData[playerid][pModel]);
				playerData[playerid][pModel] = SkinSet[change];
			}
			SetPVarInt(playerid, "ClothingSelection", change);
			ResyncSkin(playerid);
			TogglePlayerControllable(playerid, false);
			SetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
			SetPlayerCameraPos(playerid, skinChangPosX[playerid], skinChangPosY[playerid], playerData[playerid][pPosZ] + 0.8);
			SetPlayerCameraLookAt(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ] + 0.2);	
		
			OnAccountUpdate(playerid);
		}
		else if (isequal(text, "Y", true)) {

			if (GetPlayerMoneyEx(playerid) < CLOTHING_PRICE) {
				SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอจ่าย ($300)");
				return -1;
			}
			GivePlayerMoneyEx(playerid, -CLOTHING_PRICE);
			playerData[playerid][pModel] = GetPlayerSkin(playerid);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);
			DeletePVar(playerid, "ClothingSelection");
			// ResyncSkin(playerid);
			GameTextForPlayer(playerid, "~g~UPDATED YOUR SKIN!", 2500, 4);

			OnAccountUpdate(playerid);
		}
		else if (isequal(text, "N", true)) {
			SetPlayerSkin(playerid, playerData[playerid][pWear] ? playerData[playerid][pWear] : playerData[playerid][pModel]);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);
			DeletePVar(playerid, "ClothingSelection");
			ResyncSkin(playerid);
			GameTextForPlayer(playerid, "", 100, 3);
		}
		return -1;
	}
	return 0;
}
 
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) { 
	if (GetPVarType(playerid, "ClothingSelection")) {
		if (PRESSED(KEY_ANALOG_LEFT)) {
			new skinid = GetPVarInt(playerid, "ClothingSelection"), change = skinid;
			Clothing_PreviousSkin(change);
			if (change != -1 && skinid != change) {
				GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Skin~n~(ID:%d)", SkinSet[change]), 8000, 3);
				SetPlayerSkin(playerid, SkinSet[change]);
				playerData[playerid][pModel] = SkinSet[change];
			}
			else {
				GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Base skin~n~(ID:%d)", playerData[playerid][pModel]), 8000, 3);
				SetPlayerSkin(playerid, playerData[playerid][pModel]);
				playerData[playerid][pModel] = SkinSet[change];
			}
			SetPVarInt(playerid, "ClothingSelection", change);
			ResyncSkin(playerid);
			TogglePlayerControllable(playerid, false);
			SetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
			SetPlayerCameraPos(playerid, skinChangPosX[playerid], skinChangPosY[playerid], playerData[playerid][pPosZ] + 0.8);
			SetPlayerCameraLookAt(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ] + 0.2);
			OnAccountUpdate(playerid);
		}
		else if (PRESSED(KEY_ANALOG_RIGHT)) {
			new skinid = GetPVarInt(playerid, "ClothingSelection"), change = skinid;
			Clothing_GetNextSkin(change);
			if (change != -1 && skinid != change) {
				GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Skin~n~(ID:%d)", SkinSet[change]), 8000, 3);
				SetPlayerSkin(playerid, SkinSet[change]);
				playerData[playerid][pModel] = SkinSet[change];
			}
			else {
				GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Base skin~n~(ID:%d)", playerData[playerid][pModel]), 8000, 3);
				SetPlayerSkin(playerid, playerData[playerid][pModel]);
			}
			SetPVarInt(playerid, "ClothingSelection", change);
			TogglePlayerControllable(playerid, false);
			SetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
			SetPlayerCameraPos(playerid, skinChangPosX[playerid], skinChangPosY[playerid], playerData[playerid][pPosZ] + 0.8);
			SetPlayerCameraLookAt(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ] + 0.2);
			OnAccountUpdate(playerid);
		}
		else if (RELEASED(KEY_YES)) {

			if (GetPlayerMoneyEx(playerid) < CLOTHING_PRICE) {
				SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอจ่าย ($300)");
				return -1;
			}
			GivePlayerMoneyEx(playerid, -CLOTHING_PRICE);
			playerData[playerid][pModel] = GetPlayerSkin(playerid);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);
			DeletePVar(playerid, "ClothingSelection");
			//ResyncSkin(playerid);
			GameTextForPlayer(playerid, "~g~UPDATED YOUR SKIN!", 2500, 4);
			OnAccountUpdate(playerid);
		}
		else if (RELEASED(KEY_NO)) {
			SetPlayerSkin(playerid, playerData[playerid][pWear] ? playerData[playerid][pWear] : playerData[playerid][pModel]);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);
			DeletePVar(playerid, "ClothingSelection");
			ResyncSkin(playerid);
			GameTextForPlayer(playerid, "", 100, 3);
			OnAccountUpdate(playerid);
		}
	}
	return 1;
}

Clothing_GetNextSkin(&current) {
	if (current+1 >= sizeof (SkinSet)) {
		current = -1;
		return 1;
	}
	for (new i = current+1; i < sizeof (SkinSet); i ++)
	{
		if(SkinSet[i]) {
			current = i;
			break;
		}
	}
	return 1;
}

Clothing_PreviousSkin(&current) {
	if (current-1 == -1) {
		current = -1;
		return 1;
	}
	else if (current-1 <= -2) {
		current = sizeof(SkinSet) - 1;
		return 1;
	}
	for (new i = current-1; i >= 0; i --)
	{
		if(SkinSet[i]) {
			current = i;
			break;
		}
	}
	return 1;
}

ShowClothingMenu(playerid) {
	return Dialog_Show(playerid, BuySkinMenu, DIALOG_STYLE_LIST, "สกินตัวละคร ($300/ครั้ง)", "เลือกสกินตามหมายเลขที่ระบุ\nเลือกสกิน -> ชาย\nเลือกสกิน -> หญิง", "เลือก", "ปิด");
}


Dialog:BuySkinMenu(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		switch(listitem) {
			case 0: {
				Dialog_Show(playerid, BuySkinID, DIALOG_STYLE_INPUT, "สกินตัวละคร ($300/ครั้ง)", ""EMBED_WHITE"เราให้คุณเลือกสกินตัวละครโดย\nพิมพ์ไอดีที่คุณต้องการ\n"EMBED_LIGHTRED"(ใช้ได้ตั้งแต่ 1-311):", "เปลี่ยน", "กลับ");
			}
			default: {
				ChooseSkin(playerid, listitem - 1);
			}
		}
	}
	return 1;
}

isMaleSkin(skinid) {
	for(new i = 0; i != sizeof(CLOTHING_MALE); i++) {
		if (CLOTHING_MALE[i] == skinid) {
			return true;
		}
	}
	return false;
}

isFemaleSkin(skinid) {
	for(new i = 0; i != sizeof(CLOTHING_FEMALE); i++) {
		if (CLOTHING_FEMALE[i] == skinid) {
			return true;
		}
	}
	return false;
}

Dialog:BuySkinID(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new skinid;
		skinid = strval(inputtext);
		if(skinid < 1 || skinid > 311 || skinid == 74 || !(isMaleSkin(skinid) || isFemaleSkin(skinid)))
		{
			SendClientMessage(playerid, COLOR_GRAD1, "   ไอดีสกินต้องมากกว่า 1 และไม่เกิน 311");
			return Dialog_Show(playerid, BuySkinID, DIALOG_STYLE_INPUT, "สกินตัวละคร ($300/ครั้ง)", ""EMBED_WHITE"เราให้คุณเลือกสกินตัวละครโดย\nพิมพ์ไอดีที่คุณต้องการ\n"EMBED_LIGHTRED"(ใช้ได้ตั้งแต่ 1-311):\n\nบางสกินเราไม่อนุญาตให้ใช้ อย่างเช่น สกินของหน่วยงานรัฐ เป็นต้น", "เปลี่ยน", "กลับ");
		}
		else
		{
			if (GetPlayerMoneyEx(playerid) >= CLOTHING_PRICE) {
				SetPVarInt(playerid, "chooseClothing", skinid);
				return Dialog_Show(playerid, BuySkinConfirm, DIALOG_STYLE_MSGBOX, "การยืนยัน", "คุณแน่ใจหรือที่จะเปลี่ยนสกินตัวละครเป็นสกินไอดี: %d\n", "ยืนยัน", "กลับ", skinid);
			}
			else {
				SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอจ่าย ($300)");
			}
		}
	}
	ShowClothingMenu(playerid);
	return 1;
}

Dialog:BuySkinConfirm(playerid, response, listitem, inputtext[]) {
	if (response) {
		new skinid = GetPVarInt(playerid, "chooseClothing");
		SetPlayerSkin(playerid, skinid);
		GivePlayerMoneyEx(playerid, -CLOTHING_PRICE);
		playerData[playerid][pModel] = skinid;
		ResyncSkin(playerid);
		SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้เปลี่ยนสกินของคุณเป็นไอดี %d", skinid);
		OnAccountUpdate(playerid);
	}
	DeletePVar(playerid,"chooseClothing");
	return 1;
}