
#include <YSI\y_hooks> // pawn-lang/YSI-Includes

// DEALERSHIP MENU
#define MAX_PLAYER_VEHICLES 					1000
#define MAX_OWNED_CAR							10
#define MAX_CAR_WEAPONS 						4
#define	GetPlayerMaxCar(%0)	\
	MAX_OWNED_CAR - (5 - playerData[%0][pVehiclePerks])

static const VehicleMenuInfo[][] = {
"Airplanes",
//"Helicopters",
"Bikes",
"Convertibles",
"Industrial",
"Low Riders",
"Off Road",
"Saloons",
"Sports Vehicles",
"Station Wagons",
"Boats",
"Unique",
"Public Service"
};

static const Float:gBoatSpawn[10][4] = {
	{-1495.6782,1238.7279,-0.6146,118.1733},
	{-1495.0085,1231.6622,-0.2827,118.8561},
	{-1495.6500,1221.5901,-0.1711,125.7470},
	{-1488.1564,1218.9563,-0.1535,137.8345},
	{-1473.6696,1219.8805,-0.1352,125.5188},
	{-1471.0453,1210.3572,-0.3040,120.4972},
	{-1473.0374,1201.1227,-0.4537,124.7051},
	{-1473.4886,1190.9384,-0.1215,123.8931},
	{-1494.3619,1180.1519,-0.4160,59.8059},
	{-1481.7158,1169.7886,-0.1717,85.5702}
};

static const Float:gPlaneSpawn[7][4] = {
	{1967.3853,-2353.3643,13.2739,175.6344},
	{1958.5817,-2354.0073,13.2740,177.8390},
	{1949.9326,-2355.0310,13.2740,181.0763},
	{1942.8993,-2355.4915,13.2740,182.4527},
	{1991.0426,-2375.4526,13.2740,83.3619},
	{1990.3270,-2385.2410,13.2740,85.7914},
	{1989.7825,-2393.8977,13.2740,84.5329}
};

static const Float:gCombineSpawn[34][4] = {
	{94.199996, -5.199999, 1.700000, 80.000000},
	{97.599609, 14.299810, 1.700000, 79.997001},
	{95.799812, 4.700200, 1.700000, 79.997001},
	{88.000000, -46.500000, 1.799999, 79.997001},
	{92.299812, -15.200189, 1.799999, 79.997001},
	{90.599609, -25.299800, 1.899999, 79.997001},
	{89.500000, -35.799800, 1.899999, 79.997001},
	{46.299999, -172.699996, 1.799999, 3.996999},
	{14.500000, -172.899993, 1.700000, 0.000000},
	{36.599609, -173.099609, 1.700000, 3.993999},
	{25.899999, -173.699996, 1.700000, 0.000000},
	{-7.800000, -170.199996, 2.299999, 352.000000},
	{2.599610, -171.599609, 1.700000, 351.996002},
	{-17.700000, -168.699996, 3.000000, 351.996002},
	{-27.600000, -167.399993, 3.599999, 351.996002},
	{-48.900001, -164.000000, 4.199999, 350.000000},
	{-38.500000, -165.799804, 4.199999, 349.997009},
	{-132.600006, -136.899993, 4.199999, 349.997009},
	{-156.600006, -132.899993, 4.199999, 349.997009},
	{-144.400390, -134.599609, 4.199999, 349.997009},
	{-168.600006, -130.899993, 4.199999, 349.997009},
	{-181.100006, -129.500000, 4.199999, 349.997009},
	{-192.899993, -127.900001, 4.199999, 349.997009},
	{-229.899993, -123.699996, 4.199999, 349.997009},
	{-205.000000, -127.099609, 4.199999, 349.997009},
	{-217.400390, -125.599609, 4.199999, 349.997009},
	{-83.500000, 180.000000, 4.000000, 160.000000},
	{-93.000000, 184.000000, 4.099999, 159.998992},
	{-111.599998, 192.000000, 5.400000, 165.998992},
	{-102.200202, 188.099609, 4.699999, 159.998992},
	{-121.500000, 195.199996, 6.400000, 165.992004},
	{-141.699996, 200.899993, 8.800000, 169.992004},
	{-131.400390, 198.099609, 7.599999, 165.992004},
	{-151.500000, 202.800003, 10.000000, 169.990997}
};

new const Float:gVehicleSpawn_LS[120][4] = {
	{1616.900024, -1137.099975, 23.899999, 90.000000},
	{1616.800048, -1132.599975, 23.899999, 90.000000},
	{1616.800048, -1128.199951, 23.899999, 90.000000},
	{1616.699951, -1123.699951, 23.899999, 90.000000},
	{1616.599975, -1119.400024, 23.899999, 90.000000},
	{1630.099975, -1107.500000, 23.899999, 90.000000},
	{1630.099975, -1102.800048, 23.899999, 90.000000},
	{1629.800048, -1098.300048, 23.899999, 90.000000},
	{1629.800048, -1093.900024, 23.899999, 90.000000},
	{1629.699951, -1089.599975, 23.899999, 90.000000},
	{1629.599975, -1085.099975, 23.899999, 90.000000},
	{1657.699951, -1111.599975, 23.899999, 90.000000},
	{1658.000000, -1107.000000, 23.899999, 90.000000},
	{1658.000000, -1102.500000, 23.899999, 90.000000},
	{1657.900024, -1098.099975, 23.899999, 90.000000},
	{1657.800048, -1093.599975, 23.899999, 90.000000},
	{1657.800048, -1089.000000, 23.899999, 90.000000},
	{1658.000000, -1084.500000, 23.899999, 90.000000},
	{1658.099975, -1080.099975, 23.899999, 90.000000},
	{1621.099975, -1107.400024, 23.899999, 270.00000},
	{1621.199951, -1103.099975, 23.899999, 270.00000},
	{1621.300048, -1098.599975, 23.899999, 270.00000},
	{1621.300048, -1094.099975, 23.899999, 270.00000},
	{1621.300048, -1089.699951, 23.899999, 270.00000},
	{1621.300048, -1085.199951, 23.899999, 270.00000},
	{1649.199951, -1111.599975, 23.899999, 270.00000},
	{1649.599975, -1107.000000, 23.899999, 270.00000},
	{1649.699951, -1102.599975, 23.899999, 270.00000},
	{1649.699951, -1098.000000, 23.899999, 270.00000},
	{1649.699951, -1093.699951, 23.899999, 270.00000},
	{1649.700195, -1089.099609, 23.899999, 270.00000},
	{1649.700195, -1084.799804, 23.899999, 270.00000},
	{1649.699951, -1080.300048, 23.899999, 270.00000},
	{1675.599975, -1097.800048, 23.899999, 270.00000},
	{1675.599975, -1102.500000, 23.899999, 270.00000},
	{1675.500000, -1106.900024, 23.899999, 270.00000},
	{1675.400024, -1111.300048, 23.899999, 270.00000},
	{1675.500000, -1115.900024, 23.899999, 270.00000},
	{1675.500000, -1120.199951, 23.899999, 270.00000},
	{1675.500000, -1124.699951, 23.899999, 270.00000},
	{1675.500000, -1129.099975, 23.899999, 270.00000},
	{1666.199951, -1135.400024, 23.899999, 180.00000},
	{1661.599975, -1135.800048, 23.899999, 180.00000},
	{1657.400024, -1135.800048, 23.899999, 180.00000},
	{1652.900024, -1135.800048, 23.899999, 180.00000},
	{1648.400024, -1135.800048, 23.899999, 180.00000},
	{1793.400024, -1060.900024, 24.000000, 180.00000},
	{1788.800048, -1061.099975, 24.000000, 180.00000},
	{1784.500000, -1060.900024, 24.000000, 180.00000},
	{1779.800048, -1061.300048, 24.000000, 180.00000},
	{1775.400024, -1061.199951, 24.000000, 180.00000},
	{1771.000000, -1061.199951, 24.000000, 180.00000},
	{1766.599975, -1061.099975, 24.000000, 180.00000},
	{1761.699951, -1061.300048, 24.000000, 180.00000},
	{1722.699951, -1060.599975, 24.000000, 180.00000},
	{1718.099975, -1060.500000, 24.000000, 180.00000},
	{1714.000000, -1060.500000, 24.000000, 180.00000},
	{1709.000000, -1060.500000, 24.000000, 180.00000},
	{1704.500000, -1060.500000, 24.000000, 180.00000},
	{1700.300048, -1060.599975, 24.000000, 180.00000},
	{1696.000000, -1060.400024, 24.000000, 180.00000},
	{1691.400024, -1060.400024, 24.000000, 180.00000},
	{1680.900024, -1036.000000, 23.899999, 180.00000},
	{1685.400024, -1036.000000, 23.899999, 180.00000},
	{1689.800048, -1035.800048, 23.899999, 180.00000},
	{1694.400024, -1035.900024, 23.899999, 180.00000},
	{1698.699951, -1035.699951, 23.899999, 180.00000},
	{1703.300048, -1035.599975, 23.899999, 180.00000},
	{1707.699951, -1035.599975, 24.000000, 180.00000},
	{1712.300048, -1035.000000, 23.899999, 180.00000},
	{1757.199951, -1037.800048, 24.000000, 180.00000},
	{1761.599975, -1038.199951, 24.000000, 180.00000},
	{1752.900024, -1037.699951, 24.000000, 180.00000},
	{1748.699951, -1038.000000, 24.000000, 180.00000},
	{1744.199951, -1037.900024, 24.000000, 180.00000},
	{1691.400024, -1070.000000, 23.899999, 0.000000},
	{1695.699951, -1069.900024, 23.899999, 0.000000},
	{1704.800048, -1069.699951, 23.899999, 0.000000},
	{1700.200195, -1069.799804, 23.899999, 0.000000},
	{1709.300048, -1069.699951, 23.899999, 0.000000},
	{1718.199951, -1069.500000, 23.899999, 0.000000},
	{1713.700195, -1069.500000, 23.899999, 0.000000},
	{1722.500000, -1069.400024, 23.899999, 0.000000},
	{1681.199951, -1044.300048, 23.899999, 0.000000},
	{1685.699951, -1044.300048, 23.899999, 0.000000},
	{1690.000000, -1044.300048, 23.899999, 0.000000},
	{1694.599975, -1044.000000, 23.899999, 0.000000},
	{1698.900024, -1044.099975, 23.899999, 0.000000},
	{1703.400024, -1044.300048, 23.899999, 0.000000},
	{1708.099975, -1044.300048, 23.899999, 0.000000},
	{1712.699951, -1044.199951, 23.899999, 0.000000},
	{1744.099975, -1046.000000, 23.899999, 0.000000},
	{1748.400024, -1045.900024, 23.899999, 0.000000},
	{1752.800048, -1046.199951, 23.899999, 0.000000},
	{1757.500000, -1046.000000, 23.899999, 0.000000},
	{1761.599975, -1046.000000, 23.899999, 0.000000},
	{1762.099975, -1069.699951, 23.899999, 0.000000},
	{1766.699951, -1069.800048, 23.899999, 0.000000},
	{1771.199951, -1069.800048, 23.899999, 0.000000},
	{1775.300048, -1070.000000, 23.899999, 0.000000},
	{1780.000000, -1070.000000, 23.899999, 0.000000},
	{1784.400024, -1069.900024, 23.899999, 0.000000},
	{1788.800048, -1069.800048, 23.899999, 0.000000},
	{1793.199951, -1069.699951, 23.899999, 0.000000},
	{1658.699951, -1046.400024, 23.899999, 0.000000},
	{1654.199951, -1046.500000, 23.899999, 0.000000},
	{1649.599975, -1046.300048, 23.899999, 0.000000},
	{1644.900024, -1046.400024, 23.899999, 0.000000},
	{1640.400024, -1046.300048, 23.899999, 0.000000},
	{1636.199951, -1046.400024, 23.899999, 0.000000},
	{1631.699951, -1046.400024, 23.899999, 0.000000},
	{1627.099975, -1046.400024, 23.899999, 0.000000},
	{1658.099975, -1038.099975, 23.899999, 180.00000},
	{1653.599975, -1038.300048, 23.899999, 180.00000},
	{1649.000000, -1038.300048, 23.899999, 180.00000},
	{1644.599975, -1038.199951, 23.899999, 180.00000},
	{1640.000000, -1038.300048, 23.899999, 180.00000},
	{1635.599975, -1038.199951, 23.899999, 180.00000},
	{1631.099975, -1038.300048, 23.899999, 180.00000},
	{1626.699951, -1038.300048, 23.899999, 180.00000}
};

static const Float:gVehicleSpawn_SF[80][4] = {
	{-1792.8423,1294.5204,31.5566,177.1424},
	{-1798.7659,1294.9082,31.5559,175.9193},
	{-1804.8795,1295.4927,31.5564,175.4453},
	{-1811.3861,1294.0110,31.5562,185.4265},
	{-1817.2927,1294.0519,31.5562,186.2850},
	{-1824.5895,1293.0269,31.5636,200.5562},
	{-1829.6372,1290.6810,31.5639,197.8435},
	{-1835.6067,1289.0339,31.5635,200.5853},
	{-1852.8060,1299.8333,31.5563,18.9691},
	{-1847.1248,1301.7386,31.5564,19.9770},
	{-1841.5732,1303.7854,31.5569,19.8088},
	{-1835.9496,1305.6962,31.5572,20.4763},
	{-1830.4480,1307.6539,31.5639,20.4236},
	{-1821.9922,1309.2097,31.5568,6.2523},
	{-1816.3220,1310.1682,31.5564,4.6745},
	{-1810.3065,1310.5624,31.5567,4.8164},
	{-1802.8400,1310.7505,31.5564,355.5667},
	{-1797.0708,1310.7784,31.5564,356.9339},
	{-1791.1056,1311.4725,31.5560,356.3880},
	{-1785.1771,1310.2297,31.5562,357.0287},
	{-1779.3411,1310.2749,31.5567,357.5276},
	{-1793.0762,1293.9033,40.8534,177.7422},
	{-1799.0292,1294.8306,40.8535,176.8054},
	{-1804.8009,1294.8806,40.8537,174.2439},
	{-1811.6407,1294.9310,40.8530,184.7103},
	{-1817.3127,1294.4938,40.8529,182.6869},
	{-1825.0001,1293.7981,40.8474,197.7019},
	{-1830.5341,1290.9535,40.8471,202.0612},
	{-1835.7434,1289.2416,40.8469,198.4778},
	{-1852.3353,1299.8718,40.8540,19.6348},
	{-1847.1464,1302.2477,40.8530,21.3209},
	{-1841.6847,1303.7744,40.8530,19.8884},
	{-1835.7576,1305.6082,40.8514,18.2393},
	{-1830.6476,1307.9167,40.8468,19.7741},
	{-1821.9910,1309.7915,40.8531,6.6074},
	{-1816.3555,1309.7721,40.8534,5.5716},
	{-1810.2461,1311.5629,40.8531,7.2257},
	{-1802.8556,1311.1746,40.8533,355.5678},
	{-1796.7968,1311.2422,40.8527,358.0378},
	{-1790.8535,1310.9872,40.8535,357.8341},
	{-1785.1261,1310.2126,40.8537,356.4741},
	{-1779.4395,1309.6514,40.8538,355.9227},
	{-1792.9474,1294.1743,50.1500,174.5812},
	{-1799.1083,1294.2753,50.1499,175.9974},
	{-1804.7286,1295.0374,50.1502,174.6021},
	{-1811.7467,1294.7831,50.1510,186.0877},
	{-1817.4685,1294.4518,50.1502,183.4467},
	{-1824.6028,1292.7346,50.1462,199.7023},
	{-1829.7689,1289.9720,50.1460,199.0592},
	{-1835.3884,1288.0886,50.1458,199.3936},
	{-1852.7753,1300.4247,50.1497,19.7770},
	{-1847.5255,1302.0712,50.1501,17.8101},
	{-1841.7070,1304.3636,50.1500,18.8812},
	{-1835.9812,1306.2762,50.1502,20.2607},
	{-1830.3846,1308.4648,50.1465,19.4495},
	{-1822.0721,1310.2562,50.1499,6.9975},
	{-1816.4026,1310.1705,50.1504,3.9984},
	{-1810.3650,1311.6672,50.1500,5.0055},
	{-1802.9150,1311.7799,50.1500,356.5376},
	{-1796.9899,1311.4434,50.1498,354.9245},
	{-1790.9338,1310.7834,50.1503,358.0331},
	{-1784.9236,1309.7318,50.1509,357.9450},
	{-1778.9626,1309.9692,50.1498,358.1735},
	{-1793.1212,1293.9447,59.4395,176.3010},
	{-1799.0804,1293.4730,59.4390,176.3646},
	{-1804.7994,1294.8492,59.4395,175.4949},
	{-1811.4850,1295.1851,59.4400,183.5219},
	{-1817.4128,1293.7687,59.4392,185.8854},
	{-1824.3931,1292.0634,59.4372,200.4148},
	{-1830.0406,1290.7820,59.4375,200.3896},
	{-1835.4709,1287.7101,59.4372,199.9491},
	{-1841.9104,1304.6781,59.4385,20.8020},
	{-1836.0876,1306.2334,59.4389,20.6667},
	{-1830.7523,1308.3754,59.4378,21.0901},
	{-1822.1603,1310.8910,59.4389,5.2038},
	{-1815.9630,1310.9122,59.4401,6.5548},
	{-1810.6741,1310.9984,59.4388,4.3359},
	{-1802.8700,1311.5022,59.4394,356.6218},
	{-1796.8016,1310.5000,59.4401,359.1259},
	{-1791.0942,1311.1445,59.4385,355.9040}
};

static const VehicleDealership[][] = {
{511, 0},
{593, 0},

/*{417, 1},
{487, 1},
{488, 1},*/

{462, 1},
{463, 1},
{468, 1},
{471, 1},
{481, 1},
{509, 1},
{521, 1},
{586, 1},

{480, 2},
{533, 2},
{555, 2},

{408, 3},
{413, 3},
{414, 3},
{422, 3},
{440, 3},
{443, 3},
{455, 3},
{456, 3},
{459, 3},
{478, 3},
{482, 3},
{498, 3}, // ... 609
{499, 3},
{514, 3},
{515, 3},
{543, 3}, // ...605
{554, 3},
{578, 3},
{582, 3},
{600, 3},

{412, 4},
{439, 4},
{534, 4},
{535, 4},
{536, 4},
{566, 4},
{567, 4},
{575, 4},
{576, 4},

{400, 5},
{489, 5},
{500, 5},
{579, 5},

{401, 6},
{405, 6},
{410, 6},
{419, 6},
{421, 6},
{426, 6},
{436, 6},
{445, 6},
{466, 6}, //... 604
{467, 6},
{474, 6},
{491, 6},
{492, 6},
{507, 6},
{516, 6},
{517, 6},
{518, 6},
{526, 6},
{527, 6},
{529, 6},
{540, 6},
{542, 6},
{546, 6},
{547, 6},
{549, 6},
{550, 6},
{551, 6},
{560, 6},
{562, 6},
{580, 6},
{585, 6},

{402, 7},
{415, 7},
{429, 7},
{475, 7},
{477, 7},
{496, 7},
{541, 7},
{558, 7},
{559, 7},
{565, 7},
{587, 7},
{589, 7},
{602, 7},
{603, 7},

{404, 8},
{418, 8},
{458, 8},
{479, 8},
{561, 8},

{446, 9},
{453, 9},
{454, 9},
{472, 9},
{473, 9},
{484, 9},

{409, 10},
{423, 10},
{483, 10},
{508, 10},
{525, 10},
{532, 10},
{545, 10},
{588, 10},

{420, 11},
{431, 11},
{437, 11},
{438, 11}

};

enum E_UPGRADE_INFO
{
    u_price,
    Float:u_rate,
}

new const VehicleUpgradeLock[][E_UPGRADE_INFO] = {
{4000, 75.0},
{6000, 50.0},
{8000, 37.5},
{10000, 30.0}
};

new const VehicleUpgradeImmob[][E_UPGRADE_INFO] = {
{5000, 150.0},
{10000, 75.0},
{15000, 50.0},
{20000, 37.5}
};

new const VehicleUpgradeAlarm[][E_UPGRADE_INFO] = {
{2000, 150.0},
{4000, 75.0},
{5000, 50.0},
{8000, 37.5}
};

