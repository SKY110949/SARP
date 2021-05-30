forward LoadTextDraws();
public LoadTextDraws() {
    gServerRestartCount = TextDrawCreate(237.000000, 409.000000, "~r~ ~w~");
	TextDrawBackgroundColor(gServerRestartCount, 255);
	TextDrawFont(gServerRestartCount, 1);
	TextDrawLetterSize(gServerRestartCount, 0.480000, 1.300000);
	TextDrawColor(gServerRestartCount, -1);
	TextDrawSetOutline(gServerRestartCount, 1);
	TextDrawSetProportional(gServerRestartCount, 1);
	TextDrawSetSelectable(gServerRestartCount, 0);
}

