public int DiscordBot_CreateGuild(Handle plugin, int params)
{
	DiscordBot bot = GetNativeCell(1);
	DiscordGuild guild = GetNativeCell(2);
	OnDiscordGuildCreated cb = GetNativeCell(3);

	DataPack pack = new DataPack();
	pack.WriteCell(bot);
	pack.WriteCell(plugin);
	pack.WriteFunction(cb);
	pack.WriteCell(GetNativeCell(4));
	pack.WriteCell(GetNativeCell(5));

	CreateGuild(bot, guild, pack);
}

public int DiscordBot_AddRole(Handle plugin, int params)
{
	DiscordBot bot = GetNativeCell(1);
	DiscordGuild guild = GetNativeCell(2);
	DiscordUser user = GetNativeCell(3);
	DiscordRole role = GetNativeCell(4);

	char guildid[64];
	guild.GetID(guildid, sizeof(guildid));

	char userid[64];
	user.GetID(userid, sizeof(userid));

	char roleid[64];
	role.GetID(roleid, sizeof(roleid));
	AddRole(bot, guildid, userid, roleid);
}

public int DiscordBot_AddRoleID(Handle plugin, int params)
{
	DiscordBot bot = GetNativeCell(1);

	char guildid[64];
	GetNativeString(2, guildid, sizeof(guildid));

	char userid[64];
	GetNativeString(3, userid, sizeof(userid));

	char roleid[64];
	GetNativeString(4, roleid, sizeof(roleid));
	AddRole(bot, guildid, userid, roleid);
}

public int DiscordBot_RemoveRole(Handle plugin, int params)
{
	DiscordBot bot = GetNativeCell(1);
	DiscordGuild guild = GetNativeCell(2);
	DiscordUser user = GetNativeCell(3);
	DiscordRole role = GetNativeCell(4);

	char guildid[64];
	guild.GetID(guildid, sizeof(guildid));

	char userid[64];
	user.GetID(userid, sizeof(userid));

	char roleid[64];
	role.GetID(roleid, sizeof(roleid));
	RemoveRole(bot, guildid, userid, roleid);
}

public int DiscordBot_RemoveRoleID(Handle plugin, int params)
{
	DiscordBot bot = GetNativeCell(1);

	char guildid[64];
	GetNativeString(2, guildid, sizeof(guildid));

	char userid[64];
	GetNativeString(3, userid, sizeof(userid));

	char roleid[64];
	GetNativeString(4, roleid, sizeof(roleid));
	RemoveRole(bot, guildid, userid, roleid);
}

public int DiscordBot_GetGuild(Handle plugin, int params)
{
	DiscordBot bot = GetNativeCell(1);

	char guildid[64];
	GetNativeString(2, guildid, sizeof(guildid));

	bool with_counts = GetNativeCell(3);
	OnGetDiscordGuild cb = view_as<OnGetDiscordGuild>(GetNativeFunction(4));

	DataPack pack = new DataPack();
	pack.WriteCell(bot);
	pack.WriteCell(plugin);
	pack.WriteFunction(cb);
	pack.WriteCell(GetNativeCell(5));
	pack.WriteCell(GetNativeCell(6));
	GetGuild(bot, guildid, with_counts, pack);
}

public int DiscordBot_GetGuildMember(Handle plugin, int params)
{
	DiscordBot bot = GetNativeCell(1);
	DiscordGuild guild = GetNativeCell(2);
	DiscordUser user = GetNativeCell(3);
	OnGetDiscordGuildUser cb = view_as<OnGetDiscordGuildUser>(GetNativeFunction(4));
	OnFailedGetDiscordGuildUser cb2 = view_as<OnFailedGetDiscordGuildUser>(GetNativeFunction(5));

	char guildid[64];
	guild.GetID(guildid, sizeof(guildid));

	char userid[64];
	user.GetID(userid, sizeof(userid));

	DataPack pack = new DataPack();
	pack.WriteCell(bot);
	pack.WriteCell(plugin);
	pack.WriteString(userid);
	pack.WriteFunction(cb);
	pack.WriteFunction(cb2);
	pack.WriteCell(GetNativeCell(6));
	pack.WriteCell(GetNativeCell(7));
	GetGuildMember(bot, guildid, userid, pack);
}

public int DiscordBot_GetGuildMemberID(Handle plugin, int params)
{
	DiscordBot bot = GetNativeCell(1);

	char guildid[64];
	GetNativeString(2, guildid, sizeof(guildid));

	char userid[64];
	GetNativeString(3, userid, sizeof(userid));

	OnGetDiscordGuildUser cb = view_as<OnGetDiscordGuildUser>(GetNativeFunction(4));
	OnFailedGetDiscordGuildUser cb2 = view_as<OnFailedGetDiscordGuildUser>(GetNativeFunction(5));

	DataPack pack = new DataPack();
	pack.WriteCell(bot);
	pack.WriteCell(plugin);
	pack.WriteString(userid);
	pack.WriteFunction(cb);
	pack.WriteFunction(cb2);
	pack.WriteCell(GetNativeCell(6));
	pack.WriteCell(GetNativeCell(7));
	GetGuildMember(bot, guildid, userid, pack);
}

