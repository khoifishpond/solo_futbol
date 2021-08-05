module Leagueable
  def count_of_teams
    @teams.count
  end

  def best_offense
    team = @teams.find do |team|
      team.team_id == team_id_best_offense
    end
    team.team_name
  end

  def worst_offense
    team = @teams.find do |team|
      team.team_id == team_id_worst_offense
    end
    team.team_name
  end

  def highest_scoring_visitor
    team = @teams.find do |team|
      team.team_id == team_id_highest_average_score_away
    end
    team.team_name
  end

  def highest_scoring_home_team
    team = @teams.find do |team|
      team.team_id == team_id_highest_average_score_home
    end
    team.team_name
  end

  def lowest_scoring_visitor
    team = @teams.find do |team|
      team.team_id == team_id_lowest_average_score_away
    end
    team.team_name
  end

  def lowest_scoring_home_team
    team = @teams.find do |team|
      team.team_id == team_id_lowest_average_score_home
    end
    team.team_name
  end

  def team_id_best_offense
    hash_team_id_average_goals.key(hash_team_id_average_goals.values.max)
  end

  def team_id_worst_offense
    hash_team_id_average_goals.key(hash_team_id_average_goals.values.min)
  end

  def hash_team_id_average_goals
    team_id_average_goals = {}
    hash_team_id_goals_to_games.each do |key, value|
      team_id_average_goals[key] = value.sum do |game_team|
        game_team.goals.to_i
      end.fdiv(value.size).round(2)
    end
    team_id_average_goals
  end

  def hash_team_id_goals_to_games
    team_id_goals = {}
    hash_team_id_games.each do |key, value|
      team_id_goals[key] ||= []
      team_id_goals[key] << value.sum do |game_team|
        game_team.goals.to_i
      end
      team_id_goals[key] << value.size
    end
  end

  def team_id_highest_average_score_away
    best_away_average_score = hash_team_id_hoa_goals.values.max_by do |hoa|
      hoa["away"]
    end
    hash_team_id_hoa_goals.key(best_away_average_score)
  end

  def team_id_highest_average_score_home
    best_home_average_score = hash_team_id_hoa_goals.values.max_by do |hoa|
      hoa["home"]
    end
    hash_team_id_hoa_goals.key(best_home_average_score)
  end

  def team_id_lowest_average_score_away
    best_away_average_score = hash_team_id_hoa_goals.values.min_by do |hoa|
      hoa["away"]
    end
    hash_team_id_hoa_goals.key(best_away_average_score)
  end

  def team_id_lowest_average_score_home
    best_home_average_score = hash_team_id_hoa_goals.values.min_by do |hoa|
      hoa["home"]
    end
    hash_team_id_hoa_goals.key(best_home_average_score)
  end

  def hash_team_id_hoa_goals
    team_id_hoa_goals = {}
    hash_team_id_hoa_games.each do |key_team, value_hash|
      team_id_hoa_goals[key_team] = value_hash.each do |key_hoa, value_array|
        value_hash[key_hoa] = value_array.sum do |game_team|
          game_team.goals.to_i
        end.fdiv(value_array.size)
      end
    end
    team_id_hoa_goals
  end

  def hash_team_id_hoa_games
    team_id_hoa_games = {}
    hash_team_id_games.each do |key, value|
      team_id_hoa_games[key] = value.group_by do |game_team|
        game_team.hoa
      end
    end
    team_id_hoa_games
  end

  def hash_team_id_games
    @game_teams.group_by do |game_team|
      game_team.team_id
    end
  end
end