p "create general users"

5.times do |n|
  User.create!(
    email: "general#{n + 1}@test.com",
    name: "general-user#{n + 1}",
    password: "general",
    self_introduction: "general-user#{n+1}です",
    gender: "#{["male", "female"].sample}",
    profile_image: File.open("#{Rails.root}/db/dummy_images/#{rand(1..6)}.jpg"),
    role: "general"
  )
end
