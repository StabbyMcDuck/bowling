require 'rails_helper'

RSpec.describe Frame, type: :model do
  context 'database' do
    context 'columns' do
      it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
      it { is_expected.to have_db_column(:id).of_type(:uuid).with_options(null: false) }
      it { is_expected.to have_db_column(:player_id).of_type(:uuid).with_options(null: false) }
      it { is_expected.to have_db_column(:number).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:first_ball).of_type(:integer).with_options(null: false, default: 0) }
      it { is_expected.to have_db_column(:second_ball).of_type(:integer).with_options(null: true, default: 0) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    end
  end
end
