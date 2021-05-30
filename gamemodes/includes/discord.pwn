/*

    Welcome to another OUTWARDLY EXPERIENCE!!!
    In this we will learn how to control a discord command to affect ingame activities like banning, kicking or sending a message to a player!
    Let's GO!

*/

#include <a_samp>
#include <sscanf2>
#include <discord-connector> // Including the include of the plugin //

static DCC_Channel:commandChannel; // In this variable we will store the channel ID only where the commands will be registered and not anywhere else //
static DCC_Guild:guildName;
static DCC_Role:adminRole;
main(){

    commandChannel = DCC_FindChannelById("651471342180368394"); // Now we will copy the channel ID where we want the commands to work! //
    guildName = DCC_FindGuildById("816657782845079614"); // Now to get the guild ID //
    adminRole = DCC_FindRoleById("651471401408135180"); // Now to fetch the role ID //
    // Now the DCC_Channel is stored in the variable commandChannel //
}



public OnGameModeInit(){
    return 1;
}

public OnGameModeExit(){
    return 1;
}

public OnPlayerConnect(playerid){
    return 1;
}

public OnPlayerDisconnect(playerid, reason){
    return 1;
}

public OnPlayerRequestSpawn(playerid){
    return 1;
}

public OnPlayerRequestClass(playerid, classid){
    return 1;
}
public OnPlayerSpawn(playerid){
    return 1;
}
// ~~~~~~~~~~~~~~~~~~~ DISCORD COMMANDS SECTION ~~~~~~~~~~~~~~~~ //

/*
    This is the callback that will be called if a message is sent in the guild / server //
*/
public DCC_OnMessageCreate(DCC_Message:message){

    new DCC_Channel:channel;

    DCC_GetMessageChannel(message, channel);

    // This if condition checks that if the channel is not the command channel then it will do nothing and return 1 //
    if(channel != commandChannel)
        return 1;

    // But before that we need to save who actually sent the message //
    new DCC_User:author;
    DCC_GetMessageAuthor(message, author);

    // We need to check if the author is a bot or not //

    new bool:isBot;
    DCC_IsUserBot(author, isBot);

    // If the author is a bot then nothing will happen //
    if(isBot){
        return 1;
    }


    // Now we will fetch if the author has the required role or not! //
    new bool:hasRole;
    DCC_HasGuildMemberRole(guildName, author, adminRole, hasRole);

    // If the author does not have the role then don't do anything //
    if(!hasRole){
        DCC_SendChannelMessage(commandChannel, "You do not have the role required");
        return 1;
    }

    // Now to actually make a command after all the checks are done //
    new str[256];
    new command[32], params[128];

    DCC_GetMessageContent(message, str); // Storing the entire message of the author in the variable str //

    // Now seperating the command and the params //

    sscanf(str, "s[32]s[128]", command, params);

    // Now we will check the command //


    /*

        We will make a command which sends a chat message from discord to the player

    */

    if(!strcmp(command, "&chat", true)){
        new playerID, _message[128];

        sscanf(params, "us[128]", playerID, _message); // Seperating the playerID and the message //

        if(!IsPlayerConnected(playerID))
            return DCC_SendChannelMessage(channel, "The player is not online!");

        SendClientMessage(playerID, -1, _message);
    }

    // DONE !!! //

    return 1;
}
