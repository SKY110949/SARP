CMD:report(playerid, params[])
{
	if(systemVariables[reportSystem] == 0)
	{
	    if(isnull(params))
	    {
	        SendClientMessage(playerid, COLOR_GREY, "การใช้: /report [ข้อความ]");
		}
		else {
		    if(playerData[playerid][pReport] >= 1)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "คุณได้รายงานไปยังผู้ดูแลแล้ว กรุณารอการตอบหลับสักครู่");
			}
			else {
			    if(strlen(params) >= 64) {
			        return SendClientMessage(playerid, COLOR_GREY, "ข้อความของคุณยาวเกินไป กรุณาให้ต่ำกว่า 64 ตัวอักษร");
				}
				else {
					new pDialog[1900];
					strcpi(playerData[playerid][pReportMessage], params, 64);

					format(pDialog, sizeof(pDialog), "{FF6347}คำเตือ"EMBED_WHITE"น:\nคุณกำลังจะส่งให้กับผู้ดูแลระบบที่ออนไลน์ทั้งหมดรายงานต่อไปนี้: %s\n\n", params);
					strcat(pDialog, "- รายงานการกระทำที่ไม่ได้เกิดขึ้นในนขณะนี้ เป็นเรื่องยากมากสำหรับผู้ดูแลระบบที่ออนไลน์เพื่อจัดการกับปัญหาอย่างตรงจุด เนื่องจากหลักฐานไม่เป็นปัจจุบัน\nขอแนะนำให้ไปยังฟอรั่มและส่งรายงานในฟอรั่มพร้อมหลักฐานแทน\n\n- มันสำคัญมากที่ไม่ส่งรายงานเหล่านี้ในเกมแต่คุณจะได้รับการจัดการให้ดีขึ้นจาก", sizeof(pDialog));
					strcat(pDialog, "ฟอรั่มเช่น ปัญหาดังกล่าวข้างบน หรือปัญหาการโดเนท ขอคืนเงินหลังจาก\nที่เซิร์ฟเวอร์ Rollbacks ขอปลดแบนและอื่น ๆ ถ้าคุณคิดว่าคุณกำลังถูก Deathmatch ให้ลองพิจารณาถามบุคคลที่ฆ่าด้วยเหตุผลเป็นอันดับแรก\n\n- คุณควรจะได้รับการ Teleport, Unfreeze, Slap หรือที่คล้ายคลึงกัน คุณจะต้องระบุเหตุผล โดยทั่วไปแล้วคุณจะต้องอธิบายในรายงานของคุณ\n- กรุณาอย่าสแปมรายงานของคุณ ต้องอดทนและผู้ดูแลระบบจะช่วยคุณโดยเร็วที่สุดเท่าที่จะเป็นไปได้\n", sizeof(pDialog));
					strcat(pDialog, "คุณไม่ควรพยายามที่จะทำลายหรือเลิกเล่นบทบาทสมมุติของผู้เล่นอื่นเว้นแต่คุณจะได้รับความช่วยเหลือที่ผู้ดูแลระบบให้/ผู้เล่นอื่นทำให้คุณไม่สบายใจบทบาทเกี่ยวกับเพศ", sizeof(pDialog));
					Dialog_Show(playerid, ReportConfirm, DIALOG_STYLE_MSGBOX, "คุณแน่ใจที่จะส่งรายงานไปผู้ดูแลระบบแล้วหรือ?", pDialog, "Proceed", "Don't Send");
				}
			}
		}
	}
	else {
	    SendClientMessage(playerid, COLOR_WHITE, "ระบบการแจ้งรายงานถูกปิดในขณะนี้ กรุณาแจ้งอีกครั้งในภายหลัง");
	}
	return 1;
}

