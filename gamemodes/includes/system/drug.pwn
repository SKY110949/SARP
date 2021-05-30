#include <YSI\y_timers>  // pawn-lang/YSI-Includes
#include <YSI\y_hooks> // pawn-lang/YSI-Includes

#define MAX_DRUG_TYPE 14

new const Float:DrugPackageSize[MAX_DRUG_TYPE] = {
	7.0 ,
	14.0,
	28.0,
	7.0 ,
	14.0,
	28.0,
	7.0 ,
	14.0,
	28.0,
	7.0 ,
	14.0,
	28.0,
	7.0 ,
	14.0
};

new const DrugPackageName[MAX_DRUG_TYPE][90] = {
	"�ا�Ի��ͤ - ���",
	"�ا�Ի��ͤ - ��ҧ",
	"�ا�Ի��ͤ - �˭�",
	"����繡�͹��� - ���",
	"����繡�͹��� - ��ҧ",
	"����繡�͹��� - �˭�",
	"��ʹ��¿�� - ���",
	"��ʹ��¿�� - ��ҧ",
	"��ʹ��¿�� - �˭�",
	"�Ǵ�� - ���",
	"�Ǵ�� - ��ҧ",
	"�Ǵ�� - �˭�",
	"��д����͢Ѵ�ѹ - ���",
	"��д����͢Ѵ�ѹ - ��ҧ"
};

#define DRUGDATA_TYPE 0
#define DRUGDATA_NAME 1
#define MAX_DRUGS 10
new const DrugData[MAX_DRUGS][] = { // 0-grams, 1-Pills 
	{0,"�ह"},
	{0,"�ѭ��"},
	{1,"����"},
	{1,"����"},
	{0,"�����չ"},
	{0,"व��չ"},
	{0,"࿹�ҹ��"},
	{0,"������࿵��չ"},
	{1,"������´�"},
	{1,"�͡���ⴹ"}
};


#define MAX_PLAYER_DRUG_PACKAGE 24

enum e_Drug
{
	drugID,
	drugType, // 1 Cocaine, 2 Cannabis, 3 Xanax, 4 MDMA, 5 Heroin, 6 Ketamine 7, Fentanyl 8, Methamphetamine 9, Steroids 10, Oxycodone
	Float:drugQTY,
	drugStrength,
	drugPackage, // DrugPackageName 0 - 13
	drugFore
};

new PlayerDrug[MAX_PLAYERS][MAX_PLAYER_DRUG_PACKAGE][e_Drug];

// ����ü�����
new Float:EffectDrugs[MAX_PLAYERS];
new Float:EffectDrugAmount[MAX_PLAYERS];
new Timer:EffectDrugs_Timer[MAX_PLAYERS];
new bool:SufferDrugs[MAX_PLAYERS char]; // ŧᴧ
new AddictDrugs[MAX_PLAYERS];
new Timer:AddictTimer[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
	for (new i=0;i!=MAX_PLAYER_DRUG_PACKAGE;i++) {
		PlayerDrug[playerid][i][drugQTY]=0.0;
	}
	SufferDrugs{playerid}=false; EffectDrugs[playerid]=0.0;
	AddictTimer[playerid]=Timer:0;
	EffectDrugAmount[playerid]=0;
	return 1;
}

CMD:myitems(playerid) {
	ShowPlayerDrugs(playerid, playerid);
	return 1;
}

IsHaveDrug(playerid) {
	for(new i = 0; i != MAX_PLAYER_DRUG_PACKAGE; i++)
	{
		if(PlayerDrug[playerid][i][drugQTY]>0) {
			return true;
		}
	}
	return false;
}

AssignPlayerDrugAddictions(playerid, const str[])
{
	new wtmp[MAX_DRUGS][32];
	strexplode(wtmp,str,"|");
	for(new z = 0; z != MAX_DRUGS; ++z)
	{
		playerData[playerid][pDrugAddiction][z] = strval(wtmp[z]);
	}
}

CMD:drughelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_LIGHTRED,"��������ʾ�Դ:");
	SendClientMessage(playerid, COLOR_WHITE,"/mydrugs (�ҡ��ͧ����ʴ���餹����������ʹ�������) - /givedrug - /dropdrug - /usedrug");
	SendClientMessage(playerid, COLOR_WHITE,"- /transferdrug");
	return 1;
}

CMD:mydrugs(playerid, params[]) {
	new userid;

	if (sscanf(params, "u", userid))
	{
	    ShowPlayerDrugs(playerid, playerid);
	    return 1;
	}

	if(userid == INVALID_PLAYER_ID) {
		return SendClientMessage(playerid, COLOR_GRAD1, "ERROR:"EMBED_WHITE" �����蹹�鹵Ѵ�����������");
	}

	if (!IsPlayerNearPlayer(playerid, userid, 3.0))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE"  �����蹹��������������س");


    ShowPlayerDrugs(playerid, userid);

	return 1;
}

CMD:givedrug(playerid, params[]) {

	new userid, slot;
	if (sscanf(params, "ud", userid, slot))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "�����:"EMBED_WHITE" /givedrug [playerid / PoN] [package_id]");

	if(userid == playerid)
		return SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" �س�������ö������ͧ��!");

	if(userid == INVALID_PLAYER_ID) {
		return SendClientMessage(playerid, COLOR_GRAD1, "ERROR:"EMBED_WHITE" �����蹹�鹵Ѵ�����������");
	}

	if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendClientMessage(playerid, COLOR_GRAD1, "ERROR:"EMBED_WHITE" �����蹹��������������س");

	if(slot < 0 || slot >= MAX_PLAYER_DRUG_PACKAGE)
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" �ʹ���ࡨ���١��ͧ");

	if(PlayerDrug[playerid][slot][drugQTY] == 0)
     	return SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" ��辺��ࡨ����㹪�ͧ���");

	new bool:can_take;

	for(new x = 0; x != MAX_PLAYER_DRUG_PACKAGE; x++)
	{
		if(PlayerDrug[userid][x][drugQTY]==0) {

			can_take=true;

			PlayerDrug[userid][x][drugID] = PlayerDrug[playerid][slot][drugID]; // MYSQL NUMBER
			PlayerDrug[userid][x][drugType] = PlayerDrug[playerid][slot][drugType];
			PlayerDrug[userid][x][drugQTY] = PlayerDrug[playerid][slot][drugQTY];
			PlayerDrug[userid][x][drugStrength] = PlayerDrug[playerid][slot][drugStrength];
			PlayerDrug[userid][x][drugPackage] = PlayerDrug[playerid][slot][drugPackage];

			PlayerDrug[playerid][slot][drugQTY]=0;

            SendClientMessageEx(playerid, COLOR_YELLOW, "�س����� %s (%s) �Ѻ %s", 
			DrugPackageName[PlayerDrug[userid][x][drugPackage]], 
			DrugData[PlayerDrug[userid][x][drugType]][DRUGDATA_NAME],
			ReturnRealName(userid));
			
            SendClientMessageEx(userid, COLOR_YELLOW, "%s ����� %s (%s) �Ѻ�س", 
			ReturnRealName(playerid), 
			DrugPackageName[PlayerDrug[userid][x][drugPackage]], 
			DrugData[PlayerDrug[userid][x][drugType]][DRUGDATA_NAME]
			);


			new szQuery[256];
			format(szQuery, sizeof(szQuery), "UPDATE `drugs_char` SET `charID`=%d WHERE `drugID` = %d", playerData[userid][pSID], PlayerDrug[userid][x][drugID]);
			mysql_tquery(dbCon, szQuery);	
            /*Player_SavePackage(userid);
            Player_SavePackage(playerid);*/

			break;
		}
	}
	if(!can_take) SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" �����蹹������ժ�ͧ��ҧ����Ѻ��ࡨ���");
	return 1;
}

