#include <YSI\y_hooks>

#define MAX_CLOTHES 15

#define BUYZIP 1
#define BUYHARDWARE 2
#define BUYSPORTS 3
#define BUYMUSIC 4
#define BUYWATCH 5
#define BUYPOLICE 6
#define BUYMEDIC 7
#define BUYSPECIAL 8

new const BoneName[][] = {
	"กระดูกสันหลัง", "หัว", "ต้นแขนซ้าย", "ต้นแขนขวา",
	"มือซ้าย", "มือขวา", "ต้นขาซ้าย", "ต้นขาขวา", "เท้าซ้าย", "เท้าขวา", "น่องขวา", "น่องซ้าย",
	"แขนซ้าย", "แขนขวา", "กระดูกไหปลาร้าซ้าย", "กระดูกไหปลาร้าขวา", "คอ", "กราม"
}
;

enum e_cloths {
	cl_sid,
	cl_object,
	Float:cl_x,
	Float:cl_y,
	Float:cl_z,
	Float:cl_rx,
	Float:cl_ry,
	Float:cl_rz,
	Float:cl_scalex,
	Float:cl_scaley,
	Float:cl_scalez,
	cl_bone,
	cl_slot,
	cl_equip,
	cl_mc1,
	cl_mc2,
	cl_name[32]
};

enum e_cldata {
	e_model,
	e_price,
	e_bone,
	e_name[32],
	Float:e_x,
	Float:e_y,
	Float:e_z,
	Float:e_rx,
	Float:e_ry,
	Float:e_rz,
	Float:e_sx,
	Float:e_sy,
	Float:e_sz
};

new const cl_SportsData[][e_cldata] = { // 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0
	{18645, 200, 2, "(Red&White)Motorcycle Helmet", 0.059999, 0.023999, 0.005, 93.6, 75.3, 0.0, 1.0, 1.0, 1.0},
	{18976, 200, 2, "(Blue&White)DirtBike Helmet", 0.084999, 0.043999, -0.002, 82.1, 88.2999, 8.5, 1.0, 1.0, 1.0},
	{18977, 200, 2, "(Red&Black)Motorcycle Helmet", 0.052999, 0.016999, 0.006999, 0.0, 91.1, 75.7, 1.0, 1.0, 1.0},
	{18978, 200, 2, "(Blue&White)Motorcycle Helmet", 0.052999, 0.032, -0.007, 74.9, 86.5, -4.60001, 1.0, 1.0, 1.0},
	{18979, 200, 2, "(Purple)Motorcycle Helmet", 0.051999, 0.028, 0.0, 93.3, 74.8, -9.6, 1.0, 1.0, 1.0},
	{19036, 157, 2, "White Hockey Mask", 0.088996, 0.043997, -0.002998, 101.3, 92.2001, -16.5, 1.0, 1.0, 1.0},
	{19037, 157, 2, "Red Hockey Mask", 0.088996, 0.043997, -0.002998, 101.3, 92.2001, -16.5, 1.0, 1.0, 1.0},
	{19038, 157, 2, "Green Hockey Mask", 0.088996, 0.043997, -0.002998, 101.3, 92.2001, -16.5, 1.0, 1.0, 1.0},
	{3026, 200, 1, "Backpack", -0.147999, -0.061999, 0.006999, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0},
	{19559, 150, 1, "Hiking Backpack", 0.108999, -0.041, 0.000999, -5.09999, 90.1999, 3.0, 1.0, 1.0, 1.0},
	{2919, 150, 5, "Sports Bag", 0.240999, -0.066, 0.014999, 6.9, -94.6, 14.6, 0.353999, 0.196, 0.348},
	{19624, 200, 5, "Suitcase", 0.067, 0.014999, -0.006, 0.0, -90.3, -3.8, 1.0, 1.0, 1.0}
};

new const cl_MusicalData[][e_cldata] = { // 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0
	{19317, 250, 5, "Bass Guitar", 0.066999, 0.026, 0.0, 0.0, -157.5, 0.0, 1.0, 1.0, 1.0},
	{19318, 250, 5, "Flying Guitar", 0.066999, 0.026, 0.0, 0.0, -157.5, 0.0, 1.0, 1.0, 1.0},
	{19319, 250, 5, "Warlock Guitar", 0.066999, 0.026, 0.0, 0.0, -157.5, 0.0, 1.0, 1.0, 1.0},
	{19610, 250, 5, "Microphone", 0.072999, 0.041, -0.001999, 97.0, 3.1, -176.1, 1.0, 1.0, 1.0}
};

new const cl_PoliceData[][e_cldata] = { // 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0
	{18636, 90, 2, "Black Police Cap", 0.136999,0.048999,0.000000,0.000003,89.099975,88.299980,1.000000,1.000000,1.000000},
	{19161, 90, 2, "Black Police Cap", 0.076000,0.004999,-0.001999,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000},
	{19162, 90, 2, "Blue Police Cap", 0.076000,0.004999,-0.001999,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000},
	{19099, 90, 2, "Black Police Hat", 0.165000,0.028000,-0.000999,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000},
	{19100, 90, 2, "Brown Police Hat", 0.165000,0.028000,-0.000999,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000},
	{19521, 150, 2, "Officer Cap", 0.159000,0.016000,-0.002999,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000},
	{19200, 150, 2, "Police Helmet", 0.129999,0.034999,-0.003999,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000},
	{19138, 150, 2, "Black Stylish Glasses", 0.089998,0.043999,-0.003000,12.099998,84.200050,82.700042,1.000000,1.000000,1.000000},
	{19142, 300, 1, "SWAT Armour", 0.071998,0.044000,0.004000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000},
	{19141, 300, 2, "SWAT Helmet", 0.115000,0.014000,-0.000999,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000},
	{19515, 300, 1, "Grey SWAT Armour", 0.071998,0.044000,0.004000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000},
	{19514, 300, 2, "Grey SWAT Helmet", 0.115000,0.014000,-0.000999,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000},
	{19942, 400, 5, "Police Radio", 0.072999,0.054999,-0.037000,0.000000,-168.900039,-15.699998,1.000000,1.000000,1.000000},
	{11750, 400, 1, "Closed Handcuffs", -0.140999,-0.013999,-0.151000,-47.800018,-10.599998,-103.000000,1.000000,1.000000,1.000000},
	{11749, 400, 5, "Open Handcuffs", 0.208000,0.026999,-0.031000,-84.699935,-3.499998,-81.999977,1.000000,1.000000,1.000000},
	{-1001, 300, 1, "LSPD Armour (Mod)", 0.071998,0.044000,0.004000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000},
	{-1002, 300, 1, "LSPD RIOT (Mod)", 0.071998,0.044000,0.004000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000}
};

new const cl_MedicData[][e_cldata] = { // 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0
	{11736, 100, 5, "First aid kit", 0.272999,0.079999,-0.035000,95.600028,-168.800048,7.899988,1.000000,1.000000,1.000000},
	{11738, 300, 5, "Medic Case", 0.290000,0.008999,0.037000,0.099999,-105.599983,-8.099993,1.000000,1.000000,1.000000},
	{11747, 150, 5, "Bandage", 0.116000,0.022000,0.000000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000},
	{19331, 300, 2, "Black Fire Helmet", 0.158,-0.006,-0.000999,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000},
	{19330, 300, 2, "Yellow Fire Helmet", 0.158,-0.006,-0.000999,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000}

};

new const cl_HardwareData[][e_cldata] = { // 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0
	{19113, 250, 2, "Hippie Helmet", 0.152999, 0.030999, 0.000000, 0.000000, 0.000000, 0.000000, 1.0, 1.0, 1.0},
	{19114, 250, 2, "DSM Helmet", 0.152999, 0.030999, 0.000000, 0.000000, 0.000000, 0.000000, 1.0, 1.0, 1.0},
	{19115, 250, 2, "Toxic Helmet", 0.152999, 0.030999, 0.000000, 0.000000, 0.000000, 0.000000, 1.0, 1.0, 1.0},
	{19116, 250, 2, "Black Helmet", 0.152999, 0.030999, 0.000000, 0.000000, 0.000000, 0.000000, 1.0, 1.0, 1.0},
	{19117, 250, 2, "Red Helmet", 0.152999, 0.030999, 0.000000, 0.000000, 0.000000, 0.000000, 1.0, 1.0, 1.0},
	{19118, 250, 2, "Green Helmet", 0.152999, 0.030999, 0.000000, 0.000000, 0.000000, 0.000000, 1.0, 1.0, 1.0},
	{19119, 250, 2, "Blue Helmet", 0.152999, 0.030999, 0.000000, 0.000000, 0.000000, 0.000000, 1.0, 1.0, 1.0},
	{19120, 250, 2, "Yellow Helmet", 0.152999, 0.030999, 0.000000, 0.000000, 0.000000, 0.000000, 1.0, 1.0, 1.0},
	{18632, 45, 5, "Fishing Rod", 0.106999, 0.041999, 0.000000, 0.000000, 0.000000, 0.000000, 1.0, 1.0, 1.0},
	{18633, 37, 5, "Wrench", 0.103998, 0.042998, 0.019998, -90.000000, -88.199897, -6.000000, 1.0, 1.0, 1.0},
	{18634, 37, 5, "Crowbar", 0.072999, 0.028999, -0.028999, -11.899999, -70.900001, 78.400001, 1.0, 1.0, 1.0},
	{18635, 39, 5, "Hammer", 0.032999, 0.070998, 0.040998, -176.500000, -13.500000, 0.000000, 1.0, 1.0, 1.0},
	{19631, 200, 5, "Sledge Hammer", 0.088999, 0.063998, -0.126999, 0.000000, -90.699996, -101.000000, 1.0, 1.0, 1.0},
	{18644, 31, 5, "Screwdriver", 0.099999, 0.041000, -0.029999, 0.000000, 0.000000, 0.000000, 1.0, 1.0, 1.0},
	{18641, 35, 5, "Flashlight", 0.072999, 0.039, -0.072999, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0},
	{18638, 240, 2, "Construction Helmet", 0.164000, 0.040998, 0.000000, 0.000000, 0.000000, 0.000000, 1.0, 1.0, 1.0},
	{19093, 240, 2, "Grey Construction Helmet", 0.087999, 0.002000, 0.000000, 0.000000, 0.000000, 0.000000, 1.0, 1.0, 1.0},
	{19160, 240, 2, "Labeled Construction Helmet", 0.087999, 0.002000, 0.000000, 0.000000, 0.000000, 0.000000, 1.0, 1.0, 1.0},
	{19904, 200, 1, "Construction Vest", 0.052999, 0.054999, -0.016000, 98.500000, 90.999702, 81.899902, 1.0, 1.0, 1.0},
	{1210, 500, 5, "Briefcase", 0.297998, 0.082000, -0.008000, -15.899999, -96.400001, -9.699999, 1.0, 1.0, 1.0},
	{19622, 300, 5, "Broom", 0.070998, 0.050999, -0.229000, 2.200000, 0.000000, 0.000000, 1.0, 1.0, 1.0},
	{337, 300, 5, "Shovel", 0.064998, 0.110999, 0.017999, 14.199999, 175.000000, -119.300003, 1.0, 1.0, 1.0},
	{19627, 300, 5, "Double ended wrench", 0.097998, 0.025000, -0.013999, -14.300000, 90.500000, 25.100000, 1.0, 1.0, 1.0},
	{19773, 300, 7, "Holster", 0.149, -0.021999, -0.100998, 0.600012, -98.3001, -173.7, 1.0, 1.0, 1.0}
};

