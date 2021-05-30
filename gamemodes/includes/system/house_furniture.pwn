#include <YSI\y_hooks>

/*
	PVar ChosenFurnitureObject index ของ furnitureData[houseid][xxx][]
*/
new grantbuild[MAX_PLAYERS];
new FurnObject[MAX_PLAYERS];

#define MAX_FURNITURE 			400
#define MAX_FURNITURE_NAME 		64
#define MAX_FURNITURE_PERPAGE 	20

enum furnitureE
{
	fID,
	fModel,
	fObject,
	fName[MAX_FURNITURE_NAME],
	fInterior,
	fVirtualWorld,
	fMarketPrice,
	Float:fPosX,
	Float:fPosY,
	Float:fPosZ,
	Float:fPosRX,
	Float:fPosRY,
	Float:fPosRZ,
	fLocked,
	fOpened
};
new furnitureData[MAX_HOUSES][MAX_FURNITURE][furnitureE];

new
    Iterator:Iter_HouseFurniture[MAX_HOUSES]<MAX_FURNITURE>;

static const MaterialColorData[][] = {
	"white",
	"red",
	"blue",
	"samporange",
	"green",
	"grey-90-percent",
	"lightblue"
};

enum mSubE
{
    mName[32],
    mModel,
    mtxd[32],
    mtexture[32]
};

static const MaterialData[][mSubE] = {
	{"Lady Desperado", 18028, "cj_bar2", "CJ_nastybar_D"},
	{"Hispanic Pose", 18028, "cj_bar2", "CJ_nastybar_D2"},
	{"Diablo Pose", 18028, "cj_bar2", "CJ_nastybar_D3"},
	{"Jesus Saves", 18028, "cj_bar2", "CJ_nastybar_D4"},
	{"Sun Emblem", 18028, "cj_bar2", "CJ_nastybar_D5"},
	{"S.W.A.T Solider", 18028, "cj_bar2", "CJ_nastybar_D6"},
	{"Engraved Wood", 18028, "cj_bar2", "GB_nastybar01"},
	{"Snow", 3914, "snow", "mp_snow"},
	{"Dirty Sand", 18202, "w_towncs_t", "concretebig4256128"},
	{"Light Sand", 10433, "hashmarket1_sfs", "concretenewb256"},
	{"Grass", 10931, "traingen_sfse", "desgreengrass"},
	{"Light Grass", 10403, "golf_sfs", "golf_greengrass"},
	{"Cracked Ground", 5404, "stormdra1_lae", "des_crackeddirt1"},
	{"Grey Rocks", 10969, "scum_sfse", "Was_scrpyd_floor_hangar"},
	{"Red Rocks", 11421, "desn_desert", "des_redrock1"},
	{"Grey Rocks", 896, "underwater", "greyrockbig"},
	{"Concrete", 9507, "boxybld2_sfw", "sf_concrete1"},
	{"Dirty Concrete", 18200, "w_town2cs_t", "newall3_16c128"},
	{"Clear Water", 3947, "rczero_track", "waterclear256"},
	{"Glass", 17079, "cuntwland", "grasstype3dirt"},
	{"Metal Plate", 2669, "cj_chris", "cj_metalplate2"},
	{"Wood Floor", 16150, "ufo_bar", "sa_wood07_128"},
	{"Wooden Planks", 11497, "des_baitshop", "des_woodslats1"},
	{"Brick", 9495, "vict_sfw", "newall10_seamless"},
	{"Red Brick", 8678, "wddngchplgrnd01", "vgschapelwall01_128"},
	{"Marbled", 12979, "sw_block9", "sw_wall03"},
	{"Stone", 6293, "lawland2", "stonewall_la"},
	{"Zebra Skin", 14533, "pleas_dome", "club_zeb_SFW1"}
};

static const fCategory[][] = {
    "ข้าวของเครื่องใช้",
	"ความสะดวกสบาย",
	"การตกแต่ง",
	"ความบันเทิง",
	"แสงไฟ",
	"การประปา",
	"การเก็บรักษา",
	"ห้องรับแขก",
	"เบ็ดเตล็ด",
	"พิเศษ"
};

enum subCatalogE
{
    catid,
    subname[32],
}

static const fSubCategory[][subCatalogE] = {
{0, "ตู้เย็น"},
{0, "เตา"},
{0, "ถังขยะ"},
{0, "เครื่องใช้ไฟฟ้าขนาดเล็ก"},
{0, "ถังขยะใหญ่"},
{1, "เตียง"},
{1, "เก้าอี้"},
{1, "เก้าอี้มีแขน"},
{1, "ม้านั่งยาว"},
{1, "ม้านั่งเดี่ยว"},
{2, "ผ้าม่าน"},
{2, "ธง"},
{2, "พรมปูพื้น"},
{2, "รูปปั้น"},
{2, "ผ้าขนหนู"},
{2, "ภาพวาด"},
{2, "พืช"},
{2, "โปสเตอร์"},
{3, "อุปกรณ์กีฬา"},
{3, "โทรทัศน์"},
{3, "เครื่องเล่นเกมส์"},
{3, "เครื่องเล่นสื่อ"},
{3, "เครื่องเสียง"},
{3, "ลำโพง"},
{4, "โคมไฟ"},
{4, "เชิงเทียน"},
{4, "ไฟเพดาน"},
{4, "ไฟนีนอน"},
{5, "ห้องน้ำ"},
{5, "อ่างล้างมือ"},
{5, "ฝักบัว"},
{5, "อ่างอาบน้ำ"},
{6, "ตู้เซฟ"},
{6, "ชั้นวางหนังสือ"},
{6, "โต๊ะในครัว"},
{6, "ตู้เก็บเอกสาร"},
{6, "ตู้กับข้าว"},
{7, "โต๊ะกับข้าว"},
{7, "โต๊ะกาแฟ"},
{7, "เคาน์เตอร์"},
{7, "ตู้เก็บของ"},
{7, "ชั้นวางของ"},
{7, "ที่วางทีวี"},
{8, "เครื่องแต่งกาย"},
{8, "เครื่องอุปโภคบริโภค"},
{8, "ประตู"},
{8, "Mess"},
{8, "เบ็ดเตล็ด"},
{8, "เสา"},
{8, "ความปลอดภัย"},
{8, "ออฟฟิศ"},
{8, "ของเล่น"},
{9, "สัตว์"},
{9, "การพนัน"},
{9, "ป้ายแก๊งค์"},
{9, "ปาร์ตี้"},
{9, "เอฟเฟค"},
{9, "กำแพง"},
{9, "กำแพง (ทางประตู)"},
{9, "กำแพง (หน้าต่าง)"},
{9, "กำแพง (บาง)"},
{9, "กำแพง (กว้าง)"},
{9, "กระจก"}
};

enum FURNITURE_DETAILS
{
    furnitureCatalog,
    furnitureSubCatalog,
    furnitureModel,
    furnitureName[48],
    furniturePrice,
}

