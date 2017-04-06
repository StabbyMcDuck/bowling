class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players, id: :uuid do |t|
      t.string :name, null: false
      t.references :game, null: false, type: :uuid
      t.timestamps
    end

    add_index :players, [ :game_id, :name ], unique: true

  end
end
