require_relative '../modules/readable'
require 'csv'

class GameTeam
  extend Readable

  attr_reader :game_id,
              :team_id,
              :hoa,
              :result,
              :head_coach,
              :goals,
              :shots,
              :tackles
              
  def initialize(row)
    @game_id ||= row["game_id"]
    @team_id ||= row["team_id"]
    @hoa ||= row["HoA"]
    @result ||= row["result"]
    @head_coach ||= row["head_coach"]
    @goals ||= row["goals"]
    @shots ||= row["shots"]
    @tackles ||= row["tackles"]
  end
end