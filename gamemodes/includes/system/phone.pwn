//--------------------------------[PHONE.PWN]--------------------------------
/*
	format(query, sizeof(query), "SELECT * FROM `phone_contacts` WHERE `contactAdded` = %d", playerData[extraid][pPnumber]);
	mysql_tquery(dbCon, query, "LoadPlayerContacts", "d", extraid);

	format(query, sizeof(query), "SELECT * FROM `phone_sms` WHERE `PhoneReceive` = %d", playerData[extraid][pPnumber]);
	mysql_tquery(dbCon, query, "LoadPlayerSMS", "d", extraid);

	- IsPlayerPhoneStandby(playerid) // ถือโทรศัพท์ และเครื่องเปิดอยู่
	- speakerStatus(playerid)
	- callinenumber(playerid)
	- IsCalline(playerid)
	
	- LoadPlayerContacts(playerid)
	- LoadPlayerSMS(playerid)

	// ใช้กับ OnPlayerText
	- PhoneCall(playerid, text[])

	- PhoneInit(playerid)
	- PhoneSave(playerid)
*/
#include <YSI\y_hooks>

#define	SQL_TABLE	("players")
#define	SQL_ID		("id")

#define cchargetime 30
#define callcost 10

#define MAX_PHONE_NUMBER             8

#define MAX_PHONE_MODEL				12
#define MAX_PHONE_CHOICE			 4
#define MAX_PHONE_PLAYER_TEXTDRAWS	25

#define PHONE_EVENT_LEFTBTN			0
#define PHONE_EVENT_RIGHTBTN		1
#define PHONE_EVENT_ARROW_UP		2
#define PHONE_EVENT_ARROW_DN		3
#define PHONE_EVENT_ARROW_LT		4
#define PHONE_EVENT_ARROW_RT		5

#define PHONE_EMOTION_SUCCESS		1
#define PHONE_EMOTION_FAIL			2
#define PHONE_EMOTION_MESSAGE		3

#define PP_NONE					-1
#define PP_HOME					0
#define PP_MENU   				1  
#define PP_BOOK   				2		// Menu -> Phonebook 
#define PP_CONTACTLIST 			3		// Menu -> Phonebook -> List contacts
#define PP_CONTACTDETAIL		4		// Menu -> Phonebook -> List contacts -> Contact details
#define PP_CONTACTACTION		5		// Menu -> Phonebook -> List contacts -> Contact details -> Contact Action
#define PP_SMS					6		// Menu -> SMS
#define PP_SMS_CONTACT			7		// Menu -> SMS -> SMS a contact
#define PP_SMS_INBOX			8		// Menu -> SMS -> Inbox
#define PP_SMS_ARCHIVE			9		// Menu -> SMS -> Archive
#define PP_CALLS				10		// Menu -> Calls
#define PP_CALLS_CONTACT		11		// Menu -> Calls -> Dial a contact
#define PP_CALLS_HISTORY		12		// Menu -> Calls -> View call history
#define PP_SETTINGS				13		// Menu -> Settings
#define PP_SETTINGS_RINGTONE	14		// Menu -> Settings -> Change Ringtone
#define PP_SETTINGS_RINGTONE_T	15		// Menu -> Settings -> Change Ringtone -> Text
#define PP_SETTINGS_RINGTONE_C	16		// Menu -> Settings -> Change Ringtone -> Call
#define PP_SETTINGS_PHONEINFO	17		// Menu -> Settings -> Phone Info
#define PP_DIALING				20
#define PP_CALLING				21
#define PP_INCOMING				22

#define CALL_TYPE_NONE		0
#define CALL_TYPE_SERVICE	1
#define CALL_TYPE_PLAYER	2
#define CALL_TYPE_TOLLFREE	3
#define CALL_TYPE_PAYPHONE	4

#define HISTORY_TYPE_OUTGOING	1
#define HISTORY_TYPE_INCOMING	2
#define HISTORY_TYPE_MISSCALL	3

enum cache_data // Phone
{
	current_page,
	notify_page,
	row_selected,
	bool:mode_airplane,
	bool:mode_silent,
	bool:mode_speaker,
	ringtone_call,
	ringtone_text,
	calltime,
	calltype, // 0-Hotline 1-Private, 2-Payphone, 3-Toll Free
	outgoing_call,
	incoming_call,
	callline,
	callServiceCost,

	Timer:ph_timer,
	bool:exist_time,
	
	phone_data[4],
	data_selected,
	data_type, // 0-Contact, 1-SMS
}

enum E_PHONE_TEXTDRAW
{
	E_PHONE_TEXTDRAW_BODY,
	E_PHONE_TEXTDRAW_SCREEN_LTEXT,
	E_PHONE_TEXTDRAW_SCREEN_RTEXT,
	E_PHONE_TEXTDRAW_CAMERA,
	E_PHONE_TEXTDRAW_SCREEN_BG,
	E_PHONE_TEXTDRAW_POWERBTN,
	E_PHONE_TEXTDRAW_INBOX,
	E_PHONE_TEXTDRAW_LEFTBTN,
	E_PHONE_TEXTDRAW_RIGHTBTN,
	E_PHONE_TEXTDRAW_EMOTION,
    E_PHONE_TEXTDRAW_CHOICE[MAX_PHONE_CHOICE],
	E_PHONE_TEXTDRAW_ARROW_UP,
	E_PHONE_TEXTDRAW_ARROW_DOWN,
	E_PHONE_TEXTDRAW_ARROW_LEFT,
	E_PHONE_TEXTDRAW_ARROW_RIGHT,
	E_PHONE_TEXTDRAW_SCREEN_TEXT,
	E_PHONE_TEXTDRAW_SCREEN_BIGTEXT,
	E_PHONE_TEXTDRAW_SCREEN_SIGNAL,
	E_PHONE_TEXTDRAW_SCREEN_NOTIFY,

};

new PlayerText:phonePlayerTextDraw[MAX_PLAYERS][MAX_PHONE_PLAYER_TEXTDRAWS];
new phonePlayerTextDrawID[MAX_PLAYERS][E_PHONE_TEXTDRAW];
new phonePlayerTextDrawCount[MAX_PLAYERS];

new bool:playerUsingPhone[MAX_PLAYERS char];

#define    PHONE_NOTIFY_SMS_SEND			0
#define    PHONE_NOTIFY_SMS_DELIVERY_S		1
#define    PHONE_NOTIFY_SMS_DELIVERY_F		2
#define    PHONE_NOTIFY_CONTACT_FULL		3
#define    PHONE_NOTIFY_INVALID_NUMBER		4
#define    PHONE_NOTIFY_CALL_FAIL			5
#define    PHONE_NOTIFY_NO_SIGNAL			6
#define    PHONE_NOTIFY_LINE_BUSY			7

// Contact SYSTEM
#define MAX_CONTACT_LIST			40

enum E_phone_data {
	contactID,
	contactName[20],
	contactNumber,
};

new contactData[MAX_PLAYERS][MAX_CONTACT_LIST][E_phone_data];

// Short Message Service SYSTEM
#define MAX_SMS 					30

enum E_SMS_DATA {
	smsID,
	smsOwner,
	smsReceive,
	smsText[128],
	bool:smsIsRead,
	bool:smsIsArchive,
	smsDate[24],

};

new smsData[MAX_PLAYERS][MAX_SMS][E_SMS_DATA];

// Call History SYSTEM
#define MAX_LASTCALL	10

enum E_LASTCALL_DATA {
	lastcall_sec,
	lastcall_number[MAX_PHONE_NUMBER],
	bool:lastcall_read,
	lastcall_type // 1- Outgoing call to %s (%d), 2- Incoming call from %s (%d), 3- Missed call from %s (%d)
};

// Camera System (Selfie) 
new Timer:selfieTimer[MAX_PLAYERS];
new Float:SelDegree[MAX_PLAYERS];
new Float:SelAngle[MAX_PLAYERS];
const Float: Radius = 1.4; //do not edit this
const Float: Speed  = 1.25; //do not edit this
const Float: Height = 1.0; // do not edit this
new Float:lX[MAX_PLAYERS];
new Float:lY[MAX_PLAYERS];
new Float:lZ[MAX_PLAYERS];

new lastcallData[MAX_PLAYERS][MAX_LASTCALL][E_LASTCALL_DATA];
new phone_cache[MAX_PLAYERS][cache_data]; // Phone


PhoneLoad(playerid,ringtoneCall=0,ringtoneText=0,bool:modeAirplane=false,bool:modeSilent=false)
{
	phone_cache[playerid][ringtone_call]=ringtoneCall;
	phone_cache[playerid][ringtone_text]=ringtoneText;
	phone_cache[playerid][mode_airplane]=modeAirplane;
	phone_cache[playerid][mode_silent]=modeSilent;

	new query[128];
	format(query, sizeof(query), "SELECT * FROM `phone_contacts` WHERE `contactAdded` = %d", playerData[playerid][pPnumber]);
	mysql_tquery(dbCon, query, "LoadPlayerContacts", "d", playerid);
						
	format(query, sizeof(query), "SELECT * FROM `phone_sms` WHERE `PhoneReceive` = %d ORDER BY `id` DESC", playerData[playerid][pPnumber]);
	mysql_tquery(dbCon, query, "LoadPlayerSMS", "d", playerid);
}

PhoneSave(playerid)
{
	if (!BitFlag_Get(gPlayerBitFlag[playerid], IS_LOGGED)) 
		return 0;

	new query[MAX_STRING];
	MySQLUpdateInit(SQL_TABLE, SQL_ID, playerData[playerid][pSID], MYSQL_UPDATE_TYPE_SINGLE);
	MySQLUpdateInt(query, "ringtoneCall", phone_cache[playerid][ringtone_call]);
	MySQLUpdateInt(query, "ringtoneText", phone_cache[playerid][ringtone_text]);	
	MySQLUpdateBool(query, "phoneAirplane", phone_cache[playerid][mode_airplane]);	
	MySQLUpdateBool(query, "phoneSilent", phone_cache[playerid][mode_silent]);	
	MySQLUpdateFinish(query);
	return 1;
}

hook OnPlayerConnect(playerid) {

	phone_cache[playerid][current_page]=PP_HOME;
	
	phonePlayerTextDrawCount[playerid]=
	phone_cache[playerid][calltime]=
	phone_cache[playerid][callServiceCost]=
	phone_cache[playerid][callline]=
	phone_cache[playerid][ringtone_call]=
	phone_cache[playerid][ringtone_text]=
	phone_cache[playerid][calltype]=
	phone_cache[playerid][row_selected]=0;
	
	phone_cache[playerid][notify_page]=
	phone_cache[playerid][data_selected]=-1;
	phone_cache[playerid][data_type]=0;
	
	phone_cache[playerid][mode_speaker]=
	phone_cache[playerid][mode_airplane]=
	phone_cache[playerid][mode_silent]=false;

	OnDropContract(playerid);
	OnDropSMS(playerid);

    playerUsingPhone{playerid} = false;
	
	phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_BODY] = phonePlayerTextDrawCount[playerid];	
	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 499.499816, 317.032318, "_");
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.407599, 14.487455);
	PlayerTextDrawTextSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 597.000000, 0.119998);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -1);
	PlayerTextDrawUseBox(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 286331391);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetProportional(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 0);

	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 496.199707, 314.288909, "ld_spac:tvcorn");
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 55.000000, 135.000000);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -858993409);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 4);
	PlayerTextDrawSetOutline(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetShadow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 0);

	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 601.802307, 314.288909, "ld_spac:tvcorn");
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -55.000000, 135.000000);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -858993409);
	PlayerTextDrawSetShadow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetOutline(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 4);
	PlayerTextDrawSetProportional(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetOutline(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetShadow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 0);

	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 529.599975, 332.862396, "LS_Telefonica");
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.211594, 0.758750);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -1);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawSetProportional(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawSetShadow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 0);

	phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CAMERA] = phonePlayerTextDrawCount[playerid];	
	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 596.699890, 423.302307, "ld_dual:white"); // Selfie
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 5.000000, 18.000000);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1145324799);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 4);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 1);
	
	phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_POWERBTN] = phonePlayerTextDrawCount[playerid];
	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 580.200073, 322.751281, "ld_beat:circle");
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 15.000000, 15.000000);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -1);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 4);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 1);
	
	phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_LEFTBTN] = phonePlayerTextDrawCount[playerid];
	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 507.000091, 407.871215, "ld_dual:white");
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 22.000000, 8.000000);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -1717986902);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 4);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 1);

	phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_RIGHTBTN] = phonePlayerTextDrawCount[playerid];
	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 569.100585, 407.871215, "ld_dual:white");
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 22.000000, 8.000000);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -1717986902);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 4);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 1);
	
	phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_ARROW_UP] = phonePlayerTextDrawCount[playerid];
	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 543.999633, 409.339843, "ld_beat:up");
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 12.000000, 12.000000);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -690563841);
	PlayerTextDrawSetShadow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetOutline(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 4);
	PlayerTextDrawSetProportional(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetShadow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 1);

	phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_ARROW_DOWN] = phonePlayerTextDrawCount[playerid];
	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 543.999633, 429.138793, "ld_beat:down");
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 12.000000, 12.000000);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -690563841);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 4);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 1);

	phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_ARROW_LEFT] = phonePlayerTextDrawCount[playerid];
	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 533.999877, 419.002044, "ld_beat:left");
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 12.000000, 12.000000);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -690563841);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 4);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 1);

	phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_ARROW_RIGHT] = phonePlayerTextDrawCount[playerid];
	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 553.299804, 418.992980, "ld_beat:right");
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 12.000000, 12.000000);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -690563841);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 4);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 1);

	phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_INBOX] = phonePlayerTextDrawCount[playerid];	
	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 575.401733, 328.651336, "ld_pool:ball");
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 5.000000, 5.000000);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -1);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 4);
	PlayerTextDrawSetProportional(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 1);

	phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_BG] = phonePlayerTextDrawCount[playerid];	
	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 508.601379, 351.677886, "_"); // Screen BG
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.019598, 5.817771);
	PlayerTextDrawTextSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 590.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -1);
	PlayerTextDrawUseBox(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -1);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawSetProportional(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 0);

	phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_LTEXT] = phonePlayerTextDrawCount[playerid];
	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 508.599182, 393.690673, "Menu");
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.189996, 0.883198);
	PlayerTextDrawTextSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 526.0000, 10.000000);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawSetShadow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 0);

	phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT] = phonePlayerTextDrawCount[playerid];
	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 588.999450, 393.690673, "Back");
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.189996, 0.883198);
	PlayerTextDrawTextSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.0000, 0.00000);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 3);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawSetShadow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 0);

	
	phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_BIGTEXT] = phonePlayerTextDrawCount[playerid];
	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 549.300231, 357.344482, "_");
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.296398, 1.286399);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 2);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawSetProportional(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawSetShadow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 0);

	phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_TEXT] = phonePlayerTextDrawCount[playerid];
	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 549.300231, 358.797149, "_");
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.200398, 0.937954);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 2);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawSetProportional(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawSetShadow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 0);

	phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_SIGNAL] = phonePlayerTextDrawCount[playerid];
	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 590.000000, 349.288848, "_");
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.167998, 0.918043);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 3);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawSetShadow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetOutline(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawSetProportional(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawSetShadow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 0);

	phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_EMOTION] = phonePlayerTextDrawCount[playerid];
	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 488.199890, 296.000000, "_"); // Emo
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -50.000000, 50.000000);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -1);
	PlayerTextDrawSetShadow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetOutline(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 4);
	PlayerTextDrawSetProportional(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetShadow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 0);

	phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_NOTIFY] = phonePlayerTextDrawCount[playerid];
	phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 578.799987, 351.280090, "_");
	PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.139199, 0.659200);
	PlayerTextDrawTextSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 598.799987, 15.0);
	PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 3);
	PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -16776961);
	PlayerTextDrawSetShadow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetOutline(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
	PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawSetProportional(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
	PlayerTextDrawSetShadow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
	PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 1);

    for (new i = 0, Float:y = 354.812500; i < 4; i ++) {

		phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][i] = phonePlayerTextDrawCount[playerid];
		phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]] = CreatePlayerTextDraw(playerid, 510.400054, y, "_");
		PlayerTextDrawLetterSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0.1911, 0.8);
		PlayerTextDrawTextSize(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 588.099975, 8.000000);
		PlayerTextDrawAlignment(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
		PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], -1);
		PlayerTextDrawUseBox(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
		PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
		PlayerTextDrawSetShadow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
		PlayerTextDrawSetOutline(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
		PlayerTextDrawBackgroundColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 255);
		PlayerTextDrawFont(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
		PlayerTextDrawSetProportional(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 1);
		PlayerTextDrawSetShadow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]], 0);
		PlayerTextDrawSetSelectable(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawCount[playerid]++], 1);

		y += 12.8;
	}
	
	//printf("Loading Player Textdraw %d -> PHONE.PWN", phonePlayerTextDrawCount[playerid]);
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if (BitFlag_Get(gPlayerBitFlag[playerid], IS_LOGGED)) {
		PhoneSave(playerid);
		forceHangup(playerid);
	}

	for (new i; i < phonePlayerTextDrawCount[playerid]; i++)
 	{
  		PlayerTextDrawDestroy(playerid, phonePlayerTextDraw[playerid][i]);
    }
	phone_cache[playerid][exist_time]=false;
	//KillTimer(phone_cache[playerid][ph_timer]);
	stop phone_cache[playerid][ph_timer];
	phone_cache[playerid][ph_timer] = Timer:0;
	return 1;
}

