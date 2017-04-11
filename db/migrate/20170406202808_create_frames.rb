class CreateFrames < ActiveRecord::Migration[5.0]
  def change
    create_table :frames, id: :uuid do |t|
      t.references :player, type: :uuid, foreign_key: true, null: false
      t.integer :number, null: false, default: 1
      t.integer :first_ball, null: true
      t.integer :second_ball, null: true
      t.integer :third_ball, null: true

      t.timestamps
    end
  end
end
