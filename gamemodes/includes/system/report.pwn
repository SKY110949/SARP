CMD:report(playerid, params[])
{
	if(systemVariables[reportSystem] == 0)
	{
	    if(isnull(params))
	    {
	        SendClientMessage(playerid, COLOR_GREY, "�����: /report [��ͤ���]");
		}
		else {
		    if(playerData[playerid][pReport] >= 1)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "�س����§ҹ��ѧ���������� ��س��͡�õͺ��Ѻ�ѡ����");
			}
			else {
			    if(strlen(params) >= 64) {
			        return SendClientMessage(playerid, COLOR_GREY, "��ͤ����ͧ�س����Թ� ��س�����ӡ��� 64 ����ѡ��");
				}
				else {
					new pDialog[1900];
					strcpi(playerData[playerid][pReportMessage], params, 64);

					format(pDialog, sizeof(pDialog), "{FF6347}�����"EMBED_WHITE"�:\n�س���ѧ�������Ѻ�������к�����͹�Ź��������§ҹ���仹��: %s\n\n", params);
					strcat(pDialog, "- ��§ҹ��á�зӷ��������Դ���㹹��й�� ������ͧ�ҡ�ҡ����Ѻ�������к�����͹�Ź����ͨѴ��áѺ�ѭ�����ҧ�ç�ش ���ͧ�ҡ��ѡ�ҹ����繻Ѩ�غѹ\n���й������ѧ�������������§ҹ㹿������������ѡ�ҹ᷹\n\n- �ѹ�Ӥѭ�ҡ����������§ҹ����ҹ�������س�����Ѻ��èѴ������բ�鹨ҡ", sizeof(pDialog));
					strcat(pDialog, "�������� �ѭ�Ҵѧ����Ǣ�ҧ�� ���ͻѭ�ҡ���๷ �ͤ׹�Թ��ѧ�ҡ\n������������ Rollbacks �ͻŴẹ������ � ��Ҥس�Դ��Ҥس���ѧ�١ Deathmatch ����ͧ�Ԩ�óҶ���ؤ�ŷ���Ҵ����˵ؼ����ѹ�Ѻ�á\n\n- �س��è����Ѻ��� Teleport, Unfreeze, Slap ���ͷ�����¤�֧�ѹ �س�е�ͧ�к��˵ؼ� �·�������Ǥس�е�ͧ͸Ժ�����§ҹ�ͧ�س\n- ��س����������§ҹ�ͧ�س ��ͧʹ����м������к��Ъ��¤س�����Ƿ���ش��ҷ��������\n", sizeof(pDialog));
					strcat(pDialog, "�س����þ��������з����������ԡ��蹺��ҷ���صԢͧ��������������س�����Ѻ������������ͷ��������к����/��������蹷����س���ʺ��㨺��ҷ����ǡѺ��", sizeof(pDialog));
					Dialog_Show(playerid, ReportConfirm, DIALOG_STYLE_MSGBOX, "�س��㨷�������§ҹ仼������к���������?", pDialog, "Proceed", "Don't Send");
				}
			}
		}
	}
	else {
	    SendClientMessage(playerid, COLOR_WHITE, "�к��������§ҹ�١�Դ㹢�й�� ��س����ա����������ѧ");
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

		        format(string, sizeof(string), "ACTIVE REPORTS: %d (�� /reports accept �����׹�ѹ)", reportCount);
		        SendClientMessage(playerid, COLOR_WHITE, string);

				SendClientMessage(playerid, COLOR_WHITE, "-------------------------------------------------------------------------------------------------------------------------------");
		    }
		    else if(strcmp(tool, "accept", true) == 0 || strcmp(tool, "a", true) == 0)
		    {
		        new
					userID;

		        if(sscanf(params, "s[16]u", tool, userID))
				{
		            SendClientMessage(playerid, COLOR_GREY, "USAGE:/reports accept [�ʹռ�����/���ͺҧ��ǹ]");
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

		                    format(string, sizeof(string), "%s �׹�ѹ��§ҹ�ͧ %s (%s)", ReturnPlayerName(playerid), ReturnPlayerName(userID), playerData[userID][pReportMessage]);
		                    SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, string);

		                    playerData[userID][pReport] = 0;
		                    format(playerData[userID][pReportMessage], 64, "(null)");

							if(playerData[playerid][pAdmin] >= 1)
							{
		                    	format(string, sizeof(string), "�ͺ�س����Ѻ��§ҹ! ������ %s ���׹�ѹ��§ҹ�ͧ�س����", ReturnPlayerName(playerid));
                                SendClientMessage(userID, COLOR_YELLOW, string);
							}
		                }
		                else
						{
		                    SendClientMessage(playerid, COLOR_GREY, "�����蹹���������§ҹ�����");
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
		            SendClientMessage(playerid, COLOR_GREY, "USAGE:/reports disregard [�ʹռ�����/���ͺҧ��ǹ]");
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

		                    format(string, sizeof(string), "�س����ʸ��§ҹ�ͧ %s", ReturnPlayerName(userID));
		                    SendClientMessage(playerid, COLOR_WHITE, string);
		                }
		                else
						{
		                    SendClientMessage(playerid, COLOR_GREY, "�����蹹���������§ҹ�����");
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
			            SendClientMessage(playerid, COLOR_WHITE, "�س��¡��ԡ�к� Report");
			            SendClientMessageToAll(COLOR_YELLOW, "�к� Report �١¡��ԡ");
			        }
			        else
					{
			            systemVariables[reportSystem] = 0;
			            SendClientMessage(playerid, COLOR_WHITE, "�س�Դ���к� Report");
			            SendClientMessageToAll(COLOR_YELLOW, "�к� Report �١�Դ���ա����");
			        }
		        }
		        else
				{
					return SendClientMessage(playerid, COLOR_GREY, "�س��ͧ������дѺ Lead Administrator �����ҡ����������ѧ��蹹��");
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
		SendClientMessage(playerid, COLOR_LIGHTRED, "SERVER: ��§ҹ�ͧ�س��١����ѧ�����ŷء������͹�Ź�");
		playerData[playerid][pReport] = 1;
		SendAdminMessage(COLOR_YELLOW, CMD_ADM_1, "AdmCmd: ����§ҹ��������Ҿ���� '/reports list' ���͵�Ǩ�ͺ");
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