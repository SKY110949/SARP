//=============== Includes ===============
#include <a_samp>

//=============== MCMD ===============
#define mcmd:%1(%2) forward mcmd_%1(%2); public mcmd_%1(%2)
forward MCMD_OnPlayerCommandText(playerid,cmdtext[]);

//=============== News ===============
new DB:Database,dbid;

//=============== Defines ===============
#define rot 0xFF1400FF
#define gruen 0x5FFF00FF
#define SCM SendClientMessage

//=============== Enums ===============
enum
{
	DIALOG_CFG=1000,
	DIALOG_SHOW,
	DIALOG_ADD,
	DIALOG_DEL,
	DIALOG_RESET,
}

public OnFilterScriptInit()
{
	Database=db_open("list.db");
	db_query(Database,"CREATE TABLE IF NOT EXISTS `list` (`ID`, `Name`,`IP`)");
	print("\n=================================================");
	print(" Dynamic Whitelist by Music4You aka. Items4Landwirt");
	print("=================================================\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	new DBResult:Result,str[75],query[256],rows,string[128];
	#pragma unused rows
	format(str,sizeof(str),"SELECT * FROM `list` WHERE `Name`='%s'",SpielerName(playerid));
	Result=db_query(Database,str);
	if(db_num_rows(Result)>0)
	{
		format(string,sizeof(string),"Spieler: %s hat sich eingeloggt",SpielerName(playerid));
		format(query,sizeof(query),"UPDATE `list` SET `IP`='%s' WHERE `Name`='%s'",SpielerIP(playerid),SpielerName(playerid));
		SendClientMessageToAll(gruen,string);
		db_query(Database,query);
	}
	else
	{
		SCM(playerid,rot,"Dein Name steht nicht auf der Whitelist, melde dich bei einem Admin!");
		Kick(playerid);
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	cmdtext[0] = '_';
	new blacmd[37]="mcmd_",s[91]=" ",i=1,j;
	for(;i!=32;i++)
	{
		switch(cmdtext[i])
		{
			case ' ','\0': break;
			default: blacmd[i+4] = tolower(cmdtext[i]);
		}
	}
	for(;i!=128;j++,i++)
	{
		switch(cmdtext[i])
		{
			case '\0': break;
			default: s[j]=cmdtext[i];
		}
	}
	if(CallLocalFunction(blacmd,"is",playerid,s)) return true;
	cmdtext[0] = '/';
	return CallLocalFunction("MCMD_OnPlayerCommandText","ds",playerid,cmdtext);
}
mcmd:whitelistcfg(playerid,params[])
{
    if(!IsPlayerAdmin(playerid))return SCM(playerid,-1,"Du bist nicht befugt!");
	ShowPlayerDialog(playerid,DIALOG_CFG,DIALOG_STYLE_LIST,"Whitelist","Alle einträge anzeigen\nUser Hinzufügen\nUser löschen\nWhitelist Reset","Auswählen","Abbrechen");
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    new string1[128],str[128],str1[128],string[128],DBResult:Result,rows,i=1,query[256];
	switch(dialogid)
	{
		case DIALOG_CFG:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
                        for(;i<MAX_PLAYERS;i++)
					    {
						    format(str,sizeof(str),"SELECT * FROM `list` WHERE `ID`='%i'",i);
							Result = db_query(Database,str);
						 	rows = db_num_rows(Result);
						 	if(rows == 0)continue;

							db_get_field_assoc(Result,"Name",str,sizeof(str));
						 	format(string1,MAX_PLAYER_NAME,"%s",str);

						 	format(string,sizeof(string),"%s%s\n",string,string1);
					 	}
						ShowPlayerDialog(playerid,DIALOG_SHOW,DIALOG_STYLE_LIST,"Whitelist",string,"Ok","");
					 	db_free_result(Result);
					}
					case 1:
					{
						ShowPlayerDialog(playerid,DIALOG_ADD,DIALOG_STYLE_INPUT,"Useradd","Gebe den Namen des Benutzers ein, welcher Hinzugefügt werden soll!","Auswählen","Abbrechen");
					}
					case 2:
					{
                        ShowPlayerDialog(playerid,DIALOG_DEL,DIALOG_STYLE_INPUT,"Userdel","Gebe den Namen des Benutzers ein, welcher gelöscht werden soll!","Auswählen","Abbrechen");
					}
					case 3:
					{
                        ShowPlayerDialog(playerid,DIALOG_RESET,DIALOG_STYLE_MSGBOX,"Whitelist Reset","Bist du dir sicher das du Die gesamte Whitelist Resetten möchtest?\nAlle benutzer werden Gelösch!","Akzeptieren","Abbrechen");
					}
				}
			}
		}
		case DIALOG_ADD:
		{
		    if(response)
		    {
				for(;i<MAX_PLAYERS;i++)
			   	{
				   	format(str,sizeof(str),"SELECT * FROM `list` WHERE `ID`='%i'",i);
					Result = db_query(Database,str);
			 		rows = db_num_rows(Result);
			 		if(rows == 0)continue;

					db_get_field_assoc(Result,"ID",str,sizeof(str));
					dbid=strval(str);
				}
				format(str1,sizeof(str1),"SELECT * FROM `list` WHERE `Name`='%s'",inputtext);
				Result=db_query(Database,str1);
				if(db_num_rows(Result)>0)return SCM(playerid,rot,"Der Spieler ist bereits auf der Whitelist!");

				format(query,sizeof(query),"INSERT INTO `list` (`ID`,`Name`,`IP`) VALUES ('%i','%s','0')",dbid+1,inputtext);
				format(string,sizeof(string),"Du hast %s auf die Whitelist gesetzt.",inputtext);
				db_query(Database,query);
				SCM(playerid,gruen,string);
				ShowPlayerDialog(playerid,DIALOG_CFG,DIALOG_STYLE_LIST,"Whitelist","Alle einträge anzeigen\nUser Hinzufügen\nUser löschen\nWhitelist Reset","Auswählen","Abbrechen");
			}
		}
		case DIALOG_DEL:
		{
			if(response)
			{
                format(str1,sizeof(str1),"SELECT * FROM `list` WHERE `Name`='%s'",inputtext);
				Result=db_query(Database,str1);
				if(db_num_rows(Result)>0)
				{
					format(query,sizeof(query),"DELETE FROM `list` WHERE `Name`='%s'",inputtext);
					format(string,sizeof(string),"Du hast %s von der Whitelist gelöscht!",inputtext);
					db_query(Database,query);
					SCM(playerid,rot,string);
					ShowPlayerDialog(playerid,DIALOG_CFG,DIALOG_STYLE_LIST,"Whitelist","Alle einträge anzeigen\nUser Hinzufügen\nUser löschen\nWhitelist Reset","Auswählen","Abbrechen");
				}
				else return SCM(playerid,rot,"Der Spieler ist nicht auf der Whitelist!");
			}
		}
		case DIALOG_RESET:
		{
			if(response)
			{
                format(query,sizeof(query),"DELETE FROM `list`");
				db_query(Database,query);
				SCM(playerid,rot,"Du hast die Whitelist resettet!");
				dbid=0;
				ShowPlayerDialog(playerid,DIALOG_CFG,DIALOG_STYLE_LIST,"Whitelist","Alle einträge anzeigen\nUser Hinzufügen\nUser löschen\nWhitelist Reset","Auswählen","Abbrechen");
			}
		}
	}
	return 1;
}

