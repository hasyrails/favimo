FactoryBot.define do
  factory :share_video do
    association :from_user, factory: :user
    association :to_user, factory: :user
    association :youtube_video
  end
end
