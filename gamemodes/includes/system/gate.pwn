#include <YSI\y_hooks> // pawn-lang/YSI-Includes

new pdgate;
new pdngate;

hook OnGameModeInit() {
	CreateDynamicObject(969, -1571.713013, 665.608154, 6.336499, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(969, -1701.770020, 679.915344, 24.057503, 0.0000, 0.0000, 90.0000);
}

forward GateClose();
public GateClose()
{
    MoveDynamicObject (pdngate,-1571.713013, 665.608154, 6.336499, 2.5);
    MoveDynamicObject (pdgate,-1701.770020, 679.915344, 24.057503, 2.5);
}

ptask GateCheck[1000](playerid) {

    new factionType = Faction_GetTypeID(playerData[playerid][pFaction]);

    if (IsPlayerInRangeOfPoint(playerid, 8.0, -1571.713013,665.608154,6.336499))
    {
    	if (factionType == FACTION_TYPE_POLICE)
    	{
    		MoveDynamicObject(pdngate,-1571.828735, 656.457214, 6.354377, 3.5);
    		SetTimer("GateClose", 4000, 0);
    	}
    }
    else if (IsPlayerInRangeOfPoint(playerid, 8.0,-1701.770020,679.915344,24.057503))
    {
    	if (factionType == FACTION_TYPE_POLICE) {
    		MoveDynamicObject(pdgate,-1701.773193, 670.980530, 24.041584, 3.5);
    		SetTimer("GateClose", 4000, 0);
    	}
    }
}
