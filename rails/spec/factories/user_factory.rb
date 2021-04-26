FactoryBot.define do
  factory :user do
    email { 'trashme@example.com' }
    username { 'username' }
    password { 'password' }
    community
  end
end
