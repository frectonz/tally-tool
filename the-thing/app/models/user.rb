# frozen_string_literal: true

class User < ApplicationRecord
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: {
              with: /\A[\w-]+\z/,
              message: "can only contain letters and numbers"
            }

  has_many :sessions, dependent: :destroy
  has_many :namespaces, dependent: :destroy
end
