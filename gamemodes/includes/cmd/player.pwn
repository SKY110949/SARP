//===========================[ ระบบแต่งรถ ]=================================

#include  <YSI_Coding\y_hooks>
#include  <YSI_Coding\y_va>

#define SPD 			ShowPlayerDialog
#define DSL 			DIALOG_STYLE_LIST
#define DSI             DIALOG_STYLE_INPUT
#define D_TOP       	"[แต่งรถ]"
#define D_OK 			"ตกลง"
#define D_CANCEL 		"ยกเลิก"
#define D_TEXT			"Paintjobs\nColors\nExhausts\nFront Bumper\nRear Bumper\nRoof\nSpoilers\nSide Skirts\nWheels\nCar Stereo\nHydraulics\nNitro"

//#define MAX_GARAGES 	100

#define dialog_TUNING 	1323
#define dialog_TUNING_2	1324

#define COLOR_PRICE		100

//#define COLOR_RED		0xfa5555AA
//#define 0xFFA84DFF	0xFF6600FF

#define SendErrorMessage(%0,%1) \
	SendClientMessage(%0, COLOR_RED, "ERROR | {FFFFFF} "%1)

new PlayerText:TuningBuy[MAX_PLAYERS][12];

enum Vehicle {
    vVehID,
    vOwner[ MAX_PLAYER_NAME ],
	bool:vTuned,
	vSpoiler,
	vHood,
	vRoof,
	vSkirt,
	vLamps,
	vNitro,
	vExhaust,
	vWheels,
	vStereo,
	vHydraulics,
	vFrontBumper,
	vRearBumper,
	vRightVent,
	vLeftVent,
	vColor1,
	vColor2,
	vPaintJob
}
new VehicleInfo[ MAX_VEHICLES ][ Vehicle ];

enum PaintjobInfi {
	vehID,
	pNumber,
	pPrice,
	pName[ 12 ]
};
#define NUMBER_TYPE_PAINTJOB 	36
static const
	pjInfo[ NUMBER_TYPE_PAINTJOB ][ PaintjobInfi ] = {
	{ 483, 0, 100, "Paintjob 1" },
	{ 534, 0, 100, "Paintjob 1" },
	{ 534, 1, 100, "Paintjob 2" },
	{ 534, 2, 100, "Paintjob 3" },
	{ 535, 0, 100, "Paintjob 1" },
	{ 535, 1, 100, "Paintjob 2" },
	{ 535, 2, 100, "Paintjob 3" },
	{ 536, 0, 100, "Paintjob 1" },
	{ 536, 1, 100, "Paintjob 2" },
	{ 536, 2, 100, "Paintjob 3" },
	{ 558, 0, 100, "Paintjob 1" },
	{ 558, 1, 100, "Paintjob 2" },
	{ 558, 2, 100, "Paintjob 3" },
	{ 559, 0, 100, "Paintjob 1" },
	{ 559, 1, 100, "Paintjob 2" },
	{ 559, 2, 100, "Paintjob 3" },
	{ 560, 0, 100, "Paintjob 1" },
	{ 560, 1, 100, "Paintjob 2" },
	{ 560, 2, 100, "Paintjob 3" },
	{ 561, 0, 100, "Paintjob 1" },
	{ 561, 1, 100, "Paintjob 2" },
	{ 561, 2, 100, "Paintjob 3" },
	{ 562, 0, 100, "Paintjob 1" },
	{ 562, 1, 100, "Paintjob 2" },
	{ 562, 2, 100, "Paintjob 3" },
	{ 565, 0, 100, "Paintjob 1" },
	{ 565, 1, 100, "Paintjob 2" },
	{ 565, 2, 100, "Paintjob 3" },
	{ 567, 0, 100, "Paintjob 1" },
	{ 567, 1, 100, "Paintjob 2" },
	{ 567, 2, 100, "Paintjob 3" },
	{ 575, 0, 100, "Paintjob 1" },
	{ 575, 1, 100, "Paintjob 2" },
	{ 576, 0, 100, "Paintjob 1" },
	{ 576, 1, 100, "Paintjob 2" },
	{ 576, 2, 100, "Paintjob 3" }
};

enum ComponentsInfo {
	cID,
	cName[ 40 ],
	cPrice,
	cType
};
#define MAX_COMPONENTS	194
static const
	cInfo[ MAX_COMPONENTS ][ ComponentsInfo ] = {
	{ 1000, "Pro Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1001, "Win Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1002, "Drag Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1003, "Alpha Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1004, "Champ Scoop Hood", 100, CARMODTYPE_HOOD },
	{ 1005, "Fury Scoop Hood", 100, CARMODTYPE_HOOD },
	{ 1006, "Roof Scoop Roof", 100, CARMODTYPE_ROOF },
	{ 1007, "Right Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1008, "5x Nitrous", 100, CARMODTYPE_NITRO },
	{ 1009, "2x Nitrous", 100, CARMODTYPE_NITRO },
	{ 1010, "10x Nitrous", 100, CARMODTYPE_NITRO },
	{ 1011, "Race Scoop Hood", 100, CARMODTYPE_HOOD },
	{ 1012, "Worx Scoop Hood", 100, CARMODTYPE_HOOD },
	{ 1013, "Round Fog Lamp", 100, CARMODTYPE_LAMPS },
	{ 1014, "Champ Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1015, "Race Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1016, "Worx Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1017, "Left Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1018, "Upswept Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1019, "Twin Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1020, "Large Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1021, "Medium Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1022, "Small Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1023, "Fury Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1024, "Square Fog Lamp", 100, CARMODTYPE_LAMPS },
	{ 1025, "Offroad Wheels", 100, CARMODTYPE_WHEELS },
	{ 1026, "Right Alien Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1027, "Left Alien Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1028, "Alien Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1029, "X-Flow Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1030, "Left X-Flow Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1031, "Right X-Flow Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1032, "Alien Roof Vent", 100, CARMODTYPE_ROOF },
	{ 1033, "X-Flow Roof Vent", 100, CARMODTYPE_ROOF },
	{ 1034, "Alien Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1035, "X-Flow Roof Vent", 100, CARMODTYPE_ROOF },
	{ 1036, "Right Alien Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1037, "X-Flow Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1038, "Alien Roof Vent", 100, CARMODTYPE_ROOF },
	{ 1039, "Left X-Flow Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1040, "Left Alien Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1041, "Right X-Flow Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1042, "Right Chrome Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1043, "Slamin Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1044, "Chrome Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1045, "X-Flow Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1046, "Alien Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1047, "Right Alien Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1048, "Right X-Flow Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1049, "Alien Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1050, "X-Flow Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1051, "Left Alien Sideskirt", 100, CARMODTYPE_SPOILER },
	{ 1052, "Left X-Flow Sideskirt", 100, CARMODTYPE_SPOILER },
	{ 1053, "X-Flow Roof", 100, CARMODTYPE_ROOF },
	{ 1054, "Alien Roof", 100, CARMODTYPE_ROOF },
	{ 1055, "Alien Roof", 100, CARMODTYPE_ROOF },
	{ 1056, "Right Alien Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1057, "Right X-Flow Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1058, "Alien Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1059, "X-Flow Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1060, "X-Flow Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1061, "X-Flow Roof", 100, CARMODTYPE_ROOF },
	{ 1062, "Left Alien Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1063, "Left X-Flow Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1064, "Alien Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1065, "Alien Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1066, "X-Flow Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1067, "Alien Roof", 100, CARMODTYPE_ROOF },
	{ 1068, "X-Flow Roof", 100, CARMODTYPE_ROOF },
	{ 1069, "Right Alien Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1070, "Right X-Flow Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1071, "Left Alien Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1072, "Left X-Flow Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1073, "Shadow Wheels", 100, CARMODTYPE_WHEELS },
	{ 1074, "Mega Wheels", 100, CARMODTYPE_WHEELS },
	{ 1075, "Rimshine Wheels", 100, CARMODTYPE_WHEELS },
	{ 1076, "Wires Wheels", 100, CARMODTYPE_WHEELS },
	{ 1077, "Classic Wheels", 100, CARMODTYPE_WHEELS },
	{ 1078, "Twist Wheels", 100, CARMODTYPE_WHEELS },
	{ 1079, "Cutter Wheels", 100, CARMODTYPE_WHEELS },
	{ 1080, "Switch Wheels", 100, CARMODTYPE_WHEELS },
	{ 1081, "Grove Wheels", 100, CARMODTYPE_WHEELS },
	{ 1082, "Import Wheels", 100, CARMODTYPE_WHEELS },
	{ 1083, "Dollar Wheels", 100, CARMODTYPE_WHEELS },
	{ 1084, "Trance Wheels", 100, CARMODTYPE_WHEELS },
	{ 1085, "Atomic Wheels", 100, CARMODTYPE_WHEELS },
	{ 1086, "Stereo Wheels", 100, CARMODTYPE_STEREO },
	{ 1087, "Hydraulics", 100, CARMODTYPE_HYDRAULICS },
	{ 1088, "Alien Roof", 100, CARMODTYPE_ROOF },
	{ 1089, "X-Flow Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1090, "Right Alien Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1091, "X-Flow Roof", 100, CARMODTYPE_ROOF },
	{ 1092, "Alien Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1093, "Right X-Flow Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1094, "Left Alien Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1095, "Right X-Flow Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1096, "Ahab Wheels", 100, CARMODTYPE_WHEELS },
	{ 1097, "Virtual Wheels", 100, CARMODTYPE_WHEELS },
	{ 1098, "Access Wheels", 100, CARMODTYPE_WHEELS },
	{ 1099, "Left Chrome Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1100, "Chrome Grill", 100, -1 }, // Bullbar
	{ 1101, "Left `Chrome Flames` Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1102, "Left `Chrome Strip` Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1103, "Covertible Roof", 100, CARMODTYPE_ROOF },
	{ 1104, "Chrome Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1105, "Slamin Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1106, "Right `Chrome Arches`", 100, CARMODTYPE_SIDESKIRT },
	{ 1107, "Left `Chrome Strip` Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1108, "Right `Chrome Strip` Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1109, "Chrome", 100, -1 }, // Bullbar
	{ 1110, "Slamin", 100, -1 }, // Bullbar
	{ 1111, "Little Sign?", 100, -1 }, // sig
	{ 1112, "Little Sign?", 100, -1 }, // sig
	{ 1113, "Chrome Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1114, "Slamin Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1115, "Chrome", 100, -1 }, // Bullbar
	{ 1116, "Slamin", 100, -1 }, // Bullbar
	{ 1117, "Chrome Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1118, "Right `Chrome Trim` Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1119, "Right `Wheelcovers` Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1120, "Left `Chrome Trim` Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1121, "Left `Wheelcovers` Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1122, "Right `Chrome Flames` Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1123, "Bullbar Chrome Bars", 100, -1 }, // Bullbar
	{ 1124, "Left `Chrome Arches` Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1125, "Bullbar Chrome Lights", 100, -1 }, // Bullbar
	{ 1126, "Chrome Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1127, "Slamin Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1128, "Vinyl Hardtop", 100, CARMODTYPE_ROOF },
	{ 1129, "Chrome Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1130, "Hardtop Roof", 100, CARMODTYPE_ROOF },
	{ 1131, "Softtop Roof", 100, CARMODTYPE_ROOF },
	{ 1132, "Slamin Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1133, "Right `Chrome Strip` Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1134, "Right `Chrome Strip` Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1135, "Slamin Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1136, "Chrome Exhaust", 100, CARMODTYPE_EXHAUST },
	{ 1137, "Left `Chrome Strip` Sideskirt", 100, CARMODTYPE_SIDESKIRT },
	{ 1138, "Alien Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1139, "X-Flow Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1140, "X-Flow Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1141, "Alien Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1142, "Left Oval Vents", 100, CARMODTYPE_VENT_LEFT },
	{ 1143, "Right Oval Vents", 100, CARMODTYPE_VENT_RIGHT },
	{ 1144, "Left Square Vents", 100, CARMODTYPE_VENT_LEFT },
	{ 1145, "Right Square Vents", 100, CARMODTYPE_VENT_RIGHT },
	{ 1146, "X-Flow Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1147, "Alien Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1148, "X-Flow Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1149, "Alien Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1150, "Alien Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1151, "X-Flow Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1152, "X-Flow Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1153, "Alien Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1154, "Alien Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1155, "Alien Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1156, "X-Flow Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1157, "X-Flow Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1158, "X-Flow Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1159, "Alien Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1160, "Alien Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1161, "X-Flow Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1162, "Alien Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1163, "X-Flow Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1164, "Alien Spoiler", 100, CARMODTYPE_SPOILER },
	{ 1165, "X-Flow Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1166, "Alien Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1167, "X-Flow Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1168, "Alien Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1169, "Alien Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1170, "X-Flow Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1171, "Alien Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1172, "X-Flow Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1173, "X-Flow Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1174, "Chrome Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1175, "Slamin Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1176, "Chrome Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1177, "Slamin Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1178, "Slamin Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1179, "Chrome Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1180, "Chrome Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1181, "Slamin Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1182, "Chrome Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1183, "Slamin Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1184, "Chrome Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1185, "Slamin Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1186, "Slamin Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1187, "Chrome Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1188, "Slamin Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1189, "Chrome Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1190, "Slamin Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1191, "Chrome Front Bumper", 100, CARMODTYPE_FRONT_BUMPER },
	{ 1192, "Chrome Rear Bumper", 100, CARMODTYPE_REAR_BUMPER },
	{ 1193, "Slamin Rear Bumper", 100, CARMODTYPE_REAR_BUMPER }
};

enum tpi {
	tID,
	tType,
	bool:tPaintjob,
	PJColor[ 2 ]
};
new TPInfo[ MAX_PLAYERS ][ tpi ];

new globalstring[ 128 ];

// --------------------------------------------------------->


alias:help("ช่วยเหลือ");
CMD:help(playerid) {

	SendClientMessage(playerid, COLOR_GREEN, "___________________________คำสั่งพื้นฐาน___________________________");
	SendClientMessage(playerid, COLOR_GRAD1, "ทั่วไป: /id, /stats (ดูสถานะตัวละคร), /changepass (เปลี่ยนรหัสผ่าน), /pitem, (/s)pawn(c)hange");
	SendClientMessage(playerid, COLOR_GRAD1, "(/c)hange(o)rigin, /buylevel, /pay (ให้เงิน), /frisk (ค้นตัว)");

	SendClientMessage(playerid, COLOR_GRAD1, "แชท: (/o)oc (พูดคุยทั่วทั้งเซิร์ฟเวอร์), /pm (กระซิบ), /b (พูดคุยนอกบทบาท), /me (บอกการกระทำ)");
	SendClientMessage(playerid, COLOR_GRAD1, "แชท: /do (แสดง), /dolow, (/l)ocal หรือ /t (พูดคุยในบทบาทเหมือนพิมพ์พูดธรรมดาแต่ไม่มี Animation), /low (พูดในบทบาทได้ยินในระยะใกล้ ๆ)");

	if (playerData[playerid][pLevel] < 3)
		SendClientMessage(playerid, COLOR_GRAD1, "ผู้เล่นใหม่: /newspaper, (/n)ewbie (พูดคุยทั่วทั้งเซิร์ฟเวอร์)");

	SendClientMessage(playerid, COLOR_GRAD1, "พาหนะ: (/v)ehicle (รถส่วนตัว), (/en)gine, /fuel (เช็คน้ำมัน), /fill (เติมน้ำมัน)");
	SendClientMessage(playerid, COLOR_GRAD1, "อื่น ๆ: /househelp, /businesshelp, /factionhelp, /jobhelp, /fishhelp, /animhelp, /planthelp");
	SendClientMessage(playerid, COLOR_GRAD1, "/drughelp, /tog(ooc|pm|hud), /donate (ช่วยเหลือเซิร์ฟเวอร์ ซื้อสิทธิพิเศษต่าง ๆ), /party (สร้างปาร์ตี้)");
}

alias:id("ไอดี");
CMD:id(playerid, params[])
{
	new ids[MAX_PLAYERS], i;

	if (sscanf(params, "?<MATCH_NAME_PARTIAL=1>u[500]", ids))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /id [ไอดีผู้เล่น/ชื่อบางส่วน]");

	for (i = 0; ids[i] != INVALID_PLAYER_ID; ++ i)
	{
	    if (ids[i] == -1) break;

	    SendClientMessageEx(playerid, COLOR_GRAD1, "[ไอดี %d] %s | เลเวล: %d | คะแนน: %d | เล่นบน: %s", ids[i], ReturnPlayerName(ids[i]), playerData[ids[i]][pLevel], playerData[ids[i]][pScore], isPlayerAndroid(ids[i]) == 0 ? "PC" : "Android");
	}
	if (i == 0) SendClientMessage(playerid, COLOR_GRAD1, "   ไม่พบชื่อหรือไอดีผู้เล่นที่ระบุ");

	return 1;
}

alias:newspaper("ns");
CMD:newspaper(playerid)
{
	if (IsPlayerInRangeOfPoint(playerid, 2.0, -2034.5723,-61.9950,35.3203) || IsPlayerInRangeOfPoint(playerid, 2.0, 1714.9922,-1904.1827,13.5666))
	{
  		Dialog_Show(playerid, DialogNewsPaper, DIALOG_STYLE_LIST, "หนังสือพิมพ์วันนี้", "ข้อมูลพลเมือง\nการจ้างงานและงานที่ถูกกฎหมาย", "อ่านต่อ", "ปิด");
		return 1;
	}
	else SendClientMessage(playerid, COLOR_GREY,"** คุณไม่ได้อยู่ตรงหนังสือพิมพ์");

	return 1;
}

alias:window("wd");
CMD:window(playerid, params[])
{
    new item[16];

    new idcar = GetPlayerVehicleID(playerid);
	if (!IsWindowedVehicle(idcar)) return SendClientMessage(playerid, COLOR_GREY, "คุณไม่ได้อยู่ในยานพาหนะใด ๆ ที่มีหน้าต่าง");

  	if(sscanf(params, "s[32]", item)) {
		 	SendClientMessage(playerid, COLOR_WHITE, "/`[w]in[d]ow [ประตู]");
		    SendClientMessage(playerid, COLOR_YELLOW, "{FFFFFF}1. driver, 2.passenger, 3.backleft, 4.backright");
	}
	else
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
		new wdriver, wpassenger, wbackleft, wbackright;
		GetVehicleParamsCarWindows(vehicleid, wdriver, wpassenger, wbackleft, wbackright);

		if(strcmp(item, "1", true) == 0)
		{
		    if(wdriver == VEHICLE_PARAMS_OFF)
		    {
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "หน้าต่างของรถ %s ฝั่งคนขับถูกปิด (( %s ))", g_arrVehicleNames[GetVehicleModel(idcar) - 400], ReturnRealName(playerid));
				SetVehicleParamsCarWindows(vehicleid, 1, wpassenger, wbackleft, wbackright);
			}
			else if(wdriver == VEHICLE_PARAMS_ON || wdriver == VEHICLE_PARAMS_UNSET)
			{
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "หน้าต่างของรถ %s ฝั่งคนขับถูกเปิด (( %s ))", g_arrVehicleNames[GetVehicleModel(idcar) - 400], ReturnRealName(playerid));
				SetVehicleParamsCarWindows(vehicleid, 0, wpassenger, wbackleft, wbackright);
			}
		}
		if(strcmp(item, "2", true) == 0)
		{
		    if(wpassenger == VEHICLE_PARAMS_OFF)
		    {
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "หน้าต่างของรถ %s ฝั่งผู้โดยสารถูกปิด (( %s ))", g_arrVehicleNames[GetVehicleModel(idcar) - 400], ReturnRealName(playerid));
				SetVehicleParamsCarWindows(vehicleid, wdriver, 1, wbackleft, wbackright);
			}
			else if(wpassenger == VEHICLE_PARAMS_ON || wpassenger == VEHICLE_PARAMS_UNSET)
			{
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "หน้าต่างของรถ %s ฝั่งผู้โดยสารถูกเปิด (( %s ))", g_arrVehicleNames[GetVehicleModel(idcar) - 400], ReturnRealName(playerid));
				SetVehicleParamsCarWindows(vehicleid, wdriver, 0, wbackleft, wbackright);
			}
		}
		if(strcmp(item, "3", true) == 0)
		{
      		if(wbackleft == VEHICLE_PARAMS_OFF)
		    {
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "หน้าต่างหลังซ้ายของรถ %s ถูกปิด (( %s ))", g_arrVehicleNames[GetVehicleModel(idcar) - 400], ReturnRealName(playerid));
				SetVehicleParamsCarWindows(vehicleid, wdriver, wpassenger, 1, wbackright);
			}
			else if(wbackleft == VEHICLE_PARAMS_ON || wbackleft == VEHICLE_PARAMS_UNSET)
			{
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "หน้าต่างหลังซ้ายของรถ %s ถูกเปิด (( %s ))", g_arrVehicleNames[GetVehicleModel(idcar) - 400], ReturnRealName(playerid));
				SetVehicleParamsCarWindows(vehicleid, wdriver, wpassenger, 0, wbackright);
			}
		}
		if(strcmp(item, "4", true) == 0)
		{
		    if(wbackright == VEHICLE_PARAMS_OFF)
		    {
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "หน้าต่างหลังขวาของรถ %s ถูกปิด (( %s ))", g_arrVehicleNames[GetVehicleModel(idcar) - 400], ReturnRealName(playerid));
				SetVehicleParamsCarWindows(vehicleid, wdriver, wpassenger, wbackleft, 1);
			}
			else if(wbackright == VEHICLE_PARAMS_ON || wbackright == VEHICLE_PARAMS_UNSET)
			{
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "หน้าต่างหลังขวาของรถ %s ถูกเปิด (( %s ))", g_arrVehicleNames[GetVehicleModel(idcar) - 400], ReturnRealName(playerid));
				SetVehicleParamsCarWindows(vehicleid, wdriver, wpassenger, wbackleft, 0);
			}
		}
	}
	return 1;
}
CMD:gps(playerid)
{
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "คำสั่งนี้ใช้ได้เฉพาะเมื่อยืนอยู่บนพื้น");
  	Dialog_Show(playerid, DialogNewsPaper, DIALOG_STYLE_LIST, "แผนที่เดินทาง San Andreas", "ข้อมูลพลเมือง\nการจ้างงานและงานที่ถูกกฎหมาย", "อ่านต่อ", "ปิด");
	return 1;
}

Dialog:DialogNewsPaper(playerid, response, listitem, inputtext[]) {
	if (response) {
		switch(listitem) {
			case 0: {
				// ข้อมูลพลเมือง
				return Dialog_Show(playerid, DialogNewsCitizen, DIALOG_STYLE_LIST, "ข้อมูลพลเมือง", "โทรหาแท็กซี่ยังไง\nอาศัยอยู่ไหนได้บ้าง\nการขอความช่วยเหลือจากแพทย์\nการขอความช่วยเหลือจากตำรวจ", "อ่านต่อ", "กลับ");
			}
			case 1: {
				// การจ้างงานและงานที่ถูกกฎหมาย
				return Dialog_Show(playerid, DialogNewsEmployment, DIALOG_STYLE_LIST, "การจ้างงานและงานที่ถูกกฎหมาย", "ชาวไร่\nพนักงานกวาดถนน\nพนักงานเก็บขยะ\nช่างซ่อมรถ\nคนขับรถบรรทุก\nชาวประมง\nพนักงานขุดเหมืองแร่\nพนักงานส่งพิซซ่า\nคนขับรถแท็กซี่", "อ่านต่อ", "กลับ");
			}
		}
	}
	return 1;
}

Dialog:DialogNewsCitizen(playerid, response, listitem, inputtext[]) {
	if (response) {
		switch(listitem) {
			case 0: { // โทรหาแท็กซี่ยังไง
			    SendClientMessage(playerid, COLOR_GREEN,"___________โทรหาแท็กซี่ยังไง:___________");
				SendClientMessage(playerid, COLOR_WHITE,"(/c)all 544");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
			}
			case 1: { // อาศัยอยู่ไหนได้บ้าง
			    SendClientMessage(playerid, COLOR_GREEN,"___________อาศัยอยู่ไหนได้บ้าง:___________");
				SendClientMessage(playerid, COLOR_WHITE,"- จ่ายเพื่อเช่าห้องในโรงแรม");
                SendClientMessage(playerid, COLOR_WHITE,"- เช่าห้องอยู่ในบ้านสักหลัง");
                SendClientMessage(playerid, COLOR_WHITE,"- หรืออาศัยอยู่ที่โรงแรม Garcia");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
			}
			case 2: { // การขอความช่วยเหลือจากแพทย์
			    SendClientMessage(playerid, COLOR_GREEN,"___________การขอความช่วยเหลือจากแพทย์:___________");
				SendClientMessage(playerid, COLOR_WHITE,"(/c)all 911 (พิมพ์เลือกบริการ)");
				SendClientMessage(playerid, COLOR_WHITE,"ชื่อบริการภาษาไทย: แพทย์, ทั้งคู่");
				SendClientMessage(playerid, COLOR_WHITE,"ชื่อบริการภาษาอังกฤษ: medic, both");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
			}
			case 3: { //การขอความช่วยเหลือจากตำรวจ
			    SendClientMessage(playerid, COLOR_GREEN,"___________การขอความช่วยเหลือจากตำรวจ:___________");
				SendClientMessage(playerid, COLOR_WHITE,"(/c)all 911 (พิมพ์เลือกบริการ)");
				SendClientMessage(playerid, COLOR_WHITE,"ชื่อบริการภาษาไทย: ตำรวจ, ทั้งคู่");
				SendClientMessage(playerid, COLOR_WHITE,"ชื่อบริการภาษาอังกฤษ: police, both");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
			}
		}
	}
	else {
		Dialog_Show(playerid, DialogNewsCitizen, DIALOG_STYLE_LIST, "ข้อมูลพลเมือง", "โทรหาแท็กซี่ยังไง\nอาศัยอยู่ไหนได้บ้าง\nการขอความช่วยเหลือจากแพทย์\nการขอความช่วยเหลือจากตำรวจ", "อ่านต่อ", "กลับ");
	}
	return 1;
}

Dialog:DialogNewsEmployment(playerid, response, listitem, inputtext[]) {
	if (response) {
		switch(listitem) {
			case 0: { // ชาวไร่
			    SendClientMessage(playerid, COLOR_GREEN,"___________ชาวไร่:___________");
				SendClientMessage(playerid, COLOR_WHITE,"ชาวไร่ที่เก็บเกี่ยวผลผลิตให้เจ้าของฟาร์ม");
                SendClientMessage(playerid, COLOR_WHITE,"/harvest (คุณจำเป็นต้องมี Combine Harvester)");
                SendClientMessage(playerid, COLOR_YELLOW,"> สถานที่ของอาชีพนี้ถูกทำเครื่องหมายอยู่บนแผนที่");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
				SetPlayerCheckpoint(playerid, -382.5893,-1426.3422,26.2217, 3.5);
				gPlayerCheckpoint{playerid}=true;
			}
			case 1: { // พนักงานกวาดถนน
			    SendClientMessage(playerid, COLOR_GREEN,"___________พนักงานกวาดถนน:___________");
				SendClientMessage(playerid, COLOR_WHITE,"พนักงานกวาดถนนที่เก็บกวาดในพื้นที่ท้องถิ่นระแวกนั้น");
                SendClientMessage(playerid, COLOR_WHITE,"/sweeper (มีให้เช่า)");
                SendClientMessage(playerid, COLOR_YELLOW,"> สถานที่ของอาชีพนี้ถูกทำเครื่องหมายอยู่บนแผนที่");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
				SetPlayerCheckpoint(playerid, -2211.9644,1056.2740,80.0078, 3.5);
				gPlayerCheckpoint{playerid}=true;
			}
			case 2: { // พนักงานเก็บขยะ
			    SendClientMessage(playerid, COLOR_GREEN,"___________พนักงานเก็บขยะ:___________");
				SendClientMessage(playerid, COLOR_WHITE,"พนักงานเก็บขยะในเมืองลอสซานโตส");
                SendClientMessage(playerid, COLOR_WHITE,"/collect (มีให้เช่า)");
                SendClientMessage(playerid, COLOR_YELLOW,"> สถานที่ของอาชีพนี้ถูกทำเครื่องหมายอยู่บนแผนที่");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
				SetPlayerCheckpoint(playerid, 2173.5701,-1982.8094, 13.5513, 3.5);
				gPlayerCheckpoint{playerid}=true;
			}
			case 3: { // ช่างซ่อมรถ
			    SendClientMessage(playerid, COLOR_GREEN,"___________ช่างซ่อมรถ:___________");
				SendClientMessage(playerid, COLOR_WHITE,"ช่างซ่อมและทาสีรถโดยใช้");
				SendClientMessage(playerid, COLOR_WHITE,"ชิ้นส่วนรถยนต์และรถลากจูง");
                SendClientMessage(playerid, COLOR_WHITE,"/service (คุณจำเป็นต้องมี Tow truck)");
                SendClientMessage(playerid, COLOR_YELLOW,"> สถานที่ของอาชีพนี้ถูกทำเครื่องหมายอยู่บนแผนที่");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
				SetPlayerCheckpoint(playerid, 88.4620,-165.0116,2.5938, 3.5);
				gPlayerCheckpoint{playerid}=true;
			}
	        case 4: // Trucker
	        {
		    	SendClientMessage(playerid, COLOR_GREEN,"___________คนขับรถบรรทุก:___________");
				SendClientMessage(playerid, COLOR_WHITE,"รถบรรทุกลอสซานโตส; ทําให้เศรษฐกิจในเมืองเคลื่อนไหว");
				SendClientMessage(playerid, COLOR_WHITE,"เตรียมใบขับขี่ให้พร้อม! (/truckerjob)");
                SendClientMessage(playerid, COLOR_YELLOW,"> สถานที่ของอาชีพนี้ถูกทำเครื่องหมายอยู่บนแผนที่");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
				SetPlayerCheckpoint(playerid, -76.9150,-1136.6500,1.0781, 30.0);
				gPlayerCheckpoint{playerid}=true;
			}
	        case 5: // Fishing
	        {
		    	SendClientMessage(playerid, COLOR_GREEN,"___________ชาวประมง:___________");
				SendClientMessage(playerid, COLOR_WHITE,"ชาวประมง; ตกปลาด้วยเรือ, แล้วนำปลาไปขายจะได้รับเงินเป็นค่าตอบแทน");
				SendClientMessage(playerid, COLOR_WHITE,"เตรียมเรือให้พร้อมสำหรับการทำงาน! (/gofishing)");
                SendClientMessage(playerid, COLOR_YELLOW,"> สถานที่ของอาชีพนี้ถูกทำเครื่องหมายอยู่บนแผนที่");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
				SetPlayerCheckpoint(playerid, -78.0338,-1136.1221,1.0781, 3.5);
				gPlayerCheckpoint{playerid}=true;
			}
	        case 6: // Mine
	        {
		    	SendClientMessage(playerid, COLOR_GREEN,"___________พนักงานขุดเหมืองแร่:___________");
				SendClientMessage(playerid, COLOR_WHITE,"พนักงานขุดเหมืองแร่; แค่มีความพยายาม, แล้วนำแร่ไปแปรรูปและนำไปขาย !!");
				SendClientMessage(playerid, COLOR_WHITE,"คุณควรมีความขยันหากต้องการทำอาชีพนี้, และอาชีพนี้ไม่ต้องใช้รถยนต์ในการทำงาน");
                SendClientMessage(playerid, COLOR_YELLOW,"> สถานที่ของอาชีพนี้ถูกทำเครื่องหมายอยู่บนแผนที่");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
				SetPlayerCheckpoint(playerid, 595.7678, 921.1524, -39.9265, 3.5);
				gPlayerCheckpoint{playerid}=true;
			}
	        case 7: // Pizza
	        {
		    	SendClientMessage(playerid, COLOR_GREEN,"___________พนักงานส่งพิซซ่า:___________");
				SendClientMessage(playerid, COLOR_WHITE,"พนักงานส่งพิซซ่า; นำพิซซ่าที่คุณได้รับไปส่งตามบ้านของลูกค้า");
				SendClientMessage(playerid, COLOR_WHITE,"คุณควรมีใบขับขี่เพื่อทำให้การทำงานของคุณปลอดภัยและราบลื่น");
                SendClientMessage(playerid, COLOR_YELLOW,"> สถานที่ของอาชีพนี้ถูกทำเครื่องหมายอยู่บนแผนที่");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
				SetPlayerCheckpoint(playerid, 2104.2502, -1806.3750, 13.5547, 3.5);
				gPlayerCheckpoint{playerid}=true;
			}
	        case 8: // Taxi
	        {
		    	SendClientMessage(playerid, COLOR_GREEN,"___________คนขับรถแท็กซี่:___________");
				SendClientMessage(playerid, COLOR_WHITE,"คนขับรถแท็กซี่; รับลูกค้าผ่านโทรศัพท์และรับส่งลูกค้าไปยังสถานที่ต้องการ");
				SendClientMessage(playerid, COLOR_WHITE,"คุณควรมีใบขับขี่และรถแท็กซี่ส่วนตัว, เพื่อที่จะสามารถทำอาชีพนี้ได้");
                SendClientMessage(playerid, COLOR_YELLOW,"> สถานที่ของการทำงานแท็กซี่คือสถานที่เดียวกับการทำใบขับขี่ (Los Santos)");
				SendClientMessage(playerid, COLOR_GREEN,"______________________");
				//SetPlayerCheckpoint(playerid, 2104.2502, -1806.3750, 13.5547, 3.5);
				//gPlayerCheckpoint{playerid}=true;
			}
		}
	}
	else {
		Dialog_Show(playerid, DialogNewsEmployment, DIALOG_STYLE_LIST, "การจ้างงานและงานที่ถูกกฎหมาย", "ชาวไร่\nพนักงานกวาดถนน\nพนักงานเก็บขยะ\nช่างซ่อมรถ\nคนขับรถบรรทุก", "อ่านต่อ", "กลับ");
	}
	return 1;
}

