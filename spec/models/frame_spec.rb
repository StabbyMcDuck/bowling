require 'rails_helper'

RSpec.describe Frame, type: :model do
  context 'database' do
    context 'columns' do
      it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
      it { is_expected.to have_db_column(:id).of_type(:uuid).with_options(null: false) }
      it { is_expected.to have_db_column(:player_id).of_type(:uuid).with_options(null: false) }
      it { is_expected.to have_db_column(:number).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:first_ball).of_type(:integer).with_options(null: true) }
      it { is_expected.to have_db_column(:second_ball).of_type(:integer).with_options(null: true) }
      it { is_expected.to have_db_column(:third_ball).of_type(:integer).with_options(null: true) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    end
  end

  context 'validations' do
    context 'third_ball_on_frame_ten' do
      context 'with third ball' do
        context 'with 10th frame' do
          context 'first ball == 10' do
            subject(:frame){ FactoryGirl.build(:frame, first_ball: 10, second_ball: 2, third_ball: 8, number: 10) }
            it { is_expected.to be_valid }
          end

          context 'first_ball + second_ball == 10' do
            subject(:frame){ FactoryGirl.build(:frame, first_ball: 8, second_ball: 2, third_ball: 8, number: 10) }
            it { is_expected.to be_valid }
          end
        end

        context 'without 10th frame' do
          subject(:frame){ FactoryGirl.build(:frame, third_ball: 3, number: 7) }
          it { is_expected.not_to be_valid }
        end
      end

      context 'without third ball' do
        subject(:frame){ FactoryGirl.build(:frame, third_ball: nil) }
        it { is_expected.to be_valid }
      end
    end

    context 'first ball before second ball' do
      subject(:frame){ FactoryGirl.build(:frame, first_ball: first_ball, second_ball: second_ball) }

      context 'first ball is rolled' do
        let(:first_ball){ 1 }

        context 'second ball is rolled' do
          let(:second_ball){ 4 }
          it { is_expected.to be_valid }
        end

        context 'second ball is not rolled' do
          let(:second_ball){ nil }
          it { is_expected.to be_valid }
        end
      end

      context 'first ball is not rolled' do
        let(:first_ball){ nil }

        context 'second ball is rolled' do
          let(:second_ball){ 5 }
          it { is_expected.not_to be_valid }
        end

        context 'second ball is not rolled' do
          let(:second_ball){ nil }
          it { is_expected.to be_valid }
        end
      end
    end

    context 'second ball before third ball' do
      subject(:frame){ FactoryGirl.build(:frame, number: 10, first_ball: 10, second_ball: second_ball, third_ball: third_ball) }

      context 'second ball is rolled' do
        let(:second_ball){ 4 }

        context 'third ball is rolled' do
          let(:third_ball){ 7 }
          it { is_expected.to be_valid }
        end

        context 'third ball is not rolled' do
          let(:third_ball){ nil }
          it { is_expected.to be_valid }
        end
      end

      context 'second ball is not rolled' do
        let(:second_ball){ nil }

        context 'third ball is rolled' do
          let(:third_ball){ 7 }
          it { is_expected.not_to be_valid }
        end

        context 'third ball is not rolled' do
          let(:third_ball){ nil }
          it { is_expected.to be_valid }
        end
      end
    end
  end
end
