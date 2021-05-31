#include <a_samp>

#define SERVER_GM_TEXT  "SA:RP 1.0.2"

#undef  MAX_PLAYERS
#define MAX_PLAYERS     (500)

native WP_Hash(buffer[], len, const str[]); // Southclaws/samp-whirlpool

#if !defined IsValidVehicle
    native IsValidVehicle(vehicleid);
#endif

public OnGameModeInit()
{
	OnGameModeInitEx();

	#if defined main_OnGameModeInit
		return main_OnGameModeInit();
	#else
		return 1;
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
 
#define OnGameModeInit main_OnGameModeInit
#if defined main_OnGameModeInit
	forward main_OnGameModeInit();
#endif

/*======================================================================================================
										[Includes]
=======================================================================================================*/

#include <crashdetect>      // Zeex/samp-plugin-crashdetect
#include <sscanf2>          // maddinat0r/sscanf:v2.8.2
#include <streamer>         // samp-incognito/samp-streamer-plugin
#include <YSI\y_timers>     // pawn-lang/YSI-Includes
#include <YSI\y_hooks>      // pawn-lang/YSI-Includes
#include <YSI\y_iterate>    // pawn-lang/YSI-Includes asdasdasasdas
//#include <nex-ac>           // NexiusTailer/Nex-AC

#define CE_AUTO
#include <CEFix>            // aktah/SAMP-CEFix

#include <easyDialog>       // Awsomedude/easyDialog:2.0
#include <a_mysql>          // pBlueG/SA-MP-MySQL
#include <Pawn.CMD>         // urShadow/Pawn.CMD
#include <Pawn.Regex>       // urShadow/Pawn.Regex
#include <Pawn.RakNet>    	// urShadow/Pawn.RakNet
#include <log-plugin>       // maddinat0r/samp-log
#include <strlib>           // oscar-broman/strlib
#include <md-sort> 			// oscar-broman/md-sort
#include <mapandreas> 		// philip1337/samp-plugin-mapandreas
#include <compat>

// Legacy Include
#include <preloadanim>      // zAnimsFix & _Zume
#include <zones>      // 
#include <evi>
#include <a_http>
#include <io>
#include <timestamptodate>
#include <OnPlayerTeleport> // Teleport Hack
//#include <TSConnector>

//#include <PreviewModelDialog>
#include <profiler>
#include <GetVehicleColor>
/*======================================================================================================
										[Macros]
=======================================================================================================*/
DEFINE_HOOK_REPLACEMENT(OnPlayer, OP_);

/*======================================================================================================
										[Declarations]
=======================================================================================================*/

new
    Logger:anticheatlog, Logger:systemlog, Logger:adminactionlog, Logger:transferlog, 
	Logger:paychecklog, Logger:donatelog, Logger:namechangelog, Logger:playerlog, Logger:dropgunlog;

/*======================================================================================================
										[Modules]
=======================================================================================================*/


// General
#include "includes/utils/colors.pwn"

// EVENT 

#include "includes/defines.pwn"
#include "includes/enums.pwn"
#include "includes/variables.pwn"
#include "includes/wrappers.pwn"
#include "includes/overwrite.pwn"
#include "includes/functions.pwn"
#include "includes/mysql.pwn"
//#include "includes/tie.pwn"


#include "includes/event/race.pwn"
#include "includes/event/thanos.pwn"

#include "includes/callbacks.pwn"
#include "includes/textdraws.pwn"

// Core
#include "includes/utils/mobilefix.pwn"

#include "includes/core/initgamemode.pwn"
#include "includes/core/tutorial.pwn"
#include "includes/core/auth.pwn"
//#include "includes/core/ac.pwn"

#include "includes/system/realtime.pwn"

#include "includes/system/faction.pwn"

#include "includes/system/cooldown.pwn"
#include "includes/system/entrance.pwn"

#include "includes/system/vehicle.pwn"

#include "includes/system/house.pwn"
#include "includes/system/business.pwn"
#include "includes/system/business_clothing.pwn"
#include "includes/system/house_furniture.pwn"

#include "includes/system/ownership_car.pwn"
#include "includes/system/vlabeltimer.pwn"
#include "includes/system/vcolorselect.pwn"
#include "includes/system/rentcar.pwn"
#include "includes/system/vehicle_engine.pwn"
#include "includes/system/refill.pwn"
#include "includes/system/footerTD.pwn"
#include "includes/system/ironman.pwn"
#include "includes/system/takegun.pwn"
#include "includes/system/avc.pwn"
#include "includes/system/whitelist.pwn"
//#include "includes/system/carmod.pwn"

//#include "includes/system/tollguard.pwn"
// #include "includes/system/job/sweeper.pwn"
#include "includes/system/job/main.pwn"
#include "includes/system/job/farmer.pwn"
#include "includes/system/job/sweeper.pwn"
#include "includes/system/job/fishing.pwn"
#include "includes/system/job/taxi.pwn"
#include "includes/system/job/mecha.pwn"
#include "includes/system/job/garbage.pwn"
#include "includes/system/job/garbage.pwn"
#include "includes/system/job/Treasurehunt.pwn"
#include "includes/system/job/draw.pwn"
//#include "includes/system/job/pizza.pwn"
#include "includes/system/job/trucking.pwn"
#include "includes/system/job/mine.pwn"
#include "includes/system/job/material.pwn"
#include "includes/system/job/saria.pwn"

#include "includes/system/tower.pwn"
#include "includes/system/phone.pwn"
/*#include "includes/system/tower.pwn"
#include "includes/system/dialog_phone.pwn"*/
#include "includes/system/robber.pwn"
#include "includes/system/turfwar.pwn"
#include "includes/system/party.pwn"
// 
#include "includes/system/damages.pwn"
#include "includes/system/baseUI.pwn"
#include "includes/system/payday.pwn"
#include "includes/system/quiz.pwn"
#include "includes/system/dmv.pwn"
#include "includes/system/advert.pwn"
//#include "includes/system/Train.pwn"
//#include "includes/system/gate.pwn"Train

#include "includes/cmd/player.pwn"
#include "includes/cmd/admin.pwn"
#include "includes/cmd/admingoto.pwn"

#include "includes/system/donation.pwn"

#include "includes/timers.pwn"

#include "includes/system/clothing.pwn"
#include "includes/system/drug.pwn"
#include "includes/system/weed.pwn"

#include "includes/system/radio.pwn"
#include "includes/system/report.pwn"
#include "includes/system/atm.pwn"
#include "includes/system/money.pwn"
#include "includes/system/revoke.pwn"
#include "includes/system/box.pwn"
#include "includes/system/weapon.pwn"
#include "includes/system/boombox.pwn"
//#include "includes/system/map.pwn" //`c,r
#include "includes/system/fine.pwn"
#include "includes/system/warn.pwn"
#include "includes/system/warehouse.pwn"
//#include "includes/system/tester.pwn"
#include "includes/system/tie.pwn"
#include "includes/system/prison.pwn"
#include "includes/system/bartender.pwn"
#include "includes/system/tackle.pwn"
#include "includes/system/hair.pwn"
//#include "includes/system/Bunny.pwn"

// Map
#include "includes/map/LSCM2.pwn"
#include "includes/map/PIZZAI.pwn"
#include "includes/map/LSCM.pwn"
#include "includes/map/LSFMD.pwn"
#include "includes/map/kong5.pwn"
#include "includes/map/newbiespawn_ls.pwn"
#include "includes/map/newbiespawn.pwn"
#include "includes/map/school.pwn"
#include "includes/map/quest.pwn"
#include "includes/map/SFtrain 1.pwn"
#include "includes/map/blackmarket.pwn"
#include "includes/map/swrp.pwn"
#include "includes/map/titlemap.pwn"

//#include "includes/map/CQB.pwn"

//#include "includes/map/lsrp_map.pwn"

// Miscellaneous

//main(){}
main()
{
/*	print("\n----------------------------------");
	print("  Bare Script\n");
	print("----------------------------------\n");*/
}

OnGameModeInitEx()
{
	anticheatlog = CreateLog("server/anticheat");
	systemlog = CreateLog("server/system");
	adminactionlog = CreateLog("server/admin_action");
	transferlog = CreateLog("server/transfer");
	paychecklog = CreateLog("server/paycheck");
	donatelog = CreateLog("server/donate");
	namechangelog = CreateLog("server/namechange");
	playerlog = CreateLog("server/playerlog");
	dropgunlog = CreateLog("server/dropgunlog");

	print("Preparing the gamemode, please wait...");
	g_mysql_Init();
	InitiateGamemode();
}
	
public OnGameModeExit()
{
	DestroyLog(anticheatlog);
	DestroyLog(systemlog);
	DestroyLog(adminactionlog);
	DestroyLog(transferlog);
	DestroyLog(paychecklog);
	DestroyLog(donatelog);
	DestroyLog(namechangelog);
	DestroyLog(playerlog);
	DestroyLog(dropgunlog);

	print("Exiting the gamemode, please wait...");
	g_mysql_Exit();
	return 1;
}

AntiDeAMX()
{
    new b;
    #emit load.pri b
    #emit stor.pri b
}
