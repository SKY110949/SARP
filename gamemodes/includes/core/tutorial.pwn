/*
//--------------------------------[TUTORIAL.PWN]--------------------------------
*/

#include <YSI\y_hooks> 


hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetPVarInt(playerid, "TutorialStep"))
	{
	    if(RELEASED(KEY_SPRINT)) // บทเรียนไปข้างหน้า
	    {
			NextTutorial(playerid);
	    }
	    else if(RELEASED(KEY_JUMP)) // บทเรียนถอยหลัง
	    {
	        PreviewTutorial(playerid);
	    }
    }
	return 1;
}


initiateTutorial(playerid)
{
    ClearChatBox(playerid);
	SetPVarInt(playerid, "TutorialStep", 1);
    SendClientMessage(playerid, -1, "• ยินดีต้อนรับเข้าสู่ SA:RP");
    SendClientMessageEx(playerid, COLOR_GRAD, "บทเรียนวีดิทัศน์นี้จะแนะนำคุณสำหรับก้าวแรกบน %s", playerData[playerid][pSpawnPoint] == 2 ? ("Los Santos") : ("San Fierro"));
    SendClientMessage(playerid, COLOR_GRAD, "เราขอแนะนำให้คุณใช้เวลาอ่านมัน");
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);

	if (playerData[playerid][pSpawnPoint] == 2) {
		SetPlayerCameraPos(playerid, 1541.1512,-2287.1345,91.9661);
		SetPlayerCameraLookAt(playerid, 1623.3582,-2288.0413,77.9914);
	}
	else {
		SetPlayerCameraPos(playerid, -2564.2397,-816.2410,229.4705);
		SetPlayerCameraLookAt(playerid, -2506.4133,-704.2995,192.9581);
	}

	Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
	return 1;
}

Dialog:DialogTutorial(playerid, response, listitem, inputtext[]) {
	if (!response) {
		NextTutorial(playerid);
	}
	else {
		PreviewTutorial(playerid);
	}
	return 1;
}
/*
hook OnPlayerText(playerid, text[]) {
	if(GetPVarInt(playerid, "TutorialStep"))
	{
	    if(isequal(text, ">")) // บทเรียนไปข้างหน้า
	    {
			NextTutorial(playerid);
	    }
	    else if(isequal(text, "<")) // บทเรียนถอยหลัง
	    {
	        PreviewTutorial(playerid);
	    }
		return -1;
    }
	return 0;
}*/