new 
    VDealerColor1[MAX_PLAYERS], 
    VDealerColor2[MAX_PLAYERS], 
    VDealerVehicle[MAX_PLAYERS], 
    VDealerLock[MAX_PLAYERS], 
    VDealerImmob[MAX_PLAYERS], 
    VDealerAlarm[MAX_PLAYERS], 
    VDealerPrice[MAX_PLAYERS], 
    bool:VDealerSetting[MAX_PLAYERS char],
	bool:VDealerFaction[MAX_PLAYERS char];

new Iterator:Iter_PlayerCar<MAX_PLAYER_VEHICLES>;

enum E_PLAYER_CAR_DATA 
{
	carSID,
	carVehicle,
	carModel,
	carOwner,
	Float:carPos[4],
	carColor1,
	carColor2,
	carPaintjob,
	bool:carLocked,
	carMods[14],
	Float:carFuel,
	carLock,
	carAlarm,
	carDonate,
	carInsurance,
	carOwe,
    carDamage[4],
	Float:carHealth,
	carDestroyed,
	carComp,
	Float:carMileage,
	carImmob,
	Float:carBatteryL,
	Float:carEngineL,
	carPlate[32],
	carDupKey,
	carWorld,
	carInt,
	bool:carDespawn,
	carProtect,

	carWeapon[MAX_CAR_WEAPONS],
	carAmmo[MAX_CAR_WEAPONS]
};

new playerCarData[MAX_PLAYER_VEHICLES][E_PLAYER_CAR_DATA];

enum E_CAR_LIST_DATA 
{
	CLD_ID,
	CLD_Model,
	Float:CLD_Pos_X,
	Float:CLD_Pos_Y,
	Float:CLD_Pos_Z
}

new playerCarList[MAX_PLAYERS][MAX_OWNED_CAR][E_CAR_LIST_DATA];

hook OnPlayerConnect(playerid) {

    VDealerSetting{playerid} = false;
	VDealerFaction{playerid}=false;

    VDealerColor1[playerid]=
    VDealerColor2[playerid] = -1; 

    VDealerLock[playerid]=
    VDealerImmob[playerid]=
    VDealerAlarm[playerid]=
    VDealerPrice[playerid]=0;

	for (new i = 0; i != MAX_OWNED_CAR; i ++)
	{
		playerCarList[playerid][i][CLD_ID] =
		playerCarList[playerid][i][CLD_Model] = 0;
		playerCarList[playerid][i][CLD_Pos_X] = 
		playerCarList[playerid][i][CLD_Pos_Y] = 
		playerCarList[playerid][i][CLD_Pos_Z] = 0.0;
	}

	return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
	if(Iter_Contains(Iter_PlayerCar, playerData[playerid][pPCarkey])) {
		playerCarData[playerData[playerid][pPCarkey]][carDespawn]=true;
	}
	ExitSettingVehicle(playerid);
	playerData[playerid][pPCarkey] = -1;
	return 1;
}

GetNumberOwnerCar(playerid)
{
	new count;
	for(new i = 0; i != MAX_OWNED_CAR; i++) {
		if (playerCarList[playerid][i][CLD_ID]) {
			count++;
		}
	}
	return count;
}

ShowPlayerCarMenu(playerid) {
	new str[600], count, bool:near;
	for(new i = 0; i != MAX_OWNED_CAR; i++) {
		if (playerCarList[playerid][i][CLD_ID]) {

			if(IsPlayerInRangeOfPoint(playerid, 200.0, playerCarList[playerid][i][CLD_Pos_X], playerCarList[playerid][i][CLD_Pos_Y], playerCarList[playerid][i][CLD_Pos_Z]))
				near = true;

			strcat(str, sprintf("(%d): %s %s\n", count + 1, ReturnVehicleModelName(playerCarList[playerid][i][CLD_Model]), near ? ("(อยู่ใกล้คุณ)") : ("")));
			SetPVarInt(playerid, sprintf("CarMenuSelect_%d", count), playerCarList[playerid][i][CLD_ID]);
			near = false;
			count++;
		}
	}
	Dialog_Show(playerid, DialogPlayerCarMenu, DIALOG_STYLE_LIST, sprintf("รถยนต์ทั้งหมด: %d/%d", count, GetPlayerMaxCar(playerid)), str, "เรียก", "ปิด");
	return 1;
}

Dialog:DialogPlayerCarMenu(playerid, response, listitem, inputtext[]) {
	if (response) {
		new carid = GetPVarInt(playerid, sprintf("CarMenuSelect_%d", listitem));
		if (carid) {
			SpawnPlayerCar(playerid, carid);
		}
		else {
			SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่สามารถเรียกยานพาหนะส่วนตัวได้ในขณะนี้");
		}
	}
	return 1;
}

IsPlayerInOwnedCar(playerid, vehicleid) {
	return (Iter_Contains(Iter_PlayerCar, playerData[playerid][pPCarkey]) && playerCarData[playerData[playerid][pPCarkey]][carVehicle] == vehicleid && playerCarData[playerData[playerid][pPCarkey]][carOwner] == playerData[playerid][pSID]);
}