hook OP_ClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	/*if (playerUsingPhone{playerid})
	{
		if (playertextid == phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_LEFTBTN]])
		{
			OnPhoneEvent(playerid, PHONE_EVENT_LEFTBTN);
			return 1;
		}
		else if (playertextid == phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_RIGHTBTN]])
		{
			OnPhoneEvent(playerid, PHONE_EVENT_RIGHTBTN);
			return 1;
		}
		else if (playertextid == phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_ARROW_UP]])
		{
			OnPhoneEvent(playerid, PHONE_EVENT_ARROW_UP);
			return 1;
		}
		else if (playertextid == phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_ARROW_DOWN]])
		{
			OnPhoneEvent(playerid, PHONE_EVENT_ARROW_DN);
			return 1;
		}
		else if (playertextid == phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_ARROW_LEFT]])
		{
			OnPhoneEvent(playerid, PHONE_EVENT_ARROW_LT);
			return 1;
		}
		else if (playertextid == phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_ARROW_RIGHT]])
		{
			OnPhoneEvent(playerid, PHONE_EVENT_ARROW_RT);
			return 1;
		}
		else if (playertextid == phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_INBOX]])
		{
			if (phone_cache[playerid][current_page] != PP_NONE) {
				phone_cache[playerid][data_selected] = -1;
				phone_cache[playerid][current_page] = PP_SMS_INBOX;
				PHONE_Update(playerid);
			}
			return 1;
		}
		else if (playertextid == phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CAMERA]])
		{
			if (phone_cache[playerid][current_page] != PP_NONE && selfieTimer[playerid] == Timer:0) {

				CancelSelectTextDraw(playerid);
				SetPlayerArmedWeapon(playerid, 0);
				TogglePlayerControllable(playerid, false);

				SendClientMessage(playerid, COLOR_LIGHTRED, "[ ! ] กด F8 เพื่อถ่ายรูป F7 (สองครั้ง) เพื่อซ่อนแชทของคุณ");
				SendClientMessage(playerid, COLOR_LIGHTRED, "[ ! ] กด W, A, S และ D ค้างไว้เพื่อจัดกล้อง กด ENTER ค้างไว้เพื่อย้อนกลับ");
				SendClientMessage(playerid, COLOR_WHITE, "[ ! ] Info: ใช้ /headmove เพื่อหยุดการเคลื่อนไหวหัวของคุณ");

				GetPlayerPos(playerid,lX[playerid],lY[playerid],lZ[playerid]);
				GetPlayerFacingAngle(playerid, SelDegree[playerid]);

				SelDegree[playerid] += 90.0;
				SelAngle[playerid] = 0.8;
				
				new Float: n1X, Float: n1Y;
				n1X = lX[playerid] + Radius * floatcos(SelDegree[playerid], degrees);
				n1Y = lY[playerid] + Radius * floatsin(SelDegree[playerid], degrees);
				SetPlayerCameraPos(playerid, n1X, n1Y, lZ[playerid] + Height);
				SetPlayerCameraLookAt(playerid, lX[playerid], lY[playerid], lZ[playerid] + SelAngle[playerid]);
				SetPlayerFacingAngle(playerid, SelDegree[playerid] - 90);

				ApplyAnimation(playerid, "PED", "gang_gunstand", 4.1, 0, 0, 0, 1, 0, 0);

				selfieTimer[playerid] = repeat SelfieTimer(playerid);
			}
			return 1;
		}
		else if (playertextid == phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_POWERBTN]]) {

			if (!GetPVarType(playerid, "togglePhoneState")) {
				if (phone_cache[playerid][current_page] == PP_NONE) {
					SetPVarInt(playerid, "togglePhoneState", 2);
					phone_cache[playerid][current_page] = PP_NONE;
					PHONE_Update(playerid);
					SetTimerEx("TurnOnPhone", 4000, 0, "i", playerid);
				}
				else if (phone_cache[playerid][current_page] != PP_NONE) {
					PHONE_HideEmotion(playerid);
					SetPVarInt(playerid, "togglePhoneState", 1);
					phone_cache[playerid][current_page] = PP_NONE;
					PHONE_Update(playerid);

					SetTimerEx("TurnOffPhone", 4000, 0, "i", playerid);
				}
			}
			return 1;
		}
		else {
			for (new i; i < (MAX_PHONE_CHOICE); i++)
			{
				if (playertextid == phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][i]])
				{
					new temp_selected;
			
					if(phone_cache[playerid][current_page] == PP_CONTACTLIST || 
						phone_cache[playerid][current_page] == PP_SMS_CONTACT || 
						phone_cache[playerid][current_page] == PP_SMS_INBOX ||				
						phone_cache[playerid][current_page] == PP_SMS_ARCHIVE ||
						phone_cache[playerid][current_page] == PP_CALLS_CONTACT ||
						phone_cache[playerid][current_page] == PP_CALLS_HISTORY) 
					{
						temp_selected = phone_cache[playerid][data_selected];
						if(temp_selected == phone_cache[playerid][phone_data][i]) {
							OnPhoneEvent(playerid, PHONE_EVENT_LEFTBTN);
						}
						else {
							phone_cache[playerid][data_selected] = phone_cache[playerid][phone_data][i];
						}
						
						if(phone_cache[playerid][current_page] == PP_CONTACTLIST || phone_cache[playerid][current_page] == PP_SMS_CONTACT) {
							phone_cache[playerid][data_type]=0;
						}
						else if(phone_cache[playerid][current_page] == PP_SMS_INBOX || phone_cache[playerid][current_page] == PP_SMS_ARCHIVE) {
							phone_cache[playerid][data_type]=1;
						}
						else if(phone_cache[playerid][current_page] == PP_CALLS_HISTORY) {
							phone_cache[playerid][data_type]=2;
						}
					}
					else {
						temp_selected = phone_cache[playerid][row_selected];
						if(temp_selected == i) {
							OnPhoneEvent(playerid, PHONE_EVENT_LEFTBTN);
						}
						else phone_cache[playerid][row_selected]=i;
					}
					PHONE_Update(playerid);
					return 1;
				}
			}
		}
	}*/
	return 1;
}
/*
CMD:phonecursor(playerid, params[])
{
	if(!playerUsingPhone{ playerid } && playerData[playerid][pPnumber] && !gIsDeathMode{playerid} && !gIsInjuredMode{playerid})
	{
		SendClientMessage(playerid, -1, "[ ! ] Note: เพื่อสลับโทรศัพท์ใช้ /phone เพื่อนำเมาส์ขึ้นมาใช้ /pc");
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s หยิบโทรศัพท์ของเขา", ReturnRealName(playerid));

		PHONE_Show(playerid);
		SelectTextDraw(playerid, 0x58ACFAFF);

		SendClientMessage(playerid, -1, "[ ! ] Note: กด ESC เพื่อกลับไปยังโหมดการเดิน");
	}
	else SelectTextDraw(playerid, 0x58ACFAFF);

	return 1;
}
alias:phonecursor("pc");*/

alias:phone("ph");
CMD:phone(playerid, params[])
{
    if(gIsDeathMode{playerid} || gIsInjuredMode{playerid} || BitFlag_Get(gPlayerBitFlag[playerid],IS_CUFFED))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถใช้โทรศัพท์ได้ในขณะนี้");

	if (playerData[playerid][pPnumber])
	{
     	if(!playerUsingPhone{ playerid })
	    {
			SetPlayerAttachedObject(playerid, 0, 18870, 6, 0.0789, 0.0050, -0.0049, 84.9999, -179.2999, -1.6999, 1.0000, 1.0000, 1.0000);

			//SendClientMessage(playerid, -1, "[ ! ] Note: เพื่อสลับโทรศัพท์ใช้ /phone เพื่อนำเมาส์ขึ้นมาใช้ /pc");
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s หยิบโทรศัพท์ของเขา", ReturnRealName(playerid));

			PHONE_Show(playerid);
			//SelectTextDraw(playerid, 0x58ACFAFF);

			//SendClientMessage(playerid, -1, "[ ! ] Note: กด ESC เพื่อกลับไปยังโหมดการเดิน");
		}
		else {
			// PHONE_Hide(playerid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s หยิบโทรศัพท์ของเขา", ReturnRealName(playerid));
			PHONE_Show(playerid);
		}
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่มีโทรศัพท์");

	return 1;
}

CMD:sms(playerid, params[])
{
    if(gIsDeathMode{playerid} || gIsInjuredMode{playerid} || BitFlag_Get(gPlayerBitFlag[playerid],IS_CUFFED))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถทำได้ในขณะนี้");

	if(phone_cache[playerid][current_page] == PP_NONE) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถทำได้ในขณะนี้ (โทรศัพท์ปิดอยู่)");
	if(phone_cache[playerid][mode_airplane]) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณกำลังอยู่ในโหมดเครื่องบิน ไม่สามารถทำได้");
  	if(phone_cache[playerid][exist_time] || playerData[playerid][pCash] < 1 || phone_cache[playerid][outgoing_call] || phone_cache[playerid][incoming_call]) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถทำได้ในขณะนี้ (สัญญาณไม่ว่าง/มีเงินไม่พอ)");


	new phonenumb[24], sms_text[128];

	if (sscanf(params, "s[24]s[128]", phonenumb, sms_text))
		return SendClientMessage(playerid, COLOR_GRAD2, "การใช้: /sms [หมายเลขโทรศัพท์] [ข้อความ]");
		
    if(playerData[playerid][pPnumber])
	{
	    new phonenumber = strval(phonenumb);

		new contactid = -1;

		for(new i = 0; i != 40; ++i)
		{
			if(contactData[playerid][i][contactID] > 0 && (strequal(contactData[playerid][i][contactName], phonenumb, true) || contactData[playerid][i][contactNumber] == phonenumber))
			{
				contactid = i;
    			break;
   			}
  		}

        PC_EmulateCommand(playerid, "/me พิมพ์อะไรบางอย่างบนโทรศัพท์ของเขา");

		if(!playerUsingPhone{ playerid }) 
			PHONE_Show(playerid);
		
		phone_cache[playerid][notify_page] = PHONE_NOTIFY_SMS_SEND;
		PHONE_Update(playerid);

		phone_cache[playerid][exist_time]=true;
		//phone_cache[playerid][ph_timer] = defer SendPlayerSMS[(8 - GetPlayerRadioSignal(playerid)) * 1000](playerid, contactid, phonenumber, sms_text);
		SendPlayerSMS(playerid, contactid, phonenumber, sms_text);
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่มีโทรศัพท์");

	return 1;
}

CMD:call(playerid, params[])
{
    if(gIsDeathMode{playerid} && gIsInjuredMode{playerid} || BitFlag_Get(gPlayerBitFlag[playerid],IS_CUFFED))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถทำได้ในขณะนี้");

	if(phone_cache[playerid][current_page] == PP_NONE) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถทำได้ในขณะนี้ (โทรศัพท์ปิดอยู่)");
	if(phone_cache[playerid][mode_airplane]) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณกำลังอยู่ในโหมดเครื่องบิน ไม่สามารถทำได้");
  	if(phone_cache[playerid][exist_time] || playerData[playerid][pCash] < 1 || phone_cache[playerid][outgoing_call] || phone_cache[playerid][incoming_call]) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถทำได้ในขณะนี้ (สัญญาณไม่ว่าง/มีเงินไม่พอ)");

	new call_string[20];
	if (strlen(params) < 20 && sscanf(params, "s[20]", call_string))
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: /call [หมายเลขโทรศัพท์/ชื่อผู้ติดต่อ]");
		SendClientMessage(playerid, COLOR_GRAD1, "[หมายเลขทั่วไป]");
		SendClientMessage(playerid, COLOR_YELLOW2, "แจ้งเหตุฉุกเฉิน (ตำรวจ/แพทย์): 911");
		SendClientMessage(playerid, COLOR_YELLOW2, "แจ้งเหตุไม่ฉุกเฉิน [โทรศัพท์สำนักงาน]: 991");
		SendClientMessage(playerid, COLOR_YELLOW2, "การจัดส่งแท๊กซี่: 544");
		SendClientMessage(playerid, COLOR_YELLOW2, "ช่างซ่อมรถ: 555");
		return 1;
	}

    if(playerData[playerid][pPnumber])
	{
		new call_Array[3][MAX_PHONE_NUMBER], prefix = 555, ph_areacode = 999, number[MAX_PHONE_NUMBER] = '\0';
		strexplode(call_Array, call_string, "-");
		
		if(strlen(call_Array[2])) {
			prefix = strval(call_Array[0]);
			ph_areacode = strval(call_Array[1]);
			format(number, sizeof(number), call_Array[2]);
		}
		else {
			if(strlen(call_Array[1])) {
				prefix = strval(call_Array[0]);
				format(number, sizeof(number), call_Array[1]);
			}
			else {
				format(number, sizeof(number), call_Array[0]);
			}
		}
		phone_cache[playerid][notify_page] = -1;
		
		new display_name[32];
		format(display_name, sizeof(display_name), call_string);
		
		if(IsNumeric(call_string)) {
			new number_call = strval(call_string);
			switch(number_call) {
				case 911, 991, 555, 544: {
					phone_cache[playerid][calltype]=CALL_TYPE_SERVICE;
					format(display_name, sizeof(display_name), "~n~%d", number_call);
					// Hotline
				}
				default: {
					phone_cache[playerid][calltype]=CALL_TYPE_PLAYER;
					// Private Phone (Number) ค้นหาชื่อจากหมายเลข
					new contactid = GetPlayerContactByNumber(playerid, number_call);
					if(contactid != -1) format(display_name, sizeof(display_name), "%s~n~(%d)", contactData[playerid][contactid][contactName], contactData[playerid][contactid][contactNumber]);
					else format(display_name, sizeof(display_name), "~n~555-%d", number_call);
				}
			}
			phone_cache[playerid][outgoing_call]=number_call;
		}
		else if(prefix == 1 && ph_areacode == 800) {
			// Toll Free
			phone_cache[playerid][calltype]=CALL_TYPE_TOLLFREE;

			phone_cache[playerid][outgoing_call]=strval(number);
		}
		else if(prefix == 24 && ph_areacode != 999) {
			// Payphone
			phone_cache[playerid][calltype]=CALL_TYPE_PAYPHONE;

			phone_cache[playerid][outgoing_call]=strval(number);
		}
		else if(prefix == 555 && ph_areacode == 999) {
			// Private Phone (Name) ค้นหาชื่อจากชื่อที่ได้รับมา
			phone_cache[playerid][calltype]=CALL_TYPE_PLAYER;
			new contactid = GetPlayerContactByName(playerid, number);
			if(contactid != -1) {
				format(display_name, sizeof(display_name), "%s~n~(%d)", contactData[playerid][contactid][contactName], contactData[playerid][contactid][contactNumber]);
				phone_cache[playerid][outgoing_call]=contactData[playerid][contactid][contactNumber];

				valstr(number,contactData[playerid][contactid][contactNumber]);
			}
			else {
				if(IsNumeric(number)) {
					new numb = strval(number);
					format(display_name, sizeof(display_name), "~n~555-%d", numb);
					phone_cache[playerid][outgoing_call]=numb;
				}
				else {
					phone_cache[playerid][notify_page] = PHONE_NOTIFY_INVALID_NUMBER;
					
					if(!playerUsingPhone{ playerid }) 
						PHONE_Show(playerid);
						
					return 1;
				}
			}
		}
		else {
			phone_cache[playerid][notify_page] = PHONE_NOTIFY_INVALID_NUMBER;
			
			if(!playerUsingPhone{ playerid }) 
				PHONE_Show(playerid);
				
			PHONE_Update(playerid);
			
			return 1;
		}

		PlayerPlaySoundEx(playerid, 3600);

        PC_EmulateCommand(playerid, "/me กดหมายเลขบนโทรศัพท์ของเขา");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);

		if(!playerUsingPhone{ playerid }) 
			PHONE_Show(playerid);

		SetPVarString(playerid, "CallDisplay", display_name);
		phone_cache[playerid][current_page] = PP_DIALING;
		phone_cache[playerid][exist_time]=true;

		//phone_cache[playerid][ph_timer] = defer SendPlayerCall[(8 - GetPlayerRadioSignal(playerid)) * 1000](playerid, number);
		SendPlayerCall(playerid, number);

		AddPlayerCallHistory(playerid, number, HISTORY_TYPE_OUTGOING); // outgoing
		PHONE_Update(playerid);
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่มีโทรศัพท์");

	return 1;
}

PHONE_Show(playerid)
{
	PHONE_Update(playerid);
    playerUsingPhone{playerid} = true;
}

PHONE_Hide(playerid)
{
	/*RemovePlayerAttachedObject(playerid, PLAYER_ATTACH_SLOT9);
	
	for (new i; i < phonePlayerTextDrawCount[playerid]; i++)
 	{
  		PlayerTextDrawHide(playerid, phonePlayerTextDraw[playerid][i]);
    }*/

    playerUsingPhone{playerid} = false;
    //return CancelSelectTextDraw(playerid);
}

PHONE_PlayRingtone(playerid)
{
	switch(phone_cache[playerid][ringtone_text])
	{
	    case 0: PlayerPlaySound(playerid, 41603, 0.0, 0.0, 0.0);
	    case 1: PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
	    case 2: PlayerPlaySound(playerid, 21001, 0.0, 0.0, 0.0);
	    case 3: PlayerPlaySound(playerid, 21002, 0.0, 0.0, 0.0);
	}
}

PHONE_Emotion(playerid, emo) {
	switch(emo)
	{
		case PHONE_EMOTION_SUCCESS: PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0), PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_EMOTION]], "ld_chat:thumbup");
		case PHONE_EMOTION_FAIL: PlayerPlaySound(playerid, 21001, 0.0, 0.0, 0.0), PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_EMOTION]], "ld_chat:thumbdn");
		case PHONE_EMOTION_MESSAGE: PHONE_PlayRingtone(playerid), PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_EMOTION]], "ld_chat:goodcha");
	}
	PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_EMOTION]]);
	SetTimerEx("PHONE_HideEmotion", 5000, false, "d", playerid);
}

forward PHONE_HideEmotion(playerid);
public PHONE_HideEmotion(playerid)
{
	PlayerTextDrawHide(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_EMOTION]]);
	return 1;
}

