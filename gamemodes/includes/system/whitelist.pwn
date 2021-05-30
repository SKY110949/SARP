#include  <YSI_Coding\y_hooks>
#include  <YSI_Coding\y_va>

static szQueryOutput[512];

hook OnGameModeInit()
{
	g_mysql_Init();
	return 1;
}

hook OnPlayerConnect(playerid)
{
	new varName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, varName, MAX_PLAYER_NAME);
	mysql_format(dbCon, szQueryOutput, sizeof(szQueryOutput), "SELECT * FROM whitelist WHERE nickname = '%s'", varName);
	mysql_tquery(dbCon, szQueryOutput, "CheckWhitelist", "i", playerid);
	return 1;
}

forward CheckWhitelist(playerid);
public CheckWhitelist(playerid){

	new rows;
	
	cache_get_row_count(rows);

	if(!IsPlayerNPC(playerid)) {
		if(rows)
		{
			//HrLineMsg(playerid);
			SendClientMessage(playerid, 0x00FF00AA, "[Whitelist] ����Фâͧ�س�١͹حҵ������������Կ������� .");
			//HrLineMsg(playerid);
		}
		else
		{
			//HrLineMsg(playerid);
			SendClientMessage(playerid, 0xFF0000AA, "[Whitelist] ����Фâͧ�س������Ѻ���͹حҵ����������������Կ������� �Դ��� White list ����Discord �Կ�����.");
			SendClientMessage(playerid, 0xFF0000AA, "[Whitelist] ����Фâͧ�س������Ѻ���͹حҵ����������������Կ������� �Դ��� White list ����Discord �Կ�����.");
			SendClientMessage(playerid, 0xFF0000AA, "[Whitelist] ����Фâͧ�س������Ѻ���͹حҵ����������������Կ������� �Դ��� White list ����Discord �Կ�����.");
			//HrLineMsg(playerid);
			SetTimerEx("Delay_Kick", 1000, false, "i", playerid);
		}
	}
	return 1;
}

forward Delay_Kick(playerid);
public Delay_Kick(playerid)
{
	Kick(playerid);
	return 1;
}

//alias:whitelist("���������");
CMD:whitelist(playerid, params[])
{
	new playerName[64], facebook[128];

	if(playerData[playerid][pAdmin] < 4) return SendClientMessage(playerid, COLOR_WHITE, "�س�������ö�����觹���� (4)");

	if(sscanf(params, "s[64]s[128]", playerName, facebook)) return SendClientMessage(playerid, COLOR_WHITE, "Use /whitelist [Name_Lastname] [url facebook]");

	new varQuery[200];
	format(varQuery, sizeof varQuery, "INSERT INTO whitelist (nickname, urlfacebook) VALUE ('%s', '%s')", playerName, facebook);
	mysql_tquery(dbCon, varQuery);

	SendAdminMessage(COLOR_YELLOW, CMD_DEV, "[���� White list]: %s ������ {00FF00}%s {F97804}������ White list.", ReturnPlayerName(playerid), playerName);

	return 1;
}