alias:vehicle("v");
CMD:vehicle(playerid, params[])
{
	new
	    option[10],
		upgrade[24], 
		level, 
		confirm[5];

    if(gIsDeathMode{playerid} || gIsInjuredMode{playerid} || BitFlag_Get(gPlayerBitFlag[playerid],IS_CUFFED))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถใช้โทรศัพท์ได้ในขณะนี้");

	if (sscanf(params, "s[10]S()[24]D(0)S()[5]", option, upgrade, level, confirm))
 	{
 	    SendClientMessage(playerid, COLOR_YELLOW3, "___________________________________________________________");
	 	SendClientMessage(playerid, COLOR_YELLOW3, "การใช้: /(v)ehicle [การกระทำ]");
	    SendClientMessage(playerid, COLOR_YELLOW3, "[การกระทำ] get (เรียก), park (จอด), sell (ขาย), upgrade (อัพเกรด), insurance (จ่ายค่าปรับ)");
        SendClientMessage(playerid, COLOR_YELLOW3, "[การกระทำ] stats (สถิติ), tow (ส่งรถกลับจุดจอด $2,000), dupkey (ให้กุญแจสำรองคนอื่น), find (ค้นหารถ), buypark (ซื้อที่จอดใหม่)");
        SendClientMessage(playerid, COLOR_YELLOW3, "[ลบทิ้ง] scrap (คำเตือน: ยานพาหนะของคุณจะถูกลบอย่างสมบูรณ์)");
        // SendClientMessage(playerid, COLOR_YELLOW3, "[Hint] มีคำแนะนำวิธีใช้การปฏิบัติเหล่านี้ทั้งหมดที่ forum.ls-rp.co.th");
		SendClientMessage(playerid, COLOR_YELLOW3, "___________________________________________________________");
		return 1;
	}

	if (isequal(option, "list", true) || isequal(option, "get", true))
	{
		if(GetNumberOwnerCar(playerid)) ShowPlayerCarMenu(playerid);
		else SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่มียานพาหนะที่เป็นเจ้าของ");
	}
	else if (isequal(option, "scrap", true))
	{
		new vehicleid = GetPlayerVehicleID(playerid);
	    if(IsPlayerInOwnedCar(playerid, vehicleid)) {
	        new scrap_price = GetVehicleDataScrap(GetVehicleModel(vehicleid));
			
	        if(scrap_price)
	        {
				if (playerCarData[playerData[playerid][pPCarkey]][carDonate] == 1) {
					scrap_price = 0;
				}

				if(isequal(upgrade, "yes", true))
				{
					new query[128];
					format(query, sizeof(query), "DELETE FROM `cars` WHERE `carID` = '%d'", playerCarData[playerData[playerid][pPCarkey]][carSID]);
					mysql_tquery(dbCon, query, "OnPlayerVehicleScrap", "dd", playerid, scrap_price);
			    }
			    else
			    {
			 	    SendClientMessage(playerid, COLOR_YELLOW3, "SERVER: คุณได้เลือกที่จะทำให้ยานพาหนะเป็นเศษซาก");
				 	SendClientMessageEx(playerid, COLOR_YELLOW3, "SERVER: คุณจะได้รับแค่ %s จากการทำให้เป็นเศษซาก", FormatNumber(scrap_price));
				    SendClientMessage(playerid, COLOR_YELLOW3, "SERVER: เมื่อคุณทำลายให้เป็นเศษซาก ยานพาหนะนั้นจะถูกลบออกจากที่มีอยู่");
			        SendClientMessage(playerid, COLOR_YELLOW3, "การใช้: /(v)ehicle scrap yes");
			    }
		    }
		    else SendClientMessage(playerid, COLOR_LIGHTRED, "โปรดติดต่อผู้ดูแลระบบ เนื่องจากราคาต่ำกว่า $1");
	    }
	    else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่บนยานพาหนะที่ถูกเรียก");
	}
	else if (isequal(option, "find", true)) {
		if(Iter_Contains(Iter_PlayerCar, playerData[playerid][pPCarkey])) {
			new vehicleid = playerCarData[playerData[playerid][pPCarkey]][carVehicle];
			if(GetVehicleDriver(vehicleid) == INVALID_PLAYER_ID && !VehicleLabel_GetTime(vehicleid)) {
			    new Float:vehDistance[3];
			    GetVehiclePos(vehicleid, vehDistance[0], vehDistance[1], vehDistance[2]);
				SetPlayerCheckpoint(playerid,vehDistance[0], vehDistance[1], vehDistance[2], 4.0);
				gPlayerCheckpoint{playerid} = true;
			} else SendClientMessage(playerid, COLOR_LIGHTRED, "มีใครบางคนอยู่ในรถของคุณ เราไม่สามารถค้นหามันได้!");
		} else SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่มียานพาหนะที่ถูกเรียกในปัจจุบัน");
	}
	else if (isequal(option, "tow", true)) {
		if(Iter_Contains(Iter_PlayerCar, playerData[playerid][pPCarkey])) {
			new vehicleid = playerCarData[playerData[playerid][pPCarkey]][carVehicle];

		 	if(GetPlayerMoney(playerid) < 2000)
				return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอ ($2,000) !");

            new model = GetVehicleModel(vehicleid);

			//foreach (new i : Player) if(IsVehicleStreamedIn(vehicleid, i)) streamin++;

            if(gIsDeathMode{playerid} || gIsInjuredMode{playerid})
                return SendClientMessage(playerid, COLOR_GRAD1, "   ไม่สามารถใช้ได้ในขณะนี้ (คุณกำลังบาดเจ็บ/ตาย)");
            
			if(GetVehicleDriver(vehicleid) == INVALID_PLAYER_ID)
			{
			    if(!VehicleLabel_GetTime(vehicleid))
			    {
	                SetVehicleLabel(vehicleid, VLT_TYPE_TOWING, 15);
					SendClientMessage(playerid, COLOR_GREEN, "ยานพาหนะกำลังถูกลาก");
					GivePlayerMoneyEx(playerid, -2000);
					vehicleData[vehicleid][vOwnerID] = playerid;
				}
				else SendClientMessage(playerid, COLOR_LIGHTRED, "ยานพาหนะปัจจุบันได้เริ่มดำเนินการแล้ว");
			}
			else SendClientMessageEx(playerid, COLOR_LIGHTRED, "%s ได้ถูกใช้ / ขโมย อยู่ในขณะนี้", ReturnVehicleModelName(model));
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่มียานพาหนะที่ถูกเรียกในปัจจุบัน");
	}
	else if (isequal(option, "stats", true)) {
		new vehicleid = GetPlayerVehicleID(playerid);
	    if(IsPlayerInOwnedCar(playerid, vehicleid)) {
			SendClientMessageEx(playerid, COLOR_WHITE, "อายุการใช้งาน: เครื่องยนต์[%.2f] แบตเตอรี่[%.2f] ไมล์ที่ขับ[%.2f]", playerCarData[playerData[playerid][pPCarkey]][carEngineL], playerCarData[playerData[playerid][pPCarkey]][carBatteryL], playerCarData[playerData[playerid][pPCarkey]][carMileage]);
	    	SendClientMessageEx(playerid, COLOR_WHITE, "ความปลอดภัย: ล็อก[%d] สัญญาณเตือนภัย[%d] อิมโมบิไลเซอร์[%d] ประกันภัย[%d]", playerCarData[playerData[playerid][pPCarkey]][carLock], playerCarData[playerData[playerid][pPCarkey]][carAlarm], playerCarData[playerData[playerid][pPCarkey]][carImmob], playerCarData[playerData[playerid][pPCarkey]][carInsurance]);
			SendClientMessageEx(playerid, COLOR_WHITE, "อื่น ๆ: สีหลัก[{%06x}#%d"EMBED_WHITE"] สีรอง[{%06x}#%d"EMBED_WHITE"] ป้ายทะเบียน[%s]", g_arrCarColors[playerCarData[playerData[playerid][pPCarkey]][carColor1]] >>> 8, playerCarData[playerData[playerid][pPCarkey]][carColor1], g_arrCarColors[playerCarData[playerData[playerid][pPCarkey]][carColor2]] >>> 8, playerCarData[playerData[playerid][pPCarkey]][carColor2], playerCarData[playerData[playerid][pPCarkey]][carPlate]);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ในยานพาหนะของคุณ");
	}
	else if (isequal(option, "dupkey", true)) {
		new vehicleid = GetPlayerVehicleID(playerid);
	    if(IsPlayerInOwnedCar(playerid, vehicleid)) {

			if(GetPlayerMoney(playerid) < 500)
				return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอ ($500) !");

			new userid;

			if (sscanf(upgrade, "u", userid))
				return SendClientMessage(playerid, COLOR_YELLOW3, "การใช้: /(v)ehicle dupkey [ไอดีผู้เล่น/ชื่อบางส่วน]");

			if (userid == playerid)
				return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถเสนอให้ตัวเองได้!");

			if(userid == INVALID_PLAYER_ID)
				return SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่ใกล้พอ!");

			if (!IsPlayerNearPlayer(playerid, userid, 5.0))
			    return SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่ใกล้พอ!");

	        SendNearbyMessage(playerid, 30.0, COLOR_GREEN, "* %s ได้ให้ชุดกุญแจสำรองของ %s ให้กับ %s", ReturnRealName(playerid), g_arrVehicleNames[playerCarData[playerData[playerid][pPCarkey]][carModel] - 400], ReturnRealName(userid));
            playerData[userid][pPDupkey] = playerCarData[playerData[playerid][pPCarkey]][carDupKey];
			GivePlayerMoneyEx(playerid, -500);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ในยานพาหนะของคุณ");
	}
	else if (isequal(option, "insurance", true)) {
		
		if (IsPlayerAtDealership(playerid) != -1)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
		    if(IsPlayerInOwnedCar(playerid, vehicleid))
		    {
				if(playerCarData[playerData[playerid][pPCarkey]][carOwe] <= 0) {
					SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่มีค่าปรับค้างชำระอยู่ในปัจจุบัน");
					return 1;
				}
				if(isequal(upgrade, "pay", true))
				{
					if(GetPlayerMoney(playerid) >= playerCarData[playerData[playerid][pPCarkey]][carOwe]) {
						SendClientMessageEx(playerid, COLOR_YELLOW, "INSURANCE: ขอบคุณสำหรับการชำระเงินจำนวน %s!", FormatNumber(playerCarData[playerData[playerid][pPCarkey]][carOwe]));
						GivePlayerMoneyEx(playerid, -playerCarData[playerData[playerid][pPCarkey]][carOwe]);
						playerCarData[playerData[playerid][pPCarkey]][carOwe]=0;
						OnAccountUpdate(playerid);
						PlayerCar_SaveID(playerData[playerid][pPCarkey]);
					}
					else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถจ่ายมันได้ขออถัยด้วย");
				}
				else {
					SendClientMessageEx(playerid, COLOR_YELLOW, "การดำเนินการนี้ต้องการ %s", FormatNumber(playerCarData[playerData[playerid][pPCarkey]][carOwe]));
					SendClientMessage(playerid, COLOR_YELLOW3, "การใช้: /(v)ehicle insurance "EMBED_YELLOW"pay");
				}
			} else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่บนยานพาหนะที่ถูกเรียก");
		} else SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่ตัวแทนจำหน่ายยานพาหนะ");
	}
	else if (isequal(option, "upgrade", true)) {
		
		if (IsPlayerAtDealership(playerid) != -1)
		{
			new vehicleid = GetPlayerVehicleID(playerid), model = GetVehicleModel(vehicleid);
		    if(IsPlayerInOwnedCar(playerid, vehicleid))
		    {
				if (isequal(upgrade, "lock", true)) {
					if(level > 0 && level < 5)
					{
						if(isequal(confirm, "yes", true))
					    {
							if(!VehicleLabel_GetTime(vehicleid))
							{
							 	SetVehicleLabel(vehicleid, VLT_TYPE_UPGRADELOCK, 10);
								vehicleData[vehicleid][vOwnerID] = playerid;
								vehicleData[vehicleid][vUpgradeID] = level;
							}
							else SendClientMessage(playerid, COLOR_LIGHTRED, "ยานพาหนะปัจจุบันได้เริ่มดำเนินการแล้ว");
					    }
					    else
					    {
					        SendClientMessageEx(playerid, COLOR_YELLOW, "การดำเนินการนี้ต้องการ %s", FormatNumber(floatround(GetVehiclePrice(model) / VehicleUpgradeLock[level-1][u_rate]) + VehicleUpgradeLock[level-1][u_price]));
					        SendClientMessage(playerid, COLOR_YELLOW3, "การใช้: /(v)ehicle upgrade [อัพเกรด] [เลเวลอัพเกรด] "EMBED_YELLOW"yes");
					    }
					}
					else {
		                SendClientMessage(playerid, COLOR_YELLOW3, "การใช้: /(v)ehicle upgrade lock [เลเวลล็อก]");
		                SendClientMessageEx(playerid, COLOR_YELLOW3, "ระบบล็อคเลเวล 1 - {33AA33}%s", FormatNumber(floatround(GetVehiclePrice(model) / VehicleUpgradeLock[0][u_rate]) + VehicleUpgradeLock[0][u_price]));
		                SendClientMessageEx(playerid, COLOR_YELLOW3, "ระบบล็อคเลเวล 2 - {33AA33}%s", FormatNumber(floatround(GetVehiclePrice(model) / VehicleUpgradeLock[1][u_rate]) + VehicleUpgradeLock[1][u_price]));
		                SendClientMessageEx(playerid, COLOR_YELLOW3, "ระบบล็อคเลเวล 3 - {33AA33}%s", FormatNumber(floatround(GetVehiclePrice(model) / VehicleUpgradeLock[2][u_rate]) + VehicleUpgradeLock[2][u_price]));
		                SendClientMessageEx(playerid, COLOR_YELLOW3, "ระบบล็อคเลเวล 4 - {33AA33}%s", FormatNumber(floatround(GetVehiclePrice(model) / VehicleUpgradeLock[3][u_rate]) + VehicleUpgradeLock[3][u_price]));
					}
				} else if (isequal(upgrade, "alarm", true)) {
					if(level > 0 && level < 5)
					{
						if(isequal(confirm, "yes", true))
					    {
							if(!VehicleLabel_GetTime(vehicleid))
							{
							 	SetVehicleLabel(vehicleid, VLT_TYPE_UPGRADEALARM, 10);
								vehicleData[vehicleid][vOwnerID] = playerid;
								vehicleData[vehicleid][vUpgradeID] = level;
							}
							else SendClientMessage(playerid, COLOR_LIGHTRED, "ยานพาหนะปัจจุบันได้เริ่มดำเนินการแล้ว");
					    }
					    else
					    {
					        SendClientMessageEx(playerid, COLOR_YELLOW, "การดำเนินการนี้ต้องการ %s", FormatNumber(floatround(GetVehiclePrice(model) / VehicleUpgradeAlarm[level-1][u_rate]) + VehicleUpgradeAlarm[level-1][u_price]));
					        SendClientMessage(playerid, COLOR_YELLOW3, "การใช้: /(v)ehicle upgrade [อัพเกรด] [เลเวลอัพเกรด] "EMBED_YELLOW"yes");
					    }
					}
					else {
		                SendClientMessage(playerid, COLOR_YELLOW3, "การใช้: /(v)ehicle upgrade alarm [เลเวลเตือนภัย]");
		                SendClientMessageEx(playerid, COLOR_YELLOW3, "สัญญาณเตือนภัยเลเวล 1 - {33AA33}%s", FormatNumber(floatround(GetVehiclePrice(model) / VehicleUpgradeAlarm[0][u_rate]) + VehicleUpgradeAlarm[0][u_price]));
		                SendClientMessageEx(playerid, COLOR_YELLOW3, "สัญญาณเตือนภัยเลเวล 2 - {33AA33}%s", FormatNumber(floatround(GetVehiclePrice(model) / VehicleUpgradeAlarm[1][u_rate]) + VehicleUpgradeAlarm[1][u_price]));
		                SendClientMessageEx(playerid, COLOR_YELLOW3, "สัญญาณเตือนภัยเลเวล 3 - {33AA33}%s", FormatNumber(floatround(GetVehiclePrice(model) / VehicleUpgradeAlarm[2][u_rate]) + VehicleUpgradeAlarm[2][u_price]));
		                SendClientMessageEx(playerid, COLOR_YELLOW3, "สัญญาณเตือนภัยเลเวล 4 - {33AA33}%s", FormatNumber(floatround(GetVehiclePrice(model) / VehicleUpgradeAlarm[3][u_rate]) + VehicleUpgradeAlarm[3][u_price]));
					}
				} else if (isequal(upgrade, "immob", true)) {
					if(level > 0 && level < 5)
					{
						if(isequal(confirm, "yes", true))
					    {
							if(!VehicleLabel_GetTime(vehicleid))
							{
							 	SetVehicleLabel(vehicleid, VLT_TYPE_UPGRADEIMMOB, 10);
								vehicleData[vehicleid][vOwnerID] = playerid;
								vehicleData[vehicleid][vUpgradeID] = level;
							}
							else SendClientMessage(playerid, COLOR_LIGHTRED, "ยานพาหนะปัจจุบันได้เริ่มดำเนินการแล้ว");
					    }
					    else
					    {
					        SendClientMessageEx(playerid, COLOR_YELLOW, "การดำเนินการนี้ต้องการ %s", FormatNumber(floatround(GetVehiclePrice(model) / VehicleUpgradeImmob[level-1][u_rate]) + VehicleUpgradeImmob[level-1][u_price]));
					        SendClientMessage(playerid, COLOR_YELLOW3, "การใช้: /(v)ehicle upgrade [อัพเกรด] [เลเวลอัพเกรด] "EMBED_YELLOW"yes");
					    }
					}
					else {
		                SendClientMessage(playerid, COLOR_YELLOW3, "การใช้: /(v)ehicle upgrade immob [เลเวลอิมโมบิไลเซอร์]");
		                SendClientMessageEx(playerid, COLOR_YELLOW3, "อิมโมบิไลเซอร์เลเวล 1 - {33AA33}%s", FormatNumber(floatround(GetVehiclePrice(model) / VehicleUpgradeImmob[0][u_rate]) + VehicleUpgradeImmob[0][u_price]));
		                SendClientMessageEx(playerid, COLOR_YELLOW3, "อิมโมบิไลเซอร์เลเวล 2 - {33AA33}%s", FormatNumber(floatround(GetVehiclePrice(model) / VehicleUpgradeImmob[1][u_rate]) + VehicleUpgradeImmob[1][u_price]));
		                SendClientMessageEx(playerid, COLOR_YELLOW3, "อิมโมบิไลเซอร์เลเวล 3 - {33AA33}%s", FormatNumber(floatround(GetVehiclePrice(model) / VehicleUpgradeImmob[2][u_rate]) + VehicleUpgradeImmob[2][u_price]));
		                SendClientMessageEx(playerid, COLOR_YELLOW3, "อิมโมบิไลเซอร์เลเวล 4 - {33AA33}%s", FormatNumber(floatround(GetVehiclePrice(model) / VehicleUpgradeImmob[3][u_rate]) + VehicleUpgradeImmob[3][u_price]));
					}
				} else if (isequal(upgrade, "insurance", true)) {

					if(playerCarData[playerData[playerid][pPCarkey]][carOwe] > 0) {
						SendClientMessage(playerid, COLOR_LIGHTRED, "INSURANCE: การจ่ายค่าปรับประกันภัยของคุณยังไม่สำเร็จ");
						SendClientMessage(playerid, COLOR_LIGHTRED, "INSURANCE: เราไม่สามารถให้บริการนี้กับคุณได้จนกว่าจะชำระเงินเสร็จสมบูรณ์");
						SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: /v insurance pay (ขณะอยู่ในรถยนต์ ณ ตัวแทนจำหน่ายยานพาหนะ)");
						return 1;
					}

					if(level > 0 && level < 4)
					{
						if(isequal(confirm, "yes", true))
					    {
							if(!VehicleLabel_GetTime(vehicleid))
							{
							 	SetVehicleLabel(vehicleid, VLT_TYPE_UPGRADEINSURANCE, 10);
								vehicleData[vehicleid][vOwnerID] = playerid;
								vehicleData[vehicleid][vUpgradeID] = level;
							}
							else SendClientMessage(playerid, COLOR_LIGHTRED, "ยานพาหนะปัจจุบันได้เริ่มดำเนินการแล้ว");
					    }
					    else
					    {
					        SendClientMessageEx(playerid, COLOR_YELLOW, "การดำเนินการนี้ต้องการ %s", FormatNumber(((IsABike(vehicleid)) ? 1000 : 2500) * level));
							SendClientMessage(playerid, COLOR_YELLOW3, "การใช้: /(v)ehicle upgrade [upgrade] [upgrade-level] "EMBED_YELLOW"yes");
					    }
					}
					else
					{	
						SendClientMessage(playerid, COLOR_YELLOW3, "การใช้: /(v)ehicle upgrade insurance [เลเวลประกันภัย]");
						SendClientMessage(playerid, COLOR_YELLOW3, "ประกันชั้น 1: ปรากฏยานพาหนะด้วยเลือดสูงสุดทุกครั้ง");
						SendClientMessage(playerid, COLOR_YELLOW3, "ประกันชั้น 2: ป้องกันความเสียหายแบบ Cosmetic damage เมื่อยานพาหนะปรากฏอีกครั้งมันจะดีเหมือนใหม่");
						SendClientMessage(playerid, COLOR_YELLOW3, "ประกันชั้น 3: คุ้มครองการปรับแต่งยานพาหนะ เราจะเก็บเค้าโครงที่ปรับแต่งไว้");
					}
				}
				else {
					SendClientMessage(playerid, COLOR_YELLOW3, "การใช้: /(v)ehicle upgrade [อัพเกรด] [เลเวลอัพเกรด]");
	                SendClientMessage(playerid, COLOR_YELLOW3, "[อัพเกรด] lock, alarm, immob, insurance");
				}
		    }
		    else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่บนยานพาหนะที่ถูกเรียก");
		}
		else SendClientMessage(playerid, COLOR_GRAD1, "คุณไม่ได้อยู่ที่ตัวแทนจำหน่ายยานพาหนะ");
	}
	else if (isequal(option, "sell", true)) {

	    new vehicleid = GetPlayerVehicleID(playerid);
	    if(IsPlayerInOwnedCar(playerid, vehicleid) && IsPlayerInAnyVehicle(playerid))
	    {
			if(IsDonateCar(playerCarData[playerData[playerid][pPCarkey]][carModel]) || playerCarData[playerData[playerid][pPCarkey]][carDonate] == 1)
				return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถขายยานพาหนะบริจาคนี้ได้");

			new targetid = INVALID_PLAYER_ID, price;

			if(sscanf(params, "{s[10]}ud", targetid, price)) 
				return SendClientMessage(playerid, COLOR_YELLOW3, "การใช้: /(v)ehicle sell [ไอดีผู้เล่น/ชื่อบางส่วน] [ราคา]");

			if(targetid == INVALID_PLAYER_ID)
				return SendClientMessage(playerid, COLOR_LIGHTRED, "ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

			if(targetid == playerid)
				return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถเสนอให้ตัวเองได้!");

			if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
			    return SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่ใกล้พอ!");

			if(playerData[targetid][pPCarkey] != -1)
				return SendClientMessage(playerid, COLOR_LIGHTRED, "ผู้เล่นนั้นมียานพาหนะส่วนตัวที่ปรากฏอยู่!");

			if(GetNumberOwnerCar(targetid) >= GetPlayerMaxCar(targetid))
				return SendClientMessage(playerid, COLOR_LIGHTRED, "ผู้เล่นนั้นมียานพาหนะส่วนตัวถึงขีดจำกัดแล้ว!");

			if(price < 0)
				return SendClientMessage(playerid, COLOR_LIGHTRED, "ราคาไม่ถูกต้อง!");

			//SendClientMessage(playerid, COLOR_YELLOW, "SERVER: ข้อเสนอถูกส่ง");

			SetPVarInt(targetid, "CarOffer_PID", playerid);
			SetPVarInt(targetid, "CarOffer_CID", playerData[playerid][pPCarkey]);
			SetPVarInt(targetid, "CarOffer_PRICE", price);

			SendClientMessageEx(targetid, COLOR_GRAD1, "%s ได้เสนอที่จะขาย %s ของเขาในราคา %s พิมพ์ 'Y' เพื่อยอมรับ หรือ 'N' เพื่อปฏิเสธ", ReturnRealName(playerid), ReturnVehicleModelName(playerCarData[playerData[playerid][pPCarkey]][carModel]), FormatNumber(price));
			SendClientMessageEx(playerid, COLOR_GRAD1, "คุณได้เสนอที่จะขาย %s ในราคา %s ให้กับ %s", ReturnVehicleModelName(playerCarData[playerData[playerid][pPCarkey]][carModel]), FormatNumber(price), ReturnRealName(targetid));
			Mobile_GameTextForPlayer(targetid,sprintf("%s has offered to sell you their ~y~%s ~n~~w~for ~g~%s~n~~p~write ~g~Y~p~ to accept or ~r~N ~p~to deny.", ReturnRealName(playerid), ReturnVehicleModelName(playerCarData[playerData[playerid][pPCarkey]][carModel]), FormatNumber(price)), 5000, 5);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่ในยานพาหนะที่ถูกเรียก");
	}
	else if (isequal(option, "lights", true)) {
	    if (IsPlayerInAnyVehicle(playerid)) {

			new vehicleid = GetPlayerVehicleID(playerid);

			if (!IsEngineVehicle(vehicleid))
				return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้อยู่ในยานพาหนะ");

			if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ใช่คนขับ");

			switch (GetLightStatus(vehicleid))
			{
			    case false:
			    {
			        SetLightStatus(vehicleid, true);
			        Mobile_GameTextForPlayer(playerid, "~g~Lights On", 2000, 4);
				}
				case true:
				{
				    SetLightStatus(vehicleid, false);
				    Mobile_GameTextForPlayer(playerid, "~r~Lights Off", 2000, 4);
				}
			}

		} else SendClientMessage(playerid, COLOR_LIGHTRED, "   คุณไม่ได้อยู่ในยานพาหนะ");
	}
	else if (isequal(option, "buypark", true)) {
	    new vehicleid = GetPlayerVehicleID(playerid);
	    if(IsPlayerInOwnedCar(playerid, vehicleid) && IsPlayerInAnyVehicle(playerid))
	    {
	        new bool:housepark = false;

		    foreach(new i : Iter_House) {
				if(houseData[i][hOwned] != 0) {

					if(playerData[playerid][pHouseKey] == houseData[i][hID] || isequal(ReturnPlayerName(playerid), houseData[i][hOwner])) {
						if(IsPlayerInRangeOfPoint(playerid, 20.0, houseData[i][hPosX], houseData[i][hPosY], houseData[i][hPosZ]) && houseData[i][hOwned] != 0) {
							housepark = true;
							break;
						}
					}
				}
			}

	        if(GetPlayerMoney(playerid) < 5000 && !housepark)
				return SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอ ($5,000) !");

			mysql_query(dbCon, "SELECT carPosX, carPosY, carPosZ FROM `cars`");

			new
				Float:vehDistance[4],
				bool:checked = false
			;

			new rows;
			cache_get_row_count(rows);

			for (new i = 0; i < rows; i ++)
			{
				cache_get_value_index_float(i, 0,	vehDistance[0]);
				cache_get_value_index_float(i, 1,	vehDistance[1]);
				cache_get_value_index_float(i, 2,	vehDistance[2]);

			    if (IsPlayerInRangeOfPoint(playerid, 4.5, vehDistance[0], vehDistance[1], vehDistance[2])) {
					checked = true;
					break;
				}
			}

			if(!checked)
			{
			    GetVehiclePos(vehicleid, vehDistance[0], vehDistance[1], vehDistance[2]);
			    GetVehicleZAngle(vehicleid, vehDistance[3]);

                playerCarData[playerData[playerid][pPCarkey]][carPos][0]=vehDistance[0];
                playerCarData[playerData[playerid][pPCarkey]][carPos][1]=vehDistance[1];
                playerCarData[playerData[playerid][pPCarkey]][carPos][2]=vehDistance[2];
                playerCarData[playerData[playerid][pPCarkey]][carPos][3]=vehDistance[3];
                SaveVehicleDamage(vehicleid);
                PlayerCar_SaveID(playerData[playerid][pPCarkey]);
                PlayerCar_DespawnEx(playerData[playerid][pPCarkey]);
                playerData[playerid][pPCarkey] = -1;
                SendClientMessage(playerid, COLOR_GREEN, "ยานพาหนะถูกจอด");

	         	if(!housepark) {
				 	GivePlayerMoneyEx(playerid, -5000);
				}
			}
			else SendClientMessage(playerid, COLOR_LIGHTRED, "พื้นที่จอดรถตรงนี้ถูกใช้แล้ว");
		}
	    else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่บนยานพาหนะที่ถูกเรียก");
	}
	else if (isequal(option, "park", true)) {
	    new vehicleid = GetPlayerVehicleID(playerid);
	    if(IsPlayerInOwnedCar(playerid, vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	    {
		    if (IsPlayerInRangeOfPoint(playerid, 4.0, playerCarData[playerData[playerid][pPCarkey]][carPos][0], playerCarData[playerData[playerid][pPCarkey]][carPos][1], playerCarData[playerData[playerid][pPCarkey]][carPos][2])) {
				SaveVehicleDamage(playerData[playerid][pPCarkey]);
				PlayerCar_SaveID(playerData[playerid][pPCarkey], MYSQL_UPDATE_TYPE_SINGLE);
                PlayerCar_DespawnEx(playerData[playerid][pPCarkey]);
                playerData[playerid][pPCarkey] = -1;
                SendClientMessage(playerid, COLOR_GREEN, "ยานพาหนะถูกจอด");
		    }
		    else {
				SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ที่จอดของยานพาหนะคันนี้");
				SendClientMessage(playerid, TEAM_CUN_COLOR, "ไปตามเครื่องหมาย");
			    SetPlayerCheckpoint(playerid,playerCarData[playerData[playerid][pPCarkey]][carPos][0], playerCarData[playerData[playerid][pPCarkey]][carPos][1], playerCarData[playerData[playerid][pPCarkey]][carPos][2], 4.0);
				gPlayerCheckpoint{playerid} = true;
			}
	    }
	    else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่บนยานพาหนะที่ถูกเรียก");
	}
	else
	{
 	    SendClientMessage(playerid, COLOR_YELLOW3, "___________________________________________________________");
	 	SendClientMessage(playerid, COLOR_YELLOW3, "การใช้: /(v)ehicle [การกระทำ]");
	    SendClientMessage(playerid, COLOR_YELLOW3, "[การกระทำ] get (เรียก), park (จอด), sell (ขาย), upgrade (อัพเกรด), insurance (จ่ายค่าปรับ)");
        SendClientMessage(playerid, COLOR_YELLOW3, "[การกระทำ] stats (สถิติ), tow (ส่งรถกลับจุดจอด $2,000), dupkey (ให้กุญแจสำรองคนอื่น), find (ค้นหารถ), buypark (ซื้อที่จอดใหม่)");
        SendClientMessage(playerid, COLOR_YELLOW3, "[ลบทิ้ง] scrap (คำเตือน: ยานพาหนะของคุณจะถูกลบอย่างสมบูรณ์)");
        // SendClientMessage(playerid, COLOR_YELLOW3, "[Hint] มีคำแนะนำวิธีใช้การปฏิบัติเหล่านี้ทั้งหมดที่ forum.ls-rp.co.th");
		SendClientMessage(playerid, COLOR_YELLOW3, "___________________________________________________________");
	}
	return 1;
}

CMD:trunk(playerid, params[])
{
	new string[128];

	for (new i = 1; i != MAX_VEHICLES; i ++) if (IsPlayerNearBoot(playerid, i) || GetPlayerVehicleID(playerid) == i)
	{
	    if (!IsDoorVehicle(i))
	        return SendClientMessage(playerid, COLOR_LIGHTRED, "Error: "EMBED_WHITE"ยานพาหนะนี้ไม่มีฝากระโปรงหลังรถ");

		if(IsVehicleTrunkBroken(i))
		{
			SendClientMessage(playerid, COLOR_YELLOW, "(( กระโปรงหลังรถหลุดออกจากตัวถัง");
			SendClientMessage(playerid, COLOR_YELLOW, "(( ตราบใดที่มันเสีย/เปิดโล่ง จะได้รับสิทธิ์เพื่อเข้าถึง /takegun และ /place");
		    return 1;
		}

		if (GetLockStatus(i))
		    return SendClientMessage(playerid, COLOR_LIGHTRED, "Error: "EMBED_WHITE"ยานพาหนะล็อก");

	    if (!GetTrunkStatus(i))
		{
	        SetTrunkStatus(i, true);
	        SendClientMessage(playerid, COLOR_YELLOW, "คุณได้เปิดกระโปรงหลังรถ");
	        if(PlayerCar_GetID(i) != -1 && IsVehicleTrunk(i)) SendClientMessage(playerid, COLOR_WHITE, "คุณสามารถใช้ /place และ /takegun");

			format(string, sizeof(string), "* %s ได้เปิดฝากระโปรงหลังรถ %s", ReturnRealName(playerid), g_arrVehicleNames[GetVehicleModel(i) - 400]);
		 	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 6000);
		 	SendClientMessage(playerid, COLOR_PURPLE, string);

		} 
		else
		{
			SetTrunkStatus(i, false);
			SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ปิดกระโปรงหลังรถ");

			format(string, sizeof(string), "* %s ได้ปิดฝากระโปรงหลังรถ %s", ReturnRealName(playerid), g_arrVehicleNames[GetVehicleModel(i) - 400]);
		 	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 6000);
		 	SendClientMessage(playerid, COLOR_PURPLE, string);
		}
	    return 1;
	}
	SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องยืนอยู่ใกล้กระโปรงหลังรถหรือในรถ");

	return 1;
}

CMD:hood(playerid, params[])
{
	for (new i = 1; i != MAX_VEHICLES; i ++) if (IsPlayerNearHood(playerid, i) || GetPlayerVehicleID(playerid) == i)
	{
	    if (!IsDoorVehicle(i))
	        return SendClientMessage(playerid, COLOR_LIGHTRED, "รถคันนี้ไม่มีฝากระโปรงหน้ารถ");

		if (!GetEngineStatus(i))
		    return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณสามารถที่จะทำเช่นนี้ได้ก็ต่อเมื่อเครื่องยนต์ของยานพาหนะติดอยู่");

	    if (!GetHoodStatus(i))
		{
	        SetHoodStatus(i, true);

	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้เปิดฝากระโปรงหน้ารถ", ReturnPlayerName(playerid));
	        //GameTextForPlayer(playerid, "~g~Hood Opened", 2000, 4);
		}
		else
		{
			SetHoodStatus(i, false);

	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ได้ปิดฝากระโปรงหน้ารถ", ReturnPlayerName(playerid));
	        //GameTextForPlayer(playerid, "~r~Hood Closed", 2000, 4);
		}
	    return 1;
	}
	SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องยืนอยู่ใกล้กระโปรงหน้ารถหรือในรถ");
	return 1;
}

IsVehicleTrunk(vehicleid)
{
	new model = GetVehicleModel(vehicleid);
	switch(model)
	{
	    case 415,517,525,473,541,545,542,562,480,475,603,402,559,474,500,401,410,589,532,496,491,526,536,549,518,436: return 10;
	    case 492,445,405,438,426,421,467,507,550,585,604,404,546,547,422,551,420,596,597,412,533,419,600,534,575,540,516,529,561,483: return 15;
	    case 580,479,567,560,535,554,478,566,446,430,601,497,487,488: return 20;
	    case 579,400,489,418,409,453,599,423: return 25;
	    case 431,582,482,508,417,408,588,454,416,490,427: return 30;
	}
	return 0;
}

IsPlayerNearHood(playerid, vehicleid)
{
	new
		Float:fX,
		Float:fY,
		Float:fZ;

	GetVehicleHood(vehicleid, fX, fY, fZ);

	return (GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehicleid)) && IsPlayerInRangeOfPoint(playerid, 1.5, fX, fY, fZ);
}

GetHoodStatus(vehicleid)
{
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if (bonnet != 1)
		return 0;

	return 1;
}

SetHoodStatus(vehicleid, bool:status)
{
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, status, boot, objective);
}


IsDoorVehicle(vehicleid)
{
	switch (GetVehicleModel(vehicleid)) {
		case 400..424, 426..429, 431..440, 442..445, 451, 455, 456, 458, 459, 466, 467, 470, 474, 475:
		    return 1;

		case 477..480, 482, 483, 486, 489, 490..492, 494..496, 498..500, 502..508, 514..518, 524..529, 533..536:
		    return 1;

		case 540..547, 549..552, 554..562, 565..568, 573, 575, 576, 578..580, 582, 585, 587..589, 596..605, 609:
			return 1;
	}
	return 0;
}

IsVehicleTrunkBroken(vehicleid)
{
	new damage1, damage2, damage3, damage4;
  	GetVehicleDamageStatus(vehicleid, damage1, damage2, damage3, damage4);
	return (damage2 >>> 8 & 15) >= 4 ? true:false;
}

GetTrunkStatus(vehicleid)
{
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if (boot != 1)
		return 0;

	return 1;
}

SetTrunkStatus(vehicleid, bool:status)
{
	new
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, status, objective);
}

ShowPlayerDealershipMenu(playerid)
{
	//new str[128], count, numbveh;
    static str[140];
    if (str[0] == EOS) {
    	for(new i = 0; i != sizeof(VehicleMenuInfo); i++) {
    	    format(str, sizeof str, "%s\n%s", str, VehicleMenuInfo[i]);
    	}
    }
    Dialog_Show(playerid, DialogDealershipMenu, DIALOG_STYLE_LIST, "หมวดหมู่", str, "เลือก", "ยกเลิก");
}

ShowPlayerDoDealershipMenu(playerid)
{
	//new str[128], count, numbveh;
    static str[140];
    if (str[0] == EOS) {
    	for(new i = 0; i != sizeof(VehicleMenuInfo); i++) {
    	    format(str, sizeof str, "%s\n%s", str, VehicleMenuInfo[i]);
    	}
    }
    Dialog_Show(playerid, DialogDoDealershipMenu, DIALOG_STYLE_LIST, "หมวดหมู่", str, "เลือก", "ยกเลิก");
}

Dialog:DialogDealershipMenu(playerid, response, listitem, inputtext[]) {
	if (response) {
        SetPVarInt(playerid, "DealershipCatalog", listitem);
        ShowDealershipCatalog(playerid, listitem);
    }
    return 1;
}

Dialog:DialogDoDealershipMenu(playerid, response, listitem, inputtext[]) {
	if (response) {
        SetPVarInt(playerid, "DealershipCatalog", listitem);
        ShowDoDealershipCatalog(playerid, listitem);
    }
    return 1;
}

ShowDealershipCatalog(playerid, catalog) {
    new str[800], listitem;
    for(new i = 0; i != sizeof(VehicleDealership); i++) {
        if (VehicleDealership[i][1] == catalog) {
            format(str, 800, "%s\n(%d): %s\t$%d\t%s", str, 
                VehicleDealership[i][0], 
                ReturnVehicleModelName(VehicleDealership[i][0]), 
                GetVehiclePrice(VehicleDealership[i][0]), 
                (IsDonateCar(VehicleDealership[i][0]) ? sprintf("(ผู้บริจาคตั้งแต่ระดับ %s)", Donate_GetName(IsDonateCar(VehicleDealership[i][0]))) : (""))
            );
            SetPVarInt(playerid, sprintf("DealershipModel_%d", listitem), i);
            listitem++;
        }
    }
    Dialog_Show(playerid, DialogDealershipCatalog, DIALOG_STYLE_LIST, sprintf("หมวดหมู่ -> %s", VehicleMenuInfo[catalog]), str, "เลือก", "กลับ");
    return 1;
}

ShowDoDealershipCatalog(playerid, catalog) {
    new str[800], listitem;
    for(new i = 0; i != sizeof(VehicleDealership); i++) {
        if (VehicleDealership[i][1] == catalog) {
            format(str, 800, "%s\n(%d): %s\t%d แต้ม\t%s", str, 
                VehicleDealership[i][0], 
                ReturnVehicleModelName(VehicleDealership[i][0]), 
                GetVehicleDonatePrice(VehicleDealership[i][0]), 
                (IsDonateCar(VehicleDealership[i][0]) ? sprintf("(ผู้บริจาคตั้งแต่ระดับ %s)", Donate_GetName(IsDonateCar(VehicleDealership[i][0]))) : (""))
            );
            SetPVarInt(playerid, sprintf("DealershipModel_%d", listitem), i);
            listitem++;
        }
    }
    Dialog_Show(playerid, DoDealershipCatalog, DIALOG_STYLE_LIST, sprintf("หมวดหมู่ -> %s", VehicleMenuInfo[catalog]), str, "เลือก", "กลับ");
    return 1;
}

Dialog:DoDealershipCatalog(playerid, response, listitem, inputtext[]) {
	if (response) {
        new id = GetPVarInt(playerid, sprintf("DealershipModel_%d", listitem));
        GetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
        PutPlayerSettingDonateVehicle(playerid, VehicleDealership[id][0]);
    } else ShowPlayerDoDealershipMenu(playerid);
    return 1;
}

Dialog:DialogDealershipCatalog(playerid, response, listitem, inputtext[]) {
	if (response) {
        new id = GetPVarInt(playerid, sprintf("DealershipModel_%d", listitem));
        GetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
        PutPlayerSettingVehicle(playerid, VehicleDealership[id][0]);
    } else ShowPlayerDealershipMenu(playerid);
    return 1;
}

PutPlayerSettingVehicle(playerid, model)
{
	if(playerData[playerid][pPCarkey] != -1) 
        return SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: คุณไม่สามารถ Spawn ยานพาหนะได้มากกว่านี้แล้ว");
	
    new price = GetVehiclePrice(model);

    if(price <= 0) 
        return SendClientMessage(playerid, COLOR_LIGHTRED, "สินค้าหมดแล้วค่ะ!");

    if(GetPlayerMoney(playerid) < price) 
        return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมีเงินไม่พอที่จะซื้อ");

	if(playerData[playerid][pDonateRank] < IsDonateCar(model)) {
        return SendClientMessageEx(playerid, COLOR_LIGHTRED, "สำหรับผู้เล่นระดับ %s เท่านั้น", Donate_GetName(IsDonateCar(model)));
    }

	new b = IsPlayerAtDealership(playerid);
	if (b == -1) {
		return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ที่ตัวแทนจำหน่ายยานพาหนะ");
	}
	SetPVarInt(playerid, "BuyCarBusinessID", b);

    new Float:Vx, Float:Vy, Float:Vz, Float:Va, Float:xdist, Float:ydist, Float:zdist, Float:dist;

    if(IsABoat(model))
    {
		if (businessData[b][bID] == 7) {
			Vx = -1569.5641;
			Vy = 1258.0144;
			Vz = -0.6655;
			Va = 267.4615;

			dist = 6.5;
			xdist = 0.014912;
			ydist = 3.6;
			zdist = 0.004;
		}
		else if (businessData[b][bID] == 12) {
			Vx = 129.548;
			Vy = -1852.6;
			Vz = -0.4365;
			Va = 179.663;

	        dist = 6.5;
			xdist = 0.014912;
			ydist = 3.6;
			zdist = 0.004;
		}
    }
    else if(IsAPlaneModel(model))
    {
		if (businessData[b][bID] == 7) {
			Vx = -1565.6702;
			Vy = 1198.3633;
			Vz = 8.5904;
			Va = 65.2258;

			dist = 0;
			xdist = 0.003728;
			ydist = 1.8;
			zdist = 0.002;
		}
		else if (businessData[b][bID] == 12) {
			Vx = 1963.92;
			Vy = -2342.35;
			Vz = 13.5466;
			Va = 174;

	        dist = 0;
			xdist = 0.003728;
			ydist = 1.8;
			zdist = 0.002;
		}
    }
    else
    {
		if (businessData[b][bID] == 7) {
			Vx = -1585.8416;
			Vy = 1213.4854;
			Vz = 6.8984;
			Va = 53.5454;

			dist = 2.5;
			xdist = 0.003728;
			ydist = 1.8;
			zdist = 0.002;
		}
		else if (businessData[b][bID] == 12) {
			Vx = 533.279;
			Vy = -1282.69;
			Vz = 17.8654;
			Va = 239.367;

			dist = 0;
			xdist = 0.003728;
			ydist = 1.8;
			zdist = 0.002;
		}
    }

	if (Vx == 0.0 && Vy == 0.0) {
		return SendClientMessage(playerid, COLOR_LIGHTRED, "ตัวแทนจำหน่ายยังไม่ได้ตั้งค่าตำแหน่งของยานพาหนะชนิดนี้");
	}

    VDealerColor1[playerid] = random(255);
    VDealerColor2[playerid] = random(255);

    VDealerVehicle[playerid] = CreateVehicle(model, Vx,Vy,Vz,Va, VDealerColor1[playerid], VDealerColor2[playerid], -1);
	SetLockStatus(VDealerVehicle[playerid], false);

    if (VDealerVehicle[playerid] != INVALID_VEHICLE_ID)
    {
        new compid;
    	for(new i = 0; i != 14; i++)
    	{
    		compid = GetVehicleComponentInSlot(VDealerVehicle[playerid], i);
    		if (compid != 0) RemoveVehicleComponent(VDealerVehicle[playerid], compid);
    	}

        VDealerSetting{playerid} = true;
        PutPlayerInVehicle(playerid, VDealerVehicle[playerid], 0);

        new Float:X, Float:Y, Float:Z, Float:vX, Float:vY, Float:vZ;

        TogglePlayerControllable(playerid, false);

        GetVehicleHood(VDealerVehicle[playerid], X, Y, Z);
    	GetVehiclePos(VDealerVehicle[playerid],vX,vY,vZ);

    	InterpolateCameraPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ], X + (X * xdist),Y + ydist, Z + (Z * zdist) + dist, 1500, 1);
    	InterpolateCameraLookAt(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ], vX,vY,vZ, 1300, 1);

        defer FixMobileCamera(playerid, X + (X * xdist),Y + ydist, Z + (Z * zdist) + dist, vX,vY,vZ);

    	Vehicle_ResetVehicle(VDealerVehicle[playerid]);

    	VDealerLock[playerid]=0;
    	VDealerImmob[playerid]=0;
    	VDealerAlarm[playerid]=0;
    	VDealerPrice[playerid]=price;
		VDealerFaction{playerid}=false;

    	ShowPlayerDealercarDialog(playerid);
    }
	else {
		ExitSettingVehicle(playerid);
		SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: เกิดข้อผิดพลาดในการสร้างยานพาหนะ โปรดติดต่อผู้ดูแลระบบ");
	}
	return 1;
}

