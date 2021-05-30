#include <YSI\y_hooks>

/*


*/

CMD:gangwarinfo(playerid) {

    SendClientMessage(playerid, COLOR_GRAD1, "|_______________________วอร์ชิงถุง_______________________|");

    SendClientMessage(playerid, COLOR_GRAD2, "วิธีเปิดแก๊งค์");
    SendClientMessage(playerid, COLOR_GRAD1, " * เงื่อนไขในการเปิดแก๊งค์ใช้คนจำนวน 4 คน พร้อมเงิน 300k !!");
    SendClientMessage(playerid, COLOR_GRAD1, " /ganghelp คำสั่งต่าง ๆ เกี่ยวกับแก๊งค์");
    SendClientMessage(playerid, COLOR_GRAD1, " 	1. รับคนเข้าแก๊งค์ได้โดย /invite เสียครั้งละ 500k (ซื้อเพิ่มได้จาก /gangupgrade)");
    SendClientMessage(playerid, COLOR_GRAD1, " 	2. ทรัพยากรต่าง ๆ (อาวุธ/อาหาร)");
    SendClientMessage(playerid, COLOR_GRAD1, "    - ลักลอบ/ดักปล้น จาก EVENT พิเศษ");
    SendClientMessage(playerid, COLOR_GRAD1, "    - อาวุธบางชิ้นต้องสั่งซื้อจากตลาดมืด");
    SendClientMessage(playerid, COLOR_GRAD1, "    - สั่งซื้อผ่าน /gangupgrade");
    SendClientMessage(playerid, COLOR_GRAD1, "");
    SendClientMessage(playerid, COLOR_GRAD2, "วิธีการวอร์");
    SendClientMessage(playerid, COLOR_GRAD1, " คำสั่งที่จำเป็นต้องใช้ในการวอ์");
    SendClientMessage(playerid, COLOR_GRAD1, " /gangattack (พังประตู), /gangupgrade (ซ่อมประตู)");
    SendClientMessage(playerid, COLOR_GRAD1, " - เป้าหมายคือการบุก/ป้องกันประตูบ้าน");
    SendClientMessage(playerid, COLOR_GRAD1, " - การพังประตูบ้านต้องยืนหน้าประตูไม่ต่ำกว่า 4 คนในวงสีแดง (หน่วงเวลา 3 นาที/ครั้ง)");
    SendClientMessage(playerid, COLOR_GRAD1, " - เมื่อบ้านของคุณถูกโจมตีสามารถซ่อมประตูได้เพื่อเพิ่มพลังป้องกัน (หน่วงเวลา 12 นาที/ครั้ง)");
    SendClientMessage(playerid, COLOR_GRAD1, " - เมื่อประตูบ้านเปิดแล้วให้วิ่งเข้าไปชนถุงของศัตรู เมื่อได้ถุงเงินแล้วให้วิ่งมาชนถุงของแก๊งค์ตัวเอง");
    SendClientMessage(playerid, COLOR_GRAD1, "     อธิบายเพิ่มเติม: เมื่อตัวละครของคุณชิงถุงมาได้แล้ว ตัวละครของคุณจะสะพายถุงเงินพร้อมกับถูกทำเครื่องหมายบนหัว");
    SendClientMessage(playerid, COLOR_GRAD1, " ใช้ /war เพื่อท้าวอร์ (เงื่อนไขต้องครบทั้งสองฝ่าย)");
    SendClientMessage(playerid, COLOR_GRAD1, "");
    SendClientMessage(playerid, COLOR_GRAD2, "กฎการวอร์");
    SendClientMessage(playerid, COLOR_GRAD1, " 1. ห้ามใช้พาหนะที่ไม่ได้อยู่ในแฟคชั่นเข้าร่วมวอร์เด็ดขาด");
    SendClientMessage(playerid, COLOR_GRAD1, " 2. ห้าม ESC หรือนำของไปขวางหน้าประตู");
    SendClientMessage(playerid, COLOR_GRAD1, " 3. ห้ามใช้บัค/โปรแกรมช่วยเล่นอย่างเด็ดขาด");

    return 1;
}