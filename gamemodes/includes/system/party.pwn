#include <YSI\y_hooks>

#define NO_PARTY			INVALID_PLAYER_ID

new PlayerParty[MAX_PLAYERS];


hook OnPlayerConnect(playerid) {
	PlayerParty[playerid]=NO_PARTY;
	return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    Party_Leave(playerid, PlayerParty[playerid], reason);
	return 1;
}

hook OnPlayerSpawn(playerid) {
    RemoveMarkers(playerid);
}

CMD:party(playerid, params[])
{
    if(gIsDeathMode{playerid} || gIsInjuredMode{playerid} || BitFlag_Get(gPlayerBitFlag[playerid],IS_CUFFED))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "�س�������ö�����Ѿ����㹢�й��");

    ShowPartyMenu(playerid);
	return 1;
}

ShowPartyMenu(playerid) {
    if (PlayerParty[playerid]==NO_PARTY) return Dialog_Show(playerid, DialogParty, DIALOG_STYLE_MSGBOX, "�к�������", "�س��ͧ������ҧ�����������?", "��", "���");
    else return Dialog_Show(playerid, DialogParty, DIALOG_STYLE_LIST, "�к�������", "��Ҫԡ\n�͡�ҡ������", "���͡", "�Դ");
}

ShowPartyList(playerid) {
    new str[1024], count;

    if (PlayerParty[playerid] == playerid) {
        strcat(str, "������Ҫԡ");
        count ++;
    }

    if (PlayerParty[playerid] != NO_PARTY) {
        foreach(new i : Player) {
            if (PlayerParty[i] == PlayerParty[playerid] && playerid != i) {
                strcat(str, sprintf("\n%d) %s", i, ReturnPlayerName(i)));
                SetPVarInt(playerid, sprintf("PartyEdit_%d", count), i);
                count ++;
            }
        }
    }

    return Dialog_Show(playerid, DialogPartyList, DIALOG_STYLE_LIST, "��Ҫԡ㹻�����", str, "���͡", "�Դ");
}

Dialog:DialogPartyList(playerid, response, listitem, inputtext[])
{
    if (response && PlayerParty[playerid] == playerid) {
        if (listitem == 0) {
            return Dialog_Show(playerid, DialogPartyAdd, DIALOG_STYLE_INPUT, "������Ҫԡ", "��͡�ʹռ����蹷���ͧ����ԭ", "�ԭ", "�Դ");
        }
        new editid = GetPVarInt(playerid, sprintf("PartyEdit_%d", listitem));
        if (IsPlayerConnected(editid)) {
            Party_Leave(editid, PlayerParty[editid], 4);
            /*SetPVarInt(playerid, "PartyEditID", editid);
            return Dialog_Show(playerid, DialogPartyEdit, DIALOG_STYLE_LIST, sprintf("��Ҫԡ㹻����� %s", ReturnRealName(editid)), "���͡�ҡ������", "���͡", "��Ѻ");*/
        }
        return ShowPartyList(playerid);
    }
    return ShowPartyMenu(playerid);
}

Dialog:DialogPartyEdit(playerid, response, listitem, inputtext[])
{
    if (response && PlayerParty[playerid] == playerid) {
       new targetid = GetPVarInt(playerid, "PartyEditID");
       if (PlayerParty[playerid] == PlayerParty[targetid]) {
           switch(listitem) {
               case 0: {
                   if (playerid != targetid) {
                    Party_Leave(targetid, PlayerParty[targetid], 4);
                   }
                   else {
                       SendClientMessage(playerid, COLOR_LIGHTRED, "�س�������ö�е���ͧ�͡�ҡ��������");
                   }
               }
           }
       }
    }
    return ShowPartyList(playerid);
}