PutPlayerSettingDonateVehicle(playerid, model)
{
	if(playerData[playerid][pPCarkey] != -1) 
        return SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: คุณไม่สามารถ Spawn ยานพาหนะได้มากกว่านี้แล้ว");
	
    new price = GetVehicleDonatePrice(model);

    if(price <= 0)
        return SendClientMessage(playerid, COLOR_LIGHTRED, "สินค้าหมดแล้ว/หรือคุณมีแต้มไม่พอ!");

    if(playerData[playerid][pPoint] < price) 
        return SendClientMessageEx(playerid, COLOR_LIGHTRED, "คุณมีแต้มไม่พอที่จะซื้อ ใช้ %d แต้ม", price);

	if(playerData[playerid][pDonateRank] < IsDonateCar(model)) {
        return SendClientMessageEx(playerid, COLOR_LIGHTRED, "สำหรับผู้เล่นระดับ %s เท่านั้น", Donate_GetName(IsDonateCar(model)));
    }

	new b = IsPlayerAtDealership(playerid);
	if (b == -1) {
		return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ที่ตัวแทนจำหน่ายยานพาหนะ");
	}
	SetPVarInt(playerid, "BuyCarBusinessID", b);

    new Float:Vx, Float:Vy, Float:Vz, Float:Va, Float:xdist, Float:ydist, Float:zdist, Float:dist;

    if(IsABoat(model))
    {
		if (businessData[b][bID] == 7) {
			Vx = -1569.5641;
			Vy = 1258.0144;
			Vz = -0.6655;
			Va = 267.4615;

			dist = 6.5;
			xdist = 0.014912;
			ydist = 3.6;
			zdist = 0.004;
		}
		else if (businessData[b][bID] == 12) {
			Vx = 129.548;
			Vy = -1852.6;
			Vz = -0.4365;
			Va = 179.663;

	        dist = 6.5;
			xdist = 0.014912;
			ydist = 3.6;
			zdist = 0.004;
		}
    }
    else if(IsAPlaneModel(model))
    {
		if (businessData[b][bID] == 7) {
			Vx = -1565.6702;
			Vy = 1198.3633;
			Vz = 8.5904;
			Va = 65.2258;

			dist = 0;
			xdist = 0.003728;
			ydist = 1.8;
			zdist = 0.002;
		}
		else if (businessData[b][bID] == 12) {
			Vx = 1963.92;
			Vy = -2342.35;
			Vz = 13.5466;
			Va = 174;

	        dist = 0;
			xdist = 0.003728;
			ydist = 1.8;
			zdist = 0.002;
		}
    }
    else
    {
		if (businessData[b][bID] == 7) {
			Vx = -1585.8416;
			Vy = 1213.4854;
			Vz = 6.8984;
			Va = 53.5454;

			dist = 2.5;
			xdist = 0.003728;
			ydist = 1.8;
			zdist = 0.002;
		}
		else if (businessData[b][bID] == 12) {
			Vx = 533.279;
			Vy = -1282.69;
			Vz = 17.8654;
			Va = 239.367;

			dist = 0;
			xdist = 0.003728;
			ydist = 1.8;
			zdist = 0.002;
		}
    }

	if (Vx == 0.0 && Vy == 0.0) {
		return SendClientMessage(playerid, COLOR_LIGHTRED, "ตัวแทนจำหน่ายยังไม่ได้ตั้งค่าตำแหน่งของยานพาหนะชนิดนี้");
	}

    VDealerColor1[playerid] = random(255);
    VDealerColor2[playerid] = random(255);

    VDealerVehicle[playerid] = CreateVehicle(model, Vx,Vy,Vz,Va, VDealerColor1[playerid], VDealerColor2[playerid], -1);
	SetLockStatus(VDealerVehicle[playerid], false);

    if (VDealerVehicle[playerid] != INVALID_VEHICLE_ID)
    {
        new compid;
    	for(new i = 0; i != 14; i++)
    	{
    		compid = GetVehicleComponentInSlot(VDealerVehicle[playerid], i);
    		if (compid != 0) RemoveVehicleComponent(VDealerVehicle[playerid], compid);
    	}

        VDealerSetting{playerid} = true;
        PutPlayerInVehicle(playerid, VDealerVehicle[playerid], 0);

        new Float:X, Float:Y, Float:Z, Float:vX, Float:vY, Float:vZ;

        TogglePlayerControllable(playerid, false);

        GetVehicleHood(VDealerVehicle[playerid], X, Y, Z);
    	GetVehiclePos(VDealerVehicle[playerid],vX,vY,vZ);

    	InterpolateCameraPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ], X + (X * xdist),Y + ydist, Z + (Z * zdist) + dist, 1500, 1);
    	InterpolateCameraLookAt(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ], vX,vY,vZ, 1300, 1);

        defer FixMobileCamera(playerid, X + (X * xdist),Y + ydist, Z + (Z * zdist) + dist, vX,vY,vZ);

    	Vehicle_ResetVehicle(VDealerVehicle[playerid]);

    	VDealerLock[playerid]=0;
    	VDealerImmob[playerid]=0;
    	VDealerAlarm[playerid]=0;
    	VDealerPrice[playerid]=price;
		VDealerFaction{playerid}=false;

    	ShowPlayerDealercarDonateDialog(playerid);
    }
	else {
		ExitSettingVehicle(playerid);
		SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: เกิดข้อผิดพลาดในการสร้างยานพาหนะ โปรดติดต่อผู้ดูแลระบบ");
	}
	return 1;
}

IsDonateCar(model)
{
	switch(model)
	{
	    case 481, 509: return 1;
 	    case 477, 471: return 2;
 	    case 429, 541, 521, 468, 593: return 3;
	}
	return false;
}

GetEngineDrive(modelid)
{
	new string[24];
	if(GetVehicleModelInfoAsInt(modelid, "TransmissionData_nDriveType") == 'F') format(string, 32, "ขับเคลื่อนล้อหน้า");
	else if(GetVehicleModelInfoAsInt(modelid, "TransmissionData_nDriveType") == 'R') format(string, 32, "ขับเคลื่อนล้อหลัง");
	else format(string, 24, "ขับเคลื่อนสี่ล้อ");
	return string;
}

GetVehicleConsumption(modelid)
{
	new string[24], Float:consumption = GetVehicleDataFuelRate(modelid);
	format(string, 24, "%d MPG / %d KPL", floatround(consumption * 2.35214583), floatround(consumption));
	return string;
}

ShowPlayerDealercarDonateDialog(playerid) {
	new model = GetVehicleModel(VDealerVehicle[playerid]);
	new price = VDealerPrice[playerid];

    new string2[1600];
	format(string2, sizeof(string2), ""EMBED_YELLOW"ราคา:\t\t\t"EMBED_WHITE"%d แต้ม\n"EMBED_YELLOW"ความเร็วสูงสุด:\t\t"EMBED_WHITE"%.2f\n"EMBED_YELLOW"คุณภาพสูงสุด:\t\t"EMBED_WHITE"%.2f\n"EMBED_YELLOW"มวล:\t\t\t"EMBED_WHITE"%.2f\n\n"EMBED_YELLOW"ระบบขับเคลื่อน:\t\t"EMBED_WHITE"%s\n"EMBED_YELLOW"อัตราสิ้นเปลืองน้ำมันเชื้อเพลิง:\t"EMBED_WHITE"%s\n"EMBED_YELLOW"ความจุน้ำมันเชื้อเพลิง:\t\t"EMBED_WHITE"%.2f\n",
	price, GetVehicleModelInfoAsFloat(model, "TransmissionData_fMaxVelocity"), GetVehicleDataHealth(model), GetVehicleModelInfoAsFloat(model, "fMass"), GetEngineDrive(model), GetVehicleConsumption(model), GetVehicleDataFuel(model));

    Dialog_Show(playerid, DonateDealercar, DIALOG_STYLE_MSGBOX, sprintf("%s - %d แต้ม", ReturnVehicleModelName(model), price), string2, "ซื้อ", "ยกเลิก");
}