CMD:dropdrug(playerid, params[])
{
	new slot, Float:amount;

	if (sscanf(params, "df", slot, amount))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "�����:"EMBED_WHITE" /dropdrug [package_id] [�ӹǹ]");

	if(slot < 0 || slot >= MAX_PLAYER_DRUG_PACKAGE)
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" �ʹ���ࡨ���١��ͧ");

	if(PlayerDrug[playerid][slot][drugQTY] == 0)
     	return SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" ��辺��ࡨ����㹪�ͧ���");
	
	if(amount > 0 && amount <= PlayerDrug[playerid][slot][drugQTY]) {
	
		PlayerDrug[playerid][slot][drugQTY] -= amount;	
		PlayerDrug[playerid][slot][drugQTY] = PlayerDrug[playerid][slot][drugQTY];
		
		new szQuery[256];

		if(PlayerDrug[playerid][slot][drugQTY]<0.1) {
			PlayerDrug[playerid][slot][drugQTY] = 0;
			
			format(szQuery, sizeof(szQuery), "DELETE FROM `drugs_char` WHERE `drugID` = '%d'", PlayerDrug[playerid][slot][drugID]);
			mysql_tquery(dbCon, szQuery);
		}
		else {
			format(szQuery, sizeof(szQuery), "UPDATE `drugs_char` SET `drugQTY`='%1.f' WHERE `drugID` = '%d'", PlayerDrug[playerid][slot][drugQTY], PlayerDrug[playerid][slot][drugID]);
			mysql_tquery(dbCon, szQuery);
		}
		
		new strMSG[128];
		format(strMSG, sizeof(strMSG), "* %s ���� %s (%s)", ReturnRealName(playerid), DrugPackageName[PlayerDrug[playerid][slot][drugPackage]], DrugData[PlayerDrug[playerid][slot][drugType]][DRUGDATA_NAME]);
		SetPlayerChatBubble(playerid, strMSG, COLOR_PURPLE, 30.0, 6000);

		SendClientMessageEx(playerid, COLOR_YELLOW, "�س���� %s �ӹǹ %.1f", DrugData[PlayerDrug[playerid][slot][drugType]][DRUGDATA_NAME], amount);
			
	}
	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" �ӹǹ���١��ͧ");
	}
	return 1;
}

CMD:usedrug(playerid, params[]) {
	new slot, Float:amount, Float:health;

	GetPlayerHealth(playerid, health);

	if (health > 130)
		return SendClientMessage(playerid, COLOR_GRAD1, "�س��ͧ�����ʹ���¡��� 130 �֧������ö�����ʾ�Դ��");

	if (sscanf(params, "df", slot, amount))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "�����:"EMBED_WHITE" /usedrug [package_id] [�ӹǹ]");

	if (playerData[playerid][pLevel] < 3)
		return SendClientMessage(playerid, COLOR_GRAD1, "�س�ջ��ʺ��ó����ͷ��з�Ẻ��� (����ŵ���� 3 ������ҹ��)");

	if(slot < 0 || slot >= MAX_PLAYER_DRUG_PACKAGE)
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" �ʹ���ࡨ���١��ͧ");

	if(PlayerDrug[playerid][slot][drugQTY] == 0)
     	return SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" ��辺��ࡨ����㹪�ͧ���");
	
	if(amount <= PlayerDrug[playerid][slot][drugQTY]) {

		if(amount >= 0.1 && amount <= 0.4) {
			
			PlayerDrug[playerid][slot][drugQTY] -= amount;
			PlayerDrug[playerid][slot][drugQTY] = PlayerDrug[playerid][slot][drugQTY];
			
			new szQuery[128];
			if(PlayerDrug[playerid][slot][drugQTY]<0.1) {
				PlayerDrug[playerid][slot][drugQTY] = 0;
				
				format(szQuery, sizeof(szQuery), "DELETE FROM `drugs_char` WHERE `drugID` = '%d'", PlayerDrug[playerid][slot][drugID]);
				mysql_tquery(dbCon, szQuery);
			}
			else {
				format(szQuery, sizeof(szQuery), "UPDATE `drugs_char` SET `drugQTY`='%1.f' WHERE `drugID` = '%d'", PlayerDrug[playerid][slot][drugQTY], PlayerDrug[playerid][slot][drugID]);
				mysql_tquery(dbCon, szQuery);
			}

			format(szQuery, sizeof(szQuery), "* %s ���� %s", ReturnRealName(playerid), DrugData[PlayerDrug[playerid][slot][drugType]][DRUGDATA_NAME]);
			SetPlayerChatBubble(playerid, szQuery, COLOR_PURPLE, 30.0, 6000);
			
			UseDrug(playerid, PlayerDrug[playerid][slot][drugType], amount + 0.6, PlayerDrug[playerid][slot][drugStrength]);

			SendClientMessageEx(playerid, COLOR_YELLOW, "�س���� %s �ӹǹ %.1f ����", DrugData[PlayerDrug[playerid][slot][drugType]][DRUGDATA_NAME], amount);
				
		}
		else {
			SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" �ӹǹ������ͧ����ӡ��� 0.1 �����ҡ���� 0.4");
		}
		
	}
	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" �ӹǹ���١��ͧ (0.1 - 0.4)");
	}
	return 1;
}