new const cl_DsShopData[][e_cldata] = { // 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0
	{19042,150,5,"Gold watch",-0.001999,-0.016,-0.002,-83.8999,114.5,-82.0001,1.0,1.0,1.0},
	{19039,150,5,"Silver watch with gold band",-0.001999,-0.016,-0.002,-83.8999,114.5,-82.0001,1.0,1.0,1.0},
	{19041,150,5,"Silver watch with leather band",-0.001999,-0.016,-0.002,-83.8999,114.5,-82.0001,1.0,1.0,1.0},
	{19043,150,5,"Silver watch",-0.001999,-0.016,-0.002,-83.8999,114.5,-82.0001,1.0,1.0,1.0},
	{19043,150,5,"White silver watch",-0.001999,-0.016,-0.002,-83.8999,114.5,-82.0001,1.0,1.0,1.0},
	{19044,150,5,"Dark purple watch",-0.001999,-0.016,-0.002,-83.8999,114.5,-82.0001,1.0,1.0,1.0},
	{19045,150,5,"Purple watch",-0.001999,-0.016,-0.002,-83.8999,114.5,-82.0001,1.0,1.0,1.0},
	{19046,150,5,"Green watch",-0.001999,-0.016,-0.002,-83.8999,114.5,-82.0001,1.0,1.0,1.0},
	{19047,150,5,"Violet watch",-0.001999,-0.016,-0.002,-83.8999,114.5,-82.0001,1.0,1.0,1.0},
	{19048,150,5,"Seaside watch",-0.001999,-0.016,-0.002,-83.8999,114.5,-82.0001,1.0,1.0,1.0},
	{19049,150,5,"Funky watch",-0.001999,-0.016,-0.002,-83.8999,114.5,-82.0001,1.0,1.0,1.0},
	{19050,150,5,"Blue Tiger watch",-0.001999,-0.016,-0.002,-83.8999,114.5,-82.0001,1.0,1.0,1.0},
	{19051,150,5,"Tiger watch",-0.001999,-0.016,-0.002,-83.8999,114.5,-82.0001,1.0,1.0,1.0},
	{19052,150,5,"Pink Tiger watch",-0.001999,-0.016,-0.002,-83.8999,114.5,-82.0001,1.0,1.0,1.0},
	{19053,150,5,"Camo watch",-0.001999,-0.016,-0.002,-83.8999,114.5,-82.0001,1.0,1.0,1.0}
};