static const FurnitureItems[][FURNITURE_DETAILS] = {
{0,0, 1780, "Freezer", 5500},
{0,0, 2127, "LoveSet Red Refrigerator",7820},
{0,0, 2131, "Creamy Metal Refrigerator",7820},
{0,0, 2147, "Old Town Refrigerator",7820},
{0,1, 2017, "Maggie's Co. Stove",2400},
{0,1, 2135, "Sterling Co. Stove",3000},
{0,1, 2144, "Old Town Stove",2100},
{0,1, 2294, "LoveSet Stove",4500},
{0,1, 2340, "Creamy Metal Stove",4500},
{0,2, 1235, "Transparent Sides Trash Can", 50},
{0,2, 1300, "Stone Trash Can", 140},
{0,2, 1328, "Aluminum Lid Trash Can", 15},
{0,2, 1329, "Ghetto Trash Can", 10},
{0,2, 1330, "Trash Bag Covered Trash Can", 12},
{0,2, 1337, "Tall Rolling Trash Can", 70},
{0,2, 1339, "Light Blue Rolling Trash Can", 70},
{0,2, 1347, "Street Trash Can", 40},
{0,2, 1359, "Metal Plate Trash Can", 60},
{0,2, 1371, "Hippo Trash Can", 200},
{0,2, 1574, "White Trash Can", 501},
{0,2, 2770, "Cluck n Bell Trash Can", 80},
{0,3, 2149, "Microwave", 100},
{0,3, 2426, "Toaster Oven", 150},
{0,4, 1331, "Recycle Dumpster", 1400},
{0,4, 1332, "Glass Recycle Dumpster", 1400},
{0,4, 1333, "Orange Dumpster", 1200},
{0,4, 1334, "Blue Dumpster", 1200},
{0,4, 1335, "Clothes Recycle Dumpster", 1400},
{0,4, 1336, "Blue Compact Dumpster", 1200},
{0,4, 1372, "Regular Street Dumpster", 2000},
{0,4, 3035, "Black Compact Dumpster", 1200},
{0,4, 1415, "Packed Regular Street Dumpster", 2000},
{1,0, 1700, "Pink Queen Bed", 5750},
{1,0, 1701, "Royal Brown Queen Bed", 6100},
{1,0, 1745, "Green & White Backboard Queen Bed", 6200},
{1,0, 1793, "Stack of Mattresses", 2850},
{1,0, 1794, "Brown Wooden Queen Bed", 6450},
{1,0, 1795, "Basic Beach Bed", 6500},
{1,0, 1796, "Brown Wooden Quilted Bed", 4200},
{1,0, 1797, "Basic Bed & Stylish Legs", 5000},
{1,0, 1798, "Basic Beach Single Bed", 7050},
{1,0, 1799, "Brown Quilted Yellow Queen Bed", 5640},
{1,0, 1800, "Metal Prison Bed", 1520},
{1,0, 1801, "White Wooden Queen Bed", 7000},
{1,0, 1802, "Floral Quilt Wooden Queen Bed", 7200},
{1,0, 1803, "Floral Quilt Wooden Queen Bed (Overhead)	", 7300},
{1,0, 1812, "Shiny Metal Prison Bed", 1800},
{1,0, 2299, "Brown Quilted Queen Bed", 5640},
{1,0, 2302, "Cabin Bed", 3900},
{1,0, 2603, "White Police Cell Bed", 1800},
{1,0, 14866, "Tropical Sand Queen Bed", 9150},
{1,0, 14446, "King Size Zebra Styled Bed", 10200},
{1,1, 1663, "Swivel Chair", 400},
{1,1, 1671, "Arms Rest Swivel Chair", 410},
{1,1, 1720, "Wooden Chair", 500},
{1,1, 1721, "Metallic Chair", 500},
{1,1, 1739, "Dining Chair", 500},
{1,1, 11685, "Brown Thick Silk Armchair", 1080},
{1,1, 2356, "Office Chair", 700},
{1,1, 19996, "Fold Chair", 200},
{1,1, 19994, "Oval Wooden Chair", 1090},
{1,1, 2079, "Green Wooden Dining Chair", 1100},
{1,1, 2120, "Black Wooden Dining Chair", 1150},
{1,1, 2121, "Foldable Red Chair", 400},
{1,1, 2122, "White Dining Chair", 800},
{1,1, 2123, "White Dining Chair Wooden Legs", 900},
{1,1, 2124, "Light Brown Wooden Dining Chair", 850},
{1,1, 19994, "Dark Color Wooden Chair Metallic Legs", 1400},
{1,1, 1806, "Navy Wheeled Office Chair", 725},
{1,1, 2636, "Pizza Chair", 1150},
{1,1, 2724, "Black Metallic Strip Chair", 1350},
{1,1, 2777, "Black Metallic Strip Chair", 1325},
{1,1, 2788, "Red & Green Metallic Burger Chair", 1350},
{1,2, 1724, "Black Silk Arm Chair", 3000},
{1,2, 1705, "Brown Silk Arm Chair", 3000},
{1,2, 1707, "Chevy Arm Chair", 3500},
{1,2, 1708, "Blue Business Arm Chair", 3800},
{1,2, 1711, "Basic Arm Chair", 2000},
{1,2, 1727, "Black Leather Arm Chair", 4000},
{1,2, 1729, "Egg Shaped Basic Arm Chair", 1800},
{1,2, 1735, "Flowered Style Country Arm Chair", 1750},
{1,2, 1755, "Cold Autumn Styled Arm Chair", 1700},
{1,2, 1758, "Autumn Styled Arm Chair", 1500},
{1,2, 1759, "Basic Flower Styled Arm Chair", 1450},
{1,2, 1762, "Basic Wooden Arm Chair", 2000},
{1,2, 1765, "Basic Polyester Tiled Arm Chair", 1850},
{1,2, 1767, "Basic Indian Styled Arm Chair", 1800},
{1,2, 1769, "Blue Cotton Arm Chair", 1450},
{1,2, 2096, "Rocking Chair", 2010},
{1,2, 11682, "Brown Thick Silk Armchair", 3550},
{1,3, 1702, "Brown Silk Couch", 5000},
{1,3, 1703, "Black Silk Couch", 5000},
{1,3, 1706, "Purple Cotton Couch", 4750},
{1,3, 1710, "Long x2 Basic Couch", 4600},
{1,3, 1712, "Long Basic Couch", 4250},
{1,3, 1713, "Blue Business Couch", 5850},
{1,3, 1756, "Basic Indian Styled Couch", 3800},
{1,3, 1757, "Autumn Styled Couch", 3600},
{1,3, 1760, "Cold Autumn Styled Couch", 3500},
{1,3, 1761, "Basic Wooden Couch", 4050},
{1,3, 1763, "Basic Flower Styled Couch", 3500},
{1,3, 1764, "Basic Polyester Tiled Couch", 3950},
{1,3, 1768, "Blue Cotton Couch", 3650},
{1,3, 2290, "Thick Silk Couch", 6650},
{1,4, 1716, "Metal Stool", 650},
{1,4, 1805, "Short Red Cotton Stool", 525},
{1,4, 2293, "Thick Silk Foot Stool", 1000},
{1,4, 2350, "Red Cotton Stool", 425},
{1,4, 2723, "Retro Metal Stool", 700},
{2,0, 2558, "Green Curtains", 750},
{2,0, 2561, "Wide Green Curtains", 900},
{2,1, 2048, "Confederate Flag", 500},
{2,1, 2614, "USA Flags", 500},
{2,1, 11245, "USA Flags", 750},
{2,1, 2914, "Green Flag", 300},
{2,2, 2631, "Red Mat", 350},
{2,2, 2632, "Turquoise Mat", 350},
{2,2, 1828, "Tiger Rug", 3000},
{2,2, 2815, "Runway Rug", 510},
{2,2, 2817, "Bubbles Rug", 300},
{2,2, 2818, "Red & Orange Tile Bath Rug", 320},
{2,2, 2833, "Royal Tan Rug", 550},
{2,2, 2834, "Plain Tan Rug", 500},
{2,2, 2835, "Ovan Tan Rug", 430},
{2,2, 2836, "Royal Diamond Rug", 600},
{2,2, 2841, "Oval Water Tile Rug", 372},
{2,2, 2842, "Pink Diamond Rug", 323},
{2,2, 2847, "Sand Styled Rug", 300},
{2,3, 3471, "Ancient Chinese Lion Statue", 10050},
{2,3, 3935, "Headless Armless Woman Statue", 8000},
{2,3, 14467, "Big Smoke Statue", 18000},
{2,3, 14608, "Huge Buddha Statue", 50000},
{2,3, 3528, "Dragon Head Statue", 25000},
{2,3, 2743, "Crying Man Statue", 15000},
{2,3, 1736, "Moose Head", 5000},
{2,4, 1640, "Green Striped Towel", 250},
{2,4, 1641, "Blue R* Towel", 200},
{2,4, 1642, "White Sprinkled Red Towel", 300},
{2,4, 1643, "Wayland Towel", 245},
{2,5, 2289, "City Painting", 2250},
{2,5, 2287, "Boats Painting", 1500},
{2,5, 2286, "Ship Painting", 1000},
{2,5, 2285, "Abstract Painting", 900},
{2,5, 2284, "Building Painting", 1500},
{2,5, 2274, "Abstract Painting", 2300},
{2,5, 2282, "Landscape Painting", 1300},
{2,5, 2281, "Landscape Painting", 1300},
{2,5, 2280, "Landscape Painting", 1500},
{2,5, 2279, "Landscape Painting", 1400},
{2,5, 2278, "Boat Painting", 950},
{2,5, 2277, "Cat Painting", 1000},
{2,5, 2276, "Bridge Painting", 1200},
{2,5, 2275, "Fruits Painting", 1000},
{2,5, 2274, "Flowers Painting", 1500},
{2,5, 2273, "Flowers Painting", 1250},
{2,5, 2272, "Landscape Painting", 800},
{2,5, 2271, "Abstract Painting", 750},
{2,5, 2270, "Leaves Painting", 1250},
{2,5, 2269, "Landscape Painting", 1100},
{2,5, 2268, "Cat Painting", 1000},
{2,5, 2267, "Ship Painting", 1000},
{2,5, 2266, "City Painting", 850},
{2,5, 2265, "Landscape Painting", 1400},
{2,5, 2264, "Beach Painting", 1350},
{2,5, 2263, "City Painting", 1500},
{2,5, 2262, "City Painting", 1450},
{2,5, 2261, "Bridge Painting", 1500},
{2,5, 2260, "Boat Painting", 1000},
{2,5, 2259, "Landscape Painting", 800},
{2,5, 2258, "Landscape Painting", 2000},
{2,5, 2257, "Abstract Painting", 1200},
{2,5, 2256, "Landscape Painting	", 2250},
{2,5, 2255, "Candy Suxx Painting", 4500},
{2,6, 859, "Plant Top", 350}, //Decorations => Plants
{2,6, 860, "Bushy Plant Top", 375},
{2,6, 861, "Tall Plant Top", 345},
{2,6, 862, "Tall Orange Plant Top", 400},
{2,6, 863, "Cactus Top", 700},
{2,6, 638, "Planted Bush", 2500},
{2,6, 640, "Long Planted Bush", 3000},
{2,6, 948, "Dry Plant Pot", 800},
{2,6, 949, "Normal Plant Pot", 100},
{2,6, 950, "Big Dry Plants Pot", 1200},
{2,6, 2001, "Long Plants Pots", 1350},
{2,6, 2010, "Long Plants Pot 2", 1400},
{2,6, 2011, "Long Plants Pot 3", 1500},
{2,6, 2194, "Short Plants Pot", 700},
{2,6, 2195, "Short Plants Pot 2", 900},
{2,6, 2203, "Empty Pot", 200},
{2,6, 2240, "Weeds In Red Pot", 1350},
{2,6, 2241, "Rusty Pottery Plant", 1200},
{2,6, 2242, "Empty Red Pot", 350},
{2,6, 2244, "Plants With Big Wooden Pot", 1500},
{2,6, 2243, "Red Flowers With Wide Modern Pot", 1400},
{2,6, 2246, "Empty White Vase", 2000},
{2,6, 2247, "Oriental Plants In Glass Vase", 1650},
{2,6, 2248, "Empty Tall Red Vase", 1000},
{2,6, 2249, "Oriental Flowers In Glass Vase", 1500},
{2,6, 2250, "Spring Flowers In Glass Vase", 1200},
{2,6, 2251, "Oriental Flowers In blue Designer Glass", 1600},
{2,6, 2252, "Small Bowl Plant", 1000},
{2,6, 2253, "Red Flowers In Wooden Cube", 1500},
{2,6, 2345, "Vines", 700},
{2,6, 3802, "Hanging Red Flowers", 2250},
{2,6, 3806, "Wall Mounted Flowers", 2500},
{2,6, 3810, "Hanging Flowers", 2250},
{2,6, 3811, "Wall Mounted Flowers With Dandelion", 3000},
{2,6, 861, "Dark Exotic Plants", 2400},
{2,6, 2195, "Potted Shrub", 1200},
{2,7, 2049, "Shooting Target", 140},  //Decorations => Posters
{2,7, 2050, "Shooting Targets", 140},
{2,7, 2051, "Inverted Shooting Target", 140},
{2,7, 2691, "Base 5 Poster", 140},
{2,7, 2695, "Thin Bare 5 Poster", 70},
{2,7, 2696, "Thin Bare 5 Dog Poster", 70},
{2,7, 2692, "Wheelchairster cutout Poster", 200},
{2,7, 2693, "Nino Cutout Poster", 200},
{2,7, 19328, "Filthy Chicks Poster", 140},
{2,7, 2646, "Candy Suxx Set Poster", 140},
{3,0, 1985, "Punching Bag", 5000}, // Entertainment => Sporting Equipment
{3,0, 2627, "Treadmill", 13000},
{3,0, 2628, "Weight Lifting Bench", 7500},
{3,0, 2629, "Weight Lifting Bench", 7500},
{3,0, 2916, "One Dumbbell", 2500},
{3,0, 2915, "Two Dumbells", 5000},
{3,0, 2630, "Exercise Bike", 10000},
{3,0, 2964, "Blue Pool Table", 15000},
{3,0, 14651, "Green Pool Table", 15000},
{3,0, 338, "Pool Cue", 700},
{3,0, 3003, "Pool: Cue Ball", 1500},
{3,0, 3106, "Pool: 8 Ball", 1000},
{3,0, 3105, "Pool: Red Solid Ball", 700},
{3,0, 3104, "Pool: Green Solid Ball", 700},
{3,0, 3103, "Pool: Orange Solid Ball", 700},
{3,0, 3101, "Pool: Red Solid Ball", 700},
{3,0, 3100, "Pool: Blue Solid Ball", 700},
{3,0, 3002, "Pool: Yellow Solid Ball", 700},
{3,0, 2997, "Pool: Maroon Stripe Ball", 700},
{3,0, 3000, "Pool: Green Stripe Ball", 700},
{3,0, 2999, "Pool: Orange Stripe Ball", 700},
{3,0, 2997, "Pool: Red Stripe Ball", 700},
{3,0, 2996, "Pool: Blue Stripe Ball", 700},
{3,0, 2995, "Pool: Yellow Stripe Ball	", 700},
{3,0, 946, "Hanging Basketball Goal", 3000},
{3,0, 3065, "Basketball", 1100},
{3,1, 2316, "Small Black Television", 3800}, // Entertainment => Televisions
{3,1, 2320, "Wooden Television", 4550},
{3,1, 2317, "Rusty Television", 4000},
{3,1, 2322, "Dark Wooden Television", 4500},
{3,1, 1429, "Wooden White Television", 4550},
{3,1, 1791, "Tall Black Television", 5000},
{3,1, 2595, "Television On Top Of DVD", 3600},
{3,1, 14532, "Rolling Television Stand", 4000},
{3,1, 2596, "Mounted Black Television", 4300},
{3,1, 1751, "White Metal Television", 4700},
{3,1, 2648, "Tall Black Television", 5000},
{3,1, 1781, "Slim Tall Black Television", 5300},
{3,1, 1752, "Medium Black Television", 4200},
{3,1, 2224, "Orange Sphere Television", 5000},
{3,1, 1792, "Slim Grey Television", 5200},
{3,1, 19787, "Large Wide Television", 5500},
{3,2, 1515, "Triple Play Poker Machine", 20000}, // Entertainment => Gaming Machines
{3,2, 2778, "Bee Be Gone Arcade Machine", 17500},
{3,2, 2779, "Duality Arcade Machine", 17500},
{3,2, 2028, "Xbox 360 Console	2028", 10000},
{3,2, 19474, "Poker Table", 60000},
{3,3, 1782, "HI-DE DVD Player", 3240}, // Entertainment => Media Players
{3,3, 1783, "DVR620 DVD Player", 3500},
{3,3, 1785, "Sunny DVD Player", 4400},
{3,3, 1787, "BD655 Blu-Ray Player", 4300},
{3,3, 1788, "BD670 Blu-Ray Player", 4500},
{3,4, 2100, "Stereo System & Speakers", 2025}, // Entertainment => Stereos
{3,4, 2101, "Stereo System", 2500},
{3,4, 2102, "Retro Boombox", 2800},
{3,4, 2103, "White Boombox ", 3000},
{3,4, 2104, "Stereo System Stand", 3400},
{3,4, 2226, "Boombox", 3500},
{3,5, 2229, "Metal Plate Speaker", 13000}, // Entertainment => Speakers
{3,5, 2230, "Wooden Speaker", 12000},
{3,5, 2231, "Wooden Speaker Amplifier", 7000},
{3,5, 2232, "Metal Plate Speaker Amplifier", 9000},
{3,5, 2233, "Futuristic Speaker", 13000},
//Lamps
{4,0, 2238, "Lava Lamp", 900},
{4,0, 2196, "Work Lamp", 800},
{4,0, 2026, "White Lamp", 860},
{4,0, 2726, "Red Lamp", 860},
{4,0, 3534, "Red Lamp Style 2", 860},
//Sconces
{4,1, 1731, "Gray Sconce", 1500},
{4,1, 3785, "Bulkhead Light", 1600},
//Ceilinglights
{4,2, 2075, "Long Bulb Ceiling Light", 2500},
{4,2, 2073, "Brown Threaded Ceiling Light", 3200},
{4,2, 2074, "Hanging Light Bulb", 200},
{4,2, 2075, "Romantic Red Ceiling Light", 3500},
{4,2, 2076, "Hanging Bowl Ceiling Light", 3000},
{4,2, 16779, "Wooden Ceiling Fan", 3300},
//Neonlights
{4,3, 18647, "Red Neon Light", 3200},
{4,3, 18648, "Blue Neon Light", 3200},
{4,3, 18649, "Green Neon Light", 3200},
{4,3, 18650, "Yellow Neon Light", 3200},
{4,3, 18651, "Pink Neon Light", 3200},
{4,3, 18652, "White Neon Light", 3200},
//Toilets
{5,0, 2514, "Plain Toilet", 3750},
{5,0, 2521, "White Metal Toilet	", 5000},
{5,0, 2525, "Sauna Toilet", 5000},
{5,0, 2528, "Black Wooden Toilet", 5500},
//Sinks
{5,1, 2013, "Maggie's Co. Sink", 3850},
{5,1, 2130, "LoveSet Sink", 4900},
{5,1, 2132, "Creamy Metal Sink", 4600},
{5,1, 2136, "Sterlin Co. Metal Sink", 3000},
{5,1, 2150, "Old Town Sink Pt.2", 500},
{5,1, 2518, "Wooden Snow White Sink", 3850},
{5,1, 2523, "Bathroom Sink With Pad", 2550},
{5,1, 2524, "Sauna Bathroom Sink", 2200},
{5,1, 2739, "Bare Bathroom Sink", 1700},
//Showers
{5,2, 2517, "Silver Glass Shower", 8000},
{5,2, 2520, "Dark Metal Shower	", 7550},
{5,2, 2527, "Sauna Shower	", 7000},
//Bathtubs
{5,3, 2097, "Sprunk Bath Tub", 8000},
{5,3, 2516, "Sparkly White Bath Tub", 7500},
{5,3, 2519, "White Bath Tub", 7900},
{5,3, 2522, "Dark Wooden Bath Tub", 8200},
{5,3, 2526, "Sauna Wooden Bath Tub", 8500},
//Safe
{6,0, 2332, "Sealed Safe", 10000},
//Bookshelves
{6,1, 1742, "Half Empty Book Shelf", 3000},
{6,1, 14455, "Large Green Book Shelves", 3000},
{6,1, 2608, "Three Wooden Level Book Shelf", 2500},
//Dressers
{6,2, 2330, "Standard Wooden Dresser", 3250},
{6,2, 2323, "Light Wooden Dresser Bottom Opening Legs", 3500},
{6,2, 2088, "Long Light Wooden Dresser Legs", 4300},
//Filling Cabinets
{6,3, 2000, "Metal Filing Cabinet", 1500},
{6,3, 2007, "Double Filing Cabinet", 3000},
{6,3, 2163, "Wall Mounted Filing Cabinet", 900},
{6,3, 2200, "Tall Wall Mounted Filing Cabinet", 1200},
{6,3, 2197, "Brown Metal Filing CabinetAME", 1500},
{6,3, 2167, "Big Oak Filing Cabinet", 3000},
//Pantries
{6,4, 2128, "LoveSet Pantry", 3000},
{6,4, 2140, "Sterlin Co. Pantry", 2000},
{6,4, 2141, "Creamy Metal Pantry", 2500},
{6,4, 2145, "Old Town Pantry", 2500},
{6,4, 2153, "Wooden Snow White Pantry", 2000},
{6,4, 2158, "Mahogany Green Wood Pantry", 2000},
//Diningtables
{7,0, 2357, "Long Wooden Table", 2500},
{7,0, 2118, "Marble Top Table", 3000},
{7,0, 2117, "Pine Wood Table", 3000},
{7,0, 2115, "Oak Wood Table", 4700},
{7,0, 2110, "Basic Wood Table", 1500},
{7,0, 15037, "Table With TV", 4000},
//Coffeetables
{7,1, 1813, "Basic Oak Coffee Table", 5750},
{7,1, 1814, "Fancy Oak Coffee Table/Drawers", 5500},
{7,1, 1815, "Oval Coffee Table", 3750},
{7,1, 1817, "Fancy Oak Coffee Table	", 5500},
{7,1, 1818, "Square Oak Coffee Table", 5750},
{7,1, 1819, "Fancy Circle Coffee Table", 4500},
{7,1, 1820, "Basic Circle Coffee Table", 3750},
{7,1, 1822, "Mahogany Oval Coffee Table", 3750},
{7,1, 1823, "Mahogany Square Coffee Table", 4500},
{7,1, 2126, "Ebony Wood Basic Coffee Table", 3750},
//Counters
{7,2, 2014, "Maggie's Co. Counter Top", 950},
{7,2, 2015, "Maggie's Co. Counter Right Handle", 1000},
{7,2, 2016, "Maggie's Co. Counter Left Handle", 2000},
{7,2, 2019, "Maggie's Co. Blank Counter Top", 4000},
{7,2, 2022, "Maggie's Co. Corner Counter Top", 4000},
{7,2, 2129, "LoveSet Counter Top", 2000},
{7,2, 2133, "Creamy Metal Counter Top", 2000},
{7,2, 2137, "Sterlin Co. Cabinet Top", 3500},
{7,2, 2138, "Sterlin Co. Counter Top", 3500},
{7,2, 2139, "Sterlin Co. Counter", 3500},
{7,2, 2142, "Old Town Counter", 2000},
{7,2, 2151, "Wooden Snow White Counter Top", 3250},
{7,2, 2152, "Wooden Snow White Cabinete Counter", 2750},
{7,2, 2153, "Wooden Snow White Counter", 3000},
{7,2, 2156, "Mahogany Green Wood Counter", 2000},
{7,2, 2159, "Mahogany Green Wood Cabinet Counter", 3000},
{7,2, 2414, "Laguna Wooden Counter", 2200},
{7,2, 2424, "Light Blue IceBox Counter", 2100},
{7,2, 2423, "Light Blue IceBox Corner Counter	", 2100},
{7,2, 2435, "November Wood Counter", 2100},
{7,2, 2434, "November Wood Corner Counter", 2100},
{7,2, 2439, "Dark Marble Diamond Counter", 4000},
{7,2, 2440, "Dark Marble Diamond Corner Counter", 4000},
{7,2, 2441, "Marble Zinc Top Counter", 4200},
{7,2, 2442, "Marble Zinc Top Corner Counter", 6000},
{7,2, 2445, "Marble Zinc Top Counter (Regular)", 2500},
{7,2, 2444, "Marble Zinc Top Counter (Half Design)", 2500},
{7,2, 2446, "Parlor Red Counter", 2000},
{7,2, 2450, "Parlor Red Corner Counter", 2000},
{7,2, 2455, "Parlor Red Checkered Counter", 2000},
{7,2, 2454, "Parlor Red Checkered Corner Counter", 2000},
//Displaycabinets
{7,3, 2046, "Basic Wooden Display Cabinet", 1450},
{7,3, 2078, "Fancy Dark Wooden Display Cabinet", 2150},
{7,3, 2385, "Glass Front Wooden Display Cabinet", 1750},
{7,3, 2458, "Delicate Glass Wooden Display Cabinet", 1750},
{7,3, 2459, "Long Delicate Glass Wooden Display Cabinet", 1750},
{7,3, 2460, "Mini Delicate Glass Wooden Display Cabinet", 1750},
{7,3, 2461, "Cubed Delicate Glass Wooden Display Cabinet", 1750},
//Displayshelves
{7,4, 2063, "Industrial Display Shelf", 2450},
{7,4, 2210, "Black Metal Glass Display Shelf", 2750},
{7,4, 2211, "Wooden Glass Display Shelf", 2750},
{7,4, 2403, "Very Large Wooden Display Shelf", 16750},
{7,4, 2462, "Wall Mounted Thin Wooden Display Shelf", 2750},
{7,4, 2463, "Wall Mounted Thin Wooden Display Shelf", 3000},
{7,4, 2708, "Wooden Display Shelf With Bar", 3200},
{7,4, 2367, "Modern White Counter Display Shelf", 3500},
{7,4, 2368, "Wooden Counter Display Shelf", 3500},
{7,4, 2376, "Wooden & Glass Table Display Shelf", 3000},
{7,4, 2447, "Tall Parlor Red Display Shelf", 2300},
{7,4, 2448, "Wide Parlor Red Display Shelf", 2500},
{7,4, 2449, "Tall & Wide Parlor Red Display Shelf", 3700},
{7,4, 2457, "Parlor Red Checkered Display Shelf", 4500},
//Tvstands
{7,5, 2306, "Three Level Wooden TV Stand", 1500},
{7,5, 2321, "Small Two Level TV Stand", 1700},
{7,5, 2319, "Antique Oak TV Stand", 1350},
{7,5, 2314, "Light Wooden Small TV Stand", 1950},
{7,5, 2315, "Small Wooden TV Stand", 1700},
{7,5, 2313, "Light Wooden TV Stand With VCR", 2500},
{7,5, 2236, "Dark Mahogany TV Stand", 2900},
//Miscellaneous
//Clothes
{8,0, 2374, "Blue Plaid Shirts Rail", 200},
{8,0, 2377, "Black Levis Jeans Rail", 400},
{8,0, 2378, "Black Levis Jeans Rail", 400},
{8,0, 2381, "Row of Sweat Pants", 560},
{8,0, 2382, "Row of Levis Jeans	", 1000},
{8,0, 2383, "Yellow Shirts Rail", 200},
{8,0, 2384, "Stack of Khaki Pants", 300},
{8,0, 2389, "Red And White Sports Jacket Rail", 680},
{8,0, 2390, "Green Sweat Pants Rail", 240},
{8,0, 2391, "Khaki Pants Rail", 300},
{8,0, 2392, "Row of Khakis & Levis Jeans", 950},
{8,0, 2394, "Row of Shirts", 850},
{8,0, 2396, "Black and Red Blazers Rail ", 1200},
{8,0, 2397, "Grey Jeans Rail", 340},
{8,0, 2398, "Blue Sweat Pants Rail", 240},
{8,0, 2399, "Grey Sweatshirt Rail", 240},
{8,0, 2401, "Red Sweat Pants Rail", 240},
//Consumables
{8,1, 1950, "Beer Bottle", 50},
{8,1, 2958, "Beer Bottle", 50},
{8,1, 1486, "Beer Bottle", 50},
{8,1, 1543, "Beer Bottle", 50},
{8,1, 1544, "Beer Bottle", 50},
{8,1, 1520, "Scotch Bottle", 100},
{8,1, 1644, "Wine Bottle", 150},
{8,1, 1669, "Wine Bottle", 150},
//Doors
{8,2, 3109, "White Basic Door", 4000},
{8,2, 19857, "Wooden Door With Small Window", 5500},
{8,2, 3093, "Gate Door", 3000},
{8,2, 2947, "Heavy Blue Door", 5750},
{8,2, 2955, "White Basic Room Door", 4000},
{8,2, 2946, "Golden Door", 5750},
{8,2, 2930, "Small Cell Gate", 3000},
{8,2, 977, "Old Office Door", 4000},
{8,2, 1491, "Swinging Dark Wooden Door", 5000},
{8,2, 1492, "White Wooden Door", 4500},
{8,2, 1493, "Red Shop Door", 3500},
{8,2, 1494, "Blue Wooden Door", 4500},
{8,2, 1495, "Blue Wired Door", 3500},
{8,2, 1496, "Metal Love Shop Door", 4500},
{8,2, 1497, "Metal Door", 5000},
{8,2, 1498, "Dirty White Door", 2600},
{8,2, 1499, "Dirty Metal Door", 4700},
{8,2, 1500, "Metal Screen Door", 4700},
{8,2, 1501, "Wooden Screen Door", 4700},
{8,2, 1502, "Swinging Wooden Door", 5000},
{8,2, 1504, "Red Door", 4000},
{8,2, 1505, "Blue Door", 4000},
{8,2, 1506, "White Door", 4000},
{8,2, 1507, "Yellow Door", 4000},
{8,2, 1522, "Shop Door With Stickers", 3500},
{8,2, 1532, "Shop Door With Stickers 2", 3500},
{8,2, 1533, "Metal Shop Door", 4000},
{8,2, 1523, "Swinging Metal Door With Window", 4500},
{8,2, 1535, "Basic White Door", 4000},
{8,2, 1569, "Modern Black Door", 4000},
{8,2, 1559, "Modern Black Door Golden Frame", 5000},
{8,2, 1567, "Wardrobe Door", 4000},
//Mess
{8,3, 2670, "Random Mess", 5},
{8,3, 2671, "Random Mess", 5},
{8,3, 2673, "Random Mess", 5},
{8,3, 2674, "Random Mess", 5},
{8,3, 2867, "Random Mess", 5},
{8,3, 2672, "Burger Shot Mess", 8},
{8,3, 2675, "Burger Shot Mess", 8},
{8,3, 2677, "Burger Shot Mess", 8},
{8,3, 2840, "Burger Shot Mess", 8},
{8,3, 2676, "Newspapers & Burger Shot Mess", 13},
{8,3, 2850, "Dishes", 20},
{8,3, 2843, "Messy Clothes", 50},
{8,3, 2844, "Messy Clothes", 50},
{8,3, 2845, "Messy Clothes", 50},
{8,3, 2846, "Messy Clothes", 50},
{8,3, 2851, "Dishes", 20},
{8,3, 2821, "Cereal Box & Cans", 10},
{8,3, 2822, "Blue Dishes", 30},
{8,3, 2829, "Colorful Dishes", 30},
{8,3, 2830, "Dishes", 30},
{8,3, 2831, "Dishes & Colorful Cups", 30},
{8,3, 2832, "Colorful Dishes", 40},
{8,3, 2837, "Cluck N Bell Mess", 8},
{8,3, 2838, "Pizza Stack Mess", 10},
{8,3, 2839, "Chinese Food Mess", 7},
{8,3, 2848, "Dishes With Pizza", 12},
{8,3, 2850, "Dishes With Pizzaz", 13},
{8,3, 2849, "Colorful Dishes", 30},
{8,3, 2851, "Dishes", 20},
{8,3, 2856, "Crushed Milk", 5},
{8,3, 2857, "Pizza Box Mess", 6},
{8,3, 2861, "Empty Cookie Boxes", 2},
{8,3, 2866, "Empty Cookie Boxes & Cans", 4},
//Miscellaneous
{8,4, 2680, "Padlock", 700},
{8,4, 1665, "Ashtray", 700},
{8,4, 14774, "Electric Fly Killer", 2000},
{8,4, 2961, "Fire Alarm Button", 900},
{8,4, 2962, "Fire Alarm Button (Sign)", 700},
{8,4, 2616, "Whiteboard", 3500},
{8,4, 2611, "Blue Pinboard", 700},
{8,4, 2612, "Blue Pinboard	", 700},
{8,4, 2615, "Articles", 100},
{8,4, 2896, "Casket", 10000},
{8,4, 2404, "R* Surfboard", 2000},
{8,4, 2405, "Red & Blue Surfboard", 2000},
{8,4, 2406, "Vice City Surfboard", 2000},
{8,4, 2410, "Wooden Surfboard", 2000},
//Pillars
{8,5, 3494, "Stone Pillar", 5300},
{8,5, 3498, "Tall Wooden Pillar", 5200},
{8,5, 3499, "Fat Tall Wooden Pillar", 5300},
{8,5, 3524, "Pillar Skull Head", 5240},
{8,5, 3533, "Red Dragon Pillar", 5150},
{8,5, 3529, "Brick Construction Pillar", 5500},
{8,5, 3503, "Metal Pole", 1850},
//Security
{8,6, 1622, "Security Camera", 3000},
{8,6, 1616, "Security Camera", 3000},
{8,6, 1886, "Security Camera", 3000},
//Office
{8,7, 1808, "Ja Water Dispenser", 150},
{8,7, 1998, "Office Desk & Equipment", 1300},
{8,7, 1999, "Office Light Wooden Desk & Computer", 1000},
{8,7, 2002, "Water Dispenser", 150},
{8,7, 2008, "Office White Top Desk & Equipment", 1200},
{8,7, 2009, "White Office Desk & Computer", 1250},
{8,7, 2161, "Office Shelf & Files", 80},
{8,7, 2162, "Wide Office Shelf & Files", 160},
{8,7, 2164, "Wide and Tall Office Shelf & Files", 300},
{8,7, 2165, "Oak Office Desk & Equipment", 4500},
{8,7, 2166, "Oak Office Desk & Files", 3800},
{8,7, 2169, "White Office Desk With Wood Top", 2200},
{8,7, 2171, "Wood Top Desk With Backboard", 2400},
{8,7, 2172, "Blue Office Desk & Equipment", 5600},
{8,7, 2173, "Oak Office Desk", 5000},
{8,7, 2174, "Wood Top Desk With Backboard & Equipment", 2800},
{8,7, 2175, "Wood Top Desk Corner", 1900},
{8,7, 2180, "Wide Wooden Desk", 2500},
{8,7, 2181, "Office Desk With Backboard & Computer", 2500},
{8,7, 2308, "Office Desk & Files", 2200},
{8,7, 2183, "Four Divided Wooden Desks", 8500},
{8,7, 2184, "Diagonal Wooden Desk", 2000},
{8,7, 2185, "Open Wooden Desk & Computer", 1000},
{8,7, 2186, "Office Printer", 4000},
{8,7, 2187, "Blue Cubicle Divider", 1000},
{8,7, 2190, "Computer", 760},
//Toys
{8,8, 2511, "Toy Red Plane", 10},
{8,8, 2471, "Three Train Toy Boxes", 20},
{8,8, 2472, "Four Toy Red Planes", 40},
{8,8, 2473, "Two Toy Red Planes", 20},
{8,8, 2474, "Four Train Toys", 30},
{8,8, 2477, "Three Hotwheels Stacked Boxes", 25},
{8,8, 2480, "Four Hotwheels Stacked Boxes", 30},
{8,8, 2481, "Hotwheels Box", 5},
{8,8, 2483, "Train Model Box", 15},
{8,8, 2484, "R* Boat Model", 25},
{8,8, 2485, "Wooden Car Toy", 45},
{8,8, 2487, "Tropical Diamond Kite", 30},
{8,8, 2488, "Manhunt Toy Box Sets", 20},
{8,8, 2490, "Vice City Toy Box Sets", 20},
{8,8, 2497, "Pink Winged Box Kite", 35},
{8,8, 2498, "Blue Winged Box Kite", 35},
{8,8, 2499, "R* Diamond Kite", 30},
{8,8, 2512, "Paper Wooden Plane", 30},
//Special
//Animals
{9,0, 1599, "Bright Yellow Flouder", 300},
{9,0, 1600, "Exotic Blue Flounder", 350},
{9,0, 1604, "School of Blue Flounders", 600},
{9,0, 1602, "Bright Jellyfish", 500},
{9,0, 1603, "Jellyfish", 500},
{9,0, 1604, "Blue Flounder", 300},
{9,0, 1605, "School of Yellow Flounders", 600},
{9,0, 1606, "School of Exotic Blue Flounders", 650},
{9,0, 1607, "Dolphin", 5000},
{9,0, 1608, "Shark", 5000},
{9,0, 1609, "Turtle", 5000},
{9,0, 19315, "Deer", 4500},
{9,0, 19079, "Parrot", 1500},
//Gambling
{9,1, 1838, "Slot Machine", 10000},
{9,1, 1831, "Slot Machine", 10000},
{9,1, 1832, "Slot Machine", 10000},
{9,1, 1833, "Slot Machine", 10000},
{9,1, 1834, "Slot Machine", 10000},
{9,1, 1835, "Slot Machine", 10000},
{9,1, 1838, "Slot Machine", 10000},
{9,1, 1978, "Roulette Table", 10000},
{9,1, 1929, "Roulette Wheel", 10000},
{9,1, 2188, "Blackjack Table", 10000},
//Gangtags
{9,2, 18659, "Grove St. 4 Life", 3000},
{9,2, 1528, "Seville B.L.V.D Families", 3000},
{9,2, 1531, "Varrio Los Aztecas", 3000},
{9,2, 1525, "Kilo", 3000},
{9,2, 1526, "San Fiero Rifa", 3000},
{9,2, 18664, "Temple Drive Ballas", 3000},
{9,2, 1530, "Los Santos Vagos", 3000},
{9,2, 18666, "Front Yard Balas", 3000},
{9,2, 1527, "Rollin Heights Ballas", 3000},
//Party}
{9,3, 19128, "Dance Floor", 15550},
{9,3, 19129, "Large Dance Floor", 25000},
{9,3, 19159, "Disco Ball", 6300},
{9,3, 18656, "Club Lights ", 20000},
{9,3, 19122, "Blue Bollard Light", 3000},
{9,3, 19123, "Green Bollard Light", 3000},
{9,3, 19126, "Light Blue Bollard Light", 3000},
{9,3, 19127, "Purple Bollard Light", 3000},
{9,3, 19124, "Red Bollard Light", 3000},
{9,3, 19121, "White Bollard Light", 3000},
{9,3, 19125, "Yellow Bollard Light", 3000},
//Effect
{9,4, 18864, "Snow Machine", 13500},
{9,4, 18715, "Smoke Machine", 13500},
//Walls
{9,5, 19353, "Ice Cream Parlor Wall", 3000},
{9,5, 19354, "Leather Diamond Wall", 3000},
{9,5, 19355, "Cement Think Brick Wall", 3500},
{9,5, 19356, "Wooden Wall", 3200},
{9,5, 19357, "Cement Wall", 3500},
{9,5, 19358, "Grey & Black Cotton Wall", 3200},
{9,5, 19359, "Plain Tan Wall", 3300},
{9,5, 19360, "Tough Light Wood Wall", 3300},
{9,5, 19361, "Tan & Red Wall", 3300},
{9,5, 19362, "Road Textured Wall", 3200},
{9,5, 19363, "Plain Dark Pastel Pink Wall", 3400},
{9,5, 19364, "Cement Brick Wall", 3500},
{9,5, 19365, "Plain Light Blue Wall", 3300},
{9,5, 19366, "Thick Wood Wall", 3400},
{9,5, 19367, "Light Blue Spring Themed Wall", 3400},
{9,5, 19368, "Light Pink Spring Themed Wall", 3400},
{9,5, 19369, "Light Yellow Spring Themed Wall", 3300},
{9,5, 19370, "Bright Wooden Wall", 3400},
{9,5, 19371, "Plain Cement Wall", 3300},
{9,5, 19372, "Sand Wall", 3400},
{9,5, 19373, "Grass Wall", 3300},
{9,5, 19375, "Wavey Wooden Wall", 3400},
{9,5, 19376, "Red Wooden Wall", 3300},
{9,5, 19377, "Carpet Textured Wall", 3400},
{9,5, 19378, "Dark Wooden Wall", 3400},
{9,5, 19379, "Basic Light Wood Wall", 3400},
{9,5, 19380, "Dark Sand Wall", 3400},
{9,5, 19381, "Dark Grass Wall", 3300},
//Wallsdoorway
{9,6, 19383, "Ice Cream Parlor Wall (Doorway)", 3000},
{9,6, 19384, "Leather Diamond Wall (Doorway)", 3000},
{9,6, 19391, "Cement Think Brick Wall (Doorway)", 3000},
{9,6, 19386, "Wooden Wall (Doorway)", 3000},
{9,6, 19387, "Cement Wall (Doorway)	", 3000},
{9,6, 19388, "Grey & Black Cotton Wall (Doorway)", 3000},
{9,6, 19389, "Plain Tan Wall (Doorway)", 3000},
{9,6, 19390, "Tan & Red Wall (Doorway)", 3000},
{9,6, 19385, "Road Textured Wall (Doorway)", 3000},
{9,6, 19392, "Plain Dark Pastel Pink Wall (Doorway)", 3000},
{9,6, 19393, "Cement Brick Wall (Doorway)", 3000},
{9,6, 19394, "Plain Light Blue Wall (Doorway)", 3000},
{9,6, 19395, "Light Blue Spring Themed Wall (Doorway)", 3000},
{9,6, 19396, "Light Pink Spring Themed Wall (Doorway)", 3000},
{9,6, 19397, "Light Yellow Spring Themed Wall (Doorway)", 3000},
{9,6, 19398, "Plain Cement Wall (Doorway)", 3000},
//Wallsopenwindow
{9,7, 19399, "Ice Cream Parlor Wall (Open Window)", 3000},
{9,7, 19400, "Leather Diamond Wall (Open Window)", 3000},
{9,7, 19401, "Cement Think Brick Wall (Open Window)", 3300},
{9,7, 19402, "Wooden Wall (Open Window)", 3000},
{9,7, 19403, "Cement Wall (Open Window)", 3200},
{9,7, 19404, "Grey & Black Cotton Wall (Open Window)", 3200},
{9,7, 19405, "Plain Tan Wall (Open Window)", 3300},
{9,7, 19407, "Tan & Red Wall (Open Window)", 3200},
{9,7, 19408, "Road Textured Wall (Open Window)", 3300},
{9,7, 19409, "Plain Dark Pastel Pink Wall (Open Window)", 3300},
{9,7, 19410, "Cement Brick Wall (Open Window)", 3200},
{9,7, 19411, "Plain Light Blue Wall (Open Window)", 3300},
{9,7, 19412, "Thick Wooden Wall (Open Window)", 3300},
{9,7, 19413, "Light Blue Spring Themed Wall (Open Window)", 3300},
{9,7, 19414, "Light Pink Spring Themed Wall (Open Window)", 3200},
{9,7, 19415, "Light Yellow Spring Themed Wall (Open Window)", 3300},
{9,7, 19416, "Basic Light Wood Wall (Open Window)", 3300},
{9,7, 19417, "Plain Cement Wall (Open Window)", 3200},
//Wallsthin
{9,8, 19426, "Ice Cream Parlor Wall (Thin)", 2000},
{9,8, 19427, "Leather Diamond Wall (Thin)", 2000},
{9,8, 19428, "Cement Think Brick Wall (Thin)", 2000},
{9,8, 19429, "Wooden Wall (Thin)", 2000},
{9,8, 19430, "Cement Wall (Thin)", 2000},
{9,8, 19431, "Grey & Black Cotton Wall (Thin)", 2000},
{9,8, 19432, "Plain Tan Wall (Thin)", 2000},
{9,8, 19433, "Tan & Red Wall (Thin)", 2200},
{9,8, 19435, "Road Textured Wall (Thin)", 2200},
{9,8, 19436, "Plain Dark Pastel Pink Wall (Thin)", 2200},
{9,8, 19437, "Cement Brick Wall (Thin)", 2200},
{9,8, 19438, "Plain Light Blue Wall (Thin)", 2200},
{9,8, 19439, "Thick Wooden Wall (Thin)", 2300},
{9,8, 19440, "Light Blue Spring Themed Wall (Thin)", 2300},
{9,8, 19441, "Light Pink Spring Themed Wall (Thin)", 2300},
{9,8, 19442, "Light Yellow Spring Themed Wall (Thin)", 2400},
{9,8, 19443, "Basic Light Wood Wall (Thin)", 2400},
{9,8, 19444, "Plain Cement Wall (Thin)", 2500},
//Wallswide
{9,9, 19445, "Ice Cream Parlor Wall (Wide)", 6200},
{9,9, 19446, "Leather Diamond Wall (Wide)", 6200},
{9,9, 19447, "Cement Think Brick Wall (Wide)", 6500},
{9,9, 19448, "Wooden Wall (Wide)", 6200},
{9,9, 19449, "Cement Wall (Wide)", 6500},
{9,9, 19450, "Grey & Black Cotton Wall (Wide)", 6300},
{9,9, 19451, "Plain Tan Wall (Wide)", 6300},
{9,9, 19452, "Red Wooden Wall (Wide)", 6300},
{9,9, 19453, "Tan & Red Wall (Wide) ", 6300},
{9,9, 19454, "Carpet Textured Wall (Wide)	", 6300},
{9,9, 19455, "Plain Dark Pastel Pink Wall (Wide)", 6300},
{9,9, 19456, "Cement Brick Wall (Wide)", 6500},
{9,9, 19457, "Plain Light Blue Wall (Wide)", 6300},
{9,9, 19458, "Thick Wooden Wall (Wide)", 6300},
{9,9, 19459, "Light Blue Spring Themed Wall (Wide)", 6300},
{9,9, 19460, "Light Pink Spring Themed Wall (Wide)", 6300},
{9,9, 19461, "Light Yellow Spring Themed Wall (Wide)", 6300},
{9,9, 19462, "Basic Light Wood Wall (Wide)", 6300},
{9,9, 19463, "Plain Cement Wall (Wide)", 6300},
//Glass
{9,10, 19466, "Regular Glass", 3000},
{9,10, 1651, "Glass", 3000},
{9,10, 1649, "Long Glass", 6000},
{9,10, 1651, "Tall Glass", 4000},
{9,10, 19325, "Unbreakable Glass", 7000}
};