ShowPlayerDrugs(playerid, toplayer)
{
	new bool:count=false;
	SendClientMessageEx(toplayer, COLOR_LIGHTRED, "���ʾ�Դ�ͧ %s:", ReturnRealName(playerid));
	for(new i = 0; i != MAX_PLAYER_DRUG_PACKAGE; i++)
	{
		if(PlayerDrug[playerid][i][drugQTY]>0) {

			SendClientMessageEx(toplayer, -1, "{FF6347}["EMBED_WHITE" %d. %s (%s: %.1f%s / %d.0%s) (�س�Ҿ: %d) {FF6347}]", 
			i, 
			DrugPackageName[PlayerDrug[playerid][i][drugPackage]], 
			DrugData[PlayerDrug[playerid][i][drugType]][DRUGDATA_NAME],
			PlayerDrug[playerid][i][drugQTY],
			DrugData[PlayerDrug[playerid][i][drugType]][DRUGDATA_TYPE] ? (" ���") : (" ����"),
			floatround(DrugData[PlayerDrug[playerid][i][drugType]][DRUGDATA_TYPE] ? DrugPackageSize[PlayerDrug[playerid][i][drugPackage]] * 2.285714 : DrugPackageSize[PlayerDrug[playerid][i][drugPackage]]),
			DrugData[PlayerDrug[playerid][i][drugType]][DRUGDATA_TYPE] ? (" ���") : (" ����"),
			PlayerDrug[playerid][i][drugStrength]);	
			
			
			count=true;
		}
	}
	if(!count) {
		SendClientMessage(toplayer, -1, "��������ʾ�Դ�����ʴ�");
	}
}

flags:removedrug(CMD_ADM_3);
CMD:removedrug(playerid, params[]) {

	new userid, slot, Float:amount;
	if (sscanf(params, "ud", userid, slot))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "�����:"EMBED_WHITE" /removedrug [�ʹռ�����/���ͺҧ��ǹ] [��ͧ]");

	if(userid == INVALID_PLAYER_ID) {
		return SendClientMessage(playerid, COLOR_GRAD1, "ERROR:"EMBED_WHITE" �����蹹�鹵Ѵ�����������");
	}

	if(slot < 0 || slot >= MAX_PLAYER_DRUG_PACKAGE)
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" �ʹ���ࡨ���١��ͧ");

	if(PlayerDrug[userid][slot][drugQTY] == 0)
     	return SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" ��辺��ࡨ����㹪�ͧ���");
	
	if(amount <= PlayerDrug[userid][slot][drugQTY]) {
	
		PlayerDrug[userid][slot][drugQTY] -= amount;
		PlayerDrug[userid][slot][drugQTY] = PlayerDrug[userid][slot][drugQTY];
		
		new szQuery[256];
		if(PlayerDrug[userid][slot][drugQTY]<0.1) {
			PlayerDrug[userid][slot][drugQTY] = 0;
			
			format(szQuery, sizeof(szQuery), "DELETE FROM `drugs_char` WHERE `drugID` = '%d'", PlayerDrug[userid][slot][drugID]);
			mysql_tquery(dbCon, szQuery);
		}
		else {
			format(szQuery, sizeof(szQuery), "UPDATE `drugs_char` SET `drugQTY`='%1.f' WHERE `drugID` = '%d'", PlayerDrug[userid][slot][drugQTY], PlayerDrug[userid][slot][drugID]);
			mysql_tquery(dbCon, szQuery);
		}
		
		SendClientMessageEx(playerid, COLOR_YELLOW, "�س���ִ %s �ӹǹ %.1f �ͧ %s", DrugData[PlayerDrug[userid][slot][drugType]][DRUGDATA_NAME], amount, ReturnPlayerName(userid));

	}
	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" �ӹǹ���١��ͧ");
	}
	return 1;
}

flags:spawndrug(CMD_ADM_3);
CMD:spawndrug(playerid) {

	if(playerData[playerid][pAdmin] < 3) return SendClientMessage(playerid, COLOR_GREY, "�س������Ѻ͹حҵ��������觹��");

	new str[1024];

	format(str, sizeof(str), "#\tDrug Name\n");
	for(new i=0;i!=sizeof(DrugData);i++) {
		format(str, sizeof(str), "%s%d\t%s\n", str, i, DrugData[i][DRUGDATA_NAME]);
	}
	Dialog_Show(playerid, AdminDrugCreate_Type, DIALOG_STYLE_TABLIST_HEADERS, "Admin Tools: Drug Spawn", str, "���͡", "��Ѻ");
	return 1;
}

Dialog:AdminDrugCreate_Type(playerid, response, listitem, inputtext[]) {
	if(response) {	
		new str[800];
		SetPVarInt(playerid, "AdminDrugCreate_drugid", listitem);
		
		format(str, sizeof(str), "#\tStorage Name\n");
		for(new i=0;i!=MAX_DRUG_TYPE;i++) {
			format(str, sizeof(str), "%s%d\t%s (������: %.1fg)\n", str, i, DrugPackageName[i], DrugPackageSize[i]);
		}
		Dialog_Show(playerid, AdminDrugCreate_Package, DIALOG_STYLE_TABLIST_HEADERS, "Admin Tools: Drug Spawn", str, "���͡", "��Ѻ");
	}
	return 1;
}

Dialog:AdminDrugCreate_Package(playerid, response, listitem, inputtext[]) {
	if(response) {	
		new str[512];
		
		new drugid = GetPVarInt(playerid, "AdminDrugCreate_drugid");
		SetPVarInt(playerid, "AdminDrugCreate_package", listitem);
		
		format(str, sizeof(str), "���ʾ�Դ: %s\n��ࡨ������͡ %s (������: %d.0%s)\n\n��͡�ӹǹ�س�Ҿ (0-100):", DrugData[drugid][DRUGDATA_NAME], DrugPackageName[listitem], floatround(DrugData[drugid][DRUGDATA_TYPE] ? DrugPackageSize[listitem] * 2.285714 : DrugPackageSize[listitem]), DrugData[drugid][DRUGDATA_TYPE] ? (" ���") : ("����"));
		Dialog_Show(playerid, AdminDrugCreate_Strength, DIALOG_STYLE_INPUT, "Admin Tools: Drug Spawn", str, "���͡", "��Ѻ");	
	}
	else {
		PC_EmulateCommand(playerid, "/spawndrug");
	}
	return 1;
}

