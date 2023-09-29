# frozen_string_literal: true

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
    -> { where("expires_at > ? AND claimed_at IS NULL", Time.current) }
  )

  belongs_to :user

  def timed_out?
    timeout_at <= Time.current
  end

  def claim
    self.claimed_at = Time.current
    save
  end

  CHARS = [*"A".."Z", *"0".."9"].freeze

  def set_defaults
    self.expires_at = 1.year.from_now
    self.timeout_at = 10.minutes.from_now
    self.token = CHARS.sample(6).join
  end
end