hook OnPlayerConnect(playerid) {
	grantbuild[playerid]=-1;
	return 1;
}

CMD:grantbuild(playerid, params[])
{
	new house = insideHouseID[playerid];
	if (IsHouseOwner(playerid, house))
	{
		new userid = INVALID_PLAYER_ID;

		if (sscanf(params, "u", userid)) {
			SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /grantbuild [ไอดี/ชื่อบางส่วน]");
			return 1;
		}

		if (userid == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้เชื่อมต่อกับเซิร์ฟเวอร์");

		if (userid == playerid)
			return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถใช้กับตัวเองได้");

		if (insideHouseID[userid] != insideHouseID[playerid])
			return SendClientMessage(playerid, COLOR_LIGHTRED, " ผู้เล่นนั้นไม่ได้อยู่ในบ้านหลังเดียวกับคุณ");

		if(grantbuild[userid]==house) {
		    grantbuild[userid]=-1;
			SendClientMessageEx(playerid, COLOR_WHITE, "คุณไม่อนุญาตให้ %s ซื้อ / ตกแต่งเฟอร์นิเจอร์ในบ้านของคุณแล้ว", ReturnRealName(userid));
			SendClientMessageEx(userid, COLOR_WHITE, "%s ไม่อนุญาตให้คุณ ซื้อ / ตกแต่งเฟอร์นิเจอร์ในบ้านของเขาแล้ว", ReturnRealName(playerid));
		}
		else
		{
			grantbuild[userid]=house;
			SendClientMessageEx(playerid, COLOR_WHITE, "คุณอนุญาตให้ %s ซื้อ / ตกแต่งเฟอร์นิเจอร์ในบ้านของคุณ", ReturnRealName(userid));
			SendClientMessageEx(userid, COLOR_WHITE, "%s อนุญาตให้คุณ ซื้อ / ตกแต่งเฟอร์นิเจอร์ในบ้านของเขา", ReturnRealName(playerid));
			SendClientMessage(userid, COLOR_GREEN, "คำแนะนำ: ใช้ /furniture");
		}
		return 1;
	} else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้รับอนุณาตในบ้านหลังนี้");
	return 1;
}

CMD:furniture(playerid, params[])
{
	new house = insideHouseID[playerid];
    if(house != -1) {
        if (strcmp(ReturnPlayerName(playerid), houseData[house][hOwner], true) == 0 || grantbuild[playerid] == house)
        {
            return ShowFurnitureMenu(playerid);
        }
        else {
            return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้รับอนุณาตในบ้านหลังนี้");
        }
    }
	return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้รับอนุณาตในบ้านหลังนี้");
	//return SendClientMessage(playerid, COLOR_LIGHTRED, "ขออภัยฟีเจอร์นี้ถูกปิดอยู่ชั่วคราว");
}

ShowFurnitureMenu(playerid) {
	DeletePVar(playerid, "ChosenFurnitureObject");
    return Dialog_Show(playerid, FurnitureDialog, DIALOG_STYLE_LIST, "เมนูเฟอร์นิเจอร์:", "ซื้อเฟอร์นิเจอร์\nเฟอร์นิเจอร์ในปัจจุบัน\nข้อมูล", "เลือก", "<<");
}

ShowFurnitureCategory(playerid) {
    new string[256];

    for(new i = 0; i != sizeof(fCategory); ++i)
    {
        format(string, sizeof(string), "%s%s\n", string, fCategory[i]);
    }
    return Dialog_Show(playerid, FCategoryDialog, DIALOG_STYLE_LIST, "หมวดหมู่:", string, "เลือก", "<<");
}

ShowFurnitureSubCategory(playerid, category) {
    new string[256];
    for(new i = 0; i != sizeof(fSubCategory); ++i)
    {
        if(fSubCategory[i][catid] == category) {
    		format(string, sizeof(string), "%s%s\n", string, fSubCategory[i][subname]);
    	}
    }
    new caption[90];
    format(caption, sizeof caption, "หมวดหมู่: %s", fCategory[category]);
    return Dialog_Show(playerid, FSubCategoryDialog, DIALOG_STYLE_LIST, caption, string, "เลือก", "<<");
}

Dialog:ReturnFurnitureMain(playerid, response, listitem, inputtext[])
{
	ShowFurnitureMenu(playerid);
}

Dialog:FurnitureDialog(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
			case 0:
			{
			    ShowFurnitureCategory(playerid);
			}
			case 1: {
				ShowCurrentFurniture(playerid);
			}
			case 2:
			{
			    new houseid = insideHouseID[playerid];
                if(houseid != -1) 
					Dialog_Show(playerid, ReturnFurnitureMain, DIALOG_STYLE_MSGBOX, "ข้อมูล:", ""EMBED_WHITE"เฟอร์นิเจอร์: "EMBED_YELLOW"%d/%d", "ปิด", "", CountFurniture(houseid), GetMaxFurniture(houseid));

                /*houseid = BizEntered[playerid];
              	if(houseid != -1) Dialog_Show(playerid, ReturnFurnitureMain, DIALOG_STYLE_MSGBOX, "ข้อมูล:", ""EMBED_WHITE"เฟอร์นิเจอร์: "EMBED_YELLOW"%d/%d", "ปิด", "", GetBizFurnitures(houseid), GetMaximumBizFurniture(houseid));*/
			}
		}
	}
	return 1;
}