Dialog:AdminDrugCreate_Strength(playerid, response, listitem, inputtext[]) {
	new str[800];
	if(response) {	
	
		new strength = strval(inputtext);
		if(strength >= 0 || strength <= 100) {
			new packageid = GetPVarInt(playerid, "AdminDrugCreate_package");
			new drugid = GetPVarInt(playerid, "AdminDrugCreate_drugid");
			SetPVarInt(playerid, "AdminDrugCreate_strength", strength);
		
			format(str, sizeof(str), "���ʾ�Դ: %s\n��ࡨ������͡ %s (������: %d.0%s)\n�س�Ҿ: %d\n\n��͡�ӹǹ���ʾ�Դ����ͧ���:", DrugData[drugid][DRUGDATA_NAME], DrugPackageName[packageid], floatround(DrugData[drugid][DRUGDATA_TYPE] ? DrugPackageSize[packageid] * 2.285714 : DrugPackageSize[packageid]), DrugData[drugid][DRUGDATA_TYPE] ? (" ���") : ("����"), strength);
			Dialog_Show(playerid, AdminDrugCreate_Amount, DIALOG_STYLE_INPUT, "Admin Tools: Drug Spawn", str, "Done", "Back");
		}
		else {
			new drugid = GetPVarInt(playerid, "AdminDrugCreate_drugid");
			SetPVarInt(playerid, "AdminDrugCreate_package", listitem);
			
			format(str, sizeof(str), "���ʾ�Դ: %s\n��ࡨ������͡ %s (������: %d.0%s)\n\n��͡�ӹǹ�س�Ҿ (0-100):", DrugData[drugid][DRUGDATA_NAME], DrugPackageName[listitem], floatround(DrugData[drugid][DRUGDATA_TYPE] ? DrugPackageSize[listitem] * 2.285714 : DrugPackageSize[listitem]), DrugData[drugid][DRUGDATA_TYPE] ? (" ���") : ("����"));
			Dialog_Show(playerid, AdminDrugCreate_Strength, DIALOG_STYLE_INPUT, "Admin Tools: Drug Spawn", str, "���͡", "��Ѻ");	
		}
	}
	else {
		format(str, sizeof(str), "#\tStorage Name\n");
		for(new i=0;i!=MAX_DRUG_TYPE;i++) {
			format(str, sizeof(str), "%s%d\t%s (������: %.1fg)\n", str, i, DrugPackageName[i], DrugPackageSize[i]);
		}
		Dialog_Show(playerid, AdminDrugCreate_Package, DIALOG_STYLE_TABLIST_HEADERS, "Admin Tools: Drug Spawn", str, "���͡", "��Ѻ");
	}
	return 1;
}

Dialog:AdminDrugCreate_Amount(playerid, response, listitem, inputtext[]) {
	if(response) {	
	

		new drugid = GetPVarInt(playerid, "AdminDrugCreate_drugid");
		new packageid = GetPVarInt(playerid, "AdminDrugCreate_package");
		new strength = GetPVarInt(playerid, "AdminDrugCreate_strength");
		new Float:transfer_amount = floatstr(inputtext), str[512];

		if(transfer_amount > 0) {
		
			new grams = floatround(DrugData[drugid][DRUGDATA_TYPE] ? transfer_amount / 2.285714 : transfer_amount);

			if(floatround(DrugPackageSize[packageid]) >= grams) {
			
				new szQuery[256];
				for(new x = 0; x != MAX_PLAYER_DRUG_PACKAGE; x++)
				{
					if(PlayerDrug[playerid][x][drugQTY] == 0) {
					
						format(szQuery, sizeof(szQuery), "INSERT INTO `drugs_char` (`drugType`,`drugQTY`,`drugStrength`,`drugPackage`,`charID`) VALUES(%d,%f,%d,%d,%d)", drugid, transfer_amount, strength, packageid, playerData[playerid][pSID]);
						mysql_tquery(dbCon, szQuery, "OnDrugAdminCreate", "dddfdd", playerid, x, drugid, transfer_amount, strength, packageid);	
		
						DeletePVar(playerid, "AdminDrugCreate_drugid");
						DeletePVar(playerid, "AdminDrugCreate_package");
						DeletePVar(playerid, "AdminDrugCreate_strength");
						
						return 1;
					}
				}
				SendClientMessage(playerid, COLOR_LIGHTRED,"ERROR:"EMBED_WHITE" �س�������ͪ�ͧ��ҧ����Ѻ��ࡨ���");
			}
			else {
				SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" �ӹǹ���١��ͧ");
			}
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" �ӹǹ���١��ͧ");
		
		format(str, sizeof(str), "���ʾ�Դ: %s\n��ࡨ������͡ %s (������: %d.0%s)\n�س�Ҿ: %d\n\n��͡�ӹǹ����ͧ���:", DrugData[drugid][DRUGDATA_NAME], DrugPackageName[packageid], floatround(DrugData[drugid][DRUGDATA_TYPE] ? DrugPackageSize[packageid] * 2.285714 : DrugPackageSize[packageid]), DrugData[drugid][DRUGDATA_TYPE] ? (" ���") : ("����"), strength);
		Dialog_Show(playerid, AdminDrugCreate_Amount, DIALOG_STYLE_INPUT, "Admin Tools: Drug Spawn", str, "���͡", "��Ѻ");	
	}
	else {
		new str[800];
		format(str, sizeof(str), "#\tStorage Name\n");
		for(new i=0;i!=MAX_DRUG_TYPE;i++) {
			format(str, sizeof(str), "%s%d\t%s (������: %.1fg)\n", str, i, DrugPackageName[i], DrugPackageSize[i]);
		}
		Dialog_Show(playerid, AdminDrugCreate_Package, DIALOG_STYLE_TABLIST_HEADERS, "Admin Tools: Drug Spawn", str, "���͡", "��Ѻ");
	}
	return 1;
}

forward OnDrugAdminCreate(playerid, slot, drugid, Float:transfer_amount, strength, packageid);
public OnDrugAdminCreate(playerid, slot, drugid, Float:transfer_amount, strength, packageid)
{
	if(PlayerDrug[playerid][slot][drugQTY] == 0) {
		PlayerDrug[playerid][slot][drugID] = cache_insert_id(); // MYSQL NUMBER
		PlayerDrug[playerid][slot][drugType] = drugid;
		PlayerDrug[playerid][slot][drugQTY] = transfer_amount;
		PlayerDrug[playerid][slot][drugStrength] = strength;
		PlayerDrug[playerid][slot][drugPackage] = packageid;
		
		SendClientMessageEx(playerid, COLOR_YELLOW, "�س�����ҧ %s �ӹǹ %.1fg ���������ࡨ %s", DrugData[PlayerDrug[playerid][slot][drugType]][DRUGDATA_NAME], transfer_amount, DrugPackageName[PlayerDrug[playerid][slot][drugPackage]]);	
	}
	else {
		SendClientMessage(playerid, COLOR_LIGHTRED,"ERROR:"EMBED_WHITE" �س�������ͪ�ͧ��ҧ����Ѻ��ࡨ���");
	}
}


