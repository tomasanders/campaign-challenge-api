class CreateScores < ActiveRecord::Migration[8.1]
  def change
    create_table :scores do |t|
      t.references :participant, null: false, foreign_key: true, index: { unique: true }
      t.integer :score, null: false
      t.bigint :duration_ms, null: false
      t.datetime :played_at, null: false

      t.timestamps

      t.check_constraint "score > 0", name: "scores_score_positive"
      t.check_constraint "duration_ms > 0", name: "scores_duration_ms_positive"
    end
  end
end