ShowPlayerDealercarDialog(playerid)
{
	new model = GetVehicleModel(VDealerVehicle[playerid]);
	new price = VDealerPrice[playerid];

    new string2[1600];
	format(string2, sizeof(string2), ""EMBED_YELLOW"ราคา:\t\t\t"EMBED_WHITE"%s\n"EMBED_YELLOW"ความเร็วสูงสุด:\t\t"EMBED_WHITE"%.2f\n"EMBED_YELLOW"คุณภาพสูงสุด:\t\t"EMBED_WHITE"%.2f\n"EMBED_YELLOW"มวล:\t\t\t"EMBED_WHITE"%.2f\n\n"EMBED_YELLOW"ระบบขับเคลื่อน:\t\t"EMBED_WHITE"%s\n"EMBED_YELLOW"อัตราสิ้นเปลืองน้ำมันเชื้อเพลิง:\t"EMBED_WHITE"%s\n"EMBED_YELLOW"ความจุน้ำมันเชื้อเพลิง:\t\t"EMBED_WHITE"%.2f\n",
	FormatNumber(price), GetVehicleModelInfoAsFloat(model, "TransmissionData_fMaxVelocity"), GetVehicleDataHealth(model), GetVehicleModelInfoAsFloat(model, "fMass"), GetEngineDrive(model), GetVehicleConsumption(model), GetVehicleDataFuel(model));

	if(!VDealerFaction{playerid} || playerData[playerid][pFaction] == 0) {
		if(VDealerLock[playerid])
		{
			new id = VDealerLock[playerid]-1;
			format(string2, sizeof(string2), "%s\n"EMBED_YELLOW"ระบบล็อก:\t\t{B4B5B7} ระดับ %d\t"EMBED_WHITE"%s", string2,
			VDealerLock[playerid] + 1, FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeLock[id][u_rate]) + VehicleUpgradeLock[id][u_price]));

			switch(VDealerLock[playerid])
			{
				case 1: {
					format(string2, sizeof(string2), "%s\n\t"EMBED_GREEN"+"EMBED_WHITE" 500 วินาทีสำหรับการป้องกัน\n\tการพยายามงัดแงะ\n\t"EMBED_GREEN"+"EMBED_WHITE" การป้องกันที่แข็งแกร่งขึ้น\n\tป้องกันการงัดแงะด้วยมือเปล่า", string2);
				}
				case 2: {
					format(string2, sizeof(string2), "%s\n\t"EMBED_GREEN"+"EMBED_WHITE" 750 วินาทีสำหรับการป้องกัน\n\tการพยายามงัดแงะ\n\t"EMBED_GREEN"+"EMBED_WHITE" การป้องกันแบบพิเศษ - ที่ป้องกันดีกว่า 2 เท่า\n\tป้องกันการงัดแงะด้วยมือเปล่าและชะแลง", string2);
				}
				case 3: {
					format(string2, sizeof(string2), "%s\n\t"EMBED_GREEN"+"EMBED_WHITE" 750 วินาทีสำหรับการป้องกัน\n\tการพยายามงัดแงะ\n\t"EMBED_GREEN"+"EMBED_WHITE" การป้องกันแบบพิเศษ - ที่ป้องกันดีกว่า 3 เท่า\n\tป้องกันการงัดแงะด้วยมือเปล่าและชะแลง", string2);
				}
				case 4: {
					format(string2, sizeof(string2), "%s\n\t"EMBED_GREEN"+"EMBED_WHITE" 1,250 วินาทีสำหรับการป้องกัน\n\tการพยายามงัดแงะ\n\t"EMBED_GREEN"+"EMBED_WHITE" การป้องกันแบบพิเศษ ป้องกันการโจมตี\n\tทางกายภาพทุกประเภท", string2);
				}
			}
		}
		if(VDealerAlarm[playerid])
		{
			new id = VDealerAlarm[playerid]-1;
			format(string2, sizeof(string2), "%s\n"EMBED_YELLOW"สัญญาณเตือนภัย:\t{B4B5B7} ระดับ %d\t"EMBED_WHITE"%s", string2,
			VDealerAlarm[playerid], FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeAlarm[id][u_rate]) + VehicleUpgradeAlarm[id][u_price]));

			switch(VDealerAlarm[playerid])
			{
				case 1: {
					format(string2, sizeof(string2), "%s\n\t{FF6347}+"EMBED_WHITE" สัญญาณเตือนภัยดัง", string2);
				}
				case 2: {
					format(string2, sizeof(string2), "%s\n\t{FF6347}+"EMBED_WHITE" สัญญาณเตือนภัยดัง\n\t{FF6347}+"EMBED_WHITE" ยานพาหนะแจ้งเตือนไปยังเจ้าของเกี่ยวกับการบุกรุกที่อาจเกิดขึ้น", string2);
				}
				case 3: {
					format(string2, sizeof(string2), "%s\n\t{FF6347}+"EMBED_WHITE" สัญญาณเตือนภัยดัง\n\t{FF6347}+"EMBED_WHITE" ยานพาหนะแจ้งเตือนไปยังเจ้าของเกี่ยวกับการบุกรุกที่อาจเกิดขึ้น\n\t{FF6347}+"EMBED_WHITE" ยานพาหนะแจ้งเตือนไปยังสถานีตำรวจในพื้นที่เกี่ยวกับ\n\tการบุกรุกที่อาจเกิดขึ้น", string2);
				}
				case 4: {
					format(string2, sizeof(string2), "%s\n\t{FF6347}+"EMBED_WHITE" สัญญาณเตือนภัยดัง\n\t{FF6347}+"EMBED_WHITE" ยานพาหนะแจ้งเตือนไปยังเจ้าของเกี่ยวกับการบุกรุกที่อาจเกิดขึ้น\n\t{FF6347}+"EMBED_WHITE" ยานพาหนะแจ้งเตือนไปยังสถานีตำรวจในพื้นที่เกี่ยวกับ\n\tการบุกรุกที่อาจเกิดขึ้น\n\t{FF6347}+"EMBED_WHITE" สัญลักษณ์ยานพาหนะจะปรากฏบนเรดาร์\n\tของเจ้าหน้าที่ผู้บังคับใช้กฎหมาย", string2);
				}
			}
		}

		if(VDealerImmob[playerid])
		{
			new id = VDealerImmob[playerid]-1;
			format(string2, sizeof(string2), "%s\n"EMBED_YELLOW"อิมโมบิไลเซอร์:\t{B4B5B7} ระดับ %d\t"EMBED_WHITE"%s", string2,
			VDealerImmob[playerid], FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeImmob[id][u_rate]) + VehicleUpgradeImmob[id][u_price]));

			format(string2, sizeof(string2), "%s\n\t"EMBED_YELLOW"+"EMBED_WHITE" ระบบอิมโมบิไลเซอร์ช่วยป้องกันไม่ให้\n\tเครื่องยนต์ในยานพาหนะของคุณทำงานกับ\n\tกุญแจที่ไม่ได้รับอนุญาต", string2);
		}
	}
	else {
		new factionid = Faction_GetID(playerData[playerid][pFaction]);
	    format(string2, sizeof(string2), "%s\n"EMBED_YELLOW"ฝักฝ่าย:\t\t"EMBED_WHITE"%s", string2, Faction_GetName(factionid));
	}

    Dialog_Show(playerid, Dealercar, DIALOG_STYLE_MSGBOX, sprintf("%s - %s", ReturnVehicleModelName(model), FormatNumber(GetDealershipCountPrice(playerid))), string2, "แก้ไข", "ชำระเงิน");
	return 1;
}

GetDealershipCountPrice(playerid)
{
	new price = VDealerPrice[playerid], id;

    if(VDealerLock[playerid])
    {
        id = VDealerLock[playerid]-1;
        price += floatround(VDealerPrice[playerid] / VehicleUpgradeLock[id][u_rate]) + VehicleUpgradeLock[id][u_price];
    }

    if(VDealerImmob[playerid])
    {
        id = VDealerImmob[playerid]-1;
        price += floatround(VDealerPrice[playerid] / VehicleUpgradeImmob[id][u_rate]) + VehicleUpgradeImmob[id][u_price];
    }

    if(VDealerAlarm[playerid])
    {
        id = VDealerAlarm[playerid]-1;
        price += floatround(VDealerPrice[playerid] / VehicleUpgradeAlarm[id][u_rate]) + VehicleUpgradeAlarm[id][u_price];
    }

	return price;
}

Dialog:DonateDealercar(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new
	        vehicleid = VDealerVehicle[playerid],
			model = GetVehicleModel(vehicleid),
			price = GetDealershipCountPrice(playerid),
			string[256]
		;

		if(price <= 0)
		{
		    ExitSettingVehicle(playerid);
		    SendClientMessage(playerid, COLOR_RED, "มีข้อผิดพลาดในการซื้อยานพาหนะโปรดติดต่อผู้ดูแลระบบ");
		    return 1;
		}


	    if (playerData[playerid][pPoint] < price)
	    {
	    	SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมีแต้มไม่พอที่จะซื้อ");
	    	ExitSettingVehicle(playerid);
	    	return 1;
	    }

		if (GetNumberOwnerCar(playerid) >= MAX_OWNED_CAR)
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมียานพาหนะเต็มจำนวนสูงสุดแล้ว");
			ExitSettingVehicle(playerid);
			return 1;
		}

		if(playerData[playerid][pPCarkey] != -1) {
			SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: คุณไม่สามารถ Spawn ยานพาหนะได้มากกว่านี้แล้ว");
			ExitSettingVehicle(playerid);
			return 1;
		}

		new i = -1;
		if((i = Iter_Free(Iter_PlayerCar)) != -1)
		{
			new
				Float:pos[4]
			;
			GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
			GetVehicleZAngle(vehicleid, pos[3]);

			playerCarData[i][carPos][0] = pos[0];
			playerCarData[i][carPos][1] = pos[1];
			playerCarData[i][carPos][2] = pos[2];
			playerCarData[i][carPos][3] = pos[3];

			playerCarData[i][carDonate] = 1;
			playerCarData[i][carLock] = VDealerLock[playerid];
			playerCarData[i][carImmob] = VDealerImmob[playerid];
			playerCarData[i][carAlarm] = VDealerAlarm[playerid];
			playerCarData[i][carOwner] = playerData[playerid][pSID];
			playerCarData[i][carModel] = model;
			playerCarData[i][carBatteryL] = GetVehicleDataBattery(model);
			playerCarData[i][carEngineL] = GetVehicleDataEngine(model);

			vehicleData[vehicleid][vFuel] = GetVehicleDataFuel(model);
			playerCarData[i][carFuel] = vehicleData[vehicleid][vFuel];
			playerCarData[i][carHealth] = GetVehicleDataHealth(model);

			playerCarData[i][carDupKey] = randomEx(1234567, 9999999);
			playerCarData[i][carColor1] = VDealerColor1[playerid];
			playerCarData[i][carColor2] = VDealerColor2[playerid];
			playerCarData[i][carLocked] = true;
			playerCarData[i][carWorld] = 0;
			playerCarData[i][carInt] = 0;
			
			format(string,sizeof(string),"INSERT INTO `cars` (`carModel`, `carOwner`, `carColor1`, `carColor2`, `carLock`, `carImmob`, `carAlarm`, `carDate`, `carDonate`) VALUES (%d, %d, %d, %d, %d, %d, %d, NOW(), 1)",
				model,
				playerData[playerid][pSID],
				VDealerColor1[playerid],
				VDealerColor2[playerid],
				VDealerLock[playerid],
				VDealerImmob[playerid],
				VDealerAlarm[playerid]);
			mysql_tquery(dbCon, string, "OnPlayerBuyDonateCar", "iddd", playerid, i, model, price);
		}
		else {
			SendClientMessage(playerid, COLOR_LIGHTRED, "ช่องยานพาหนะส่วนตัวเต็ม โปรดติดต่อผู้ดูแลระบบ");
		}
	}
	else
	{
        ExitSettingVehicle(playerid);
	}
	return 1;
}

Dialog:Dealercar(playerid, response, listitem, inputtext[])
{
    new string[64];
	new model = GetVehicleModel(VDealerVehicle[playerid]);

	if (!response)
	{
		format(string, sizeof(string), "%s - %s", g_arrVehicleNames[model - 400], FormatNumber(GetDealershipCountPrice(playerid)));
	    Dialog_Show(playerid, DealercarConfirm, DIALOG_STYLE_MSGBOX, string, "คุณแน่ใจหรือที่จะซื้อยานพาหนะคันนี้ ?", "ซื้อ", "ยกเลิก");
	}
	else
	{
        ShowEditCarMenu(playerid);
	}
	return 1;
}

Dialog:DealerMenu(playerid, response, listitem, inputtext[])
{
    //new string2[128];
	if (response)
	{
	    //
	    switch(listitem)
	    {
	        case 0:
	        {
				//format(string2,sizeof(string2),"%sไม่มี\n%sสัญญาณเตือนภัยระดับ 1 - $5,000\n%sสัญญาณเตือนภัยระดับ 2 - $7,000\n%sสัญญาณเตือนภัยระดับ 3 - $10,000\n%sสัญญาณเตือนภัยระดับ 4 - $12,000");
				Dialog_Show(playerid, CarDealerAlarm, DIALOG_STYLE_LIST, "Alarm", "%sไม่มี\n%sสัญญาณเตือนภัยระดับ 1 - %s\n%sสัญญาณเตือนภัยระดับ 2 - %s\n%sสัญญาณเตือนภัยระดับ 3 - %s\n%sสัญญาณเตือนภัยระดับ 4 - %s", "ปรับแต่ง", "<< กลับ",
				(VDealerAlarm[playerid] == 0) ? (">> ") : (""),
				(VDealerAlarm[playerid] == 1) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeAlarm[0][u_rate]) + VehicleUpgradeAlarm[0][u_price]),
				(VDealerAlarm[playerid] == 2) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeAlarm[1][u_rate]) + VehicleUpgradeAlarm[1][u_price]),
				(VDealerAlarm[playerid] == 3) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeAlarm[2][u_rate]) + VehicleUpgradeAlarm[2][u_price]),
				(VDealerAlarm[playerid] == 4) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeAlarm[3][u_rate]) + VehicleUpgradeAlarm[3][u_price]));
	        }
	        case 1:
	        {
				//format(string2,sizeof(string2),"%sระบบล็อกระดับ - 1 $0\n%sระบบล็อกระดับ 2 - $5,000\n%sระบบล็อกระดับ 3 - $7,000\n%sLevel - 4 $10,000\n%sLevel - 5 $12,000");
				Dialog_Show(playerid, CarDealerLock, DIALOG_STYLE_LIST, "Lock", "%sระบบล็อกระดับ 1 - $0\n%sระบบล็อกระดับ 2 - %s\n%sระบบล็อกระดับ 3 - %s\n%sระบบล็อกระดับ 4 - %s\n%sระบบล็อกระดับ 5 - %s", "ปรับแต่ง", "<< กลับ",
				(VDealerLock[playerid] == 0) ? (">> ") : (""),
				(VDealerLock[playerid] == 1) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeLock[0][u_rate]) + VehicleUpgradeLock[0][u_price]),
				(VDealerLock[playerid] == 2) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeLock[1][u_rate]) + VehicleUpgradeLock[1][u_price]),
				(VDealerLock[playerid] == 3) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeLock[2][u_rate]) + VehicleUpgradeLock[2][u_price]),
				(VDealerLock[playerid] == 4) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeLock[3][u_rate]) + VehicleUpgradeLock[3][u_price]));
	        }
 	        case 2:
	        {
 				//format(string2,sizeof(string2),"%sไม่มี\n%sอิมโมบิไลเซอร์ระดับ  1 - $5,000\n%sอิมโมบิไลเซอร์ระดับ  2 - $10,000\n%sอิมโมบิไลเซอร์ระดับ  3 - $15,000\n%sอิมโมบิไลเซอร์ระดับ  4 - $20,000");
				Dialog_Show(playerid, CarDealerImmob, DIALOG_STYLE_LIST, "Immobiliser", "%sไม่มี\n%sอิมโมบิไลเซอร์ระดับ  1 - %s\n%sอิมโมบิไลเซอร์ระดับ  2 - %s\n%sอิมโมบิไลเซอร์ระดับ  3 - %s\n%sอิมโมบิไลเซอร์ระดับ  4 - %s", "ปรับแต่ง", "<< กลับ",
				(VDealerImmob[playerid] == 0) ? (">> ") : (""),
				(VDealerImmob[playerid] == 1) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeImmob[0][u_rate]) + VehicleUpgradeImmob[0][u_price]),
				(VDealerImmob[playerid] == 2) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeImmob[1][u_rate]) + VehicleUpgradeImmob[1][u_price]),
				(VDealerImmob[playerid] == 3) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeImmob[2][u_rate]) + VehicleUpgradeImmob[2][u_price]),
				(VDealerImmob[playerid] == 4) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeImmob[3][u_rate]) + VehicleUpgradeImmob[3][u_price]));
	        }
	        case 3:
	        {
                Dialog_Show(playerid, DialogCarColor1, DIALOG_STYLE_INPUT, "เปลี่ยนสี 1", GetVehicleColorList(), "เปลี่ยน", "กลับ");
	        }
	        case 4:
	        {
                Dialog_Show(playerid, DialogCarColor2, DIALOG_STYLE_INPUT, "เปลี่ยนสี 2", GetVehicleColorList(), "เปลี่ยน", "กลับ");
	        }
	        case 5:
	        {
				if(playerData[playerid][pFaction] == 0 || playerData[playerid][pFactionRank] > 2) {
	                SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ใช่ผู้นำของ Faction");
				}
	            else {
					VDealerFaction{playerid} = !VDealerFaction{playerid};
				}

				ShowEditCarMenu(playerid);	
	        }
	    }
	}
	else ShowPlayerDealercarDialog(playerid);
	return 1;
}

Dialog:CarDealerLock(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    VDealerLock[playerid] = listitem;
		Dialog_Show(playerid, CarDealerLock, DIALOG_STYLE_LIST, "Lock", "%sระบบล็อกระดับ 1 - $0\n%sระบบล็อกระดับ 2 - %s\n%sระบบล็อกระดับ 3 - %s\n%sระบบล็อกระดับ 4 - %s\n%sระบบล็อกระดับ 5 - %s", "ปรับแต่ง", "<< กลับ",
		(VDealerLock[playerid] == 0) ? (">> ") : (""),
		(VDealerLock[playerid] == 1) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeLock[0][u_rate]) + VehicleUpgradeLock[0][u_price]),
		(VDealerLock[playerid] == 2) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeLock[1][u_rate]) + VehicleUpgradeLock[1][u_price]),
		(VDealerLock[playerid] == 3) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeLock[2][u_rate]) + VehicleUpgradeLock[2][u_price]),
		(VDealerLock[playerid] == 4) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeLock[3][u_rate]) + VehicleUpgradeLock[3][u_price]));
	}
	else
	{
	    ShowEditCarMenu(playerid);
	}
	return 1;
}

Dialog:CarDealerImmob(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    VDealerImmob[playerid] = listitem;
		Dialog_Show(playerid, CarDealerImmob, DIALOG_STYLE_LIST, "Immobiliser", "%sไม่มี\n%sอิมโมบิไลเซอร์ระดับ  1 - %s\n%sอิมโมบิไลเซอร์ระดับ  2 - %s\n%sอิมโมบิไลเซอร์ระดับ  3 - %s\n%sอิมโมบิไลเซอร์ระดับ  4 - %s", "ปรับแต่ง", "<< กลับ",
		(VDealerImmob[playerid] == 0) ? (">> ") : (""),
		(VDealerImmob[playerid] == 1) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeImmob[0][u_rate]) + VehicleUpgradeImmob[0][u_price]),
		(VDealerImmob[playerid] == 2) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeImmob[1][u_rate]) + VehicleUpgradeImmob[1][u_price]),
		(VDealerImmob[playerid] == 3) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeImmob[2][u_rate]) + VehicleUpgradeImmob[2][u_price]),
		(VDealerImmob[playerid] == 4) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeImmob[3][u_rate]) + VehicleUpgradeImmob[3][u_price]));
	}
	else
	{
	    ShowEditCarMenu(playerid);
	}
}


Dialog:CarDealerAlarm(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    VDealerAlarm[playerid] = listitem;
		Dialog_Show(playerid, CarDealerAlarm, DIALOG_STYLE_LIST, "Alarm", "%sไม่มี\n%sสัญญาณเตือนภัยระดับ 1 - %s\n%sสัญญาณเตือนภัยระดับ 2 - %s\n%sสัญญาณเตือนภัยระดับ 3 - %s\n%sสัญญาณเตือนภัยระดับ 4 - %s", "ปรับแต่ง", "<< กลับ",
		(VDealerAlarm[playerid] == 0) ? (">> ") : (""),
		(VDealerAlarm[playerid] == 1) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeAlarm[0][u_rate]) + VehicleUpgradeAlarm[0][u_price]),
		(VDealerAlarm[playerid] == 2) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeAlarm[1][u_rate]) + VehicleUpgradeAlarm[1][u_price]),
		(VDealerAlarm[playerid] == 3) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeAlarm[2][u_rate]) + VehicleUpgradeAlarm[2][u_price]),
		(VDealerAlarm[playerid] == 4) ? (">> ") : (""), FormatNumber(floatround(VDealerPrice[playerid] / VehicleUpgradeAlarm[3][u_rate]) + VehicleUpgradeAlarm[3][u_price]));
	}
	else
	{
	    ShowEditCarMenu(playerid);
	}
	return 1;
}