forward UseDrug(playerid, drugid, Float:level, strength);
public UseDrug(playerid, drugid, Float:level, strength) {

	static const DrugsAddict[MAX_DRUGS][5] =
	{
		/*
			0 - �ʾ�Դ�����á
			1 - �ҡ�Դ��������
			2 - ��������͵Դ��������
			3 - �Դ�Ҫ�Դ�����������
			4 - ��ҵԴ�ҵ���������������
		*/
		{3, 3, 6, 2, 15}, //Cocaine
		{0, 0, 0, 0, 0}, //Cannabis
		{3, 3, 6, 2, 15}, //Xanax
		{3, 3, 6, 2, 15}, //MDMA
		{3, 3, 6, 2, 15}, //Heroin
		{3, 3, 6, 2, 15}, //Ketamine
		{3, 3, 6, 2, 15}, //Fentanyl
		{3, 3, 6, 2, 15}, //Methamphetamine
		{3, 3, 3, 1, 7}, //Steroids
		{3, 3, 6, 2, 15} //Oxycodone
	};
	
	static const Float:DrugsHealth[MAX_DRUGS][4] =
	{
		/*
			0 - ���ʹ������������
			1 - ⺹�������٧�ش
			2 - �ӹǹ�Թҷ�
			3 - �����������
		*/
		{7.0, 70.0, 10.0, 10.0}, //Cocaine
		{3.0, 45.0, 15.0, 9.0}, //Cannabis
		{4.0, 40.0, 15.0, 10.0}, //Xanax
		{5.0, 35.0, 12.0, 10.0}, //MDMA
		{5.0, 65.0, 12.0, 10.0}, //Heroin
		{6.0, 60.0, 10.0, 10.0}, //Ketamine
		{6.0, 60.0, 10.0, 10.0}, //Fentanyl
		{10.0, 50.0, 13.0, 7.0}, //Methamphetamine
		{10.0, 50.0, 20.0, 10.0}, //Steroids
		{5.0, 50.0, 20.0, 10.0} //Oxycodone
	};
	
	if(playerData[playerid][pDrugAddiction][drugid] == 0) {
		playerData[playerid][pDrugAddiction][drugid] = DrugsAddict[drugid][0];
	}
	else {

		if(DrugsAddict[drugid][1] > 0)
			playerData[playerid][pDrugAddiction][drugid] += DrugsAddict[drugid][1] + (random(DrugsAddict[drugid][2]) + 1);
		
		if(DrugAddiction_OtherDrug(playerid, drugid)) {
			if(DrugsAddict[drugid][3] > 0)
				playerData[playerid][pDrugAddiction][drugid] += DrugsAddict[drugid][3];
		}
		if(playerData[playerid][pDrugAddict] && playerData[playerid][pDrugAddict] != drugid + 1) {
			
			if(DrugsAddict[drugid][4] > 0) {
				playerData[playerid][pDrugAddiction][drugid] += DrugsAddict[drugid][4];
				
				if(strength >= playerData[playerid][pDrugAddictStrength] && playerData[playerid][pDrugAddiction][drugid] > DrugsAddict[drugid][4]) {
					playerData[playerid][pDrugAddict] = drugid + 1;
					playerData[playerid][pDrugAddictStrength] = strength;
				}
			}
		}
		
		if(playerData[playerid][pDrugAddict] && playerData[playerid][pDrugAddict] == drugid + 1)
			SufferDrugs{playerid}=true;
	}
	
	if(playerData[playerid][pDrugAddiction][drugid] > 100) {
		playerData[playerid][pDrugAddiction][drugid] = 100;
	}
	
	// �������
	if(DrugsHealth[drugid][3]) {
		if(playerData[playerid][pSHealth] / DrugsHealth[drugid][3] > 0) {
			playerData[playerid][pHunger] += playerData[playerid][pSHealth] / DrugsHealth[drugid][3];
		}
	}
	
	//���ʹ����
	if(playerData[playerid][pDrugAddiction][drugid] < 70) {
		if(EffectDrugs_Timer[playerid] != Timer:0) {
			stop EffectDrugs_Timer[playerid];
			EffectDrugs_Timer[playerid] = Timer:0;
		}
		EffectDrugs[playerid]=DrugsHealth[drugid][1];
		EffectDrugAmount[playerid] = floatround(DrugsHealth[drugid][2]);
		EffectDrugs_Timer[playerid] = repeat drugEffects(playerid, DrugsHealth[drugid][0] * level);

		GameTextForPlayer(playerid, "~r~Max Health Increase", 5000, 4);
		//SetPlayerMaxHealth(playerid, 200.0);
	}
	return 1;
}

DrugAddiction_OtherDrug(playerid, drugid) {
	for(new i=0;i!=MAX_DRUGS;i++) {
		if(playerData[playerid][pDrugAddiction][i] != drugid) {
			return true;
		}
	}
	return false;
}

timer drugEffects[1000](playerid, Float:amount)
{
	if(gIsDeathMode{playerid} || gIsInjuredMode{playerid} || EffectDrugAmount[playerid] <= 0) {
		stop EffectDrugs_Timer[playerid];
		EffectDrugs_Timer[playerid]=Timer:0;
		return true;
	}

	if(playerData[playerid][pHealth] > 200) SetPlayerHealthEx(playerid, 200.0); 
	else 
	{
		SetPlayerHealthEx(playerid,(playerData[playerid][pHealth] + amount));
		EffectDrugs[playerid] -= amount;
		if(EffectDrugs[playerid] <= 0.0) {
			stop EffectDrugs_Timer[playerid];
			EffectDrugs_Timer[playerid]=Timer:0;
		}
	}
	EffectDrugAmount[playerid]--;
	return true; 
}


ptask DrugUpdate[60000](playerid) {
	if(AddictDrugs[playerid] != 0 && AddictTimer[playerid] == Timer:0) {
		AddictTimer[playerid] = repeat drugAddictTimer(playerid);
	}
	return 1;
}

timer drugAddictTimer[70000](playerid)
{
	if(IsPlayerConnected(playerid)) {
		new Float:decrease;
		decrease = playerData[playerid][pDrugAddiction][playerData[playerid][pDrugAddict]-1]/10;
		if(playerData[playerid][pHealth] - decrease > 0) SetPlayerHealthEx(playerid, playerData[playerid][pHealth] - decrease);
		else SetPlayerHealthEx(playerid, 1);
		AddictDrugs[playerid]-=4;
	}
	if(AddictDrugs[playerid] <= 0) {
		stop AddictTimer[playerid];
		AddictTimer[playerid]=Timer:0;
	}
}

