FactoryBot.define do
  factory :user do
	name "Marek"
	email "marek@gmail.com"
	password "password123"
	password_confirmation "password123"
	confirmed_at Time.now
  end
end
