# frozen_string_literal: true

class AddNameColumnToTally < ActiveRecord::Migration[7.0]
  def change
    add_column :tallies, :name, :string
  end
end