Dialog:DealercarConfirm(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new
	        vehicleid = VDealerVehicle[playerid],
			model = GetVehicleModel(vehicleid),
			price = GetDealershipCountPrice(playerid),
			string[256]
		;

		if(price <= 0)
		{
		    ExitSettingVehicle(playerid);
		    SendClientMessage(playerid, COLOR_RED, "มีข้อผิดพลาดในการซื้อยานพาหนะโปรดติดต่อผู้ดูแลระบบ");
		    return 1;
		}


	    if (playerData[playerid][pCash] < price)
	    {
	    	SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมีเงินไม่พอที่จะซื้อ");
	    	ShowPlayerDealercarDialog(playerid);
	    	return 1;
	    }

		if(VDealerFaction{playerid}) {
		    new temp_faction = playerData[playerid][pFaction];
		    if(temp_faction == 0 || playerData[playerid][pFactionRank] > 2) {
				SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ใช่ผู้นำของ Faction");
				ShowPlayerDealercarDialog(playerid);
				return 1;
			}
			new count_vehicle=0, factionid = Faction_GetID(playerData[playerid][pFaction]);
			foreach(new i : Iter_ServerCar) {
				if(vehicleVariables[i][vVehicleFaction] == temp_faction) {
					count_vehicle++;
				}
			}

			if(count_vehicle >= factionData[factionid][fMaxVehicles]) {
				SendClientMessageEx(playerid, COLOR_LIGHTRED, "ยานพาหนะแฟคชั่นของคุณเต็มจำนวนสูงสุดแล้ว (%d คัน)", factionData[factionid][fMaxVehicles]);
				SendClientMessage(playerid, COLOR_LIGHTRED, "ต้องการเพิ่มติดต่อโดเนทกับผู้ดูแลระบบ");
				ShowPlayerDealercarDialog(playerid);
				return 1;
			}

			new i = Iter_Free(Iter_ServerCar);

			if(i != -1)
			{
				new
					queryString[255],
					Float: vPosX, Float:vPosY, Float:vPosZ, Float:vPosA
				; // x, y, z + z angle

				GetVehiclePos(vehicleid, vPosX, vPosY, vPosZ);
				GetVehicleZAngle(vehicleid, vPosA);

				format(queryString, sizeof(queryString), "INSERT INTO vehicle (vehicleModelID, vehiclePosX, vehiclePosY, vehiclePosZ, vehiclePosRotation, vehicleFaction) VALUES('%d', '%f', '%f', '%f', '%f', %d)",model, vPosX, vPosY, vPosZ, vPosA, temp_faction);
				mysql_query(dbCon,queryString);

				new insertid = cache_insert_id();

				vehicleVariables[i][vVehicleID] = insertid;
				vehicleVariables[i][vVehicleModelID] = model;
				vehicleVariables[i][vVehiclePosition][0] = vPosX;
				vehicleVariables[i][vVehiclePosition][1] = vPosY;
				vehicleVariables[i][vVehiclePosition][2] = vPosZ;
				vehicleVariables[i][vVehicleRotation] = vPosA;
				vehicleVariables[i][vVehicleFaction] = temp_faction;
				vehicleVariables[i][vVehicleWorld]=GetPlayerVirtualWorld(playerid);
				vehicleVariables[i][vVehicleInterior]=GetPlayerInterior(playerid);
				vehicleVariables[i][vVehicleScriptID] = vehicleid;
				vehicleVariables[i][vVehicleColour][0] = VDealerColor1[playerid];
				vehicleVariables[i][vVehicleColour][1] = VDealerColor2[playerid];

				Iter_Add(Iter_ServerCar, i);
				
		        ExitSettingVehicle(playerid);

				vehicleVariables[i][vVehicleScriptID] = CreateVehicle(vehicleVariables[i][vVehicleModelID], vehicleVariables[i][vVehiclePosition][0], vehicleVariables[i][vVehiclePosition][1], vehicleVariables[i][vVehiclePosition][2], vehicleVariables[i][vVehicleRotation], vehicleVariables[i][vVehicleColour][0], vehicleVariables[i][vVehicleColour][1], 60000);
				Vehicle_ResetVehicle(vehicleVariables[i][vVehicleScriptID]);
				LinkVehicleToInterior(vehicleVariables[i][vVehicleScriptID], vehicleVariables[i][vVehicleInterior]);
				SetVehicleVirtualWorld(vehicleVariables[i][vVehicleScriptID], vehicleVariables[i][vVehicleWorld]);
				SetVehicleNumberPlate(vehicleVariables[i][vVehicleScriptID], factionData[factionid][fShortName]);

				SetVehicleHealthEx(vehicleVariables[i][vVehicleScriptID], GetVehicleDataHealth(vehicleVariables[i][vVehicleModelID]));

     	        PutPlayerInVehicle(playerid, vehicleVariables[i][vVehicleScriptID], 0);
     	        
				GivePlayerMoneyEx(playerid, -price);
				OnAccountUpdate(playerid);
			}
		}
		else {
	    
			if (GetNumberOwnerCar(playerid) >= MAX_OWNED_CAR)
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมียานพาหนะเต็มจำนวนสูงสุดแล้ว");
				ExitSettingVehicle(playerid);
				return 1;
			}

			if(playerData[playerid][pPCarkey] != -1) {
				SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: คุณไม่สามารถ Spawn ยานพาหนะได้มากกว่านี้แล้ว");
				ExitSettingVehicle(playerid);
				return 1;
			}

			new i = -1;
			if((i = Iter_Free(Iter_PlayerCar)) != -1)
			{
				new
					Float:pos[4]
				;
				GetVehiclePos(vehicleid, pos[0], pos[1], pos[2]);
				GetVehicleZAngle(vehicleid, pos[3]);

				playerCarData[i][carPos][0] = pos[0];
				playerCarData[i][carPos][1] = pos[1];
				playerCarData[i][carPos][2] = pos[2];
				playerCarData[i][carPos][3] = pos[3];

				playerCarData[i][carLock] = VDealerLock[playerid];
				playerCarData[i][carImmob] = VDealerImmob[playerid];
				playerCarData[i][carAlarm] = VDealerAlarm[playerid];
				playerCarData[i][carOwner] = playerData[playerid][pSID];
				playerCarData[i][carModel] = model;
				playerCarData[i][carBatteryL] = GetVehicleDataBattery(model);
				playerCarData[i][carEngineL] = GetVehicleDataEngine(model);

				vehicleData[vehicleid][vFuel] = GetVehicleDataFuel(model);
				playerCarData[i][carFuel] = vehicleData[vehicleid][vFuel];
				playerCarData[i][carHealth] = GetVehicleDataHealth(model);

				playerCarData[i][carDupKey] = randomEx(1234567, 9999999);
				playerCarData[i][carColor1] = VDealerColor1[playerid];
				playerCarData[i][carColor2] = VDealerColor2[playerid];
				playerCarData[i][carLocked] = true;
				playerCarData[i][carWorld] = 0;
				playerCarData[i][carInt] = 0;
				
				for(new x = 0; x < 14; x++) playerCarData[i][carMods][x]=0;

				for(new x = 0; x != MAX_CAR_WEAPONS; x++)
				{
					playerCarData[i][carWeapon][x] = 0;
					playerCarData[i][carAmmo][x] = 0;
					//CarData[i][carWeaponLicense][x] = 0;
				}

				format(string,sizeof(string),"INSERT INTO `cars` (`carModel`, `carOwner`, `carColor1`, `carColor2`, `carLock`, `carImmob`, `carAlarm`, `carDate`) VALUES (%d, %d, %d, %d, %d, %d, %d, NOW())",
					model,
					playerData[playerid][pSID],
					VDealerColor1[playerid],
					VDealerColor2[playerid],
					VDealerLock[playerid],
					VDealerImmob[playerid],
					VDealerAlarm[playerid]);
				mysql_tquery(dbCon, string, "OnPlayerBuyCar", "iddd", playerid, i, model, price);
			}
			else {
				SendClientMessage(playerid, COLOR_LIGHTRED, "ช่องยานพาหนะส่วนตัวเต็ม โปรดติดต่อผู้ดูแลระบบ");
			}
	    }
	}
	else
	{
		ExitSettingVehicle(playerid);
	}
	return 1;
}

forward OnPlayerBuyDonateCar(playerid, i, model, price);
public OnPlayerBuyDonateCar(playerid, i, model, price)
{
	new insert_id = cache_insert_id(), str[128];
	if(insert_id != -1) {
		playerCarData[i][carSID] = cache_insert_id();

		SendClientMessage(playerid, 0xADFF2FFF, "PROCESSING: กำลังสร้าง /v list ของคุณใหม่..");
		PlayerCar_Load(playerid);

		format(str, sizeof(str), "ยินดีต้อนรับสู่ %s ของคุณ", g_arrVehicleNames[model - 400]);
		SendClientMessage(playerid, COLOR_WHITE, str);

		SendClientMessageEx(playerid, COLOR_WHITE, "ล็อก[%d] สัญญาณเตือนภัย[%d] อิมโมบิ[%d] ประกันภัย[%d]", playerCarData[i][carLock], playerCarData[i][carAlarm], playerCarData[i][carImmob], playerCarData[i][carInsurance]);
		SendClientMessageEx(playerid, COLOR_WHITE, "อายุการใช้งาน: อายุเครื่องยนต์[%.2f] อายุแบตเตอรี่[%.2f] ระยะไมล์ที่ขับ[%.2f]", playerCarData[i][carEngineL], playerCarData[i][carBatteryL], playerCarData[i][carMileage]);

		SendClientMessage(playerid, COLOR_GREEN, "เครื่องยนต์ดับอยู่ (/engine)");
		SendClientMessage(playerid, 0xADFF2FFF, "PROCESSED: รายการปรับปรุงใหม่");

        playerData[playerid][pPoint] -= price;
        OnAccountUpdate(playerid, MYSQL_UPDATE_TYPE_SINGLE);

		if (VDealerVehicle[playerid])
			DestroyVehicle(VDealerVehicle[playerid]);
			
		VDealerSetting{playerid} = false;
		VDealerFaction{playerid} = false;

		VDealerColor1[playerid] = -1;
		VDealerColor2[playerid] = -1;
		
		VDealerLock[playerid]=0;
		VDealerImmob[playerid]=0;
		VDealerAlarm[playerid]=0;

		SetCameraBehindPlayer(playerid);

		new plate[8];
		format(plate, sizeof(plate), RandomVehiclePlate());
		mysql_format(dbCon, str,sizeof(str),"SELECT * FROM cars WHERE carPlate = '%s'", plate);
		mysql_tquery(dbCon, str, "DuplicatePlates", "iis", playerid, i, plate);

		Iter_Add(Iter_PlayerCar, i);
	}
	else
	{
	    ExitSettingVehicle(playerid);
	    SendClientMessage(playerid, COLOR_RED, "มีข้อผิดพลาดในการซื้อยานพาหนะโปรดติดต่อผู้ดูแลระบบ");
	}

	return 1;
}

forward OnPlayerBuyCar(playerid, i, model, price);
public OnPlayerBuyCar(playerid, i, model, price)
{
	new insert_id = cache_insert_id(), str[128];
	if(insert_id != -1) {
		playerCarData[i][carSID] = cache_insert_id();

		SendClientMessage(playerid, 0xADFF2FFF, "PROCESSING: กำลังสร้าง /v list ของคุณใหม่..");
		PlayerCar_Load(playerid);

		format(str, sizeof(str), "ยินดีต้อนรับสู่ %s ของคุณ", g_arrVehicleNames[model - 400]);
		SendClientMessage(playerid, COLOR_WHITE, str);

		SendClientMessageEx(playerid, COLOR_WHITE, "ล็อก[%d] สัญญาณเตือนภัย[%d] อิมโมบิ[%d] ประกันภัย[%d]", playerCarData[i][carLock], playerCarData[i][carAlarm], playerCarData[i][carImmob], playerCarData[i][carInsurance]);
		SendClientMessageEx(playerid, COLOR_WHITE, "อายุการใช้งาน: อายุเครื่องยนต์[%.2f] อายุแบตเตอรี่[%.2f] ระยะไมล์ที่ขับ[%.2f]", playerCarData[i][carEngineL], playerCarData[i][carBatteryL], playerCarData[i][carMileage]);

		SendClientMessage(playerid, COLOR_GREEN, "เครื่องยนต์ดับอยู่ (/engine)");
		SendClientMessage(playerid, 0xADFF2FFF, "PROCESSED: รายการปรับปรุงใหม่");

        GivePlayerMoneyEx(playerid, -price);
        OnAccountUpdate(playerid, MYSQL_UPDATE_TYPE_SINGLE);

		if (VDealerVehicle[playerid])
			DestroyVehicle(VDealerVehicle[playerid]);
			
		VDealerSetting{playerid} = false;
		VDealerFaction{playerid} = false;

		VDealerColor1[playerid] = -1;
		VDealerColor2[playerid] = -1;
		
		VDealerLock[playerid]=0;
		VDealerImmob[playerid]=0;
		VDealerAlarm[playerid]=0;

		SetCameraBehindPlayer(playerid);

		new plate[8];
		format(plate, sizeof(plate), RandomVehiclePlate());
		mysql_format(dbCon, str,sizeof(str),"SELECT * FROM cars WHERE carPlate = '%s'", plate);
		mysql_tquery(dbCon, str, "DuplicatePlates", "iis", playerid, i, plate);

		Iter_Add(Iter_PlayerCar, i);
	}
	else
	{
	    ExitSettingVehicle(playerid);
	    SendClientMessage(playerid, COLOR_RED, "มีข้อผิดพลาดในการซื้อยานพาหนะโปรดติดต่อผู้ดูแลระบบ");
	}

	return 1;
}

forward DuplicatePlates(playerid, id, plate[]);
public DuplicatePlates(playerid, id, plate[])
{
    new
		rows;

    cache_get_row_count(rows);

    if(rows)
    {
		new newplate[8], str[47];
		format(newplate, sizeof(newplate), RandomVehiclePlate());

      	mysql_format(dbCon, str,sizeof(str),"SELECT * FROM cars WHERE carPlate = '%s'", newplate);
		mysql_tquery(dbCon, str, "DuplicatePlates", "iis", playerid, id, newplate);
    }
    else {

		format(playerCarData[id][carPlate], 32, plate);

		playerCarData[id][carVehicle] = CreateVehicle(playerCarData[id][carModel], playerCarData[id][carPos][0],playerCarData[id][carPos][1],playerCarData[id][carPos][2],playerCarData[id][carPos][3], playerCarData[id][carColor1], playerCarData[id][carColor2], -1);
        SetVehicleNumberPlate(playerCarData[id][carVehicle], playerCarData[id][carPlate]);

		LinkVehicleToInterior(playerCarData[id][carVehicle], playerCarData[id][carInt]);
		SetVehicleVirtualWorld(playerCarData[id][carVehicle], playerCarData[id][carWorld]);
			
		playerData[playerid][pPCarkey] = id;

	  	vehicleData[playerCarData[id][carVehicle]][vFuel] = playerCarData[id][carFuel];

		new
			engine,
			lights,
			alarm,
			doors,
			bonnet,
			boot,
			objective;

		GetVehicleParamsEx(playerCarData[id][carVehicle], engine, lights, alarm, doors, bonnet, boot, objective);
        SetVehicleParamsEx(playerCarData[id][carVehicle], engine, lights, alarm, 0, bonnet, boot, objective);

		SetVehicleHealthEx(playerCarData[id][carVehicle], playerCarData[id][carHealth]);
		
		PutPlayerInVehicle(playerid, playerCarData[id][carVehicle], 0);
		RandomVehiclePark(GetPVarInt(playerid, "BuyCarBusinessID"), id);
        PlayerCar_SaveID(id);

		TogglePlayerControllable(playerid, IsABike(playerCarData[id][carVehicle]));
/*
		new str[43];
		format(str, sizeof(str), "Your new plate has been set~n~~y~%s.", playerCarData[id][carPlate]);
		ShowPlayerFooter(playerid, str);*/
		Mobile_GameTextForPlayer(playerid, sprintf("~n~~n~~n~~n~~n~Your new plate has been set~n~~y~%s.", playerCarData[id][carPlate]), 5000, 3);
		
	}
    return 1;
}


ExitSettingVehicle(playerid)
{
	if(VDealerSetting{playerid})
	{
	    VDealerSetting{playerid} = false;
		VDealerFaction{playerid} = false;

		if (VDealerVehicle[playerid])
		    DestroyVehicle(VDealerVehicle[playerid]);

        TogglePlayerControllable(playerid, true);
        Dialog_Close(playerid);
		VDealerLock[playerid]=0;
		VDealerImmob[playerid]=0;
		VDealerAlarm[playerid]=0;
		SetCameraBehindPlayer(playerid);
	}
}

GetVehicleColorList()
{
    static
    	color_code[3344];

    if (color_code[0] == EOS) {
    	for(new i = 0; i < 128; i++)
    	{
    	    if(i > 0 && (i % 16) == 0) format(color_code, sizeof(color_code), "%s\n{%06x}#%03d", color_code, g_arrCarColors[i] >>> 8, i);
    	    else format(color_code, sizeof(color_code), "%s{%06x}#%03d ", color_code, g_arrCarColors[i] >>> 8, i);
    	}
    }
    return color_code;
}

Dialog:DialogCarColor1(playerid, response, listitem, inputtext[])
{
    if (response) {
	    VDealerColor1[playerid] = strval(inputtext);
		if (isPlayerAndroid(playerid) == 0) {
			SetVehicleColor(VDealerVehicle[playerid], VDealerColor1[playerid], VDealerColor2[playerid]);
		}
		else {
			new model = GetVehicleModel(VDealerVehicle[playerid]);
			new Float:Vx, Float:Vy, Float:Vz, Float:Va;
			GetVehiclePos(VDealerVehicle[playerid], Vx,Vy,Vz);
			GetVehicleZAngle(VDealerVehicle[playerid], Va);
			DestroyVehicle(VDealerVehicle[playerid]);
			VDealerVehicle[playerid] = CreateVehicle(model, Vx,Vy,Vz,Va, VDealerColor1[playerid], VDealerColor2[playerid], -1);

			PutPlayerInVehicle(playerid, VDealerVehicle[playerid], 0);
		}
    }
    return ShowEditCarMenu(playerid);
}

Dialog:DialogCarColor2(playerid, response, listitem, inputtext[])
{
    if (response) {
        VDealerColor2[playerid] = strval(inputtext);
	
		if (isPlayerAndroid(playerid) == 0) {
			SetVehicleColor(VDealerVehicle[playerid], VDealerColor1[playerid], VDealerColor2[playerid]);
		}
		else {
			new model = GetVehicleModel(VDealerVehicle[playerid]);
			new Float:Vx, Float:Vy, Float:Vz, Float:Va;
			GetVehiclePos(VDealerVehicle[playerid], Vx,Vy,Vz);
			GetVehicleZAngle(VDealerVehicle[playerid], Va);
			DestroyVehicle(VDealerVehicle[playerid]);
			VDealerVehicle[playerid] = CreateVehicle(model, Vx,Vy,Vz,Va, VDealerColor1[playerid], VDealerColor2[playerid], -1);

			PutPlayerInVehicle(playerid, VDealerVehicle[playerid], 0);
		}
    }
    return ShowEditCarMenu(playerid);
}

ShowEditCarMenu(playerid) {
    return Dialog_Show(playerid, DealerMenu, DIALOG_STYLE_LIST, sprintf("%s - %s", g_arrVehicleNames[GetVehicleModel(VDealerVehicle[playerid]) - 400], FormatNumber(GetDealershipCountPrice(playerid))), "สัญญาณเตือนภัย\nระบบล็อก\nอิมโมบิไลเซอร์\nเปลี่ยนสี 1\n\nเปลี่ยนสี 2\n%s", "เพิ่มเติม", "<< กลับ", VDealerFaction{playerid} ? (">> สำหรับแฟคชั่น") : ("สำหรับแฟคชั่น"));
}

SetVehicleColor(vehicleid, color1, color2)
{
    new id = -1;
	if ((id = PlayerCar_GetID(vehicleid)) != -1)
	{
	    playerCarData[id][carColor1] = color1;
	    playerCarData[id][carColor2] = color2;
	}
	return ChangeVehicleColor(vehicleid, color1, color2);
}

PlayerCar_GetID(vehicleid)
{
	if(vehicleid == -1 || vehicleid == INVALID_VEHICLE_ID) return -1;

	foreach(new i : Iter_PlayerCar) {
		if(playerCarData[i][carVehicle]==vehicleid) {
			return i;
		}
	}
	return -1;
}

PlayerCar_GetLocked(carid)
{
	if(Iter_Contains(Iter_PlayerCar, carid)) {
		return playerCarData[carid][carLocked];
	}
	return 0;
}

PlayerCar_GetAlarm(carid)
{
	if(Iter_Contains(Iter_PlayerCar, carid)) {
		return playerCarData[carid][carAlarm];
	}
	return 0;
}

PlayerCar_GetOwnerSID(carid)
{
	if(Iter_Contains(Iter_PlayerCar, carid)) {
		return playerCarData[carid][carSID];
	}
	return 0;
}

