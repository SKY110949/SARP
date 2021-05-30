#include <YSI\y_hooks>

//งานก่อสร้าง
new
	BuilderActor,
	Working[MAX_PLAYERS],
	LastSkin[MAX_PLAYERS],
	BuilderCP[MAX_PLAYERS];

hook OnGameModeInit()
{
	BuilderActor = CreateActor(16, 1254.1410, -1265.7305, 13.3705, 358.4537);
	SetActorInvulnerable(BuilderActor, true);
	ApplyActorAnimation(BuilderActor, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);

	AddStaticPickup(1275, 23, 1254.1210, -1265.0613, 13.2784);
    Create3DTextLabel("{FFFF00}งานก่อสร้าง! Lv. 1{FFFFFF}\nคำสั่ง: /ก่อสร้าง เพื่อเริ่มงาน.\nและ /หยุดก่อสร้าง เพื่อหยุดทำงาน.", -1, 1254.1210, -1265.0613, 13.2784, 10.0,0);

	// Builder
	CreateObject(11081, 1253.47888, -1238.73682, 21.98707,   0.00000, 0.00000, 0.00000);
	CreateObject(1684, 1257.44678, -1268.18860, 13.92266,   0.00000, 0.00000, -180.00000);
	CreateObject(3504, 1248.59839, -1269.02271, 13.85367,   0.00000, 0.00000, 0.00000);
	CreateObject(3504, 1245.22815, -1269.02271, 13.85370,   0.00000, 0.00000, 0.00000);
	CreateObject(3504, 1241.80103, -1269.02271, 13.85370,   0.00000, 0.00000, 0.00000);
	CreateObject(1380, 1242.71594, -1255.90039, 36.20860,   0.00000, 0.00000, 0.00000);
	CreateObject(1391, 1242.84509, -1256.15466, 67.51294,   0.00000, 0.00000, 0.00000);
	CreateObject(1388, 1242.78784, -1256.14575, 78.81348,   3.14159, 0.00000, -36.32735);
	CreateObject(944, 1280.83032, -1238.00964, 13.88971,   0.00000, 0.00000, 0.00000);
	CreateObject(944, 1280.82617, -1239.37219, 13.88971,   0.00000, 0.00000, 0.00000);
	CreateObject(944, 1280.81775, -1240.77649, 13.88971,   0.00000, 0.00000, 0.00000);
	CreateObject(944, 1280.82617, -1239.37219, 15.26536,   0.00000, 0.00000, 0.00000);
	CreateObject(2359, 1280.74414, -1240.79858, 14.79832,   0.00000, 0.00000, 0.00000);
	CreateObject(925, 1264.98474, -1236.76953, 17.18457,   0.00000, 0.00000, 88.80002);
	CreateObject(3573, 1262.30530, -1249.57727, 15.40564,   0.00000, 0.00000, 0.00000);
	CreateObject(2567, 1268.85315, -1232.81580, 17.88041,   0.00000, 0.00000, 0.00000);
	CreateObject(3796, 1265.99060, -1251.27612, 18.09540,   0.00000, 0.00000, 0.00000);
	CreateObject(2669, 1271.85730, -1251.04346, 14.35794,   6.00000, 0.00000, 0.00000);
	CreateObject(2669, 1246.29199, -1256.84241, 13.53976,   0.00000, 0.00000, -268.85983);
	CreateObject(1465, 1282.14600, -1267.90417, 13.61396,   0.00000, 0.00000, -90.47998);
	CreateObject(1465, 1282.14600, -1265.25549, 13.63090,   0.00000, 0.00000, -90.48000);
	CreateObject(1465, 1281.98218, -1262.63489, 12.24269,   0.00000, -18.00000, 1.80000);
	CreateObject(1465, 1282.14600, -1259.91467, 13.63090,   0.00000, 0.00000, -90.48000);
	CreateObject(1465, 1282.14600, -1257.23779, 13.63090,   0.00000, 0.00000, -90.48000);
	CreateObject(1465, 1282.14600, -1257.23779, 15.48013,   0.00000, 0.00000, -90.48000);
	CreateObject(1465, 1282.14600, -1259.91467, 15.48010,   0.00000, 0.00000, -90.48000);
	CreateObject(1465, 1282.14600, -1262.59583, 15.48010,   0.00000, 0.00000, -90.48000);
	CreateObject(1465, 1282.14600, -1265.25549, 15.48010,   0.00000, 0.00000, -90.48000);
	CreateObject(1465, 1282.14600, -1267.90417, 15.48010,   0.00000, 0.00000, -90.48000);
	CreateObject(3864, 1281.10425, -1248.87158, 18.57323,   0.00000, 0.00000, 0.00000);
	CreateObject(3864, 1266.49414, -1268.06592, 18.57320,   0.00000, 0.00000, -90.00000);
	CreateObject(19791, 1268.58093, -1236.00977, 6.05160,   0.00000, 0.00000, 0.00000);
	CreateObject(19357, 1242.21143, -1256.64771, 35.47490,   0.00000, 90.00000, 0.00000);
	CreateObject(19357, 1242.20984, -1253.93250, 35.47490,   0.00000, 90.00000, 0.00000);
	CreateObject(19357, 1244.22314, -1257.11230, 35.47490,   0.00000, 90.00000, 0.00000);
	CreateObject(1473, 1271.83289, -1241.87573, 15.56858,   0.00000, 0.00000, 0.00000);
	CreateObject(1473, 1274.27112, -1235.94006, 15.38793,   11.00000, 0.00000, 90.63998);
	CreateObject(1473, 1275.77148, -1235.92285, 14.32175,   11.00000, 0.00000, 90.63998);

}
hook OnPlayerConnect(playerid)
{
	Working[playerid] = 0;
	LastSkin[playerid] = GetPlayerSkin(playerid);
	BuilderCP[playerid] = 0;

	// Map
	RemoveBuildingForPlayer(playerid, 1388, 1238.3750, -1258.2813, 57.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 1391, 1238.3750, -1258.2734, 44.6641, 0.25);
	return 1;
}
hook OnPlayerUpdate(playerid)
{
	if(Working[playerid] == 1) //งานก่อสร้าง
	{
		if(!PlayerToPoint(80, playerid, 1254.1210, -1265.0613, 13.2784) && Working[playerid] == 1)
		{
			Working[playerid] = 0;
			DisablePlayerCheckpoint(playerid);
			RemovePlayerAttachedObject(playerid,0);
			ClearAnimations(playerid);
			SetPlayerSpecialAction(playerid, 0);
			BuilderCP[playerid] = 0;

			if(IsPlayerInAnyVehicle(playerid))
			{
				RemovePlayerFromVehicle(playerid);
				SendClientMessage(playerid, -1, "[!] คุณออกจากพื้นที่การทำงาน ระบบจึงยกเลิกงานอัตโนมัติ");
			}
			else
			{
				SendClientMessage(playerid, -1, "[!] คุณออกจากพื้นที่การทำงาน ระบบจึงยกเลิกงานอัตโนมัติ");
			}
			SetPlayerSkin(playerid, LastSkin[playerid]);
		}
	}
	return 1;
}

