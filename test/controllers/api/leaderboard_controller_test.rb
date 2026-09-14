require "test_helper"

class Api::LeaderboardControllerTest < ActionDispatch::IntegrationTest
  test "returns the top ten scores with participant names and play dates" do
    participants = 11.times.map do |index|
      Participant.create!(
        first_name: "Player#{("A".."K").to_a[index]}",
        last_name: "Example",
        email: "player#{index}@example.com",
        age: 30,
        country_code: "US",
        marketing_opt_in: false
      )
    end

    scores = participants.each_with_index.map do |participant, index|
      Score.create!(participant: participant, score: index + 1, duration_ms: 100, played_at: index.days.ago)
    end

    get "/api/v1/leaderboard"

    assert_response :success
    leaderboard = response.parsed_body.fetch("leaderboard")
    assert_equal 10, leaderboard.size
    assert_equal scores.reverse.first(10).map(&:score), leaderboard.map { |entry| entry["score"] }
    assert_equal "PlayerK", leaderboard.first["first_name"]
    assert_equal scores.last.played_at.iso8601(3), leaderboard.first["played_at"]
    assert_equal %w[score first_name played_at].sort, leaderboard.first.keys.sort
  end
end
