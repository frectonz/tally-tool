class CreateTallies < ActiveRecord::Migration[7.0]
  def change
    create_table :tallies do |t|
      t.references :namespace, null: false, foreign_key: true
      t.integer :count

      t.timestamps
    end
  end
end