Dialog:FCategoryDialog(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new category = listitem;
		SetPVarInt(playerid, "CategorySelected", category);
		ShowFurnitureSubCategory(playerid, category);
	}
	else ShowFurnitureMenu(playerid);
}

Dialog:FSubCategoryDialog(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new category = GetPVarInt(playerid, "CategorySelected"), count;

		for(new i = 0; i != sizeof(fSubCategory); ++i)
		{
		    if(fSubCategory[i][catid] == category) {
				if(listitem == count)
				{
					SetPVarInt(playerid, "SubCategorySelected", i);
					break;
				}
				count++;
			}
		}
		SetPVarInt(playerid, "SubCategoryRow", listitem);
        ShowFurnitureList(playerid, category, listitem);
	}
	else
	{
		ShowFurnitureCategory(playerid);
	}
}

ShowFurnitureList(playerid, category, sub) {
    new string[1280];
    // format(string, sizeof(string), "ชื่อเฟอร์นิเจอร์\tราคา\n");

    for(new i = 0; i != sizeof(FurnitureItems); ++i)
    {
        if(FurnitureItems[i][furnitureCatalog] == category && FurnitureItems[i][furnitureSubCatalog] == sub) {
    		format(string, sizeof(string), "%s%s\t%s\n", string, FurnitureItems[i][furnitureName], FormatNumber(FurnitureItems[i][furniturePrice]));
    	}
    }
    return Dialog_Show(playerid, FurnitureBuyDialog, DIALOG_STYLE_LIST, "รายการเฟอร์นิเจอร์ที่มีจำหน่าย:", string, "เลือก", "<<");
}