ptask DrugTimer[900000](playerid) {
	if(!SufferDrugs{playerid} && AddictDrugs[playerid]==0 && random(5) == 0 && playerData[playerid][pDrugAddict] > 0 && playerData[playerid][pDrugAddiction][playerData[playerid][pDrugAddict]-1] >= 70) {
		AddictDrugs[playerid] = playerData[playerid][pDrugAddiction][playerData[playerid][pDrugAddict]-1]; // Ŵ�ҷ������
		SendClientMessage(playerid, COLOR_YELLOW, "�س��������ҡ����ҡ���ʾ�Դ");
	}
	return 1;
}

forward OnLoadDrug(playerid);
public OnLoadDrug(playerid) {
	new rows;
    cache_get_row_count(rows);
	if (rows) {
	    for (new i = 0; i < rows; i ++) if(i < MAX_PLAYER_DRUG_PACKAGE)
	    {
			cache_get_value_name_int(i, "drugID", PlayerDrug[playerid][i][drugID]);
			cache_get_value_name_int(i, "drugType", PlayerDrug[playerid][i][drugType]);
			cache_get_value_name_float(i, "drugQTY", PlayerDrug[playerid][i][drugQTY]);
			cache_get_value_name_int(i, "drugStrength", PlayerDrug[playerid][i][drugStrength]);
			cache_get_value_name_int(i, "drugPackage", PlayerDrug[playerid][i][drugPackage]);
		}
	}
}

FormatDrugAddiction(playerid)
{
	new wstr[256];
	new tmp[32];
	for(new a = 0; a != MAX_DRUGS; ++a)
	{
		if(!a) format(tmp,sizeof(tmp),"%d",playerData[playerid][pDrugAddiction][a]);
		else format(tmp,sizeof(tmp),"|%d",playerData[playerid][pDrugAddiction][a]);
		strins(wstr,tmp,strlen(wstr));
	}
	return wstr;
}

CMD:transferdrug(playerid, params[]) {
	new slot;
	if (sscanf(params, "d", slot))
	    return SendClientMessage(playerid, COLOR_LIGHTRED, "USAGE:"EMBED_WHITE" /transferdrug [package_id]");

	if(slot < 0 || slot >= MAX_PLAYER_DRUG_PACKAGE)
		return SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" �ʹ���ࡨ���١��ͧ");
	
	if(PlayerDrug[playerid][slot][drugQTY] == 0)
		return SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" ��辺��ࡨ����㹪�ͧ���");
			
	SetPVarInt(playerid, "TransferDrug", slot);
	Dialog_Show(playerid, TransferDrugMenu, DIALOG_STYLE_LIST, "Transfer Drug", "������ѧ��ࡨ����\n������ѧ��ࡨ���������", "�Ѵ�", "�͡");
	
	return 1;
}

Dialog:TransferDrugMenu(playerid, response, listitem, inputtext[])
{
	if(response) {
		
		if(listitem==0) {
			new str[800];

			if (isPlayerAndroid(playerid) != 0) {
				SetPVarInt(playerid, "TransferDrugMenu", 1);
				for(new i=0;i!=MAX_DRUG_TYPE;i++) {
					format(str, sizeof(str), "%s%d\t%s (������: %.1fg)\n", str, i, DrugPackageName[i], DrugPackageSize[i]);
				}
				Dialog_Show(playerid, TransferDrugNewPackage, DIALOG_STYLE_LIST, "Transfer Drug", str, "���͡", "��Ѻ");
			}
			else {
				SetPVarInt(playerid, "TransferDrugMenu", 1);
				format(str, sizeof(str), "#\tStorage Name\n");
				for(new i=0;i!=MAX_DRUG_TYPE;i++) {
					format(str, sizeof(str), "%s%d\t%s (������: %.1fg)\n", str, i, DrugPackageName[i], DrugPackageSize[i]);
				}
				Dialog_Show(playerid, TransferDrugNewPackage, DIALOG_STYLE_TABLIST_HEADERS, "Transfer Drug", str, "���͡", "��Ѻ");
			}
		}
		else {
			new str[1024];
			new slot = GetPVarInt(playerid, "TransferDrug");
			new bool:count;
			SetPVarInt(playerid, "TransferDrugMenu", 2);
			
			for(new i = 0; i != MAX_PLAYER_DRUG_PACKAGE; i++)
			{
				if(i != slot && PlayerDrug[playerid][i][drugQTY]>0 && PlayerDrug[playerid][i][drugType] == PlayerDrug[playerid][slot][drugType] && PlayerDrug[playerid][i][drugStrength] == PlayerDrug[playerid][slot][drugStrength]) {
					
					format(str, sizeof(str), "%s%s %s (������: %.1f%s / %d.0%s) (���������: %d)\n", 
					str, 
					DrugPackageName[PlayerDrug[playerid][i][drugPackage]], 
					DrugData[PlayerDrug[playerid][i][drugType]][DRUGDATA_NAME],
					PlayerDrug[playerid][i][drugQTY],
					DrugData[PlayerDrug[playerid][i][drugType]][DRUGDATA_TYPE] ? (" ���") : ("����"),
					floatround(DrugData[PlayerDrug[playerid][i][drugType]][DRUGDATA_TYPE] ? DrugPackageSize[PlayerDrug[playerid][i][drugPackage]] * 2.285714 : DrugPackageSize[PlayerDrug[playerid][i][drugPackage]]),
					DrugData[PlayerDrug[playerid][i][drugType]][DRUGDATA_TYPE] ? (" ���") : ("����"),
					PlayerDrug[playerid][i][drugStrength]);
					count = true;
				}
			}
			if(count) Dialog_Show(playerid, TransferDrugExistPackage, DIALOG_STYLE_LIST, "Transfer Drug", str, "���͡", "��Ѻ");
			else Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "Transfer Drug", "��辺��ࡨ�������ö������", "O", "K");
		}
	}
	else {
		DeletePVar(playerid, "TransferDrug");
	}
	return 1;
}

Dialog:TransferDrugExistPackage(playerid, response, listitem, inputtext[])
{
	if(response) {
		new str[256], slot = GetPVarInt(playerid, "TransferDrug");
		SetPVarInt(playerid, "TransferPackage", listitem);
		format(str, sizeof(str), "%s �ͧ�س�Ѩ�غѹ�� %s ���� %.1f%s\n\n�س��ͧ�������������?", DrugPackageName[PlayerDrug[playerid][slot][drugPackage]], DrugData[PlayerDrug[playerid][slot][drugType]][DRUGDATA_NAME], PlayerDrug[playerid][slot][drugQTY], DrugData[PlayerDrug[playerid][slot][drugType]][DRUGDATA_TYPE] ? (" ���") : ("����"));
		Dialog_Show(playerid, TransferDrugAmount, DIALOG_STYLE_INPUT, "Transfer Drug", str, "���͡", "��Ѻ");	
	}
	else {
		Dialog_Show(playerid, TransferDrugMenu, DIALOG_STYLE_LIST, "Transfer Drug", "������ѧ��ࡨ����\n������ѧ��ࡨ���������", "Next", "Exit");
	}
	return 1;
}

