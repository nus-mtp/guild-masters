GM.RankingController = Ember.Controller.extend();

/**
 * display the ranking of players
 * @param  {array} players
 * @return {void}
 */
GM.RankingController.displayRanking = function (players) {
	players.sort(GM.RankingController.defaultRanking);
	for (var i = 0; i < players.length; i++) {
		players[i].ranking = i + 1;
	}
	var view = rankingTemplate({'users':players});
	$('#gameWindow').html(view);
}

/**
 * default comparator of players, based on the following priority:
 * 	1. higher level
 * 	2. higher popularity
 * 	3. higher gold
 * 	4. less game time
 * @param  {player} p1 
 * @param  {player} p2
 * @return {integer} the comparison result of p1 and p2
 */
GM.RankingController.defaultRanking = function (p1, p2) {
	if (p2.level != p1.level) {
		return p2.level - p1.level;
	} else {
		if (p2.popularity != p1.popularity) {
			return p2.popularity - p1.popularity;
		} else {
			if (p2.gold != p1.gold) {
				return p2.gold - p1.gold;
			} else {
				return GM.RankingController.compareByLevelToTime(p1, p2);
			}
		}
	}
}

GM.RankingController.compareByLevelToTime = function (p1, p2) {
	return p2.level / p2.game_time - p1.level / p1.game_time;
}

GM.RankingController.compareByPopularityToTime = function (p1, p2) {
	return p2.popularity / p2.game_time - p1.popularity / p1.game_time;
}

GM.RankingController.compareByGoldToTime = function (p1, p2) {
	return p2.gold / p2.game_time - p1.gold / p1.game_time;
}