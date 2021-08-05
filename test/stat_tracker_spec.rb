require './lib/stat_tracker'
require 'rspec'
require 'simplecov'
SimpleCov.start

describe StatTracker do
  context 'Attributes' do
    before(:all) do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      @stat_tracker ||= StatTracker.from_csv(locations)
    end

    it 'exists' do
      expect(@stat_tracker).to be_a(StatTracker)
    end

    it 'has games' do
      expect(@stat_tracker.games.all? { |game| game.class == Game }).to eq(true)
    end

    it 'has teams' do
      expect(@stat_tracker.teams.all? { |team| team.class == Team }).to eq(true)
    end

    it 'has game teams' do
      expect(@stat_tracker.game_teams.all? { |game_team| game_team.class == GameTeam }).to eq(true)
    end
  end

  context 'Calculations' do
    before(:all) do
      game_path = './data/games.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams.csv'
      locations = {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }
      @stat_tracker ||= StatTracker.from_csv(locations)
    end

    it "highest sum of winning and losing teams' scores" do
      expect(@stat_tracker.highest_total_score).to eq(11)
    end

    it "lowest sum of winning and losing teams' scores" do
      expect(@stat_tracker.lowest_total_score).to eq(0)
    end

    it "all sums of winning and losing teams' scores" do
      expect(@stat_tracker.array_all_total_scores).to be_a(Array)
      expect(@stat_tracker.array_all_total_scores.all? { |score| score.class == Integer }).to eq(true)
    end

    it 'percentage of games that a home team has won' do
      expect(@stat_tracker.percentage_home_wins).to eq(0.44)
    end

    it 'percentage of games that an away team has won' do
      expect(@stat_tracker.percentage_visitor_wins).to eq(0.36)
    end

    it 'percentage of games that resulted in a tie' do
      expect(@stat_tracker.percentage_ties).to eq(0.2)
    end

    it 'counts games by season' do
      expect(@stat_tracker.count_of_games_by_season).to eq(
        {
          "20122013"=>806,
          "20162017"=>1317,
          "20142015"=>1319,
          "20152016"=>1321,
          "20132014"=>1323,
          "20172018"=>1355
        }
      )
    end

    it 'average total goals per game across all seasons' do
      expect(@stat_tracker.average_goals_per_game).to eq(4.22)
    end

    it 'average total goals per season' do
      expect(@stat_tracker.average_goals_by_season).to eq(
        {
          "20122013"=>4.12,
          "20162017"=>4.23,
          "20142015"=>4.14,
          "20152016"=>4.16,
          "20132014"=>4.19,
          "20172018"=>4.44
        }
      )
    end

    it 'total number of teams' do
      expect(@stat_tracker.count_of_teams).to eq(32)
    end

    it 'team with highest average of goals scored per game all seasons' do
      expect(@stat_tracker.best_offense).to eq("Reign FC")
    end

    it 'team with the lowest average of goals scored per game all seasons' do
      expect(@stat_tracker.worst_offense).to eq("Utah Royals FC")
    end

    it 'home team with the highest average score per game all seasons' do
      expect(@stat_tracker.highest_scoring_home_team).to eq("Reign FC")
    end

    it 'visitor with the highest average score per game all seasons' do
      expect(@stat_tracker.highest_scoring_visitor).to eq("FC Dallas")
    end

    it 'home team with the lowest average score per game all seasons' do
      expect(@stat_tracker.lowest_scoring_home_team).to eq("Utah Royals FC")
    end

    it 'visitor with the lowest average score per game all seasons' do
      expect(@stat_tracker.lowest_scoring_visitor).to eq("San Jose Earthquakes")
    end

    it 'can find the winningest coach of a season' do
      expect(@stat_tracker.winningest_coach("20132014")).to eq("Claude Julien")
    end

    it 'can find the worst coach of a season' do
      expect(@stat_tracker.worst_coach("20142015")).to eq("Peter Laviolette")
    end

    it 'can find the most accurate team' do
      expect(@stat_tracker.most_accurate_team("20142015")).to eq("Toronto FC")
    end

    it 'can find the least accurate team' do
      expect(@stat_tracker.least_accurate_team("20142015")).to eq("Columbus Crew SC")
    end

    it 'can find the most tackles' do
      expect(@stat_tracker.most_tackles("20142015")).to eq("Seattle Sounders FC")
    end

    it 'can find the least tackles' do
      expect(@stat_tracker.fewest_tackles("20142015")).to eq("Orlando City SC")
    end

    it 'can give team information as a hash' do
      expect(@stat_tracker.team_info("6")).to eq({
        team_id: "6",
        franchise_id: "6",
        team_name: "FC Dallas",
        abbreviation: "DAL"
      })
    end

    it 'season with the highest win percentage for a team' do
      expect(@stat_tracker.best_season("6")).to eq("20132014")
    end

    it 'season with the lowest win percentage for a team' do
      expect(@stat_tracker.worst_season("6")).to eq("20142015")
    end

    it 'average win percentage overall for a team' do
      expect(@stat_tracker.average_win_percentage("6")).to eq(0.49)
    end

    it 'can find the highest number of goals in a single game for a team' do
      expect(@stat_tracker.most_goals_scored("18")).to eq(7)
    end

    it 'can find the lowest number of goals in a single game for a team' do
      expect(@stat_tracker.fewest_goals_scored("18")).to eq(0)
    end

    it 'finds favorite opponent that has the lowest win percentage' do
      expect(@stat_tracker.favorite_opponent("18")).to eq("DC United")
    end

    it 'finds rival opponent that has the highest win percentage' do
      expect(@stat_tracker.rival("18")).to eq("Houston Dash").or(eq("LA Galaxy"))
    end
  end
end
