Handlebars.registerPartial('quest',  HandlebarsTemplates['quest/quest']);
var questsListTemplate = HandlebarsTemplates['quest/quest_list'];
GM.QuestController = {
	quest_list : {
		quests:[
				{
					id : 1,
					description: 'You need to kill the monster at the cave!',
					difficulty: 5,
					state: 'unassigned',
					reward: 10

				},
				{
					id : 2,
					difficulty: 8,
					state: 'unassigned',
					reward: 12

				},
				{
					id : 3,
					difficulty: 2,
					state: 'unassigned',
					reward: 4
				}
			]
	},
};