Dialog:FurnitureBuyDialog(playerid, response, listitem, inputtext[])
{
	//new string[256];

	if(response)
	{
	    new
			furnitureid,
			count,
			category = GetPVarInt(playerid, "CategorySelected"),
			subrow = GetPVarInt(playerid, "SubCategoryRow");

		for(new i = 0; i != sizeof(FurnitureItems); ++i)
		{
		    if(FurnitureItems[i][furnitureCatalog] == category && FurnitureItems[i][furnitureSubCatalog] == subrow) {
				if(listitem == count)
				{
					furnitureid = i;
					break;
				}
				count++;
			}
		}
		SetPVarInt(playerid, "FurnitureItemID", furnitureid);

		new houseid = insideHouseID[playerid];
		if(houseid != -1) {
			if(IsHouseCanBuyFurniture(houseid, CountFurniture(houseid))) {

				if(playerData[playerid][pCash] >= FurnitureItems[furnitureid][furniturePrice]) {
					playerData[playerid][pCash] -= FurnitureItems[furnitureid][furniturePrice];
	
                    new Float:px,Float:py,Float:pz;
					GetPlayerPos(playerid, px, py, pz);
					GetXYInFrontOfPlayer(playerid, px, py, 1.5);
					FurnObject[playerid] = CreatePlayerObject(playerid, FurnitureItems[furnitureid][furnitureModel], px, py, pz, 0.0, 0.0, 0.0);
			        SetPVarInt(playerid, "FurnitureEditorMode", 1);
			        EditPlayerObject(playerid, FurnObject[playerid]);

					ShowPlayerFooter(playerid, "~n~HOLD \"~y~SPACE~w~\" AND PRESS YOUR \"~y~MMB~w~\" KEY TO MOVE YOUR FURNITURE ITEM BACK TO YOU.~n~PRESS YOUR \"~r~ESC~w~\" KEY TO RETURN THE ITEM IF YOU ARE NOT PLEASED", 7000);
				}
				else SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอ !");
			}
			else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณใช้สล็อตเฟอร์นิเจอร์สูงสุดของคุณแล้ว");
		}
	}
	else
	{
	    new category = GetPVarInt(playerid, "CategorySelected");
		ShowFurnitureSubCategory(playerid, category);
	}
    return 1;
}

CountFurniture(houseid)
{
	return Iter_Count(Iter_HouseFurniture[houseid]);
}

MaxFurnitureCanBuy(donaterank) {
	switch(donaterank) {
		case 1: return 150;
		case 2: return 250;
		case 3: return 400;
	}
	return 75;
}

GetMaxFurniture(houseid)
{
	new donaterank = 0;
	if(Iter_Contains(Iter_House, houseid))
	{
		donaterank = GetPlayerDonateLevel(houseData[houseid][hOwner]);
	}
	return MaxFurnitureCanBuy(donaterank);
}

MaterialAbility(houseid)
{
	new donaterank = 0;
	if(Iter_Contains(Iter_House, houseid))
	{
		donaterank = GetPlayerDonateLevel(houseData[houseid][hOwner]);
	}
	return donaterank;
}

GetPlayerDonateLevel(playername[]) {
	new
		query[128],
		row,
		donaterank = 0;
	mysql_format(dbCon, query, sizeof(query), "SELECT `donaterank` FROM `players` WHERE `name` = '%e'", playername);
	mysql_query(dbCon, query);
	cache_get_row_count(row);
	if(row) cache_get_value_index_int(0, 0, donaterank);
	return donaterank;
}

IsHouseCanBuyFurniture(houseid, current)
{
	if(current < GetMaxFurniture(houseid)) return true;
	return false;
}

hook OP_EditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	switch(GetPVarInt(playerid, "FurnitureEditorMode"))
	{
	    case 1: // Buy Furniture
	    {
            if(response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL) {
				new houseid = insideHouseID[playerid];
				new furnitureid = GetPVarInt(playerid, "FurnitureItemID");

                if(response == EDIT_RESPONSE_FINAL) {
                    if(houseid != -1) {
                        new fid = Iter_Free(Iter_HouseFurniture[houseid]);
                        if(fid != -1) {

                            Iter_Add(Iter_HouseFurniture[houseid], fid);

                            new 
                                world = GetPlayerVirtualWorld(playerid), 
                                interior = GetPlayerInterior(playerid)
                            ;
    
                            furnitureData[houseid][fid][fObject] = CreateDynamicObject(FurnitureItems[furnitureid][furnitureModel], fX, fY, fZ, fRotX, fRotY, fRotZ, world, interior, -1, 200.0);
     
                            new query[1024];
                            mysql_format(dbCon, query, sizeof(query), "INSERT INTO `house_furnitures` (model, name, houseid, interior, virworld, marketprice, posx, posy, posz, posrx, posry, posrz) VALUES (%d, '%e', %d, %d, %d, %d, %f, %f, %f, %f, %f, %f)",
                            FurnitureItems[furnitureid][furnitureModel], FurnitureItems[furnitureid][furnitureName], houseData[houseid][hID], interior, world, FurnitureItems[furnitureid][furniturePrice], fX, fY, fZ, fRotX, fRotY, fRotZ);
					
                            mysql_tquery(dbCon, query, "OnHouseFurnitureInsert", "iii", houseid, fid, GetPVarInt(playerid, "ChosenFurnitureObject"));

                            furnitureData[houseid][fid][fInterior] = interior;
                            furnitureData[houseid][fid][fVirtualWorld] = world;
                            furnitureData[houseid][fid][fMarketPrice] = FurnitureItems[furnitureid][furniturePrice];
                            furnitureData[houseid][fid][fModel] = FurnitureItems[furnitureid][furnitureModel];
                            furnitureData[houseid][fid][fPosX] = fX;
                            furnitureData[houseid][fid][fPosY] = fY;
                            furnitureData[houseid][fid][fPosZ] = fZ;
                            furnitureData[houseid][fid][fPosRX] = fRotX;
                            furnitureData[houseid][fid][fPosRY] = fRotY;
                            furnitureData[houseid][fid][fPosRZ] = fRotZ;
                            format(furnitureData[houseid][fid][fName], MAX_FURNITURE_NAME, FurnitureItems[furnitureid][furnitureName]);

                            SendClientMessage(playerid, COLOR_GRAD1, "คุณได้แก้ไขตำแหน่งของเฟอนิเจอร์เสร็จแล้ว");

                            ShowCurrentFurniture(playerid, -1);

                            DestroyPlayerObject(playerid,FurnObject[playerid]);
                            DeletePVar(playerid,"FurnitureEditorMode");
                            return 1;
                        }
                    }
                }
				SendClientMessageEx(playerid, COLOR_GREY, "คุณได้ยกเลิกการซื้อ %s และได้รับเงินคืน $%d", FurnitureItems[furnitureid][furnitureName], FurnitureItems[furnitureid][furniturePrice]);
				playerData[playerid][pCash] += FurnitureItems[furnitureid][furniturePrice];

				DestroyPlayerObject(playerid,FurnObject[playerid]);
				DeletePVar(playerid,"FurnitureEditorMode");
            }
		}
	}
	return 1;
}

forward OnHouseFurnitureInsert(houseid, furid, copy_fid);
public OnHouseFurnitureInsert(houseid, furid, copy_fid)
{
	furnitureData[houseid][furid][fID] = cache_insert_id();

	if (Iter_Contains(Iter_HouseFurniture[houseid], copy_fid)) {
		new query[128];
		format(query, 128, "SELECT * FROM `house_materials` WHERE `furnitureid` = %d", furnitureData[houseid][copy_fid][fID]);
		mysql_tquery(dbCon, query, "OnMaterialsDuplicate", "ii",  furnitureData[houseid][furid][fObject], furnitureData[houseid][furid][fID]);
	}
	return 1;
}

