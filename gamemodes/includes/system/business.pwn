#include <YSI\y_hooks>

#define MAX_OWN_BIZ             			1
#define MAX_BIZS                 			100
#define	BIZ_WORLD			    			10000

#define BUSINESS_TYPE_NONE      			0
#define BUSINESS_TYPE_STORE     			1
#define BUSINESS_TYPE_GAS       			2
#define BUSINESS_TYPE_BANK					3
#define BUSINESS_TYPE_CLOTH					4
#define BUSINESS_TYPE_DEALERSHIP			5
#define BUSINESS_TYPE_RESTAURANT			6
#define BUSINESS_TYPE_ADVERTISEMENT			7

enum businessE
{
	bID,
	bPickup,
	Float:bPosX,
	Float:bPosY,
	Float:bPosZ,
	bPosInt,
	bPosWorld,
	Float:bIntX,
	Float:bIntY,
	Float:bIntZ,
	bIntInt,
	bIntWorld,
	bInfo[128],
	bOwner[MAX_PLAYER_NAME],
	bool:bOwned,
	bLocked,
	bPrice,
	bLevelbuy,
	bCash,
	bAreaExt,
	bAreaInt,
    bEntranceCost,
    bType,
	bMapIcon
};

new businessData[MAX_BIZS][businessE];

new Iterator:Iter_Business<MAX_BIZS>;

new nearBusiness_var[MAX_PLAYERS];
new insideBusinessID[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
	nearBusiness_var[playerid]=
	insideBusinessID[playerid]=-1;
	return 1;
}

hook OnGameModeInit() {
	mysql_tquery(dbCon, "SELECT * FROM `business`", "Business_Load", "");
	return 1;
}

forward Business_Load();
public Business_Load() {

    new
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_BIZS)
	{
        cache_get_value_name_int(i, "business_id", businessData[i][bID]);
        cache_get_value_name_float(i, "posX", businessData[i][bPosX]);
        cache_get_value_name_float(i, "posY", businessData[i][bPosY]);
        cache_get_value_name_float(i, "posZ", businessData[i][bPosZ]);
        cache_get_value_name_int(i, "posInt", businessData[i][bPosInt]);
		cache_get_value_name_int(i, "posWorld", businessData[i][bPosWorld]);

        cache_get_value_name_float(i, "extX", businessData[i][bIntX]);
        cache_get_value_name_float(i, "extY", businessData[i][bIntY]);
        cache_get_value_name_float(i, "extZ", businessData[i][bIntZ]);
        cache_get_value_name_int(i, "extInt", businessData[i][bIntInt]);
		cache_get_value_name_int(i, "extWorld", businessData[i][bIntWorld]);
				
        cache_get_value_name(i, "info", businessData[i][bInfo], 128);
		cache_get_value_name(i, "owner", businessData[i][bOwner], MAX_PLAYER_NAME);

        cache_get_value_name_bool(i, "owned", businessData[i][bOwned]);
        cache_get_value_name_int(i, "locked", businessData[i][bLocked]);
        cache_get_value_name_int(i, "marketPrice", businessData[i][bPrice]);
        cache_get_value_name_int(i, "levelBuy", businessData[i][bLevelbuy]);
		cache_get_value_name_int(i, "cash", businessData[i][bCash]);
        cache_get_value_name_int(i, "entranceCost", businessData[i][bEntranceCost]);
        cache_get_value_name_int(i, "type", businessData[i][bType]);

        Iter_Add(Iter_Business, i);

		businessData[i][bPickup] = CreateDynamicPickup(businessData[i][bOwned] ? 1239 : 1272, 23, businessData[i][bPosX], businessData[i][bPosY], businessData[i][bPosZ], 0, 0);
        Streamer_SetIntData(STREAMER_TYPE_PICKUP, businessData[i][bPickup], E_STREAMER_EXTRA_ID, i);

		businessData[i][bAreaExt] = CreateDynamicSphere(businessData[i][bPosX], businessData[i][bPosY], businessData[i][bPosZ], 3.0, businessData[i][bPosWorld], businessData[i][bPosInt]); // The business exterior.
		Streamer_SetIntData(STREAMER_TYPE_AREA, businessData[i][bAreaExt], E_STREAMER_EXTRA_ID, i);

        if(businessData[i][bIntX] != 0.0 && businessData[i][bIntY] != 0.0) {
			businessData[i][bAreaInt] = CreateDynamicSphere(businessData[i][bIntX], businessData[i][bIntY], businessData[i][bIntZ], 3.0, businessData[i][bIntWorld], businessData[i][bIntInt]); // The business interior.
			Streamer_SetIntData(STREAMER_TYPE_AREA, businessData[i][bAreaInt], E_STREAMER_EXTRA_ID, i);
		}

		BusinessMapIcon(i);

		/*format(msg, sizeof(msg), "SELECT * FROM `business_furnitures` WHERE `businessid` = %d", businessData[i][bID]);
		mysql_pquery(dbCon, msg, "OnBusinessFurnituresLoad", "i", i);*/
	}

    printf("Business loaded (%d/%d)", Iter_Count(Iter_Business), MAX_BIZS);
	return 1;
}

Business_Save(businessid)
{
    if(Iter_Contains(Iter_Business, businessid)) {
        new query[MAX_STRING];
        MySQLUpdateInit("business", "business_id", businessData[businessid][bID], MYSQL_UPDATE_TYPE_THREAD); 
        MySQLUpdateInt(query, "business_id", businessData[businessid][bID]);
        MySQLUpdateFlo(query, "posX", businessData[businessid][bPosX]);
        MySQLUpdateFlo(query, "posY", businessData[businessid][bPosY]);
        MySQLUpdateFlo(query, "posZ", businessData[businessid][bPosZ]);
        MySQLUpdateInt(query, "posInt", businessData[businessid][bPosInt]);
		MySQLUpdateInt(query, "posWorld", businessData[businessid][bPosWorld]);
        MySQLUpdateFlo(query, "extX", businessData[businessid][bIntX]);
        MySQLUpdateFlo(query, "extY", businessData[businessid][bIntY]);
        MySQLUpdateFlo(query, "extZ", businessData[businessid][bIntZ]);
        MySQLUpdateInt(query, "extInt", businessData[businessid][bIntInt]);
		MySQLUpdateInt(query, "extWorld", businessData[businessid][bIntWorld]);
        MySQLUpdateStr(query, "info", businessData[businessid][bInfo]);
		MySQLUpdateStr(query, "owner", businessData[businessid][bOwner]);
        MySQLUpdateBool(query, "owned", businessData[businessid][bOwned]);
        MySQLUpdateInt(query, "locked", businessData[businessid][bLocked]);
        MySQLUpdateInt(query, "marketPrice", businessData[businessid][bPrice]);
        MySQLUpdateInt(query, "levelBuy", businessData[businessid][bLevelbuy]);
		MySQLUpdateInt(query, "cash", businessData[businessid][bCash]);
        MySQLUpdateInt(query, "entranceCost", businessData[businessid][bEntranceCost]);
        MySQLUpdateInt(query, "type", businessData[businessid][bType]);
		MySQLUpdateFinish(query);
    }
	return 1;
}

