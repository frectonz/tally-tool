# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:5173"
    resource "/namespaces/*/tallies/*",
             headers: :any,
             methods: %i[get post patch put],
             credentials: true
  end
end
