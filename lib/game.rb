require_relative '../modules/readable'
require 'csv'

class Game
  extend Readable

  attr_reader :game_id,
              :season,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals
              
  def initialize(row)
    @game_id ||= row["game_id"]
    @season ||= row["season"]
    @away_team_id ||= row["away_team_id"]
    @home_team_id ||= row["home_team_id"]
    @away_goals ||= row["away_goals"]
    @home_goals ||= row["home_goals"]
  end
end