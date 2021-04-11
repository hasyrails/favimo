describe 'user_path(user)ページ(ユーザ-詳細)' do
  context '自分(current_user)のユーザー詳細ページに遷移したとき' do
    let!(:user) { create(:user) }
    before do
      # login_asメソッド
      # rails_helperを読み込むとテストブラウザが何故か開かないため読み込まないようにする
      visit root_path
      click_on 'ログイン' 
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_on 'ログイン'

      visit user_path(user)
    end

    it '自分の名前(name)が表示されていること' do
      page.has_text? user.name
    end
    
    it '自分の自己紹介文(self_introduction)が表示されていること' do
      page.has_text? user.self_introduction
    end

    it '自分のタイプしたユーザー一覧ページへのリンクボタンが表示されていること' do
      expect(page).to have_text('タイプしたユーザーをみる')
      page.has_selector? 'link-button-to-like-users-page'
    end

    it '自分のLikeした動画一覧ページへのリンクボタンが表示されていること' do
      expect(page).to have_text('Likeした動画をみる')
      page.has_selector? 'link-button-to-like-videos-page'
    end
    
    it '自分の共有している動画一覧ページへのリンクボタンが表示されていること' do
      expect(page).to have_text('共有している動画をみる')
      page.has_selector? 'link-button-to-sharing-and-shared-videos-page'
    end
    
    it 'ログアウトボタンが表示されていること' do
      expect(page).to have_text('ログアウト')
      page.has_selector? 'logout-button'
    end

    it 'ユーザー情報編集ページへのリンクボタンが表示されていること' do
      expect(page).to have_text('情報を編集')
      page.has_selector? 'link-button-to-profile-edit-page'
    end

    context '自分のユーザー詳細ページに表示されている各ボタンをクリックしたとき' do
      it '「タイプしたユーザーをみる」ボタンをクリックするとLikeしたユーザー一覧ページへ遷移すること' do
        find('.link-button-to-like-users-page').click
        expect(current_path).to eq user_status_like_index_path(user)
      end
      
      it '「Likeした動画をみる」ボタンをクリックするとLikeした動画一覧ページへ遷移すること' do
        find('.link-button-to-like-videos-page').click
        expect(current_path).to eq youtube_myvideos_status_like_index_path
      end

      it '「共有している動画をみる」ボタンをクリックすると共有中の動画一覧ページへ遷移すること' do
        find('.link-button-to-sharing-and-shared-videos-page').click
        expect(current_path).to eq youtube_myvideos_status_like_shared_and_sharing_history_path(user)
      end

      it '「ログアウト」ボタンをクリックするとログアウトすること' do
        find('.logout-button').click
        expect(current_path).to eq root_path
        expect(page).to have_selector '.notification', text: 'ログアウトしました'
      end

      it '「情報を編集」ボタンをクリックするとプロフィール編集ページへ遷移すること' do
        find('.link-button-to-profile-edit-page').click
        uri = URI.parse(current_url)
        expect("#{uri.path}?#{uri.query}").to eq(edit_user_registration_path(params: {user_id: user.id}))
      end
    end
    
    context '自分(current_user)のprofile_imageが登録されていないとき' do
      let(:user) { create(:user, :user_without_profile_image) }
      it 'profile_imageを登録していないユーザー向けのアイコンが表示されること' do
        expect(page).to have_css ".profile-default-img"
      end
    end
    
    context '自分(current_user)のprofile_imageが登録されているとき' do
      let(:user) { create(:user, :user_with_profile_image) }
      it'登録したprofile_imageがユーザーアイコンとして表示されること' do
        random_num = [1,2,3,4,5].sample.to_s
        expect(page).to have_css ".profile-img"
      end
    end
  end

  context '他のユーザーのユーザー詳細ページに遷移したとき' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user, :other_user) }

    before do
      visit root_path
      click_on 'ログイン' 
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_on 'ログイン'

      visit user_path(other_user)
    end

    it '他のユーザーの名前(name)が表示されていること' do
      page.has_text? other_user.name
    end

    it '他のユーザーの自己紹介文(self_introduction)が表示されていること' do
      page.has_text? other_user.self_introduction
    end

    it 'ユーザー一覧ページへのリンクボタンが表示されていないこと' do
      expect(page).not_to have_text('タイプしたユーザーをみる')
      page.has_selector?('link-button-to-like-users-page')
    end

    it 'Likeした動画一覧ページへのリンクボタンが表示されていないこと' do
      expect(page).not_to have_text('Likeした動画をみる')
      page.has_selector? 'link-button-to-like-videos-page'
    end
    
    it '共有している動画一覧ページへのリンクボタンが表示されていないこと' do
      expect(page).not_to have_text('共有している動画をみる')
      page.has_selector? 'link-button-to-sharing-and-shared-videos-page'
    end
    
    it 'ログアウトボタンが表示されていないこと' do
      expect(page).not_to have_text('ログアウト')
      page.has_selector? 'logout-button'
    end

    it 'ユーザー情報編集ページへのリンクボタンが表示されていないこと' do
      expect(page).not_to have_text('情報を編集')
      page.has_selector? 'link-button-to-profile-edit-page'
    end
  end

  # ↓ShareVideoファクトリが作成できないため、別途
  # paramsが渡るのが前提としているので、順次ページを渡るようにしなければならない
    # context '共有する動画・共有するユーザーを選択した状態で他のユーザーの詳細ページへ遷移したとき' do
    #   let!(:user) { create(:user) }
    #   # let!(:youtube_video) { create(:youtube_video) }
    #   let!(:other_user) { create(:user, :other_user) }
    #   # let!(:share_video) { create(:share_video) }
    #   before do
    #     # login_asメソッド
    #     # rails_helperを読み込むとテストブラウザが何故か開かないため読み込まないようにする
    #     visit root_path
    #     click_on 'ログイン' 
    #     fill_in 'メールアドレス', with: user.email
    #     fill_in 'パスワード', with: user.password
    #     click_on 'ログイン'
    #     # binding.pry

    #     visit user_path(other_user, params: {
    #       share_video_unique_id: user.youtube_videos
    #     })
    #   end

    #   fit '共有する動画が表示されていること' do
    #     expect(page).to have_css('iframe')
    #     # iframe内のコンテンツを確認
    #     within_frame find('iframe') do
    #       expect(page).to have_content 'コンテンツ'
    #     end
    #   end

    # end
end