Dialog:TransferDrugNewPackage(playerid, response, listitem, inputtext[])
{
	if(response) {
		new str[256], slot = GetPVarInt(playerid, "TransferDrug");
		SetPVarInt(playerid, "TransferPackage", listitem);
		format(str, sizeof(str), "%s �ͧ�س�Ѩ�غѹ�� %s ���� %.1f%s\n\n�س��ͧ�������������?", DrugPackageName[PlayerDrug[playerid][slot][drugPackage]], DrugData[PlayerDrug[playerid][slot][drugType]][DRUGDATA_NAME], PlayerDrug[playerid][slot][drugQTY], DrugData[PlayerDrug[playerid][slot][drugType]][DRUGDATA_TYPE] ? (" ���") : ("����"));
		Dialog_Show(playerid, TransferDrugAmount, DIALOG_STYLE_INPUT, "Transfer Drug", str, "���͡", "��Ѻ");	
	}
	else {
		Dialog_Show(playerid, TransferDrugMenu, DIALOG_STYLE_LIST, "Transfer Drug", "������ѧ��ࡨ����\n������ѧ��ࡨ���������", "Next", "Exit");
	}
	return 1;
}

Dialog:TransferDrugAmount(playerid, response, listitem, inputtext[])
{
	new transfertype = GetPVarInt(playerid, "TransferDrugMenu");
	
	if(response) {
	
		new packageid = GetPVarInt(playerid, "TransferPackage");
		new Float:transfer_amount = floatstr(inputtext), str[256];
		new slot = GetPVarInt(playerid, "TransferDrug"), Float:grams;

		if(transfertype == 1) {
			if(PlayerDrug[playerid][slot][drugQTY] > 0 && transfer_amount <= PlayerDrug[playerid][slot][drugQTY] && transfer_amount >= 0.1) {
			
				grams = DrugData[PlayerDrug[playerid][slot][drugType]][DRUGDATA_TYPE] ? transfer_amount / 2.285714 : transfer_amount;

				if(DrugPackageSize[packageid] >= grams) {
				
					for(new x = 0; x != MAX_PLAYER_DRUG_PACKAGE; x++)
					{
						if(PlayerDrug[playerid][x][drugQTY] == 0) {

							new szQuery[256];
							format(szQuery, sizeof(szQuery), "INSERT INTO `drugs_char` (`drugType`,`drugQTY`,`drugStrength`,`drugPackage`,`charID`) VALUES('%d','%f','%d','%d','%d')", PlayerDrug[playerid][slot][drugType], transfer_amount, PlayerDrug[playerid][slot][drugStrength], PlayerDrug[playerid][slot][drugPackage], playerData[playerid][pSID]);
							mysql_tquery(dbCon, szQuery, "OnDrugTransferNew", "ddddf", playerid, slot, packageid, x, transfer_amount);
									
							return 1;
						}
					}
					SendClientMessage(playerid, COLOR_LIGHTRED,"ERROR:"EMBED_WHITE" �س�������ͪ�ͧ��ҧ����Ѻ��ࡨ���");
				}
				else {
					SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" ��ࡨ����վ�鹷�������§������Ѻ�Ңͧ�س");
				}
			}
			else SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" ��辺��ࡨ����㹪�ͧ���/�ӹǹ����ͧ����������١��ͧ");
		
			format(str, sizeof(str), "%s �ͧ�س�Ѩ�غѹ�� %s ���� %.1f%s\n\n�س��ͧ�������������?", DrugPackageName[PlayerDrug[playerid][slot][drugPackage]], DrugData[PlayerDrug[playerid][slot][drugType]][DRUGDATA_NAME], PlayerDrug[playerid][slot][drugQTY], DrugData[PlayerDrug[playerid][slot][drugType]][DRUGDATA_TYPE] ? (" ���") : ("����"));
			Dialog_Show(playerid, TransferDrugAmount, DIALOG_STYLE_INPUT, "Transfer Drug", str, "���͡", "��Ѻ");
		}
		else {
			if(PlayerDrug[playerid][slot][drugQTY] >= 0.1 && transfer_amount <= PlayerDrug[playerid][slot][drugQTY] && transfer_amount >= 0.1) {
			
				for(new i = 0; i != MAX_PLAYER_DRUG_PACKAGE; i++)
				{
					if(i != slot && PlayerDrug[playerid][i][drugQTY]>0 && PlayerDrug[playerid][i][drugType] == PlayerDrug[playerid][slot][drugType] && PlayerDrug[playerid][i][drugStrength] == PlayerDrug[playerid][slot][drugStrength]) {
						if(packageid) {
							packageid--;
							continue;
						}
						if(PlayerDrug[playerid][i][drugQTY]) {
						
							grams = (DrugData[PlayerDrug[playerid][slot][drugType]][DRUGDATA_TYPE] ? transfer_amount / 2.285714 : transfer_amount) + (DrugData[PlayerDrug[playerid][slot][drugType]][DRUGDATA_TYPE] ? PlayerDrug[playerid][i][drugQTY] / 2.285714 : PlayerDrug[playerid][i][drugQTY]);
				
							if(floatround(grams) <= floatround(DrugPackageSize[PlayerDrug[playerid][i][drugPackage]])) {
								
								PlayerDrug[playerid][slot][drugQTY] -= transfer_amount;
								PlayerDrug[playerid][slot][drugQTY] = PlayerDrug[playerid][slot][drugQTY];
								
								new szQuery[256];

								if(PlayerDrug[playerid][slot][drugQTY]<0.1) {
									PlayerDrug[playerid][slot][drugQTY] = 0;
									
									format(szQuery, sizeof(szQuery), "DELETE FROM `drugs_char` WHERE `drugID` = '%d'", PlayerDrug[playerid][slot][drugID]);
									mysql_tquery(dbCon, szQuery);
								}
								else {
									format(szQuery, sizeof(szQuery), "UPDATE `drugs_char` SET `drugQTY`='%1.f' WHERE `drugID` = '%d'", PlayerDrug[playerid][slot][drugQTY], PlayerDrug[playerid][slot][drugID]);
									mysql_tquery(dbCon, szQuery);
								}
								
								PlayerDrug[playerid][i][drugQTY] += transfer_amount;
								PlayerDrug[playerid][i][drugQTY] = PlayerDrug[playerid][i][drugQTY];
								
								SendClientMessageEx(playerid, COLOR_YELLOW, "�س������ %s �ӹǹ %.1fg ���������ࡨ %s", DrugData[PlayerDrug[playerid][i][drugType]][DRUGDATA_NAME], transfer_amount, DrugPackageName[PlayerDrug[playerid][i][drugPackage]]);

								format(szQuery, sizeof(szQuery), "UPDATE `drugs_char` SET `drugQTY`='%1.f' WHERE `drugID` = '%d'", PlayerDrug[playerid][i][drugQTY], PlayerDrug[playerid][i][drugID]);
								mysql_tquery(dbCon, szQuery);
								
								return 1;
							}
							else {
								SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" ��ࡨ����վ�鹷�������§������Ѻ�Ңͧ�س");
							}
						}
						else {
							SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" ��辺��ࡨ����㹪�ͧ���");
						}
						break;
					}
				}
			}
			else SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR:"EMBED_WHITE" ��辺��ࡨ����㹪�ͧ���/�ӹǹ����ͧ����������١��ͧ");
		
			format(str, sizeof(str), "%s �ͧ�س�Ѩ�غѹ�� %s ���� %.1f%s\n\n�س��ͧ�������������?", DrugPackageName[PlayerDrug[playerid][slot][drugPackage]], DrugData[PlayerDrug[playerid][slot][drugType]][DRUGDATA_NAME], PlayerDrug[playerid][slot][drugQTY], DrugData[PlayerDrug[playerid][slot][drugType]][DRUGDATA_TYPE] ? (" ���") : ("����"));
			Dialog_Show(playerid, TransferDrugAmount, DIALOG_STYLE_INPUT, "Transfer Drug", str, "���͡", "��Ѻ");
		}
	}
	else {
		if(transfertype == 1) {
			new str[800];
			if (isPlayerAndroid(playerid) != 0) 
			{
				for(new i=0;i!=MAX_DRUG_TYPE;i++) {
					format(str, sizeof(str), "%s%d\t%s (������: %.1fg)\n", str, i, DrugPackageName[i], DrugPackageSize[i]);
				}
				Dialog_Show(playerid, TransferDrugNewPackage, DIALOG_STYLE_LIST, "Transfer Drug", str, "���͡", "��Ѻ");
			}
			else {
				format(str, sizeof(str), "#\tStorage Name\n");
				for(new i=0;i!=MAX_DRUG_TYPE;i++) {
					format(str, sizeof(str), "%s%d\t%s (������: %.1fg)\n", str, i, DrugPackageName[i], DrugPackageSize[i]);
				}
				Dialog_Show(playerid, TransferDrugNewPackage, DIALOG_STYLE_TABLIST_HEADERS, "Transfer Drug", str, "���͡", "��Ѻ");
			}
		}
		else {
			new str[1024];
			new slot = GetPVarInt(playerid, "TransferDrug");
			SetPVarInt(playerid, "TransferDrugMenu", 2);
			
			for(new i = 0; i != MAX_PLAYER_DRUG_PACKAGE; i++)
			{
				if(i != slot && PlayerDrug[playerid][i][drugQTY]>0 && PlayerDrug[playerid][i][drugType] == PlayerDrug[playerid][slot][drugType] && PlayerDrug[playerid][i][drugStrength] == PlayerDrug[playerid][slot][drugStrength]) {
					
					format(str, sizeof(str), "%s%s %s (������: %.1f%s / %d.0%s) (���������: %d)\n", 
					str, 
					DrugPackageName[PlayerDrug[playerid][i][drugPackage]], 
					DrugData[PlayerDrug[playerid][i][drugType]][DRUGDATA_NAME],
					PlayerDrug[playerid][i][drugQTY],
					DrugData[PlayerDrug[playerid][i][drugType]][DRUGDATA_TYPE] ? (" ���") : ("����"),
					floatround(DrugData[PlayerDrug[playerid][i][drugType]][DRUGDATA_TYPE] ? DrugPackageSize[PlayerDrug[playerid][i][drugPackage]] * 2.285714 : DrugPackageSize[PlayerDrug[playerid][i][drugPackage]]),
					DrugData[PlayerDrug[playerid][i][drugType]][DRUGDATA_TYPE] ? (" ���") : ("����"),
					PlayerDrug[playerid][i][drugStrength]);
				}
			}
			Dialog_Show(playerid, TransferDrugExistPackage, DIALOG_STYLE_LIST, "Transfer Drug", str, "���͡", "��Ѻ");
		}
	}
	return 1;
}

