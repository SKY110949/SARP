//--------------------------------[DEFINES.PWN]--------------------------------

// #define SV_DEBUG

// ใช้มาโคร BitFlag
#define BitFlag_Get(%0,%1)   		((%0) & (%1))   // ส่งค่ากลับ 0 (เท็จ)หากยังไม่ได้ตั้งค่าให้มัน
#define BitFlag_On(%0,%1)    		((%0) |= (%1))  // ปรับค่าเป็น เปิด
#define BitFlag_Off(%0,%1)   		((%0) &= ~(%1)) // ปรับค่าเป็น ปิด
#define BitFlag_Toggle(%0,%1)		((%0) ^= (%1))  // สลับค่า (สลับ จริง/เท็จ)

// ใช้มาโคร Key
#define PRESSED(%0)	\
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))

#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

// Weapon Skill
#define NORMAL_SKILL			1
#define MEDIUM_SKILL			2
#define FULL_SKILL				3

#define WEAPON_UNARMED 			0
#define WEAPON_PISTOLWHIP 		48
#define WEAPON_CARPARK 			52

// BODY PARTS
#define BODY_PART_TORSO 		3
#define BODY_PART_GROIN 		4
#define BODY_PART_RIGHT_ARM 	5
#define BODY_PART_LEFT_ARM 		6
#define BODY_PART_RIGHT_LEG 	7
#define BODY_PART_LEFT_LEG 		8
#define BODY_PART_HEAD 			9


// ช่องเครื่องแต่งกาย
#define CLOTHING_SLOT_0 		0
#define CLOTHING_SLOT_1 		1
#define CLOTHING_SLOT_2 		2
#define CLOTHING_SLOT_3 		3
#define CLOTHING_SLOT_4 		4
#define CLOTHING_SLOT_5 		5
#define CLOTHING_SLOT_6 		6
#define CLOTHING_SLOT_7 		7
#define CLOTHING_SLOT_8 		8
#define CLOTHING_SLOT_9 		9

// Spawn points:
#define SPAWN_TYPE_DEFAULT		(0)
#define SPAWN_TYPE_PROPERTY		(1)
#define SPAWN_TYPE_FACTION		(2)
#define SPAWN_TYPE_LASTPOS		(3)

// Type Offer
#define OFFER_TYPE_NONE			0
#define OFFER_TYPE_SERVICE		1

#define MAX_STRING				255

#define	MULTIPLE_EXP			4
#define	FUEL_PRICE				50

#define Main_GetRespawnPerks(%0) \
	(playerData[%0][pRespawnPerks]*10)

#define Main_GetRespawnTime(%0) \
	(60-(playerData[%0][pRespawnPerks]*10))