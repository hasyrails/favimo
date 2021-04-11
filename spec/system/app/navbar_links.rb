describe 'root_pathページ(トップページ)' do
  context '非ログイン状態のとき' do
    before do
      visit root_path
    end

    it 'トップ画面が表示されること' do
      expect(page).to have_selector 'h2', text: 'お気に入りの動画を共有しよう'
    end
    
    context 'ログインボタンをクリックしたとき' do
      it 'ログイン画面へ遷移すること' do
        click_on 'ログイン'
        expect(current_path).to eq new_user_session_path
      end
    end
    
    context 'ゲストログインボタンをクリックしたとき' do
      it 'ゲストログインとしてユーザータイプ画面へ遷移すること' do
        click_on 'ゲストログイン（閲覧用）'
        expect(current_path).to eq users_path
        expect(page).to have_selector '.notification', text: 'ゲストユーザーとしてログインしました'
      end
    end
    
    context 'アカウント作成ボタンをクリックしたとき' do
      it 'アカウント作成画面へ遷移すること' do
        click_on 'アカウントを作成する'
        expect(current_path).to eq users_path
        expect(page).to have_selector '.notification', text: 'ゲストユーザーとしてログインしました'
      end
    end
  end
  
  context 'ログイン状態のとき' do
    let!(:user) { create(:user) }
    before do
      visit root_path
      click_on 'ログイン' 
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_on 'ログイン' 
    end
    
    it 'ログインした後はユーザータイプ画面が表示されること' do
      expect(current_path).to eq users_path
      expect(page).to have_selector '.notification', text: 'ログインしました'
    end
    
  end
end