Dialog:DialogPartyAdd(playerid, response, listitem, inputtext[])
{
    if (response) {
        new targetid = strval(inputtext);
        if (IsPlayerConnected(targetid) && BitFlag_Get(gPlayerBitFlag[targetid], IS_LOGGED)) {
            if (PlayerParty[targetid] == NO_PARTY) {
                SetPVarInt(targetid, "PartyInvite", playerid);
                SendClientMessageEx(playerid, COLOR_LIGHTCYAN, "[Party]:"EMBED_WHITE" �س���ԭ %s ����������������ͧ�س", ReturnRealName(targetid));
                Dialog_Show(targetid, DialogPartyJoin, DIALOG_STYLE_MSGBOX, "�������������", "%s ���ԭ�س����������������ͧ��", "�������", "����ʸ", ReturnRealName(playerid));
            }
            else SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹���ջ�������������!");
        }
        else {
            SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹���ѧ������������͡Ѻ���������!");
        }
    }
    return ShowPartyList(playerid);
}

Dialog:DialogPartyJoin(playerid, response, listitem, inputtext[])
{
    if (response) {
        new targetid = GetPVarInt(playerid, "PartyInvite");
        if (IsPlayerConnected(targetid) && BitFlag_Get(gPlayerBitFlag[targetid], IS_LOGGED) && PlayerParty[targetid] == targetid) {
            PlayerParty[playerid] = PlayerParty[targetid];
            foreach(new member : Player) {
                if (PlayerParty[member] == PlayerParty[playerid]) {
                    SendClientMessageEx(member, COLOR_LIGHTCYAN, "[Party]:"EMBED_WHITE" %s �������������", ReturnRealName(playerid));

                    ShowMarkers(member, playerid);
                }
            }
            // ResyncSkin(playerid);
        }
        else {
            SendClientMessage(playerid, COLOR_GRAD1, "   �����蹹�����������㹻���������!");
        }
    }
    DeletePVar(playerid, "PartyInvite");
    return 1;
}

Dialog:DialogParty(playerid, response, listitem, inputtext[])
{
	if(response) {
        switch(listitem) {
            case 0: {
                ShowPartyList(playerid);
            }
            case 1: {
                Party_Leave(playerid, PlayerParty[playerid]);
                SendClientMessageEx(playerid, COLOR_LIGHTCYAN, "[Party]:"EMBED_WHITE" �س���͡�ҡ����������");
                // ShowPartyMenu(playerid);
            }
            default: {
                PlayerParty[playerid]=playerid;
                SendClientMessageEx(playerid, COLOR_LIGHTCYAN, "[Party]:"EMBED_WHITE" ������ͧ�س�١���ҧ���º��������");
                ShowPartyMenu(playerid);
            }
        }
    }
    return 1;
}

CMD:leaveparty(playerid, params[])
{
	Party_Leave(playerid, PlayerParty[playerid]);
	return 1;
}

Party_Count(party) {
    new count = 0;
    foreach(new member : Player) {
        if (PlayerParty[member] == party) {
            count++;
        }
    }
    return count;
}

