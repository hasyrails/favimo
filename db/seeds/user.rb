p "create Users for demo operating"

User.create!(
  email: 'hoge@mail.com',
  password: 'demopass',
  name: 'hoge',
  self_introduction: 'hogeです',
  gender: 0,
  profile_image: open("#{Rails.root}/db/dummy_images/6.jpg")
)
User.create!(
  email: 'fuga@mail.com',
  password: 'demopass',
  name: 'fuga',
  self_introduction: 'hogeです',
  gender: 0,
  profile_image: open("#{Rails.root}/db/dummy_images/6.jpg")
)
User.create!(
  email: 'gege@mail.com',
  password: 'demopass',
  name: 'gege',
  self_introduction: 'hogeです',
  gender: 0,
  profile_image: open("#{Rails.root}/db/dummy_images/6.jpg")
)
