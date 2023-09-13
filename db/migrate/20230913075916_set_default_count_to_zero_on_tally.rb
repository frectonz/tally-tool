class SetDefaultCountToZeroOnTally < ActiveRecord::Migration[7.0]
  def change
    change_column_default :tallies, :count, 0
  end
end
