require "test_helper"

class Api::ParticipantsControllerTest < ActionDispatch::IntegrationTest
  test "lists participants as JSON" do
    get "/api/v1/participants"

    assert_response :success
    assert_equal Participant.count, response.parsed_body.length
    assert_equal "MyString", response.parsed_body.first["first_name"]
  end

  test "creates a participant" do
    assert_difference("Participant.count") do
      post "/api/v1/participants", params: {
        first_name: "Ava",
        last_name: "Martinez",
        email: "AVA@example.com",
        age: 29,
        country_code: "us",
        marketing_opt_in: false
      }
    end

    assert_response :created
    assert_equal "Signup successful", response.parsed_body["message"]
    assert_equal "ava@example.com", response.parsed_body["participant"]["email"]
    assert_equal "US", response.parsed_body["participant"]["country_code"]
  end

  test "returns inline validation errors for invalid data" do
    assert_no_difference("Participant.count") do
      post "/api/v1/participants", params: {
        first_name: "A",
        last_name: "Smith123",
        email: "invalid",
        age: 121,
        country_code: "USA",
        marketing_opt_in: nil
      }
    end

    assert_response :unprocessable_entity
    assert response.parsed_body["errors"].key?("first_name")
    assert response.parsed_body["errors"].key?("email")
    assert response.parsed_body["errors"].key?("age")
  end

  test "rejects duplicate email case insensitively" do
    assert_no_difference("Participant.count") do
      post "/api/v1/participants", params: {
        first_name: "Another",
        last_name: "Participant",
        email: "ONE@example.com",
        age: 30,
        country_code: "US",
        marketing_opt_in: true
      }
    end

    assert_response :unprocessable_entity
    assert response.parsed_body["errors"].key?("email")
  end
end
