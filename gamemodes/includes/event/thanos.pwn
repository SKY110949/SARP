

new countPlayer;
new Timer:snapTimer;

flags:snap(CMD_DEV);
CMD:snap(playerid)
{
    if (countPlayer)
        return 1;

    countPlayer = floatround(float(GetPlayerPoolSize()) / 2.0);
	SendClientMessageToAllEx(COLOR_LIGHTRED, "�ʹ�Թ %s �����ا����������дմ��������Ŵ��Ъҡ�����������ŧ���觹֧", ReturnPlayerName(playerid));
    snapTimer = repeat SnapFinger[500]();
	return 1;
}

timer SnapFinger[500]() {
    countPlayer--;
    if (countPlayer <= 0) {
        stop snapTimer;
        return 1;
    }

    new rand = random(GetPlayerPoolSize());
    if (IsPlayerConnected(rand)) {
        SendClientMessageToAllEx(COLOR_GRAD1, sprintf("*** %s �͡�ҡ��������� (�����繽��)", ReturnPlayerName(rand)));
    }
    return 1;
}
