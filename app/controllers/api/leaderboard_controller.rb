class Api::LeaderboardController < ApplicationController
  def index
    scores = Score.includes(:participant).order(score: :desc, played_at: :asc, id: :asc).limit(10)

    render json: {
      leaderboard: scores.map do |score|
        {
          score: score.score,
          first_name: score.participant.first_name,
          played_at: score.played_at
        }
      end
    }
  end
end