stock SpielerName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));
	return name;
}
stock SpielerIP(playerid)
{
	new getip[20];
	GetPlayerIp(playerid,getip,sizeof(getip));
	return getip;
}
stock sscanf(string[], format[], {Float,_}:...)
{
	#if defined isnull
		if (isnull(string))
	#else
		if (string[0] == 0 || (string[0] == 1 && string[1] == 0))
	#endif
		{
			return format[0];
		}
	#pragma tabsize 4
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs(),
		delim = ' ';
	while (string[stringPos] && string[stringPos] <= ' ')
	{
		stringPos++;
	}
	while (paramPos < paramCount && string[stringPos])
	{
		switch (format[formatPos++])
		{
			case '\0':
			{
				return 0;
			}
			case 'i', 'd':
			{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-')
				{
					neg = -1;
					ch = string[++stringPos];
				}
				do
				{
					stringPos++;
					if ('0' <= ch <= '9')
					{
						num = (num * 10) + (ch - '0');
					}
					else
					{
						return -1;
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					num = 0,
					ch = string[stringPos];
				do
				{
					stringPos++;
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						default:
						{
							return -1;
						}
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num);
			}
			case 'c':
			{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':
			{

				new changestr[16], changepos = 0, strpos = stringPos;
				while(changepos < 16 && string[strpos] && string[strpos] != delim)
				{
					changestr[changepos++] = string[strpos++];
    				}
				changestr[changepos] = '\0';
				setarg(paramPos,0,_:floatstr(changestr));
			}
			case 'p':
			{
				delim = format[formatPos++];
				continue;
			}
			case '\'':
			{
				new
					end = formatPos - 1,
					ch;
				while ((ch = format[++end]) && ch != '\'') {}
				if (!ch)
				{
					return -1;
				}
				format[end] = '\0';
				if ((ch = strfind(string, format[formatPos], false, stringPos)) == -1)
				{
					if (format[end + 1])
					{
						return -1;
					}
					return 0;
				}
				format[end] = '\'';
				stringPos = ch + (end - formatPos);
				formatPos = end + 1;
			}
			case 'u':
			{
				new
					end = stringPos - 1,
					id = 0,
					bool:num = true,
					ch;
				while ((ch = string[++end]) && ch != delim)
				{
					if (num)
					{
						if ('0' <= ch <= '9')
						{
							id = (id * 10) + (ch - '0');
						}
						else
						{
							num = false;
						}
					}
				}
				if (num && IsPlayerConnected(id))
				{
					setarg(paramPos, 0, id);
				}
				else
				{
					#if !defined foreach
						#define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
						#define __SSCANF_FOREACH__
					#endif
					string[end] = '\0';
					num = false;
					new
						name[MAX_PLAYER_NAME];
					id = end - stringPos;
					foreach (Player, playerid)
					{
						GetPlayerName(playerid, name, sizeof (name));
						if (!strcmp(name, string[stringPos], true, id))
						{
							setarg(paramPos, 0, playerid);
							num = true;
							break;
						}
					}
					if (!num)
					{
						setarg(paramPos, 0, INVALID_PLAYER_ID);
					}
					string[end] = ch;
					#if defined __SSCANF_FOREACH__
						#undef foreach
						#undef __SSCANF_FOREACH__
					#endif
				}
				stringPos = end;
			}
			case 's', 'z':
			{
				new
					i = 0,
					ch;
				if (format[formatPos])
				{
					while ((ch = string[stringPos++]) && ch != delim)
					{
						setarg(paramPos, i++, ch);
					}
					if (!i)
					{
						return -1;
					}
				}
				else
				{
					while ((ch = string[stringPos++]))
					{
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:
			{
				continue;
			}
		}
		while (string[stringPos] && string[stringPos] != delim && string[stringPos] > ' ')
		{
			stringPos++;
		}
		while (string[stringPos] && (string[stringPos] == delim || string[stringPos] <= ' '))
		{
			stringPos++;
		}
		paramPos++;
	}
	do
	{
		if ((delim = format[formatPos++]) > ' ')
		{
			if (delim == '\'')
			{
				while ((delim = format[formatPos++]) && delim != '\'') {}
			}
			else if (delim != 'z')
			{
				return delim;
			}
		}
	}
	while (delim > ' ');
	return 0;
}

#if defined _ALS_OnPlayerCommandText
	#undef OnPlayerCommandText
#else
#define _ALS_OnPlayerCommandText
	#endif
#define OnPlayerCommandText MCMD_OnPlayerCommandText