PHONE_Update(playerid)
{

	if(phone_cache[playerid][notify_page] != -1 && phone_cache[playerid][current_page] != PP_NONE) {
		switch(phone_cache[playerid][notify_page]) {
			case PHONE_NOTIFY_CONTACT_FULL: Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "แจ้งเตือน", "\nรายชื่อผู้ติดต่อเต็ม", "", "ปิด");
			case PHONE_NOTIFY_CALL_FAIL: Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "แจ้งเตือน", "\nโทรไม่ติด", "", "ปิด");
			case PHONE_NOTIFY_INVALID_NUMBER: Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "แจ้งเตือน", "\nผิดพลาด!\nหมายเลขไม่ถูกต้อง", "", "ปิด");
			case PHONE_NOTIFY_LINE_BUSY: Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "แจ้งเตือน", "\nแจ้งให้ทราบ!\nสายไม่ว่าง", "", "ปิด");
			case PHONE_NOTIFY_NO_SIGNAL: Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "แจ้งเตือน", "\nไม่มีสัญญาณ", "", "ปิด");
			case PHONE_NOTIFY_SMS_DELIVERY_F: Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "แจ้งเตือน", "\nการส่งล้มเหลว", "", "ปิด");
			case PHONE_NOTIFY_SMS_DELIVERY_S: Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "แจ้งเตือน", "\nส่งสำเร็จแล้ว", "", "ปิด");
			case PHONE_NOTIFY_SMS_SEND: Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "แจ้งเตือน", "\nกำลังส่ง ...", "", "ปิด");
		}
		/*PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_TEXT]]);
		PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]], "Close");
		PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]]);*/
		return 1;
	}
	
	switch(phone_cache[playerid][current_page]) {
		case PP_NONE: {
			switch(GetPVarInt(playerid, "togglePhoneState")) {
				case 0: {
					/*PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_BG]], 0x1C1C1CFF);
					PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_BG]]);*/

					Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "SF Telefon", "", "", "ปิด");
				}
				case 1: {
					/*Dialog_Show(playerid, D_PHONE_NOTIFY, "~n~See you!");
					PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_TEXT]]);*/

					Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "SF Telefon", "\nแล้วพบกันใหม่ !", "", "ปิด");
				}
				case 2: {
					/*Dialog_Show(playerid, D_PHONE_NOTIFY, "~n~Loading..");
					PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_TEXT]]);*/

					Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "SF Telefon", "\nกำลังโหลด..", "", "ปิด");
				}
			}
		}
		case PP_HOME: {
			/*PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_BG]], -1);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_BG]]);
	*/
	
			new
				day, month, year, hour, minute, second, count_numb;
				
			new str[1024];
		
			if((count_numb = CountMissedCall(playerid))) format(str, sizeof(str), "%d สายที่ไม่ได้รับ | สัญญาณ [", count_numb);
			else if((count_numb = CountUnreadSMS(playerid))) format(str, sizeof(str), "%d ข้อความที่ยังไม่ได้อ่าน | สัญญาณ [", count_numb);
			else format(str, sizeof(str), "สัญญาณ [");

			for(new i=0, j=GetPlayerRadioSignal(playerid); i != j; ++i)
				strcat(str, "l");

			strcat(str, "]");
			/*PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_SIGNAL]], (strlen(str) > 0) ? str : ("X"));
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_SIGNAL]]);*/
			
			getdate(year, month, day);
			gettime(hour, minute, second);

			format(str, sizeof(str), "%s\nเวลา %02d:%02d", str, hour, minute);
			/*PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_BIGTEXT]], str);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_BIGTEXT]]);*/

			format(str, sizeof(str), "%s\nวันที่ %d เดือน %s", str, day, MONTH_DAY_TH[month - 1]);
			/*PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_TEXT]], str);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_TEXT]]);*/

			Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "SF Telefon", str, "เมนู", "กลับ");
		/*
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_NOTIFY]], str);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_NOTIFY]]);
			

			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_LTEXT]], "Menu");
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_LTEXT]]);
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]], "Back");
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]]);
*/
		}
		case PP_MENU: {
			/*PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], "Phonebook");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], (phone_cache[playerid][row_selected] == 0) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], (phone_cache[playerid][row_selected] == 0) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]]);

			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], "SMS");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][row_selected] == 1) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][row_selected] == 1) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]]);			

			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], "Calls");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], (phone_cache[playerid][row_selected] == 2) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], (phone_cache[playerid][row_selected] == 2) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]]);					

			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][3]], "Settings");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][3]], (phone_cache[playerid][row_selected] == 3) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][3]], (phone_cache[playerid][row_selected] == 3) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][3]]);	*/
			Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_LIST, "SF Telefon", "สมุดโทรศัพท์\nข้อความสั้น\nการโทร\nตั้งค่า", "เลือก", "กลับ");
		}
		case PP_BOOK: {

			/*PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], "Add a contact");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], (phone_cache[playerid][row_selected] == 0) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], (phone_cache[playerid][row_selected] == 0) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]]);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], "List contacts");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][row_selected] == 1) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][row_selected] == 1) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]]);

			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_LTEXT]], "Select");
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_LTEXT]]);
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]], "Back");
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]]);*/
			Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_LIST, "SF Telefon", "เพิ่มรายชื่อผู้ติดต่อ\nรายชื่อผู้ติดต่อ", "เลือก", "กลับ");
		}
		case PP_CALLS_HISTORY: {
		
			new count = 0, str[512], select = phone_cache[playerid][data_selected], bool:found_target;
			
			for(new i = MAX_LASTCALL - 1; i >= 0; --i)
			{
				if(lastcallData[playerid][i][lastcall_type]>0)
				{
					if(count > 3)
					{
						if(found_target) break;
						else count = 0;
					}
					
					if(select == -1) {
					
						select=
						phone_cache[playerid][data_selected] = i;
						
						found_target = true;
					}
					else {
						if(select == i) {
							found_target = true;
						}
					}
					
					new contactid = GetPlayerContactByNumber(playerid, strval(lastcallData[playerid][i][lastcall_number]));
					if(contactid == -1) {
						format(str, sizeof(str), "%s%s%s"EMBED_WHITE"", str, (lastcallData[playerid][i][lastcall_type]==1) ? (">") : (lastcallData[playerid][i][lastcall_type] == 2) ? ("<") : ("<"EMBED_LIGHTRED""), lastcallData[playerid][i][lastcall_number]);
					}
					else {
						format(str, sizeof(str), "%s%s%s"EMBED_WHITE"", str, (lastcallData[playerid][i][lastcall_type]==1) ? (">") : (lastcallData[playerid][i][lastcall_type] == 2) ? ("<") : ("<"EMBED_LIGHTRED""), contactData[playerid][contactid][contactName]);
					}
					/*PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][count]], str);
					PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][count]], (select == i) ? 0x989898FF : 0x000000FF);
					PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][count]], (select == i) ? 0x222222FF : 0xAAAAAAFF);
					PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][count]]);	*/
					phone_cache[playerid][phone_data][count] = i;
					count++;
				}
			}
			
			if(count==0)
			{
				Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "แจ้งเตือน", "\nประวัติการโทรของคุณ\nว่างเปล่า", "", "ปิด");
				/*PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_TEXT]]);
				
				PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]], "Back");
				PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]]);*/
			}
			else
			{
				strcat(str, "\n<<\n>>");
				Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_LIST, "SF Telefon", str, "เลือก", "กลับ");
			}
		}
		case PP_CONTACTLIST, PP_SMS_CONTACT, PP_CALLS_CONTACT: {
		
			new count = 0, str[512], select = phone_cache[playerid][data_selected], bool:found_target;

			for(new i=0;i!=MAX_CONTACT_LIST;++i)
			{
				if(contactData[playerid][i][contactID])
				{
					if(count > 3)
					{
						if(found_target) break;
						else count = 0;
					}
					
					if(select == -1) {
					
						select=
						phone_cache[playerid][data_selected]=i;
						
						found_target = true;
					}
					else {
						if(select == i) {
							found_target = true;
						}
					}
					
					format(str, sizeof str, "%s\n%s", str, contactData[playerid][i][contactName]);
					/*PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][count]], contactData[playerid][i][contactName]);
					PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][count]], (select == i) ? 0x989898FF : 0x000000FF);
					PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][count]], (select == i) ? 0x222222FF : 0xAAAAAAFF);
					PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][count]]);	*/
					
					phone_cache[playerid][phone_data][count] = i;
					
					count++;
				}
			}

			if(count==0)
			{
				Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "แจ้งเตือน", "\nรายชื่อผู้ติดต่อในปัจจุบัน\nว่างเปล่า", "", "ปิด");
				/*PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_TEXT]]);
				
				PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]], "Back");
				PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]]);*/
			}
			else
			{
				/*if(count < MAX_PHONE_CHOICE) {
					PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_LTEXT]], "Select");
					PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_LTEXT]]);
					PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]], "Back");
					PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]]);
				
					for(;count!=MAX_PHONE_CHOICE;++count)
						PlayerTextDrawHide(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][count]]);
				}*/
				strcat(str, "\n<<\n>>");
				Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_LIST, "SF Telefon", str, "เลือก", "กลับ");
			}
			
		}
		case PP_CONTACTDETAIL: {
		
			new cid = phone_cache[playerid][data_selected];

			Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "SF Telefon", "\n%s\n(%d)", "ตัวเลือก", "กลับ", contactData[playerid][cid][contactName], contactData[playerid][cid][contactNumber]);
		
			/*PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_TEXT]], str);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_TEXT]]);

			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_LTEXT]], "Options");
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_LTEXT]]);
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]], "Back");
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]]);*/
		}
		
		case PP_CONTACTACTION: {
			/*PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], "Call");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], (phone_cache[playerid][row_selected] == 0) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], (phone_cache[playerid][row_selected] == 0) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]]);
		
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], "Text");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][row_selected] == 1) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][row_selected] == 1) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]]);			
		
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], "Delete");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], (phone_cache[playerid][row_selected] == 2) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], (phone_cache[playerid][row_selected] == 2) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]]);					
		
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]], "Back");
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]]);*/
			Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_LIST, "SF Telefon", "โทร\nส่งข้อความ\nลบ", "เลือก", "กลับ");
		}
		case PP_SMS: {
			/*PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], "SMS a contact");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], (phone_cache[playerid][row_selected] == 0) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], (phone_cache[playerid][row_selected] == 0) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]]);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], "SMS a number");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][row_selected] == 1) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][row_selected] == 1) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]]);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], "Inbox");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], (phone_cache[playerid][row_selected] == 2) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], (phone_cache[playerid][row_selected] == 2) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]]);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][3]], "Archive");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][3]], (phone_cache[playerid][row_selected] == 3) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][3]], (phone_cache[playerid][row_selected] == 3) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][3]]);*/
			Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_LIST, "SF Telefon", "ส่งข้อความหาผู้ติดต่อ\nส่งข้อความหาเบอร์โทร\nกล่องข้อความ\nข้อความที่ถูกกักเก็บ", "เลือก", "กลับ");
			
		}
		case PP_SMS_INBOX, PP_SMS_ARCHIVE: {
		
			new count = 0, str[512], select = phone_cache[playerid][data_selected], bool:found_target;

			for(new i=0;i!=MAX_SMS;++i)
			{
				if(smsData[playerid][i][smsID] && (phone_cache[playerid][current_page] == PP_SMS_ARCHIVE ? true : false) == smsData[playerid][i][smsIsArchive])
				{
					if(count > 3)
					{
						if(found_target) break;
						else count = 0;
					}
					
					if(select == -1) {
					
						select=
						phone_cache[playerid][data_selected]=i;
						
						found_target = true;
					}
					else {
						if(select == i) {
							found_target = true;
						}
					}
					
					new contactid = GetPlayerContactByNumber(playerid, smsData[playerid][i][smsOwner]);
					if(contactid == -1) {
						format(str, sizeof(str), "%s\n%s%d", str, (!smsData[playerid][i][smsIsRead]) ? ("> ") : (""), smsData[playerid][i][smsOwner]);
					}
					else {
						format(str, sizeof(str), "%s\n%s%s", str, (!smsData[playerid][i][smsIsRead]) ? ("> ") : (""), contactData[playerid][contactid][contactName]);
					}
					PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][count]], str);
					PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][count]], (select == i) ? 0x989898FF : 0x000000FF);
					PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][count]], (select == i) ? 0x222222FF : 0xAAAAAAFF);
					PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][count]]);	
					
					phone_cache[playerid][phone_data][count] = i;
					
					count++;
				}
			}

			if(count==0)
			{
				Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "แจ้งเตือน", "\nยังไม่มีข้อความใน\nไดเรกทอรีนี้", "", "ปิด");
				/*PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_TEXT]]);
				
				PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]], "Back");
				PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]]);*/
			}
			else
			{
				strcat(str, "\n<<\n>>");
				Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_LIST, "SF Telefon", str, "เลือก", "กลับ");
			}
			/*
					new count = 0, next = ph_page[playerid] * 4;

                    for(new i=0;i!=MAX_SMS;++i) if(subid == 3 && !SmsData[playerid][i][smsIsArchive] || subid == 4 && SmsData[playerid][i][smsIsArchive])
                    {
                        if(i < 4) ph_data[playerid][i]=-1;

                    	if(SmsData[playerid][i][smsExist])
				        {
	                        if(next)
	                        {
	                            next--;
	                            continue;
	                        }
							if(count > 3)
							{
							    break;
							}
							format(str, sizeof(str), "%s%s", (!SmsData[playerid][i][smsIsRead]) ? ("~>~ ") : (""), GetContactName(playerid, SmsData[playerid][i][smsOwner]));
                            //printf(str);
							PlayerTextDrawSetString(playerid, TDPhone_Choice[playerid][count], str);
							PlayerTextDrawColor(playerid, TDPhone_Choice[playerid][count], (select == count) ? 0x989898FF : 0x000000FF);
							PlayerTextDrawBoxColor(playerid, TDPhone_Choice[playerid][count], (select == count) ? 0x222222FF : 0xAAAAAAFF);
							PlayerTextDrawShow(playerid, TDPhone_Choice[playerid][count]);
							ph_data[playerid][count] = i + 1;
							count++;
						}
					}

					if(!count)
					{
						PlayerTextDrawSetString(playerid, TDPhone_ScreenText[playerid], "~n~No messages in this~n~directory");
						PlayerTextDrawShow(playerid, TDPhone_ScreenText[playerid]);

						PlayerTextDrawSetString(playerid, TDPhone_TSButton[playerid], "Back");
						PlayerTextDrawShow(playerid, TDPhone_TSButton[playerid]);
					}
					else if(count < 4)
					{
						PlayerTextDrawSetString(playerid, TDPhone_TFButton[playerid], "Select");
						PlayerTextDrawShow(playerid, TDPhone_TFButton[playerid]);

						PlayerTextDrawSetString(playerid, TDPhone_TSButton[playerid], "Back");
						PlayerTextDrawShow(playerid, TDPhone_TSButton[playerid]);
					}*/
		}
		case PP_DIALING: {
	
			/*new display_name[46];
			GetPVarString(playerid, "CallDisplay", display_name, 32);
			format(display_name, sizeof(display_name), "~n~Dialing %s", display_name);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_TEXT]], display_name);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_TEXT]]);
	
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]], "Hangup");
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]]);*/
		
			new display_name[46];
			GetPVarString(playerid, "CallDisplay", display_name, 32);
			Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "SF Telefon", "\nกำลังต่อสาย %s", "", "วางสาย", display_name);
		}
		case PP_CALLING: {
			/*new display_name[46];
			GetPVarString(playerid, "CallDisplay", display_name, 32);
			format(display_name, sizeof(display_name), "~n~Call with %s", display_name);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_TEXT]], display_name);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_TEXT]]);
	
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]], "Hangup");
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]]);*/
			new display_name[46];
			GetPVarString(playerid, "CallDisplay", display_name, 32);
			Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "SF Telefon", "\n%s อยู่ในสาย", "", "วางสาย", display_name);
		}
		case PP_INCOMING: {
			/*new display_name[46];
			GetPVarString(playerid, "CallDisplay", display_name, 32);
			format(display_name, sizeof(display_name), "~n~Incoming call %s", display_name);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_TEXT]], display_name);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_TEXT]]);
	
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_LTEXT]], "Answer");
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_LTEXT]]);
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]], "Igonore");
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]]);*/
			new display_name[46];
			GetPVarString(playerid, "CallDisplay", display_name, 32);
			Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "SF Telefon", "\n%s ได้โทรหาคุณ", "รับสาย", "ปฏิเสธ", display_name);
		}
		case PP_CALLS: {
			/*PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], "Dial a contact");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], (phone_cache[playerid][row_selected] == 0) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], (phone_cache[playerid][row_selected] == 0) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]]);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], "Dial a number");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][row_selected] == 1) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][row_selected] == 1) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]]);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], "View call history");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], (phone_cache[playerid][row_selected] == 2) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], (phone_cache[playerid][row_selected] == 2) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]]);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_LTEXT]], "Select");
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_LTEXT]]);
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]], "Back");
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]]);*/
			Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_LIST, "SF Telefon", "ต่อสายหาผู้ติดต่อ\nต่อสายด้วยเบอร์โทร\nดูประวัติการโทร", "เลือก", "กลับ");
		}
		case PP_SETTINGS: {
			/*PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], "Change Ringtone");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], (phone_cache[playerid][row_selected] == 0) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], (phone_cache[playerid][row_selected] == 0) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]]);

			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][mode_airplane]) ? ("Disable airplane mode") : ("Enable airplane mode"));
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][row_selected] == 1) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][row_selected] == 1) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]]);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], (phone_cache[playerid][mode_silent]) ? ("Disable silent mode") : ("Enable silent mode"));
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], (phone_cache[playerid][row_selected] == 2) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], (phone_cache[playerid][row_selected] == 2) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]]);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][3]], "Phone Info");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][3]], (phone_cache[playerid][row_selected] == 3) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][3]], (phone_cache[playerid][row_selected] == 3) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][3]]);	*/
			Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_LIST, "SF Telefon", "เปลี่ยนเสียงรอสาย\n%s\n%s\nข้อมูลโทรศัพท์", "เลือก", "กลับ", (phone_cache[playerid][mode_airplane]) ? ("ปิดโหมดเครื่องบิน") : ("เปิดโหมดเครื่องบิน"), (phone_cache[playerid][mode_silent]) ? ("ปิดโหมดเงียบ") : ("เปิดโหมดเงียบ"));		
		}
		case PP_SETTINGS_RINGTONE: {
			/*PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], "Call ringtone");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], (phone_cache[playerid][row_selected] == 0) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], (phone_cache[playerid][row_selected] == 0) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]]);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], "Text ringtone");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][row_selected] == 1) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][row_selected] == 1) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]]);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_LTEXT]], "Select");
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_LTEXT]]);
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]], "Back");
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]]);
*/
			Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_LIST, "SF Telefon", "เสียงเรียกเข้า\nเสียงข้อความ", "เลือก", "กลับ");	
		}
		case PP_SETTINGS_RINGTONE_T: {
			/*PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], "Ringtone 1");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], (phone_cache[playerid][row_selected] == 0) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], (phone_cache[playerid][row_selected] == 0) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]]);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], "Ringtone 2");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][row_selected] == 1) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][row_selected] == 1) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]]);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], "Ringtone 3");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], (phone_cache[playerid][row_selected] == 2) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], (phone_cache[playerid][row_selected] == 2) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]]);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_LTEXT]], "Select");
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_LTEXT]]);
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]], "Back");
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]]);*/

			Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_LIST, "SF Telefon", "เสียงที่ 1\nเสียงที่ 2\nเสียงที่ 3", "เลือก", "กลับ");	
		}
		case PP_SETTINGS_RINGTONE_C: {
			/*PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], "Ringtone 1");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], (phone_cache[playerid][row_selected] == 0) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]], (phone_cache[playerid][row_selected] == 0) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][0]]);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], "Ringtone 2");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][row_selected] == 1) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]], (phone_cache[playerid][row_selected] == 1) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][1]]);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], "Ringtone 3");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], (phone_cache[playerid][row_selected] == 2) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]], (phone_cache[playerid][row_selected] == 2) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][2]]);
			
			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][3]], "Ringtone 4");
			PlayerTextDrawColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][3]], (phone_cache[playerid][row_selected] == 3) ? 0x989898FF : 0x000000FF);
			PlayerTextDrawBoxColor(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][3]], (phone_cache[playerid][row_selected] == 3) ? 0x222222FF : 0xAAAAAAFF);
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_CHOICE][3]]);*/
			Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_LIST, "SF Telefon", "เสียงที่ 1\nเสียงที่ 2\nเสียงที่ 3\nเสียงที่ 4", "เลือก", "กลับ");	
		}
		case PP_SETTINGS_PHONEINFO: {
			Dialog_Show(playerid, D_PHONE, DIALOG_STYLE_MSGBOX, "แจ้งเตือน", "\nโครงสร้าง: เวอร์ชั่น 1", "", "ปิด");

			/*PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_TEXT]]);

			PlayerTextDrawSetString(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]], "Close");
			PlayerTextDrawShow(playerid, phonePlayerTextDraw[playerid][phonePlayerTextDrawID[playerid][E_PHONE_TEXTDRAW_SCREEN_RTEXT]]);*/
		}
	}
	return 1;
}

