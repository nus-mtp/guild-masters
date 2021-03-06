GM.QuestController = Ember.Controller.extend();

/**
 * show page for assigning adventurers to quests
 * @param  {integer} id
 *         id of the quest
 * @return {void} 
 */
GM.QuestController.showQuestAssignPage = function(id) {
	var quests = GM.QuestModel.quest_list;
	var quest;
	for (var q in quests) {
		if (quests[q]['id'] == id) {
			quest = quests[q];
		}
	}
	var questView = questAssignTemplate(quest);
	GM.AdventurerModel.getAllAdventurers(function () {
		var adventurers = GM.AdventurerController.filterForQuest(GM.AdventurerModel.adventurers_list);
		if (adventurers.length == 0) {
			showView("<p>You do not have any adventurers to be assigned to the quest.</p>");
		} else {
			GM.AdventurerController.showAdventurerWithGraph(adventurers, adventurerAssignTableTemplate, questView)
		}
	});
}

/**
 * assign adventurers to the quest
 * @param  {integer} id 
 *         the id of the quest
 * @return {void}
 */
GM.QuestController.assign = function(id) {
	var assigned = [];
	$.each($("input:checked"), function (){
		assigned.push($(this).val());
	});
	if (assigned.length == 0) {
		GM.QuestController.showMessage("Please select at least one adventurer.");
	} else {
		GM.QuestModel.assign(id, assigned);
	}
}

GM.QuestController.showMessage = function (message) {
	var alertMessage = alertMessageTemplate({'message' : message});
    $('#alert').html(alertMessage);
}

/**
 * get the quests which are in pending state
 * @param  {array} quests
 * @return {array} filtered quests
 */
GM.QuestController.filterPending = function(quests) {
	return quests.filter(function(quest) {
		var isPending = (quest.state != 'assigned') && (quest.state != 'successful');
		return isPending;
	});	
}

/**
 * show the quest page
 * @return {void}
 */
GM.QuestController.showQuestPage = function() {
	GM.QuestModel.getAllQuests(function(data) {
		var quests = GM.QuestController.filterPending(data);
		if (quests.length == 0) {
			showView("There is no Quest, please try scouting for some Adventurers and Quests")
		} else {
			var view = questPendingTableTemplate({"quests" : quests});
			showView(view);	
		}
	})
}