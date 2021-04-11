describe 'ナビバーリンク(パーシャルファイル)' do
  context 'ナビバーリンクをクリックしたとき' do
    let!(:user) { create(:user) }
    before do
      visit root_path
      click_on 'ログイン' 
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_on 'ログイン'
    end
      
    context 'user-friendsアイコン(FontAwesome)をクリックしたとき' do
      before do
        find('.fa-user-friends').click
      end
      it 'ユーザータイプ画面へ遷移すること' do
        expect(current_path).to eq users_path
      end
      it 'frinedsアイコン(FontAwesome)がアクティブになっていること' do
        find('.fa-user-friends').has_selector? '.active'
      end
    end

    context 'play-circleアイコン(FontAwesome)をクリックしたとき' do
      before do
        find('.fa-play-circle').click
      end
      it 'YouTube検索画面へ遷移すること' do
        expect(current_path).to eq youtube_videos_search_index_path
      end
      it 'play-circleアイコン(FontAwesome)がアクティブになっていること' do
        first('.fa-play-circle').has_selector? '.active'

        #Capybara::Ambiguous:
        #  Ambiguous match, found 3 elements matching visible css ".fa-play-circle" 対策
      end
    end

    context 'commentsアイコン(FontAwesome)をクリックしたとき' do
      before do
        find('.fa-comments').click
      end
      it 'チャット作成画面へ遷移すること' do
        expect(current_path).to eq matching_index_path
      end
      it 'commentsアイコン(FontAwesome)がアクティブになっていること' do
        find('.fa-comments').has_selector? '.active'
      end
    end

    context 'portraitアイコン(FontAwesome)をクリックしたとき' do
      before do
        find('.fa-portrait').click
      end
      it 'チャット作成画面へ遷移すること' do
        expect(current_path).to eq user_path(user)
      end
      it 'portraitアイコン(FontAwesome)がアクティブになっていること' do
        find('.fa-portrait').has_selector? '.active'
      end
    end
  end
end
