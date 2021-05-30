//--------------------------------[MYSQL.PWN]--------------------------------

/* 
g_mysql_Init()
-> รายละเอียด: ถูกเรียกใน {root}:OnGameModeInitEx
*/
g_mysql_Init()
{
	mysql_log(ERROR | WARNING);
	dbCon = mysql_connect("localhost", "root","","sdasdas");
	if (mysql_errno(dbCon)) {
		print("[SQL] Connection failed! Please check the connection settings...\a");
		SendRconCommand("exit");
		return 1;
	}
	else print("[SQL] Connection passed!");
    
	return 1;
}

/* 
g_mysql_Exit()
-> รายละเอียด: ถูกเรียกใน {root}:OnGameModeExit
*/
g_mysql_Exit()
{
	if(dbCon)
		mysql_close(dbCon);
	return 1;
}


//==================== [ MySQL Function ] ==========================

#define MYSQL_MAX_STRING			64
#define MYSQL_UPDATE_TYPE_SINGLE	0
#define MYSQL_UPDATE_TYPE_THREAD	1

#define MYSQL_UPDATE_QUERY(%0,%1)              			\
    if(gUpdateThreadType) { mysql_query(%0, %1); }		\
	else mysql_tquery(%0, %1)

static 
	gUpdateTableName[MYSQL_MAX_STRING],
	gUpdateColumnName[MYSQL_MAX_STRING],
	gUpdateRowID,
	gUpdateThreadType;

stock MySQLUpdateInit(const table_name[], const column_name[], row_id, type = MYSQL_UPDATE_TYPE_SINGLE) {
	format(gUpdateTableName, MYSQL_MAX_STRING, table_name);
	format(gUpdateColumnName, MYSQL_MAX_STRING, column_name);
	gUpdateRowID = row_id;
	gUpdateThreadType = type;
}

static stock MySQLUpdateBuild(query[]) 
{
	new queryLen = strlen(query), whereclause[MYSQL_MAX_STRING], queryMax = MAX_STRING;
	if (queryLen < 1) format(query, queryMax, "UPDATE `%s` SET ", gUpdateTableName);
	else if (queryMax-queryLen < 80) // make sure we're being safe here
	{
		// query is too large, send this one and reset
		format(whereclause, MYSQL_MAX_STRING, " WHERE `%s`=%d", gUpdateColumnName, gUpdateRowID); // 60
		strcat(query, whereclause, queryMax);

		MYSQL_UPDATE_QUERY(dbCon, query);

		format(query, queryMax, "UPDATE `%s` SET ", gUpdateTableName);
	}
	else if (strfind(query, "=", true) != -1) strcat(query, ",", MAX_STRING);
	return 1;
}

stock MySQLUpdateFinish(query[]) 
{
	new whereclause[MYSQL_MAX_STRING];
	format(whereclause, MYSQL_MAX_STRING, "WHERE `%s`=", gUpdateColumnName);
	if (strcmp(query, whereclause, false) == 0) {
		MYSQL_UPDATE_QUERY(dbCon, query);
	}
	else
	{
		format(whereclause, MYSQL_MAX_STRING, " WHERE `%s`=%d", gUpdateColumnName, gUpdateRowID);
		strcat(query, whereclause, MAX_STRING);

		MYSQL_UPDATE_QUERY(dbCon, query);

		gUpdateTableName[0] = '\0';
		gUpdateColumnName[0] = '\0';
		gUpdateRowID = 0;
		gUpdateThreadType = MYSQL_UPDATE_TYPE_SINGLE;
	}
	return 1;
}

stock MySQLUpdateInt(query[], const sqlvalname[], sqlupdateint) 
{
	MySQLUpdateBuild(query);
	strcat(query, sprintf("`%s`=%d", sqlvalname, sqlupdateint), MAX_STRING);
	return 1;
}

stock MySQLUpdateBool(query[], const sqlvalname[], bool:sqlupdatebool) 
{
	MySQLUpdateBuild(query);
	strcat(query, sprintf("`%s`=%d", sqlvalname, sqlupdatebool), MAX_STRING);
	return 1;
}

stock MySQLUpdateFlo(query[], const sqlvalname[], Float:sqlupdateflo) 
{
	MySQLUpdateBuild(query);
	strcat(query, sprintf("`%s`=%f", sqlvalname, sqlupdateflo), MAX_STRING);
	return 1;
}

stock MySQLUpdateStr(query[], const sqlvalname[], const sqlupdatestr[]) 
{
	MySQLUpdateBuild(query);
	new updval[128];
	mysql_format(dbCon, updval, sizeof(updval), "`%s`='%e'", sqlvalname, sqlupdatestr);
	strcat(query, updval, MAX_STRING);
	return 1;
}