CMD:reports(playerid, params[]) {
	if(playerData[playerid][pAdmin] >= 1)
	{
		new
			tool[16];

		if(sscanf(params, "s[16] ", tool))
		{
		    SendClientMessage(playerid, COLOR_GREY, "USAGE:/reports [tool]");
		    SendClientMessage(playerid, COLOR_GREY, "Tools: List, Accept, Disregard, Status");
		}
		else
		{
		    if(strcmp(tool, "list", true) == 0 || strcmp(tool, "l", true) == 0)
			{
				SendClientMessage(playerid, COLOR_WHITE, "-------------------------------------------------------------------------------------------------------------------------------");

		        new
					string[128],
					reportCount;

		        foreach (new  i: Player)
				{
		            if(playerData[i][pReport] >= 1)
					{
		                format(string, sizeof(string), "[ACTIVE]"EMBED_WHITE" %s {FF6347}[%d] {FFFF91}: %s", ReturnRealName(i), i, playerData[i][pReportMessage]);
		                SendClientMessage(playerid, COLOR_YELLOW, string);
		                reportCount++;
		            }
		        }

		        format(string, sizeof(string), "ACTIVE REPORTS: %d (ใช้ /reports accept เพื่อยืนยัน)", reportCount);
		        SendClientMessage(playerid, COLOR_WHITE, string);

				SendClientMessage(playerid, COLOR_WHITE, "-------------------------------------------------------------------------------------------------------------------------------");
		    }
		    else if(strcmp(tool, "accept", true) == 0 || strcmp(tool, "a", true) == 0)
		    {
		        new
					userID;

		        if(sscanf(params, "s[16]u", tool, userID))
				{
		            SendClientMessage(playerid, COLOR_GREY, "USAGE:/reports accept [ไอดีผู้เล่น/ชื่อบางส่วน]");
		        }
		        else
				{
		            if(!IsPlayerConnected(userID))
					{
		                SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
		            }
		            else
		            {
		                if(playerData[userID][pReport] >= 1)
						{
		                    new

								string[128];

		                    format(string, sizeof(string), "%s ยืนยันรายงานของ %s (%s)", ReturnPlayerName(playerid), ReturnPlayerName(userID), playerData[userID][pReportMessage]);
		                    SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, string);

		                    playerData[userID][pReport] = 0;
		                    format(playerData[userID][pReportMessage], 64, "(null)");

							if(playerData[playerid][pAdmin] >= 1)
							{
		                    	format(string, sizeof(string), "ขอบคุณสำหรับรายงาน! ผู้ดูแล %s ได้ยืนยันรายงานของคุณแล้ว", ReturnPlayerName(playerid));
                                SendClientMessage(userID, COLOR_YELLOW, string);
							}
		                }
		                else
						{
		                    SendClientMessage(playerid, COLOR_GREY, "ผู้เล่นนั้นไม่ได้รายงานเข้ามา");
		                }
		            }
		        }
		    }
		    else if(strcmp(tool, "disregard", true) == 0 || strcmp(tool, "d", true) == 0)
			{
		        new
					userID,
					string[128];

		        if(sscanf(params, "s[16]u", tool, userID))
				{
		            SendClientMessage(playerid, COLOR_GREY, "USAGE:/reports disregard [ไอดีผู้เล่น/ชื่อบางส่วน]");
		        }
		        else
				{
				    if(!IsPlayerConnected(userID))
					{
		                SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
		            }
		            else
					{
		                if(playerData[userID][pReport] != 0) {

		                    playerData[userID][pReport] = 0;
		                    format(playerData[userID][pReportMessage], 64, "(null)");

		                    format(string, sizeof(string), "คุณปฏิเสธรายงานของ %s", ReturnPlayerName(userID));
		                    SendClientMessage(playerid, COLOR_WHITE, string);
		                }
		                else
						{
		                    SendClientMessage(playerid, COLOR_GREY, "ผู้เล่นนั้นไม่ได้รายงานเข้ามา");
		                }
		            }
		        }
		    }
		    else if(strcmp(tool, "status", true) == 0 || strcmp(tool, "s", true) == 0)
			{
		        if(playerData[playerid][pAdmin] >= 4)
				{
			        if(systemVariables[reportSystem] == 0)
					{
			            systemVariables[reportSystem] = 1;
			            SendClientMessage(playerid, COLOR_WHITE, "คุณได้ยกเลิกระบบ Report");
			            SendClientMessageToAll(COLOR_YELLOW, "ระบบ Report ถูกยกเลิก");
			        }
			        else
					{
			            systemVariables[reportSystem] = 0;
			            SendClientMessage(playerid, COLOR_WHITE, "คุณเปิดใช้ระบบ Report");
			            SendClientMessageToAll(COLOR_YELLOW, "ระบบ Report ถูกเปิดใช้อีกครั้ง");
			        }
		        }
		        else
				{
					return SendClientMessage(playerid, COLOR_GREY, "คุณต้องอยู่ในระดับ Lead Administrator หรือมากกว่าเพื่อใช้ฟังชั่นนี้");
				}
 		    }
		    else
			{
			    SendClientMessage(playerid, COLOR_GREY, "USAGE:/reports [tool]");
			    SendClientMessage(playerid, COLOR_GREY, "TOOLS: List, Accept, Disregard, Status");
		    }
		}
	}

	return 1;
}

Dialog:ReportConfirm(playerid, response, listitem, inputtext[])
{
	if(response) {
		SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: รายงานของคุณได้ถูกส่งไปยังผู้ดูแลทุกคนที่ออนไลน์");
		playerData[playerid][pReport] = 1;
		SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, "AdmCmd: มีรายงานใหม่เข้ามาพิมพ์ '/reports list' เพื่อตรวจสอบ");
	}
	else {
	    format(playerData[playerid][pReportMessage], 64, "(null)");
	}
	return 1;
}

strcpi(dest[], const src[], sz=sizeof(dest))
{
  dest[0] = 0;
  return strcat(dest,src,sz); //Notice that I have used strcat instead of writing my own loops
}