alias:seatbelt("sb");
CMD:seatbelt(playerid, params[])
{
    if (!IsPlayerInAnyVehicle(playerid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "คุณต้องอยู่บนยานพาหนะก่อนจะใช้คำสั่งนี้!");
 
    if (IsPlayerInAnyVehicle(playerid))
    {
        new BikeModel = GetVehicleModel(GetPlayerVehicleID(playerid));
        switch(BikeModel)
        {
            case 448,461,462,463,468,471,509,510,521,522,523,581,586: 
			{
            	SendClientMessage(playerid, COLOR_GRAD1, "ยานพาหนะนี้ไม่มี Seatbelt");
            }
            default: 
			{
				if(safetybelt[playerid] == 0)
				{
            		safetybelt[playerid] = 1;

                    SendClientMessage(playerid, COLOR_LIGHTBLUE, "คุณได้ใช้งาน Seatbelt บนยานพาหนะของคุณเรียบร้อยแล้ว!");
                    SendClientMessage(playerid, COLOR_LIGHTBLUE, "หากคุณต้องการนำออกพิมพ์ : \"/seatbelt\"");
            	}
            	else if(safetybelt[playerid] == 1)
            	{
					safetybelt[playerid] = 0;

					SendClientMessage(playerid, COLOR_LIGHTBLUE, "คุณได้เลิกใช้งาน Seatbelt บนยานพาหนะของคุณเรียบร้อยแล้ว!");
                    SendClientMessage(playerid, COLOR_LIGHTBLUE, "หากคุณต้องการใช้งานพิมพ์ : \"/seatbelt\"");
            	}
            }
        }
    }
    return 1;
}

alias:leavesidejob("lsj", "ออกงานเสริม");
CMD:leavesidejob(playerid)
{
	if(playerData[playerid][pSideJob] != 0)
	{
	    playerData[playerid][pSideJob]=0;
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณได้ออกจากอาชีพเสริมในปัจจุบันแล้ว");
	}
	else return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่มีอาชีพเสริมในปัจจุบัน");

}

alias:leavejob("lj", "ออกงานหลัก");
CMD:leavejob(playerid) {
	if(playerData[playerid][pJob])
	{
		if(!IsSideJob(playerData[playerid][pJob])) {
			if(playerData[playerid][pDonateRank])
			{
				if(playerData[playerid][pContractTime])
				{
					playerData[playerid][pJob] = 0;
					playerData[playerid][pContractTime] = 0;
					return SendClientMessage(playerid, COLOR_LIGHTBLUE, "* คุณได้ปฏิบัติตามสัญญา 1 ชั่วโมงแล้วและได้ออกจากงาน");
				}
				else return SendClientMessage(playerid, COLOR_LIGHTBLUE, "* คุณยังคงเหลืออีก 1 ชั่วโมงที่จะปฏิบัติตามและสิ้นสุดสัญญาของคุณ");
			}
			else
			{
				if(playerData[playerid][pDonateRank] > 1 && playerData[playerid][pContractTime] >= 1) {
					playerData[playerid][pJob] = 0;
					playerData[playerid][pContractTime] = 0;
					return SendClientMessage(playerid, COLOR_LIGHTBLUE, "* คุณได้ปฏิบัติตามสัญญา 1 ชั่วโมงแล้วและได้ออกจากงาน");
				}
				else if(playerData[playerid][pDonateRank] > 1) {
					return SendClientMessage(playerid, COLOR_LIGHTBLUE, "* คุณยังคงเหลืออีก 1 ชั่วโมงที่จะปฏิบัติตามและสิ้นสุดสัญญาของคุณ");
				}

				if(playerData[playerid][pContractTime] >= 4)
				{
					playerData[playerid][pJob] = 0;
					playerData[playerid][pContractTime] = 0;
					return SendClientMessage(playerid, COLOR_LIGHTBLUE, "* คุณได้ปฏิบัติตามสัญญา 4 ชั่วโมงแล้วและได้ออกจากงาน");
				}
				else
				{
					return SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "* คุณยังคงเหลืออีก %d ชั่วโมงที่จะปฏิบัติตามและสิ้นสุดสัญญาของคุณ", 4 - playerData[playerid][pContractTime]);
				}
			}
		} else {
			playerData[playerid][pJob]=0;
			return SendClientMessage(playerid, COLOR_LIGHTBLUE, "   คุณได้ออกจากงานในปัจจุบันแล้ว");
		}
	}
	else return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่มีงานในปัจจุบัน");
}

alias:jobswitch("js", "สลับงาน");
CMD:jobswitch(playerid)
{
    if(IsSideJob(playerData[playerid][pJob])) {

        if(playerData[playerid][pJob] != JOB_NONE || playerData[playerid][pSideJob] != JOB_NONE)
        {
            new sidejob = playerData[playerid][pSideJob];

            playerData[playerid][pSideJob] = playerData[playerid][pJob];
            playerData[playerid][pJob] = sidejob;

            if(playerData[playerid][pSideJob] == JOB_NONE) SendClientMessage(playerid, COLOR_LIGHTRED, "อาชีพหลักของคุณถูกตั้งเป็นอาชีพเสริม");
			else if(playerData[playerid][pJob] == JOB_NONE) SendClientMessage(playerid, COLOR_LIGHTRED, "อาชีพหลักของคุณถูกแทนที่โดยอาชีพเสริม");
		}
        else
        {
            SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องออกจากงานก่อน (/leavejob หรือ /leavesidejob)");
        }
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณสามารถสลับงานได้แค่ คนขับแท็กซี่");
	return 1;
}

IsSideJob(jobid)
{
	if(jobid == JOB_NONE || jobid == JOB_TAXI || jobid == JOB_MECHANIC) return 1;
	return 0;
}

alias:jobhelp("ช่วยเหลืองาน", "jh");
CMD:jobhelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
	SendClientMessage(playerid, COLOR_GRAD3,"อาชีพในปัจจุบันของคุณคือ:");
	SendClientMessageEx(playerid,COLOR_GRAD3,"%s", ReturnJobName(playerData[playerid][pJob]));

	if(playerData[playerid][pSideJob]) {
		SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
		SendClientMessage(playerid, COLOR_GRAD3,"อาชีพเสริม:");
		SendClientMessageEx(playerid,COLOR_GRAD3,"%s", ReturnJobName(playerData[playerid][pSideJob]));
	}

	if(playerData[playerid][pJob] == JOB_MECHANIC || playerData[playerid][pSideJob] == JOB_MECHANIC) {
		if(playerData[playerid][pSideJob] == JOB_MECHANIC) SendClientMessage(playerid,COLOR_LIGHTRED,"คำสั่งช่างซ่อมรถ [อาชีพเสริม]");
		else SendClientMessage(playerid,COLOR_LIGHTRED,"คำสั่งช่างซ่อมรถ:");
		SendClientMessage(playerid,COLOR_WHITE,"/buycomp (ซื้อวัสดุ) - /checkcomp (ดูวัสดุ) - /service (บริการ) - /paintcar (เปลี่ยนสี) - /colorlist (เลขสี)");
		// SendClientMessage(playerid,COLOR_WHITE,"/colorlist - /attach - /detach");
	}

	if(playerData[playerid][pJob] == JOB_TAXI || playerData[playerid][pSideJob] == JOB_TAXI) {
	    if(playerData[playerid][pSideJob] == JOB_TAXI) SendClientMessage(playerid,COLOR_LIGHTRED,"คำสั่งคนขับแท็กซี่ [อาชีพเสริม]");
		else SendClientMessage(playerid,COLOR_LIGHTRED,"คำสั่งคนขับแท็กซี่:");
		SendClientMessage(playerid,COLOR_WHITE,"/taxi [accept / duty / fare / start / stop]");
	}

	if(playerData[playerid][pJob] == JOB_FARMER) {
	    SendClientMessage(playerid,COLOR_LIGHTRED,"คำสั่งของชาวไร่:");
		SendClientMessage(playerid,COLOR_WHITE,"/harvest");
		SendClientMessage(playerid,COLOR_WHITE,"/stopharvest");
		SendClientMessageEx(playerid,COLOR_GRAD1,"ชั่วโมงการทำงาน: %d/25 (โบนัส +10 ต่อชั่วโมงงาน)", playerData[playerid][pContractTime]);
	}
	else if(playerData[playerid][pJob] == JOB_SWEEPER) {
	    SendClientMessage(playerid,COLOR_LIGHTRED,"คำสั่งของพนักงานกวาดถนน:");
		SendClientMessage(playerid,COLOR_WHITE,"/sweeper");
		SendClientMessage(playerid,COLOR_WHITE,"/stopsweeper");
		SendClientMessageEx(playerid,COLOR_GRAD1,"ชั่วโมงการทำงาน: %d/25 (โบนัส +5 ต่อชั่วโมงงาน)", playerData[playerid][pContractTime]);
	}
	else if(playerData[playerid][pJob] == JOB_GARBAGE) {
	    SendClientMessage(playerid,COLOR_LIGHTRED,"คำสั่งของพนักงานเก็บขยะ:");
		SendClientMessage(playerid,COLOR_WHITE,"/collect");
		SendClientMessage(playerid,COLOR_WHITE,"/stopgarbage");
		SendClientMessageEx(playerid,COLOR_GRAD1,"ชั่วโมงการทำงาน: %d/25 (โบนัส +20 ต่อชั่วโมงงาน)", playerData[playerid][pContractTime]);
	}
	else if(playerData[playerid][pJob] == JOB_TRUCKER) {
		SendClientMessage(playerid,COLOR_GRAD1,"อ่านเอกสารบนฟอรั่ม:");
		SendClientMessage(playerid,COLOR_GRAD1,"ช่วยเหลือผู้เล่น -> ไกด์ที่เป็นทางการ -> การทำงาน Trucker");
		SendClientMessage(playerid,COLOR_GRAD1,"(http://script-wise.in.th/forum)");
		SendClientMessage(playerid,COLOR_GRAD2,"คุณจำเป็นต้องมีรถกระบะ รถตู้ หรือรถบรรทุกในการทำงานนี้");
		SendClientMessage(playerid, -1, ""EMBED_YELLOW"Commands:"EMBED_WHITE"ใช้"EMBED_YELLOW" /cargo"EMBED_WHITE" เพื่อดูรายการที่สามารถทำได้");
		SendClientMessage(playerid, -1, ""EMBED_YELLOW"Commands:"EMBED_WHITE"ใช้"EMBED_YELLOW" /tpda"EMBED_WHITE" เพื่อเปิด PDA ของรถบรรทุกพร้อมแสดงข้อมูล");
		SendClientMessage(playerid, -1, ""EMBED_YELLOW"Commands:"EMBED_WHITE"ใช้"EMBED_YELLOW" /industry"EMBED_WHITE" เพื่อเปิด PDA ของรถบรรทุกพร้อมแสดงข้อมูล");
		if(playerData[playerid][pContractTime]) SendClientMessageEx(playerid, -1,"คุณมี %d ชั่วโมงในการประกอบอาชีพ", playerData[playerid][pContractTime]);
		SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
	}

	return 1;
}

alias:pitem("ไอเท็ม");
CMD:pitem(playerid, params[]) {
	SendClientMessage(playerid, COLOR_GREEN, "|_______________ไอเท็มของคุณ_______________|");
	SendClientMessageEx(playerid, COLOR_LIGHTCYAN, "โทรโข่ง: %d ชิ้น     น้ำมันกระป๋อง: %d ชิ้น", playerData[playerid][pItemOOC], playerData[playerid][pItemGasCan]);
	SendClientMessageEx(playerid, COLOR_LIGHTCYAN, "ชะแลง: %s     เมล็ดพืช: %d     บัวรดน้ำ: %s", (playerData[playerid][pItemCrowbar] ? ("มี") : ("ไม่มี")), playerData[playerid][pSeedWeed], (playerData[playerid][pWatering] ? ("มี") : ("ไม่มี")));
	SendClientMessageEx(playerid, COLOR_GRAD1, "/myitems ดูสิ่งของผิดกฎหมาย");
	return 1;
}

alias:licenses("lic", "ใบ");
CMD:licenses(playerid, params[])
{
	new targetid = INVALID_PLAYER_ID;

	if (sscanf(params, "u", targetid)) {
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /licenses [ไอดีผู้เล่น/ชื่อบางส่วน]");
		SendClientMessage(playerid, COLOR_GRAD1, "หมายเหตุ: ใส่เมื่อต้องการแสดงให้คนอื่นดูใบอนุญาตของเรา");
	}

	if(targetid == playerid || targetid == INVALID_PLAYER_ID) {

		SendClientMessage(playerid, COLOR_GREEN, "______บัตรประจำตัว San Andreas______");
		SendClientMessageEx(playerid, COLOR_WHITE, "ชื่อ : %s", ReturnPlayerName(playerid));
		SendClientMessageEx(playerid, COLOR_WHITE, "ใบอนุญาตขับขี่: %s", playerData[playerid][pCarLic] ? ("ผ่าน") : ("ยังไม่ผ่าน"));
		SendClientMessage(playerid, COLOR_GREEN, "_________________________");
		SendNearbyMessage(playerid, 25.0, COLOR_PURPLE, "* %s มองดูไปที่บัตรประจำตัวของเขา", ReturnRealName(playerid));
	
		return 1;
	}

	if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

	SendClientMessage(targetid, COLOR_GREEN, "______บัตรประจำตัว San Andreas______");
	SendClientMessageEx(targetid, COLOR_WHITE, "ชื่อ : %s", ReturnPlayerName(playerid));
	SendClientMessageEx(targetid, COLOR_WHITE, "ใบอนุญาตขับขี่: %s", playerData[playerid][pCarLic] ? ("ผ่าน") : ("ยังไม่ผ่าน"));
	SendClientMessage(targetid, COLOR_GREEN, "_________________________");
	SendNearbyMessage(playerid, 25.0, COLOR_PURPLE, "* %s ได้ยื่นบัตรประจำตัวของเขาให้กับ %s", ReturnRealName(playerid), ReturnRealName(targetid));
	return 1;
}

alias:togooc("ปิดทั่วโลก");
CMD:togooc(playerid,params[])
{
	if(!BitFlag_Get(gPlayerBitFlag[playerid], TOGGLE_OOC))
	{
		BitFlag_On(gPlayerBitFlag[playerid], TOGGLE_OOC);
 		SendClientMessage(playerid,COLOR_GREEN,"ปิดกั้นระบบแชท Global OOC");
	}
	else
	{
		BitFlag_Off(gPlayerBitFlag[playerid], TOGGLE_OOC);
		SendClientMessage(playerid,COLOR_GREEN,"ยกเลิกการบล็อกระบบแชท Global OOC แล้ว");
	}
	return 1;
}

CMD:toghud(playerid,params[])
{
	if(!BitFlag_Get(gPlayerBitFlag[playerid], TOGGLE_HUD))
	{
		BitFlag_On(gPlayerBitFlag[playerid], TOGGLE_HUD);
 		SendClientMessage(playerid,COLOR_GREEN,"ปิดกั้นระบบ HUD");
	}
	else
	{
		BitFlag_Off(gPlayerBitFlag[playerid], TOGGLE_HUD);
		SendClientMessage(playerid,COLOR_GREEN,"ยกเลิกการบล็อกระบบ HUD");
	}
	return 1;
}

alias:spawnchange("sc");
CMD:spawnchange(playerid, params[]) {

	new type, tmp2[16];
	if(sscanf(params,"dS()[16]",type, tmp2)) {
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /spawnchange [ตัวเลือก]");
		SendClientMessage(playerid, COLOR_GRAD1, "ตัวเลือก: 0 - จุดเกิดเริ่มต้น, 1 - แฟคชั่น, 2 - บ้าน, 3 - จุดล่าสุดที่ออกเกม");
		return 1;
	}

	if(type == 0)
 	{
 		SendClientMessage(playerid, COLOR_GRAD1, " จุดเกิดของคุณถูกเปลี่ยนเป็น: จุดเกิดเริ่มต้น");
 		playerData[playerid][pSpawnType] = SPAWN_TYPE_DEFAULT;
	}
	else if(type == 1)
	{
		if(playerData[playerid][pFaction] != 0) {
			SendClientMessage(playerid, COLOR_GRAD1, " จุดเกิดของคุณถูกเปลี่ยนเป็น: แฟคชั่น");
			playerData[playerid][pSpawnType] = SPAWN_TYPE_FACTION;
		} else SendClientMessage(playerid, COLOR_GREY, "คุณไม่ใช่ส่วนหนึ่งของแฟคชั่นใด ๆ");
		return 1;
	}
	else if(type == 2)
	{
		new houseid;

		if(sscanf(tmp2,"d", houseid)) {

			new hcount;

			SendClientMessage(playerid, COLOR_YELLOW, "|_______________บ้านของคุณ_______________|");

			foreach(new i : Iter_House)
			{
				if(houseData[i][hOwned] == 1 && ((playerData[playerid][pHouseKey] == houseData[i][hID]) || isequal(houseData[i][hOwner], ReturnPlayerName(playerid))))
				{
				    SendClientMessageEx(playerid, COLOR_GRAD2, "#%d: %s", i, houseData[i][hAddress]);
		      		hcount++;
				}
			}

			if(hcount) {
				SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /spawnchange 2 [ไอดีบ้าน]");
			}
			else {
			    SendClientMessage(playerid, COLOR_GREY, "คุณไม่มีบ้าน");
			}
			return 1;
		}

		if(Iter_Contains(Iter_House, houseid)) {
			if(houseData[houseid][hOwned] == 1 && ((playerData[playerid][pHouseKey] == houseData[houseid][hID]) || isequal(houseData[houseid][hOwner], ReturnPlayerName(playerid))))
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้เปลี่ยนแปลงจุดเกิด: บ้าน #%d", houseid);
				playerData[playerid][pSpawnType] = SPAWN_TYPE_PROPERTY;
				playerData[playerid][pHouseKey] = houseData[houseid][hID];
			}
			else SendClientMessage(playerid, COLOR_GREY, "คุณไม่มีบ้าน");
		}
	}
	if(type == 3)
 	{
 		SendClientMessage(playerid, COLOR_GRAD1, " จุดเกิดของคุณถูกเปลี่ยนเป็น: จุดล่าสุดที่คุณออกเกม");
 		playerData[playerid][pSpawnType] = SPAWN_TYPE_LASTPOS;
	}
	else {
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /spawnchange [ตัวเลือก]");
		SendClientMessage(playerid, COLOR_GRAD1, "ตัวเลือก: 0 - เด็กใหม่, 1 - แฟคชั่น, 2 - บ้าน, 3 - จุดล่าสุดที่ออกเกม");
	}
	return 1;
}

/*CMD:sethouse(playerid, params[])
{
	new
		amount;

	if (sscanf(params, "d", amount))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /sethouse [ไอดีบ้านของคุณ] (ดูไอดีบ้านได้จากคำสั่ง /sc)");

	if (playerData[playerid][pHouseKey] != amount)
		return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้ใส่ไอดีบ้านของคุณ !");

	SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้เปลี่ยนแปลงจุดเกิด: บ้าน #%d", amount);
	playerData[playerid][pSpawnType] = SPAWN_TYPE_PROPERTY;
	playerData[playerid][pHouseKey] = houseData[amount][hID];

	return 1;
}*/

CMD:inv(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_LIGHTRED, "- My Inventory -");
	SendClientMessageEx(playerid, COLOR_WHITE, "จำนวนข้าวกล่องในตัวคุณ : [%d]", playerData[playerid][pPizza]);
	SendClientMessageEx(playerid, COLOR_WHITE, "จำนวนน้ำโค้กในตัวคุณ : [%d]", playerData[playerid][pDrink]);
	SendClientMessageEx(playerid, COLOR_YELLOW, "คุณสามารถรับประทานอาหารที่คุณพกพามาด้วยการพิมพ์คำสั่ง /eatfood");
	SendClientMessageEx(playerid, COLOR_YELLOW, "คุณสามารดื่มน้ำที่คุณพกพามาด้วยการพิมพ์คำสั่ง /drinkwater");
	SendClientMessageEx(playerid, COLOR_LIGHTRED, "__________________");
	
	
	return 1;
}

CMD:eatfood(playerid, params[])
{
	if (playerData[playerid][pPizza] <= 0)
		return SendClientMessage(playerid , COLOR_GRAD2, "คุณไม่มีอาหารภายในตัวของคุณ");
	
	if (playerData[playerid][pHungry] >= 70)
		return SendClientMessage(playerid, COLOR_GRAD2, "คุณยังไม่หิวตอนนี้");

	playerData[playerid][pHungry] += 30;
	playerData[playerid][pPizza] -= 1;

	SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้ทำการรับประทานอาหารที่คุณพกมา, ทำให้คุณได้รับค่าพลังงานเพิ่ม +30");
	return 1;
}

CMD:drinkwater(playerid, params[])
{
	if (playerData[playerid][pDrink] <= 0)
		return SendClientMessage(playerid , COLOR_GRAD2, "คุณไม่มีน้ำดื่มภายในตัวของคุณ");
	
	if (playerData[playerid][pThirst] >= 70)
		return SendClientMessage(playerid, COLOR_GRAD2, "คุณยังไม่กระหายน้ำตอนนี้");

	playerData[playerid][pThirst] += 30;
	playerData[playerid][pDrink] -= 1;	

	SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้ทำการดื่มน้ำโค้กที่คุณพกมา, ทำให้คุณได้รับค่าพลังงานเพิ่ม +30");
	return 1;
}

CMD:stats(playerid, params[])
{
	ShowStats(playerid,playerid);
	return 1;
}

ShowStats(playerid,targetid)
{
	new string[256];
	format(string, sizeof string, "|____________________%s [%s]____________________|", ReturnRealName(targetid), ReturnDateTime());
	SendClientMessage(playerid, COLOR_GREEN,   string);
	new factionid = Faction_GetID(playerData[targetid][pFaction]);
	new Float:health;
	GetPlayerHealth(playerid, health);

	new nxtlevel = playerData[playerid][pLevel]+1;
	// new costlevel = nxtlevel*45000;//10k for testing purposes
	new expamount = nxtlevel*MULTIPLE_EXP;

	SendClientMessageEx(playerid, COLOR_LIGHTCYAN, "| ตัวละคร | กลุ่ม:[%d][%s] ตำแหน่ง:[%s] อาชีพ:[%s] เบอร์โทรศัพท์:[%d]", playerData[targetid][pFaction], Faction_GetName(factionid), Faction_GetRankName(factionid, playerData[targetid][pFactionRank]), ReturnJobName(playerData[targetid][pJob], playerData[targetid][pJobRank]), playerData[targetid][pPnumber]);
	SendClientMessageEx(playerid, COLOR_LIGHTCYAN2,"| เลเวล | เลเวลผู้เล่น:[%d] ประสบการณ์:[%d/%d] ระดับบริจาค:[%s]", playerData[targetid][pLevel], playerData[targetid][pExp], expamount, Donate_GetName(playerData[targetid][pDonateRank]));

	SendClientMessageEx(playerid, COLOR_LIGHTCYAN, "| อาวุธ | อาวุธหลัก:[%s] กระสุน:[%d] อาวุธรอง:[%s] กระสุน:[%d]",
	(!playerData[targetid][pGun2] && playerData[targetid][pGun3]) ? ReturnWeaponName(playerData[targetid][pGun3]) : ReturnWeaponName(playerData[targetid][pGun2]),
	(!playerData[targetid][pGun2] && playerData[targetid][pGun3]) ? playerData[targetid][pAmmo3] : playerData[targetid][pAmmo2],
	(!playerData[targetid][pGun2] && playerData[targetid][pGun3]) ? ("ไม่มี") : ReturnWeaponName(playerData[targetid][pGun3]),
	(!playerData[targetid][pGun2] && playerData[targetid][pGun3]) ? 0 : playerData[targetid][pAmmo3]);

	SendClientMessageEx(playerid, COLOR_LIGHTCYAN2, "| ทักษะ | เลือด:[%.1f/%.1f] คุณภาพ:[%.0f] ชั่วโมงที่ออนไลน์:[%d]", health, 100.0 + playerData[targetid][pSHealth], playerData[targetid][pSHealth], playerData[targetid][pPlayingHours]);
	SendClientMessageEx(playerid, COLOR_LIGHTCYAN,"| เงิน | เงินสด:[%s] เงินในธนาคาร:[%s] บัญชีออมทรัพย์:[%s] เงินค่าจ้าง:[%s]", FormatNumber(GetPlayerMoneyEx(targetid)), FormatNumber(playerData[targetid][pAccount]), FormatNumber(playerData[targetid][pSavingsCollect]), FormatNumber(playerData[targetid][pPayCheck]));
	SendClientMessageEx(playerid, COLOR_LIGHTCYAN2, "| อื่น ๆ | กุญแจยานพาหนะ:[%s] ที่ทำงาน:[%s] อาชีพเสริม:[%s] คะแนน:[%d]", (playerData[targetid][pPCarkey] == -1 ? ("ไม่มี") : sprintf("%d", playerCarData[playerData[targetid][pPCarkey]][carVehicle])), "ไม่มี", ReturnJobName(playerData[targetid][pSideJob]), playerData[targetid][pScore]);
	SendClientMessageEx(playerid, COLOR_LIGHTCYAN,"| วิทยุ | Channel:[%d] Slot:[%d] วิทยุ:[%s] เชือก:[%d]", playerData[targetid][pRChannel], playerData[targetid][pRSlot], (playerData[targetid][pRadio]) ? ("มี") : ("ไม่มี"), playerData[targetid][pTie]);
	SendClientMessageEx(playerid, COLOR_LIGHTCYAN2, "| ค่าพลังงาน | ความหิว:[%.2f] ความกระหายน้ำ:[%.2f]", playerData[targetid][pHungry], playerData[targetid][pThirst]);
	
	SendClientMessageEx(playerid, COLOR_GRAD1, "เพิ่มเติม: /perks, (/lic)enses");

	SendClientMessage(playerid, COLOR_GREEN, string);
}

CMD:perks(playerid, params[])
{
	SendClientMessageEx(playerid, COLOR_GRAD1, "ความสามารถพิเศษ: "EMBED_YELLOW"/upgrade"EMBED_GRAD1" (ค่าอัพเกรดในปัจจุบัน %d)", playerData[playerid][pPUpgrade]);
	SendClientMessageEx(playerid, COLOR_GRAD1, "- คุณภาพ +%.0f", playerData[playerid][pSHealth]);
	SendClientMessageEx(playerid, COLOR_GRAD1, "- ก้าวข้ามความเจ็บปวด เลเวล %d", playerData[playerid][pRespawnPerks]);
	SendClientMessageEx(playerid, COLOR_GRAD1, "- ปลดล็อกขีดจำกัดพาหนะ +%d คัน", playerData[playerid][pVehiclePerks]);
	SendClientMessageEx(playerid, COLOR_GRAD1, "- เหยื่อล่อปลาคุณภาพ เลเวล %d", playerData[playerid][pFishingPerks]);
	return 1;
}

CMD:buylevel(playerid, params[])
{
	if(playerData[playerid][pLevel])
	{
		new nxtlevel = playerData[playerid][pLevel]+1;
		new costlevel = nxtlevel*4500;//10k for testing purposes
		new expamount = nxtlevel*MULTIPLE_EXP, confirm[8];

		if (sscanf(params, "s[8]", confirm)) {
	 	    SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /buylevel yes");
			SendClientMessageEx(playerid, COLOR_GREY, "เลเวลที่คุณกำลังซื้อราคา $%d", costlevel);
			return 1;
		}

		if(isequal(confirm, "yes")) {
			if(playerData[playerid][pCash] < costlevel)
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอ ($%d) !",costlevel);
				return 1;
			}
			else if (playerData[playerid][pExp] < expamount)
			{
				SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณต้องมีค่าอัพเกรด %d Point แต่ในปัจจุบันคุณมีเพียง [%d] !",expamount,playerData[playerid][pExp]);
				return 1;
			}
			else
			{
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				PlayerPlayMusic(playerid);
				playerData[playerid][pCash] -= costlevel;
				playerData[playerid][pLevel]++;
				SetPlayerScore(playerid, playerData[playerid][pLevel]);
				if(playerData[playerid][pDonateRank] > 0)
				{
					playerData[playerid][pExp] -= expamount;
					new total = playerData[playerid][pExp];
					if(total > 0)
					{
						playerData[playerid][pExp] = total;
					}
					else
					{
						playerData[playerid][pExp] = 0;
					}
				}
				else
				{
					playerData[playerid][pExp] = 0;
				}
				playerData[playerid][pPUpgrade] = playerData[playerid][pPUpgrade]+2;
				GameTextForPlayer(playerid, sprintf("~g~LEVEL UP~n~~w~You Are Now Level %d", nxtlevel), 5000, 1);
				SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณซื้อเลเวล %d ในราคา ($%d) ใช้ /upgrade", nxtlevel, costlevel);
				SendClientMessageEx(playerid, COLOR_GRAD2, "   คุณมีค่าอัพเกรดอยู่ %d จุด (พิมพ์ /upgrade เพื่ออัพเกรด)",playerData[playerid][pPUpgrade]);
			}
		}
		else {
			SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /buylevel yes");
			SendClientMessageEx(playerid, COLOR_GREY, "เลเวลที่คุณกำลังซื้อราคา $%d", costlevel);
		}
	}
	return 1;
}

CMD:upgrade(playerid, params[]) {
	new options[64];
	if (sscanf(params, "s[64]", options)) {
	    SendClientMessage(playerid, COLOR_WHITE,"*** UPGRADES ***");
		SendClientMessageEx(playerid, COLOR_GRAD1, "การใช้: /upgrade [ชื่ออัพเกรด] (คุณมีค่าอัพเกรดอยู่ %d จุด)",playerData[playerid][pPUpgrade]);
		SendClientMessage(playerid, COLOR_GRAD2, "เลเวล 1-5: ก้าวข้ามความเจ็บปวด, เหยื่อล่อปลาคุณภาพ (-1 จุด)");
		SendClientMessage(playerid, COLOR_GRAD2, "เลเวล 10,15,20,25,30: ปลดล็อกขีดจำกัดพาหนะ (-5 จุด)");
		SendClientMessage(playerid, COLOR_GRAD2, "ทุกเลเวล: คุณภาพ (-1 จุด)");
		SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");
		return 1;
	}
	if (isequal(options, "คุณภาพ"))
	{
		if (playerData[playerid][pPUpgrade] > 1)
		{
			if (playerData[playerid][pSHealth] < 50)
			{
				playerData[playerid][pSHealth] = playerData[playerid][pSHealth]+5.0;
				SendClientMessageEx(playerid, COLOR_GRAD6, "อัพเกรดใหม่: คุณจะเกิดด้วยเลือด %.2f (+5)",playerData[playerid][pSHealth]+50);
				playerData[playerid][pPUpgrade]--;
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD6, "   คุณมีเลือดตอนเกิดสูงสุดแล้ว");
				return 1;
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GRAD6, "   คุณมีค่าอัพเกรด 0 จุด");
			return 1;
		}
	}
	else if (isequal(options, "ก้าวข้ามความเจ็บปวด"))
	{
		if (playerData[playerid][pPUpgrade] > 1)
		{
			if (playerData[playerid][pRespawnPerks] < 5)
			{
				if (playerData[playerid][pRespawnPerks] < playerData[playerid][pLevel]) {
					playerData[playerid][pRespawnPerks]++;
					SendClientMessageEx(playerid, COLOR_GRAD6, "อัพเกรดสถานะพิเศษใหม่: ก้าวข้ามความเจ็บปวด ของคุณเลเวล %d แล้ว", playerData[playerid][pRespawnPerks]);
					playerData[playerid][pPUpgrade]--;
					GameTextForPlayer(playerid, "~g~New Perk Upgraded", 5000, 1);
					return 1;
				}
				else {
					SendClientMessage(playerid, COLOR_GRAD6, "   เลเวลของคุณยังไม่สูงพอที่จะอัพเกรดสถานะพิเศษนี้ !");
					return 1;
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD6, "   คุณมีเลเวล ก้าวข้ามความเจ็บปวด เต็มแล้ว !");
				return 1;
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GRAD6, "   คุณมีค่าอัพเกรด 0 จุด");
			return 1;
		}
	}
	else if (isequal(options, "เหยื่อล่อปลาคุณภาพ"))
	{
		if (playerData[playerid][pPUpgrade] > 1)
		{
			if (playerData[playerid][pFishingPerks] < 5)
			{
				if (playerData[playerid][pFishingPerks] < playerData[playerid][pLevel]) {
					playerData[playerid][pFishingPerks]++;
					SendClientMessageEx(playerid, COLOR_GRAD6, "อัพเกรดสถานะพิเศษใหม่: เหยื่อล่อปลาคุณภาพ ของคุณเลเวล %d แล้ว", playerData[playerid][pFishingPerks]);
					playerData[playerid][pPUpgrade]--;
					GameTextForPlayer(playerid, "~g~New Perk Upgraded", 5000, 1);
					return 1;
				}
				else {
					SendClientMessage(playerid, COLOR_GRAD6, "   เลเวลของคุณยังไม่สูงพอที่จะอัพเกรดสถานะพิเศษนี้ !");
					return 1;
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD6, "   คุณมีเลเวล เหยื่อล่อปลาคุณภาพ เต็มแล้ว !");
				return 1;
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GRAD6, "   คุณมีค่าอัพเกรด 0 จุด");
			return 1;
		}
	}
	else if (isequal(options, "ปลดล็อกขีดจำกัดพาหนะ"))
	{
		if (playerData[playerid][pPUpgrade] > 4)
		{
			if (playerData[playerid][pVehiclePerks] < 5)
			{
				/*(playerData[playerid][pVehiclePerks] == 0 && playerData[playerid][pLevel] >= 10) ||
				(playerData[playerid][pVehiclePerks] == 1 && playerData[playerid][pLevel] >= 15) ||
				(playerData[playerid][pVehiclePerks] == 2 && playerData[playerid][pLevel] >= 20) ||
				(playerData[playerid][pVehiclePerks] == 3 && playerData[playerid][pLevel] >= 25) ||
				(playerData[playerid][pVehiclePerks] == 4 && playerData[playerid][pLevel] >= 30)*/

				if (playerData[playerid][pLevel] >= (playerData[playerid][pVehiclePerks] * 5) + 10) {
					playerData[playerid][pVehiclePerks] += 1;
					SendClientMessageEx(playerid, COLOR_GRAD6, "อัพเกรดสถานะพิเศษใหม่: ปลดล็อกขีดจำกัดพาหนะ ของคุณเลเวล %d แล้ว", playerData[playerid][pVehiclePerks]);
					playerData[playerid][pPUpgrade]-= 5;
					GameTextForPlayer(playerid, "~g~New Perk Upgraded", 5000, 1);
					return 1;
				}
				else {
					SendClientMessage(playerid, COLOR_GRAD6, "   เลเวลของคุณยังไม่สูงพอที่จะอัพเกรดสถานะพิเศษนี้ !");
					return 1;
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD6, "   คุณมีเลเวล ก้าวข้ามความเจ็บปวด เต็มแล้ว !");
				return 1;
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GRAD6, "   คุณมีค่าอัพเกรดไม่พอ (ใช้ 5 จุด)");
			return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD6, "   การอัพเกรดที่ไม่รู้จัก");
		return 1;
	}
	return 1;
}

