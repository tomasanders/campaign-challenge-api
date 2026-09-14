class CreateParticipants < ActiveRecord::Migration[8.1]
  def change
    create_table :participants do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :age
      t.string :country_code
      t.boolean :marketing_opt_in

      t.timestamps
    end
  end
end
