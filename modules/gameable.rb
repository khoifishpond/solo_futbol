module Gameable
  def highest_total_score
    array_all_total_scores.max
  end

  def lowest_total_score
    array_all_total_scores.min
  end

  def array_all_total_scores
    @games.map { |game| game.away_goals.to_i + game.home_goals.to_i}
  end

  def percentage_home_wins
    win_count = hash_hoa_game_teams["home"].count do |game_team|
      game_team.result == "WIN"
    end
    all_games = hash_hoa_game_teams["home"].count do |game_team|
      game_team
    end
    win_count.fdiv(all_games).round(2)
  end

  def percentage_visitor_wins
    win_count = hash_hoa_game_teams["away"].count do |game_team|
      game_team.result == "WIN"
    end
    all_games = hash_hoa_game_teams["away"].count do |game_team|
      game_team
    end
    win_count.fdiv(all_games).round(2)
  end

  def hash_hoa_game_teams
    @game_teams.group_by { |game_team| game_team.hoa}
  end

  def percentage_ties
    tie_count = @game_teams.count { |game_team| game_team.result == "TIE"}
    all_games = @game_teams.size
    tie_count.fdiv(all_games).round(2)
  end

  def count_of_games_by_season
    hash_season_game_count = {}
    hash_season_games.each { |key, value| hash_season_game_count[key] = value.size}
    hash_season_game_count
  end

  def hash_season_games
    @games.group_by { |game| game.season}
  end

  def average_goals_per_game
    total_away_goals = @games.sum { |game| game.away_goals.to_i}
    total_home_goals = @games.sum { |game| game.home_goals.to_i}
    (total_away_goals + total_home_goals).fdiv(@games.size).round(2)
  end

  def average_goals_by_season
    hash_season_average_goals = {}
    hash_season_games.each do |key, value|
      hash_season_average_goals[key] = value.sum do |game|
        game.away_goals.to_i + game.home_goals.to_i
      end.fdiv(value.size).round(2)
    end
    hash_season_average_goals
  end
end