CMD:pay(playerid, params[])
{
	new
	    targetid, 
		amount,
		str[128];

	if (sscanf(params, "ud", targetid, amount))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /pay [ไอดีผู้เล่น/ชื่อบางส่วน] [จำนวน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

	if (targetid == playerid)
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถให้เงินตัวเองได้");

	if (amount < 1)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   โปรดระบุจำนวนที่มากกว่า 1 ดอลล่า");

	if (amount > 5 && playerData[playerid][pPlayingHours] < 2)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถจ่ายได้มากกว่า $5 ในขณะที่ชั่วโมงที่เล่นต่ำกว่า 2 ชั่วโมง");

	if (amount > GetPlayerMoney(playerid))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้มีเงินมากขนาดนั้น");

	if (amount >= 100000)
	{
		format(str, sizeof(str), "AdmWarn: %s (%d) ได้มอบเงินให้ %s (%d) เป็นจำนวน %d", ReturnRealName(playerid), playerid, ReturnRealName(targetid), targetid, amount);
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, str);
	}

	GivePlayerMoneyEx(playerid, -amount);
	GivePlayerMoneyEx(targetid, amount);

	SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณได้ให้เงิน %d กับ %s", amount, ReturnRealName(targetid));
	SendClientMessageEx(targetid, COLOR_GRAD1, "   คุณได้รับเงิน %d จาก %s", amount, ReturnRealName(playerid));

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s ควักเงินออกมาบางส่วนและใส่ไว้ในมือของ %s", ReturnRealName(playerid), ReturnRealName(targetid));

	Log(transferlog, INFO, "%s ให้เงินให้กับ %s จำนวน %d", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount);
	
	return 1;
}

CMD:rpay(playerid, params[])
{
	new
	    targetid, 
		amount,
		str[128];

	if (sscanf(params, "ud", targetid, amount))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /rpay [ไอดีผู้เล่น/ชื่อบางส่วน] [จำนวน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

	if (targetid == playerid)
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถให้เงินตัวเองได้");

	if (amount < 1)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   โปรดระบุจำนวนที่มากกว่า 1 ดอลล่า");

	if (amount > 5 && playerData[playerid][pPlayingHours] < 2)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถจ่ายได้มากกว่า $5 ในขณะที่ชั่วโมงที่เล่นต่ำกว่า 2 ชั่วโมง");

	if (amount > playerData[playerid][pRMoney])
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้มีเงินมากขนาดนั้น");

	if (amount >= 100000)
	{
		format(str, sizeof(str), "AdmWarn: %s (%d) ได้มอบเงินแดงให้ %s (%d) เป็นจำนวน %d", ReturnRealName(playerid), playerid, ReturnRealName(targetid), targetid, amount);
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, str);
	}

	playerData[playerid][pRMoney] -= amount;
	playerData[targetid][pRMoney] += amount;

	SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณได้ให้เงินแดง %d กับ %s", amount, ReturnRealName(targetid));
	SendClientMessageEx(targetid, COLOR_GRAD1, "   คุณได้รับเงินแดง %d จาก %s", amount, ReturnRealName(playerid));

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s ควักเงินแดงออกมาบางส่วนและใส่ไว้ในมือของ %s", ReturnRealName(playerid), ReturnRealName(targetid));

	Log(transferlog, INFO, "%s ให้เงินแดงให้กับ %s จำนวน %d", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount);
	
	return 1;
}

CMD:givescore(playerid, params[])
{
	new
	    targetid, 
		amount,
		str[128];

	if (sscanf(params, "ud", targetid, amount))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /givescore [ไอดีผู้เล่น/ชื่อบางส่วน] [จำนวน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

	if (targetid == playerid)
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถให้ Score ตัวเองได้");

	if (amount < 1)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   โปรดระบุจำนวนที่มากกว่า 1 Score");

	if (amount > playerData[playerid][pScore])
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้มี Score มากขนาดนั้น");

	if (amount > 50)
	{
		format(str, sizeof(str), "AdmWarn: %s (%d) ได้มอบ Score ให้ %s (%d) เป็นจำนวน %d", ReturnRealName(playerid), playerid, ReturnRealName(targetid), targetid, amount);
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, str);
	}

	playerData[playerid][pScore] -= amount;
	playerData[targetid][pScore] += amount;

	SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณได้ให้ Score %d กับ %s", amount, ReturnRealName(targetid));
	SendClientMessageEx(targetid, COLOR_GRAD1, "   คุณได้รับ Score %d จาก %s", amount, ReturnRealName(playerid));

	//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s ควัก Point ออกมาบางส่วนและใส่ไว้ในมือของ %s", ReturnRealName(playerid), ReturnRealName(targetid));
	Log(transferlog, INFO, "%s ให้ Score ให้กับ %s จำนวน %d", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount);
	
	return 1;
}

CMD:givepoint(playerid, params[])
{
	new
	    targetid, 
		amount,
		str[128];

	if (sscanf(params, "ud", targetid, amount))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /givepoint [ไอดีผู้เล่น/ชื่อบางส่วน] [จำนวน]");

	if(targetid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

	if (targetid == playerid)
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถให้ Point ตัวเองได้");

	if (amount < 1)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   โปรดระบุจำนวนที่มากกว่า 1 Point");

	if (amount > playerData[playerid][pPoint])
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้มี Point มากขนาดนั้น");

	if (amount > 100)
	{
		format(str, sizeof(str), "AdmWarn: %s (%d) ได้มอบ Point ให้ %s (%d) เป็นจำนวน %d", ReturnRealName(playerid), playerid, ReturnRealName(targetid), targetid, amount);
		SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, str);
	}

	playerData[playerid][pPoint] -= amount;
	playerData[targetid][pPoint] += amount;

	SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณได้ให้ Point %d กับ %s", amount, ReturnRealName(targetid));
	SendClientMessageEx(targetid, COLOR_GRAD1, "   คุณได้รับ Point %d จาก %s", amount, ReturnRealName(playerid));

	//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "> %s ควัก Point ออกมาบางส่วนและใส่ไว้ในมือของ %s", ReturnRealName(playerid), ReturnRealName(targetid));
	Log(transferlog, INFO, "%s ให้ Point ให้กับ %s จำนวน %d", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount);
	
	return 1;
}

// Copy from LS:RP

CMD:coin(playerid, params[])
{
	new str[128];
	format(str, sizeof(str), "** %s พลิกเหรียญลงพื้นและมันออก%s", ReturnRealName(playerid), (random(2)) ? ("หัว") : ("ก้อย"));
    SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, str);
	return 1;
}

CMD:dice(playerid, params[])
{
	new str[128];
	format(str, sizeof(str), "** %s ทอยลูกเต๋าและมันออก %d", ReturnRealName(playerid), random(6)+1);
    SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, str);
	return 1;
}

CMD:rnumber(playerid, params[])
{
	new
	    rmin,
	    rmax,
		emote[128],
		str[128];

	if (sscanf(params, "dds[128]", rmin, rmax, emote))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /rnumber [min] [max] [การกระทำ]");

	if(rmin >= rmax) {
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "ตัวเลขต่ำสุดต้องน้อยกว่าตัวเลขสูงสุด");
	}

	format(str, sizeof(str), "** %s %s %d (( %d ถึง %d ))", ReturnRealName(playerid), emote, randomEx(rmin, rmax), rmin, rmax);
    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, str);
	return 1;
}

CMD:b(playerid, params[])
{
	new str[128];

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /b [ข้อความ]");

	if (strlen(params) > 80) {

		format(str, sizeof(str), "(( [%d] %s: %.80s ))", playerid, ReturnRealName(playerid), params);
        ProxDetectorOOC(playerid, 20.0, str);

	    format(str, sizeof(str), "... %s", params[80]);
        ProxDetectorOOC(playerid, 20.0, str);
	}
	else {

		format(str, sizeof(str), "(( [%d] %s: %s ))", playerid, ReturnRealName(playerid), params);
		ProxDetectorOOC(playerid, 20.0, str);
	}
	return 1;
}

CMD:ass(playerid, params[])
{
	if (playerData[playerid][pAdmin] < 1)
		return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ใช่ผู้ดูแลระบบ");

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /(as)administrator [ข้อความ]");

	if (strlen(params) > 80) {
	    if(playerData[playerid][pAdmin]) {
			SendOOCMessage(COLOR_GRAD1, "(( [{FF8300}Administrator{B4B5B7}] {%06x}%s"EMBED_GRAD1": %.80s ))", GetPlayerColor(playerid) >>> 8, playerData[playerid][pAdminName],params);
			SendOOCMessage(COLOR_GRAD1, "... %s", params[80]);
		}
	}
	else {
	    if(playerData[playerid][pAdmin]) {
			SendOOCMessage(COLOR_GRAD1, "(( [{FF8300}Administrator{B4B5B7}] {%06x}%s"EMBED_GRAD1": %s ))", GetPlayerColor(playerid) >>> 8, playerData[playerid][pAdminName], params);
		}
	}

	return 1;
}


alias:administrator("as");
CMD:administrator(playerid, params[])
{
	if (playerData[playerid][pAdmin] < 1)
		return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ใช่ผู้ดูแลระบบ");

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /(as)administrator [ข้อความ]");

	if (strlen(params) > 80) {
	    if(playerData[playerid][pAdmin]) {
			SendOOCMessage(COLOR_GRAD1, "(( [{FF8300}Administrator{B4B5B7}] {%06x}%s"EMBED_GRAD1"(%d): %.80s ))", GetPlayerColor(playerid) >>> 8, ReturnPlayerName(playerid), playerid, params);
			SendOOCMessage(COLOR_GRAD1, "... %s", params[80]);
		}
	}
	else {
	    if(playerData[playerid][pAdmin]) {
			SendOOCMessage(COLOR_GRAD1, "(( [{FF8300}Administrator{B4B5B7}] {%06x}%s"EMBED_GRAD1"(%d): %s ))", GetPlayerColor(playerid) >>> 8, ReturnPlayerName(playerid), playerid, params);
		} 
	}

	return 1;
}

alias:ooc("o");
CMD:ooc(playerid, params[])
{
    if(systemVariables[OOCStatus] == 1 && !playerData[playerid][pAdmin])
		return SendClientMessage(playerid, COLOR_GREY, "ช่องทางแชท OOC ถูกปิดในปัจจุบัน");

	if(playerData[playerid][pItemOOC] <= 0 && !playerData[playerid][pAdmin])
		return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่มีโทรโข่ง!");

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /(o)oc [ข้อความ]");

	if (strlen(params) > 80) {
	    if(playerData[playerid][pAdmin]) {//{ED3CCA}
			SendOOCMessage(COLOR_GRAD1, "(( [ทั่วโลก] {%06x}%s"EMBED_GRAD1"(%d): %.80s ))", GetPlayerColor(playerid) >>> 8, ReturnPlayerName(playerid), playerid, params);
			SendOOCMessage(COLOR_GRAD1, "... %s", params[80]);
		}
	    else if(playerData[playerid][pDonateRank]) {
			SendOOCMessage(COLOR_GRAD1, "(( [ทั่วโลก] {00FF00}%s{B4B5B7} {%06x}%s"EMBED_GRAD1"(%d): %.80s ))", Donate_GetName(playerData[playerid][pDonateRank]), GetPlayerColor(playerid) >>> 8, ReturnPlayerName(playerid), playerid, params);
			SendOOCMessage(COLOR_GRAD1, "... %s", params[80]);
		}
		else {
			SendOOCMessage(COLOR_GRAD1, "(( [ทั่วโลก] %s(%d): %.80s ))", ReturnPlayerName(playerid), playerid, params);
			SendOOCMessage(COLOR_GRAD1, "... %s", params[80]);
		}
	}
	else {
	    if(playerData[playerid][pAdmin]) {
			SendOOCMessage(COLOR_GRAD1, "(( [{ED3CCA}ทั่วโลก{B4B5B7}] {%06x}%s"EMBED_GRAD1"(%d): %s ))", GetPlayerColor(playerid) >>> 8, ReturnPlayerName(playerid), playerid, params);
		} 
	    else if(playerData[playerid][pDonateRank]) {
			SendOOCMessage(COLOR_GRAD1, "(( [ทั่วโลก] {7535FF}%s{B4B5B7} {%06x}%s"EMBED_GRAD1"(%d): %s ))", Donate_GetName(playerData[playerid][pDonateRank]), GetPlayerColor(playerid) >>> 8, ReturnPlayerName(playerid), playerid, params);
		}
		else SendOOCMessage(COLOR_GRAD1, "(( [ทั่วโลก] %s(%d): %s ))", ReturnPlayerName(playerid), playerid, params);
	}

	if (!playerData[playerid][pAdmin]) 
		playerData[playerid][pItemOOC]--;

	return 1;
}

alias:newbie("n");
CMD:newbie(playerid, params[]) {

	new szMessage[128];

	if(HasCooldown(playerid,COOLDOWN_NEWBIE))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "ช่องทาง Newbie OOC ใช้ได้ 60 วินาที/ครั้ง");

	if(playerData[playerid][pNMuted] == 1)
		return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้รับอนุญาตให้ใช้ช่องทางสนทนา Newbie ชั่วคราว");

	if(!isnull(params)) {

		if(playerData[playerid][pAdmin] >= 1) {
			format(szMessage, sizeof(szMessage), "** (ช่องทางการสอบถาม) ผู้ดูแลระบบ %s : %s", playerData[playerid][pAdminName], params);
		}
		else if (playerData[playerid][pHelper] >= 1)
		{
			format(szMessage, sizeof(szMessage), "** (ช่องทางการสอบถาม) Helper %s : %s", ReturnPlayerName(playerid), params);
		}
		else if(playerData[playerid][pPlayingHours] >= 50) {
			format(szMessage, sizeof(szMessage), "** (ช่องทางการสอบถาม) ผู้เล่น %s (%d): %s", ReturnPlayerName(playerid), playerid , params);
			SetCooldown(playerid,COOLDOWN_NEWBIE, 60);
		}
		else {
			format(szMessage, sizeof(szMessage), "** (ช่องทางการสอบถาม) ผู้เล่นใหม่ %s (%d): %s", ReturnPlayerName(playerid), playerid, params);
			SetCooldown(playerid,COOLDOWN_NEWBIE, 60);
		}
		foreach (new x : Player) 
		{
			if(playerData[x][pNewbieEnabled] == 1) {
				SendClientMessage(x, COLOR_LIGHTBLUE, szMessage);
			}
		}
	}
	else {
	    return SendClientMessage(playerid, COLOR_GREY, "การใช้: /(n)ewbie [คำถาม]");
	}
	return 1;
}

CMD:tognewbie(playerid, params[]) 
{
	if(playerData[playerid][pNewbieEnabled] == 1) {
	    playerData[playerid][pNewbieEnabled] = 0;
	    SendClientMessage(playerid, COLOR_WHITE, "คุณได้ทำการปิดการมองเห็นช่องทางสนทนา Newbie");
	}
	else {
	    playerData[playerid][pNewbieEnabled] = 1;
	    SendClientMessage(playerid, COLOR_WHITE, "คุณได้ทำการเปิดการมองเห็นช่องทางสนทนา Newbie");
	}
	return 1;
}

CMD:walk(playerid, params[])
{
	new styleID;

	if(sscanf(params, "i", styleID)) {
	    //format(szMessage, sizeof(szMessage), SYNTAX_MESSAGE"/walkstyle (0-%i)", sizeof(walkAnimations));
	    return SendClientMessage(playerid, COLOR_GREY, "การใช้: /walk (1-18)");
	}

	switch(styleID)
	{
		case 1: ApplyAnimation(playerid,"PED","WALK_gang1",4.1,1,1,1,1,1);
		case 2: ApplyAnimation(playerid,"PED","WOMAN_walksexy",4.1,1,1,1,1,1);
		case 3: ApplyAnimation(playerid,"PED","WALK_armed",4.1,1,1,1,1,1);
		case 4: ApplyAnimation(playerid,"PED","WALK_civi",4.1,1,1,1,1,1);
		case 5: ApplyAnimation(playerid,"PED","WALK_csaw",4.1,1,1,1,1,1);
		case 6: ApplyAnimation(playerid,"PED","WALK_gang2",4.1,1,1,1,1,1);
		case 7: ApplyAnimation(playerid,"PED","WALK_drunk",4.1,1,1,1,1,1);
		case 8: ApplyAnimation(playerid,"PED","WALK_fat",4.1,1,1,1,1,1);
		case 9: ApplyAnimation(playerid,"PED","WALK_fatold",4.1,1,1,1,1,1);
		case 10: ApplyAnimation(playerid,"PED","WALK_old",4.1,1,1,1,1,1);
		case 11: ApplyAnimation(playerid,"PED","WALK_player",4.1,1,1,1,1,1);
		case 12: ApplyAnimation(playerid,"PED","WALK_rocket",4.1,1,1,1,1,1);
		case 13: ApplyAnimation(playerid,"PED","WALK_shuffle",4.1,1,1,1,1,1);
		case 14: ApplyAnimation(playerid,"PED","WOMAN_walknorm",4.1,1,1,1,1,1);
		case 15: ApplyAnimation(playerid,"PED","WOMAN_walkpro",4.1,1,1,1,1,1);
		case 16: ApplyAnimation(playerid,"PED","WOMAN_walkbusy",4.1,1,1,1,1,1);
		case 17: ApplyAnimation(playerid,"PED","WOMAN_walknorm",4.1,1,1,1,1,1);
		case 18: ApplyAnimation(playerid,"PED","Walk_Wuzi",4.1,1,1,1,1,1);
		default: ApplyAnimation(playerid,"PED","WALK_player",4.1,1,1,1,1,1);
	}
	playerData[playerid][pAnimation] = 1;
	return 1;
}

CMD:resetweed(playerid, params[])
{
	if (playerData[playerid][pLuckyBox] > 100) {
		playerData[playerid][pLuckyBox] = 0;
	}

	playerData[playerid][pCPCannabis] = 0;
	playerData[playerid][pCannabis] = 0;
	playerData[playerid][pTurismo] = 0;

	OnAccountUpdate(playerid);
	SendClientMessage(playerid, COLOR_GRAD1, "คุณได้ทำการรีเซ็ตค่าอาชีพขนส่งกัญชา, คุณสามารถทำงานขนส่งกัญชาได้ตามปกติ");

	return 1;
}

//=====================================[ BWMode ]============================================
CMD:respawnme(playerid)
{
	if(!gIsDeathMode{playerid})
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณยังไม่ตาย");
		
	if(gInjuredTime[playerid] <= 0)
	{
		BitFlag_Off(gPlayerBitFlag[playerid], IS_SPAWNED);
		
		gInjuredTime[playerid] = 0;
		gIsDeathMode{playerid} = false;
		gIsInjuredMode{playerid}=false;
		playerData[playerid][pMedicBill] = true;
		Damage_Reset(playerid);

		/*if(IsValidDynamic3DTextLabel(gDeathLabel[playerid])) 
			DestroyDyn3DTextLabelFix(gDeathLabel[playerid]);*/

		SpawnPlayer(playerid);
		GivePlayerMoneyEx(playerid, -500);
		SendClientMessage(playerid, COLOR_YELLOW, "คุณได้เสียเงินเพิ่มจำนวน $500 โดยเป็นค่ารักษาของโรงพยาบาล All Saints General Hospital");
	}
	else SendClientMessageEx(playerid, COLOR_LIGHTRED, "รอเวลาอีก %d วินาที", gInjuredTime[playerid]);
	
	return 1;
}

alias:acceptdeath("atd");
CMD:acceptdeath(playerid, params[])
{
    if(!gIsInjuredMode{playerid} || gIsDeathMode{playerid})
 		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้รับบาดเจ็บ");

	if(gInjuredTime[playerid] > 120 - Main_GetRespawnPerks(playerid) && playerData[playerid][pDonateRank] == 0)
		return SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณต้องรอเวลาประมาณ %d วินาทีเพื่อที่จะยอมรับความตาย", gInjuredTime[playerid] - 120 - Main_GetRespawnPerks(playerid));

	gIsDeathMode{playerid} = true;
	gInjuredTime[playerid] = Main_GetRespawnTime(playerid);

	SendClientMessageEx(playerid, COLOR_YELLOW, "-> คุณตายแล้วในขณะนี้ คุณจำเป็นต้องรอ %d วินาทีและหลังจากนั้นคุณถึงจะสามารถ /respawnme", gInjuredTime[playerid]);

    if (!IsPlayerInAnyVehicle(playerid)) {
		ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}
//=====================================[ BWMode ]============================================



CMD:lock(playerid, params[])
{
	new id = -1, vehicleid;

	if( (IsPlayerInAnyVehicle(playerid) ? ((vehicleid = GetPlayerVehicleID(playerid)) != 0) : ((vehicleid = Vehicle_Nearest(playerid)) != -1))) {

		/*new
			engine,
			lights,
			alarm,
			doors,
			bonnet,
			boot,
			objective;*/

		if((id = PlayerCar_GetID(vehicleid)) == -1)
		{
			if((IsVehicleRental(vehicleid) == -1 && gLastCar[playerid] == vehicleid)) {

				// GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

				if(!GetLockStatus(vehicleid))
				{
					GameTextForPlayer(playerid, sprintf("~r~%s Locked", ReturnVehicleModelName(GetVehicleModel(vehicleid))), 2000, 4);
					// SetVehicleParamsEx(vehicleid, engine, lights, alarm, 1, bonnet, boot, objective);
					SetLockStatus(vehicleid, true);
					PlayerPlaySoundEx(playerid, 24600);
				}
				else
				{
					GameTextForPlayer(playerid, sprintf("~g~%s Unlocked", ReturnVehicleModelName(GetVehicleModel(vehicleid))), 2000, 4);
					// SetVehicleParamsEx(vehicleid, engine, lights, alarm, 0, bonnet, boot, objective);
					SetLockStatus(vehicleid, false);
					PlayerPlaySoundEx(playerid, 24600);
				}
			} 
			else if(IsVehicleRental(vehicleid) != -1  && RentCarKey[playerid] == vehicleid) {

				// GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

				if(!GetLockStatus(vehicleid))
				{
					GameTextForPlayer(playerid, sprintf("~r~%s Locked", ReturnVehicleModelName(GetVehicleModel(vehicleid))), 2000, 4);
					//SetVehicleParamsEx(vehicleid, engine, lights, alarm, 1, bonnet, boot, objective);
					SetLockStatus(vehicleid, true);
					PlayerPlaySoundEx(playerid, 24600);
				}
				else
				{
					GameTextForPlayer(playerid, sprintf("~g~%s Unlocked", ReturnVehicleModelName(GetVehicleModel(vehicleid))), 2000, 4);
					//SetVehicleParamsEx(vehicleid, engine, lights, alarm, 0, bonnet, boot, objective);
					SetLockStatus(vehicleid, false);
					PlayerPlaySoundEx(playerid, 24600);
				}
			}
		}
		else
		{
			if(playerData[playerid][pPCarkey] != id && playerData[playerid][pPDupkey] != playerCarData[id][carDupKey]) {

				SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: คุณไม่สามารถเข้าถึงยานพาหนะนี้ได้");

				//id = PlayerCar_GetID(vehicleid);
				if (GetLockStatus(vehicleid)) {
					if (isequal(params, "breakin")) {
						if(playerCarData[id][carProtect] == 0) {
							SendClientMessage(playerid, COLOR_WHITE, "คุณสามารถเริ่มพังประตูได้ในขณะนี้! วิธีในการพัง:");
							SendClientMessage(playerid, COLOR_WHITE, "-กำปั้น");
							SendClientMessage(playerid, COLOR_WHITE, "-อาวุธระยะประชิด");

							vehicleData[vehicleid][vbreakin] = 50 + floatround(playerCarData[id][carLock]*25);
							vehicleData[vehicleid][vbreaktime] = 20;
						}
						else SendClientMessage(playerid, COLOR_LIGHTRED, "ยานพาหนะคันนี้ยังอยู่ในโหมดป้องกันตัวเอง โปรดลองใหม่ภายหลัง");
					}
					else SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: หากคุณพยายามที่จะพังเข้าไป: "EMBED_YELLOW"\"/lock "EMBED_WHITE"breakin"EMBED_YELLOW"\"");
				}
			}
			else {
				// GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

				if(!GetLockStatus(vehicleid))
				{
					GameTextForPlayer(playerid, sprintf("~r~%s Locked", ReturnVehicleModelName(GetVehicleModel(vehicleid))), 2000, 4);
					//SetVehicleParamsEx(vehicleid, engine, lights, alarm, 1, bonnet, boot, objective);
					SetLockStatus(vehicleid, true);
					PlayerPlaySoundEx(playerid, 24600);
				}
				else
				{
					GameTextForPlayer(playerid, sprintf("~g~%s Unlocked", ReturnVehicleModelName(GetVehicleModel(vehicleid))), 2000, 4);
					//SetVehicleParamsEx(vehicleid, engine, lights, alarm, 0, bonnet, boot, objective);
					SetLockStatus(vehicleid, false);
					PlayerPlaySoundEx(playerid, 24600);
				}	
			}
		}
	}
	else if (IsPlayerAtHouseArea(playerid)) {
		PlayerLockHouse(playerid);
	}
	else if (IsPlayerAtBusinessArea(playerid)) {
		PlayerLockBusiness(playerid);
	}
	else if ((id = IsPlayerNearestEntrance(playerid) != -1)) {
		ToggleEntranceLockStatus(playerid, id);
	}
	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, " ..ไม่มีอะไรรอบ ๆ ตัวคุณที่สามารถล็อกได้");
	}
	return 1;
}


CMD:enter(playerid)
{
	if (IsPlayerAtHouseEntrance(playerid)) {
		PlayerEnterNearestHouse(playerid);
	}
	else if (IsPlayerAtBusinessEntrance(playerid)) {
		PlayerEnterNearestBusiness(playerid);
	}
	else if (IsPlayerAtEntranceEntrance(playerid)) {
		PlayerEnterNearestEntrance(playerid);
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4,2073.2979,-1831.1228,13.5469))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
			new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
			if (factionType == FACTION_TYPE_POLICE)
	        {
	            if(playerData[playerid][pOnDuty])
	            {
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, 2062.1294,-1831.5498,13.5469);
	        		SetVehicleZAngle(tmpcar, 90);
					SetPVarInt(playerid, "SprayID", 1);
					TogglePlayerControllable(playerid, 0);
	        		SetTimerEx("AfterSpray", 7500, 0, "i", playerid);
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTRED, "คุณจำเป็นต้องปฏิบัติหน้าที่! (OnDuty)");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่เจ้าหน้าที่ตำรวจ");
			}
	    }
	}
	else if (IsPlayerInRangeOfPoint(playerid, 4,1024.9756,-1030.7930,32.0257))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
			new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
			if (factionType == FACTION_TYPE_POLICE)
	        {
	            if(playerData[playerid][pOnDuty])
	            {
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, 1024.9763,-1021.8850,32.1016);
	        		SetVehicleZAngle(tmpcar, 0);
	        		SetPVarInt(playerid, "SprayID", 2);
	        		TogglePlayerControllable(playerid, 0);
	        		SetTimerEx("AfterSpray", 7500, 0, "i", playerid);
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTRED, "คุณจำเป็นต้องปฏิบัติหน้าที่! (OnDuty)");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่เจ้าหน้าที่ตำรวจ");
			}
	    }
	}
	else if (IsPlayerInRangeOfPoint(playerid, 4,488.3819,-1733.0563,11.1752))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
			new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
			if (factionType == FACTION_TYPE_POLICE)
	        {
	            if(playerData[playerid][pOnDuty])
	            {
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, 487.4099,-1741.4585,11.1330);
	        		SetVehicleZAngle(tmpcar, 180);
	        		SetPVarInt(playerid, "SprayID", 3);
	        		TogglePlayerControllable(playerid, 0);
	        		SetTimerEx("AfterSpray", 7500, 0, "i", playerid);
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTRED, "คุณจำเป็นต้องปฏิบัติหน้าที่! (OnDuty)");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่เจ้าหน้าที่ตำรวจ");
			}
	    }
	}
	
	////////////////////

	else if (IsPlayerInRangeOfPoint(playerid, 4,719.8940,-464.8272,16.3359))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
			new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
			if (factionType == FACTION_TYPE_POLICE)
	        {
	            if(playerData[playerid][pOnDuty])
	            {
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, 720.3924,-456.0286,16.3359);
	        		SetVehicleZAngle(tmpcar, 0);
	        		SetPVarInt(playerid, "SprayID", 4);
	        		TogglePlayerControllable(playerid, 0);
	        		SetTimerEx("AfterSpray", 7500, 0, "i", playerid);
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTRED, "คุณจำเป็นต้องปฏิบัติหน้าที่! (OnDuty)");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่เจ้าหน้าที่ตำรวจ");
			}
	    }
	}
	//////////////////////////////////////////////////////////////////////////////
  	else if (IsPlayerInRangeOfPoint(playerid, 4,-1904.5464,275.1555,40.3010))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
			new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
			if (factionType == FACTION_TYPE_POLICE)
	        {
	            if(playerData[playerid][pOnDuty])
	            {
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, -1904.1996,284.1657,40.2974);
	        		SetVehicleZAngle(tmpcar, 180);
	        		SetPVarInt(playerid, "SprayID", 5);
	        		TogglePlayerControllable(playerid, 0);
	        		SetTimerEx("AfterSpray", 7500, 0, "i", playerid);
				}
				else
				{
				    SendClientMessage(playerid, COLOR_LIGHTRED, "คุณจำเป็นต้องปฏิบัติหน้าที่! (OnDuty)");
				}
			}
			else
			{
			    SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่เจ้าหน้าที่ตำรวจ");
			}
	    }
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 630.8229,-3058.3379,10.4870)) // Prison #1
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
	        if(playerData[playerid][pOnDuty])
	        {
				SetPlayerPos(playerid, 632.8108,-3063.8755,10.3060);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTRED, "คุณจำเป็นต้องปฏิบัติหน้าที่! (OnDuty)");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่เจ้าหน้าที่ตำรวจ");
		}
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 604.3121,-3136.1377,10.1333)) // Prison #2
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
	        if(playerData[playerid][pOnDuty])
	        {
				SetPlayerPos(playerid, 605.4823,-3140.5581,10.1325);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTRED, "คุณจำเป็นต้องปฏิบัติหน้าที่! (OnDuty)");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่เจ้าหน้าที่ตำรวจ");
		}
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 645.8768,-3115.1067,11.0019)) // Prison #3
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
	        if(playerData[playerid][pOnDuty])
	        {
				SetPlayerPos(playerid, 1765.1758,-1568.9832,1742.4930);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTRED, "คุณจำเป็นต้องปฏิบัติหน้าที่! (OnDuty)");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่เจ้าหน้าที่ตำรวจ");
		}
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 1779.7113,-1580.5214,1742.4500)) // Prison #4
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
	        if(playerData[playerid][pOnDuty])
	        {
				SetPlayerPos(playerid, 1779.7740,-1577.9274,1741.9115);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTRED, "คุณจำเป็นต้องปฏิบัติหน้าที่! (OnDuty)");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่เจ้าหน้าที่ตำรวจ");
		}
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 1780.2192,-1576.5327,1734.9430)) // Prison #5
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
			if(systemVariables[PrisonStatus] == 0)
			{
				if(playerData[playerid][pOnDuty])
				{
					SetPlayerPos(playerid, 624.5247,-3146.2415,10.3016);
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTRED, "คุณจำเป็นต้องปฏิบัติหน้าที่! (OnDuty)");
				}
			}
			else return SendClientMessage(playerid, COLOR_GRAD2, "ประตูไม่ได้ถูกเปิดใช้งาน, กรุณารอการเปิดใช้งานจากผู้คุมเรือนจำ");
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่เจ้าหน้าที่ตำรวจ");
		}
	}

	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ใกล้ทางเข้าใด ๆ");
	}
	return 1;
}