hook OP_EnterDynamicArea(playerid, areaid)
{
	new b = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID);
	if(Iter_Contains(Iter_Business, b)) {
		if(areaid == businessData[b][bAreaInt] ||  areaid == businessData[b][bAreaExt]) {
			nearBusiness_var[playerid] = b;
		}
	}
	return 1;
}

hook OP_LeaveDynamicArea(playerid, areaid) {
	new b = Streamer_GetIntData(STREAMER_TYPE_AREA, areaid, E_STREAMER_EXTRA_ID);
	if(Iter_Contains(Iter_Business, b)) {
		if(areaid == businessData[b][bAreaInt] ||  areaid == businessData[b][bAreaExt]) {
	        nearBusiness_var[playerid] = -1;
		}
	}
	return 1;
}

CMD:businesshelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
	SendClientMessage(playerid, COLOR_WHITE,"*** Business HELP *** พิมพ์คำสั่งสำหรับความช่วยเหลือเพิ่มเติม");
	SendClientMessage(playerid, COLOR_GRAD3,"*** Business *** /mybusiness");
	SendClientMessage(playerid, COLOR_GRAD3,"*** Business *** /lock");
	// SendClientMessage(playerid, COLOR_GRAD3,"*** Other *** /furniture /grantbuild");
	return 1;
}

CMD:mybusiness(playerid, params[])
{
    new option[10], param2[128];
	new business = nearBusiness_var[playerid] == -1 ? insideBusinessID[playerid] : nearBusiness_var[playerid];

	if (business != -1 && IsBusinessOwner(playerid, business))
	{
		if(sscanf(params, "s[10]S()[128]", option, param2)) {
			SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /mybusiness [ตัวเลือก]");
			SendClientMessage(playerid, COLOR_GRAD2, "[ตัวเลือก] เงินสด | ข้อมูล");
			return 1;
		}
    	if(!strcmp(option, "ข้อมูล", true))
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "ข้อมูลธุรกิจ: ธุรกิจไอดี - %d ราคาตลาด - $%d", businessData[business][bID], businessData[business][bPrice]);
		}
		else if(!strcmp(option, "เงินสด", true))
		{
			if (insideBusinessID[playerid] != -1 && insideBusinessID[playerid] == business) {
				new amount;
				if(sscanf(param2, "s[10]d", option, amount))
				{
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /mybusiness เงินสด [ถอน/ฝาก] [จำนวน]");
					SendClientMessageEx(playerid, COLOR_GRAD1, "คุณมี $%d อยู่ในกล่องเงินสด", businessData[business][bCash]);
					return 1;
				}

				if(!strcmp(option, "ถอน", true))
				{
					if (amount > businessData[business][bCash] || amount < 1) 
						return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้มีมากขนาดนั้น!");

					playerData[playerid][pCash] += amount;
					businessData[business][bCash] -= amount;

					SendClientMessageEx(playerid, COLOR_GRAD1, "คุณถอน $%d จากกล่องเงินสด ยอดคงเหลือ: $%d ", amount, businessData[business][bCash]);
				}
				else if(!strcmp(option, "ฝาก", true))
				{
					if (amount > playerData[playerid][pCash] || amount < 1)
						return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้มีมากขนาดนั้น!");

					playerData[playerid][pCash] -= amount;
					businessData[business][bCash] += amount;
					SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้วาง $%d ในกล่องเงินสดของคุณ ยอดรวมทั้งหมด: $%d ", amount, businessData[business][bCash]);
				}
				else {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /mybusiness เงินสด [ถอน/ฝาก] [จำนวน]");
				}
			}
			else SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องอยู่ในธุรกิจที่คุณเป็นเจ้าของ");
		}
		else {
			SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /mybusiness [ตัวเลือก]");
			SendClientMessage(playerid, COLOR_GRAD2, "[ตัวเลือก] เงินสด | ข้อมูล");
		}
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องอยู่ในบริเวณธุรกิจที่คุณเป็นเจ้าของ");
	return 1;
}

flags:businesscmds(CMD_MANAGEMENT);
CMD:businesscmds(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GRAD1, "คำสั่ง: /makebusiness, /businessenter, /businessexit, /gotobusiness, /editbusiness, /viewbusiness");
	return 1;
}

#define	BUSINESS_MAX_TYPE	7

ShowAllBusinessType(playerid) {
	SendClientMessage(playerid, COLOR_GRAD2, "[ประเภท] 0: ทั่วไป, 1: ร้านค้า, 2: ปั้มน้ำมัน, 3: ธนาคาร, 4: ร้านขายเสื้อผ้า, 5: ตัวแทนจำหน่ายรถยนต์, 6: ร้านอาหาร, 7: โฆษณา");
}

flags:makebusiness(CMD_MANAGEMENT);
CMD:makebusiness(playerid, params[])
{
	new businessid, buylevel, price, type, hinfo[128];
	if(sscanf(params,"ddds[128]", type, buylevel, price, hinfo)) {
        SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /makebusiness [ประเภท] [เลเวล] [ราคา] [รายละเอียด]");
        ShowAllBusinessType(playerid);
		return 1;
	}

	if(type < 0 || type > BUSINESS_MAX_TYPE) {
        SendClientMessageEx(playerid, COLOR_GRAD1, "   ประเภทต้องเป็น 0 ถึง %d เท่านั้น !!", BUSINESS_MAX_TYPE);
		return 1;
	}

    if((businessid = Iter_Free(Iter_Business)) != -1) {

		new 
			pint=GetPlayerInterior(playerid), 
			pworld=GetPlayerVirtualWorld(playerid);

		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);

		businessData[businessid][bPosX] = x;
		businessData[businessid][bPosY] = y;
		businessData[businessid][bPosZ] = z;
		businessData[businessid][bPosInt] = pint;
		businessData[businessid][bPosWorld] = pworld;
		businessData[businessid][bIntX] = 0.0;
		businessData[businessid][bIntY] = 0.0;
		businessData[businessid][bIntZ] = 0.0;
		businessData[businessid][bIntInt] = 0;
		businessData[businessid][bIntWorld] = 0;
		businessData[businessid][bPrice] = price;
		businessData[businessid][bOwned] = false;
		businessData[businessid][bLocked] = 1;
		businessData[businessid][bCash] = 0;
		businessData[businessid][bLevelbuy] = buylevel;

        businessData[businessid][bType] = type;
	
		format(businessData[businessid][bInfo], 128, hinfo);
		format(businessData[businessid][bOwner], MAX_PLAYER_NAME, "The State");

		if(IsValidDynamicArea(businessData[businessid][bAreaExt]))
			DestroyDynamicArea(businessData[businessid][bAreaExt]);

		businessData[businessid][bAreaExt] = CreateDynamicSphere(businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 3.0, businessData[businessid][bPosWorld], businessData[businessid][bPosInt]); // The business exterior.	
		Streamer_SetIntData(STREAMER_TYPE_AREA, businessData[businessid][bAreaExt], E_STREAMER_EXTRA_ID, businessid);

		businessData[businessid][bPickup] = CreateDynamicPickup(businessData[businessid][bOwned] ? 1239 : 1272, 23, businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 0, 0);
        Streamer_SetIntData(STREAMER_TYPE_PICKUP, businessData[businessid][bPickup], E_STREAMER_EXTRA_ID, businessid);

		new query[256];
		mysql_format(dbCon, query, sizeof query, "INSERT INTO `business` (`levelBuy`,`marketPrice`) VALUES(%d,%d)", buylevel, price);
		mysql_tquery(dbCon, query, "OnBusinessCreated", "ii", playerid, businessid);
    }
	else SendClientMessageEx(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"ไม่สามารถสร้างธุรกิจได้มากกว่านี้แล้ว จำกัดไว้ที่ "EMBED_ORANGE"%d", MAX_BIZS);

	return 1;
}

