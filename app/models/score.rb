class Score < ApplicationRecord
  belongs_to :participant

  validates :score, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :duration_ms, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :participant_id, uniqueness: true

  before_validation :set_played_at, on: :create

  private

  def set_played_at
    self.played_at = Time.current
  end
end
