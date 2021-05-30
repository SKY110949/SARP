#define JOB_NONE			0
#define JOB_FARMER			1
#define JOB_TAXI        	2
#define JOB_SWEEPER        	3
#define	JOB_MECHANIC		4
#define	JOB_GARBAGE			5
#define	JOB_TRUCKER			6

ReturnJobName(jobid, skill = 0)
{
	new name[32];

	switch(jobid)
	{
	    case JOB_NONE: format(name, 32, "ไม่มี");
	    case JOB_FARMER: format(name, 32, "ชาวไร่");
	    case JOB_TAXI: format(name, 32, "คนขับแท็กซี่");
        case JOB_SWEEPER: format(name, 32, "พนักงานกวาดถนน");
		case JOB_MECHANIC: format(name, 32, "ช่างซ่อมรถ");
		case JOB_GARBAGE: format(name, 32, "พนักงานเก็บขยะ");
	    case JOB_TRUCKER: {
			switch(skill)
			{
			    case 0: format(name, 32, "Courier Trainee");
			    case 1: format(name, 32, "Courier");
			    case 2: format(name, 32, "Professional Courier");
			    case 3: format(name, 32, "Trucker Trainee");
			    case 4: format(name, 32, "Trucker");
			    case 5: format(name, 32, "Professional Trucker");
			}
	    }
	    default: format(name, 32, "ว่างงาน");
	}
	return name;
}

SendJobMessage(jobid, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string
		#emit PUSH.C args

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		foreach (new i : Player) if (playerData[i][pJob] == jobid || playerData[i][pSideJob] == jobid) {
		    SendClientMessage(i, color, string);
		}
		return 1;
	}
	foreach (new i : Player) if (playerData[i][pJob] == jobid || playerData[i][pSideJob] == jobid) {
		SendClientMessage(i, color, str);
	}
	return 1;
}