alias:exit("ex");
CMD:exit(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid) && IsVehicleRental(vehicleid) != -1 || (!GetEngineStatus(vehicleid) && IsEngineVehicle(vehicleid)))
	{
		RemovePlayerFromVehicle(playerid);
		TogglePlayerControllable(playerid, true);
	}
	else if (IsPlayerAtHouseExit(playerid)) {
		PlayerExitHouse(playerid);
	}
	else if (IsPlayerAtBusinessExit(playerid)) {
		PlayerExitBusiness(playerid);
	}
	else if (IsPlayerAtEntranceExit(playerid)) {
		PlayerExitEntrance(playerid);
	}
	else if(VDealerSetting{playerid})
	{
		ExitSettingVehicle(playerid);
	}
	else if (IsPlayerInRangeOfPoint(playerid, 4,2062.1294,-1831.5498,13.5469))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
	        new tmpcar = GetPlayerVehicleID(playerid);
			DeletePVar(playerid, "SprayID");
			TogglePlayerControllable(playerid, 1);
			SetVehiclePos(tmpcar, 2073.2979,-1831.1228,13.5469);
			SetVehicleZAngle(tmpcar, 0);
	    }
	}
	else if (IsPlayerInRangeOfPoint(playerid, 4,1024.9763,-1021.8850,32.1016))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
	        new tmpcar = GetPlayerVehicleID(playerid);
			DeletePVar(playerid, "SprayID");
			TogglePlayerControllable(playerid, 1);
			SetVehiclePos(tmpcar, 1024.9756,-1030.7930,32.0257);
			SetVehicleZAngle(tmpcar, 90);
	    }
	}
	else if (IsPlayerInRangeOfPoint(playerid, 4,487.4099,-1741.4585,11.1330))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
	        new tmpcar = GetPlayerVehicleID(playerid);
			DeletePVar(playerid, "SprayID");
			TogglePlayerControllable(playerid, 1);
			SetVehiclePos(tmpcar, 488.3819,-1733.0563,11.1752);
			SetVehicleZAngle(tmpcar, 90);
	    }
	}
	
	else if (IsPlayerInRangeOfPoint(playerid, 4,720.3924,-456.0286,16.3359))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
	        new tmpcar = GetPlayerVehicleID(playerid);
			DeletePVar(playerid, "SprayID");
			TogglePlayerControllable(playerid, 1);
			SetVehiclePos(tmpcar, 719.8940,-464.8272,16.3359);
			SetVehicleZAngle(tmpcar, 90);
	    }
	}
	
 	else if (IsPlayerInRangeOfPoint(playerid, 4,-1904.1996,284.1657,40.2974))
	{ // Pay & Spray
	    if(GetPlayerState(playerid) == 2)
	    {
	        new tmpcar = GetPlayerVehicleID(playerid);
			DeletePVar(playerid, "SprayID");
			TogglePlayerControllable(playerid, 1);
			SetVehiclePos(tmpcar, -1904.5464,275.1555,40.3010);
			SetVehicleZAngle(tmpcar, 90);
	    }
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 632.8108,-3063.8755,10.3060)) // Prison #1
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
	        if(playerData[playerid][pOnDuty])
	        {
				SetPlayerPos(playerid, 630.8229,-3058.3379,10.4870);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTRED, "คุณจำเป็นต้องปฏิบัติหน้าที่! (OnDuty)");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่เจ้าหน้าที่ตำรวจ");
		}
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 605.4823,-3140.5581,10.1325)) // Prison #2
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
	        if(playerData[playerid][pOnDuty])
	        {
				SetPlayerPos(playerid, 604.3121,-3136.1377,10.1333);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTRED, "คุณจำเป็นต้องปฏิบัติหน้าที่! (OnDuty)");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่เจ้าหน้าที่ตำรวจ");
		}
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 1765.1758,-1568.9832,1742.4930)) // Prison #3
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
	        if(playerData[playerid][pOnDuty])
	        {
				SetPlayerPos(playerid, 645.8768,-3115.1067,11.0019);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTRED, "คุณจำเป็นต้องปฏิบัติหน้าที่! (OnDuty)");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่เจ้าหน้าที่ตำรวจ");
		}
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 1779.7740,-1577.9274,1741.9115)) // Prison #4
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
	        if(playerData[playerid][pOnDuty])
	        {
				SetPlayerPos(playerid, 1779.7113,-1580.5214,1742.4500);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_LIGHTRED, "คุณจำเป็นต้องปฏิบัติหน้าที่! (OnDuty)");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่เจ้าหน้าที่ตำรวจ");
		}
	}

	else if (IsPlayerInRangeOfPoint(playerid, 4, 624.5247,-3146.2415,10.3016)) // Prison #5
	{
		new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
		if (factionType == FACTION_TYPE_POLICE)
	    {
			if(systemVariables[PrisonStatus] == 0)
			{
				if(playerData[playerid][pOnDuty])
				{
					SetPlayerPos(playerid, 1780.2192,-1576.5327,1734.9430);
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTRED, "คุณจำเป็นต้องปฏิบัติหน้าที่! (OnDuty)");
				}
			}
			else return SendClientMessage(playerid, COLOR_GRAD2, "ประตูไม่ได้ถูกเปิดใช้งาน, กรุณารอการเปิดใช้งานจากผู้คุมเรือนจำ");
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่เจ้าหน้าที่ตำรวจ");
		}
	}

	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ใกล้ทางออกใด ๆ");
	}
	return 1;
}

alias:buy("fill", "eat");
CMD:buy(playerid, params[])
{
	new id = -1;
	if ((id = IsPlayerInteractiveBusiness(playerid)) != -1) {
		Store_Interactive(playerid, id, params);
	}
	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ใกล้ร้านค้าใด ๆ");
	}
    return 1;
}

//----------------------------------[Bank System]-----------------------------------------------

CMD:bank(playerid, params[]) {
	if (IsPlayerAtBank(playerid)) {
		ShowBankMenu(playerid);
	}
	else SendClientMessage(playerid, COLOR_GREY, "   คุณไม่ได้อยู่ที่ธนาคาร !");
	return 1;
}

ShowBankMenu(playerid) {
	return Dialog_Show(playerid,BankDialogMenu,DIALOG_STYLE_LIST,"ธนาคาร","ฝากเงิน\nถอนเงิน\nเช็คยอดเงิน\nโอนเงิน","เลือก","ยกเลิก");
}

