class Reaction < ApplicationRecord
  belongs_to :to_user, class_name: "User", foreign_key: :to_user_id
  belongs_to :from_user, class_name: "User", foreign_key: :from_user_id

  enum status: { like: 0, dislike: 1 }
end