ptask PlayerPhoneTimer[1000](playerid) {

	// Update Clock
	if(playerUsingPhone{playerid} && phone_cache[playerid][current_page] == PP_HOME) {
		PHONE_Update(playerid);
	}

	if (phone_cache[playerid][calltype] != CALL_TYPE_NONE)
	{
		phone_cache[playerid][calltime]++;
		if (!GetPVarType(playerid, "callLine")) {
			if (GetPVarType(playerid, "IncomingFrom")) {
				// มีคนโทรมา เล่นเสียงเรียกเข้า ทุก ๆ 10 วินาที
				if (phone_cache[playerid][calltime] % 10 == 1 && !phone_cache[playerid][mode_silent])
				{
					switch(phone_cache[playerid][ringtone_call])
					{
						case 0: PlayerPlaySoundEx(playerid, 23000);
						case 1: PlayerPlaySoundEx(playerid, 20600);
						case 2: PlayerPlaySoundEx(playerid, 20804);
					}

					if(phone_cache[playerid][calltime] == 10)
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* เสียงกริ่งโทรศัพท์ของ %s เริ่มดังขึ้น", ReturnRealName(playerid));

					if(phone_cache[playerid][calltime] >= 300) {
						PC_EmulateCommand(playerid, "/hangup");
					}
				}
			}
		}
		else {
			new targetid = GetPVarInt(playerid, "callLine");
			// เป็นคนโทรออก และคนรับสายยังเชื่อมต่ออยู่
			if (GetPVarType(playerid, "OutgoingTo") && IsPlayerConnected(targetid)) {

				if (GetPlayerRadioSignal(playerid) < 1 || GetPlayerRadioSignal(targetid) < 1)
				{
					SendClientMessage(targetid,  COLOR_GRAD2, "   สายหลุด....");
					forceHangup(playerid);
					return 1;
				}

				if (phone_cache[playerid][calltime] == cchargetime)
				{
					phone_cache[playerid][calltime] = 1;

					if(playerData[playerid][pCash]-(phone_cache[playerid][callServiceCost]+callcost) < 0)
					{
						SendClientMessage(targetid,  COLOR_GRAD2, "   สายหลุด....");
						forceHangup(playerid);
					}
					else {
						phone_cache[playerid][callServiceCost] = phone_cache[playerid][callServiceCost]+callcost;
					}
				}
			}
		}
	}
	return 1;
}

OnPhoneEvent(playerid, event) {
	
	if(Dialog_Opened(playerid))
		Dialog_Close(playerid);
	
	if(phone_cache[playerid][notify_page] != -1) {
		phone_cache[playerid][notify_page]=-1;
		PHONE_Update(playerid);
		return 1;
	}
	switch(phone_cache[playerid][current_page]) {

		case PP_HOME: {
			switch(event) {
				case PHONE_EVENT_LEFTBTN: {
					phone_cache[playerid][current_page] = PP_MENU;
					PHONE_Update(playerid);
				}
				case PHONE_EVENT_RIGHTBTN:
				{
					PHONE_Hide(playerid);
                    PC_EmulateCommand(playerid, "/me เก็บโทรศัพท์ของเขา");
				}
			}
		}
		
		case PP_MENU: {
			switch(event) {
				case PHONE_EVENT_LEFTBTN: {
					switch(phone_cache[playerid][row_selected]) {
						case 0: {
							phone_cache[playerid][row_selected] = 0;
							phone_cache[playerid][current_page] = PP_BOOK;
						}
						case 1: {
							phone_cache[playerid][row_selected] = 0;
							phone_cache[playerid][current_page] = PP_SMS;
						}
						case 2: {
							phone_cache[playerid][row_selected] = 0;
							phone_cache[playerid][current_page] = PP_CALLS;
						}
						case 3: {
							phone_cache[playerid][row_selected] = 0;
							phone_cache[playerid][current_page] = PP_SETTINGS;
						}
					}
				
				}
				case PHONE_EVENT_RIGHTBTN: {
					phone_cache[playerid][current_page] = PP_HOME;
					phone_cache[playerid][row_selected] = 0;
				}

				case PHONE_EVENT_ARROW_UP: {
					phone_cache[playerid][row_selected]--;
					if(phone_cache[playerid][row_selected] < 0) {
						phone_cache[playerid][row_selected] = 0;
					}
				}

				case PHONE_EVENT_ARROW_DN: {
					phone_cache[playerid][row_selected]++;
					if(phone_cache[playerid][row_selected] > 3) {
						phone_cache[playerid][row_selected] = 3;
					}
				}
			}
			PHONE_Update(playerid);
		}
		
		case PP_BOOK: {
			switch(event) {
			
				case PHONE_EVENT_LEFTBTN: {
					switch(phone_cache[playerid][row_selected]) {
						case 0: { // Add a contact
							Dialog_Show(playerid, AddContact, DIALOG_STYLE_INPUT, "ป้อนชื่อ", "เพิ่มผู้ติดต่อ\n\n\t\tใส่ชื่อผู้ติดต่อ:", "ดำเนินการ", "กลับ");
						}
						case 1: { // List contacts
							phone_cache[playerid][current_page] = PP_CONTACTLIST;
							PHONE_Update(playerid);
						}
					}
				}
				
				case PHONE_EVENT_RIGHTBTN: {
					phone_cache[playerid][current_page] = PP_MENU;
					phone_cache[playerid][row_selected] = 0;
					PHONE_Update(playerid);
				}
				
				case PHONE_EVENT_ARROW_UP: {
					phone_cache[playerid][row_selected]--;
					if(phone_cache[playerid][row_selected] < 0) {
						phone_cache[playerid][row_selected] = 0;
					}
					PHONE_Update(playerid);
				}

				case PHONE_EVENT_ARROW_DN: {
					phone_cache[playerid][row_selected]++;
					if(phone_cache[playerid][row_selected] > 1) {
						phone_cache[playerid][row_selected] = 1;
					}
					PHONE_Update(playerid);
				}
			}
		}
		
		case PP_CONTACTLIST: {
			switch(event) {
			
				case PHONE_EVENT_LEFTBTN: {
					if (CountPlayerContact(playerid)) {
						phone_cache[playerid][current_page] = PP_CONTACTDETAIL;
						PHONE_Update(playerid);
					}
				}
				
				case PHONE_EVENT_RIGHTBTN: {

					if(phone_cache[playerid][data_selected] <= 0) {
						phone_cache[playerid][data_selected] = -1;
						phone_cache[playerid][row_selected] = 0;
						phone_cache[playerid][current_page] = PP_BOOK;
						PHONE_Update(playerid);	
						return 1;
					}
					phone_cache[playerid][data_selected] = -1;
					PHONE_Update(playerid);
				}
				
				case PHONE_EVENT_ARROW_UP: {
					new temp_selected = phone_cache[playerid][data_selected];
					SetPlayerToPreviousContact(playerid, phone_cache[playerid][data_selected]);
					if(phone_cache[playerid][data_selected] != temp_selected) {
						PHONE_Update(playerid);
					}
				}

				case PHONE_EVENT_ARROW_DN: {
					new temp_selected = phone_cache[playerid][data_selected];
					SetPlayerToNextContact(playerid, phone_cache[playerid][data_selected]);
					if(phone_cache[playerid][data_selected] != temp_selected) {
						PHONE_Update(playerid);
					}
				}
				
			}
		}
		case PP_CONTACTDETAIL: {
			switch(event) {
			
				case PHONE_EVENT_LEFTBTN: {
					phone_cache[playerid][row_selected] = 0;
					phone_cache[playerid][current_page] = PP_CONTACTACTION;
					PHONE_Update(playerid);
				}

				case PHONE_EVENT_RIGHTBTN: {
					phone_cache[playerid][current_page] = PP_CONTACTLIST;
					PHONE_Update(playerid);
				}
			}
		}
		case PP_CONTACTACTION: {
			switch(event) {
				case PHONE_EVENT_LEFTBTN: {
					switch(phone_cache[playerid][row_selected]) {
						case 0: { // Call
                            new call_string[25];
                            format(call_string, sizeof(call_string), "/call %s", contactData[playerid][phone_cache[playerid][data_selected]][contactName]);
                            PC_EmulateCommand(playerid, call_string);
						}
						case 1: { // SMS
							Dialog_Show(playerid, SMSText, DIALOG_STYLE_INPUT, "บริการส่งข้อความ", "กรอกข้อความ:", "ส่ง", "กลับ");
						}
						case 2: { // Delete
							Dialog_Show(playerid, DeleteContact, DIALOG_STYLE_MSGBOX, "คุณแน่ใจหรือ ?", "คุณแน่ใจไหมที่จะลบ %s (%d) ออกจากรายชื่อผู้ติดต่อ?", "ใช่", "ไม่", contactData[playerid][phone_cache[playerid][data_selected]][contactName], contactData[playerid][phone_cache[playerid][data_selected]][contactNumber]);
						}
					}
				}
		
		
				case PHONE_EVENT_RIGHTBTN: {
					phone_cache[playerid][current_page] = PP_CONTACTDETAIL;
					PHONE_Update(playerid);
				}
				
				case PHONE_EVENT_ARROW_UP: {
					phone_cache[playerid][row_selected]--;
					if(phone_cache[playerid][row_selected] < 0) {
						phone_cache[playerid][row_selected] = 0;
					}
					PHONE_Update(playerid);
				}

				case PHONE_EVENT_ARROW_DN: {
					phone_cache[playerid][row_selected]++;
					if(phone_cache[playerid][row_selected] > 2) {
						phone_cache[playerid][row_selected] = 2;
					}
					PHONE_Update(playerid);
				}
			}
		}
		case PP_DIALING: {
			switch(event) {
				case PHONE_EVENT_RIGHTBTN: {
					/*if(phone_cache[playerid][calltype] == 1) {
						if(GetPVarType(playerid, "OutgoingTo")) {
							new targetid = GetPVarInt(playerid, "OutgoingTo"); // ไอดีผู้เล่นที่ขึ้น incoming call

							new number[MAX_PHONE_NUMBER];
							format(number, sizeof number, "%d", phone_cache[targetid][incoming_call]);
							AddPlayerCallHistory(targetid, number, 3); // Missed Call

							phone_cache[targetid][incoming_call]=0;
							phone_cache[targetid][current_page] = PP_HOME; 
							PHONE_Update(targetid);
						}
						DeletePVar(playerid, "OutgoingTo");	
					}
					phone_cache[playerid][outgoing_call]=0;
					phone_cache[playerid][exist_time]=false;
					phone_cache[playerid][current_page] = PP_HOME;
					stop phone_cache[playerid][ph_timer];
					PHONE_Update(playerid);*/
					PC_EmulateCommand(playerid, "/hangup");
				}
			}
		}
		case PP_CALLING: {
			switch(event) {
				case PHONE_EVENT_RIGHTBTN: {
					/*if(phone_cache[playerid][calltype] == 1) { // โทรคุยกันอยู่แล้วฝ่ายใดฝ่ายหนึ่งวางสาย

						new incomingID = INVALID_PLAYER_ID;
						new OutgoingID = INVALID_PLAYER_ID;

						if(GetPVarType(playerid, "IncomingFrom")) { // เป็นฝ่ายที่รับสาย (Incoming Call)
							OutgoingID = GetPVarInt(playerid, "IncomingFrom"); // ไอดีคนที่โทร
							incomingID = playerid;
							DeletePVar(playerid, "IncomingFrom");	
							DeletePVar(playerid, "IncomingTime");	
						}
						else if(GetPVarType(playerid, "OutgoingTo")) { // เป็นฝ่ายที่โทร (Outgoing Call)
							incomingID = GetPVarInt(playerid, "OutgoingTo"); // ไอดีคนที่รับสาย
							OutgoingID = playerid;
							DeletePVar(playerid, "OutgoingTo");	
						}

						if(incomingID != INVALID_PLAYER_ID) {

							new number[MAX_PHONE_NUMBER];
							valstr(number,phone_cache[incomingID][incoming_call]);
							AddPlayerCallHistory(incomingID, number, 2, GetPVarInt(incomingID, "IncomingTime")); // Incomming Call

							phone_cache[incomingID][callline]=0;
							phone_cache[incomingID][incoming_call]=0;
							phone_cache[incomingID][current_page] = PP_HOME; 
							phone_cache[incomingID][notify_page] = -1;
							PHONE_Update(incomingID);
						}
						else if(OutgoingID != INVALID_PLAYER_ID) {
							phone_cache[OutgoingID][callline]=0;
							phone_cache[OutgoingID][outgoing_call]=0;
							phone_cache[OutgoingID][current_page] = PP_HOME; 
							phone_cache[OutgoingID][notify_page] = -1;
							PHONE_Update(OutgoingID);
						}
						return 1;
					}
					phone_cache[playerid][callline]=0;
					phone_cache[playerid][outgoing_call]=0;
					phone_cache[playerid][incoming_call]=0;
					phone_cache[playerid][current_page] = PP_HOME; 
					phone_cache[playerid][notify_page] = -1;
					PHONE_Update(playerid);*/
					PC_EmulateCommand(playerid, "/hangup");
				}
			}
		}
		case PP_INCOMING: {
			switch(event) {
				case PHONE_EVENT_LEFTBTN: {
					/*if(GetPVarType(playerid, "DialTarget")) {
						new targetid = GetPVarInt(playerid, "DialTarget");
						phone_cache[targetid][current_page] = PP_CALLING;
						phone_cache[targetid][callline]=phone_cache[targetid][outgoing_call];
						PHONE_Update(targetid);

						phone_cache[playerid][current_page] = PP_CALLING;
						phone_cache[playerid][callline]=phone_cache[playerid][incoming_call];
						PHONE_Update(playerid);

						DeletePVar(playerid, "DialTarget");	
						DeletePVar(playerid, "DialActive");	
						DeletePVar(playerid, "DialActiveTime");	
					}*/
					PC_EmulateCommand(playerid, "/pickup");
				}
				case PHONE_EVENT_RIGHTBTN: {
					/*phone_cache[playerid][exist_time]=false;
					phone_cache[playerid][callline]=0;
					phone_cache[playerid][outgoing_call]=0;
					phone_cache[playerid][current_page] = PP_HOME; 
					phone_cache[playerid][notify_page] = -1;
					
					PHONE_Update(playerid);*/
					PC_EmulateCommand(playerid, "/hangup");
				}
			}
		}
		case PP_SMS: {
			switch(event) {
			
				case PHONE_EVENT_LEFTBTN: {
					switch(phone_cache[playerid][row_selected]) {
						case 0: { // SMS a contact
							phone_cache[playerid][current_page] = PP_SMS_CONTACT;
							PHONE_Update(playerid);
						}
						case 1: { // SMS a number
							Dialog_Show(playerid, SMSNumber, DIALOG_STYLE_INPUT, "Insert number", "ส่ง SMS ผ่านหมายเลขโทรศัพท์\n\n\t\tใส่หมายเลขผู้ติดต่อ:", "ดำเนินการ", "กลับ");
						}
						case 2: { // Inbox
							phone_cache[playerid][current_page] = PP_SMS_INBOX;
							PHONE_Update(playerid);
						}
						case 3: { // Archive
							phone_cache[playerid][current_page] = PP_SMS_ARCHIVE;
							PHONE_Update(playerid);
						}
					}
				}
				
				case PHONE_EVENT_RIGHTBTN: {
					phone_cache[playerid][current_page] = PP_MENU;
					phone_cache[playerid][row_selected] = 0;
					PHONE_Update(playerid);
				}
				
				case PHONE_EVENT_ARROW_UP: {
					phone_cache[playerid][row_selected]--;
					if(phone_cache[playerid][row_selected] < 0) {
						phone_cache[playerid][row_selected] = 0;
					}
					PHONE_Update(playerid);
				}

				case PHONE_EVENT_ARROW_DN: {
					phone_cache[playerid][row_selected]++;
					if(phone_cache[playerid][row_selected] > 3) {
						phone_cache[playerid][row_selected] = 3;
					}
					PHONE_Update(playerid);
				}
			}
		}
		case PP_SMS_CONTACT: {
			switch(event) {
			
				case PHONE_EVENT_LEFTBTN: {
					Dialog_Show(playerid, SMSText, DIALOG_STYLE_INPUT, "บริการส่งข้อความ", "กรอกข้อความ:", "ส่ง", "กลับ");		
				}
				
				case PHONE_EVENT_RIGHTBTN: {

					if(phone_cache[playerid][data_selected] == 0 || phone_cache[playerid][data_selected] == -1) {
						phone_cache[playerid][data_selected] = -1;
						phone_cache[playerid][row_selected] = 0;
						phone_cache[playerid][current_page] = PP_SMS;
						PHONE_Update(playerid);	
						return 1;
					}
					phone_cache[playerid][data_selected] = -1;
					PHONE_Update(playerid);
				}
				
				case PHONE_EVENT_ARROW_UP: {
					new temp_selected = phone_cache[playerid][data_selected];
					SetPlayerToPreviousContact(playerid, phone_cache[playerid][data_selected]);
					if(phone_cache[playerid][data_selected] != temp_selected) {
						PHONE_Update(playerid);
					}
				}

				case PHONE_EVENT_ARROW_DN: {
					new temp_selected = phone_cache[playerid][data_selected];
					SetPlayerToNextContact(playerid, phone_cache[playerid][data_selected]);
					if(phone_cache[playerid][data_selected] != temp_selected) {
						PHONE_Update(playerid);
					}
				}
				
			}
		}
		case PP_SMS_INBOX, PP_SMS_ARCHIVE: {
			switch(event) {
			
				case PHONE_EVENT_LEFTBTN: {
	
					new id = phone_cache[playerid][data_selected];
					if(id != -1) {
/*						if(smsData[playerid][id][smsIsRead])
						{
							new str[192], contactid = GetPlayerContactByNumber(playerid, smsData[playerid][id][smsOwner]);
							if(contactid == -1) {
								format(str, sizeof(str), "ผู้ส่ง:\t\t%d\nส่งเมื่อ:  \t\t%s\n\n%s", smsData[playerid][id][smsOwner], smsData[playerid][id][smsDate], smsData[playerid][id][smsText]);
							}
							else {
								format(str, sizeof(str), "ผู้ส่ง:\t\t%s\nส่งเมื่อ:  \t\t%s\n\n%s", contactData[playerid][contactid][contactName], smsData[playerid][id][smsDate], smsData[playerid][id][smsText]);
							}
							
							Dialog_Show(playerid, SMSRead, DIALOG_STYLE_MSGBOX, "SMS", str, "ตัวเลือก", "ปิด");
						}
						else
						{
							//SendClientMessageEx(playerid, -1, "Set Message %d to Read", id);
							smsData[playerid][id][smsIsRead] = true;
							SavePlayerSMS(playerid, id);
							PHONE_Update(playerid);
						}
						*/
						if(!smsData[playerid][id][smsIsRead])
						{
							smsData[playerid][id][smsIsRead] = true;
							SavePlayerSMS(playerid, id);
							PHONE_Update(playerid);
						}
						
						new str[192], contactid = GetPlayerContactByNumber(playerid, smsData[playerid][id][smsOwner]);
						if(contactid == -1) {
							format(str, sizeof(str), "ผู้ส่ง:\t\t%d\nส่งเมื่อ:  \t\t%s\n\n%s", smsData[playerid][id][smsOwner], smsData[playerid][id][smsDate], smsData[playerid][id][smsText]);
						}
						else {
							format(str, sizeof(str), "ผู้ส่ง:\t\t%s\nส่งเมื่อ:  \t\t%s\n\n%s", contactData[playerid][contactid][contactName], smsData[playerid][id][smsDate], smsData[playerid][id][smsText]);
						}
						
						Dialog_Show(playerid, SMSRead, DIALOG_STYLE_MSGBOX, "SMS", str, "ตัวเลือก", "ปิด");
					}
				}
				
				case PHONE_EVENT_RIGHTBTN: {

					if(phone_cache[playerid][data_selected] == 0 || phone_cache[playerid][data_selected] == -1) {
						phone_cache[playerid][data_selected] = -1;
						phone_cache[playerid][row_selected] = 0;
						phone_cache[playerid][current_page] = PP_SMS;
						PHONE_Update(playerid);	
						return 1;
					}
					phone_cache[playerid][data_selected] = -1;
					PHONE_Update(playerid);
				}
				
				case PHONE_EVENT_ARROW_UP: {
					new temp_selected = phone_cache[playerid][data_selected];
					SetPlayerToPreviousSMS(playerid, phone_cache[playerid][current_page] == PP_SMS_ARCHIVE ? true : false, phone_cache[playerid][data_selected]);
					if(phone_cache[playerid][data_selected] != temp_selected) {
						PHONE_Update(playerid);
					}
				}

				case PHONE_EVENT_ARROW_DN: {
					new temp_selected = phone_cache[playerid][data_selected];
					SetPlayerToNextSMS(playerid, phone_cache[playerid][current_page] == PP_SMS_ARCHIVE ? true : false, phone_cache[playerid][data_selected]);
					if(phone_cache[playerid][data_selected] != temp_selected) {
						PHONE_Update(playerid);
					}
				}
				
			}
		}
		case PP_CALLS: {
			switch(event) {
			
				case PHONE_EVENT_LEFTBTN: {
					switch(phone_cache[playerid][row_selected]) {
						case 0: { // Dial a contact
							phone_cache[playerid][current_page] = PP_CALLS_CONTACT;
							PHONE_Update(playerid);
						}
						case 1: { // Dial a number
							Dialog_Show(playerid, CallNumber, DIALOG_STYLE_INPUT, "Insert number", "ติดต่อผ่านหมายเลขโทรศัพท์\n\n\t\tใส่หมายเลขผู้ติดต่อ:", "โทรออก", "กลับ");
						}
						case 2: { // Call History
							phone_cache[playerid][current_page] = PP_CALLS_HISTORY;
							PHONE_Update(playerid);
						}
					}
				}
				
				case PHONE_EVENT_RIGHTBTN: {
					phone_cache[playerid][current_page] = PP_MENU;
					phone_cache[playerid][row_selected] = 0;
					PHONE_Update(playerid);
				}
				
				case PHONE_EVENT_ARROW_UP: {
					phone_cache[playerid][row_selected]--;
					if(phone_cache[playerid][row_selected] < 0) {
						phone_cache[playerid][row_selected] = 0;
					}
					PHONE_Update(playerid);
				}

				case PHONE_EVENT_ARROW_DN: {
					phone_cache[playerid][row_selected]++;
					if(phone_cache[playerid][row_selected] > 2) {
						phone_cache[playerid][row_selected] = 2;
					}
					PHONE_Update(playerid);
				}
			}
		}
		case PP_CALLS_CONTACT: {
			switch(event) {
			
				case PHONE_EVENT_LEFTBTN: {
					if(phone_cache[playerid][data_selected] != -1) {
                        new call_string[25];
                        format(call_string, sizeof(call_string), "/call %s", contactData[playerid][phone_cache[playerid][data_selected]][contactNumber]);
                        PC_EmulateCommand(playerid, call_string);
					}					
				}
				
				case PHONE_EVENT_RIGHTBTN: {

					if(phone_cache[playerid][data_selected] == 0 || phone_cache[playerid][data_selected] == -1) {
						phone_cache[playerid][data_selected] = -1;
						phone_cache[playerid][row_selected] = 0;
						phone_cache[playerid][current_page] = PP_CALLS;
						PHONE_Update(playerid);	
						return 1;
					}
					phone_cache[playerid][data_selected] = -1;
					PHONE_Update(playerid);
				}
				
				case PHONE_EVENT_ARROW_UP: {
					new temp_selected = phone_cache[playerid][data_selected];
					SetPlayerToPreviousContact(playerid, phone_cache[playerid][data_selected]);
					if(phone_cache[playerid][data_selected] != temp_selected) {
						PHONE_Update(playerid);
					}
				}

				case PHONE_EVENT_ARROW_DN: {
					new temp_selected = phone_cache[playerid][data_selected];
					SetPlayerToNextContact(playerid, phone_cache[playerid][data_selected]);
					if(phone_cache[playerid][data_selected] != temp_selected) {
						PHONE_Update(playerid);
					}
				}
				
			}
		}
		case PP_CALLS_HISTORY: {
			switch(event) {
			
				case PHONE_EVENT_LEFTBTN: {
	
					ShowLastCallHistory(playerid);
				}
				
				case PHONE_EVENT_RIGHTBTN: {

					if(MAX_LASTCALL - 1 - phone_cache[playerid][data_selected] == 0 || phone_cache[playerid][data_selected] == -1) {
						phone_cache[playerid][data_selected] = -1;
						phone_cache[playerid][row_selected] = 0;
						phone_cache[playerid][current_page] = PP_CALLS;
						PHONE_Update(playerid);	
						return 1;
					}
					phone_cache[playerid][data_selected] = -1;
					PHONE_Update(playerid);
				}
				
				case PHONE_EVENT_ARROW_UP: {
					new temp_selected = phone_cache[playerid][data_selected];
					SetPlayerToPreviousLastcall(playerid, phone_cache[playerid][data_selected]);
					if(phone_cache[playerid][data_selected] != temp_selected) {
						PHONE_Update(playerid);
					}
				}

				case PHONE_EVENT_ARROW_DN: {
					new temp_selected = phone_cache[playerid][data_selected];
					SetPlayerToNextLastcall(playerid, phone_cache[playerid][data_selected]);
					if(phone_cache[playerid][data_selected] != temp_selected) {
						PHONE_Update(playerid);
					}
				}
				
			}
		}
		case PP_SETTINGS: {
			switch(event) {
				case PHONE_EVENT_LEFTBTN: {
					switch(phone_cache[playerid][row_selected]) {
						case 0: {
							phone_cache[playerid][data_selected] = -1;
							phone_cache[playerid][row_selected] = 0;
							phone_cache[playerid][current_page] = PP_SETTINGS_RINGTONE;
							PHONE_Update(playerid);	
						}
						case 1: {
							phone_cache[playerid][mode_airplane] = !phone_cache[playerid][mode_airplane];
							PHONE_Update(playerid);
						}
						case 2: {
							phone_cache[playerid][mode_silent] = !phone_cache[playerid][mode_silent];
							PHONE_Update(playerid);
						}
						case 3: {
							phone_cache[playerid][data_selected] = -1;
							phone_cache[playerid][row_selected] = 0;
							phone_cache[playerid][current_page] = PP_SETTINGS_PHONEINFO;
							PHONE_Update(playerid);	
						}
					}
				}
				
				case PHONE_EVENT_RIGHTBTN: {
					phone_cache[playerid][current_page] = PP_MENU;
					phone_cache[playerid][row_selected] = 0;
					PHONE_Update(playerid);
				}
				
				case PHONE_EVENT_ARROW_UP: {
					phone_cache[playerid][row_selected]--;
					if(phone_cache[playerid][row_selected] < 0) {
						phone_cache[playerid][row_selected] = 0;
					}
					PHONE_Update(playerid);
				}

				case PHONE_EVENT_ARROW_DN: {
					phone_cache[playerid][row_selected]++;
					if(phone_cache[playerid][row_selected] > 3) {
						phone_cache[playerid][row_selected] = 3;
					}
					PHONE_Update(playerid);
				}
			}
		}
		case PP_SETTINGS_RINGTONE: {
			switch(event) {
				case PHONE_EVENT_LEFTBTN: {
					switch(phone_cache[playerid][row_selected]) {
						case 0: {
							phone_cache[playerid][data_selected] = -1;
							phone_cache[playerid][row_selected] = 0;
							phone_cache[playerid][current_page] = PP_SETTINGS_RINGTONE_T;
							PHONE_Update(playerid);	
						}
						case 1: {
							phone_cache[playerid][data_selected] = -1;
							phone_cache[playerid][row_selected] = 0;
							phone_cache[playerid][current_page] = PP_SETTINGS_RINGTONE_C;
							PHONE_Update(playerid);	
						}
					}
				}
				
				case PHONE_EVENT_RIGHTBTN: {
					phone_cache[playerid][current_page] = PP_SETTINGS;
					phone_cache[playerid][row_selected] = 0;
					PHONE_Update(playerid);
				}
				
				case PHONE_EVENT_ARROW_UP: {
					phone_cache[playerid][row_selected]--;
					if(phone_cache[playerid][row_selected] < 0) {
						phone_cache[playerid][row_selected] = 0;
					}
					PHONE_Update(playerid);
				}

				case PHONE_EVENT_ARROW_DN: {
					phone_cache[playerid][row_selected]++;
					if(phone_cache[playerid][row_selected] > 2) {
						phone_cache[playerid][row_selected] = 2;
					}
					PHONE_Update(playerid);
				}
			}
		}
		case PP_SETTINGS_RINGTONE_T: {
			switch(event) {
				case PHONE_EVENT_LEFTBTN: {
				  	SetPVarInt(playerid, "ringtoneID", phone_cache[playerid][row_selected]);
					Dialog_Show(playerid, TextRingtone, DIALOG_STYLE_MSGBOX, "การยืนยัน", "คุณต้องการตั้งค่าริงโทนนี้ไหม?", "ใช่", "ไม่");
				}
				
				case PHONE_EVENT_RIGHTBTN: {
					phone_cache[playerid][current_page] = PP_SETTINGS_RINGTONE;
					phone_cache[playerid][row_selected] = 0;
					PHONE_Update(playerid);
				}
				
				case PHONE_EVENT_ARROW_UP: {
					phone_cache[playerid][row_selected]--;
					if(phone_cache[playerid][row_selected] < 0) {
						phone_cache[playerid][row_selected] = 0;
					}
					PHONE_Update(playerid);
				}

				case PHONE_EVENT_ARROW_DN: {
					phone_cache[playerid][row_selected]++;
					if(phone_cache[playerid][row_selected] > 2) {
						phone_cache[playerid][row_selected] = 2;
					}
					PHONE_Update(playerid);
				}
			}
		}
		case PP_SETTINGS_RINGTONE_C: {
			switch(event) {
				case PHONE_EVENT_LEFTBTN: {
				  	SetPVarInt(playerid, "ringtoneID", phone_cache[playerid][row_selected]);
					Dialog_Show(playerid, CallRingtone, DIALOG_STYLE_MSGBOX, "การยืนยัน", "คุณต้องการตั้งค่าริงโทนนี้ไหม?", "ใช่", "ไม่");
				}
				
				case PHONE_EVENT_RIGHTBTN: {
					phone_cache[playerid][current_page] = PP_SETTINGS_RINGTONE;
					phone_cache[playerid][row_selected] = 0;
					PHONE_Update(playerid);
				}
				
				case PHONE_EVENT_ARROW_UP: {
					phone_cache[playerid][row_selected]--;
					if(phone_cache[playerid][row_selected] < 0) {
						phone_cache[playerid][row_selected] = 0;
					}
					PHONE_Update(playerid);
				}

				case PHONE_EVENT_ARROW_DN: {
					phone_cache[playerid][row_selected]++;
					if(phone_cache[playerid][row_selected] > 3) {
						phone_cache[playerid][row_selected] = 3;
					}
					PHONE_Update(playerid);
				}
			}
		}
		case PP_SETTINGS_PHONEINFO: {
			switch(event) {
				case PHONE_EVENT_RIGHTBTN: {
					phone_cache[playerid][current_page] = PP_SETTINGS;
					phone_cache[playerid][row_selected] = 0;
					PHONE_Update(playerid);
				}
			}
		}
	}
	return 1;
}