new const cl_ZipData[][e_cldata] = { // 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0
	{19066, 400, 2, "Santa Hat", 0.1229, 0.0350, 0.000, 90.7, 119.2999, -2.4, 1.0, 1.0, 1.0},
	{18970, 200, 2, "Tiger Pimp Hat", 0.1089, 0.0360, 0.0000, 0.0000, 93.5999, 87.7999, 1.0, 1.0, 1.0},
	{18971, 200, 2, "Disco Pimp Hat", 0.1089, 0.0360, 0.0000, 0.0000, 93.5999, 87.7999, 1.0, 1.0, 1.0},
	{18972, 200, 2, "Lava Pimp Hat", 0.1089, 0.0360, 0.0000, 0.0000, 93.5999, 87.7999, 1.0, 1.0, 1.0},
	{18973, 200, 2, "Camo Pimp Hat", 0.1089, 0.0360, 0.0000, 0.0000, 93.5999, 87.7999, 1.0, 1.0, 1.0},
	{18921, 210, 2, "Beret", 0.1430, 0.0210, -0.0029, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18922, 210, 2, "Red Beret", 0.1430, 0.0210, -0.0029, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18923, 210, 2, "Blue Beret", 0.1430, 0.0210, -0.0029, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18924, 210, 2, "Camo Beret", 0.1430, 0.0210, -0.0029, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{19067, 220, 2, "Red Hoody Hat", 0.1239, 0.0290, -0.0009, 85.5999, 118.7000, 1.0000, 1.0, 1.0, 1.0},
	{19068, 220, 2, "Zebra Hoody Hat", 0.1239, 0.0290, -0.0009, 85.5999, 118.7000, 1.0000, 1.0, 1.0, 1.0},
	{19069, 220, 2, "Black Hoody Hat", 0.1239, 0.0290, -0.0009, 85.5999, 118.7000, 1.0000, 1.0, 1.0, 1.0},
	{18926, 200, 2, "Camo Hat", 0.1460, 0.0250, -0.0070, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18927, 200, 2, "Blue Flame Hat", 0.1460, 0.0250, -0.0070, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18928, 200, 2, "Hippie Hat", 0.1460, 0.0250, -0.0070, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18929, 200, 2, "Illusion Hat", 0.1460, 0.0250, -0.0070, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18930, 200, 2, "Fire Hat", 0.1460, 0.0250, -0.0070, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18931, 200, 2, "Dark Flame Hat", 0.1460, 0.0250, -0.0070, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18932, 200, 2, "Lava Hat", 0.1460, 0.0250, -0.0070, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18933, 200, 2, "Poka Dot Hat", 0.1460, 0.0250, -0.0070, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18934, 200, 2, "Red Hat", 0.1460, 0.0250, -0.0070, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18935, 200, 2, "Yellow Hat", 0.1460, 0.0250, -0.0070, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18941, 200, 2, "Black Hat", 0.1460, 0.0250, -0.0070, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18942, 200, 2, "Dark Blue Hat", 0.1460, 0.0250, -0.0070, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18943, 200, 2, "Green Hat", 0.1460, 0.0250, -0.0070, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18961, 200, 2, "Trucker Hat", 0.1370, 0.0320, 0.0030, 103.0000, 94.0000, -14.9000, 1.0, 1.0, 1.0},
	{18960, 200, 2, "Cap Rim Up", 0.1370, 0.0320, 0.0030, 103.0000, 94.0000, -14.9000, 1.0, 1.0, 1.0},
	{18936, 250, 2, "Grey Helmet", 0.0980, 0.0369, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18937, 250, 2, "Red Helmet", 0.0980, 0.0369, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18938, 250, 2, "Purple Helmet", 0.0980, 0.0369, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{19101, 240, 2, "Army Helmet(Straps)", 0.1470, 0.0260, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{19102, 240, 2, "Navy Helmet(Straps)", 0.1470, 0.0260, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{19103, 240, 2, "Desert Helmet(Straps)", 0.1470, 0.0260, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{19104, 240, 2, "Day Camo Helmet(Straps)", 0.1470, 0.0260, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{19105, 240, 2, "Night Camo Helmet(Straps)", 0.1470, 0.0260, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{19106, 220, 2, "Army Helmet", 0.1470, 0.0260, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{19107, 220, 2, "Navy Helmet", 0.1470, 0.0260, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{19108, 220, 2, "Desert Helmet", 0.1470, 0.0260, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{19109, 220, 2, "Day Camo Helmet", 0.1470, 0.0260, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{19110, 220, 2, "Night Camo Helmet", 0.1470, 0.0260, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{19111, 220, 2, "Sand Camo Helmet", 0.1470, 0.0260, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{19112, 220, 2, "Pink Camo Helmet", 0.1470, 0.0260, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18911, 150, 2, "Skull Bandana", 0.0785, 0.0348, -0.0007, 268.9704, 1.5333, 269.2237, 1.0, 1.0, 1.0},
    {18912, 150, 2, "Black Bandana", 0.0785, 0.0348, -0.0007, 268.9704, 1.5333, 269.2237, 1.0, 1.0, 1.0},
    {18913, 150, 2, "Green Bandana", 0.0785, 0.0348, -0.0007, 268.9704, 1.5333, 269.2237, 1.0, 1.0, 1.0},
    {18914, 150, 2, "Camo Bandana", 0.0785, 0.0348, -0.0007, 268.9704, 1.5333, 269.2237, 1.0, 1.0, 1.0},
    {18915, 150, 2, "Funky Bandana", 0.0785, 0.0348, -0.0007, 268.9704, 1.5333, 269.2237, 1.0, 1.0, 1.0},
    {18916, 150, 2, "Triangle Bandana", 0.0785, 0.0348, -0.0007, 268.9704, 1.5333, 269.2237, 1.0, 1.0, 1.0},
    {18917, 150, 2, "Dark Blue Bandana", 0.0785, 0.0348, -0.0007, 268.9704, 1.5333, 269.2237, 1.0, 1.0, 1.0},
    {18918, 150, 2, "Black & White Bandana", 0.0785, 0.0348, -0.0007, 268.9704, 1.5333, 269.2237, 1.0, 1.0, 1.0},
    {18919, 150, 2, "Dots Bandana", 0.0785, 0.0348, -0.0007, 268.9704, 1.5333, 269.2237, 1.0, 1.0, 1.0},
    {18920, 150, 2, "Triangle & Dots Bandana", 0.0785, 0.0348, -0.0007, 268.9704, 1.5333, 269.2237, 1.0, 1.0, 1.0},
    {19469, 150, 1, "Scarf", 0.3000, 0.0550, -0.0369, -5.8999, 0.0000, 26.2000, 1.0000, 1.5519, 1.3889},
	{18944, 210, 2, "Lava Hat Boater", 0.1330, 0.0180, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18945, 210, 2, "Grey Hat Boater", 0.1330, 0.0180, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18946, 210, 2, "Casual Hat Boater", 0.1330, 0.0180, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18947, 230, 2, "Black Hat Bowler", 0.1390, 0.0180, -0.0010, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
    {18948, 230, 2, "Blue Hat Bowler", 0.1390, 0.0180, -0.0010, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
    {18949, 230, 2, "Green Hat Bowler", 0.1390, 0.0180, -0.0010, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
    {18950, 230, 2, "Red Hat Bowler", 0.1390, 0.0180, -0.0010, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
    {18951, 230, 2, "Yellow Hat Bowler", 0.1390, 0.0180, -0.0010, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18953, 200, 2, "Black Cap Knit", 0.1110, 0.0340, -0.0010, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18954, 200, 2, "Grey Cap Knit", 0.1110, 0.0340, -0.0010, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{18955, 205, 2, "Lava Cap Eye", 0.1030, 0.0440, 0.0009, -95.6000, 92.2001, -161.9002, 1.0, 1.0, 1.0},
	{18956, 205, 2, "Dark Flame Cap Eye", 0.1030, 0.0440, 0.0009, -95.6000, 92.2001, -161.9002, 1.0, 1.0, 1.0},
	{18957, 205, 2, "Blue Cap Eye", 0.1030, 0.0440, 0.0009, -95.6000, 92.2001, -161.9002, 1.0, 1.0, 1.0},
	{18958, 205, 2, "Cheetah Cap Eye", 0.1030, 0.0440, 0.0009, -95.6000, 92.2001, -161.9002, 1.0, 1.0, 1.0},
	{18959, 205, 2, "Camo Cap Eye", 0.1030, 0.0440, 0.0009, -95.6000, 92.2001, -161.9002, 1.0, 1.0, 1.0},
	{18964, 180, 2, "Black Skully Cap", 0.1210, 0.0310, 0.0000, 95.3000, 107.1999, 0.0000, 1.0, 1.0, 1.0},
	{18965, 180, 2, "Skully Cap", 0.1210, 0.0310, 0.0000, 95.3000, 107.1999, 0.0000, 1.0, 1.0, 1.0},
	{18966, 180, 2, "Funky Skully Cap", 0.1210, 0.0310, 0.0000, 95.3000, 107.1999, 0.0000, 1.0, 1.0, 1.0},
	{18967, 180, 2, "Black Chav Hat", 0.1030, 0.0260, 0.0000, 95.7000, 87.3999, -0.3999, 1.0, 1.0, 1.0},
	{18968, 180, 2, "Chav Hat", 0.1030, 0.0260, 0.0000, 95.7000, 87.3999, -0.3999, 1.0, 1.0, 1.0},
	{18969, 180, 2, "Lava Chav Hat", 0.1030, 0.0260, 0.0000, 95.7000, 87.3999, -0.3999, 1.0, 1.0, 1.0},
	{19006, 50, 2, "Red Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19007, 50, 2, "Orange Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19008, 50, 2, "Green Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19009, 50, 2, "Blue Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19010, 50, 2, "Pink Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19011, 50, 2, "Black & White Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19012, 50, 2, "Black Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19013, 50, 2, "Dot Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19014, 50, 2, "Square Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19015, 50, 2, "Lucent Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19016, 50, 2, "X-Ray Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19017, 50, 2, "Plain Yellow Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19018, 50, 2, "Plain Orange Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19019, 50, 2, "Plain Red Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19020, 50, 2, "Plain Blue Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19021, 50, 2, "Plain Green Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19022, 50, 2, "Lucent Aviators", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19023, 50, 2, "Blue Aviators", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19024, 50, 2, "Purple Aviators", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19025, 50, 2, "Pink Aviators", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19026, 50, 2, "Red Aviators", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19027, 50, 2, "Orange Aviators", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19028, 50, 2, "Yellow Aviators", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19029, 50, 2, "Green Aviators", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19030, 50, 2, "Thick Lucent", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19031, 50, 2, "Thick Yellow", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19032, 50, 2, "Thick Red", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19033, 50, 2, "Plain Black Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
    {19024, 50, 2, "Squares Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
    {19025, 50, 2, "Dark Blue Glasses", 0.0879, 0.0460, 0.0000, 91.0999, 85.3999, 0.0000, 1.0, 1.0, 1.0},
	{19349, 50, 2, "Monocle", 0.0769, 0.1050, 0.0340, 120.9999, 2.6999, -96.3998, 1.0, 1.0, 1.0},
	{18891, 150, 2, "Blue Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
	{18892, 150, 2, "Red Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
	{18893, 150, 2, "White & Red  Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
	{18894, 150, 2, "Bob Marley Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
	{18895, 150, 2, "Skulls Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
	{18896, 150, 2, "Black & White Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
	{18897, 150, 2, "Blue & White Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
	{18898, 150, 2, "Green & White Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
	{18899, 150, 2, "Purple & White Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
	{18900, 150, 2, "Psychedelic Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
	{18901, 150, 2, "Fall Camo Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
	{18902, 150, 2, "Yellow Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
	{18903, 150, 2, "Light Blue Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
	{18904, 150, 2, "Dark Blue Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
    {18905, 150, 2, "Hay Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
    {18906, 150, 2, "Red & Yellow Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
	{18907, 150, 2, "Psychedelic Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
	{18908, 150, 2, "Waves Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
	{18909, 150, 2, "Sky Blue Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
	{18910, 150, 2, "Lava Bandana", 0.1149, 0.0160, -0.0029, -88.2001, 8.3999, -95.0999, 1.0, 1.0, 1.0},
	{18962, 200, 2, "Black Cowboy Hat", 0.1630, 0.0270, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{19095, 200, 2, "Light Brown Cowboy Hat", 0.1630, 0.0270, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{19096, 200, 2, "Dark Blue Cowboy Hat", 0.1630, 0.0270, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
	{19097, 200, 2, "Red Cowboy Hat", 0.1630, 0.0270, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
    {19098, 200, 2, "Brown Cowboy Hat", 0.1630, 0.0270, 0.0000, 0.0000, 0.0000, 0.0000, 1.0, 1.0, 1.0},
    {19352, 220, 2, "Top Hat", 0.1039, 0.0210, 0.0060, 93.7000, 74.3000, 0.0000, 1.0, 1.0, 1.0}
};

new const cl_SpecialData[][e_cldata] = { // 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0
	{19348, 150, 2, "ไม้เท้า", 0.059999, 0.023999, 0.005, 93.6, 75.3, 0.0, 1.0, 1.0, 1.0},
	{19590, 150, 2, "มีดดาบ", 0.084999, 0.043999, -0.002, 82.1, 88.2999, 8.5, 1.0, 1.0, 1.0},
	{19350, 90, 2, "หนวดทรงสั้น", 0.052999, 0.016999, 0.006999, 0.0, 91.1, 75.7, 1.0, 1.0, 1.0},
	{19351, 90, 2, "หนวดทรงยาว", 0.052999, 0.032, -0.007, 74.9, 86.5, -4.60001, 1.0, 1.0, 1.0},
	{18975, 150, 2, "ทรงผม 1", 0.051999, 0.028, 0.0, 93.3, 74.8, -9.6, 1.0, 1.0, 1.0},
	{19077, 150, 2, "ทรงผม 2", 0.088996, 0.043997, -0.002998, 101.3, 92.2001, -16.5, 1.0, 1.0, 1.0},
	{19274, 150, 2, "ทรงผม 3", 0.088996, 0.043997, -0.002998, 101.3, 92.2001, -16.5, 1.0, 1.0, 1.0},
	{19625, 100, 2, "บุหรี่ 1", 0.088996, 0.043997, -0.002998, 101.3, 92.2001, -16.5, 1.0, 1.0, 1.0},
	{1485, 100, 1, "บุหรี่ 2", -0.147999, -0.061999, 0.006999, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0},
	{19077, 100, 1, "ทรงผม 4", -0.147999, -0.061999, 0.006999, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0},
	{19078, 100, 1, "นกแก้ว", -0.147999, -0.061999, 0.006999, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}
};

new ClothingData[MAX_PLAYERS][MAX_CLOTHES][e_cloths];

new cl_selected[MAX_PLAYERS];
new cl_dataslot[MAX_PLAYERS][MAX_CLOTHES];

new cl_buying[MAX_PLAYERS];
new cl_buyingpslot[MAX_PLAYERS];

cl_DressPlayer(playerid)
{
	for (new id = 0; id < MAX_CLOTHES; id ++)
	{
		if(ClothingData[playerid][id][cl_object] != INVALID_OBJECT_ID && ClothingData[playerid][id][cl_equip]) {
			SetPlayerAttachedObject(playerid, ClothingData[playerid][id][cl_slot], ClothingData[playerid][id][cl_object], ClothingData[playerid][id][cl_bone], ClothingData[playerid][id][cl_x], ClothingData[playerid][id][cl_y],
			ClothingData[playerid][id][cl_z], ClothingData[playerid][id][cl_rx], ClothingData[playerid][id][cl_ry], ClothingData[playerid][id][cl_rz], ClothingData[playerid][id][cl_scalex], ClothingData[playerid][id][cl_scaley], ClothingData[playerid][id][cl_scalez], ClothingData[playerid][id][cl_mc1], ClothingData[playerid][id][cl_mc2]);
		}
	}
}

cl_ResetDressPlayer(playerid)
{
	for (new i = 0; i != MAX_PLAYER_ATTACHED_OBJECTS; i ++)
		RemovePlayerAttachedObject(playerid, i);

	for (new id = 0; id < MAX_CLOTHES; id ++)
	{
		if(ClothingData[playerid][id][cl_object] != INVALID_OBJECT_ID && ClothingData[playerid][id][cl_equip]) {
			ClothingData[playerid][id][cl_equip] = 0;
		}
	}
}

cl_ShowClothingMenu(playerid)
{
	new cl_str[675], count;
	for (new i = 0; i < MAX_CLOTHES; i ++)
	{
	    if(ClothingData[playerid][i][cl_object] != INVALID_OBJECT_ID)
	    {
		    cl_dataslot[playerid][count] = i;
			format(cl_str, sizeof(cl_str), "%s"EMBED_YELLOW"%d. "EMBED_WHITE"%s (Index: %d)\n", cl_str, i + 1, ClothingData[playerid][i][cl_name], ClothingData[playerid][i][cl_slot] + 1);
			count++;
		}
	}
	if(count) Dialog_Show(playerid, ClothingList, DIALOG_STYLE_LIST, "อะไรคือสิ่งที่คุณต้องการแก้ไข ?", cl_str, "เลือก", "<< กลับ");
}

hook OnGameModeInit() {
	CreateDynamic3DTextLabel("/buyitem\nเพื่อดูรายชื่อไอเท็มกีฬาที่มีอยู่", COLOR_WHITE, 1117.0027,-1522.3009,15.7969, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	CreateDynamic3DTextLabel(""EMBED_YELLOW"ร้านเครื่องแต่งกายของ srysgag"EMBED_WHITE"\n/buyitem เพื่อดูรายชื่อเครื่องแต่งกายที่มีขาย", COLOR_WHITE, 1103.0394,-1440.1451,15.7969, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	CreateDynamic3DTextLabel("/buyitem\nเพื่อดูรายชื่อเครื่องมือ", COLOR_WHITE, 1154.3328,-1458.1566,15.7969, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	CreateDynamic3DTextLabel("/buyitem\nเพื่อดูรายชื่อไอเท็มดนตรี", COLOR_WHITE, 1099.9929,-1506.8816,15.7969, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	CreateDynamic3DTextLabel("/buyitem\nเพื่อดูรายชื่อนาฬิกา", COLOR_WHITE, -1440.1041,15.7969,268.3609, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	CreateDynamic3DTextLabel("/buyitem\nเพื่อดูเครื่องแต่งกายพิเศษ", COLOR_WHITE, 1156.7029,-1506.5414,15.8050, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);
	CreateDynamic3DTextLabel("/buyitem\nเพื่อดูเครื่องแต่งกายสำหรับตำรวจ", COLOR_WHITE, 1097.6575,-1521.2761,22.7439, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);

}

hook OnPlayerSpawn(playerid) {
    cl_DressPlayer(playerid);
    return 1;
}

hook OnPlayerConnect(playerid) {
    for(new i=0;i!=MAX_CLOTHES; ++i) cl_dataslot[playerid][i] = -1, ClothingData[playerid][i][cl_object] = INVALID_OBJECT_ID;
    return 1;
}

SaveClothing(playerid) {

    new query[256];
    for (new id = 0; id < MAX_CLOTHES; id ++)
	{
	    if(ClothingData[playerid][id][cl_object] != INVALID_OBJECT_ID)
	    {
		 	mysql_format(dbCon, query,sizeof(query),"UPDATE clothing SET object = '%d', bone = '%d', slot = '%d', equip = '%d', name = '%e', materialColor1 = %d, materialColor2 = %d WHERE id = '%d' AND owner = '%d' LIMIT 1",
		    ClothingData[playerid][id][cl_object],
		    ClothingData[playerid][id][cl_bone],
		    ClothingData[playerid][id][cl_slot],
			ClothingData[playerid][id][cl_equip],
			ClothingData[playerid][id][cl_name],
			ClothingData[playerid][id][cl_mc1],
			ClothingData[playerid][id][cl_mc2],
			ClothingData[playerid][id][cl_sid],
			playerData[playerid][pSID]);
			mysql_query(dbCon, query);
		}
	}
    return 1;
}

CMD:clothinghelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN,"_______________________________________");

	SendClientMessage(playerid, COLOR_WHITE,"*** HELP *** พิมพ์คำสั่งสำหรับความช่วยเหลือเพิ่มเติม");
	SendClientMessage(playerid, COLOR_GRAD3,"*** CLOTHING *** /clothing [ชื่อ]");
	SendClientMessage(playerid, COLOR_GRAD4, "ชื่อที่ใช้ได้: (p)lace, (d)rop, (a)djust, (g)ive");
	return 1;
}

CMD:buyitem(playerid, params[])
{

	if(isPlayerAndroid(playerid) != 0)
	{
		return SendClientMessage(playerid, COLOR_YELLOW, "คำสั่งนี้เฉพาะผู้เล่นบน PC เท่านั้น");
	}

	new
	    itemid;

    if(IsPlayerInRangeOfPoint(playerid, 5.0, 1117.0027,-1522.3009,15.7969)) cl_buying[playerid]=BUYSPORTS;
    else if(IsPlayerInRangeOfPoint(playerid, 5.0, 1103.0394,-1440.1451,15.7969)) cl_buying[playerid]=BUYZIP;
	else if(IsPlayerInRangeOfPoint(playerid, 5.0, 1154.3328,-1458.1566,15.7969)) cl_buying[playerid]=BUYHARDWARE;
	else if(IsPlayerInRangeOfPoint(playerid, 5.0, -1440.1041,15.7969,268.3609)) cl_buying[playerid]=BUYWATCH;
	else if(IsPlayerInRangeOfPoint(playerid, 5.0, 1099.9929,-1506.8816,15.7969)) cl_buying[playerid]=BUYMUSIC;
	else if(IsPlayerInRangeOfPoint(playerid, 5.0, 1156.7029,-1506.5414,15.8050)) cl_buying[playerid]=BUYSPECIAL;
	else if(IsPlayerInRangeOfPoint(playerid, 5.0, 1097.6575,-1521.2761,22.7439)) cl_buying[playerid]=BUYPOLICE;

	if (sscanf(params, "d", itemid))
 	{
		new str[3600];
		switch(cl_buying[playerid])
		{
		    case BUYSPORTS:
		    {
				for(new i=0;i!=sizeof(cl_SportsData);++i) format(str, 3600, "%s %d.%s\t{48E348}%d Score"EMBED_WHITE"\n", str, i, cl_SportsData[i][e_name], cl_SportsData[i][e_price]);
		        Dialog_Show(playerid, buyClothing, DIALOG_STYLE_TABLIST, "/buyitem ItemID", str, "Ok", "Cancel");
		    }
		    case BUYHARDWARE:
		    {
				for(new i=0;i!=sizeof(cl_HardwareData);++i) format(str, 3600, "%s %d.%s\t{48E348}%d Score"EMBED_WHITE"\n", str, i, cl_HardwareData[i][e_name], cl_HardwareData[i][e_price]);
		        Dialog_Show(playerid, buyClothing, DIALOG_STYLE_TABLIST, "/buyitem ItemID", str, "Ok", "Cancel");
		    }
		    case BUYMUSIC:
		    {
				for(new i=0;i!=sizeof(cl_MusicalData);++i) format(str, 3600, "%s %d.%s\t{48E348}%d Score"EMBED_WHITE"\n", str, i, cl_MusicalData[i][e_name], cl_MusicalData[i][e_price]);
		        Dialog_Show(playerid, buyClothing, DIALOG_STYLE_TABLIST, "/buyitem ItemID", str, "Ok", "Cancel");
		    }
		    case BUYWATCH:
		    {
				for(new i=0;i!=sizeof(cl_DsShopData);++i) format(str, 3600, "%s %d.%s\t{48E348}%d Score"EMBED_WHITE"\n", str, i, cl_DsShopData[i][e_name], cl_DsShopData[i][e_price]);
		        Dialog_Show(playerid, buyClothing, DIALOG_STYLE_TABLIST, "/buyitem ItemID", str, "Ok", "Cancel");
		    }
		    case BUYPOLICE:
		    {
				for(new i=0;i!=sizeof(cl_PoliceData);++i) format(str, 3600, "%s %d.%s\t{48E348}%d Score"EMBED_WHITE"\n", str, i, cl_PoliceData[i][e_name], cl_PoliceData[i][e_price]);
		        Dialog_Show(playerid, buyClothing, DIALOG_STYLE_TABLIST, "/buyitem ItemID", str, "Ok", "Cancel");
		    }
		    case BUYMEDIC:
		    {
				for(new i=0;i!=sizeof(cl_MedicData);++i) format(str, 3600, "%s %d.%s\t{48E348}%d Score"EMBED_WHITE"\n", str, i, cl_MedicData[i][e_name], cl_MedicData[i][e_price]);
		        Dialog_Show(playerid, buyClothing, DIALOG_STYLE_TABLIST, "/buyitem ItemID", str, "Ok", "Cancel");
		    }
		    case BUYZIP:
		    {
				// 3597

				for(new i=0;i!=sizeof(cl_ZipData);++i)
				{
				    if(i == 91)
				    {
				        format(str, 3600, "%s"EMBED_YELLOW"หน้าถัดไป!"EMBED_WHITE"", str);
						break;
				    }
				    format(str, 3600, "%s %d.%s\t{48E348}%d Score"EMBED_WHITE"\n", str, i, cl_ZipData[i][e_name], cl_ZipData[i][e_price]);
				}
		        Dialog_Show(playerid, buyClothing, DIALOG_STYLE_TABLIST, "/buyitem ItemID", str, "Ok", "Cancel");
		    }
		    case BUYSPECIAL:
		    {
				// 3597

				for(new i=0;i!=sizeof(cl_SpecialData);++i)
				{
				    if(i == 91)
				    {
				        format(str, 3600, "%s"EMBED_YELLOW"หน้าถัดไป!"EMBED_WHITE"", str);
						break;
				    }
				    format(str, 3600, "%s %d.%s\t{48E348}%d Point"EMBED_WHITE"\n", str, i, cl_SpecialData[i][e_name], cl_SpecialData[i][e_price]);
				}
		        Dialog_Show(playerid, buyClothing, DIALOG_STYLE_TABLIST, "/buyitem ItemID", str, "Ok", "Cancel");
		    }
		}
		return 1;
	}

	if((cl_buyingpslot[playerid] = ClothingExistSlot(playerid)) != -1) {
		switch(PurchaseClothing(playerid, itemid)) {
			case -2: {
				SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถซื้อได้มากกว่านี้แล้ว");
			}
			case -1: {
				SendClientMessage(playerid, COLOR_LIGHTRED, "ขออภัยคุณมี Score ไม่พอที่จะซื้อ !!");
			}
			case 0: {
				SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่สามารถซื้อไอเท็มเครื่องแต่งกายไอดีนี้ได้");
			}
		}
	}
	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถซื้อได้มากกว่านี้แล้ว");
	}

	return 1;
}

/*CMD:buyclothing(playerid, params[])
{

	if(isPlayerAndroid(playerid) != 0)
	{
		return SendClientMessage(playerid, COLOR_YELLOW, "คำสั่งนี้เฉพาะผู้เล่นบน PC เท่านั้น");
	}

	for(new i=0;i!=sizeof(cl_SpecialData);++i) format(str, 3600, "%s %d.%s\t{48E348}%d Point"EMBED_WHITE"\n", str, i, cl_SportsData[i][e_name], cl_SportsData[i][e_price]);
	Dialog_Show(playerid, buyClothing, DIALOG_STYLE_TABLIST, "/buyitem ItemID", str, "Ok", "Cancel");

	return 1;

	if((cl_buyingpslot[playerid] = ClothingExistSlot(playerid)) != -1) {
		switch(PurchaseClothing(playerid, itemid)) {
			case -2: {
				SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถซื้อได้มากกว่านี้แล้ว");
			}
			case -1: {
				SendClientMessage(playerid, COLOR_LIGHTRED, "ขออภัยคุณมี Score ไม่พอที่จะซื้อ !!");
			}
			case 0: {
				SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่สามารถซื้อไอเท็มเครื่องแต่งกายไอดีนี้ได้");
			}
		}
	}
	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถซื้อได้มากกว่านี้แล้ว");
	}

	return 1;
}*/

CMD:clothing(playerid,params[])
{
	new
	    name[16],
	    userid,
	    clothingid;

	if (sscanf(params, "s[16]D(-1)U(65535)", name, clothingid, userid))
 	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: "EMBED_WHITE"/clothing place | adjust | drop | give");
		cl_ShowClothingMenu(playerid);
		return 1;
	}
	if(!HasCooldown(playerid,COOLDOWN_CLOTHES))
	{
        clothingid = clothingid-1;

		if (!strcmp(name, "place", true) || !strcmp(name, "p", true))
		{
		    if (clothingid < 0)
			{
				for (new id = 0; id < MAX_CLOTHES; id ++)
				{
				    if(ClothingData[playerid][id][cl_object] != INVALID_OBJECT_ID) {
				        SendClientMessageEx(playerid, COLOR_GRAD1, "%d: %s", id+1, ClothingData[playerid][id][cl_name]);
	            	}
	            }
				SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: "EMBED_WHITE"/clothing place [ไอดีเครื่องแต่งกาย]");
			    return 1;
			}

			if(clothingid < MAX_CLOTHES && ClothingData[playerid][clothingid][cl_object] != INVALID_OBJECT_ID) {
			if(ClothingData[playerid][clothingid][cl_equip]) {

				RemovePlayerAttachedObject(playerid, ClothingData[playerid][clothingid][cl_slot]);
				ClothingData[playerid][clothingid][cl_equip] = 0;
			}
			else
			{
	   			SetPlayerAttachedObject(playerid, ClothingData[playerid][clothingid][cl_slot], ClothingData[playerid][clothingid][cl_object], ClothingData[playerid][clothingid][cl_bone], ClothingData[playerid][clothingid][cl_x], ClothingData[playerid][clothingid][cl_y],
				ClothingData[playerid][clothingid][cl_z], ClothingData[playerid][clothingid][cl_rx], ClothingData[playerid][clothingid][cl_ry], ClothingData[playerid][clothingid][cl_rz], ClothingData[playerid][clothingid][cl_scalex], ClothingData[playerid][clothingid][cl_scaley], 
				ClothingData[playerid][clothingid][cl_scalez], ClothingData[playerid][clothingid][cl_mc1], ClothingData[playerid][clothingid][cl_mc2]);
				SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้สวมใส่ "EMBED_YELLOW"%s", ClothingData[playerid][clothingid][cl_name]);

				for (new i = 0; i < MAX_CLOTHES; i ++)
				{
					if(ClothingData[playerid][i][cl_object] != INVALID_OBJECT_ID && ClothingData[playerid][i][cl_equip] && ClothingData[playerid][i][cl_slot] == ClothingData[playerid][clothingid][cl_slot])
					{
						ClothingData[playerid][i][cl_equip] = 0;
					}
				}
				ClothingData[playerid][clothingid][cl_equip] = 1;
			}
			}
            else SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่มีอะไรอยู่ที่นั้น..");
		}
		else if (!strcmp(name, "drop", true) || !strcmp(name, "d", true))
		{
      		if (clothingid < 0)
			{
				for (new id = 0; id < MAX_CLOTHES; id ++)
				{
				    if(ClothingData[playerid][id][cl_object] != INVALID_OBJECT_ID) {
				        SendClientMessageEx(playerid, COLOR_GRAD1, "%d: %s", id+1, ClothingData[playerid][id][cl_name]);
	            	}
	            }
				SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: "EMBED_WHITE"/clothing drop [ไอดีเครื่องแต่งกาย]");
			    return 1;
			}

			if(clothingid < MAX_CLOTHES && ClothingData[playerid][clothingid][cl_object] != INVALID_OBJECT_ID) {

				if(IsPlayerAttachedObjectSlotUsed(playerid, ClothingData[playerid][clothingid][cl_slot])) RemovePlayerAttachedObject(playerid, ClothingData[playerid][clothingid][cl_slot]);
                ClothingData[playerid][clothingid][cl_object] = INVALID_OBJECT_ID;

				new
		    		query[128];

				format(query,sizeof(query),"DELETE FROM `clothing` WHERE owner = '%d' and id = '%d'",playerData[playerid][pSID], ClothingData[playerid][clothingid][cl_sid]);
				mysql_query(dbCon, query);

				SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณได้ทิ้ง %s#%d", ClothingData[playerid][clothingid][cl_name], clothingid + 1);

				SetCooldown(playerid,COOLDOWN_CLOTHES,5);
			}
			else SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่มีอะไรอยู่ที่นั้น..");

		}
		else if (!strcmp(name, "adjust", true) || !strcmp(name, "a", true))
		{
      		if (clothingid < 0)
			{
				for (new id = 0; id < MAX_CLOTHES; id ++)
				{
				    if(ClothingData[playerid][id][cl_object] != INVALID_OBJECT_ID) {
				        SendClientMessageEx(playerid, COLOR_GRAD1, "%d: %s", id+1, ClothingData[playerid][id][cl_name]);
	            	}
	            }
				SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: "EMBED_WHITE"/clothing adjust [ไอดีเครื่องแต่งกาย]");
			    return 1;
			}

            if(clothingid < MAX_CLOTHES && ClothingData[playerid][clothingid][cl_object] != INVALID_OBJECT_ID) {
                cl_selected[playerid] = clothingid;
			    SetPlayerAttachedObject(playerid, ClothingData[playerid][clothingid][cl_slot], ClothingData[playerid][clothingid][cl_object], ClothingData[playerid][clothingid][cl_bone], ClothingData[playerid][clothingid][cl_x], ClothingData[playerid][clothingid][cl_y],
				ClothingData[playerid][clothingid][cl_z], ClothingData[playerid][clothingid][cl_rx], ClothingData[playerid][clothingid][cl_ry], ClothingData[playerid][clothingid][cl_rz], ClothingData[playerid][clothingid][cl_scalex], ClothingData[playerid][clothingid][cl_scaley], ClothingData[playerid][clothingid][cl_scalez], ClothingData[playerid][clothingid][cl_mc1], ClothingData[playerid][clothingid][cl_mc2]);

				ApplyAnimation(playerid, "CLOTHES", "CLO_Buy", 4.1, 0, 1,1, 1, 0, 1);
				EditAttachedObject(playerid, ClothingData[playerid][clothingid][cl_slot]);
				BitFlag_On(gPlayerBitFlag[playerid], IS_PLAYER_EDITCLOTHING);
			}
			else SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่มีอะไรอยู่ที่นั้น..");
		}
		else if (!strcmp(name, "give", true) || !strcmp(name, "g", true))
		{
      		if (clothingid < 0)
			{
				for (new id = 0; id < MAX_CLOTHES; id ++)
				{
				    if(ClothingData[playerid][id][cl_object] != INVALID_OBJECT_ID) {
				        SendClientMessageEx(playerid, COLOR_GRAD1, "%d: %s", id+1, ClothingData[playerid][id][cl_name]);
	            	}
	            }

				SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: "EMBED_WHITE"/clothing give [ไอดีเครื่องแต่งกาย] [ไอดีผู้เล่น/ชื่อบางส่วน]");
			    return 1;
			}


			if(userid == INVALID_PLAYER_ID) {
				return SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: "EMBED_WHITE"/clothing give [ไอดีเครื่องแต่งกาย] [ไอดีผู้เล่น/ชื่อบางส่วน]");
			}

			if (!IsPlayerNearPlayer(playerid, userid, 5.0))
                return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

			if(clothingid < MAX_CLOTHES && ClothingData[playerid][clothingid][cl_object] != INVALID_OBJECT_ID) {
			
				/*for(new i=0;i!=sizeof(cl_PoliceData);++i) {
					if(cl_PoliceData[i][e_model] == ClothingData[playerid][clothingid][cl_object]) {
						return SendClientMessage(playerid, COLOR_GRAD1, "   ไม่สามารถให้ออบเจ็คนี้กับผู้เล่นอื่นได้");
					}
				}
				for(new i=0;i!=sizeof(cl_MedicData);++i) {
					if(cl_MedicData[i][e_model] == ClothingData[playerid][clothingid][cl_object]) {
						return SendClientMessage(playerid, COLOR_GRAD1, "   ไม่สามารถให้ออบเจ็คนี้กับผู้เล่นอื่นได้");
					}
				}*/
				new clotingName[32];
				format(clotingName, 32, GetClotingItemName(ClothingData[playerid][clothingid][cl_object]));

				if(AddPlayerClothing(
				userid,
				ClothingData[playerid][clothingid][cl_object],
				ClothingData[playerid][clothingid][cl_x],
				ClothingData[playerid][clothingid][cl_y],
				ClothingData[playerid][clothingid][cl_z],
				ClothingData[playerid][clothingid][cl_rx],
				ClothingData[playerid][clothingid][cl_ry],
				ClothingData[playerid][clothingid][cl_rz],
				ClothingData[playerid][clothingid][cl_bone],
				ClothingData[playerid][clothingid][cl_slot],
				ClothingData[playerid][clothingid][cl_scalex],
				ClothingData[playerid][clothingid][cl_scaley],
				ClothingData[playerid][clothingid][cl_scalez],
				ClothingData[playerid][clothingid][cl_mc1],
				ClothingData[playerid][clothingid][cl_mc2],
				clotingName,
				ClothingData[playerid][clothingid][cl_sid]) != -1)
				{
				    new query[150];
					mysql_format(dbCon, query,sizeof(query),"UPDATE clothing SET owner = %d, name = '%e', equip = 0 WHERE owner = '%d' and id = '%d'", playerData[userid][pSID], clotingName, playerData[playerid][pSID], ClothingData[playerid][clothingid][cl_sid]);
					mysql_query(dbCon, query);

					if(IsPlayerAttachedObjectSlotUsed(playerid, ClothingData[playerid][clothingid][cl_slot])) RemovePlayerAttachedObject(playerid, ClothingData[playerid][clothingid][cl_slot]);

					SendClientMessageEx(userid, COLOR_GRAD1, "   คุณได้รับ %s#%d จาก %s", clotingName, clothingid + 1, ReturnRealName(playerid));
					SendClientMessageEx(playerid, COLOR_GRAD1, "   คุณได้ให้ %s#%d กับ %s", ClothingData[playerid][clothingid][cl_name], clothingid + 1, ReturnRealName(userid));

                    ClothingData[playerid][clothingid][cl_object] = INVALID_OBJECT_ID;
					SetCooldown(playerid,COOLDOWN_CLOTHES,5);
				}
				else return SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่สามารถให้สิ่งของได้");


                SetCooldown(playerid,COOLDOWN_CLOTHES,5);
            }
			else SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่มีอะไรอยู่ที่นั้น..");

		}
	}
	else SendClientMessageEx(playerid, COLOR_LIGHTRED, "กรุณารอ %d วินาทีก่อนที่จะพยายามใช้คำสั่ง /clothing อีกครั้ง",GetCooldownLevel(playerid,COOLDOWN_CLOTHES));

	return 1;
}

CountPlayerClothing(playerid)
{
	new count;
	for (new id = 0; id < MAX_CLOTHES; id ++) if(ClothingData[playerid][id][cl_object] != INVALID_OBJECT_ID) count++;
	return count;
}

AddPlayerClothing(playerid,modelid,Float:fOffsetX,Float:fOffsetY,Float:fOffsetZ,Float:fRotX,Float:fRotY,Float:fRotZ,boneid,index,Float:fScaleX,Float:fScaleY,Float:fScaleZ, fmc1, fmc2, const cNamex[], sid = -1)
{
	new num = CountPlayerClothing(playerid), bool:success, clothingid;
	switch(playerData[playerid][pDonateRank])
	{
		case 0: if(num >= 6) return -1;
		case 1: if(num >= 8) return -1;
		case 2: if(num >= 10) return -1;
		case 3: if(num >= 15) return -1;
	}

	for (new id = 0; id < MAX_CLOTHES; id ++)
	{
	    if(ClothingData[playerid][id][cl_object] == INVALID_OBJECT_ID)
	    {
			ClothingData[playerid][id][cl_sid] = sid;
			ClothingData[playerid][id][cl_object] = modelid;
			ClothingData[playerid][id][cl_x] = fOffsetX;
			ClothingData[playerid][id][cl_y] = fOffsetY;
			ClothingData[playerid][id][cl_z] = fOffsetZ;
			ClothingData[playerid][id][cl_rx] = fRotX;
			ClothingData[playerid][id][cl_ry] = fRotY;
			ClothingData[playerid][id][cl_rz] = fRotZ;
			ClothingData[playerid][id][cl_scalex] = fScaleX;
			ClothingData[playerid][id][cl_scaley] = fScaleY;
			ClothingData[playerid][id][cl_scalez] = fScaleZ;
			ClothingData[playerid][id][cl_mc1] = fmc1;
			ClothingData[playerid][id][cl_mc2] = fmc2;
	    	ClothingData[playerid][id][cl_bone] = boneid;
			ClothingData[playerid][id][cl_slot] = index;
			ClothingData[playerid][id][cl_equip] = 0;
			format(ClothingData[playerid][id][cl_name], 32, cNamex);
			clothingid = id;
	        success = true;
	        break;
	    }
	}
	if(success)
	{
	    return clothingid;
	}
	return -1;
}

hook OP_EditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	if(BitFlag_Get(gPlayerBitFlag[playerid], IS_PLAYER_EDITCLOTHING))
	{
		if(response)
		{
		    new str[1024];

		    format(str,sizeof(str),"UPDATE clothing SET x = '%f', y = '%f', z = '%f', rx = '%f', ry = '%f', rz = '%f', scalex = '%f', scaley = '%f', scalez = '%f' WHERE id = '%d' AND owner = '%d' LIMIT 1",
		    fOffsetX,
		    fOffsetY,
		    fOffsetZ,
			fRotX,
			fRotY,
			fRotZ,
			fScaleX,
			fScaleY,
			fScaleZ,
			ClothingData[playerid][cl_selected[playerid]][cl_sid],
			playerData[playerid][pSID]);
			mysql_query(dbCon, str);

			ClothingData[playerid][cl_selected[playerid]][cl_x] = fOffsetX;
			ClothingData[playerid][cl_selected[playerid]][cl_y] = fOffsetY;
			ClothingData[playerid][cl_selected[playerid]][cl_z] = fOffsetZ;
			ClothingData[playerid][cl_selected[playerid]][cl_rx] = fRotX;
			ClothingData[playerid][cl_selected[playerid]][cl_ry] = fRotY;
			ClothingData[playerid][cl_selected[playerid]][cl_rz] = fRotZ;
			ClothingData[playerid][cl_selected[playerid]][cl_scalex] = fScaleX;
			ClothingData[playerid][cl_selected[playerid]][cl_scaley] = fScaleY;
			ClothingData[playerid][cl_selected[playerid]][cl_scalez] = fScaleZ;

		}
		ClearAnimations(playerid);

		RemovePlayerClothing(playerid);

		ShowPlayerFooter(playerid, "~g~UPDATED YOUR ITEM!~n~~w~Use ~y~/clothing ~w~to put it back on.", 10000);

		BitFlag_Off(gPlayerBitFlag[playerid], IS_PLAYER_EDITCLOTHING);
	}
	

	if(BitFlag_Get(gPlayerBitFlag[playerid], IS_PLAYER_BUYCLOTHING))
	{
		if(response)
		{//cl_SportsData[cl_buyingslot[playerid]][e_model]
		    new str[1024], money, name[32];

			switch(cl_buying[playerid])
			{
			    case BUYSPORTS: for(new i=0;i!=sizeof(cl_SportsData);++i) if(cl_SportsData[i][e_model] == modelid) format(name, 32, cl_SportsData[i][e_name]), money = cl_SportsData[i][e_price];
				case BUYHARDWARE: for(new i=0;i!=sizeof(cl_HardwareData);++i) if(cl_HardwareData[i][e_model] == modelid) format(name, 32, cl_HardwareData[i][e_name]), money = cl_HardwareData[i][e_price];
				case BUYWATCH: for(new i=0;i!=sizeof(cl_DsShopData);++i) if(cl_DsShopData[i][e_model] == modelid) format(name, 32, cl_DsShopData[i][e_name]), money = cl_DsShopData[i][e_price];
                case BUYZIP: for(new i=0;i!=sizeof(cl_ZipData);++i) if(cl_ZipData[i][e_model] == modelid) format(name, 32, cl_ZipData[i][e_name]), money = cl_ZipData[i][e_price];
				case BUYMUSIC: for(new i=0;i!=sizeof(cl_MusicalData);++i) if(cl_MusicalData[i][e_model] == modelid) format(name, 32, cl_MusicalData[i][e_name]), money = cl_MusicalData[i][e_price];
				case BUYPOLICE: for(new i=0;i!=sizeof(cl_PoliceData);++i) if(cl_PoliceData[i][e_model] == modelid) format(name, 32, cl_PoliceData[i][e_name]), money = cl_PoliceData[i][e_price];
				case BUYMEDIC: for(new i=0;i!=sizeof(cl_MedicData);++i) if(cl_MedicData[i][e_model] == modelid) format(name, 32, cl_MedicData[i][e_name]), money = cl_MedicData[i][e_price];
                case BUYSPECIAL: for(new i=0;i!=sizeof(cl_SpecialData);++i) if(cl_SpecialData[i][e_model] == modelid) format(name, 32, cl_SpecialData[i][e_name]), money = cl_SpecialData[i][e_price];
				
			}

			if(!strcmp(name, "Holster", true)) 
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องมีใบอนุญาตในการพกอาวุธเพื่อจะซื้อไอเท็มชิ้นนี้");
				RemovePlayerClothing(playerid);
				cl_ResetDressPlayer(playerid);

				cl_buying[playerid]=0; cl_buyingpslot[playerid]=-1;
				ClearAnimations(playerid);
				BitFlag_Off(gPlayerBitFlag[playerid], IS_PLAYER_BUYCLOTHING);
				return 1;
			}

			if (cl_buying[playerid] != BUYSPECIAL)
			{
				if (playerData[playerid][pScore] >= money)
				{
					new id = -1;
					if((id = AddPlayerClothing(playerid,modelid,fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,boneid,index,fScaleX,fScaleY,fScaleZ,0,0,name)) != -1)
					{
						format(str,sizeof(str),"INSERT INTO `clothing` (`object`, `x`, `y`, `z`, `rx`, `ry`, `rz`, `bone`, `slot`, `owner`, `equip`, `scalex`, `scaley`, `scalez`, `name`) VALUES ('%d', '%f', '%f', '%f', '%f', '%f', '%f', '%d', '%d', '%d', '0', '%f', '%f', '%f', '%s')",
						modelid,
						fOffsetX,
						fOffsetY,
						fOffsetZ,
						fRotX,
						fRotY,
						fRotZ,
						boneid,
						index,
						playerData[playerid][pSID],
						fScaleX,
						fScaleY,
						fScaleZ,
						name);
						mysql_tquery(dbCon, str, "OnQueryBuyClothing", "dd", playerid, id);
		
						playerData[playerid][pScore] -= money;
						SendClientMessage(playerid, COLOR_WHITE, "ใช้ "EMBED_YELLOW"/clothing"EMBED_WHITE" เพื่อแก้ไขไอเท็มเครื่องแต่งกายของคุณ");
						ShowPlayerFooter(playerid, "~g~Enjoy your purchase!~n~~w~Use ~y~/clothing ~w~to edit your clothing items.", 10000);
					}
					else {
						SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถซื้อได้มากกว่านี้แล้ว");
					}
				}
				else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถจ่ายมันได้ขออถัยด้วย");
			}

			if (cl_buying[playerid] == BUYSPECIAL)
			{
				if (playerData[playerid][pPoint] >= money)
				{
					new id = -1;
					if((id = AddPlayerClothing(playerid,modelid,fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,boneid,index,fScaleX,fScaleY,fScaleZ,0,0,name)) != -1)
					{
						format(str,sizeof(str),"INSERT INTO `clothing` (`object`, `x`, `y`, `z`, `rx`, `ry`, `rz`, `bone`, `slot`, `owner`, `equip`, `scalex`, `scaley`, `scalez`, `name`) VALUES ('%d', '%f', '%f', '%f', '%f', '%f', '%f', '%d', '%d', '%d', '0', '%f', '%f', '%f', '%s')",
						modelid,
						fOffsetX,
						fOffsetY,
						fOffsetZ,
						fRotX,
						fRotY,
						fRotZ,
						boneid,
						index,
						playerData[playerid][pSID],
						fScaleX,
						fScaleY,
						fScaleZ,
						name);
						mysql_tquery(dbCon, str, "OnQueryBuyClothing", "dd", playerid, id);
		
						playerData[playerid][pPoint] -= money;
						SendClientMessage(playerid, COLOR_WHITE, "ใช้ "EMBED_YELLOW"/clothing"EMBED_WHITE" เพื่อแก้ไขไอเท็มเครื่องแต่งกายของคุณ");
						ShowPlayerFooter(playerid, "~g~Enjoy your purchase!~n~~w~Use ~y~/clothing ~w~to edit your clothing items.", 10000);
					}
					else {
						SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถซื้อได้มากกว่านี้แล้ว");
					}
				}
				else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถจ่ายมันได้ขออถัยด้วย");
			}
		}
		RemovePlayerClothing(playerid);
        cl_ResetDressPlayer(playerid);

		cl_buying[playerid]=0; cl_buyingpslot[playerid]=-1;
		ClearAnimations(playerid);
	    BitFlag_Off(gPlayerBitFlag[playerid], IS_PLAYER_BUYCLOTHING);
	}
	return 1;

}

GetClotingItemName(modelid) {
	new clotingName[32];
	for(new i=0;i!=sizeof(cl_SportsData);++i) if(cl_SportsData[i][e_model] == modelid) {
		format(clotingName, 32, cl_SportsData[i][e_name]);
		return clotingName;
	}
	for(new i=0;i!=sizeof(cl_HardwareData);++i) if(cl_HardwareData[i][e_model] == modelid) {
		format(clotingName, 32, cl_HardwareData[i][e_name]);
		return clotingName;
	}
	for(new i=0;i!=sizeof(cl_DsShopData);++i) if(cl_DsShopData[i][e_model] == modelid) {
		format(clotingName, 32, cl_DsShopData[i][e_name]);
		return clotingName;
	}
	for(new i=0;i!=sizeof(cl_ZipData);++i) if(cl_ZipData[i][e_model] == modelid) {
		format(clotingName, 32, cl_ZipData[i][e_name]);
		return clotingName;
	}
	for(new i=0;i!=sizeof(cl_SpecialData);++i) if(cl_SpecialData[i][e_model] == modelid) {
		format(clotingName, 32, cl_SpecialData[i][e_name]);
		return clotingName;
	}
	for(new i=0;i!=sizeof(cl_MusicalData);++i) if(cl_MusicalData[i][e_model] == modelid) {
		format(clotingName, 32, cl_MusicalData[i][e_name]);
		return clotingName;
	}
	for(new i=0;i!=sizeof(cl_PoliceData);++i) if(cl_PoliceData[i][e_model] == modelid) {
		format(clotingName, 32, cl_PoliceData[i][e_name]);
		return clotingName;
	}
	for(new i=0;i!=sizeof(cl_MedicData);++i) if(cl_MedicData[i][e_model] == modelid) {
		format(clotingName, 32, cl_MedicData[i][e_name]);
		return clotingName;
	}
	format(clotingName, 32, "Unknown");
	return clotingName;
}

RemovePlayerClothing(playerid)
{
	for (new i = 0; i != MAX_PLAYER_ATTACHED_OBJECTS; i ++)
		RemovePlayerAttachedObject(playerid, i);
}

ClothingExistSlot(playerid)
{
	new query[128], slot = -1;
	for(new i = 0; i!=MAX_CLOTHES;++i)
	{
		format(query,sizeof(query),"SELECT * FROM clothing WHERE owner = '%d' AND slot = %d",playerData[playerid][pSID], i);
		mysql_query(dbCon, query);

		if(!cache_num_rows())
		{
		    slot = i;
		    break;
		}
	}
	if(slot > 7) slot = 7;
	return slot;
}


PurchaseClothing(playerid, slot)
{
	new num = CountPlayerClothing(playerid);
	switch(playerData[playerid][pDonateRank])
	{
		case 0: if(num >= 6) return -2;
		case 1: if(num >= 8) return -2;
		case 2: if(num >= 10) return -2;
		case 3: if(num >= 15) return -2;
	}
	
	new model, bone, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:sx, Float:sy, Float:sz;
	switch(cl_buying[playerid])
	{
	    case BUYSPORTS:
	    {
			if(slot < 0 || slot >= sizeof(cl_SportsData)) return 0;
			if(playerData[playerid][pScore] < cl_SportsData[slot][e_price]) return -1;

	        model = cl_SportsData[slot][e_model];
	        bone = cl_SportsData[slot][e_bone];
	        x = cl_SportsData[slot][e_x];
	        y = cl_SportsData[slot][e_y];
	        z = cl_SportsData[slot][e_z];
	        rx = cl_SportsData[slot][e_rx];
	        ry = cl_SportsData[slot][e_ry];
	        rz = cl_SportsData[slot][e_rz];
	        sx = cl_SportsData[slot][e_sx];
	        sy = cl_SportsData[slot][e_sy];
	        sz = cl_SportsData[slot][e_sz];
	    }
	    case BUYHARDWARE:
	    {
	        if(slot < 0 || slot >= sizeof(cl_HardwareData)) return 0;
			if(playerData[playerid][pScore] < cl_HardwareData[slot][e_price]) return -1;

	        model = cl_HardwareData[slot][e_model];
	        bone = cl_HardwareData[slot][e_bone];
	        x = cl_HardwareData[slot][e_x];
	        y = cl_HardwareData[slot][e_y];
	        z = cl_HardwareData[slot][e_z];
	        rx = cl_HardwareData[slot][e_rx];
	        ry = cl_HardwareData[slot][e_ry];
	        rz = cl_HardwareData[slot][e_rz];
	        sx = cl_HardwareData[slot][e_sx];
	        sy = cl_HardwareData[slot][e_sy];
	        sz = cl_HardwareData[slot][e_sz];
	    }
	    case BUYMUSIC:
	    {
			if(slot < 0 || slot >= sizeof(cl_MusicalData)) return 0;
			if(playerData[playerid][pScore] < cl_MusicalData[slot][e_price]) return -1;

	        model = cl_MusicalData[slot][e_model];
	        bone = cl_MusicalData[slot][e_bone];
	        x = cl_MusicalData[slot][e_x];
	        y = cl_MusicalData[slot][e_y];
	        z = cl_MusicalData[slot][e_z];
	        rx = cl_MusicalData[slot][e_rx];
	        ry = cl_MusicalData[slot][e_ry];
	        rz = cl_MusicalData[slot][e_rz];
	        sx = cl_MusicalData[slot][e_sx];
	        sy = cl_MusicalData[slot][e_sy];
	        sz = cl_MusicalData[slot][e_sz];
	    }
	    case BUYWATCH:
	    {
	        if(slot < 0 || slot >= sizeof(cl_DsShopData)) return 0;
			if(playerData[playerid][pScore] < cl_DsShopData[slot][e_price]) return -1;

	        model = cl_DsShopData[slot][e_model];
	        bone = cl_DsShopData[slot][e_bone];
	        x = cl_DsShopData[slot][e_x];
	        y = cl_DsShopData[slot][e_y];
	        z = cl_DsShopData[slot][e_z];
	        rx = cl_DsShopData[slot][e_rx];
	        ry = cl_DsShopData[slot][e_ry];
	        rz = cl_DsShopData[slot][e_rz];
	        sx = cl_DsShopData[slot][e_sx];
	        sy = cl_DsShopData[slot][e_sy];
	        sz = cl_DsShopData[slot][e_sz];
	    }
	    case BUYPOLICE:
	    {
			new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);

	        if(slot < 0 || slot >= sizeof(cl_PoliceData)) return 0;
			if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin]) return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่ตำรวจเท่านั้น !");
			if(playerData[playerid][pScore] < cl_PoliceData[slot][e_price]) return -1;

	        model = cl_PoliceData[slot][e_model];
	        bone = cl_PoliceData[slot][e_bone];
	        x = cl_PoliceData[slot][e_x];
	        y = cl_PoliceData[slot][e_y];
	        z = cl_PoliceData[slot][e_z];
	        rx = cl_PoliceData[slot][e_rx];
	        ry = cl_PoliceData[slot][e_ry];
	        rz = cl_PoliceData[slot][e_rz];
	        sx = cl_PoliceData[slot][e_sx];
	        sy = cl_PoliceData[slot][e_sy];
	        sz = cl_PoliceData[slot][e_sz];
	    }
	    case BUYMEDIC:
	    {
	        if(slot < 0 || slot >= sizeof(cl_MedicData)) return 0;
			if(playerData[playerid][pScore] < cl_MedicData[slot][e_price]) return -1;

	        model = cl_MedicData[slot][e_model];
	        bone = cl_MedicData[slot][e_bone];
	        x = cl_MedicData[slot][e_x];
	        y = cl_MedicData[slot][e_y];
	        z = cl_MedicData[slot][e_z];
	        rx = cl_MedicData[slot][e_rx];
	        ry = cl_MedicData[slot][e_ry];
	        rz = cl_MedicData[slot][e_rz];
	        sx = cl_MedicData[slot][e_sx];
	        sy = cl_MedicData[slot][e_sy];
	        sz = cl_MedicData[slot][e_sz];
	    }
	    case BUYZIP:
	    {
	        if(slot < 0 || slot >= sizeof(cl_ZipData)) return 0;
			if(playerData[playerid][pScore] < cl_ZipData[slot][e_price]) return -1;

	        model = cl_ZipData[slot][e_model];
	        bone = cl_ZipData[slot][e_bone];
	        x = cl_ZipData[slot][e_x];
	        y = cl_ZipData[slot][e_y];
	        z = cl_ZipData[slot][e_z];
	        rx = cl_ZipData[slot][e_rx];
	        ry = cl_ZipData[slot][e_ry];
	        rz = cl_ZipData[slot][e_rz];
	        sx = cl_ZipData[slot][e_sx];
	        sy = cl_ZipData[slot][e_sy];
	        sz = cl_ZipData[slot][e_sz];
	    }
	    case BUYSPECIAL:
	    {
	        if(slot < 0 || slot >= sizeof(cl_SpecialData)) return 0;
			if(playerData[playerid][pPoint] < cl_SpecialData[slot][e_price]) return -1;

	        model = cl_SpecialData[slot][e_model];
	        bone = cl_SpecialData[slot][e_bone];
	        x = cl_SpecialData[slot][e_x];
	        y = cl_SpecialData[slot][e_y];
	        z = cl_SpecialData[slot][e_z];
	        rx = cl_SpecialData[slot][e_rx];
	        ry = cl_SpecialData[slot][e_ry];
	        rz = cl_SpecialData[slot][e_rz];
	        sx = cl_SpecialData[slot][e_sx];
	        sy = cl_SpecialData[slot][e_sy];
	        sz = cl_SpecialData[slot][e_sz];
	    }
	}
	SetPlayerAttachedObject(playerid, cl_buyingpslot[playerid], model, bone, x, y, z, rx, ry, rz, sx, sy, sz);
	EditAttachedObject(playerid, cl_buyingpslot[playerid]);
	BitFlag_On(gPlayerBitFlag[playerid], IS_PLAYER_BUYCLOTHING);

	SendClientMessage(playerid, COLOR_WHITE, "ข้อแนะ: ใช้ "EMBED_YELLOW"SPACE"EMBED_WHITE" เพื่อดูรอบ ๆ กด "EMBED_YELLOW"ESC"EMBED_WHITE" เพื่อยกเลิก");
	SendClientMessage(playerid, COLOR_LIGHTRED, "ใส่เครื่องแต่งกายตำแหน่งที่ไม่เหมาะสมมีโทษ");

	ApplyAnimation(playerid, "CLOTHES", "CLO_Buy", 4.1, 0, 1,1, 1, 0, 1);
	return 1;
}

Dialog:buyClothing(playerid, response, listitem, inputtext[])
{
	if (response) {

		if(!strcmp(inputtext, "หน้าถัดไป!", true)) {
			new str[1728];
			switch(cl_buying[playerid])
			{
			    case BUYZIP:
			    {
					for(new i= 91;i!=sizeof(cl_ZipData);++i)
					{
					    format(str, sizeof(str), "%s %d.%s\t{48E348}%d Score"EMBED_WHITE"\n", str, i, cl_ZipData[i][e_name], cl_ZipData[i][e_price]);
					}
				}

			    case BUYSPECIAL:
			    {
					for(new i= 91;i!=sizeof(cl_SpecialData);++i)
					{
					    format(str, sizeof(str), "%s %d.%s\t{48E348}%d Point"EMBED_WHITE"\n", str, i, cl_SpecialData[i][e_name], cl_SpecialData[i][e_price]);
					}
				}
			}
	        return Dialog_Show(playerid, buyClothing2, DIALOG_STYLE_TABLIST, "/buy ItemID", str, "Ok", "Cancel");
		}

		if((cl_buyingpslot[playerid] = ClothingExistSlot(playerid)) != -1)
		{
			switch(PurchaseClothing(playerid, listitem)) {
				case -2: {
					SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถซื้อได้มากกว่านี้แล้ว");
				}
				case -1: {
					SendClientMessage(playerid, COLOR_LIGHTRED, "ขออภัยคุณมี Score ไม่พอที่จะซื้อ !!");
				}
				case 0: {
					SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่สามารถซื้อไอเท็มเครื่องแต่งกายไอดีนี้ได้");
				}
			}
		}
	}
	return 1;
}

Dialog:buyClothing2(playerid, response, listitem, inputtext[])
{
	if (response) {
		if((cl_buyingpslot[playerid] = ClothingExistSlot(playerid)) != -1)
		{
			switch(PurchaseClothing(playerid, listitem + 91)) {
				case -2: {
					SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่สามารถซื้อได้มากกว่านี้แล้ว");
				}
				case -1: {
					SendClientMessage(playerid, COLOR_LIGHTRED, "ขออภัยคุณมี Score ไม่พอที่จะซื้อ !!");
				}
				case 0: {
					SendClientMessage(playerid, COLOR_LIGHTRED, "ไม่สามารถซื้อไอเท็มเครื่องแต่งกายไอดีนี้ได้");
				}
			}
		}
	}
	return 1;
}

showPlayerClothingMenu(playerid) {
	new id = cl_dataslot[playerid][cl_selected[playerid]];
	return Dialog_Show(playerid, ClothingMenu, DIALOG_STYLE_LIST, ClothingData[playerid][id][cl_name], "เปลี่ยนชื่อไอเท็ม:\t"EMBED_WHITE"["EMBED_YELLOW"%s"EMBED_YELLOW""EMBED_WHITE"]\nเปลี่ยนสล็อตกระดูก:\t"EMBED_WHITE"["EMBED_YELLOW"%s"EMBED_YELLOW""EMBED_WHITE"]\nเปลี่ยนสล็อตอินเด็กซ์:\t"EMBED_WHITE"["EMBED_YELLOW"%d"EMBED_YELLOW""EMBED_WHITE"]\nเปลี่ยนสีไอเท็ม\nเปลี่ยนสีที่สองไอเท็ม\nปรับตำแหน่งไอเท็ม\n%s", "เลือก", "<< กลับ", ClothingData[playerid][id][cl_name], BoneName[ClothingData[playerid][id][cl_bone]-1], ClothingData[playerid][id][cl_slot], (ClothingData[playerid][id][cl_equip]) ? ("ถอด "EMBED_RED"ออก") : ("สวม "EMBED_GREENMONEY"ใส่"));
}

Dialog:ClothingList(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return 1;

	cl_selected[playerid] = listitem;
	return showPlayerClothingMenu(playerid);
}

Dialog:ClothingColorSelect(playerid, response, listitem, inputtext[])
{
	if (response) {
		new slot = GetPVarInt(playerid, "materialColorSlot");
		if (isequal(inputtext, "0")) {
			new id = cl_dataslot[playerid][cl_selected[playerid]];
			if (slot == 1) ClothingData[playerid][id][cl_mc1] = 0;
			else  ClothingData[playerid][id][cl_mc2] = 0;

			SendClientMessageEx(playerid, COLOR_WHITE, "คุณเปลี่ยนสีพื้นผิวไอเท็มช่องที่ "EMBED_YELLOW"%d"EMBED_WHITE" ของ ("EMBED_YELLOW"%s"EMBED_WHITE") เป็น "EMBED_YELLOW"สีปกติ", slot, ClothingData[playerid][id][cl_name]);
			
			DeletePVar(playerid, "materialColorSlot");
			cl_DressPlayer(playerid);
			return 1;
		}
		new color;
		if(sscanf(inputtext,"h", color)) return Dialog_Show(playerid, ClothingColorSelect, DIALOG_STYLE_INPUT, "เปลี่ยนสีไอเท็ม", ""EMBED_WHITE"วางโค้ดสีที่คุณต้องการ\nหรือให้เว็บไซต์ช่วย \""EMBED_YELLOW"http://www.color-hex.com"EMBED_WHITE"/\"\n-รูปแบบต้องเป็นแบบนี้ \""EMBED_YELLOW"FFFF00"EMBED_WHITE"\" (ไม่รวมเครื่องหมายคำพูด)\n-คุณสามารถใส่ (0) เพื่อรีเซตสีได้\n\n"EMBED_LIGHTRED"[!] คุณมีความสามารถในการเปลี่ยนสีเครื่องแต่งกายของคุณ", "ใส่", "<< กลับ");
		new id = cl_dataslot[playerid][cl_selected[playerid]];
		if (slot == 1) ClothingData[playerid][id][cl_mc1] = RGBToARGB(color);
		else  ClothingData[playerid][id][cl_mc2] = RGBToARGB(color);

		SendClientMessageEx(playerid, COLOR_WHITE, "คุณเปลี่ยนสีพื้นผิวไอเท็มช่องที่ "EMBED_YELLOW"%d"EMBED_WHITE" ของ ("EMBED_YELLOW"%s"EMBED_WHITE") เป็น "EMBED_YELLOW"%06x", slot, ClothingData[playerid][id][cl_name], color);

		DeletePVar(playerid, "materialColorSlot");
		cl_DressPlayer(playerid);
	}
	return showPlayerClothingMenu(playerid);
}

Dialog:ClothingMenu(playerid, response, listitem, inputtext[])
{
	if (!response) cl_ShowClothingMenu(playerid);
	else
	{
		switch(listitem)
		{
		    case 0: // เปลี่ยนชื่อไอเท็ม
		    {
		        Dialog_Show(playerid, ClothingName, DIALOG_STYLE_INPUT, "เปลี่ยนชื่อไอเท็ม", ""EMBED_YELLOW"คุณสามารถที่จะเพิ่ม ตัวระบุที่ไม่ซ้ำ ให้กับไอเท็มเครื่องแต่งกายของคุณ\nสิ่งนี้จะช่วยชี้ทางให้กับคุณเมื่อมีเครื่องแต่งกายมีจำนวนมาก\n\nกรอกชื่อที่คุณต้องการแสดงให้กับไอเท็มเครื่องแต่งกายของคุณ มันจำกัดไว้ที่ 20 ตัวอักษร\nหากคุณต้องการให้มันกลับไปเป็นชื่อเดิม ให้กดปุ่ม ENTER ในขณะที่ช่องยังว่างอยู่\n\n"EMBED_LIGHTRED"[!] คำเตือน: การใช้ฟีเจอร์นี้ในการโกงหรือเอาเปรียบจะถูกลงโทษ อย่าใช้มันผิดวัตถุประสงค์\n[!] หมายเหตุ: นี่เป็นการสร้างตัวระบุที่ไม่ซ้ำมันจะแสดงให้เห็นเพียงแค่คุณเท่านั้น", "เปลี่ยน", "<< กลับ");
		    }
		    case 1: // เปลี่ยนสล็อตกระดูก
		    {
				new str[256];
				new id = cl_dataslot[playerid][cl_selected[playerid]];
				for(new i=0; i != sizeof(BoneName); i++) {
					if (ClothingData[playerid][id][cl_bone]-1 == i) {
						strcat(str, sprintf("%s ["EMBED_YELLOW"ปัจจุบัน"EMBED_WHITE"]\n", BoneName[i]));
					}
					else strcat(str, sprintf("%s\n", BoneName[i]));
				}
                Dialog_Show(playerid, ClothingBone, DIALOG_STYLE_LIST, "เปลี่ยนสล็อตกระดูก", str, "เลือก", "<< กลับ");
		    }
 		    case 2: // เปลี่ยนสล็อตอินเด็กซ์
		    {

				new str[128];
				new id = cl_dataslot[playerid][cl_selected[playerid]];
				for(new i=0; i != 5; i++) {
					if (ClothingData[playerid][id][cl_slot] == i) {
						strcat(str, sprintf("อินเด็กซ์ %d ["EMBED_YELLOW"ปัจจุบัน"EMBED_WHITE"]\n", i));
					}
					else strcat(str, sprintf("อินเด็กซ์ %d\n", i));
				}
				Dialog_Show(playerid, ClothingIndex, DIALOG_STYLE_LIST, "เปลี่ยนสล็อตอินเด็กซ์", str, "เลือก", "<< กลับ");
		    }
			case 3: // เปลี่ยนสีไอเท็ม 
			{
				SetPVarInt(playerid, "materialColorSlot", 1);
				Dialog_Show(playerid, ClothingColorSelect, DIALOG_STYLE_INPUT, "เปลี่ยนสีไอเท็ม", ""EMBED_WHITE"วางโค้ดสีที่คุณต้องการ\nหรือให้เว็บไซต์ช่วย \""EMBED_YELLOW"http://www.color-hex.com"EMBED_WHITE"/\"\n-รูปแบบต้องเป็นแบบนี้ \""EMBED_YELLOW"FFFF00"EMBED_WHITE"\" (ไม่รวมเครื่องหมายคำพูด)\n-คุณสามารถใส่ (0) เพื่อรีเซตสีได้\n\n"EMBED_LIGHTRED"[!] คุณมีความสามารถในการเปลี่ยนสีเครื่องแต่งกายของคุณ", "ใส่", "<< กลับ");
		    }
			case 4: // เปลี่ยนสีไอเท็ม 2
			{
				SetPVarInt(playerid, "materialColorSlot", 2);
				Dialog_Show(playerid, ClothingColorSelect, DIALOG_STYLE_INPUT, "เปลี่ยนสีไอเท็ม 2", ""EMBED_WHITE"วางโค้ดสีที่คุณต้องการ\nหรือให้เว็บไซต์ช่วย \""EMBED_YELLOW"http://www.color-hex.com"EMBED_WHITE"/\"\n-รูปแบบต้องเป็นแบบนี้ \""EMBED_YELLOW"FFFF00"EMBED_WHITE"\" (ไม่รวมเครื่องหมายคำพูด)\n-คุณสามารถใส่ (0) เพื่อรีเซตสีได้\n\n"EMBED_LIGHTRED"[!] คุณมีความสามารถในการเปลี่ยนสีเครื่องแต่งกายของคุณ", "ใส่", "<< กลับ");
			}
		    case 5: // ปรับตำแหน่งไอเท็ม
		    {
		        new id = cl_dataslot[playerid][cl_selected[playerid]];

			    SetPlayerAttachedObject(playerid, ClothingData[playerid][id][cl_slot], ClothingData[playerid][id][cl_object], ClothingData[playerid][id][cl_bone], ClothingData[playerid][id][cl_x], ClothingData[playerid][id][cl_y],
				ClothingData[playerid][id][cl_z], ClothingData[playerid][id][cl_rx], ClothingData[playerid][id][cl_ry], ClothingData[playerid][id][cl_rz], ClothingData[playerid][id][cl_scalex], ClothingData[playerid][id][cl_scaley], ClothingData[playerid][id][cl_scalez], ClothingData[playerid][id][cl_mc1], ClothingData[playerid][id][cl_mc2]);

				ApplyAnimation(playerid, "CLOTHES", "CLO_Buy", 4.1, 0, 1,1, 1, 0, 1);
				EditAttachedObject(playerid, ClothingData[playerid][id][cl_slot]);
				BitFlag_On(gPlayerBitFlag[playerid], IS_PLAYER_EDITCLOTHING);

				// SendClientMessage(playerid, COLOR_WHITE, "ข้อแนะ: ใช้ "EMBED_YELLOW"SPACE"EMBED_WHITE" เพื่อดูรอบ ๆ กด "EMBED_YELLOW"ESC"EMBED_WHITE" เพื่อยกเลิก");
		    }
 		    case 6: // On-Off
		    {
		        new id = cl_dataslot[playerid][cl_selected[playerid]];

				if(ClothingData[playerid][id][cl_equip]) {

					RemovePlayerAttachedObject(playerid, ClothingData[playerid][id][cl_slot]);
					ClothingData[playerid][id][cl_equip] = 0;
				}
				else
				{
				    SetPlayerAttachedObject(playerid, ClothingData[playerid][id][cl_slot], ClothingData[playerid][id][cl_object], ClothingData[playerid][id][cl_bone], ClothingData[playerid][id][cl_x], ClothingData[playerid][id][cl_y],
					ClothingData[playerid][id][cl_z], ClothingData[playerid][id][cl_rx], ClothingData[playerid][id][cl_ry], ClothingData[playerid][id][cl_rz], ClothingData[playerid][id][cl_scalex], ClothingData[playerid][id][cl_scaley], ClothingData[playerid][id][cl_scalez], ClothingData[playerid][id][cl_mc1], ClothingData[playerid][id][cl_mc2]);
					SendClientMessageEx(playerid, COLOR_WHITE, "คุณได้สวมใส่ "EMBED_YELLOW"%s"EMBED_WHITE" ของคุณ", ClothingData[playerid][id][cl_name]);

					for (new i = 0; i < MAX_CLOTHES; i ++)
					{
					    if(ClothingData[playerid][i][cl_object] != INVALID_OBJECT_ID && ClothingData[playerid][i][cl_equip] && ClothingData[playerid][i][cl_slot] == ClothingData[playerid][id][cl_slot])
					    {
					        ClothingData[playerid][i][cl_equip] = 0;
						}
					}
					ClothingData[playerid][id][cl_equip] = 1;
				}

		    }
		}
	}
	return 1;
}

Dialog:ClothingName(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = cl_dataslot[playerid][cl_selected[playerid]];
		if (isnull(inputtext)) {
			new oldName[32];
			format(oldName, 32, GetClotingItemName(ClothingData[playerid][id][cl_object]));
			SendClientMessageEx(playerid, COLOR_WHITE, "คุณเปลี่ยนชื่อไอเท็ม "EMBED_YELLOW"%s "EMBED_WHITE"เป็น "EMBED_YELLOW"%s", ClothingData[playerid][id][cl_name], oldName);
			format(ClothingData[playerid][id][cl_name], 32, oldName);
		}
		else if (strlen(inputtext) > 20) {
			return Dialog_Show(playerid, ClothingName, DIALOG_STYLE_INPUT, "เปลี่ยนชื่อไอเท็ม", "ชื่อไอเท็มต้องไม่เป็นค่าว่างหรือมากกว่า 20 ตัวอักษร\nกรอกชื่อไอเท็มที่ต้องการลงบนกล่องด้านล่างนี้:", "เปลี่ยน", "<< กลับ");
		}
		else {
			SendClientMessageEx(playerid, COLOR_WHITE, "คุณเปลี่ยนชื่อไอเท็ม "EMBED_YELLOW"%s "EMBED_WHITE"เป็น "EMBED_YELLOW"%s", ClothingData[playerid][id][cl_name], inputtext);
			format(ClothingData[playerid][id][cl_name], 32, inputtext);
		}
	}
    return showPlayerClothingMenu(playerid);
}

Dialog:ClothingBone(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = cl_dataslot[playerid][cl_selected[playerid]];
        ClothingData[playerid][id][cl_bone] = listitem + 1;
		SetPlayerAttachedObject(playerid, ClothingData[playerid][id][cl_slot], ClothingData[playerid][id][cl_object], ClothingData[playerid][id][cl_bone]);
       	ApplyAnimation(playerid, "CLOTHES", "CLO_Buy", 4.1, 0, 1, 1, 1, 0, 1);
		EditAttachedObject(playerid, ClothingData[playerid][id][cl_slot]);
		BitFlag_On(gPlayerBitFlag[playerid], IS_PLAYER_EDITCLOTHING);

		SendClientMessageEx(playerid, COLOR_WHITE, "คุณเปลี่ยน ("EMBED_YELLOW"%s"EMBED_WHITE") เป็นส่วน "EMBED_YELLOW"%s"EMBED_WHITE"", ClothingData[playerid][id][cl_name], BoneName[listitem]);
	}
    return showPlayerClothingMenu(playerid);
}

Dialog:ClothingIndex(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new id = cl_dataslot[playerid][cl_selected[playerid]];
	    ClothingData[playerid][id][cl_slot] = listitem;

        RemovePlayerClothing(playerid);
        cl_DressPlayer(playerid);

		SendClientMessageEx(playerid, COLOR_WHITE, "คุณเปลี่ยน ("EMBED_YELLOW"%s"EMBED_WHITE") เป็นอินเด็กซ์ช่องที่ "EMBED_YELLOW"%d", ClothingData[playerid][id][cl_name], listitem + 1);
	}
    return showPlayerClothingMenu(playerid);
}

stock RGBToARGB(color)
{
 	return (0xFF << 24) | color;
}

forward OnLoadClothing(playerid);
public OnLoadClothing(playerid) {
    new rows;
    cache_get_row_count(rows);
    if (rows) {
        for (new i = 0; i < rows; i ++) if(i < MAX_CLOTHES)
        {
    		cache_get_value_name_int(i, "id", ClothingData[playerid][i][cl_sid]);
    		cache_get_value_name_int(i, "object", ClothingData[playerid][i][cl_object]);
    		cache_get_value_name_float(i, "x", ClothingData[playerid][i][cl_x]);
    		cache_get_value_name_float(i, "y", ClothingData[playerid][i][cl_y]);
    		cache_get_value_name_float(i, "z", ClothingData[playerid][i][cl_z]);
    		cache_get_value_name_float(i, "rx", ClothingData[playerid][i][cl_rx]);
    		cache_get_value_name_float(i, "ry", ClothingData[playerid][i][cl_ry]);
    		cache_get_value_name_float(i, "rz", ClothingData[playerid][i][cl_rz]);
    		cache_get_value_name_float(i, "scalex", ClothingData[playerid][i][cl_scalex]);
    		cache_get_value_name_float(i, "scaley", ClothingData[playerid][i][cl_scaley]);
    		cache_get_value_name_float(i, "scalez", ClothingData[playerid][i][cl_scalez]);
    		cache_get_value_name_int(i, "bone", ClothingData[playerid][i][cl_bone]);
    		cache_get_value_name_int(i, "slot", ClothingData[playerid][i][cl_slot]);
    		cache_get_value_name_int(i, "equip", ClothingData[playerid][i][cl_equip]);
    		cache_get_value_name_int(i, "materialColor1", ClothingData[playerid][i][cl_mc1]);
    		cache_get_value_name_int(i, "materialColor2", ClothingData[playerid][i][cl_mc2]);
    		cache_get_value_name(i, "name", ClothingData[playerid][i][cl_name], 32);
    	}
    }
}
