GM.Guild = DS.Model.extend({
	level: DS.attr('number'),
	popularity: DS.attr('number'),

	adventurers: DS.hasMany('adventurer'),
	quests: DS.hasMany('quest'),
	facilities: DS.hasMany('facility')
});

GM.GuildModel = DS.Model.extend();

GM.GuildModel.getAllGuilds = function (func) {
	$.ajax({
		type: 'GET',
	    url: 'guild_sessions.json',
	    success: function(feedback) {
	    	var guild = feedback.guild_sessions[0];
            GM.GuildmasterModel.guildmaster.guild = guild;
	    	GM.GuildmasterView = guildmasterTemplate(GM.GuildmasterModel.guildmaster);
	    	GM.GuildModel.postGuildID(guild.id);
	    	if (func) {
	    		func(GM.GuildmasterView);
	    	}
	    }
	});
}

GM.GuildModel.postGuildID = function (guildID) {
    $.ajax({
	    type: 'POST',
	    url: 'guild_sessions.json',
	    data: {
	    	guild_id : guildID
	    },
	    success: function(feedback) {
	    }
	});
}