alias:startbuild("ก่อสร้าง");
CMD:startbuild(playerid)
{

    if(PlayerToPoint(4, playerid, 1254.1210, -1265.0613, 13.2784)){
		if(playerData[playerid][pLevel] > 4)
			return SendErrorMessage(playerid, "คุณมีเลเวลมากกว่า 4 แล้วไม่สามารถทำได้");

		if(Working[playerid] == 0)
		{
			Working[playerid] = 1;
			LastSkin[playerid] = GetPlayerSkin(playerid);
			SetPlayerSkin(playerid, 16);
			new x = random(3);
			if(x == 0) {
				SetPlayerCheckpoint(playerid, 1280.0118, -1262.7102, 13.5107, 2.0);
			}
			if(x == 1) {
				SetPlayerCheckpoint(playerid, 1280.9083, -1242.0677, 13.9160, 2.0);
			}
			if(x == 2 || x == 3) {
				SetPlayerCheckpoint(playerid, 1268.9485, -1234.4961, 17.0519, 2.0);
			}
			
			BuilderCP[playerid] = 1;

			SendClientMessage(playerid, 0xFFFF00FF, "คุณได้เริ่มทำงานแล้ว ไปยังจุดสีแดงในแผนที่");
		}
		else SendClientMessage(playerid, 0xA8FA82FF, "คุณพร้อมทำงานแล้ว, ถ้าอยากหยุดทำงานใช้คำสั่ง /หยุดก่อสร้าง ");
	}
	return 1;
}
alias:stopbuild("หยุดก่อสร้าง");
CMD:stopbuild(playerid)
{
    if(PlayerToPoint(4, playerid, 1254.1210, -1265.0613, 13.2784)){
		if(Working[playerid] == 1)
		{
			SetPlayerSkin(playerid, LastSkin[playerid]);
			DisablePlayerCheckpoint(playerid);
			RemovePlayerAttachedObject(playerid,0);
			ClearAnimations(playerid);
			SetPlayerSpecialAction(playerid, 0);
			BuilderCP[playerid] = 0;
			Working[playerid] = 0;

			SendClientMessage(playerid, 0x80FF00FF, "คุณได้หยุดทำงานก่อสร้างแล้วแล้ว");
		}
		else SendClientMessage(playerid, 0xFF0000FF, "คุณยังไม่ได้ทำงาน!");
	}
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	if(BuilderCP[playerid] == 1)
	{
		if(GetPlayerState(playerid) == 1){
			DisablePlayerCheckpoint(playerid);
			new randobj = random(3);
			if(randobj == 0) {
				SetPlayerAttachedObject( playerid, 0, 3632, 1, 0.280445, 0.445938, 0.000000, 0.000000, 0.000000, 0.000000, 0.935883, 1.000000, 0.508070 );
				ApplyAnimation(playerid,"CARRY","crry_prtial",4.0,1,0,0,1,1,1);
			}
			else if(randobj == 1) {
				SetPlayerAttachedObject( playerid, 0, 2040, 1, 0.132374, 0.415244, 0.000000, 0.000000, 0.000000, 0.000000, 1.338602, 1.000000, 2.515828 );
				ApplyAnimation(playerid,"CARRY","crry_prtial",4.0,1,0,0,1,1,1);
			}
			else if(randobj == 2) {
				SetPlayerAttachedObject( playerid, 0, 1353, 1, 0.238547, 0.448155, 0.000000, 277.985870, 87.919158, 352.250915, 0.317783, 1.000000, 0.308136 );
				ApplyAnimation(playerid,"CARRY","crry_prtial",4.0,1,0,0,1,1,1);
			}
			else if(randobj == 3) {
				SetPlayerAttachedObject( playerid, 0, 2060, 1, 0.178045, 0.407681, -0.025817, 3.533153, 102.484672, 350.146301, 1.000000, 1.000000, 1.000000 );
				ApplyAnimation(playerid,"CARRY","crry_prtial",4.0,1,0,0,1,1,1);
			}

			new x = random(5);
			if(x == 0 || x == 1 || x == 2) {
				SetPlayerCheckpoint(playerid, 1271.8511, -1254.3572, 13.6028, 2.0);
			}
			if(x == 3 || x == 4 || x == 5) {
				SetPlayerCheckpoint(playerid, 1250.0131, -1256.7892, 13.6028, 2.0);
			}
			BuilderCP[playerid] = 2;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		}
	}
	else if(BuilderCP[playerid] == 2)
	{
		if(GetPlayerState(playerid) == 1){

			DisablePlayerCheckpoint(playerid);
			RemovePlayerAttachedObject(playerid,0);
			ClearAnimations(playerid);

			new x = random(3);
			if(x == 0) {
				SetPlayerCheckpoint(playerid, 1280.0118, -1262.7102, 13.5107, 2.0);
			}
			if(x == 1) {
				SetPlayerCheckpoint(playerid, 1280.9083, -1242.0677, 13.9160, 2.0);
			}
			if(x == 2 || x == 3) {
				SetPlayerCheckpoint(playerid, 1268.9485, -1234.4961, 17.0519, 2.0);
			}
			SetPlayerSpecialAction(playerid, 0);
			BuilderCP[playerid] = 1;

			new
				message[256],
				salar = 50 + random(100);

			format(message, sizeof(message), "ทำงานสำเร็จได้รับค่าจ้าง +$%d", salar);
			SendClientMessage(playerid, 0xFFFF00FF, message);
			GivePlayerMoneyEx(playerid, salar);
			GameTextForPlayer(playerid,sprintf("~g~ + %d", salar),1200,1);
		}
	}
	return 1;
}