forward OnHouseFurnituresLoad(houseid);
public OnHouseFurnituresLoad(houseid)
{
    new rows, query[128];

    cache_get_row_count(rows);

    if(rows)
    {
		//new data[furnitureE];
		for (new i = 0; i < rows; i ++)
		{
			Iter_Add(Iter_HouseFurniture[houseid], i);	
			cache_get_value_name_int(i, "id", furnitureData[houseid][i][fID]);
			cache_get_value_name_int(i, "model", furnitureData[houseid][i][fModel]);
			cache_get_value_name(i, "name", furnitureData[houseid][i][fName], MAX_FURNITURE_NAME);
			cache_get_value_name_int(i, "interior", furnitureData[houseid][i][fInterior]);
			cache_get_value_name_int(i, "virworld", furnitureData[houseid][i][fVirtualWorld]);
			cache_get_value_name_int(i, "marketprice", furnitureData[houseid][i][fMarketPrice]);
			cache_get_value_name_float(i, "posx", furnitureData[houseid][i][fPosX]);
			cache_get_value_name_float(i, "posy", furnitureData[houseid][i][fPosY]);
			cache_get_value_name_float(i, "posz", furnitureData[houseid][i][fPosZ]);
			cache_get_value_name_float(i, "posrx", furnitureData[houseid][i][fPosRX]);
			cache_get_value_name_float(i, "posry", furnitureData[houseid][i][fPosRY]);
			cache_get_value_name_float(i, "posrz", furnitureData[houseid][i][fPosRZ]);

			furnitureData[houseid][i][fObject] = CreateDynamicObject(furnitureData[houseid][i][fModel], furnitureData[houseid][i][fPosX], furnitureData[houseid][i][fPosY], furnitureData[houseid][i][fPosZ], furnitureData[houseid][i][fPosRX], furnitureData[houseid][i][fPosRY], furnitureData[houseid][i][fPosRZ], furnitureData[houseid][i][fVirtualWorld], furnitureData[houseid][i][fInterior], -1, 200.0);

			if(isHouseDoor(furnitureData[houseid][i][fModel]))
			{
				furnitureData[houseid][i][fLocked] = 1;
				furnitureData[houseid][i][fOpened] = 0;
			}

			format(query, 128, "SELECT * FROM `house_materials` WHERE `furnitureid` = %d", furnitureData[houseid][i][fID]);
			mysql_tquery(dbCon, query, "OnMaterialsLoad", "i", furnitureData[houseid][i][fObject]);

		}
    }
    return 1;
}

forward OnMaterialsDuplicate(objectid, fid);
public OnMaterialsDuplicate(objectid, fid)
{
    new rows, query[256];

    cache_get_row_count(rows);

    if(rows)
    {
		new matIndex = -1, matModel = 0, matTxd[32], MatTexture[32];
		
		for (new i = 0; i < rows; i ++)
		{
			cache_get_value_name_int(i, "matIndex", matIndex);
			cache_get_value_name_int(i, "matModel", matModel);
			cache_get_value_name(i, "matTxd", matTxd, 32);
			cache_get_value_name(i, "MatTexture", MatTexture, 32);
			
			mysql_format(dbCon, query, sizeof(query), "INSERT INTO `house_materials` (`furnitureid`, `matIndex`, `matModel`, `matTxd`, `MatTexture`) VALUES ('%d', '%d', '%d', '%e', '%e')", fid, matIndex, matModel, matTxd, MatTexture);
			mysql_tquery(dbCon, query);

			SetDynamicObjectMaterial(objectid, matIndex, matModel, matTxd, MatTexture, 0);
		}
    }
    return 1;
}

forward OnMaterialsLoad(objectid);
public OnMaterialsLoad(objectid)
{
    new rows;

    cache_get_row_count(rows);

    if(rows)
    {
		new matIndex = -1, matModel = 0, matTxd[32], MatTexture[32];
		
		for (new i = 0; i < rows; i ++)
		{
			cache_get_value_name_int(i, "matIndex", matIndex);
			cache_get_value_name_int(i, "matModel", matModel);
			cache_get_value_name(i, "matTxd", matTxd, 32);
			cache_get_value_name(i, "MatTexture", MatTexture, 32);
			
			SetDynamicObjectMaterial(objectid, matIndex, matModel, matTxd, MatTexture, 0);
		}
    }
    return 1;
}

ShowCurrentFurniture(playerid, page = 0)
{
	if(insideHouseID[playerid] != -1) {

		new total_page = (floatround(CountFurniture(insideHouseID[playerid]) / MAX_FURNITURE_PERPAGE, floatround_ceil) - 1);
		new skip, count, menu[16], string[1024], caption[128], temp_skip;

		if(page == -1) // Last Page
		{
			page = total_page + 1;
			skip = page * MAX_FURNITURE_PERPAGE;
			SetPVarInt(playerid, "FurniturePages", page);
			temp_skip = skip;
			foreach(new i : Iter_HouseFurniture[insideHouseID[playerid]]) {
				if(skip>0) {
					skip--;
					continue;
				}
				format(string, sizeof(string), "%sช่อง %d: %s\n", string, temp_skip + count + 1, furnitureData[insideHouseID[playerid]][i][fName]);
				format(menu, sizeof(menu), "FurnList%d", count);
				SetPVarInt(playerid, menu, i);
				count++;
			}
		}
		else {
			SetPVarInt(playerid, "FurniturePages", page);
			skip = page * MAX_FURNITURE_PERPAGE;
			temp_skip = skip;
			foreach(new i : Iter_HouseFurniture[insideHouseID[playerid]]) {
				if(skip>0) {
					skip--;
					continue;
				}
				if(count >= MAX_FURNITURE_PERPAGE)
				{
					if(Iter_Contains(Iter_HouseFurniture[insideHouseID[playerid]], i + 1))
						format(string, sizeof(string), "%s>>\n", string);
					break;
				}
				else {
					format(string, sizeof(string), "%sช่อง %d: %s\n", string, temp_skip + count + 1, furnitureData[insideHouseID[playerid]][i][fName]);
					format(menu, sizeof(menu), "FurnList%d", count);
					SetPVarInt(playerid, menu, i);
				}
				count++;
			}
		
		}
		if(page > 0) format(string, sizeof(string), "%s<<\n", string);
		format(string, sizeof(string), "%s"EMBED_YELLOW"*เลือกเฟอร์นิเจอร์*", string);

		format(caption, sizeof(caption), "เฟอร์นิเจอร์ในปัจจุบัน(%d) [หน้า %d/%d]", CountFurniture(insideHouseID[playerid]), page+1, total_page+2);
		Dialog_Show(playerid, DisplayFurniture, DIALOG_STYLE_LIST, caption, string, "เลือก", "<<");
	}
}

Dialog:DisplayFurniture(playerid, response, listitem, inputtext[]) {
	if(response)
	{
	    new page = GetPVarInt(playerid, "FurniturePages");

		if(!strcmp(inputtext, ">>", true)) {
			page++;
			DeletePVar(playerid, "FurniturePages");
		    SetPVarInt(playerid, "FurniturePages", page);
		}
		else if(!strcmp(inputtext, "<<", true)) {
		    page--;
		    DeletePVar(playerid, "FurniturePages");
		    SetPVarInt(playerid, "FurniturePages", page);
		}
		else if(!strcmp(inputtext, "*เลือกเฟอร์นิเจอร์*", true)) {
            SelectObject(playerid);
            SetPVarInt(playerid, "SelectingFurniture", 1);
			return 1;
		}
		else
		{
		    if(GetPVarInt(playerid, "EditingFurniture") == 1 || GetPVarInt(playerid, "FurnitureEditorMode") == 1) 
				return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณอยู่ในระหว่างการแก้ไขเฟอร์นิเจอร์");

			new menu[24];
			format(menu, sizeof(menu), "FurnList%d", listitem);
			SetPVarInt(playerid, "ChosenFurnitureObject", GetPVarInt(playerid, menu));
			return EditFurniture(playerid);
		}
		ShowCurrentFurniture(playerid, page);

	}
	else ShowFurnitureMenu(playerid);
	
	return 1;
}

Dialog:ReturnFurnitureEditMenu(playerid, response, listitem, inputtext[]) {
	return Dialog_Show(playerid, FurnitureEditMenu, DIALOG_STYLE_LIST, "การแก้ไขวัตถุ:", "ข้อมูล\nตำแหน่ง\nแก้ไขพื้นผิว\nขาย\nเปลี่ยนชื่อ\nก๊อปปี้", "เลือก", "<<");
}

EditFurniture(playerid) {
	if (GetPVarType(playerid, "ChosenFurnitureObject")) {
		return Dialog_Show(playerid, FurnitureEditMenu, DIALOG_STYLE_LIST, "การแก้ไขวัตถุ:", "ข้อมูล\nตำแหน่ง\nแก้ไขพื้นผิว\nขาย\nเปลี่ยนชื่อ\nก๊อปปี้", "เลือก", "<<");
	}
	else return ShowFurnitureMenu(playerid);
}