Dialog:TextRingtone(playerid, response, listitem, inputtext[])
{
	if(response) {
		if(GetPVarType(playerid, "ringtoneID")) {
			phone_cache[playerid][ringtone_text] = GetPVarInt(playerid, "ringtoneID");
		}
	}
	DeletePVar(playerid, "ringtoneID");
}

Dialog:CallRingtone(playerid, response, listitem, inputtext[])
{
	if(response) {
		if(GetPVarType(playerid, "ringtoneID")) {
			phone_cache[playerid][ringtone_call] = GetPVarInt(playerid, "ringtoneID");
		}
	}
	DeletePVar(playerid, "ringtoneID");
}

CountUnreadSMS(playerid)
{
	new count;
	for (new x = 0; x != MAX_SMS; x ++) if(smsData[playerid][x][smsID] && !smsData[playerid][x][smsIsRead]) count++;
	return count;
}

CountMissedCall(playerid)
{
	new count;
	for (new x = 0; x < MAX_LASTCALL; x ++)
	{
		if(lastcallData[playerid][x][lastcall_type] == 3 && !lastcallData[playerid][x][lastcall_read]) count++;
	}
	return count;
}


GetPlayerMaximumContact(playerid) {
	new con_max;
	switch(playerData[playerid][pDonateRank])
	{
		case 0: con_max = 16;
		case 1: con_max = 24;
		case 2: con_max = 32;
		case 3: con_max = 40;
		default: con_max = 16;
	}
	return con_max;
}

CountPlayerContact(playerid) {
	new count;
	for (new i = 0; i < MAX_CONTACT_LIST; i ++)
	{
		if(contactData[playerid][i][contactID]) count++;
	}
	return count;
}

ContactFreeSlot(playerid) {
	for (new i = 0; i < MAX_CONTACT_LIST; i ++)
	{
		if(contactData[playerid][i][contactID] == 0) {
			return i;
		}
	}
	return -1;
}

stock GetPlayerNextContact(playerid, current) {
	for (new i = current+1; i < MAX_CONTACT_LIST; i ++)
	{
		if(contactData[playerid][i][contactID]) {
			return i;
		}
	}
	return -1;
}

stock GetPlayerPreviousContact(playerid, current) {
	for (new i = current-1; i >= 0; i --)
	{
		if(contactData[playerid][i][contactID]) {
			return i;
		}
	}
	return -1;
}

SetPlayerToNextContact(playerid, &current) {
	for (new i = current+1; i < MAX_CONTACT_LIST; i ++)
	{
		if(contactData[playerid][i][contactID]) {
			current = i;
			break;
		}
	}
	return 1;
}

SetPlayerToPreviousContact(playerid, &current) {
	for (new i = current-1; i >= 0; i --)
	{
		if(contactData[playerid][i][contactID]) {
			current = i;
			break;
		}
	}
	return 1;
}

SetPlayerToPreviousSMS(playerid, bool:type, &current) {
	for (new i = current-1; i >= 0; i --)
	{
		if(smsData[playerid][i][smsID] && smsData[playerid][i][smsIsArchive] == type) {
			current = i;
			break;
		}
	}
	return 1;
}

SetPlayerToNextSMS(playerid, bool:type, &current) {
	for (new i = current+1; i < MAX_SMS; i ++)
	{
		if(smsData[playerid][i][smsID] && smsData[playerid][i][smsIsArchive] == type) {
			current = i;
			break;
		}
	}
	return 1;
}

GetPlayerContactByNumber(playerid, pnumber) {
	for (new i = 0; i != MAX_CONTACT_LIST; i++) if(contactData[playerid][i][contactID])
	{
		if(contactData[playerid][i][contactNumber] == pnumber) {
			return i;
		}
	}
	return -1;
}

GetPlayerContactByName(playerid, const contact[]) {
	for (new i = 0; i != MAX_CONTACT_LIST; i++) if(contactData[playerid][i][contactID])
	{
		if(strequal(contactData[playerid][i][contactName], contact, true)) {
			return i;
		}
	}
	return -1;
}

SetPlayerToNextLastcall(playerid, &current) {
	// for (new i = current+1; i < MAX_LASTCALL; i ++)
	for(new i = current - 1; i >= 0; --i)
	{
		if(lastcallData[playerid][i][lastcall_type]>0) {
			current = i;
			break;
		}
	}
	return 1;
}

SetPlayerToPreviousLastcall(playerid, &current) {
	// for (new i = current-1; i >= 0; i --)
	for(new i = current + 1; i >= 0; --i) if (i < MAX_LASTCALL)
	{
		if(lastcallData[playerid][i][lastcall_type]>0) {
			current = i;
			break;
		}
	}
	return 1;
}
/*
FindContactByName(playerid, contact[]) {
	for (new i = 0; i != MAX_CONTACT_LIST; i++)
	{
		if(!strcmp(contactData[playerid][i][contactName],contact, true)) {
			return true;
		}
	}
	return false;
}
*/
IsPlayerPhoneStandby(playerid) {
	if(playerUsingPhone{playerid} && phone_cache[playerid][current_page] != PP_NONE) {
		return true;
	}
	return false;
}

forward LoadPlayerSMS(playerid);
public LoadPlayerSMS(playerid) {
	new rows;
	cache_get_row_count(rows);
	if (rows) {

		new temp_bool;
		for (new i = 0; i < rows; i ++) if(i < MAX_SMS)
		{
			cache_get_value_name_int(i, "id", smsData[playerid][i][smsID]);
			cache_get_value_name_int(i, "PhoneOwner", smsData[playerid][i][smsOwner]);
			cache_get_value_name_int(i, "PhoneReceive", smsData[playerid][i][smsReceive]);
			cache_get_value_name(i, "PhoneSMS", smsData[playerid][i][smsText], 128);
			cache_get_value_name(i, "Date", smsData[playerid][i][smsDate], 24);
			
			cache_get_value_name_int(i, "ReadSMS", temp_bool);
			smsData[playerid][i][smsIsRead] = !!temp_bool;
			
			cache_get_value_name_int(i, "Archive", temp_bool);
			smsData[playerid][i][smsIsArchive] = !!temp_bool;
		}
	}
	return 1;
}

SavePlayerSMS(playerid, sms_id) {
	new query[80];
	format(query, sizeof(query), "UPDATE `phone_sms` SET `Archive` = %d, `ReadSMS` = %d WHERE `id` = %d", smsData[playerid][sms_id][smsIsArchive] ? 1 : 0, smsData[playerid][sms_id][smsIsRead] ? 1 : 0, smsData[playerid][sms_id][smsID]);
	mysql_query(dbCon, query);
}
	
forward LoadPlayerContacts(playerid);
public LoadPlayerContacts(playerid) {
	new rows;
	cache_get_row_count(rows);
	if (rows) {
		for (new i = 0; i < rows; i ++)	if(i < MAX_CONTACT_LIST)
		{
			cache_get_value_name_int(i, "contactID", contactData[playerid][i][contactID]);
			cache_get_value_name_int(i, "contactAddee", contactData[playerid][i][contactNumber]);
			cache_get_value_name(i, "contactName", contactData[playerid][i][contactName], 20);
		}
	}
	return 1;
}

