require_relative '../lib/game'
require_relative '../lib/team'
require_relative '../lib/game_team'
require_relative '../modules/gameable'
require_relative '../modules/teamable'
require_relative '../modules/leagueable'
require_relative '../modules/seasonable'

class StatTracker
  include Gameable
  include Teamable
  include Leagueable
  include Seasonable

  attr_reader :games, :teams, :game_teams

  def initialize(files)
    @games ||= Game.file(files[:games])
    @teams ||= Team.file(files[:teams])
    @game_teams ||= GameTeam.file(files[:game_teams])
  end

  def self.from_csv(files)
    new(files)
  end
end
