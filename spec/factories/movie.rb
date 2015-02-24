FactoryGirl.define do
  factory :movie do
    title { Faker::Lorem.word }
    description { Faker::Lorem.sentence(3, true) }
    released_at { Faker::Date.between(40.years.ago, Date.today) }
    genre
  end
end