Dialog:FurnitureEditMenu(playerid, response, listitem, inputtext[]) {

	if(response)
	{
		switch(listitem)
		{
		    case 0: { // Information
				new houseid = insideHouseID[playerid];
				new string[512];
				new fid = GetPVarInt(playerid, "ChosenFurnitureObject");
				new fdid = -1; // FurnitureItems

				for(new i = 0, j = sizeof(FurnitureItems); i != j; ++i)
				{
					if(FurnitureItems[i][furnitureModel] == furnitureData[houseid][fid][fModel]) {
						fdid = i;
						break;
					}
				}

				if (fdid != -1) {
					new count = 0, subcategory = -1;
					for(new i = 0, j = sizeof(fSubCategory); i != j; ++i)
					{
						if(fSubCategory[i][catid] == FurnitureItems[fdid][furnitureCatalog]) {
							if(count == FurnitureItems[fdid][furnitureSubCatalog])
							{
								subcategory = i;
								break;
							}
							count++;
						}
					}

					if (subcategory != -1) {
						format(string, sizeof(string), ""EMBED_DIALOG"หมวด:"EMBED_YELLOW" %s\n"EMBED_WHITE"หมวดย่อย:"EMBED_YELLOW" %s\n"EMBED_WHITE"สิ่งของ:"EMBED_YELLOW" %s\n"EMBED_WHITE"ชื่อ:"EMBED_YELLOW" %s\n"EMBED_WHITE"ราคา: %s", 
						fCategory[FurnitureItems[fdid][furnitureCatalog]], fSubCategory[subcategory][subname], FurnitureItems[fdid][furnitureName], furnitureData[houseid][fid][fName], FormatNumber(FurnitureItems[fdid][furniturePrice], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));


						new query[128], materialslot;
						format(query, sizeof(query), "SELECT * FROM `house_materials` WHERE `furnitureid` = %d  ORDER BY `matIndex` ASC", furnitureData[houseid][fid][fID]);
						mysql_query(dbCon, query);

						new rows, texturename[32];
						cache_get_row_count(rows);
						if(rows)
						{
							format(string, sizeof(string), "%s\n{FF6347}", string);
							for (new i = 0; i < rows; i ++)
							{
								cache_get_value_name_int(i, "matIndex", materialslot);
								cache_get_value_name(i, "MatTexture", texturename, 32);
								format(string, sizeof(string), "%s\nช่องที่ %d | พื้นผิว: %s", string, materialslot + 1, texturename);
							}
						}

						return Dialog_Show(playerid, ReturnFurnitureEditMenu, DIALOG_STYLE_MSGBOX, "ข้อมูล:", string, "ปิด", "");
					}
				}
		    }
		    case 1: { // Position
				new houseid = insideHouseID[playerid];
				new fid = GetPVarInt(playerid, "ChosenFurnitureObject");
				if(Iter_Contains(Iter_HouseFurniture[houseid], fid)) {
					SetPVarInt(playerid, "EditingFurniture", 1);
					EditDynamicObject(playerid, furnitureData[houseid][fid][fObject]);
					ShowPlayerFooter(playerid, "~n~HOLD \"~y~SPACE~w~\" AND PRESS YOUR \"~y~MMB~w~\" KEY TO MOVE YOUR FURNITURE ITEM BACK TO YOU.", 7000);
					SendClientMessageEx(playerid, COLOR_GRAD1, "คุณกำลังแก้ไขเฟอร์นิเจอร์ %s", furnitureData[houseid][fid][fName]);
				}
				return 1;
		    }
		    case 2: { // Material
				new houseid = insideHouseID[playerid];
				if (MaterialAbility(houseid)) {
					ShowPlayerFooter(playerid, "~n~~n~EACH FURNITURE ITEM HAS AROUND 5 TEXTURE SLOTS.~n~EACH SLOT AFFECTS A PIECE OF THE ITEM.", 5000);
					return ShowMaterialMenu(playerid);
				}
				else {
					SendClientMessage(playerid, COLOR_LIGHTRED, "ฟังก์ชั่นนี้มีไว้สำหรับผู้บริจาคเท่านั้น");
					return EditFurniture(playerid);
				}
			}
		    case 3: { // Sell
				new houseid = insideHouseID[playerid];
				new string[512];
				new fid = GetPVarInt(playerid, "ChosenFurnitureObject");
				new fdid = -1; // FurnitureItems

				for(new i = 0, j = sizeof(FurnitureItems); i != j; ++i)
				{
					if(FurnitureItems[i][furnitureModel] == furnitureData[houseid][fid][fModel]) {
						fdid = i;
						break;
					}
				}

				if (fdid != -1) {
					new count = 0, subcategory = -1;
					for(new i = 0, j = sizeof(fSubCategory); i != j; ++i)
					{
						if(fSubCategory[i][catid] == FurnitureItems[fdid][furnitureCatalog]) {
							if(count == FurnitureItems[fdid][furnitureSubCatalog])
							{
								subcategory = i;
								break;
							}
							count++;
						}
					}

					if (subcategory != -1) {
						format(string, sizeof(string), ""EMBED_DIALOG"หมวด:"EMBED_YELLOW" %s\n"EMBED_WHITE"หมวดย่อย:"EMBED_YELLOW" %s\n"EMBED_WHITE"สิ่งของ:"EMBED_YELLOW" %s\n"EMBED_WHITE"ชื่อ:"EMBED_YELLOW" %s\n"EMBED_WHITE"ราคา: %s", 
						fCategory[FurnitureItems[fdid][furnitureCatalog]], fSubCategory[subcategory][subname], FurnitureItems[fdid][furnitureName], furnitureData[houseid][fid][fName], FormatNumber(FurnitureItems[fdid][furniturePrice], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));


						new query[128], materialslot;
						format(query, sizeof(query), "SELECT * FROM `house_materials` WHERE `furnitureid` = %d  ORDER BY `matIndex` ASC", furnitureData[houseid][fid][fID]);
						mysql_query(dbCon, query);

						new rows, texturename[32];
						cache_get_row_count(rows);
						if(rows)
						{
							format(string, sizeof(string), "%s\n{FF6347}", string);
							for (new i = 0; i < rows; i ++)
							{
								cache_get_value_name_int(i, "matIndex", materialslot);
								cache_get_value_name(i, "MatTexture", texturename, 32);
								format(string, sizeof(string), "%s\nช่องที่ %d | พื้นผิว: %s", string, materialslot + 1, texturename);
							}
						}

						return Dialog_Show(playerid, HandleFurnitureSelling, DIALOG_STYLE_MSGBOX, "คุณแน่ใจไหม:?", string, "ขาย", "<<");
					}
				}	
			}
		    case 4: { // Rename
				return Dialog_Show(playerid, HandleFurnitureRename, DIALOG_STYLE_INPUT, "การแก้ไขชื่อ:", "คุณสามารถตั้งชื่อให้กับเฟอร์นิเจอร์ของคุณได้ดังนี้\n\t- ตัวอักษรต้องไม่ต่ำกว่า 3 ตัวอักษร\n\t- ตัวอักษรต้องไม่มากกว่า 30 ตัวอักษร\n\t- ไม่สามารถใช้ตัวอักษรพิเศษได้", "เลือก", "<<");
			}
		    case 5: { // Copy
				new houseid = insideHouseID[playerid];
				new string[512];
				new fid = GetPVarInt(playerid, "ChosenFurnitureObject");
				new fdid = -1; // FurnitureItems

				for(new i = 0, j = sizeof(FurnitureItems); i != j; ++i)
				{
					if(FurnitureItems[i][furnitureModel] == furnitureData[houseid][fid][fModel]) {
						fdid = i;
						break;
					}
				}

				if (fdid != -1) {
					new count = 0, subcategory = -1;
					for(new i = 0, j = sizeof(fSubCategory); i != j; ++i)
					{
						if(fSubCategory[i][catid] == FurnitureItems[fdid][furnitureCatalog]) {
							if(count == FurnitureItems[fdid][furnitureSubCatalog])
							{
								subcategory = i;
								break;
							}
							count++;
						}
					}

					if (subcategory != -1) {
						format(string, sizeof(string), ""EMBED_DIALOG"หมวด:"EMBED_YELLOW" %s\n"EMBED_WHITE"หมวดย่อย:"EMBED_YELLOW" %s\n"EMBED_WHITE"สิ่งของ:"EMBED_YELLOW" %s\n"EMBED_WHITE"ชื่อ:"EMBED_YELLOW" %s\n"EMBED_WHITE"ราคา: %s", 
						fCategory[FurnitureItems[fdid][furnitureCatalog]], fSubCategory[subcategory][subname], FurnitureItems[fdid][furnitureName], furnitureData[houseid][fid][fName], FormatNumber(FurnitureItems[fdid][furniturePrice], ""EMBED_GREENMONEY"$"EMBED_YELLOW""));


						new query[128], materialslot;
						format(query, sizeof(query), "SELECT * FROM `house_materials` WHERE `furnitureid` = %d  ORDER BY `matIndex` ASC", furnitureData[houseid][fid][fID]);
						mysql_query(dbCon, query);

						new rows, texturename[32];
						cache_get_row_count(rows);
						if(rows)
						{
							format(string, sizeof(string), "%s\n{FF6347}", string);
							for (new i = 0; i < rows; i ++)
							{
								cache_get_value_name_int(i, "matIndex", materialslot);
								cache_get_value_name(i, "MatTexture", texturename, 32);
								format(string, sizeof(string), "%s\nช่องที่ %d | พื้นผิว: %s", string, materialslot + 1, texturename);
							}
						}

						return Dialog_Show(playerid, HandleFurnitureDuplicate, DIALOG_STYLE_MSGBOX, "คุณแน่ใจไหม:?", string, "ซื้อ", "<<");
					}
				}
		    }
		}
	}
	return ShowFurnitureMenu(playerid);
}

forward OnHouseFurnitureSell(playerid, houseid, fid);
public OnHouseFurnitureSell(playerid, houseid, fid) {
	if (cache_affected_rows()) {
		if (Iter_Contains(Iter_HouseFurniture[houseid], fid)) {
			new query[128];
			mysql_format(dbCon, query, sizeof(query), "DELETE FROM `house_materials` WHERE `furnitureid` = %d", furnitureData[houseid][fid][fID]);
			mysql_tquery(dbCon, query);

			Iter_Remove(Iter_HouseFurniture[houseid], fid);
			new sellprice = floatround(float(furnitureData[houseid][fid][fMarketPrice]) * 0.7);
			SendClientMessageEx(playerid, COLOR_GRAD2, "คุณได้ขาย %s และได้รับเงินคืน 70 เปอร์เซ็นต์ $%d", furnitureData[houseid][fid][fName], sellprice);
			playerData[playerid][pCash] += sellprice;
			DestroyDynamicObject(furnitureData[houseid][fid][fObject]);
		}
	}
}

Dialog:HandleFurnitureSelling(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new fid = GetPVarInt(playerid, "ChosenFurnitureObject");
		new houseid = insideHouseID[playerid];
		if (Iter_Contains(Iter_HouseFurniture[houseid], fid)) {
			new query[128];
			mysql_format(dbCon, query, sizeof(query), "DELETE FROM `house_furnitures` WHERE `id` = %d", furnitureData[houseid][fid][fID]);
			mysql_tquery(dbCon, query, "OnHouseFurnitureSell", "iii", playerid, houseid, fid);
		}

		return ShowFurnitureMenu(playerid);
	}
	return EditFurniture(playerid);
}

Dialog:HandleFurnitureRename(playerid, response, listitem, inputtext[]) {

	if (response) {

		if(strlen(inputtext) < 3 || strlen(inputtext) > 30)
		    return Dialog_Show(playerid, HandleFurnitureRename, DIALOG_STYLE_INPUT, "การแก้ไขชื่อ:", "คุณสามารถตั้งชื่อให้กับเฟอร์นิเจอร์ของคุณได้ดังนี้\n\t- ตัวอักษรต้องไม่ต่ำกว่า 3 ตัวอักษร\n\t- ตัวอักษรต้องไม่มากกว่า 30 ตัวอักษร\n\t- ไม่สามารถใช้ตัวอักษรพิเศษได้", "เลือก", "<<");

		if(!IsEnglishAndNumber(inputtext))
		    return Dialog_Show(playerid, HandleFurnitureRename, DIALOG_STYLE_INPUT, "การแก้ไขชื่อ:", "คุณสามารถตั้งชื่อให้กับเฟอร์นิเจอร์ของคุณได้ดังนี้\n\t- ตัวอักษรต้องไม่ต่ำกว่า 3 ตัวอักษร\n\t- ตัวอักษรต้องไม่มากกว่า 30 ตัวอักษร\n\t- ไม่สามารถใช้ตัวอักษรพิเศษได้", "เลือก", "<<");

		new fid = GetPVarInt(playerid, "ChosenFurnitureObject");
		new houseid = insideHouseID[playerid];
		if (Iter_Contains(Iter_HouseFurniture[houseid], fid)) {
			new query[128];
			format(furnitureData[houseid][fid][fName], MAX_FURNITURE_NAME, inputtext);
			mysql_format(dbCon, query, 128, "UPDATE `house_furnitures` SET `name` = '%e' WHERE `id` = %d", inputtext, furnitureData[houseid][fid][fID]);
			mysql_tquery(dbCon, query);
		}
	}
	return EditFurniture(playerid);
}

Dialog:HandleFurnitureDuplicate(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new fid = GetPVarInt(playerid, "ChosenFurnitureObject");
		new houseid = insideHouseID[playerid];
		if (Iter_Contains(Iter_HouseFurniture[houseid], fid)) {

			new
				furnitureid;

			for(new i = 0; i != sizeof(FurnitureItems); ++i)
			{
				if(FurnitureItems[i][furnitureModel] == furnitureData[houseid][fid][fModel]) {
					furnitureid = i;
					break;
				}
			}
			SetPVarInt(playerid, "FurnitureItemID", furnitureid);

			if(houseid != -1) {
				if(IsHouseCanBuyFurniture(houseid, CountFurniture(houseid))) {

					if(playerData[playerid][pCash] >= FurnitureItems[furnitureid][furniturePrice]) {
						playerData[playerid][pCash] -= FurnitureItems[furnitureid][furniturePrice];

						FurnObject[playerid] = CreatePlayerObject(playerid, FurnitureItems[furnitureid][furnitureModel], furnitureData[houseid][fid][fPosX], furnitureData[houseid][fid][fPosY], furnitureData[houseid][fid][fPosZ], furnitureData[houseid][fid][fPosRX], furnitureData[houseid][fid][fPosRY], furnitureData[houseid][fid][fPosRZ]);
						SetPVarInt(playerid, "FurnitureEditorMode", 1);
						EditPlayerObject(playerid, FurnObject[playerid]);

						ShowPlayerFooter(playerid, "~n~HOLD \"~y~SPACE~w~\" AND PRESS YOUR \"~y~MMB~w~\" KEY TO MOVE YOUR FURNITURE ITEM BACK TO YOU.~n~PRESS YOUR \"~r~ESC~w~\" KEY TO RETURN THE ITEM IF YOU ARE NOT PLEASED", 7000);
						return 1;
					}
					else SendClientMessage(playerid, COLOR_GRAD1, "   คุณมีเงินไม่พอ !");
				}
				else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณใช้สล็อตเฟอร์นิเจอร์สูงสุดของคุณแล้ว");
			}
		}
	}
	return EditFurniture(playerid);
}

ShowMaterialMenu(playerid) {
    return Dialog_Show(playerid, FurnitureMaterial, DIALOG_STYLE_LIST, "ช่องแก้ไขที่ใช้งานได้:", "พื้นผิวช่องที่ 1\nพื้นผิวช่องที่ 2\nพื้นผิวช่องที่ 3\nพื้นผิวช่องที่ 4\nพื้นผิวช่องที่ 5\nลบพื้นผิวทั้งหมด", "เลือก", "<<");
}

Dialog:FurnitureMaterial(playerid, response, listitem, inputtext[]) {
	new fid = GetPVarInt(playerid, "ChosenFurnitureObject");
	if(response)
	{
		new houseid = insideHouseID[playerid];
		if (Iter_Contains(Iter_HouseFurniture[houseid], fid)) {
			if(listitem == 5)
			{
				new query[128];
				mysql_format(dbCon, query, sizeof query, "DELETE FROM `house_materials` WHERE `furnitureid` = %d", furnitureData[houseid][fid][fID]);
				mysql_tquery(dbCon, query);
				
				SetDynamicObjectMaterial(furnitureData[houseid][fid][fObject], 0, -1, "none", "none", 0xFFFFFFFF);
				SetDynamicObjectMaterial(furnitureData[houseid][fid][fObject], 1, -1, "none", "none", 0xFFFFFFFF);
				SetDynamicObjectMaterial(furnitureData[houseid][fid][fObject], 2, -1, "none", "none", 0xFFFFFFFF);
				SetDynamicObjectMaterial(furnitureData[houseid][fid][fObject], 3, -1, "none", "none", 0xFFFFFFFF);
				SetDynamicObjectMaterial(furnitureData[houseid][fid][fObject], 4, -1, "none", "none", 0xFFFFFFFF);

				SendClientMessageEx(playerid, COLOR_GRAD2, "คุณได้ลบพื้นผิวทั้งหมดของ %s", furnitureData[houseid][fid][fName]);
			}
			else {
				SetPVarInt(playerid, "FurnitureEditingSlot", listitem);
				return ShowMaterialEditType(playerid);
			}
		}
	}
	return EditFurniture(playerid);
}

ShowMaterialEditType(playerid) {
	if(GetPVarType(playerid, "FurnitureEditingSlot")) {
		new str[64];
		new materialslot = GetPVarInt(playerid, "FurnitureEditingSlot");
		format(str, 64, "แก้ไขพื้นผิว("EMBED_YELLOW"%d"EMBED_WHITE"):", materialslot + 1);
		return Dialog_Show(playerid, FurnitureEditingTexture, DIALOG_STYLE_LIST, str, "แก้ไขสี\nแก้ไขพื้นผิว\nลบพื้นผิว\nข้อมูลพื้นผิว", "เลือก", "<<");
	}
	else {
		return ShowMaterialMenu(playerid);
	}
}

