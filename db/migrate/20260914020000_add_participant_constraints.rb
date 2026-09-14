class AddParticipantConstraints < ActiveRecord::Migration[8.1]
  def change
    change_column_null :participants, :first_name, false
    change_column_null :participants, :last_name, false
    change_column_null :participants, :email, false
    change_column_null :participants, :age, false
    change_column_null :participants, :country_code, false
    change_column_null :participants, :marketing_opt_in, false

    add_index :participants, "LOWER(email)", unique: true, name: "index_participants_on_lower_email"
  end
end