SendPlayerCall(playerid, callnumber[]) {
	if(IsPlayerConnected(playerid)) {
		if(phone_cache[playerid][exist_time]) {
			phone_cache[playerid][exist_time]=false;
			
			if(GetPlayerRadioSignal(playerid)) {
				
				switch(phone_cache[playerid][calltype]) {
					case CALL_TYPE_SERVICE: { // Hotline
						switch(phone_cache[playerid][outgoing_call]) {
							case 911: {
								SendClientMessage(playerid, COLOR_YELLOW, "Emergency Dispatch พูด (โทรศัพท์): นี่คือสายด่วน 911 Emergency Dispatch คุณต้องการบริการใด ?");
							}
							case 991: {
								SendClientMessage(playerid, COLOR_YELLOW, "Dispatch พูด (โทรศัพท์): เราขอทราบตำแหน่งในปัจจุบันของคุณ ?");
							}
							case 555: {
								SendClientMessage(playerid, COLOR_YELLOW, "Mechanic Dispatch พูด (โทรศัพท์): บริการช่างยนต์ San Fierro มีอะไรให้เราช่วย ?");
							}
							case 544: {
								SendClientMessage(playerid, COLOR_YELLOW, "Taxi Dispatch พูด (โทรศัพท์): สวัสดี คุณต้องการจะไปที่ไหน ?");
							}
						}
						SetPVarString(playerid, "CallDisplay", callnumber);
						phone_cache[playerid][current_page] = PP_CALLING; 
						phone_cache[playerid][callline] = strval(callnumber);
						if(IsPlayerPhoneStandby(playerid)) {
							PHONE_Update(playerid);
						}
						return 1;
					}
					case CALL_TYPE_PLAYER: { // Private Phone
						new numberid=strval(callnumber);
						foreach (new i : Player)
						{
							if(playerData[playerid][pPnumber] != playerData[i][pPnumber] && (numberid != 0 && playerData[i][pPnumber] == numberid) && !phone_cache[i][exist_time] && !phone_cache[i][outgoing_call] && !phone_cache[i][incoming_call] && !gIsDeathMode{i} && !gIsInjuredMode{i} && !BitFlag_Get(gPlayerBitFlag[i],IS_CUFFED)) {
								
								new contactid = GetPlayerContactByNumber(i, playerData[playerid][pPnumber]), display_name[32];
								if(contactid != -1) {
									format(display_name, sizeof(display_name), "%s~n~(%d)", contactData[i][contactid][contactName], contactData[i][contactid][contactNumber]);
								}
								else {
									format(display_name, sizeof(display_name), "~n~555-%s", callnumber);
								}

								SetPVarString(i, "CallDisplay", display_name);
								phone_cache[i][current_page] = PP_INCOMING;
								phone_cache[i][incoming_call] = playerData[playerid][pPnumber];
								phone_cache[i][calltype] = CALL_TYPE_PLAYER;
								SetPVarInt(i, "IncomingFrom", playerid);
								SetPVarInt(i, "IncomingTime", gettime());
				
								SetPVarInt(playerid, "OutgoingTo", i);

								if(!phone_cache[i][mode_silent])
								{
									if(!playerUsingPhone{i}) {
										//SendClientMessage(i, COLOR_WHITE, "[ ! ] Note: เพื่อสลับโทรศัพท์ใช้ /phone เพื่อนำเมาส์ขึ้นมาใช้ /pc");
										PHONE_Show(i);
									}
									PHONE_Update(i);
									
									switch(phone_cache[i][ringtone_call])
									{
										case 0: PlayerPlaySoundEx(i, 23000);
										case 1: PlayerPlaySoundEx(i, 20600);
										case 2: PlayerPlaySoundEx(i, 20804);
									}
									SendNearbyMessage(i, 30.0, COLOR_PURPLE, "* เสียงกริ่งโทรศัพท์ของ %s เริ่มดังขึ้น", ReturnRealName(i));
								}
								return 1;
							}
						}
					}
					case CALL_TYPE_TOLLFREE: { // Toll Free

					}
					case CALL_TYPE_PAYPHONE: { // Payphone
					
					}
				}

				phone_cache[playerid][outgoing_call]=0;
				phone_cache[playerid][current_page] = PP_HOME; 
				phone_cache[playerid][notify_page] = PHONE_NOTIFY_CALL_FAIL;
				
				if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE) 
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);

				if(IsPlayerPhoneStandby(playerid)) {
					PHONE_Update(playerid);
				}
			}
			else {
				phone_cache[playerid][current_page] = PP_HOME; 
				phone_cache[playerid][notify_page] = PHONE_NOTIFY_NO_SIGNAL;
				
				if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE) 
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);

				if(IsPlayerPhoneStandby(playerid)) {
					PHONE_Update(playerid);
				}
			}
		}
	}
	return 1;
}

SendPlayerSMS(playerid, contactid, phonenumber, const sms_text[]) {
	if(IsPlayerConnected(playerid)) {
		if(phone_cache[playerid][exist_time]) {
			phone_cache[playerid][exist_time]=false;
		
			new targetid = INVALID_PLAYER_ID, target_number;

			foreach (new i : Player)
			{
				if(playerData[playerid][pPnumber] != playerData[i][pPnumber] && ((contactid != -1 && playerData[i][pPnumber] == contactData[playerid][contactid][contactNumber]) || (phonenumber > 0 && playerData[i][pPnumber] == phonenumber))) {

					targetid = i;

					if(phonenumber > 0 && playerData[i][pPnumber] == phonenumber) target_number = phonenumber;
					else target_number = playerData[i][pPnumber];

					break;
				}
			}

			if(targetid != INVALID_PLAYER_ID && GetPlayerRadioSignal(targetid) > 0 && !phone_cache[targetid][mode_airplane] && phone_cache[targetid][current_page] != PP_NONE && !gIsDeathMode{targetid} && !gIsInjuredMode{targetid}) {

				for (new x = 0; x != MAX_SMS; x ++)
				{
					if(!smsData[targetid][x][smsID])
					{		
						new largeQuery[305], phoneDate[24];
						format(phoneDate, sizeof phoneDate, ReturnDateTime(2));
						mysql_format(dbCon, largeQuery, sizeof(largeQuery), "INSERT INTO `phone_sms` (`PhoneReceive`, `PhoneOwner`, `PhoneSMS`, `ReadSMS`, `Archive`, `Date`) VALUES ('%d', '%d', '%e', '0', '0', '%s');", target_number, playerData[playerid][pPnumber], sms_text, phoneDate);
						mysql_query(dbCon, largeQuery);
						
						if(cache_affected_rows() != -1) {
						
							smsData[targetid][x][smsID] = cache_insert_id();
							smsData[targetid][x][smsOwner] = playerData[playerid][pPnumber];
							smsData[targetid][x][smsReceive] = target_number;
							smsData[targetid][x][smsIsArchive]=
							smsData[targetid][x][smsIsRead]=false;
							strmid(smsData[targetid][x][smsText], sms_text, 0, strlen(sms_text), 128);
							strmid(smsData[targetid][x][smsDate], phoneDate, 0, strlen(phoneDate), 24);

							if(!phone_cache[targetid][mode_silent])
							{
								if(!playerUsingPhone{targetid}) 
									PHONE_Show(targetid);
									
								PHONE_Update(targetid);
								
								PHONE_Emotion(targetid, PHONE_EMOTION_MESSAGE);
							}
						
							phone_cache[playerid][notify_page] = PHONE_NOTIFY_SMS_DELIVERY_S;
							if(IsPlayerPhoneStandby(playerid)) {
								PHONE_Emotion(playerid, PHONE_EMOTION_SUCCESS);
								PHONE_Update(playerid);
							}
							return 1;
						}
					}
				}
			}
		
			phone_cache[playerid][notify_page] = PHONE_NOTIFY_SMS_DELIVERY_F;
			if(IsPlayerPhoneStandby(playerid)) {
				PHONE_Emotion(playerid, PHONE_EMOTION_FAIL);
				PHONE_Update(playerid);
			}
		}
	}
	return 1;
}

Dialog:AddContactNum(playerid, response, listitem, inputtext[])
{
	if (response) {

		new name[20];

		GetPVarString(playerid, "ContactName", name, sizeof(name));

		if (!IsNumeric(inputtext) || strlen(inputtext) > 7 || strlen(inputtext) <= 0)
			return Dialog_Show(playerid, AddContactNum, DIALOG_STYLE_INPUT, "Insert number", "เพิ่มผู้ติดต่อ\n\n\t\tใส่หมายเล{FF0000}ขผู้ติดต่อ:\t\tผิดพลาด: หมายเลขที่ระบุไม่ถูกต้อง", "ดำเนินการ", "กลับ");

		new exist, addnumber = strval(inputtext);
		if((exist = ContactFreeSlot(playerid)) != -1 && GetPlayerMaximumContact(playerid) > CountPlayerContact(playerid))
		{
			new query[124];
	     	mysql_format(dbCon, query,sizeof(query),"INSERT INTO `phone_contacts` (`contactAdded`, `contactAddee`, `contactName`) VALUES ('%d', '%d', '%e')", playerData[playerid][pPnumber], addnumber, name);
			mysql_query(dbCon, query);

			contactData[playerid][exist][contactID] = cache_insert_id();
			contactData[playerid][exist][contactNumber] = addnumber;
			format(contactData[playerid][exist][contactName], 20, name);
			
			phone_cache[playerid][current_page] = PP_CONTACTLIST;
			phone_cache[playerid][data_selected]=exist;
			PHONE_Update(playerid);
		}
		else
		{
			phone_cache[playerid][notify_page]=PHONE_NOTIFY_CONTACT_FULL;
			PHONE_Update(playerid);
		}
	}
	else {
	    DeletePVar(playerid, "ContactName");
	    Dialog_Show(playerid, AddContact, DIALOG_STYLE_INPUT, "ป้อนชื่อ", "เพิ่มผู้ติดต่อ\n\n\t\tใส่ชื่อผู้ติดต่อ:", "ดำเนินการ", "กลับ");
	}
	return 1;
}

Dialog:AddContact(playerid, response, listitem, inputtext[])
{
	if (response) {

		if(strlen(inputtext) < 2 || strlen(inputtext) > 20)
		    return Dialog_Show(playerid, AddContact, DIALOG_STYLE_INPUT, "ป้อนชื่อ", "เพิ่มผู้ติดต่อ\n\n\t\tใส่ช{FF0000}ื่อผู้ติดต่อ:\t\tผิดพลาด: ผู้ติดต่อจะต้องมีความยาว 2-20 ของสัญลักษณ์", "ดำเนินการ", "กลับ");

		if(!IsEnglishAndNumber(inputtext))
		    return Dialog_Show(playerid, AddContact, DIALOG_STYLE_INPUT, "ป้อนชื่อ", "เพิ่มผู้ติดต่อ\n\n\t\tใส่ช{FF0000}ื่อผู้ติดต่อ:\t\tผิดพลาด: พบสัญลักษณ์ที่ไม่ถูกต้อง", "ดำเนินการ", "กลับ");

		//[a-zA-Z0-9]+
		SetPVarString(playerid, "ContactName", inputtext);
        Dialog_Show(playerid, AddContactNum, DIALOG_STYLE_INPUT, "Insert number", "เพิ่มผู้ติดต่อ\n\n\t\tใส่หมายเลขผู้ติดต่อ:", "ดำเนินการ", "กลับ");
	}
	return 1;
}

Dialog:DeleteContact(playerid, response, listitem, inputtext[])
{
	if (response) {

		new query[128];
		format(query, sizeof(query), "DELETE FROM `phone_contacts` WHERE `contactID` = %d", contactData[playerid][phone_cache[playerid][data_selected]][contactID]);
  		mysql_query(dbCon, query);

  		contactData[playerid][phone_cache[playerid][data_selected]][contactID]=0;
  		contactData[playerid][phone_cache[playerid][data_selected]][contactNumber]=0;

		phone_cache[playerid][current_page] = PP_CONTACTLIST;
		phone_cache[playerid][data_selected] = GetPlayerPreviousContact(playerid, phone_cache[playerid][data_selected]);
		PHONE_Update(playerid);
		
	}
	return 1;
}

Dialog:AddSMSContact(playerid, response, listitem, inputtext[])
{
	if (response) {
		new id = phone_cache[playerid][data_selected];
		if(id != -1) {
			if(strlen(inputtext) < 2 || strlen(inputtext) > 20)
				return Dialog_Show(playerid, AddSMSContact, DIALOG_STYLE_INPUT, "ป้อนชื่อ", "เพิ่มผู้ติดต่อ\n\n\t\tใส่ช{FF0000}ื่อผู้ติดต่อ:\t\tผิดพลาด: ผู้ติดต่อจะต้องมีความยาว 2-20 ของสัญลักษณ์", "ดำเนินการ", "กลับ");

			if(!IsEnglishAndNumber(inputtext))
				return Dialog_Show(playerid, AddSMSContact, DIALOG_STYLE_INPUT, "ป้อนชื่อ", "เพิ่มผู้ติดต่อ\n\n\t\tใส่ช{FF0000}ื่อผู้ติดต่อ:\t\tผิดพลาด: พบสัญลักษณ์ที่ไม่ถูกต้อง", "ดำเนินการ", "กลับ");

			new exist, addnumber = smsData[playerid][id][smsOwner];
			if((exist = ContactFreeSlot(playerid)) != -1 && GetPlayerMaximumContact(playerid) > CountPlayerContact(playerid))
			{
				new query[124];
				mysql_format(dbCon, query,sizeof(query),"INSERT INTO `phone_contacts` (`contactAdded`, `contactAddee`, `contactName`) VALUES ('%d', '%d', '%e')", playerData[playerid][pPnumber], addnumber, inputtext);
				mysql_query(dbCon, query);

				contactData[playerid][exist][contactID] = cache_insert_id();
				contactData[playerid][exist][contactNumber] = addnumber;
				format(contactData[playerid][exist][contactName], 20, inputtext);
				
				phone_cache[playerid][current_page] = PP_CONTACTLIST;
				phone_cache[playerid][data_selected]=exist;
				PHONE_Update(playerid);
			}
			else
			{
				phone_cache[playerid][notify_page]=PHONE_NOTIFY_CONTACT_FULL;
				PHONE_Update(playerid);
			}
		}
	}
	else {
		ShowSMSOption(playerid);
	}
	return 1;
}

Dialog:AddLastCallContact(playerid, response, listitem, inputtext[])
{
	if (response) {
		new id = phone_cache[playerid][data_selected];
		if(id != -1) {
			if(strlen(inputtext) < 2 || strlen(inputtext) > 20)
				return Dialog_Show(playerid, AddLastCallContact, DIALOG_STYLE_INPUT, "ป้อนชื่อ", "เพิ่มผู้ติดต่อ\n\n\t\tใส่ช{FF0000}ื่อผู้ติดต่อ:\t\tผิดพลาด: ผู้ติดต่อจะต้องมีความยาว 2-20 ของสัญลักษณ์", "ดำเนินการ", "กลับ");

			if(!IsEnglishAndNumber(inputtext))
				return Dialog_Show(playerid, AddLastCallContact, DIALOG_STYLE_INPUT, "ป้อนชื่อ", "เพิ่มผู้ติดต่อ\n\n\t\tใส่ช{FF0000}ื่อผู้ติดต่อ:\t\tผิดพลาด: พบสัญลักษณ์ที่ไม่ถูกต้อง", "ดำเนินการ", "กลับ");

			new exist, addnumber = strval(lastcallData[playerid][id][lastcall_number]);
			if((exist = ContactFreeSlot(playerid)) != -1 && GetPlayerMaximumContact(playerid) > CountPlayerContact(playerid))
			{
				new query[124];
				mysql_format(dbCon, query,sizeof(query),"INSERT INTO `phone_contacts` (`contactAdded`, `contactAddee`, `contactName`) VALUES ('%d', '%d', '%e')", playerData[playerid][pPnumber], addnumber, inputtext);
				mysql_query(dbCon, query);

				contactData[playerid][exist][contactID] = cache_insert_id();
				contactData[playerid][exist][contactNumber] = addnumber;
				format(contactData[playerid][exist][contactName], 20, inputtext);
				
				phone_cache[playerid][current_page] = PP_CONTACTLIST;
				phone_cache[playerid][data_selected]=exist;
				PHONE_Update(playerid);
			}
			else
			{
				phone_cache[playerid][notify_page]=PHONE_NOTIFY_CONTACT_FULL;
				PHONE_Update(playerid);
			}
		}
	}
	else {
		if (phone_cache[playerid][current_page] == PP_CALLS_HISTORY) {
			ShowLastCallHistory(playerid);
		}
	}
	return 1;
}

Dialog:SMSRead(playerid, response, listitem, inputtext[])
{
	if (response) {
	    ShowSMSOption(playerid);
	}
	return 1;
}

Dialog:CallNumber(playerid, response, listitem, inputtext[])
{
	if (response) {
		new call_string[25];
		if(phone_cache[playerid][data_selected] != -1) {
            format(call_string, sizeof(call_string), "/call %s", lastcallData[playerid][phone_cache[playerid][data_selected]][lastcall_number]);
            PC_EmulateCommand(playerid, call_string);
		}
		else {
            format(call_string, sizeof(call_string), "/call %s", inputtext);
            PC_EmulateCommand(playerid, call_string);
		}
	}
	return 1;
}

ShowSMSOption(playerid) {
	new id = phone_cache[playerid][data_selected];
	return Dialog_Show(playerid, SMSOption, DIALOG_STYLE_LIST, "ตัวเลือก", "ตอบกลับ\nโทรกลับ\n%s\nส่งต่อ\nลบ\n%s", "ดำเนินการ", "กลับ", (!smsData[playerid][id][smsIsArchive]) ? ("เก็บถาวร") : ("นำออกจากที่เก็บถาวร"), (GetPlayerContactByNumber(playerid,smsData[playerid][id][smsOwner]) == -1) ? ("บันทึกหมายเลขผู้ติดต่อ") : ("ดูรายชื่อผู้ติดต่อ"));
}

Dialog:SMSOption(playerid, response, listitem, inputtext[])
{
	//new nstring[24];
   //new id = phone_cache[playerid][data_selected];

	if (response) {
		switch(listitem)
		{
			case 0: { // ตอบกลับ
			 	Dialog_Show(playerid, SMSText, DIALOG_STYLE_INPUT, "บริการส่งข้อความ", "กรอกข้อความ:", "ส่ง", "กลับ");
			}
		    case 1: { //โทรกลับ
                new call_string[25];
                format(call_string, sizeof(call_string), "/call %d", smsData[playerid][phone_cache[playerid][data_selected]][smsOwner]);
                PC_EmulateCommand(playerid, call_string);
			}
		    case 2: { //เก็บถาวร
				new id = phone_cache[playerid][data_selected];
				if(id != -1) {
					smsData[playerid][id][smsIsArchive] = !smsData[playerid][id][smsIsArchive];
					SavePlayerSMS(playerid, id);
					Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "สำเร็จ", "%s", "ตกลง", "", (smsData[playerid][id][smsIsArchive]) ? ("ข้อความถูกเก็บถาวร") : ("ข้อความถูกนำออกจากที่เก็บถาวร"));
					PHONE_Update(playerid);
				}
			}
		    case 3: { //ส่งต่อ
				Dialog_Show(playerid, ForwardSMS, DIALOG_STYLE_INPUT, "ส่งต่อ SMS", "กรอกหมายเลขโทรศัพท์:", "ส่ง", "กลับ");
			}
		    case 4: { //ลบข้อความ
				Dialog_Show(playerid, DeleteSMS, DIALOG_STYLE_MSGBOX, "คุณแน่ใจหรือ ?", "คุณแน่ใจไหมที่จะลบข้อความนี้?", "ใช่", "ไม่");
			}
		    case 5: { //ผู้ติดต่อ
                new contactid = -1, id = phone_cache[playerid][data_selected];
				if(id != -1 && (contactid = GetPlayerContactByNumber(playerid, smsData[playerid][id][smsOwner])) != -1)
				{
					phone_cache[playerid][data_selected]=contactid;
					phone_cache[playerid][current_page] = PP_CONTACTDETAIL;
					PHONE_Update(playerid);
				}
				else
				{
				    Dialog_Show(playerid, AddSMSContact, DIALOG_STYLE_INPUT, "ป้อนชื่อ", "เพิ่มผู้ติดต่อ\n\n\t\tใส่ชื่อผู้ติดต่อ:", "ดำเนินการ", "กลับ");
				}
			}
		}
	}
	return 1;
}