forward OnBusinessCreated(playerid, businessid);
public OnBusinessCreated(playerid, businessid)
{
	new insert_id = cache_insert_id();
	if(insert_id) {

		Iter_Add(Iter_Business, businessid);
		businessData[businessid][bID] = insert_id;
		Business_Save(businessid);

		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้สร้างธุรกิจไอดี %d", ReturnPlayerName(playerid), businessData[businessid][bID]);
	}
	else {
		if(IsValidDynamicArea(businessData[businessid][bAreaExt]))
			DestroyDynamicArea(businessData[businessid][bAreaExt]);
		if(IsValidDynamicPickup(businessData[businessid][bPickup]))
			DestroyDynamicPickup(businessData[businessid][bPickup]);
		SendClientMessage(playerid, COLOR_LIGHTRED, "ความผิดพลาด: "EMBED_WHITE"ไม่สามารถเพิ่มข้อมูลธุรกิจลงฐานข้อมูลได้ โปรดติดต่อ DEV");
	}
	return 1;
}

CountPlayerOwnBusiness(playerid)
{
	new hcount;
	foreach(new i : Iter_Business)
	{
		if(businessData[i][bOwned] && IsBusinessOwner(playerid, i)) hcount++;
	}
	return hcount;
}

CMD:buybiz(playerid, params[])
{
	new confirm[8], b = -1;

	if ((b = nearBusiness_var[playerid]) != -1 && !businessData[b][bOwned]) {

		new numbusiness = CountPlayerOwnBusiness(playerid);
		new extra_price = numbusiness * 10;
		new businessprice = businessData[b][bPrice];

		if(extra_price) 
			businessprice *= extra_price;

   		if(!sscanf(params, "s[8]", confirm) && !strcmp(confirm, "yes", true)) {

			if(numbusiness >= MAX_OWN_BIZ) return SendClientMessage(playerid, COLOR_GRAD1, "คุณมีธุรกิจเต็มจำนวนสูงสุดแล้ว ใช้ /sellbusiness เพื่อขายธุรกิจของคุณ");
			if(playerData[playerid][pLevel] < businessData[b][bLevelbuy]) return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่สามารถซื้ออสังหาริมทรัพย์นี้ได้!");
			if(GetPlayerMoneyEx(playerid) < businessprice || businessprice <= 0) return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่สามารถซื้ออสังหาริมทรัพย์นี้ได้!");

			playerData[playerid][pBusinessKey] = businessData[b][bID];
			businessData[b][bOwned] = true;
			businessData[b][bLocked] = 1;
			businessData[b][bCash] = 0;
			strmid(businessData[b][bOwner], ReturnPlayerName(playerid), 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
            GivePlayerMoneyEx(playerid, -businessprice);

			SendClientMessage(playerid, COLOR_WHITE, "ขอแสดงความยินดีในการสั่งซื้อใหม่ของคุณ!");
			SendClientMessage(playerid, COLOR_WHITE, "ใช้ /help เพื่อการตรวจสอบการเข้าถึงใหม่ของคุณ  !");

			Business_Save(b);

			return 1;
		}
	 	else
	 	{
	 	    SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /buybiz yes");
			SendClientMessageEx(playerid, COLOR_GREY, "ธุรกิจที่คุณกำลังซื้อราคา $%d", businessprice);
	 	}
 	}
	return 1;
}

CMD:sellbusiness(playerid, params[])
{
	new confirm[8], businessid = -1;
	if ((businessid = nearBusiness_var[playerid]) != -1) {
		if(IsBusinessOwner(playerid, businessid))
		{
			new businessprice = businessData[businessid][bPrice];
			new businesstax = floatround(businessprice / 100.0);
			if(!sscanf(params, "s[8]", confirm) && !strcmp(confirm, "yes", true)) {

				new strMSG[128];

				if(businessData[businessid][bCash] > 0)
				{
					playerData[playerid][pCash] += businessData[businessid][bCash];
					SendClientMessageEx(playerid, COLOR_GRAD2, "คุณได้รับเงินสดจากธุรกิจ $%d", businessData[businessid][bCash]);
				}
				businessData[businessid][bLocked] = 1;
				businessData[businessid][bOwned] = false;
				businessData[businessid][bCash] = 0;

				strmid(businessData[businessid][bOwner], "The State", 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);

				playerData[playerid][pCash] += businessprice-businesstax;

				//PlayerPlaySoundEx(playerid, 1052);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				format(strMSG, sizeof(strMSG), "~w~Congratulations~n~ You have sold your property for ~n~~g~$%d", businessprice-businesstax);
				GameTextForPlayer(playerid, strMSG, 10000, 3);
				SendClientMessageEx(playerid, COLOR_GRAD3, "ภาษีของรัฐ: $%d", businesstax);

				Business_Save(businessid);

				playerData[playerid][pBusinessKey] = 0;

				return 1;
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /sellbusiness yes");
				SendClientMessageEx(playerid, COLOR_GREY, "ธุรกิจที่คุณกำลังขายราคา $%d และมีภาษี $%d", businessprice, businesstax);
			}
		}
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องอยู่ในธุรกิจที่เป็นเจ้าของ");
	return 1;
}

Business_GetID(businessid) {
	foreach(new i : Iter_Business) {
		if(businessData[i][bID] == businessid) {
			return i;
		}
	}
	return -1;
}

flags:businessenter(CMD_MANAGEMENT);
CMD:businessenter(playerid,params[])
{
	new hid = -1;
	if(sscanf(params,"d",hid)) {
        return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /businessenter [ไอดีธุรกิจ]");
	}
	new businessid = Business_GetID(hid);
	
	if(!Iter_Contains(Iter_Business, businessid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   ไอดีธุรกิจไม่ถูกต้อง !!");

	new Float:px,Float:py,Float:pz;
	GetPlayerPos(playerid, px, py, pz);

	new 
		pint=GetPlayerInterior(playerid), 
		pworld=GetPlayerVirtualWorld(playerid);

	businessData[businessid][bPosX] = px;
	businessData[businessid][bPosY] = py;
	businessData[businessid][bPosZ] = pz;
	businessData[businessid][bPosInt] = pint;
	businessData[businessid][bPosWorld] = pworld;

	if(IsValidDynamicArea(businessData[businessid][bAreaExt]))
		DestroyDynamicArea(businessData[businessid][bAreaExt]);

	if(IsValidDynamicPickup(businessData[businessid][bPickup]))
		DestroyDynamicPickup(businessData[businessid][bPickup]);

	BusinessMapIcon(businessid);

	businessData[businessid][bAreaExt] = CreateDynamicSphere(businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 3.0, businessData[businessid][bPosWorld], businessData[businessid][bPosInt]); // The business exterior.	
	Streamer_SetIntData(STREAMER_TYPE_AREA, businessData[businessid][bAreaExt], E_STREAMER_EXTRA_ID, businessid);

	businessData[businessid][bPickup] = CreateDynamicPickup(businessData[businessid][bOwned] ? 1239 : 1272, 23, businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 0, 0);
    Streamer_SetIntData(STREAMER_TYPE_PICKUP, businessData[businessid][bAreaExt], E_STREAMER_EXTRA_ID, businessid);

	Business_Save(businessid);
	SendClientMessageEx(playerid, COLOR_GRAD1, "   ธุรกิจไอดี %d ถูกปรับทางเข้าใหม่เรียบร้อยแล้ว !!", businessData[businessid][bID]);
	return 1;
}

flags:businessexit(CMD_MANAGEMENT);
CMD:businessexit(playerid,params[])
{
	new hid = -1;
	if(sscanf(params,"d",hid)) {
        return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /businessexit [ไอดีธุรกิจ]");
	}
	new businessid = Business_GetID(hid);
	
	if(!Iter_Contains(Iter_Business, businessid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   ไอดีธุรกิจไม่ถูกต้อง !!");

	new Float:px,Float:py,Float:pz;
	GetPlayerPos(playerid, px, py, pz);

	businessData[businessid][bIntX] = px;
	businessData[businessid][bIntY] = py;
	businessData[businessid][bIntZ] = pz;
	businessData[businessid][bIntInt] = GetPlayerInterior(playerid);
	businessData[businessid][bIntWorld] = businessData[businessid][bID] + BIZ_WORLD;
	insideBusinessID[playerid] = businessid;
	SetPlayerVirtualWorld(playerid, businessData[businessid][bIntWorld]);

	if(IsValidDynamicArea(businessData[businessid][bAreaInt]))
		DestroyDynamicArea(businessData[businessid][bAreaInt]);

	businessData[businessid][bAreaInt] = CreateDynamicSphere(businessData[businessid][bIntX], businessData[businessid][bIntY], businessData[businessid][bIntZ], 3.0, businessData[businessid][bIntWorld], businessData[businessid][bIntInt]);
	Streamer_SetIntData(STREAMER_TYPE_AREA, businessData[businessid][bAreaInt], E_STREAMER_EXTRA_ID, businessid);

	Business_Save(businessid);
	SendClientMessageEx(playerid, COLOR_GRAD1, "   ธุรกิจไอดี %d ถูกปรับทางออกใหม่เรียบร้อยแล้ว !!", businessData[businessid][bID]);

	return 1;
}

IsPlayerInteractiveBusiness(playerid) {
	new id = -1;
	if ((id = insideBusinessID[playerid]) != -1 && Iter_Contains(Iter_Business, id)) return id;
	else {
		foreach(id : Iter_Business)
		{
			if(IsPlayerInRangeOfPoint(playerid, 25.0, businessData[id][bPosX],businessData[id][bPosY],businessData[id][bPosZ]) && businessData[id][bIntX] == 0.0 && businessData[id][bIntY] == 0.0) {
				return id;
			}
		}
	}
	return -1;
}

IsPlayerAtBusinessArea(playerid) {
	new id = nearBusiness_var[playerid];
	if (id != -1 && Iter_Contains(Iter_Business, id) && (IsPlayerInRangeOfPoint(playerid, 3.0, businessData[id][bIntX],businessData[id][bIntY],businessData[id][bIntZ]) || (IsPlayerInRangeOfPoint(playerid, 3.0, businessData[id][bPosX],businessData[id][bPosY],businessData[id][bPosZ]) && businessData[id][bPosX] != 0.0 && businessData[id][bPosY] != 0.0))) return true;	
	else return false;
}

IsPlayerAtBusinessEntrance(playerid) {
	new id = nearBusiness_var[playerid];
	if (id != -1 && Iter_Contains(Iter_Business, id) && IsPlayerInRangeOfPoint(playerid, 3.0, businessData[id][bPosX],businessData[id][bPosY],businessData[id][bPosZ]) && businessData[id][bPosX] != 0.0 && businessData[id][bPosY] != 0.0) return true;
	else return false;
}

IsPlayerAtBusinessExit(playerid) {
	new id = nearBusiness_var[playerid];
	if (id != -1 && Iter_Contains(Iter_Business, id) && IsPlayerInRangeOfPoint(playerid, 3.0, businessData[id][bIntX],businessData[id][bIntY],businessData[id][bIntZ])) return true;
	else return false;
}

Business_DynamicPos(playerid, world, &Float:X, &Float:Y, &Float:Z) {
	new id = insideBusinessID[playerid];
	if (Iter_Contains(Iter_Business, id) && businessData[id][bIntWorld] == world) {
		X = businessData[id][bIntX];
		Y = businessData[id][bIntY];
		Z = businessData[id][bIntZ];
		return id;
	}
	return -1;
}

PlayerLockBusiness(playerid) {
	new id = nearBusiness_var[playerid];
	if (id != -1 && Iter_Contains(Iter_Business, id) && (IsPlayerInRangeOfPoint(playerid, 3.0, businessData[id][bIntX],businessData[id][bIntY],businessData[id][bIntZ]) || (IsPlayerInRangeOfPoint(playerid, 3.0, businessData[id][bPosX],businessData[id][bPosY],businessData[id][bPosZ]) && businessData[id][bPosX] != 0.0 && businessData[id][bPosY] != 0.0)))
	{
		if(businessData[id][bLocked] == 1)
		{
			businessData[id][bLocked] = 0;
			GameTextForPlayer(playerid, "~w~Business ~g~Unlocked", 5000, 6);
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		}
		else {
			businessData[id][bLocked] = 1;
			GameTextForPlayer(playerid, "~w~Business ~r~Locked", 5000, 6);
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		}
		Business_Save(id);
	}
	return 1;
}

PlayerEnterNearestBusiness(playerid) {
	new id = nearBusiness_var[playerid];
	if (id != -1 && Iter_Contains(Iter_Business, id) && businessData[id][bPosX] != 0.0 && businessData[id][bPosY] != 0.0)
	{
		
		if(businessData[id][bLocked] == 1) 
			return GameTextForPlayer(playerid, "~r~Locked", 5000, 1);

		if (businessData[id][bIntX] != 0.0 && businessData[id][bIntY] != 0.0) {
			SetPlayerPos(playerid,businessData[id][bIntX],businessData[id][bIntY],businessData[id][bIntZ]);
			SetPlayerInterior(playerid,businessData[id][bIntInt]);
			SetPlayerVirtualWorld(playerid,businessData[id][bIntWorld]);
			playerData[playerid][pInterior] = businessData[id][bIntInt];
			playerData[playerid][pVWorld] = businessData[id][bIntWorld];
			insideBusinessID[playerid] = id;

			if(playerData[playerid][pBusinessKey] == businessData[id][bID]) return GameTextForPlayer(playerid, sprintf("~w~Welcome to ~n~%s", businessData[id][bInfo]), 5000, 1);
			else {
				ShowBusinessMessage(playerid, businessData[id][bType]);
			}
			return 1;
		}

		if(playerData[playerid][pBusinessKey] == businessData[id][bID]) return GameTextForPlayer(playerid, sprintf("~w~Welcome to ~n~%s", businessData[id][bInfo]), 5000, 1);
		else {
			ShowBusinessMessage(playerid, businessData[id][bType]);
		}
	}
	return 1;
}

ShowBusinessMessage(playerid, biztype) {
	switch(biztype) {
		case BUSINESS_TYPE_STORE: {
			SendClientMessage(playerid, COLOR_GRAD4,"*** ธุรกิจร้านค้า ***  /buy (ซื้อของ)");
		}
		case BUSINESS_TYPE_BANK: {
			SendClientMessage(playerid, COLOR_GRAD4,"*** ธนาคาร ***  /bank (กล่องอย่างง่าย), /balance (เช็คเงิน), /deposit (ฝาก)");
			SendClientMessage(playerid, COLOR_GRAD4,"*** ธนาคาร ***  /withdraw (ถอน), /transfer (โอน), /savings (ออมทรัพย์)");
		}
		case BUSINESS_TYPE_GAS: {
			SendClientMessage(playerid, COLOR_GRAD4,"*** ธุรกิจปั้มน้ำมัน ***  /fill (เติมน้ำมัน)");
		}
		case BUSINESS_TYPE_CLOTH: {
			SendClientMessage(playerid, COLOR_GRAD4,"*** ธุรกิจเสื้อผ้า ***  /buy (เปลี่ยนสกินตัวละคร $300)");
		}
		case BUSINESS_TYPE_DEALERSHIP: {
			SendClientMessage(playerid, COLOR_GRAD4,"*** ธุรกิจตัวแทนจำหน่ายรถยนต์ ***  /buy");
		}
		case BUSINESS_TYPE_RESTAURANT: {
			SendClientMessage(playerid, COLOR_GRAD4,"*** ธุรกิจร้านอาหาร ***  /eat");
		}
		case BUSINESS_TYPE_ADVERTISEMENT: {
			SendClientMessage(playerid, COLOR_GRAD4,"*** ธุรกิจโฆณษา ***  (/ad)vert, (/c)ompany(ad)vert");
		}
	}
	return 1;
}

PlayerExitBusiness(playerid) {
	new id = nearBusiness_var[playerid];
	if (id != -1 && Iter_Contains(Iter_Business, id) && IsPlayerInRangeOfPoint(playerid, 3.0, businessData[id][bIntX],businessData[id][bIntY],businessData[id][bIntZ])) {

		SetCameraBehindPlayer(playerid);
		SetPlayerPos(playerid,businessData[id][bPosX],businessData[id][bPosY],businessData[id][bPosZ]);
		SetPlayerInterior(playerid,businessData[id][bPosInt]);
		SetPlayerVirtualWorld(playerid,businessData[id][bPosWorld]);
		playerData[playerid][pInterior] = businessData[id][bPosInt];
		playerData[playerid][pVWorld] = businessData[id][bPosWorld];
		insideBusinessID[playerid] = -1;
		//grantbuild[playerid]=-1;
	}
	return 1;
}


flags:gotobusiness(CMD_ADM_2);
CMD:gotobusiness(playerid,params[])
{
	new hid = -1;
	if(sscanf(params,"d",hid)) {
        return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /gotobusiness [ไอดีธุรกิจ]");
	}
	new businessid = Business_GetID(hid);
	
	if(!Iter_Contains(Iter_Business, businessid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   ไอดีธุรกิจไม่ถูกต้อง !!");


	SetPlayerVirtualWorld(playerid, businessData[businessid][bPosWorld]);
	SetPlayerInterior(playerid, businessData[businessid][bPosInt]);
	SetPlayerPos(playerid, businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ]);

	SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณได้วาร์ปไปยังธุรกิจไอดี %d", businessData[businessid][bID]);
	
	return 1;
}

IsBusinessOwner(playerid, businessid)
{
	if(IsPlayerConnected(playerid) && businessid != -1 && Iter_Contains(Iter_Business, businessid)) {
		if (businessData[businessid][bOwned] && !strcmp(ReturnPlayerName(playerid), businessData[businessid][bOwner], true))
			return 1;
	}
	return 0;
}

hook OP_PickUpDynamicPickup(playerid, pickupid)
{
	new bizid = Streamer_GetIntData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_EXTRA_ID);

    if(Iter_Contains(Iter_Business, bizid)) {
            
    	if(businessData[bizid][bPickup] == pickupid) {

            new str[128];
    		if(businessData[bizid][bOwned]) {
                if (businessData[bizid][bIntX] == 0.0 && businessData[bizid][bIntY] == 0.0) {
					switch(businessData[bizid][bType]) {
						case BUSINESS_TYPE_ADVERTISEMENT: {
							format(str, sizeof(str), "~w~%s~w~~n~Owner : %s~n~~w~Level : %d ~n~type /ad or /cad",businessData[bizid][bInfo],businessData[bizid][bOwner]);
						}
						case BUSINESS_TYPE_GAS: {
							format(str, sizeof(str), "~w~%s~w~~n~Owner : %s~n~Entrance Fee : ~g~$%d ~w~Level : %d ~n~type /fill",businessData[bizid][bInfo],businessData[bizid][bOwner],businessData[bizid][bEntranceCost]);
						}					
						default: {
							format(str, sizeof(str), "~w~%s~w~~n~Owner : %s~n~Entrance Fee : ~g~$%d ~w~Level : %d ~n~type /buy",businessData[bizid][bInfo],businessData[bizid][bOwner],businessData[bizid][bEntranceCost]);
						}
					}
				}
				else {
					format(str, sizeof(str), "~w~%s~w~~n~Owner : %s~n~Entrance Fee : ~g~$%d ~w~Level : %d ~n~to enter type /enter",businessData[bizid][bInfo],businessData[bizid][bOwner],businessData[bizid][bEntranceCost]);
				}
            }
            else format(str, sizeof(str), "~w~%s~w~~n~This Business is for sale~n~Cost: ~g~$%d ~w~Level : %d ~n~to buy this Business type /buybiz",businessData[bizid][bInfo],businessData[bizid][bPrice],businessData[bizid][bLevelbuy]);
    		Mobile_GameTextForPlayer(playerid, str, 5000, 3);
    		
    		return 1;
    	}
    }
	return 1;
}

Store_Interactive(playerid, id, const params[]) {

    new itemid;
	if (Iter_Contains(Iter_Business, id)) {

		switch(businessData[id][bType]) {
			case BUSINESS_TYPE_CLOTH: {
				ShowClothingMenu(playerid);
			}
			case BUSINESS_TYPE_DEALERSHIP: {
				ShowPlayerDealershipMenu(playerid);
			}
			case BUSINESS_TYPE_RESTAURANT: {
				ShowPlayerFoodMenu(playerid);
			}
			case BUSINESS_TYPE_STORE: {
				if (sscanf(params, "d", itemid)) {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /buy [หมายเลขไอเท็ม]");
					SendClientMessage(playerid, COLOR_GREEN, "|_______ ร้านค้า _______|");
					SendClientMessage(playerid, 0xFDBFFFFF, "| 1. โทรโข่ง x20 $5000     		2. น้ำมันกระป๋อง $250 (3 แกลอน)");
					SendClientMessage(playerid, 0xFDBFFFFF, "| 3. ชะแลง $1500 (ไม่เซฟ)  		4. วิทยุ $3000  5. ลำโพง Boombox $20,000");
					SendClientMessage(playerid, 0xFDBFFFFF, "| 6. เชือก x5 $8,000        		7. น้ำดื่ม x5 $200");
					SendClientMessage(playerid, 0xFDBFFFFF, "| 8. ข้าวกล่องพกพา x5 $2,000        9. น้ำโค้ก x5 $500");
					return 1;
				}

				switch(itemid) {
					case 1: {
						if (GetPlayerMoneyEx(playerid) < 5000)
							return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอซื้อค่ะ! ($5000)");

						GivePlayerMoneyEx(playerid, -5000);
						playerData[playerid][pItemOOC] += 20;
						SendClientMessage(playerid, COLOR_GRAD4, "คุณได้ซื้อโทรโข่งจำนวน 20 ชิ้น");
						SendClientMessage(playerid, COLOR_WHITE, "ใช้ /ooc เพื่อพูดคุยทั่วทั้งเซิร์ฟเวอร์ !");
					}
					case 2: {
						if (GetPlayerMoneyEx(playerid) < 250)
							return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอซื้อค่ะ! ($250)");

						GivePlayerMoneyEx(playerid, -250);
		
						playerData[playerid][pItemGasCan]+=3;
						SendClientMessage(playerid, COLOR_GREEN, "คุณได้ซื้อถังน้ำมัน 3 แกลลอน");
						SendClientMessage(playerid, COLOR_WHITE, "ใช้ /gascan เพื่อเติมน้ำมัน");
					}
					case 3: {

						if (playerData[playerid][pItemCrowbar]) 
							return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีชะแลงอยู่กับตัวแล้ว!");

						if (GetPlayerMoneyEx(playerid) < 1500)
							return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอซื้อค่ะ! ($1500)");

						GivePlayerMoneyEx(playerid, -1500);
		
						playerData[playerid][pItemCrowbar]=1;
						SendClientMessage(playerid, COLOR_GREEN, "คุณได้ซื้อชะแลง 1 ชิ้น");
						SendClientMessage(playerid, COLOR_WHITE, "ใช้ /lock breakin เพื่อปลดล็อกรถ");
					}
					case 4: {

						if (playerData[playerid][pRadio]) 
							return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีวิทยุแล้ว !!");

						if (GetPlayerMoneyEx(playerid) < 3000)
							return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอซื้อค่ะ! ($3000)");

						GivePlayerMoneyEx(playerid, -3000);
		
						playerData[playerid][pRadio] = 1;

						SendClientMessage(playerid, COLOR_GREEN, "คุณได้ซื้อวิทยุ 1 เครื่องเสียง");
						SendClientMessage(playerid, COLOR_WHITE, "ใช้ /radiohelp เพื่อศึกษาคำสั่งการใช้งานวิทยุ");
					}
					case 5: {

						if (playerData[playerid][pBoombox]) 
							return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมี Boombox แล้ว !!");

						if (GetPlayerMoneyEx(playerid) < 20000)
							return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอซื้อค่ะ! ($20,000)");

						GivePlayerMoneyEx(playerid, -20000);
						playerData[playerid][pBoombox] = 1;
						OnAccountUpdate(playerid);

						SendClientMessage(playerid, COLOR_GREEN, "คุณได้ซื้อ Boombox 1 เครื่องเสียง");
						SendClientMessage(playerid, COLOR_WHITE, "ใช้ /boombox เพื่อเปิดเพลงให้คนรอบข้างฟัง !!");
					}
					case 6: {

						if (GetPlayerMoneyEx(playerid) < 10000)
							return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอซื้อค่ะ! ($10,000)");

						if (playerData[playerid][pPlayingHours] < 50)
							return SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องมีชั่วโมงออนไลน์มากกว่า 50 ถึงจะสามารถซื้อได้");

						GivePlayerMoneyEx(playerid, -10000);
						playerData[playerid][pTie] += 5;
						OnAccountUpdate(playerid);

						SendClientMessage(playerid, COLOR_GREEN, "คุณได้ซื้อเชือกจำนวน 5 เส้น");
						SendClientMessage(playerid, COLOR_WHITE, "ใช้ /tie เพื่อใช้เชือกมัดกับผู้เล่นคนอื่น !!");
					}
					case 7: {

						if (GetPlayerMoneyEx(playerid) < 200)
							return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอซื้อค่ะ! ($200)");

						if (playerData[playerid][pThirst] >= 70)
							return SendClientMessage(playerid, COLOR_GRAD1, "คุณยังไม่กระหายน้ำตอนนี้");

						GivePlayerMoneyEx(playerid, -200);
						playerData[playerid][pThirst] += 30;
						OnAccountUpdate(playerid);

						SendClientMessage(playerid, COLOR_GREEN, "คุณได้ซื้อน้ำดื่ม, แล้วเปิดฝาน้ำเพื่อดื่มเรียบร้อยแล้ว");
						//SendClientMessage(playerid, COLOR_WHITE, "ใช้ /tie เพื่อใช้เชือกมัดกับผู้เล่นคนอื่น !!");
					}
					case 8: {

						if (GetPlayerMoneyEx(playerid) < 2000)
							return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอซื้อค่ะ! ($2,000)");

						if (playerData[playerid][pPizza] >= 5)
							return SendClientMessage(playerid, COLOR_GRAD1, "	คุณได้พกพาข้าวกล่องสูงสุดที่คุณจะสามารถพกพาได้แล้ว (Max 5)");

						GivePlayerMoneyEx(playerid, -2000);
						playerData[playerid][pPizza] = 5;
						OnAccountUpdate(playerid);

						SendClientMessage(playerid, COLOR_GREEN, "คุณได้ซื้อข้าวกล่องแล้ว, หากคุณต้องการจะตรวจสอบจำนวนข้าวกล่องและน้ำโค้กของคุณพิมพ์ /inv");
						//SendClientMessage(playerid, COLOR_WHITE, "ใช้ /tie เพื่อใช้เชือกมัดกับผู้เล่นคนอื่น !!");
					}
					case 9: {

						if (GetPlayerMoneyEx(playerid) < 500)
							return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอซื้อค่ะ! ($500)");

						if (playerData[playerid][pDrink] >= 5)
							return SendClientMessage(playerid, COLOR_GRAD1, "	คุณได้พกพาน้ำโค้กสูงสุดที่คุณจะสามารถพกพาได้แล้ว (Max 5)");

						GivePlayerMoneyEx(playerid, -500);
						playerData[playerid][pDrink] = 5;
						OnAccountUpdate(playerid);

						SendClientMessage(playerid, COLOR_GREEN, "คุณได้ซื้อน้ำโค้กแล้ว, หากคุณต้องการจะตรวจสอบจำนวนข้าวกล่องและน้ำโค้กของคุณพิมพ์ /inv");
						//SendClientMessage(playerid, COLOR_WHITE, "ใช้ /tie เพื่อใช้เชือกมัดกับผู้เล่นคนอื่น !!");
					}
					default: {
						SendClientMessage(playerid, COLOR_LIGHTRED, "   ขออภัยเราไม่มีสินค้าชิ้นนี้ค่ะ!");
					}
				}
			}
			case BUSINESS_TYPE_GAS: {
				if (IsPlayerInAnyVehicle(playerid)) {
					new string[256], vehicleid = GetPlayerVehicleID(playerid);
					new Float:maxfuel = GetVehicleDataFuel(GetVehicleModel(vehicleid));
					new Float:fueladd = maxfuel - vehicleData[vehicleid][vFuel];
					format(string, sizeof(string), ""EMBED_WHITE"เชื้อเพลิงในปัจจุบัน:"EMBED_YELLOW"%.6f"EMBED_WHITE"/"EMBED_YELLOW"%.6f"EMBED_WHITE"( สูงสุด )\n\tจำนวนที่เพิ่ม:"EMBED_YELLOW"%.6f\n\t"EMBED_WHITE"ราคา:"EMBED_YELLOW"%s", vehicleData[vehicleid][vFuel], maxfuel, fueladd, FormatNumber(floatround(fueladd*float(FUEL_PRICE), floatround_ceil)));
					Dialog_Show(playerid, FuelRefill, DIALOG_STYLE_MSGBOX, "ซื้อน้ำมันเชื้อเพลิง:", string, "จ่าย", "ยกเลิก");
				} else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ในยานพาหนะ");
			}
		}
	}

    return 1;
}

Business_GetInsideID(playerid) {
	return insideBusinessID[playerid];
}

IsPlayerAtGasStation(playerid) {
	
	foreach(new i : Iter_Business)
	{
		if(businessData[i][bType] == BUSINESS_TYPE_GAS) {
			if (IsPlayerInRangeOfPoint(playerid, 2.5, businessData[i][bPosX],businessData[i][bPosY],businessData[i][bPosZ])) {
				return true;
			}
		}
	}
	return false;
}

IsPlayerAtBank(playerid) {
	foreach(new i : Iter_Business)
	{
		if(businessData[i][bType] == BUSINESS_TYPE_BANK) {
			if (IsPlayerInRangeOfPoint(playerid, 25.0, businessData[i][bIntX],businessData[i][bIntY],businessData[i][bIntZ])) {
				return true;
			}
		}
	}
	return false;
}

IsPlayerAtDealership(playerid) {
	
	foreach(new i : Iter_Business)
	{
		if(businessData[i][bType] == BUSINESS_TYPE_DEALERSHIP) {
			if (IsPlayerInRangeOfPoint(playerid, 25.0, businessData[i][bPosX],businessData[i][bPosY],businessData[i][bPosZ])) {
				return i;
			}
		}
	}
	return -1;
}

IsPlayerAtAdvert(playerid) {
	
	foreach(new i : Iter_Business)
	{
		if(businessData[i][bType] == BUSINESS_TYPE_ADVERTISEMENT) {
			if (IsPlayerInRangeOfPoint(playerid, 25.0, businessData[i][bPosX],businessData[i][bPosY],businessData[i][bPosZ])) {
				return i;
			}
		}
	}
	return -1;
}

Business_SetInside(playerid, value) {
	insideBusinessID[playerid] = value;
}

BusinessMapIcon(businessid) {
	if(Iter_Contains(Iter_Business, businessid)) {

		if (IsValidDynamicMapIcon(businessData[businessid][bMapIcon])) {
			DestroyDynamicMapIcon(businessData[businessid][bMapIcon]);
		}

		switch(businessData[businessid][bType]) {
			case BUSINESS_TYPE_STORE: {
				businessData[businessid][bMapIcon] = CreateDynamicMapIcon(businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 17, 0xFFFFFFFF, 0, 0);
			}
			case BUSINESS_TYPE_GAS: {
				businessData[businessid][bMapIcon] = CreateDynamicMapIcon(businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 63, 0xFFFFFFFF, 0, 0);
			}
			case BUSINESS_TYPE_BANK: {
				businessData[businessid][bMapIcon] = CreateDynamicMapIcon(businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 52, 0xFFFFFFFF, 0, 0);
			}
			case BUSINESS_TYPE_CLOTH: {
				businessData[businessid][bMapIcon] = CreateDynamicMapIcon(businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 45, 0xFFFFFFFF, 0, 0);
			}
			case BUSINESS_TYPE_DEALERSHIP: {
				businessData[businessid][bMapIcon] = CreateDynamicMapIcon(businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 11, 0xFFFFFFFF, 0, 0);
			}
			case BUSINESS_TYPE_RESTAURANT: {
				businessData[businessid][bMapIcon] = CreateDynamicMapIcon(businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 50, 0xFFFFFFFF, 0, 0);
			}
			case BUSINESS_TYPE_ADVERTISEMENT: {
				businessData[businessid][bMapIcon] = CreateDynamicMapIcon(businessData[businessid][bPosX], businessData[businessid][bPosY], businessData[businessid][bPosZ], 56, 0xFFFFFFFF, 0, 0);
			}
		}
	}
}

flags:editbusiness(CMD_MANAGEMENT);
CMD:editbusiness(playerid, params[])
{
	new text[160], type;

	if(sscanf(params,"ds[160]", type, text)) {
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /editbusiness [ตัวเลือก] [ค่า]");
		SendClientMessage(playerid, COLOR_GRAD2, "ตัวเลือกที่ใช้ได้: 1-ชื่อ, 2-เจ้าของ, 3-เป็นเจ้าของ, 4-ล็อก, 5-ราคา, 6-เลเวลที่ซื้อได้, 7-เงินในธุรกิจ");
		SendClientMessage(playerid, COLOR_GRAD2, "ตัวเลือกที่ใช้ได้: 8-ค่าเข้า, 9-ประเภท");
		return 1;
	}

	new business = nearBusiness_var[playerid] == -1 ? insideBusinessID[playerid] : nearBusiness_var[playerid];
	if (business != -1 && Iter_Contains(Iter_Business, business))
	{
		switch(type) {
			case 1: {
				new info[128];
				if(sscanf(text,"s[128]", info)) {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /editbusiness ชื่อ [ชื่อธุรกิจ]");
					return 1;
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนชื่อธุรกิจ #%d จาก %s เป็น %s", ReturnPlayerName(playerid), businessData[business][bID], businessData[business][bInfo], info);
				format(businessData[business][bInfo], 128, info);
				Business_Save(business);
			}
			case 2: {
				new name[MAX_PLAYER_NAME];
				if(sscanf(text,"s[24]", name)) {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /editbusiness เจ้าของ [ชื่อเจ้าของ]");
					return 1;
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนชื่อเจ้าของธุรกิจ #%d จาก %s เป็น %s", ReturnPlayerName(playerid), businessData[business][bID], businessData[business][bOwner], name);
				format(businessData[business][bOwner], MAX_PLAYER_NAME, name);
				Business_Save(business);
			}
			case 3: {
				new status;
				if(sscanf(text,"i", status)) {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /editbusiness เป็นเจ้าของ [0-ไม่มีเจ้าของ, 1-มีเจ้าของ]");
					return 1;
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนการเป็นเจ้าของธุรกิจ #%d เป็น %s", ReturnPlayerName(playerid), businessData[business][bID], (!!status) ? ("มีเจ้าของ") : ("ไม่มีเจ้าของ"));
				businessData[business][bOwned] = !!status;

				if(IsValidDynamicPickup(businessData[business][bPickup]))
					DestroyDynamicPickup(businessData[business][bPickup]);

				businessData[business][bPickup] = CreateDynamicPickup(businessData[business][bOwned] ? 1239 : 1272, 23, businessData[business][bPosX], businessData[business][bPosY], businessData[business][bPosZ], 0, 0);
				Streamer_SetIntData(STREAMER_TYPE_PICKUP, businessData[business][bPickup], E_STREAMER_EXTRA_ID, business);

				Business_Save(business);
			}
			case 5: {
				new price;
				if(sscanf(text,"d", price)) {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /editbusiness ราคา [จำนวน]");
					return 1;
				}
				if (price <= 0 || price >= 50000000) {
					SendClientMessage(playerid, COLOR_GRAD1, "   ราคาธุรกิจต้องไม่ต่ำกว่าหรือเท่ากับ 0");
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนราคาของธุรกิจ #%d จาก %d เป็น %d", ReturnPlayerName(playerid), businessData[business][bID], businessData[business][bPrice], price);
				businessData[business][bPrice] = price;
				Business_Save(business);
			}
			case 6: {
				new level;
				if(sscanf(text,"d", level)) {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /editbusiness เลเวลที่ซื้อได้ [เลเวล]");
					return 1;
				}
				if (level <= 0 || level >= 50000000) {
					SendClientMessage(playerid, COLOR_GRAD1, "   เลเวลขั้นต่ำในการซื้อธุรกิจต้องไม่ต่ำกว่าหรือเท่ากับ 0");
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนเลเวลขั้นต่ำในการซื้อของธุรกิจ #%d จาก %d เป็น %d", ReturnPlayerName(playerid), businessData[business][bID], businessData[business][bLevelbuy], level);
				businessData[business][bLevelbuy] = level;
				Business_Save(business);
			}
			case 7: {
				new till;
				if(sscanf(text,"d", till)) {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /editbusiness เงินในธุรกิจ [จำนวน]");
					return 1;
				}
				if (till <= 0 || till >= 50000000) {
					SendClientMessage(playerid, COLOR_GRAD1, "   เงินในธุรกิจต้องไม่ต่ำกว่าหรือเท่ากับ 0");
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนเงินของธุรกิจ #%d จาก %d เป็น %d", ReturnPlayerName(playerid), businessData[business][bID], businessData[business][bCash], till);
				businessData[business][bCash] = till;
				Business_Save(business);
			}
			case 8: {
				new enc;
				if(sscanf(text,"d", enc)) {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /editbusiness ค่าเข้า [จำนวน]");
					return 1;
				}
				if (enc < 0 || enc >= 50000000) {
					SendClientMessage(playerid, COLOR_GRAD1, "   ค่าเข้าต้องไม่ต่ำกว่า 0");
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนค่าเข้าของธุรกิจ #%d จาก %d เป็น %d", ReturnPlayerName(playerid), businessData[business][bID], businessData[business][bEntranceCost], enc);
				businessData[business][bEntranceCost] = enc;
				Business_Save(business);
			}
			case 9: {
				new btype;
				if(sscanf(text,"d", btype)) {
					SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /editbusiness ประเภท [หมายเลข]");
					ShowAllBusinessType(playerid);
					return 1;
				}
				if(btype < 0 || btype > BUSINESS_MAX_TYPE) {
					SendClientMessageEx(playerid, COLOR_GRAD1, "   ประเภทต้องเป็น 0 ถึง %d เท่านั้น !!", BUSINESS_MAX_TYPE);
					return 1;
				}
				SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, "AdmAction: %s ได้เปลี่ยนประเภทของธุรกิจ #%d จาก %d เป็น %d", ReturnPlayerName(playerid), businessData[business][bID], businessData[business][bType], btype);
				businessData[business][bType] = btype;
				BusinessMapIcon(business);
				Business_Save(business);
			}
		}
	}
	else return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่ได้อยู่ใกล้ธุรกิจใด ๆ");
	return 1;
}

ShowPlayerFoodMenu(playerid) {
	return Dialog_Show(playerid, DialogFoodMenu, DIALOG_STYLE_LIST, "รายการอาหาร", "ชุดเล็ก\tความหิว+15\t$200\nชุดกลาง\tความหิว+20\t$350\nชุดเต็มอิ่ม\tความหิว+30\t$500", "ซื้อ", "ออก");
}

Dialog:DialogFoodMenu(playerid, response, listitem, inputtext[]) {
	if (response) {
		new Float:currentHealth;
		GetPlayerHealth(playerid, currentHealth);
		switch(listitem) {
			case 0: {
				/*if(currentHealth < 100.0)
				{
				    if(currentHealth + 30.0 <= 100.0) SetPlayerHealthEx(playerid,(currentHealth + 30.0));
				    else SetPlayerHealthEx(playerid, 100.0);
				}*/
				if (playerData[playerid][pHungry] >= 85)
					return SendClientMessage(playerid, COLOR_GRAD1, "คุณยังไม่หิวตอนนี้");

				playerData[playerid][pHungry] += 15;
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s สั่งอาหาร", ReturnRealName(playerid));
				SendClientMessage(playerid, COLOR_WHITE, "คุณได้สั่ง {FF6347}ชุดเล็ก"EMBED_WHITE" ในราคา {FF6347}$200");
				GivePlayerMoneyEx(playerid, -200);

				SendClientMessage(playerid, COLOR_YELLOW, "คุณได้รับค่าพลังงานความหิวเพิ่มขึ้น +15");
			}
			case 1: {
				/*if(currentHealth < 100.0)
				{
				    if(currentHealth + 60.0 <= 100.0) SetPlayerHealthEx(playerid,(currentHealth + 60.0));
				    else SetPlayerHealthEx(playerid, 100.0);
				}*/
				if (playerData[playerid][pHungry] >= 80)
					return SendClientMessage(playerid, COLOR_GRAD1, "คุณยังไม่หิวตอนนี้");

				playerData[playerid][pHungry] += 20;

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s สั่งอาหาร", ReturnRealName(playerid));
				SendClientMessage(playerid, COLOR_WHITE, "คุณได้สั่ง {FF6347}ชุดกลาง"EMBED_WHITE" ในราคา {FF6347}$350");
				GivePlayerMoneyEx(playerid, -350);

				SendClientMessage(playerid, COLOR_YELLOW, "คุณได้รับค่าพลังงานความหิวเพิ่มขึ้น +20");
			}
			case 2: {
				if (playerData[playerid][pHungry] >= 70)
					return SendClientMessage(playerid, COLOR_GRAD1, "คุณยังไม่หิวตอนนี้");

				playerData[playerid][pHungry] += 30;

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s สั่งอาหาร", ReturnRealName(playerid));
				SendClientMessage(playerid, COLOR_WHITE, "คุณได้สั่ง {FF6347}ชุดเต็มอิ่ม"EMBED_WHITE" ในราคา {FF6347}$500");
				GivePlayerMoneyEx(playerid, -500);

				SendClientMessage(playerid, COLOR_YELLOW, "คุณได้รับค่าพลังงานความหิวเพิ่มขึ้น +30");
			}
		}
	}
	return 1;
}
