FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" } # 連番
    sequence(:email) { |n| "user#{n}@example.com" } # 連番
    sequence(:self_introduction) { |n| "user#{n}です" } # 連番
    password { 'password' }
    # association :youtube_video

    trait :other_user do
      sequence(:name) { |n| "other-user#{n}@example.com" } # 連番
      sequence(:email) { |n| "other-user#{n}@example.com" } # 連番
      sequence(:self_introduction) { |n| "other-user#{n}です" } # 連番
      password { 'other-password' }
    end

    trait :user_with_profile_image do
      random_num = [1,2,3,4,5].sample.to_s
      profile_image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/images/'+random_num+'.jpg'), 'image/jpg') }
    end

    trait :user_without_profile_image do
      # もともとのuserファクトリがprofile_imageを登録していないため
      # 変数名変更だけ
    end

    trait :user_associated_with_reactions do
      after(:build) do |user|  # after(:build)とした場合、createの場合もcallbackが走る
        user.reactions << build(:reaction)
      end
    end

    trait :next_user_associated_with_reactions do
      after(:build) do |user|  # after(:build)とした場合、createの場合もcallbackが走る
        user.reactions << build(:reaction)
        # binding.pry
      end
    end

    trait :user_with_like_reactions do
      after(:build) do |user|  # after(:build)とした場合、createの場合もcallbackが走る
        user.reactions << build(:reaction, :like_reaction)
        # binding.pry
      end
    end

    trait :user_with_dislike_reactions do
      after(:build) do |user|  # after(:build)とした場合、createの場合もcallbackが走る
        user.reactions << build(:reaction, :dislike_reaction)
        # binding.pry
      end
    end

    # trait :user_willing_to_share_video do
    #   after(:build) do |user|
    #     user.share_videos << build(:share_video)
    #   end
    # end
    
    # factory :other_user do
    #   sequence(:name) { |n| "other-user#{n}@example.com" } # 連番
    #   sequence(:email) { |n| "other-user#{n}@example.com" } # 連番
    #   password { 'password' }
    # end
    
    # after(:create) do |user|
    #   user.reactions << FactoryBot.create(:reaction)
    # end
    
    # factory :other_user do
    #   sequence(:name) { |n| "other-user#{n}@example.com" } # 連番
    #   sequence(:email) { |n| "other-user#{n}@example.com" } # 連番
    #   password { 'other-password' }
    # end
    
    # # 中間テーブル Reactionモデルレコードも生成する
    # user = FactoryBot.build(:user) do |user|
    #   # user.reactions.build(FactoryBot.attributes_for(:reaction))
    
    #   other_user = FactoryBot.build(:other_user) do |other_user|
    #     # Reactionモデルレコードのfrom_user_idとto_user_idを限定したい
    #     user.reactions.build(from_user_id: user.id, to_user_id: other_user.id)
    #   end
    # end
    
  end
end
  
  