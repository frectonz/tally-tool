# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "tally-tool@frectonz.io"
  layout "mailer"
end
