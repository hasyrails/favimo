module LoginSupport
  # 利用者がログインする
  def login_as(user)
    visit root_path
    click_on 'ログイン' 
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_on 'ログイン'
  end
end
