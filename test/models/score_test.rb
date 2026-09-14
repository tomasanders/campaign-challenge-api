require "test_helper"

class ScoreTest < ActiveSupport::TestCase
  test "accepts positive score attributes and sets played_at server-side" do
    score = Score.new(
      participant: participants(:one),
      score: 3,
      duration_ms: 12_345,
      played_at: 1.day.ago
    )

    assert score.save
    assert_operator score.played_at, :>, 1.minute.ago
  end

  test "rejects non-positive score attributes" do
    score = Score.new(participant: participants(:one), score: 0, duration_ms: -1)

    assert_not score.valid?
    assert score.errors[:score].any?
    assert score.errors[:duration_ms].any?
  end

  test "allows only one score per participant" do
    Score.create!(participant: participants(:one), score: 1, duration_ms: 1)
    duplicate = Score.new(participant: participants(:one), score: 2, duration_ms: 2)

    assert_not duplicate.valid?
    assert duplicate.errors[:participant_id].any?
  end
end
