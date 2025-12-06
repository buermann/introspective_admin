# frozen_string_literal: true

class CreateTeamUsers < ActiveRecord::Migration
  def change
    create_table :team_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :team, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :team_users, %i[user_id team_id], unique: true
  end
end