Dialog:FurnitureEditingTexture(playerid, response, listitem, inputtext[]) {

	if(response)
	{
		switch(listitem)
		{
		    case 0: { // Edit Color
				return ShowMaterialColor(playerid);
		    }
			case 1: { // Show Material list
				return SelectMaterial(playerid);
			}
		    case 2: { // Remove Texture

				new houseid = insideHouseID[playerid];
				new fid = GetPVarInt(playerid, "ChosenFurnitureObject");
				if(Iter_Contains(Iter_HouseFurniture[houseid], fid)) {

					new materialslot = GetPVarInt(playerid, "FurnitureEditingSlot");

					new query[128];
					format(query, sizeof(query), "DELETE FROM `house_materials` WHERE `matIndex` = %d AND `furnitureid` = %d", materialslot, furnitureData[houseid][fid][fID]);
					mysql_tquery(dbCon, query);
					
					SetDynamicObjectMaterial(furnitureData[houseid][fid][fObject], materialslot, -1, "none", "none", 0);
				}
				return ShowMaterialMenu(playerid);
		    }
		    case 3: { //Material Infomation

				new houseid = insideHouseID[playerid];
				new fid = GetPVarInt(playerid, "ChosenFurnitureObject");
				if(Iter_Contains(Iter_HouseFurniture[houseid], fid)) {

					new materialslot = GetPVarInt(playerid, "FurnitureEditingSlot");

					new query[128];
					format(query, sizeof(query), "SELECT * FROM `house_materials` WHERE `furnitureid` = %d  AND `matIndex` = %d", furnitureData[houseid][fid][fID], materialslot);
					mysql_query(dbCon, query);

					new rows, string[256], texturename[32];
					cache_get_row_count(rows);
					if(rows)
					{
						format(string, sizeof(string), "{FF6347}");
						for (new i = 0; i < rows; i ++)
						{
							cache_get_value_name_int(i, "matIndex", materialslot);
							cache_get_value_name(i, "MatTexture", texturename, 32);
							format(string, sizeof(string), "%s\nช่องที่ %d | พื้นผิว: %s", string, materialslot + 1, texturename);
						}
					}
					return Dialog_Show(playerid, HouseMaterialInfo, DIALOG_STYLE_MSGBOX, "ข้อมูล:", string, "ปิด", "");
				}
		    }
		}
	}
	return ShowMaterialMenu(playerid);
}

Dialog:HouseMaterialInfo(playerid, response, listitem, inputtext[]) {
	return ShowMaterialEditType(playerid);
}

SelectMaterial(playerid, page = 0) {
	new string[800], count;
	for(new i = page * 25, j = sizeof(MaterialData); i != j; ++i)
	{
		if(count >= 25)
		{
			format(string, sizeof(string), "%s>>\n", string);
			break;
		}
		format(string, sizeof(string), "%s%s\n", string, MaterialData[i][mName]);
		count++;
	}
	if(page > 0) format(string, sizeof(string), "%s<<\n", string);

	new materialslot = GetPVarInt(playerid, "FurnitureEditingSlot");
	return Dialog_Show(playerid, FurnitureSelectMaterial, DIALOG_STYLE_LIST, sprintf("แก้ไขพื้นผิว(%d):", materialslot + 1), string, "เลือก", "<<");
}

Dialog:FurnitureSelectMaterial(playerid, response, listitem, inputtext[]) {

	if(response)
	{
	    new page = GetPVarInt(playerid, "MaterialPages");
		if(!strcmp(inputtext, ">>", true)) {
			page++;
		    SetPVarInt(playerid, "MaterialPages", page);
			SelectMaterial(playerid, page);
		}
		else if(!strcmp(inputtext, "<<", true)) {
		    page--;
		    SetPVarInt(playerid, "MaterialPages", page);
			SelectMaterial(playerid, page);
		}
		else
		{
			new fid = GetPVarInt(playerid, "ChosenFurnitureObject");
			new houseid = insideHouseID[playerid];
			if (Iter_Contains(Iter_HouseFurniture[houseid], fid)) {
				new i = listitem + (page * 25);
				new materialslot = GetPVarInt(playerid, "FurnitureEditingSlot");

				new query[128];
				format(query, 128, "SELECT * FROM house_materials WHERE furnitureid=%d  AND matIndex=%d", furnitureData[houseid][fid][fID], materialslot);
				mysql_tquery(dbCon, query, "OnMaterialUpdate", "issii", MaterialData[i][mModel], MaterialData[i][mtxd], MaterialData[i][mtexture], furnitureData[houseid][fid][fID], materialslot);
				SetDynamicObjectMaterial(furnitureData[houseid][fid][fObject], materialslot, MaterialData[i][mModel], MaterialData[i][mtxd], MaterialData[i][mtexture], 0);
			}
			/*for(new i = page * 25; i != sizeof(MaterialData); ++i)
			{
				if(listitem == count)
				{
					format(szQuery, sizeof(szQuery), "SELECT * FROM `%s_materials` WHERE `furnitureid` = %d  AND `matIndex` = %d", data[fType] == TYPE_HOUSE ? ("house") : ("business"), data[fID], materialslot);
					mysql_query(dbCon, szQuery);
	
					if(cache_num_rows()) {
						format(query, sizeof(query), "UPDATE `%s_materials` SET `matModel` = '%d', `matTxd` = '%s', `MatTexture` = '%s' WHERE `furnitureid` = %d AND `matIndex` = %d", data[fType] == TYPE_HOUSE ? ("house") : ("business"), MaterialData[i][mModel], MaterialData[i][mtxd], MaterialData[i][mtexture], data[fID], materialslot);
						mysql_tquery(dbCon, query, "", "");
					}
					else {
						format(query, sizeof(query), "INSERT INTO `%s_materials` (`furnitureid`, `matIndex`, `matModel`, `matTxd`, `MatTexture`, `MatName`) VALUES ('%d', '%d', '%d', '%s', '%s', '%s')", data[fType] == TYPE_HOUSE ? ("house") : ("business"), data[fID], materialslot, MaterialData[i][mModel], MaterialData[i][mtxd], MaterialData[i][mtexture], MaterialData[i][mName]);
						mysql_tquery(dbCon, query, "", "");
					}
					SetDynamicObjectMaterial(objectid, materialslot, MaterialData[i][mModel], MaterialData[i][mtxd], MaterialData[i][mtexture], 0xFFFFFFFF);
					break;
				}
				count++;
			}*/
			
			Dialog_Show(playerid, FurnitureMaterial, DIALOG_STYLE_LIST, "ช่องแก้ไขที่ใช้งานได้:", "พื้นผิวช่องที่ 1\nพื้นผิวช่องที่ 2\nพื้นผิวช่องที่ 3\nพื้นผิวช่องที่ 4\nพื้นผิวช่องที่ 5\nลบพื้นผิวทั้งหมด", "เลือก", "<<");
			return 1;
		}
		SelectMaterial(playerid);
	}
	else {
		ShowMaterialEditType(playerid);
	}
	return 1;
}

ShowMaterialColor(playerid) {
	if(GetPVarType(playerid, "FurnitureEditingSlot")) {
		new str[64];
		new materialslot = GetPVarInt(playerid, "FurnitureEditingSlot");
		format(str, 64, "แก้ไขพื้นผิว("EMBED_YELLOW"%d"EMBED_WHITE"):", materialslot + 1);
		return Dialog_Show(playerid, FurnitureSelectColor, DIALOG_STYLE_LIST, str, "สีขาว\nสีแดง\nสีน้ำเงิน\nสีส้ม\nสีเขียว\nสีดำ\nสีน้ำเงินสว่าง", "เลือก", "<<");
	}
	else {
		return ShowMaterialMenu(playerid);
	}
}

forward OnMaterialUpdate(modelid, txd[], texture[], furnitureid, materialslot);
public OnMaterialUpdate(modelid, txd[], texture[], furnitureid, materialslot) {
	new query[256];
	if(cache_num_rows()) {
		mysql_format(dbCon, query, sizeof(query), "UPDATE `house_materials` SET `matModel` = '%d', `matTxd` = '%e', `MatTexture` = '%e' WHERE `furnitureid` = %d AND `matIndex` = %d", modelid, txd, texture, furnitureid, materialslot);
		mysql_tquery(dbCon, query);
	}
	else {
		mysql_format(dbCon, query, sizeof(query), "INSERT INTO `house_materials` (`furnitureid`, `matIndex`, `matModel`, `matTxd`, `MatTexture`) VALUES ('%d', '%d', '%d', '%e', '%e')", furnitureid, materialslot, modelid, txd, texture);
		mysql_tquery(dbCon, query);
	}
}

Dialog:FurnitureSelectColor(playerid, response, listitem, inputtext[]) {

	if(response)
	{
		new houseid = insideHouseID[playerid];
		new fid = GetPVarInt(playerid, "ChosenFurnitureObject");

		if (Iter_Contains(Iter_HouseFurniture[houseid], fid)) {
			new materialslot = GetPVarInt(playerid, "FurnitureEditingSlot");

			new query[128];
			format(query, 128, "SELECT * FROM house_materials WHERE furnitureid=%d  AND matIndex=%d", furnitureData[houseid][fid][fID], materialslot);
			mysql_tquery(dbCon, query, "OnMaterialUpdate", "issii", 18646, "matcolours", MaterialColorData[listitem], furnitureData[houseid][fid][fID], materialslot);
			SetDynamicObjectMaterial(furnitureData[houseid][fid][fObject], materialslot, 18646, "matcolours", MaterialColorData[listitem], 0);
		}
		return ShowMaterialMenu(playerid);
	}
	else {
		return ShowMaterialEditType(playerid);
	}
}

isHouseDoor(model)
{
	switch (model) {
		case 3109, 19857, 3093, 2947, 2955, 2946, 2930, 977, 1491, 1492, 1493, 1494, 1495, 1496, 1497, 1498, 1499..1507, 1559, 1567, 1569, 1535, 1523, 1533, 1532, 1522:
		    return 1;
	}
	return 0;
}

hook OnPlayerSelectDynObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
{
	if(IsValidDynamicObject(objectid) && GetPVarInt(playerid, "SelectingFurniture") == 1) {

		new houseid = insideHouseID[playerid];
		if (houseid != -1) {
			foreach(new fid : Iter_HouseFurniture[houseid]) {
				if (furnitureData[houseid][fid][fObject] == objectid) {
					SetPVarInt(playerid, "ChosenFurnitureObject", fid);
					EditFurniture(playerid);
					CancelEdit(playerid);
					break;
				}
			}
		}
	}
	return 1;
}

hook OnPlayerEditDynObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	new Float:oldX, Float:oldY, Float:oldZ,
	Float:oldRotX, Float:oldRotY, Float:oldRotZ;
	GetDynamicObjectPos(objectid, oldX, oldY, oldZ);
	GetDynamicObjectRot(objectid, oldRotX, oldRotY, oldRotZ);

	if(IsValidDynamicObject(objectid) && GetPVarInt(playerid, "EditingFurniture") == 1)
	{
		if(response == EDIT_RESPONSE_FINAL)
		{
			new houseid = insideHouseID[playerid];
			new fid = GetPVarInt(playerid, "ChosenFurnitureObject");

			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);
			SendClientMessage(playerid, COLOR_GRAD1, "คุณได้แก้ไขตำแหน่งของเฟอนิเจอร์เสร็จแล้ว");
			if(Iter_Contains(Iter_HouseFurniture[houseid], fid)) {
				OnPlayerEditedFurniture(furnitureData[houseid][fid][fID], x, y, z, rx, ry, rz);
			}
			DeletePVar(playerid, "EditingFurniture");

			EditFurniture(playerid);
		}
		if(response == EDIT_RESPONSE_CANCEL)
		{
			SetDynamicObjectPos(objectid, oldX, oldY, oldZ);
			SetDynamicObjectRot(objectid, oldRotX, oldRotY, oldRotZ);
			SendClientMessage(playerid, COLOR_GRAD1, "คุณได้ยกเลิกการแก้ไขตำแหน่งของเฟอนิเจอร์");
			DeletePVar(playerid, "EditingFurniture");

			EditFurniture(playerid);
		}
		return 1;
	}
	return 1;
}

OnPlayerEditedFurniture(furnitureid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	new query[256];
	format(query, sizeof(query), "UPDATE `house_furnitures` SET `posx` = %f, `posy` = %f, `posz` = %f, `posrx` = %f, `posry` = %f, `posrz` = %f WHERE `id` = %d", x, y, z, rx, ry, rz, furnitureid);
	mysql_query(dbCon, query);
	return 1;
}


hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_LOOK_BEHIND || newkeys & KEY_SUBMISSION ) {
		
		if(GetPVarInt(playerid, "FurnitureEditorMode") == 1) {
			new Float:px, Float:py, Float:pz;
			GetPlayerPos(playerid, px, py, pz);
			GetXYInFrontOfPlayer(playerid, px, py, 1.5);
		
			new objectid = FurnObject[playerid];
			if(IsValidPlayerObject(playerid, objectid))
			{
				SetPlayerObjectPos(playerid, objectid, px, py, pz);
				SetPlayerObjectRot(playerid, objectid, 0, 0, 0);
			}
		}
		else if(GetPVarInt(playerid, "EditingFurniture") == 1) {

			new houseid = insideHouseID[playerid];
			new fid = GetPVarInt(playerid, "ChosenFurnitureObject");

			if(Iter_Contains(Iter_HouseFurniture[houseid], fid)) {

				if(IsValidDynamicObject(furnitureData[houseid][fid][fObject]))
				{
					new Float:px, Float:py, Float:pz;
					GetPlayerPos(playerid, px, py, pz);
					GetXYInFrontOfPlayer(playerid, px, py, 1.5);

					SetDynamicObjectPos(furnitureData[houseid][fid][fObject], px, py, pz);
					SetDynamicObjectRot(furnitureData[houseid][fid][fObject], 0, 0, 0);
				}
			}
		}
		
    }
	return 1;
}