require 'rails_helper'

RSpec.describe Player, type: :model do
  context 'database' do
    context 'columns' do
      it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
      it { is_expected.to have_db_column(:game_id).of_type(:uuid).with_options(null: false) }
      it { is_expected.to have_db_column(:id).of_type(:uuid).with_options(null: false) }
      it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    end

    context 'indices' do
      it { is_expected.to have_db_index([:game_id, :name]).unique(true) }
    end
  end

  context 'factories' do

  end
end