Dialog:BankDialogMenu(playerid, response, listitem, inputtext[])
{
	if(response) {
		switch(listitem) {
			case 0: { // ฝากเงิน
	        	Dialog_Show(playerid,BankDialog_Deposit,DIALOG_STYLE_INPUT,"ฝากเงิน",""EMBED_DIALOG"ยอดเงินคงเหลือของคุณ : %s"EMBED_DIALOG"\nกรอกจำนวนที่คุณต้องการฝากด้านล่างนี้:","ฝาก","กลับ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));
			}
			case 1: { // ถอนเงิน
	        	Dialog_Show(playerid,BankDialog_Withdraw,DIALOG_STYLE_INPUT,"ถอนเงิน",""EMBED_DIALOG"ยอดเงินคงเหลือของคุณ : %s"EMBED_DIALOG"\nกรอกจำนวนที่คุณต้องการถอนด้านล่างนี้:","ถอน","กลับ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));
			}
			case 2: {
				PC_EmulateCommand(playerid, "/balance");
				ShowBankMenu(playerid);
			}
			case 3: { // โอน
				if (playerData[playerid][pPlayingHours] < 2)
					return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถโอนเงินในขณะที่ชั่วโมงที่เล่นต่ำกว่า 2 ชั่วโมง");

	        	Dialog_Show(playerid,BankDialog_Transfer,DIALOG_STYLE_INPUT,"โอนเงิน",""EMBED_DIALOG"ยอดเงินคงเหลือของคุณ : %s"EMBED_DIALOG"\nกรอก ไอดี/ชื่อบางส่วน ที่คุณต้องการโอนด้านล่างนี้:","ถัดไป","กลับ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));
			}
		}
	}
	return 1;
}

Dialog:BankDialog_Deposit(playerid, response, listitem, inputtext[])
{
	if(response) {
		new cashdeposit = strval(inputtext);

		if(playerData[playerid][pSavingsCollect]) 
			return Dialog_Show(playerid,BankDialog_Deposit,DIALOG_STYLE_INPUT,"ฝากเงิน",""EMBED_DIALOG"ยอดเงินคงเหลือของคุณ : %s"EMBED_DIALOG"\nกรอกจำนวนที่คุณต้องการฝากด้านล่างนี้:\n\n"EMBED_LIGHTRED"เกิดข้อผิดพลาด: "EMBED_WHITE"คุณไม่สามารถใช้คำสั่งนี้ได้ในขณะที่เปิดบัญชีออมทรัพย์","ฝาก","กลับ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));

		if (cashdeposit > playerData[playerid][pCash] || cashdeposit < 1)
			return Dialog_Show(playerid,BankDialog_Deposit,DIALOG_STYLE_INPUT,"ฝากเงิน",""EMBED_DIALOG"ยอดเงินคงเหลือของคุณ : %s"EMBED_DIALOG"\nกรอกจำนวนที่คุณต้องการฝากด้านล่างนี้:\n\n"EMBED_LIGHTRED"เกิดข้อผิดพลาด: "EMBED_WHITE"คุณไม่ได้มีเงินมากขนาดนั้น","ฝาก","กลับ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));

		GivePlayerMoneyEx(playerid, -cashdeposit);
		//playerData[playerid][pCash] -= cashdeposit;
		new curfunds = playerData[playerid][pAccount];
		playerData[playerid][pAccount]=cashdeposit+playerData[playerid][pAccount];

		return Dialog_Show(playerid,BankDialog_ReturnMenu,DIALOG_STYLE_MSGBOX,"รายการเงินฝากถอนในบัญชีเงินฝาก","|___ BANK STATEMENT ___|\n  ยอดเงินเก่า: $%d\n  เงินฝาก: $%d\n|-----------------------------------------|\n  ยอดเงินใหม่: $%d","กลับ","", curfunds, cashdeposit, playerData[playerid][pAccount]);
	}
    return ShowBankMenu(playerid);
}

Dialog:BankDialog_Withdraw(playerid, response, listitem, inputtext[])
{
	if(response) {
		new cashwithdraw = strval(inputtext);
		if(cashwithdraw < 250) 
			return Dialog_Show(playerid,BankDialog_Withdraw,DIALOG_STYLE_INPUT,"ถอนเงิน",""EMBED_DIALOG"ยอดเงินคงเหลือของคุณ : %s"EMBED_DIALOG"\nกรอกจำนวนที่คุณต้องการถอนด้านล่างนี้:\n\n"EMBED_LIGHTRED"เกิดข้อผิดพลาด: "EMBED_WHITE"ถอนได้ตั้งแต่ $250 ขึ้นไป","ถอน","กลับ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));
	    
		if(playerData[playerid][pSavingsCollect]) 
			return Dialog_Show(playerid,BankDialog_Withdraw,DIALOG_STYLE_INPUT,"ถอนเงิน",""EMBED_DIALOG"ยอดเงินคงเหลือของคุณ : %s"EMBED_DIALOG"\nกรอกจำนวนที่คุณต้องการถอนด้านล่างนี้:\n\n"EMBED_LIGHTRED"เกิดข้อผิดพลาด: "EMBED_WHITE"คุณไม่สามารถใช้คำสั่งนี้ได้ในขณะที่เปิดบัญชีออมทรัพย์","ถอน","กลับ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));

        new tax = floatround(cashwithdraw * 0.002, floatround_round);
		if (cashwithdraw+tax > playerData[playerid][pAccount] || cashwithdraw < 1) 
			return Dialog_Show(playerid,BankDialog_Withdraw,DIALOG_STYLE_INPUT,"ถอนเงิน",""EMBED_DIALOG"ยอดเงินคงเหลือของคุณ : %s"EMBED_DIALOG"\nกรอกจำนวนที่คุณต้องการถอนด้านล่างนี้:\n\n"EMBED_LIGHTRED"เกิดข้อผิดพลาด: "EMBED_WHITE"คุณไม่ได้มีเงินมากขนาดนั้น","ถอน","กลับ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));

	    cashwithdraw = cashwithdraw - tax;
		// playerData[playerid][pCash] += cashwithdraw;
		GivePlayerMoneyEx(playerid, cashwithdraw);
		playerData[playerid][pAccount] -= cashwithdraw + tax;

		return Dialog_Show(playerid,BankDialog_ReturnMenu,DIALOG_STYLE_MSGBOX, "ถอนเงิน","คุณถอน $%d จากบัญชีของคุณ คงเหลือ: $%d ภาษี $%d","กลับ","", cashwithdraw, playerData[playerid][pAccount], cashwithdraw + tax, playerData[playerid][pAccount], tax);
	}
    return ShowBankMenu(playerid);
}

Dialog:BankDialog_ReturnMenu(playerid) {
	return ShowBankMenu(playerid);
}

Dialog:BankDialog_Transfer(playerid, response, listitem, inputtext[])
{
	if(response) {
		new targetid = INVALID_PLAYER_ID;
		if(sscanf(inputtext,"u", targetid)) {
			Dialog_Show(playerid,BankDialog_Transfer,DIALOG_STYLE_INPUT,"โอนเงิน",""EMBED_DIALOG"ยอดเงินคงเหลือของคุณ : %s"EMBED_DIALOG"\nกรอก ไอดี/ชื่อบางส่วน ที่คุณต้องการโอนด้านล่างนี้:","ถัดไป","กลับ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));
			return 1;
		}
		SetPVarInt(playerid, "TransferID", targetid);
		Dialog_Show(playerid,BankDialog_Confirm,DIALOG_STYLE_INPUT,"โอนเงิน",""EMBED_DIALOG"ยอดเงินคงเหลือของคุณ : %s"EMBED_DIALOG"\nผู้เล่นที่ต้องการโอน: (%d) %s\nตอนนี้กรอกจำนวนที่คุณต้องการโอนด้านล่างนี้:","ถัดไป","กลับ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""), targetid, ReturnRealName(targetid));
		return 1;
	}
    return ShowBankMenu(playerid);
}

Dialog:BankDialog_Confirm(playerid, response, listitem, inputtext[])
{
	if(response) {
		PC_EmulateCommand(playerid, sprintf("/transfer %d %s", GetPVarInt(playerid, "TransferID"), inputtext));
		DeletePVar(playerid, "TransferID");
		return ShowBankMenu(playerid);
	}
    return Dialog_Show(playerid,BankDialog_Transfer,DIALOG_STYLE_INPUT,"โอนเงิน",""EMBED_DIALOG"ยอดเงินคงเหลือของคุณ : %s"EMBED_DIALOG"\nกรอก ไอดี/ชื่อบางส่วน ที่คุณต้องการโอนด้านล่างนี้:","ถัดไป","กลับ", FormatNumber(playerData[playerid][pAccount], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));
}

CMD:deposit(playerid, params[])
{
	if (IsPlayerAtBank(playerid)) {
		new cashdeposit;
		if (sscanf(params, "d", cashdeposit))
		{
			SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /deposit [จำนวน]");
			SendClientMessageEx(playerid, COLOR_GRAD3, "  คุณมี $%d อยู่ในบัญชี", playerData[playerid][pAccount]);
			return 1;
		}

		if(playerData[playerid][pSavingsCollect]) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถใช้คำสั่งนี้ได้ในขณะที่เปิดบัญชีออมทรัพย์");
		if (cashdeposit > playerData[playerid][pCash] || cashdeposit < 1) return SendClientMessage(playerid, COLOR_GRAD2, "   คุณไม่ได้มีมากขนาดนั้น");

		//playerData[playerid][pCash] -= cashdeposit;
		GivePlayerMoneyEx(playerid, -cashdeposit);
		new curfunds = playerData[playerid][pAccount];
		playerData[playerid][pAccount]=cashdeposit+playerData[playerid][pAccount];

		SendClientMessage(playerid, COLOR_WHITE, "|___ BANK STATEMENT ___|");
		SendClientMessageEx(playerid, COLOR_FADE1, "  ยอดเงินเก่า: $%d", curfunds);
		SendClientMessageEx(playerid, COLOR_FADE1, "  เงินฝาก: $%d", cashdeposit);
		SendClientMessage(playerid, COLOR_WHITE, "|-----------------------------------------|");
		SendClientMessageEx(playerid, COLOR_WHITE, "  ยอดเงินใหม่: $%d", playerData[playerid][pAccount]);
	}
	else SendClientMessage(playerid, COLOR_GREY, "   คุณไม่ได้อยู่ที่ธนาคาร !");
	return 1;
}


CMD:withdraw(playerid, params[])
{
	new cashdeposit, tax;

    if(IsPlayerAtBank(playerid)) {

		if (sscanf(params, "d", cashdeposit))
		{
			SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /withdraw [จำนวน]");
			SendClientMessageEx(playerid, COLOR_GRAD3, "  คุณมี $%d อยู่ในบัญชี", playerData[playerid][pAccount]);
			return 1;
		}
		if(cashdeposit < 250) return SendClientMessage(playerid, COLOR_LIGHTRED, "ถอนได้ตั้งแต่ $250 ขึ้นไป");
	    if(playerData[playerid][pSavingsCollect]) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถใช้คำสั่งนี้ได้ในขณะที่เปิดบัญชีออมทรัพย์");

        tax = floatround(cashdeposit * 0.002, floatround_round);
		if (cashdeposit+tax > playerData[playerid][pAccount] || cashdeposit < 1) return SendClientMessage(playerid, COLOR_GRAD2, "   คุณไม่ได้มีมากขนาดนั้น !");

	    cashdeposit = cashdeposit - tax;
		GivePlayerMoneyEx(playerid, cashdeposit);
		//playerData[playerid][pCash] += cashdeposit;
		playerData[playerid][pAccount] -= cashdeposit + tax;
	 	SendClientMessageEx(playerid, COLOR_YELLOW, "  คุณถอน $%d จากบัญชีของคุณ คงเหลือ: $%d ภาษี $%d", cashdeposit + tax, playerData[playerid][pAccount], tax);

	}
	else SendClientMessage(playerid, COLOR_GREY, "   คุณไม่ได้อยู่ที่ธนาคาร !");

	return 1;
}

CMD:balance(playerid, params[])
{
	if(IsPlayerAtBank(playerid)) {
		SendClientMessageEx(playerid, COLOR_YELLOW, "  คุณมี $%d อยู่ในบัญชี", playerData[playerid][pAccount]);
	} else SendClientMessage(playerid, COLOR_GREY, "   คุณไม่ได้อยู่ที่ธนาคาร !");
	return 1;
}

CMD:transfer(playerid, params[])
{
	if (IsPlayerAtBank(playerid)) {

        new targetid, amount, str[128];
        
		if (playerData[playerid][pPlayingHours] < 2)
	    	return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถโอนเงินในขณะที่ชั่วโมงที่เล่นต่ำกว่า 2 ชั่วโมง");

		if(playerData[playerid][pSavingsCollect]) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถใช้คำสั่งนี้ได้ในขณะที่เปิดบัญชีออมทรัพย์");

		if(sscanf(params,"ud", targetid, amount)) {
			SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /transfer [ไอดี/ชื่อบางส่วน] [จำนวน]");
			SendClientMessageEx(playerid, COLOR_GRAD3, "  คุณมี $%d อยู่ในบัญชี", playerData[playerid][pAccount]);
			return 1;
		}

        if(playerData[playerid][pAccount] < amount || amount < 1) return SendClientMessage(playerid, COLOR_GRAD2, "  คุณไม่ได้มีมากขนาดนั้น");
		if(playerid == targetid) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถโอนเงินให้ตัวเองได้");

		if (amount > 10000)
		{
			format(str, sizeof(str), "AdmWarn: %s (%d) ได้โอนเงินให้ %s (%d) เป็นจำนวน %d", ReturnRealName(playerid), playerid, ReturnRealName(targetid), targetid, amount);
			SendAdminMessage(COLOR_YELLOW, CMD_MANAGEMENT, str);
		}

		if(IsPlayerConnected(targetid)) {

			playerData[playerid][pAccount] -= amount;
			playerData[targetid][pAccount] += amount;

			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "คุณได้โอนเงิน $%d เข้าบัญชีของ %d", amount, ReturnRealName(targetid));
			SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "คุณได้รับ $%d เข้าธนาคารจากบัญชีของ %s", amount, ReturnRealName(playerid));

			Log(transferlog, INFO, "%s โอนเงินให้กับ %s จำนวน %d", ReturnPlayerName(playerid), ReturnPlayerName(targetid), amount);
		}
		else {
		    SendClientMessage(playerid, COLOR_GREY, "   ไม่พบข้อมูลบัญชีหมายเลขนี้ !");
		}
		
	} else SendClientMessage(playerid, COLOR_GREY, "   คุณไม่ได้อยู่ที่ธนาคาร !");
	return 1;
}


Dialog:WithdrawSavings(playerid, response, listitem, inputtext[])
{
	if(response) {
		SendClientMessage(playerid, COLOR_WHITE, "คุณปิดบัญชีออมทรัพย์เรียบร้อยแล้ว");
		GivePlayerMoneyEx(playerid, playerData[playerid][pSavingsCollect]);
		playerData[playerid][pSavings] = 0;
		playerData[playerid][pSavingsCollect] = 0;
	}
	return 1;
}

CMD:savings(playerid, params[])
{
	if(IsPlayerAtBank(playerid)) {

		if(isequal(params, "withdraw"))
		{
			if (playerData[playerid][pSavings]) {
				Dialog_Show(playerid, WithdrawSavings, DIALOG_STYLE_MSGBOX, "ยืนยันที่จะถอนเงิน", ""EMBED_DIALOG"คุณแน่ใจหรือที่จะถอนเงินจาก"EMBED_RED"บัญชีออมทรัพย์"EMBED_DIALOG" ?\nมันไม่สามารถเปลี่ยนกลับได้และคุณจะต้องเริ่มต้นใหม่!", "ตกลง", "ไม่");
			}
			else SendClientMessage(playerid, COLOR_LIGHTBLUE, "คุณไม่มีบัญชีออมทรัพย์");
		}
		else
		{
			if(playerData[playerid][pSavings])
			{
				SendClientMessage(playerid, COLOR_WHITE, "|_______ BANK STATEMENT _______|");
				SendClientMessageEx(playerid, COLOR_GRAD1, "ยอดเงินในบัญชีเงินฝากออมทรัพย์: %s", FormatNumber(playerData[playerid][pSavingsCollect]));
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "[ ! ] "EMBED_WHITE"คุณมี %s อยู่ในบัญชีฝากออมทรัพย์", FormatNumber(playerData[playerid][pSavingsCollect]));

				new paycheck = 0, maximum = 20000000;
				new i = playerData[playerid][pSavings], currently;

				while(i < maximum)
				{
					i += floatround((i/100.0)*(0.5), floatround_round);
					paycheck++;

					if(playerData[playerid][pSavingsCollect] > i) currently = 2 + paycheck;
				}


				SendClientMessageEx(playerid, COLOR_LIGHTRED, "[ ! ] "EMBED_WHITE"เงินฝากออมทรัพย์ของคุณเหลืออีก %d/%d paydays (%d%s)", currently, paycheck, floatround(float(currently) / float(paycheck) * 100), "%%");
				SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: "EMBED_WHITE" เพื่อถอนเงินฝา{FF6347}ก ใช้ /savings withdraw");
			}
			else
			{
				new savings = strval(params);

				if (!savings)
					return SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้:"EMBED_WHITE" เพื่อสร้างบัญชีออมทรัพย์ /savings [จำนวน]");

				if(savings == 50000 || savings == 100000)
				{
					if(playerData[playerid][pCash] > savings)
					{
						playerData[playerid][pSavings] = savings;
						playerData[playerid][pSavingsCollect] = savings;
						playerData[playerid][pCash] -= savings;

						SendClientMessage(playerid, COLOR_WHITE, "|_______ BANK STATEMENT _______|");
						SendClientMessageEx(playerid, COLOR_GRAD1, "ยอดเงินในบัญชีเงินฝากออมทรัพย์: %s", FormatNumber(savings));
						SendClientMessageEx(playerid, COLOR_LIGHTRED, "[ ! ] "EMBED_WHITE"คุณมี %s อยู่ในบัญชีฝากออมทรัพย์", FormatNumber(savings));


						new paycheck = 0, maximum = 20000000;
						new i = playerData[playerid][pSavings], currently;

						while(i < maximum)
						{
							i += floatround((i/float(100))*(0.5), floatround_round);
							paycheck++;
							if(playerData[playerid][pSavingsCollect] > i) currently = 2 + paycheck;
						}


						SendClientMessageEx(playerid, COLOR_LIGHTRED, "[ ! ] "EMBED_WHITE"เงินฝากออมทรัพย์ของคุณเหลืออีก %d/%d paydays (%d%s)", currently, paycheck, floatround(currently / float(paycheck) * 100), "%%");
						SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: "EMBED_WHITE" เพื่อถอนเงินฝา{FF6347}ก ใช้ /savings withdraw");
					}
					else SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอ !");
				}
				else SendClientMessage(playerid, COLOR_LIGHTRED, "เงินฝากออมทรัพย์ต้องอยู่ระหว่าง $50,000 และ $100,000 เท่านั้น");
			}
		}
	}
	else SendClientMessage(playerid, COLOR_GREY, "   คุณไม่ได้อยู่ที่ธนาคาร !");
	return 1;
}

// 

CMD:accept(playerid, params[])
{
	if (isnull(params))
 	{
	 	SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /accept [ชื่อ]");
		SendClientMessage(playerid, COLOR_GREY, "ชื่อที่ใช้ได้: invite");
		return 1;
	}
	if (!strcmp(params, "invite", true) && GetPVarType(playerid, "OfferID"))
	{
	    new
	        targetid = GetPVarInt(playerid, "OfferID"),
	        factionSID = GetPVarInt(playerid, "OfferFactionID"); // sid

		if (IsPlayerConnected(targetid)) {

			new factionid = Faction_GetID(factionSID); // index

			if (playerData[targetid][pFactionRank] > 1)
				return SendClientMessage(playerid, COLOR_GRAD1, "   ข้อเสนอฝ่ายหรือกลุ่มไม่สามารถใช้งานได้");

			playerData[playerid][pFaction] = factionSID;
			playerData[playerid][pFactionRank] = factionData[factionid][fMaxRanks];

			SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "   คุณได้ยอมรับข้อเสนอ %s เพื่อเข้าร่วม \"%s\"", ReturnRealName(targetid), Faction_GetName(factionid));
			SendClientMessageEx(targetid, COLOR_LIGHTBLUE, "   %s ได้ยอมรับข้อเสนอของคุณเพื่อเข้าร่วม \"%s\"", ReturnRealName(playerid), Faction_GetName(factionid));

			DeletePVar(playerid, "OfferID");
			DeletePVar(playerid, "OfferFactionID");
		}
		else {
			return SendClientMessage(playerid, COLOR_GRAD1, "   ข้อเสนอฝ่ายหรือกลุ่มไม่สามารถใช้งานได้");
		}
	}
	return 1;
}

/* Anim  */
alias:animhelp("anim");
CMD:animhelp(playerid, params[])
{
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "คำสั่งนี้ใช้ได้เฉพาะเมื่อยืนอยู่บนพื้น");
    if(gIsDeathMode{playerid} || gIsInjuredMode{playerid} || BitFlag_Get(gPlayerBitFlag[playerid],IS_CUFFED))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถใช้คำสั่งได้ในขณะนี้");

    SendClientMessage(playerid, COLOR_GREEN,"____________อนิเมชั่นตัวละคร____________");
	SendClientMessage(playerid, COLOR_WHITE,"[นั่ง/นอน] /sit /chairsit /groundsit /seat /sleep /lean");
	SendClientMessage(playerid, COLOR_WHITE,"[สัญญาณมือ] /gsign /salute");
	SendClientMessage(playerid, COLOR_WHITE,"[การสื่อสาร] /greet /taxiL /taxiR");
    SendClientMessage(playerid, COLOR_WHITE,"[การสื่อสาร] /fuckyou /wave /kiss /no");
    SendClientMessage(playerid, COLOR_WHITE,"[กริยาทางกายภาพ] /bat /punch /taunt /facepalm /aim /slapass");
    SendClientMessage(playerid, COLOR_WHITE,"[กริยาทางกายภาพ] /hide /crawl /crack /think /sipdrink /sipdrink2");
    SendClientMessage(playerid, COLOR_WHITE,"[อารมณ์] /cry /injured /panic");
    SendClientMessage(playerid, COLOR_GREEN,"_____________________________________________");

    GameTextForPlayer(playerid, "TO STOP ANIMATION TYPE ~r~/STOPANIM OR PRESS ~r~ENTER.", 3000, 4);

	new str[3500];
    strcat(str, "/fall | /fallback | /injured | /akick | /push | /lowbodypush | /handsup | /bomb | /drunk | /getarrested | /laugh | /sup\n");
    strcat(str, "/basket | /headbutt | /medic | /spray | /robman | /taichi | /lookout | /kiss | /cellin | /cellout | /crossarms | /lay\n");
	strcat(str, "/deal | /crack | /groundsit | /chat  | /dance | /fucku | /strip | /hide | /vomit | /chairsit | /reload\n");
    strcat(str, "/koface | /kostomach | /rollfall | /bat | /die | /joint | /bed | /lranim | /fixcar | /fixcarout\n");
    strcat(str, "/lifejump | /exhaust | /leftslap | /carlock | /hoodfrisked | /lightcig | /tapcig | /box | /lay2 | /chant | /fuckyou| /fuckyou2\n");
    strcat(str, "/shouting | /knife | /cop | /elbow | /kneekick | /airkick | /gkick | /punch | /gpunch | /fstance | /lowthrow | /highthrow | /aim\n");
    strcat(str, "/pee | /lean | /run | /poli | /surrender | /sit | /breathless | /seat | /rap | /cross | /jiggy | /gsign\n");
    strcat(str, "/sleep | /smoke | /pee | /chora | /relax | /crabs | /stop | /wash | /mourn | /fuck | /tosteal | /crawl\n");
    strcat(str, "/followme | /greet | /still | /hitch | /palmbitch | /cpranim | /giftgiving | /slap2 | /pump | /cheer\n");
    strcat(str, "/dj | /foodeat | /wave | /slapass | /dealer | /dealstance | /inbedright | /inbedleft\n");
	strcat(str, "/wank | /bj | /getup | /follow | /stand | /slapped | /yes | /celebrate | /win | /checkout\n");
	strcat(str, "/thankyou | /invite1 | /scratch | /nod | /cry | /carsmoke | /benddown | /facepalm | /angry\n");
	strcat(str, "/cockgun | /bar | /liftup | /putdown | /camera | /think | /handstand | /panicjump\n");
    Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "ท่าทางอื่น ๆ", str, "โอเค", "");
	return 1;
}

AnimationCheck(playerid)
{
	return (gIsDeathMode{playerid} || BitFlag_Get(gPlayerBitFlag[playerid], IS_CUFFED));
}

ApplyAnimationEx(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
{
	if(gIsInjuredMode{playerid})
	    return 0;

	ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
	return 1;
}

CMD:greet(playerid, params[])
{
	new targetid, type;
	if(sscanf(params,"ud",targetid,type)) {
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /greet [ไอดีผู้เล่น/ชื่อบางส่วน] [style]");
		SendClientMessage(playerid, COLOR_YELLOW3, "[1] Kiss [2] Handshake [3] Handshake [4] Handshake [5] Handshake");
		SendClientMessage(playerid, COLOR_YELLOW3, "[6] Handshake [7] Handshake [8] Handshake [9] Handshake [10] Handshake");
		return 1;
	}

	if(targetid == INVALID_PLAYER_ID)
		SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if(targetid == playerid) 
		return SendClientMessage(playerid, COLOR_GREY, "คุณไม่สามารถทักทายตัวเองได้");

	if(type > 10 || type < 1) 
		return SendClientMessage(playerid, COLOR_WHITE, "มีแค่ 1-10!");

	if (!IsPlayerNearPlayer(playerid, targetid, 2.0)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

	SetPVarInt(playerid, "SentGreet", 1);
	SetPVarInt(playerid, "GreetType", type);
	SetPVarInt(targetid, "GreetFrom", playerid);
	SetPVarInt(targetid, "GettingGreet", 1);

	SendClientMessageEx(playerid, COLOR_WHITE, "* คุณต้องการทักทาย %s", ReturnRealName(targetid));
	SendClientMessageEx(targetid, COLOR_WHITE, "(ID: %d)%s อยากจะเริ่มทักทายกับคุณ(/acceptshake playerID)", playerid,ReturnRealName(playerid));
	return 1;
}

CMD:acceptshake(playerid, params[])
{
	new targetid;
	if(sscanf(params,"d",targetid)) return SendClientMessage(playerid, COLOR_GREY, "{FF6142}USAGE:"EMBED_WHITE" /acceptshake [ไอดีผู้เล่น/ชื่อบางส่วน]");
	if(GetPVarInt(playerid, "GettingGreet") == 0) return SendClientMessage(playerid, COLOR_GREY, "ไม่มีใครต้องการทักทายคุณ");
	if(GetPVarInt(playerid, "GreetFrom") != targetid) return SendClientMessage(playerid, COLOR_GREY, "คุณไม่ได้ถูกร้องขอการทักทายจากผู้เล่นนี้");

	if(targetid == INVALID_PLAYER_ID) {
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");
	}

	if(targetid == playerid) return SendClientMessage(playerid, COLOR_GREY, "คุณไม่สามารถทักทายตัวเองได้");


	if (!IsPlayerNearPlayer(playerid, targetid, 1.0)) return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

    if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถทักทายได้ในขณะนี้");
    if (AnimationCheck(targetid)) return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนี้ไม่สามารถทักทายคุณได้ในขณะนี้");

	new type = GetPVarInt(targetid, "GreetType");

	ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	playerData[playerid][pAnimation] = 0;

	ApplyAnimationEx(targetid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
	SetPlayerSpecialAction(targetid, SPECIAL_ACTION_NONE);
	playerData[targetid][pAnimation] = 0;

	SetPlayerFacePlayer(playerid, targetid);
	SetPlayerFacePlayer(targetid, playerid);


	if(type == 1)
	{
		ApplyAnimation(playerid, "KISSING", "Playa_Kiss_02", 2.0, 0, 0, 1, 0, 0);
		ApplyAnimation(targetid, "KISSING", "Playa_Kiss_02", 2.0, 0, 0, 1, 0, 0);
	}
	else if(type == 2)
	{
		ApplyAnimation(playerid,"GANGS","hndshkfa_swt", 2.0, 0, 0, 0, 0, 0);
		ApplyAnimation(targetid,"GANGS","hndshkfa_swt", 2.0, 0, 0, 0, 0, 0);
	}
	else if(type == 3)
	{
		ApplyAnimation(playerid,"GANGS","hndshkba", 2.0, 0, 0, 0, 0, 0);
		ApplyAnimation(targetid,"GANGS","hndshkba", 2.0, 0, 0, 0, 0, 0);
	}
	else if(type == 4)
	{
		ApplyAnimation(playerid,"GANGS","hndshkca", 2.0, 0, 0, 0, 0, 0);
		ApplyAnimation(targetid,"GANGS","hndshkca", 2.0, 0, 0, 0, 0, 0);
	}
	else if(type == 5)
	{
		ApplyAnimation(playerid,"GANGS","hndshkcb", 2.0, 0, 0, 0, 0, 0);
		ApplyAnimation(targetid,"GANGS","hndshkcb", 2.0, 0, 0, 0, 0, 0);
	}
	else if(type == 6)
	{
		ApplyAnimation(playerid,"GANGS","hndshkda", 2.0, 0, 0, 0, 0, 0);
		ApplyAnimation(targetid,"GANGS","hndshkda", 2.0, 0, 0, 0, 0, 0);
	}
	else if(type == 7)
	{
		ApplyAnimation(playerid,"GANGS","hndshkea", 2.0, 0, 0, 0, 0, 0);
		ApplyAnimation(targetid,"GANGS","hndshkea", 2.0, 0, 0, 0, 0, 0);
	}
	else if(type == 8)
	{
		ApplyAnimation(playerid,"GANGS","hndshkfa", 2.0, 0, 0, 0, 0, 0);
		ApplyAnimation(targetid,"GANGS","hndshkfa", 2.0, 0, 0, 0, 0, 0);
	}
	else if(type == 9)
	{
		ApplyAnimation(playerid,"GANGS","hndshkaa", 2.0, 0, 0, 0, 0, 0);
		ApplyAnimation(targetid,"GANGS","hndshkaa", 2.0, 0, 0, 0, 0, 0);
	}
	else if(type == 10)
	{
		ApplyAnimation(playerid,"GANGS","prtial_hndshk_biz_01", 2.0, 0, 0, 0, 0, 0);
		ApplyAnimation(targetid,"GANGS","prtial_hndshk_biz_01", 2.0, 0, 0, 0, 0, 0);
	}
	DeletePVar(GetPVarInt(playerid, "GreetFrom"), "SentGreet");
	DeletePVar(GetPVarInt(playerid, "GreetFrom"), "GreetType");
	DeletePVar(playerid, "GreetFrom");
	DeletePVar(playerid, "GettingGreet");
	return 1;
}

CMD:stopanim(playerid)
{
	if(BitFlag_Get(gPlayerBitFlag[playerid], IS_CUFFED)) {
		ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
    	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CUFFED);
    	return 1;
    }
    
    if (AnimationCheck(playerid))
        return SendClientMessage(playerid, COLOR_GRAD1, "ไม่สามารถหยุด Animation ได้ในขณะนี้");

	if ((playerData[playerid][pAnimation] || GetPlayerCameraMode(playerid) == 55) && GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) {
		playerData[playerid][pAnimation] = 0;
		ClearAnimations(playerid);
		return 1;
	}

	if(playerData[playerid][pAnimation]) {
		ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		playerData[playerid][pAnimation] = 0;
	}
	return 1;
}
alias:stopanim("sa");

CMD:no(playerid, params[])
{
    if (AnimationCheck(playerid))
        return SendClientMessage(playerid, COLOR_GRAD1, "ไม่สามารถเล่น Animation ได้ในขณะนี้");

    ApplyAnimation(playerid, "PED","endchat_02", 4.1, 0, 0, 0, 0, 0);
   	return 1;
}
alias:no("ไม่");

CMD:punch(playerid, params[])
{
    if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "ไม่สามารถเล่น Animation ได้ในขณะนี้");
    ApplyAnimation(playerid, "RIOT", "RIOT_PUNCHES", 4.1, 0, 1, 1, 0, 0, 0);
    return 1;
}
alias:punch("ต่อย", "ชก");

CMD:crawl(playerid, params[])
{
    if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "ไม่สามารถเล่น Animation ได้ในขณะนี้");
    ApplyAnimation(playerid, "PED", "CAR_CRAWLOUTRHS", 4.1, 0, 0, 0, 0, 0, 0);
    return 1;
}
alias:crawl("คลาน");

CMD:sipdrink(playerid, params[])
{
    if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "ไม่สามารถเล่น Animation ได้ในขณะนี้");
    ApplyAnimation(playerid, "BAR", "DNK_STNDM_LOOP", 4.1, 0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:sipdrink2(playerid, params[])
{
    if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "ไม่สามารถเล่น Animation ได้ในขณะนี้");
    ApplyAnimation(playerid, "BAR", "DNK_STNDF_LOOP", 4.1, 0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:surrender(playerid,params[])
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !AnimationCheck(playerid))
	{
		playerData[playerid][pAnimation] = 1;
	    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
  		return 1;
	}
	else return SendClientMessage(playerid, COLOR_GRAD2, "ไม่สามารถเล่น Animation ได้ในขณะนี้");
}
alias:surrender("ยอม", "มอบตัว");
	
CMD:sit(playerid,params[])
{
    new anim;
    if(sscanf(params, "d", anim)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /sit [1-5]");

	playerData[playerid][pAnimation] = 1;

    switch(anim){
		case 1: ApplyAnimation(playerid,"BEACH","bather",4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid,"BEACH","Lay_Bac_Loop",4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid,"BEACH","ParkSit_W_loop",4.1, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimation(playerid,"BEACH","SitnWait_loop_W",4.1, 0, 1, 1, 1, 1, 1);
		case 5: ApplyAnimation(playerid,"BEACH","SitnWait_loop_W",4.1, 0, 1, 1, 1, 1, 1);
		case 6: ApplyAnimation(playerid,"BEACH", "ParkSit_M_loop", 4.1, 0, 1, 1, 1, 1, 1);
		default: {
			return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /sit [1-5]");
		}
	}
	return 1;
}
alias:sit("นั่ง");

CMD:sleep(playerid,params[])
{
	new anim;
	
	if(sscanf(params, "d", anim)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /sleep [1-2]");
	playerData[playerid][pAnimation] = 1;
	switch(anim){
		case 1: ApplyAnimation(playerid,"CRACK","crckdeth4",4.1, 0, 1, 1, 1, 1, 1); 
		case 2: ApplyAnimation(playerid,"CRACK","crckidle2",4.1, 0, 1, 1, 1, 1, 1); 
		default: {
			return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /sleep [1-2]");
		}
	}
	return 1;
}

CMD:salute(playerid, params[])
{
    if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "ไม่สามารถเล่น Animation ได้ในขณะนี้");
    playerData[playerid][pAnimation] = 1;

    ApplyAnimation(playerid, "GHANDS", "GSIGN5LH", 4.1, false, false, false, false, 0, false);
    return 1;
}

CMD:cheer(playerid,params[])
{
	new anim;

	if(sscanf(params, "d", anim)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /cheer [1-8]");
	playerData[playerid][pAnimation] = 1;
	switch(anim){
		case 1: ApplyAnimation(playerid,"ON_LOOKERS","shout_01",4.1, 0, 1, 1, 1, 1, 1); 
		case 2: ApplyAnimation(playerid,"ON_LOOKERS","shout_02",4.1, 0, 1, 1, 1, 1, 1); 
		case 3: ApplyAnimation(playerid,"ON_LOOKERS","shout_in",4.1, 0, 1, 1, 1, 1, 1); 
		case 4: ApplyAnimation(playerid,"RIOT","RIOT_ANGRY_B",4.1, 0, 1, 1, 1, 1, 1); 
		case 5: ApplyAnimation(playerid,"RIOT","RIOT_CHANT",4.1, 0, 1, 1, 1, 1, 1); 
		case 6: ApplyAnimation(playerid,"RIOT","RIOT_shout",4.1, 0, 1, 1, 1, 1, 1); 
		case 7: ApplyAnimation(playerid,"STRIP","PUN_HOLLER",4.1, 0, 1, 1, 1, 1, 1); 
		case 8: ApplyAnimation(playerid,"OTB","wtchrace_win",4.1, 0, 1, 1, 1, 1, 1); 
		default: {
			return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /cheer [1-8]");
		}
	}
	return 1;
}	
alias:cheer("เชียร์");
	
CMD:dj(playerid,params[]){
    new anim;
    if(sscanf(params, "d", anim)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /dj [1-4]");
	playerData[playerid][pAnimation] = 1;
    switch(anim){
		case 1: ApplyAnimation(playerid,"SCRATCHING","scdldlp",4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid,"SCRATCHING","scdlulp",4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid,"SCRATCHING","scdrdlp",4.1, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimation(playerid,"SCRATCHING","scdrulp",4.1, 0, 1, 1, 1, 1, 1);
		default: {
			return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /dj [1-4]");
		}
	}
	return 1;
}
	
CMD:breathless(playerid,params[]){
    new anim;
    if(sscanf(params, "d", anim)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /breathless [1-2]");
	playerData[playerid][pAnimation] = 1;
    switch(anim){
		case 1: ApplyAnimation(playerid,"PED","IDLE_tired",4.1, 1, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid,"FAT","IDLE_tired",4.1, 1, 1, 1, 1, 1, 1);
        default: {
			return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /breathless [1-2]");
		}
	}
	return 1;
}
	
CMD:poli(playerid,params[]){
    new anim;
    if(sscanf(params, "d", anim)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /poli [1-2]");
	playerData[playerid][pAnimation] = 1;
	switch(anim){
		case 1:ApplyAnimation(playerid,"POLICE","CopTraf_Come",4.1, 0, 1, 1, 1, 1, 1);
		case 2:ApplyAnimation(playerid,"POLICE","CopTraf_Stop",4.1, 0, 1, 1, 1, 1, 1);
		default: {
			return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /poli [1-2]");
		}
	}
	return 1;
}
	
CMD:seat(playerid,params[]){
    new anim;
    if(sscanf(params, "d", anim)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /seat [1-7]");
	if(anim < 1 || anim > 7) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /seat [1-7]");
	playerData[playerid][pAnimation] = 1;
	switch(anim){
		case 1: ApplyAnimation(playerid,"Attractors","Stepsit_in",4.1, 0, 0, 0, 1, 0, 0);
		case 2: ApplyAnimation(playerid,"CRIB","PED_Console_Loop",4.1, 0, 0, 0, 1, 0, 0);
		case 3: ApplyAnimation(playerid,"INT_HOUSE","LOU_In",4.1, 0, 0, 0, 1, 0, 0);
		case 4: ApplyAnimation(playerid,"MISC","SEAT_LR",4.1, 0, 0, 0, 1, 0, 0);
		case 5: ApplyAnimation(playerid,"MISC","Seat_talk_01",4.1, 0, 0, 0, 1, 0, 0);
		case 6: ApplyAnimation(playerid,"MISC","Seat_talk_02",4.1, 0, 0, 0, 1, 0, 0);
		case 7: ApplyAnimation(playerid,"ped","SEAT_down",4.1, 0, 0, 0, 1, 0, 0);
	}
	return 1;
}
	
CMD:dance(playerid,params[]){
    new dancestyle;
    if(sscanf(params, "d", dancestyle)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /dance [1-3]");
	playerData[playerid][pAnimation] = 1;
	switch(dancestyle){
		case 1: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
		case 2: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
		case 3: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
		case 4: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
	}
   	return 1;
}
	
CMD:cross(playerid,params[]){
    new anim;
    if(sscanf(params, "d", anim)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /cross [1-5]");
	playerData[playerid][pAnimation] = 1;
	switch(anim){
		case 1: ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE", 4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_01", 4.1, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimation(playerid,"GRAVEYARD","mrnM_loop",4.1, 0, 1, 1, 1, 1, 1);
		case 5: ApplyAnimation(playerid,"GRAVEYARD","prst_loopa",4.1, 0, 1, 1, 1, 1, 1);
		default: return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /cross [1-5]");
	}
	return 1;
}
	
CMD:jiggy(playerid,params[])
{
    new anim;
    if(sscanf(params, "d", anim)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /jiggy [1-10]");
	playerData[playerid][pAnimation] = 1;
	switch(anim){
		case 1: ApplyAnimation(playerid,"DANCING","DAN_Down_A",4.1, 1, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid,"DANCING","DAN_Left_A",4.1, 1, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid,"DANCING","DAN_Loop_A",4.1, 1, 1, 1, 1, 1, 1);
		case 4: ApplyAnimation(playerid,"DANCING","DAN_Right_A",4.1, 1, 1, 1, 1, 1, 1);
		case 5: ApplyAnimation(playerid,"DANCING","DAN_Up_A",4.1, 1, 1, 1, 1, 1, 1);
		case 6: ApplyAnimation(playerid,"DANCING","dnce_M_a",4.1, 1, 1, 1, 1, 1, 1);
		case 7: ApplyAnimation(playerid,"DANCING","dnce_M_b",4.1, 1, 1, 1, 1, 1, 1);
		case 8: ApplyAnimation(playerid,"DANCING","dnce_M_c",4.1, 1, 1, 1, 1, 1, 1);
		case 9: ApplyAnimation(playerid,"DANCING","dnce_M_c",4.1, 1, 1, 1, 1, 1, 1);
		case 10: ApplyAnimation(playerid,"DANCING","dnce_M_d",4.1, 1, 1, 1, 1, 1, 1);
		default: return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /jiggy [1-10]");
	}
	return 1;
}
	
CMD:rap(playerid,params[]){
    new rapstyle;
    if(sscanf(params, "d", rapstyle)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /rap [1-3]");
	playerData[playerid][pAnimation] = 1;
	switch(rapstyle){
		case 1: ApplyAnimation(playerid,"RAPPING","RAP_A_Loop",4.1, 1, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid,"RAPPING","RAP_B_Loop",4.1, 1, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid,"RAPPING","RAP_C_Loop",4.1, 1, 1, 1, 1, 1, 1);
		default: return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /rap [1-3]");
	}
   	return 1;
}
	
CMD:gsign(playerid,params[]){
    new gesture;
    if(sscanf(params, "d", gesture)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /gsign [1-15]");
	playerData[playerid][pAnimation] = 1;
	switch(gesture){
		case 1: ApplyAnimation(playerid,"GHANDS","gsign1",4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid,"GHANDS","gsign1LH",4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid,"GHANDS","gsign2",4.1, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimation(playerid,"GHANDS","gsign2LH",4.1, 0, 1, 1, 1, 1, 1);
		case 5: ApplyAnimation(playerid,"GHANDS","gsign3",4.1, 0, 1, 1, 1, 1, 1);
		case 6: ApplyAnimation(playerid,"GHANDS","gsign3LH",4.1, 0, 1, 1, 1, 1, 1);
		case 7: ApplyAnimation(playerid,"GHANDS","gsign4",4.1, 0, 1, 1, 1, 1, 1);
		case 8: ApplyAnimation(playerid,"GHANDS","gsign4LH",4.1, 0, 1, 1, 1, 1, 1);
		case 9: ApplyAnimation(playerid,"GHANDS","gsign5",4.1, 0, 1, 1, 1, 1, 1);
		case 10: ApplyAnimation(playerid,"GHANDS","gsign5",4.1, 0, 1, 1, 1, 1, 1);
		case 11: ApplyAnimation(playerid,"GHANDS","gsign5LH",4.1, 0, 1, 1, 1, 1, 1);
		case 12: ApplyAnimation(playerid,"GANGS","Invite_No",4.1, 0, 1, 1, 1, 1, 1);
		case 13: ApplyAnimation(playerid,"GANGS","Invite_Yes",4.1, 0, 1, 1, 1, 1, 1);
		case 14: ApplyAnimation(playerid,"GANGS","prtial_gngtlkD",4.1, 0, 1, 1, 1, 1, 1);
		case 15: ApplyAnimation(playerid,"GANGS","smkcig_prtl",4.1, 0, 1, 1, 1, 1, 1);
		default: return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /gsign [1-15]");
	}
	return 1;
}
	
CMD:smoke(playerid,params[]){
    new gesture;
    if(sscanf(params, "d", gesture)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /smoke [1-2]");
	playerData[playerid][pAnimation] = 1;
	switch(gesture){
		case 1: ApplyAnimation(playerid,"SMOKING","M_smk_in",4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid,"SMOKING","M_smklean_loop",4.1, 0, 1, 1, 1, 1, 1);
		default: return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /smoke [1-2]");
	}
	return 1;
}
	
CMD:chora(playerid,params[]) { ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_watch",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:relax(playerid,params[]) { ApplyAnimation(playerid, "CRACK", "crckidle1",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:crabs(playerid,params[]) { ApplyAnimation(playerid,"MISC","Scratchballs_01",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:stop(playerid,params[]) { ApplyAnimation(playerid,"PED","endchat_01",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:wash(playerid,params[]) { ApplyAnimation(playerid,"BD_FIRE","wash_up",4.1, 0, 0, 0, 0, 0, 0); return 1; }
CMD:mourn(playerid,params[]) { ApplyAnimation(playerid,"GRAVEYARD","mrnF_loop",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:followme(playerid,params[]) { ApplyAnimation(playerid,"WUZI","Wuzi_follow",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:still(playerid,params[]) { ApplyAnimation(playerid,"WUZI","Wuzi_stand_loop", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:hitch(playerid,params[]) { ApplyAnimation(playerid,"MISC","Hiker_Pose", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:palmbitch(playerid,params[]) { ApplyAnimation(playerid,"MISC","bitchslap",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:cpranim(playerid,params[]) { ApplyAnimation(playerid,"MEDIC","CPR",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:giftgiving(playerid,params[]) { ApplyAnimation(playerid,"KISSING","gift_give",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:slap2(playerid,params[]) { ApplyAnimation(playerid,"SWEET","sweet_ass_slap",4.1, 0, 1, 1, 0, 0, 1); return 1; }

CMD:taxiL(playerid) {
	ApplyAnimation(playerid,"MISC","Hiker_Pose_L",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}

CMD:taxiR(playerid) {
	ApplyAnimation(playerid,"MISC","Hiker_Pose",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}


CMD:handstand(playerid) {
	ApplyAnimation(playerid,"DAM_JUMP","DAM_Dive_Loop",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}

CMD:panicjump(playerid) {
	ApplyAnimation(playerid,"DODGE","Crush_Jump",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}

CMD:drunk(playerid,params[]) { 
	ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1; 
}
CMD:pump(playerid,params[]) { ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 1, 1, 0, 1, 1); return 1; }
CMD:tosteal(playerid,params[]) { ApplyAnimation(playerid,"ped", "ARRESTgun", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:laugh(playerid,params[]) { ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:lookout(playerid,params[])  { 
	ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.1, 0, 1, 1, 0, 0, 1); 
	return 1; 
}
CMD:robman(playerid,params[]) { ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:hide(playerid,params[]) { 
	ApplyAnimation(playerid, "ped", "cower",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1; 
}
CMD:vomit(playerid,params[]) { ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:crack(playerid,params[]) { 
	new choice;
	if(sscanf(params, "d", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /crack [1-3]");
		return 1;
	}
	playerData[playerid][pAnimation] = 1;
	switch(choice) {
		case 1: ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid, "CRACK","crckidle3", 4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid, "CRACK","crckidle4", 4.1, 0, 1, 1, 1, 1, 1);
	}
	return 1;
}
CMD:fuck(playerid,params[]) { ApplyAnimation(playerid,"PED","fucku",4.1, 0, 1, 1, 1, 1, 1); return 1; }
CMD:taichi(playerid,params[]) { 
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"PARK","Tai_Chi_Loop", 4.1, 1, 1, 1, 1, 1, 1); 
	return 1; 
}
CMD:kiss(playerid,params[]) { ApplyAnimation(playerid,"KISSING","Playa_Kiss_01",4.1, 0, 1, 1, 0, 1, 1); return 1; }

CMD:handsup(playerid, params[])//19 1:00 pm , 4/27/2012
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid, "ROB_BANK","SHP_HandsUp_Scr",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}
CMD:cellin(playerid, params[])// 20 1:01 pm, 4/27/2012
{
	if(AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, "ไม่สามารถเล่น Animation ได้ในขณะนี้");
	playerData[playerid][pAnimation] = 1;
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
	return 1;
}
CMD:cellout(playerid, params[])//21 1:02 pm , 4/27/2012
{
	if(AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, "ไม่สามารถเล่น Animation ได้ในขณะนี้");
	playerData[playerid][pAnimation] = 1;
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
	return 1;
}
CMD:bomb(playerid, params[])//23 4/27/2012
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 1, 1, 1, 1, 1); // Place Bomb
	return 1;
}
CMD:getarrested(playerid, params[])//24 4/27/2012
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"ped", "ARRESTgun", 4.1, 0, 1, 1, 1, 1, 1); // Gun Arrest
	return 1;
}
CMD:crossarms(playerid, params[])//28
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 0, 1, 1, 1, 1, 1); // Arms crossed
	return 1;
}

CMD:lay(playerid, params[])//29
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"BEACH", "bather",4.1, 0, 1, 1, 1, 1, 1); // Lay down
	return 1;
}

CMD:foodeat(playerid, params[])//32
{
	ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 1, 1, 1, 1, 1); // Eat Burger
	return 1;
}

CMD:wave(playerid, params[])//33
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.1, 1, 1, 1, 1, 1, 1); // Wave
	return 1;
}

CMD:slapass(playerid, params[])//34
{
	ApplyAnimation(playerid, "SWEET", "sweet_ass_slap", 4.1, 0, 1, 1, 0, 0, 1); // Ass Slapping
 	return 1;
}

CMD:dealer(playerid, params[])//35
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.1, 0, 1, 1, 1, 1, 1); // Deal Drugs
	return 1;
}

CMD:groundsit(playerid, params[])//38
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"BEACH", "ParkSit_M_loop", 4.1, 0, 1, 1, 1, 1, 1); // Sit
	return 1;
}

CMD:chat(playerid, params[])//39
{
	new num;
	if(sscanf(params, "i", num)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /chat [1-2]");
	if(num > 2 || num < 1) { SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /chat [1-2]"); }
	playerData[playerid][pAnimation] = 1;
	if(num == 1) { ApplyAnimation(playerid,"PED","IDLE_CHAT",4.1, 1, 1, 1, 1, 1, 1); }
	else { ApplyAnimation(playerid,"MISC","Idle_Chat_02",4.1, 1, 1, 1, 1, 1, 1); }
    return 1;
}

CMD:fucku(playerid, params[])//40
{
	ApplyAnimation(playerid,"PED","fucku",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:chairsit(playerid, params[])//42
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"PED","SEAT_idle",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:fall(playerid, params[])//43
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"PED","KO_skid_front",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:fallback(playerid, params[])//44
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid, "PED","FLOOR_hit_f", 4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:injured(playerid, params[])//46
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:sup(playerid, params[])//47
{
	new number;
	if(sscanf(params, "i", number)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /sup [1-3]");
	if(number < 1 || number > 3) { SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /sup [1-3]"); }
	playerData[playerid][pAnimation] = 1;
	if(number == 1) { ApplyAnimation(playerid,"GANGS","hndshkba",4.1, 0, 1, 1, 1, 1, 1); }
	if(number == 2) { ApplyAnimation(playerid,"GANGS","hndshkda",4.1, 0, 1, 1, 1, 1, 1); }
    if(number == 3) { ApplyAnimation(playerid,"GANGS","hndshkfa_swt",4.1, 0, 1, 1, 1, 1, 1); }
   	return 1;
}

CMD:push(playerid, params[])// 49
{
	ApplyAnimation(playerid,"GANGS","shake_cara",4.1, 0, 1, 1, 0, 1, 1);
    return 1;
}

CMD:akick(playerid, params)// 50
{
	ApplyAnimation(playerid,"POLICE","Door_Kick",4.1, 0, 1, 1, 0, 1, 1);
    return 1;
}

CMD:lowbodypush(playerid, params[])// 51
{
	ApplyAnimation(playerid,"GANGS","shake_carSH",4.1, 0, 1, 1, 0, 0, 1);
    return 1;
}

CMD:spray(playerid, params[])// 52
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"SPRAYCAN","spraycan_full",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:headbutt(playerid, params[])//53
{
	ApplyAnimation(playerid,"WAYFARER","WF_Fwd",4.1, 0, 1, 1, 0, 0, 1);
	return 1;
}

CMD:medic(playerid, params[])//54
{
	ApplyAnimation(playerid,"MEDIC","CPR",4.1, 0, 1, 1, 0, 0, 1);
    return 1;
}

CMD:koface(playerid, params[])//55
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"PED","KO_shot_face",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:kostomach(playerid, params[])//56
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"PED","KO_shot_stom",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:lifejump(playerid, params[])//57
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"PED","EV_dive",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:exhaust(playerid, params[])//58
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"PED","IDLE_tired",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:leftslap(playerid, params[])//59
{
	ApplyAnimation(playerid,"PED","BIKE_elbowL",4.1, 0, 1, 1, 0, 0, 1);
    return 1;
}

CMD:rollfall(playerid, params[])//60
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"PED","BIKE_fallR",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:carlock(playerid, params[])//61
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"PED","CAR_doorlocked_LHS",4.1, 0, 1, 1, 0, 0, 1);
	return 1;
}

CMD:hoodfrisked(playerid, params[])//66
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"POLICE","crm_drgbst_01",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:lightcig(playerid, params[])//67
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"SMOKING","M_smk_in",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:tapcig(playerid, params[])//68
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"SMOKING","M_smk_tap",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:bat(playerid, params[])//69
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"BASEBALL","Bat_IDLE",4.1, 1, 1, 1, 1, 1, 1);
    return 1;
}

CMD:box(playerid, params[])//70
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"GYMNASIUM","GYMshadowbox",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:lay2(playerid, params[])//71
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"SUNBATHE","Lay_Bac_in",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:chant(playerid, params[])//72
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"RIOT","RIOT_CHANT",4.1, 0, 1, 1, 0, 0, 1);
    return 1;
}

CMD:fuckyou(playerid, params[])//73
{
	if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "ไม่สามารถเล่น Animation ได้ในขณะนี้");
    playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"RIOT","RIOT_FUKU",4.1, 0, 1, 1, 0, 0, 1);
    return 1;
}

CMD:fuckyou2(playerid, params[])
{
    if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "ไม่สามารถเล่น Animation ได้ในขณะนี้");
    playerData[playerid][pAnimation] = 1;
    ApplyAnimation(playerid, "RIOT", "RIOT_FUKU", 4.0, 0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:fixcar(playerid, params[])
{
    if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "ไม่สามารถเล่น Animation ได้ในขณะนี้");
    playerData[playerid][pAnimation] = 1;
    ApplyAnimation(playerid, "CAR", "FIXN_CAR_LOOP", 4.1, 0, 0, 0, 1, 0, 0);
    return 1;
}

CMD:fixcarout(playerid, params[])
{
    if (AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, "ไม่สามารถเล่น Animation ได้ในขณะนี้");
    playerData[playerid][pAnimation] = 1;
    ApplyAnimation(playerid, "CAR", "FIXN_CAR_OUT", 4.1, 0, 0, 0, 0, 0, 0);
    return 1;
}

CMD:shouting(playerid, params[])//74
{
	ApplyAnimation(playerid,"RIOT","RIOT_shout",4.1, 0, 1, 1, 0, 0, 1);
    return 1;
}

CMD:cop(playerid,params[])//75
{
	ApplyAnimation(playerid,"SWORD","sword_block",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:elbow(playerid, params[])//76
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"FIGHT_D","FightD_3",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:kneekick(playerid, params[])//77
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"FIGHT_D","FightD_2",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:fstance(playerid, params[])//78
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"FIGHT_D","FightD_IDLE",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:gpunch(playerid, params[])//79
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"FIGHT_B","FightB_G",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:airkick(playerid, params[])//80
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"FIGHT_C","FightC_M",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:gkick(playerid, params[])//81
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"FIGHT_D","FightD_G",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:lowthrow(playerid, params[])//82
{
	ApplyAnimation(playerid,"GRENADE","WEAPON_throwu",4.1, 0, 1, 1, 0, 0, 1);
    return 1;
}

CMD:highthrow(playerid, params[])//83
{
	ApplyAnimation(playerid,"GRENADE","WEAPON_throw",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:dealstance(playerid, params[])//84
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"DEALER","DEALER_IDLE",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:pee(playerid, params[])//85
{
	if(AnimationCheck(playerid)) return SendClientMessage(playerid, COLOR_GRAD2, "ไม่สามารถเล่น Animation ได้ในขณะนี้");
	playerData[playerid][pAnimation] = 1;
	SetPlayerSpecialAction(playerid, 68);
    return 1;
}

CMD:knife(playerid, params[])//86
{
	new nbr;
	if(sscanf(params, "i", nbr)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /knife [1-4]");
    if(nbr < 1 || nbr > 4) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /knife [1-4]"); 
	playerData[playerid][pAnimation] = 1;
	switch(nbr)
	{ 
		case 1: { ApplyAnimation(playerid,"KNIFE","KILL_Knife_Ped_Damage",4.1, 0, 1, 1, 1, 1, 1); }
		case 2: { ApplyAnimation(playerid,"KNIFE","KILL_Knife_Ped_Die",4.1, 0, 1, 1, 1, 1, 1); }
		case 3: { ApplyAnimation(playerid,"KNIFE","KILL_Knife_Player",4.1, 0, 1, 1, 1, 1, 1); }
		case 4: { ApplyAnimation(playerid,"KNIFE","KILL_Partial",4.1, 0, 1, 1, 1, 1, 1); }
	}
	return 1;
}

CMD:basket(playerid, params[])//87
{
	new ddr;
	if (sscanf(params, "i", ddr)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /basket [1-6]");
    if(ddr < 1 || ddr > 6) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /basket [1-6]"); 
    playerData[playerid][pAnimation] = 1;
	switch(ddr)
	{
		case 1: { ApplyAnimation(playerid,"BSKTBALL","BBALL_idleloop",4.1, 0, 1, 1, 1, 1, 1); }
		case 2: { ApplyAnimation(playerid,"BSKTBALL","BBALL_Jump_Shot",4.1, 0, 1, 1, 1, 1, 1); }
		case 3: { ApplyAnimation(playerid,"BSKTBALL","BBALL_pickup",4.1, 0, 1, 1, 1, 1, 1); }
		case 4: { ApplyAnimation(playerid,"BSKTBALL","BBALL_run",4.1, 0, 1, 1, 1, 1, 1); }
		case 5: { ApplyAnimation(playerid,"BSKTBALL","BBALL_def_loop",4.1, 1, 1, 1, 1, 1, 1); }
		case 6: { ApplyAnimation(playerid,"BSKTBALL","BBALL_Dnk",4.1, 0, 1, 1, 0, 1, 1); }
	}
   	return 1;
}

CMD:reload(playerid, params[])//88
{
	new result[128];
	if(sscanf(params, "s[24]", result)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /reload [deagle/smg/ak/m4]");
    if(strcmp(result,"deagle", true) == 0)
	{
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"COLT45","colt45_reload",4.1, 0, 1, 1, 1, 1, 1);
    }
    else if(strcmp(result,"smg", true) == 0)
    {
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"UZI","UZI_reload",4.1, 0, 1, 1, 1, 1, 1);
    }
	else if(strcmp(result,"ak", true) == 0)
	{
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"UZI","UZI_reload",4.1, 0, 1, 1, 1, 1, 1);
    }
	else if(strcmp(result,"m4", true) == 0)
	{
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"UZI","UZI_reload",4.1, 0, 1, 1, 1, 1, 1);
    }
   	else { SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /reload [deagle/smg/ak/m4]"); }
   	return 1;
}

CMD:aim(playerid, params[])//90
{
	new lmb;
	if(sscanf(params, "i", lmb)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /aim [1-3]");
	playerData[playerid][pAnimation] = 1;
	if(lmb == 1) { ApplyAnimation(playerid,"PED","gang_gunstand",4.1, 0, 1, 1, 1, 1, 1); }
    if(lmb == 2) { ApplyAnimation(playerid,"PED","Driveby_L",4.1, 0, 1, 1, 1, 1, 1); }
    if(lmb == 3) { ApplyAnimation(playerid,"PED","Driveby_R",4.1, 0, 1, 1, 1, 1, 1); }
    else { SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /aim [1-3]"); }
    return 1;
}

CMD:lean(playerid, params[])//91
{
	new mj;
	if(sscanf(params, "i", mj)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /lean [1-2]");
	if(mj < 1 || mj > 2) { SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /lean [1-2]"); }
    playerData[playerid][pAnimation] = 1;
	if(mj == 1) { ApplyAnimation(playerid,"GANGS","leanIDLE",4.1, 0, 1, 1, 1, 1, 1); }
	if(mj == 2) { ApplyAnimation(playerid,"MISC","Plyrlean_loop",4.1, 0, 1, 1, 1, 1, 1); }
   	return 1;
}

CMD:strip(playerid, params[])//93
{
	new kj;
    if(sscanf(params, "i", kj)) return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /strip [1-7]");
	if(kj < 1 || kj > 7) { SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /strip [1-7]"); }
	playerData[playerid][pAnimation] = 1;
	if(kj == 1) { ApplyAnimation(playerid,"STRIP", "strip_A", 4.1, 1, 1, 1, 1, 1, 1 ); }
	if(kj == 2) { ApplyAnimation(playerid,"STRIP", "strip_B", 4.1, 1, 1, 1, 1, 1, 1 ); }
    if(kj == 3) { ApplyAnimation(playerid,"STRIP", "strip_C", 4.1, 1, 1, 1, 1, 1, 1 ); }
    if(kj == 4) { ApplyAnimation(playerid,"STRIP", "strip_D", 4.1, 1, 1, 1, 1, 1, 1 ); }
    if(kj == 5) { ApplyAnimation(playerid,"STRIP", "strip_E", 4.1, 1, 1, 1, 1, 1, 1 ); }
    if(kj == 6) { ApplyAnimation(playerid,"STRIP", "strip_F", 4.1, 1, 1, 1, 1, 1, 1 ); }
    if(kj == 7) { ApplyAnimation(playerid,"STRIP", "strip_G", 4.1, 1, 1, 1, 1, 1, 1 ); }
 	return 1;
}

CMD:inbedright(playerid, params[])//94
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"INT_HOUSE","BED_Loop_R",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:inbedleft(playerid, params[])//95
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"INT_HOUSE","BED_Loop_L",4.1, 0, 1, 1, 1, 1, 1);
    return 1;
}

CMD:wank(playerid, params[])
{
	new choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /wank [1-2]");
		return 1;
	}
	if(strcmp(choice, "1", true) == 0)
	{
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"PAULNMAC","wank_in",4.1, 0, 1, 1, 1, 1, 1);
	}
	if(strcmp(choice, "2", true) == 0)
	{
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"PAULNMAC","wank_loop",4.1, 1, 1, 1, 1, 1, 1);
	}
	return 1;
}

CMD:bj(playerid, params[])
{
	new choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /bj [1-4]");
		return 1;
	}
	if(strcmp(choice, "1", true) == 0)
	{
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_START_P",4.1, 0, 1, 1, 1, 1, 1);
	}
	if(strcmp(choice, "2", true) == 0)
	{
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_START_W",4.1, 0, 1, 1, 1, 1, 1);
	}
	if(strcmp(choice, "3", true) == 0)
	{
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_LOOP_P",4.1, 0, 1, 1, 1, 1, 1);
	}
	if(strcmp(choice, "4", true) == 0)
	{
		playerData[playerid][pAnimation] = 1;
		ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_LOOP_W",4.1, 1, 0, 0, 1, 1, 1);

	}
	return 1;
}

CMD:stand(playerid, params[])
{
	playerData[playerid][pAnimation] = 1;
	ApplyAnimation(playerid,"WUZI","Wuzi_stand_loop", 4.1, 0, 1, 1, 1, 1, 1);
	return 1;
}

CMD:follow(playerid, params[])
{
	ApplyAnimation(playerid,"WUZI","Wuzi_follow",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
    return 1;
}

CMD:getup(playerid, params[])
{
	ApplyAnimation(playerid,"PED","getup",4.1, 0, 1, 1, 0, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}
CMD:slapped(playerid, params[])
{
	ApplyAnimation(playerid,"SWEET","ho_ass_slapped",4.1, 0, 1, 1, 0, 0, 1);
	playerData[playerid][pAnimation] = 1;
    return 1;
}

CMD:win(playerid, params[])
{
	new choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /win [1-2]");
		return 1;
	}
	if(strcmp(choice, "1", true) == 0)
	{
		ApplyAnimation(playerid,"CASINO","cards_win", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	if(strcmp(choice, "2", true) == 0)
	{
		ApplyAnimation(playerid,"CASINO","Roulette_win", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	return 1;
}

CMD:celebrate(playerid, params[])
{
	new choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /celebrate [1-2]");
		return 1;
	}
	if(strcmp(choice, "1", true) == 0)
	{
		ApplyAnimation(playerid,"benchpress","gym_bp_celebrate", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	if(strcmp(choice, "2", true) == 0)
	{
		ApplyAnimation(playerid,"GYMNASIUM","gym_tread_celebrate", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	return 1;
}

CMD:yes(playerid, params[])
{
	ApplyAnimation(playerid,"CLOTHES","CLO_Buy", 4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}

CMD:deal(playerid, params[])
{
	new choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /deal [1-2]");
		return 1;
	}
	if(strcmp(choice, "1", true) == 0)
	{
		ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	if(strcmp(choice, "2", true) == 0)
	{
		ApplyAnimation(playerid,"DEALER","DRUGS_BUY", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	return 1;
}

CMD:thankyou(playerid, params[])
{
	ApplyAnimation(playerid,"FOOD","SHP_Thank", 4.1, 0, 1, 1, 0, 0, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}

CMD:invite1(playerid, params[])
{
	new choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /invite1 [1-2]");
		return 1;
	}
	if(strcmp(choice, "1", true) == 0)
	{
		ApplyAnimation(playerid,"GANGS","Invite_Yes",4.1, 0, 1, 1, 0, 0, 1);
		playerData[playerid][pAnimation] = 1;
	}
	if(strcmp(choice, "2", true) == 0)
	{
		ApplyAnimation(playerid,"GANGS","Invite_No",4.1, 0, 1, 1, 0, 0, 1);
		playerData[playerid][pAnimation] = 1;
	}
	return 1;
}

CMD:scratch(playerid, params[])
{
	ApplyAnimation(playerid,"MISC","Scratchballs_01", 4.1, 0, 1, 1, 0, 0, 1);
	playerData[playerid][pAnimation] = 1;
    return 1;
}
CMD:checkout(playerid, params[])
{
	ApplyAnimation(playerid, "GRAFFITI", "graffiti_Chkout", 4.1, 0, 1, 1, 0, 0, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}
CMD:nod(playerid, params[])
{
	ApplyAnimation(playerid,"COP_AMBIENT","Coplook_nod",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}
CMD:think(playerid, params[])
{
	ApplyAnimation(playerid,"COP_AMBIENT","Coplook_think",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}
CMD:cry(playerid, params[])
{
	new choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /cry [1-2]");
		return 1;
	}
	if(strcmp(choice, "1", true) == 0)
	{
		ApplyAnimation(playerid,"GRAVEYARD","mrnF_loop", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	if(strcmp(choice, "2", true) == 0)
	{
		ApplyAnimation(playerid,"GRAVEYARD","mrnM_loop", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	return 1;
}
CMD:bed(playerid, params[])
{
	new choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /bed [1-2]");
		return 1;
	}
	if(strcmp(choice, "1", true) == 0)
	{
		ApplyAnimation(playerid,"INT_HOUSE","BED_In_L",4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	if(strcmp(choice, "2", true) == 0)
	{
		ApplyAnimation(playerid,"INT_HOUSE","BED_In_R",4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	if(strcmp(choice, "3", true) == 0)
	{
		ApplyAnimation(playerid,"INT_HOUSE","BED_Loop_L", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	if(strcmp(choice, "4", true) == 0)
	{
		ApplyAnimation(playerid,"INT_HOUSE","BED_Loop_R", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	return 1;
}
CMD:carsmoke(playerid, params[])
{
	ApplyAnimation(playerid,"PED","Smoke_in_car", 4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}

CMD:angry(playerid, params[])
{
	ApplyAnimation(playerid,"RIOT","RIOT_ANGRY",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}
CMD:benddown(playerid, params[])
{
	ApplyAnimation(playerid, "BAR", "Barserve_bottle", 4.1, 0, 1, 1, 0, 0, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}
CMD:facepalm(playerid, params[])
{
	ApplyAnimation(playerid, "MISC", "plyr_shkhead", 4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}
CMD:cockgun(playerid, params[])
{
	ApplyAnimation(playerid, "SILENCED", "Silence_reload", 4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}
CMD:bar(playerid, params[])
{
	new choice;
	if(sscanf(params, "d", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /bar [1-12]");
		return 1;
	}
	playerData[playerid][pAnimation] = 1;
	switch(choice) {
		case 1: ApplyAnimation(playerid, "BAR", "Barcustom_get", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid, "BAR","Barcustom_loop", 4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid, "BAR","Barcustom_order", 4.1, 0, 1, 1, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "BAR","BARman_idle", 4.1, 0, 1, 1, 1, 1, 1);
		case 5: ApplyAnimation(playerid, "BAR","Barserve_bottle", 4.1, 0, 1, 1, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "BAR","Barserve_give", 4.1, 0, 1, 1, 0, 0, 1);
		case 7: ApplyAnimation(playerid, "BAR","Barserve_glass", 4.1, 0, 1, 1, 0, 0, 1);
		case 8: ApplyAnimation(playerid, "BAR","Barserve_in", 4.1, 0, 1, 1, 1, 1, 1);
		case 9: ApplyAnimation(playerid, "BAR","Barserve_loop", 4.1, 1, 1, 1, 1, 1, 1);
		case 10: ApplyAnimation(playerid, "BAR","Barserve_order", 4.1, 0, 1, 1, 0, 0, 1);
		case 11: ApplyAnimation(playerid, "BAR","dnk_stndF_loop", 4.1, 0, 1, 1, 1, 1, 1);
		case 12: ApplyAnimation(playerid, "BAR","dnk_stndM_loop", 4.1, 0, 1, 1, 1, 1, 1);
	}
	return 1;
}
CMD:camera(playerid, params[])
{
	new choice;
	if(sscanf(params, "d", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /camera [1-10]");
		return 1;
	}
	playerData[playerid][pAnimation] = 1;
	switch(choice) {
		case 1: ApplyAnimation(playerid,  "CAMERA","camcrch_cmon", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid,  "CAMERA","camcrch_to_camstnd", 4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid,  "CAMERA","camstnd_cmon", 4.1, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimation(playerid,  "CAMERA","camstnd_idleloop", 4.1, 1, 0, 0, 1, 1, 1);
		case 5: ApplyAnimation(playerid,  "CAMERA","camstnd_lkabt", 4.1, 0, 1, 1, 1, 1, 1);
		case 6: ApplyAnimation(playerid,  "CAMERA","piccrch_in", 4.1, 0, 1, 1, 1, 1, 1);
		case 7: ApplyAnimation(playerid,  "CAMERA","piccrch_take", 4.1, 0, 1, 1, 1, 1, 1);
		case 8: ApplyAnimation(playerid,  "CAMERA","picstnd_in", 4.1, 0, 1, 1, 1, 1, 1);
		case 9: ApplyAnimation(playerid, "CAMERA","picstnd_out", 4.1, 0, 1, 1, 1, 1, 1);
		case 10: ApplyAnimation(playerid, "CAMERA","picstnd_take", 4.1, 0, 1, 1, 1, 1, 1);
	}
	return 1;
}

CMD:panic(playerid, params[])
{
	new choice;
	if(sscanf(params, "d", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /panic [1-4]");
		return 1;
	}
	playerData[playerid][pAnimation] = 1;
	switch(choice) {
		case 1: ApplyAnimation(playerid,"ON_LOOKERS","panic_cower", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid,"ON_LOOKERS","panic_hide", 4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid,"ON_LOOKERS","panic_in", 4.1, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimation(playerid,"ON_LOOKERS","panic_loop", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:liftup(playerid, params[])
{
	ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}

CMD:putdown(playerid, params[])
{
	ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}

CMD:joint(playerid, params[])
{
	ApplyAnimation(playerid,"GANGS","smkcig_prtl",4.1, 0, 1, 1, 1, 1, 1);
	playerData[playerid][pAnimation] = 1;
	return 1;
}
CMD:die(playerid, params[])
{
	new choice[32];
	if(sscanf(params, "s[32]", choice))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /die [1-2]");
		return 1;
	}
	if(strcmp(choice, "1", true) == 0)
	{
		ApplyAnimation(playerid,"KNIFE","KILL_Knife_Ped_Die",4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	if(strcmp(choice, "2", true) == 0)
	{
		ApplyAnimation(playerid, "PARACHUTE", "FALL_skyDive_DIE", 4.1, 0, 1, 1, 1, 1, 1);
		playerData[playerid][pAnimation] = 1;
	}
	return 1;
}

CMD:lranim(playerid, params[])
{
	if(IsInLowRider(playerid))
	{
		new choice;
		if(sscanf(params, "i", choice))
		{
			SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /lranim");
			SendClientMessage(playerid, COLOR_GRAD2, "ตัวเลือกที่มี: 0-36");
			return 1;
		}
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
		    SendClientMessage(playerid, COLOR_GRAD2, "  คุณต้องไม่ใช่คนขับรถ!");
		    return 1;
		}
		playerData[playerid][pAnimation] = 1;
		switch(choice)
		{
		    case 0:
		    {
				ApplyAnimation(playerid, "LOWRIDER", "F_smklean_loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 1:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_bdbnce", 4.0, 0, 0, 0, 1, 0, 1);
		    }
		    case 2:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_hair", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 3:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_hurry", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 4:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_idleloop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 5:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_idle_to_l0", 4.0, 0, 0, 0, 1, 0, 1);
		    }
		    case 6:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l0_bnce", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 7:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l0_loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 8:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l0_to_l1", 4.0, 0, 0, 0, 1, 0, 1);
		    }
		    case 9:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l12_to_l0", 4.0, 0, 0, 0, 1, 0, 1);
		    }
		    case 10:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l1_bnce", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 11:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l1_loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 12:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l1_to_l2", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 13:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l2_bnce", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 14:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l2_loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 15:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l2_to_l3", 4.0, 0, 0, 0, 1, 0, 1);
		    }
		    case 16:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l345_to_l1", 4.0, 0, 0, 0, 1, 0, 1);
		    }
		    case 17:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l3_bnce", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 18:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l3_loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 19:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l3_to_l4", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 20:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l4_bnce", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 21:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l4_loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 22:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l4_to_l5", 4.0, 0, 0, 0, 1, 0, 1);
		    }
		    case 23:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l5_bnce", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 24:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l5_loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 25:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 26:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkB", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 27:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkC", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 28:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkD", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 29:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkF", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 30:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkG", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 31:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkH", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 32:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "RAP_A_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 33:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "RAP_B_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 34:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "RAP_C_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 35:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "Sit_relaxed", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		    case 36:
		    {
		        ApplyAnimation(playerid, "LOWRIDER", "Tap_hand", 4.0, 1, 0, 0, 0, 0, 1);
		    }
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD2, " คุณต้องอยู่ในรถยนต์ประเภท Lowrider เพื่อใช้คำสั่งนี้!");
	}
	return 1;
}

//=====================================[ Roleplay ]============================================

CMD:do(playerid, params[])
{

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD2, "การใช้: /do [แสดง]");

	if (strlen(params) > 80) {
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %.80s", params);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "... %s (( %s ))", params[80], ReturnRealName(playerid));
	}
	else SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s (( %s ))", params, ReturnRealName(playerid));

	return 1;
}

CMD:dolow(playerid, params[])
{

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD2, "การใช้: /dolow [แสดง]");

	if (strlen(params) > 80) {
	    SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %.80s", params);
	    SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "... %s (( %s ))", params[80], ReturnRealName(playerid));
	}
	else SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s (( %s ))", params, ReturnRealName(playerid));

	return 1;
}

alias:local("l", "t");
CMD:local(playerid, params[])
{
    if(gIsDeathMode{playerid} || gIsInjuredMode{playerid})
        return SendClientMessage(playerid, COLOR_GRAD1, "   คุณสลบและไม่สามารถพูดได้");

	new str[128];

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD2, "การใช้: /(l)ocal [ข้อความ]");

	if (strlen(params) > 80) {

	    format(str, sizeof(str), "%s พูดว่า: %.80s", ReturnRealName(playerid), params);
	    ProxDetector(playerid, 20.0, str);

	    format(str, sizeof(str), "... %s", params[80]);
	    ProxDetector(playerid, 20.0, str);
	}
	else format(str, sizeof(str), "%s พูดว่า: %s", ReturnRealName(playerid), params), ProxDetector(playerid, 20.0, str);

    ChatAnimation(playerid, strlen(params));

	return 1;
}

CMD:low(playerid, params[])
{
    if(gIsDeathMode{playerid} || gIsInjuredMode{playerid})
        return SendClientMessage(playerid, COLOR_GRAD1, "   คุณสลบและไม่สามารถพูดได้");

	new str[128];

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD2, "การใช้: /low [ข้อความ]");

	if (strlen(params) > 80) {
	    format(str, sizeof(str), "%s พูดว่า [เบา]: %.80s", ReturnRealName(playerid), params);
	    ProxDetector(playerid, 5.0, str);

	    format(str, sizeof(str), "... %s", params[80]);
	    ProxDetector(playerid, 5.0, str);
	}
	else format(str, sizeof(str), "%s พูดว่า [เบา]: %s", ReturnRealName(playerid), params), ProxDetector(playerid, 5.0, str);

    ChatAnimation(playerid, strlen(params));

	return 1;
}

alias:shout("s");
CMD:shout(playerid, params[])
{
    if(gIsDeathMode{playerid} || gIsInjuredMode{playerid})
        return SendClientMessage(playerid, COLOR_GRAD1, "   คุณสลบและไม่สามารถพูดได้");

    new str[128];

	if (isnull(params))
	    return SendClientMessage(playerid, COLOR_GRAD2, "การใช้: /(s)hout [ข้อความ]");

	if (strlen(params) > 80) {
	    format(str, sizeof(str), "%s ตะโกน: %.80s", ReturnRealName(playerid), params);
	    ProxDetector(playerid, 30.0, str);

	    format(str, sizeof(str), "... %s!", params[80]);
	    ProxDetector(playerid, 30.0, str);
	}
	else format(str, sizeof(str), "%s ตะโกน: %s!", ReturnRealName(playerid), params),ProxDetector(playerid, 30.0, str);

	return 1;
}

CMD:me(playerid, params[])
{
    if(gIsInjuredMode{playerid} || gIsDeathMode{playerid})
		return SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่มี /me ในโหมดความตายและโหมดบาดเจ็บ");

	if (isnull(params)) 
		return SendClientMessage(playerid, COLOR_GRAD2, "การใช้: /me [กิริยา]");

	if (strlen(params) > 80) {
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s %.80s", ReturnRealName(playerid), params);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "... %s", params[80]);
	}
	else {
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s %s", ReturnRealName(playerid), params);
	}
	return 1;
}

CMD:ame(playerid, params[])
{
    if(gIsInjuredMode{playerid} || gIsDeathMode{playerid})
		return SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่มี /me ในโหมดความตายและโหมดบาดเจ็บ");

	if (isnull(params)) 
		return SendClientMessage(playerid, COLOR_GRAD2, "การใช้: /ame [กิริยา]");
			
	new string[128];
	format(string, sizeof(string), "* %s %s", ReturnRealName(playerid), params);
 	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 6000);
 	SendClientMessage(playerid, COLOR_PURPLE, string);
	
	return 1;
}

CMD:pm(playerid, params[])
{
	new userid, text[128];

    if (sscanf(params, "us[128]", userid, text))
	    return SendClientMessage(playerid, COLOR_GRAD2, "การใช้: /pm [ไอดีผู้เล่น/ชื่อบางส่วน] [ข้อความ]");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (userid == playerid)
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถส่งข้อความส่วนตัวให้กับตัวเองได้");

	if (BitFlag_Get(gPlayerBitFlag[userid], TOGGLE_PMS) && !playerData[playerid][pAdmin])
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นปิดกั้น PMs");

    if (strlen(text) > 80) {
	    SendClientMessageEx(userid, COLOR_PMF, "(( PM จาก %s (%d): %.80s", ReturnRealName(playerid), playerid, text);
	    SendClientMessageEx(userid, COLOR_PMF, "... %s ))", text[80]);

	    SendClientMessageEx(playerid, COLOR_PMS, "(( PM ส่งถึง %s (%d): %.80s", ReturnRealName(userid), userid, text);
	    SendClientMessageEx(playerid, COLOR_PMS, "... %s ))", text[80]);
	}
	else {
  		SendClientMessageEx(userid, COLOR_PMF, "(( PM จาก %s (%d): %s ))", ReturnRealName(playerid), playerid, text);
	    SendClientMessageEx(playerid, COLOR_PMS, "(( PM ส่งถึง %s (%d): %s ))", ReturnRealName(userid), userid, text);
	}
	return 1;
}

CMD:togpm(playerid,params[])
{
    if(playerData[playerid][pAdmin] || playerData[playerid][pDonateRank])
    {
        if(!BitFlag_Get(gPlayerBitFlag[playerid], TOGGLE_PMS))
        {
			BitFlag_On(gPlayerBitFlag[playerid], TOGGLE_PMS);
	        SendClientMessage(playerid,COLOR_GREEN,"ปิดกั้นระบบ PMs");
	        return 1;
		}
		else
		{
			BitFlag_Off(gPlayerBitFlag[playerid], TOGGLE_PMS);
		    SendClientMessage(playerid,COLOR_GREEN,"ยกเลิกการบล็อกระบบ PMs แล้ว");
		    return 1;
		}
    }
    else
    {
		SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้ (สำหรับผู้เล่นตั้งแต่ระดับรุกกี้ขึ้นไป)");
    }
	return 1;
}

CMD:eject(playerid, params[]) {
	new
		targetID;

	if(sscanf(params, "u", targetID))
		return SendClientMessage(playerid, COLOR_GRAD2, "การใช้: /eject [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(targetID == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if(targetID == playerid) 
		return SendClientMessage(playerid, COLOR_GRAD2, "คุณไม่สามารถไล่ตัวเองได้");
	    
	if(GetPlayerState(playerid) == 2) {
		if(GetPlayerVehicleID(playerid) == GetPlayerVehicleID(targetID)) {
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้ผลัก %s ออกจากพาหนะ", ReturnRealName(playerid), ReturnRealName(targetID));
			RemovePlayerFromVehicle(targetID);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "ผู้เล่นนี้ไม่ได้อยู่ภายในพาหนะ");
	}
	else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่ในสถานะผู้ขับรถ");

	return 1;
}

alias:changeorigin("co");
CMD:changeorigin(playerid, params[]) {
	if (IsPlayerInRangeOfPoint(playerid, 3, 358.7115,178.6364,1008.3828) && (GetPlayerVirtualWorld(playerid) == 2016 || GetPlayerVirtualWorld(playerid) == 2017)) {
		Dialog_Show(playerid, DialogChangeOrigin, DIALOG_STYLE_LIST, "ย้ายเมืองหลัก (ค่าบริการ $2,500)", "ย้ายไปยังเมือง Los Santos\nย้ายไปยังเมือง San Fierro", "ย้าย", "ยกเลิก");
	}
	else {
		SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่ศาลากลางจังหวัด");
	}
	return 1;
}

Dialog:DialogChangeOrigin(playerid, response, listitem, inputtext[]) {
	if (response) {

		if (GetPlayerMoney(playerid) < 2500) {
			return SendClientMessage(playerid, COLOR_GRAD1, "พนักงาน พูดว่า: ต้องใช้ $2,500 ในการดำเนินการเรื่องค่ะ");
		}

		if (listitem == 1) { // 1
			if (playerData[playerid][pSpawnPoint] == 1)
				return SendClientMessage(playerid, COLOR_GRAD1, "พนักงาน พูดว่า: คุณแน่ใจหรือคะ? คุณได้อาศัยอยู่เมืองนี้อยู่แล้วค่ะ");

			playerData[playerid][pSpawnPoint] = 1;
		}
		else { // 0
			if (playerData[playerid][pSpawnPoint] == 2)
				return SendClientMessage(playerid, COLOR_GRAD1, "พนักงาน พูดว่า: คุณแน่ใจหรือคะ? คุณได้อาศัยอยู่เมืองนี้อยู่แล้วค่ะ");

			playerData[playerid][pSpawnPoint] = 2;
		}
		GivePlayerMoneyEx(playerid, -2500);
		SendClientMessage(playerid, COLOR_GRAD1, "พนักงาน พูดว่า: ดำเนินการเรียบร้อยแล้วค่ะ!");
		SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้ย้ายไปยังเมือง %s เรียบร้อยแล้วและเสียค่าดำเนินการทั้งหมด $2,500", playerData[playerid][pSpawnPoint] == 2 ? ("Los Santos") : ("San Fierro"));
	}
	return 1;
}


CMD:changepass(playerid, params[])
{
	if (!BitFlag_Get(gPlayerBitFlag[playerid], IS_LOGGED))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "   คุณยังไม่ได้เข้าสู่ระบบ!");
		return 1;
	}

	new newpassword[64];
	if (sscanf(params, "s[64]", newpassword)) {
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /changepass [รหัสผ่านใหม่]");
	}
	else if (strlen(newpassword) > 12) {
		return SendClientMessage(playerid, COLOR_GRAD1, "รหัสผ่านต้องมีความยาวไม่เกินกว่า 12 ตัวอักษร");
	}

	SendClientMessageEx(playerid, COLOR_YELLOW, "รหัสผ่านใหม่ของคุณคือ %s อย่าลืมซะล่ะ", newpassword);

	new
		query[256],
		buffer[129];

	WP_Hash(buffer, sizeof(buffer), newpassword);

	mysql_format(dbCon, query, sizeof(query), "UPDATE `players` SET `Password` = '%e' WHERE `ID` = %d", buffer, playerData[playerid][pSID]);
	mysql_tquery(dbCon, query);

	Log(playerlog, INFO, "%s ได้เปลี่ยนรหัสผ่าน", ReturnPlayerName(playerid));

	return 1;
}

CMD:frisk(playerid, params[])
{
	new userid;

	if(sscanf(params,"u",userid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /frisk [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(userid == playerid) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถค้นตัวเองได้");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (!IsPlayerNearPlayer(playerid, userid, 3.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");


	if (!BitFlag_Get(gPlayerBitFlag[userid], FRISKAPPROVE))
	{
	    SendClientMessageEx(playerid, COLOR_YELLOW,"คุณได้ส่งคำขอการค้นตัว %s", ReturnRealName(userid));
	    SendClientMessage(playerid,COLOR_LIGHTRED,"SERVER: ผู้เล่นนี้ต้องอนุมัติการค้นหาของคุณ (/friskapprove)");
	    SendClientMessageEx(userid, COLOR_YELLOW,"%s ต้องการค้นหาคุณ (/friskapprove)", ReturnRealName(playerid));
	}
	else
	{
	    SendClientMessage(playerid, COLOR_LIGHTBLUE, "___________สิ่งของผิดกฎหมาย___________");
	    SendClientMessageEx(playerid, COLOR_WHITE, "ชื่อ: %s", ReturnRealName(userid));
	    SendClientMessageEx(playerid, COLOR_WHITE, "เงินเขียว: %s", playerData[userid][pCash] > 500 ? ("มีมากกว่า $500") : ("มีต่ำกว่า $500"));
	    SendClientMessageEx(playerid, COLOR_WHITE, "เงินแดง: %s", FormatNumber(playerData[userid][pRMoney]));
	 	SendClientMessageEx(playerid, COLOR_WHITE, "ดินปืน: %d", playerData[userid][pMaterials]);

		new Player_Weapons[13], Player_Ammos[13], str_weapons[500];
		for(new i = 1;i <= 12;i++)
		{
			GetPlayerWeaponData(userid,i,Player_Weapons[i],Player_Ammos[i]);

			if(Player_Weapons[i] != 0)
			{
			    if(i == 1) format(str_weapons, 500, "%s%s", str_weapons, ReturnWeaponNameEx(Player_Weapons[i]));
				else format(str_weapons, 500, "%s,%s", str_weapons, ReturnWeaponNameEx(Player_Weapons[i]));
			}
		}
	 	SendClientMessageEx(playerid, COLOR_WHITE, "อาวุธ: [%s]", strlen(str_weapons) ? str_weapons : "ไม่มี");
		
		SendClientMessageEx(playerid, COLOR_WHITE, "ยาเสพติด: %s", IsHaveDrug(userid) ? ("มี") : ("ไม่มี"));
		
        SendClientMessage(playerid, COLOR_LIGHTBLUE, "___________________________________");
		BitFlag_Off(gPlayerBitFlag[userid], FRISKAPPROVE);
	}
	return 1;
}


CMD:friskapprove(playerid, params[])
{
	new userid;

	if(sscanf(params,"u",userid)) 
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /friskapprove [ไอดีผู้เล่น/ชื่อบางส่วน]");

	if(userid == playerid) return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถค้นตัวเองได้");

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (!IsPlayerNearPlayer(playerid, userid, 3.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

  	BitFlag_On(gPlayerBitFlag[playerid], FRISKAPPROVE);

    SendClientMessageEx(userid,COLOR_LIGHTRED,"SERVER: ผู้เล่น %s ให้สิทธิ์ค้นตัวกับคุณ และใช้ /frisk ได้แล้วในขณะนี้", ReturnRealName(playerid));
    SendClientMessageEx(playerid,COLOR_YELLOW,"คุณอนุญาตให้ %s ค้นตัวคุณ", ReturnRealName(userid));
    return 1;
}

// Event Free Change Name 

CMD:openfreename(playerid, params[])
{
	if (playerData[playerid][pAdmin] < 5)
		return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ใช่ Development");

 	if(playerData[playerid][pAdmin] >= 5)
	{
		if(systemVariables[EventSystem] == 0)
		{
			systemVariables[EventSystem] = 1;
			SendClientMessage(playerid, COLOR_WHITE, "คุณได้ยกเลิกกิจกรรมเปลี่ยนชื่อฟรีสำหรับผู้เล่นที่ตั้งชื่อผิดรูปแบบ Firstname_Lastname");
			SendClientMessageToAll(COLOR_YELLOW, "Event เปลี่ยนชื่อฟรี (ถูกยกเลิก)");
		}
		else
		{
			systemVariables[EventSystem] = 0;
			SendClientMessage(playerid, COLOR_WHITE, "คุณได้เปิดกิจกรรมเปลี่ยนชื่อฟรีสำหรับผู้เล่นที่ตั้งชื่อผิดรูปแบบ Firstname_Lastname");
			SendClientMessageToAll(COLOR_YELLOW, "Event เปลี่ยนชื่อฟรี (ถูกเปิดใช้งานอีกครั้ง)");
		}
	}
	else
	{
		return SendClientMessage(playerid, COLOR_GREY, "คุณต้องอยู่ในระดับ Lead Administrator หรือมากกว่าเพื่อใช้ฟังชั่นนี้");
	}

	return 1;
}

CMD:freename(playerid, params[]) // Event Name Change
{
	if (playerData[playerid][pNameChangeFree] != 0)
		return SendClientMessage(playerid, COLOR_GRAD1, "คุณได้เข้าร่วมกิจกรรมเปลี่ยนชื่อฟรีเรียบร้อยแล้ว, กรุณาเติมเงินหากคุณต้องการเปลี่ยนชื่อ (/donate)");

	if(systemVariables[EventSystem] == 0)
	{
		Dialog_Show(playerid, DialogNameChangeF, DIALOG_STYLE_INPUT, "เลือกชื่อผู้ใช้ของคุณ:","รูปแบบ: "EMBED_ORANGE"Firstname_Lastname"EMBED_DIALOG" (ชื่อและนามสกุลตัวแรกใช้"EMBED_LIGHTRED"พิมพ์ใหญ่"EMBED_DIALOG"\nนอกนั้นใช้ตัวพิมพ์เล็ก และมีขีดเส้นทางระหว่างชื่อและนามสกุล)","เปลี่ยน","ออก");
	}
	else return SendClientMessage(playerid, COLOR_GRAD1, "ขณะนี้กิจกรรมปิดอยู่, หรือหมดเขตของกิจกรรมเปลี่ยนชื่อแล้ว !!");
	return 1;
}

Dialog:DialogNameChangeF(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return 0;

	if (IsValidRpName(inputtext)) {
	    new
	    	query[80];
	    mysql_format(dbCon, query, sizeof(query), "SELECT `id` FROM `players` WHERE `Name` = '%e' LIMIT 1", inputtext);
	    mysql_pquery(dbCon, query, "isExistUsername", "is", playerid, inputtext);

		playerData[playerid][pNameChangeFree] = 1;
	}
	else {
		Dialog_Show(playerid, DialogNameChangeF, DIALOG_STYLE_INPUT, "เลือกชื่อผู้ใช้ของคุณ:",""EMBED_DIALOG"ตรวจพบข้อผิดพลาด: "EMBED_LIGHTRED"ชื่อนี้ไม่สามารถใช้งานได้"EMBED_DIALOG"\n\nรูปแบบ: "EMBED_ORANGE"Firstname_Lastname"EMBED_DIALOG" (ชื่อและนามสกุลตัวแรกใช้"EMBED_LIGHTRED"พิมพ์ใหญ่"EMBED_DIALOG"\nนอกนั้นใช้ตัวพิมพ์เล็ก และมีขีดเส้นทางระหว่างชื่อและนามสกุล)","เปลี่ยน","ออก");
	}
	return 1;
}

// Bartender System ::
CMD:listdrink(playerid, params[])
{
	SendClientMessage(playerid, COLOR_LIGHTRED, "เครื่องดื่มของ Bartender");

	SendClientMessage(playerid, COLOR_WHITE, "Water - $10");
	SendClientMessage(playerid, COLOR_WHITE, "Hongthong - $300");
	SendClientMessage(playerid, COLOR_WHITE, "Sangasom - $800");
	SendClientMessage(playerid, COLOR_WHITE, "Redlabel - $1,200");
	SendClientMessage(playerid, COLOR_WHITE, "Blacklabel - $2,000");
	SendClientMessage(playerid, COLOR_WHITE, "JackDaniel - $3,500");

	return 1;
}

/*CMD:buydrink(playerid, params[])
{
	new type[24];

	if (!IsPlayerInRangeOfPoint(playerid, 3, -1851.7897, -137.2997, 11.9051))
		return SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่บาร์");

	if (sscanf(params,"s[24]D(0)S()[16]", type)) {
		SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: "EMBED_WHITE"/buydrink [เครื่องดื่มที่คุณต้องการ]");
        SendClientMessage(playerid, COLOR_WHITE, "คุณสามารถพิมพ์ /listdrink เพื่อดูเครื่องดื่มที่มีขาย,และราคาที่คุณต้องจ่าย");
		return 1;
	}

	if(!strcmp(type, "Water", true))
	{
        if (playerData[playerid][pCash] < 10)
            return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเงินมากกว่า $10");
 
        GivePlayerMoneyEx(playerid, -10);
		//ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ได้ซื้อเครื่องดื่ม Water จากพนักงานบาร์เทนเดอร์พร้อมกับจ่ายเงิน $10", ReturnRealName(playerid));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* พนักงานบาร์เทนเดอร์ : ได้นำเครื่องดื่ม Water ใส่แก้วแล้วยื่นให้กับ %s", ReturnRealName(playerid));

		itemVariables[iDrink] += 10;

		new szLabelText[128];
 		format(szLabelText, sizeof(szLabelText), "คลังเก็บเงินร้านเครื่องดื่ม\nจำนวนเงินคงเหลือ %d", itemVariables[iDrink]);
		UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);

		return 1;
	}

	if(!strcmp(type, "Hongthong", true))
	{
        if (playerData[playerid][pCash] < 300)
            return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเงินมากกว่า $300");
 
        GivePlayerMoneyEx(playerid, -300);
		ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ได้ซื้อเครื่องดื่ม Hongthong จากพนักงานบาร์เทนเดอร์พร้อมกับจ่ายเงิน $300", ReturnRealName(playerid));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* พนักงานบาร์เทนเดอร์ : ได้นำเครื่องดื่ม Hongthong ใส่แก้วแล้วยื่นให้กับ %s", ReturnRealName(playerid));

		itemVariables[iDrink] += 300;

		new szLabelText[128];
 		format(szLabelText, sizeof(szLabelText), "คลังเก็บเงินร้านเครื่องดื่ม\nจำนวนเงินคงเหลือ %d", itemVariables[iDrink]);
		UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);

		return 1;
	}

	if(!strcmp(type, "Sangasom", true))
	{
        if (playerData[playerid][pCash] < 800)
            return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเงินมากกว่า $800");
 
        GivePlayerMoneyEx(playerid, -800);
		ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ได้ซื้อเครื่องดื่ม Sangasom จากพนักงานบาร์เทนเดอร์พร้อมกับจ่ายเงิน $800", ReturnRealName(playerid));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* พนักงานบาร์เทนเดอร์ : ได้นำเครื่องดื่ม Sangasom ใส่แก้วแล้วยื่นให้กับ %s", ReturnRealName(playerid));

		itemVariables[iDrink] += 800;

		new szLabelText[128];
 		format(szLabelText, sizeof(szLabelText), "คลังเก็บเงินร้านเครื่องดื่ม\nจำนวนเงินคงเหลือ %d", itemVariables[iDrink]);
		UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);


		return 1;
	}

	if(!strcmp(type, "Redlabel", true))
	{
        if (playerData[playerid][pCash] < 1200)
            return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเงินมากกว่า $1200");
 
        GivePlayerMoneyEx(playerid, -1200);
		ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ได้ซื้อเครื่องดื่ม Red Label จากพนักงานบาร์เทนเดอร์พร้อมกับจ่ายเงิน $1200", ReturnRealName(playerid));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* พนักงานบาร์เทนเดอร์ : ได้นำเครื่องดื่ม Red Label ใส่แก้วแล้วยื่นให้กับ %s", ReturnRealName(playerid));

		itemVariables[iDrink] += 1200;

		new szLabelText[128];
 		format(szLabelText, sizeof(szLabelText), "คลังเก็บเงินร้านเครื่องดื่ม\nจำนวนเงินคงเหลือ %d", itemVariables[iDrink]);
		UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);


		return 1;
	}

	if(!strcmp(type, "Blacklabel", true))
	{
        if (playerData[playerid][pCash] < 2000)
            return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเงินมากกว่า $2000");
 
        GivePlayerMoneyEx(playerid, -2000);
		ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ได้ซื้อเครื่องดื่ม Black Label จากพนักงานบาร์เทนเดอร์พร้อมกับจ่ายเงิน $2000", ReturnRealName(playerid));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* พนักงานบาร์เทนเดอร์ : ได้นำเครื่องดื่ม Black Label ใส่แก้วแล้วยื่นให้กับ %s", ReturnRealName(playerid));

		itemVariables[iDrink] += 2000;

		new szLabelText[128];
 		format(szLabelText, sizeof(szLabelText), "คลังเก็บเงินร้านเครื่องดื่ม\nจำนวนเงินคงเหลือ %d", itemVariables[iDrink]);
		UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);


		return 1;
	}

	if(!strcmp(type, "JackDaniel", true))
	{
        if (playerData[playerid][pCash] < 3500)
            return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องมีเงินมากกว่า $3500");
 
        GivePlayerMoneyEx(playerid, -3500);
		ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1, 1, 1, 1, 1, 1, 1);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* %s ได้ซื้อเครื่องดื่ม Jack Daniel จากพนักงานบาร์เทนเดอร์พร้อมกับจ่ายเงิน $3500", ReturnRealName(playerid));
		SendNearbyMessage(playerid, 15.0, COLOR_PURPLE, "* พนักงานบาร์เทนเดอร์ : ได้นำเครื่องดื่ม Jack Daniel ใส่แก้วแล้วยื่นให้กับ %s", ReturnRealName(playerid));

		itemVariables[iDrink] += 3500;

		new szLabelText[128];
 		format(szLabelText, sizeof(szLabelText), "คลังเก็บเงินร้านเครื่องดื่ม\nจำนวนเงินคงเหลือ %d", itemVariables[iDrink]);
		UpdateDynamic3DTextLabelText(itemVariables[iDrinkText], COLOR_YELLOW, szLabelText);

		return 1;
	}
	return 1;
}*/

CMD:detain(playerid, params[]) {
	new
		seat,
		targetID;

	if(sscanf(params, "ud", targetID, seat))
		return SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /detain [playerid] [ที่นั่ง (1-3)]");

	if(playerData[targetID][pFreezeType] == 4) {
		if(seat > 0 && seat < 4) {
			if(IsPlayerInRangeOfPlayer(playerid, targetID, 5.0) && IsPlayerInRangeOfVehicle(playerid, GetClosestVehicle(playerid), 5.0)) {

				new
					detaintarget = GetClosestVehicle(playerid);

				if(checkVehicleSeat(detaintarget, seat) != 0) SendClientMessage(playerid, COLOR_GREY, "หมายเลข ID ที่นั่งไม่ว่าง");

				else {

					SendNearbyMessage(playerid, 25.0, COLOR_PURPLE, "* %s ถูกเรียกขึ้นรถมาโดย %s", ReturnRealName(targetID), ReturnRealName(playerid));
					PutPlayerInVehicle(targetID, detaintarget, seat);
				}
			}
			else SendClientMessage(playerid, COLOR_GRAD1, "คุณและรถต้องอยู่ใกล้กับคนที่คุณจะควบคุมตัวขึ้นรถ");
	    }
	}
	return 1;
}

hook OP_ClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    // --> ระบบแต่งรถ

    if( _:playertextid != INVALID_TEXT_DRAW ) {
        if( playertextid == TuningBuy[ playerid ][ 10 ] ) { // desno
            if( !IsPlayerInAnyVehicle( playerid ) ) return SendClientMessage(playerid, -1, "คุณต้องอยู่บนรถ" );
	        if( GetPlayerState( playerid ) != PLAYER_STATE_DRIVER ) return SendClientMessage(playerid, -1, "คุณต้องเป็นคนขับรถ" );

            if( TPInfo[ playerid ][ tPaintjob ] == false ) {

				new compid = -1, vehicleid = GetPlayerVehicleID( playerid );

	            for( new i = ( TPInfo[ playerid ][ tID ]+1 ); i < MAX_COMPONENTS; i++ ) {
					if( cInfo[ i ][ cType ] == TPInfo[ playerid ][ tType ] ) {
						if( cInfo[ i ][ cID ] == IsComponentidCompatibleNew( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
							compid = i;
							break;
						}
					}
				}
				if( compid == -1 ) return SendClientMessage(playerid, COLOR_LIGHTRED, "[ ยานพาหนะของคุณไม่สามารถติดตั้งอุปกรณ์แต่งอื่นได้แล้ว ]" );

	            RemoveVehicleComponent( vehicleid, cInfo[ TPInfo[ playerid ][ tID ] ][ cID ] );

	            TPInfo[ playerid ][ tID ] = compid;

	            format( globalstring, sizeof( globalstring ), "%s", cInfo[ compid ][ cName ] );
				PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 3 ], globalstring );
				format( globalstring, sizeof( globalstring ), "Price: ~w~%d$", cInfo[ compid ][ cPrice ] );
				PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 4 ], globalstring );

				AddVehicleComponent( vehicleid, cInfo[ compid ][ cID ] );

				SelectTextDraw( playerid, 0xFFA84DFF );
			}
			else if( TPInfo[ playerid ][ tPaintjob ] == true ) {

			    new paintid = -1, vehicleid = GetPlayerVehicleID( playerid );

			    for( new i = ( TPInfo[ playerid ][ tID ]+1 ); i < NUMBER_TYPE_PAINTJOB; i++ ) {
			    	if( pjInfo[ i ][ vehID ] == GetVehicleModel( vehicleid ) ) {
						paintid = i;
						break;
					}
			   	}
			   	if( paintid == -1 ) return SendClientMessage(playerid, -1, "[ ยานพาหนะของคุณไม่สามารถติดตั้งอุปกรณ์แต่งอื่นได้แล้ว ]" );

                TPInfo[ playerid ][ tID ] = paintid;

                format( globalstring, sizeof( globalstring ), "%s", pjInfo[ paintid ][ pName ] );
				PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 3 ], globalstring );
				format( globalstring, sizeof( globalstring ), "Price: ~w~%d$", pjInfo[ paintid ][ pPrice ] );
				PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 4 ], globalstring );

                ChangeVehiclePaintjob( vehicleid, pjInfo[ paintid ][ pNumber ] );

                SelectTextDraw( playerid, 0xFFA84DFF );
			}
        }
        if( playertextid == TuningBuy[ playerid ][ 11 ] )
		{ // levo
			if( TPInfo[ playerid ][ tPaintjob ] == false )
			{
	            if( !IsPlayerInAnyVehicle( playerid ) ) return SendClientMessage(playerid, -1, "คุณต้องอยู่บนรถ" );
		        if( GetPlayerState( playerid ) != PLAYER_STATE_DRIVER ) return SendClientMessage(playerid, -1, "คุณต้องเป็นคนขับรถ" );

				new compid = -1, vehicleid = GetPlayerVehicleID( playerid );

	            for( new i = (TPInfo[ playerid ][ tID ]-1); i > 0; i-- ) {
					if( cInfo[ i ][ cType ] == TPInfo[ playerid ][ tType ] ) {
						if( cInfo[ i ][ cID ] == IsComponentidCompatibleNew( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
							compid = i;
							break;
						}
					}
				}
				if( compid == -1 ) return SendClientMessage(playerid, -1, "[ ยานพาหนะของคุณไม่สามารถติดตั้งอุปกรณ์แต่งอื่นได้แล้ว ]" );

				RemoveVehicleComponent( vehicleid, cInfo[ TPInfo[ playerid ][ tID ] ][ cID ] );

	            TPInfo[ playerid ][ tID ] = compid;

	            format( globalstring, sizeof( globalstring ), "%s", cInfo[ compid ][ cName ] );
				PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 3 ], globalstring );
				format( globalstring, sizeof( globalstring ), "Price: ~w~%d$", cInfo[ compid ][ cPrice ] );
				PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 4 ], globalstring );

				AddVehicleComponent( vehicleid, cInfo[ compid ][ cID ] );

				SelectTextDraw( playerid, 0xFFA84DFF );
			}
			else if( TPInfo[ playerid ][ tPaintjob ] == true ) {

			    new paintid = -1, vehicleid = GetPlayerVehicleID( playerid );

			    for( new i = (TPInfo[ playerid ][ tID ]-1); i > 0; i-- ) {
			    	if( pjInfo[ i ][ vehID ] == GetVehicleModel( vehicleid ) ) {
						paintid = i;
						break;
					}
			   	}
			   	if( paintid == -1 ) return SendClientMessage(playerid, -1, "[ ยานพาหนะของคุณไม่สามารถติดตั้งอุปกรณ์แต่งอื่นได้แล้ว ]" );

                TPInfo[ playerid ][ tID ] = paintid;

                format( globalstring, sizeof( globalstring ), "%s", pjInfo[ paintid ][ pName ] );
				PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 3 ], globalstring );
				format( globalstring, sizeof( globalstring ), "Price: ~w~%d$", pjInfo[ paintid ][ pPrice ] );
				PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 4 ], globalstring );

                ChangeVehiclePaintjob( vehicleid, pjInfo[ paintid ][ pNumber ] );

                SelectTextDraw( playerid, 0xFFA84DFF );
			}
        }
        if( playertextid == TuningBuy[ playerid ][ 7 ] ) { // buy
            if( !IsPlayerInAnyVehicle( playerid ) ) return SendClientMessage(playerid, -1, "คุณต้องอยู่บนรถ" );
	        if( GetPlayerState( playerid ) != PLAYER_STATE_DRIVER ) return SendClientMessage(playerid, -1, "คุณต้องเป็นคนขับรถ" );

            new Float:Pos[ 6 ], vehicleid = GetPlayerVehicleID( playerid );

            if( TPInfo[ playerid ][ tPaintjob ] == false ) {

				if( GetPlayerMoneyEx( playerid ) < cInfo[ TPInfo[ playerid ][ tID ] ][ cPrice ] ) return SendClientMessage(playerid, -1, "คุณมีเงินไม่เพียงพอ" );

				new cid = TPInfo[ playerid ][ tID ];

		        RemoveVehicleComponent( vehicleid, cInfo[ TPInfo[ playerid ][ tID ] ][ cID ] );

		        VehicleInfo[ vehicleid ][ vTuned ] = true;

		        AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

		        GivePlayerMoneyEx( playerid, -cInfo[ TPInfo[ playerid ][ tID ] ][ cPrice ] );

			}
			else if( TPInfo[ playerid ][ tPaintjob ] == true ) {

			    if( GetPlayerMoneyEx( playerid ) < pjInfo[ TPInfo[ playerid ][ tID ] ][ pPrice ] ) return SendClientMessage(playerid, -1, "คุณมีเงินไม่เพียงพอ" );

			    new paintid = TPInfo[ playerid ][ tID ];

			    VehicleInfo[ vehicleid ][ vTuned ] = true;

			    VehicleInfo[ vehicleid ][ vPaintJob ] = pjInfo[ paintid ][ pNumber ];

			    GivePlayerMoneyEx( playerid, -pjInfo[ TPInfo[ playerid ][ tID ] ][ pPrice ] );

			    SetVehicleColor( vehicleid, TPInfo[ playerid ][ PJColor ][ 0 ], TPInfo[ playerid ][ PJColor ][ 1 ] );

			    ChangeVehiclePaintjob( vehicleid, pjInfo[ paintid ][ pNumber ] );

			}
			GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 0, 6, 2 );
			SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

			GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
			SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

			CancelSelectTextDraw( playerid );

		    TuningTDControl( playerid, false );
		    TogglePlayerControllable( playerid, true );

			SPD( playerid, dialog_TUNING, DSL, D_TOP, D_TEXT, D_OK, D_CANCEL );
        }
        if( playertextid == TuningBuy[ playerid ][ 2 ] ) { // close

            if( !IsPlayerInAnyVehicle( playerid ) ) return SendClientMessage(playerid, -1, "คุณต้องอยู่บนรถ" );
	        if( GetPlayerState( playerid ) != PLAYER_STATE_DRIVER ) return SendClientMessage(playerid, -1, "คุณต้องเป็นคนขับรถ" );

            new Float:Pos[ 6 ], vehicleid = GetPlayerVehicleID( playerid );

			if( TPInfo[ playerid ][ tPaintjob ] == false ) {

		        RemoveVehicleComponent( vehicleid, cInfo[ TPInfo[ playerid ][ tID ] ][ cID ] );

				SetTune( vehicleid );
			}
			else if( TPInfo[ playerid ][ tPaintjob ] == true ) {
			    ChangeVehiclePaintjob( vehicleid, 3 );
				SetVehicleColor( vehicleid, TPInfo[ playerid ][ PJColor ][ 0 ], TPInfo[ playerid ][ PJColor ][ 1 ] );
			}
			GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 0, 6, 2 );
			SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

			GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
			SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

	        CancelSelectTextDraw( playerid );

			TuningTDControl( playerid, false );
		    TogglePlayerControllable( playerid, true );

			SPD( playerid, dialog_TUNING, DSL, D_TOP, D_TEXT, D_OK, D_CANCEL );
        }
    }
	return 1;
}

CMD:tune(playerid, params[])
{
	if (!IsPlayerInAnyVehicle(playerid))
 		return SendClientMessage(playerid, COLOR_RED, "[ระบบ] {FFFFFF}คุณต้องอยู่ในรถส่วนตัว");

    SPD( playerid, dialog_TUNING, DSL, D_TOP, D_TEXT, D_OK, D_CANCEL );
    return 1;
}

hook OnPlayerConnect(playerid)
{
    CreatePlayerTextDraws(playerid);
    return 1;
}

//=================================[ Functions ]=================================
stock CreatePlayerTextDraws( playerid ) {

	TuningBuy[playerid][0] = CreatePlayerTextDraw(playerid, 315.000000, 359.000000, "_");
	PlayerTextDrawFont(playerid, TuningBuy[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, TuningBuy[playerid][0], 0.600000, 5.300003);
	PlayerTextDrawTextSize(playerid, TuningBuy[playerid][0], 298.500000, 145.000000);
	PlayerTextDrawSetOutline(playerid, TuningBuy[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, TuningBuy[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, TuningBuy[playerid][0], 2);
	PlayerTextDrawColor(playerid, TuningBuy[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningBuy[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, TuningBuy[playerid][0], 135);
	PlayerTextDrawUseBox(playerid, TuningBuy[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, TuningBuy[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, TuningBuy[playerid][0], 0);

	TuningBuy[playerid][1] = CreatePlayerTextDraw(playerid, 241.000000, 350.000000, "Car Tuning");
	PlayerTextDrawFont(playerid, TuningBuy[playerid][1], 3);
	PlayerTextDrawLetterSize(playerid, TuningBuy[playerid][1], 0.350000, 1.500000);
	PlayerTextDrawTextSize(playerid, TuningBuy[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, TuningBuy[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, TuningBuy[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, TuningBuy[playerid][1], 1);
	PlayerTextDrawColor(playerid, TuningBuy[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningBuy[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, TuningBuy[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, TuningBuy[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, TuningBuy[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, TuningBuy[playerid][1], 0);

	TuningBuy[playerid][2] = CreatePlayerTextDraw(playerid, 385.000000, 353.000000, "X");
	PlayerTextDrawFont(playerid, TuningBuy[playerid][2], 3);
	PlayerTextDrawLetterSize(playerid, TuningBuy[playerid][2], 0.350000, 1.000000);
	PlayerTextDrawTextSize(playerid, TuningBuy[playerid][2], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, TuningBuy[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, TuningBuy[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, TuningBuy[playerid][2], 1);
	PlayerTextDrawColor(playerid, TuningBuy[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningBuy[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, TuningBuy[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, TuningBuy[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, TuningBuy[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, TuningBuy[playerid][2], 1);

	TuningBuy[playerid][3] = CreatePlayerTextDraw(playerid, 253.000000, 370.000000, "Rear Bumper");
	PlayerTextDrawFont(playerid, TuningBuy[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, TuningBuy[playerid][3], 0.333333, 1.350000);
	PlayerTextDrawTextSize(playerid, TuningBuy[playerid][3], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, TuningBuy[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, TuningBuy[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, TuningBuy[playerid][3], 1);
	PlayerTextDrawColor(playerid, TuningBuy[playerid][3], 9109759);
	PlayerTextDrawBackgroundColor(playerid, TuningBuy[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, TuningBuy[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, TuningBuy[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, TuningBuy[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, TuningBuy[playerid][3], 0);

	TuningBuy[playerid][4] = CreatePlayerTextDraw(playerid, 254.000000, 382.000000, "Price: ~g~$500");
	PlayerTextDrawFont(playerid, TuningBuy[playerid][4], 2);
	PlayerTextDrawLetterSize(playerid, TuningBuy[playerid][4], 0.191666, 1.050000);
	PlayerTextDrawTextSize(playerid, TuningBuy[playerid][4], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, TuningBuy[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, TuningBuy[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, TuningBuy[playerid][4], 1);
	PlayerTextDrawColor(playerid, TuningBuy[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningBuy[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, TuningBuy[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, TuningBuy[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, TuningBuy[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, TuningBuy[playerid][4], 0);

	TuningBuy[playerid][5] = CreatePlayerTextDraw(playerid, 254.000000, 392.000000, "Click 'buy' to add components");
	PlayerTextDrawFont(playerid, TuningBuy[playerid][5], 2);
	PlayerTextDrawLetterSize(playerid, TuningBuy[playerid][5], 0.150000, 0.850000);
	PlayerTextDrawTextSize(playerid, TuningBuy[playerid][5], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, TuningBuy[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, TuningBuy[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, TuningBuy[playerid][5], 1);
	PlayerTextDrawColor(playerid, TuningBuy[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningBuy[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, TuningBuy[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, TuningBuy[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, TuningBuy[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, TuningBuy[playerid][5], 0);

	TuningBuy[playerid][6] = CreatePlayerTextDraw(playerid, 419.000000, 359.000000, "_");
	PlayerTextDrawFont(playerid, TuningBuy[playerid][6], 1);
	PlayerTextDrawLetterSize(playerid, TuningBuy[playerid][6], 0.600000, 1.300003);
	PlayerTextDrawTextSize(playerid, TuningBuy[playerid][6], 298.500000, 35.000000);
	PlayerTextDrawSetOutline(playerid, TuningBuy[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, TuningBuy[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, TuningBuy[playerid][6], 2);
	PlayerTextDrawColor(playerid, TuningBuy[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningBuy[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, TuningBuy[playerid][6], 9109639);
	PlayerTextDrawUseBox(playerid, TuningBuy[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, TuningBuy[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, TuningBuy[playerid][6], 0);

	TuningBuy[playerid][7] = CreatePlayerTextDraw(playerid, 409.000000, 358.000000, "BUY");
	PlayerTextDrawFont(playerid, TuningBuy[playerid][7], 2);
	PlayerTextDrawLetterSize(playerid, TuningBuy[playerid][7], 0.241666, 1.250000);
	PlayerTextDrawTextSize(playerid, TuningBuy[playerid][7], 450.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, TuningBuy[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, TuningBuy[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, TuningBuy[playerid][7], 1);
	PlayerTextDrawColor(playerid, TuningBuy[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningBuy[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, TuningBuy[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, TuningBuy[playerid][7], 0);
	PlayerTextDrawSetProportional(playerid, TuningBuy[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, TuningBuy[playerid][7], 1);

	TuningBuy[playerid][8] = CreatePlayerTextDraw(playerid, 419.000000, 379.000000, "_");
	PlayerTextDrawFont(playerid, TuningBuy[playerid][8], 1);
	PlayerTextDrawLetterSize(playerid, TuningBuy[playerid][8], 0.600000, 0.800003);
	PlayerTextDrawTextSize(playerid, TuningBuy[playerid][8], 298.500000, 35.000000);
	PlayerTextDrawSetOutline(playerid, TuningBuy[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, TuningBuy[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, TuningBuy[playerid][8], 2);
	PlayerTextDrawColor(playerid, TuningBuy[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningBuy[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, TuningBuy[playerid][8], -121);
	PlayerTextDrawUseBox(playerid, TuningBuy[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, TuningBuy[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, TuningBuy[playerid][8], 0);

	TuningBuy[playerid][9] = CreatePlayerTextDraw(playerid, 419.000000, 394.000000, "_");
	PlayerTextDrawFont(playerid, TuningBuy[playerid][9], 1);
	PlayerTextDrawLetterSize(playerid, TuningBuy[playerid][9], 0.600000, 0.800003);
	PlayerTextDrawTextSize(playerid, TuningBuy[playerid][9], 298.500000, 35.000000);
	PlayerTextDrawSetOutline(playerid, TuningBuy[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, TuningBuy[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, TuningBuy[playerid][9], 2);
	PlayerTextDrawColor(playerid, TuningBuy[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningBuy[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, TuningBuy[playerid][9], -121);
	PlayerTextDrawUseBox(playerid, TuningBuy[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, TuningBuy[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, TuningBuy[playerid][9], 0);

	TuningBuy[playerid][10] = CreatePlayerTextDraw(playerid, 415.000000, 377.000000, ">");
	PlayerTextDrawFont(playerid, TuningBuy[playerid][10], 3);
	PlayerTextDrawLetterSize(playerid, TuningBuy[playerid][10], 0.287500, 1.100000);
	PlayerTextDrawTextSize(playerid, TuningBuy[playerid][10], 430.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, TuningBuy[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, TuningBuy[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, TuningBuy[playerid][10], 1);
	PlayerTextDrawColor(playerid, TuningBuy[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningBuy[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, TuningBuy[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, TuningBuy[playerid][10], 0);
	PlayerTextDrawSetProportional(playerid, TuningBuy[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, TuningBuy[playerid][10], 1);

	TuningBuy[playerid][11] = CreatePlayerTextDraw(playerid, 415.000000, 392.000000, "<");
	PlayerTextDrawFont(playerid, TuningBuy[playerid][11], 3);
	PlayerTextDrawLetterSize(playerid, TuningBuy[playerid][11], 0.287500, 1.100000);
	PlayerTextDrawTextSize(playerid, TuningBuy[playerid][11], 430.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, TuningBuy[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, TuningBuy[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, TuningBuy[playerid][11], 1);
	PlayerTextDrawColor(playerid, TuningBuy[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, TuningBuy[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, TuningBuy[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, TuningBuy[playerid][11], 0);
	PlayerTextDrawSetProportional(playerid, TuningBuy[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, TuningBuy[playerid][11], 1);
}

//==============================================================================
stock SetTune( vehicleid ) {
    if( VehicleInfo[ vehicleid ][ vTuned ] ) {
	    if( VehicleInfo[ vehicleid ][ vPaintJob ] != 255 ) ChangeVehiclePaintjob( vehicleid, VehicleInfo[ vehicleid ][ vPaintJob ] );
		if( VehicleInfo[ vehicleid ][ vSpoiler ] != -1 ) AddVehicleComponent( vehicleid, VehicleInfo[ vehicleid ][ vSpoiler ] );
		if( VehicleInfo[ vehicleid ][ vHood ] != -1 ) AddVehicleComponent( vehicleid, VehicleInfo[ vehicleid ][ vHood ] );
		if( VehicleInfo[ vehicleid ][ vRoof ] != -1 ) AddVehicleComponent( vehicleid, VehicleInfo[ vehicleid ][ vRoof ] );
		if( VehicleInfo[ vehicleid ][ vSkirt ] != -1 ) AddVehicleComponent( vehicleid, VehicleInfo[ vehicleid ][ vSkirt ] );
		if( VehicleInfo[ vehicleid ][ vLamps ] != -1 ) AddVehicleComponent( vehicleid, VehicleInfo[ vehicleid ][ vLamps ] );
		if( VehicleInfo[ vehicleid ][ vNitro ] != -1 ) AddVehicleComponent( vehicleid, VehicleInfo[ vehicleid ][ vNitro ] );
		if( VehicleInfo[ vehicleid ][ vExhaust ] != -1 ) AddVehicleComponent( vehicleid, VehicleInfo[ vehicleid ][ vWheels ] );
		if( VehicleInfo[ vehicleid ][ vWheels ] != -1 ) AddVehicleComponent( vehicleid, VehicleInfo[ vehicleid ][ vWheels ] );
		if( VehicleInfo[ vehicleid ][ vStereo ] != -1 ) AddVehicleComponent( vehicleid, VehicleInfo[ vehicleid ][ vStereo ] );
		if( VehicleInfo[ vehicleid ][ vHydraulics ] != -1 ) AddVehicleComponent( vehicleid, VehicleInfo[ vehicleid ][ vHydraulics ] );
		if( VehicleInfo[ vehicleid ][ vFrontBumper ] != -1 ) AddVehicleComponent( vehicleid, VehicleInfo[ vehicleid ][ vFrontBumper ] );
		if( VehicleInfo[ vehicleid ][ vRearBumper ] != -1 ) AddVehicleComponent( vehicleid, VehicleInfo[ vehicleid ][ vRearBumper ] );
		if( VehicleInfo[ vehicleid ][ vRightVent ] != -1 ) AddVehicleComponent( vehicleid, VehicleInfo[ vehicleid ][ vRightVent ] );
		if( VehicleInfo[ vehicleid ][ vLeftVent ] != -1 ) AddVehicleComponent( vehicleid, VehicleInfo[ vehicleid ][ vLeftVent ] );
    }
}
//==============================================================================
stock AddComponentToVehicle( vehicleid, componentid ) {
	if( VehicleInfo[ vehicleid ][ vTuned ] ) {
		if( GetVehicleComponentType( componentid ) == CARMODTYPE_SPOILER ) {
		    VehicleInfo[ vehicleid ][ vSpoiler ] = componentid;
			if( VehicleInfo[ vehicleid ][ vSpoiler ] != -1 ) AddVehicleComponent( vehicleid, componentid );
		}
	    else if( GetVehicleComponentType( componentid ) == CARMODTYPE_HOOD ) {
		    VehicleInfo[ vehicleid ][ vHood ] = componentid;
			if( VehicleInfo[ vehicleid ][ vHood ] != -1 ) AddVehicleComponent( vehicleid, componentid );
		}
	    else if( GetVehicleComponentType( componentid ) == CARMODTYPE_ROOF ) {
		    VehicleInfo[ vehicleid ][ vRoof ] = componentid;
			if( VehicleInfo[ vehicleid ][ vRoof ] != -1 ) AddVehicleComponent( vehicleid, componentid );
		}
	    else if( GetVehicleComponentType( componentid ) == CARMODTYPE_SIDESKIRT ) {
		    VehicleInfo[ vehicleid ][ vSkirt ] = componentid;
			if( VehicleInfo[ vehicleid ][ vSkirt ] != -1 ) AddVehicleComponent( vehicleid, componentid );
		}
	    else if( GetVehicleComponentType( componentid ) == CARMODTYPE_LAMPS ) {
		    VehicleInfo[ vehicleid ][ vLamps ] = componentid;
			if( VehicleInfo[ vehicleid ][ vLamps ] != -1 ) AddVehicleComponent( vehicleid, componentid );
		}
	    else if( GetVehicleComponentType( componentid ) == CARMODTYPE_NITRO ) {
		    VehicleInfo[ vehicleid ][ vNitro ] = componentid;
			if( VehicleInfo[ vehicleid ][ vNitro ] != -1 ) AddVehicleComponent( vehicleid, componentid );
		}
	    else if( GetVehicleComponentType( componentid ) == CARMODTYPE_EXHAUST ) {
		    VehicleInfo[ vehicleid ][ vExhaust ] = componentid;
			if( VehicleInfo[ vehicleid ][ vExhaust ] != -1 ) AddVehicleComponent( vehicleid, componentid );
		}
	    else if( GetVehicleComponentType( componentid ) == CARMODTYPE_WHEELS ) {
		    VehicleInfo[ vehicleid ][ vWheels ] = componentid;
			if( VehicleInfo[ vehicleid ][ vWheels ] != -1 ) AddVehicleComponent( vehicleid, componentid );
		}
	    else if( GetVehicleComponentType( componentid ) == CARMODTYPE_STEREO ) {
		    VehicleInfo[ vehicleid ][ vStereo ] = componentid;
			if( VehicleInfo[ vehicleid ][ vStereo ] != -1 ) AddVehicleComponent( vehicleid, componentid );
		}
	    else if( GetVehicleComponentType( componentid ) == CARMODTYPE_HYDRAULICS ) {
		    VehicleInfo[ vehicleid ][ vHydraulics ] = componentid;
			if( VehicleInfo[ vehicleid ][ vHydraulics ] != -1 ) AddVehicleComponent( vehicleid, componentid );
		}
	    else if( GetVehicleComponentType( componentid ) == CARMODTYPE_FRONT_BUMPER ) {
		    VehicleInfo[ vehicleid ][ vFrontBumper ] = componentid;
			if( VehicleInfo[ vehicleid ][ vFrontBumper ] != -1 ) AddVehicleComponent( vehicleid, componentid );
		}
	    else if( GetVehicleComponentType( componentid ) == CARMODTYPE_REAR_BUMPER ) {
		    VehicleInfo[ vehicleid ][ vRearBumper ] = componentid;
			if( VehicleInfo[ vehicleid ][ vRearBumper ] != -1 ) AddVehicleComponent( vehicleid, componentid );
		}
	    else if( GetVehicleComponentType( componentid ) == CARMODTYPE_VENT_RIGHT ) {
		    VehicleInfo[ vehicleid ][ vRightVent ] = componentid;
			if( VehicleInfo[ vehicleid ][ vRightVent ] != -1 ) AddVehicleComponent( vehicleid, componentid );
		}
	    else if( GetVehicleComponentType( componentid ) == CARMODTYPE_VENT_LEFT ) {
		    VehicleInfo[ vehicleid ][ vLeftVent ] = componentid;
			if( VehicleInfo[ vehicleid ][ vLeftVent ] != -1 ) AddVehicleComponent( vehicleid, componentid );
		}
	}
}
//==============================================================================
stock GetVehicleCameraPos( vehicleid, &Float:x, &Float:y, &Float:z, Float:xoff=0.0, Float:yoff=0.0, Float:zoff=0.0 ) { // credits Pasha
    new Float:rot;
    GetVehicleZAngle( vehicleid, rot );
    rot = 360 - rot;
    GetVehiclePos( vehicleid, x, y, z );
    x = floatsin( rot, degrees ) * yoff + floatcos( rot, degrees ) * xoff + x;
    y = floatcos( rot, degrees ) * yoff - floatsin( rot, degrees ) * xoff + y;
    z = zoff + z;
}
//==============================================================================
stock TuningTDControl( playerid, bool:show ) {
	if( show == true ) {
        for( new i = 0; i < 12; i ++ ) {
			PlayerTextDrawShow( playerid, TuningBuy[ playerid ][ i ] );
		}

	}
	else if( show == false ) {
		for( new i = 0; i < 12; i ++ ) {
			PlayerTextDrawHide( playerid, TuningBuy[ playerid ][ i ]);
		}
	}
}
//==============================================================================
stock ResetTuning( vehid ) {
	if( VehicleInfo[ vehid ][ vTuned ] ) {
	    VehicleInfo[ vehid ][ vTuned ] = false;
		VehicleInfo[ vehid ][ vSpoiler ] = -1;
		VehicleInfo[ vehid ][ vHood ] = -1;
		VehicleInfo[ vehid ][ vRoof ] = -1;
		VehicleInfo[ vehid ][ vSkirt ] = -1;
		VehicleInfo[ vehid ][ vLamps ] = -1;
		VehicleInfo[ vehid ][ vNitro ] = -1;
		VehicleInfo[ vehid ][ vExhaust ] = -1;
		VehicleInfo[ vehid ][ vWheels ] = -1;
		VehicleInfo[ vehid ][ vStereo ] = -1;
		VehicleInfo[ vehid ][ vHydraulics ] = -1;
		VehicleInfo[ vehid ][ vFrontBumper ] = -1;
		VehicleInfo[ vehid ][ vRearBumper ] = -1;
		VehicleInfo[ vehid ][ vRightVent ] = -1;
		VehicleInfo[ vehid ][ vLeftVent ] = -1;
		VehicleInfo[ vehid ][ vPaintJob ] = 255;
	}
}
//==============================================================================
hook OnDialogResponse( playerid, dialogid, response, listitem, inputtext[] ) {
	switch( dialogid ) {
	    case dialog_TUNING: {
	        if( response ) {
	            if( !IsPlayerInAnyVehicle( playerid ) ) return SendClientMessage(playerid, -1, "คุณต้องอยู่บนรถ" );
	            if( GetPlayerState( playerid ) != PLAYER_STATE_DRIVER ) return SendClientMessage(playerid, -1, "คุณต้องเป็นคนขับรถ" );
				new vehicleid = GetPlayerVehicleID( playerid ), Float:Pos[ 6 ];

	            TPInfo[ playerid ][ tID ] = -1;

				switch( listitem ) {
	                case 0: {

						for( new i = 0; i < NUMBER_TYPE_PAINTJOB; i++ ) {
			                if( pjInfo[ i ][ vehID ] == GetVehicleModel( vehicleid ) ) {
				            	TPInfo[ playerid ][ tID ] = i;
								break;
							}
			           	}
						if( TPInfo[ playerid ][ tID ] == -1 ) return SendClientMessage(playerid, -1, "[ รถของคุณไม่สามารถติดตั้งอุปกรณ์แต่งอื่นได้แล้ว ]" );

						new pid = TPInfo[ playerid ][ tID ];
						TPInfo[ playerid ][ tPaintjob ] = true;

						GetVehicleColor( vehicleid, TPInfo[ playerid ][ PJColor ][ 0 ], TPInfo[ playerid ][ PJColor ][ 1 ] );

						TogglePlayerControllable( playerid, false );
	                    TuningTDControl( playerid, true );

                        ChangeVehicleColor( vehicleid, 1, 1 );
                        ChangeVehiclePaintjob( vehicleid, pjInfo[ pid ][ pNumber ] );

	                    format( globalstring, sizeof( globalstring ), "%s", pjInfo[ pid ][ pName ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 3 ], globalstring );
						format( globalstring, sizeof( globalstring ), "Price: ~w~%d$", pjInfo[ pid ][ pPrice ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 4 ], globalstring );

						GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 4, 0, 5 );
						SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

						GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
						SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

						SelectTextDraw( playerid, 0xFFA84DFF );
					}
	                case 1: {
						SPD( playerid, dialog_TUNING_2, DSI, D_TOP, "ใส่สีรถที่คุณต้องการ\nเช่น :0 1", D_OK, D_CANCEL );
	                }
	                case 2: {

	                    for( new i = 0; i < MAX_COMPONENTS; i++ ) {
			                if( cInfo[ i ][ cType ] == CARMODTYPE_EXHAUST ) {
			                    if( cInfo[ i ][ cID ] == IsComponentidCompatibleNew( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
				                    TPInfo[ playerid ][ tID ] = i;
									break;
								}
			                }
						}
	                    if( TPInfo[ playerid ][ tID ] == -1 ) return SendClientMessage(playerid, -1, "[ รถของคุณไม่สามารถติดตั้งอุปกรณ์แต่งอื่นได้แล้ว ]" );

						new cid = TPInfo[ playerid ][ tID ];
						TPInfo[ playerid ][ tType ] = CARMODTYPE_EXHAUST;
						TPInfo[ playerid ][ tPaintjob ] = false;

	                    TogglePlayerControllable( playerid, false );
	                    TuningTDControl( playerid, true );

	                    format( globalstring, sizeof( globalstring ), "%s", cInfo[ cid ][ cName ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 3 ], globalstring );
						format( globalstring, sizeof( globalstring ), "Price: ~w~%d$", cInfo[ cid ][ cPrice ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 4 ], globalstring );

                        AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

						GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], -2, -5, 0 );
						SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

						GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
						SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

						SelectTextDraw( playerid, 0xFFA84DFF );
	                }
	                case 3: {

	                    for( new i = 0; i < MAX_COMPONENTS; i++ ) {
			                if( cInfo[ i ][ cType ] == CARMODTYPE_FRONT_BUMPER ) {
			                    if( cInfo[ i ][ cID ] == IsComponentidCompatibleNew( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
				                    TPInfo[ playerid ][ tID ] = i;
									break;
								}
			                }
						}
	                    if( TPInfo[ playerid ][ tID ] == -1 ) return SendClientMessage(playerid, -1, "[ รถของคุณไม่สามารถติดตั้งอุปกรณ์แต่งอื่นได้แล้ว ]" );

						new cid = TPInfo[ playerid ][ tID ];
						TPInfo[ playerid ][ tType ] = CARMODTYPE_FRONT_BUMPER;
						TPInfo[ playerid ][ tPaintjob ] = false;

	                    TogglePlayerControllable( playerid, false );
	                    TuningTDControl( playerid, true );

	                    format( globalstring, sizeof( globalstring ), "%s", cInfo[ cid ][ cName ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 3 ], globalstring );
						format( globalstring, sizeof( globalstring ), "Price: ~w~%d$", cInfo[ cid ][ cPrice ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 4 ], globalstring );

                        AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

						GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 0, 6, 0.5 ); // done
						SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

						GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
						SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

						SelectTextDraw( playerid, 0xFFA84DFF );
	                }
	                case 4: {

	                    for( new i = 0; i < MAX_COMPONENTS; i++ ) {
			                if( cInfo[ i ][ cType ] == CARMODTYPE_REAR_BUMPER ) {
			                    if( cInfo[ i ][ cID ] == IsComponentidCompatibleNew( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
				                    TPInfo[ playerid ][ tID ] = i;
									break;
								}
			                }
						}
	                    if( TPInfo[ playerid ][ tID ] == -1 ) return SendClientMessage(playerid, -1, "[ รถของคุณไม่สามารถติดตั้งอุปกรณ์แต่งอื่นได้แล้ว ]" );

						new cid = TPInfo[ playerid ][ tID ];
						TPInfo[ playerid ][ tType ] = CARMODTYPE_REAR_BUMPER;
						TPInfo[ playerid ][ tPaintjob ] = false;

	                    TogglePlayerControllable( playerid, false );
	                    TuningTDControl( playerid, true );

	                    format( globalstring, sizeof( globalstring ), "%s", cInfo[ cid ][ cName ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 3 ], globalstring );
						format( globalstring, sizeof( globalstring ), "Price: ~w~%d$", cInfo[ cid ][ cPrice ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 4 ], globalstring );

                        AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

						GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 0, -6, 0.5 ); // done
						SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

						GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
						SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

						SelectTextDraw( playerid, 0xFFA84DFF );
	                }
	                case 5: {

	                    for( new i = 0; i < MAX_COMPONENTS; i++ ) {
			                if( cInfo[ i ][ cType ] == CARMODTYPE_ROOF ) {
			                    if( cInfo[ i ][ cID ] == IsComponentidCompatibleNew( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
				                    TPInfo[ playerid ][ tID ] = i;
									break;
								}
			                }
						}
	                    if( TPInfo[ playerid ][ tID ] == -1 ) return SendClientMessage(playerid, -1, "[ รถของคุณไม่สามารถติดตั้งอุปกรณ์แต่งอื่นได้แล้ว ]" );

						new cid = TPInfo[ playerid ][ tID ];
						TPInfo[ playerid ][ tType ] = CARMODTYPE_ROOF;
						TPInfo[ playerid ][ tPaintjob ] = false;

	                    TogglePlayerControllable( playerid, false );
	                    TuningTDControl( playerid, true );

	                    format( globalstring, sizeof( globalstring ), "%s", cInfo[ cid ][ cName ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 3 ], globalstring );
						format( globalstring, sizeof( globalstring ), "Price: ~w~%d$", cInfo[ cid ][ cPrice ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 4 ], globalstring );

                        AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

						GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 0, 6, 2 ); // done
						SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

						GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
						SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

						SelectTextDraw( playerid, 0xFFA84DFF );
	                }
	                case 6: {

	                    for( new i = 0; i < MAX_COMPONENTS; i++ ) {
			                if( cInfo[ i ][ cType ] == CARMODTYPE_SPOILER ) {
			                    if( cInfo[ i ][ cID ] == IsComponentidCompatibleNew( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
				                    TPInfo[ playerid ][ tID ] = i;
									break;
								}
			                }
						}
	                    if( TPInfo[ playerid ][ tID ] == -1 ) return SendClientMessage(playerid, -1, "[ รถของคุณไม่สามารถติดตั้งอุปกรณ์แต่งอื่นได้แล้ว ]" );

						new cid = TPInfo[ playerid ][ tID ];
						TPInfo[ playerid ][ tType ] = CARMODTYPE_SPOILER;
						TPInfo[ playerid ][ tPaintjob ] = false;

	                    TogglePlayerControllable( playerid, false );
	                    TuningTDControl( playerid, true );

	                    format( globalstring, sizeof( globalstring ), "%s", cInfo[ cid ][ cName ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 3 ], globalstring );
						format( globalstring, sizeof( globalstring ), "Price: ~w~%d$", cInfo[ cid ][ cPrice ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 4 ], globalstring );

                        AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

						GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 0, -6, 2 ); // done
						SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

						GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
						SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

						SelectTextDraw( playerid, 0xFFA84DFF );
	                }
	                case 7: {

	                    for( new i = 0; i < MAX_COMPONENTS; i++ ) {
			                if( cInfo[ i ][ cType ] == CARMODTYPE_SIDESKIRT ) {
			                    if( cInfo[ i ][ cID ] == IsComponentidCompatibleNew( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
				                    TPInfo[ playerid ][ tID ] = i;
									break;
								}
			                }
						}
	                    if( TPInfo[ playerid ][ tID ] == -1 ) return SendClientMessage(playerid, -1, "[ รถของคุณไม่สามารถติดตั้งอุปกรณ์แต่งอื่นได้แล้ว ]" );

						new cid = TPInfo[ playerid ][ tID ];
						TPInfo[ playerid ][ tType ] = CARMODTYPE_SIDESKIRT;
						TPInfo[ playerid ][ tPaintjob ] = false;

	                    TogglePlayerControllable( playerid, false );
	                    TuningTDControl( playerid, true );

	                    format( globalstring, sizeof( globalstring ), "%s", cInfo[ cid ][ cName ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 3 ], globalstring );
						format( globalstring, sizeof( globalstring ), "Price: ~w~%d$", cInfo[ cid ][ cPrice ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 4 ], globalstring );

                        AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

						GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 4, 0, 0.5 );
						SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

						GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
						SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

						SelectTextDraw( playerid, 0xFFA84DFF );
	                }
	                case 8: {

	                    for( new i = 0; i < MAX_COMPONENTS; i++ ) {
			                if( cInfo[ i ][ cType ] == CARMODTYPE_WHEELS ) {
			                    if( cInfo[ i ][ cID ] == IsComponentidCompatibleNew( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
				                    TPInfo[ playerid ][ tID ] = i;
									break;
								}
			                }
						}
	                    if( TPInfo[ playerid ][ tID ] == -1 ) return SendClientMessage(playerid, -1, "[ รถของคุณไม่สามารถติดตั้งอุปกรณ์แต่งอื่นได้แล้ว ]" );

						new cid = TPInfo[ playerid ][ tID ];
						TPInfo[ playerid ][ tType ] = CARMODTYPE_WHEELS;
						TPInfo[ playerid ][ tPaintjob ] = false;

	                    TogglePlayerControllable( playerid, false );
	                    TuningTDControl( playerid, true );

	                    format( globalstring, sizeof( globalstring ), "%s", cInfo[ cid ][ cName ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 3 ], globalstring );
						format( globalstring, sizeof( globalstring ), "Price: ~w~%d$", cInfo[ cid ][ cPrice ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 4 ], globalstring );

                        AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

						GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 4, 0, 0.5 ); // done
						SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

						GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
						SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

						SelectTextDraw( playerid, 0xFFA84DFF );
	                }
	                case 9: {

	                    for( new i = 0; i < MAX_COMPONENTS; i++ ) {
			                if( cInfo[ i ][ cType ] == CARMODTYPE_STEREO ) {
			                    if( cInfo[ i ][ cID ] == IsComponentidCompatibleNew( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
				                    TPInfo[ playerid ][ tID ] = i;
									break;
								}
			                }
						}
	                    if( TPInfo[ playerid ][ tID ] == -1 ) return SendClientMessage(playerid, -1, "[ รถของคุณไม่สามารถติดตั้งอุปกรณ์แต่งอื่นได้แล้ว ]" );

						new cid = TPInfo[ playerid ][ tID ];
						TPInfo[ playerid ][ tType ] = CARMODTYPE_STEREO;
						TPInfo[ playerid ][ tPaintjob ] = false;

	                    TogglePlayerControllable( playerid, false );
	                    TuningTDControl( playerid, true );

	                    format( globalstring, sizeof( globalstring ), "%s", cInfo[ cid ][ cName ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 3 ], globalstring );
						format( globalstring, sizeof( globalstring ), "Price: ~w~%d$", cInfo[ cid ][ cPrice ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 4 ], globalstring );

                        AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

						GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 0, -6, 2 );
						SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

						GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
						SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

						SelectTextDraw( playerid, 0xFFA84DFF );
	                }
	                case 10: {

	                    for( new i = 0; i < MAX_COMPONENTS; i++ ) {
			                if( cInfo[ i ][ cType ] == CARMODTYPE_HYDRAULICS ) {
			                    if( cInfo[ i ][ cID ] == IsComponentidCompatibleNew( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
				                    TPInfo[ playerid ][ tID ] = i;
									break;
								}
			                }
						}
	                    if( TPInfo[ playerid ][ tID ] == -1 ) return SendClientMessage(playerid, -1, "[ รถของคุณไม่สามารถติดตั้งอุปกรณ์แต่งอื่นได้แล้ว ]" );

						new cid = TPInfo[ playerid ][ tID ];
						TPInfo[ playerid ][ tType ] = CARMODTYPE_HYDRAULICS;
						TPInfo[ playerid ][ tPaintjob ] = false;

	                    TogglePlayerControllable( playerid, false );
	                    TuningTDControl( playerid, true );

	                    format( globalstring, sizeof( globalstring ), "%s", cInfo[ cid ][ cName ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 3 ], globalstring );
						format( globalstring, sizeof( globalstring ), "Price: ~w~%d$", cInfo[ cid ][ cPrice ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 4 ], globalstring );

                        AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

						GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 2, 2, 2 );
						SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

						GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
						SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

						SelectTextDraw( playerid, 0xFFA84DFF );
	                }
	                case 11: {

	                    for( new i = 0; i < MAX_COMPONENTS; i++ ) {
			                if( cInfo[ i ][ cType ] == CARMODTYPE_NITRO ) {
			                    if( cInfo[ i ][ cID ] == IsComponentidCompatibleNew( GetVehicleModel( vehicleid ), cInfo[ i ][ cID ] ) ) {
				                    TPInfo[ playerid ][ tID ] = i;
									break;
								}
			                }
						}
	                    if( TPInfo[ playerid ][ tID ] == -1 ) return SendClientMessage(playerid, -1, "[ รถของคุณไม่สามารถติดตั้งอุปกรณ์แต่งอื่นได้แล้ว ]" );

						new cid = TPInfo[ playerid ][ tID ];
						TPInfo[ playerid ][ tType ] = CARMODTYPE_NITRO;
						TPInfo[ playerid ][ tPaintjob ] = false;

	                    TogglePlayerControllable( playerid, false );
	                    TuningTDControl( playerid, true );

	                    format( globalstring, sizeof( globalstring ), "%s", cInfo[ cid ][ cName ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 3 ], globalstring );
						format( globalstring, sizeof( globalstring ), "Price: ~w~%d$", cInfo[ cid ][ cPrice ] );
						PlayerTextDrawSetString( playerid, TuningBuy[ playerid ][ 4 ], globalstring );

                        AddVehicleComponent( vehicleid, cInfo[ cid ][ cID ] );

						GetVehicleCameraPos( vehicleid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ], 0, -6, 2 ); // done
						SetPlayerCameraPos( playerid, Pos[ 0 ], Pos[ 1 ], Pos[ 2 ] );

						GetVehiclePos( vehicleid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );
						SetPlayerCameraLookAt( playerid, Pos[ 0 ],Pos[ 1 ],Pos[ 2 ] );

						SelectTextDraw( playerid, 0xFFA84DFF );
	                }
	            }
	        }
	        else if( !response ) {
	            SetCameraBehindPlayer( playerid );
	        }
	    }
	    case dialog_TUNING_2: {
	        if( !response ) return 1;
			if( response ) {
			    if( !IsPlayerInAnyVehicle( playerid ) ) return SendClientMessage(playerid, -1, "คุณต้องอยู่ในรถ" );
	            if( GetPlayerState( playerid ) != PLAYER_STATE_DRIVER ) return SendClientMessage(playerid, -1, "คุณต้องเป็นคนขับรถ" );
				new vehicleid = GetPlayerVehicleID( playerid );
			    if( GetPlayerMoney( playerid ) < COLOR_PRICE ) return SendClientMessage(playerid, -1, "คุณมีเงินไม่เพียงพอ" );
			    new b1, b2;
			    if( sscanf( inputtext, "ii", b1, b2 ) ) return SPD( playerid, dialog_TUNING_2, DSI, D_TOP, "ใส่เลขสีรถที่คุณต้องการจะเปลี่ยน\nเช่น:0 1", D_OK, D_CANCEL );
				if( b1 < 0 || b2 < 0 || b1 > 255 || b2 > 255 ) return SendClientMessage(playerid, -1, "ไอดีต้องอยู่ระหว่าง 0 - 255");

				ChangeVehicleColor( vehicleid, b1, b2 );
				GivePlayerMoney( playerid, COLOR_PRICE );

				SPD( playerid, dialog_TUNING, DSL, D_TOP, D_TEXT, D_OK, D_CANCEL );
			}
		}
	}
	return true;
}

stock IsComponentidCompatibleNew( modelid, componentid ) {
    if( componentid == 1025 || componentid == 1073 || componentid == 1074 || componentid == 1075 || componentid == 1076 ||
		componentid == 1077 || componentid == 1078 || componentid == 1079 || componentid == 1080 || componentid == 1081 ||
        componentid == 1082 || componentid == 1083 || componentid == 1084 || componentid == 1085 || componentid == 1096 ||
        componentid == 1097 || componentid == 1098 || componentid == 1087 || componentid == 1086 ) {
        return componentid;
	}

    switch( modelid ) {
        case 400: if( componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1013 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010 ) return componentid;
        case 401: if( componentid == 1005 || componentid == 1004 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 114 || componentid == 1020 || componentid == 1019 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1003 || componentid == 1017 || componentid == 1007) return componentid;
        case 402: if( componentid == 1009 || componentid == 1009 || componentid == 1010 ) return componentid;
        case 404: if( componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1002 || componentid == 1016 || componentid == 1000 || componentid == 1017 || componentid == 1007) return componentid;
        case 405: if( componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1001 || componentid == 1014 || componentid == 1023 || componentid == 1000) return componentid;
        case 409: if( componentid == 1009 ) return componentid;
        case 410: if( componentid == 1019 || componentid == 1021 || componentid == 1020 || componentid == 1013 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1001 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007) return componentid;
        case 411: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 412: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 415: if( componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1001 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007) return componentid;
        case 418: if( componentid == 1020 || componentid == 1021 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1002 || componentid == 1016) return componentid;
        case 419: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 420: if( componentid == 1005 || componentid == 1004 || componentid == 1021 || componentid == 1019 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1001 || componentid == 1003) return componentid;
        case 421: if( componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1014 || componentid == 1023 || componentid == 1016 || componentid == 1000) return componentid;
        case 422: if( componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1017 || componentid == 1007) return componentid;
        case 426: if( componentid == 1005 || componentid == 1004 || componentid == 1021 || componentid == 1019 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1003) return componentid;
        case 429: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 436: if( componentid == 1020 || componentid == 1021 || componentid == 1022 || componentid == 1019 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1003 || componentid == 1017 || componentid == 1007) return componentid;
        case 438: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 439: if( componentid == 1003 || componentid == 1023 || componentid == 1001 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1017 || componentid == 1007 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1013) return componentid;
        case 442: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 445: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 451: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 458: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 466: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 467: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 474: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 475: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 477: if( componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1017 || componentid == 1007) return componentid;
        case 478: if( componentid == 1005 || componentid == 1004 || componentid == 1012 || componentid == 1020 || componentid == 1021 || componentid == 1022 || componentid == 1013 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 479: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 480: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 489: if( componentid == 1005 || componentid == 1004 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1013 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1002 || componentid == 1016 || componentid == 1000) return componentid;
        case 491: if( componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1014 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007) return componentid;
        case 492: if( componentid == 1005 || componentid == 1004 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1016 || componentid == 1000) return componentid;
        case 496: if( componentid == 1006 || componentid == 1017 || componentid == 1007 || componentid == 1011 || componentid == 1019 || componentid == 1023 || componentid == 1001 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1003 || componentid == 1002 || componentid == 1142 || componentid == 1143 || componentid == 1020) return componentid;
        case 500: if( componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1013 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 506: if( componentid == 1009) return componentid;
        case 507: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 516: if( componentid == 1004 || componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1002 || componentid == 1015 || componentid == 1016 || componentid == 1000 || componentid == 1017 || componentid == 1007) return componentid;
        case 517: if( componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1002 || componentid == 1023 || componentid == 1016 || componentid == 1003 || componentid == 1017 || componentid == 1007) return componentid;
        case 518: if( componentid == 1005 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1018 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007) return componentid;
        case 526: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 527: if( componentid == 1021 || componentid == 1020 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1001 || componentid == 1014 || componentid == 1015 || componentid == 1017 || componentid == 1007) return componentid;
        case 529: if( componentid == 1012 || componentid == 1011 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007) return componentid;
        case 533: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 534: if( componentid == 1126 || componentid == 1127 || componentid == 1179 || componentid == 1185 || componentid == 1100 || componentid == 1123 || componentid == 1125 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1180 || componentid == 1178 || componentid == 1101 || componentid == 1122 || componentid == 1124 || componentid == 1106) return componentid;
        case 535: if( componentid == 1109 || componentid == 1110 || componentid == 1113 || componentid == 1114 || componentid == 1115 || componentid == 1116 || componentid == 1117 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1120 || componentid == 1118 || componentid == 1121 || componentid == 1119) return componentid;
        case 536: if( componentid == 1104 || componentid == 1105 || componentid == 1182 || componentid == 1181 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1184 || componentid == 1183 || componentid == 1128 || componentid == 1103 || componentid == 1107 || componentid == 1108) return componentid;
        case 540: if( componentid == 1004 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1017 || componentid == 1007) return componentid;
        case 541: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 542: if( componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1014 || componentid == 1015) return componentid;
        case 545: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 546: if( componentid == 1004 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1019 || componentid == 1018 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1002 || componentid == 1001 || componentid == 1023 || componentid == 1017 || componentid == 1007) return componentid;
        case 547: if( componentid == 1142 || componentid == 1143 || componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1016 || componentid == 1003 || componentid == 1000) return componentid;
        case 549: if( componentid == 1012 || componentid == 1011 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1001 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007) return componentid;
        case 550: if( componentid == 1005 || componentid == 1004 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1003) return componentid;
        case 551: if( componentid == 1005 || componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1002 || componentid == 1023 || componentid == 1016 || componentid == 1003) return componentid;
        case 555: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 558: if( componentid == 1092 || componentid == 1089 || componentid == 1166 || componentid == 1165 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1168 || componentid == 1167 || componentid == 1088 || componentid == 1091 || componentid == 1164 || componentid == 1163 || componentid == 1094 || componentid == 1090 || componentid == 1095 || componentid == 1093) return componentid;
        case 559: if( componentid == 1065 || componentid == 1066 || componentid == 1160 || componentid == 1173 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1159 || componentid == 1161 || componentid == 1162 || componentid == 1158 || componentid == 1067 || componentid == 1068 || componentid == 1071 || componentid == 1069 || componentid == 1072 || componentid == 1070 || componentid == 1009) return componentid;
        case 560: if( componentid == 1028 || componentid == 1029 || componentid == 1169 || componentid == 1170 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1141 || componentid == 1140 || componentid == 1032 || componentid == 1033 || componentid == 1138 || componentid == 1139 || componentid == 1027 || componentid == 1026 || componentid == 1030 || componentid == 1031) return componentid;
        case 561: if( componentid == 1064 || componentid == 1059 || componentid == 1155 || componentid == 1157 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1154 || componentid == 1156 || componentid == 1055 || componentid == 1061 || componentid == 1058 || componentid == 1060 || componentid == 1062 || componentid == 1056 || componentid == 1063 || componentid == 1057) return componentid;
        case 562: if( componentid == 1034 || componentid == 1037 || componentid == 1171 || componentid == 1172 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1149 || componentid == 1148 || componentid == 1038 || componentid == 1035 || componentid == 1147 || componentid == 1146 || componentid == 1040 || componentid == 1036 || componentid == 1041 || componentid == 1039) return componentid;
        case 565: if( componentid == 1046 || componentid == 1045 || componentid == 1153 || componentid == 1152 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1150 || componentid == 1151 || componentid == 1054 || componentid == 1053 || componentid == 1049 || componentid == 1050 || componentid == 1051 || componentid == 1047 || componentid == 1052 || componentid == 1048) return componentid;
        case 566: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 567: if( componentid == 1129 || componentid == 1132 || componentid == 1189 || componentid == 1188 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1187 || componentid == 1186 || componentid == 1130 || componentid == 1131 || componentid == 1102 || componentid == 1133) return componentid;
        case 575: if( componentid == 1044 || componentid == 1043 || componentid == 1174 || componentid == 1175 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1176 || componentid == 1177 || componentid == 1099 || componentid == 1042) return componentid;
        case 576: if( componentid == 1136 || componentid == 1135 || componentid == 1191 || componentid == 1190 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1192 || componentid == 1193 || componentid == 1137 || componentid == 1134) return componentid;
        case 579: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 580: if( componentid == 1020 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1017 || componentid == 1007) return componentid;
        case 585: if( componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007) return componentid;
        case 587: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 589: if( componentid == 1005 || componentid == 1004 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1024 || componentid == 1013 || componentid == 1006 || componentid == 1016 || componentid == 1000 || componentid == 1017 || componentid == 1007) return componentid;
        case 600: if( componentid == 1005 || componentid == 1004 || componentid == 1020 || componentid == 1022 || componentid == 1018 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1017 || componentid == 1007) return componentid;
        case 602: if( componentid == 1008 || componentid == 1009 || componentid == 1010) return componentid;
        case 603: if( componentid == 1144 || componentid == 1145 || componentid == 1142 || componentid == 1143 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1017 || componentid == 1007) return componentid;
    }
    return false;
}
