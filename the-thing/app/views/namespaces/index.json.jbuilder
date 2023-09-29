# frozen_string_literal: true

json.array! @namespaces, partial: "namespaces/namespace", as: :namespace
