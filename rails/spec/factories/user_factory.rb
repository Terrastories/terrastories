FactoryBot.define do
  factory :user do
    email { 'trashme@example.com' }
    password { 'password' }
    username { 'trashme' }
    community
  end
end
