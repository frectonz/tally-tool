# frozen_string_literal: true

require "test_helper"

class NamespacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @namespace = namespaces(:one)
  end
end