Party_Leave(playerid, party, reason = 3) {
    if (party != NO_PARTY) {
        PlayerParty[playerid]=NO_PARTY;
        RemoveMarkers(playerid);
        // ResyncSkin(playerid);

        static const szDisconnectReason[5][] = {"��ش�͡�ҡ����","�͡�ҡ����","�١���͡�ҡ����","�͡�ҡ������","�١���͡�ҡ������"};

        new count = Party_Count(party);
        
        if (count > 1) {
            if (playerid == party) { // �繼���
                // �Ҽ��Ӥ�����
                new leader = INVALID_PLAYER_ID;

                foreach(new member : Player) {
                    if (PlayerParty[member] == party) {
                        leader = member;
                        break;
                    }
                }

                if (leader != INVALID_PLAYER_ID) {
                    // ��䢻�������Ҫԡ����� � 
                    foreach(new member : Player) {
                        if (PlayerParty[member] == party) {
                            PlayerParty[member] = leader;
                            SendClientMessageEx(member, COLOR_LIGHTCYAN, "[Party]:"EMBED_WHITE" %s ��ͼ��Ӥ����� (%s %s)", ReturnRealName(leader), ReturnRealName(playerid), szDisconnectReason[reason]);

                            new r, g, b, a;
                            HexToRGBA(GetPlayerColor(playerid), r, g, b, a);
                            SetPlayerMarkerForPlayer(member, playerid, RGBAToHex(r, g, b, 0x00));
                        }
                    }
                    //UpdatePartyMarker(leader);
                }
            }
            else {
                foreach(new member : Player) {
                    if (PlayerParty[member] == party) {
                        SendClientMessageEx(member, COLOR_LIGHTCYAN, "[Party]:"EMBED_WHITE" %s �͡�ҡ������ (%s)", ReturnRealName(playerid), szDisconnectReason[reason]);
                        
                        new r, g, b, a;
                        HexToRGBA(GetPlayerColor(playerid), r, g, b, a);
                        SetPlayerMarkerForPlayer(member, playerid, RGBAToHex(r, g, b, 0x00));
                    }
                }
                //UpdatePartyMarker(party);
            }
        }
        else {
            foreach(new member : Player) {
                if (PlayerParty[member] == party) {
                    SendClientMessageEx(member, COLOR_LIGHTCYAN, "[Party]:"EMBED_WHITE" %s �͡�ҡ������ (%s)", ReturnRealName(playerid), szDisconnectReason[reason]);
                    SendClientMessage(member, COLOR_LIGHTCYAN, "[Party]:"EMBED_WHITE" ������㹻Ѩ�غѹ�ͧ�س�١�غ");
                    PlayerParty[member] = NO_PARTY;
                }
            } 
        }
    }
    return 1;
}
/*
UpdatePartyMarker(party)
{
    foreach(new i : Player) {
        if (PlayerParty[i] == party) {
            foreach(new member : Player) {
                if (PlayerParty[member] == party) {
                    SetPlayerMarkerForPlayer(i, member, GetPlayerColor(member));
                } else SetPlayerMarkerForPlayer(i, member, 0xFFFFFF00);
            }
        }
    }
}*/

ptask PartyUpdateTimer[5000](playerid) 
{
    if(PlayerParty[playerid] != NO_PARTY && BitFlag_Get(gPlayerBitFlag[playerid], IS_LOGGED)) {
        foreach(new i : Player)
        {
            if (i != playerid && PlayerParty[playerid] == PlayerParty[i] && BitFlag_Get(gPlayerBitFlag[i], IS_LOGGED) && playerData[playerid][pVWorld] == playerData[i][pVWorld] && playerData[playerid][pInterior] == playerData[i][pInterior]) {
                ShowMarkers(playerid, i);
            }
        }
    }
}

ShowMarkers(playerid, memberid)
{
    new r, g, b, a;
	if(PlayerParty[playerid] != NO_PARTY) {
        HexToRGBA(GetPlayerColor(memberid), r, g, b, a);
        SetPlayerMarkerForPlayer(playerid, memberid, RGBAToHex(r, g, b, 0xFF));
    }
    /*else {
        HexToRGBA(GetPlayerColor(memberid), r, g, b, a);
        SetPlayerMarkerForPlayer(playerid, memberid, RGBAToHex(r, g, b, 0x00));
    }*/
}

RemoveMarkers(playerid)
{
    new r, g, b, a;
    foreach(new i : Player)
    {
        if (playerid != i && BitFlag_Get(gPlayerBitFlag[i], IS_LOGGED)) {
            HexToRGBA(GetPlayerColor(i), r, g, b, a);
            SetPlayerMarkerForPlayer(playerid, i, RGBAToHex(r, g, b, 0x00));
        }
    }   
}

RemoveOtherMarkers(playerid)
{
    new r, g, b, a;
    foreach(new i : Player)
    {
        if (playerid != i && BitFlag_Get(gPlayerBitFlag[i], IS_LOGGED)) {
            HexToRGBA(GetPlayerColor(playerid), r, g, b, a);
            SetPlayerMarkerForPlayer(i, playerid, RGBAToHex(r, g, b, 0x00));
        }
    }   
}