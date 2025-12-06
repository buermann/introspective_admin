# frozen_string_literal: true

class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.string :kind
      t.integer :parent_location_id, index: true, foreign_key: false
      t.integer :unreflected_id, index: true, foreign_key: false

      t.timestamps null: false
    end
    add_index :locations, %i[parent_location_id kind name], unique: true
  end
end
