
static 
    isenable,
    score, 
    answer,
    number[4];

CMD:answer(playerid, params[]) {

    new pAnswer;
    if(sscanf(params,"d", pAnswer)) {
    	SendClientMessage(playerid, COLOR_GRAD1, "�����: /answer [�ӵͺ]");
    	return 1;
    }

    if (isenable) {
        if(pAnswer == answer)
        {
            isenable = false;
            playerData[playerid][pScore] += score;
            SendClientMessageToAllEx(COLOR_LIGHTGREEN, "[Answer] %s ��ͺ��� "EMBED_LIGHTRED"%d"EMBED_LIGHTGREEN" ������Ѻ %d Score", ReturnPlayerName(playerid), answer, score);
            SetPlayerScore(playerid, GetPlayerScore(playerid)+score);
        }
        else {
            SendClientMessage(playerid, COLOR_LIGHTRED, "�ӵͺ�ѧ���١��Ѻ !");
        }
        return 1;
    }
    else {
        SendClientMessage(playerid, COLOR_LIGHTRED, "�ѧ����դӶ����Ѻ !");
    }
    return 1;
}

task mathquiz[1800000]()
{
    new string[128];
    if(!isenable)
    {
        switch(random(4))
        {
            case 0:
            {
                score = 5+random(5);
                answer = (number[0]=random(1000)) + (number[1]=random(840));
                format(string, sizeof(string),"[Quiz] ������ %d + %d = ? �ͺ�١���Ѻ %d Score (����� /answer ���͵ͺ)",number[0], number[1], score);
            }
            case 1:
            {
                score = 5+random(5);
                do
                {
                    answer = (number[0]=random(500)) - (number[1]=random(500));
                }
                while(number[0] < number[1]);
                format(string, sizeof(string),"[Quiz] ������ %d - %d = ? �ͺ�١���Ѻ %d Score (����� /answer ���͵ͺ)",number[0], number[1], score);
            }
            case 2:
            {
                score = 5+random(5);
                answer = (number[0]=random(100)) * (number[1]=random(80));
                format(string, sizeof(string),"[Quiz] ������ %d * %d = ? �ͺ�١���Ѻ %d Score (����� /answer ���͵ͺ)",number[0], number[1], score);
            }
            case 3:
            {
                score = 5+random(5);
                do
                {
                    answer = (number[0]=random(1000)+1) / (number[1]=random(600)+1);
                }
                while(number[0] % number[1]);
                format(string, sizeof(string),"[Quiz] ������ %d / %d = ? �ͺ�١���Ѻ %d Score (����� /answer ���͵ͺ)",number[0], number[1], score);
            }
        }
        SendClientMessageToAll(COLOR_LIGHTGREEN, string);
        isenable = true;
    }
    else
    {
        isenable = false;
    }
    return 1;
}