PlayerCar_SetLocked(carid, bool:lock_status)
{
	if(Iter_Contains(Iter_PlayerCar, carid)) {
		playerCarData[carid][carLocked] = lock_status;
	}
}
/*
PlayerCar_Respawn(carid)
{
	if(Iter_Contains(Iter_PlayerCar, carid)) {
		SetVehicleToRespawn(playerCarData[carid][carVehicle]);
		LinkVehicleToInterior(playerCarData[carid][carVehicle], playerCarData[carid][carInt]);
		SetVehicleVirtualWorld(playerCarData[carid][carVehicle], playerCarData[carid][carWorld]);
	}
}
*/
RandomVehiclePlate()
{
	const len = 7;
	new plate[len+1];
	for (new i = 0; i < len; i++)
	{
	    if (i > 0 && i < 4) // letter or number?
	    {
	     	plate[i] = 'A' + random(26);
	    }
	    else
	    { // number
	    	plate[i] = '0' + random(10);
	    }
	}
	return plate;
}

forward RandomVehiclePark(bizid, carid);
public RandomVehiclePark(bizid, carid)
{
	new
		Float:vehRandom[4]
	;

	new rand;
	
	if(playerCarData[carid][carModel] == 532) {

		rand = random(sizeof(gCombineSpawn));

		vehRandom[0]=gCombineSpawn[rand][0];
		vehRandom[1]=gCombineSpawn[rand][1];
		vehRandom[2]=gCombineSpawn[rand][2];
		vehRandom[3]=gCombineSpawn[rand][3];
	}
	else if(IsABoat(playerCarData[carid][carModel]))
	{
		rand = random(sizeof(gBoatSpawn));

		vehRandom[0]=gBoatSpawn[rand][0];
		vehRandom[1]=gBoatSpawn[rand][1];
		vehRandom[2]=gBoatSpawn[rand][2];
		vehRandom[3]=gBoatSpawn[rand][3];
	}
	else if(IsAPlaneModel(playerCarData[carid][carModel]))
	{
		rand = random(sizeof(gPlaneSpawn));

		vehRandom[0]=gPlaneSpawn[rand][0];
		vehRandom[1]=gPlaneSpawn[rand][1];
		vehRandom[2]=gPlaneSpawn[rand][2];
		vehRandom[3]=gPlaneSpawn[rand][3];
	}
	else {
		if (businessData[bizid][bID] == 7) {
			rand = random(sizeof(gVehicleSpawn_SF));

			vehRandom[0]=gVehicleSpawn_SF[rand][0];
			vehRandom[1]=gVehicleSpawn_SF[rand][1];
			vehRandom[2]=gVehicleSpawn_SF[rand][2];
			vehRandom[3]=gVehicleSpawn_SF[rand][3];
		}
		else {
			rand = random(sizeof(gVehicleSpawn_LS));

			vehRandom[0]=gVehicleSpawn_LS[rand][0];
			vehRandom[1]=gVehicleSpawn_LS[rand][1];
			vehRandom[2]=gVehicleSpawn_LS[rand][2];
			vehRandom[3]=gVehicleSpawn_LS[rand][3];
		}
	}

	playerCarData[carid][carPos][0]=vehRandom[0];
	playerCarData[carid][carPos][1]=vehRandom[1];
	playerCarData[carid][carPos][2]=vehRandom[2];
	playerCarData[carid][carPos][3]=vehRandom[3];
	return 1;
}

PlayerCar_Load(playerid) {
	return mysql_tquery(dbCon, sprintf("SELECT carID, carModel, carPosX, carPosY, carPosZ FROM `cars` WHERE `carOwner` = %d", playerData[playerid][pSID]), "RebuildCarList", "i", playerid);
}

forward RebuildCarList(playerid);
public RebuildCarList(playerid) 
{
	new
	    rows;
	cache_get_row_count(rows);

	playerData[playerid][pPCarkey] = -1;

	for (new i = 0; i != MAX_OWNED_CAR; i ++)
	{
		if (i < rows) {

			cache_get_value_name_int(i, "carID",playerCarList[playerid][i][CLD_ID]);
			cache_get_value_name_int(i, "carModel",playerCarList[playerid][i][CLD_Model]);
			cache_get_value_name_float(i, "carPosX",playerCarList[playerid][i][CLD_Pos_X]);
			cache_get_value_name_float(i, "carPosY",playerCarList[playerid][i][CLD_Pos_Y]);
			cache_get_value_name_float(i, "carPosZ",playerCarList[playerid][i][CLD_Pos_Z]);

			foreach(new c : Iter_PlayerCar)
			{
				if(playerCarData[c][carSID] == playerCarList[playerid][i][CLD_ID]) {
					playerData[playerid][pPCarkey] = c;
					playerCarData[c][carDespawn]=false;
				}
			}
		}
		else {
			playerCarList[playerid][i][CLD_ID] =
			playerCarList[playerid][i][CLD_Model] = 0;
			playerCarList[playerid][i][CLD_Pos_X] = 
			playerCarList[playerid][i][CLD_Pos_Y] = 
			playerCarList[playerid][i][CLD_Pos_Z] = 0.0;
		}
	}
	return 1;
}

PlayerCar_SaveID(carid, thread = MYSQL_UPDATE_TYPE_THREAD)
{
	if(Iter_Contains(Iter_PlayerCar, carid))
	{

		if(playerCarData[carid][carVehicle] != INVALID_VEHICLE_ID && playerCarData[carid][carVehicle] < MAX_VEHICLES)
			playerCarData[carid][carFuel] = vehicleData[playerCarData[carid][carVehicle]][vFuel];

        new query[MAX_STRING];
		MySQLUpdateInit("cars", "carID", playerCarData[carid][carSID], thread); 
        MySQLUpdateInt(query, "carModel", playerCarData[carid][carModel]);
        MySQLUpdateInt(query, "carOwner", playerCarData[carid][carOwner]);
        MySQLUpdateFlo(query, "carPosX", playerCarData[carid][carPos][0]);
        MySQLUpdateFlo(query, "carPosY", playerCarData[carid][carPos][1]);
        MySQLUpdateFlo(query, "carPosZ", playerCarData[carid][carPos][2]);
        MySQLUpdateFlo(query, "carPosR", playerCarData[carid][carPos][3]);
        MySQLUpdateInt(query, "carColor1", playerCarData[carid][carColor1]);
        MySQLUpdateInt(query, "carColor2", playerCarData[carid][carColor2]);
        MySQLUpdateInt(query, "carPaintjob", playerCarData[carid][carPaintjob]);
        MySQLUpdateInt(query, "carDonate", playerCarData[carid][carDonate]);
        MySQLUpdateInt(query, "carAlarm", playerCarData[carid][carAlarm]);
        MySQLUpdateFlo(query, "carFuel", playerCarData[carid][carFuel]);
        MySQLUpdateInt(query, "carInsurance", playerCarData[carid][carInsurance]);
        MySQLUpdateInt(query, "carDamage1", playerCarData[carid][carDamage][0]);
        MySQLUpdateInt(query, "carDamage2", playerCarData[carid][carDamage][1]);
        MySQLUpdateInt(query, "carDamage3", playerCarData[carid][carDamage][2]);
        MySQLUpdateInt(query, "carDamage4", playerCarData[carid][carDamage][3]);
        MySQLUpdateFlo(query, "carHealth", playerCarData[carid][carHealth]);
        MySQLUpdateInt(query, "carDestroyed", playerCarData[carid][carDestroyed]);
		MySQLUpdateInt(query, "carComp", playerCarData[carid][carComp]);
        MySQLUpdateInt(query, "carLock", playerCarData[carid][carLock]);
        MySQLUpdateInt(query, "carImmob", playerCarData[carid][carImmob]);
        MySQLUpdateFlo(query, "carMileage", playerCarData[carid][carMileage]);
        MySQLUpdateFlo(query, "carBatteryL", playerCarData[carid][carBatteryL]);
        MySQLUpdateFlo(query, "carEngineL", playerCarData[carid][carEngineL]);
        MySQLUpdateStr(query, "carPlate", playerCarData[carid][carPlate]);
        MySQLUpdateInt(query, "carDuplicate", playerCarData[carid][carDupKey]);
        MySQLUpdateInt(query, "carWorld", playerCarData[carid][carWorld]);
        MySQLUpdateInt(query, "carInt", playerCarData[carid][carInt]);
        MySQLUpdateInt(query, "carOwe", playerCarData[carid][carOwe]);

		MySQLUpdateInt(query, "carWeapon0", playerCarData[carid][carWeapon][0]);
		MySQLUpdateInt(query, "carWeapon1", playerCarData[carid][carWeapon][1]);
		MySQLUpdateInt(query, "carWeapon2", playerCarData[carid][carWeapon][2]);
		MySQLUpdateInt(query, "carWeapon3", playerCarData[carid][carWeapon][3]);

		MySQLUpdateInt(query, "carAmmo0", playerCarData[carid][carAmmo][0]);
		MySQLUpdateInt(query, "carAmmo1", playerCarData[carid][carAmmo][1]);
		MySQLUpdateInt(query, "carAmmo2", playerCarData[carid][carAmmo][2]);
		MySQLUpdateInt(query, "carAmmo3", playerCarData[carid][carAmmo][3]);

		MySQLUpdateInt(query, "carMod1", playerCarData[carid][carMods][0]);
		MySQLUpdateInt(query, "carMod2", playerCarData[carid][carMods][1]);
		MySQLUpdateInt(query, "carMod3", playerCarData[carid][carMods][2]);
		MySQLUpdateInt(query, "carMod4", playerCarData[carid][carMods][3]);
		MySQLUpdateInt(query, "carMod5", playerCarData[carid][carMods][4]);
		MySQLUpdateInt(query, "carMod6", playerCarData[carid][carMods][5]);
		MySQLUpdateInt(query, "carMod7", playerCarData[carid][carMods][6]);
		MySQLUpdateInt(query, "carMod8", playerCarData[carid][carMods][7]);
		MySQLUpdateInt(query, "carMod9", playerCarData[carid][carMods][8]);
		MySQLUpdateInt(query, "carMod10", playerCarData[carid][carMods][9]);
		MySQLUpdateInt(query, "carMod11", playerCarData[carid][carMods][10]);
		MySQLUpdateInt(query, "carMod12", playerCarData[carid][carMods][11]);
		MySQLUpdateInt(query, "carMod13", playerCarData[carid][carMods][12]);
		MySQLUpdateInt(query, "carMod14", playerCarData[carid][carMods][13]);


		MySQLUpdateFinish(query);
        return 1;
	}
	else
	{
	    return 0;
	}
}

SpawnPlayerCar(playerid, carid)
{
	if(playerData[playerid][pPCarkey] != -1)
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: คุณมียานพาหนะส่วนตัวที่ปรากฏอยู่แล้ว");
	    return 1;
	}
	mysql_tquery(dbCon, sprintf("SELECT * FROM `cars` WHERE `carOwner` = %d AND `carID` = %d", playerData[playerid][pSID], carid), "OnLoadPlayerCar", "i", playerid);
    return 1;
}

forward OnLoadPlayerCar(playerid, slot);
public OnLoadPlayerCar(playerid, slot) {

    new
	    rows,
		str[256];

	cache_get_row_count(rows);

	if(rows && playerData[playerid][pPCarkey] == -1) {
		new i = -1;
		if((i = Iter_Free(Iter_PlayerCar)) != -1)
		{
			Iter_Add(Iter_PlayerCar, i);

			for(new x = 0; x != MAX_CAR_WEAPONS; x++)
			{
				playerCarData[i][carWeapon][x] = 0;
				playerCarData[i][carAmmo][x] = 0;
				//CarData[i][carWeaponLicense][x] = 0;
			}

			cache_get_value_name_int(0, "carID", playerCarData[i][carSID]);
			cache_get_value_name_int(0, "carOwner", playerCarData[i][carOwner]);
			cache_get_value_name_int(0, "carModel", playerCarData[i][carModel]);
			cache_get_value_name_float(0, "carPosX", playerCarData[i][carPos][0]);
			cache_get_value_name_float(0, "carPosY", playerCarData[i][carPos][1]);
			cache_get_value_name_float(0, "carPosZ", playerCarData[i][carPos][2]);
			cache_get_value_name_float(0, "carPosR", playerCarData[i][carPos][3]);
			cache_get_value_name_int(0, "carColor1", playerCarData[i][carColor1]);
			cache_get_value_name_int(0, "carColor2", playerCarData[i][carColor2]);
			cache_get_value_name_int(0, "carLock", playerCarData[i][carLock]);
			cache_get_value_name_int(0, "carDonate", playerCarData[i][carDonate]);
			cache_get_value_name_int(0, "carAlarm", playerCarData[i][carAlarm]);
			cache_get_value_name_int(0, "carInsurance", playerCarData[i][carInsurance]);
			cache_get_value_name_float(0, "carMileage", playerCarData[i][carMileage]);
			cache_get_value_name_int(0, "carImmob", playerCarData[i][carImmob]);
			cache_get_value_name_float(0, "carBatteryL", playerCarData[i][carBatteryL]);
			cache_get_value_name_float(0, "carEngineL", playerCarData[i][carEngineL]);
			cache_get_value_name_float(0, "carFuel", playerCarData[i][carFuel]);
			cache_get_value_name_int(0, "carDamage1", playerCarData[i][carDamage][0]);
			cache_get_value_name_int(0, "carDamage2", playerCarData[i][carDamage][1]);
			cache_get_value_name_int(0, "carDamage3", playerCarData[i][carDamage][2]);
			cache_get_value_name_int(0, "carDamage4", playerCarData[i][carDamage][3]);
			cache_get_value_name_float(0, "carHealth", playerCarData[i][carHealth]);
			cache_get_value_name_int(0, "carDestroyed", playerCarData[i][carDestroyed]);
			cache_get_value_name_int(0, "carComp", playerCarData[i][carComp]);
			cache_get_value_name(0, "carPlate", playerCarData[i][carPlate], 32);
			cache_get_value_name_int(0, "carDuplicate", playerCarData[i][carDupKey]);
			cache_get_value_name_int(0, "carPaintjob", playerCarData[i][carPaintjob]);
			cache_get_value_name_int(0, "carWorld", playerCarData[i][carWorld]);
			cache_get_value_name_int(0, "carInt", playerCarData[i][carInt]);
			cache_get_value_name_int(0, "carOwe", playerCarData[i][carOwe]);

	
			playerCarData[i][carVehicle] = CreateVehicle(playerCarData[i][carModel], playerCarData[i][carPos][0], playerCarData[i][carPos][1], playerCarData[i][carPos][2], playerCarData[i][carPos][3], playerCarData[i][carColor1], playerCarData[i][carColor2], -1);
			UpdateVehicleDamageStatus(playerCarData[i][carVehicle],playerCarData[i][carDamage][0],playerCarData[i][carDamage][1],playerCarData[i][carDamage][2],playerCarData[i][carDamage][3]);
			
			if(playerCarData[i][carHealth] >= 250.0) SetVehicleHealthEx(playerCarData[i][carVehicle],playerCarData[i][carHealth]);
			else SetVehicleHealthEx(playerCarData[i][carVehicle],250.0);

			LinkVehicleToInterior(playerCarData[i][carVehicle], playerCarData[i][carInt]);
			SetVehicleVirtualWorld(playerCarData[i][carVehicle], playerCarData[i][carWorld]);

			SetVehicleNumberPlate(playerCarData[i][carVehicle], playerCarData[i][carPlate]);

			for(new x = 0; x != MAX_CAR_WEAPONS; x++)
			{
				format(str, sizeof(str), "carWeapon%d", x);
				cache_get_value_name_int(slot, str, playerCarData[i][carWeapon][x]);

				format(str, sizeof(str), "carAmmo%d", x);
				cache_get_value_name_int(slot, str, playerCarData[i][carAmmo][x]);
			}

			for(new x = 0; x != 14; x++)
			{
				format(str, sizeof(str), "carMod%d", x+1);
				cache_get_value_name_int(slot, str, playerCarData[i][carMods][x]);
				if(playerCarData[i][carMods][x]) {
					switch(playerCarData[i][carMods][x])
					{
						case 1008..1010: if(IsPlayerInInvalidNosVehicle(playerid)) {
							RemoveVehicleComponent(playerCarData[i][carVehicle], playerCarData[i][carMods][x]);
							//playerCarData[i][carNos] = 0;
						}
					}
					if(IsComponentidCompatible(playerCarData[i][carModel], playerCarData[i][carMods][x])) AddVehicleComponent(playerCarData[i][carVehicle], playerCarData[i][carMods][x]);
				}
			}

			ChangeVehiclePaintjob(playerCarData[i][carVehicle], 3 - playerCarData[i][carPaintjob]);

			playerData[playerid][pPCarkey] = i;

			vehicleData[playerCarData[i][carVehicle]][vFuel] = playerCarData[i][carFuel];

			if (playerCarData[i][carLock]) {
				playerCarData[i][carProtect] = 250 * playerCarData[i][carLock] + 250;
			}
			else playerCarData[i][carProtect] = 0;

			playerCarData[i][carLocked] = true;

			SendClientMessageEx(playerid, COLOR_GREEN, "%s ได้ปรากฏขึ้นที่จอดยานพาหนะ:", ReturnVehicleModelName(playerCarData[i][carModel]));
			SendClientMessageEx(playerid, COLOR_WHITE, "ล็อก[%d] สัญญาณเตือนภัย[%d] อิมโมบิ[%d] ประกันภัย[%d]", playerCarData[i][carLock], playerCarData[i][carAlarm], playerCarData[i][carImmob], playerCarData[i][carInsurance]);
			SendClientMessageEx(playerid, COLOR_WHITE, "อายุการใช้งาน: อายุเครื่องยนต์[%.2f] อายุแบตเตอรี่[%.2f] ระยะไมล์ที่ขับ[%.2f]", playerCarData[i][carEngineL], playerCarData[i][carBatteryL], playerCarData[i][carMileage]);
			SendClientMessage(playerid, TEAM_CUN_COLOR, "ข้อแนะ: ตามเครื่องหมายสีแดงเพื่อค้นหายานพาหนะของคุณ");

			SetPlayerCheckpoint(playerid,playerCarData[i][carPos][0], playerCarData[i][carPos][1], playerCarData[i][carPos][2], 4.0);
			gPlayerCheckpoint{playerid} = true;

			new
				engine,
				lights,
				alarm,
				doors,
				bonnet,
				boot,
				objective;

			GetVehicleParamsEx(playerCarData[i][carVehicle], engine, lights, alarm, doors, bonnet, boot, objective);
			SetVehicleParamsEx(playerCarData[i][carVehicle], engine, lights, alarm, 0, bonnet, boot, objective);
		}
		else {
			SendClientMessage(playerid, COLOR_LIGHTRED, "จำนวนยานพาหนะส่วนตัวภายในเซิร์ฟเวอร์ถึงจำนวนสูงสุดแล้ว โปรดลองใหม่อีกครั้งภายหลัง!");
		}
	}
	return 1;
}

IsPlayerInInvalidNosVehicle(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	#define MAX_INVALID_NOS_VEHICLES 52
	new InvalidNosVehicles[MAX_INVALID_NOS_VEHICLES] =
	{
		581,523,462,521,463,522,461,448,468,586,417,425,469,487,512,520,563,593,
		509,481,510,472,473,493,520,595,484,430,453,432,476,497,513,533,577,
		452,446,447,454,590,569,537,538,570,449,519,460,488,511,519,548,592
	};
 	if(IsPlayerInAnyVehicle(playerid))
  	{
   		for(new i = 0; i < MAX_INVALID_NOS_VEHICLES; i++)
     	{
      		if(GetVehicleModel(vehicleid) == InvalidNosVehicles[i]) return true;
       	}
   	}
   	return false;
}