Dialog:SMSNumber(playerid, response, listitem, inputtext[])
{
	if (response) {
	    SetPVarString(playerid,"SMSPhoneNumber",inputtext);
		Dialog_Show(playerid, SMSText, DIALOG_STYLE_INPUT, "บริการส่งข้อความ", "กรอกข้อความ:", "ส่ง", "กลับ");
	}
	return 1;
}

Dialog:ForwardSMS(playerid, response, listitem, inputtext[])
{
	if (response) {
	    if(strlen(inputtext) > 0 && phone_cache[playerid][data_selected] != -1)
	    {
            new call_string[145];
            format(call_string, sizeof(call_string), "/sms %s %s", inputtext, smsData[playerid][phone_cache[playerid][data_selected]][smsText]);
            PC_EmulateCommand(playerid, call_string);
        }
		else Dialog_Show(playerid, ForwardSMS, DIALOG_STYLE_INPUT, "ส่งต่อ SMS", "กรอกหมายเลขโทรศัพท์:", "ส่ง", "กลับ");
	}
	else {
		ShowSMSOption(playerid);
	}
	return 1;
}

Dialog:DeleteSMS(playerid, response, listitem, inputtext[])
{
	if (response) {

		new id = phone_cache[playerid][data_selected];
		
		if(id != -1) {
			new query[50];
			format(query,sizeof(query),"DELETE FROM `phone_sms` WHERE `id` = %d", smsData[playerid][id][smsID]);
			mysql_query(dbCon, query);
			smsData[playerid][id][smsID]=0;
			
			PHONE_Update(playerid);
		}
	}
	else {
		ShowSMSOption(playerid);
	}
	return 1;
}

Dialog:SMSText(playerid, response, listitem, inputtext[])
{
	if (response) {
	    new call_string[150];
		if(phone_cache[playerid][data_selected] != -1) {
			switch(phone_cache[playerid][data_type]) {
				case 0: { // Contact Data
					format(call_string, sizeof(call_string), "/sms %d %s", contactData[playerid][phone_cache[playerid][data_selected]][contactNumber], inputtext);
				}
				case 1: { // SMS Data
					format(call_string, sizeof(call_string), "/sms %d %s", smsData[playerid][phone_cache[playerid][data_selected]][smsOwner], inputtext);
				}
				case 2: { // LastCall Data
                    format(call_string, sizeof(call_string), "/sms %s %s", lastcallData[playerid][phone_cache[playerid][data_selected]][lastcall_number], inputtext);
                }
			}
		}
		else {	
            new phonenumb[16];
			GetPVarString(playerid, "SMSPhoneNumber", phonenumb, 16);
            format(call_string, sizeof(call_string), "/sms %s %s", phonenumb, inputtext);
		}
        PC_EmulateCommand(playerid, call_string);
	}
	else {
		if (phone_cache[playerid][current_page] == PP_CALLS_HISTORY) {
			ShowLastCallHistory(playerid);
		}
		else if (phone_cache[playerid][current_page] == PP_SMS_INBOX || phone_cache[playerid][current_page] == PP_SMS_ARCHIVE) {
			ShowSMSOption(playerid);
		}
	}
	return 1;
}

ShowLastCallHistory(playerid) {
	new id = phone_cache[playerid][data_selected];
	if(id != -1) {
						
		if(!lastcallData[playerid][id][lastcall_read])
		{
			lastcallData[playerid][id][lastcall_read] = true;
			PHONE_Update(playerid);
		}
		
		new dialog_str[128], str[24], callnumber = strval(lastcallData[playerid][id][lastcall_number]), contactid = GetPlayerContactByNumber(playerid, callnumber);
		if(contactid == -1 || callnumber == 0) {
			format(str, sizeof(str), "%s %s", (lastcallData[playerid][id][lastcall_type]==1) ? ("สายโทรออก") : (lastcallData[playerid][id][lastcall_type] == 2) ? ("สายเรียกเข้า") : ("สายที่ไม่ได้รับ"), lastcallData[playerid][id][lastcall_number]);
		}
		else {
			format(str, sizeof(str), "%s %s", (lastcallData[playerid][id][lastcall_type]==1) ? ("สายโทรออก") : (lastcallData[playerid][id][lastcall_type] == 2) ? ("สายเรียกเข้า") : ("สายที่ไม่ได้รับ"), contactData[playerid][contactid][contactName]);
		}
		
		format(dialog_str, sizeof(dialog_str), "%s\n%d วินาทีที่ผ่านมา\nโทรออก\nส่งข้อความ\n%s", str, gettime()-lastcallData[playerid][id][lastcall_sec], (callnumber > 0) ? (contactid == -1) ? ("บันทึกหมายเลขผู้ติดต่อ") : ("ดูรายชื่อผู้ติดต่อ") : (""));
		Dialog_Show(playerid, LastCall, DIALOG_STYLE_LIST, str, dialog_str, "เลือก", "ปิด");
	}
}

Dialog:LastCall(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new id = phone_cache[playerid][data_selected];
		if(id != -1 ) {
			switch(listitem)
			{
				case 2: {
                    new call_string[25];
                    format(call_string, sizeof(call_string), "/call %s", lastcallData[playerid][id][lastcall_number]);
                    PC_EmulateCommand(playerid, call_string);
				}
				case 3: {
					Dialog_Show(playerid, SMSText, DIALOG_STYLE_INPUT, "บริการส่งข้อความ", "กรอกข้อความ:", "ส่ง", "กลับ");
				}
				case 4: {
				
					new callnumber = strval(lastcallData[playerid][id][lastcall_number]);
					if(callnumber > 0) {
						new contactid = GetPlayerContactByNumber(playerid, callnumber);
						if(contactid == -1) {
							Dialog_Show(playerid, AddLastCallContact, DIALOG_STYLE_INPUT, "ป้อนชื่อ", "เพิ่มผู้ติดต่อ\n\n\t\tใส่ชื่อผู้ติดต่อ:", "ดำเนินการ", "กลับ");
						}
						else {
							phone_cache[playerid][data_selected]=contactid;
							phone_cache[playerid][current_page] = PP_CONTACTDETAIL;
							PHONE_Update(playerid);
						}
					}
				}
				default: {
					ShowLastCallHistory(playerid);
				}
			}
		}
	}
	return 1;
}

AddPlayerCallHistory(playerid, const number[], type, active_time=0)
{
	if(active_time==0) {
		active_time = gettime();
	}

	for(new i = MAX_LASTCALL - 1; i >= 0; --i)
	{
	    if(lastcallData[playerid][i][lastcall_type]==0)
	    {
	        lastcallData[playerid][i][lastcall_sec] = active_time;
	        lastcallData[playerid][i][lastcall_type] = type;
	        lastcallData[playerid][i][lastcall_read] = false;
            format(lastcallData[playerid][i][lastcall_number], MAX_PHONE_NUMBER, number);
			return i;
	    }
	}
	new i = MAX_LASTCALL - 1, tempCall[MAX_LASTCALL][E_LASTCALL_DATA];
	lastcallData[playerid][i][lastcall_sec] = active_time;
	lastcallData[playerid][i][lastcall_type] = type;
	lastcallData[playerid][i][lastcall_read] = false;
    format(lastcallData[playerid][i][lastcall_number], MAX_PHONE_NUMBER, number);
	
	for(new x = 0; x != MAX_LASTCALL; ++x)
	{
		for(new e = 0; e != sizeof(tempCall); ++e)
	    	tempCall[x][E_LASTCALL_DATA:e] = lastcallData[playerid][x][E_LASTCALL_DATA:e];
	}
	SortDeepArray(tempCall, lastcall_sec);
	for(new x = 0; x != MAX_LASTCALL; ++x)
	{
		for(new e = 0; e != sizeof(tempCall); ++e)
			lastcallData[playerid][x][E_LASTCALL_DATA:e] = tempCall[x][E_LASTCALL_DATA:e];
	}
	return i;
}

PhoneCall(playerid, text[]) {

	if(IsCalline(playerid)) {
		new signal = GetPlayerRadioSignal(playerid);
		if(phone_cache[playerid][calltype] == CALL_TYPE_SERVICE && phone_cache[playerid][callline]) {
			switch(phone_cache[playerid][callline]) {
				case 911: {
					switch(GetPVarInt(playerid, "hotlineStep")) {
						case 0: { // เลือกบริการ

							if (strequal(text, "ตำรวจ") || strequal(text, "police")) {
								SendClientMessage(playerid, COLOR_YELLOW, "Emergency Dispatch พูด (โทรศัพท์): เอาล่ะบริการการบังคับใช้กฎหมายจะได้รับการแจ้งเตือน ขอทราบตำแหน่งในปัจจุบันของคุณด้วย?");
							}
							else if (strequal(text, "แพทย์") || strequal(text, "medic")) {
								SendClientMessage(playerid, COLOR_YELLOW, "Emergency Dispatch พูด (โทรศัพท์): เอาล่ะบริการการแพทย์จะได้รับการแจ้งเตือน ขอทราบตำแหน่งในปัจจุบันของคุณด้วย?");
							}
							else if (strequal(text, "ทั้งคู่") || strequal(text, "both")) {
								SendClientMessage(playerid, COLOR_YELLOW, "Emergency Dispatch พูด (โทรศัพท์): เอาล่ะบริการทั้งการบังคับใช้กฎหมายและการแพทย์จะได้รับการแจ้งเตือน ขอทราบตำแหน่งในปัจจุบันของคุณด้วย?");
							}
							else {
								SendClientMessage(playerid, COLOR_YELLOW, "Emergency Dispatch พูด (โทรศัพท์): ขออภัยเราไม่เข้าใจ คุณต้องการบริการใด ?");
								return 0;
							}
							SetPVarString(playerid,"CE_Type", text);
							SetPVarInt(playerid, "hotlineStep", 1);
						}
						case 1: { // แจ้งตำแหน่ง
							if(strlen(text) < 128)
							{
								SetPVarString(playerid,"CE_Loc", FormatTextSignal(text, signal));

								SendClientMessage(playerid, COLOR_YELLOW, "Emergency Dispatch พูด (โทรศัพท์): กรุณาอธิบายถึงสถานการณ์โดยสังเขป");
								SetPVarInt(playerid, "hotlineStep", 2);
							}
							else SendClientMessage(playerid, COLOR_YELLOW, "Emergency Dispatch พูด (โทรศัพท์): ขออภัยเราไม่เข้าใจ ตำแหน่งในปัจจุบันของคุณคืออะไร?");
						}
						case 2: { // แจ้งสถานการณ์
							new temp_situation[128], temp_type[10], temp_location[128], temp_trace[32];
					
							format(temp_situation, sizeof(temp_situation), FormatTextSignal(text, signal));
							GetPVarString(playerid, "CE_Type", temp_type, sizeof(temp_type));
							GetPVarString(playerid, "CE_Loc", temp_location, sizeof(temp_location));
							SendClientMessage(playerid, COLOR_YELLOW, "Emergency Dispatch พูด (โทรศัพท์): ขอบคุณที่โทรมา หน่วยงานนั้นได้ถูกส่งไปยังสถานที่ของคุณแล้ว");

							format(temp_trace, sizeof(temp_trace), GetPlayerLocation(playerid));
							SetPVarString(playerid,"CE_Trace", temp_trace);

							SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_LIGHTBLUE, "|_________________โทรฉุกเฉิน_________________|");
							SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_LIGHTBLUE, "ผู้โทร: [%s] เบอร์: %d แกะรอย: %s", ReturnRealName(playerid), playerData[playerid][pPnumber], temp_trace);
							SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_LIGHTBLUE, "บริการที่ใช้: %s", temp_type);
							SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_LIGHTBLUE, "สถานที่: %s", temp_location);
							SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_LIGHTBLUE, "สถานการณ์: %s", temp_situation);

							SendFactionTypeMessage(FACTION_TYPE_MEDIC, COLOR_LIGHTRED, "|_________________โทรฉุกเฉิน_________________|");
							SendFactionTypeMessage(FACTION_TYPE_MEDIC, COLOR_LIGHTRED, "ผู้โทร: [%s] เบอร์: %d แกะรอย: %s", ReturnRealName(playerid), playerData[playerid][pPnumber], temp_trace);
							SendFactionTypeMessage(FACTION_TYPE_MEDIC, COLOR_LIGHTRED, "บริการที่ใช้: %s", temp_type);
							SendFactionTypeMessage(FACTION_TYPE_MEDIC, COLOR_LIGHTRED, "สถานที่: %s", temp_location);
							SendFactionTypeMessage(FACTION_TYPE_MEDIC, COLOR_LIGHTRED, "สถานการณ์: %s", temp_situation);
							// SetLastCaller(playerid, 911, temp_situation);
							PC_EmulateCommand(playerid, "/hangup");
						}
					}
				}
				case 991: {
					switch(GetPVarInt(playerid, "hotlineStep")) {
						case 0: { // แจ้งตำแหน่ง
							if(strlen(text) < 128)
							{
								SetPVarString(playerid,"CE_Type", "ตำรวจ");
								SetPVarString(playerid,"CE_Loc", FormatTextSignal(text, signal));

								SendClientMessage(playerid, COLOR_YELLOW, "Dispatch พูด (โทรศัพท์): กรุณาอธิบายถึงสถานการณ์โดยสังเขป");
								SetPVarInt(playerid, "hotlineStep", 1);
							}
							else SendClientMessage(playerid, COLOR_YELLOW, "Dispatch พูด (โทรศัพท์): ขออภัยเราไม่เข้าใจ ตำแหน่งในปัจจุบันของคุณคืออะไร?");
						}
						case 1: { // แจ้งสถานการณ์
							new temp_situation[128], temp_type[10], temp_location[128], temp_trace[32];
					
							format(temp_situation, sizeof(temp_situation), FormatTextSignal(text, signal));
							GetPVarString(playerid, "CE_Type", temp_type, sizeof(temp_type));
							GetPVarString(playerid, "CE_Loc", temp_location, sizeof(temp_location));
							SendClientMessage(playerid, COLOR_YELLOW, "Dispatch พูด (โทรศัพท์): ขอบคุณที่โทรมา หน่วยงานนั้นได้รับการแจ้งเตือนแล้วและจะไปถึงให้เร็วที่สุดเท่าที่จะเป็นไปได้");

							format(temp_trace, sizeof(temp_trace), GetPlayerLocation(playerid));
							SetPVarString(playerid,"CE_Trace", temp_trace);

							SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_LIGHTBLUE, "|_________________โทรไม่ฉุกเฉิน_________________|");
							SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_LIGHTBLUE, "ผู้โทร: [%s] เบอร์: %d แกะรอย: %s", ReturnRealName(playerid), playerData[playerid][pPnumber], temp_trace);
							SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_LIGHTBLUE, "บริการที่ใช้: %s", temp_type);
							SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_LIGHTBLUE, "สถานที่: %s", temp_location);
							SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_LIGHTBLUE, "สถานการณ์: %s", temp_situation);
							// SendFactionMessage(FACTION_TYPE_POLICE, COLOR_LIGHTBLUE, "* สำหรับยอมรับการโทรนี้พิมพ์ /rne %d", SetLastCaller(playerid, 991, temp_situation));

							PC_EmulateCommand(playerid, "/hangup");
						}
					}
				}
				case 544: {
					if(strlen(text) < 128)
					{
						DeletePVar(playerid, "ResponseTaxi");

						SendClientMessage(playerid, COLOR_WHITE, "** /taxi check ID เพื่อดูรายละเอียดราคาค่าโดยสารของเขา/เธอ! **");
						SendClientMessage(playerid, COLOR_YELLOW, "Taxi Dispatch พูด (โทรศัพท์): เรียบร้อย เราจะส่งใครสักคนไปให้เร็วที่สุดเท่าที่จะเป็นไปได้");

						SendJobMessage(JOB_TAXI, COLOR_GREEN, "|_________เรียกแท็กซี่_________|");

						SendJobMessage(JOB_TAXI, COLOR_WHITE, "** (ID:%d) %s ได้โทรเรียกแท็กซี่", playerid, ReturnRealName(playerid));
						SendJobMessage(JOB_TAXI, COLOR_WHITE, "จุดหมายปลายทาง: %s", FormatTextSignal(text, signal));

						SendJobMessage(JOB_TAXI, COLOR_WHITE, "** /taxi accept ID เพื่อรับงานนี้");

						SetPVarInt(playerid, "NeedTaxi", 1);
						SetPVarString(playerid,"CallTaxiLoc", FormatTextSignal(text, signal));

						PC_EmulateCommand(playerid, "/hangup");
					}
					else SendClientMessage(playerid, COLOR_LIGHTBLUE, "Taxi Dispatch พูด (โทรศัพท์): ขออภัยเราไม่เข้าใจ คุณต้องการไปที่ไหน?");
				}
				case 555: {
					if(2 < strlen(text) < 128)
					{
						SendClientMessage(playerid, COLOR_YELLOW, "Mechanic Dispatch พูด (โทรศัพท์): ช่างยนต์ที่กำลังปฏิบัติหน้าที่ได้รับการแจ้งเตือนจากคำขอของคุณแล้ว");
	
						SendJobMessage(JOB_MECHANIC, COLOR_GREEN, "|_________สายด่วนช่างยนต์_________|");
						SendJobMessage(JOB_MECHANIC, COLOR_WHITE, "ผู้โทร: %s เบอร์: [%d]", ReturnRealName(playerid), playerData[playerid][pPnumber]);
						SendJobMessage(JOB_MECHANIC, COLOR_WHITE, "เหตุการณ์: %s", FormatTextSignal(text, signal));

						PC_EmulateCommand(playerid, "/hangup");
					}
					else SendClientMessage(playerid, COLOR_YELLOW, "Mechanic Dispatch พูด (โทรศัพท์): ขออภัยเราไม่เข้าใจ มีอะไรให้เราช่วย?");
				}
			}
		}
	}
	return 0;
}

IsCalline(playerid) {
	return (phone_cache[playerid][callline] != 0);
}

callineNumber(playerid) {
	return phone_cache[playerid][callline];
}

speakerStatus(playerid) {
	return phone_cache[playerid][mode_speaker];
}

SetPlayerCallState(playerid, targetid) {
	new contactid = GetPlayerContactByNumber(targetid, playerData[playerid][pPnumber]), display_name[32];
	if(contactid != -1) {
		format(display_name, sizeof(display_name), "%s~n~(%d)", contactData[targetid][contactid][contactName], contactData[targetid][contactid][contactNumber]);
	}
	else {
		format(display_name, sizeof(display_name), "~n~555-%d", playerData[playerid][pPnumber]);
	}
	SetPVarString(targetid, "CallDisplay", display_name);
				
	phone_cache[targetid][current_page] = PP_CALLING; 
	phone_cache[targetid][callline] = playerData[playerid][pPnumber];
	SetPVarInt(targetid, "callLine", playerid);

	if(IsPlayerPhoneStandby(targetid)) {
		PHONE_Update(targetid);
	}
	return 1;
}

