FactoryBot.define do
  factory :reaction do
    association :from_user, factory: :user
    association :to_user, factory: :user
    status { ['dislike', 'like'].sample }

    trait :like_reaction do
      status { 'like' }
    end

    trait :dislike_reaction do
      status { 'dislike' }
    end
  end
end
