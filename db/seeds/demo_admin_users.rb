p "create demo_admin users"

5.times do |n|
  User.create!(
    email: "demo-admin#{n + 1}@test.com",
    name: "demo-admin-user#{n + 1}",
    password: "demo_admin",
    self_introduction: "demo-admin-user#{n+1}です",
    gender: "#{["male", "female"].sample}",
    profile_image: File.open("#{Rails.root}/db/dummy_images/#{rand(1..6)}.jpg"),
    role: "demo_admin"
  )
end
