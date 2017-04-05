require 'rails_helper'

RSpec.describe Game, type: :model do
  context 'database' do
    context 'columns' do
      it { is_expected.to have_db_column(:id).of_type(:uuid).with_options(null: false) }
    end
  end

  context 'factories' do
    context 'game' do
      subject(:game){ FactoryGirl.build(:game) }
      it { is_expected.to be_valid }
      it 'can be persisted' do
        expect { game.save! }.not_to raise_error
      end
    end
  end
end