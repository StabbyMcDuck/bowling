class CreateGames < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'
    create_table :games, id: :uuid do |t|
      t.timestamps
    end
  end
end