forward OnDrugTransferNew(playerid, slot, packageid, toslot, Float:transfer_amount);
public OnDrugTransferNew(playerid, slot, packageid, toslot, Float:transfer_amount)
{
	PlayerDrug[playerid][toslot][drugID] = cache_insert_id();
	PlayerDrug[playerid][toslot][drugType] = PlayerDrug[playerid][slot][drugType];
	PlayerDrug[playerid][toslot][drugQTY] = transfer_amount;
	PlayerDrug[playerid][toslot][drugStrength] = PlayerDrug[playerid][slot][drugStrength];
	PlayerDrug[playerid][toslot][drugPackage] = packageid;
	
	PlayerDrug[playerid][slot][drugQTY] -= transfer_amount;
	PlayerDrug[playerid][slot][drugQTY] = PlayerDrug[playerid][slot][drugQTY];
	
	new szQuery[256];
	if(PlayerDrug[playerid][slot][drugQTY]<0.1) {
		PlayerDrug[playerid][slot][drugQTY] = 0;
		
		format(szQuery, sizeof(szQuery), "DELETE FROM `drugs_char` WHERE `drugID` = '%d'", PlayerDrug[playerid][slot][drugID]);
		mysql_tquery(dbCon, szQuery);
	}
	else {
		format(szQuery, sizeof(szQuery), "UPDATE `drugs_char` SET `drugQTY`='%1.f' WHERE `drugID` = '%d'", PlayerDrug[playerid][slot][drugQTY], PlayerDrug[playerid][slot][drugID]);
		mysql_tquery(dbCon, szQuery);
	}
	
	SendClientMessageEx(playerid, COLOR_YELLOW, "�س������ %s �ӹǹ %.1fg ���������ࡨ %s", DrugData[PlayerDrug[playerid][toslot][drugType]][DRUGDATA_NAME], transfer_amount, DrugPackageName[PlayerDrug[playerid][toslot][drugPackage]]);
	
}

ptask CheckHealth[1000](playerid) {
	new 
		Float:health;

	GetPlayerHealth(playerid, health);

	if (health > 150)
		SetPlayerHealthEx(playerid, 150);
}