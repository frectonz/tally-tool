# frozen_string_literal: true

class Tally < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: {
              with: /\A[\w-]+\z/,
              message: "can only contain letters and numbers"
            }

  belongs_to :namespace
end
