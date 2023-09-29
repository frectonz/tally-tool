# frozen_string_literal: true

class Namespace < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: {
              with: /\A[\w-]+\z/,
              message: "can only contain letters and numbers"
            }

  has_many :tallies, dependent: :destroy
  belongs_to :user
end
