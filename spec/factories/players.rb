FactoryGirl.define do
  factory :player do
    name { Faker::Name.name }
    game
  end
end
