# frozen_string_literal: true

json.extract! namespace, :id, :name, :created_at, :updated_at
json.url namespace_url(namespace, format: :json)
json.tallies namespace.tallies