NextTutorial(playerid) {

	SetPVarInt(playerid, "TutorialStep", GetPVarInt(playerid, "TutorialStep")+1);
	ClearChatBox(playerid);

	if (playerData[playerid][pSpawnPoint] == 2) {
		switch(GetPVarInt(playerid, "TutorialStep"))
    	{
    	    case 2: {

			    SendClientMessage(playerid, COLOR_GRAD3, "ตู้หนังสือพิมพ์ตั้งอยู่ติดกับ El Corona Motel จุดเกิดในปัจจุบันของคุณ");
			    SendClientMessage(playerid, COLOR_GRAD3, "ไปที่เครื่องหมาย 'i' และพิมพ์ /newspaper เพื่ออ่าน");

			    SendClientMessage(playerid, COLOR_WHITE, "");
			    SendClientMessage(playerid, COLOR_WHITE, "");
			    SendClientMessage(playerid, COLOR_WHITE, "");
			    SendClientMessage(playerid, COLOR_WHITE, "");

			    SendClientMessage(playerid, COLOR_WHITE, "• ครั้งแรกในเมืองลอสแซนโตส");
			    SendClientMessage(playerid, COLOR_GRAD3, "ยินดีต้อนรับเข้าสู่เมืองลอสแซนโตส เมืองที่ใหญ่ที่สุดในรัฐซานแอนเดรียส");
			    SendClientMessage(playerid, COLOR_GRAD3, "ขณะนี้คุณอาศัยอยู่ที่ El Corona Motel จนกว่าคุณจะหาสถานที่ที่ดีกว่าด้วยตัวคุณเอง");
			    SendClientMessage(playerid, COLOR_GRAD3, "คุณอาจต้องการที่จะเริ่มต้นด้วยการอ่านหนังสือพิมพ์ของวันนี้ ที่คุณสามารถหาข้อมูลบางอย่างที่เป็นประโยชน์");

    	        InterpolateCameraPos(playerid, 1541.1512,-2287.1345,91.9661, 1715.7267,-1932.2345,20.3447, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 1623.3582,-2288.0413,77.9914, 1731.9973,-1912.0378,13.5624, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 1715.7267,-1932.2345,20.3447, 1731.9973,-1912.0378,13.5624);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
    	    case 3: {

			    SendClientMessage(playerid, COLOR_WHITE, "• การขนส่ง");
			    SendClientMessage(playerid, COLOR_GRAD3, "เพื่อเคลื่อนตัวไปรอบ ๆ เมือง คุณจะต้องพาตัวเองนั่งรถ");
			    SendClientMessage(playerid, COLOR_GRAD3, "คุณสามารถรอรถบัสเรียกแท็กซี่หรือเช่ารถ และใช้เงินจำนวนหนึ่ง");
			    SendClientMessage(playerid, COLOR_GRAD3, "โทร 544 เพื่อใช้บริการแท็กซี่หรือรอรถบัสตามบูธ รถยนต์ให้เช่าสามารถพบได้รอบ ๆ เมือง");

    	        GameTextForPlayer(playerid, "~p~/call 544 ~w~to call~n~~y~los santos & san fierro public transportation service", 20000, 3);

    	        InterpolateCameraPos(playerid, 1715.7267,-1932.2345,20.3447, 1807.2902,-1939.7085,67.2748, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 1731.9973,-1912.0378,13.5624, 1773.8251,-1902.2825,13.5502, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 1807.2902,-1939.7085,67.2748, 1773.8251,-1902.2825,13.5502);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
    	    case 4: {

			    SendClientMessage(playerid, COLOR_WHITE, "• อยู่ได้ด้วยตัวเอง");
			    SendClientMessage(playerid, COLOR_GRAD3, "เมื่อคุณรู้สึกว่ามันถึงเวลาที่จะย้ายออกจาก El Corona Motel ไปยังสถานที่ของคุณเอง คุณควรเริ่มมองหาบ้านใหม่หรือโมเต็ลที่อื่น");
			    SendClientMessage(playerid, COLOR_GRAD3, "มีบ้านมากมายอยู่อยู่รอบ ๆ เมืองลอสแซนโตส ซึ่งสามารถซื้อหรือเช่าได้ทุกคนโดยการแลกเปลี่ยนเงินบางส่วนเท่านั้น");
			    SendClientMessage(playerid, COLOR_GRAD3, "นอกจากนี้ยังมีไม่กี่โรงแรมและโมเต็ลรอบ ๆ เมืองที่คุณสามารถเช่าห้องพักได้แค่บางช่วง");

    	        GameTextForPlayer(playerid, "~y~Idlewood motel~n~~w~(~p~/rent~w~) or (~p~/rentroom~w~)", 20000, 3);

    	        InterpolateCameraPos(playerid, 1807.2902,-1939.7085,67.2748, 2119.4541,-1751.1744,21.5524, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 1773.8251,-1902.2825,13.5502, 2155.6519,-1776.4888,18.5486, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 2119.4541,-1751.1744,21.5524, 2155.6519,-1776.4888,18.5486);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
    	    case 5: {

			    SendClientMessage(playerid, COLOR_WHITE, "• รักษาสุขภาพ");
			    SendClientMessage(playerid, COLOR_GRAD3, "พยายามที่จะให้ชีวิตของคุณมีสุขภาพที่ดีและกินให้ตรงเวลา คุณจะเริ่มสูญเสีย HP อย่างต่อเนื่องเมื่อตัวละครของคุณหิว");
			    SendClientMessage(playerid, COLOR_GRAD3, "การใช้ยาเสพติดมันอาจจะลด HP ของคุณ เพิ่มระดับความหิวของคุณ และยังจะทำให้คุณป่วยหรือเสียชีวิต");
			    SendClientMessage(playerid, COLOR_GRAD3, "มีร้านอาหารหลายแห่งทั่วเมืองที่คุณสามารถกินเพื่อเพิ่ม HP ของคุณและลดระดับความหิวของคุณ");

    	        GameTextForPlayer(playerid, "~y~Idlewood pizza stack~n~~w~(~p~/eat~w~)", 20000, 3);

    	        InterpolateCameraPos(playerid, 2119.4541,-1751.1744,21.5524, 2070.5469,-1834.5552,30.9983, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 2155.6519,-1776.4888,18.5486, 2108.1138,-1779.3624,13.3898, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 2070.5469,-1834.5552,30.9983, 2108.1138,-1779.3624,13.3898);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
    	    case 6: {

			    SendClientMessage(playerid, COLOR_WHITE, "• บริการสาธารณะ");
				SendClientMessage(playerid, COLOR_GRAD, "งานบริการสาธารณะแห่งเมืองลอสแซนโตสก็คงให้บริการเสมอ เมื่อไหร่ที่คุณต้องที่จะใช่บริการพวกเขา");
    	        SendClientMessage(playerid, COLOR_GRAD, "นั้นก็คือ {8D8DFF}Los Santos & San Fierro Police Department");
				SendClientMessage(playerid, COLOR_GRAD, "{FF8282}Los Santos & San Fierro Fire Department"EMBED_GRAD" มีหน้าในการรับผิดชอบด้านรักษาสุขภาพและช่วยเหลือปฐมพยาบาลผู้เจ็บป่วย ");
    	        SendClientMessage(playerid, COLOR_GRAD, "พวกเขาประสานงานกับโรงพยาบาลและหน่วยกู้ภัยทั้งคู่");
				SendClientMessage(playerid, COLOR_GRAD, "ถ้าคุณต้องการหน่วยงานใดๆดังกล่าวในตามชื่อนี้อย่ามัวลังเลกรุณาโทรหรือติดต่อไปที่ 911 และเรียกพวกเขาเพื่อให้มาช่วยเหลือคุณ");

    	        GameTextForPlayer(playerid, "~w~San Andreas~n~Department", 4000, 3);

    	        InterpolateCameraPos(playerid, 1744.5216,-1693.8655,52.5560, 667.7610,-608.4394,38.1223, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 1774.4377,-1658.4363,30.9402, 618.0063,-574.8521,26.1432, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 667.7610,-608.4394,38.1223, 618.0063,-574.8521,26.1432);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
    	    case 7: {
			    SendClientMessage(playerid, COLOR_WHITE, "• ข้อสรุป:");
			    SendClientMessage(playerid, COLOR_GRAD3, "ต้องจดจำไว้เสมอว่าคุณต้องปฏิบัติตามกฎของเซิร์ฟเวอร์ทุกข้อให้ความเคารพหรือเกียรติแก่ผู้เล่นทุกคนและฟังคำแนะนำจากผู้ดูแลเซิร์ฟเวอร์");
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 8: { // End Tutorial
				DeletePVar(playerid, "TutorialStep");
				SendClientMessage(playerid, COLOR_GRAD, "คุณได้รับบทเรียนวีดิทัศน์เรียบร้อยแล้ว");
				Dialog_Close(playerid);
				Dialog_Show(playerid, StarterModel, DIALOG_STYLE_LIST, "โปรดเลือกสกินเริ่มต้นของคุณ", "ตัวละครเพศชาย\nตัวละครเพศหญิง", "เลือก", "");
			}
    	}
	}
	else {
		switch(GetPVarInt(playerid, "TutorialStep"))
		{
			case 2: {

				SendClientMessage(playerid, COLOR_GRAD, "ตู้หนังสือพิมพ์ตั้งอยู่ติดกับ Doherty Motel จุดเกิดในปัจจุบันของคุณ");
				SendClientMessage(playerid, COLOR_GRAD, "ไปที่เครื่องหมาย 'i' และพิมพ์ /newspaper เพื่ออ่าน");

				SendClientMessage(playerid, -1, "");
				SendClientMessage(playerid, -1, "");
				SendClientMessage(playerid, -1, "");
				SendClientMessage(playerid, -1, "");


				SendClientMessage(playerid, -1, "• ครั้งแรกในเมือง San Fierro");
				SendClientMessage(playerid, COLOR_GRAD, "ยินดีต้อนรับเข้าสู่เมืองแซนเฟอร์โร เมืองที่เล็กที่สุดในรัฐซานแอนเดรียส");
				SendClientMessage(playerid, COLOR_GRAD, "ขณะนี้คุณอาศัยอยู่ที่ Doherty Motel จนกว่าคุณจะหาสถานที่ที่ดีกว่าด้วยตัวคุณเอง");
				SendClientMessage(playerid, COLOR_GRAD, "คุณอาจต้องการที่จะเริ่มต้นด้วยการอ่านหนังสือพิมพ์ของวันนี้ ที่คุณสามารถหาข้อมูลบางอย่างที่เป็นประโยชน์");

				InterpolateCameraPos(playerid, -2564.2397,-816.2410,229.4705, -2012.8434,-73.1334,48.6836, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -2506.4133,-704.2995,192.9581, -2027.7747,-41.3567,38.8047, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -2012.8434,-73.1334,48.6836, -2027.7747,-41.3567,38.8047);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 3: {

				SendClientMessage(playerid, -1, "• การขนส่ง");
				SendClientMessage(playerid, COLOR_GRAD, "เพื่อเคลื่อนตัวไปรอบ ๆ เมือง คุณจะต้องพาตัวเองนั่งรถ");
				SendClientMessage(playerid, COLOR_GRAD, "คุณสามารถรอรถบัสเรียกแท็กซี่หรือเช่ารถ และใช้เงินจำนวนหนึ่ง");
				SendClientMessage(playerid, COLOR_GRAD, "โทร 544 เพื่อใช้บริการแท็กซี่หรือรอรถบัสตามบูธ รถยนต์ให้เช่าสามารถพบได้รอบ ๆ เมือง");

				GameTextForPlayer(playerid, "~p~/call 544 ~w~to call~n~~y~san fierro public transportation service", 20000, 3);

				InterpolateCameraPos(playerid, -2012.8434,-73.1334,48.6836, -2078.0098,32.5450,45.9552, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -2027.7747,-41.3567,38.8047, -2055.3335,8.0542,35.3281, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -2078.0098,32.5450,45.9552, -2055.3335,8.0542,35.3281);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 4: {

				SendClientMessage(playerid, -1, "• อยู่ได้ด้วยตัวเอง");
				SendClientMessage(playerid, COLOR_GRAD, "เมื่อคุณรู้สึกว่ามันถึงเวลาที่จะย้ายออกจาก Doherty Motel ไปยังสถานที่ของคุณเอง คุณควรเริ่มมองหาบ้านใหม่หรือโมเต็ลที่อื่น");
				SendClientMessage(playerid, COLOR_GRAD, "มีบ้านมากมายอยู่อยู่รอบ ๆ เมืองแซนเฟอร์โร ซึ่งสามารถซื้อหรือเช่าได้ทุกคนโดยการแลกเปลี่ยนเงินบางส่วนเท่านั้น");
				SendClientMessage(playerid, COLOR_GRAD, "นอกจากนี้ยังมีไม่กี่โรงแรมและโมเต็ลรอบ ๆ เมืองที่คุณสามารถเช่าห้องพักได้แค่บางช่วง");

				GameTextForPlayer(playerid, "~y~Garcia Motel~n~~w~(~p~/rent~w~) or (~p~/rentroom~w~)", 20000, 3);

				InterpolateCameraPos(playerid, -2078.0098,32.5450,45.9552, -2154.9983,-65.2416,45.5149, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -2055.3335,8.0542,35.3281, -2176.3682,-42.3011,35.3125, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -2154.9983,-65.2416,45.5149, -2176.3682,-42.3011,35.3125);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 5: {

				SendClientMessage(playerid, -1, "• รักษาสุขภาพ");
				SendClientMessage(playerid, COLOR_GRAD, "พยายามที่จะให้ชีวิตของคุณมีสุขภาพที่ดีและกินให้ตรงเวลา คุณจะเริ่มสูญเสีย HP อย่างต่อเนื่องเมื่อตัวละครของคุณหิว");
				SendClientMessage(playerid, COLOR_GRAD, "การใช้ยาเสพติดมันอาจจะลด HP ของคุณ เพิ่มระดับความหิวของคุณ และยังจะทำให้คุณป่วยหรือเสียชีวิต");
				SendClientMessage(playerid, COLOR_GRAD, "มีร้านอาหารหลายแห่งทั่วเมืองที่คุณสามารถกินเพื่อเพิ่ม HP ของคุณและลดระดับความหิวของคุณ");

				GameTextForPlayer(playerid, "~y~Garcia Burger Shot~n~~w~(~p~/eat~w~)", 20000, 3);

				InterpolateCameraPos(playerid, -2154.9983,-65.2416,45.5149, -2292.7346,-197.3345,55.2711, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -2176.3682,-42.3011,35.3125, -2336.6841,-166.7888,35.5547, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -2292.7346,-197.3345,55.2711, -2336.6841,-166.7888,35.5547);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 6: {

				SendClientMessage(playerid, -1, "• การเงิน");
				SendClientMessage(playerid, COLOR_GRAD, "สังคมของเมืองแซนเฟอร์โร ต่างคนต่างเลือกใช้ชีวิตและเริ่มจากการวางแผนการเงินที่ดี");
				SendClientMessage(playerid, COLOR_GRAD, "คุณยอมที่จะนำเงินก้อนมาฝากกับธนาคารเพื่อรับดอกเบี้ยที่มากขึ้นไหมล่ะ? หรือจะนำไปหมุนในชีวิตประจำวันก่อน");
				SendClientMessage(playerid, COLOR_GRAD, "");

				GameTextForPlayer(playerid, "~w~Central Bank of San Fierro", 4000, 3);

				InterpolateCameraPos(playerid, -2292.7346,-197.3345,55.2711, -1597.3508,848.2234,17.7428, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -2336.6841,-166.7888,35.5547, -1619.1672,865.4321,7.6953, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -1597.3508,848.2234,17.7428, -1619.1672,865.4321,7.6953);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 7: {
				SendClientMessage(playerid, -1, "• ข้อสรุป:");
				SendClientMessage(playerid, COLOR_GRAD, "ต้องจดจำไว้เสมอว่าคุณต้องปฏิบัติตามกฎของเซิร์ฟเวอร์ทุกข้อให้ความเคารพหรือเกียรติแก่ผู้เล่นทุกคนและฟังคำแนะนำจากผู้ดูแลเซิร์ฟเวอร์");

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", "จบวีดิทัศน์", GetPVarInt(playerid, "TutorialStep"));
			}
			case 8: { // End Tutorial

				DeletePVar(playerid, "TutorialStep");
				SendClientMessage(playerid, COLOR_GRAD, "คุณได้รับบทเรียนวีดิทัศน์เรียบร้อยแล้ว");
				Dialog_Close(playerid);
				Dialog_Show(playerid, StarterModel, DIALOG_STYLE_LIST, "โปรดเลือกสกินเริ่มต้นของคุณ", "ตัวละครเพศชาย\nตัวละครเพศหญิง", "เลือก", "");
			}
		}
	}
	return 1;
}

PreviewTutorial(playerid) {
	if(GetPVarInt(playerid, "TutorialStep") == 1)
	{
	    PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
	    return 1;
	}

	SetPVarInt(playerid, "TutorialStep", GetPVarInt(playerid, "TutorialStep")-1);
 	ClearChatBox(playerid);

	if (playerData[playerid][pSpawnPoint] == 2) {
		switch(GetPVarInt(playerid, "TutorialStep"))
    	{
    	    case 1: {
			    SendClientMessage(playerid, COLOR_WHITE, "");
			    SendClientMessage(playerid, COLOR_GRAD3, "บทเรียนวีดิทัศน์นี้จะแนะนำคุณสำหรับก้าวแรกบน Los Santos");
			    SendClientMessage(playerid, COLOR_GRAD3, "เราขอแนะนำให้คุณใช้เวลาอ่านมัน");

    	        InterpolateCameraPos(playerid, 1715.7267,-1932.2345,20.3447, 1541.1512,-2287.1345,91.9661, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 1731.9973,-1912.0378,13.5624, 1623.3582,-2288.0413,77.9914, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 1541.1512,-2287.1345,91.9661, 1623.3582,-2288.0413,77.9914);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
    	    case 2: {
			
			    SendClientMessage(playerid, COLOR_GRAD3, "ตู้หนังสือพิมพ์ตั้งอยู่ติดกับ El Corona Motel จุดเกิดในปัจจุบันของคุณ");
			    SendClientMessage(playerid, COLOR_GRAD3, "ไปที่เครื่องหมาย 'i' และพิมพ์ /newspaper เพื่ออ่าน");

			    SendClientMessage(playerid, COLOR_WHITE, "");
			    SendClientMessage(playerid, COLOR_WHITE, "");
			    SendClientMessage(playerid, COLOR_WHITE, "");
			    SendClientMessage(playerid, COLOR_WHITE, "");

			    SendClientMessage(playerid, COLOR_WHITE, "• ครั้งแรกในเมืองลอสแซนโตส");
			    SendClientMessage(playerid, COLOR_GRAD3, "ยินดีต้อนรับเข้าสู่เมืองลอสแซนโตส เมืองที่ใหญ่ที่สุดในรัฐซานแอนเดรียส");
			    SendClientMessage(playerid, COLOR_GRAD3, "ขณะนี้คุณอาศัยอยู่ที่ El Corona Motel จนกว่าคุณจะหาสถานที่ที่ดีกว่าด้วยตัวคุณเอง");
			    SendClientMessage(playerid, COLOR_GRAD3, "คุณอาจต้องการที่จะเริ่มต้นด้วยการอ่านหนังสือพิมพ์ของวันนี้ ที่คุณสามารถหาข้อมูลบางอย่างที่เป็นประโยชน์");

    	        InterpolateCameraPos(playerid, 1807.2902,-1939.7085,67.2748, 1715.7267,-1932.2345,20.3447, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 1773.8251,-1902.2825,13.5502, 1731.9973,-1912.0378,13.5624, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 1715.7267,-1932.2345,20.3447, 1731.9973,-1912.0378,13.5624);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));

			}
    	    case 3: {

			    SendClientMessage(playerid, COLOR_WHITE, "• การขนส่ง");
			    SendClientMessage(playerid, COLOR_GRAD3, "เพื่อเคลื่อนตัวไปรอบ ๆ เมือง คุณจะต้องพาตัวเองนั่งรถ");
			    SendClientMessage(playerid, COLOR_GRAD3, "คุณสามารถรอรถบัสเรียกแท็กซี่หรือเช่ารถ และใช้เงินจำนวนหนึ่ง");
			    SendClientMessage(playerid, COLOR_GRAD3, "โทร 544 เพื่อใช้บริการแท็กซี่หรือรอรถบัสตามบูธ รถยนต์ให้เช่าสามารถพบได้รอบ ๆ เมือง");

    	        GameTextForPlayer(playerid, "~p~/call 544 ~w~to call~n~~y~los santos & san fieror public transportation service", 20000, 3);

    	        InterpolateCameraPos(playerid, 2119.4541,-1751.1744,21.5524, 1807.2902,-1939.7085,67.2748, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 2155.6519,-1776.4888,18.5486, 1773.8251,-1902.2825,13.5502, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 1807.2902,-1939.7085,67.2748, 1773.8251,-1902.2825,13.5502);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
    	    case 4: {

			    SendClientMessage(playerid, COLOR_WHITE, "• อยู่ได้ด้วยตัวเอง");
			    SendClientMessage(playerid, COLOR_GRAD3, "เมื่อคุณรู้สึกว่ามันถึงเวลาที่จะย้ายออกจาก El Corona Motel ไปยังสถานที่ของคุณเอง คุณควรเริ่มมองหาบ้านใหม่หรือโมเต็ลที่อื่น");
			    SendClientMessage(playerid, COLOR_GRAD3, "มีบ้านมากมายอยู่อยู่รอบ ๆ เมืองลอสแซนโตส ซึ่งสามารถซื้อหรือเช่าได้ทุกคนโดยการแลกเปลี่ยนเงินบางส่วนเท่านั้น");
			    SendClientMessage(playerid, COLOR_GRAD3, "นอกจากนี้ยังมีไม่กี่โรงแรมและโมเต็ลรอบ ๆ เมืองที่คุณสามารถเช่าห้องพักได้แค่บางช่วง");

    	        GameTextForPlayer(playerid, "~y~Idlewood motel~n~~w~(~p~/rent~w~) or (~p~/rentroom~w~)", 20000, 3);

    	        InterpolateCameraPos(playerid, 2070.5469,-1834.5552,30.9983, 2119.4541,-1751.1744,21.5524, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 2108.1138,-1779.3624,13.3898, 2155.6519,-1776.4888,18.5486, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 2119.4541,-1751.1744,21.5524, 2155.6519,-1776.4888,18.5486);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
    	    case 5: {

			    SendClientMessage(playerid, COLOR_WHITE, "• รักษาสุขภาพ");
			    SendClientMessage(playerid, COLOR_GRAD3, "พยายามที่จะให้ชีวิตของคุณมีสุขภาพที่ดีและกินให้ตรงเวลา คุณจะเริ่มสูญเสีย HP อย่างต่อเนื่องเมื่อตัวละครของคุณหิว");
			    SendClientMessage(playerid, COLOR_GRAD3, "การใช้ยาเสพติดมันอาจจะลด HP ของคุณ เพิ่มระดับความหิวของคุณ และยังจะทำให้คุณป่วยหรือเสียชีวิต");
			    SendClientMessage(playerid, COLOR_GRAD3, "มีร้านอาหารหลายแห่งทั่วเมืองที่คุณสามารถกินเพื่อเพิ่ม HP ของคุณและลดระดับความหิวของคุณ");

				GameTextForPlayer(playerid, "~y~Idlewood pizza stack~n~~w~(~p~/eat~w~)", 20000, 3);

    	        InterpolateCameraPos(playerid, 1129.1364,-1359.0806,60.4063, 2070.5469,-1834.5552,30.9983, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 1129.1011,-1488.4135,22.7614, 2108.1138,-1779.3624,13.3898, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 2070.5469,-1834.5552,30.9983, 2108.1138,-1779.3624,13.3898);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
    	    case 6: {
			    SendClientMessage(playerid, COLOR_WHITE, "• บริการสาธารณะ");
				SendClientMessage(playerid, COLOR_GRAD, "งานบริการสาธารณะแห่งเมืองลอสแซนโตสก็คงให้บริการเสมอ เมื่อไหร่ที่คุณต้องที่จะใช่บริการพวกเขา");
    	        SendClientMessage(playerid, COLOR_GRAD, "นั้นก็คือ {8D8DFF}Los Santos & San Fierro Police Department");
				SendClientMessage(playerid, COLOR_GRAD, "{FF8282}Los Santos & San Fierro Fire Department"EMBED_GRAD" มีหน้าในการรับผิดชอบด้านรักษาสุขภาพและช่วยเหลือปฐมพยาบาลผู้เจ็บป่วย ");
    	        SendClientMessage(playerid, COLOR_GRAD, "พวกเขาประสานงานกับโรงพยาบาลและหน่วยกู้ภัยทั้งคู่");
				SendClientMessage(playerid, COLOR_GRAD, "ถ้าคุณต้องการหน่วยงานใดๆดังกล่าวในตามชื่อนี้อย่ามัวลังเลกรุณาโทรหรือติดต่อไปที่ 911 และเรียกพวกเขาเพื่อให้มาช่วยเหลือคุณ");

    	        GameTextForPlayer(playerid, "~w~San Andreas~n~Department", 4000, 3);

    	        InterpolateCameraPos(playerid, 1474.6232,-1723.1591,42.9895, 667.7610,-608.4394,38.1223, 1500, CAMERA_MOVE);
    	        InterpolateCameraLookAt(playerid, 1480.6512,-1771.0350,31.6094, 618.0063,-574.8521,26.1432, 1500, CAMERA_MOVE);

				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, 667.7610,-608.4394,38.1223, 618.0063,-574.8521,26.1432);
				
				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
		}
	}
	else {
		switch(GetPVarInt(playerid, "TutorialStep"))
		{
			case 1: {
				SendClientMessage(playerid, -1, "• ยินดีต้อนรับเข้าสู่ SA:RP");
				SendClientMessage(playerid, COLOR_GRAD, "บทเรียนวีดิทัศน์นี้จะแนะนำคุณสำหรับก้าวแรกบน San Fierro");
				SendClientMessage(playerid, COLOR_GRAD, "เราขอแนะนำให้คุณใช้เวลาอ่านมัน");

				InterpolateCameraPos(playerid, -2012.8434,-73.1334,48.6836, -2564.2397,-816.2410,229.4705, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -2027.7747,-41.3567,38.8047, -2506.4133,-704.2995,192.9581, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -2564.2397,-816.2410,229.4705, -2506.4133,-704.2995,192.9581);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 2: {

				SendClientMessage(playerid, COLOR_GRAD, "ตู้หนังสือพิมพ์ตั้งอยู่ติดกับ Doherty Motel จุดเกิดในปัจจุบันของคุณ");
				SendClientMessage(playerid, COLOR_GRAD, "ไปที่เครื่องหมาย 'i' และพิมพ์ /newspaper เพื่ออ่าน");

				SendClientMessage(playerid, -1, "");
				SendClientMessage(playerid, -1, "");
				SendClientMessage(playerid, -1, "");
				SendClientMessage(playerid, -1, "");


				SendClientMessage(playerid, -1, "• ครั้งแรกในเมือง San Fierro");
				SendClientMessage(playerid, COLOR_GRAD, "ยินดีต้อนรับเข้าสู่เมืองแซนเฟอร์โร เมืองที่เล็กที่สุดในรัฐซานแอนเดรียส");
				SendClientMessage(playerid, COLOR_GRAD, "ขณะนี้คุณอาศัยอยู่ที่ Doherty Motel จนกว่าคุณจะหาสถานที่ที่ดีกว่าด้วยตัวคุณเอง");
				SendClientMessage(playerid, COLOR_GRAD, "คุณอาจต้องการที่จะเริ่มต้นด้วยการอ่านหนังสือพิมพ์ของวันนี้ ที่คุณสามารถหาข้อมูลบางอย่างที่เป็นประโยชน์");

				InterpolateCameraPos(playerid, -2078.0098,32.5450,45.9552, -2012.8434,-73.1334,48.6836, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -2055.3335,8.0542,35.3281, -2027.7747,-41.3567,38.8047, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -2012.8434,-73.1334,48.6836, -2027.7747,-41.3567,38.8047);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 3: {

				SendClientMessage(playerid, -1, "• การขนส่ง");
				SendClientMessage(playerid, COLOR_GRAD, "เพื่อเคลื่อนตัวไปรอบ ๆ เมือง คุณจะต้องพาตัวเองนั่งรถ");
				SendClientMessage(playerid, COLOR_GRAD, "คุณสามารถรอรถบัสเรียกแท็กซี่หรือเช่ารถ และใช้เงินจำนวนหนึ่ง");
				SendClientMessage(playerid, COLOR_GRAD, "โทร 544 เพื่อใช้บริการแท็กซี่หรือรอรถบัสตามบูธ รถยนต์ให้เช่าสามารถพบได้รอบ ๆ เมือง");

				GameTextForPlayer(playerid, "~p~/call 544 ~w~to call~n~~y~san fierro public transportation service", 20000, 3);

				InterpolateCameraPos(playerid, -2154.9983,-65.2416,45.5149, -2078.0098,32.5450,45.9552, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -2176.3682,-42.3011,35.3125, -2055.3335,8.0542,35.3281, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -2078.0098,32.5450,45.9552, -2055.3335,8.0542,35.3281);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 4: {

				SendClientMessage(playerid, -1, "• อยู่ได้ด้วยตัวเอง");
				SendClientMessage(playerid, COLOR_GRAD, "เมื่อคุณรู้สึกว่ามันถึงเวลาที่จะย้ายออกจาก Doherty Motel ไปยังสถานที่ของคุณเอง คุณควรเริ่มมองหาบ้านใหม่หรือโมเต็ลที่อื่น");
				SendClientMessage(playerid, COLOR_GRAD, "มีบ้านมากมายอยู่อยู่รอบ ๆ เมืองแซนเฟอร์โร ซึ่งสามารถซื้อหรือเช่าได้ทุกคนโดยการแลกเปลี่ยนเงินบางส่วนเท่านั้น");
				SendClientMessage(playerid, COLOR_GRAD, "นอกจากนี้ยังมีไม่กี่โรงแรมและโมเต็ลรอบ ๆ เมืองที่คุณสามารถเช่าห้องพักได้แค่บางช่วง");

				GameTextForPlayer(playerid, "~y~Garcia Motel~n~~w~(~p~/rent~w~) or (~p~/rentroom~w~)", 20000, 3);

				InterpolateCameraPos(playerid, -2292.7346,-197.3345,55.2711, -2154.9983,-65.2416,45.5149, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -2336.6841,-166.7888,35.5547, -2176.3682,-42.3011,35.3125, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -2154.9983,-65.2416,45.5149, -2176.3682,-42.3011,35.3125);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 5: {

				SendClientMessage(playerid, -1, "• รักษาสุขภาพ");
				SendClientMessage(playerid, COLOR_GRAD, "พยายามที่จะให้ชีวิตของคุณมีสุขภาพที่ดีและกินให้ตรงเวลา คุณจะเริ่มสูญเสีย HP อย่างต่อเนื่องเมื่อตัวละครของคุณหิว");
				SendClientMessage(playerid, COLOR_GRAD, "การใช้ยาเสพติดมันอาจจะลด HP ของคุณ เพิ่มระดับความหิวของคุณ และยังจะทำให้คุณป่วยหรือเสียชีวิต");
				SendClientMessage(playerid, COLOR_GRAD, "มีร้านอาหารหลายแห่งทั่วเมืองที่คุณสามารถกินเพื่อเพิ่ม HP ของคุณและลดระดับความหิวของคุณ");

				GameTextForPlayer(playerid, "~y~Garcia Burger Shot~n~~w~(~p~/eat~w~)", 20000, 3);

				InterpolateCameraPos(playerid, -1597.3508,848.2234,17.7428, -2292.7346,-197.3345,55.2711, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, -1619.1672,865.4321,7.6953, -2336.6841,-166.7888,35.5547, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -2292.7346,-197.3345,55.2711, -2336.6841,-166.7888,35.5547);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
			case 6: {

				SendClientMessage(playerid, -1, "• การเงิน");
				SendClientMessage(playerid, COLOR_GRAD, "สังคมของเมืองแซนเฟอร์โร ต่างคนต่างเลือกใช้ชีวิตและเริ่มจากการวางแผนการเงินที่ดี");
				SendClientMessage(playerid, COLOR_GRAD, "คุณยอมที่จะนำเงินก้อนมาฝากกับธนาคารเพื่อรับดอกเบี้ยที่มากขึ้นไหมล่ะ? หรือจะนำไปหมุนในชีวิตประจำวันก่อน");
				SendClientMessage(playerid, COLOR_GRAD, "");

				GameTextForPlayer(playerid, "~w~Central Bank of San Fierro", 4000, 3);

				InterpolateCameraPos(playerid, 1697.8542,-1308.5330,60.4948, -1597.3508,848.2234,17.7428, 1500, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, 1736.1309,-1267.8335,13.5431, -1619.1672,865.4321,7.6953, 1500, CAMERA_MOVE);
				stop fixCameraTimer[playerid];
				fixCameraTimer[playerid] = defer FixMobileCamera[1500](playerid, -1597.3508,848.2234,17.7428, -1619.1672,865.4321,7.6953);

				Dialog_Show(playerid, DialogTutorial, DIALOG_STYLE_MSGBOX, "บทเรียนวีดิทัศน์", "San Andreas Roleplay %d/7", "<<", ">>", GetPVarInt(playerid, "TutorialStep"));
			}
		}
	}
	return 1;
}


Dialog:StarterModel(playerid, response, listitem, inputtext[]) {
	if (response) {
		SendClientMessage(playerid, COLOR_GRAD, ""EMBED_LIGHTRED"• ยินดีต้อนรับเข้าสู่ SA:RP");
		GameTextForPlayer(playerid, sprintf("~w~Welcome ~n~~y~   %s", ReturnPlayerName(playerid)), 5000, 1);
		ResetPlayerMoney(playerid);
		GivePlayerMoneyEx(playerid, playerData[playerid][pCash]);

		switch(playerData[playerid][pAdmin]) {
			case 1: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1;
			}
			case 2: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2;
			}
			case 3: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3;
			}
			case 4: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3 | CMD_LEAD_ADMIN;
			}
			case 5: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3 | CMD_LEAD_ADMIN | CMD_MANAGEMENT;
			}
			case 6: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM_1 | CMD_ADM_2 | CMD_ADM_3 | CMD_LEAD_ADMIN | CMD_MANAGEMENT | CMD_DEV;
			}
			default: {
				playerData[playerid][pCMDPermission] = CMD_PLAYER;
			}
		}
		playerData[playerid][pLevel]=1;
		playerData[playerid][pCreated]=true;
		playerData[playerid][pPnumber] = 100000 + random(999999);

		if (listitem==0) playerData[playerid][pModel] = 60; 
		else playerData[playerid][pModel] = 56;

		TogglePlayerControllable(playerid, true);
		BitFlag_On(gPlayerBitFlag[playerid], IS_LOGGED);
		SetPlayerScore(playerid, playerData[playerid][pScore]);
		SetPlayerTeam(playerid, NO_TEAM);
		SetSpawnInfo(playerid, NO_TEAM, (playerData[playerid][pWear] ? playerData[playerid][pWear] : playerData[playerid][pModel]), 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
		SpawnPlayer(playerid);

		OnAccountUpdate(playerid);
	}
	return 1;
}