public int DiscordBot_GetGuildScheduledEvent(Handle plugin, int params)
{
	DiscordBot bot = GetNativeCell(1);
	DiscordGuild guild = GetNativeCell(2);

	char guildid[64];
	guild.GetID(guildid, sizeof(guildid));

	char eventid[64];
	GetNativeString(3, eventid, sizeof(eventid));

	OnGetDiscordGuildScheduledEvent cb = view_as<OnGetDiscordGuildScheduledEvent>(GetNativeFunction(4));
	
	DataPack pack = new DataPack();
	pack.WriteCell(bot);
	pack.WriteCell(plugin);
	pack.WriteFunction(cb);
	pack.WriteCell(GetNativeCell(5));
	pack.WriteCell(GetNativeCell(6));
	GetGuildScheduledEvent(bot, guildid, eventid, pack);
}

public int DiscordBot_DeleteGuildScheduledEvent(Handle plugin, int params)
{
	DiscordBot bot = GetNativeCell(1);
	DiscordGuild guild = GetNativeCell(2);
	DiscordGuildScheduledEvent event = GetNativeCell(3);

	char guildid[64];
	guild.GetID(guildid, sizeof(guildid));

	char eventid[64];
	event.GetID(eventid, sizeof(eventid));

	DeleteGuildScheduledEvent(bot, guildid, eventid);
}

static void CreateGuild(DiscordBot bot, DiscordGuild guild, DataPack pack)
{
	char route[128];
	Format(route, sizeof(route), "guilds");
	SendRequest(bot, route, guild, k_EHTTPMethodPOST, OnDiscordDataReceived, _, pack);
}

static void AddRole(DiscordBot bot, const char[] guildid, const char[] userid, const char[] roleid)
{
	char route[128];
	Format(route, sizeof(route), "guilds/%s/members/%s/roles/%s", guildid, userid, roleid);
	SendRequest(bot, route, _, k_EHTTPMethodPUT);
}

static void RemoveRole(DiscordBot bot, const char[] guildid, const char[] userid, const char[] roleid)
{
	char route[128];
	Format(route, sizeof(route), "guilds/%s/members/%s/roles/%s", guildid, userid, roleid);
	SendRequest(bot, route, _, k_EHTTPMethodDELETE);
}

static void GetGuild(DiscordBot bot, const char[] guildid, bool with_counts, DataPack pack)
{
	char route[128];
	Format(route, sizeof(route), "guilds/%s?with_counts=%s", guildid, with_counts ? "true" : "false");
	SendRequest(bot, route, _, k_EHTTPMethodGET, OnDiscordDataReceived, _, pack);
}

static void GetGuildMember(DiscordBot bot, const char[] guildid, const char[] userid, DataPack pack)
{
	char route[128];
	Format(route, sizeof(route), "guilds/%s/members/%s", guildid, userid);
	SendRequest(bot, route, _, k_EHTTPMethodGET, OnGetGuildMemberDataReceived, _, pack);
}

static void GetGuildScheduledEvent(DiscordBot bot, const char[] guildid, const char[] eventid, DataPack pack)
{
	char route[128];
	Format(route, sizeof(route), "guilds/%s/scheduled-events/%s", guildid, eventid);
	SendRequest(bot, route, _, k_EHTTPMethodGET, OnDiscordDataReceived, _, pack);
}

static void DeleteGuildScheduledEvent(DiscordBot bot, const char[] guildid, const char[] eventid)
{
	char route[128];
	Format(route, sizeof(route), "guilds/%s/scheduled-events/%s", guildid, eventid);
	SendRequest(bot, route, _, k_EHTTPMethodDELETE);
}

public int OnGetGuildMemberDataReceived(Handle request, bool failure, int offset, int statuscode, DataPack pack)
{
	if(failure || (statuscode != 200 && statuscode != 204))
	{
		if(statuscode == 404)
		{
			pack.Reset();
			char sUserID[64];
			DiscordBot bot = pack.ReadCell();
			Handle plugin = pack.ReadCell();
			pack.ReadString(sUserID, 64);
			Function callback = pack.ReadFunction();
			Function callback2 = pack.ReadFunction();
			any data1 = pack.ReadCell();
			any data2 = pack.ReadCell();
			delete pack;
			
			if(callback != INVALID_FUNCTION) {} //To avoid warning
			if(callback2 != INVALID_FUNCTION)
			{
				Call_StartFunction(plugin, callback2);
				Call_PushCell(bot);
				Call_PushString(sUserID);
				Call_PushCell(data1);
				Call_PushCell(data2);
				Call_Finish();
			}
			return;
		}
		
		new DiscordException("OnDiscordDataReceived - Fail %i %i", failure, statuscode);
		delete request;
		delete pack;
		return;
	}

	SteamWorks_GetHTTPResponseBodyCallback(request, ReceivedGuildMemberData, pack);
	delete request;
}

static int ReceivedGuildMemberData(const char[] data, DataPack pack)
{
	pack.Reset();
	char sUserID[64];
	DiscordBot bot = pack.ReadCell();
	Handle plugin = pack.ReadCell();
	pack.ReadString(sUserID, 64);
	Function callback = pack.ReadFunction();
	Function callback2 = pack.ReadFunction();
	any data1 = pack.ReadCell();
	any data2 = pack.ReadCell();
	delete pack;

	if(callback != INVALID_FUNCTION)
	{
		Call_StartFunction(plugin, callback);
		Call_PushCell(bot);
		Call_PushCell(json_decode(data));
		Call_PushCell(data1);
		Call_PushCell(data2);
		Call_Finish();
	}
	if(callback2 != INVALID_FUNCTION) {} //To avoid warning
}