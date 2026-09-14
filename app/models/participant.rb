class Participant < ApplicationRecord
  has_one :score, dependent: :destroy

  before_validation :normalize_attributes

  validates :first_name, presence: true, length: { in: 2..50 }, format: {
    with: /\A[\p{L}][\p{L} '\-]*[\p{L}]\z/
  }
  validates :last_name, presence: true, length: { in: 2..50 }, format: {
    with: /\A[\p{L}][\p{L} '\-]*[\p{L}]\z/
  }
  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/ },
    uniqueness: { case_sensitive: false }
  validates :age, presence: true, numericality: { only_integer: true, in: 13..120 }
  validates :country_code, presence: true, format: { with: /\A[A-Z]{2}\z/ }
  validates :marketing_opt_in, inclusion: { in: [ true, false ] }

  private

  def normalize_attributes
    self.first_name = first_name.to_s.strip
    self.last_name = last_name.to_s.strip
    self.email = email.to_s.strip.downcase
    self.country_code = country_code.to_s.strip.upcase
  end
end
