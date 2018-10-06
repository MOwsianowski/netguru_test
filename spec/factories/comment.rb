FactoryBot.define do

  factory :comment do
    user :user
    movie :movie
    text { "Test text for comment" }
  end
end