FactoryGirl.define do
  factory :player do
    name { Faker::RickAndMorty.character }
    game
  end
end
