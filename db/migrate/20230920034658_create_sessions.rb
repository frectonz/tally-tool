class CreateSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions do |t|
      t.string :token, null: false
      t.datetime :timeout_at, null: false
      t.datetime :expires_at, null: false
      t.datetime :claimed_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
