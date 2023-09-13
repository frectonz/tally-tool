class Namespace < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :name, format: { with: /\A[\w]+\z/, message: "can only contain letters and numbers" }

  has_many :tallies
end
