p "create dummy users"

5.times do |n|
  User.create!(
    email: "dummy#{n + 1}@mail.com",
    name: "dummy-user#{n + 1}",
    password: "dummy-password",
    self_introduction: "dummy-user#{n+1}です",
    gender: "#{["male", "female"].sample}",
    profile_image: File.open("#{Rails.root}/db/dummy_images/#{rand(1..6)}.jpg"),
    role: "dummy"
  )
end
