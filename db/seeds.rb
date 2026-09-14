# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

participants = [
  { first_name: "Ava", last_name: "Martinez", email: "ava.martinez@example.com", age: 29, country_code: "US", marketing_opt_in: true },
  { first_name: "Liam", last_name: "Chen", email: "liam.chen@example.com", age: 34, country_code: "CA", marketing_opt_in: false },
  { first_name: "Sofia", last_name: "Rossi", email: "sofia.rossi@example.com", age: 26, country_code: "IT", marketing_opt_in: true },
  { first_name: "Noah", last_name: "Williams", email: "noah.williams@example.com", age: 41, country_code: "GB", marketing_opt_in: true },
  { first_name: "Mia", last_name: "Schneider", email: "mia.schneider@example.com", age: 38, country_code: "DE", marketing_opt_in: false },
  { first_name: "Lucas", last_name: "Silva", email: "lucas.silva@example.com", age: 24, country_code: "BR", marketing_opt_in: true },
  { first_name: "Emma", last_name: "Dubois", email: "emma.dubois@example.com", age: 31, country_code: "FR", marketing_opt_in: false },
  { first_name: "Oliver", last_name: "Berg", email: "oliver.berg@example.com", age: 45, country_code: "SE", marketing_opt_in: true },
  { first_name: "Yuki", last_name: "Tanaka", email: "yuki.tanaka@example.com", age: 28, country_code: "JP", marketing_opt_in: false },
  { first_name: "Amara", last_name: "Okafor", email: "amara.okafor@example.com", age: 36, country_code: "NG", marketing_opt_in: true }
]

participants.each do |attributes|
  Participant.find_or_create_by!(email: attributes[:email]) do |participant|
    participant.assign_attributes(attributes)
  end
end