alias:pickup("p");
CMD:pickup(playerid) {

    if(gIsDeathMode{playerid} || gIsInjuredMode{playerid} || BitFlag_Get(gPlayerBitFlag[playerid],IS_CUFFED))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถใช้โทรศัพท์ได้ในขณะนี้");

	if (IsCalline(playerid))
		return SendClientMessage(playerid, COLOR_GRAD1, "คุณได้อยู่ในสายเรียบร้อยแล้ว");

	if(GetPVarType(playerid, "IncomingFrom"))
	{
		new targetid = GetPVarInt(playerid, "IncomingFrom"); // คนโทร
		if(targetid != INVALID_PLAYER_ID && IsPlayerConnected(targetid) || !IsCalline(targetid))
		{
			SendClientMessage(targetid,  COLOR_GRAD2, "[ ! ] เขารับสายแล้ว คุณสามารถพูดคุยได้โดยใช้กล่องแชท"); //บอกคนโทรมาเจ้าของสายกดรับแล้ว
			
			SetPlayerCallState(playerid, targetid);
			SetPlayerCallState(targetid, playerid);

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
			return 1;
		}
		else SendClientMessage(playerid,  COLOR_GRAD2, "   ไม่มีสายเรียกเข้าเพื่อรับสาย");
	}
	else SendClientMessage(playerid,  COLOR_GRAD2, "   ไม่มีสายเรียกเข้าเพื่อรับสาย");

	/*new targetid = INVALID_PLAYER_ID;
	if(GetPVarType(playerid, "IncomingFrom")) { // ถูกโทรเข้า
		targetid = GetPVarInt(playerid, "IncomingFrom"); // คนโทร

		// ตัดสายทิ้ง
		new number[MAX_PHONE_NUMBER];
		format(number, sizeof number, "%d", phone_cache[playerid][incoming_call]);

		if(!GetPVarType(playerid, "callLine")) { // รอสาย
			AddPlayerCallHistory(playerid, number, HISTORY_TYPE_MISSCALL); // Missed Call
		}
		else {	// ถือสาย
			AddPlayerCallHistory(playerid, number, HISTORY_TYPE_INCOMING, GetPVarInt(playerid, "IncomingTime")); // Incomming Call
			DeletePVar(targetid, "callLine");
			DeletePVar(playerid, "callLine");
		}

		DeletePVar(playerid, "IncomingFrom");
		DeletePVar(playerid, "IncomingTime");
	}*/
	return 1;
}

alias:hangup("h");
CMD:hangup(playerid) {

	if (phone_cache[playerid][calltype] != CALL_TYPE_NONE) {
		if (phone_cache[playerid][calltype] == CALL_TYPE_PLAYER) {
			new targetid = INVALID_PLAYER_ID;
			if(GetPVarType(playerid, "IncomingFrom")) { // ถูกโทรเข้า
				targetid = GetPVarInt(playerid, "IncomingFrom"); // คนโทร

				if (phone_cache[targetid][callServiceCost]) {
					new str[30];
					format(str, sizeof(str), "~w~The call cost~n~~r~$%d", phone_cache[targetid][callServiceCost]);
					playerData[targetid][pCash] -= phone_cache[targetid][callServiceCost];
					GameTextForPlayer(targetid, str, 5000, 1);
					phone_cache[targetid][callServiceCost] = 0;	
				}
				// ตัดสายทิ้ง
				new number[MAX_PHONE_NUMBER];
				format(number, sizeof number, "%d", phone_cache[playerid][incoming_call]);

				if(phone_cache[playerid][callline] == 0) { // รอสาย
					AddPlayerCallHistory(playerid, number, HISTORY_TYPE_MISSCALL); // Missed Call
				}
				else {	// ถือสาย
					AddPlayerCallHistory(playerid, number, HISTORY_TYPE_INCOMING, GetPVarInt(playerid, "IncomingTime")); // Incomming Call
					DeletePVar(targetid, "callLine");
				}
				DeletePVar(playerid, "IncomingFrom");
				DeletePVar(playerid, "IncomingTime");
			}
			else if(GetPVarType(playerid, "OutgoingTo")) {// โทรออก (เป้าหมายยังไม่ได้รับสาย)
				targetid = GetPVarInt(playerid, "OutgoingTo"); // เป้าหมาย
				
				if (phone_cache[playerid][callServiceCost]) {
					new str[30];
					format(str, sizeof(str), "~w~The call cost~n~~r~$%d", phone_cache[playerid][callServiceCost]);
					playerData[playerid][pCash] -= phone_cache[playerid][callServiceCost];
					GameTextForPlayer(playerid, str, 5000, 1);
					phone_cache[playerid][callServiceCost] = 0;	
				}
				// ยกเลิกการโทรออก
				new number[MAX_PHONE_NUMBER];
				format(number, sizeof number, "%d", phone_cache[targetid][incoming_call]);

				if(phone_cache[playerid][callline] == 0) { // รอสาย
					AddPlayerCallHistory(targetid, number, HISTORY_TYPE_MISSCALL); // Missed Call
				}
				else {	// ถือสาย
					AddPlayerCallHistory(targetid, number, HISTORY_TYPE_INCOMING, GetPVarInt(playerid, "IncomingTime")); // Incomming Call
					DeletePVar(targetid, "callLine");
				}
				DeletePVar(playerid, "OutgoingTo");	
			}

			if (targetid != INVALID_PLAYER_ID) {
				phone_cache[targetid][incoming_call]=0;
				phone_cache[targetid][callline]=0;
				phone_cache[targetid][outgoing_call]=0;
				phone_cache[targetid][current_page] = PP_HOME; 
				phone_cache[targetid][notify_page] = -1;

				if(GetPlayerSpecialAction(targetid) == SPECIAL_ACTION_USECELLPHONE) 
					SetPlayerSpecialAction(targetid, SPECIAL_ACTION_STOPUSECELLPHONE);

				if(IsPlayerPhoneStandby(targetid)) {
					PHONE_Update(targetid);
				}
				phone_cache[targetid][exist_time]=false;
			}
			phone_cache[playerid][exist_time]=false;
		}
		else if (phone_cache[playerid][calltype] == CALL_TYPE_SERVICE) {
			DeletePVar(playerid, "hotlineStep");
		}

		phone_cache[playerid][callline]=0;
		phone_cache[playerid][outgoing_call]=0;
		phone_cache[playerid][current_page] = PP_HOME; 
		phone_cache[playerid][notify_page] = -1;
		phone_cache[playerid][incoming_call]=0;

		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE) 
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);

		if(IsPlayerPhoneStandby(playerid)) {
			PHONE_Update(playerid);
		}
	}
	return 1;
}

CMD:loudspeaker(playerid, params[])
{
    if(gIsDeathMode{playerid} || gIsInjuredMode{playerid})
		return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถใช้โทรศัพท์ได้ในขณะนี้");

	if(phone_cache[playerid][mode_speaker])
	{
		PC_EmulateCommand(playerid, "/me ปิดลำโพงโทรศัพท์ของเขา");
		phone_cache[playerid][mode_speaker] = false;
	}
	else {
		PC_EmulateCommand(playerid, "/me เปิดลำโพงโทรศัพท์ของเขา");
		phone_cache[playerid][mode_speaker] = true;
	}
	return 1;
}

CMD:turn_on(playerid, params[])
{

	if(gIsDeathMode{playerid} || gIsInjuredMode{playerid})
		return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถใช้โทรศัพท์ได้ในขณะนี้");

    if(playerData[playerid][pPnumber]) {
		if (phone_cache[playerid][current_page] == PP_NONE && !GetPVarType(playerid, "togglePhoneState")) {
			SetPVarInt(playerid, "togglePhoneState", 2);
			phone_cache[playerid][current_page] = PP_NONE;
			PHONE_Update(playerid);
			SetTimerEx("TurnOnPhone", 4000, 0, "i", playerid);
		}
	}
  	else SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่มีโทรศัพท์");

	return 1;
}

CMD:turn_off(playerid, params[])
{
    if(gIsDeathMode{playerid} || gIsInjuredMode{playerid})
		return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถใช้โทรศัพท์ได้ในขณะนี้");

	if (IsCalline(playerid))
			return SendClientMessage(playerid, COLOR_GRAD1, "ไม่สามารถปิดเครื่องได้ คุณกำลังอยู่ในสาย");

	if(playerData[playerid][pPnumber])
	{
		if (phone_cache[playerid][current_page] != PP_NONE && !GetPVarType(playerid, "togglePhoneState")) {
			PHONE_HideEmotion(playerid);
			SetPVarInt(playerid, "togglePhoneState", 1);
			phone_cache[playerid][current_page] = PP_NONE;
			PHONE_Update(playerid);

			SetTimerEx("TurnOffPhone", 4000, 0, "i", playerid);
		}
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่มีโทรศัพท์");

	return 1;
}

forward TurnOnPhone(playerid);
public TurnOnPhone(playerid) {
	DeletePVar(playerid, "togglePhoneState");
	phone_cache[playerid][current_page] = PP_HOME;
	PHONE_Update(playerid);
	return 1;
}

forward TurnOffPhone(playerid);
public TurnOffPhone(playerid) {
	phone_cache[playerid][notify_page] = -1;

	DeletePVar(playerid, "togglePhoneState");
	phone_cache[playerid][current_page] = PP_NONE;
	PHONE_Update(playerid);
	return 1;
}

CMD:dropcell(playerid, params[])
{
    if(gIsDeathMode{playerid} || gIsInjuredMode{playerid})
		return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถใช้โทรศัพท์ได้ในขณะนี้");

	if(playerData[playerid][pPnumber])
	{
		new pquery[128];
	    format(pquery, sizeof(pquery), "DELETE FROM phone_contacts WHERE contactAdded = '%d'", playerData[playerid][pPnumber]); // ลบรายชื่อ
		mysql_tquery(dbCon, pquery, "OnDropContract", "i", playerid);
	    format(pquery, sizeof(pquery), "DELETE FROM phone_sms WHERE PhoneReceive = '%d'", playerData[playerid][pPnumber]); // ลบข้อความ
		mysql_tquery(dbCon, pquery, "OnDropSMS", "i", playerid);

		PHONE_Hide(playerid);
		PHONE_HideEmotion(playerid);

     	playerData[playerid][pPnumber] = 0;
		SendClientMessage(playerid, COLOR_WHITE, "   คุณได้ทิ้งโทรศัพท์มือถือ");
	}
	else SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่มีโทรศัพท์");
	return 1;
}

forward OnDropContract(playerid);
public OnDropContract(playerid) {
	for(new i=0;i!=MAX_CONTACT_LIST;++i) {
		contactData[playerid][i][contactID]=0;
		contactData[playerid][i][contactNumber]=0;
	}
	return 1;
}

forward OnDropSMS(playerid);
public OnDropSMS(playerid) {
	for(new i=0;i!=MAX_SMS;++i) {
		smsData[playerid][i][smsID]=0;
	}
	return 1;
}

CMD:cellphonehelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
	if (playerData[playerid][pPnumber]) {
		SendClientMessage(playerid, COLOR_WHITE,"*** HELP *** พิมพ์คำสั่งสำหรับความช่วยเหลือเพิ่มเติม");
		SendClientMessage(playerid, COLOR_GRAD3,"[CELLPHONE] /call /sms (/p)ickup (/h)angup /turn_off /turn_on /dropcell /loudspeaker");
	}
	else SendClientMessage(playerid, COLOR_WHITE,"คุณสามารถซื้อโทรศัพท์มือถือได้ที่ 24-7");

	return 1;
}

timer SelfieTimer[500](playerid) {

	new Keys, ud, lr;
	GetPlayerKeys(playerid,Keys,ud,lr);

	if(lr == KEY_LEFT) {
		GetPlayerPos(playerid,lX[playerid],lY[playerid],lZ[playerid]);
		new Float: n1X, Float: n1Y;
		SelDegree[playerid] += Speed;
		n1X = lX[playerid] + Radius * floatcos(SelDegree[playerid], degrees);
		n1Y = lY[playerid] + Radius * floatsin(SelDegree[playerid], degrees);
		SetPlayerCameraPos(playerid, n1X, n1Y, lZ[playerid] + Height);
		SetPlayerCameraLookAt(playerid, lX[playerid], lY[playerid], lZ[playerid]+ SelAngle[playerid]);
		SetPlayerFacingAngle(playerid, SelDegree[playerid] - 90.0);
	}
	else if(lr == KEY_RIGHT) {

		GetPlayerPos(playerid,lX[playerid],lY[playerid],lZ[playerid]);
		new Float: n1X, Float: n1Y;
		SelDegree[playerid] -= Speed;
		n1X = lX[playerid] + Radius * floatcos(SelDegree[playerid], degrees);
		n1Y = lY[playerid] + Radius * floatsin(SelDegree[playerid], degrees);
		SetPlayerCameraPos(playerid, n1X, n1Y, lZ[playerid] + Height);
		SetPlayerCameraLookAt(playerid, lX[playerid], lY[playerid], lZ[playerid]+ SelAngle[playerid]);
		SetPlayerFacingAngle(playerid, SelDegree[playerid] - 90.0);
	}

	if(ud == KEY_UP) {

		GetPlayerPos(playerid,lX[playerid],lY[playerid],lZ[playerid]);
		new Float: n1X, Float: n1Y;

		if(SelAngle[playerid] < 1.0)
			SelAngle[playerid] += 0.1;

		n1X = lX[playerid] + Radius * floatcos(SelDegree[playerid], degrees);
		n1Y = lY[playerid] + Radius * floatsin(SelDegree[playerid], degrees);
		SetPlayerCameraPos(playerid, n1X, n1Y, lZ[playerid] + Height);
		SetPlayerCameraLookAt(playerid, lX[playerid], lY[playerid], lZ[playerid]+ SelAngle[playerid]);
		SetPlayerFacingAngle(playerid, SelDegree[playerid] - 90.0);
	}
	else if(ud == KEY_DOWN) {

		GetPlayerPos(playerid,lX[playerid],lY[playerid],lZ[playerid]);
		new Float: n1X, Float: n1Y;

		if(SelAngle[playerid] > 0.8)
			SelAngle[playerid] -= 0.1;

		n1X = lX[playerid] + Radius * floatcos(SelDegree[playerid], degrees);
		n1Y = lY[playerid] + Radius * floatsin(SelDegree[playerid], degrees);
		SetPlayerCameraPos(playerid, n1X, n1Y, lZ[playerid] + Height);
		SetPlayerCameraLookAt(playerid, lX[playerid], lY[playerid], lZ[playerid]+ SelAngle[playerid]);
		SetPlayerFacingAngle(playerid, SelDegree[playerid] - 90.0);
	}
	else if(Keys == KEY_SECONDARY_ATTACK || phone_cache[playerid][current_page] == PP_NONE || IsCalline(playerid))
	{
		stop selfieTimer[playerid];
		TogglePlayerControllable(playerid, true);
		SetCameraBehindPlayer(playerid);
		ClearAnimations(playerid);
		selfieTimer[playerid] = Timer:0;
	}
	return 1;
}

forceHangup(playerid) {
	if (phone_cache[playerid][calltype] != CALL_TYPE_NONE) {
		if (phone_cache[playerid][calltype] == CALL_TYPE_PLAYER) {
			new targetid = GetPVarInt(playerid, "callLine");

			if (targetid != INVALID_PLAYER_ID) {
				SendClientMessage(targetid, COLOR_GRAD2, "   สายหลุด....");
			}
		}
		PC_EmulateCommand(playerid, "/hangup");
	}
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	#if defined SV_DEBUG
		printf("phone.pwn: OnPlayerStateChange(playerid %d, newstate %d, oldstate %d)", playerid, newstate, oldstate);
	#endif
	if (newstate == PLAYER_STATE_WASTED)
	{
		forceHangup(playerid);
	}
	return 1;
}

//HOOK CALLBACK PLAYERTEXT
hook OnPlayerText(playerid, text[]){
	static str[128];
	if(IsCalline(playerid)) {
		new signal = GetPlayerRadioSignal(playerid);

		if(GetPVarType(playerid, "callLine")) {
			new temp_targetid = GetPVarInt(playerid, "callLine");
			if(IsPlayerConnected(temp_targetid))
			{
				if(callineNumber(playerid) == playerData[temp_targetid][pPnumber])
				{
					if(speakerStatus(temp_targetid))
					{
						format(str, sizeof(str), "%s พูดว่า [ลำโพง] (โทรศัพท์): %s", ReturnRealName(playerid), text);
						ProxDetector(temp_targetid, 20.0, str);
					}

					format(str, sizeof(str), "%s พูดว่า (โทรศัพท์): %s", ReturnRealName(playerid), FormatTextSignal(text, signal));
					SendClientMessage(temp_targetid, COLOR_YELLOW, str);
				}
			}
		}
		format(str, sizeof(str), "%s พูดว่า (โทรศัพท์): %s", ReturnRealName(playerid), text);
		ProxDetector(playerid, 20.0, str);

		PhoneCall(playerid, text);
		return -1;
	}
	return 0;
}

Dialog:D_PHONE(playerid, response, listitem, inputtext[])
{
	//printf("response: %d listitem: %d inputtext: %s", response, listitem, inputtext);

	if (isequal(inputtext, "<<"))
	{
		phone_cache[playerid][data_selected] = phone_cache[playerid][phone_data][0];
		OnPhoneEvent(playerid, PHONE_EVENT_ARROW_UP);
	}
	else if (isequal(inputtext, ">>"))
	{
		phone_cache[playerid][data_selected] = phone_cache[playerid][phone_data][listitem-2];
		OnPhoneEvent(playerid, PHONE_EVENT_ARROW_DN);
	}
	else if (response && listitem < 0) {
		OnPhoneEvent(playerid, PHONE_EVENT_LEFTBTN);
	}
	else if (!response && listitem < 0) {
		OnPhoneEvent(playerid, PHONE_EVENT_RIGHTBTN);
	}
	else {
		if (!response) {
			OnPhoneEvent(playerid, PHONE_EVENT_RIGHTBTN);
			PHONE_Update(playerid);
			return 1;
		}

		if(phone_cache[playerid][current_page] == PP_CONTACTLIST || 
			phone_cache[playerid][current_page] == PP_SMS_CONTACT || 
			phone_cache[playerid][current_page] == PP_SMS_INBOX ||				
			phone_cache[playerid][current_page] == PP_SMS_ARCHIVE ||
			phone_cache[playerid][current_page] == PP_CALLS_CONTACT ||
			phone_cache[playerid][current_page] == PP_CALLS_HISTORY) 
		{
			phone_cache[playerid][data_selected] = phone_cache[playerid][phone_data][listitem];
			OnPhoneEvent(playerid, PHONE_EVENT_LEFTBTN);
			
			if(phone_cache[playerid][current_page] == PP_CONTACTLIST || phone_cache[playerid][current_page] == PP_SMS_CONTACT) {
				phone_cache[playerid][data_type]=0;
			}
			else if(phone_cache[playerid][current_page] == PP_SMS_INBOX || phone_cache[playerid][current_page] == PP_SMS_ARCHIVE) {
				phone_cache[playerid][data_type]=1;
			}
			else if(phone_cache[playerid][current_page] == PP_CALLS_HISTORY) {
				phone_cache[playerid][data_type]=2;
			}
		}
		else {
			phone_cache[playerid][row_selected]=listitem;
			OnPhoneEvent(playerid, PHONE_EVENT_LEFTBTN);
		}
		if(!Dialog_Opened(playerid)) {
			PHONE_Update(playerid);
		}
		return 1;
	}
	return 1;
}
