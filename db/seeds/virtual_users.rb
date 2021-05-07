# require 'faker'

p "create virtual users"

5.times do |n|
  User.create!(
    email: "virtual#{n + 1}@test.com",
    name: Gimei.name.katakana,
    password: "general",
    self_introduction: Gimei.name.katakana + "です",
    gender: "#{["male", "female"].sample}",
    profile_image: File.open("#{Rails.root}/db/dummy_images/#{rand(1..6)}.jpg"),
    role: "general"
  )
end
