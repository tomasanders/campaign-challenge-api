require "test_helper"

class Api::ScoresControllerTest < ActionDispatch::IntegrationTest
  test "returns a saved score for a participant" do
    participant = participants(:one)
    participant.update_column(:created_at, Time.current)
    score = Score.create!(participant: participant, score: 2, duration_ms: 100)

    get "/api/v1/participants/#{participant.id}/scores"

    assert_response :success
    assert_equal score.id, response.parsed_body["score"]["id"]
  end

  test "returns not found when a participant has not played" do
    get "/api/v1/participants/#{participants(:one).id}/scores"

    assert_response :not_found
  end

  test "creates a score for an eligible participant" do
    participant = participants(:one)
    participant.update_column(:created_at, Time.current)

    assert_difference("Score.count") do
      post "/api/v1/participants/#{participant.id}/scores", params: {
        score: 3,
        duration_ms: 12_345,
        played_at: 1.day.ago
      }
    end

    assert_response :created
    assert_equal 3, response.parsed_body["score"]["score"]
    assert_equal 12_345, response.parsed_body["score"]["duration_ms"]
    assert_operator Time.iso8601(response.parsed_body["score"]["played_at"]), :>, 1.minute.ago
  end

  test "rejects a missing participant" do
    assert_no_difference("Score.count") do
      post "/api/v1/participants/0/scores", params: { score: 1, duration_ms: 1 }
    end

    assert_response :unprocessable_entity
    assert_equal [ "does not exist" ], response.parsed_body["errors"]["participant"]
  end

  test "rejects a participant older than 24 hours" do
    participant = participants(:one)
    participant.update_column(:created_at, 24.hours.ago - 1.second)

    assert_no_difference("Score.count") do
      post "/api/v1/participants/#{participant.id}/scores", params: { score: 1, duration_ms: 1 }
    end

    assert_response :unprocessable_entity
    assert_equal [ "is no longer eligible" ], response.parsed_body["errors"]["participant"]
  end

  test "accepts a participant exactly 24 hours old" do
    participant = participants(:one)
    participant.update_column(:created_at, 24.hours.ago + 1.second)

    post "/api/v1/participants/#{participant.id}/scores", params: { score: 1, duration_ms: 1 }

    assert_response :created
  end

  test "rejects duplicate score submissions" do
    participant = participants(:one)
    participant.update_column(:created_at, Time.current)
    post "/api/v1/participants/#{participant.id}/scores", params: { score: 1, duration_ms: 1 }

    assert_no_difference("Score.count") do
      post "/api/v1/participants/#{participant.id}/scores", params: { score: 2, duration_ms: 2 }
    end

    assert_response :unprocessable_entity
    assert response.parsed_body["errors"].key?("participant_id")
  end

  test "returns validation errors for non-positive values" do
    participant = participants(:one)
    participant.update_column(:created_at, Time.current)

    post "/api/v1/participants/#{participant.id}/scores", params: { score: 0, duration_ms: -1 }

    assert_response :unprocessable_entity
    assert response.parsed_body["errors"].key?("score")
    assert response.parsed_body["errors"].key?("duration_ms")
  end
end
