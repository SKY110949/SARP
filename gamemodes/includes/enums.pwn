//--------------------------------[ENUMS.PWN]--------------------------------

enum PlayerFlags:(<<= 1)    // BitFlag
{
    IS_SPAWNED = 1,
	IS_LOGGED,
    IS_MASKED,
    IS_CUFFED,
    TOGGLE_PMS,
    TOGGLE_OOC,
    TOGGLE_HUD,
    TOGGLE_FACTION,
    IS_TAZERED,
    TOGGLE_AC,
    IS_PLAYER_EDITCLOTHING,
    IS_PLAYER_EDITWEAPON,
    IS_PLAYER_BUYCLOTHING,
    FRISKAPPROVE,
    PLAYER_MINING,
    IS_PLAYER_TAZER
};

enum (<<= 1)
{
    CMD_PLAYER = 1,
    CMD_TESTER,
    CMD_ADM_1,
    CMD_ADM_2,
    CMD_ADM_3,
    CMD_LEAD_ADMIN,         // Lead Admin
    CMD_MANAGEMENT,        // Management
    CMD_DEV,                // Developer
};

enum systemE {
	OOCStatus,
    reportSystem,
    EventSystem,
    regisStatus,
    PrisonStatus,
}

enum E_PLAYER_DATA
{
    pSID,
    pAdmin,
    pPnumber,
    pModel,
    pIsDead,
    pPrisonTime,
    pWear,
    pScore,
    pLevel,
    pExp,
    pCash,
    bool:pCarLic,
    pWarrants,
    pJailed,
    pJailTime,
    pSeedWeed,
    bool:pWatering,
    pPCarkey,
    pPDupkey,
    pSQLID,
	pDrugAddiction[10],
	pDrugAddict,
	pDrugAddictStrength,

    pItemGasCan,
    pItemCrowbar,
    pItemOOC,
    pAccount,
    pSavingsCollect,
    pSavings,
    pPayDayHad,
    pPayCheck,
    pPayDay,
    pPUpgrade,
    Float:pHunger,

    pRespawnPerks,
    pVehiclePerks,
    pFishingPerks,

    pPlayingHours,
    pDonateRank,
    pSpawnType,
    pSpawnPoint,
    pTalkStyle,
    pHouseKey,
    pBusinessKey,
    pTimeout,

    Float:pPosX,
    Float:pPosY,
    Float:pPosZ,
    Float:pPosA,

    pArrested,

    pVWorld,
    pInterior,

    bool:pCreated,
    bool:pMedicBill,
    
    Float:pHealth,
    Float:pSHealth,
    Float:pArmour,

    pOnDuty,

    pFaction, // faction.pwn
    pFactionRank,

    pFishes,
    pContractTime,
    pJob,
    pSideJob,
    pJobRank,

    pPoint,

    pIP[16],
    pSpectating,
    pCMDPermission,
    pAnimation,

    pRadio,
	pRChannel,
	pRSlot,
	pRAuth[16],

    pReport,
    pReportMessage[64],
    pATM,

    pNameChangeFree,
    pCannabis,

    pRMoney,
    pIrons,
    pAllowMiner,
	pAlgePack,

    pOre,
    pCold,
    pDiamond,

    pLuckyBox,
    pTurismo,

    pCPCannabis,

	pGuns[13],
	pAmmo[13],

	pGun1,
	pGun2,
	pGun3,

	pAmmo1,
	pAmmo2,
	pAmmo3,

	pBoombox,
	pBoomboxPlaced,
	pBoomboxURL[128],
	Float:pBoomboxX,
	Float:pBoomboxY,
	Float:pBoomboxZ,
	pBoomboxInterior,
	pBoomboxWorld,
	pBoomboxObject,
	Text3D:pBoomboxText,
	pBoomboxNearby,

    pFirstAid,

    pMaterials,
    pCPMaterials,

    pBox,
    pDBox,

	pWarning1[32],
	pWarning2[32],
	pWarning3[32],

    pNMuted,
    pNewbieEnabled,
    pNewbieTimeout,

    pMechanicBox,
	pHelper,
	pAdminName[MAX_PLAYER_NAME],

    pStock,
    pTie,
    pFreezeType,
    pFreezeTime,

    pDrag,

    Float:pHungry,
    Float:pThirst,

    pPizza,
    pDrink,

    pChristmas,
    pKeyBox,
    pHair,
    pChristmasx,

    pChangeName,
};

enum E_VEHICLE_DATA {
    vOwnerID,
    vUpgradeID,
    Float:vFuel,
    Float:vMiles,
    Float:vHealth,
	startup_delay,
	startup_delay_sender,
	startup_delay_random,
    vehicleBadlyDamage,
    Text3D:vehSignText,
	vbreakin,
	vbreaktime,
	vbreakdelay,
    bool:vlocked,
};

enum atmData {
	atmID,
	atmExists,
	Float:atmPos[4],
	atmInterior,
	atmWorld,
	atmObject,
	Text3D:atmText3D
};
