module Teamable
  def team_info(team_id)
    info = {
      "team_id" => get_team_with_id(team_id).team_id,
      "franchise_id" => get_team_with_id(team_id).franchise_id,
      "link" => get_team_with_id(team_id).link,
      "team_name" => get_team_with_id(team_id).team_name,
      "abbreviation" => get_team_with_id(team_id).abbreviation
    }
    info
  end

  def get_team_with_id(team_id)
    @teams.find { |team| team.team_id == team_id}
  end

  def best_season(team_id)
    seasons_win_percentage = hash_season_games_won_percentage_by_team_id(team_id)
    seasons_win_percentage.key(seasons_win_percentage.values.max)
  end

  def worst_season(team_id)
    seasons_win_percentage = hash_season_games_won_percentage_by_team_id(team_id)
    seasons_win_percentage.key(seasons_win_percentage.values.min)
  end

  def average_win_percentage(team_id)
    hash_average_wins_percentage_by_team[team_id]
  end

  def most_goals_scored(team_id)
    most_goals_scored_by_team = {}
    hash_game_teams_by_team_id.each do |key_team, value_game_teams|
      most_goals_scored_by_team[key_team] = value_game_teams.map do |game_team|
        game_team.goals.to_i
      end.max
    end
    most_goals_scored_by_team[team_id]
  end

  def fewest_goals_scored(team_id)
    fewest_goals_scored_by_team = {}
    hash_game_teams_by_team_id.each do |key_team, value_game_teams|
      fewest_goals_scored_by_team[key_team] = value_game_teams.map do |game_team|
        game_team.goals.to_i
      end.min
    end
    fewest_goals_scored_by_team[team_id]
  end

  def favorite_opponent(team_id)
    id = hash_opponent_win_percentage(team_id).key(hash_opponent_win_percentage(team_id).values.min)
    team = get_team_with_id(id)
    team.team_name
  end

  def rival(team_id)
    id = hash_opponent_win_percentage(team_id).key(hash_opponent_win_percentage(team_id).values.max)
    team = get_team_with_id(id)
    team.team_name
  end

  def hash_opponent_win_percentage(team_id)
    team_win_percentage = {}
    hash_opponent_wins_all_games(team_id).each do |key_team, value_wins_games|
      team_win_percentage[key_team] = value_wins_games[0].fdiv(value_wins_games[1])
    end
    team_win_percentage
  end

  def hash_opponent_wins_all_games(team_id)
    opponent_wins_all_games = {}
    hash_opponent_games(team_id).each do |key_team, value_games|
      opponent_wins_all_games[key_team] ||= []
      opponent_wins_all_games[key_team] << value_games.count do |game|
        if key_team == game.away_team_id
          game.away_goals > game.home_goals
        elsif key_team == game.home_team_id
          game.home_goals > game.away_goals
        end
      end
      opponent_wins_all_games[key_team] << value_games.size
    end
    opponent_wins_all_games
  end

  def hash_opponent_games(team_id)
    array_games_by_team_id(team_id).group_by do |game|
      if team_id == game.away_team_id
        game.home_team_id
      elsif team_id == game.home_team_id
        game.away_team_id
      end
    end
  end

  def hash_average_wins_percentage_by_team
    team_overall_win_percentage = {}
    hash_wins_and_total_games_by_team.each do |key_team, value_wins_games|
      team_overall_win_percentage[key_team] = value_wins_games[0].fdiv(value_wins_games[1]).round(2)
    end
    team_overall_win_percentage
  end

  def hash_wins_and_total_games_by_team
    team_wins_all_games = {}
    hash_game_teams_by_team_id.each do |key_team, value_game_teams|
      team_wins_all_games[key_team] ||= []
      team_wins_all_games[key_team] << value_game_teams.count do |game_team|
        game_team.result == "WIN"
      end
      team_wins_all_games[key_team] << value_game_teams.size
    end
    team_wins_all_games
  end

  def hash_game_teams_by_team_id
    @game_teams.group_by { |game_team| game_team.team_id}
  end

  def hash_season_games_won_percentage_by_team_id(team_id)
    season_games_won_percentage = {}
    hash_games_by_season(team_id).each do |key_season, value_games|
      season_games_won_percentage[key_season] = value_games.count do |game|
        (game.away_team_id == team_id && game.away_goals > game.home_goals) ||
        (game.home_team_id == team_id && game.home_goals > game.away_goals)
      end.fdiv(value_games.count).round(2)
    end
    season_games_won_percentage
  end

  def hash_games_by_season(team_id)
    array_games_by_team_id(team_id).group_by { |game| game.season}
  end

  def array_games_by_team_id(team_id)
    @games.find_all do |game|
      game.away_team_id == team_id || game.home_team_id == team_id
    end
  end
end