IsComponentidCompatible(modelid, componentid)
{
    if(componentid == 1025 || componentid == 1073 || componentid == 1074 || componentid == 1075 || componentid == 1076 ||
         componentid == 1077 || componentid == 1078 || componentid == 1079 || componentid == 1080 || componentid == 1081 ||
         componentid == 1082 || componentid == 1083 || componentid == 1084 || componentid == 1085 || componentid == 1096 ||
         componentid == 1097 || componentid == 1098 || componentid == 1087 || componentid == 1086)
         return true;

    switch (modelid)
    {
        case 400: return (componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1013 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 401: return (componentid == 1005 || componentid == 1004 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 114 || componentid == 1020 || componentid == 1019 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1003 || componentid == 1017 || componentid == 1007);
        case 402: return (componentid == 1009 || componentid == 1009 || componentid == 1010);
        case 404: return (componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1002 || componentid == 1016 || componentid == 1000 || componentid == 1017 || componentid == 1007);
        case 405: return (componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1001 || componentid == 1014 || componentid == 1023 || componentid == 1000);
        case 409: return (componentid == 1009);
        case 410: return (componentid == 1019 || componentid == 1021 || componentid == 1020 || componentid == 1013 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1001 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007);
        case 411: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 412: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 415: return (componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1001 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007);
        case 418: return (componentid == 1020 || componentid == 1021 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1002 || componentid == 1016);
        case 419: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 420: return (componentid == 1005 || componentid == 1004 || componentid == 1021 || componentid == 1019 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1001 || componentid == 1003);
        case 421: return (componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1014 || componentid == 1023 || componentid == 1016 || componentid == 1000);
        case 422: return (componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1017 || componentid == 1007);
        case 426: return (componentid == 1005 || componentid == 1004 || componentid == 1021 || componentid == 1019 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1003);
        case 429: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 436: return (componentid == 1020 || componentid == 1021 || componentid == 1022 || componentid == 1019 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1003 || componentid == 1017 || componentid == 1007);
        case 438: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 439: return (componentid == 1003 || componentid == 1023 || componentid == 1001 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1017 || componentid == 1007 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1013);
        case 442: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 445: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 451: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 458: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 466: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 467: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 474: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 475: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 477: return (componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1017 || componentid == 1007);
        case 478: return (componentid == 1005 || componentid == 1004 || componentid == 1012 || componentid == 1020 || componentid == 1021 || componentid == 1022 || componentid == 1013 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 479: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 480: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 489: return (componentid == 1005 || componentid == 1004 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1013 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1002 || componentid == 1016 || componentid == 1000);
        case 491: return (componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1014 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007);
        case 492: return (componentid == 1005 || componentid == 1004 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1016 || componentid == 1000);
        case 496: return (componentid == 1006 || componentid == 1017 || componentid == 1007 || componentid == 1011 || componentid == 1019 || componentid == 1023 || componentid == 1001 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1003 || componentid == 1002 || componentid == 1142 || componentid == 1143 || componentid == 1020);
        case 500: return (componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1013 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 506: return (componentid == 1009);
        case 507: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 516: return (componentid == 1004 || componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1002 || componentid == 1015 || componentid == 1016 || componentid == 1000 || componentid == 1017 || componentid == 1007);
        case 517: return (componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1002 || componentid == 1023 || componentid == 1016 || componentid == 1003 || componentid == 1017 || componentid == 1007);
        case 518: return (componentid == 1005 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1018 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007);
        case 526: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 527: return (componentid == 1021 || componentid == 1020 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1001 || componentid == 1014 || componentid == 1015 || componentid == 1017 || componentid == 1007);
        case 529: return (componentid == 1012 || componentid == 1011 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007);
        case 533: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 534: return (componentid == 1126 || componentid == 1127 || componentid == 1179 || componentid == 1185 || componentid == 1100 || componentid == 1123 || componentid == 1125 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1180 || componentid == 1178 || componentid == 1101 || componentid == 1122 || componentid == 1124 || componentid == 1106);
        case 535: return (componentid == 1109 || componentid == 1110 || componentid == 1113 || componentid == 1114 || componentid == 1115 || componentid == 1116 || componentid == 1117 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1120 || componentid == 1118 || componentid == 1121 || componentid == 1119);
        case 536: return (componentid == 1104 || componentid == 1105 || componentid == 1182 || componentid == 1181 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1184 || componentid == 1183 || componentid == 1128 || componentid == 1103 || componentid == 1107 || componentid == 1108);
        case 540: return (componentid == 1004 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1017 || componentid == 1007);
        case 541: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 542: return (componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1014 || componentid == 1015);
        case 545: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 546: return (componentid == 1004 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1019 || componentid == 1018 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1002 || componentid == 1001 || componentid == 1023 || componentid == 1017 || componentid == 1007);
        case 547: return (componentid == 1142 || componentid == 1143 || componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1016 || componentid == 1003 || componentid == 1000);
        case 549: return (componentid == 1012 || componentid == 1011 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1001 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007);
        case 550: return (componentid == 1005 || componentid == 1004 || componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1003);
        case 551: return (componentid == 1005 || componentid == 1020 || componentid == 1021 || componentid == 1019 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1002 || componentid == 1023 || componentid == 1016 || componentid == 1003);
        case 555: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 558: return (componentid == 1092 || componentid == 1089 || componentid == 1166 || componentid == 1165 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1168 || componentid == 1167 || componentid == 1088 || componentid == 1091 || componentid == 1164 || componentid == 1163 || componentid == 1094 || componentid == 1090 || componentid == 1095 || componentid == 1093);
        case 559: return (componentid == 1065 || componentid == 1066 || componentid == 1160 || componentid == 1173 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1159 || componentid == 1161 || componentid == 1162 || componentid == 1158 || componentid == 1067 || componentid == 1068 || componentid == 1071 || componentid == 1069 || componentid == 1072 || componentid == 1070 || componentid == 1009);
        case 560: return (componentid == 1028 || componentid == 1029 || componentid == 1169 || componentid == 1170 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1141 || componentid == 1140 || componentid == 1032 || componentid == 1033 || componentid == 1138 || componentid == 1139 || componentid == 1027 || componentid == 1026 || componentid == 1030 || componentid == 1031);
        case 561: return (componentid == 1064 || componentid == 1059 || componentid == 1155 || componentid == 1157 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1154 || componentid == 1156 || componentid == 1055 || componentid == 1061 || componentid == 1058 || componentid == 1060 || componentid == 1062 || componentid == 1056 || componentid == 1063 || componentid == 1057);
        case 562: return (componentid == 1034 || componentid == 1037 || componentid == 1171 || componentid == 1172 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1149 || componentid == 1148 || componentid == 1038 || componentid == 1035 || componentid == 1147 || componentid == 1146 || componentid == 1040 || componentid == 1036 || componentid == 1041 || componentid == 1039);
        case 565: return (componentid == 1046 || componentid == 1045 || componentid == 1153 || componentid == 1152 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1150 || componentid == 1151 || componentid == 1054 || componentid == 1053 || componentid == 1049 || componentid == 1050 || componentid == 1051 || componentid == 1047 || componentid == 1052 || componentid == 1048);
        case 566: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 567: return (componentid == 1129 || componentid == 1132 || componentid == 1189 || componentid == 1188 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1187 || componentid == 1186 || componentid == 1130 || componentid == 1131 || componentid == 1102 || componentid == 1133);
        case 575: return (componentid == 1044 || componentid == 1043 || componentid == 1174 || componentid == 1175 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1176 || componentid == 1177 || componentid == 1099 || componentid == 1042);
        case 576: return (componentid == 1136 || componentid == 1135 || componentid == 1191 || componentid == 1190 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1192 || componentid == 1193 || componentid == 1137 || componentid == 1134);
        case 579: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 580: return (componentid == 1020 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1017 || componentid == 1007);
        case 585: return (componentid == 1142 || componentid == 1143 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1003 || componentid == 1017 || componentid == 1007);
        case 587: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 589: return (componentid == 1005 || componentid == 1004 || componentid == 1144 || componentid == 1145 || componentid == 1020 || componentid == 1018 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1024 || componentid == 1013 || componentid == 1006 || componentid == 1016 || componentid == 1000 || componentid == 1017 || componentid == 1007);
        case 600: return (componentid == 1005 || componentid == 1004 || componentid == 1020 || componentid == 1022 || componentid == 1018 || componentid == 1013 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1017 || componentid == 1007);
        case 602: return (componentid == 1008 || componentid == 1009 || componentid == 1010);
        case 603: return (componentid == 1144 || componentid == 1145 || componentid == 1142 || componentid == 1143 || componentid == 1020 || componentid == 1019 || componentid == 1018 || componentid == 1024 || componentid == 1008 || componentid == 1009 || componentid == 1010 || componentid == 1006 || componentid == 1001 || componentid == 1023 || componentid == 1017 || componentid == 1007);
    }
    return false;
}


PlayerCar_DespawnEx(carid)
{
    if(Iter_Contains(Iter_PlayerCar, carid))
	{
		DestroyVehicle(playerCarData[carid][carVehicle]);
	    playerCarData[carid][carSID] = 0;
	    playerCarData[carid][carOwner] = 0;
	    playerCarData[carid][carVehicle]=INVALID_VEHICLE_ID;
		playerCarData[carid][carDespawn]=false;
		Iter_Remove(Iter_PlayerCar, carid);
	}
}

PlayerVehicle_Reset() {
	foreach(new i : Iter_PlayerCar) {

		new
			cur = i;
			
		if(playerCarData[i][carDespawn] && GetVehicleDriver(playerCarData[i][carVehicle]) == INVALID_PLAYER_ID) {
		
			SaveVehicleDamage(i);
		    PlayerCar_SaveID(i, MYSQL_UPDATE_TYPE_SINGLE);

			DestroyVehicle(playerCarData[i][carVehicle]);

			playerCarData[i][carSID] = 0;
			playerCarData[i][carOwner] = 0;
			playerCarData[i][carVehicle]=INVALID_VEHICLE_ID;
			playerCarData[i][carDespawn]=false;
	
			Iter_SafeRemove(Iter_PlayerCar, cur, i);
		}
	}
}

SaveVehicleDamage(slot)
{
	if(Iter_Contains(Iter_PlayerCar, slot)) {
		GetVehicleDamageStatus(playerCarData[slot][carVehicle],playerCarData[slot][carDamage][0],playerCarData[slot][carDamage][1],playerCarData[slot][carDamage][2],playerCarData[slot][carDamage][3]);
		GetVehicleHealth(playerCarData[slot][carVehicle],playerCarData[slot][carHealth]);
	}
}

hook OnPlayerText(playerid, text[]) {
	if (GetPVarType(playerid, "CarOffer_PID")) {
		new offerid = GetPVarInt(playerid, "CarOffer_PID"), carid = GetPVarInt(playerid, "CarOffer_CID"), price = GetPVarInt(playerid, "CarOffer_PRICE");
		
		if (isequal(text, "Y", true)) {
			Mobile_GameTextForPlayer(offerid, sprintf("~n~~n~~n~~y~%s ~g~has accepted your offer!", ReturnRealName(playerid)), 3000, 5);
			Mobile_GameTextForPlayer(playerid, sprintf("~n~~n~~n~~g~You have accepted ~y~%s~g~ offer!", ReturnRealName(offerid)), 3000, 5);

			if(GetPlayerMoney(playerid) >= price)
			{
				if(playerData[offerid][pPCarkey] == carid) {
					new vehicleid = GetPlayerVehicleID(offerid);

					if(IsDonateCar(playerCarData[carid][carModel])) 
						return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถซื้อยานพาหนะบริจาคนี้ได้");

					if(IsPlayerInOwnedCar(offerid, vehicleid))
					{
						GivePlayerMoneyEx(offerid, price);
						GivePlayerMoneyEx(playerid, -price);

						/*playerData[playerid][pPCarkey] = carid;
						playerData[offerid][pPCarkey] = -1;*/

						playerCarData[carid][carOwner] = playerData[playerid][pSID];
						PlayerCar_SaveID(carid, MYSQL_UPDATE_TYPE_SINGLE);

						SendClientMessage(offerid, 0xADFF2FFF, "PROCESSING: กำลังสร้าง /v list ของคุณใหม่..");
						PlayerCar_Load(playerid);
						PlayerCar_Load(offerid);

						SendClientMessageEx(offerid, 0xADFF2FFF, "PROCESSED: รายการปรับปรุงใหม่ %s", (GetNumberOwnerCar(offerid)) ? (""):("คุณไม่มียานพาหนะเหลืออยู่แล้ว"));

						Log(transferlog, INFO, "%s ขาย %s ในราคา %s ให้กับ %s", ReturnPlayerName(offerid), ReturnVehicleModelName(playerCarData[carid][carModel]), FormatNumber(price), ReturnPlayerName(playerid));
						SendAdminMessage(COLOR_YELLOW, CMD_ADM_3, "AdmCmd: %s ได้ขายยานพาหนะ %s ในราคา %s ให้กับผู้เล่น %s", ReturnPlayerName(offerid), ReturnVehicleModelName(playerCarData[carid][carModel]), FormatNumber(price), ReturnPlayerName(playerid));

						OnAccountUpdate(playerid);
						OnAccountUpdate(offerid);
					}
					else
					{
						SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: เจ้าของต้องอยู่ในยานพาหนะเพื่อทำข้อเสนอนี้ให้สำเร็จ!");
						SendClientMessage(offerid, COLOR_LIGHTRED, "SERVER: เจ้าของต้องอยู่ในยานพาหนะเพื่อทำข้อเสนอนี้ให้สำเร็จ!");
					}
				}
				else {
					SendClientMessage(playerid, COLOR_LIGHTRED, "คุณมีเงินไม่พอ!");
					SendClientMessage(offerid, COLOR_LIGHTRED, "ยานพาหนะของคุณไม่สามารถขายได้เพราะผู้เล่นนั้นมีเงินไม่เพียงพอ");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "ยานพาหนะคันนี้ไม่มีอยู่ให้ขายแล้ว!");
				SendClientMessage(offerid, COLOR_LIGHTRED, "ไม่พบยานพาหนะที่จะขายของคุณ");
			}

			DeletePVar(playerid, "CarOffer_PID");
			DeletePVar(playerid, "CarOffer_CID");
			DeletePVar(playerid, "CarOffer_PRICE");
		}
		else if (isequal(text, "N", true)) {
			Mobile_GameTextForPlayer(offerid, sprintf("~n~~n~~n~~y~%s ~r~has denied your offer!", ReturnRealName(playerid)), 3000, 5);
			Mobile_GameTextForPlayer(playerid, sprintf("~n~~n~~n~~r~You have denied ~y~%s~r~ offer!", ReturnRealName(offerid)), 3000, 5);

			DeletePVar(playerid, "CarOffer_PID");
			DeletePVar(playerid, "CarOffer_CID");
			DeletePVar(playerid, "CarOffer_PRICE");
		}
		return -1;
	}
	return 0;
}

PlayerCar_DecreaseEngine(carid, Float:value) {
	if(Iter_Contains(Iter_PlayerCar, carid)) {
		playerCarData[carid][carEngineL] -= value;
		if (playerCarData[carid][carEngineL] < 0.0) {
			playerCarData[carid][carEngineL] = 0.0;
		}
	}
	return 1;
}		

PlayerCar_DecreaseBattery(carid, Float:value) {
	if(Iter_Contains(Iter_PlayerCar, carid)) {
		playerCarData[carid][carBatteryL] -= value;
		if (playerCarData[carid][carBatteryL] < 0.0) {
			playerCarData[carid][carBatteryL] = 0.0;
		}
	}
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid) {
	#if defined SV_DEBUG
		printf("ownership_car.pwn: OnPlayerEnterCheckpoint(playerid %d)", playerid);
	#endif
	return 1;
}


hook OnVehicleSpawn(vehicleid)
{
	#if defined SV_DEBUG
		printf("ownership_car.pwn: OnVehicleSpawn(vehicleid %d)", vehicleid);
	#endif

    if(!VehicleLabel_GetTime(vehicleid)) {
		Vehicle_ResetVehicle(vehicleid);
	}
	return 1;
}

hook OnVehicleDeath(vehicleid, killerid)
{
	new id = -1;

	if((id = PlayerCar_GetID(vehicleid)) != -1)
	{
		// Log_Write("logs/vehicle_death.txt", "[%s] %s (%s) has destroy car %d (SID:%d) [Ins:%d, E: %f, B: %f]", ReturnDate(), ReturnPlayerName(killerid), playerData[killerid][pIP], id, playerCarData[id][carSID], playerCarData[id][carInsurance], playerCarData[id][carEngineL], playerCarData[id][carBatteryL]);
		
		playerCarData[id][carDestroyed]++;
		playerCarData[id][carEngineL]-=float(10+random(5));
		playerCarData[id][carBatteryL]-=float(10);

		if (playerCarData[id][carBatteryL] < 0.0) {
			playerCarData[id][carBatteryL] = 0.0;
		}
		if (playerCarData[id][carEngineL] < 0.0) {
			playerCarData[id][carEngineL] = 0.0;
		}	
		new ownerid = -1;
		if((ownerid = IsCharacterOnline(playerCarData[id][carOwner])) != -1) {
			SendClientMessageEx(ownerid, COLOR_LIGHTRED, "%s ของคุณถูกทำลาย", g_arrVehicleNames[playerCarData[id][carModel] - 400]);
			SendClientMessageEx(ownerid, COLOR_LIGHTRED, "อายุการใช้งาน: อายุเครื่องยนต์ลดลงเหลือ "EMBED_WHITE"%.2f{FF6347} อายุแบตเตอรี่ลดลงเหลือ "EMBED_WHITE"%.2f{FF6347}", playerCarData[id][carEngineL], playerCarData[id][carBatteryL]);
		}
		GetVehicleDamageStatus(vehicleid,playerCarData[id][carDamage][0],playerCarData[id][carDamage][1],playerCarData[id][carDamage][2],playerCarData[id][carDamage][3]);
		playerCarData[id][carHealth]=300.0;
	
		if(playerCarData[id][carInsurance] > 0)
		{
			if(playerCarData[id][carOwe] > 0) {
			
				if(ownerid != -1)
					SendClientMessage(ownerid, COLOR_LIGHTRED, "INSURANCE: บริการประกันภัยรถยนต์ของคุณถูกยกเลิกเนื่องจากติดค้างชำระค่าปรับ");
					
				playerCarData[id][carInsurance]=0;
			}
			else {
				playerCarData[id][carHealth] = GetVehicleDataHealth(playerCarData[id][carModel]);
				playerCarData[id][carOwe] += floatround(((playerCarData[id][carHealth] - vehicleData[vehicleid][vHealth]) / 30.0 ) * 2.0, floatround_round);
	
				if(playerCarData[id][carInsurance] > 1)
				{
					playerCarData[id][carDamage][0]=0;
					playerCarData[id][carDamage][1]=0;
					playerCarData[id][carDamage][2]=0;
					playerCarData[id][carDamage][3]=0;
					
					playerCarData[id][carOwe] += random(200);
				}
	
				if(playerCarData[id][carInsurance] < 3) {
					 //playerCarData[id][carXM]=0;
					//playerCarData[id][carPaintjob]=0;
					for(new x = 0; x < 14; x++) playerCarData[id][carMods][x]=0;
				}
			}
		}
	
		PlayerCar_SaveID(id);
		PlayerCar_DespawnEx(id);
		
		if(ownerid != -1)
			playerData[ownerid][pPCarkey] = 0;
	}
	return 1;
}
/*
GetRepairPrice(vehicleid)
{
	return 200 + random(100);
}*/

forward OnPlayerVehicleScrap(playerid, scrap_price);
public OnPlayerVehicleScrap(playerid, scrap_price)
{
	if(cache_affected_rows())
	{
		// Log(pveh_log, INFO, "%s scrap %s for %d", ReturnPlayerName(playerid), g_arrVehicleNames[playerCarData[playerData[playerid][pPCarkey]][carModel] - 400], scrap_price);
		Log(paychecklog, INFO, "%s ขาย %s ในราคา %d", ReturnPlayerName(playerid), g_arrVehicleNames[playerCarData[playerData[playerid][pPCarkey]][carModel] - 400], scrap_price);

		PlayerCar_DespawnEx(playerData[playerid][pPCarkey]);
		playerData[playerid][pPCarkey] = 0;

		PlayerCar_Load(playerid);
		SendClientMessageEx(playerid, COLOR_GREEN, "คุณได้ทำลายยานพาหนะของคุณให้เป็นเศษซากในราคา %s และจะไม่มีมันอีกต่อไป", FormatNumber(scrap_price));
		SendClientMessageEx(playerid, 0xADFF2FFF, "PROCESSED: รายการปรับปรุงใหม่ %s", (GetNumberOwnerCar(playerid)) ? (""):("คุณไม่มียานพาหนะเหลืออยู่แล้ว"));
		GivePlayerMoneyEx(playerid, scrap_price);

		
	}
	else
	{
	    SendClientMessage(playerid, COLOR_RED, "มีข้อผิดพลาดโปรดติดต่อผู้ดูแลระบบ");
	}
	return 1;
}

stock AssignCarLicenseWeapons(carid, const str[])
{
	new wtmp[MAX_CAR_WEAPONS][32];
	strexplode(wtmp,str,"|");
	for(new z = 0; z != MAX_CAR_WEAPONS; ++z)
	{
		playerCarData[carid][carWeaponLicense][z] = strval(wtmp[z]);
	}
}
