forward PayDay();
public PayDay()
{
	new account,interest;
	new savaccount, savings;
    new rent = 0;

	foreach (new i : Player)
	{
		if(playerData[i][pLevel] > 0 && playerData[i][pPayDay] >= 5)
		{
			if(playerData[i][pJob] && !IsSideJob(playerData[i][pJob])) {

				if(playerData[i][pJob] == JOB_TRUCKER)
				{
					playerData[i][pContractTime]++;

					if(playerData[i][pContractTime] >= 164) playerData[i][pJobRank] = 5;
					else if(playerData[i][pContractTime] >= 116) playerData[i][pJobRank] = 4;
					else if(playerData[i][pContractTime] >= 64) playerData[i][pJobRank] = 3;
					else if(playerData[i][pContractTime] >= 36) playerData[i][pJobRank] = 2;
					else if(playerData[i][pContractTime] >= 12) playerData[i][pJobRank] = 1;
					else playerData[i][pJobRank] = 0;
				}
				else {
					if(playerData[i][pContractTime] < 25) 
						playerData[i][pContractTime] ++;		
				}
			}

		    new house = House_GetID(playerData[i][pHouseKey]);
			new nxtlevel = playerData[i][pLevel]+1;
			new expamount = nxtlevel*MULTIPLE_EXP;

			account = playerData[i][pAccount];

            new Float:tmpintrate = 0.01;
			new Float:tmpsavrate = 0.5;

			if (playerData[i][pDonateRank]) {
				tmpintrate += float(playerData[i][pDonateRank]) * 2.0 / 100.0;
			}

			new TaxValue = floatround(((playerData[i][pAccount]+playerData[i][pPayCheck])/110.0) * 0.01);
			
			if (TaxValue)
				playerData[i][pAccount] -= TaxValue;

			interest = floatround(((playerData[i][pAccount]+playerData[i][pPayCheck])/100.0)*(tmpintrate), floatround_round);
			playerData[i][pExp]+=1*gMultipleEXP;
			PlayerPlayMusic(i);
			playerData[i][pAccount] = account+interest;

			if(playerData[i][pSavingsCollect])
			{
				if (playerData[i][pDonateRank] == 1) {
					tmpsavrate = 2.0;
				}

				if (playerData[i][pDonateRank] == 2) {
					tmpsavrate = 2.5;
				}

				if (playerData[i][pDonateRank] == 3) {
					tmpsavrate = 3.0;
				}

				if(playerData[i][pAccount] > 20000000)
					tmpsavrate = 0.01;
					
			    savaccount = playerData[i][pSavingsCollect];
			    savings = floatround((playerData[i][pSavingsCollect]/100.0)*(tmpsavrate), floatround_round);

			    playerData[i][pSavingsCollect] = savaccount+savings;
			    if(playerData[i][pSavingsCollect] > 20000000)
			    {
			        playerData[i][pSavingsCollect] = 20000000;
			    }
			}

            new ebill = floatround((float(account) / 100.0) / 110.0) * CountPlayerOwnHouse(i);

			if(house != -1 && !strcmp(ReturnPlayerName(i), houseData[house][hOwner], true))
			{
				playerData[i][pAccount] -= ebill;
				new string[32];
				format(string, sizeof(string), "ค่าไฟ: $%d  (ออกจากธนาคาร)", ebill);
				SendClientMessage(i, COLOR_WHITE, string);
			}
			else if(house != -1)
			{
				rent = houseData[house][hRentPrice];

				if(playerData[i][pAccount] >= rent) {
					playerData[i][pAccount] -= rent;
					new string[32];
					format(string, sizeof(string), "ค่าเช่า: $%d (ออกจากธนาคาร)", rent);
					SendClientMessage(i, COLOR_WHITE, string);
					houseData[house][hCash] += rent;
				}
				else {
				    playerData[i][pHouseKey] = 0;
				}
			}

			SendClientMessage(i, COLOR_WHITE, "|___ BANK STATEMENT ___|");

			SendClientMessageEx(i, COLOR_FADE1, "  ยอดเงินในบัญชี: $%d", account);
			SendClientMessageEx(i, COLOR_FADE1, "  อัตราดอกเบี้ย: %.2f", tmpintrate);
			SendClientMessageEx(i, COLOR_FADE1, "  ดอกเบี้ยทีได้รับ $%d", interest);
			SendClientMessageEx(i, COLOR_FADE1, "  ภาษีที่จ่าย $%d", TaxValue);

			if(playerData[i][pSavingsCollect])
			{
				SendClientMessageEx(i, COLOR_WHITE, "  รายได้เงินฝากออมทรัพย์: $%d อยู่ที่อัตรา: %.2f", savings, tmpsavrate);
				SendClientMessageEx(i, COLOR_WHITE, "  ยอดเงินในบัญชีออมทรัพย์ใหม่: $%d", playerData[i][pSavingsCollect]);
			}

			SendClientMessage(i, COLOR_WHITE, "|______________________|");
			SendClientMessageEx(i, COLOR_WHITE, "  ยอดเงินในบัญชีใหม่: $%d", playerData[i][pAccount]);

			if(account+interest)
				SendClientMessage(i, COLOR_WHITE, "คุณสามารถรับ Paycheck ของคุณได้ใน Los Santos Bank");

			if(playerData[i][pLevel] < 5)
			{
				SendClientMessageEx(i, COLOR_FADE1, "(( คุณได้รับ $500 ในฐานะที่อยู่เลเวล %d ))", playerData[i][pLevel]);
				playerData[i][pPayCheck] += 500;
			}

			if(playerData[i][pJob] == JOB_MECHANIC && playerData[i][pSideJob] == JOB_MECHANIC)
			{
				SendClientMessageEx(i, COLOR_FADE1, "(( คุณได้รับ $800 ในฐานะที่คุณทำอาชีพเป็นช่างซ่อมรถ ))");
				playerData[i][pPayCheck] += 800;
			}

			// Donate

			if(playerData[i][pJob] == JOB_MECHANIC && playerData[i][pSideJob] == JOB_MECHANIC)
			{
				SendClientMessageEx(i, COLOR_FADE1, "(( คุณได้รับ $800 ในฐานะที่คุณทำอาชีพเป็นช่างซ่อมรถ ))");
				playerData[i][pPayCheck] += 800;
			}

			if(house != -1 && playerData[i][pHouseKey] == 0) {
				SendClientMessage(i, COLOR_FADE1, "คุณไม่มีเงินในบัญชีเพื่อจ่ายค่าเช่าดังนั้นคุณจึงถูกขับไล่ออกจากบ้าน");
			}

			new string[40];
			format(string, sizeof(string), "~y~PayDay~n~~w~Paycheck~n~~g~$%d", playerData[i][pPayCheck]);
			GameTextForPlayer(i, string, 5000, 1);

			playerData[i][pPayDay] = 0;
			playerData[i][pPlayingHours] += 1;

			if(playerData[i][pExp] >= expamount && (playerData[i][pLevel] < 5 || playerData[i][pDonateRank]))
			{
				new str_level[40];
				format(str_level, sizeof(str_level), "~g~LEVEL UP~n~~w~You Are Now Level %d", nxtlevel);
				GameTextForPlayer(i, str_level, 5000, 1);
				PlayerPlaySound(i, 1052, 0.0, 0.0, 0.0);
				PlayerPlayMusic(i);
				playerData[i][pLevel]++;
				playerData[i][pPUpgrade] = playerData[i][pPUpgrade]+2;
				SendClientMessageEx(i, COLOR_FADE2, "   เลเวลของคุณในปัจจุบันถูกเพิ่มขึ้นเป็นเลเวล %d",playerData[i][pLevel]);
				SendClientMessageEx(i, COLOR_FADE2, "   คุณมีค่าอัพเกรดอยู่ %d จุด (พิมพ์ /upgrade เพื่ออัพเกรด)",playerData[i][pPUpgrade]);
				if(playerData[i][pDonateRank] > 0)
				{
					playerData[i][pExp] -= expamount;
					new total = playerData[i][pExp];
					if(total > 0)
					{
						playerData[i][pExp] = total;
					}
					else
					{
						playerData[i][pExp] = 0;
					}
				}
				else
				{
					playerData[i][pExp] = 0;
				}
				SetPlayerScore(i, playerData[i][pLevel]);
			}


			if(playerData[i][pHungry] > 100.0) playerData[i][pHungry] = 100.0;

			if(playerData[i][pHungry] <= 100.0)
			{
				playerData[i][pHungry] -= 5;
			}

			if(playerData[i][pThirst] > 100.0) playerData[i][pThirst] = 100.0;

			if(playerData[i][pThirst] <= 100.0)
			{

				playerData[i][pThirst] -= 5;
			}
	
			// Donate
			if(playerData[i][pDonateRank] > 0)
			{
				playerData[i][pPayDayHad] += 1;
				if(playerData[i][pPayDayHad] >= 5)
				{
					playerData[i][pExp]++;
					playerData[i][pPayDayHad] = 0;
				}
			}

			if(playerData[i][pHungry] <= 20)
			{
				new Float:decrease;
				decrease = playerData[i][pHungry]/10.0;
				if(playerData[i][pHealth] - decrease > 0.0) {
					if(decrease>0.0) SetPlayerHealth(i, playerData[i][pHealth] - decrease);
				}
				else SetPlayerHealth(i, 1);
			}

			if(playerData[i][pThirst] <= 20)
			{
				new Float:decrease;
				decrease = playerData[i][pThirst]/10.0;
				if(playerData[i][pThirst] - decrease > 0.0) {
					if(decrease>0.0) SetPlayerHealth(i, playerData[i][pThirst] - decrease);
				}
				else SetPlayerHealth(i, 1);
			}
		}
		else
		{
			SendClientMessage(i, COLOR_LIGHTRED, "* คุณเล่นไม่นานพอที่จะได้รับ Paycheck");
		}
	}
    return 1;
}

task SyncUpTimer[60000]() {

	new tmphour, tmpminute, tmpsecond;
	GetRealTime(tmphour, tmpminute, tmpsecond);

	if ((tmphour > ghour) || (tmphour == 0 && ghour == 23))
	{
		SendClientMessageToAll(COLOR_WHITE, sprintf("เวลาเซิร์ฟเวอร์:[ %d.00 ]",tmphour));

		ghour = tmphour;

		PayDay();

		SetWorldTime(tmphour);

		WarehouseTime();

		PlayerVehicle_Reset();

	}
}