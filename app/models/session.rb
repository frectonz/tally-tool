class Session < ApplicationRecord
  validates(
    :timeout_at,
    :expires_at,
    :token,
    :user_id,
    presence: true
  )

  before_validation :set_defaults

  scope(
    :available,
    lambda { where("expires_at > ?", Time.current) }
  )

  belongs_to :user

  CHARS = [*"A".."Z", *"0".."9"].freeze
  def set_defaults
    self.expires_at = 1.year.from_now
    self.timeout_at = 10.minutes.from_now
    self.token = CHARS.sample(6).join
  end
end
