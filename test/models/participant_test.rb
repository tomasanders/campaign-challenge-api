require "test_helper"

class ParticipantTest < ActiveSupport::TestCase
  test "normalizes valid participant attributes" do
    participant = Participant.new(
      first_name: " Ava ",
      last_name: " O'Connor ",
      email: " AVA@example.com ",
      age: 29,
      country_code: " us ",
      marketing_opt_in: false
    )

    assert participant.valid?
    assert_equal "Ava", participant.first_name
    assert_equal "O'Connor", participant.last_name
    assert_equal "ava@example.com", participant.email
    assert_equal "US", participant.country_code
  end

  test "rejects invalid participant attributes" do
    participant = Participant.new(
      first_name: "A",
      last_name: "Smith123",
      email: "invalid",
      age: 121,
      country_code: "USA",
      marketing_opt_in: nil
    )

    assert_not participant.valid?
    assert_includes participant.errors[:first_name], "is too short (minimum is 2 characters)"
    assert participant.errors[:last_name].any?
    assert participant.errors[:email].any?
    assert participant.errors[:age].any?
    assert participant.errors[:country_code].any?
    assert participant.errors[:marketing_opt_in].any?
  end
end
