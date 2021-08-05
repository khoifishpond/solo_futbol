module Seasonable
  def winningest_coach(season)
    highest_win_ratio = {}
    coach_win_loss_tie(season).each do |key, value|
      highest_win_ratio[key] = value[0].fdiv(value.sum)
    end
    highest_win_ratio.key(highest_win_ratio.values.max)
  end

  def worst_coach(season)
    highest_loss_ratio = {}
    coach_win_loss_tie(season).each do |key, value|
      highest_loss_ratio[key] = value[0].fdiv(value.sum)
    end
    highest_loss_ratio.key(highest_loss_ratio.values.min)
  end

  def most_accurate_team(season)
    team_accuracy = team_accuracy_ratio_season(season)
    team_id = team_accuracy.key(team_accuracy.values.max)
    team = @teams.find do |team|
      team.team_id == team_id
    end
    team.team_name
  end

  def least_accurate_team(season)
    team_accuracy = team_accuracy_ratio_season(season)
    team_id = team_accuracy.key(team_accuracy.values.min)
    team = @teams.find do |team|
      team.team_id == team_id
    end
    team.team_name
  end

  def most_tackles(season)
    team_id_tackles = team_tackles_season(season)
    team_id = team_id_tackles.key(team_id_tackles.values.max)
    team = @teams.find do |team|
      team.team_id == team_id
    end
    team.team_name
  end

  def fewest_tackles(season)
    team_id_tackles = team_tackles_season(season)
    team_id = team_id_tackles.key(team_id_tackles.values.min)
    team = @teams.find do |team|
      team.team_id == team_id
    end
    team.team_name
  end

  def team_tackles_season(season)
    team_id_tackles = {}
    all_season_games_by_team(season).each do |key, value|
      team_id_tackles[key] ||= 0
      value.each do |game_team|
        team_id_tackles[key] += game_team.tackles.to_i
      end
    end
    team_id_tackles
  end

  def coach_win_loss_tie(season)
    win_loss_tie = {}
    all_season_games_by_coach(season).each do |key, value|
      win_loss_tie[key] ||= []
      win_loss_tie[key] << value.count do |game_team|
        game_team.result == "WIN"
      end
      win_loss_tie[key] << value.count do |game_team|
        game_team.result == "LOSS"
      end
      win_loss_tie[key] << value.count do |game_team|
        game_team.result == "TIE"
      end
    end
    win_loss_tie
  end

  def all_season_games_by_coach(season)
    all_game_teams_season(season).group_by do |game_team|
      game_team.head_coach
    end
  end

  def all_game_teams_season(season)
    game_id_season(season).flat_map do |game|
      @game_teams.select do |game_team|
        game == game_team.game_id
      end
    end
  end

  def game_id_season(season)
    games_by_season(season).map do |game|
      game.game_id
    end
  end

  def games_by_season(season)
    @games.find_all do |game|
      game.season == season
    end
  end

  def all_season_games_by_team(season)
    all_game_teams_season(season).group_by do |game_team|
      game_team.team_id
    end
  end

  def team_accuracy_ratio_season(season)
    team_accuracy = {}
    team_goals_shots_season(season).each do |key, value|
      team_accuracy[key] = value[0].fdiv(value[1])
    end
    team_accuracy
  end

  def team_goals_shots_season(season)
    goal_shots = {}
    all_season_games_by_team(season).each do |key, value|
      goal_shots[key] ||= []
      goal_shots[key] << value.sum do |game_team|
        game_team.goals.to_i
      end
      goal_shots[key] << value.sum do |game_team|
        game_team.shots.to_i
      end
    end
    goal_shots
  end
end
