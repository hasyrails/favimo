describe 'users_pathページ(ユーザータイプページ)' do
  context '非ログイン状態のとき' do
    before do
      visit users_path
    end
    
    it 'ユーザータイプページに遷移できずログイン画面が表示されること' do
      # deviseデフォルトのauthenticate_user!メソッドによるリダイレクト
      expect(current_path).to eq new_user_session_path
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
    
    it 'ユーザータイプ画面が表示されること' do
      # SessionController#after_sign_in_path_for(resource)のオーバーライドで設定したパスに遷移することを確認
      expect(current_path).to eq users_path
      expect(page).to have_selector '.notification', text: 'ログインしました'
    end
    
    context 'ユーザーカードが表示されているとき' do
      let!(:user) { create(:user, :user_with_reactions) }
      it '❤︎ボタンを押すとユーザーカードが右スライドされること/Reactionレコード(like)が作成されること' do
        expect {
          find("#like").click
          # スワイプされたカードのユーザーは.swipe--cardではなく.swipe--card removedとして存在するようになる
          find('.swipe--card').has_no_text?(user.name)
          find('.removed').has_text?(user.name)
        }.to change(Reaction.like, :count).by(1)
      end

      it '✖︎ボタンを押すとユーザーカードが左スライドされること/Reactionレコード(dislike)が作成されること' do
        expect {
          find("#dislike").click
          # スワイプされたカードのユーザーは.swipe--cardではなく.swipe--card removedとして存在するようになる
          find('.swipe--card').has_no_text?(user.name)
          find('.removed').has_text?(user.name)
        }.to change(Reaction.dislike, :count).by(1)
      end
    end

    # Reactionモデルレコードの状態によるカードの表示有無のテストはユーザー表示→Like/Dislikeアクション→リロードをしなければならない
    # ↓ユーザーカードが表示されてしまう
    # context '表示されうるユーザーを全てLikeしたとき' do
    #   let!(:user) { create(:user, :user_with_like_reactions) }
    #   fit 'ユーザーカードが表示されないこと' do
    #     page.has_no_css?('.swipe--card')
    #   end
    # end
    
    # ↓ユーザーカードが表示されてしまう  
    # context '表示されうるユーザーの中でDisLikeしたユーザーがいるとき' do
      #   let!(:user) { create(:user, :user_with_reactions) }
      #   fit 'ユーザーカードが表示されること' do
      #     find('.swipe--card').has_text?(user.name)
      #   end
      # end
  end

  context 'ゲストログイン状態のとき' do
    let!(:guest_user) { create(:user) }
    before do
      visit root_path
      click_on 'ゲストログイン（閲覧用）' 
    end
    
    it 'ユーザータイプ画面が表示されること' do
      # SessionController#after_sign_in_path_for(resource)のオーバーライドで設定したパスに遷移することを確認
      expect(current_path).to eq users_path
      expect(page).to have_selector '.notification', text: 'ゲストユーザーとしてログインしました'
    end
    
    context 'ユーザーカードが表示されているとき' do
      let!(:user) { create(:user, :user_with_reactions) }
      it '❤︎ボタンを押すとユーザーカードが右スライドされること/Reactionレコード(like)が作成されること' do
        # expect {
          find("#like").click
          # スワイプされたカードのユーザーは.swipe--cardではなく.swipe--card removedとして存在するようになる
          find('.swipe--card').has_no_text?(user.name)
          find('.removed').has_text?(user.name)
        # }.to change(Reaction.like, :count).by(1)
      end

      it '✖︎ボタンを押すとユーザーカードが左スライドされること/Reactionレコード(dislike)が作成されること' do
        expect {
          find("#dislike").click
          # スワイプされたカードのユーザーは.swipe--cardではなく.swipe--card removedとして存在するようになる
          find('.swipe--card').has_no_text?(user.name)
          find('.removed').has_text?(user.name)
        }.to change(Reaction.dislike, :count).by(1)
      end
    end
  end
end
