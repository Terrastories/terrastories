FactoryBot.define do
  factory :user do
    email { 'trashme@example.com' }
    password { 'password' }
    community
  end
end
