FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user#{n}@example.com" } # 連番
    sequence(:email) { |n| "user#{n}@example.com" } # 連番
    password { 'password' }
  end
end
