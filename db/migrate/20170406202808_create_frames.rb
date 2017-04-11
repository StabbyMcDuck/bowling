class CreateFrames < ActiveRecord::Migration[5.0]
  def change
    create_table :frames, id: :uuid do |t|
      t.references :player, type: :uuid, foreign_key: true, null: false
      t.integer :number, null: false, default: 1
      t.integer :first_ball, null: false, default: 0
      t.integer :second_ball, null: true, default: 0

      t.timestamps
    end
  end
end
