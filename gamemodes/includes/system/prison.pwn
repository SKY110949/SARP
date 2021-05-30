#include <YSI\y_hooks>

new Float:PrisonSpawns[][] = 
{
    {1777.4839,-1565.3458,1734.9430}, // PrisonSpawns
    {1772.9803,-1565.2146,1734.9430}, // PrisonSpawns
    {1768.8168,-1564.7576,1734.9430}, // PrisonSpawns
    {1764.6261,-1565.0900,1734.9430}, // PrisonSpawns
    {1760.0579,-1564.4680,1734.9430}, // PrisonSpawns
    {1755.9989,-1581.5919,1734.9430}, // PrisonSpawns
    {1760.3005,-1581.4974,1734.9430}, // PrisonSpawns
    {1764.4890,-1581.7781,1734.9430}, // PrisonSpawns
    {1768.4534,-1581.7981,1734.9430} // PrisonSpawns
};

hook OnGameModeInit()
{
    Create3DTextLabel("{FFFF00}ทางเข้าเรือนจำ San Andreas\n{FFFFFF}พิมพ์ {7FFF00}/enter{FFFFFF} เพื่อเข้าเรือนจำ",0xFFFF00FF, 630.8229,-3058.3379,10.4870,30.0,0,1);
    Create3DTextLabel("{FFFF00}ทางออกเรือนจำ San Andreas\n{FFFFFF}พิมพ์ {7FFF00}/exit{FFFFFF} เพื่อออกเรือนจำ",0xFFFF00FF, 632.8108,-3063.8755,10.3060,30.0,0,1);

    Create3DTextLabel("{FFFF00}ทางเข้าลานกว้างของเรือนจำ\n{FFFFFF}พิมพ์ {7FFF00}/enter{FFFFFF} เพื่อเข้าไปด้านใน",0xFFFF00FF, 604.3121,-3136.1377,10.1333,30.0,0,1);
    Create3DTextLabel("{FFFF00}ทางออกลานกว้างของเรือนจำ\n{FFFFFF}พิมพ์ {7FFF00}/exit{FFFFFF} เพื่อออกจากที่นี่",0xFFFF00FF, 605.4823,-3140.5581,10.1325,30.0,0,1);

    Create3DTextLabel("{FFFF00}Department of Correction\n{FFFFFF}พิมพ์ {7FFF00}/enter{FFFFFF} เพื่อเข้าไปด้านใน",0xFFFF00FF, 645.8768,-3115.1067,11.0019,30.0,0,1);
    Create3DTextLabel("{FFFF00}Department of Correction\n{FFFFFF}พิมพ์ {7FFF00}/exit{FFFFFF} เพื่อออกจากที่นี่",0xFFFF00FF, 1765.1758,-1568.9832,1742.4930,30.0,0,1);

    Create3DTextLabel("{FFFF00}ทางเข้าห้องขังนักโทษ\n{FFFFFF}พิมพ์ {7FFF00}/enter{FFFFFF} เพื่อเข้าไปด้านใน",0xFFFF00FF, 1779.7113,-1580.5214,1742.4500,30.0,0,1);
    Create3DTextLabel("{FFFF00}ทางออกห้องขังนักโทษ\n{FFFFFF}พิมพ์ {7FFF00}/exit{FFFFFF} เพื่อออกจากที่นี่",0xFFFF00FF, 1779.7740,-1577.9274,1741.9115,30.0,0,1);

    CreateDynamicPickup(1240, 23, 1775.7197,-1572.6295,1734.9430, 0,0);
    CreateDynamic3DTextLabel("จุดส่งตัวนักโทษ\nพิมพ์ /prison เพื่อส่งตัวนักโทษ", -1, 1775.7197,-1572.6295,1734.9430, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 100.0);

    Create3DTextLabel("{FFFF00}ทางเข้าห้องขังนักโทษ\n{FFFFFF}พิมพ์ {7FFF00}/enter{FFFFFF} เพื่อเข้าไปด้านใน\nต้องรอผู้คุมเรือนจำเปิดให้ใช้งานประตู",0xFFFF00FF, 1780.2192,-1576.5327,1734.9430,30.0,0,1);
    Create3DTextLabel("{FFFF00}ทางออกห้องขังนักโทษ\n{FFFFFF}พิมพ์ {7FFF00}/exit{FFFFFF} เพื่อออกจากที่นี่\nต้องรอผู้คุมเรือนจำเปิดให้ใช้งานประตู",0xFFFF00FF, 1624.5247,-3146.2415,10.3016,30.0,0,1);

    // Prison Interior

    CreateDynamicObject(7191, 1759.33887, -1602.47559, 1734.94885,   0.00000, 359.24744, 179.99451);
    CreateDynamicObject(8661, 1775.47681, -1555.70300, 1733.94299,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(8661, 1775.51074, -1575.59961, 1733.94299,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(8661, 1773.91602, -1585.53955, 1743.44299,   271.99951, 179.99451, 179.99451);
    CreateDynamicObject(8661, 1769.37012, -1560.26367, 1743.89319,   90.00000, 179.99451, 179.99451);
    CreateDynamicObject(8661, 1755.54297, -1565.83496, 1743.86816,   90.00000, 164.49872, 285.49030);
    CreateDynamicObject(8661, 1780.48730, -1566.79688, 1743.91846,   271.99402, 179.99451, 270.74158);
    CreateDynamicObject(7191, 1763.61584, -1602.32544, 1734.94885,   0.00000, 359.24744, 179.99451);
    CreateDynamicObject(7191, 1767.83789, -1602.22559, 1734.94885,   0.00000, 359.24744, 179.99451);
    CreateDynamicObject(7191, 1772.08643, -1602.06995, 1734.94885,   0.00000, 359.24744, 179.99451);
    CreateDynamicObject(7191, 1776.33545, -1601.98816, 1734.94885,   0.00000, 359.24744, 179.99451);
    CreateDynamicObject(7191, 1780.60925, -1601.95776, 1734.94885,   0.00000, 359.24744, 179.99451);
    CreateDynamicObject(7191, 1780.60840, -1601.95703, 1738.89856,   0.00000, 359.24744, 179.99451);
    CreateDynamicObject(7191, 1776.35535, -1601.96533, 1738.89856,   0.00000, 359.24744, 179.99451);
    CreateDynamicObject(7191, 1772.10400, -1602.02283, 1738.89856,   0.00000, 359.24744, 179.99451);
    CreateDynamicObject(7191, 1767.85596, -1602.20557, 1738.89856,   0.00000, 359.24744, 179.99451);
    CreateDynamicObject(7191, 1763.63049, -1602.28760, 1738.89856,   0.00000, 359.24744, 179.99451);
    CreateDynamicObject(7191, 1759.38232, -1602.49524, 1738.89856,   0.00000, 359.24744, 179.99451);
    CreateDynamicObject(8661, 1774.91199, -1585.83813, 1737.71729,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(8661, 1774.90625, -1586.21289, 1737.71729,   0.00000, 179.99994, 0.00000);
    CreateDynamicObject(7191, 1759.47070, -1544.44385, 1734.94885,   0.00000, 359.24744, 359.99451);
    CreateDynamicObject(7191, 1763.72021, -1544.37646, 1734.94885,   0.00000, 359.24194, 359.98901);
    CreateDynamicObject(7191, 1767.96826, -1544.28381, 1734.94885,   0.00000, 359.24194, 359.98901);
    CreateDynamicObject(7191, 1772.26855, -1544.30994, 1734.94885,   0.00000, 359.24194, 359.98901);
    CreateDynamicObject(7191, 1776.52319, -1544.21216, 1734.94885,   0.00000, 359.24194, 359.98901);
    CreateDynamicObject(7191, 1780.51929, -1544.10156, 1734.94885,   0.00000, 359.24194, 0.48901);
    CreateDynamicObject(8661, 1775.49219, -1559.57874, 1737.69348,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(7191, 1780.46851, -1544.10107, 1738.87500,   0.00000, 359.24194, 0.48889);
    CreateDynamicObject(7191, 1776.26636, -1544.22375, 1738.87500,   0.00000, 359.24194, 0.48889);
    CreateDynamicObject(7191, 1772.01392, -1544.32251, 1738.87500,   0.00000, 359.24194, 0.48889);
    CreateDynamicObject(7191, 1767.71362, -1544.31873, 1738.87500,   0.00000, 359.24194, 0.48889);
    CreateDynamicObject(7191, 1763.46191, -1544.39099, 1738.87500,   0.00000, 359.24194, 0.48889);
    CreateDynamicObject(7191, 1759.23499, -1544.46594, 1738.87500,   0.00000, 359.24194, 0.48889);
    CreateDynamicObject(8661, 1775.49219, -1559.57813, 1737.69348,   0.00000, 179.99451, 0.00000);
    CreateDynamicObject(8661, 1758.60547, -1576.85156, 1741.39661,   0.00000, 180.24719, 0.00000);
    CreateDynamicObject(8661, 1796.80469, -1573.79883, 1737.69299,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(8661, 1796.80469, -1573.79883, 1737.69299,   0.00000, 180.00000, 0.00000);
    CreateDynamicObject(8614, 1759.44958, -1570.43896, 1736.46753,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(970, 1774.75964, -1569.58252, 1738.24500,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(970, 1770.65503, -1569.58191, 1738.24500,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(970, 1766.52393, -1569.59546, 1738.24500,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(970, 1764.44043, -1569.59668, 1738.24500,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(970, 1760.35168, -1569.60010, 1738.24500,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(970, 1776.81946, -1571.72888, 1738.26953,   0.00000, 0.00000, 90.50000);
    CreateDynamicObject(970, 1776.86340, -1573.79102, 1738.24500,   0.00000, 0.00000, 90.49988);
    CreateDynamicObject(970, 1774.84778, -1575.85779, 1738.24500,   0.00000, 0.00000, 180.49988);
    CreateDynamicObject(970, 1770.74707, -1575.88159, 1738.24500,   0.00000, 0.00000, 180.49988);
    CreateDynamicObject(970, 1766.62427, -1575.93018, 1738.24500,   0.00000, 0.00000, 180.49988);
    CreateDynamicObject(970, 1762.49915, -1575.97559, 1738.24500,   0.00000, 0.00000, 180.49988);
    CreateDynamicObject(970, 1758.39355, -1576.00171, 1738.24500,   0.00000, 0.00000, 180.49988);
    CreateDynamicObject(970, 1754.26697, -1576.00842, 1738.24500,   0.00000, 0.00000, 180.49988);
    CreateDynamicObject(970, 1753.49280, -1576.04333, 1738.24500,   0.00000, 0.00000, 180.49988);
    CreateDynamicObject(8661, 1757.46338, -1557.05518, 1741.39661,   0.00000, 180.24719, 0.00000);
    CreateDynamicObject(8661, 1761.17578, -1557.23340, 1741.44666,   0.00000, 359.74182, 0.00000);
    CreateDynamicObject(8661, 1760.80688, -1557.22192, 1741.37158,   0.00000, 180.24170, 0.00000);
    CreateDynamicObject(8661, 1758.52771, -1574.44946, 1741.52173,   0.00000, 0.24719, 0.00000);
    CreateDynamicObject(8661, 1763.06543, -1589.03027, 1741.52173,   0.00000, 0.24719, 0.00000);
    CreateDynamicObject(8661, 1761.82434, -1589.05786, 1741.39661,   0.00000, 180.24719, 0.00000);
    CreateDynamicObject(14387, 1780.91284, -1577.63000, 1740.50708,   0.00000, 0.00000, 92.00000);
    CreateDynamicObject(14387, 1780.79639, -1574.75488, 1738.73206,   0.00000, 0.00000, 91.99951);
    CreateDynamicObject(14387, 1780.69727, -1574.78723, 1738.73206,   0.00000, 113.99997, 269.99963);
    CreateDynamicObject(14387, 1780.69092, -1577.21973, 1740.25635,   0.00000, 113.99963, 269.99451);
    CreateDynamicObject(970, 1778.51648, -1577.00818, 1742.02051,   0.00000, 0.00000, 90.49438);
    CreateDynamicObject(8661, 1775.04883, -1576.23438, 1744.96729,   0.00000, 179.99451, 0.00000);
    CreateDynamicObject(8661, 1775.40430, -1562.49023, 1746.96729,   0.00000, 179.99451, 0.00000);
    CreateDynamicObject(8614, 1754.39514, -1570.43872, 1732.71753,   0.00000, 179.25000, 0.00000);
    CreateDynamicObject(2205, 1778.93628, -1571.53638, 1733.94299,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2205, 1778.02222, -1572.87854, 1733.94299,   0.00000, 0.00000, 89.50000);
    CreateDynamicObject(2205, 1779.34424, -1573.83276, 1733.94299,   0.00000, 0.00000, 178.99463);
    CreateDynamicObject(2190, 1779.52197, -1571.44006, 1734.87952,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2190, 1777.92188, -1572.66064, 1734.87952,   0.00000, 0.00000, 89.25000);
    CreateDynamicObject(2776, 1779.93103, -1572.26440, 1734.44043,   0.00000, 0.00000, 232.00000);
    CreateDynamicObject(14819, 1780.77576, -1575.82715, 1735.09290,   358.25003, 0.25012, 91.25766);
    CreateDynamicObject(14401, 1767.80371, -1573.59082, 1734.26868,   0.00000, 0.00000, 91.99402);
    CreateDynamicObject(3858, 1760.93433, -1571.00793, 1744.40942,   0.00000, 0.00000, 260.00000);
    CreateDynamicObject(8661, 1778.78479, -1553.51575, 1751.29260,   90.00000, 180.00549, 269.23352);
    CreateDynamicObject(8661, 1778.32080, -1567.11340, 1751.24255,   89.24982, 269.99982, 89.23663);
    CreateDynamicObject(970, 1778.47668, -1572.88269, 1742.02051,   0.00000, 0.00000, 90.99438);
    CreateDynamicObject(3858, 1760.93359, -1571.00781, 1744.40942,   0.00000, 0.00000, 79.99695);
    CreateDynamicObject(3089, 1764.10718, -1568.76721, 1742.82666,   0.00000, 0.00000, 34.00000);
    CreateDynamicObject(2173, 1758.08972, -1572.24866, 1741.52356,   0.00000, 0.00000, 216.00000);
    CreateDynamicObject(2173, 1760.33533, -1570.66028, 1741.52356,   0.00000, 0.00000, 215.99670);
    CreateDynamicObject(2173, 1762.61743, -1569.15759, 1741.52356,   0.00000, 0.00000, 215.24670);
    CreateDynamicObject(2173, 1762.45386, -1570.66968, 1741.52356,   0.00000, 0.00000, 35.49414);
    CreateDynamicObject(2173, 1760.23218, -1572.24976, 1741.52356,   0.00000, 0.00000, 35.49133);
    CreateDynamicObject(2173, 1757.98828, -1573.84326, 1741.52356,   0.00000, 0.00000, 35.49133);
    CreateDynamicObject(1671, 1763.51978, -1571.32776, 1741.96143,   0.00000, 0.00000, 218.00000);
    CreateDynamicObject(1671, 1761.29626, -1572.90210, 1741.96143,   0.00000, 0.00000, 215.49623);
    CreateDynamicObject(1671, 1759.01147, -1574.51953, 1741.96143,   0.00000, 0.00000, 215.49133);
    CreateDynamicObject(1671, 1757.01660, -1571.60168, 1741.96143,   0.00000, 0.00000, 31.49133);
    CreateDynamicObject(1671, 1759.24402, -1569.97876, 1741.96143,   0.00000, 0.00000, 35.48682);
    CreateDynamicObject(1671, 1761.52612, -1568.53650, 1741.96143,   0.00000, 0.00000, 35.48584);
    CreateDynamicObject(2187, 1760.58557, -1570.35425, 1741.51221,   0.00000, 0.00000, 214.00000);
    CreateDynamicObject(2187, 1760.58496, -1570.35352, 1742.23792,   0.00000, 0.00000, 213.99719);
    CreateDynamicObject(2187, 1760.81287, -1569.07544, 1742.23792,   0.00000, 0.00000, 36.49716);
    CreateDynamicObject(2187, 1760.81250, -1569.07520, 1741.43811,   0.00000, 0.00000, 36.49658);
    CreateDynamicObject(2187, 1758.27673, -1571.80212, 1742.23792,   0.00000, 0.00000, 213.99719);
    CreateDynamicObject(2187, 1758.27637, -1571.80176, 1741.41211,   0.00000, 0.00000, 213.99719);
    CreateDynamicObject(2187, 1758.50903, -1570.49707, 1741.41211,   0.00000, 0.00000, 34.24716);
    CreateDynamicObject(2187, 1758.50879, -1570.49707, 1742.23669,   0.00000, 0.00000, 34.24438);
    CreateDynamicObject(2187, 1762.16943, -1571.02295, 1741.50610,   0.00000, 0.00000, 34.00000);
    CreateDynamicObject(2187, 1762.16895, -1571.02246, 1742.23181,   0.00000, 0.00000, 33.99719);
    CreateDynamicObject(2187, 1759.92725, -1572.57556, 1742.23181,   0.00000, 0.00000, 33.99719);
    CreateDynamicObject(2187, 1759.92676, -1572.57520, 1741.40601,   0.00000, 0.00000, 33.99719);
    CreateDynamicObject(2187, 1759.67029, -1573.84766, 1742.23792,   0.00000, 0.00000, 213.99719);
    CreateDynamicObject(2187, 1759.66992, -1573.84766, 1741.46216,   0.00000, 0.00000, 213.99719);
    CreateDynamicObject(2187, 1761.92969, -1572.32581, 1742.23792,   0.00000, 0.00000, 213.99719);
    CreateDynamicObject(2187, 1761.92969, -1572.32520, 1741.41211,   0.00000, 0.00000, 213.99719);
    CreateDynamicObject(8661, 1766.45886, -1559.20154, 1751.26758,   271.26886, 168.62805, 259.37781);
    CreateDynamicObject(8661, 1766.92334, -1559.11230, 1751.26758,   271.26346, 168.62366, 78.87613);
    CreateDynamicObject(2136, 1767.33252, -1569.92639, 1741.48230,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(2135, 1767.34814, -1570.86084, 1741.48376,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(2828, 1778.97925, -1573.73181, 1734.87952,   0.00000, 0.00000, 326.00000);
    CreateDynamicObject(2139, 1767.38965, -1571.84753, 1741.48352,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(2139, 1767.36035, -1567.96838, 1741.48352,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(2140, 1767.40881, -1572.81580, 1741.48389,   0.00000, 0.00000, 87.00000);
    CreateDynamicObject(2164, 1776.04614, -1567.08313, 1741.46960,   0.00000, 0.00000, 359.25000);
    CreateDynamicObject(2163, 1774.25586, -1567.17090, 1741.50024,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2208, 1767.07788, -1585.10645, 1741.50293,   0.00000, 0.00000, 91.50000);
    CreateDynamicObject(2208, 1767.00330, -1582.40222, 1741.50293,   0.00000, 0.00000, 153.49963);
    CreateDynamicObject(2208, 1764.46558, -1581.14221, 1741.50293,   0.00000, 0.00000, 153.49548);
    CreateDynamicObject(2208, 1762.12024, -1579.98608, 1741.50293,   0.00000, 0.00000, 183.49548);
    CreateDynamicObject(2208, 1759.58862, -1580.14380, 1741.50293,   0.00000, 0.00000, 183.49365);
    CreateDynamicObject(2637, 1770.80518, -1570.48840, 1741.87354,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(2637, 1770.81116, -1572.38843, 1741.87354,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(2776, 1771.96375, -1572.65625, 1741.95923,   0.00000, 0.00000, 272.00000);
    CreateDynamicObject(2776, 1771.92590, -1571.48547, 1741.95923,   0.00000, 0.00000, 271.99951);
    CreateDynamicObject(2776, 1771.99731, -1570.25354, 1741.95923,   0.00000, 0.00000, 271.99951);
    CreateDynamicObject(2776, 1770.24768, -1572.90601, 1741.95923,   0.00000, 0.00000, 91.99951);
    CreateDynamicObject(2776, 1769.68835, -1571.50916, 1741.95923,   0.00000, 0.00000, 91.99402);
    CreateDynamicObject(2776, 1769.72302, -1570.24988, 1741.95923,   0.00000, 0.00000, 91.99402);
    CreateDynamicObject(2776, 1770.04517, -1567.30603, 1741.95923,   0.00000, 0.00000, 1.74402);
    CreateDynamicObject(2776, 1770.04492, -1567.30566, 1742.10938,   0.00000, 0.00000, 1.74133);
    CreateDynamicObject(2776, 1770.04492, -1567.30566, 1742.28455,   0.00000, 0.00000, 1.74133);
    CreateDynamicObject(1713, 1777.74744, -1571.45032, 1741.43884,   0.00000, 0.00000, 272.00000);
    CreateDynamicObject(1713, 1776.78271, -1574.27490, 1741.43884,   0.00000, 0.00000, 178.99951);
    CreateDynamicObject(3962, 1775.31177, -1571.70605, 1741.50232,   0.03925, 90.49854, 359.74973);
    CreateDynamicObject(8661, 1778.10852, -1554.00220, 1751.29260,   90.00000, 179.99451, 90.99194);
    CreateDynamicObject(1429, 1774.67322, -1567.41516, 1742.69165,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2964, 1773.10205, -1578.45813, 1741.46484,   0.00000, 0.00000, 180.00000);
    CreateDynamicObject(2008, 1756.09851, -1583.40295, 1741.54822,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2008, 1759.10095, -1583.39014, 1741.54822,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2008, 1762.02661, -1583.37524, 1741.54822,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2190, 1760.82910, -1580.09387, 1742.36816,   0.00000, 0.00000, 342.00000);
    CreateDynamicObject(2190, 1767.27405, -1584.07324, 1742.36816,   0.00000, 0.00000, 259.99890);
    CreateDynamicObject(2776, 1762.89758, -1584.48608, 1742.01990,   0.00000, 0.00000, 184.00000);
    CreateDynamicObject(2776, 1759.99976, -1584.62109, 1742.01990,   0.00000, 0.00000, 183.99902);
    CreateDynamicObject(2776, 1756.96472, -1584.68237, 1742.01990,   0.00000, 0.00000, 183.99902);
    CreateDynamicObject(2776, 1760.12671, -1581.24402, 1742.01990,   0.00000, 0.00000, 135.99902);
    CreateDynamicObject(2776, 1765.60303, -1584.43689, 1742.01990,   0.00000, 0.00000, 147.99426);
    CreateDynamicObject(2602, 1758.99341, -1561.92603, 1734.46643,   0.00000, 0.00000, 268.00000);
    CreateDynamicObject(2602, 1763.21863, -1561.89966, 1734.46643,   0.00000, 0.00000, 267.99500);
    CreateDynamicObject(2602, 1767.51782, -1561.87219, 1734.46643,   0.00000, 0.00000, 267.99500);
    CreateDynamicObject(2602, 1771.80627, -1561.85754, 1734.46643,   0.00000, 0.00000, 267.99500);
    CreateDynamicObject(2602, 1776.07935, -1561.99622, 1734.46643,   0.00000, 0.00000, 267.99500);
    CreateDynamicObject(2602, 1780.05237, -1561.72046, 1734.46643,   0.00000, 0.00000, 267.99500);
    CreateDynamicObject(2602, 1780.11157, -1582.58887, 1734.46643,   0.00000, 0.00000, 267.99500);
    CreateDynamicObject(2602, 1775.85107, -1583.17676, 1734.46643,   0.00000, 0.00000, 267.99500);
    CreateDynamicObject(2602, 1771.56580, -1583.76807, 1734.46643,   0.00000, 0.00000, 267.99500);
    CreateDynamicObject(2602, 1767.33008, -1584.35205, 1734.46643,   0.00000, 0.00000, 267.99500);
    CreateDynamicObject(2602, 1762.99976, -1584.06531, 1734.46643,   0.00000, 0.00000, 267.99500);
    CreateDynamicObject(2602, 1758.80371, -1584.39087, 1734.46643,   0.00000, 0.00000, 267.99500);
    CreateDynamicObject(1800, 1756.03723, -1585.60107, 1733.94299,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1800, 1759.98682, -1585.61987, 1733.94299,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1800, 1764.23560, -1585.63989, 1733.94299,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1800, 1768.43604, -1585.66016, 1733.94299,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1800, 1772.66125, -1585.68079, 1733.94299,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1800, 1776.93542, -1585.70154, 1733.94299,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1800, 1777.15283, -1565.10754, 1733.94299,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1800, 1772.90210, -1565.10156, 1733.94299,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1800, 1768.62708, -1565.11926, 1733.94299,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1800, 1764.37671, -1565.11328, 1733.94299,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1800, 1760.10144, -1565.10632, 1733.94299,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1800, 1756.10107, -1565.09888, 1733.94299,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1800, 1756.03723, -1585.60107, 1737.64746,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2602, 1758.80371, -1584.39087, 1738.20081,   0.00000, 0.00000, 267.99500);
    CreateDynamicObject(1495, 1778.55017, -1579.07410, 1741.41895,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1495, 1781.39600, -1579.06104, 1741.41895,   0.00000, 0.00000, -180.23996);
    CreateDynamicObject(970, 1778.51648, -1577.00818, 1743.03491,   0.00000, 0.00000, 90.49438);
    CreateDynamicObject(1800, 1776.93542, -1585.70154, 1737.68250,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1800, 1772.78809, -1586.06726, 1737.68250,   0.00000, 0.00000, -0.66000);
    CreateDynamicObject(1800, 1768.59766, -1585.91821, 1737.68250,   0.00000, 0.00000, -0.66000);
    CreateDynamicObject(1800, 1764.39526, -1585.90637, 1737.68250,   0.00000, 0.00000, -0.66000);
    CreateDynamicObject(1800, 1760.09448, -1585.94922, 1737.68250,   0.00000, 0.00000, -0.66000);
}

CMD:prison(playerid, params[])
{
	new id, time, fine;

	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่ตำรวจเท่านั้น !");

	// if(!playerData[playerid][pOnDuty]) return SendClientMessage(playerid, COLOR_GRAD1,"   คุณยังไม่ได้เริ่มปฏิบัติหน้าที่");

	if(IsPlayerInRangeOfPoint(playerid, 6.0, 1775.7197,-1572.6295,1734.9430)) { // LSPD
		if(sscanf(params,"udd",id,time,fine)) return SendClientMessage(playerid, COLOR_LIGHTRED, "การใช้: /prison [ไอดีผู้เล่น/ชื่อบางส่วน] [เวลา(นาที)] [ค่าปรับ]");
		
		if(id == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

		if (id == playerid) return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่สามารถขังตัวเองได้");
		if (!IsPlayerNearPlayer(playerid, id, 5.0)) return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นไม่ได้อยู่ใกล้คุณ");

		//if(cell < 1 || cell > 5) return SendClientMessage(playerid, COLOR_GRAD2, "ห้องขังต้องไม่ต่ำกว่า 1 หรือมากกว่า 4");
		if(fine < 0 || fine > 500000) return SendClientMessage(playerid, COLOR_GRAD2, "ค่าปรับต้องไม่เกิน $500,000 หรือต่ำกว่า $0");
		if(time < 1 || time > 240) return SendClientMessage(playerid, COLOR_GRAD2, "เวลาต้องไม่มากกว่า 240 นาทีหรือต่ำกว่า 1 นาที");

		if(playerData[id][pJailed] == 2) return SendClientMessage(playerid, COLOR_LIGHTRED, "ผู้เล่นนั้นได้ถูกจับแล้ว");

	    BitFlag_Off(gPlayerBitFlag[id],IS_CUFFED);
	    //SetPlayerSpecialAction(id, SPECIAL_ACTION_NONE);
	    //RemovePlayerAttachedObject(id, FREESLOT9);
		GivePlayerMoneyEx(id, -fine);
		// FullResetPlayerWeapons(id);
		FullResetPlayerWeapons(id);
		playerData[id][pJailTime] = time * 60;
		playerData[id][pJailed] = 2;
		playerData[id][pArrested] += 1;
		//PutPlayerInCell(id, cell);

        new rd = random(sizeof(PrisonSpawns));
        SetPlayerPos(id, PrisonSpawns[rd][0], PrisonSpawns[rd][1], PrisonSpawns[rd][2]);
        //SetPlayerFacingAngle(playerid, RandomSpawns[Random][3]);

        SetPlayerInterior(id, 0);
        SetPlayerVirtualWorld(id, 0);

		TurnOffPhone(id);

		playerData[id][pWarrants] = 0;
		SetPlayerWantedLevel(id, 0);
		ClearCrime(id);

		if(gPlayerDrag[id] == playerid) {
			gPlayerDrag[id] = INVALID_PLAYER_ID;
		}
		
		new factionid = Faction_GetID(playerData[playerid][pFaction]);
		SendFactionTypeMessage(FACTION_TYPE_POLICE, COLOR_LIGHTBLUE, "[ห้องขัง] %s %s ได้คุมขัง %s เวลา %d นาที", Faction_GetRankName(factionid, playerData[playerid][pFactionRank]), ReturnRealName(playerid), ReturnRealName(id), time);

		SendClientMessageEx(id, COLOR_LIGHTRED, "[ ! ] จ่ายค่าปรับ $%d", fine, time);
		SendClientMessage(id, COLOR_LIGHTRED, "[ ! ] คำเตือน: คุณอยู่ในคุกดังนั้นโทรศัพท์ของคุณจึงถูกปิดและอย่าลืมเปิดเครื่องเมื่อออกจากคุก");
	}
	else SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่หน้าห้องขัง");

	return 1;
}

CMD:closeprison(playerid, params[]) {

	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่ตำรวจเท่านั้น !");

    if(systemVariables[PrisonStatus] == 0) {
	    systemVariables[PrisonStatus] = 1;
        SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ปิดให้นักโทษสามารถออกไปลานกว้างได้แล้ว !!");
	    //SendClientMessageToAll(COLOR_LIGHTRED, "ประกาศ : ขณะนี้เซิร์ฟเวอร์ได้ทำการปิดรับสมัครสมาชิกชั่วคราวแล้ว");
    }
    else {
		return SendClientMessage(playerid, COLOR_GRAD1, "ประตูสำหรับเรือนจำถูกปิดใช้งานแล้ว");
	}
    
	return 1;
}

CMD:openprison(playerid, params[]) {

	new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);
	if (factionType != FACTION_TYPE_POLICE && !playerData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_GRAD2,"   สำหรับเจ้าหน้าที่ตำรวจเท่านั้น !");

    if(systemVariables[PrisonStatus] == 1) {
	    systemVariables[PrisonStatus] = 0;
        SendClientMessage(playerid, COLOR_YELLOW, "คุณได้เปิดให้นักโทษสามารถออกไปลานกว้างได้แล้ว !!");
	    //SendClientMessageToAll(COLOR_LIGHTRED, "ประกาศ : ขณะนี้เซิร์ฟเวอร์ได้ทำการเปิดรับสมัครสมาชิกแล้ว, ขอให้ผู้เล่นใหม่ทุกท่านสนุกกับเซิร์ฟเวอร์ของเรา");
    }
    else {
		return SendClientMessage(playerid, COLOR_GRAD1, "ประตูสำหรับเรือนจำถูกเปิดใช้งานแล้ว");
	}
    
	return 1;
}
